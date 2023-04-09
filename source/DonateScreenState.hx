package;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.FlxSprite;

class DonateScreenState extends MusicBeatState {
	var blurb:Array<String> = [
		"your donations help us",
		"",
		"develop the funkiest game",
		"",
		"this side of the internet",
		"",
		"support the funky cause",
		"give a lil bit back"
	];

	override function create()
	{
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

        FlxG.sound.playMusic(Paths.music('give a little bit back'));

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
		menuItem.animation.addByPrefix('selected', "donate idle", 24);
        menuItem.animation.addByPrefix('kickstarter selected', "kickstarter idle", 24);
        if (VideoState.seenVideo)
		    menuItem.animation.play('kickstarter selected');
        else
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
			money.y += (i * 60) + 10;
			textGroup.add(money);
		}

		#if web
		var someText:FlxText = new FlxText(0, 684, 0, "(opens the donate page in a new tab)");
		#else
		var someText:FlxText = new FlxText(0, 684, 0, "(opens the donate page in a browser window)");
		#end
		someText.setFormat("PhantomMuff 1.5", 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
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
            if (VideoState.seenVideo)
			    Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
            else
		        Sys.command('/usr/bin/xdg-open', [
			    "https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game",
			    "&"
		    ]);
			#else
            if (VideoState.seenVideo)
                FlxG.openURL('https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game');
            else
			    FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
			#end
		}

		super.update(elapsed);
	}
}

