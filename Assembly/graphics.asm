proc DrawFrame
	push ax
	push cx
	push di
	push es

	mov ax, 0a000h
	mov es, ax
	mov di, 0

	mov ax, 5
	mov cx, 1280 ; 320 * 4
	cld
	rep stosb

	mov di, 64000
	mov cx, 1280
	std
	rep stosb

	pop es
	pop di
	pop cx
	pop ax
	ret
endp DrawFrame

proc PrintDot
	push ax
	push bx
	push dx
	push cx

	mov ah, 0ch
	mov al, 6
	xor bh, bh
	mov cx, [dot_x]
	mov dx, [dot_y]
	int 10h

	pop cx
	pop dx
	pop bx
	pop ax
	ret
endp PrintDot

proc UpdateDot
	push ax

	mov ax, [dot_x]
	add ax, [speed_x]
	mov [dot_x], ax

	mov ax, [dot_y]
	add ax, [speed_y]
	mov [dot_y], ax

	pop ax
	ret
endp UpdateDot

proc MoveDotRight
	cmp [speed_x], 0
	jg MoveDotRightP_moving_right
	jl MoveDotRightP_moving_left

	cmp [speed_y], 0
	jg MoveDotRightP_moving_down
	jl MoveDotRightP_moving_up

MoveDotRightP_moving_right:
	mov [speed_x], 0
	mov [speed_y], 1
	jmp continue_moving_right
MoveDotRightP_moving_left:
	mov [speed_x], 0
	mov [speed_y], -1
	jmp continue_moving_right
MoveDotRightP_moving_up:
	mov [speed_x], 1
	mov [speed_y], 0
	jmp continue_moving_right
MoveDotRightP_moving_down:
	mov [speed_x], -1
	mov [speed_y], 0
	jmp continue_moving_right

continue_moving_right:
	ret
endp MoveDotRight

proc MoveDotLeft
	cmp [speed_x], 0
	jg MoveDotLeftP_moving_right
	jl MoveDotLeftP_moving_left

	cmp [speed_y], 0
	jg MoveDotLeftP_moving_down
	jl MoveDotLeftP_moving_up

MoveDotLeftP_moving_right:
	mov [speed_x], 0
	mov [speed_y], -1
	jmp continue_moving_left
MoveDotLeftP_moving_left:
	mov [speed_x], 0
	mov [speed_y], 1
	jmp continue_moving_left
MoveDotLeftP_moving_up:
	mov [speed_x], -1
	mov [speed_y], 0
	jmp continue_moving_left
MoveDotLeftP_moving_down:
	mov [speed_x], 1
	mov [speed_y], 0
	jmp continue_moving_left
continue_moving_left:
	ret
endp MoveDotLeft

proc ColorScreen ; al - color
	push cx
	push di
	push es

	push ax
	mov ax, 0a000h
	mov es, ax

	mov di, 0
	pop ax
	push ax
	mov ah, al
	mov cx, 32000
	cld
	rep stosw

	push ax
	pop es
	pop di
	pop cx
	ret
endp ColorScreen