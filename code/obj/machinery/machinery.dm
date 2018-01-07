/obj/machinery
	icon = 'machinery.dmi'
	density = 1
	anchored = 1
	layer = 2
	var/on
	var/powered
	var/use_power
	var/icon_off
	var/icon_on
	Bumped(var/mob/living/H) if(!anchored) step(src,H.dir)

/obj/machinery/light/lightbulb
	icon_state = "bulb1"
	icon_on = "bulb1"
	icon_off = "bulb0"
	layer = 12
	density = 0
	power = 4

/obj/machinery/light
	var/power
	attack_hand()
		if(on)
			on = 0
			icon_state = icon_off
		else
			on = 1
			icon_state = icon_on

//GENERATOR*start*//
/obj/machinery/generator
	icon_state = "generator"
	var/energy = 0
	var/bioenergy = 0
	layer = 5

/obj/machinery/generator/proc/check()
	if(bioenergy <= 0) on = 0
	if(on) icon_state = "generator_working"
	else icon_state = "generator"

/obj/machinery/generator/proc/work()
	while(bioenergy > 0)
		sleep(3)
		energy++
		bioenergy--
		check()

/obj/machinery/generator/attack_hand()
	playsound('console.ogg')
	menu()

/obj/machinery/generator/proc/menu()
	var/pick = input("���������") in list ("������", "���������", "������� ���������", "(������)") as text|null
	if(pick)
		if(get_dist(src,usr) > 1) return
		switch(pick)
			if("������")
				playsound('console_done.ogg')
				to_chat(usr,"<B>[src] �������� � ���� [energy] ������ �������.</B>")
				to_chat(usr,"<B>[src] �������� � ���� [bioenergy] ������ ���-�������.</B>")
			if("���������")
				if(bioenergy > 0 && !on)
					playsound('console.ogg')
					on = 1
					work()
				else playsound('console_error.ogg')
			if("������� ���������")
				playsound('console.ogg')
				battery()
			if("(������)") playsound('console.ogg')

/obj/machinery/generator/proc/battery()
	var/pick = input("�������?") in list ("��", "���") as text|null
	if(pick)
		if(get_dist(src,usr) > 1) return
		switch(pick)
			if("��")
				if(energy >= 100)
					msg("<B>\icon[src] ������� �������� ��������� ��������.</B>")
					playsound('console_done.ogg')
					energy -= 100
					new /obj/items/battery(usr.loc)
				else
					to_chat(usr,"<B>������������ �������.</B>")
					playsound('console_error.ogg')
			if("���") playsound('console.ogg')

/obj/machinery/generator/act_by_item(var/mob/living/H, var/obj/items/I)
	var/obj/items/food/poop/P = I
	var/obj/items/devices/analyzer/A = I
	var/obj/items/weapon/tools/wrench/W = I
	if(istype(W)) try_to_wrench(H)
	if(istype(P))
		msg("<B>[H.name]</B> ���������� ����������� � <B>[src]</B>!")
		bioenergy += 100
		H.cut_hands()
	if(istype(A))
		msg("<font color='blue'><B>[H.name]</B> ��������� <B>[src]</B>!</font>")
		to_chat(H,"<B>[src] �������� � ���� [energy] ������ �������.</B>")
		to_chat(H,"<B>[src] �������� � ���� [bioenergy] ������ ���-�������.</B>")
//GENERATOR*end*//