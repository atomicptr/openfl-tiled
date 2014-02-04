package openfl.tiled;

import flash.display.BitmapData;

import openfl.Assets;

/**
 * ...
 * @author Christopher Kaster
 */
class DefaultAssetLoader implements AssetLoader{
	
	public function new() {
	}
	
	/** Default OpenFL way to load text */
	public function getText(assetPath:String):String {
		return Assets.getText(assetPath);
	}
	
	/** Default OpenFL way to load bitmapData */
	public function getBitmapData(assetPath:String):BitmapData {
		return Assets.getBitmapData(assetPath);
	}
	
}