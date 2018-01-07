/obj/machinery/atmos
	icon = 'atmos_devices.dmi'
	New() for(var/obj/structures/cable/C in loc) if(C.power > 0) powered = 1

/obj/machinery/atmos/heater
	icon_state = "heater"
	var/haspower = 100
	var/opened

/obj/machinery/atmos/heater/attack_hand(var/mob/living/H)
	if(!on)
		if(haspower > 0)
			msg("<B>[H.name] включает [src]!</B>")
			on = 1
			check()
		else to_chat(H,"<font color='red'>Недостаточно энергии.</font>")
	else
		msg("<B>[H.name] выключает [src]!</B>")
		on = 0

/obj/machinery/atmos/heater/act_by_item(var/mob/living/H, var/obj/items/I)
	var/obj/items/battery/B = I
	var/obj/items/devices/analyzer/A = I
	var/obj/items/weapon/tools/screwdriver/S = I
	var/obj/items/weapon/tools/wrench/W = I
	if(istype(W)) try_to_wrench(H)
	if(istype(S))
		playsound('screwdriver.ogg')
		if(!opened)
			msg("<B>[H.name]</B> открывает <B>[src]</B>!")
			opened = 1
		else
			msg("<B>[H.name]</B> закрывает <B>[src]</B>!")
			opened = 0
	if(istype(B))
		if(opened)
			msg("<B>[H.name]</B> вставляет батарейку в [src]!")
			haspower += B.energystored
			H.cut_hands()
		else H << "[src] закрыт. Нужна отвертка."
	if(istype(A))
		msg("<font color='blue'><B>[H.name]</B> сканирует <B>[src]</B>!</font>")
		to_chat(H,"[src] содержит в себе [haspower] единиц энергии.")
		if(!opened) to_chat(H,"[src] закрыт.")
		else if(opened) to_chat(H,"[src] открыт.")

/obj/machinery/atmos/heater/proc/check()
	for(var/turf/simulated/floor/T in range(4, src))
		if(!T.loc.density)
			while(haspower > 0 && on)
				sleep(20)
				T.temperature++
				T.SAS() //При активации ключевых для атмоса объектов совершаются дополнительные проверки, дабы ускорить процесс.
				haspower -= 10

/obj/machinery/atmos/cooler
	icon_state = "cooler"
	var/haspower = 100
	var/opened

/obj/machinery/atmos/cooler/attack_hand(var/mob/living/H)
	if(!on)
		if(haspower > 0)
			msg("<B>[H.name] включает [src]!</B>")
			on = 1
			check()
		else to_chat(H,"<font color='red'>Недостаточно энергии.</font>")
	else
		msg("<B>[H.name] выключает [src]!</B>")
		on = 0

/obj/machinery/atmos/cooler/act_by_item(var/mob/living/H, var/obj/items/I)
	var/obj/items/battery/B = I
	var/obj/items/devices/analyzer/A = I
	var/obj/items/weapon/tools/screwdriver/S = I
	var/obj/items/weapon/tools/wrench/W = I
	if(istype(W)) try_to_wrench(H)
	if(istype(S))
		playsound('screwdriver.ogg')
		if(!opened)
			msg("<B>[H.name]</B> открывает <B>[src]</B>!")
			opened = 1
		else
			msg("<B>[H.name]</B> закрывает <B>[src]</B>!")
			opened = 0
	if(istype(B))
		if(opened)
			msg("<B>[H.name]</B> вставляет батарейку в <B>[src]</B>!")
			haspower += B.energystored
			H.cut_hands()
		else to_chat(H,"[src] закрыт. Нужна отвертка.")
	if(istype(A))
		msg("<font color='blue'><B>[H.name]</B> сканирует <B>[src]</B>!</font>")
		to_chat(H,"[src] содержит в себе [haspower] единиц энергии.")
		if(!opened) to_chat(H,"[src] закрыт.")
		else if(opened) to_chat(H,"[src] открыт.")

/obj/machinery/atmos/cooler/proc/check()
	for(var/turf/simulated/floor/T in range(4, src))
		if(!T.loc.density)
			while(haspower > 0 && on)
				sleep(20)
				T.temperature--
				T.SAS() //При активации ключевых для атмоса объектов совершаются дополнительные проверки, дабы ускорить процесс.
				haspower -= 10

/obj/machinery/atmos/vent
	name = "vent"
	icon_state = "vent0"
	icon_on = "vent1"
	icon_off = "vent0"
	density = 0
	attack_hand(var/mob/living/H)
		if(!powered) return to_chat(H,"<font color='red'>Не работает.</font>")
		if(!on)
			msg("<font color='red'><B>[H.name] активирует [src]!</B></font>")
			on = 1
		else
			msg("<font color='red'><B>[H.name] выключает [src]!<B></font>")
			on = 0
		work()
		check()

/obj/machinery/atmos/vent/proc/check()
	if(on) icon_state = icon_on
	else icon_state = icon_off

/obj/machinery/atmos/vent/proc/work()
	for(var/turf/simulated/floor/F in range(9,src))
		for(var/atom/A in F)
			if(A.pass_gas && F.pass_gas)
				while(F.oxygen > 0 && on)
					check()
					F.SAS() //При активации ключевых для атмоса объектов совершаются дополнительные проверки, дабы ускорить процесс.
					sleep(1)
					F.oxygen--

//CANISTERS*start*//
/obj/machinery/atmos/canister
	name = "canister"
	var/oxygen
	var/opened
	anchored = 0
	attack_hand(var/mob/living/H)
		if(!opened)
			msg("<B>[H.name]</B> открывает <B>[src]</B>!")
			opened = 1
		else
			msg("<B>[H.name]</B> закрывает <B>[src]</B>!")
			opened = 0
		work()
		check()
	act_by_item(var/mob/living/H, var/obj/items/I)
		var/turf/T = src.loc
		var/obj/items/devices/analyzer/A = I
		var/obj/items/weapon/tools/wrench/W = I
		if(istype(W))
			for(var/obj/machinery/atmos/connector/C in T)
				if(pulled) try_to_pull(src,H)
				playsound('wrench.ogg')
				if(!C.connected)
					msg("<B>[H.name]</B> прикручивает <B>[src]</B> к <B>[C]</B>!")
					C.connected = src
					anchored = 1
				else if(C.connected)
					msg("<B>[H.name]</B> откручивает <B>[src]</B>!")
					C.connected = null
					anchored = 0
		if(istype(A))
			msg("<font color='blue'><B>[H.name]</B> сканирует <B>[src]</B>!</font>")
			to_chat(H,"Oxygen ([oxygen])")

/obj/machinery/atmos/canister/proc/check()
	if(opened) icon_state = icon_on
	else icon_state = icon_off

/obj/machinery/atmos/canister/proc/work()
	for(var/turf/simulated/floor/F in range(9,src))
		while(oxygen > 0 && opened)
			F.oxygen++
			oxygen--
			sleep(1)
			F.SAS()
			check()

/obj/machinery/atmos/canister/oxygen
	icon_state = "02canister_closed"
	icon_on = "02canister_opened"
	icon_off = "02canister_closed"
	oxygen = 1000
//CANISTERS*end*//

/obj/machinery/atmos/connector
	icon_state = "connector"
	density = 0
	var/opened
	var/obj/machinery/atmos/canister/connected
	attack_hand(var/mob/living/H)
		if(!powered) return to_chat(H,"<font color='red'>Не работает.</font>")
		if(!opened && connected)
			msg("<B>[H.name]</B> активирует <B>[src]</B>!")
			opened = 1
		else if(opened && connected)
			msg("<B>[H.name]</B> выключает <B>[src]</B>!")
			opened = 0
		work()

/obj/machinery/atmos/connector/proc/work()
	if(connected)
		while(connected.oxygen < 1000 && opened)
			sleep(1)
			connected.oxygen++




