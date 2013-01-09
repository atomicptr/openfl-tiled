package;

import nme.Assets;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;

import de.kasoki.nme.tiled.TiledMap;

/**
 * ...
 * @author Christopher Kaster
 */

class Main extends Sprite {
	
	public function new() {
		super();
		#if iphone
		Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
		addEventListener(Event.ADDED_TO_STAGE, init);
		#end
	}

	private function init(e) {
		var map:TiledMap = new TiledMap("assets/map.tmx");
	}
	
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		Lib.current.addChild(new Main());
	}
	
}
