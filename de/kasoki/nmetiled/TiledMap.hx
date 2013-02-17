// Copyright (C) 2013 Christopher "Kasoki" Kaster
// 
// This file is part of "nme-tiled". <http://github.com/Kasoki/nme-tiled>
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
package de.kasoki.nmetiled;

import nme.Assets;
import nme.geom.Rectangle;
import nme.geom.Point;
import nme.display.BitmapData;

class TiledMap {

	public var width:Int;
	public var height:Int;
	public var totalWidth(getTotalWidth, null):Int;
	public var totalHeight(getTotalHeight, null):Int;
	public var orientation:TiledMapOrientation;
	public var tileWidth:Int;
	public var tileHeight:Int;
	public var tilesets:Array<Tileset>;
	public var layers:Array<Layer>;
	public var objectGroups:Array<TiledObjectGroup>;
	
	
	private function new(xml:String) {
		parseXML(xml);
	}

	public static function fromAssets(path:String):TiledMap {
		return new TiledMap(Assets.getText(path));
	}

	public static function fromGenericXml(xml:String):TiledMap {
		return new TiledMap(xml);
	}
	
	private function parseXML(xml:String) {
		var xml = Xml.parse(xml).firstElement();
		
		this.width = Std.parseInt(xml.get("width"));
		this.height = Std.parseInt(xml.get("height"));
		this.orientation = xml.get("orientation") == "orthogonal" ?
			TiledMapOrientation.Orthogonal : TiledMapOrientation.Isometric;
		this.tileWidth = Std.parseInt(xml.get("tilewidth"));
		this.tileHeight = Std.parseInt(xml.get("tileheight"));
		this.tilesets = new Array<Tileset>();
		this.layers = new Array<Layer>();
		this.objectGroups = new Array<TiledObjectGroup>();
		
		for (child in xml) {
			if(Helper.isValidElement(child)) {
				if (child.nodeName == "tileset") {
					var tileset:Tileset = null;
					
					if (child.get("source") != null) {
						tileset = Tileset.fromGenericXml(Assets.getText(child.get("source")));
					} else {
						tileset = Tileset.fromGenericXml(child.toString());
					}

					tileset.setFirstGID(Std.parseInt(child.get("firstgid")));
					
					this.tilesets.push(tileset);
				}
				
				if (child.nodeName == "layer") {
					var layer:Layer = Layer.fromGenericXml(child);
					
					this.layers.push(layer);
				}
				
				if (child.nodeName == "objectgroup") {
					var objectGroup = TiledObjectGroup.fromGenericXml(child);
					
					this.objectGroups.push(objectGroup);
				}
			}
		}
	}
	
	public function createBitmapData():BitmapData {
		var tilesetBitmapDataByFirstGID:IntHash<BitmapData> = new IntHash<BitmapData>();
		
		for(t in this.tilesets) {
			tilesetBitmapDataByFirstGID.set(t.firstGID, Assets.getBitmapData(t.image.source));
		}
		
		var bitmapData = new BitmapData(this.width * this.tileWidth,
			this.height * this.tileHeight);
		
		for(i in 0...this.layers.length) {
			var layer = this.layers[i];
			
			var gidCounter:Int = 0;

			for(y in 0...this.height) {
				for(x in 0...this.width) {
					var nextGID = layer.tiles[gidCounter];
					
					if(nextGID != 0) {
						
						var tileset:Tileset = null;
						
						for(t in this.tilesets) {
							if(nextGID >= t.firstGID) {
								tileset = t;
							}
						}
						
						var textureNumber:Int = nextGID - tileset.firstGID;
						
						var innerTexturePositionX:Int = tileset.getInnerTexturePositionX(textureNumber);
						var innerTexturePositionY:Int = tileset.getInnerTexturePositionY(textureNumber);
						
						var texture:BitmapData = tilesetBitmapDataByFirstGID.get(tileset.firstGID);
						var rect:Rectangle = new Rectangle(innerTexturePositionX * this.tileWidth,
							innerTexturePositionY * this.tileHeight, this.tileWidth, this.tileHeight);
						var point:Point = new Point(x * this.tileWidth, y * this.tileHeight);
						
						bitmapData.copyPixels(texture, rect, point, null, null, true);
					}
					
					gidCounter++;
				}
			}
		}
		
		return bitmapData;
	}
	
	private function getTotalWidth():Int {
		return this.width * this.tileWidth;	
	}
	
	private function getTotalHeight():Int {
		return this.height * this.tileHeight;
	}
	
}
