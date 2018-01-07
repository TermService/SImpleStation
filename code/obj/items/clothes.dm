/mob/living/proc/equip(var/mob/living/H = usr)
	if(H.acthand && !H.my_clothes_contents)
		var/obj/items/clothes/I = H.acthand
		if(istype(I))
			H.C.overlays += I
			H.my_clothes_contents = I
			msg("<font color='blue'><B>[H.name]</B> надевает <B>[I]</B>.</font>")
			I.layer = MOB_LAYER + 51
			H.overlays += I.texture
			H.cut_hands()

/mob/living/proc/unequip(var/mob/living/H = usr)
	if(H.hand && !H.my_rhand_contents)
		var/obj/items/clothes/I = H.my_clothes_contents
		if(istype(I))
			H.R.overlays += I
			H.my_rhand_contents = I
			I.layer = MOB_LAYER + 51
			H.overlays -= I.texture
			H.C.overlays -= I
			H.my_clothes_contents = null
	if(!H.hand && !H.my_lhand_contents)
		var/obj/items/clothes/I = H.my_clothes_contents
		if(istype(I))
			H.L.overlays += I
			H.my_lhand_contents = I
			I.layer = MOB_LAYER + 51
			H.overlays -= I.texture
			H.C.overlays -= I
			H.my_clothes_contents = null
	if(H.my_pocket_contents)
		var/obj/items/I = H.my_pocket_contents
		POCKET.overlays -= I
		H.my_pocket_contents = null
		I.Move(src.loc)
		I.layer = 4
	if(H.my_pocket2_contents)
		var/obj/items/I = H.my_pocket2_contents
		POCKET2.overlays -= I
		H.my_pocket2_contents = null
		I.Move(src.loc)
		I.layer = 4
	if(H.my_belt_contents)
		var/obj/items/I = H.my_belt_contents
		BELT.overlays -= I
		H.my_belt_contents = null
		I.Move(src.loc)
		I.layer = 4

//POCKETS*start*//
/mob/living/proc/epocket(var/mob/living/H = usr)
	if(H.acthand && !H.my_pocket_contents && H.my_clothes_contents)
		var/obj/items/I = H.acthand
		if(istype(I))
			H.POCKET.overlays += I
			H.my_pocket_contents = I
			msg("<B>[H.name]</B> что-то сует себе в карман.")
			I.layer = MOB_LAYER + 51
			H.cut_hands()

/mob/living/proc/upocket(var/mob/living/H = usr)
	if(H.hand && !H.my_rhand_contents && H.my_pocket_contents && H.my_clothes_contents)
		var/obj/items/I = H.my_pocket_contents
		H.R.overlays += I
		H.my_rhand_contents = I
		I.layer = MOB_LAYER + 51
		H.POCKET.overlays -= I
		H.my_pocket_contents = null
	if(!H.hand && !H.my_lhand_contents && H.my_pocket_contents && H.my_clothes_contents)
		var/obj/items/I = H.my_pocket_contents
		H.L.overlays += I
		H.my_lhand_contents = I
		I.layer = MOB_LAYER + 51
		H.POCKET.overlays -= I
		H.my_pocket_contents = null

/mob/living/proc/epocket2(var/mob/living/H = usr)
	if(H.acthand && !H.my_pocket2_contents && H.my_clothes_contents)
		var/obj/items/I = H.acthand
		if(istype(I))
			H.POCKET2.overlays += I
			H.my_pocket2_contents = I
			msg("<B>[H.name]</B> что-то сует себе в карман.")
			I.layer = MOB_LAYER + 51
			H.cut_hands()

/mob/living/proc/upocket2(var/mob/living/H = usr)
	if(H.hand && !H.my_rhand_contents && H.my_pocket2_contents && H.my_clothes_contents)
		var/obj/items/I = H.my_pocket2_contents
		H.R.overlays += I
		H.my_rhand_contents = I
		I.layer = MOB_LAYER + 51
		H.POCKET2.overlays -= I
		H.my_pocket2_contents = null
	if(!H.hand && !H.my_lhand_contents && H.my_pocket2_contents && H.my_clothes_contents)
		var/obj/items/I = H.my_pocket2_contents
		H.L.overlays += I
		H.my_lhand_contents = I
		I.layer = MOB_LAYER + 51
		H.POCKET2.overlays -= I
		H.my_pocket2_contents = null
//POCKETS*end*//

/mob/living/proc/ebelt(var/mob/living/H = usr)
	if(H.acthand && !H.my_belt_contents && H.my_clothes_contents)
		var/obj/items/I = H.acthand
		if(istype(I))
			H.BELT.overlays += I
			H.my_belt_contents = I
			I.layer = MOB_LAYER + 51
			H.cut_hands()

/mob/living/proc/ubelt(var/mob/living/H = usr)
	if(H.hand && !H.my_rhand_contents && H.my_belt_contents && H.my_clothes_contents)
		var/obj/items/I = H.my_belt_contents
		H.R.overlays += I
		H.my_rhand_contents = I
		I.layer = MOB_LAYER + 51
		H.BELT.overlays -= I
		H.my_belt_contents = null
	if(!H.hand && !H.my_lhand_contents && H.my_belt_contents && H.my_clothes_contents)
		var/obj/items/I = H.my_belt_contents
		H.L.overlays += I
		H.my_lhand_contents = I
		I.layer = MOB_LAYER + 51
		H.BELT.overlays -= I
		H.my_belt_contents = null

/obj/items/clothes
	icon = 'clothes.dmi'
	var/texture = "" //ќверлей

/obj/items/clothes/jan_suit
	name = "janitor uniform"
	icon_state = "jan_uniform"
	texture = "jan_suit"

/obj/items/clothes/sec_suit
	name = "security uniform"
	icon_state = "sec_uniform"
	texture = "sec_suit"

/obj/items/clothes/eng_suit
	name = "engineer uniform"
	icon_state = "eng_uniform"
	texture = "eng_suit"