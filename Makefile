NMML:=hxmario.nmml

build:buildhtml5 buildandroid buildflash buildlinux buildwindows

buildhtml5:
	haxelib run nme build $(NMML) html5
	neko html5bugfix.n bin/html5/bin/hxMario.js

buildandroid:
	haxelib run nme build $(NMML) android

buildflash:
	haxelib run nme build $(NMML) flash

buildlinux:
	haxelib run nme build $(NMML) linux

buildwindows:
	haxelib run nme build $(NMML) windows

html5: buildhtml5 runhtml5

android: buildandroid runandroid

flash: buildflash runflash

linux: buildlinux runlinux

windows: buildwindows runwindows

runhtml5:
	haxelib run nme run $(NMML) html5

runandroid:
	haxelib run nme run $(NMML) android

runflash:
	haxelib run nme run $(NMML) flash

runlinux:
	haxelib run nme run $(NMML) linux

runwindows:
	haxelib run nme run $(NMML) windows
