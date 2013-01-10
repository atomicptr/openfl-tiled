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
	public var tilesets(default, null):Hash<Tileset>;
	public var layers(default, null):Array<Layer>;
	public var objectGroups(default, null):Hash<ObjectGroup>;
	
	
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
		this.tilesets = new Hash<Tileset>();
		this.layers = new Array<Layer>();
		this.objectGroups = new Hash<ObjectGroup>();
		
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
					
					// Tilesets with the same name are not allowed!
					this.tilesets.set(tileset.name, tileset);
				}
				
				if (child.nodeName == "layer") {
					var layer:Layer = Layer.fromXml(child);
					
					this.layers.push(layer);
				}
				
				if (child.nodeName == "objectgroup") {
					var objectGroup = ObjectGroup.fromXml(child);
					
					this.objectGroups.set(objectGroup.name, objectGroup);
				}
			}
		}
	}
	
	private function readFile(path:String):String {
		return Assets.getText(path);
	}
	
	public function createBitmapData():BitmapData {
		var tilesetsByFirstGID:IntHash<BitmapData> = new IntHash<BitmapData>();
		
		for(t in this.tilesets) {
			tilesetsByFirstGID.set(t.firstGID, Assets.getBitmapData(t.image.source));
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
						
						var tilesetFirstGID:Int = -1;
						var width:Int = 0;
						var height:Int = 0;
						
						for(t in this.tilesets) {
							if(nextGID >= t.firstGID) {
								tilesetFirstGID = t.firstGID;
								width = t.image.width;
								height = t.image.height;
							}
						}
						
						var textureX:Int = ((nextGID - 1) % Std.int(width / this.tileWidth));
						var textureY:Int = Std.int((nextGID - 1) / Std.int(width / this.tileWidth));
						
						var texture:BitmapData = tilesetsByFirstGID.get(tilesetFirstGID);
						var rect:Rectangle = new Rectangle(textureX * this.tileWidth,
							textureY * this.tileHeight, this.tileWidth, this.tileHeight);
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
