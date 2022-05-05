extends Control

signal buy_simple_unit
signal buy_attacker_unit
signal buy_tower_unit

func _ready():
	pass

## Emmits a "buy_simple_unit" signal.
## @desc:
## 		Emmits a "buy_simple_unit" signal. Buys a simple unit for the current player.
func _on_ButtonBuyNormal_pressed():
	emit_signal('buy_simple_unit')

## Emmits a "buy_attacker_unit" signal.
## @desc:
## 		Emmits a "buy_attacker_unit" signal. Buys an attacker unit for the current player.
func _on_ButtonBuyAttacker_pressed():
	emit_signal('buy_attacker_unit')

## Emmits a "buy_tower_unit" signal.
## @desc:
## 		Emmits a "buy_tower_unit" signal. Buys a tower unit for the current player.
func _on_ButtonBuyTower_pressed():
	emit_signal('buy_tower_unit')
