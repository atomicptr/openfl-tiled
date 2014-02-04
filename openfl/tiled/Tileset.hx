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

import flash.geom.Point;
import flash.display.BitmapData;
import flash.geom.Rectangle;

class Tileset {

	/** The first GID this tileset has */
	public var firstGID:Int;

	/** The name of this tileset */
	public var name:String;

	/** The width of the tileset image */
	public var width(get_width, null):Int;

	/** The height of the tileset image */
	public var height(get_height, null):Int;

	/** The width of one tile */
	public var tileWidth:Int;

	/** The height of one tile */
	public var tileHeight:Int;
	
	/** The spacing between the tiles */
	public var spacing:Int;

	/** All properties this Tileset contains */
	public var properties:Map<String, String>;

	/** All tiles with special properties */
	public var propertyTiles:Map<Int, PropertyTile>;

	/** The image of this tileset */
	public var image:TilesetImage;
	
	private function new(name:String, tileWidth:Int, tileHeight:Int, spacing:Int, properties:Map<String, String>, image:TilesetImage) {
		this.name = name;
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
		this.spacing = spacing;
		this.properties = properties;
		this.image = image;
	}
	
	/** Sets the first GID. */
	public function setFirstGID(gid:Int) {
		this.firstGID = gid;
	}
	
	/** Generates a new Tileset from the given Xml code */
	public static function fromGenericXml(content:String):Tileset {
		var xml = Xml.parse(content).firstElement();
		
		var name:String = xml.get("name");
		var tileWidth:Int = Std.parseInt(xml.get("tilewidth"));
		var tileHeight:Int = Std.parseInt(xml.get("tileheight"));
		var spacing:Int = xml.exists("spacing") ? Std.parseInt(xml.get("spacing")) : 0;
		var properties:Map<String, String> = new Map<String, String>();
		var propertyTiles:Map<Int, PropertyTile> = new Map<Int, PropertyTile>();
		var image:TilesetImage = null;
		
		for (child in xml.elements()) {
			if(Helper.isValidElement(child)) {
				if (child.nodeName == "properties") {
					for (property in child) {
						if (Helper.isValidElement(property)) {
							properties.set(property.get("name"), property.get("value"));
						}
					}
				}
				
				if (child.nodeName == "image") {
					var width = Std.parseInt(child.get("width"));
					var height = Std.parseInt(child.get("height"));
					
					image = new TilesetImage(child.get("source"), width, height);
				}
				
				if (child.nodeName == "tile") {
					var id:Int = Std.parseInt(child.get("id"));
					var properties:Map<String, String> = new Map<String, String>();
					
					for (element in child) {
						if(Helper.isValidElement(element)) {
							if (element.nodeName == "properties") {
								for (property in element) {
									if (!Helper.isValidElement(property)) {
										continue;
									}
									
									properties.set(property.get("name"), property.get("value"));
								}
							}
						}
					}
					
					propertyTiles.set(id, new PropertyTile(id, properties));
				}
			}
		}
		
		return new Tileset(name, tileWidth, tileHeight, spacing, properties, image);
	}
	
	/** Returns the BitmapData of the given GID */
	public function getTileBitmapDataByGID(gid:Int):BitmapData {
		var bitmapData = new BitmapData(this.tileWidth, this.tileHeight, true, 0x000000);

		var texturePositionX:Float = getTexturePositionByGID(gid).x;
		var texturePositionY:Float = getTexturePositionByGID(gid).y;
		
		var texture:BitmapData = Helper.getBitmapData(this.image.source);
		var rect:Rectangle = new Rectangle((texturePositionX * this.tileWidth) + (texturePositionX * spacing),
			(texturePositionY * this.tileHeight) + (texturePositionY * spacing), this.tileWidth, this.tileHeight);
			
		trace("X: " + rect.x + ", Y: " + rect.y);
			
		var point:Point = new Point(0, 0);
		
		bitmapData.copyPixels(texture, rect, point, null, null, true);

		return bitmapData;
	}

	/** Returns a Point which specifies the position of the gid in this tileset (Not in pixels!) */
	public function getTexturePositionByGID(gid:Int):Point {
		var number = gid - this.firstGID;

		return new Point(getInnerTexturePositionX(number), getInnerTexturePositionY(number));
	}

	/** Returns the inner x-position of a texture with given tileNumber */
	private function getInnerTexturePositionX(tileNumber):Int {
		return (tileNumber % Std.int(this.width / this.tileWidth));
	}
	
	/** Returns the inner y-position of a texture with given tileNumber */
	private function getInnerTexturePositionY(tileNumber):Int {
		return Std.int(tileNumber / Std.int(this.width / this.tileWidth));
	}
	
	private function get_width():Int {
		return this.image.width;
	}
	
	private function get_height():Int {
		return this.image.height;
	}
}
