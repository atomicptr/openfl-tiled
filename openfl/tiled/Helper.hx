// Copyright (C) 2013 Christopher "Kasoki" Kaster
//
// This file is part of "openfl-tiled". <http://github.com/Kasoki/openfl-tiled>
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
package openfl.tiled;

import haxe.io.Path;

import flash.display.BitmapData;

class Helper {

	private static var assetLoader:AssetLoader;

	private function new() {
	}

	/** This method checks if the given Xml element is really a Xml element! */
	public static function isValidElement(element:Xml):Bool {
		return Std.string(element.nodeType) == "element";
	}

	/** This method sets a new AssetLoader */
	public static function setAssetLoader(assetLoader:AssetLoader):Void {
		Helper.assetLoader = assetLoader;
	}

	/** This methods is wrapper for Assets.getText(string), if
		you're using another Asset managment system simply override this method */
	public static function getText(assetPath:String, ?prefix:String):String {
		if (assetLoader == null) {
			assetLoader = new DefaultAssetLoader();
		}

		return assetLoader.getText(Helper.joinPath(prefix, assetPath));
	}

	/** This methods is wrapper for Assets.getBitmapData(string), if
		you're using another Asset managment system simply override this method */
	public static function getBitmapData(assetPath:String, ?prefix:String):BitmapData {
		if(assetLoader == null) {
			assetLoader = new DefaultAssetLoader();
		}

		return assetLoader.getBitmapData(Helper.joinPath(prefix, assetPath));
	}

	public static function joinPath(path1:String, path2:String):String {
		if(path1 == null) {
			path1 = "";
		}

		if(path2 == null) {
			path2 = "";
		}

		return Path.normalize(path1 + path2);
	}
}
