	;proc para mostar el punteo del juego
showNumber PROC
	                                cmp               bx, 10
	                                jl                showNumber_Unidades
	                                cmp               bx, 100
	                                jl                showNumber_Decenas
	                                jmp               showNumber_Centenas
	showNumber_Unidades:            
	                                add               bl, 30h
	                                mov               dh, 48
	                                mov               ch, bl
	                                mov               cl, 48
	                                jmp               showNumberEnd
	showNumber_Decenas:             
	                                xor               ax, ax
	                                mov               ax, bx
	                                xor               bx, bx
	                                mov               bx, 0ah
	                                div               bl
	                                xor               cx, cx
	                                mov               ch, ah
	                                mov               cl, al
	                                xor               ax, ax
	                                mov               al, cl
	                                div               bl
	                                mov               cl, ah
	                                mov               dh, 48
	                                add               ch, 30h
	                                add               cl, 30h
	                                jmp               showNumberEnd
	showNumber_Centenas:            
	                                xor               ax, ax
	                                mov               ax, bx
	                                xor               bx, bx
	                                mov               bx, 0ah
	                                div               bl
	                                xor               cx, cx
	                                mov               ch, ah
	                                mov               cl, al
	                                xor               ax, ax
	                                mov               al, cl
	                                div               bl
	                                mov               cl, ah
	                                xor               dx, dx
	                                mov               dl, al
	                                xor               ax, ax
	                                mov               al, dl
	                                div               bl
	                                mov               dh ,ah
	                                add               dh, 30h
	                                add               ch, 30h
	                                add               cl, 30h
	                                jmp               showNumberEnd
	showNumberEnd:                  
	                                ret
showNumber ENDP


	;proc para modo texto
modoTexto PROC
	                                mov               ah, 00h
	                                mov               al, 03h
	                                int               10h
	                                ret
modoTexto ENDP

	;proc para cargar la ubicacion donde se encontrara el archivo top xd
LoadPathTop PROC
	                                mov               ubicacionRankingArchivo[0], 74h
	                                mov               ubicacionRankingArchivo[1], 6fh
	                                mov               ubicacionRankingArchivo[2], 70h
	                                mov               ubicacionRankingArchivo[3], 2eh
	                                mov               ubicacionRankingArchivo[4], 74h
	                                mov               ubicacionRankingArchivo[5], 78h
	                                mov               ubicacionRankingArchivo[6], 74h
LoadPathTop ENDP

	;procedimiento para la carga de los archivos
LoadUsers PROC
	                                mov               ubicacionJugadores[0], 70h                                  	;p
	                                mov               ubicacionJugadores[1], 6ch                                  	;l
	                                mov               ubicacionJugadores[2], 61h                                  	;a
	                                mov               ubicacionJugadores[3], 79h                                  	;y
	                                mov               ubicacionJugadores[4], 65h                                  	;e
	                                mov               ubicacionJugadores[5], 72h                                  	;r
	                                mov               ubicacionJugadores[6], 73h                                  	;s
	                                mov               ubicacionJugadores[7], 2eh                                  	;.
	                                mov               ubicacionJugadores[8], 74h                                  	;t
	                                mov               ubicacionJugadores[9], 78h                                  	;x
	                                mov               ubicacionJugadores[10], 74h
	                                mov               ubicacionJugadores[11], 00h                                 	;t
	                                ret
LoadUsers ENDP