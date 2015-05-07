;------------------------------------------
; File        : LogicM.asm
; Parent      : achtung.asm
; Authors     : Etgar
; Description : This file contains the game's logical ideas procedures.
;------------------------------------------

CODESEG

; Returns how many players remained in the game
proc HowManyPlayersInGame
	push ax

	xor al, al ; counter of players

	UpdateRemPlayers al, dot_in_game, dot_name
	UpdateRemPlayers al, dot2_in_game, dot2_name

	mov [remaining_players], al

	pop ax
	ret
endp HowManyPlayersInGame

; Check if there is a winner. If so, ends the game.
proc TryEnd ; using HowManyPlayersInGame procedure

	call HowManyPlayersInGame
	cmp [remaining_players], 1
	ja @@return
	call EndGame
@@return:
	ret
endp TryEnd

proc EndGame
	push ax
	push dx
	push bx
@@end_game_creator:
	call MoveCursorToCenter



	mov bx, offset winner_msg
	call PrintColoredString

	mov bx, offset winner
	call PrintColoredString

	push cx
	mov cl, [pressed_key]
@@end_game_loop:
	call ReadKey

	cmp [pressed_key], ESCAPE_KEY
	jz @@back_to_menu

	cmp [pressed_key], ENTER_KEY
	jnz @@end_game_loop

	mov [pressed_key], cl
	pop cx
	pop bx
	pop dx
	pop ax
	jmp game_creation
@@back_to_menu:
	pop cx
	pop bx
	pop dx
	pop ax
	jmp menu_creation
endp EndGame