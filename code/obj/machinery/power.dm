var/list/cables = list()
var/list/APCs = list()

proc/powernet_controller()
	for(var/obj/structures/cable/C in cables)
		sleep(1)
		C.POWERNET()
	for(var/obj/machinery/APC/A in APCs)
		sleep(1)
		A.process()

/obj/structures/cable
	icon = 'machinery.dmi'
	icon_state = "cable"
	anchored = 1
	alpha = 70
	layer = 1
	var/power = 100
	New() cables += src
	act_by_item(var/mob/living/H, var/obj/items/I)
		var/obj/items/devices/analyzer/A = I
		if(istype(A))
			msg("<font color='blue'><B>[H.name]</B> сканирует <B>[src]</B>!</font>")
			to_chat(H,"Power ([round(power)])")

/obj/structures/cable/proc/move_power(var/obj/structures/cable/C, var/obj/structures/cable/target)
	C.power -= 5
	target.power += 5

/obj/structures/cable/proc/POWERNET()
	if(power <= 0) return
	power -= 0.1
	for(var/obj/structures/cable/C in range(1,src)) if(C != src) if(C.power-(power-(power/21)) >= 19) move_power(C,src)
	for(var/obj/machinery/doors/D in range(0,src))
		if(power <= 0) D.powered = 0
		else D.powered = 1
	for(var/obj/machinery/atmos/vent/V in range(0,src))
		if(power <= 0) V.powered = 0
		else V.powered = 1
	for(var/obj/machinery/atmos/connector/C in range(0,src))
		if(power <= 0) C.powered = 0
		else C.powered = 1

/obj/machinery/APC
	icon_state = "apc"
	var/haspower = 200
	New() APCs += src
	act_by_item(var/mob/living/H, var/obj/items/I)
		var/obj/items/devices/analyzer/A = I
		var/obj/items/battery/B = I
		if(istype(B))
			msg("<B>[H.name]</B> вставляет батарейку в <B>[src]</B>!")
			haspower += B.energystored
			H.cut_hands()
		if(istype(A))
			msg("<font color='blue'><B>[H.name]</B> сканирует <B>[src]</B>!</font>")
			to_chat(H,"Power ([round(haspower)])")

/obj/machinery/APC/proc/process()
	if(haspower > 0)
		for(var/obj/structures/cable/C in orange(1,src))
			if(100-C.power >= 19)
				haspower -= 5
				C.power += 20