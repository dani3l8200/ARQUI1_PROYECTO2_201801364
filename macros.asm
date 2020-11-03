printArray MACRO array
	           LOCAL start
	start:     
	           mov   ah, 09h
	           mov   dx, @data
	           mov   ds, dx
	           mov   dx, offset array
	           int   21h
ENDM

print MACRO cadena
	      LOCAL start
	start:
	      mov   ah, 09h
	      mov   dx, offset cadena
	      int   21h
ENDM

printChar MACRO char
	          LOCAL start
	start:    
	          mov   ah, 02h
	          mov   dl, char
	          int   21h
ENDM

getLinea MACRO buffer
	         LOCAL   start, endL
	         mov     si, 0
	start:   
	         getChar
	         cmp     al, 0dh
	         je      endL
	         mov     buffer[si], al
	         inc     si
	         jmp     start
	endL:    
	         mov     buffer[si], '$'
ENDM

ReadKeyPad MACRO
	           MOV AH, 01h	;se pone en modo lectura de caracteres
	           int 21h    	;para el kernel de dos
ENDM

getChar MACRO
	        mov ah, 0dh
	        int 21h
	        mov ah, 01h
	        int 21h
ENDM

clean MACRO buffer, numBytes, character
	          LOCAL cleanLoop
	          xor   bx, bx
	          xor   cx, cx
	          mov   cx, numBytes
	cleanLoop:
	          mov   buffer[bx], character
	          inc   bx
	          LOOP  cleanLoop
ENDM

delay MACRO constant
	         LOCAL delay1, delay2, endDelay
	         PUSH  SI
	         PUSH  DI
	         mov   si, 0
	         mov   di, 0
	         mov   si, constant
	delay1:  
	         dec   si
	         jz    endDelay
	         mov   di, constant
	delay2:  
	         dec   di
	         jnz   delay2
	         jmp   delay1
	endDelay:
	         POP   di
	         POP   si
ENDM
;drawBall
pintaBolita MACRO pos, color
	            push dx
	            mov  di, pos
	            mov  dl, color
	            mov  es:[di+0], dl
	            mov  es:[di+1], dl
	            mov  es:[di+2], dl
	            mov  es:[di+320], dl
	            mov  es:[di+321], dl
	            mov  es:[di+322], dl
	            mov  es:[di+640], dl
	            mov  es:[di+641], dl
	            mov  es:[di+642], dl
	            pop  dx
ENDM
;drawBlockedededededeb2
dibujarBloques MACRO pos, color
	               LOCAL whileBlock
	               PUSH  dx
	               PUSH  cx
	               mov   cx,  0
	               mov   cx, pos
	               add   cx, 48
	               mov   di, pos
	               mov   dl, color
	whileBlock:    
	               mov   es:[di+0], dl
	               mov   es:[di+320], dl
	               mov   es:[di+640], dl
	               mov   es:[di+960], dl
	               mov   es:[di+1280], dl
	               mov   es:[di+1600], dl
	               inc   di
	               cmp   di, cx
	               jne   whileBlock
	               pop   cx
	               pop   dx
ENDM
;drawBar
dibujarBarraJuego MACRO pos, color
	                  LOCAL whileBar
	                  push  dx
	                  push  cx
	                  mov   cx, 0
	                  mov   cx, pos
	                  add   cx, 32
	                  mov   di, pos
	                  mov   dl, color
	whileBar:         
	                  mov   es:[di+0], dl
	                  mov   es:[di+320], dl
	                  mov   es:[di+640], dl
	                  inc   di
	                  cmp   di, cx
	                  jne   whileBar
	                  pop   cx
	                  pop   dx
ENDM 

clearString MACRO buffer
	            LOCAL      repeatClear
	            SetData
	            mov        si, 0
	            mov        cx, 0
	            mov        cx, SIZEOF buffer

	repeatClear:
	            mov        buffer[si], '$'
	            inc        si
	            LOOP       repeatClear
	            RemoveData
ENDM

SetData MACRO
	        PUSH AX
	        PUSH BX
	        PUSH CX
	        PUSH DX
	        PUSH SI
	        PUSH DI
ENDM

RemoveData MACRO
	           POP DI
	           POP SI
	           POP DX
	           POP CX
	           POP BX
	           POP AX
ENDM