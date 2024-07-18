all:
	@echo Choose between install and uninstall

install:
	# install -m 440 ./root/etc/sudoers.d/setkeycodes /etc/sudoers.d
	install -m 440 ./root/etc/udev/hwdb.d/70-acer.hwdb /etc/udev/hwdb.d/
	systemd-hwdb update
	udevadm trigger

uninstall:
	# rm /etc/sudoers.d/setkeycodes
	rm /etc/udev/hwdb.d/70-acer.hwdb
	systemd-hwdb update
	udevadm trigger