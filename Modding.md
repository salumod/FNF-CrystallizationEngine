# RIGHT NOW THE MODS FOLDER DOES NOT WORK ENTIRELY JUST YET!!!
## THIS IS WORK IN PROGRESS!!!

# QUICK AND DIRTY MOD GUIDE

With the pb updating,  I added a slightly better mod support backend.

It's POLYMOD, which is made by Lars Doucet: https://github.com/larsiusprime/polymod
at the source code page:
-                   "songs" => "songs",
-                   "shared" => "shared",
-                   "fonts" => "fonts", 
-					"data" => "data",
-					"images" => "images",
-					"music" => "music",
-					"sounds" => "sounds",
-					"tutorial" => "tutorial",
-					"week1" => "week1",
-					"week2" => "week2",
-					"week3" => "week3",
-					"week4" => "week4",
-					"week5" => "week5",
-					"week6" => "week6",
-					"week7" => "week7",
-					"week8" => "week8"

If every mod want to be in game.You have to make a file for polymod to loading form your PC.The name is _polymod_meta.json
Sample file content:

{
	"title":"name",
	"description":"description",
	"homepage": "homepage",
	"contributors": [
		{
			"name": "who",
			"role": "what"
		}
	],
	"api_version":"0.0.1",
	"mod_version":"0.0.1",
	"license":"unknown"
}

so you can start now!
