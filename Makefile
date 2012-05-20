NMML:=hxmario.nmml

build:buildhtml5 buildandroid buildflash buildlinux buildwindows

buildhtml5:
	haxelib run nme build $(NMML) html5
	cp -R data/map bin/html5/bin/data

buildandroid:
	haxelib run nme build $(NMML) android
	cp -R data/map bin/android/bin/data

buildflash:
	haxelib run nme build $(NMML) flash
	cp -R data/map bin/flash/bin/data

buildlinux:
	haxelib run nme build $(NMML) linux
	cp -R data/map bin/cpp/linux/bin/data

buildwindows:
	haxelib run nme build $(NMML) windows
	cp -R data/map bin/neko/windows/bin/data

html5: buildhtml5
	haxelib run nme run $(NMML) $@

android: buildandroid
	haxelib run nme run $(NMML) $@

flash: buildflash
	haxelib run nme run $(NMML) $@

linux: buildlinux
	haxelib run nme run $(NMML) $@

windows: buildwindows
	haxelib run nme run $(NMML) $@

