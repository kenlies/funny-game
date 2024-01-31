extends Control

var jokes = [
"What do you call axolotl when it's doing taxes?\n- Taxolotl",
"What do you call axolotl when it small?\n- Axolitl",
"What do you call axolotl when it's a hacker?\n- Haxolotl",
"What do you call axolotil when it's using too much deodorant?\n- AXElotl",
"What do you call owl that is bald?\n- Bowld",
"What do you call penguin that is holdign an pen?\n- PENguin",
"What do you call a seagull who's a girl?\n- Shegull",
"How do you make cupcakes?\n- First you make cake and then put it in a cup!",
"What do you call a bumblebee that is a exercise equipment?\n- Dumbellbee",
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
"What do you call an elephant that has an x86 architechture central proceccssing unit?\n- Intelephant",
"What do you call a mouse that is taking a break?\n- A pause",
"What do you call a window that came in second?\n- Losedow",
"What do you call a door that has no money?\n- A poor",
"What does the atmosphere use for its hair?\n- Air conditioner",
"What do you call an octopus that is a doctor?\n- Doctopus",
"What do you call an octopus that is suspicious?\n- Octosus"
]

func _ready():
	$Panel.hide()

func displayJoke():
	randomize()
	$Panel.show()
	$Panel/Label.text = jokes[randi() % len(jokes)]
	$HideBubbleTimer.start()
	
func hideJoke():
	$Panel.hide()
