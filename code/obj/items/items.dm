/obj/items
	icon = 'items.dmi'

/obj/items/battery
	icon_state = "battery"
	var/energystored = 500

/obj/items/devices/analyzer
	icon_state = "analyzer"
	act_self() to_chat(usr,"Current position ([loc.x];[loc.y];[loc.z])")

