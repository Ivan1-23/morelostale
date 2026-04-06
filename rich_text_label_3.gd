extends RichTextLabel

func _ready():
	text = "NV  " + str(Global.NV) + "\n" + "PS  " + str(Global.vida) +\
	"/" + str(Global.vidaMax) + "\n" + "OR  " + str(Global.oro) 
