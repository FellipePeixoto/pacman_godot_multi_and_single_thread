extends Timer

onready var director = get_parent()

export var time_left_warn_when = 0.3
signal warn

func _physics_process(delta):
	if (director.state == director.STATE_BACKOFF):
		var time_left_percent = time_left / wait_time
		if (time_left_percent <= time_left_warn_when):
			director.state = director.STATE_BACKOFF_END
