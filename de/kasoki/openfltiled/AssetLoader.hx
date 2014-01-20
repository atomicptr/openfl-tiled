package de.kasoki.openfltiled;
import flash.display.BitmapData;

/**
 * ...
 * @author Christopher Kaster
 */
interface AssetLoader{
	public function getText(assetPath:String):String;
	public function getBitmapData(assetPath:String):BitmapData;
}