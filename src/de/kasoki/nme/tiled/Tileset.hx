package de.kasoki.nme.tiled;

class Tileset {

	public var name(default, null):String;
	public var tileWidth(default, null):Int;
	public var tileHeight(default, null):Int;
	
	public function new(name:String, tileWidth:Int, tileHeight:Int) {
		this.name = name;
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
	}
	
	public static function fromGenericXml(content:String):Tileset {
		var xml = Xml.parse(content).firstElement();
		
		var name:String = xml.get("name");
		var tileWidth:Int = cast xml.get("tilewidth");
		var tileHeight:Int = cast xml.get("tileheight");
		// properties
		// var image:TilesetImage
		
		return new Tileset(name, tileWidth, tileHeight);
	}
	
	public static function fromGenericXmlAsset(path:String):Tileset {
		
	}
	
}