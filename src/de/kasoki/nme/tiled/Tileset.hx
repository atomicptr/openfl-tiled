package de.kasoki.nme.tiled;

class Tileset {

	public var firstGID(default, null):Int;
	public var name(default, null):String;
	public var tileWidth(default, null):Int;
	public var tileHeight(default, null):Int;
	public var properties(default, null):Hash<String>;
	public var image(default, null):TilesetImage;
	
	public function new(name:String, tileWidth:Int, tileHeight:Int, properties:Hash<String>, image:TilesetImage) {
		this.name = name;
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
		this.properties = properties;
		this.image = image;
		
		#if debug
		trace(name);
		trace(tileWidth);
		for (property in properties) {
			trace(property);
		}
		trace(image);
		#end
	}
	
	public function setFirstGID(gid:Int) {
		this.firstGID = gid;
	}
	
	public static function fromGenericXml(content:String):Tileset {
		var xml = Xml.parse(content).firstElement();
		
		var name:String = xml.get("name");
		var tileWidth:Int = cast xml.get("tilewidth");
		var tileHeight:Int = cast xml.get("tileheight");
		var properties:Hash<String> = new Hash<String>();
		var image:TilesetImage = null;
		
		for (child in xml.elements()) {
			if (cast(child.nodeType, String) != "element") {
				continue;
			}
			
			if (child.nodeName == "properties") {
				for (property in child) {
					properties.set(property.get("name"), property.get("value"));
				}
			}
			
			if (child.nodeName == "image") {
				image = new TilesetImage(child.get("source"), cast child.get("width"), cast child.get("height"));
			}
		}
		
		return new Tileset(name, tileWidth, tileHeight, properties, image);
	}
	
	public static function fromGenericXmlAsset(path:String):Tileset {
		return null;
	}
	
}