/obj/structures/closets
	icon = 'closets.dmi'
	var/closed = 1
	var/mycloset = "" //Сюда пихают первую часть icon_state'a
	var/transparent = 0 //Если эта переменная больше нуля - в шкаф можно будет заходить
	var/list/obj/item/container = list()
	density = 1
	layer = 4
	New() for(var/obj/items/I in loc) I.Move(src)

/obj/structures/closets/closet
	name = "closet"
	icon_state = "closet_closed"
	mycloset = "closet"
	transparent = 1

/obj/structures/closets/attack_hand(var/mob/living/H)
	proceed()

/obj/structures/closets/act_by_item(var/mob/living/H = usr, var/obj/items/I)
	if(!closed)
		I.loc = src.loc
		H.cut_hands()
		I.layer = 4
	else proceed() //Если шкаф закрыт и по нему тыкают предметом - шкаф открывается

/obj/structures/closets/proc/proceed()
	playsound('click.ogg')
	if(closed) open()
	else close()

/obj/structures/closets/proc/open()
	icon_state = "[mycloset]_opened"
	closed = 0
	if(transparent) density = 0
	for(var/obj/items/I in contents)
		I.Move(src.loc)
		I.layer = 4

/obj/structures/closets/proc/close()
	icon_state = "[mycloset]_closed"
	closed = 1
	density = 1
	for(var/obj/items/I in loc) I.Move(src)