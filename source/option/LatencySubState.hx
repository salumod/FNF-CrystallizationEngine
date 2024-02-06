package option;

import flixel.FlxCamera;
import funkin.Note;
import funkin.GameUI.UIButton;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;
import haxe.io.Path;
import option.OptionsState;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import ui.AtlasText;

class LatencyMenu extends MusicBeatSubstate
{
	var soundText:FlxText;
	var offsetText:FlxText;
	var bpmText:FlxText;
	var noteGrp:FlxTypedGroup<Note>;
	var strumLine:FlxSprite;
	var multiply:Float;
    var desctxt:FlxText;
	var botton_OFFSET:UIButton;
	var botton_BPM:UIButton;
	var curSelected:Int;
	var menuCamera:FlxCamera;
	
	override function create()
	{
		FlxG.sound.music.fadeOut(FlxG.save.data.volume * FlxG.save.data.musicVolume, 0);

		var menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.scrollFactor.set(0, 0);
		add(menuBG);
		
		menuCamera = new FlxCamera();
		FlxG.cameras.add(menuCamera, true);
		menuCamera.bgColor = 0x0;
		camera = menuCamera;

		//some bg
		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 0.45), Std.int(FlxG.height * 0.87), 0xFF000000);
		bg.scrollFactor.set();
		bg.alpha = 0.4;
		add(bg);

		//play sound
		soundText = new FlxText(FlxG.width * 0.1, FlxG.height * 0.6);
		soundText.setFormat(Paths.font("vcr.ttf"), 30);
		soundText.scrollFactor.set();
		soundText.text = 'play sound';
		add(soundText);
		//note
		noteGrp = new FlxTypedGroup<Note>();
		add(noteGrp);

		for (i in 0...100)
		{
			var note:Note = new Note(Conductor.crochet * i, 1);
			note.scrollFactor.set();
			noteGrp.add(note);
		}

		//offset
		offsetText = new FlxText(FlxG.width * 0.1, FlxG.height * 0.2);
		offsetText.setFormat(Paths.font("vcr.ttf"), 30);
		offsetText.scrollFactor.set();
		add(offsetText);

		botton_OFFSET = new UIButton(FlxG.width * 0.05, FlxG.height * 0.2, FlxG.width * 0.25);
		add(botton_OFFSET);

		botton_BPM = new UIButton(FlxG.width * 0.05, FlxG.height * 0.4, FlxG.width * 0.25 + 100);
		add(botton_BPM);

        //bpm
		bpmText = new FlxText(FlxG.width * 0.1, FlxG.height * 0.4);
		bpmText.setFormat(Paths.font("vcr.ttf"), 30);
		bpmText.scrollFactor.set();
		add(bpmText);

		//removing line
		strumLine = new FlxSprite(FlxG.width * 0.7, 100).makeGraphic(FlxG.width, 5);
		strumLine.loadGraphic(Paths.imageUI('line'));
		strumLine.scrollFactor.set();
		add(strumLine);

		//bgsaying
		var descBg:FlxSprite = new FlxSprite(0, FlxG.height - 90).makeGraphic(FlxG.width, 90, 0xFF000000);
		descBg.scrollFactor.set();
		descBg.alpha = 0.4;
		add(descBg);

		desctxt = new FlxText(descBg.x, descBg.y + 4, FlxG.width, "RESET to reset", 18);
		desctxt.setFormat(Paths.font("Funkin/Funkin.ttf"), 24, FlxColor.WHITE, CENTER);
		desctxt.borderColor = FlxColor.BLACK;
		desctxt.borderSize = 1;
		desctxt.borderStyle = OUTLINE;
		desctxt.scrollFactor.set();
		desctxt.screenCenter(X);
		add(desctxt);

		//bpm used
		Conductor.changeBPM(120);
		changeSelection(0);
		super.create();
	}

	public function changeSelection(change:Int = 0)
	{
		curSelected += change;

		if (curSelected <= 0)
			{
				curSelected = 0;
			}

		if (curSelected >= 2)
			{
				curSelected = 2;
			}

		if (curSelected == 0)
			{
				offsetText.color = FlxColor.YELLOW;
				bpmText.color = FlxColor.WHITE;
				soundText.color = FlxColor.WHITE;
			}
		
		if (curSelected == 1)
			{
				bpmText.color = FlxColor.YELLOW;
				offsetText.color = FlxColor.WHITE;
				soundText.color = FlxColor.WHITE;
			}
		
		if (curSelected == 2)
		    {
				soundText.color = FlxColor.YELLOW;
				bpmText.color = FlxColor.WHITE;
				offsetText.color = FlxColor.WHITE;
			}
	}

	function updateValue()
	{
		FlxG.save.data.offset = Conductor.offset;

		if (curSelected == 0)
			{
				if (controls.UI_LEFT_P)
					{
						Conductor.offset -= 1;
						FlxG.save.flush();
					}

				if (controls.UI_RIGHT_P)
					{
						Conductor.offset += 1;
						FlxG.save.flush();
					}
			}

		if (curSelected == 1)
			{
				if (controls.UI_LEFT_P)
					{
						Conductor.bpm -= 1;
					}

			    if (controls.UI_RIGHT_P)
					{
						Conductor.bpm += 1;
					}
			}

		if (curSelected == 2)
			{
				if (controls.ACCEPT)
					{
						soundsPlay();
					}
			}


	}

	function soundsPlay()
	{
		FlxG.sound.playMusic(Paths.music('soundTest'), FlxG.save.data.volume * FlxG.save.data.musicVolume, true);
	}

	override function destroy()
	{
		super.destroy();

		if (FlxG.cameras.list.contains(menuCamera))
			FlxG.cameras.remove(menuCamera);
	}

	static public function defaultValue()
	{
		if (FlxG.save.data.offset == null)
			FlxG.save.data.offset = 0;
		else
			trace('offset: ' + FlxG.save.data.offset);

		Conductor.offset = FlxG.save.data.offset;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		Conductor.songPosition = FlxG.sound.music.time - Conductor.offset;

		offsetText.text = "Offset: " + Conductor.offset + "ms";
		bpmText.text = "BPM(FOR TEST): " + Conductor.bpm;

		if (controls.UI_UP_P)
			{
				changeSelection(-1);
			}
		if (controls.UI_DOWN_P)
			{
				changeSelection(1);
			}

		updateValue();
		
		if (controls.RESET)
		{
			FlxG.sound.music.stop();
			FlxG.resetState();
		}

		noteGrp.forEach(function(daNote:Note)
		{
			daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * 0.45);
			daNote.x = strumLine.x + 130;

			if (daNote.y < strumLine.y)
				{
					daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * 1.7);
				}
		});

		if (controls.BACK)
			{
				FlxG.sound.playMusic(Paths.music('Keeper'), 0);
				FlxG.sound.music.fadeIn(1, 0, FlxG.save.data.volume * FlxG.save.data.musicVolume);
				close();
			}
	}
}
