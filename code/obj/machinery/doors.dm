/mob/living/var/currentArea = ""

/obj/machinery/doors/Bumped()
	if(closed && !broken && !working && powered) proceed(src)

/obj/machinery/doors
	icon = 'doors.dmi'
	var/mydoor = "" //Сюда пихают первую часть icon_state'a
	var/mysound //Звук двери
	var/broken
	var/closed = 1
	var/transparent //Прозрачность двери
	var/working
	density = 1
	pass_gas = 0
	layer = 5
	New() if(!transparent) opacity = 1

/obj/machinery/doors/attack_hand(var/mob/living/H)
	if(!working && powered) proceed(H)

/obj/machinery/doors/act_by_item(var/mob/living/H, var/obj/items/I)
	var/obj/items/weapon/tools/crowbar/C = I
	if(istype(C) && !powered)
		if(closed) msg("<B>[H.name] открывает [src] ломом!</B>")
		else msg("<B>[H.name] закрывает [src] ломом!</B>")
		proceed(H)

/obj/machinery/doors/proc/proceed(var/mob/living/H = usr)
	if(!broken) //Если дверь не сломана
		playsound(mysound)
		if(closed)
			flick("[mydoor]_opening", src)
			working = 1
			sleep(6)
			open()
		else
			flick("[mydoor]_closing", src)
			working = 1
			sleep(6)
			close()
		for(var/turf/simulated/floor/T in range(6,src)) spawn() T.SAS() //При активации ключевых для атмоса объектов совершаются дополнительные проверки, дабы ускорить процесс.
	else to_chat(H,"<B>Не поддается.</B>")

/obj/machinery/doors/proc/open()
	icon_state = "[mydoor]_opened"
	closed = 0
	if(!transparent) opacity = 0
	pass_gas = 1
	density = 0
	working = 0

/obj/machinery/doors/proc/close()
	icon_state = "[mydoor]_closed"
	closed = 1
	pass_gas = 0
	if(!transparent) opacity = 1
	density = 1
	working = 0

/obj/machinery/doors/futuristic
	name = "futuristic door"
	icon_state = "futuristic_closed"
	mydoor = "futuristic"
	mysound = 'sounds/airlock.ogg'