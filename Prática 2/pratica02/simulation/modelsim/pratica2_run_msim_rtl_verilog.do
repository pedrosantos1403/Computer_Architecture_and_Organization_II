transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/pedro/OneDrive/Documentos/CEFETMG/2023.2/Laboratório\ AOC\ II/Práticas\ AOC2/Prática\ 2/pratica02 {C:/Users/pedro/OneDrive/Documentos/CEFETMG/2023.2/Laborat�rio AOC II/Pr�ticas AOC2/Pr�tica 2/pratica02/mem_ram.v}
vlog -vlog01compat -work work +incdir+C:/Users/pedro/OneDrive/Documentos/CEFETMG/2023.2/Laboratório\ AOC\ II/Práticas\ AOC2/Prática\ 2/pratica02 {C:/Users/pedro/OneDrive/Documentos/CEFETMG/2023.2/Laborat�rio AOC II/Pr�ticas AOC2/Pr�tica 2/pratica02/disp7seg.v}
vlog -vlog01compat -work work +incdir+C:/Users/pedro/OneDrive/Documentos/CEFETMG/2023.2/Laboratório\ AOC\ II/Práticas\ AOC2/Prática\ 2/pratica02 {C:/Users/pedro/OneDrive/Documentos/CEFETMG/2023.2/Laborat�rio AOC II/Pr�ticas AOC2/Pr�tica 2/pratica02/pratica2.v}

