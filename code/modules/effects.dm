proc/dir4()
	return pick(NORTH, SOUTH, EAST, WEST)

proc/dir8()
	return pick(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)

//Аутоджоининг для турфов
turf/proc/autojoin(var_name, var_value = 1)
	var/n = 0
	var/turf/t
	t = locate(x, y + 1, z)
	if(t && t.vars[var_name] == var_value) n |= 1
	t = locate(x + 1, y, z)
	if(t && t.vars[var_name] == var_value) n |= 2
	t = locate(x, y - 1, z)
	if(t && t.vars[var_name] == var_value) n |= 4
	t = locate(x - 1, y, z)
	if(t && t.vars[var_name] == var_value) n |= 8
	return n