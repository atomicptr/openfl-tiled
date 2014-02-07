package;

import flash.display.Bitmap;
import flash.Lib;

import openfl.tiled.TiledMap;

import openfl.Assets;
import openfl.display.FPS;

class Main {
	public static function main():Void {
		var map = TiledMap.fromAssets("sewers.tmx");
		
		Lib.current.stage.addChild(map);
		Lib.current.stage.addChild(new FPS());
	}
}
