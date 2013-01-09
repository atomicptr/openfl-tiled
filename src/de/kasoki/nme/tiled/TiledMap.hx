package de.kasoki.nme.tiled;
import nme.Assets;

class TiledMap {

	public var width(default, null):Int;
	public var height(default, null):Int;
	public var orientation(default, null):TiledMapOrientation;
	public var tileWidth(default, null):Int;
	public var tileHeight(default, null):Int;
	public var tilesets(default, null):Hash<TiledMapTileset>;
	
	
	public function new(path:String) {
		parseXML(readFile(path));
	}
	
	private function parseXML(xml:String) {
		var xml = Xml.parse(xml).firstElement();
		
		this.width = cast xml.get("width");
		this.height = cast xml.get("height");
		this.orientation = xml.get("orientation") == "orthogonal" ?
			TiledMapOrientation.Orthogonal : TiledMapOrientation.Isometric;
		this.tileWidth = cast xml.get("tilewidth");
		this.tileHeight = cast xml.get("tileheight");
		
		
		
		#if debug
		trace(width);
		trace(height);
		trace(orientation);
		trace(tileWidth);
		trace(tileHeight);
		#end
		
	}
	
	private function readFile(path:String):String {
		return Assets.getText(path);
	}
	
}