package openfl.tiled.display;

interface Renderer {
	public function setTiledMap(map:TiledMap):Void;
	public function drawLayer(on:Dynamic, layer:Layer):Void;
	public function drawImageLayer(on:Dynamic, imageLayer:ImageLayer):Void;
	public function clear(on:Dynamic):Void;
}