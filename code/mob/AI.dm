proc/AI_controller()
	for(var/mob/living/critter/monkey/M in creatures)
		if(M.key || M.state == "DEAD") return
		sleep(1)
		M.monkeyAI()

/mob/living/critter/proc/monkeyAI()
	if(prob(55)) step(src,pick(directions)) //� ������������ � 55 ��������� ��� ������� ��� � ���� �� ������� ������
	if(prob(2)) poo()
