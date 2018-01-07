/mob/living
	var/obj/hud/lhand/L
	var/obj/hud/rhand/R
	var/obj/hud/drop/D
	var/obj/hud/clothes/C
	var/obj/hud/intent/ACT
	var/obj/hud/belt/BELT
	var/obj/hud/pocket/POCKET
	var/obj/hud/pocket2/POCKET2
	var/obj/items/my_clothes_contents = null
	var/obj/items/my_rhand_contents = null
	var/obj/items/my_lhand_contents = null
	var/obj/items/my_pocket_contents = null
	var/obj/items/my_pocket2_contents = null
	var/obj/items/my_belt_contents = null
	var/hand = RHAND
	var/acthand
	var/intent = "help"

/mob/living/proc/draw_hud() //Рисуем худ
	L = new(src)
	R = new(src)
	D = new(src)
	C = new(src)
	ACT = new(src)
	BELT = new(src)
	POCKET = new(src)
	POCKET2 = new(src)

/mob/living/proc/del_hud() //Стираем худ
	del(R)
	del(L)
	del(D)
	del(C)
	del(ACT)
	del(BELT)
	del(POCKET)
	del(POCKET2)

/mob/living/proc/hud_processor()
	if(state != "DEAD")
		R.check_act_hand()
		L.check_act_hand()
		if(hand == RHAND)
			R.active = 1
			acthand = my_rhand_contents
			L.active = 0
		else
			R.active = 0
			acthand = my_lhand_contents
			L.active = 1
		if(R.time_to_swap || L.time_to_swap)
			R.time_to_swap = 0
			L.time_to_swap = 0
			swap_hands()
		if(ACT.time_to_intent)
			ACT.time_to_intent = 0
			intent()
		spawn(1) hud_processor()

/obj/hud
	layer = MOB_LAYER + 50
	icon = 'hud.dmi'
	movable = 0
	var/time_to_swap = 0
	var/time_to_intent = 0
	var/active = 0

//PARALLAX*start*//
/mob/living
	var/obj/hud/parallax/layer_1/L1
	var/obj/hud/parallax/layer_2/L2
	var/obj/hud/parallax/layer_3/L3

/mob/living/proc/draw_parallax()
	L1 = new(src)
	L2 = new(src)
	L3 = new(src)

/mob/living/proc/del_parallax()
	del(L1)
	del(L2)
	del(L3)

/mob/living/proc/move_parallax()
	var/matrix/Ma = matrix()
	if(prob(50))
		L2.angle += 0.025
		Ma.Turn(L2.angle)
		L2.transform = Ma
	else
		L3.angle -= 0.025
		Ma.Turn(L3.angle)
		L3.transform = Ma

/obj/hud/parallax
	name = "open space"
	icon = 'parallax.dmi'
	mouse_opacity = 1
	var/angle = 0
	plane = PLANE_SPACE_PARALLAX
	New()
		screen_loc = "1,1"
		usr.client.screen += src

/obj/hud/parallax/layer_1 //Основа
	icon_state = "layer_1"

/obj/hud/parallax/layer_2 //Звездочки
	icon_state = "layer_2"

/obj/hud/parallax/layer_3 //Толстые звездочки
	icon_state = "layer_3"
//PARALLAX*end*//

//HANDS*start*//
/obj/hud/rhand
	name = "right hand"
	icon_state = "hand"
	active = 1
	New()
		screen_loc = "2,2"
		usr.client.screen += src
	Click(var/mob/living/H = usr) //как минять руки
		if(H.hand == RHAND)
			if(!H.my_rhand_contents) time_to_swap = 1
			else H.my_rhand_contents.act_self(H.my_rhand_contents,H)
		else time_to_swap = 1

/obj/hud/lhand
	name = "left hand"
	icon_state = "hand"
	active = 1
	New()
		screen_loc = "3,2"
		usr.client.screen += src
	Click(var/mob/living/H = usr) //как минять руки[2]
		if(H.hand == LHAND)
			if(!H.my_lhand_contents) time_to_swap = 1
			else H.my_lhand_contents.act_self(H.my_lhand_contents,H)
		else time_to_swap = 1

/mob/living/proc/cut_hands()
	if(R.active)
		R.overlays -= my_rhand_contents
		my_rhand_contents = null
	else
		L.overlays -= my_lhand_contents
		my_lhand_contents = null

/obj/hud/proc/check_act_hand()
	if(active) icon_state = "act_hand"
	else icon_state = "hand"

/mob/living/proc/swap_hands()
	if(state != "DEAD")
		if(hand == RHAND)
			R.active = 0
			L.active = 1
			hand = LHAND
		else if(hand == LHAND)
			R.active = 1
			L.active = 0
			hand = RHAND
//HANDS*end*//

/obj/hud/drop
	icon_state = "drop"
	New()
		screen_loc = "4,1"
		usr.client.screen += src
	Click(var/mob/living/H = usr) H.drop()

/obj/hud/intent
	icon_state = "act_help"
	New()
		screen_loc = "4,2"
		usr.client.screen += src
	Click() time_to_intent = 1

/mob/living/proc/intent()
	if(intent == "help")
		intent = "harm"
		ACT.icon_state = "act_harm"
	else if(intent == "harm")
		intent = "help"
		ACT.icon_state = "act_help"

/obj/hud/clothes
	icon_state = "clothes"
	New()
		screen_loc = "1,2"
		usr.client.screen += src
	Click(var/mob/living/H = usr)
		if(H.state == "DEAD") return
		if(!H.my_clothes_contents) H.equip()
		else H.unequip()

/obj/hud/pocket
	icon_state = "pocket"
	New()
		screen_loc = "2,1"
		usr.client.screen += src
	Click(var/mob/living/H = usr)
		if(H.state == "DEAD") return
		if(!H.my_pocket_contents) H.epocket()
		else H.upocket()

/obj/hud/pocket2
	icon_state = "pocket"
	New()
		screen_loc = "3,1"
		usr.client.screen += src
	Click(var/mob/living/H = usr)
		if(H.state == "DEAD") return
		if(!H.my_pocket2_contents) H.epocket2()
		else H.upocket2()

/obj/hud/belt
	icon_state = "belt"
	New()
		screen_loc = "1,1"
		usr.client.screen += src
	Click(var/mob/living/H = usr)
		if(H.state == "DEAD") return
		if(!H.my_belt_contents) H.ebelt()
		else H.ubelt()

