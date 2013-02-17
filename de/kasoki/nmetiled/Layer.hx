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

class Layer {

	public var name(default, null):String;
	public var width(default, null):Int;
	public var height(default, null):Int;
	
	public var tiles(default, null):Array<Int>;
	
	public function new(name:String, width:Int, height:Int, tiles:Array<Int>) {
		this.name = name;
		this.width = width;
		this.height = height;
		this.tiles = tiles;
	}
	
	public static function fromGenericXml(xml:Xml):Layer {
		var name:String = xml.get("name");
		var width:Int = Std.parseInt(xml.get("width"));
		var height:Int = Std.parseInt(xml.get("height"));
		var tiles:Array<Int> = new Array<Int>();
		
		for (child in xml) {
			if(Helper.isValidElement(child)) {
				if (child.nodeName == "data") {
					for (tile in child) {
						if (Helper.isValidElement(tile)) {
							var gid = Std.parseInt(tile.get("gid"));
							
							tiles.push(gid);
						}
					}
				}
			}
		}
		
		return new Layer(name, width, height, tiles);
	}

	
	
}
