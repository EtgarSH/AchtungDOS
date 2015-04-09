IDEAL
MODEL small
STACK 100h
DATASEG
	last_video_mode db 0

	dot_x dw 380
	dot_y dw 380

	speed_x dw 0
	speed_y dw 0

	pressed_key db 0

	LEFT_KEY equ 'a'
	RIGHT_KEY equ 'd'

CODESEG

start:
	mov ax, @data
	mov ds, ax

	call GetVideoMode
	call EnterGraphicsMode

gameloop:
	mov ah, 86h
	mov cx, 0
	mov dx, 9999h
	int 15h

	call ReadKey
	call ConvertToMovement
	call MoveDot
	call PrintDot

	cmp [pressed_key], 27
	jnz gameloop


exit:
	call ReturnToLastVideoMode
	mov ax, 4c00h
	int 21h

proc Delay
	
endp Delay

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
	cmp [pressed_key], RIGHT_KEY
	jz right_key_pressed

	cmp [pressed_key], LEFT_KEY
	jz left_key_pressed

	jmp continue_ConvertToMovement

right_key_pressed:
	call MoveDotRight
	jmp continue_ConvertToMovement
left_key_pressed:
	call MoveDotLeft
	jmp continue_ConvertToMovement

continue_ConvertToMovement:
	ret
endp ConvertToMovement

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

proc MoveDot
	push ax

	mov ax, [dot_x]
	add ax, [speed_x]
	mov [dot_x], ax

	mov ax, [dot_y]
	add ax, [speed_y]
	mov [dot_y], ax

	pop ax
	ret
endp MoveDot

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

end start