extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	text = "''" + Global.nombre + "''" + "\n" +\
	 "" + "\n" + "NV  " + str(Global.NV) + "\n" +\
	"PS  " + str(Global.vida) + " / " + str(Global.vidaMax) +\
	"\n" + "" + "\n" + "AT  " + str(Global.ATQ) + " (" + str(Global.ATQ_extra) + ")" +\
	"\n" + "DF  " + str(Global.DEF) + " (" + str(Global.DEF_extra) + ")" 
