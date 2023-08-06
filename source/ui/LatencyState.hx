package ui;

import flixel.util.FlxColor;
import flixel.ui.FlxButton;
import haxe.io.Path;
import ui.OptionsState;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import ui.AtlasText;

class LatencyState extends MusicBeatState
{
	var offsetText:FlxText;
	var bpmText:FlxText;
	var noteGrp:FlxTypedGroup<Note>;
	var strumLine:FlxSprite;
	var multiply:Float;
    var desctxt:FlxText;
    var checkBox:CheckboxThingie;
	var items:TextMenuList;
    var check:Bool;

	override function create()
	{
		FlxG.sound.music.fadeOut(FlxG.save.data.volume * FlxG.save.data.musicVolume, 0);
		FlxG.sound.music.stop();

		var menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
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

		buttonADD("Down", FlxG.width * 0.05, FlxG.height * 0.2, function() Conductor.offset -= 1 * multiply);
		buttonADD("Up", FlxG.width * 0.3, FlxG.height * 0.2, function() Conductor.offset += 1 * multiply);

        //bpm
		bpmText = new FlxText(FlxG.width * 0.1, FlxG.height * 0.4);
		bpmText.setFormat(Paths.font("vcr.ttf"), 30);
		bpmText.scrollFactor.set();
		add(bpmText);

		buttonADD("Down", FlxG.width * 0.05, FlxG.height * 0.4, function() Conductor.bpm -= 1 * multiply);
		buttonADD("Up", FlxG.width * 0.3 + 100, FlxG.height * 0.4, function() Conductor.bpm += 1 * multiply);

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

		desctxt = new FlxText(descBg.x, descBg.y + 4, FlxG.width, "RESET to reset\nPAUSE to play the test sound", 18);
		desctxt.setFormat(Paths.font("Funkin/Funkin.ttf"), 24, FlxColor.WHITE, CENTER);
		desctxt.borderColor = FlxColor.BLACK;
		desctxt.borderSize = 1;
		desctxt.borderStyle = OUTLINE;
		desctxt.scrollFactor.set();
		desctxt.screenCenter(X);
		add(desctxt);

		//checkBox things
		checkBox = new CheckboxThingie(FlxG.width * 0.5, FlxG.height * 0.65);
		checkBox.scrollFactor.set();
		add(checkBox);
		
		add(items = new TextMenuList());
		items.createItem(FlxG.width * 0.005, FlxG.height * 0.68, "multiply value", AtlasFont.Bold, function()
			{
				check = !check;
				checkBox.daValue = check;
			});

		//bpm used
		Conductor.changeBPM(120);

		super.create();
	}

	function soundsPlay() 
	{
		FlxG.sound.play(Paths.sound('soundTest'), FlxG.save.data.volume * FlxG.save.data.SFMVolume, true);
	}

	function buttonADD(string:String, x:Float = 0, y:Float = 0, ?onClick) 
	{
		var botton:FlxButton = new FlxButton(x, y , "", onClick);
		botton.loadGraphic(Paths.imageUI('Button_' + string));
		add(botton);
		botton.scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		offsetText.text = "Offset: " + Conductor.offset + "ms";
		bpmText.text = "BPM(FOR TEST): " + Conductor.bpm;
		Conductor.songPosition = FlxG.sound.music.time - Conductor.offset;

		if (check)
			multiply = 10;
        else
			multiply = 1;

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
				FlxG.sound.music.fadeIn(4, 0, 0.7 * FlxG.save.data.volume * FlxG.save.data.musicVolume);
				FlxG.switchState(new OptionsState());
			}
		
		super.update(elapsed);
	}
}
