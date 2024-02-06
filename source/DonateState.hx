package;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.FlxSprite;

class DonateState extends MusicBeatState 
{
	var blurb:Array<String> = [
		"your donations help us",
		"develop the funkiest game",
		"this side of the internet",
		"",
		"support the funky cause",
		"give a lil bit back"
	];

	override function create()
	{
        FlxG.sound.playMusic(Paths.music('give a little bit back'), FlxG.save.data.volume * FlxG.save.data.musicVolume, true);

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.color = 0xFF8F8F; // this was supposed to be red but it came out orange. oh well
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		var tex = Paths.getSparrowAtlas('main_menu');

		var menuItem:FlxSprite = new FlxSprite(0, 520);
		menuItem.frames = tex;
		menuItem.animation.addByPrefix('selected', "kickstarter selected", 24);
		menuItem.animation.play('selected');
		menuItem.updateHitbox();
		menuItem.screenCenter(X);
		add(menuItem);
		menuItem.antialiasing = true;

		var textGroup:FlxTypedGroup<Alphabet> = new FlxTypedGroup<Alphabet>();
		add(textGroup);
		for (i in 0...blurb.length)
		{
			var money:Alphabet = new Alphabet(0, 0, blurb[i], true, false);
			money.screenCenter(X);
			money.y += (i * 80) + 120;
			textGroup.add(money);
		}

		#if html5
		var someText:FlxText = new FlxText(0, 684, 0, "(opens the itch.io page in a new tab)");
		#else
		var someText:FlxText = new FlxText(0, 684, 0, "(opens the itch.io page in a browser window)");
		#end
		someText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		someText.updateHitbox();
		someText.screenCenter(X);
		add(someText);

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (controls.ACCEPT)
		{
			#if linux
			Sys.command('/usr/bin/xdg-open', ["https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game", "&"]);
			#else
			FlxG.openURL('https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game');
			#end
		}

		super.update(elapsed);
	}
}