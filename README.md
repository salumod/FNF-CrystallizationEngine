                                               crystallization engine
This is an engine for Friday night funkin'
the engine combined with many pull requests (original page)
Build instructions!

Installing the Required Programs
First, you need to install Haxe and HaxeFlixel. I'm too lazy to write and keep updated with that setup (which is pretty simple).

Install Haxe 4.1.5 (Download 4.1.5 instead of 4.2.0 because 4.2.0 is broken and is not working with gits properly...)
Install HaxeFlixel after downloading Haxe
Other installations you'd need are the additional libraries, a fully updated list will be in in the project root. Currently, these are all of the things you need to install:Project.xml

 flixel
 flixel-addons
 flixel-ui
 hscript
 newgrounds

So for each of those type so shit like haxelib install [library]haxelib install newgrounds

You'll also need to install a couple things that involve Gits. To do this, you need to do a few things first.

Download git-scm. Works for Windows, Mac, and Linux, just select your build.
Follow instructions to install the application properly.
Run to install Polymod.haxelib git polymod https://github.com/larsiusprime/polymod.git
Run to install Discord RPC.haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
You should have everything ready for compiling the game! Follow the guide below to continue!

At the moment, you can optionally fix the transition bug in songs with zoomed-out cameras.

Run in the terminal/command-prompt.haxelib git flixel-addons https://github.com/HaxeFlixel/flixel-addons

Compiling game!

NOTE: If you see any messages relating to deprecated packages, ignore them. They're just warnings that don't affect compiling

Once you have all those installed, it's pretty easy to compile the game. You just need to run in the root of the project to build and run the HTML5 version. (command prompt navigation guide can be found here: https://ninjamuffin99.newgrounds.com/news/post/1090480) To run it from your desktop (Windows, Mac, Linux) it can be a bit more involved. For Linux, you only need to open a terminal in the project directory and run and then run the executable file in export/release/linux/bin. For Windows, you need to install Visual Studio Community 2019. While installing VSC, don't click on any of the options to install workloads. Instead, go to the individual components tab and choose the following:lime test html5 -debuglime test linux -debug

MSVC v142 - VS 2019 C++ x64/x86 build tools
Windows SDK (10.0.17763.0)
Only executable files can be compiled
