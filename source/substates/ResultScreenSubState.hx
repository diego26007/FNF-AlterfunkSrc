package substates;

import backend.WeekData;
import backend.Highscore;
import backend.Song;

import flixel.addons.transition.FlxTransitionableState;

import flixel.util.FlxStringUtil;

import states.StoryMenuState;
import states.FreeplayState;
import options.OptionsState;
import backend.Rating;

class ResultScreenSubState extends MusicBeatSubstate{

	var pauseMusic:FlxSound;
	var practiceText:FlxText;
	var ratingList:Array<String> = ['Sicks: ', 'Goods: ', 'Bads: ', 'Shits: '];
	var endMusic:FlxSound;
	
	var ratings:FlxTypedGroup<FlxText>;
	
	public static var songName:String = '';
	
	public var endSong = controls.ACCEPT;
	
	public function new(x:Float, y:Float, score:Int, misses:Int){
		super();
		
		endMusic = new FlxSound();
		if(songName != null) {
			endMusic.loadEmbedded(Paths.music(songName), true, true);
		} else if (songName != 'None') {
			endMusic.loadEmbedded(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)), true, true);
		}
		endMusic.volume = 0;
		endMusic.play(false, FlxG.random.int(0, Std.int(endMusic.length / 2)));
		
		FlxG.sound.list.add(endMusic);
		
		add(ratings);
		
		/*for (i in 0...ratingList.length) {
			var item:FlxText = new FlxText(0, 0, 0, ratingList[i] + PlayState.instance.ratingsData[i].hits, 20);
			item.setFormat(Paths.font("vcr.ttf"), 20);
			item.x = 20;
			item.y = 171 + 20 * i;
			item.scrollFactor.set();
			ratings.insert(i, item);
			item.updateHitbox();
		}*/
		
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);
		trace("bg added");
		
		var levelName:FlxText = new FlxText(20, 15, 0, PlayState.SONG.song, 54);
		levelName.scrollFactor.set();
		levelName.setFormat(Paths.font("vcr.ttf"), 54);
		levelName.updateHitbox();
		add(levelName);
		trace("level name added");

		var levelDifficulty:FlxText = new FlxText(20, 15 + 54, 0, Difficulty.getString().toUpperCase(), 32);
		levelDifficulty.setFormat(Paths.font("vcr.ttf"), 32);
		levelDifficulty.scrollFactor.set();
		levelDifficulty.updateHitbox();
		add(levelDifficulty);
		trace("level difficulty added");
		
		var songScore:FlxText = new FlxText(20, 69 + 32 + 10, 0, 'Score: ${PlayState.instance.songScore}', 25);
		songScore.setFormat(Paths.font("vcr.ttf"), 25);
		songScore.scrollFactor.set();
		songScore.updateHitbox();
		add(songScore);
		trace("song score added");
		
		var songMisses:FlxText = new FlxText(20, 111 + 25, 0, 'Misses: ${PlayState.instance.songMisses}', 25);
		songMisses.setFormat(Paths.font("vcr.ttf"), 25);
		songMisses.scrollFactor.set();
		songMisses.updateHitbox();
		add(songMisses);
		trace("song misses added");
		
		levelDifficulty.alpha = 0;
		levelName.alpha = 0;
		songScore.alpha = 0;
		
		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelName, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(songScore, {alpha: 1, y: songScore.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.85});
		FlxTween.tween(songMisses, {alpha: 1, y: songMisses.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.85});
	}
	override function update(elapsed:Float){
		if (endMusic.volume < 0.5){
			endMusic.volume += 0.01 * elapsed;
		}

		super.update(elapsed);
		
		endSong = controls.ACCEPT;
		
		if (endSong){
			PlayState.instance.notes.clear();
			PlayState.instance.unspawnNotes = [];
			PlayState.instance.finishSong(true);
			PlayState.instance.endSong();
			close();
		}
		
		
	}
}