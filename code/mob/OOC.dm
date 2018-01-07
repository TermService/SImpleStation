//SETTINGS*start*//
/mob/living
	var/parallax_movement = 1
//SETTINGS*end*//

/mob/living/verb/Parallax_Movement()
	set category = "OOC"
	if(parallax_movement)
		to_chat(usr,"Движение параллакса выключено.")
		parallax_movement = 0
	else
		to_chat(usr,"Движение параллакса включено.")
		parallax_movement = 1

client/verb/who()
	set category = "OOC"
	set name = "Who"
	to_chat(mob,"---<br>На сервере:")
	var/num
	for(var/client/P)
		num++
		to_chat(mob,"[num]. [P]")
	to_chat(mob,"---")