package;

import flash.display.Bitmap;
import flash.Lib;
import flash.ui.Keyboard;
import flash.events.KeyboardEvent;

import openfl.tiled.TiledMap;

import openfl.display.FPS;

class Main {

	private static var map:TiledMap;

	public static function main():Void {
		map = TiledMap.fromAssets("level.tmx");

		map.x = 0;
		map.y = 0;

		Lib.current.stage.addChild(map);
		Lib.current.stage.addChild(new FPS());

		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	}

	private static function onKeyDown(e:KeyboardEvent):Void {
		if(e.keyCode == Keyboard.RIGHT) {
			map.x -= 5;
		}

		if(e.keyCode == Keyboard.DOWN) {
			map.y -= 5;
		}
	}
}