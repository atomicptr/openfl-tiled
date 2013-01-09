package de.kasoki.nme.tiled;

import nme.Assets;

class TiledMap {

	public var width(default, null):Int;
	public var height(default, null):Int;
	public var orientation(default, null):TiledMapOrientation;
	public var tileWidth(default, null):Int;
	public var tileHeight(default, null):Int;
	public var tilesets(default, null):Hash<Tileset>;
	public var layers(default, null):Hash<Layer>;
	
	
	public function new(path:String) {
		parseXML(readFile(path));
	}
	
	private function parseXML(xml:String) {
		var xml = Xml.parse(xml).firstElement();
		
		this.width = Std.parseInt(xml.get("width"));
		this.height = Std.parseInt(xml.get("height"));
		this.orientation = xml.get("orientation") == "orthogonal" ?
			TiledMapOrientation.Orthogonal : TiledMapOrientation.Isometric;
		this.tileWidth = Std.parseInt(xml.get("tilewidth"));
		this.tileHeight = Std.parseInt(xml.get("tileheight"));
		this.tilesets = new Hash<Tileset>();
		this.layers = new Hash<Layer>();
		
		for (child in xml) {
			if (Std.string(child.nodeType) != "element") {
				continue;
			}
			
			if (child.nodeName == "tileset") {
				var tileset:Tileset = null;
				
				if (child.get("source") != null) {
					tileset = Tileset.fromGenericXml(Assets.getText(child.get("source")));
				} else {
					tileset = Tileset.fromGenericXml(child.toString());
				}

				tileset.setFirstGID(Std.parseInt(child.get("firstgid")));
				
				// Tilesets with the same name are not allowed!
				this.tilesets.set(tileset.name, tileset);
			}
			
			if (child.nodeName == "layer") {
				var layer:Layer = Layer.fromXml(child);
				
				this.layers.set(layer.name, layer);
			}
		}
	}
	
	private function readFile(path:String):String {
		return Assets.getText(path);
	}
	
}