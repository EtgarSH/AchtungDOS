	; Graphic details
	last_video_mode db 0

	in_game db 1
	; First Player's details
	dot_x dw 0
	dot_y dw 0

	speed_x dw 0
	speed_y dw 0

	dot_color db 3

	dot_name db "&3Bluebell$"

	dot_in_game db 1

	; Second Player's details
	dot2_x dw 0
	dot2_y dw 0

	speed2_x dw 0
	speed2_y dw 0

	dot2_color db 4h

	dot2_name db "&4Fred$"

	dot2_in_game db 1

	winner db 20 dup("$")
	remaining_players db 2
	; Keyboard
	pressed_key db 0

	; strings:
	menu 	db "          Welcome to Achtung!", 10
			db "       Press Enter to start game,", 10
			db "          Press ESC to exit...", 10, "$"

	winner_msg db "The winner is: $"

	; Keys constants
	ESCAPE_KEY equ 27
	ENTER_KEY equ 13
	A_KEY equ 'a'
	D_KEY equ 'd'
	LEFT_KEY equ ','
	RIGHT_KEY equ '.'
	SPACEBAR_KEY equ 20h

CODESEG
macro ResetData
	mov [in_game], 1

	mov [speed_x], 1
	mov [speed_y], 0
	mov [dot_x], 160
	mov [dot_y], 100

	mov [speed2_x], -1
	mov [speed2_y], 0
	mov [dot2_x], 120
	mov [dot2_y], 20

	mov [dot_in_game], 1
	mov [dot2_in_game], 1

	mov [remaining_players], 2
endm ResetData