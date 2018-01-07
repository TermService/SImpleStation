proc/master_controller() //Многопоточный контроллер
	spawn() powernet_controller()
	spawn() AI_controller()
	spawn(10) master_controller()
