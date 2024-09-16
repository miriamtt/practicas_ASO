#!/bin/bash

#Se establecen las variables que se necesitarán durante el ejercicio.
usuario=$( echo $USER )
verif="abc123."

#Se eliminan los datos introducidos en los ficheros para que queden vacíos cada vez que se ejecute el ejercicio para se repitan los PID.
echo " " > listaPID.txt
echo " " > porTerm.txt


#Creamos la función para que al llamarla nos salte la ventana zenity que nos ofrezca tres opciones a elegir.
eleccion=$( zenity --list \
	--text="Elija el filtraje de procesos" \
	--column="valor" --column="Descripcion" \
	--hide-column=1 --print-column=1 \
	1 " Por usuario actual" \
	2 " Procesos con salida en terminal" \
	3 " Procesos con... " )


#Creamos dos funciones, una que nos permita filtrar por usuario y otra que nos permita fitrar por terminal. Además de crear otra ventana zenity que nos permita escoger entre tres opciones para realizar sobre el PID que se haya elegido.

filtrarPorUsuario(){
ps aux | egrep $usuario | awk '{ print $2 }' >> listaPID.txt

numPID=$( zenity --list \
	--text="Elige el PID" \
	--column="PID" \
	--print-column=1 \
	$(cat listaPID.txt)
	)

accion=$( zenity --list \
        --title="Opciones" \
        --text="Qué acción desea realizar sobre el proceso?" \
        --column="Opciones" \
	 "Matar" \
	 "Parar" \
	 "Permitir que continúe" )
}
pid=$?



filtrarPorTerminal(){
ps aux | egrep pts | awk '{ print $2 }' >> porTerm.txt

numTerm=$( zenity --list \
        --text="Elige la terminal" \
        --column="terminal" \
        --print-column=1 \
        $(cat porTerm.txt)
        )

accion=$( zenity --list \
	--title="Opciones" \
	--text="Qué acción desea realizar sobre el proceso?" \
	--column="Opciones" \
         "Matar" \
         "Parar" \
         "Permitir que continúe" )

}


#Se crea otra función que abra otra ventana zenity con una pregunta, dependiendo de la respuesta de la misma se realiza una acción u otra.

comoActuar(){
actuar=$( zenity --question \
        --title="Pregunta" \
	--ok-label="Sí" \
	--cancel-label="Cancelar" \
        --text="Esta seguro de realizar esta acción sobre el proceso?")

ans=$?
if [ $ans -eq  0 ] ;
then
        contra
else
        exit;
fi

#Aquí se establece que, si la respuesta a la pregunta es "Si" (lo que equivale a 0) se llama a la función contraseña para que nos pida la contraseña. Si la contraseña es correcta se realiza finalmente la acción sobre el proceso, sino no se ejecuta ni se realiza nada.

if [ ${contrasinal} = $verif ] ;
then
        kill -9 $pid
else
	echo "La contraseña es incorrecta, no se ha podido matar el proceso."
        exit;
fi

}


#Se crea otra función para cuando se elija la otra opción a realizar sobre el proceso, vuelva a hacer la pregunta y si la respuesta es "si" (lo que equivale a 0), se solicitará la contraseña, si no se cierra la ventana zenity sin realizar ninguna ejecución sobre el proceso.

comoActuar2(){
	actuar=$( zenity --question \
        --title="Pregunta" \
        --ok-label="Sí" \
        --cancel-label="Cancelar" \
        --text="Esta seguro de realizar esta acción sobre el proceso?")

ans=$?
if [ $ans -eq  0 ] ;
then
        contra
else
        exit;
fi


if [ ${contrasinal} = $verif ] ;
then
        kill -19 $pid
else
	echo "La contraseña es incorrecta, no se ha podido parar el proceso."
        exit;
fi

}


#Se crea esta función para que salte una ventana zenity pidiendo la contraseña.

contra(){
contrasinal=$( zenity --password \
        --title="Autenticación" \
        --text="Introduce tu contraseña"

)
}


#Se crean dos controladores de flujo de tipo case, el primero para la función eleccion, en la cual para la cada eleccion se llama a la función correspondiente. Para la eleccion "Por usuario actual" se llama a la funcion que filtra por el usuario, para procesos con salida a terminal se llama a la función que filtra por la terminal, para todo lo demás o el resto, se hace un exit para que salga de la ventana zenity.

case $eleccion in

    1)
        filtrarPorUsuario
    ;;
    2)
        filtrarPorTerminal
    ;;
    *)
        exit
    ;;
esac


#En este case se decide y se realiza la acción que se escoge entre las 3 opciones. Si la opción elegida es matar, se llama a la funcion que mata el proceso, si es parar, se llama a la función que detiene el proceso y para todo lo demás se hace un exit para salir de las ventanas zenity y no se realizaría nada.

case $accion in

	Matar)
		comoActuar
	;;
	Parar)
		comoActuar2
	;;
	*)
		exit
	;;

esac
