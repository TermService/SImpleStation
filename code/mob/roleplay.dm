proc/to_chat(target,message) //����� ��������� � ���
	var/index = findtext(message, "�")
	while(index) //���� � ������ ���� "�" - ����� ���������� �������� ��� ����� �� "&#255;"
		message = copytext(message, 1, index) + "&#255;" + copytext(message, index+1)
		index = findtext(message, "�")
	target << message

/atom/proc/msg(message, vision_distance)
	var/tiles = 7
	if(vision_distance) tiles = vision_distance
	for(var/mob/M in view(tiles,src)) to_chat(M,message)

/mob/living
	var/cantalk = 1

/mob/living/verb/Say(message as text)
	set category = "IC"
	if(!cantalk||!message||message == ""||message == " ") return
	msg("<B>[name]</B> �������, \"[message]\"")
	cantalk = 0
	spawn(4) cantalk = 1

/mob/living/verb/Emote(emotion as text)
	set category = "IC"
	if(!cantalk||!emotion||emotion == ""||emotion == " ") return
	msg("<B>[name]</B> [emotion]")
	cantalk = 0
	spawn(4) cantalk = 1