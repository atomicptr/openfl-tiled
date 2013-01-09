package de.kasoki.nmetiled;

class PropertyTile {

	public var id(default, null):Int;
	public var properties(default, null):Hash<String>;
	
	public function new(id:Int, properties:Hash<String>) {
		this.id = id;
		this.properties = properties;
	}
	
}
