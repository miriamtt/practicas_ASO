#!/bin/bash

# Se crea la variable para saber si el usuario es root o no.
usuario="$USER"
# Si el usuario es root se realizarán las siguientes acciones, si no mostrará un mensaje y saldrá del script.
if [ $usuario == "root" ] ;
then
# Se define la variable i que se usará para el array
                i=0
                cat paquetes.txt | tr -s ':' ' ' > paquetes2.txt
                # Se sustituyen los ':' del fichero paquetes.txt por espacios y se guarda en el fichero paquetes2.txt
				while read -r packagename action
				do
                # Se realiza un bucle while para leer las columnas del fichero paquetes y se cargan en un array para usar posteriormente.
					pack[$i]="$packagename"
					accion[$i]="$action"
					((i++))

				done < paquetes2.txt
    
# Se define la variable para contar cuantos paquetes son en total.
    size="${#pack[@]}"
        # Se realiza un bucle "for" que procederá a leer el array y realizar las acciones necesarias sobre el.
                for ((b=0; b<size; b++))
                do
                # Se define la variable "estado", que se usará para saber el estado del paquete que se necesite
                estado="whereis ${pack[b]} | grep bin | wc -l"

                # Si la acción es "remove" o "r" , se comprobará el estado del paquete y si está instalado se eliminará.
                    if [[ ${accion[b]} == "remove" || "r" ]] ;
                    then
                                if [[ $estado == "1" ]] ;
                                then
                                    sudo apt remove -y ${pack[b]}
                                else
                                    echo "El paquete " ${pack[b]} " no está instalado, no se puede eliminar."
                                fi
                    
                # Si la acción es "add" o "a", se comprobará si el paquete no está instalado y se instalará.
                    elif [[ ${accion[b]} == "add" || "a" ]] ;
                    then
                                if [[ $estado == "0" ]] ;
                                then
                                    sudo apt install -y ${pack[b]}
                                else
                                    echo "El paquete " ${pack[b]} " ya está instalado."
                                fi
                        
                # Si la acción es "status" o "s" , se comprobará el estado del paquete, si devuelve el valor "1" es que está instalado, si el valor es "0", no está instalado.
                    elif [[ ${accion[b]} == "status" || "s" ]] ;
                    then     
                                if [[ $estado == "1" ]] ;
                                then
                                    echo "El paquete " ${pack[b]} " SÍ está instalado."
                                else
                                    echo "El paquete " ${pack[b]} " NO está instalado."
                                fi
                    # Si la acción no es ninguna de las nombradas anteriormente, no es válida y saldrá del script mostrando ese mensaje.
                    else 
                        echo "Acción no válida"
                        exit;
                    fi
                done
# Si el usuario no es root, se mostrará el siguiente mensaje y se saldrá del script.
else 
    echo "No tiene permisos para ejecutar el script."
    exit;
fi

