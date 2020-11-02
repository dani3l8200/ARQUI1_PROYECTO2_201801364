;GetPahtFile sirve para introducir el directorio donde se encuentre algun archivo 
GetPathFile MACRO array
	            LOCAL      getCadena, endCadena, RemoveSpace
				; setea el registro SI con 0
	            MOV        SI, 0
	getCadena:  
				;lee la consola para introducir la ubicacion del archivo
	            ReadKeyPad
				;compara si hay un enter que seria un retorno de carro
	            CMP        AL, 0dh
	            JE         endCadena
				;esto es por si se metio mal alguna letra poder borrar la de atras
	            CMP        AL, 08h
	            JE         RemoveSpace
				;se mueve al path el contenido 
	            MOV        array[SI], AL
				;incrementa SI
	            INC        SI
				;se vuelve a repetir el ciclo
	            JMP        getCadena
	RemoveSpace:
				;mueve un fin de cadena a AL
	            MOV        AL, 24h
				;decrementa SI SI--
	            DEC        SI
				;mueve el caracter al path una casilla anterior
	            MOV        array[SI], AL
				;regresa al getCadena para seguir anadiendo al path
	            JMP        getCadena
	endCadena:  
				;termina de ingresar el path 
	            MOV        array[SI], 00h
ENDM

;openFile macro para abrir el archivo 
openFile MACRO file, handler
	         MOV AH, 3dh    	;abre el archivo
	         MOV AL, 010b   	;Acceso lectura/escritura
	         lea DX, file   	;realiza una lectura con la informacion
	         int 21h
	         jc  ErrorOpen  	;si hay carry lanzara un error ya que no pudo abrir el archivo con exito
			 MOV handler, AX	;transfiere la informacion al handler
ENDM



createFile macro path, handle
    mov ah,3ch
    mov cx,00h
    lea dx, path
    int 21h
    jc ErrorCreate
    mov handle,ax
endm

;WriteFile macro para escribir el archivo 


writeFile macro handle, numBytes, buffer
    mov ah,40h
    mov bx,handle
    mov cx,numBytes
    lea dx,buffer
    int 21h
    jc ErrorWrite
endm

;readFile macro para leer el archivo 
readFile MACRO array, handler, numBytes
            ;activamos el modo lectura 
	         MOV AH, 3fh
            ;movemos el contenido a bx
	         MOV BX, handler
            ;movemos al contador cx el tamano del archivo
	         MOV CX, numBytes
            ;transferimos la direccion del array a DX
	         lea DX, array
            ;activamos el bios 
	         int 21h
            ;en caso de ver error mostrara el mensaje
	         jc  ErrorRead
            ;si todo esta ok, muestra el mensaje de que se leyo bien el archivo
			 printArray messageSuccessPath
ENDM

;closeFile macro para cerrar el archivo
closeFile MACRO handler
            ;ponemos a AH en modo de cierre de archivos
	          MOV AH, 3eh
            ;movemos el registro bx al handler 
	          mov bx, handler
            ;activamos el modo bios 
	          int 21h
            ;en caso de a ver un error muestra el mensaje definido 
	          jc  ErrorClose
ENDM

;deleteFile macro para eliminar el archivo 
deleteFile MACRO buffer
             ;ponemos a AH en modo eliminar archivo
	           MOV AH, 41h
             ;movemos la direccion del buffer con lea a DX
	           lea DX, buffer
             ;en caso de que hubiera error mostramos mensaje 
	           jc  ErrorDelete
ENDM