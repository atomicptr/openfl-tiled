// Copyright (C) 2013 Christopher "Kasoki" Kaster
//
// This file is part of "openfl-tiled". <http://github.com/Kasoki/openfl-tiled>
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
package openfl.tiled;

import flash.geom.Rectangle;
import flash.geom.Point;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;

import openfl.display.Tilesheet;

/**
 * This class represents a TILED map
 * @author Christopher Kaster
 */
class TiledMap extends Sprite {

	/** The map width in tiles */
	public var widthInTiles(default, null):Int;

	/** The map height in tiles */
	public var heightInTiles(default, null):Int;

	/** The map width in pixels */
	public var totalWidth(get_totalWidth, null):Int;

	/** The map height in pixels */
	public var totalHeight(get_totalHeight, null):Int;

	/** TILED orientation: Orthogonal or Isometric */
	public var orientation(default, null):TiledMapOrientation;

	/** The tile width */
	public var tileWidth(default, null):Int;

	/** The tile height */
	public var tileHeight(default, null):Int;

	/** The background color of the map */
	public var backgroundColor(default, null):Int;

	/** All tilesets the map is using */
	public var tilesets(default, null):Array<Tileset>;

	/** Contains all layers from this map */
	public var layers(default, null):Array<Layer>;

	/** All objectgroups */
	public var objectGroups(default, null):Array<TiledObjectGroup>;

	/** All map properties */
	public var properties(default, null):Map<String, String>;

	private var tilesheets:Map<Int, Tilesheet>;
	private var tileRects:Array<Rectangle>;
	private var backgroundColorSet:Bool = false;

	private function new(xml:String) {
		super();

		this.tilesheets = new Map<Int, Tilesheet>();
		this.tileRects = new Array<Rectangle>();

		parseXML(xml);

		// create tilesheets
		for(tileset in this.tilesets) {
			this.tilesheets.set(tileset.firstGID, new Tilesheet(tileset.image.texture));
		}

		#if flash
		this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStageFlash);
		#else
		this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		#end
	}

	// onAddedToStage for non-flash targets
	private function onAddedToStage(e:Event) {
		this.graphics.clear();

		for(layer in this.layers) {

			var drawList:Array<Float> = new Array<Float>();
			var gidCounter:Int = 0;

			for(y in 0...this.heightInTiles) {
				for(x in 0...this.widthInTiles) {
					var nextGID = layer.tiles[gidCounter].gid;

					if(nextGID != 0) {
						var point:Point = new Point();

						switch (orientation) {
							case TiledMapOrientation.Orthogonal:
								point = new Point(x * this.tileWidth, y * this.tileHeight);
							case TiledMapOrientation.Isometric:
								point = new Point((this.width + x - y - 1) * this.tileWidth * 0.5, (y + x) * this.tileHeight * 0.5);
						}

						var tileset:Tileset = getTilesetByGID(nextGID);

						var tilesheet:Tilesheet = this.tilesheets.get(tileset.firstGID);

						var rect:Rectangle = tileset.getTileRectByGID(nextGID);

						var tileId:Int = -1;

						var foundSomething:Bool = false;

						for(r in this.tileRects) {
							if(rectEquals(r, rect)) {
								tileId = Lambda.indexOf(this.tileRects, r);

								foundSomething = true;

								break;
							}
						}

						if(!foundSomething) {
							tileRects.push(rect);
						}

						if(tileId < 0) {
							tileId = this.tilesheets.get(tileset.firstGID).addTileRect(rect);
						}

						// add coordinates to draw list
						drawList.push(point.x); // x coord
						drawList.push(point.y); // y coord
						drawList.push(tileId); // tile id
						drawList.push(layer.opacity); // alpha channel
					}

					gidCounter++;
				}
			}

			if(backgroundColorSet) {
				this.fillBackground();
			}

			// draw layer
			for(tileset in this.tilesets) {
				var tilesheet:Tilesheet = this.tilesheets.get(tileset.firstGID);

				tilesheet.drawTiles(this.graphics, drawList, true, Tilesheet.TILE_ALPHA);
			}
		}
	}

	private function onAddedToStageFlash(e:Event) {
		var bitmapData:BitmapData;

		if(backgroundColorSet) {
			bitmapData = new BitmapData(this.totalWidth, this.totalHeight, true, this.backgroundColor);
		} else {
			bitmapData = new BitmapData(this.totalWidth, this.totalHeight, true);
		}

		for(layer in this.layers) {
			var gidCounter:Int = 0;

			for(y in 0...this.heightInTiles) {
				for(x in 0...this.widthInTiles) {
					var nextGID = layer.tiles[gidCounter].gid;

					if(nextGID != 0) {
						var point:Point = new Point();

						switch (orientation) {
							case TiledMapOrientation.Orthogonal:
								point = new Point(x * this.tileWidth, y * this.tileHeight);
							case TiledMapOrientation.Isometric:
								point = new Point((this.width + x - y - 1) * this.tileWidth * 0.5, (y + x) * this.tileHeight * 0.5);
						}

						var tileset:Tileset = getTilesetByGID(nextGID);

						var rect:Rectangle = tileset.getTileRectByGID(nextGID);

						// copy pixels
						bitmapData.copyPixels(tileset.image.texture, rect, point, null, null, true);
					}

					gidCounter++;
				}
			}
		}

		var bitmap:Bitmap = new Bitmap(bitmapData);

		this.addChild(bitmap);
	}

	private function fillBackground():Void {
		this.graphics.beginFill(this.backgroundColor);

		if(orientation == TiledMapOrientation.Orthogonal) {
			this.graphics.drawRect(0, 0, this.totalWidth, this.totalHeight);
		} else {
			this.graphics.drawRect(-this.totalWidth/2, 0, this.totalWidth, this.totalHeight);
		}

		this.graphics.endFill();
	}

	/**
	 * Creates a new TiledMap from an Assets
	 * @param path The path to your asset
	 * @return A TiledMap object
	 */
	public static function fromAssets(path:String):TiledMap {
		return new TiledMap(Helper.getText(path));
	}

	/**
	 * Creates a new TiledMap from a Xml String
	 * @param xml
	 * @return A TiledMap object
	 */
	public static function fromGenericXml(xml:String):TiledMap {
		return new TiledMap(xml);
	}

	private function parseXML(xml:String) {
		var xml = Xml.parse(xml).firstElement();

		this.widthInTiles = Std.parseInt(xml.get("width"));
		this.heightInTiles = Std.parseInt(xml.get("height"));
		this.orientation = xml.get("orientation") == "orthogonal" ?
			TiledMapOrientation.Orthogonal : TiledMapOrientation.Isometric;
		this.tileWidth = Std.parseInt(xml.get("tilewidth"));
		this.tileHeight = Std.parseInt(xml.get("tileheight"));
		this.tilesets = new Array<Tileset>();
		this.layers = new Array<Layer>();
		this.objectGroups = new Array<TiledObjectGroup>();
		this.properties = new Map<String, String>();

		// get background color
		var backgroundColor:String = xml.get("backgroundcolor");

		// if the element isn't set choose white
		if(backgroundColor != null) {
			this.backgroundColorSet = true;

			// replace # with 0xff to match ARGB
			backgroundColor = StringTools.replace(backgroundColor, "#", "0xff");

			this.backgroundColor = Std.parseInt(backgroundColor);
		}

		for (child in xml) {
			if(Helper.isValidElement(child)) {
				if (child.nodeName == "tileset") {
					var tileset:Tileset = null;

					if (child.get("source") != null) {
						tileset = Tileset.fromGenericXml(Helper.getText(child.get("source")));
					} else {
						tileset = Tileset.fromGenericXml(child.toString());
					}

					tileset.setFirstGID(Std.parseInt(child.get("firstgid")));

					this.tilesets.push(tileset);
				}

				else if (child.nodeName == "properties") {
					for (property in child) {
						if (!Helper.isValidElement(property))
							continue;
						properties.set(property.get("name"), property.get("value"));
					}
				}

				else if (child.nodeName == "layer") {
					var layer:Layer = Layer.fromGenericXml(child, this);

					this.layers.push(layer);
				}

				else if (child.nodeName == "objectgroup") {
					var objectGroup = TiledObjectGroup.fromGenericXml(child);

					this.objectGroups.push(objectGroup);
				}
			}
		}
	}

	/**
	 * Returns the Tileset which contains the given GID.
	 * @return The tileset which contains the given GID, or if it doesn't exist "null"
	 */
	public function getTilesetByGID(gid:Int):Tileset {
		var tileset:Tileset = null;

		for(t in this.tilesets) {
			if(gid >= t.firstGID) {
				tileset = t;
			}
		}

		return tileset;
	}

	/**
	 * Returns the total Width of the map
	 * @return Map width in pixels
	 */
	private function get_totalWidth():Int {
		return this.widthInTiles * this.tileWidth;
	}

	/**
	 * Returns the total Height of the map
	 * @return Map height in pixels
	 */
	private function get_totalHeight():Int {
		return this.heightInTiles * this.tileHeight;
	}

	/**
	 * Returns the layer with the given name.
	 * @param name The name of the layer
	 * @return The searched layer, null if there is no such layer.
	 */
	public function getLayerByName(name:String):Layer {
		for(layer in this.layers) {
			if(layer.name == name) {
				return layer;
			}
		}

		return null;
	}

	/**
	 * Returns the object group with the given name.
	 * @param name The name of the object group
	 * @return The searched object group, null if there is no such object group.
	 */
	public function getObjectGroupByName(name:String):TiledObjectGroup {
		for(objectGroup in this.objectGroups) {
			if(objectGroup.name == name) {
				return objectGroup;
			}
		}

		return null;
	}

	 /**
	  * Returns an object in a given object group
	  * @param name The name of the object
	  * @param inObjectGroup The object group which contains this object.
	  * @return An TiledObject, null if there is no such object.
	  */
	public function getObjectByName(name:String, inObjectGroup:TiledObjectGroup):TiledObject {
		for(object in inObjectGroup) {
			if(object.name == name) {
				return object;
			}
		}

		return null;
	}

	private function rectEquals(r1:Rectangle, r2:Rectangle):Bool {
		return r1.x == r2.x && r1.y == r2.y && r1.width == r2.width && r1.height == r2.height;
	}
}
