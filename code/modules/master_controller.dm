proc/master_controller() //������������� ����������
	spawn() powernet_controller()
	spawn() AI_controller()
	spawn(10) master_controller()
