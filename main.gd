extends Node2D

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

var entries = ["these","are","tests","and","examples"]


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	
	

func _fixed_process(delta):
	
	if program_state == "main":
		main_frame(delta)
	elif program_state == "settings":
		pass
	elif program_state == "list setup":
		pass
	elif program_state == "new entry":
		new_entry()
	
	


func new_entry():
	if get_node("new entry frame/new entry input").has_focus() and ( Input.is_key_pressed(KEY_RETURN) or Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_KP_ENTER) ):
		_on_confirm_button_pressed()
		
		

func main_frame(delta):
	
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
		
		if max_shuffle_number <= 1:
			shuffle_state = "done"
			get_node("overlay frame").show()
			get_node("overlay frame/setup list warning panel").show()
			get_node("overlay frame/setup list warning panel/setup list warning confirm").grab_focus()
		else:
			print("max: "+str(max_shuffle_number))
			
			if hold_time > 100:
				hold_time = 100
			
			#find the difference between 100 & hold time
			var inversed_hold_time = 100 - hold_time
			
			
			#the greater the hold time the less resistance
			resistance = inversed_hold_time *0.005
			
			
			shuffle_state = "active"
	
	
	
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
			print("next number: "+str(next_number))
			
			
	
	#reverses direction whe maxed and vice versa
	meter_direction()
	
	
	#display the next number
	get_node("main frame/number result").set_text(str(round(next_number)))
	#display the next entry
	#print(get_node("list setup frame/entry list").get_item_text(int(round(next_number))))
	get_node("main frame/result").set_text( get_node("list setup frame/entry list").get_item_text(int(round(next_number))) )#(entries[next_number-1])
	
	
	
	
	
	
	#update power meter display
	if shuffle_state == "pressed":
		
		get_node("main frame/power meter").set_value(hold_time)
		
		#If at full power, change color to red, otherwise keep it green
		if get_node("main frame/power meter").get_value() >= 100:
			
			#print(get_node_and_resource("res://main.tscn::5"))
			#print(get_node_and_resource("main frame/power meter"))
			#print(ResourceInteractiveLoader.get_resource("res://main.tscn::5"))
			#var new_color = Color.new()
			#new_color = 
			#get_node("main frame/power meter").add_color_override("max",Color(128,12,52))#.set_bg_color( Color(255,255,0) )  )   )
			
			#I give up for now
			pass
			
		else:
			pass
	
	
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
	if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT:
		if event.pressed:
			hold_time = 0
			shuffle_state = "pressed"
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
	if get_node("main frame/trim notice").is_hidden():
		get_node("main frame/trim notice").show()
		get_node("main frame/cutout").show()
	else:
		get_node("main frame/trim notice").hide()
		get_node("main frame/cutout").hide()
	


func _on_checkbox_name_pressed():
	if get_node("main frame/result").is_hidden():
		get_node("main frame/result").show()
	else:
		get_node("main frame/result").hide()


func _on_checkbox_number_pressed():
	if get_node("main frame/number result").is_hidden():
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
