extends RichTextLabel
#texto del menu de estadisticas
func _ready():
	text = "''" + Global.nombre + "''" + "\n" +\
	 "" + "\n" + "NV  " + str(Global.NV) + "\n" +\
	"PS  " + str(Global.vida) + " / " + str(Global.vidaMax) +\
	"\n" + "" + "\n" + "AT  " + str(Global.ATQ) + " (" + str(Global.ATQ_extra) + ")" + "                   " + "PE:  " + str(Global.PE) +\
	"\n" + "DF  " + str(Global.DEF) + " (" + str(Global.DEF_extra) + ")"  + "                   " + "SIG:  " + str(Global.sig) +\
	"\n" + "" + "\n" + "ARMA: " + "Lapiz" +\
	"\n" + "" + "ARMAD: " + "Borrador"
