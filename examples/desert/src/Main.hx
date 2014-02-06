package;

import flash.display.Bitmap;
import flash.Lib;
import flash.ui.Keyboard;
import flash.events.KeyboardEvent;

import openfl.tiled.TiledMap;

import openfl.display.FPS;

class Main {

	private static var mapBitmap:Bitmap;

	public static function main():Void {
		var map = TiledMap.fromAssets("desert.tmx");

		mapBitmap = new Bitmap(map.createBitmapData());

		Lib.current.stage.addChild(mapBitmap);
		Lib.current.stage.addChild(new FPS());

		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	}

	private static function onKeyDown(e:KeyboardEvent):Void {
		if(e.keyCode == Keyboard.RIGHT) {
			mapBitmap.x -= 5;
		}

		if(e.keyCode == Keyboard.DOWN) {
			mapBitmap.y -= 5;
		}
	}
}