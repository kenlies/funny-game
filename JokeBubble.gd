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
"What do you call a bumblebee that is seeping?\n- Slumberbee",
"What do you call a bumblebee that is a rabbit character from Disney motion picture \"Bambi\"?\n- Thumperbee",
"What do you call a bumblebee that is a log?\n- Lumberbee",
"What do you call a bumblebee that mgdmmgdf mgmgd?\n- Mumblebee",
"What do you call a hobbit that is not a hobbit?\n- Nobbit",
"What do you call a hobbit that is overight?\n- Fabbit",
"What do you call a hobbit that is a thief?\n- Robbit",
"What do you call game of ping-pong when it is a male genitalia?\n- Ding-dong",
"What do you call water when it is a dad?\n- Fater",
"What is a game developer's favorite soda drink?\n- Sprite"
]

func _ready():
	$Panel.hide()

func displayJoke():
	randomize()
	$Panel.show()
	$Panel/Label.text = jokes[randi() % len(jokes)]
	$HideBubbleTimer.start()
	
func _on_HideBubbleTimer_timeout():
	$Panel.hide()