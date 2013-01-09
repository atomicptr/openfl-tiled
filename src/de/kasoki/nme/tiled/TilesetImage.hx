package de.kasoki.nme.tiled;

class TilesetImage {

	public var source(default, null):String;
	public var fileName(default, null):String;
	public var width(default, null):Int;
	public var height(default, null):Int;
	
	public function new(source:String, width:Int, height:Int) {
		this.source = source;
		// get fileName from path
		this.fileName = source.substring(source.lastIndexOf("/", 0) + 1, source.length);
		this.width = width;
		this.height = height;
	}
	
}