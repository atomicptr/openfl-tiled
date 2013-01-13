// Copyright (C) 2012 Christopher Kaster
// 
// This file is part of nme-tiled.
// 
// nme-tiled is free software: you can redistribute it and/or modify it under the
// terms of the GNU Lesser General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option)
// any later version.
// 
// nme-tiled is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
// more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with nme-tiled. If not, see: <http://www.gnu.org/licenses/>.
package de.kasoki.nmetiled;

import nme.Assets;
import nme.geom.Rectangle;
import nme.geom.Point;
import nme.display.BitmapData;

class TiledMap {

	public var width(default, null):Int;
	public var height(default, null):Int;
	public var orientation(default, null):TiledMapOrientation;
	public var tileWidth(default, null):Int;
	public var tileHeight(default, null):Int;
	public var tilesets(default, null):Array<Tileset>;
	public var layers(default, null):Array<Layer>;
	public var objectGroups(default, null):Array<TiledObjectGroup>;
	
	
	public function new(path:String) {
		parseXML(readFile(path));
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
					var layer:Layer = Layer.fromXml(child);
					
					this.layers.push(layer);
				}
				
				if (child.nodeName == "objectgroup") {
					var objectGroup = TiledObjectGroup.fromXml(child);
					
					this.objectGroups.push(objectGroup);
				}
			}
		}
	}
	
	private function readFile(path:String):String {
		return Assets.getText(path);
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
	
}
