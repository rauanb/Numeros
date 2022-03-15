extends Control

var level = 1

var audio_directories = ["res://Level1Sounds/", "res://Level2Sounds/", "res://Level3Sounds/"]
var audio_list = []
var name_list = []

var correct_button = 0 # Inicitalize
var invert = 1 # invert sign to buttons label
var score = 0

func _ready():
	randomize()
	OS.set_current_screen(1)
	audio_list = get_audio_list(level)
	name_list = audio_list
	$CenterContainer/VBoxContainer/HBoxContainer2/Label.text = "Nível: " + str(level) + "\n" + "Pontos: " + str(score)
	new_challenge()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func new_challenge():
	sort_audio()
	


func sort_audio():
	if audio_list.empty():
		level_up(0)
	else:
		var sorted_audio = audio_list.pop_at(randi() % audio_list.size())
		sort_buttons(sorted_audio)
		$audioNum.set_stream(load(audio_directories[level-1] + sorted_audio))
		$audioNum.play()
	
	
func sort_buttons(correct):
	var buttons_list = $CenterContainer/VBoxContainer/HBoxContainer.get_children()
	var sorted_button = buttons_list.pop_at(randi() % buttons_list.size())
	correct_button = sorted_button
	
	
	
#	format label of button based on the sorted audio
	correct.erase(0,correct.find("-")+1)
	correct.erase(correct.find("."),correct.length())
	sorted_button.text = str(correct)
	
	for i in buttons_list:
		invert *= -1
		var aux = randi() % 15
		var txt = max(int(correct) + aux*invert,1)
		if txt == int(correct):
			txt += randi() % 3 + 1
		i.text = str(txt)
	
func check(button):
	if button == correct_button:
		score += 1
		update_score()
	new_challenge()
	
func update_score():
	$CenterContainer/VBoxContainer/HBoxContainer2/Label.text = "Nível: " + str(level) + "\n" + "Pontos: " + str(score)
	
	if score % 10 == 0:
		level_up(1)
		
func level_up(incr):
	level += incr
	audio_list = get_audio_list(level)
	sort_audio()
	
		

func get_audio_list(level):
	var files = []
	var dir = Directory.new()
	dir.open(audio_directories[level-1])
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.ends_with(".import") && not file.begins_with("."):
			files.append(file)
	
	dir.list_dir_end()
	return files


func _on_PlayButton_button_up():
	$audioNum.play()


func _on_Alt1Button_button_up():
	check(get_node("CenterContainer/VBoxContainer/HBoxContainer/Alt1Button"))


func _on_Alt2Button_button_up():
	check(get_node("CenterContainer/VBoxContainer/HBoxContainer/Alt2Button"))
	


func _on_Alt3Button_button_up():
	check(get_node("CenterContainer/VBoxContainer/HBoxContainer/Alt3Button"))
	
