/obj/decals
	icon = 'decals.dmi'
	layer = 12
	anchored = 1
	act_by_item(var/mob/living/H, var/obj/items/I)
		var/obj/items/weapon/tools/wrench/W = I
		if(istype(W)) try_to_wrench(H)

/obj/decals/space_sign
	name = "SPACE"
	icon_state = "space"