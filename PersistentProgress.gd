extends Node 

signal save

class Progress:
	var highscore = {}
	func to_json() -> String: 
		
		var entries = {}
		for key in highscore.keys(): 
			entries[key] = highscore[key].to_json()
		
		var dict = {
			"highscore" : JSON.print(entries)
		}
		return JSON.print(dict)
		
	func from_json(json): 
		var parse_result = JSON.parse(json)
		if parse_result.error == OK: 
			var result = parse_result.result
			for key in result.keys(): 
				highscore[key] = Stats.new().from_json(result[key])
			return self
		else:
			 print(parse_result.error)
			
class Wave_Stats: 

	var wave_index: int
	var wave_name: String
	var episode_name: String 
	var wave_score: int = 0
	var wave_time: float = 0.0
	var wave_attempts: int = 0
	
	func to_json() -> String: 
		var dict = {
			"wave_index": wave_index,
			"wave_name": wave_name,
			"episode_name": episode_name,
			"wave_score": wave_score,
			"wave_time": wave_time,
			"wave_attempts": wave_attempts,
		}
		return JSON.print(dict)
		
	func from_json(json): 
		var parse_result = JSON.parse(json)
		if parse_result.error == OK: 
			var result = parse_result.result
			wave_index = result["wave_index"]
			wave_name = result["wave_name"]
			episode_name = result["episode_name"]
			wave_score = result["wave_score"]
			wave_time = result["wave_time"]
			wave_attempts = result["wave_attempts"]
			return self
		else:
			 print(parse_result.error)
			
class Stats: 

	var episode_name: String 
	var score: int = 0
	var total_play_time : float = 0.0
	var balls_lost: int = 0
	var wave_stats = {}

	func to_json() -> String: 
		var wave_stats_json = {}
		for key in wave_stats.keys(): 
			var wave_stat = wave_stats[key]
			wave_stats_json[key] = wave_stat.to_json()

		var dict = {
			"episode_name": episode_name,
			"score": score,
			"total_play_time" : total_play_time,
			"balls_lost": balls_lost, 
			"wave_stats" : wave_stats_json
		}
		return JSON.print(dict)
	
	func from_json(json): 
		var parse_result = JSON.parse(json)
		if parse_result.error == OK: 
			var result = parse_result.result
			episode_name = result["episode_name"]
			score = result["score"]
			total_play_time = result["total_play_time"]
			balls_lost = result["balls_lost"]
			var wave_stats_json = result["wave_stats"]
			for key in wave_stats_json.keys(): 
				wave_stats[key] = Wave_Stats.new().from_json(wave_stats_json[key])
			return self
		else:
			 print(parse_result.error)

var progress

func _ready():
	var _save = connect("save", self, "on_save") 
	progress = Progress.new()
	on_load() 

func on_save(): 
	if progress == null:
		print("Cannot save empty progress!")
		return
	var save_game = File.new()
	save_game.open("user://savegame.json", File.WRITE)
	print("Saving to ",save_game.get_path_absolute())
	save_game.store_string(progress.to_json()) 
	save_game.close() 

func on_load(): 
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.json"): 
		return
	save_game.open("user://savegame.json", File.READ)
	print("Loading from ",save_game.get_path_absolute())
	var parse_result = JSON.parse(save_game.get_line())
	if parse_result.error == OK: 
		var result = parse_result.result
		progress = Progress.new().from_json(result["highscore"])

	else:
		 print(parse_result.error)
	save_game.close()
	
func on_reset(): 
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.json"): 
		return
	var dir = Directory.new()
	dir.remove("user://savegame.json")

func update_score_total(episode): 
	progress.highscore[episode].score = 0
	progress.highscore[episode].total_play_time = 0.0
	progress.highscore[episode].balls_lost = 0
	var wave_stats : Dictionary = progress.highscore[episode].wave_stats
	for key in wave_stats.keys(): 
		progress.highscore[episode].score += wave_stats[key].wave_score
		progress.highscore[episode].total_play_time += wave_stats[key].wave_time
		progress.highscore[episode].balls_lost += wave_stats[key].wave_attempts


func add_wave_stat(wave_index, wave_name, episode_name, wave_score, wave_time, wave_attempts): 
	var wave_stat = Wave_Stats.new()
	wave_stat.wave_index = wave_index
	wave_stat.wave_name = wave_name
	wave_stat.episode_name = episode_name
	wave_stat.wave_score = wave_score
	wave_stat.wave_time = wave_time
	wave_stat.wave_attempts = wave_attempts
	
	if !progress.highscore.has(episode_name):
		var episode_stats = Stats.new()
		episode_stats.episode_name = episode_name
		print(episode_stats)
		progress.highscore[episode_name] = episode_stats
	
	progress.highscore[episode_name].wave_stats[str(wave_index)] = wave_stat
	update_score_total(episode_name)
	on_save()
	
