var/list/tiles_to_SAS = list()

/turf
	icon = 'turfs.dmi'
	layer = 1

/turf/act_by_item(var/mob/living/H, var/obj/items/I)
	var/obj/items/devices/analyzer/A = I
	if(istype(A))
		msg("<font color='blue'><B>[H.name]</B> сканирует <B>[src]</B>!</font>")
		to_chat(H,"Temperature ([temperature]°C)")
		to_chat(H,"Oxygen ([oxygen])")

/turf/simulated/floor
	icon_state = "floor"
	New() tiles_to_SAS += src //Помещаем все турфы пола в список tiles_to_SAS

/turf/simulated/floor/plating
	icon_state = "plating"

/turf/simulated/wall
	icon = 'walls.dmi'
	icon_state = "wall"
	opacity = 1
	density = 1
	pass_gas = 0
	New()
		if(density)
			var/n = autojoin("density")
			icon_state = "[n]"

/turf/simulated/wall/window
	icon = 'windows.dmi'
	icon_state = "window"
	opacity = 0

