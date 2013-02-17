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

import nme.geom.Point;

class TiledObject {

	public var gid(default, null):Int;
	public var name(default, null):String;
	public var type(default, null):String;
	public var x(default, null):Int;
	public var y(default, null):Int;
	public var width(default, null):Int;
	public var height(default, null):Int;
	public var hasPolygon(checkHasPolygon, null):Bool;
	public var hasPolyline(checkHasPolyline, null):Bool;
	public var polygon(default, null):TiledPolygon;
	public var polyline(default, null):TiledPolyline;
	public var properties(default, null):Hash<String>;
	
	public function new(gid:Int, name:String, type:String, x:Int, y:Int, width:Int, height:Int, polygon:TiledPolygon, polyline:TiledPolyline, properties:Hash<String>) {
		this.gid = gid;
		this.name = name;
		this.type = type;
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.polygon = polygon;
		this.polyline = polyline;
		this.properties = properties;
	}
	
	public static function fromXml(xml:Xml):TiledObject {
		var gid:Int = xml.get("gid") != null ? Std.parseInt(xml.get("gid")) : 0;
		var name:String = xml.get("name");
		var type:String = xml.get("type");
		var x:Int = Std.parseInt(xml.get("x"));
		var y:Int = Std.parseInt(xml.get("y"));
		var width:Int = Std.parseInt(xml.get("width"));
		var height:Int = Std.parseInt(xml.get("height"));
		var polygon:TiledPolygon = null;
		var polyline:TiledPolyline = null;
		var properties:Hash<String> = new Hash<String>();
		
		for (child in xml) {
			if(Helper.isValidElement(child)) {
				if (child.nodeName == "properties") {
					for (property in child) {
						if(Helper.isValidElement(property)) {
							properties.set(property.get("name"), property.get("value"));
						}
					}
				}
				
				if (child.nodeName == "polygon" || child.nodeName == "polyline") {
					var origin:Point = new Point(x, y);
					var points:Array<Point> = new Array<Point>();
					
					var pointsAsString:String = child.get("points");
					
					var pointsAsStringArray:Array<String> = pointsAsString.split(" ");
					
					for(p in pointsAsStringArray) {
						var coords:Array<String> = p.split(",");
						points.push(new Point(Std.parseInt(coords[0]), Std.parseInt(coords[1])));
					}
					
					if(child.nodeName == "polygon") {
						polygon = new TiledPolygon(origin, points);
					} else if(child.nodeName == "polyline") {
						polyline = new TiledPolyline(origin, points);
					}
				}
			}
		}
		
		return new TiledObject(gid, name, type, x, y, width, height, polygon, polyline, properties);
	}
	
	private function checkHasPolygon():Bool {
		return this.polygon != null;
	}
	
	private function checkHasPolyline():Bool {
		return this.polyline != null;
	}
	
}
