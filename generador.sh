#!/bin/bash 
##-----UTN FACULTAD REGIONAL HAEDO----------------* - shell - *------------------
## _______     ___       __   __   __  |
##|   ____|   /   \     |  | |  | |  | | CATEDRA ESTRUCTURAS AERONAUTICAS III
##|  |__     /  ^  \    |  | |  | |  | |
##|   __|   /  /_\  \   |  | |  | |  | |    GENERADOR LATEX TP MRP
##|  |____ /  _____  \  |  | |  | |  | |
##|_______/__/     \__\ |__| |__| |__| | generador: script principal
##                                     |
##-------------------------------------------------------------------------------
##################### DECLARACIONES ########################

declare -r nNac=$(wc -l ./bancoEjercicios/nacho/guiaEjercicios | awk '{print $1}')

declare -r nMau=$(ls -lB ./bancoEjercicios/mauri/ | tail -n +2 | wc -l)

declare -r nNic=$(ls -lB ./bancoEjercicios/nico/ | tail -n +2 | wc -l)

let nac=1

let mau=1

let nic=1

let numeroLinea=1

################### FUNCIONES ###############################

	
#@@@@@@@@@@@@@@@@@@ SCRIPT ##################################	


echo "ALUMNO,EJERCICIO 1,EJERCICIO 2" >asignacionEjercicios.csv

while read line
do

    ### Limita rango de variables
    
    test "$nac" -gt "$nNac" && let nac=1

    test "$mau" -gt "$nMau" && let mau=1

    test "$nic" -gt "$nNic" && let nic=1

    ### Interprete nacho
    
    ECUACION=$(cat bancoEjercicios/nacho/guiaEjercicios | sed -n ''${nac}'p' | tr ';' '\n' | tr '\\' '?' | sed -n '1p')

    INTERVALO=$(cat bancoEjercicios/nacho/guiaEjercicios | sed -n ''${nac}'p' | tr ';' '\n' | tr '\\' '?' | sed -n '2p')

    CONDICIONDECONTORNO=$(cat bancoEjercicios/nacho/guiaEjercicios | sed -n ''${nac}'p' | tr ';' '\n' | tr '\\' '?' | sed -n '3p')

    cat ./db/planillaBase.tex | sed 's/ECUACION/'"${ECUACION}"'/' | sed 's/INTERVALO/'"${INTERVALO}"'/' | sed 's/CONDICIONESDECONTORNO/'"${CONDICIONDECONTORNO}"'/' | tr '?' '\\' | sed 's/ALUMNO/'"${line}"'/' >EngCalcPaper.tex
    
    ### Interprete ayudantes

    if [ $((numeroLinea%2)) -eq 0 ]
    then

	cat bancoEjercicios/mauri/${mau} >>EngCalcPaper.tex

	echo "${line},nacho ${nac},mauri ${mau}" >>asignacionEjercicios.csv
	
	let mau++

    else
	
	cat bancoEjercicios/nico/${nic} >>EngCalcPaper.tex

	echo "${line},nacho ${nac},nico ${nic}" >>asignacionEjercicios.csv
	
	let nic++
	
    fi
    
    ### Adecuacion de variables
   
    let nac++

    let numeroLinea++

    ## Post-procesamiento

    pdflatex -interaction=nonstopmode EngCalcPaper.tex

    pdftk caratula/Caratula.pdf EngCalcPaper.pdf cat output informesFinales/"${line}".pdf
    
done<./db/listadoAlumnos.csv   	


################## MANTENIMIENTO FINAL ###################


#exit 0

