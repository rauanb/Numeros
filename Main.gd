extends Control

var level = 1

#var audio_directories = ["res://level1sounds/", "res://level2sounds/", "res://level3sounds/"]
var audio_list = []
var name_list = []

var correct_button = 0 # Inicitalize
var invert = 1 # invert sign to buttons label
var score = 0

func _ready():
#	get_audio_list()
	randomize()
	OS.set_current_screen(0)
#	audio_list = get_audio_list(level)
	audio_list = Persistent.level1
	audio_list.shuffle()
#	name_list = audio_list
	$CenterContainer/VBoxContainer/HBoxContainer2/Label.text = "Nível: " + str(level) + "\n" + "Pontos: " + str(score)
	new_challenge()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func new_challenge():
	$CenterContainer/VBoxContainer/HBoxContainer2/PlayButton.emit_signal("pressed")
	sort_audio()
	


func sort_audio():
	if audio_list.empty():
		level_up()
	else:
		var sorted_audio = audio_list.pop_front()
		sort_buttons(sorted_audio)
		$audioNum.set_stream(load(sorted_audio))
		$audioNum.play()
	
	
func sort_buttons(correct):
#	var buttons_list = $CenterContainer/VBoxContainer/HBoxContainer.get_children()
	var buttons_list = [$CenterContainer/VBoxContainer/HBoxContainer/Alt1Button/Label,
			$CenterContainer/VBoxContainer/HBoxContainer/Alt2Button/Label,
			$CenterContainer/VBoxContainer/HBoxContainer/Alt3Button/Label]
	for i in buttons_list.size():
		buttons_list[i].release_focus()
		buttons_list[i].add_color_override("font_color", Color(0, 0, 0, 1))
	var sorted_button = buttons_list.pop_at(randi() % buttons_list.size())
	correct_button = sorted_button
#	sorted_button.add_color_override("font_color", Color(1, 1, 1, 1))
	sorted_button.release_focus()
		
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
		i.set_modulate(Color(1, 1, 1, 1))
	
func check(button):
	if button == correct_button:
#		button.font_color(Color(0, 1, 0, 1))
		button.add_color_override("font_color", Color(0, 1, 0, 1))
		score += 1
		$audioScore.play()
		yield($audioScore,"finished")
		update_score()
	else:
		button.add_color_override("font_color", Color(1, 0, 0, 1))
		$audioError.play()
		yield($audioError,"finished")
	new_challenge()
	
func update_score():
	$CenterContainer/VBoxContainer/HBoxContainer2/Label.text = "Nível: " + str(level) + "\n" + "Pontos: " + str(score)
	
	if score % 10 == 0:
		level_up()
		$audioLevelUp.play()
		yield($audioLevelUp,"finished")
		
func level_up():
	if level == 1:
		audio_list = Persistent.level1
	if level == 2:
		audio_list = Persistent.level2
	elif level == 3:
		audio_list = Persistent.level3
	elif level == 4:
		audio_list = Persistent.level4
		
	sort_audio()
	
		

func get_audio_list():
	var files = []
	var dir = Directory.new()
	dir.open("res://level2sounds/")
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.ends_with(".import") && not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()
	for i in files.size():
		files[i] = "res://level1sounds/" + files[i]
	print(files)


func _on_PlayButton_button_up():
	$audioNum.play()


func _on_Alt1Button_button_up():
	check(get_node("CenterContainer/VBoxContainer/HBoxContainer/Alt1Button/Label"))


func _on_Alt2Button_button_up():
	check(get_node("CenterContainer/VBoxContainer/HBoxContainer/Alt2Button/Label"))
	


func _on_Alt3Button_button_up():
	check(get_node("CenterContainer/VBoxContainer/HBoxContainer/Alt3Button/Label"))
	


func _on_Button_pressed():
	get_tree().quit()
