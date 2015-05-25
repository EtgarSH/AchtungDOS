;------------------------------------------
; File        : data.asm
; Parent      : achtung.asm
; Authors     : Etgar
; Description : This file contains the data of his parent.
;------------------------------------------

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
	menu 	db " Welcome to Achtung!", 10
			db "       Press Enter to start game,", 10
			db "          Press ESC to exit...", 10, "$"

	winner_msg db "&9The winner is: $"
	tie_msg db "&2Wow! It's &5tie! &2Awesome!$"

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
	;RandomLocation dot_x, dot_y
	mov [dot_x], 160
	mov [dot_y], 100

	mov [speed2_x], -1
	mov [speed2_y], 0
	;RandomLocation dot2_x, dot2_y
	mov [dot2_x], 120
	mov [dot2_y], 20

	mov [dot_in_game], 1
	mov [dot2_in_game], 1

	mov [remaining_players], 2
endm ResetData

; Not in use in this version
macro RandomLocation DOT_X, DOT_Y ; Generating a location for a dot
	push ax
	push dx

	; Random x
	RandomFF
	mov [DOT_X], ax

	; Random y
	RandomFF
	mov [DOT_Y], ax

	pop dx
	pop ax
endm RandomLocation

; Not in use in this version
macro RandomFF ; Random a number in ax of 16 bits
	mov ah, 2ch
	int 21h
	mov ax, dx
	and ax, 0ffh
	add ax, 256
endm RandomFF