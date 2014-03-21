package openfl.tiled.display;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

import openfl.tiled.TiledMap;

class CopyPixelsRenderer implements Renderer {

	private var map:TiledMap;

	public function new() {

	}

	public function setTiledMap(map:TiledMap):Void {
		this.map = map;
	}

	public function addTileset(tileset:Tileset):Void {
		// don't need this method in this renderer :)
	}

	public function drawLayer(on:Dynamic, layer:Layer):Void {
		if(!Std.is(on, Sprite)) {
			return;
		}

		var sprite:Sprite = cast on;

		var bitmapData = new BitmapData(map.totalWidth, map.totalHeight, true, map.backgroundColor);
		var gidCounter:Int = 0;

		if(layer.visible) {
			for(y in 0...map.heightInTiles) {
				for(x in 0...map.widthInTiles) {
					var nextGID = layer.tiles[gidCounter].gid;

					if(nextGID != 0) {
						var point:Point = new Point();

						switch (map.orientation) {
							case TiledMapOrientation.Orthogonal:
								point = new Point(x * map.tileWidth, y * map.tileHeight);
							case TiledMapOrientation.Isometric:
								point = new Point((map.width + x - y - 1) * map.tileWidth * 0.5, (y + x) * map.tileHeight * 0.5);
						}

						var tileset:Tileset = map.getTilesetByGID(nextGID);

						var rect:Rectangle = tileset.getTileRectByGID(nextGID);

						if(map.orientation == TiledMapOrientation.Isometric) {
							point.x += map.totalWidth/2;
						}

						// copy pixels
						bitmapData.copyPixels(tileset.image.texture, rect, point, null, null, true);
					}

					gidCounter++;
				}
			}
		}

		var bitmap = new Bitmap(bitmapData);

		if(map.orientation == TiledMapOrientation.Isometric) {
			bitmap.x -= map.totalWidth/2;
		}

		sprite.addChild(bitmap);
	}

	public function drawImageLayer(on:Dynamic, imageLayer:ImageLayer):Void {
		if(!Std.is(on, Sprite)) {
			return;
		}

		var sprite:Sprite = cast on;

		var bitmap = new Bitmap(imageLayer.image.texture);

		sprite.addChild(bitmap);
	}

	public function clear(on:Dynamic):Void {
		if(!Std.is(on, Sprite)) {
			return;
		}

		var sprite:Sprite = cast on;

		sprite.graphics.clear();

		while(sprite.numChildren > 0){
			sprite.removeChildAt(0);
		}
	}
}