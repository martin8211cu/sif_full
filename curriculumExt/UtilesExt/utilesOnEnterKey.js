//Autor: Ing. Óscar Enrique Bonilla Calderón, 28/JUL/2006
//Implementa la lógica para el tag cf_onEnterKey
// IE y FireFox 1.5: 		se ejecuta en onKeyDown
// NAV y Fire Fox < 1.5: 	se ejecuta en onKeyPress, porque el return false no cancela el keyDown
//							pero el en el indexTab = "-1" se comporta como "0"

var CF_onEnter = false;
var Gvar_CF_onEnter_submit = false;
function fnCF_onEnter(evt, obj, enterAction)
{
	if (",submit,tab,none,".indexOf(","+Gvar_CF_onEnterAction+",") == -1) Gvar_CF_onEnterAction = "submit";
	if (enterAction == "" || ",submit,tab,none,".indexOf(","+enterAction+",") == -1) enterAction = Gvar_CF_onEnterAction;

	var LvarKeyCode = 0;
	if (!evt) 
	{
		// NAV y Fire Fox < 1.5
		evt = window.Event;

		if (evt.type != "keypress") return false;
		Gvar_CF_onEnterAllTabIdx = true;		
		if (window.Event) 
			LvarKeyCode = (evt.charCode == 0 && evt.keyCode < 32) ? evt.keyCode : evt.charCode;
		else
			LvarKeyCode = evt.charCode ? evt.charCode : evt.keyCode;
	}
	else
		LvarKeyCode = evt.keyCode;

	if (evt.type != "keydown" && evt.type != "keypress") return false;

	if (LvarKeyCode == 13)
	{
		// Variable global que indica que se presionó Enter, se usa en onBlur
		CF_onEnterKey = true;
		if (evt.shiftKey)
		{
			// Actúa normalmente, específicamente para el autocomplete
			return true;
		}
		else if (enterAction == "none" && !evt.ctrlKey)
		{
			// Fuerza el blur del objeto
			if (obj.blur) obj.blur();
			if (obj.focus) obj.focus();
			if (obj.select) obj.select();
			return true;
		}
		else if (enterAction == "tab" && !evt.ctrlKey)
		{
			if (evt.type == "keydown")
			{
				// Convierte el Enter en Tab
				// En FireFox se ejecuta en el keyPress
				if (!window.Event) try {evt.keyCode = 9;} catch(e) {;}
				return false;
			}
			else
			{
				// Busca el siguiente campo para ejecutar focus()
				try {fnCF_onEnter_ToTab(obj, evt.shiftKey);} catch(e) {alert(e.toString());}
				return true;
			}
		}
		else
		{
			return fnCF_onEnter_ToSubmit(obj);
		}
	}
	return false;
}

//Autor: Ing. Óscar Enrique Bonilla Calderón, 28/JUL/2006
//Fuerza el blur() del campo, busca el primerSubmit y ejecuta el primerSubmit.click()
function fnCF_onEnter_ToSubmit(obj)
{
	Gvar_CF_onEnter_submit = false;
	// Fuerza el blur del objeto y devuelve el foco al objeto
	if (obj.blur && obj.onblur) if (obj.onblur() == false) {return true;}
	if (obj.focus) obj.focus();
	if (obj.select) obj.select();
	if (!obj.form) return false;

	// Busca el primer submit en el mismo form del objeto
	var LvarFormElems	= obj.form.elements;
	var LvarFormElemsN	= LvarFormElems.length;

	var LvarEncontrado  = false;
	var LvarFirstSubmit	= -1;
	for (var i=0; i<LvarFormElemsN; i++)
	{
		if (LvarFormElems[i] == obj)
		{
			LvarEncontrado = true;
		}
		else if ((LvarFormElems[i].type == "submit" || LvarFormElems[i].type == "image") && !LvarFormElems[i].disabled)
		{
			if (LvarEncontrado)
			{
				Gvar_CF_onEnter_submit = LvarFormElems[i];
				setTimeout ("Gvar_CF_onEnter_submit.click();",100);
				return true;
			}
			else if (LvarFirstSubmit != null)
			{
				LvarFirstSubmit = i;
			}
		}
	}
	if (LvarFirstSubmit != -1)
	{
		Gvar_CF_onEnter_submit = LvarFormElems[LvarFirstSubmit];
		setTimeout ("Gvar_CF_onEnter_submit.click();",100);
		return true;
	}
	return false;
}

//Autor: Ing. Óscar Enrique Bonilla Calderón, 2/AGO/2006
//Convierte el Enter en Tab, unicamente en Netscape/FireFox porque no se puede sustituir el enter por tab
function fnCF_onEnter_ToTab(obj, shiftKey)
{
	var LvarDocElems 	= document.getElementsByTagName("*");
	var LvarDocElemsN	= LvarDocElems.length;
	var LvarIdxDocs	= -1;

	if (obj.blur && obj.onblur) if (obj.onblur() == false) {return true;}
	// Busca la posicion del objeto en el documento
	if (Gvar_CF_onEnterDocElemsN != LvarDocElemsN)
	{
		LvarIdxDocs = fnCF_onEnter_ElemsLoad(LvarDocElems, obj)
	}
	else
	{
		for (var i=0; i<LvarDocElemsN; i++)
		{
			if (LvarDocElems[i] == obj)
				LvarIdxDocs = i;
		}
	}

	// Busca el indice del objeto en Gvar_CF_onEnterElems
	var LvarIdxElems = -1;
	for (var i=0; i<Gvar_CF_onEnterElemsN; i++)
	{
		if (Gvar_CF_onEnterElems[i][1] == LvarIdxDocs)
		{
			LvarIdxElems = i;
			break;
		}
	}

	// Busca el indice del siguiente objeto que pueda recibir el foco en Gvar_CF_onEnterElems
	for (var cont=0; cont<Gvar_CF_onEnterElemsN; cont++)
	{
		if (!shiftKey)		// Escoge el Siguiente
			LvarIdxElems = (LvarIdxElems != -1 && LvarIdxElems < Gvar_CF_onEnterElemsN-1) ?  LvarIdxElems+1 : 0;
		else				// Escoge el Anterior
			LvarIdxElems = (LvarIdxElems != -1 && LvarIdxElems > 0) ? LvarIdxElems-1 : Gvar_CF_onEnterElemsN-1;

		LvarIdxDocs = Gvar_CF_onEnterElems[LvarIdxElems][1];
		if ( LvarDocElems[LvarIdxDocs].style.display != "none" && 
			!LvarDocElems[LvarIdxDocs].disabled && 
			 LvarDocElems[LvarIdxDocs].style.visibility != "hidden"
		   )
			break;
	}

	// Pone foco en el objeto encontrado
	try
	{
		LvarDocElems[LvarIdxDocs].focus();
	}
	catch (e)
	{
		alert(e.description);
	}
}

//Autor: Ing. Óscar Enrique Bonilla Calderón, 2/AGO/2006
//Carga Gvar_CF_onEnterElems con todos los elementos del documento ordenados de la forma {tabIndex, Posición}
var Gvar_CF_onEnterElems 	= new Array();
var Gvar_CF_onEnterElemsN 	= -1;
var Gvar_CF_onEnterDocElemsN = -1
var Gvar_CF_onEnterAllTabIdx	= false;
function fnCF_onEnter_ElemsLoad(LvarDocElems, obj)
{
	Gvar_CF_onEnterDocElemsN = LvarDocElems.length;
	var LvarIdxDocs 	= -1;

	var j = 0;
	for (var i=0; i<Gvar_CF_onEnterDocElemsN; i++)
	{
		var LvarTieneTabIndex = false;
		
		try
		{
			LvarTieneTabIndex = LvarDocElems[i].tabIndex;
			LvarTieneTabIndex = (true);
		}
		catch (e) 
		{
			LvarTieneTabIndex = false;
		}
			
		LvarTieneTabIndex = (
								LvarTieneTabIndex &&
								LvarDocElems[i].type &&
								LvarDocElems[i].focus &&
								("text,password,checkbox,radio,submit,image,reset,button,file,select-one,select-multiple,textarea".indexOf(LvarDocElems[i].type) !=-1) 
							);

		if (LvarTieneTabIndex)
		{
			var LvarName = ((LvarDocElems[i].name) ? LvarDocElems[i].name : "") + "\n";
			if (LvarDocElems[i].tabIndex < 0 && Gvar_CF_onEnterAllTabIdx)
			{
				Gvar_CF_onEnterElems[j] = new Array(32767,i, LvarName);
				j++;
			}
			else if (LvarDocElems[i].tabIndex == 0)
			{
				Gvar_CF_onEnterElems[j] = new Array(32767,i, LvarName);
				j++;
			}
			else if (LvarDocElems[i].tabIndex > 0)
			{
				Gvar_CF_onEnterElems[j] = new Array(LvarDocElems[i].tabIndex,i, LvarName);
				j++;
			}
		}
		if (obj && LvarDocElems[i] == obj)
			LvarIdxDocs = i;
	}
	Gvar_CF_onEnterElems	= Gvar_CF_onEnterElems.sort(fnCF_onEnter_ElemsSort);
	Gvar_CF_onEnterElemsN	= Gvar_CF_onEnterElems.length;
	return LvarIdxDocs;
}

//Autor: Ing. Óscar Enrique Bonilla Calderón, 2/AGO/2006
//Funcion de ordenamiento del arreglo primero por tabIndex y luego por Posición
function fnCF_onEnter_ElemsSort(e1, e2)
{
	return (e1[0] < e2[0]) ? -1 : ((e1[0] == e2[0] && e1[1] <= e2[1]) ? -1 : 1);
}

//Autor: Ing. Óscar Enrique Bonilla Calderón, 28/JUL/2006
//Cambia el evento document.body.onload para que inicialice los elementos del documento
var Gvar_CF_onEnterAction 	= "submit";

//Autor: Ing. Óscar Enrique Bonilla Calderón, 28/JUL/2006
//Función que inicializa todos los elementos del documento que puedan presionar enter:
//text,password,checkbox,radio,file,select-one,select-multiple
function sbCF_onEnter_changeOnKeysEvents()
{
	if (",submit,tab,none,".indexOf(","+Gvar_CF_onEnterAction+",") == -1) Gvar_CF_onEnterAction = "submit";
	var LvarTypes 		= ",text,password,checkbox,radio,file,select-one,select-multiple,";
	var LvarDocElems 	= document.getElementsByTagName("*");
	var LvarDocElemsN	= LvarDocElems.length;

	var LvarOnMouseDown	= "CF_onEnterKey=false;"
	var LvarOnEnter		= "CF_onEnterKey=false; if (fnCF_onEnter(event, this, '')) return false;"
	var LvarSubmitClick	= "Gvar_CF_onEnter_submit=this;"
	var LvarNewEvent 	= null;
	// Inicializa variable CF_onEnterKey cuando el focus llega por el mouse
	if (window.Event)
	{
		LvarNewEvent = fnCFonEnter_EventAppend (window.onmousedown, LvarOnMouseDown, false);
		if (LvarNewEvent) window.onmousedown = LvarNewEvent;
	}
	// modifica onKeyDown y onKeyPress de todos los elementos del documento
	// para inicializar la variable CF_onEnterKey y procesar el EnterKey
	for (var i=0; i<LvarDocElemsN; i++)
		if (LvarTypes.indexOf(","+LvarDocElems[i].type+",") != -1)
		{
			LvarNewEvent = fnCFonEnter_EventAppend (LvarDocElems[i].onkeydown, LvarOnEnter, false);
			if (LvarNewEvent) LvarDocElems[i].onkeydown = LvarNewEvent;
			LvarNewEvent = fnCFonEnter_EventAppend (LvarDocElems[i].onkeypress, LvarOnEnter, false);
			if (LvarNewEvent) LvarDocElems[i].onkeypress = LvarNewEvent;
			if (!window.Event)
			{
				LvarNewEvent = fnCFonEnter_EventAppend (LvarDocElems[i].onmousedown, LvarOnMouseDown, false);
				if (LvarNewEvent) LvarDocElems[i].onmousedown = LvarNewEvent;
			}
		}
		else if (",submit,image,".indexOf(","+LvarDocElems[i].type+",") != -1)
		{
			LvarNewEvent = fnCFonEnter_EventAppend (LvarDocElems[i].onclick, LvarSubmitClick, true);
			if (LvarNewEvent) LvarDocElems[i].onclick = LvarNewEvent;
		}
	return;
}

function fnCFonEnter_EventAppend(oldEvent, appendEventString, notEnterAction)
{
	var LvarNewEvent	= appendEventString;

	if (oldEvent)
	{
		var LvarOldEvent = oldEvent.toString();
		LvarOldEvent = LvarOldEvent.substring(LvarOldEvent.indexOf("{"),LvarOldEvent.lastIndexOf("}")+1);
		if (notEnterAction)
			LvarNewEvent 	= LvarNewEvent+LvarOldEvent;
		else if (LvarOldEvent.search(/{\s*CF_onEnterAction\s*=/) == 0)
		{
			LvarNewEvent	= LvarNewEvent.replace("''","CF_onEnterAction");
			var LvarPto		= LvarOldEvent.indexOf(";")
			if (LvarPto >= 0)
				LvarNewEvent 	= LvarOldEvent.substr(0,LvarPto+1)+LvarNewEvent+LvarOldEvent.substr(LvarPto+1);
			else
				LvarNewEvent 	= LvarOldEvent.substr(0,LvarOldEvent.length-1)+";"+LvarNewEvent+"\n }";
		}
		else if (LvarOldEvent.search(/fnCF_onEnter\s*\(/) == -1)
			LvarNewEvent 	= LvarNewEvent+LvarOldEvent;
		else
			return null;
	}

	if (window.Event)
		return new Function("event", LvarNewEvent);
	else
		return new Function(LvarNewEvent);
}
