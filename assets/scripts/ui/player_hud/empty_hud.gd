extends Sprite


func _ready():
	$flicker.play("RESET")
	$t.interpolate_property(self, "position", self.position, self.position + Vector2(0, -15), 1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$t.start()
	yield($t, "tween_completed")
	$wait_timer.start()

func _on_Timer_timeout():
	$flicker.play("flicker")
	$despawn_timer.start()


func _on_despawn_timer_timeout():
	queue_free()
