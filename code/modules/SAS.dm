/*
   _____ _     _ _                _                _                          _____           _
  / ____| |   (_) |              | |          /\  | |                        / ____|         | |
 | (___ | |__  _| |_ ___ ___   __| | ___     /  \ | |_ _ __ ___   ___  ___  | (___  _   _ ___| |_ ___ _ __ ___
  \___ \| '_ \| | __/ __/ _ \ / _` |/ _ \   / /\ \| __| '_ ` _ \ / _ \/ __|  \___ \| | | / __| __/ _ \ '_ ` _ \
  ____) | | | | | || (_| (_) | (_| |  __/  / ____ \ |_| | | | | | (_) \__ \  ____) | |_| \__ \ ||  __/ | | | | |
 |_____/|_| |_|_|\__\___\___/ \__,_|\___| /_/    \_\__|_| |_| |_|\___/|___/ |_____/ \__, |___/\__\___|_| |_| |_|
                                                                                     __/ |
                                                                                    |___/
пиздец я ненавижу этот кал
*/
#define gas_number 21  //Газоделитель
atom
	var/pass_gas = 1

/turf
	var/oxygen = -INFINITY
	var/temperature

/turf/space
	icon_state = "space"
	temperature = -270
	New() icon_state = null

/turf/simulated
	oxygen = 100
	temperature = 21

/turf/simulated/proc/SAS()
	turf_check()
	gas_control()
	temperature_control()

/turf/simulated/proc/turf_check()
	for(var/obj/machinery/doors/D in src.loc)
		if(D.pass_gas) pass_gas = 1
		else pass_gas = 0

/turf/simulated/proc/gas_control()
	for(var/turf/T in orange(1, src))
		var/turf/space/S = T
		var/turf/simulated/floor/F = T
		if(!pass_gas) return
		if(istype(S)) //Кислород и космос
			while(oxygen > 0)
				sleep(1)
				oxygen -= 10
		if(istype(F))
			if(F.oxygen-oxygen >= 10) //Определение небольшой разницы, дабы не зацикливать процессы при малейших отклонениях
				while(F.oxygen-oxygen > 10)
					sleep(1)
					F.move_gas(src)
			if(F.oxygen-oxygen <= -10)
				while(F.oxygen-oxygen < -10)
					sleep(1)
					move_gas(F)

/turf/simulated/proc/move_gas(var/turf/simulated/target) //Передвижение газа с турфа на турф
	oxygen--
	target.oxygen++
	for(var/obj/O in range(0,src)) if(!O.anchored) O.Move(target)
	for(var/mob/living/H in range(0,src)) H.Move(target)

/turf/simulated/proc/move_temperature(var/turf/simulated/A, var/turf/simulated/target) //Передвижение температуры с турфа на турф
	A.temperature--
	target.temperature++

/turf/simulated/proc/temperature_control()
	for(var/turf/T in orange(1, src))
		var/turf/space/S = T
		var/turf/simulated/floor/F = T
		if(!pass_gas) return
		if(istype(S)) if(temperature > S.temperature) temperature -= 10 //Температура и космос
		if(istype(F))
			if(F.temperature-(temperature-(temperature/gas_number)) >= 2.5)
				sleep(1)
				move_temperature(F,src)
			if(F.temperature-(temperature-(temperature/gas_number)) <= -4.5)
				sleep(1)
				move_temperature(src,F)