package ui;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import ui.AtlasText.AtlasFont;
import ui.TextMenuList.TextMenuItem;
import haxe.DynamicAccess;

import TitleState;

typedef Iterator<T> = {
	function hasNext():Bool;
	function next():T;
}

class PreferencesMenu extends ui.OptionsState.Page
{
	public static var preferences:Map<String, Dynamic> = new Map();

	var items:TextMenuList;

	var checkboxes:Array<CheckboxThingie> = [];
	var menuCamera:FlxCamera;
	var camFollow:FlxObject;

	public function new()
	{
		super();

		menuCamera = new SwagCamera();
		FlxG.cameras.add(menuCamera, false);
		menuCamera.bgColor = 0x0;
		camera = menuCamera;

		add(items = new TextMenuList());

		if (TitleState.optionsSave.data.optionsList == null) {
			TitleState.optionsSave.data.optionsList = [];
		}

		//if (TitleState.optionsSave.data.zeOptionsList == null) {
		//	TitleState.optionsSave.data.zeOptionsList = [];
		//}

		createPrefItem('naughtyness', 'censor-naughty', true);
		createPrefItem('downscroll', 'downscroll', false);
		createPrefItem('Ghost Tapping', 'ghost-tapping', true);
		createPrefItem('flashing menu', 'flashing-menu', true);
		createPrefItem('Camera Zooming on Beat', 'camera-zoom', true);
		createPrefItem('Show Song Timer', 'timer', true);
		createPrefItem('FPS Counter', 'fps-counter', true);
		createPrefItem('Auto Pause', 'auto-pause', false);

		//------------------------------------------------------- DEBUG ------------------------------------------------------

		/*var somethingSomething = {
			something1: "hello",
			something2: false
		}

		Reflect.setProperty(somethingSomething, "something3", 334);

		trace(somethingSomething.something3);

		Reflect.setProperty(somethingSomething, "something1", "hi");
		
		trace(Reflect.getProperty(somethingSomething, "something1"));*/
		


		// -------------------------------------------------------------------------------------------------------------------

		camFollow = new FlxObject(FlxG.width / 2, 0, 140, 70);
		if (items != null)
			camFollow.y = items.selectedItem.y;

		menuCamera.follow(camFollow, null, 0.06);
		var margin = 160;
		menuCamera.deadzone.set(0, margin, menuCamera.width, 40);
		menuCamera.minScrollY = 0;

		items.onChange.add(function(selected)
		{
			camFollow.y = selected.y;
		});
	}

	public static function getPref(pref:String):Dynamic
	{
		return preferences.get(pref);
	}

	// easy shorthand?
	public static function setPref(pref:String, value:Dynamic):Void
	{
		preferences.set(pref, value);
	}

	public static function initPrefs():Void
	{	
		/*
		if (TitleState.optionsSave.data.defaultSettingsSetYet != true) {
			preferenceCheck('censor-naughty', true);
			preferenceCheck('downscroll', false);
			preferenceCheck('ghost-tapping', true);
			preferenceCheck('flashing-menu', true);
			preferenceCheck('camera-zoom', true);
			preferenceCheck('timer', true);
			preferenceCheck('fps-counter', true);
			preferenceCheck('auto-pause', false);
			preferenceCheck('master-volume', 1);

			TitleState.optionsSave.data.defaultSettingsSetYet = true;
		} else {
			preferenceCheck('censor-naughty', TitleState.optionsSave.data.censor_naughty);
			preferenceCheck('downscroll', TitleState.optionsSave.data.downscroll);
			preferenceCheck('ghost-tapping', TitleState.optionsSave.data.ghost_tapping);
			preferenceCheck('flashing-menu', TitleState.optionsSave.data.flashing_menu);
			preferenceCheck('camera-zoom', TitleState.optionsSave.data.camera_zoom);
			preferenceCheck('timer', TitleState.optionsSave.data.timer);
			preferenceCheck('fps-counter', TitleState.optionsSave.data.fps_counter);
			preferenceCheck('auto-pause', TitleState.optionsSave.data.auto_pause);
			preferenceCheck('master-volume', 1);
		}*/

		// YOU KNOW WHAT FUCK THIS!
		// "You can't iterate on a Dynamic value, please specify Iterator or Iterable"
		// "You can't iterate on a Dynamic value, please specify Iterator or Iterable"
		// "You can't iterate on a Dynamic value, please specify Iterator or Iterable"
		// "You can't iterate on a Dynamic value, please specify Iterator or Iterable"
		// "You can't iterate on a Dynamic value, please specify Iterator or Iterable"
		// "You can't iterate on a Dynamic value, please specify Iterator or Iterable"
		// "You can't iterate on a Dynamic value, please specify Iterator or Iterable"
		// "You can't iterate on a Dynamic value, please specify Iterator or Iterable"
		// "You can't iterate on a Dynamic value, please specify Iterator or Iterable"
		// SHUT THE FUCK UP I'M SWITCHING TO ARRAYS NOW YOU PIECE OF SHIT!

		var someOptionsOnList:Array<DynamicAccess<Dynamic>> = TitleState.optionsSave.data.optionsList.keys();

		for (anOption in someOptionsOnList) {
			var value = TitleState.optionsSave.data.optionsList.get(anOption);

			preferenceCheck(anOption, value);

			trace(anOption + " is now set to " + value);
		}

		#if muted
		setPref('master-volume', 0);
		FlxG.sound.muted = true;
		#end

		//if (!getPref('fps-counter')) {
		//	FlxG.stage.removeChild(Main.fpsCounter);
		//	trace('if you see this message that means the FPS counter should be removed now.');
		//}

		FlxG.autoPause = getPref('auto-pause');
	}

	private function createPrefItem(prefName:String, prefString:String, prefValue:Dynamic):Void
	{
		items.createItem(120, (120 * items.length) + 30, prefName, AtlasFont.Bold, function()
		{
			preferenceCheck(prefString, prefValue);

			switch (Type.typeof(prefValue).getName())
			{
				case 'TBool':
					prefToggle(prefString);

				default:
					trace('swag');
			}
		});

		switch (Type.typeof(prefValue).getName())
		{
			case 'TBool':
				createCheckbox(prefString);

			default:
				trace('swag');
		}

		trace(Type.typeof(prefValue).getName());

		if (TitleState.optionsSave.data.optionsList.get(prefString) == null) {
			TitleState.optionsSave.data.optionsList.set(prefString, prefValue);
		} else {
			TitleState.optionsSave.data.optionsList.set(prefString, TitleState.optionsSave.data.optionsList.get(prefString));
		}

		/*var iDontCareAnymoreJustLetThisWorkPLEASE = 0;

		for (arrayThingy in TitleState.optionsSave.data.zeOptionsList) {
			if (arrayThingy[0] == prefString) {
				iDontCareAnymoreJustLetThisWorkPLEASE++;
				preferenceCheck(prefString, arrayThingy[1]);
			}

			if (iDontCareAnymoreJustLetThisWorkPLEASE == 0) {
				TitleState.optionsSave.data.zeOptionsList.push([prefString, prefValue]);

				iDontCareAnymoreJustLetThisWorkPLEASE = 0;
			}
		}*/

		TitleState.optionsSave.flush();
	}

	function createCheckbox(prefString:String)
	{
		var checkbox:CheckboxThingie = new CheckboxThingie(0, 120 * (items.length - 1), preferences.get(prefString));
		checkboxes.push(checkbox);
		add(checkbox);
	}

	/**
	 * Assumes that the preference has already been checked/set?
	 */
	private function prefToggle(prefName:String)
	{
		var daSwap:Bool = preferences.get(prefName);
		daSwap = !daSwap;
		preferences.set(prefName, daSwap);
		checkboxes[items.selectedIndex].daValue = daSwap;
		trace('toggled? ' + preferences.get(prefName));

		switch (prefName)
		{
			case 'fps-counter':
				if (getPref('fps-counter')) {
					//FlxG.stage.addChild(Main.fpsCounter);
					Main.fpsCounter.visible = true;
					trace('hello fps counter');
				} else {
					//FlxG.stage.removeChild(Main.fpsCounter);
					Main.fpsCounter.visible = false;
					trace('goodbye fps counter');
				}
			case 'auto-pause':
				FlxG.autoPause = getPref('auto-pause');
		}

		if (prefName == 'fps-counter') {}

		TitleState.optionsSave.data.optionsList.set(prefName, daSwap);

		//for (arrayIndex => arrayThingy in TitleState.optionsSave.data.zeOptionsList) {
		//	if (arrayThingy[0] == prefName) {
		//		TitleState.optionsSave.data.zeOptionsList[arrayIndex][1] = daSwap;
		//	}
		//}

		TitleState.optionsSave.flush();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// menuCamera.followLerp = CoolUtil.camLerpShit(0.05);

		items.forEach(function(daItem:TextMenuItem)
		{
			if (items.selectedItem == daItem)
				daItem.x = 150;
			else
				daItem.x = 120;
		});
	}

	private static function preferenceCheck(prefString:String, prefValue:Dynamic):Void
	{
		if (preferences.get(prefString) == null)
		{
			preferences.set(prefString, prefValue);
			trace('set preference!');
		}
		else
		{
			trace('found preference: ' + preferences.get(prefString));
		}
	}
}

class CheckboxThingie extends FlxSprite
{
	public var daValue(default, set):Bool;

	public function new(x:Float, y:Float, daValue:Bool = false)
	{
		super(x, y);

		frames = Paths.getSparrowAtlas('checkboxThingie');
		animation.addByPrefix('static', 'Check Box unselected', 24, false);
		animation.addByPrefix('checked', 'Check Box selecting animation', 24, false);

		antialiasing = true;

		setGraphicSize(Std.int(width * 0.7));
		updateHitbox();

		this.daValue = daValue;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		switch (animation.curAnim.name)
		{
			case 'static':
				offset.set();
			case 'checked':
				offset.set(17, 70);
		}
	}

	function set_daValue(value:Bool):Bool
	{
		if (value)
			animation.play('checked', true);
		else
			animation.play('static');

		return value;
	}
}
