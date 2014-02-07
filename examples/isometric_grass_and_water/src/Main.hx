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

		map.x += 500;
		map.y -= 200;

		Lib.current.stage.addChild(map);
		Lib.current.stage.addChild(new FPS());
	}
}