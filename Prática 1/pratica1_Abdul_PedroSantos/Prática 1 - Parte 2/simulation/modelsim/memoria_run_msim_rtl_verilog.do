transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/pedro/OneDrive/Documentos/CEFETMG/2023.2/Laboratório\ AOC\ II/Prática\ 1/Prática\ 1\ -\ Parte\ 1\ -\ Entrega/pratica01 {C:/Users/pedro/OneDrive/Documentos/CEFETMG/2023.2/Laborat�rio AOC II/Pr�tica 1/Pr�tica 1 - Parte 1 - Entrega/pratica01/memoria.v}
vlog -vlog01compat -work work +incdir+C:/Users/pedro/OneDrive/Documentos/CEFETMG/2023.2/Laboratório\ AOC\ II/Prática\ 1/Prática\ 1\ -\ Parte\ 1\ -\ Entrega/pratica01 {C:/Users/pedro/OneDrive/Documentos/CEFETMG/2023.2/Laborat�rio AOC II/Pr�tica 1/Pr�tica 1 - Parte 1 - Entrega/pratica01/ramlpm.v}
vlog -vlog01compat -work work +incdir+C:/Users/pedro/OneDrive/Documentos/CEFETMG/2023.2/Laboratório\ AOC\ II/Prática\ 1/Prática\ 1\ -\ Parte\ 1\ -\ Entrega/pratica01 {C:/Users/pedro/OneDrive/Documentos/CEFETMG/2023.2/Laborat�rio AOC II/Pr�tica 1/Pr�tica 1 - Parte 1 - Entrega/pratica01/disp7seg.v}

