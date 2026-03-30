// JavaScript Document
// agregar en el onsubmit del formulario para que
// todos los botones se inhabiliten
function sinbotones()
{
	var d = document, i = 0;
	var inp = d.getElementsByTagName("INPUT");
	for (i = 0; i < inp.length; i++) {
		if (inp[i].type.toLowerCase()=="submit" || inp[i].type.toLowerCase()=="button" || inp[i].type.toLowerCase()=="reset") {
			inp[i].disabled = true;
		}
	}
	return true;
}