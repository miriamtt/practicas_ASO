#!/bin/bash

#Creamos las variables que necesitaremos, en este caso las variables para las rutas y para la fecha actual en la cual se crea la copia. 
ruta1="/var/log/"
ruta2="/home/sad/Descargas"
date=$( date +%Y-%m-%d-%H.%M.%S )

#Se crea una variable para extraer el tamaño para la ruta1 y otra para la ruta2.
tam1=$( du -s $ruta1 | awk '{print $1}' )
tam2=$( du -s $ruta2 | awk '{print $1}' )

#Creamos la función para que, si el tamaño de la ruta es mayor que 20, cree una copia de seguridad comprimida. Si no cumple esa condición que realice la copia mediante el comadno cp. Se usa la opción 'if'
# dos veces, una para que lo realice con ruta1 y otra para realizarlo con ruta2.
extraer_Tamanho(){
	if [ $tam1 > 20 ] ;
	then
		tar -czvf /home/sad/Descargas/backup/ruta1_"$date".tar.gz $ruta1
	else
		cp -rf $ruta1 /home/sad/Descargas/backup
	fi


	if [ $tam2 > 20 ] ;
        then
                tar -czvf /home/sad/Descargas/backup/ruta2_"$date".tar.gz $ruta2
        else
                cp -rf $ruta2 /home/sad/Descargas/backup
        fi

}

#Se llama a la función para que realice la copia de seguridad.
extraer_Tamanho

#Se usa este comando para que se abra una ventana de la carpeta en la cual se va a guardar la copia de seguridad, podemos así confirmar que las copias se crean de forma correcta.
xdg-open /home/sad/Descargas/backup
