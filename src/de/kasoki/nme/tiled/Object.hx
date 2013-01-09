package de.kasoki.nme.tiled;

class Object {

	public var name(default, null):String;
	public var type(default, null):String;
	public var x(default, null):Int;
	public var y(default, null):Int;
	public var width(default, null):Int;
	public var height(default, null):Int;
	public var properties(default, null):Hash<String>;
	
	public function new(name:String, type:String, x:Int, y:Int, width:Int, height:Int, properties:Hash<String>) {
		this.name = name;
		this.type = type;
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.properties = properties;
	}
	
	public static function fromXml(xml:Xml):Object {
		var name:String = xml.get("name");
		var type:String = xml.get("type");
		var x:Int = Std.parseInt(xml.get("x"));
		var y:Int = Std.parseInt(xml.get("y"));
		var width:Int = Std.parseInt(xml.get("width"));
		var height:Int = Std.parseInt(xml.get("height"));
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
			}
		}
		
		return new Object(name, type, x, y, width, height, properties);
	}
	
}