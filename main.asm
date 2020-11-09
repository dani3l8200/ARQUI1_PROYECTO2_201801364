include  macros.asm
include files.asm
.model small 

.stack 100h

.data
	;********************************************************************* INTERFAZ *****************************************************************
	margenStart             db '========================================================', 0aH, 0dH, '$'
	messageWelcome          db '*  UNIVERSIDAD DE SAN CARLOS DE GUATEMALA              *', 0aH, 0dH, '*  FACULTAD DE INGENIERIA                              *', 0aH, 0dH, '*  CIENCIAS Y SISTEMAS                                 *', 0aH, 0dH, '*  ARQUITECTURA DE COMPUTADORES Y EMSAMBLADORES 1      *', 0aH, 0dH, '*  NOMBRE: JUAN DANIEL ENRIQUE ROMAN BARRIENTOS        *', 0aH, 0dH, '*  CARNET: 201801364                                   *', 0aH, 0dH,  '$'
	margenEnd               db '*  SECCION: A                                          *', 0aH,  0dH, '*                      PROYECTO 2                      *', 0aH, 0dH, '********************************************************', 0aH , 0dH, '$'
	messageOptionStart      db '*  1) INGRESAR                                         *', 0aH, 0dH, '*  2) REGISTRAR                                        *', 0ah, 0dh, '*  3) SALIR                                            *', 0ah, 0dh, '*                                                      *', 0ah, 0dh, '*  :\> SELECT A OPTION: ','$'
	messageOptionEnd        db '                              *', 0ah, 0dh,'========================================================', 0ah, 0dh, '$'
	messageJoker            db 'Sale En vacas',0ah,0dh,'$'
	messageLogin            db 0ah,0dh,0ah,0ah,'======================== LOGIN =========================',0ah,0ah,0dh,'>>NICKNAME: ','$'
	messageRegistro         db 0ah,0dh,0ah,0ah,'======================== REGISTRO ======================',0ah,0ah,0dh,'>>NICKNAME: ','$'
	messagePassword         db 0ah,0dh,'>>PASSWORD: ','$'
	messageEnd              db 0ah,0dh,'$'
	messageErrorOpen        db 0ah, 0dh, '  ERROR: Not is possible open this file', '$'
	messageErrorCreate      db 0ah, 0dh, '  ERROR: Not is possible create the file', '$'
	messageErrorWrite       db 0ah, 0dh, '   ERROR: Not is possible write in the file', '$'
	messageErrorDelete      db 0ah, 0dh, '  ERROR: Not is possible delete the file', '$'
	messageErrorRead        db 0ah, 0dh, '  ERROR: Not is possible read the file', '$'
	messageErrorClose       db 0ah, 0dh, '  ERROR: Not is possible close the file', '$'
	messageSuccessPath      db 0ah, 0dh, '  File read successfully :)',0ah,0dh, '$'
	messagePivote           db 0ah, 0dh, 'entro aqui', 0ah,0dh, '$'
	;*********************************************************************** END INTERFAZ ************************************************************
	;*********************************************************************** Declaracion y Asignacion de Variables ******************************************
	nicknames               db 7 dup('$')
	password                db 5 dup('$')
	ubicacionJugadores      db 16 dup('$')
	handleFile              dw ?
	currentTime             dw 0
	time                    dw 0
	terceraBall             dw 0
	segundaBall             dw 0
	primeraBall             dw 0
	currentLevel            db 0
	finalScore              db 0
	finalTime               db 0
	delayGamePlay           db 0
	primerCuadrante         db 0
	segundoCuadrante        db 0
	tercerCuadrante         db 0
	swapBall                db 0
	players                 db 300 dup('$')
	info                    db 8 dup('$')
	levelone                db 12 dup('$')
	leveltwo                db 24 dup('$')
	levelthree              db 36 dup('$')
	ubicacionRankingArchivo db 16 dup('$')
	startLevel              db 0
    ;*********************************************************************** END Declaracion ******************************************************************
.code
	;procedimiento donde va ir el menu de inicio y sus acciones para que empiece el juego uwu
main PROC
	         
	MenuGame:                       
	                                printArray        margenStart
	                                printArray        messageWelcome
	                                printArray        margenEnd
	                                printArray        messageOptionStart
	                                xor               ax,ax
	                                getChar
	                                printArray        messageOptionEnd
	                                cmp               al,49
	                                je                Op1
	                                cmp               al,50
	                                je                Op2
	                                cmp               al,51
	                                je                EXIT
	                                jmp               MenuGame
	Op1:                            
	                                call              login
	                                jmp               MenuGame
	Op2:                            
	                                call              registro
	                                jmp               MenuGame
	Exit:                           
	                                mov               ah,4ch
	                                int               21h
    
main ENDP
	;NOTA: algo curioso que me di cuenta cuando hacia el proyecto es que las macros no pueden tenner mucho codigo
	;por lo que mejor use procedimientos, que cosas no xD

	;procedimiento para el login xd
login PROC
	                                printArray        messageLogin
	                                getLinea          nicknames
	                                printArray        messagePassword
	                                getLinea          password
	                                clean             ubicacionJugadores, SIZEOF ubicacionJugadores, 24h
	                                clean             players, SIZEOF players, 24h
	                                call              LoadUsers
	                                clean             handleFile, SIZEOF handleFile, 24h
	                                openFile          ubicacionJugadores, handleFile
	                                readFile          players, handleFile, SIZEOF players
	                                closeFile         handleFile
	                                xor               si, si
	SearchingLoop:                  
	                                push              si
	                                xor               di, di
	                                xor               cx, cx
	NicknameVerification:           
	                                mov               bl, nicknames[di]
	                                mov               bh, players[si]
	                                cmp               bl, bh
	                                je                NicknameVerificationCounter
	                                jmp               NicknameVerificationContinue
	NicknameVerificationCounter:    
	                                inc               cx
	NicknameVerificationContinue:   
	                                inc               si
	                                inc               di
	                                cmp               di, 7
	                                jne               NicknameVerification
	                                cmp               cx, 7
	                                je                NicknameVerificationSuccess
	                                jmp               EndSearchingLoop
	NicknameVerificationSuccess:    
	                                printArray        messagePivote
	                                inc               si
	                                xor               di, di
	                                xor               cx, cx
	PasswordVerification:           
	                                mov               bl, password[di]
	                                mov               bh, players[si]
	                                cmp               bl, bh
	                                je                PasswordVerificationCounter
	                                jmp               PasswordVerificationContinue
	PasswordVerificationCounter:    
	                                inc               cx
	PasswordVerificationContinue:   
	                                inc               si
	                                inc               di
	                                cmp               di,5
	                                jne               PasswordVerification
	                                cmp               cx,5
	                                je                PasswordVerificationSuccess
	                                jmp               EndSearchingLoop
	PasswordVerificationSuccess:    
	                                pop               si
	IsAdmin:                        
	                                mov               bl, nicknames[0]
	                                cmp               bl, 97
	                                je                IsAdminAT
	                                jmp               NotAdmin
	IsAdminAT:                      
	                                mov               bl, nicknames[1]
	                                cmp               bl, 100
	                                je                IsAdminDT
	                                jmp               NotAdmin
	IsAdminDT:                      
	                                mov               bl, nicknames[2]
	                                cmp               bl, 109
	                                je                IsAdminMT
	                                jmp               NotAdmin
	IsAdminMT:                      
	                                mov               bl, nicknames[3]
	                                cmp               bl, 105
	                                je                IsAdminIT
	                                jmp               NotAdmin
	IsAdminIT:                      
	                                mov               bl, nicknames[4]
	                                cmp               bl, 110
	                                je                IsAdminSAT
	                                jmp               NotAdmin
	IsAdminSAT:                     
	                                mov               bl, nicknames[5]
	                                cmp               bl, 65
	                                je                IsAdminTPT
	                                jmp               NotAdmin
	IsAdminTPT:                     
	                                mov               bl, nicknames[6]
	                                cmp               bl, 80
	                                printArray        messageJoker
	                                jmp               EndLogin
	NotAdmin:                       
	                                clean             info, SIZEOF info, 24h
	                                mov               bl, nicknames[0]
	                                mov               info[0], bl
	                                mov               bl, nicknames[1]
	                                mov               info[1], bl
	                                mov               bl, nicknames[2]
	                                mov               info[2], bl
	                                mov               bl, nicknames[3]
	                                mov               info[3], bl
	                                mov               bl, nicknames[4]
	                                mov               info[4], bl
	                                mov               bl, nicknames[5]
	                                mov               info[5], bl
	                                mov               bl, nicknames[6]
	                                mov               info[6], bl
	                                mov               info[7], 24h
	                                call              modoGrafico
	                                push              ds
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 5
	                                int               10h
	                                printArray        info
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 14
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, 76
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 15
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, 49
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                pop               ds
	                                call              dibujarMargen
	                                call              iniciarJuego1
	                                call              modoTexto
	                                jmp               EndLogin
	EndSearchingLoop:               
	; printArray messageSuccessPath
	                                pop               si
	                                add               si, 14
	                                cmp               si, 300
	                                jne               SearchingLoop
	EndLogin:                       
	                                ret
login ENDP

	;proc utilizado para realiza el registro de usuarios
registro PROC
	                                printArray        messageRegistro
	                                clean             nicknames, SIZEOF nicknames, 24h
	                                getLinea          nicknames
	                                printArray        messagePassword
	                                clean             password, SIZEOF password, 24h
	                                getLinea          password
	                                clean             ubicacionJugadores, SIZEOF ubicacionJugadores, 24h
	                                call              LoadUsers
	                                clean             handleFile, SIZEOF handleFile, 24h
	                                clean             players, SIZEOF players, 24h
	                                openFile          ubicacionJugadores, handleFile
	                                readFile          players, handleFile, SIZEOF players
						
	                                xor               si, si
	NuevoJugador:                   
	                                mov               bl, players[si]
	                                inc               si
	                                cmp               bl, 2fh
	                                jne               NuevoJugador
	                                dec               si
	                                mov               players[si], 3bh
	                                inc               si
	                                xor               di, di
	NuevoUser:                      
	                                mov               bl, nicknames[di]
	                                mov               bh, bl
	                                mov               players[si], bh
	                                inc               si
	                                inc               di
	                                cmp               di, 7
	                                jne               NuevoUser
	NuevoUserContinue:              
	                                mov               players[si], 2ch
	                                inc               si
	                                xor               di,di
	AddPassword:                    
	                                mov               bl, password[di]
	                                mov               bh, bl
	                                mov               players[si], bh
	                                inc               si
	                                inc               di
	                                cmp               di, 5
	                                jne               AddPassword
	AddPasswordContinue:            
	                                mov               players[si], 2fh
	                                printArray        messageEnd
	                                closeFile         handleFile
	                                clean             handleFile, SIZEOF handleFile, 24h
	                                clean             ubicacionJugadores, SIZEOF ubicacionJugadores, 24h
	                                call              LoadUsers
								 
	                                createFile        ubicacionJugadores, handleFile
	                                writeFile         handleFile, SIZEOF players, players
	                                closeFile         handleFile
	                                ret
registro ENDP

	;proc para el modo grafico
modoGrafico PROC
	                                mov               ah, 00h
	                                mov               al, 13h
	                                int               10h
	                                mov               ax, 0A000h
	                                mov               es, ax
	                                ret
modoGrafico ENDP

	;proc para dibujar el margen
dibujarMargen PROC
	                                mov               dl, 1
	                                mov               di, 6405
	MargenSuperior:                 
	                                mov               es:[di], dl
	                                inc               di
	                                cmp               di, 6714
	                                jne               MargenSuperior
	                                mov               di, 60805
	MargenInferior:                 
	                                mov               es:[di], dl
	                                inc               di
	                                cmp               di, 61114
	                                jne               MargenInferior
	                                mov               di, 6405
	MargenIzquierdo:                
	                                mov               es:[di], dl
	                                add               di, 320
	                                cmp               di, 60805
	                                jne               MargenIzquierdo
	                                mov               di, 6714
	MargenDerecho:                  
	                                mov               es:[di], dl
	                                add               di, 320
	                                cmp               di, 61114
	                                jne               MargenDerecho
	                                ret
dibujarMargen ENDP

	;proc para realizar los tops de puntos y tiempo
addResume PROC
	                                clean             ubicacionRankingArchivo, SIZEOF ubicacionRankingArchivo, 24h
	                                call              LoadPathTop
	                                clean             handleFile, SIZEOF handleFile, 24h
	                                openFile          ubicacionRankingArchivo, handleFile
	                                readFile          players, handleFile, SIZEOF players
	                                xor               si, si
	AddNewResume:                   
	                                mov               al, players[si]
	                                inc               si
	                                cmp               al, 47
	                                jne               AddNewResume
	                                dec               si
	                                mov               players[si], 59
	                                inc               si
	                                xor               di, di
	AddUsersNameResume:             
	                                mov               al, info[di]
	                                mov               players[si], al
	                                inc               si
	                                inc               di
	                                cmp               di, 5
	                                jne               AddUsersNameResume
	                                mov               players[si], 44
	                                inc               si
	                                mov               al, currentLevel
	                                mov               players[si], al
	                                inc               si
	                                mov               players[si], 44
	                                inc               si
	                                xor               bx, bx
	                                mov               bl, finalTime
	                                call              showNumber
	                                mov               players[si], dh
	                                inc               si
	                                mov               players[si], cl
	                                inc               si
	                                mov               players[si], ch
	                                inc               si
	                                mov               players[si], 44
	                                inc               si
	                                xor               bx, bx
	                                mov               bl, finalScore
	                                call              showNumber
	                                mov               players[si], dh
	                                inc               si
	                                mov               players[si], cl
	                                inc               si
	                                mov               players[si], ch
	                                inc               si
	                                mov               players[si], 47
	                                closeFile         handleFile
	                                clean             handleFile, SIZEOF handleFile, 24h
	                                clean             ubicacionRankingArchivo, SIZEOF ubicacionRankingArchivo, 24h
	                                call              LoadPathTop
	                                createFile        ubicacionRankingArchivo, handleFile
	                                writeFile         handleFile, SIZEOF players, players
	                                closeFile         handleFile
	                                ret
addResume ENDP

	;proc para empezar el juego en modo grafico
iniciarJuego1 PROC
	                                mov               dx, 58735
	                                xor               cx, cx
	                                mov               cx, currentTime
	                                xor               bx, bx
	                                xor               ax, ax
	                                mov               ax, 59680
	                                dibujarBarraJuego ax, 12
	                                dibujarBloques    7367, 71
	                                dibujarBloques    7417, 72
	                                dibujarBloques    7467, 73
	                                dibujarBloques    7517, 74
	                                dibujarBloques    7567, 75
	                                dibujarBloques    7617, 76
	                                dibujarBloques    9927, 76
	                                dibujarBloques    9977, 75
	                                dibujarBloques    10027, 74
	                                dibujarBloques    10077, 73
	                                dibujarBloques    10127, 72
	                                dibujarBloques    10177, 71
	                                mov               levelone[0], 1
	                                mov               levelone[1], 1
	                                mov               levelone[2], 1
	                                mov               levelone[3], 1
	                                mov               levelone[4], 1
	                                mov               levelone[5], 1
	                                mov               levelone[6], 1
	                                mov               levelone[7], 1
	                                mov               levelone[8], 1
	                                mov               levelone[9], 1
	                                mov               levelone[10], 1
	                                mov               levelone[11], 1
	                                pintaBolita       dx, 40
	                                mov               bl, 1
	Level1Action:                   
	                                push              cx
	                                push              bx
	                                mov               bx, ax
	                                mov               ah, 01h
	                                int               16h
	                                jz                Level1NoBarChanges
	                                mov               ah, 00h
	                                int               16h
	                                cmp               ah, 4dh
	                                je                Level1MoverBarraToDerecha
	                                cmp               ah, 4bh
	                                je                Level1MoverbarraToIzquierda
	                                cmp               ah, 39h
	                                je                Level1Start
	                                cmp               ah, 1
	                                je                Level1Pause
	                                jmp               Level1NoBarChanges
	Level1MoverBarraToDerecha:      
	                                cmp               bx, 59800
	                                jge               Level1NoBarChanges
	                                dibujarBarraJuego bx, 0
	                                add               bx, 8
	                                dibujarBarraJuego bx, 12
	                                cmp               startLevel, 1
	                                je                Level1NoBarChanges
	                                pintaBolita       dx, 0
	                                add               dx, 8
	                                pintaBolita       dx, 40
	                                jmp               Level1NoBarChanges
	Level1MoverbarraToIzquierda:    
	                                cmp               bx, 59530
	                                jle               Level1NoBarChanges
	                                dibujarBarraJuego bx, 0
	                                sub               bx, 8
	                                dibujarBarraJuego bx, 12
	                                cmp               startLevel, 1
	                                je                Level1NoBarChanges
	                                pintaBolita       dx, 0
	                                sub               dx, 8
	                                pintaBolita       dx, 40
	                                jmp               Level1NoBarChanges
	Level1Start:                    
	                                mov               startLevel, 1
	                                jmp               Level1NoBarChanges
	Level1Pause:                    
	                                mov               ah, 01h
	                                int               16h
	                                jz                Level1Pause
	                                mov               ah, 00h
	                                int               16h
	                                cmp               ah, 1
	                                je                Level1NoBarChanges
	                                cmp               ah, 57
	                                je                Level1PauseExit
	                                cmp               ah, 2
	                                je                Level1GotoLevel1
	                                cmp               ah, 3
	                                je                Level1GotoLevel2
	                                cmp               ah,4
	                                je                Level1GotoLevel3
	                                jmp               Level1Pause
	Level1PauseExit:                
	                                pop               bx
	                                pop               cx
	                                mov               currentLevel, 31h
	                                mov               finalScore, ch
	                                mov               finalTime, cl
	                                call              addResume
	                                mov               currentLevel, 0
	                                mov               finalScore, 0
	                                mov               finalTime, 0
	                                jmp               Level1Finish
	Level1GotoLevel1:               
	                                pop               bx
	                                pop               cx
	                                mov               startLevel, 0
	                                mov               time, 0
	                                mov               currentTime, 0
	                                mov               delayGamePlay, 0
	                                mov               primerCuadrante, 0
	                                mov               segundoCuadrante, 0
	                                mov               tercerCuadrante, 0
	                                mov               swapBall, 0
	                                mov               terceraBall, 0
	                                mov               segundaBall, 0
	                                mov               primeraBall, 0
	                                call              modoGrafico
	                                push              ds
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 5
	                                int               10h
	                                printArray        info
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 14
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, 76
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 15
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, 49
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                pop               ds
	                                call              dibujarMargen
	                                call              iniciarJuego1
	                                jmp               Level1CleanFinish
	Level1GotoLevel2:               
	                                pop               bx
	                                pop               cx
	                                mov               startLevel, 0
	                                mov               time, 0
	                                mov               currentTime, 0
	                                mov               delayGamePlay, 130
	                                mov               primerCuadrante, 0
	                                mov               segundoCuadrante, 0
	                                mov               tercerCuadrante, 0
	                                mov               swapBall, 0
	                                mov               terceraBall, 0
	                                mov               segundaBall, 0
	                                mov               primeraBall, 0
	                                call              modoGrafico
	                                push              ds
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 5
	                                int               10h
	                                printArray        info
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 14
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, 76
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 15
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, 50
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                pop               ds
	                                call              dibujarMargen
	                                call              iniciarJuego2
	                                jmp               Level1CleanFinish
	Level1GotoLevel3:               
	                                pop               bx
	                                pop               cx
	                                mov               startLevel, 0
	                                mov               time, 0
	                                mov               currentTime, 0
	                                mov               delayGamePlay, 120
	                                mov               primerCuadrante, 0
	                                mov               segundoCuadrante, 0
	                                mov               tercerCuadrante, 0
	                                mov               swapBall, 0
	                                mov               terceraBall, 0
	                                mov               segundaBall, 0
	                                mov               primeraBall, 0
	                                call              modoGrafico
	                                push              ds
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 5
	                                int               10h
	                                printArray        info
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 14
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, 76
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 15
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, 51
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                pop               ds
	                                call              dibujarMargen
	                                call              iniciarJuego3
	                                jmp               Level1CleanFinish
	Level1NoBarChanges:             
	                                mov               ax, bx
	                                mov               cx, ax
	                                pop               bx
	                                push              ax
	                                cmp               startLevel, 0
	                                je                Level1EndAction
	                                cmp               bl, 1
	                                je                Level1Cuadrante1
	                                cmp               bl, 2
	                                je                Level1Cuadrante2
	                                cmp               bl, 3
	                                je                Level1Cuadrante3
	                                cmp               bl, 4
	                                je                Level1Cuadrante4
	                                jmp               Level1EndAction
	Level1Cuadrante1:               
	                                pintaBolita       dx, 0
	                                sub               dx, 319
	                                pintaBolita       dx, 40
	                                xor               ax, ax
	                                mov               ax, 7047
	Level1Cuadrante1Top:            
	                                cmp               dx, ax
	                                je                Level1Cuadrante1TopChange
	                                inc               ax
	                                cmp               ax, 7352
	                                jne               Level1Cuadrante1Top
	                                xor               ax, ax
	                                mov               ax, 7351
	Level1Cuadrante1Derecha:        
	                                cmp               dx, ax
	                                je                Level1Cuadrante1DerechaChange
	                                add               ax, 320
	                                cmp               ax, 60151
	                                jne               Level1Cuadrante1Derecha
	                                jmp               Level1EndAction
	Level1Cuadrante1TopChange:      
	                                pintaBolita       dx, 0
	                                add               dx, 319
	                                pintaBolita       dx, 40
	                                mov               bl, 4
	                                jmp               Level1EndAction
	Level1Cuadrante1DerechaChange:  
	                                pintaBolita       dx, 0
	                                add               dx, 319
	                                pintaBolita       dx, 40
	                                mov               bl, 2
	                                jmp               Level1EndAction
	Level1Cuadrante2:               
	                                pintaBolita       dx, 0
	                                sub               dx, 321
	                                pintaBolita       dx, 40
	                                xor               ax, ax
	                                mov               ax, 7047
	Level1Cuadrante2Top:            
	                                cmp               dx, ax
	                                je                Level1Cuadrante2TopChange
	                                inc               ax
	                                cmp               ax, 7352
	                                jne               Level1Cuadrante2Top
	                                xor               ax, ax
	                                mov               ax, 7047
	Level1Cuadrante2Izquierda:      
	                                cmp               dx, ax
	                                je                Level1Cuadrante2IzquierdaChange
	                                add               ax, 320
	                                cmp               ax, 60167
	                                jne               Level1Cuadrante2Izquierda
	                                jmp               Level1EndAction
	Level1Cuadrante2TopChange:      
	                                pintaBolita       dx, 0
	                                add               dx, 321
	                                pintaBolita       dx, 40
	                                mov               bl, 3
	                                jmp               Level1EndAction
	Level1Cuadrante2IzquierdaChange:
	                                pintaBolita       dx, 0
	                                add               dx, 321
	                                pintaBolita       dx, 40
	                                mov               bl, 1
	                                jmp               Level1EndAction
	Level1Cuadrante3:               
	                                pintaBolita       dx, 0
	                                add               dx, 319
	                                pintaBolita       dx, 40
	                                xor               ax, ax
	                                mov               ax, 7047
	Level1Cuadrante3Left:           
	                                cmp               dx, ax
	                                je                Level1Cuadrante3LeftChange
	                                add               ax, 320
	                                cmp               ax, 60167
	                                jne               Level1Cuadrante3Left
	                                xor               ax, ax
	                                mov               ax, cx
	                                add               cx, 32
	Level1Cuadrante3Bottom:         
	                                cmp               dx, ax
	                                je                Level1Cuadrante3BottomChange
	                                inc               ax
	                                cmp               ax, cx
	                                jne               Level1Cuadrante3Bottom
	                                xor               ax, ax
	                                mov               ax, 60805
	Level1Cuadrante3Lost:           
	                                cmp               dx, ax
	                                je                Level1Lost
	                                inc               ax
	                                cmp               ax, 61114
	                                jne               Level1Cuadrante3Lost
	                                jmp               Level1EndAction
	Level1Cuadrante3BottomChange:   
	                                pintaBolita       dx, 0
	                                sub               dx, 319
	                                pintaBolita       dx, 40
	                                mov               bl, 2
	                                jmp               Level1EndAction
	Level1Cuadrante3LeftChange:     
	                                pintaBolita       dx, 0
	                                sub               dx, 319
	                                pintaBolita       dx, 40
	                                mov               bl, 4
	                                jmp               Level1EndAction
	Level1Cuadrante4:               
	                                pintaBolita       dx, 0
	                                add               dx, 321
	                                pintaBolita       dx, 40
	                                xor               ax, ax
	                                mov               ax, 7351
	Level1Cuadrante4Derecha:        
	                                cmp               dx,ax
	                                je                Level1Cuadrante4DerechaChange
	                                add               ax, 320
	                                cmp               ax, 60151
	                                jne               Level1Cuadrante4Derecha
	                                xor               ax, ax
	                                mov               ax, cx
	                                add               cx, 32
	Level1Cuadrante4Bottom:         
	                                cmp               dx, ax
	                                je                Level1Cuadrante4BottomChange
	                                inc               ax
	                                cmp               ax, cx
	                                jne               Level1Cuadrante4Bottom
	                                xor               ax, ax
	                                mov               ax, 60805
	Level1Cuadrante4Lost:           
	                                cmp               dx, ax
	                                je                Level1Lost
	                                inc               ax
	                                cmp               ax, 61114
	                                jne               Level1Cuadrante4Lost
	                                jmp               Level1EndAction
	Level1Cuadrante4BottomChange:   
	                                pintaBolita       dx, 0
	                                sub               dx, 321
	                                pintaBolita       dx, 40
	                                mov               bl, 1
	                                jmp               Level1EndAction
	Level1Cuadrante4DerechaChange:  
	                                pintaBolita       dx, 0
	                                sub               dx, 321
	                                pintaBolita       dx, 40
	                                mov               bl, 3
	                                jmp               Level1EndAction
	Level1EndAction:                
	                                xor               ax, ax
	                                mov               al, levelone[0]
	                                cmp               al, 1
	                                je                Level1Block1
	Level1Block1NoDestroy:          
	                                mov               al, levelone[1]
	                                cmp               al, 1
	                                je                Level1Block2
	Level1Block2NoDestroy:          
	                                mov               al, levelone[2]
	                                cmp               al, 1
	                                je                Level1Block3
	Level1Block3NoDestroy:          
	                                mov               al, levelone[3]
	                                cmp               al, 1
	                                je                Level1Block4
	Level1Block4NoDestroy:          
	                                mov               al, levelone[4]
	                                cmp               al, 1
	                                je                Level1Block5
	Level1Block5NoDestroy:          
	                                mov               al, levelone[5]
	                                cmp               al, 1
	                                je                Level1Block6
	Level1Block6NoDestroy:          
	                                mov               al, levelone[6]
	                                cmp               al, 1
	                                je                Level1Block7
	Level1Block7NoDestroy:          
	                                mov               al, levelone[7]
	                                cmp               al, 1
	                                je                Level1Block8
	Level1Block8NoDestroy:          
	                                mov               al, levelone[8]
	                                cmp               al, 1
	                                je                Level1Block9
	Level1Block9NoDestroy:          
	                                mov               al, levelone[9]
	                                cmp               al, 1
	                                je                Level1Block10
	Level1Block10NoDestroy:         
	                                mov               al, levelone[10]
	                                cmp               al, 1
	                                je                Level1Block11
	Level1Block11NoDestroy:         
	                                mov               al, levelone[11]
	                                cmp               al, 1
	                                je                Level1Block12
	Level1Block12NoDestroy:         
	                                jmp               Level1ContinueAction
	                               
	Level1Block1:                   
	                                xor               ax, ax
	                                mov               ax, 8967
	Level1Block1While:              
	                                cmp               dx, ax
	                                je                Level1Block1Destroy
	                                inc               ax
	                                cmp               ax, 9017
	                                jne               Level1Block1While
	                                jmp               Level1Block1NoDestroy
	Level1Block1Destroy:            
	                                dibujarBloques    7367, 0
	                                mov               levelone[0], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level1BlockDestroy
	Level1Block2:                   
	                                xor               ax, ax
	                                mov               ax, 9017
	Level1block2While:              
	                                cmp               dx, ax
	                                je                Level1Block2Destroy
	                                inc               ax
	                                cmp               ax, 9067
	                                jne               Level1block2While
	                                jmp               Level1Block2NoDestroy
	Level1Block2Destroy:            
	                                dibujarBloques    7417,0
	                                mov               levelone[1], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level1BlockDestroy
	Level1Block3:                   
	                                xor               ax, ax
	                                mov               ax, 9067
	Level1Block3While:              
	                                cmp               dx, ax
	                                je                Level1Block3Destroy
	                                inc               ax
	                                cmp               ax, 9117
	                                jne               Level1Block3While
	                                jmp               Level1Block3NoDestroy
	Level1Block3Destroy:            
	                                dibujarBloques    7467, 0
	                                mov               levelone[2], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level1BlockDestroy
	Level1Block4:                   
	                                xor               ax, ax
	                                mov               ax, 9117
	Level1BLock4While:              
	                                cmp               dx, ax
	                                je                Level1Block4Destroy
	                                inc               ax
	                                cmp               ax, 9167
	                                jne               Level1BLock4While
	                                jmp               Level1Block4NoDestroy
	Level1Block4Destroy:            
	                                dibujarBloques    7517, 0
	                                mov               levelone[3], 0
	                                pop               ax
	                                pop               cx
	                                add               ch,1
	                                push              cx
	                                push              ax
	                                jmp               Level1BlockDestroy
	Level1Block5:                   
	                                xor               ax, ax
	                                mov               ax, 9167
	Level1Block5While:              
	                                cmp               dx, ax
	                                je                Level1Block5Destroy
	                                inc               ax
	                                cmp               ax, 9217
	                                jne               Level1Block5While
	                                jmp               Level1Block5NoDestroy
	Level1Block5Destroy:            
	                                dibujarBloques    7567, 0
	                                mov               levelone[4], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level1BlockDestroy
	Level1Block6:                   
	                                xor               ax, ax
	                                mov               ax, 9217
	Level1Block6While:              
	                                cmp               dx, ax
	                                je                Level1Block6Destroy
	                                inc               ax
	                                cmp               ax, 9267
	                                jne               Level1Block6While
	                                jmp               Level1Block6NoDestroy
	Level1Block6Destroy:            
	                                dibujarBloques    7617, 0
	                                mov               levelone[5], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level1BlockDestroy
	Level1Block7:                   
	                                xor               ax, ax
	                                mov               ax, 11527
	Level1Block7While:              
	                                cmp               dx, ax
	                                je                Level1Block7Destroy
	                                inc               ax
	                                cmp               ax, 11577
	                                jne               Level1Block7While
	                                jmp               Level1Block7NoDestroy
	Level1Block7Destroy:            
	                                dibujarBloques    9927, 0
	                                mov               levelone[6], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level1BlockDestroy
	Level1Block8:                   
	                                xor               ax, ax
	                                mov               ax, 11577
	Level1Block8While:              
	                                cmp               dx, ax
	                                je                Level1Block8Destroy
	                                inc               ax
	                                cmp               ax, 11627
	                                jne               Level1Block8While
	                                jmp               Level1Block8NoDestroy
	Level1Block8Destroy:            
	                                dibujarBloques    9977, 0
	                                mov               levelone[7], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level1BlockDestroy
	Level1Block9:                   
	                                xor               ax, ax
	                                mov               ax, 11627
	Level1Block9While:              
	                                cmp               dx, ax
	                                je                Level1Block9Destroy
	                                inc               ax
	                                cmp               ax, 11677
	                                jne               Level1Block9While
	                                jmp               Level1Block9NoDestroy
	Level1Block9Destroy:            
	                                dibujarBloques    10027, 0
	                                mov               levelone[8], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level1BlockDestroy
	Level1Block10:                  
	                                xor               ax, ax
	                                mov               ax, 11677
	Level1Block10While:             
	                                cmp               dx, ax
	                                je                Level1Block10Destroy
	                                inc               ax
	                                cmp               ax, 11727
	                                jne               Level1Block10While
	                                jmp               Level1Block10NoDestroy
	Level1Block10Destroy:           
	                                dibujarBloques    10077, 0
	                                mov               levelone[9], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level1BlockDestroy
	Level1Block11:                  
	                                xor               ax, ax
	                                mov               ax, 11727
	Level1Block11While:             
	                                cmp               dx, ax
	                                je                Level1Block11Destroy
	                                inc               ax
	                                cmp               ax, 11777
	                                jne               Level1Block11While
	                                jmp               Level1Block11NoDestroy
	Level1Block11Destroy:           
	                                dibujarBloques    10127, 0
	                                mov               levelone[10], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level1BlockDestroy
	Level1Block12:                  
	                                xor               ax, ax
	                                mov               ax, 11777
	Level1Block12While:             
	                                cmp               dx, ax
	                                je                Level1Block12Destroy
	                                inc               ax
	                                cmp               ax, 11827
	                                jne               Level1Block12While
	                                jmp               Level1Block12NoDestroy
	Level1Block12Destroy:           
	                                dibujarBloques    10177, 0
	                                mov               levelone[11], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level1BlockDestroy
	Level1BlockDestroy:             
	                                cmp               bl,1
	                                je                Level1BlockCuadrante1
	                                cmp               bl, 2
	                                je                Level1BlockCuadrante2
	                                cmp               bl, 3
	                                je                Level1BlockCuadrante3
	                                cmp               bl, 4
	                                je                Level1BlockCuadrante4
	                                jmp               Level1ContinueAction
	Level1BlockCuadrante1:          
	                                mov               bl, 4
	                                jmp               Level1ContinueAction
	Level1BlockCuadrante2:          
	                                mov               bl, 3
	                                jmp               Level1ContinueAction
	Level1BlockCuadrante3:          
	                                mov               bl, 2
	                                jmp               Level1ContinueAction
	Level1BlockCuadrante4:          
	                                mov               bl,1
	                                jmp               Level1ContinueAction
	Level1ContinueAction:           
	                                delay             140
	                                pop               ax
	                                pop               cx
	                                push              ax
	                                push              bx
	                                push              cx
	                                push              dx
	Level1UpdateScore:              
	                                push              bx
	                                xor               bx, bx
	                                mov               bl, ch
	                                call              showNumber
	                                push              cx
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 23
	                                int               10h
	                                pop               dx
	                                push              dx
	                                mov               ah, 0ah
	                                mov               al, dl
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 24
	                                int               10h
	                                pop               dx
	                                mov               ah, 0ah
	                                mov               al, dh
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                pop               bx
	                                pop               dx
	                                pop               cx
	                                pop               bx
	                                pop               ax
	                                push              ax
	                                push              dx
	                                push              bx
	                                mov               bx, cx
	                                mov               ah, 2ch
	                                int               21h
	                                xor               ax, ax
	                                mov               al, cl
	                                mov               ch, 60
	                                mul               ch
	                                mov               dl, dh
	                                mov               dh, 0
	                                add               ax, dx
	                                mov               dx, time
	                                cmp               ax, dx
	                                jg                Level1AddSegundo
	                                jmp               Level1NotAddSegundo
	Level1AddSegundo:               
	                                mov               cx, bx
	                                inc               cl
	                                mov               time, ax
	                                push              cx
	                                xor               ax, ax
	                                mov               al, cl
	                                mov               bl, 60
	                                div               bl
	                                push              ax
	                                mov               ch, al
	                                add               ch, 30h
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 30
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, ch
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 31
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, 58
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                pop               ax
	                                mov               al, ah
	                                mov               ah, 0
	                                mov               bx, ax
	                                call              showNumber
	                                push              cx
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 32
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, cl
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                pop               cx
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 33
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, ch
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                pop               cx
	                                jmp               Level1AddSegundoContinue
	Level1NotAddSegundo:            
	                                mov               cx, bx
	Level1AddSegundoContinue:       
	                                pop               bx
	                                pop               dx
	                                pop               ax
	                                cmp               ch, 12
	                                je                Level1EndJuego
	                                jmp               Level1Action
	Level1EndJuego:                 
	                                mov               currentTime, cx
	                                call              modoTexto
	                                call              modoGrafico
	                                push              ds
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 5
	                                int               10h
	                                printArray        info
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 14
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, 76
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 15
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, 50
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                pop               ds
	                                mov               startLevel, 0
	                                mov               startLevel, 0
	                                mov               primerCuadrante, 0
	                                mov               segundoCuadrante, 0
	                                mov               tercerCuadrante, 0
	                                mov               swapBall, 0
	                                mov               segundaBall, 0
	                                mov               primeraBall, 0
	                                mov               terceraBall, 0
	                                mov               delayGamePlay, 130
	                                call              dibujarMargen
	                                call              iniciarJuego2
	                                call              modoTexto
	                                jmp               Level1Finish
	Level1Lost:                     
	                                pop               ax
	                                pop               cx
	                                mov               currentLevel, 49
	                                mov               finalScore, ch
	                                mov               finalTime, cl
	                                call              addResume
	                                mov               currentLevel, 0
	                                mov               finalScore, 0
	                                mov               finalTime, 0
	Level1Finish:                   
	Level1CleanFinish:              
	                                mov               startLevel, 0
	                                mov               time, 0
	                                mov               currentTime, 0
	                                mov               delayGamePlay, 0
	                                mov               primerCuadrante, 0
	                                mov               segundoCuadrante, 0
	                                mov               tercerCuadrante, 0
	                                mov               swapBall, 0
	                                mov               terceraBall, 0
	                                mov               segundaBall, 0
	                                mov               primeraBall, 0
				

	                                ret
iniciarJuego1 ENDP

	;proc para inciar con el nivel 2 del juego
iniciarJuego2 PROC
	                                mov               dx, 58735
	                                xor               cx, cx
	                                mov               cx, currentTime
	                                xor               bx, bx
	                                xor               ax, ax
	                                mov               ax, 59680
	                                dibujarBarraJuego ax, 44
	                                dibujarBloques    7367,71
	                                dibujarBloques    7417,72
	                                dibujarBloques    7467,73
	                                dibujarBloques    7517,74
	                                dibujarBloques    7567,75
	                                dibujarBloques    7617,76
	                                dibujarBloques    9927,76
	                                dibujarBloques    9977,75
	                                dibujarBloques    10027,74
	                                dibujarBloques    10077,73
	                                dibujarBloques    10127,72
	                                dibujarBloques    10177,71
	                                dibujarBloques    12487,43
	                                dibujarBloques    12537,44
	                                dibujarBloques    12587,45
	                                dibujarBloques    12637,46
	                                dibujarBloques    12687,47
	                                dibujarBloques    12737,48
	                                dibujarBloques    15047,48
	                                dibujarBloques    15097,47
	                                dibujarBloques    15147,46
	                                dibujarBloques    15197,45
	                                dibujarBloques    15247,44
	                                dibujarBloques    15297,43
	                                mov               leveltwo[0], 1
	                                mov               leveltwo[1], 1
	                                mov               leveltwo[2], 1
	                                mov               leveltwo[3], 1
	                                mov               leveltwo[4], 1
	                                mov               leveltwo[5], 1
	                                mov               leveltwo[6], 1
	                                mov               leveltwo[7], 1
	                                mov               leveltwo[8], 1
	                                mov               leveltwo[9], 1
	                                mov               leveltwo[10], 1
	                                mov               leveltwo[11], 1
	                                mov               leveltwo[12], 1
	                                mov               leveltwo[13], 1
	                                mov               leveltwo[14], 1
	                                mov               leveltwo[15], 1
	                                mov               leveltwo[16], 1
	                                mov               leveltwo[17], 1
	                                mov               leveltwo[18], 1
	                                mov               leveltwo[19], 1
	                                mov               leveltwo[20], 1
	                                mov               leveltwo[21], 1
	                                mov               leveltwo[22], 1
	                                mov               leveltwo[23], 1
	                                pintaBolita       dx, 40
	                                mov               bl, 1
	Level2Action:                   
	                                cmp               segundaBall, 0
	                                jne               Level2ActiveSegundaBall
	                                jmp               Level2NoBallSwap
	Level2ActiveSegundaBall:        
	                                cmp               swapBall, 0
	                                je                Level2FirstBallTurn
	                                cmp               swapBall, 1
	                                je                Level2SecondBallTurn
	                                jmp               Level2NoBallSwap
	Level2FirstBallTurn:            
	                                mov               primeraBall, dx
	                                mov               primerCuadrante, bl
	                                mov               dx, segundaBall
	                                mov               bl, segundoCuadrante
	                                mov               swapBall, 1
	                                jmp               Level2NoBallSwap
	Level2SecondBallTurn:           
	                                mov               segundaBall, dx
	                                mov               segundoCuadrante, bl
	                                mov               dx, primeraBall
	                                mov               bl, primerCuadrante
	                                mov               swapBall, 0
	                                jmp               Level2NoBallSwap
	Level2NoBallSwap:               
	                                push              cx
	                                push              bx
	                                mov               bx, ax
	                                mov               ah, 01h
	                                int               16h
	                                jz                Level2NoBarChanges
	                                mov               ah, 00h
	                                int               16h
	                                cmp               ah, 4dh
	                                je                Level2MoveBarToDerecha
	                                cmp               ah, 4bh
	                                je                Level2MoveBarToIzquierda
	                                cmp               ah, 57
	                                je                Level2Start
	                                cmp               ah, 1
	                                je                Level2Pause
	                                jmp               Level2NoBarChanges
	Level2MoveBarToDerecha:         
	                                cmp               bx, 59800
	                                jge               Level2NoBarChanges
	                                dibujarBarraJuego bx, 0
	                                add               bx, 8
	                                dibujarBarraJuego bx, 44
	                                cmp               startLevel, 1
	                                je                Level2NoBarChanges
	                                pintaBolita       dx, 0
	                                add               dx, 8
	                                pintaBolita       dx, 40
	                                jmp               Level2NoBarChanges
	Level2MoveBarToIzquierda:       
	                                cmp               bx, 59530
	                                jle               Level2NoBarChanges
	                                dibujarBarraJuego bx, 0
	                                sub               bx, 8
	                                dibujarBarraJuego bx, 44
	                                cmp               startLevel, 1
	                                je                Level2NoBarChanges
	                                pintaBolita       dx, 0
	                                sub               dx, 8
	                                pintaBolita       dx, 40
	                                jmp               Level2NoBarChanges
	Level2Start:                    
	                                mov               startLevel, 1
	                                jmp               Level2NoBarChanges
	Level2Pause:                    
	                                mov               ah, 01h
	                                int               16h
	                                jz                Level2Pause
	                                mov               ah, 00h
	                                int               16h
	                                cmp               ah, 1
	                                je                Level2NoBarChanges
	                                cmp               ah, 57
	                                je                Level2PauseExit
	                                cmp               ah, 2
	                                je                Level2GoToLevel1
	                                cmp               ah, 3
	                                je                Level2GoToLevel2
	                                cmp               ah, 4
	                                je                Level2GoToLevel3
	                                jmp               Level2Pause
	Level2PauseExit:                
	                                pop               bx
	                                pop               cx
	                                mov               currentLevel, 50
	                                mov               finalScore, ch
	                                mov               finalTime, cl
	                                call              addResume
	                                mov               currentLevel, 0
	                                mov               finalScore, 0
	                                mov               finalTime, 0
	                                jmp               Level2Finish
	Level2GoToLevel1:               
	                                pop               bx
	                                pop               cx
	                                mov               startLevel, 0
	                                mov               time, 0
	                                mov               currentTime, 0
	                                mov               delayGamePlay, 0
	                                mov               primerCuadrante, 0
	                                mov               segundoCuadrante, 0
	                                mov               tercerCuadrante, 0
	                                mov               swapBall, 0
	                                mov               terceraBall, 0
	                                mov               segundaBall, 0
	                                mov               primeraBall, 0
	                                call              modoGrafico
	                                push              ds
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 5
	                                int               10h
	                                printArray        info
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 14
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, 76
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 15
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, 49
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                pop               ds
	                                call              dibujarMargen
	                                call              iniciarJuego1
	                                jmp               Level2CleanFinish
	Level2GoToLevel2:               
	                                pop               bx
	                                pop               cx
	                                mov               startLevel, 0
	                                mov               time, 0
	                                mov               currentTime, 0
	                                mov               delayGamePlay, 130
	                                mov               primerCuadrante, 0
	                                mov               segundoCuadrante, 0
	                                mov               tercerCuadrante, 0
	                                mov               swapBall, 0
	                                mov               terceraBall, 0
	                                mov               segundaBall, 0
	                                mov               primeraBall, 0
	                                call              modoGrafico
	                                push              ds
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 5
	                                int               10h
	                                printArray        info
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 14
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, 76
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 15
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, 50
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                pop               ds
	                                call              dibujarMargen
	                                call              iniciarJuego2
	                                jmp               Level2CleanFinish
	Level2GoToLevel3:               
	                                pop               bx
	                                pop               cx
	                                mov               startLevel, 0
	                                mov               time, 0
	                                mov               currentTime, 0
	                                mov               delayGamePlay, 120
	                                mov               primerCuadrante, 0
	                                mov               segundoCuadrante, 0
	                                mov               tercerCuadrante, 0
	                                mov               swapBall, 0
	                                mov               terceraBall, 0
	                                mov               segundaBall, 0
	                                mov               primeraBall, 0
	                                call              modoGrafico
	                                push              ds
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 5
	                                int               10h
	                                printArray        info
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 14
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, 76
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 15
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, 51
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                pop               ds
	                                call              dibujarMargen
	                                call              iniciarJuego3
	                                jmp               Level2CleanFinish
	Level2NoBarChanges:             
	                                mov               ax, bx
	                                mov               cx, ax
	                                pop               bx
	                                push              ax
	                                cmp               startLevel, 0
	                                je                Level2EndAction
	                                cmp               bl, 1
	                                je                Level2Cuadrante1
	                                cmp               bl, 2
	                                je                Level2Cuadrante2
	                                cmp               bl, 3
	                                je                Level2Cuadrante3
	                                cmp               bl, 4
	                                je                Level2Cuadrante4
	                                jmp               Level2EndAction
	Level2Cuadrante1:               
	                                pintaBolita       dx, 0
	                                sub               dx, 319
	                                pintaBolita       dx, 40
	                                xor               ax, ax
	                                mov               ax, 7047
	Level2Cuadrante1Top:            
	                                cmp               dx, ax
	                                je                Level2Cuadrante1TopChange
	                                inc               ax
	                                cmp               ax, 7352
	                                jne               Level2Cuadrante1Top
	                                xor               ax, ax
	                                mov               ax, 7351
	Level2Cuadrante1Derecha:        
	                                cmp               dx, ax
	                                je                Level2Cuadrante1DerechaChange
	                                add               ax, 320
	                                cmp               ax, 60151
	                                jne               Level2Cuadrante1Derecha
	                                jmp               Level2EndAction
	Level2Cuadrante1TopChange:      
	                                pintaBolita       dx, 0
	                                add               dx, 319
	                                pintaBolita       dx, 40
	                                mov               bl, 4
	                                jmp               Level2EndAction
	Level2Cuadrante1DerechaChange:  
	                                pintaBolita       dx, 0
	                                add               dx, 319
	                                pintaBolita       dx, 40
	                                mov               bl, 2
	                                jmp               Level2EndAction
	Level2Cuadrante2:               
	                                pintaBolita       dx, 0
	                                sub               dx, 321
	                                pintaBolita       dx, 40
	                                xor               ax, ax
	                                mov               ax, 7047
	Level2Cuadrante2Top:            
	                                cmp               dx, ax
	                                je                Level2Cuadrante2TopChange
	                                inc               ax
	                                cmp               ax, 7352
	                                jne               Level2Cuadrante2Top
	                                xor               ax, ax
	                                mov               ax, 7047
	Level2Cuadrante2Izquierda:      
	                                cmp               dx, ax
	                                je                Level2Cuadrante2IzquierdaChange
	                                add               ax, 320
	                                cmp               ax, 60167
	                                jne               Level2Cuadrante2Izquierda
	                                jmp               Level2EndAction
	Level2Cuadrante2TopChange:      
	                                pintaBolita       dx, 0
	                                add               dx, 321
	                                pintaBolita       dx, 40
	                                mov               bl, 3
	                                jmp               Level2EndAction
	Level2Cuadrante2IzquierdaChange:
	                                pintaBolita       dx, 0
	                                add               dx, 321
	                                pintaBolita       dx, 40
	                                mov               bl, 1
	                                jmp               Level2EndAction
	Level2Cuadrante3:               
	                                pintaBolita       dx, 0
	                                add               dx, 319
	                                pintaBolita       dx, 40
	                                xor               ax, ax
	                                mov               ax, 7047
	Level2Cuadrante3Izquierda:      
	                                cmp               dx, ax
	                                je                Level2Cuadrante3IzquierdaChange
	                                add               ax, 320
	                                cmp               ax, 60167
	                                jne               Level2Cuadrante3Izquierda
	                                xor               ax, ax
	                                mov               ax, cx
	                                add               cx, 32
	Level2Cuadrante3Bottom:         
	                                cmp               dx, ax
	                                je                Level2Cuadrante3BottomChange
	                                inc               ax
	                                cmp               ax, cx
	                                jne               Level2Cuadrante3Bottom
	                                xor               ax, ax
	                                mov               ax, 60805
	Level2Cuadrante3Lost:           
	                                cmp               dx, ax
	                                je                Level2Lost
	                                inc               ax
	                                cmp               ax, 61114
	                                jne               Level2Cuadrante3Lost
	                                jmp               Level2EndAction
	Level2Cuadrante3BottomChange:   
	                                pintaBolita       dx, 0
	                                sub               dx, 319
	                                pintaBolita       dx, 40
	                                mov               bl, 2
	                                jmp               Level2EndAction
	Level2Cuadrante3IzquierdaChange:
	                                pintaBolita       dx, 0
	                                sub               dx, 319
	                                pintaBolita       dx, 40
	                                mov               bl, 4
	                                jmp               Level2EndAction
	Level2Cuadrante4:               
	                                pintaBolita       dx, 0
	                                add               dx, 321
	                                pintaBolita       dx, 40
	                                xor               ax, ax
	                                mov               ax, 7351
	Level2Cuadrante4Derecha:        
	                                cmp               dx, ax
	                                je                Level2Cuadrante4DerechaChange
	                                add               ax, 320
	                                cmp               ax, 60151
	                                jne               Level2Cuadrante4Derecha
	                                xor               ax, ax
	                                mov               ax, cx
	                                add               cx, 32
	Level2Cuadrante4Bottom:         
	                                cmp               dx, ax
	                                je                Level2Cuadrante4BottomChange
	                                inc               ax
	                                cmp               ax, cx
	                                jne               Level2Cuadrante4Bottom
	                                xor               ax, ax
	                                mov               ax, 60805
	Level2Cuadrante4Lost:           
	                                cmp               dx, ax
	                                je                Level2Lost
	                                inc               ax
	                                cmp               ax, 61114
	                                jne               Level2Cuadrante4Lost
	                                jmp               Level2EndAction
	Level2Cuadrante4BottomChange:   
	                                pintaBolita       dx, 0
	                                sub               dx, 321
	                                pintaBolita       dx, 40
	                                mov               bl, 1
	                                jmp               Level2EndAction
	Level2Cuadrante4DerechaChange:  
	                                pintaBolita       dx, 0
	                                sub               dx, 321
	                                pintaBolita       dx, 40
	                                mov               bl, 3
	                                jmp               Level2EndAction
	Level2EndAction:                
	                                xor               ax, ax
	                                mov               al, leveltwo[0]
	                                cmp               al, 1
	                                je                Level2Block1
	Level2Block1NoDestroy:          
	                                mov               al, leveltwo[1]
	                                cmp               al, 1
	                                je                Level2Block2
	Level2Block2NoDestroy:          
	                                mov               al, leveltwo[2]
	                                cmp               al, 1
	                                je                Level2Block3
	Level2Block3NoDestroy:          
	                                mov               al, leveltwo[3]
	                                cmp               al, 1
	                                je                Level2Block4
	Level2Block4NoDestroy:          
	                                mov               al, leveltwo[4]
	                                cmp               al, 1
	                                je                Level2Block5
	Level2Block5NoDestroy:          
	                                mov               al, leveltwo[5]
	                                cmp               al, 1
	                                je                Level2Block6
	Level2Block6NoDestroy:          
	                                mov               al, leveltwo[6]
	                                cmp               al, 1
	                                je                Level2Block7
	Level2Block7NoDestroy:          
	                                mov               al, leveltwo[7]
	                                cmp               al, 1
	                                je                Level2Block8
	Level2Block8NoDestroy:          
	                                mov               al, leveltwo[8]
	                                cmp               al, 1
	                                je                Level2Block9
	Level2Block9NoDestroy:          
	                                mov               al, leveltwo[9]
	                                cmp               al, 1
	                                je                Level2Block10
	Level2Block10NoDestroy:         
	                                mov               al, leveltwo[10]
	                                cmp               al, 1
	                                je                Level2Block11
	Level2Block11NoDestroy:         
	                                mov               al, leveltwo[11]
	                                cmp               al, 1
	                                je                Level2Block12
	Level2Block12NoDestroy:         
	                                mov               al, leveltwo[12]
	                                cmp               al, 1
	                                je                Level2Block13
	Level2Block13NoDestroy:         
	                                mov               al, leveltwo[13]
	                                cmp               al, 1
	                                je                Level2Block14
	Level2Block14NoDestroy:         
	                                mov               al, leveltwo[14]
	                                cmp               al, 1
	                                je                Level2Block15
	Level2Block15NoDestroy:         
	                                mov               al, leveltwo[15]
	                                cmp               al, 1
	                                je                Level2Block16
	Level2Block16NoDestroy:         
	                                mov               al, leveltwo[16]
	                                cmp               al, 1
	                                je                Level2Block17
	Level2Block17NoDestroy:         
	                                mov               al, leveltwo[17]
	                                cmp               al, 1
	                                je                Level2Block18
	Level2Block18NoDestroy:         
	                                mov               al, leveltwo[18]
	                                cmp               al, 1
	                                je                Level2Block19
	Level2Block19NoDestroy:         
	                                mov               al, leveltwo[19]
	                                cmp               al, 1
	                                je                Level2Block20
	Level2Block20NoDestroy:         
	                                mov               al, leveltwo[20]
	                                cmp               al, 1
	                                je                Level2Block21
	Level2Block21NoDestroy:         
	                                mov               al, leveltwo[21]
	                                cmp               al, 1
	                                je                Level2Block22
	Level2Block22NoDestroy:         
	                                mov               al, leveltwo[22]
	                                cmp               al, 1
	                                je                Level2Block23
	Level2Block23NoDestroy:         
	                                mov               al, leveltwo[23]
	                                cmp               al, 1
	                                je                Level2Block24
	Level2Block24NoDestroy:         
	                                jmp               Level2ContinueAction
	Level2Block1:                   
	                                xor               ax, ax
	                                mov               ax, 8967
	Level2Block1While:              
	                                cmp               dx, ax
	                                je                Level2Block1Destroy
	                                inc               ax
	                                cmp               ax, 9017
	                                jne               Level2Block1While
	                                jmp               Level2Block1NoDestroy
	Level2Block1Destroy:            
	                                dibujarBloques    7367, 0
	                                mov               leveltwo[0], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level2BlockDestroy
	Level2Block2:                   
	                                xor               ax, ax
	                                mov               ax, 9017
	Level2Block2While:              
	                                cmp               dx, ax
	                                je                Level2Block2Destroy
	                                inc               ax
	                                cmp               ax, 9067
	                                jne               Level2Block2While
	                                jmp               Level2Block2NoDestroy
	Level2Block2Destroy:            
	                                dibujarBloques    7417, 0
	                                mov               leveltwo[1], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level2BlockDestroy
	Level2Block3:                   
	                                xor               ax, ax
	                                mov               ax, 9067
	Level2Block3While:              
	                                cmp               dx, ax
	                                je                Level2Block3Destroy
	                                inc               ax
	                                cmp               ax, 9117
	                                jne               Level2Block3While
	                                jmp               Level2Block3NoDestroy
	Level2Block3Destroy:            
	                                dibujarBloques    7467, 0
	                                mov               leveltwo[2], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level2BlockDestroy
	Level2Block4:                   
	                                xor               ax, ax
	                                mov               ax, 9117
	Level2Block4While:              
	                                cmp               dx, ax
	                                je                Level2Block4Destroy
	                                inc               ax
	                                cmp               ax, 9167
	                                jne               Level2Block4While
	                                jmp               Level2Block4NoDestroy
	Level2Block4Destroy:            
	                                dibujarBloques    7517, 0
	                                mov               leveltwo[3], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level2BlockDestroy
	Level2Block5:                   
	                                xor               ax, ax
	                                mov               ax, 9167
	Level2Block5While:              
	                                cmp               dx, ax
	                                je                Level2Block5Destroy
	                                inc               ax
	                                cmp               ax, 9217
	                                jne               Level2Block5While
	                                jmp               Level2Block5NoDestroy
	Level2Block5Destroy:            
	                                dibujarBloques    7567, 0
	                                mov               leveltwo[4], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level2BlockDestroy
	Level2Block6:                   
	                                xor               ax, ax
	                                mov               ax, 9217
	Level2Block6While:              
	                                cmp               dx, ax
	                                je                Level2Block6Destroy
	                                inc               ax
	                                cmp               ax, 9267
	                                jne               Level2Block6While
	                                jmp               Level2Block6NoDestroy
	Level2Block6Destroy:            
	                                dibujarBloques    7617, 0
	                                mov               leveltwo[5], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level2BlockDestroy
	Level2Block7:                   
	                                xor               ax, ax
	                                mov               ax, 11527
	Level2Block7While:              
	                                cmp               dx, ax
	                                je                Level2Block7Destroy
	                                inc               ax
	                                cmp               ax, 11577
	                                jne               Level2Block7While
	                                jmp               Level2Block7NoDestroy
	Level2Block7Destroy:            
	                                dibujarBloques    9927, 0
	                                mov               leveltwo[6], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level2BlockDestroy
	Level2Block8:                   
	                                xor               ax, ax
	                                mov               ax, 11577
	Level2Block8While:              
	                                cmp               dx, ax
	                                je                Level2Block8Destroy
	                                inc               ax
	                                cmp               ax, 11627
	                                jne               Level2Block8While
	                                jmp               Level2Block8NoDestroy
	Level2Block8Destroy:            
	                                dibujarBloques    9977, 0
	                                mov               leveltwo[7], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level2BlockDestroy
	Level2Block9:                   
	                                xor               ax, ax
	                                mov               ax, 11627
	Level2Block9While:              
	                                cmp               dx, ax
	                                je                Level2Block9Destroy
	                                inc               ax
	                                cmp               ax, 11677
	                                jne               Level2Block9While
	                                jmp               Level2Block9NoDestroy
	Level2Block9Destroy:            
	                                dibujarBloques    10027, 0
	                                mov               leveltwo[8], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level2BlockDestroy
	Level2Block10:                  
	                                xor               ax, ax
	                                mov               ax, 11677
	Level2Block10While:             
	                                cmp               dx, ax
	                                je                Level2Block10Destroy
	                                inc               ax
	                                cmp               ax, 11727
	                                jne               Level2Block10While
	                                jmp               Level2Block10NoDestroy
	Level2Block10Destroy:           
	                                dibujarBloques    10077, 0
	                                mov               leveltwo[9], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level2BlockDestroy
	Level2Block11:                  
	                                xor               ax, ax
	                                mov               ax, 11727
	Level2Block11While:             
	                                cmp               dx, ax
	                                je                Level2Block11Destroy
	                                inc               ax
	                                cmp               ax, 11777
	                                jne               Level2Block11While
	                                jmp               Level2Block11NoDestroy
	Level2Block11Destroy:           
	                                dibujarBloques    10127, 0
	                                mov               leveltwo[10], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level2BlockDestroy
	Level2Block12:                  
	                                xor               ax, ax
	                                mov               ax, 11777
	Level2Block12While:             
	                                cmp               dx, ax
	                                je                Level2Block12Destroy
	                                inc               ax
	                                cmp               ax, 11827
	                                jne               Level2Block12While
	                                jmp               Level2Block12NoDestroy
	Level2Block12Destroy:           
	                                dibujarBloques    10177, 0
	                                mov               leveltwo[11], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level2BlockDestroy
	Level2Block13:                  
	                                xor               ax, ax
	                                mov               ax, 14087
	Level2Block13While:             
	                                cmp               dx, ax
	                                je                Level2Block13Destroy
	                                inc               ax
	                                cmp               ax, 14137
	                                jne               Level2Block13While
	                                jmp               Level2Block13NoDestroy
	Level2Block13Destroy:           
	                                dibujarBloques    12487, 0
	                                mov               leveltwo[12], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level2BlockDestroy
	Level2Block14:                  
	                                xor               ax, ax
	                                mov               ax, 14137
	Level2Block14While:             
	                                cmp               dx, ax
	                                je                Level2Block14Destroy
	                                inc               ax
	                                cmp               ax, 14187
	                                jne               Level2Block14While
	                                jmp               Level2Block14NoDestroy
	Level2Block14Destroy:           
	                                dibujarBloques    12537, 0
	                                mov               leveltwo[13], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level2BlockDestroy
	Level2Block15:                  
	                                xor               ax, ax
	                                mov               ax, 14187
	Level2Block15While:             
	                                cmp               dx, ax
	                                je                Level2Block15Destroy
	                                inc               ax
	                                cmp               ax, 14237
	                                jne               Level2Block15While
	                                jmp               Level2Block15NoDestroy
	Level2Block15Destroy:           
	                                dibujarBloques    12587,0
	                                mov               leveltwo[14], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level2BlockDestroy
	Level2Block16:                  
	                                xor               ax, ax
	                                mov               ax, 14237
	Level2Block16While:             
	                                cmp               dx, ax
	                                je                Level2Block16Destroy
	                                inc               ax
	                                cmp               ax, 14287
	                                jne               Level2Block16While
	                                jmp               Level2Block16NoDestroy
	Level2Block16Destroy:           
	                                dibujarBloques    12637, 0
	                                mov               leveltwo[15], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level2BlockDestroy
	Level2Block17:                  
	                                xor               ax, ax
	                                mov               ax, 14287
	Level2Block17While:             
	                                cmp               dx, ax
	                                je                Level2Block17Destroy
	                                inc               ax
	                                cmp               ax, 14337
	                                jne               Level2Block17While
	                                jmp               Level2Block17NoDestroy
	Level2Block17Destroy:           
	                                dibujarBloques    12687, 0
	                                mov               leveltwo[16], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level2BlockDestroy
	Level2Block18:                  
	                                xor               ax, ax
	                                mov               ax, 14337
	Level2Block18While:             
	                                cmp               dx, ax
	                                je                Level2Block18Destroy
	                                inc               ax
	                                cmp               ax, 14387
	                                jne               Level2Block18While
	                                jmp               Level2Block18NoDestroy
	Level2Block18Destroy:           
	                                dibujarBloques    12737, 0
	                                mov               leveltwo[17], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level2BlockDestroy
	Level2Block19:                  
	                                xor               ax, ax
	                                mov               ax, 16647
	Level2Block19While:             
	                                cmp               dx, ax
	                                je                Level2Block19Destroy
	                                inc               ax
	                                cmp               ax, 16697
	                                jne               Level2Block19While
	                                jmp               Level2Block19NoDestroy
	Level2Block19Destroy:           
	                                dibujarBloques    15047, 0
	                                mov               leveltwo[18], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level2BlockDestroy
	Level2Block20:                  
	                                xor               ax, ax
	                                mov               ax, 16697
	Level2Block20While:             
	                                cmp               dx, ax
	                                je                Level2Block20Destroy
	                                inc               ax
	                                cmp               ax, 16747
	                                jne               Level2Block20While
	                                jmp               Level2Block20NoDestroy
	Level2Block20Destroy:           
	                                dibujarBloques    15097, 0
	                                mov               leveltwo[19], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level2BlockDestroy
	Level2Block21:                  
	                                xor               ax, ax
	                                mov               ax, 16747
	Level2Block21While:             
	                                cmp               dx, ax
	                                je                Level2Block21Destroy
	                                inc               ax
	                                cmp               ax, 16797
	                                jne               Level2Block21While
	                                jmp               Level2Block21NoDestroy
	Level2Block21Destroy:           
	                                dibujarBloques    15147, 0
	                                mov               leveltwo[20], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level2BlockDestroy
	Level2Block22:                  
	                                xor               ax, ax
	                                mov               ax, 16797
	Level2Block22While:             
	                                cmp               dx, ax
	                                je                Level2Block22Destroy
	                                inc               ax
	                                cmp               ax, 16847
	                                jne               Level2Block22While
	                                jmp               Level2Block22NoDestroy
	Level2Block22Destroy:           
	                                dibujarBloques    15197, 0
	                                mov               leveltwo[21], 0
	                                pop               ax
	                                pop               cx
	                                add               ch,1
	                                push              cx
	                                push              ax
	                                jmp               Level2BlockDestroy
	Level2Block23:                  
	                                xor               ax, ax
	                                mov               ax, 16847
	Level2Block23While:             
	                                cmp               dx, ax
	                                je                Level2Block23Destroy
	                                inc               ax
	                                cmp               ax, 16897
	                                jne               Level2Block23While
	                                jmp               Level2Block23NoDestroy
	Level2Block23Destroy:           
	                                dibujarBloques    15247, 0
	                                mov               leveltwo[22], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level2BlockDestroy
	Level2Block24:                  
	                                xor               ax, ax
	                                mov               ax, 16897
	Level2Block24While:             
	                                cmp               dx, ax
	                                je                Level2Block24Destroy
	                                inc               ax
	                                cmp               ax, 16947
	                                jne               Level2Block24While
	                                jmp               Level2Block24NoDestroy
	Level2Block24Destroy:           
	                                dibujarBloques    15297, 0
	                                mov               leveltwo[23], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level2BlockDestroy
	Level2BlockDestroy:             
	                                cmp               bl, 1
	                                je                Level2BlockCuadrante1
	                                cmp               bl,2
	                                je                Level2BlockCuadrante2
	                                cmp               bl,3
	                                je                Level2BlockCuadrante3
	                                cmp               bl, 4
	                                je                Level2BlockCuadrante4
	                                jmp               Level2ContinueAction
	Level2BlockCuadrante1:          
	                                mov               bl, 4
	                                jmp               Level2ContinueAction
	Level2BlockCuadrante2:          
	                                mov               bl, 3
	                                jmp               Level2ContinueAction
	Level2BlockCuadrante3:          
	                                mov               bl, 2
	                                jmp               Level2ContinueAction
	Level2BlockCuadrante4:          
	                                mov               bl, 1
	                                jmp               Level2ContinueAction
	Level2ContinueAction:           
	                                xor               ax, ax
	                                mov               al, delayGamePlay
	                                delay             ax
	                                pop               ax
	                                pop               cx
	                                push              ax
	                                push              bx
	                                push              cx
	                                push              dx
	Level2UpdateScore:              
	                                push              bx
	                                xor               bx, bx
	                                mov               bl, ch
	                                call              showNumber
	                                push              cx
	                                mov               ah,02h
	                                mov               bh,0
	                                mov               dh,1
	                                mov               dl,23
	                                int               10h
	                                pop               dx
	                                push              dx
	                                mov               ah,0ah
	                                mov               al,dl
	                                mov               bh,0
	                                mov               cx,1
	                                int               10h
	                                mov               ah,02h
	                                mov               bh,0
	                                mov               dh,1
	                                mov               dl,24
	                                int               10h
	                                pop               dx
	                                mov               ah,0ah
	                                mov               al,dh
	                                mov               bh,0
	                                mov               cx,1
	                                int               10h
	                                pop               bx
	                                pop               dx
	                                pop               cx
	                                pop               bx
	                                pop               ax
	                                push              ax
	                                push              dx
	                                push              bx
	                                mov               bx, cx
	                                mov               ah, 2ch
	                                int               21h
	                                xor               ax, ax
	                                mov               al, cl
	                                mov               ch, 60
	                                mul               ch
	                                mov               dl, dh
	                                mov               dh, 0
	                                add               ax, dx
	                                mov               dx, time
	                                cmp               ax, dx
	                                jg                Level2AddSegundo
	                                jmp               Level2NotAddSegundo
	Level2AddSegundo:               
	                                mov               cx, bx
	                                inc               cl
	                                mov               time, ax
	                                push              cx
	                                xor               ax,ax
	                                mov               al,cl
	                                mov               bl,60
	                                div               bl
	                                push              ax
	                                mov               ch,al
	                                add               ch,30h
	                                mov               ah,02h
	                                mov               bh,0
	                                mov               dh,1
	                                mov               dl,30
	                                int               10h
	                                mov               ah,0ah
	                                mov               al,ch
	                                mov               bh,0
	                                mov               cx,1
	                                int               10h
	                                mov               ah,02h
	                                mov               bh,0
	                                mov               dh,1
	                                mov               dl,31
	                                int               10h
	                                mov               ah,0ah
	                                mov               al,58
	                                mov               bh,0
	                                mov               cx,1
	                                int               10h
	                                pop               ax
	                                mov               al,ah
	                                mov               ah,0
	                                mov               bx,ax
	                                call              showNumber
	                                push              cx
	                                mov               ah,02h
	                                mov               bh,0
	                                mov               dh,1
	                                mov               dl,32
	                                int               10h
	                                mov               ah,0ah
	                                mov               al,cl
	                                mov               bh,0
	                                mov               cx,1
	                                int               10h
	                                pop               cx
	                                mov               ah,02h
	                                mov               bh,0
	                                mov               dh,1
	                                mov               dl,33
	                                int               10h
	                                mov               ah,0ah
	                                mov               al,ch
	                                mov               bh,0
	                                mov               cx,1
	                                int               10h
	                                pop               cx
	                                jmp               Level2AddSegundoContinue
	Level2NotAddSegundo:            
	                                mov               cx, bx
	Level2AddSegundoContinue:       
	                                pop               bx
	                                pop               dx
	                                pop               ax
	                                cmp               ch, 24
	                                push              bx
	                                push              dx
	                                push              cx
	                                xor               cx, cx
	Level2CountBlocks:              
	                                xor               dx, dx
	                                mov               dl, leveltwo[bx]
	                                cmp               dl, 0
	                                je                Level2CountBlocksAdd
	                                jmp               Level2CountBlocksContinue
	Level2CountBlocksAdd:           
	                                inc               cx
	Level2CountBlocksContinue:      
	                                inc               bx
	                                cmp               bx, 24
	                                jne               Level2CountBlocks
	                                cmp               cx, 12
	                                je                Level2AddBall
	                                cmp               cx, 23
	                                je                Level2Win
	                                jmp               Level2NotAddBall
	Level2Win:                      
	                                pop               cx
	                                pop               dx
	                                pop               bx
	                                jmp               Level2EndNivel2
	Level2AddBall:                  
	                                cmp               segundaBall, 0
	                                jne               Level2NotAddBall
	                                mov               segundoCuadrante, 1
	                                mov               segundaBall, 48160
	                                mov               delayGamePlay, 100
	Level2NotAddBall:               
	                                pop               cx
	                                pop               dx
	                                pop               bx
	                                cmp               ch, 36
	                                je                Level2EndNivel2
	                                jmp               Level2Action
	Level2EndNivel2:                
	                                mov               currentTime, cx
	                                call              modoTexto
	                                call              modoGrafico
	                                push              ds
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 5
	                                int               10h
	                                printArray        info
	                                mov               ah,02h
	                                mov               bh,0
	                                mov               dh,1
	                                mov               dl,14
	                                int               10h
	                                mov               ah,0ah
	                                mov               al,76
	                                mov               bh,0
	                                mov               cx,1
	                                int               10h
	                                mov               ah,02h
	                                mov               bh,0
	                                mov               dh,1
	                                mov               dl,15
	                                int               10h
	                                mov               ah,0ah
	                                mov               al,51
	                                mov               bh,0
	                                mov               cx,1
	                                int               10h
	                                pop               ds
	                                mov               startLevel, 0
	                                mov               startLevel, 0
	                                mov               primerCuadrante, 0
	                                mov               segundoCuadrante, 0
	                                mov               tercerCuadrante, 0
	                                mov               swapBall, 0
	                                mov               segundaBall, 0
	                                mov               primeraBall, 0
	                                mov               terceraBall, 0
	                                mov               delayGamePlay, 120
	                                call              dibujarMargen
	                                call              iniciarJuego3
	                                jmp               Level2Finish
	Level2Lost:                     
	                                pop               ax
	                                pop               cx
	                                mov               currentLevel, 50
	                                mov               finalScore, ch
	                                mov               finalTime, cl
	                                call              addResume
	                                mov               currentLevel, 0
	                                mov               finalScore, 0
	                                mov               finalTime, 0
	Level2Finish:                   
	Level2CleanFinish:              
	                                mov               startLevel, 0
	                                mov               time, 0
	                                mov               currentTime, 0
	                                mov               delayGamePlay, 0
	                                mov               primerCuadrante, 0
	                                mov               segundoCuadrante, 0
	                                mov               tercerCuadrante, 0
	                                mov               swapBall, 0
	                                mov               terceraBall, 0
	                                mov               segundaBall, 0
	                                mov               primeraBall, 0
	                                ret
iniciarJuego2 ENDP

	;proc para inicial con el nivel 3 del juego
iniciarJuego3 PROC
	                                mov               dx, 58735
	                                xor               cx, cx
	                                mov               cx, currentTime
	                                xor               bx, bx
	                                xor               ax, ax
	                                mov               ax, 59680
	                                dibujarBarraJuego ax, 44
	                                dibujarBloques    7367,71
	                                dibujarBloques    7417,72
	                                dibujarBloques    7467,73
	                                dibujarBloques    7517,74
	                                dibujarBloques    7567,75
	                                dibujarBloques    7617,76
	                                dibujarBloques    9927,76
	                                dibujarBloques    9977,75
	                                dibujarBloques    10027,74
	                                dibujarBloques    10077,73
	                                dibujarBloques    10127,72
	                                dibujarBloques    10177,71
	                                dibujarBloques    12487,43
	                                dibujarBloques    12537,44
	                                dibujarBloques    12587,45
	                                dibujarBloques    12637,46
	                                dibujarBloques    12687,47
	                                dibujarBloques    12737,48
	                                dibujarBloques    15047,48
	                                dibujarBloques    15097,47
	                                dibujarBloques    15147,46
	                                dibujarBloques    15197,45
	                                dibujarBloques    15247,44
	                                dibujarBloques    15297,43
	                                dibujarBloques    17607,71
	                                dibujarBloques    17657,72
	                                dibujarBloques    17707,73
	                                dibujarBloques    17757,74
	                                dibujarBloques    17807,75
	                                dibujarBloques    17857,76
	                                dibujarBloques    20167,76
	                                dibujarBloques    20217,75
	                                dibujarBloques    20267,74
	                                dibujarBloques    20317,73
	                                dibujarBloques    20367,72
	                                dibujarBloques    20417,71
	                                mov               levelthree[0], 1
	                                mov               levelthree[1], 1
	                                mov               levelthree[2], 1
	                                mov               levelthree[3], 1
	                                mov               levelthree[4], 1
	                                mov               levelthree[5], 1
	                                mov               levelthree[6], 1
	                                mov               levelthree[7], 1
	                                mov               levelthree[8], 1
	                                mov               levelthree[9], 1
	                                mov               levelthree[10], 1
	                                mov               levelthree[11], 1
	                                mov               levelthree[12], 1
	                                mov               levelthree[13], 1
	                                mov               levelthree[14], 1
	                                mov               levelthree[15], 1
	                                mov               levelthree[16], 1
	                                mov               levelthree[17], 1
	                                mov               levelthree[18], 1
	                                mov               levelthree[19], 1
	                                mov               levelthree[20], 1
	                                mov               levelthree[21], 1
	                                mov               levelthree[22], 1
	                                mov               levelthree[23], 1
	                                mov               levelthree[24], 1
	                                mov               levelthree[25], 1
	                                mov               levelthree[26], 1
	                                mov               levelthree[27], 1
	                                mov               levelthree[28], 1
	                                mov               levelthree[29], 1
	                                mov               levelthree[30], 1
	                                mov               levelthree[31], 1
	                                mov               levelthree[32], 1
	                                mov               levelthree[33], 1
	                                mov               levelthree[34], 1
	                                mov               levelthree[35], 1
	                                pintaBolita       dx, 40
	                                mov               bl, 1
	Level3Action:                   
	                                cmp               segundaBall, 0
	                                jmp               Level3ActiveSegundaBall
	                                jmp               Level3NoBallSwap
	Level3ActiveSegundaBall:        
	                                cmp               terceraBall, 0
	                                jne               Level3ActiveTerceraBall
	                                cmp               swapBall, 0
	                                je                Level3FirstBallTurnOne
	                                cmp               swapBall, 1
	                                je                Level3SecondBallTurnOne
	                                jmp               Level3NoBallSwap
	Level3FirstBallTurnOne:         
	                                mov               primeraBall, dx
	                                mov               primerCuadrante, bl
	                                mov               dx, segundaBall
	                                mov               bl, segundoCuadrante
	                                mov               swapBall, 1
	                                jmp               Level3NoBallSwap
	Level3SecondBallTurnOne:        
	                                mov               segundaBall, dx
	                                mov               segundoCuadrante, bl
	                                mov               dx, primeraBall
	                                mov               bl, primerCuadrante
	                                mov               swapBall, 0
	                                jmp               Level3NoBallSwap
	Level3ActiveTerceraBall:        
	                                cmp               swapBall, 0
	                                je                Level3FirstBallTurnTwo
	                                cmp               swapBall, 1
	                                je                Level3SecondBallTurnTwo
	                                cmp               swapBall, 2
	                                je                Level3ThirdBallTurnTwo
	                                jmp               Level3NoBallSwap
	Level3FirstBallTurnTwo:         
	                                mov               primeraBall, dx
	                                mov               primerCuadrante, bl
	                                mov               dx, segundaBall
	                                mov               bl, segundoCuadrante
	                                mov               swapBall, 1
	                                jmp               Level3NoBallSwap
	Level3SecondBallTurnTwo:        
	                                mov               segundaBall, dx
	                                mov               segundoCuadrante, bl
	                                mov               dx, terceraBall
	                                mov               bl, tercerCuadrante
	                                mov               swapBall, 2
	                                jmp               Level3NoBallSwap
	Level3ThirdBallTurnTwo:         
	                                mov               terceraBall, dx
	                                mov               tercerCuadrante, bl
	                                mov               dx, primeraBall
	                                mov               bl, primerCuadrante
	                                mov               swapBall, 0
	                                jmp               Level3NoBallSwap
	Level3NoBallSwap:               
	                                push              cx
	                                push              bx
	                                mov               bx, ax
	                                mov               ah, 01h
	                                int               16h
	                                jz                Level3NoBarChanges
	                                mov               ah, 00h
	                                int               16h
	                                cmp               ah, 4dh
	                                je                Level3MoveBarToDerecha
	                                cmp               ah, 4bh
	                                je                Level3MoveBarToIzquierda
	                                cmp               ah, 57
	                                je                Level3Start
	                                cmp               ah, 1
	                                je                Level3Pause
	                                jmp               Level3NoBarChanges
	Level3MoveBarToDerecha:         
	                                cmp               bx, 59800
	                                jge               Level3NoBarChanges
	                                dibujarBarraJuego bx, 0
	                                add               bx, 8
	                                dibujarBarraJuego bx, 44
	                                cmp               startLevel, 1
	                                je                Level3NoBarChanges
	                                pintaBolita       dx, 0
	                                add               dx, 8
	                                pintaBolita       dx, 40
	                                jmp               Level3NoBarChanges
	Level3MoveBarToIzquierda:       
	                                cmp               bx, 59530
	                                jle               Level3NoBarChanges
	                                dibujarBarraJuego bx, 0
	                                sub               bx, 8
	                                dibujarBarraJuego bx, 44
	                                cmp               startLevel, 1
	                                je                Level3NoBarChanges
	                                pintaBolita       dx, 0
	                                sub               dx, 8
	                                pintaBolita       dx, 40
	Level3Start:                    
	                                mov               startLevel, 1
	                                jmp               Level3NoBarChanges
	Level3Pause:                    
	                                mov               ah, 01h
	                                int               16h
	                                jz                Level3Pause
	                                mov               ah, 00h
	                                int               16h
	                                cmp               ah, 1
	                                je                Level3NoBarChanges
	                                cmp               ah, 57
	                                je                Level3PauseExit
	                                cmp               ah, 2
	                                je                Level3GoToLevel1
	                                cmp               ah, 3
	                                je                Level3GoToLevel2
	                                cmp               ah, 4
	                                je                Level3GoToLevel3
	                                jmp               Level3Pause
	Level3PauseExit:                
	                                pop               bx
	                                pop               cx
	                                mov               currentLevel, 51
	                                mov               finalScore, ch
	                                call              addResume
	                                mov               currentLevel, 0
	                                mov               finalScore, 0
	                                mov               finalTime, 0
	                                jmp               Level3Finish
	Level3GoToLevel1:               
	                                pop               bx
	                                pop               cx
	                                mov               startLevel, 0
	                                mov               time, 0
	                                mov               currentTime, 0
	                                mov               delayGamePlay, 0
	                                mov               primerCuadrante, 0
	                                mov               segundoCuadrante, 0
	                                mov               tercerCuadrante, 0
	                                mov               swapBall, 0
	                                mov               terceraBall, 0
	                                mov               segundaBall, 0
	                                mov               primeraBall, 0
	                                call              modoGrafico
	                                push              ds
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 5
	                                int               10h
	                                printArray        info
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 14
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, 76
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 15
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, 49
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                pop               ds
	                                call              dibujarMargen
	                                call              iniciarJuego1
	                                jmp               Level3CleanFinish
	Level3GoToLevel2:               
	                                pop               bx
	                                pop               cx
	                                mov               startLevel, 0
	                                mov               time, 0
	                                mov               currentTime, 0
	                                mov               delayGamePlay, 130
	                                mov               primerCuadrante, 0
	                                mov               segundoCuadrante, 0
	                                mov               tercerCuadrante, 0
	                                mov               swapBall, 0
	                                mov               terceraBall, 0
	                                mov               segundaBall, 0
	                                mov               primeraBall, 0
	                                call              modoGrafico
	                                push              ds
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 5
	                                int               10h
	                                printArray        info
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 14
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, 76
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 15
	                                mov               ah, 0ah
	                                mov               al, 50
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                pop               ds
	                                call              dibujarMargen
	                                mov               startLevel, 0
	                                mov               delayGamePlay, 130
	                                call              iniciarJuego2
	                                jmp               Level3CleanFinish
	Level3GoToLevel3:               
	                                pop               bx
	                                pop               cx
	                                mov               startLevel, 0
	                                mov               time, 0
	                                mov               currentTime, 0
	                                mov               delayGamePlay, 120
	                                mov               primerCuadrante, 0
	                                mov               segundoCuadrante, 0
	                                mov               tercerCuadrante, 0
	                                mov               swapBall, 0
	                                mov               terceraBall, 0
	                                mov               segundaBall, 0
	                                mov               primeraBall, 0
	                                call              modoGrafico
	                                push              ds
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 5
	                                int               10h
	                                printArray        info
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 14
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, 76
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 15
	                                int               10h
	                                mov               ah, 0ah
	                                mov               al, 51
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                pop               ds
	                                call              dibujarMargen
	                                call              iniciarJuego3
	                                jmp               Level3CleanFinish
	Level3NoBarChanges:             
	                                mov               ax, bx
	                                mov               cx, ax
	                                pop               bx
	                                push              ax
	                                cmp               startLevel, 0
	                                je                Level3EndAction
	                                cmp               bl, 1
	                                je                Level3Cuadrante1
	                                cmp               bl,2
	                                je                Level3Cuadrante2
	                                cmp               bl, 3
	                                je                Level3Cuadrante3
	                                cmp               bl, 4
	                                je                Level3Cuadrante4
	                                jmp               Level3EndAction
	Level3Cuadrante1:               
	                                pintaBolita       dx, 0
	                                sub               dx, 319
	                                pintaBolita       dx, 40
	                                xor               ax, ax
	                                mov               ax, 7047
	Level3Cuadrante1Top:            
	                                cmp               dx, ax
	                                je                Level3Cuadrante1TopChange
	                                inc               ax
	                                cmp               ax, 7352
	                                jne               Level3Cuadrante1Top
	                                xor               ax, ax
	                                mov               ax, 7351
	Level3Cuadrante1Derecha:        
	                                cmp               dx, ax
	                                je                Level3Cuadrante1DerechaChange
	                                add               ax, 320
	                                cmp               ax, 60151
	                                jne               Level3Cuadrante1Derecha
	                                jmp               Level3EndAction
	Level3Cuadrante1TopChange:      
	                                pintaBolita       dx, 0
	                                add               dx, 319
	                                pintaBolita       dx, 40
	                                mov               bl, 4
	                                jmp               Level3EndAction
	Level3Cuadrante1DerechaChange:  
	                                pintaBolita       dx, 0
	                                add               dx, 319
	                                pintaBolita       dx, 40
	                                mov               bl, 2
	                                jmp               Level3EndAction
	Level3Cuadrante2:               
	                                pintaBolita       dx, 0
	                                sub               dx, 321
	                                pintaBolita       dx, 40
	                                xor               ax, ax
	                                mov               ax, 7047
	Level3Cuadrante2Top:            
	                                cmp               dx, ax
	                                je                Level3Cuadrante2TopChange
	                                inc               ax
	                                cmp               ax, 7352
	                                jne               Level3Cuadrante2Top
	                                xor               ax, ax
	                                mov               ax, 7047
	Level3Cuadrante2Izquierda:      
	                                cmp               dx, ax
	                                je                Level3Cuadrante2IzquierdaChange
	                                add               ax, 320
	                                cmp               ax, 60167
	                                jne               Level3Cuadrante2Izquierda
	                                jmp               Level3EndAction
	Level3Cuadrante2TopChange:      
	                                pintaBolita       dx, 0
	                                add               dx, 321
	                                pintaBolita       dx, 40
	                                mov               bl, 3
	                                jmp               Level3EndAction
	Level3Cuadrante2IzquierdaChange:
	                                pintaBolita       dx, 0
	                                add               dx, 321
	                                pintaBolita       dx, 40
	                                mov               bl, 1
	                                jmp               Level3EndAction
	Level3Cuadrante3:               
	                                pintaBolita       dx, 0
	                                add               dx, 319
	                                pintaBolita       dx, 40
	                                xor               ax, ax
	                                mov               ax, 7047
	Level3Cuadrante3Izquierda:      
	                                cmp               dx, ax
	                                je                Level3Cuadrante3IzquierdaChange
	                                add               ax, 320
	                                cmp               ax, 60167
	                                jne               Level3Cuadrante3Izquierda
	                                xor               ax, ax
	                                mov               ax, cx
	                                add               cx, 32
	Level3Cuadrante3Bottom:         
	                                cmp               dx, ax
	                                je                Level3Cuadrante3BottomChange
	                                inc               ax
	                                cmp               ax, cx
	                                jne               Level3Cuadrante3Bottom
	                                xor               ax, ax
	                                mov               ax, 60805
	Level3Cuadrante3Lost:           
	                                cmp               dx, ax
	                                je                Level3Lost
	                                inc               ax
	                                cmp               ax, 61114
	                                jne               Level3Cuadrante3Lost
	                                jmp               Level3EndAction
	Level3Cuadrante3BottomChange:   
	                                pintaBolita       dx, 0
	                                sub               dx, 319
	                                pintaBolita       dx, 40
	                                mov               bl, 2
	                                jmp               Level3EndAction
	Level3Cuadrante3IzquierdaChange:
	                                pintaBolita       dx, 0
	                                sub               dx, 319
	                                pintaBolita       dx, 40
	                                mov               bl, 4
	                                jmp               Level3EndAction
	Level3Cuadrante4:               
	                                pintaBolita       dx, 0
	                                add               dx, 321
	                                pintaBolita       dx, 40
	                                xor               ax, ax
	                                mov               ax, 7351
	Level3Cuadrante4Derecha:        
	                                cmp               dx, ax
	                                je                Level3Cuadrante4DerechaChange
	                                add               ax, 320
	                                cmp               ax, 60151
	                                jne               Level3Cuadrante4Derecha
	                                xor               ax, ax
	                                mov               ax, cx
	                                add               cx, 32
	Level3Cuadrante4Bottom:         
	                                cmp               dx, ax
	                                je                Level3Cuadrante4BottomChange
	                                inc               ax
	                                cmp               ax, cx
	                                jne               Level3Cuadrante4Bottom
	                                xor               ax, ax
	                                mov               ax, 60805
	Level3Cuadrante4Lost:           
	                                cmp               dx, ax
	                                je                Level3Lost
	                                inc               ax
	                                cmp               ax, 61114
	                                jne               Level3Cuadrante4Lost
	                                jmp               Level3EndAction
	Level3Cuadrante4BottomChange:   
	                                pintaBolita       dx, 0
	                                sub               dx, 321
	                                pintaBolita       dx, 40
	                                mov               bl, 1
	                                jmp               Level3EndAction
	Level3Cuadrante4DerechaChange:  
	                                pintaBolita       dx, 0
	                                sub               dx, 321
	                                pintaBolita       dx, 40
	                                mov               bl, 3
	                                jmp               Level3EndAction
	Level3EndAction:                
	                                xor               ax, ax
	                                mov               al, levelthree[0]
	                                cmp               al, 1
	                                je                Level3Block1
	Level3Block1NoDestroy:          
	                                mov               al, levelthree[1]
	                                cmp               al, 1
	                                je                Level3Block2
	Level3Block2NoDestroy:          
	                                mov               al, levelthree[2]
	                                cmp               al, 1
	                                je                Level3Block3
	Level3Block3NoDestroy:          
	                                mov               al, levelthree[3]
	                                cmp               al, 1
	                                je                Level3Block4
	Level3Block4NoDestroy:          
	                                mov               al, levelthree[4]
	                                cmp               al, 1
	                                je                Level3Block5
	Level3Block5NoDestroy:          
	                                mov               al, levelthree[5]
	                                cmp               al, 1
	                                je                Level3Block6
	Level3Block6NoDestroy:          
	                                mov               al, levelthree[6]
	                                cmp               al, 1
	                                je                Level3Block7
	Level3Block7NoDestroy:          
	                                mov               al, levelthree[7]
	                                cmp               al, 1
	                                je                Level3Block8
	Level3Block8NoDestroy:          
	                                mov               al, levelthree[8]
	                                cmp               al, 1
	                                je                Level3Block9
	Level3Block9NoDestroy:          
	                                mov               al, levelthree[9]
	                                cmp               al, 1
	                                je                Level3Block10
	Level3Block10NoDestroy:         
	                                mov               al, levelthree[10]
	                                cmp               al, 1
	                                je                Level3Block11
	Level3Block11NoDestroy:         
	                                mov               al, levelthree[11]
	                                cmp               al, 1
	                                je                Level3Block12
	Level3Block12NoDestroy:         
	                                mov               al, levelthree[12]
	                                cmp               al, 1
	                                je                Level3Block13
	Level3Block13NoDestroy:         
	                                mov               al, levelthree[13]
	                                cmp               al, 1
	                                je                Level3Block14
	Level3Block14NoDestroy:         
	                                mov               al, levelthree[14]
	                                cmp               al, 1
	                                je                Level3Block15
	Level3Block15NoDestroy:         
	                                mov               al, levelthree[15]
	                                cmp               al, 1
	                                je                Level3Block16
	Level3Block16NoDestroy:         
	                                mov               al, levelthree[16]
	                                cmp               al, 1
	                                je                Level3Block17
	Level3Block17NoDestroy:         
	                                mov               al, levelthree[17]
	                                cmp               al, 1
	                                je                Level3Block18
	Level3Block18NoDestroy:         
	                                mov               al, levelthree[18]
	                                cmp               al, 1
	                                je                Level3Block19
	Level3Block19NoDestroy:         
	                                mov               al, levelthree[19]
	                                cmp               al, 1
	                                je                Level3Block20
	Level3Block20NoDestroy:         
	                                mov               al, levelthree[20]
	                                cmp               al, 1
	                                je                Level3Block21
	Level3Block21NoDestroy:         
	                                mov               al, levelthree[21]
	                                cmp               al, 1
	                                je                Level3Block22
	Level3Block22NoDestroy:         
	                                mov               al, levelthree[22]
	                                cmp               al, 1
	                                je                Level3Block23
	Level3Block23NoDestroy:         
	                                mov               al, levelthree[23]
	                                cmp               al, 1
	                                je                Level3Block24
	Level3Block24NoDestroy:         
	                                mov               al, levelthree[24]
	                                cmp               al, 1
	                                je                Level3Block25
	Level3Block25NoDestroy:         
	                                mov               al, levelthree[25]
	                                cmp               al, 1
	                                je                Level3Block26
	Level3Block26NoDestroy:         
	                                mov               al, levelthree[26]
	                                cmp               al, 1
	                                je                Level3Block27
	Level3Block27NoDestroy:         
	                                mov               al, levelthree[27]
	                                cmp               al, 1
	                                je                Level3Block28
	Level3Block28NoDestroy:         
	                                mov               al, levelthree[28]
	                                cmp               al, 1
	                                je                Level3Block29
	Level3Block29NoDestroy:         
	                                mov               al, levelthree[29]
	                                cmp               al, 1
	                                je                Level3Block30
	Level3Block30NoDestroy:         
	                                mov               al, levelthree[30]
	                                cmp               al, 1
	                                je                Level3Block31
	Level3Block31NoDestroy:         
	                                mov               al, levelthree[31]
	                                cmp               al, 1
	                                je                Level3Block32
	Level3Block32NoDestroy:         
	                                mov               al, levelthree[32]
	                                cmp               al, 1
	                                je                Level3Block33
	Level3Block33NoDestroy:         
	                                mov               al, levelthree[33]
	                                cmp               al, 1
	                                je                Level3Block34
	Level3Block34NoDestroy:         
	                                mov               al, levelthree[34]
	                                cmp               al, 1
	                                je                Level3Block35
	Level3Block35NoDestroy:         
	                                mov               al, levelthree[35]
	                                cmp               al, 1
	                                je                Level3Block36
	Level3Block36NoDestroy:         
	                                jmp               Level3ContinueAction
	Level3Block1:                   
	                                xor               ax, ax
	                                mov               ax, 8967
	Level3Block1While:              
	                                cmp               dx, ax
	                                je                Level3Block1Destroy
	                                inc               ax
	                                cmp               ax, 9017
	                                jne               Level3Block1While
	                                jmp               Level3Block1NoDestroy
	Level3Block1Destroy:            
	                                dibujarBloques    7367, 0
	                                mov               levelthree[0], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block2:                   
	                                xor               ax, ax
	                                mov               ax, 9017
	Level3Block2While:              
	                                cmp               dx, ax
	                                je                Level3Block2Destroy
	                                inc               ax
	                                cmp               ax, 9067
	                                jne               Level3Block2While
	                                jmp               Level3Block2NoDestroy
	Level3Block2Destroy:            
	                                dibujarBloques    7417, 0
	                                mov               levelthree[1], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block3:                   
	                                xor               ax, ax
	                                mov               ax, 9067
	Level3Block3While:              
	                                cmp               dx, ax
	                                je                Level3Block3Destroy
	                                inc               ax
	                                cmp               ax, 9117
	                                jne               Level3Block3While
	                                jmp               Level3Block3NoDestroy
	Level3Block3Destroy:            
	                                dibujarBloques    7467, 0
	                                mov               levelthree[2], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block4:                   
	                                xor               ax, ax
	                                mov               ax, 9117
	Level3Block4While:              
	                                cmp               dx, ax
	                                je                Level3Block4Destroy
	                                inc               ax
	                                cmp               ax, 9167
	                                jne               Level3Block4While
	                                jmp               Level3Block4NoDestroy
	Level3Block4Destroy:            
	                                dibujarBloques    7517, 0
	                                mov               levelthree[3], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block5:                   
	                                xor               ax, ax
	                                mov               ax, 9167
	Level3Block5While:              
	                                cmp               dx, ax
	                                je                Level3Block5Destroy
	                                inc               ax
	                                cmp               ax, 9217
	                                jne               Level3Block5While
	                                jmp               Level3Block5NoDestroy
	Level3Block5Destroy:            
	                                dibujarBloques    7567, 0
	                                mov               levelthree[4], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block6:                   
	                                xor               ax, ax
	                                mov               ax, 9217
	Level3Block6While:              
	                                cmp               dx, ax
	                                je                Level3Block6Destroy
	                                inc               ax
	                                cmp               ax, 9267
	                                jne               Level3Block6While
	                                jmp               Level3Block6NoDestroy
	Level3Block6Destroy:            
	                                dibujarBloques    7617, 0
	                                mov               levelthree[5], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block7:                   
	                                xor               ax, ax
	                                mov               ax, 11527
	Level3Block7While:              
	                                cmp               dx, ax
	                                je                Level3Block7Destroy
	                                inc               ax
	                                cmp               ax, 11577
	                                jne               Level3Block7While
	                                jmp               Level3Block7NoDestroy
	Level3Block7Destroy:            
	                                dibujarBloques    9927, 0
	                                mov               levelthree[6], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block8:                   
	                                xor               ax, ax
	                                mov               ax, 11577
	Level3Block8While:              
	                                cmp               dx, ax
	                                je                Level3Block8Destroy
	                                inc               ax
	                                cmp               ax, 11627
	                                jne               Level3Block8While
	                                jmp               Level3Block8NoDestroy
	Level3Block8Destroy:            
	                                dibujarBloques    9977, 0
	                                mov               levelthree[7], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block9:                   
	                                xor               ax, ax
	                                mov               ax, 11627
	Level3Block9While:              
	                                cmp               dx, ax
	                                je                Level3Block9Destroy
	                                inc               ax
	                                cmp               ax, 11677
	                                jne               Level3Block9While
	                                jmp               Level3Block9NoDestroy
	Level3Block9Destroy:            
	                                dibujarBloques    10027, 0
	                                mov               levelthree[8], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block10:                  
	                                xor               ax, ax
	                                mov               ax, 11677
	Level3Block10While:             
	                                cmp               dx, ax
	                                je                Level3Block10Destroy
	                                inc               ax
	                                cmp               ax, 11727
	                                jne               Level3Block10While
	                                jmp               Level3Block10NoDestroy
	Level3Block10Destroy:           
	                                dibujarBloques    10077, 0
	                                mov               levelthree[9], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block11:                  
	                                mov               ax, ax
	                                mov               ax, 11727
	Level3Block11While:             
	                                cmp               dx, ax
	                                je                Level3Block11Destroy
	                                inc               ax
	                                cmp               ax, 11777
	                                jne               Level3Block11While
	                                jmp               Level3Block11NoDestroy
	Level3Block11Destroy:           
	                                dibujarBloques    10127, 0
	                                mov               levelthree[10], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block12:                  
	                                xor               ax, ax
	                                mov               ax, 11777
	Level3Block12While:             
	                                cmp               dx, ax
	                                je                Level3Block12Destroy
	                                inc               ax
	                                cmp               ax, 11827
	                                jne               Level3Block12While
	                                jmp               Level3Block12NoDestroy
	Level3Block12Destroy:           
	                                dibujarBloques    10177, 0
	                                mov               levelthree[11], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block13:                  
	                                xor               ax, ax
	                                mov               ax, 14087
	Level3Block13While:             
	                                cmp               dx, ax
	                                je                Level3Block13Destroy
	                                inc               ax
	                                cmp               ax, 14137
	                                jne               Level3Block13While
	                                jmp               Level3Block13NoDestroy
	Level3Block13Destroy:           
	                                dibujarBloques    12487, 0
	                                mov               levelthree[12], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block14:                  
	                                xor               ax, ax
	                                mov               ax, 14137
	Level3Block14While:             
	                                cmp               dx, ax
	                                je                Level3Block14Destroy
	                                inc               ax
	                                cmp               ax, 14187
	                                jne               Level3Block14While
	                                jmp               Level3Block14NoDestroy
	Level3Block14Destroy:           
	                                dibujarBloques    12537, 0
	                                mov               levelthree[13], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block15:                  
	                                xor               ax, ax
	                                mov               ax, 14187
	Level3Block15While:             
	                                cmp               dx, ax
	                                je                Level3Block15Destroy
	                                inc               ax
	                                cmp               ax, 14237
	                                jne               Level3Block15While
	                                jmp               Level3Block15NoDestroy
	Level3Block15Destroy:           
	                                dibujarBloques    12587, 0
	                                mov               levelthree[14], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block16:                  
	                                xor               ax, ax
	                                mov               ax, 14237
	Level3Block16While:             
	                                cmp               dx, ax
	                                je                Level3Block16Destroy
	                                inc               ax
	                                cmp               ax, 14287
	                                jne               Level3Block16While
	                                jmp               Level3Block16NoDestroy
	Level3Block16Destroy:           
	                                dibujarBloques    12637, 0
	                                mov               levelthree[15], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy

	Level3Block17:                  
	                                xor               ax, ax
	                                mov               ax, 14287
	Level3Block17While:             
	                                cmp               dx, ax
	                                je                Level3Block17Destroy
	                                inc               ax
	                                cmp               ax, 14337
	                                jne               Level3Block17While
	                                jmp               Level3Block17NoDestroy
	Level3Block17Destroy:           
	                                dibujarBloques    12687, 0
	                                mov               levelthree[16], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block18:                  
	                                xor               ax, ax
	                                mov               ax, 14337
	Level3Block18While:             
	                                cmp               dx, ax
	                                je                Level3Block18Destroy
	                                inc               ax
	                                cmp               ax, 14387
	                                jne               Level3Block18While
	                                jmp               Level3Block18NoDestroy
	Level3Block18Destroy:           
	                                dibujarBloques    12737, 0
	                                mov               levelthree[17], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block19:                  
	                                xor               ax, ax
	                                mov               ax, 16647
	Level3Block19While:             
	                                cmp               dx, ax
	                                je                Level3Block19Destroy
	                                inc               ax
	                                cmp               ax, 16697
	                                jne               Level3Block19While
	                                jmp               Level3Block19NoDestroy
	Level3Block19Destroy:           
	                                dibujarBloques    15047, 0
	                                mov               levelthree[18], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block20:                  
	                                xor               ax, ax
	                                mov               ax, 16697
	Level3Block20While:             
	                                cmp               dx, ax
	                                je                Level3Block20Destroy
	                                inc               ax
	                                cmp               ax, 16747
	                                jne               Level3Block20While
	                                jmp               Level3Block20NoDestroy
	Level3Block20Destroy:           
	                                dibujarBloques    15097, 0
	                                mov               levelthree[19], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block21:                  
	                                xor               ax, ax
	                                mov               ax, 16747
	Level3Block21While:             
	                                cmp               dx, ax
	                                je                Level3Block21Destroy
	                                inc               ax
	                                cmp               ax, 16797
	                                jne               Level3Block21While
	                                jmp               Level3Block21NoDestroy
	Level3Block21Destroy:           
	                                dibujarBloques    15147, 0
	                                mov               levelthree[20], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block22:                  
	                                xor               ax, ax
	                                mov               ax, 16797
	Level3Block22While:             
	                                cmp               dx, ax
	                                je                Level3Block22Destroy
	                                inc               ax
	                                cmp               ax, 16847
	                                jne               Level3Block22While
	                                jmp               Level3Block22NoDestroy
	Level3Block22Destroy:           
	                                dibujarBloques    15197, 0
	                                mov               levelthree[21], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block23:                  
	                                xor               ax, ax
	                                mov               ax, 16847
	Level3Block23While:             
	                                cmp               dx, ax
	                                je                Level3Block23Destroy
	                                inc               ax
	                                cmp               ax, 16897
	                                jne               Level3Block23While
	                                jmp               Level3Block23NoDestroy
	Level3Block23Destroy:           
	                                dibujarBloques    15247, 0
	                                mov               levelthree[22], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block24:                  
	                                xor               ax, ax
	                                mov               ax, 16897
	Level3Block24While:             
	                                cmp               dx, ax
	                                je                Level3Block24Destroy
	                                inc               ax
	                                cmp               ax, 16947
	                                jne               Level3Block24While
	                                jmp               Level3Block24NoDestroy
	Level3Block24Destroy:           
	                                dibujarBloques    15297, 0
	                                mov               levelthree[23], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block25:                  
	                                xor               ax, ax
	                                mov               ax, 19207
	Level3Block25While:             
	                                cmp               dx, ax
	                                je                Level3Block25Destroy
	                                inc               ax
	                                cmp               ax, 19257
	                                jne               Level3Block25While
	                                jmp               Level3Block25NoDestroy
	Level3Block25Destroy:           
	                                dibujarBloques    17607, 0
	                                mov               levelthree[24], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block26:                  
	                                xor               ax, ax
	                                mov               ax, 19257
	Level3Block26While:             
	                                cmp               dx, ax
	                                je                Level3Block26Destroy
	                                inc               ax
	                                cmp               ax, 19307
	                                jne               Level3Block26While
	                                jmp               Level3Block26NoDestroy
	Level3Block26Destroy:           
	                                dibujarBloques    17657, 0
	                                mov               levelthree[25], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block27:                  
	                                xor               ax, ax
	                                mov               ax, 19307
	Level3Block27While:             
	                                cmp               dx, ax
	                                je                Level3Block27Destroy
	                                inc               ax
	                                cmp               ax, 19357
	                                jne               Level3Block27While
	                                jmp               Level3Block27NoDestroy
	Level3Block27Destroy:           
	                                dibujarBloques    17707, 0
	                                mov               levelthree[26], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block28:                  
	                                xor               ax, ax
	                                mov               ax, 19357
	Level3Block28While:             
	                                cmp               dx, ax
	                                je                Level3Block28Destroy
	                                inc               ax
	                                cmp               ax, 19407
	                                jne               Level3Block28While
	                                jmp               Level3Block28NoDestroy
	Level3Block28Destroy:           
	                                dibujarBloques    17757, 0
	                                mov               levelthree[27], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block29:                  
	                                xor               ax, ax
	                                mov               ax, 19407
	Level3Block29While:             
	                                cmp               dx, ax
	                                je                Level3Block29Destroy
	                                inc               ax
	                                cmp               ax, 19457
	                                jne               Level3Block29While
	                                jmp               Level3Block29NoDestroy
	Level3Block29Destroy:           
	                                dibujarBloques    17807, 0
	                                mov               levelthree[28], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block30:                  
	                                xor               ax, ax
	                                mov               ax, 19457
	Level3Block30While:             
	                                cmp               dx, ax
	                                je                Level3Block30Destroy
	                                inc               ax
	                                cmp               ax, 19507
	                                jne               Level3Block30While
	                                jmp               Level3Block30NoDestroy
	Level3Block30Destroy:           
	                                dibujarBloques    17857, 0
	                                mov               levelthree[29], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block31:                  
	                                xor               ax, ax
	                                mov               ax, 21767
	Level3Block31While:             
	                                cmp               dx, ax
	                                je                Level3Block31Destroy
	                                inc               ax
	                                cmp               ax, 21817
	                                jne               Level3Block31While
	                                jmp               Level3Block31NoDestroy
	Level3Block31Destroy:           
	                                dibujarBloques    20167, 0
	                                mov               levelthree[30], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block32:                  
	                                xor               ax, ax
	                                mov               ax, 21817
	Level3Block32While:             
	                                cmp               dx, ax
	                                je                Level3Block32Destroy
	                                inc               ax
	                                cmp               ax, 21867
	                                jne               Level3Block32While
	                                jmp               Level3Block32NoDestroy
	Level3Block32Destroy:           
	                                dibujarBloques    20217, 0
	                                mov               levelthree[31], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block33:                  
	                                xor               ax, ax
	                                mov               ax, 21867
	Level3Block33While:             
	                                cmp               dx, ax
	                                je                Level3Block33Destroy
	                                inc               ax
	                                cmp               ax, 21917
	                                jne               Level3Block33While
	                                jmp               Level3Block33NoDestroy
	Level3Block33Destroy:           
	                                dibujarBloques    20267, 0
	                                mov               levelthree[32], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block34:                  
	                                xor               ax, ax
	                                mov               ax, 21917
	Level3Block34While:             
	                                cmp               dx, ax
	                                je                Level3Block34Destroy
	                                inc               ax
	                                cmp               ax, 21967
	                                jne               Level3Block34While
	                                jmp               Level3Block34NoDestroy
	Level3Block34Destroy:           
	                                dibujarBloques    20317, 0
	                                mov               levelthree[33], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block35:                  
	                                xor               ax, ax
	                                mov               ax, 21967
	Level3Block35While:             
	                                cmp               dx, ax
	                                je                Level3Block35Destroy
	                                inc               ax
	                                cmp               ax, 22017
	                                jne               Level3Block35While
	                                jmp               Level3Block35NoDestroy
	Level3Block35Destroy:           
	                                dibujarBloques    20367, 0
	                                mov               levelthree[34], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy
	Level3Block36:                  
	                                xor               ax, ax
	                                mov               ax, 22017
	Level3Block36While:             
	                                cmp               dx, ax
	                                je                Level3Block36Destroy
	                                inc               ax
	                                cmp               ax, 22067
	                                jne               Level3Block36While
	                                jmp               Level3Block36NoDestroy
	Level3Block36Destroy:           
	                                dibujarBloques    20417, 0
	                                mov               levelthree[35], 0
	                                pop               ax
	                                pop               cx
	                                add               ch, 1
	                                push              cx
	                                push              ax
	                                jmp               Level3BlockDestroy

	Level3BlockDestroy:             
	                                cmp               bl, 1
	                                je                Level3BlockCuadrante1
	                                cmp               bl, 2
	                                je                Level3BlockCuadrante2
	                                cmp               bl, 3
	                                je                Level3BlockCuadrante3
	                                cmp               bl, 4
	                                je                Level3BlockCuadrante4
	                                jmp               Level3ContinueAction
	Level3BlockCuadrante1:          
	                                mov               bl,4
	                                jmp               Level3ContinueAction
	Level3BlockCuadrante2:          
	                                mov               bl, 3
	                                jmp               Level3ContinueAction
	Level3BlockCuadrante3:          
	                                mov               bl, 2
	                                jmp               Level3ContinueAction
	Level3BlockCuadrante4:          
	                                mov               bl, 1
	                                jmp               Level3ContinueAction
	Level3ContinueAction:           
	                                xor               ax, ax
	                                mov               al, delayGamePlay
	                                delay             ax
	                                pop               ax
	                                pop               cx
	                                push              ax
	                                push              bx
	                                push              cx
	                                push              dx
	Level3UpdateScore:              
	                                push              bx
	                                xor               bx, bx
	                                mov               bl, ch
	                                call              showNumber
	                                push              cx
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 23
	                                int               10h
	                                pop               dx
	                                push              dx
	                                mov               ah, 0ah
	                                mov               al, dl
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 24
	                                int               10h
	                                pop               dx
	                                mov               ah, 0ah
	                                mov               al, dh
	                                mov               bh, 0
	                                mov               cx, 1
	                                int               10h
	                                pop               bx
	                                pop               dx
	                                pop               cx
	                                pop               bx
	                                pop               ax
	                                push              ax
	                                push              dx
	                                push              bx
	                                mov               bx, cx
	                                mov               ah, 2ch
	                                int               21h
	                                xor               ax, ax
	                                mov               al, cl
	                                mov               ch, 60
	                                mul               ch
	                                mov               dl, dh
	                                mov               dh, 0
	                                add               ax, dx
	                                mov               dx, time
	                                cmp               ax, dx
	                                jg                Level3AddSegundo
	                                jmp               Level3NotAddSegundo
	Level3AddSegundo:               
	                                mov               cx, bx
	                                inc               cl
	                                mov               time, ax
	                                push              cx
	                                xor               ax, ax
	                                mov               al, cl
	                                mov               bl, 60
	                                div               bl
	                                push              ax
	                                mov               ch, al
	                                add               ch, 30h
	                                mov               ah, 02h
	                                mov               bh, 0
	                                mov               dh, 1
	                                mov               dl, 30
	                                int               10h
	                                mov               ah,0ah
	                                mov               al,ch
	                                mov               bh,0
	                                mov               cx,1
	                                int               10h
	                                mov               ah,02h
	                                mov               bh,0
	                                mov               dh,1
	                                mov               dl,31
	                                int               10h
	                                mov               ah,0ah
	                                mov               al,58
	                                mov               bh,0
	                                mov               cx,1
	                                int               10h
	                                pop               ax
	                                mov               al,ah
	                                mov               ah,0
	                                mov               bx,ax
	                                call              showNumber
	                                push              cx
	                                mov               ah,02h
	                                mov               bh,0
	                                mov               dh,1
	                                mov               dl,32
	                                int               10h
	                                mov               ah,0ah
	                                mov               al,cl
	                                mov               bh,0
	                                mov               cx,1
	                                int               10h
	                                pop               cx
	                                mov               ah,02h
	                                mov               bh,0
	                                mov               dh,1
	                                mov               dl,33
	                                int               10h
	                                mov               ah,0ah
	                                mov               al,ch
	                                mov               bh,0
	                                mov               cx,1
	                                int               10h
	                                pop               cx
	                                jmp               Level3AddSegundoContinue
	Level3NotAddSegundo:            
	                                mov               cx, bx
	Level3AddSegundoContinue:       
	                                pop               bx
	                                pop               dx
	                                pop               ax
	                                cmp               ch, 24
	                                push              bx
	                                push              dx
	                                push              cx
	                                xor               cx, cx
	Level3CountBlocks:              
	                                xor               dx, dx
	                                mov               dl, levelthree[bx]
	                                cmp               dl, 0
	                                je                Level3CountBlocksAdd
	                                jmp               Level3CountBlocksContinue
	Level3CountBlocksAdd:           
	                                inc               cx
	Level3CountBlocksContinue:      
	                                inc               bx
	                                cmp               bx, 36
	                                jne               Level3CountBlocks
	                                cmp               cx, 12
	                                je                Level3AddSegundaBall
	                                cmp               cx, 23
	                                je                Level3AddTerceraBall
	                                cmp               cx, 35
	                                je                Level3Win
	                                jmp               Level3NotAddBall
	Level3Win:                      
	                                pop               cx
	                                pop               dx
	                                pop               bx
	                                jmp               Level3EndNivel3
	                                jmp               Level3NotAddBall
	Level3AddSegundaBall:           
	                                cmp               segundaBall, 0
	                                jne               Level3NotAddBall
	                                mov               segundoCuadrante, 1
	                                mov               segundaBall, 48160
	                                mov               delayGamePlay, 90
	                                jmp               Level3NotAddBall
	Level3AddTerceraBall:           
	                                cmp               terceraBall, 0
	                                jne               Level3NotAddBall
	                                mov               tercerCuadrante, 1
	                                mov               terceraBall, 48160
	                                mov               delayGamePlay, 60
	                                jmp               Level3NotAddBall
	Level3NotAddBall:               
	                                pop               cx
	                                pop               dx
	                                pop               bx
	                                cmp               ch, 72
	                                je                Level3EndNivel3
	                                jmp               Level3Action
	Level3EndNivel3:                
	                                jmp               Level3Finish
	Level3Lost:                     
	                                pop               ax
	                                pop               cx
	                                mov               currentLevel, 51
	                                mov               finalScore, ch
	                                mov               finalTime, cl
	                                call              addResume
	                                mov               currentLevel, 0
	                                mov               finalScore, 0
	                                mov               finalTime, 0
	                                jmp               Level3CleanFinish
	Level3Finish:                   
	                                mov               currentLevel, 51
	                                mov               finalScore, ch
	                                mov               finalTime, cl
	                                call              addResume
	                                mov               currentLevel, 0
	                                mov               finalScore, 0
	                                mov               finalTime, 0
	Level3CleanFinish:              
	                                mov               startLevel, 0
	                                mov               time, 0
	                                mov               currentTime, 0
	                                mov               delayGamePlay, 0
	                                mov               primerCuadrante, 0
	                                mov               segundoCuadrante, 0
	                                mov               tercerCuadrante, 0
	                                mov               swapBall, 0
	                                mov               terceraBall, 0
	                                mov               segundaBall, 0
	                                mov               primeraBall, 0
	                                ret



iniciarJuego3 ENDP
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

	ErrorOpen:                      
	                                printArray        messageErrorOpen
	                                getChar
	                                JMP               main
	ErrorCreate:                    
	                                printArray        messageErrorCreate
	                                getChar
	                                JMP               main
	ErrorWrite:                     
	                                printArray        messageErrorWrite
	                                getChar
	                                JMP               main
	ErrorRead:                      
	                                printArray        messageErrorRead
	                                getChar
	                                JMP               main
	ErrorClose:                     
	                                printArray        messageErrorClose
	                                getChar
	                                JMP               main
	ErrorDelete:                    
	                                printArray        messageErrorDelete
	                                getChar
	               JMP                 main
end main