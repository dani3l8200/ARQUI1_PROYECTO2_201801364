include  macros.asm
include files.asm
include estadisticasJuego.asm
include GamePlay.asm
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