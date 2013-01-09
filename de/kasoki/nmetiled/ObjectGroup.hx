package de.kasoki.nmetiled;

class ObjectGroup {

	public var name(default, null):String;
	public var color(default, null):String;
	public var width(default, null):Int;
	public var height(default, null):Int;
	public var properties(default, null):Hash<String>;
	public var objects(default, null):Array<Object>;
	
	public function new(name:String, color:String, width:Int, height:Int, properties:Hash<String>, objects:Array<Object>) {
		this.name = name;
		this.color = color;
		this.width = width;
		this.height = height;
		this.properties = properties;
		this.objects = objects;
	}
	
	public static function fromXml(xml:Xml):ObjectGroup {
		var name = xml.get("name");
		var color = xml.get("color");
		var width = Std.parseInt(xml.get("width"));
		var height = Std.parseInt(xml.get("height"));
		var properties:Hash<String> = new Hash<String>();
		var objects:Array<Object> = new Array<Object>();
		
		for (child in xml) {
			if (Helper.isValidElement(child)) {
				if (child.nodeName == "properties") {
					for (property in child) {
						if (Helper.isValidElement(property)) {
							properties.set(property.get("name"), property.get("value"));
						}
					}
				}
				
				if (child.nodeName == "object") {
					objects.push(Object.fromXml(child));
				}
			}
		}
		
		return new ObjectGroup(name, color, width, height, properties, objects);
	}
	
}
