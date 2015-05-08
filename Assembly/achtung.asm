;               _     _                     _____   ____   _____ 
;     /\       | |   | |                   |  __ \ / __ \ / ____|
;    /  \   ___| |__ | |_ _   _ _ __   __ _| |  | | |  | | (___  
;   / /\ \ / __| '_ \| __| | | | '_ \ / _` | |  | | |  | |\___ \ 
;  / ____ \ (__| | | | |_| |_| | | | | (_| | |__| | |__| |____) |
; /_/    \_\___|_| |_|\__|\__,_|_| |_|\__, |_____/ \____/|_____/ 
;                                      __/ |                     
;                                     |___/                      

;------------------------------------------
; File        : achtung.asm
; Authors     : Etgar
; Description : This is a game for DOS. A very addective game. Try it by yourself.
;------------------------------------------

IDEAL
MODEL small
STACK 100h
DATASEG

include "data.asm"

CODESEG

include "MoveM.asm"
include "LogicM.asm"

start:

	mov ax, @data
	mov ds, ax

	call EnterGraphicsMode

menu_creation:
	call EnterGraphicsMode
	call DrawFrame

	call MoveCursorToCenter

	; Print the menu message
	mov ah, 9
	mov dx, offset menu
	int 21h

menu_loop:
	call ReadKey

	cmp [pressed_key], ENTER_KEY
	jz game_creation

	cmp [pressed_key], ESCAPE_KEY
	jnz menu_loop
	jmp exit

game_creation:
	call EnterGraphicsMode

	ResetData

	call DrawFrame

gameloop:
	mov ah, 86h
	mov cx, 0
	mov dx, 9999h
	int 15h

	call ReadKey

	; Convert the players' input to their movement.
	ConvertToMovement D_KEY, A_KEY, speed_x, speed_y ; See more documentation in "MoveM.asm"
	UpdateDot dot_x, dot_y, speed_x, speed_y ; See more documentation in "MoveM.asm"

	ConvertToMovement RIGHT_KEY, LEFT_KEY, speed2_x, speed2_y
	UpdateDot dot2_x, dot2_y, speed2_x, speed2_y

	; Check if the players had crashed.
	CheckLocation dot_x, dot_y, dot_in_game
	CheckLocation dot2_x, dot2_y, dot2_in_game

	PrintDot dot_x, dot_y, dot_color
	PrintDot dot2_x, dot2_y, dot2_color

	call TryEnd ; See documentation in "LogicP.asm"

	cmp [pressed_key], ESCAPE_KEY
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

; Return to the Text Mode
proc ReturnToLastVideoMode
	push ax

	mov ah, 00h
	mov al, 3
	int 10h

	pop ax
	ret
endp ReturnToLastVideoMode

include "graphics.asm"
include "LogicP.asm"

end start