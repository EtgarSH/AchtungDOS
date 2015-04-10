IDEAL
MODEL small
STACK 100h
DATASEG
	
	; Graphic details
	last_video_mode db 0


	; First Player's details
	dot_x dw 0
	dot_y dw 0

	speed_x dw 0
	speed_y dw 0

	dot_color db 4

	; Second Player's details
	dot2_x dw 0
	dot2_y dw 0

	speed2_x dw 0
	speed2_y dw 0

	dot2_color db 0eh

	; Keyboard
	pressed_key db 0

	; strings:
	menu 	db "          Welcome to Achtung!", 10
			db "       Press Enter to start game,", 10
			db "          Press ESC to exit...", 10, "$"

	; Keys constants
	A_KEY equ 'a'
	D_KEY equ 'd'
	LEFT_KEY equ ','
	RIGHT_KEY equ '.'
	SPACEBAR_KEY equ 20h



CODESEG

include "MoveM.asm"

start:

	mov ax, @data
	mov ds, ax

	call GetVideoMode
	call EnterGraphicsMode

menu_creation:
	call EnterGraphicsMode
	call DrawFrame

	mov bh, 0
	mov dh, 10
	mov dl, 0
	mov ah, 2
	int 10h

	mov ah, 9
	mov dx, offset menu
	int 21h

menu_loop:
	call ReadKey

	cmp [pressed_key], 13
	jz game_creation

	cmp [pressed_key], 27
	jnz menu_loop
	jmp exit

game_creation:
	call EnterGraphicsMode

	mov [speed_x], 1
	mov [speed_y], 0
	mov [dot_x], 160
	mov [dot_y], 100

	mov [speed2_x], -1
	mov [speed2_y], 0
	mov [dot2_x], 120
	mov [dot2_y], 20

	call DrawFrame

gameloop:
	mov ah, 86h
	mov cx, 0
	mov dx, 9999h
	int 15h

	call ReadKey

	ConvertToMovement D_KEY, A_KEY, speed_x, speed_y
	UpdateDot dot_x, dot_y, speed_x, speed_y

	ConvertToMovement RIGHT_KEY, LEFT_KEY, speed2_x, speed2_y
	UpdateDot dot2_x, dot2_y, speed2_x, speed2_y

	mov cx, [dot_x]
	mov dx, [dot_y]
	call CheckLocation

	mov cx, [dot2_x]
	mov dx, [dot2_y]
	call CheckLocation

	PrintDot dot_x, dot_y, dot_color
	PrintDot dot2_x, dot2_y, dot2_color

	cmp [pressed_key], 27
	jz jump_menu_creation
; This is only because of the jump disability of 8086...
gameloop_continue:
	jmp gameloop
jump_menu_creation:
	jmp menu_creation


exit:
	call ReturnToLastVideoMode
	mov ax, 4c00h
	int 21h

proc ReadKey
	push ax
	push dx

	mov ah, 6
	mov dl, 0ffh
	int 21h

	mov [pressed_key], al

	pop dx
	pop ax
	ret
endp ReadKey

proc EnterGraphicsMode
	push ax

	mov ax, 13h
	int 10h
	pop ax

	ret
endp EnterGraphicsMode

proc GetVideoMode
	push ax

	mov ah, 0fh
	int 10h
	mov [last_video_mode], al

	pop ax
	ret
endp GetVideoMode

proc ReturnToLastVideoMode
	push ax

	mov ah, 00h
	;mov al, [last_video_mode]
	mov al, 3
	int 10h

	pop ax
	ret
endp ReturnToLastVideoMode

proc CheckLocation ; cx - x, dx - y 
	push bx
	push ax

	mov ah, 0dh
	xor bh, bh
	int 10h

	cmp al, 0
	jz @@return

	pop ax
	pop bx
	jmp menu_creation
@@return:
	pop ax
	pop bx
	ret
endp CheckLocation
include "graphics.asm"

end start