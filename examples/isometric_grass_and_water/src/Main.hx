package;

import flash.display.Bitmap;
import flash.Lib;

import openfl.tiled.TiledMap;

import openfl.Assets;
import openfl.display.FPS;

class Main {

	private static var mapBitmap:Bitmap;

	public static function main():Void {
		var map = TiledMap.fromAssets("isometric_grass_and_water.tmx");
		
		mapBitmap = new Bitmap(map.createBitmapData());

		mapBitmap.x -= 400;
		mapBitmap.y -= 150;

		Lib.current.stage.addChild(mapBitmap);
		Lib.current.stage.addChild(new FPS());
	}
}