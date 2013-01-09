package de.kasoki.nme.tiled;
import nme.Assets;

class Tileset {

	public var firstGID(default, null):Int;
	public var name(default, null):String;
	public var tileWidth(default, null):Int;
	public var tileHeight(default, null):Int;
	public var properties(default, null):Hash<String>;
	public var propertyTiles(default, null):IntHash<PropertyTile>;
	public var image(default, null):TilesetImage;
	
	public function new(name:String, tileWidth:Int, tileHeight:Int, properties:Hash<String>, image:TilesetImage) {
		this.name = name;
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
		this.properties = properties;
		this.image = image;
	}
	
	public function setFirstGID(gid:Int) {
		this.firstGID = gid;
	}
	
	public static function fromGenericXml(content:String):Tileset {
		var xml = Xml.parse(content).firstElement();
		
		var name:String = xml.get("name");
		var tileWidth:Int = Std.parseInt(xml.get("tilewidth"));
		var tileHeight:Int = Std.parseInt(xml.get("tileheight"));
		var properties:Hash<String> = new Hash<String>();
		var propertyTiles:IntHash<PropertyTile> = new IntHash<PropertyTile>();
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
					var properties:Hash<String> = new Hash<String>();
					
					for (element in child) {
						if(Helper.isValidElement(element)) {
							if (element.nodeName == "properties") {
								for (property in element) {
									if (Std.string(property.nodeType) != "element") {
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
		
		return new Tileset(name, tileWidth, tileHeight, properties, image);
	}
}