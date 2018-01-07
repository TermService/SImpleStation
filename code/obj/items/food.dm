/obj/items/food
	icon = 'food.dmi'
	var/nutriments

/obj/items/food/poop
	icon_state = "poop1"
	nutriments = 40
	New() icon_state = "poop[pick("1","2","3")]"