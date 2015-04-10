IDEAL
MODEL small
STACK 100h
DATASEG
	last_video_mode db 0

	dot_x dw 0
	dot_y dw 0

	speed_x dw 0
	speed_y dw 0

	pressed_key db 0

	; strings:
	menu 	db "          Welcome to Achtung!", 10
			db "       Press Enter to start game,", 10
			db "          Press ESC to exit...", 10, "$"

	A_KEY equ 'a'
	D_KEY equ 'd'
	SPACEBAR_KEY equ 20h


CODESEG
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

	call DrawFrame

gameloop:
	mov ah, 86h
	mov cx, 0
	mov dx, 9999h
	int 15h

	call ReadKey
	call ConvertToMovement
	call UpdateDot

	mov cx, [dot_x]
	mov dx, [dot_y]
	call CheckLocation

	cmp [pressed_key], SPACEBAR_KEY
	jz SpaceDot1
	call PrintDot
SpaceDot1:
	cmp [pressed_key], 27
	jnz gameloop
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

proc ConvertToMovement
	cmp [pressed_key], D_KEY
	jz d_key_pressed

	cmp [pressed_key], A_KEY
	jz a_key_pressed

	jmp continue_ConvertToMovement

d_key_pressed:
	call MoveDotRight
	jmp continue_ConvertToMovement
a_key_pressed:
	call MoveDotLeft
	jmp continue_ConvertToMovement

continue_ConvertToMovement:
	ret
endp ConvertToMovement

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
	jz return_CheckLocationProc

	pop ax
	pop bx
	jmp menu_creation
return_CheckLocationProc:
	pop ax
	pop bx
	ret
endp CheckLocation
include "graphics.asm"

end start