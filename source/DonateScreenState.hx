package;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxAnimation;

class DonateScreenState extends MusicBeatState 
{
	var menuItem:FlxSprite;

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

		menuItem = new FlxSprite(0, 520);
		menuItem.frames = tex;
		menuItem.animation.addByPrefix('donate idle', "donate idle", 24);
		menuItem.animation.addByPrefix('donate selected', "donate selected", 24);
		menuItem.animation.addByPrefix('kickstarter idle', "kickstarter idle", 24);
        menuItem.animation.addByPrefix('kickstarter selected', "kickstarter selected", 24);
        if (VideoState.seenVideo)
		    menuItem.animation.play('kickstarter idle');
        else
            menuItem.animation.play('donate idle');

		menuItem.updateHitbox();
		menuItem.screenCenter(X);
		add(menuItem);
		menuItem.antialiasing = true;

	    var txt:FlxText = new FlxText(0, 0, 0, "Give a lil bit back");
		txt.setFormat(Paths.font("Font.ttf") , 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txt.updateHitbox();
		txt.screenCenter();
		add(txt);

		txt.text = txt.text.toUpperCase();

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
		FlxG.sound.music.volume = FlxG.save.data.volume * FlxG.save.data.musicVolume;
		
		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (controls.ACCEPT)
		{
			#if linux
            if (VideoState.seenVideo)
				{
					menuItem.animation.play('kickstarter selected');
					Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
				}
            else
				{
					menuItem.animation.play('donate selected');
					Sys.command('/usr/bin/xdg-open', [
						"https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game",
						"&"]);
				}
			#else
            if (VideoState.seenVideo)
				{
					menuItem.animation.play('kickstarter selected');
					FlxG.openURL('https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game');
				}
            else
				{
					menuItem.animation.play('donate selected');
					FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
				}
			#end
		}

		if (menuItem.animation.finished && menuItem.animation.curAnim.name == 'donate selected' || menuItem.animation.finished && menuItem.animation.curAnim.name == 'kickstarter selected')
			{
				if (VideoState.seenVideo)
					menuItem.animation.play('kickstarter idle');
				else
					menuItem.animation.play('donate idle');
			}

		super.update(elapsed);
	}
}

