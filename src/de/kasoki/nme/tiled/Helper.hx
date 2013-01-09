package de.kasoki.nme.tiled;

class Helper {

	private function new() {
	}
	
	public static function isValidElement(element:Xml):Bool {
		return Std.string(element.nodeType) == "element";
	}
	
}