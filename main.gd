extends Node2D

var version = "0.3"
var version_name = "Improved"

var program_state = "main"

var shuffle_state = "done"

var hold_time = 0
var hold_reverse = false

var acceleration = -17
var resistance = 0.08
var velocity = 100


var next_number = 0
var display_number = 0
var max_shuffle_number = 0

var key_enter_held = false
var key_delete_held = false

var entries = ["these","are","tests","and","examples"]
var selection_for_deletion = []
var last_selected_entry_before_deletion = 0


func _ready():
	#update the about header with the version
	get_node("overlay frame/about panel/about header").set_text("How to use:\n1. Access the list setup by pressing the bottom-right most button.\n2. Add items as desired to the list that you want shuffled.\n3. Hold the shuffle button for more power, then let go and it will shuffle the results!\n\nAbout:\nVersion "+version+",  Created by AGamerAaron of \"VAR Team\".\nMIT licensed. Feel free to contribute on Github!")
	
	

func _physics_process(delta):
	#print(program_state)
	if program_state == "main":
		main_frame(delta)
		
	elif program_state == "settings":
		update_background_color()
	elif program_state == "list setup":
		if get_node("overlay frame").visible == false and get_node("new entry frame").visible == false:
			keep_focus_on_list()
			list_setup_keyboard_shortcuts()
	elif program_state == "new entry":
		new_entry()
	
	


func list_setup_keyboard_shortcuts():
	if Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_KP_ENTER) or Input.is_key_pressed(KEY_PLUS):
		if key_enter_held == false:
			get_node("list setup frame/add entry").emit_signal("pressed")
			key_enter_held = true
			
	else:
		key_enter_held = false
	
	if Input.is_key_pressed(KEY_DELETE) or Input.is_key_pressed(KEY_BACKSPACE) or Input.is_key_pressed(KEY_MINUS):
		if key_delete_held == false:
			selection_for_deletion = get_node("list setup frame/entry list").get_selected_items()
			last_selected_entry_before_deletion = selection_for_deletion[0]
			print("to be deleted from list: "+str(selection_for_deletion))
			var current_deletion = selection_for_deletion.size()-1
			#Have a confirmation pop-up
			# IMPORTANT! Work backwards from the bottom because the list shrinks as things are deleted!!
			while current_deletion >= 0:
				get_node("list setup frame/entry list").remove_item(selection_for_deletion[current_deletion])
				print("removed: "+str(selection_for_deletion[current_deletion]))
				current_deletion = current_deletion - 1
				
			key_delete_held = true
			get_node("list setup frame/entry list").grab_focus()
			get_node("list setup frame/entry list").select(last_selected_entry_before_deletion)
	else:
		key_delete_held = false
		
	

func keep_focus_on_list():
	if get_node("list setup frame/entry list").has_focus() == false:
		get_node("list setup frame/entry list").grab_focus()
		
		if get_node("list setup frame/entry list").is_selected(0) == false:
			get_node("list setup frame/entry list").select(0)
	#has focus but after deletion does not highlight anything

func update_background_color():
	get_node("main frame").set_frame_color(get_node("settings frame/background color picker").get_pick_color())

func new_entry():
	if Input.is_key_pressed(KEY_ENTER) == false and Input.is_key_pressed(KEY_KP_ENTER) == false:
		key_enter_held = false
	elif get_node("new entry frame/new entry input").has_focus() and (Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_KP_ENTER)) and key_enter_held == false and get_node("new entry frame/new entry input").text != "":
		key_enter_held = true
		_on_confirm_button_pressed()
		
		get_node("list setup frame/entry list").grab_focus()
		get_node("list setup frame/entry list").select(get_node("list setup frame/entry list").get_item_count()-1)
		
		
		

func main_frame(delta):
	
	
	#print(shuffle_state)
	
	if shuffle_state == "initialize":
		
		#reinitialize all involved variables
		hold_reverse = false
		acceleration = -17
		resistance = 0.08
		velocity = 100
		next_number = 0
		display_number = 0
		max_shuffle_number = 0
		
		
		#size of the entries list
		max_shuffle_number = get_node("list setup frame/entry list").get_item_count()#entries.size()
		
		if max_shuffle_number <= 0:
			shuffle_state = "done"
			get_node("overlay frame").show()
			get_node("overlay frame/setup list warning panel").show()
			get_node("overlay frame/setup list warning panel/setup list warning confirm").grab_focus()
		else:
			print("Maximum number based on the amount of entries: "+str(max_shuffle_number))
			
			if hold_time > 100:
				hold_time = 100
			print("hold time: "+str(hold_time))
			#find the difference between the max power & hold time
			var inversed_hold_time = 110 - hold_time
			
			
			#the greater the hold time the less resistance
			resistance = (inversed_hold_time *0.005) - 0.08
			if resistance <= 0.01:
				resistance = 0.01
			
			shuffle_state = "active"
	
	if shuffle_state == "pressed":
		#reverses direction when maxed and vice versa
		meter_direction()
		
		#print(str(round(next_number)))
	
	#Shuffling active loop
	if shuffle_state == "active":
		
		
		if acceleration >= 0:
			shuffle_state = "done"
			#shuffle is over, highlight result in orange
			#get_node("main frame/result").set_opacity(0.1)
		else:
			
			acceleration += resistance
			velocity += acceleration * delta
			
			#loops around :)
			if velocity < 0:
				velocity = 100
			
			#keep subtracting until there's only a remainder left
			#that remainder will be the resulting number
			next_number = (velocity - (max_shuffle_number-1))
			while next_number >= (max_shuffle_number-1):
				#print("meep: "+str(next_number))
				next_number = next_number - (max_shuffle_number-1)
			#print("next number: "+str(round(next_number)))
			
		
		#display the next number
		get_node("main frame/number result").set_text(str(round(abs(next_number))))
		#display the next entry
		#print(get_node("list setup frame/entry list").get_item_text(int(round(next_number))))
		get_node("main frame/result").set_text(get_node("list setup frame/entry list").get_item_text(int(round(abs(next_number)))) )#(entries[next_number-1])
		
		
	
	
	
	
	
	
	
	
	
	
	
	#update power meter display
	if shuffle_state == "pressed":
		if entries.size() > 0:
			
			
			#If at full power, change color to red, otherwise keep it green
			#if get_node("main frame/power meter").value >= 100: #get_node("main frame/power meter").get_value() >= 100:
				
				#print(get_node_and_resource("res://main.tscn::5"))
				#print(get_node_and_resource("main frame/power meter"))
				#print(ResourceInteractiveLoader.get_resource("res://main.tscn::5"))
				#var new_color = Color.new()
				#new_color = 
				#get_node("main frame/power meter").add_color_override("max",Color(128,12,52))#.set_bg_color( Color(255,255,0) )  )   )
				
				#I give up for now
			#	pass
			#else:
				#hold_time = hold_time + 1
			get_node("main frame/power meter").value = hold_time #get_node("main frame/power meter").set_value(hold_time)
			
		else:
			#setup_list_warning_active = true
			#get_node("overlay frame").show()
			#get_node("overlay frame/setup list warning panel").show()
			print("Error! No entries!")
			
	
	
	#update all debug displays
	update_debug()



func meter_direction():
	if shuffle_state == "pressed":
		if hold_reverse == false:
			hold_time = hold_time + 2
		if hold_reverse == true:
			hold_time = hold_time - 5
	
	if hold_time > 100:
		hold_reverse = true
	elif hold_time <= 0:
		hold_reverse = false

func update_debug():
	get_node("debug info/max shuffle number display").set_text(str(max_shuffle_number))
	get_node("debug info/next number display").set_text(str(next_number))
	get_node("debug info/acceleration display").set_text(str(acceleration))
	get_node("debug info/resistance display").set_text(str(resistance))
	get_node("debug info/velocity display").set_text(str(velocity))
	get_node("debug info/shuffle state display").set_text(shuffle_state)
	
	get_node("debug info/acceleration meter").set_value((acceleration * -1)* 5)
	get_node("debug info/velocity meter").set_value(velocity)
	



#shuffle button signals. The longer you hold, the higher the hold_time gets. 
# This determines how long the shuffling will go on for.


func _on_shuffle_button_input_event( event ):
	#print("event: "+str(event))
	if event is InputEventMouseButton:
		
		if event.get_button_index() == BUTTON_LEFT:
			if event.is_pressed():
				hold_time = 0
				shuffle_state = "pressed"
				print("hold time: "+str(hold_time))
			else: #left button released
				
				#execute shuffle
				shuffle_state = "initialize"
				#reset hold so hold time doesn't keep accumulating



#Signals for accessing other menus
func _on_list_setup_pressed():
	program_state = "list setup"
	get_node("list setup frame").show()


func _on_settings_pressed():
	program_state = "settings"
	get_node("settings frame").show()




#Signals for closing other menus

func _on_list_setup_go_back_pressed():
	program_state = "main"
	get_node("list setup frame").hide()

func _on_settings_go_back_pressed():
	program_state = "main"
	get_node("settings frame").hide()







func _on_add_entry_pressed():
	get_node("new entry frame").show()
	get_node("new entry frame/new entry input").grab_focus()
	program_state = "new entry"



func _on_confirm_button_pressed():
	get_node("list setup frame/entry list").add_item(get_node("new entry frame/new entry input").get_text())
	get_node("new entry frame/new entry input").clear()
	get_node("new entry frame").hide()
	program_state = "list setup"


func _on_cancel_button_pressed():
	get_node("new entry frame/new entry input").clear()
	get_node("new entry frame").hide()
	program_state = "list setup"


func _on_setup_list_warning_confirm_pressed():
	get_node("overlay frame").hide()
	get_node("overlay frame/setup list warning panel").hide()




func _on_checkbox_crop_pressed():
	if get_node("main frame/trim notice").visible == false:
		get_node("main frame/trim notice").show()
		get_node("main frame/cutout").show()
	else:
		get_node("main frame/trim notice").hide()
		get_node("main frame/cutout").hide()
	


func _on_checkbox_name_pressed():
	if get_node("settings frame/checkbox name").pressed == true:
	#if get_node("main frame/result").visible == false:
		get_node("main frame/result").show()
	else:
		get_node("main frame/result").hide()


func _on_checkbox_number_pressed():
	if get_node("settings frame/checkbox number").pressed == true:
	#if get_node("main frame/number result").visible == false:
		get_node("main frame/number result").show()
	else:
		get_node("main frame/number result").hide()


func _on_remove_entry_pressed():
	get_node("list setup frame/entry list").remove_item(get_node("list setup frame/entry list").get_selected_items()[0])


func _on_about_pressed():
	get_node("overlay frame").show()
	get_node("overlay frame/about panel").show()
	


func _on_go_back_pressed():
	get_node("overlay frame").hide()
	get_node("overlay frame/about panel").hide()
