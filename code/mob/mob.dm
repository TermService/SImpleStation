var/list/creatures = list()

/mob/living
	var/state = "ALIVE"
	var/health = 100
	var/obj/my_pull
	var/canhit = 1
	var/canrest = 1
	var/rests
	layer = 5
	New() creatures += src //�������� ���� ������� � ���� creatures

mob/verb
	Change_An_Icon_Color()// selects icon
		src.icon += rgb(50,0,0)// puts amounts into icon

/mob/living/Stat(var/mob/living/H = usr)
	..()
	if(statpanel("Status"))
		stat(null, "CPU: [world.cpu]")

/mob/living/Bumped(var/mob/living/attacker) //��� ������������ � �����
	if(attacker.intent == "help" && intent == "help") //���� ������ ���������� ������������ � ���� ����� �����
		attacker.loc = loc //��������� ������������ �� ������� ����
		loc = attacker.oldloc //��� ������� �� ������ ������� ����������
	else if(attacker.intent == "harm")
		step(src,attacker.dir) //���� ������ ���������� ������������ ����� ����� - ��� ���� � ������� ����������� ����������

/mob/living/human
	icon = 'human.dmi'
	icon_state = "human"
	Login()
		loc = locate(/turf/simulated/floor)
		draw_hud() //������ ���
		hud_processor() //���������� ��� ����������������
		draw_parallax() //������ ���������

//////Movement*start*//////
/mob/living
	var/canMove = 1
	var/rundelay = 2
	var/turf/oldloc

/mob/living/proc/calcutale_step() return rundelay

/mob/living/Move()
	if(key && parallax_movement) move_parallax()
	oldloc = loc
	if(my_pull) if(my_pull.pulled && my_pull.puller == src) my_pull.loc = oldloc //����
	if(canMove)
		canMove = 0
		..()
		sleep(calcutale_step())
		canMove = 1
//////Movement*end*//////

//////Damage*start*//////
/mob/living/var/list/bodyparts = list()
/obj/bodypart
	icon = 'human.dmi'
	var/hp = 10
	var/hp_max = 10
	var/fracture = 0

/obj/bodypart/human/head
/obj/bodypart/human/right_arm
/obj/bodypart/human/left_arm
/obj/bodypart/human/right_leg
/obj/bodypart/human/left_leg
//////�������//////
/mob/living/var/Overlay/o_head
/mob/living/var/Overlay/o_right_arm
/mob/living/var/Overlay/o_left_arm
/mob/living/var/Overlay/o_right_leg
/mob/living/var/Overlay/o_left_leg
/mob/living/var/Overlay/head_wound
/mob/living/var/Overlay/chest_wound
/mob/living/var/Overlay/right_arm_wound
/mob/living/var/Overlay/left_arm_wound
/mob/living/var/Overlay/right_leg_wound
/mob/living/var/Overlay/left_leg_wound

/mob/living/human/New()
	..()
	icon_state = "torso"
	var/obj/bodypart/human/head/h = new; bodyparts += h
	var/obj/bodypart/human/right_arm/ra = new; bodyparts += ra
	var/obj/bodypart/human/left_arm/la = new; bodyparts += la
	var/obj/bodypart/human/right_leg/rl = new; bodyparts += rl
	var/obj/bodypart/human/left_leg/ll = new; bodyparts += ll
	for(var/obj/bodypart/human/b in bodyparts) b.hp = b.hp_max
	draw_bodyparts() //������ ����

/mob/living/proc/draw_bodyparts()
	del o_head
	del o_right_arm
	del o_left_arm
	del o_right_leg
	del o_left_leg
	del head_wound
	del chest_wound
	del right_arm_wound
	del left_arm_wound
	del right_leg_wound
	del left_leg_wound
	//����� �� �������� ���������� ���������� ����� ���� ����
	for(var/obj/bodypart/human/head/h in bodyparts) o_head = overlay('human.dmi', "head")
	for(var/obj/bodypart/human/right_arm/h in bodyparts) o_right_arm = overlay('human.dmi', "r_arm")
	for(var/obj/bodypart/human/left_arm/h in bodyparts) o_left_arm = overlay('human.dmi', "l_arm")
	for(var/obj/bodypart/human/right_leg/h in bodyparts) o_right_leg = overlay('human.dmi', "r_leg")
	for(var/obj/bodypart/human/left_leg/h in bodyparts) o_left_leg = overlay('human.dmi', "l_leg")
//////Damage*end*//////

//////Interactions*start*//////
atom
	var/pulled
	var/puller
	var/anchored
	var/movable = 1

/atom/proc/Bumped(var/mob/living/H)

/atom/Click(location,control,params,var/mob/living/H = usr)
	params = params2list(params)
	var/obj/O = src
	if("right" in params)
		world << "1"
		if(O in range(1,H))
			world << "2"
			if(istype(O) && O.movable)
				world << "3"
				try_to_pull(O,H)
	if("left" in params)
		if(src in range(1,H))
			if(!H.acthand) attack_hand(H)
			if(H.acthand) act_by_item(H,H.acthand)
	if("middle" in params) H.swap_hands()

/atom/proc/try_to_pull(var/obj/O, var/mob/living/H)
	if(H.my_pull && O.puller != H) return to_chat(H,"<font color='red'>�� ��� ���-�� ������.</font>")
	if(anchored) return to_chat(H,"<font color='red'>[src] ��������� � ����.</font>")
	if(!pulled)
		to_chat(H,"�� �������� [src].")
		pulled = 1
		puller = H
		H.my_pull = src
	else
		to_chat(H,"�� ���������� [src].")
		pulled = 0
		puller = null
		H.my_pull = null

/obj/proc/try_to_wrench(var/mob/living/H)
	if(pulled) try_to_pull(src,H)
	playsound('wrench.ogg')
	if(anchored)
		msg("<B>[H.name]</B> ����������� <B>[src]</B>!"); anchored = 0
	else
		msg("<B>[H.name]</B> ������������ <B>[src]</B> � ����!"); anchored = 1

/obj/items/proc/act_self(var/mob/living/H = usr)

/atom/proc/special_act(var/mob/living/H = usr)

/atom/proc/act_by_item(var/mob/living/H,var/obj/items/I)

/atom/proc/attack_hand(var/mob/living/H = usr)
	if(src in range(1, H))
		if(istype(src, /obj/items))
			var/obj/items/I = src
			if(H.hand && !H.my_rhand_contents)
				H.my_rhand_contents = src
				I.Move(usr)
				layer = MOB_LAYER + 51
				H.R.overlays += src
			if(!H.hand && !H.my_lhand_contents)
				H.my_lhand_contents = src
				I.Move(usr)
				layer = MOB_LAYER + 51
				H.L.overlays += src
			if(H.acthand) act_by_item(usr, H.acthand)
			if(pulled) try_to_pull(src,H)
		else act_by_item(usr, H.acthand)

/mob/living/proc/drop(var/mob/living/H = usr)
	if(H.acthand)
		var/obj/items/I = H.acthand
		H.cut_hands()
		I.Move(usr.loc)
		I.layer = 5

/mob/living/Bump(var/atom/A)
	A.Bumped(src)
//////Interactions*end*//////

/mob/living/proc/poo()
	Emote("����!")
	new/obj/items/food/poop(src.loc)