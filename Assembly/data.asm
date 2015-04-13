	; Graphic details
	last_video_mode db 0


	; First Player's details
	dot_x dw 0
	dot_y dw 0

	speed_x dw 0
	speed_y dw 0

	dot_color db 3

	dot_in_game db 1

	; Second Player's details
	dot2_x dw 0
	dot2_y dw 0

	speed2_x dw 0
	speed2_y dw 0

	dot2_color db 4h

	dot2_in_game db 1

	winner db 10 dup("$")

	; Keyboard
	pressed_key db 0

	; strings:
	menu 	db "          Welcome to Achtung!", 10
			db "       Press Enter to start game,", 10
			db "          Press ESC to exit...", 10, "$"

	; Keys constants
	ESCAPE_KEY equ 27
	ENTER_KEY equ 13
	A_KEY equ 'a'
	D_KEY equ 'd'
	LEFT_KEY equ ','
	RIGHT_KEY equ '.'
	SPACEBAR_KEY equ 20h