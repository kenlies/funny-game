extends Control

var jokes = [
"What do you call axolotl when it's doing taxes?\n- Taxolotl",
"What do you call axolotl when it small?\n- Axolitl",
"What do you call axolotl when it's a hacker?\n- Haxolotl",
"What do you call axolotil when it's using too much deodorant?\n- AXElotl",
"What do you call owl that is bald?\n- Bowld",
"What do you call penguin that is holding a pen?\n- PENguin",
"What do you call a seagull who's a girl?\n- Shegull",
"How do you make cupcakes?\n- First you make cake and then put it in a cup!",
"What do you call a bumblebee that is an exercise equipment?\n- Dumbellbee",
"What do you call a bumblebee that is sleeping?\n- Slumberbee",
"What do you call a bumblebee that is a rabbit character from Disney motion picture \"Bambi\"?\n- Thumperbee",
"What do you call a bumblebee that is a log?\n- Lumberbee",
"What do you call a bumblebee that mgdmmgdf mgmgd?\n- Mumblebee",
"What do you call a hobbit that is not a hobbit?\n- Nobbit",
"What do you call a hobbit that is overweight?\n- Fabbit",
"What do you call a hobbit that is a thief?\n- Robbit",
"What do you call water when it is a dad?\n- Fater",
"What is a game developer's favorite soda drink?\n- Sprite",
"What do you call a koala when it is a snake?\n- Boala",
"What do you call a tapiir when it is a multiplayer online battle arena game?\n- DotApiir",
"What do you call an elephant that is a x86 architechture central proceccssing unit?\n- Intelephant",
"What do you call a mouse that is taking a break?\n- A pause",
"What do you call a window that came in second?\n- Losedow",
"What do you call a door that has no money?\n- A poor",
"What does the atmosphere use for its hair?\n- Air conditioner",
"What do you call an octopus that is a doctor?\n- Doctopus",
"What do you call an octopus that is suspicious?\n- Octosus",
"What do you call a horse, when it is a method used in telecommunication to encode text characters as standardized sequences of two different signal durations?\n- Morse"
]

onready var player = get_parent().get_node("Player")
var joke_index = 0

func _ready():
	# I don't understand why this needs to be called to shuffle with random seed every time program is run. The randomize() in Main.gd seems to be randomizing only locally??
	# - try removing randomize() below and see that that the same jokes appear in order each time program is run.
	randomize()
	jokes.shuffle()
	$Panel.hide()

func displayJoke():
	bubblePosition()
	$Panel.show()
	$AnimationPlayer.play("JokeBubblePopup")
	if joke_index == len(jokes):
		joke_index = 0
	$Panel/Label.text = jokes[joke_index]
	joke_index += 1
	$HideBubbleTimer.start()
	
func hideJoke():
	$Panel.hide()

func bubblePosition():
	var bubble_side_padding = 10 #space between the bubble and screen edge
	var panel_middle = $Panel.rect_size.x / 2

	$Panel.rect_pivot_offset.x = panel_middle
	rect_position.x = player.position.x - panel_middle
	if (player.position.x < -1500 + panel_middle + bubble_side_padding):
		rect_position.x += (panel_middle - (player.position.x + 1500) + bubble_side_padding)
		$Panel.rect_pivot_offset.x = (player.position.x + 1500)
	elif (player.position.x > 1500 - panel_middle - bubble_side_padding):
		rect_position.x -= (panel_middle + (player.position.x - 1500) + bubble_side_padding)
		$Panel.rect_pivot_offset.x = $Panel.rect_size.x + (player.position.x - 1500)

	if (player.position.y > -820):
		rect_position.y = player.position.y - 60
		$Panel.grow_vertical = 0
		$Panel.rect_pivot_offset.y = 60
	else:
		rect_position.y = player.position.y + 20
		$Panel.grow_vertical = 1
		$Panel.rect_pivot_offset.y = -20
