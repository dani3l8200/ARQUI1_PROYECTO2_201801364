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
	         MOV AL, 10b   	;Acceso lectura/escritura
	         lea DX, file   	;realiza una lectura con la informacion
	         int 21h
	         MOV handler, AX	;transfiere la informacion al handler
	         jc  ErrorOpen  	;si hay carry lanzara un error ya que no pudo abrir el archivo con exito
ENDM


;createFile macro para crear archivos 
createFile MACRO file, handler
	           MOV AH, 3ch    	;crea el archivo
	           MOV CX, 00h    	;mueve al inicio del archivo
	           lea DX, file   	;realiza una lectura con la informacion
	           int 21h
	           MOV handler, AX	;transfiere la informacion al handler
	           jc  ErrorCreate	;si hay carry lanzara un error ya que no se creo con exito el archivo
ENDM

;WriteFile macro para escribir el archivo 
writeFile MACRO array, handler, numBytes
            ;pusheamos el contador y la data 
	          PUSH CX
	          PUSH DX
            ;activamos el modo escritura
	          MOV  AH, 40h
            ;movemos el contenido a bx
	          MOV  BX, handler
            ;movemos el tamano al contador cx
	          MOV  CX, numBytes
            ;movemos la direccion del array a DX
	          lea  DX, array
            ;activamos el bios
	          int  21h
            ;si hay un error lo imprime 
	          jc   ErrorWrite
            ;saca los datos de la pia 
	          POP  DX
	          POP  CX
ENDM

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
	          mov handler, BX
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