.code
;-------------------------------------------------------------------------------------------------------------
Make_Sum proc
; int Make_Sum(int one_value, int another_value)
; RCX - one_value
; RDX - another_value

	mov eax, ecx
	add eax, edx

	ret

Make_Sum endp
;-------------------------------------------------------------------------------------------------------------
Get_Pos_Address proc
; RCX - screen_buffer
; RDX - pos

	; 1. Calculate addres_offset = (pos.Y_Pos * pos.Screen_Width + pos.X_Pos) * 4
	; 1.1.Calculate pos.Y * pos.Screen_Width
	mov rax, rdx
	shr rax, 16  ; AX = pos.Y_Pos
	movzx rax, ax  ; RAX = AX = pos.Y_Pos

	mov rbx, rdx
	shr rbx, 32  ; BX = pos.Screen_Width
	movzx rbx, bx  ; RBX = BX = pos.Screen_Width

	imul rax, rbx  ; RAX = RAX * RBX = pos.Y_Pos * pos.Screen_Width

	; 1.2. Add pos.X к RAX
	movzx rbx, dx  ; RBX = DX = pox.X_Pos
	add rax, rbx  ; RAX = pos.Y_Pos * pos.Screen_Width + pox.X_Pos = offset in characters

	; 1.3.  RAX contains the offset of the beginning of the line in characters, but it should be in bytes.
	; Because each character takes 4 bytes, you need to multiply this offset by 4
	shl rax, 2  ; RAX = RAX * 4 = addres_offset

	mov rdi, rcx  ; RDI = screen_buffer
	add rdi, rax  ; RDI = screen_buffer + addres_offset

	ret

Get_Pos_Address endp
;-------------------------------------------------------------------------------------------------------------
Draw_Line_Horizontal proc
; extern "C" void Draw_Line_Horizontal(CHAR_INFO *screen_buffer, SPos pos, CHAR_INFO symbol);
; RCX - screen_buffer
; RDX - pos
; R8 - symbol

	push rax
	push rbx
	push rcx
	push rdi

	; 1. Calculate the output address
	call Get_Pos_Address  ; RDI = character position in buffer screen_buffer in positions pos

	; 2. Outputting characters
	mov eax, r8d
	mov rcx, rdx
	shr rcx, 48  ; RCX = CX = pos.Len

	rep stosd

	pop rdi
	pop rcx
	pop rbx
	pop rax

	ret

Draw_Line_Horizontal endp
;-------------------------------------------------------------------------------------------------------------
Show_Colors proc
; extern "C" void Show_Colors(CHAR_INFO *screen_buffer, SPos pos, CHAR_INFO symbol);
; RCX - screen_buffer
; RDX - pos
; R8 - symbol

	push rax
	push rbx
	push rcx
	push rdi
	push r10
	push r11

	; 1. Calculate the output address
	call Get_Pos_Address  ; RDI = position character in buffer screen_buffer in positions pos

	mov r10, rdi

	; 2. Output Position Correction Calculation
	mov r11, rdx
	shr r11, 32  ; R11 = pos
	movzx r11, r11w  ; R11 = R11W = pos.Screen_Width
	shl r11, 2  ; R11 = pos.Screen_Width * 4 = Screen width in bytes

	; 3. Preparing cycles
	mov rax, r8  ; RAX = EAX = symbol

	; 3.1. Result of the AND command (logical "AND")
	; 0 & 0 = 0
	; 0 & 1 = 0
	; 1 & 0 = 0
	; 1 & 1 = 1

	and rax, 0ffffh  ; Reset all RAX bytes except 0 and 1
	mov rbx, 16

	xor rcx, rcx  ; RCX = 0

	; 0 XOR 0 = 0
	; 0 XOR 1 = 1
	; 1 XOR 0 = 1
	; 1 XOR 1 = 0

_0:
	mov cl, 16

_1:
	stosd
	add rax, 010000h  ; A unit shifted 16 bits to the left (i.e. the elementary step for attributes)

	loop _1

	add r10, r11
	mov rdi, r10

	dec rbx
	jnz _0

	pop r11
	pop r10
	pop rdi
	pop rcx
	pop rbx
	pop rax

	ret

Show_Colors endp
;-------------------------------------------------------------------------------------------------------------
end
