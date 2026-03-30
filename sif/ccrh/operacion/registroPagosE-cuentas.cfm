<script type="text/javascript" language="javascript1.2">
	var index = 0;

	//**********************************Tabla Dinámica**********************************************
	var GvarNewTD;
	
	//Función para agregar TRs
	function fnNuevoTR(){
	  var LvarTable = document.getElementById("tbldynamic");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOne;
	  
	  var p1 		= document.form1.DPEreferencia.value;//id
	  var p2 		= document.form1.DPEdescripcion.value;//cod
	  var p3 		= document.form1.Ccuenta.value;//desc
	  var p4 		= document.form1.CFcuenta.value;//desc
  	  var p5 		= document.form1.Cmayor.value;//desc
  	  var p6 		= document.form1.Cformato.value;//desc
  	  var p7 		= document.form1.Cdescripcion.value;//desc
	  var p8 		= document.form1.DPEmonto.value;//desc

	// validacion
	var LvarError   = false;
	var LvarMensaje = 'Se presentaron los siguientes errores:\n';
	if ( trim(p1) == ''  ){
		LvarError = true;
		LvarMensaje = LvarMensaje + ' - El campo Referencia es requerido.\n';
	}
	if ( trim(p2) == ''  ){
		LvarError = true;
		LvarMensaje = LvarMensaje + ' - El campo Descripción es requerido.\n';
	}
	if ( trim(p3) == ''  ){
		LvarError = true;
		LvarMensaje = LvarMensaje + ' - El campo Cuenta es requerido.\n';
	}
	
	if ( LvarError ){
		alert(LvarMensaje);
		return false; 
	}

	index = index + 1;

	// Referencia
	sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "DPEdescripcion_"+index);
	sbAgregaTdText  (LvarTR, Lclass.value, p1);
	
	// Descripcion
	sbAgregaTdInput (LvarTR, Lclass.value, p2, "hidden", "DPEreferencia_"+index);
	sbAgregaTdText  (LvarTR, Lclass.value, p2);

	// Cuenta
	sbAgregaTdInput (LvarTR, Lclass.value, p3, "hidden", "Ccuenta_"+index); 	// Ccuenta
	sbAgregaTdInput (LvarTR, Lclass.value, p4, "hidden", "CFcuenta_"+index); 	// CFcuenta
	sbAgregaTdText  (LvarTR, Lclass.value, p5+p6+' '+p7);

	// Monto
	sbAgregaTdInput (LvarTR, Lclass.value, p8, "hidden", "DPEmonto_"+index); // Monto
	sbAgregaTdText  (LvarTR, Lclass.value, p8);

	  // Agrega Evento de borrado
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel");
	  if (document.all)
		GvarNewTD.attachEvent ("onclick", sbEliminarTR);
	  else
		GvarNewTD.addEventListener ("click", sbEliminarTR, false);
	
	  // Nombra el TR
	  LvarTR.name = "XXXXX";
	  // Agrega el TR al Tbody
	  LvarTbody.appendChild(LvarTR);
	  
	  if (Lclass.value=="ListaNon")
		Lclass.value="ListaPar";
	  else
		Lclass.value="ListaNon";

		//limpia los campos
		document.form1.DPEreferencia.value='';//id
		document.form1.DPEdescripcion.value='';//cod
		document.form1.Ccuenta.value='';//desc
		document.form1.CFcuenta.value='';//desc
		document.form1.Cmayor.value='';//desc
		document.form1.Cformato.value='';//desc
		document.form1.Cdescripcion.value='';//desc
		document.form1.DPEmonto.value='';//monto

	}
	
	//Función para eliminar TRs
	function sbEliminarTR(e)
	{
	  var LvarTR;

	  if (document.all)
		LvarTR = e.srcElement;
	  else
		LvarTR = e.currentTarget;
	
	  while (LvarTR.name != "XXXXX")
		LvarTR = LvarTR.parentNode;
		
	  LvarTR.parentNode.removeChild(LvarTR);
	  
	  index = index -1;
	  
	}
	
	//Función para agregar Imagenes
	function sbAgregaTdImage (LprmTR, LprmClass, LprmNombre)
	{
	  // Copia una imagen existente
	  var LvarTDimg    = document.createElement("TD");
	  var LvarImg = document.getElementById(LprmNombre).cloneNode(true);
	  LvarImg.style.display="";
	  LvarTDimg.appendChild(LvarImg);
	  if (LprmClass != "") LvarTDimg.className = LprmClass;
	  GvarNewTD = LvarTDimg;
	  LprmTR.appendChild(LvarTDimg);
	}
	
	//Función para agregar TDs con texto
	function sbAgregaTdText (LprmTR, LprmClass, LprmValue)
	{
	  var LvarTD    = document.createElement("TD");
	  LvarTD.noWrap = true;	  
	
	  var LvarTxt   = document.createTextNode(LprmValue);
	  LvarTD.appendChild(LvarTxt);
	  if (LprmClass!="") LvarTD.className = LprmClass;
	  GvarNewTD = LvarTD;
	  LprmTR.appendChild(LvarTD);
	}
	
	//Función para agregar TDs con Objetos
	function sbAgregaTdInput (LprmTR, LprmClass, LprmValue, LprmType, LprmName)
	{
	  var LvarTD    = document.createElement("TD");
	
	  var LvarInp   = document.createElement("INPUT");
	  LvarInp.type = LprmType;
	  if (LprmName!="") LvarInp.name = LprmName;
	  if (LprmValue!="") LvarInp.value = LprmValue;
	  LvarTD.appendChild(LvarInp);
	  if (LprmClass!="") LvarTD.className = LprmClass;
	  GvarNewTD = LvarTD;
	  LprmTR.appendChild(LvarTD);
	}
</script>