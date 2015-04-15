CODESEG

proc HowManyPlayersInGame
	push ax

	xor al, al ; counter of players

	UpdateRemPlayers al, dot_in_game, dot_name
	UpdateRemPlayers al, dot2_in_game, dot2_name

	mov [remaining_players], al

	pop ax
	ret
endp HowManyPlayersInGame


proc TryEnd ; using HowManyPlayersInGame procedure

	call HowManyPlayersInGame
	cmp [remaining_players], 1
	jnz @@return
	call EndGame
@@return:
	ret
endp TryEnd

proc EndGame
	push ax
	push dx
	push bx
@@end_game_creator:

	mov ah, 9
	mov dx, offset winner_msg
	int 21h

	mov bx, offset winner
	call PrintColoredString

	push cx
	mov cl, [pressed_key]
@@end_game_loop:
	call ReadKey
	cmp [pressed_key], ENTER_KEY
	jnz @@end_game_loop

	mov [pressed_key], cl
	pop cx
	pop bx
	pop dx
	pop ax
	jmp game_creation
endp EndGame