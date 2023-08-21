package option;

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
	var offsetText:FlxText;
	var bpmText:FlxText;
	var noteGrp:FlxTypedGroup<Note>;
	var strumLine:FlxSprite;
	var multiply:Float;
    var desctxt:FlxText;
	var botton_OFFSET:UIButton;
	var botton_BPM:UIButton;
	var items:TextMenuList;

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

		botton_OFFSET = new UIButton(FlxG.width * 0.05, FlxG.height * 0.2, FlxG.width * 0.25, function() Conductor.offset += 1 * multiply, function() Conductor.offset -= 1 * multiply);
		add(botton_OFFSET);

		botton_BPM = new UIButton(FlxG.width * 0.05, FlxG.height * 0.4, FlxG.width * 0.25 + 100, function() Conductor.bpm += 1 * multiply, function() Conductor.bpm -= 1 * multiply);
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

		desctxt = new FlxText(descBg.x, descBg.y + 4, FlxG.width, "Hold ACCEPT to multiply value\nRESET to reset\nPAUSE to play the test sound", 18);
		#if !debug
		desctxt.text = "RESET to reset\nPAUSE to play the test sound";
		#end
		desctxt.setFormat(Paths.font("Funkin/Funkin.ttf"), 24, FlxColor.WHITE, CENTER);
		desctxt.borderColor = FlxColor.BLACK;
		desctxt.borderSize = 1;
		desctxt.borderStyle = OUTLINE;
		desctxt.scrollFactor.set();
		desctxt.screenCenter(X);
		add(desctxt);

		add(items = new TextMenuList());

		//bpm used
		Conductor.changeBPM(120);

		super.create();
	}

	function soundsPlay() 
	{
		FlxG.sound.playMusic(Paths.music('soundTest'), FlxG.save.data.volume * FlxG.save.data.musicVolume, true);
	}

	override function update(elapsed:Float)
	{
		offsetText.text = "Offset: " + Conductor.offset + "ms";
		bpmText.text = "BPM(FOR TEST): " + Conductor.bpm;
		Conductor.songPosition = FlxG.sound.music.time - Conductor.offset;

		// if (controls.ACCEPT)
		// 	multiply = 10;
        // else
		// 	multiply = 1;

		if (controls.PAUSE)
			soundsPlay();

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
				daNote.kill();
		});

		if (controls.BACK)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
				FlxG.sound.music.fadeIn(1, 0, FlxG.save.data.volume * FlxG.save.data.musicVolume);
				close();
			}

		super.update(elapsed);
	}
}
