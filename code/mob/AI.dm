proc/AI_controller()
	for(var/mob/living/critter/monkey/M in creatures)
		if(M.key || M.state == "DEAD") return
		sleep(1)
		M.monkeyAI()

/mob/living/critter/proc/monkeyAI()
	if(prob(55)) step(src,pick(directions)) //С вероятностью в 55 процентов моб сделает шаг в одну из четырех сторон
	if(prob(2)) poo()
