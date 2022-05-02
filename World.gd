extends Node2D

onready var worldMusicPlayer = $WorldMusicPlayer

func _ready():
#	Games uses seeds to generate random numbers. This means, if we don't call
#	randomize the result of random generators will always be the same...
	randomize()
	worldMusicPlayer.play()
	
