#SingleInstance force ; only 1 instance of this script may run at a time.
#InstallMouseHook
#InstallKeybdHook

CoordMode, Mouse, screen
CoordMode, Pixel, screen

Menu, Tray, Icon, imageres.dll, 90

; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; NOTE THAT YOU MUST ASSIGN \ (backslash) TO "Move playhead to cursor" IN PREMIERE'S KEYBOARD SHORTCUTS PANEL!
; YOU SHOULD ALSO ASSIGN CTRL ALT D to "DESELECT ALL" 
; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


;NOTE: I use the right mouse button for this because my current mouse does not have macro keys on it. Since you guys make gaming content as well, I assume you use gaming mice,
;which naturally don't give us many mouse buttons to edit with. I could use the middle mouse button, but it requires too much pressure to push down so often, and you 
;have to be careful not to accidentally scroll it. But if you want to use a button other than the right mouse button, the script becomes a lot simpler. 
;Scroll down to the bottom for that script.

;That is color 0x212121, and last I checked, it shows up in many other places in premiere, not just that part of the timeline.
;The easy solution is to just fill up your timeline with tracks; have no blank space.

;---------------------------------------------------------------------------------------

;First, we define all the timeline's DEFAULT possible colors.
;(Note that your colors will be different if you changed the UI brightness inside preferences > appearance > brightness.)
;I used Window Spy (it comes with AHK) to detect the exact colors onscreen.
timeline1 = 0x414141 ;timeline color inside the in/out points ON a targeted track
timeline2 = 0x313131 ;timeline color of the separating LINES between targeted AND non targeted tracks inside the in/out points
timeline3 = 0x1b1b1b ;the timeline color inside in/out points on a NON targeted track
timeline4 = 0x202020 ;the color of the bare timeline NOT inside the in out points
timeline5 = 0xDFDFDF ;the color of a SELECTED blank space on the timeline, NOT in the in/out points
timeline6 = 0xE4E4E4 ;the color of a SELECTED blank space on the timeline, IN the in/out points, on a TARGETED track
timeline7 = 0xBEBEBE ;the color of a SELECTED blank space on the timeline, IN the in/out points, on an UNTARGETED track


#IfWinActive ahk_exe Adobe Premiere Pro.exe ;exact name was gotten from windowspy
;--------EVERYTHING BELOW THIS LINE WILL ONLY WORK INSIDE PREMIERE PRO!----------

Rbutton::
MouseGetPos X, Y
PixelGetColor colorr, %X%, %Y%, RGB
if (colorr = timeline5 || colorr = timeline6 || colorr = timeline7) ;these are the timeline colors of a selected clip or blank space, in or outside of in/out points.
	send {ESC} ;in Premiere 13.0, ESCAPE will now deselect clips on the timeline, in addition to its other uses. i think it is good ot use here, now. But you can swap this out with CTRL SHIFT D if you like.
;send ^!d ;in Premiere, set CTRL ALT D to "DESELECT ALL"
if (colorr = timeline1 || colorr = timeline2 || colorr = timeline3 || colorr = timeline4 || colorr = timeline5 || colorr = timeline6 || colorr = timeline7) ;alternatively, i think I can use "if in" for this kind of thing..
{
	;BREAKTHROUGH -- it looks like a middle mouse click will BRING FOCUS TO a panel without doing ANYTHING ELSE like selecting or going through tabs or anything. Unfortunately, i still can't know with AHK which panel is already in focus.
	click middle ;sends the middle mouse button to BRING FOCUS TO the timeline, WITHOUT selecting any clips or empty spaces between clips. very nice!
	; tooltip, % GetKeyState("Rbutton", "P") ;<----this was essential for me to figure out EXACTLY how AHK wanted this query to be phrased. Why should i need the quotation marks?? Why does it return a 1 and 0, but for the other method, it returns U and D? Who the hell knows...
	; if GetKeyState("$Rbutton") = D ;<--- see, this line did not work AT ALL.
	if GetKeyState("Rbutton", "P") = 1 ;<----THIS is the only way to phrase this query.
		{
		;tooltip, we are inside the IF now
		;sleep 1000
		;tooltip,
		loop
			{
			Send \ ;in premiere, this must be set to "move playhead to cursor."

			sleep 16 ;this loop will repeat every 16 milliseconds.
			if GetKeyState("Rbutton", "P") = 0
				{
				;msgbox,,,time to break,1 ;I use message boxes when debugging, and then just comment the out rather than deleting them. It's just like disabling a clip in Premiere.
				tooltip,
				goto theEnd
				break
				}
			}
		}
	;tooltip,
	Send {escape} ;in case you end up inside the "delete" right click menu from the timeline
	;MouseClick, left ;notice how this is commented out. I deemed it inferior to using ESCAPE.
}
else
	sendinput {Rbutton} ;this is to make up for the lack of a ~ in front of Rbutton. ... ~Rbutton. It allows the command to pass through, but only if the above conditions were NOT met.
theEnd:
Return


;If you don't want to use Rbutton (the right mouse button), then you don't need to check for colors and things. This simplifies the script siginificantly.
;In the following script, You can change "Mbutton" to anything else. like "Xbutton1", or  even "F12" if you wanted.
;So, assuming you've mapped "move playhead to cursor" to the \ key, the problem is that it fires once, waits 1 second, and only then does it continue to fire.
;that's why I use a loop - to send constant keypresses, for a smooth experience.
;SCRIPT HAS NOT YET BEEN TESTED BY ME.

;;;;;Mbutton::\ ;<----this would be the STUPID way of doing this. BAD BAD BAD! do not want!
; #ifwinactive ahk_exe adobe premiere pro.exe
; Xbutton2::
; if GetKeyState("Xbutton2", "P") = 1
		; {
		; loop
			; {
			; Send \ ;in premiere, this must be set to "move playhead to cursor."
			; ;Tooltip, button 5 playhead mod!
			; sleep 16 ;this loop will repeat every 16 milliseconds.
			; if GetKeyState("Xbutton2", "P") = 0
				; {
				; ;msgbox,,,time to break,1
				; tooltip,
				; goto theEnd2
				; break
				; }
			; }
; }
; theEnd2:
; Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; F1 - ripple delete clip or blank at playhead
!+e::
Send v+f
return

----

#SingleInstance force ;only one instance of this script may run at a time!
#MaxHotkeysPerInterval 2000
Menu, Tray, Icon, shell32.dll, 303 ; this changes the tray icon to a little check mark!

;you know that extremely annoying dialouge box that says,
; "This action will delete existing keyframes. Do you want to continue?"
;Well, now you can auto-dismiss it. If only Adobe added some kind of feature to prevent this constant nuisance...

DetectHiddenText, On

lol:
WinWait, Warning ahk_exe Adobe Premiere Pro.exe
sendinput, {enter}
sleep 100
goto lol


----

Menu, Tray, Icon, shell32.dll, 110 ; changes the icon to a 🚫

;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#InstallKeybdHook
#NoEnv
;#NoTrayIcon ;comment this in if you do not want a tray icon.
#SingleInstance
#MaxHotkeysPerInterval 2000
Process, Priority, , H
SendMode Input
#SingleInstance force

;These next two lines are very important. You have to change the "menu mask key" away from being CTRL, to something that won't result in cross-talk. Read this thread to learn the details: https://autohotkey.com/boards/viewtopic.php?f=76&t=57683
#MenuMaskKey vk07  ; vk07 is unassigned. 
#UseHook


;Note that the script will add a little red 🚫 to your taskbar, which can be right clicked to be disabled or exited from the menu.

; You can hold down both ALT keys whenever you want to easily toggle this script on and off. This is useful for things like Premiere's keyboard shortcuts menu, which has ALT-nullification of its own.



;TO AUTO-START THIS SCRIPT WHEN WINDOWS STARTS:

; Once you've chosen a good folder location for the script, right click on it and choose "create shortcut." Then drag that shortcut into your startup folder! KEEP IN MIND that there are TWO startup folders - one for your user account, and one for ALL users. you can use either one. Here they are:

; THE SOLUTION IS LITERALLY JUST TWO LINES:


; ~LAlt::Sendinput {Blind}{sc0E9}
; ~RAlt::Sendinput {Blind}{sc0E9}

;;; I had no idea that {Blind} was a thing in AHK. Super helpful. 


;;;UPDATE: Those two lines totally work, but I am now trying a slightly different thing instead:

~LAlt::
Sendinput {Blind}{sc0E9}
KeyWait, LAlt ; 
Sendinput {Blind}{sc0EA}
return

~RAlt::
Sendinput {Blind}{sc0E9}
KeyWait, RAlt ; so that it doesn't keep spamming SC0E9
Sendinput {Blind}{sc0EA}
return
/*

~LAlt::
sendinput, {SC0E9 down} ;this is the scan code of an unassigned key. As long as you nor the system never use it for anything else, it can be used in THIS way to cancel the menu acceleration.
KeyWait, LAlt
return

~LAlt up::
sendinput, {SC0E9 up}
return

~RAlt::
;sendinput, {RAlt down}
sendinput, {SC0E9 down}
;;tooltip, Ralt is pressed
KeyWait, RAlt
;;tooltip, Ralt was released
return

~RAlt up::
;sendinput, {RAlt up}
sendinput, {SC0E9 up}
;;tooltip, 
return

*/

;;;;;;;alternatively, it might be as just 2 lines:

Lalt & Ralt::suspend ;hit both ALT keys simultaneously to toggle the functonality of this script. The tray icon will also change visually, so you will always know. You might want to delete this line if it's messing you up!



;;comment in the code below if you wish to reassign alt modifier combinations:



;!f::msgbox,,,To block modifier key use of alt you can do it like this,0.7
;!e::msgbox,,,replace msgbox with whatever code you want,0.7
;!w::msgbox,,,horray for having control of your own computer,0.7
;#ifWinActive ahk_exe Adobe Premiere Pro.exe


; ~!f::f
; !e::e
; !c::c
; !s::s
; !m::m
; !g::g
; !v::v
; !w::w
; !h::h

; 7B  058	#	d	0.64	F12            	
; 7B  058	 	u	0.08	F12            	
; 7B  058	#	d	0.41	F12            	
; 7B  058	 	u	0.08	F12            	
; A4  038	 	d	0.77	LAlt           	
; 07  000	i	d	0.00	not found      	
; 07  000	i	u	0.00	not found      	
; A4  038	i	u	0.00	LAlt           	
; 00  0E9	i	d	0.00	not found      	
; 07  000	i	d	0.00	not found      	
; A4  038	i	d	0.00	LAlt           	
; 07  000	i	u	0.00	not found      	
; A4  038	 	d	0.50	LAlt           	
; A4  038	 	d	0.03	LAlt           	
; A4  038	 	d	0.03	LAlt           	
; A4  038	 	d	0.03	LAlt           	
; A4  038	 	d	0.03	LAlt           	
; A4  038	 	u	0.03	LAlt           	
; 00  0E9	i	u	0.00	not found      	
; 35  006	#	d	2.48	5              	
; 35  006	 	u	0.06	5              	
; 13  045	h	d	1.72	Pause          	
; 13  045	s	u	0.06	Pause        

; with the new alt killer code that is only 2 lines... it doesn't even show up in here...
   	; ;no noise:
; 81  069	h	d	0.08	F18            	
; A4  038	i	d	0.00	LAlt           	
; A0  02A	i	d	0.00	LShift         	
; 35  006	i	d	0.00	5              	
; 35  006	i	u	0.00	5              	
; A4  038	i	u	0.00	LAlt           	
; A0  02A	i	u	0.00	LShift         	
; 1B  001	#	d	0.09	Escape         	
; 81  069	s	u	0.01	F18            	
; 1B  001	 	u	0.06	Escape         	
; 1B  001	#	d	0.06	Escape         	
; 1B  001	 	u	0.08	Escape         	
; 1B  001	#	d	0.06	Escape         

; ;;;and YES a noise:	
; 1B  001	 	u	0.09	Escape         	
; 1B  001	#	d	0.06	Escape         	
; 1B  001	 	u	0.06	Escape         	
; 1B  001	#	d	0.05	Escape         	
; 1B  001	 	u	0.08	Escape         	
; 81  069	h	d	0.09	F18            	
; A4  038	i	d	0.00	LAlt           	
; A0  02A	i	d	0.00	LShift         	
; 35  006	i	d	0.00	5              	
; 35  006	i	u	0.00	5              	
; A4  038	i	u	0.00	LAlt           	
; A0  02A	i	u	0.00	LShift         	
; 81  069	s	u	0.09	F18            	
; 13  045	h	d	1.64	Pause          	
; 13  045	s	u	0.08	Pause          	
; Press [F5] to refresh.

;;biggest differeence is that the firs tone has an escape down event still inside the F18 events. idk why.
;also the 2nd one has more milliseconds on the f18 up event. that's pretty much it.

#singleinstance force

#ifwinactive ahk_exe adobe premiere pro.exe

+x::
sendinput, ^+!x
sendinput, ^\
return
