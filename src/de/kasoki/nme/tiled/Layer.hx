package de.kasoki.nme.tiled;

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
	
	public static function fromXml(xml:Xml):Layer {
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