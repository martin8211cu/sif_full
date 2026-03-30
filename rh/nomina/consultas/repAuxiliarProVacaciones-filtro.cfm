<cfsetting requesttimeout="8600">
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_ReporteDeSaldosDeVacaciones" default="Reporte de Saldos de Vacaciones" returnvariable="LB_ReporteDeSaldosDeVacaciones" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Consultar" default="Consultar" returnvariable="BTN_Consultar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke Key="MSG_DebeSeleccionarUnaFechaDeInicioYUnaFechaFinal" Default="Debe seleccionar una fecha de inicio y una fecha final" returnvariable="MSG_DebeSeleccionarUnaFechaDeInicioYUnaFechaFinal" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="JSMSG_La_lista_de_Nominas_es_requerida" Default="La lista de Nóminas es requerida"returnvariable="JSMSG_La_lista_de_Nominas_es_requerida"/> 
<!--- FIN VARIABLES DE TRADUCCION --->

<cfquery name="rsTiposNominas" datasource="#session.dsn#">
	select Tcodigo, Tdescripcion 
	from TiposNomina
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">	
</cfquery>	
    
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">

<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
	<!--
	function MM_reloadPage(init) {  //reloads the window if Nav4 resized
	  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
		document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
	  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
	}
	MM_reloadPage(true);
	//-->
</script>

<cfinclude template="/rh/Utiles/params.cfm">
<cfset Session.Params.ModoDespliegue = 1>
<cfset Session.cache_empresarial = 0>

             	
<cf_web_portlet_start border="true" titulo="#LB_ReporteDeSaldosDeVacaciones#" skin="#session.preferences.skin#" >
<cfinclude template="/rh/portlets/pNavegacionPago.cfm">

<cfoutput>
<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
<form name="form1" method="post" action="repAuxiliarProVacaciones-rep.cfm" style="margin:0;">
	<input type="hidden" name="LastOneCalendario" id="LastOneCalendario" value="ListaNon" tabindex="1">
	<input type="hidden" name="CPidlist1" id="CPidlist1" value="" tabindex="1">
	<table width="90%" cellpadding="0" cellspacing="0" border="0">
		<tr><td colspan="3">&nbsp;</td></tr>
        <tr>
			<td width="33.3%" nowrap align="right"><strong><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate>:&nbsp;</strong></td>										
			<td width="33.3%">
				<cf_rhcfuncional form="form1" name="CFcodigoI" desc="CFdescripcionI" id="CFidI" codigosize='15' size='25' >
			</td>
            <td width="33.3%" align="right"></td>
		</tr>
		<tr>
			<td width="33.3%" nowrap align="right">
				<strong><cf_translate  key="LB_IncluirDependencias">Incluir dependencias</cf_translate>:&nbsp;</strong>
			</td>
			<td width="33.3%"> <input type="checkbox" name="dependencias" value="dependencias" <cfif isdefined("form.dependencias")>checked</cfif> /></td>
            <td width="33.3%"></td>
		</tr>
		<tr>
			<td nowrap align="right" width="33.3%"> <strong><cf_translate  key="LB_Nomina">N&oacute;mina</cf_translate> :&nbsp;</strong></td>
			<td width="33.3%">
				<cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true" index="1" tabindex="1" pintaRCDescripcion="true" orientacion="2" Excluir = "1">
	       </td>
			<td width="33.3%" align="center">
				<input type="button" name="agregarCalendario1" onClick="javascript:if (window.fnNuevoCalendario) fnNuevoCalendario();" value="+" tabindex="1">
			</td>
		</tr>
		<tr>
			<td colspan = "3">
				<table id="tblcalendario1" width="80%" cellpadding="2" cellspacing="0" border="0" align="center">
					<tbody>
					</tbody>
				</table>
			</td>
		</tr>
		<tr id="trBTNgen">
			<td align="center" colspan="3">
				<cf_botones values="Generar" tabindex="1">
			</td>
		</tr>
	</table>
</form>

<cf_web_portlet_end>


<script language="javascript" type="text/javascript">
	
	function irAExportar(){
		document.form1.action="ReporteBancosExportar.cfm";
	}
	
	function showExportadores(chk){
		if(chk.checked) {
			document.getElementById("TDExp").style.display = '';
			document.getElementById("trBTNexp").style.display = '';
			document.getElementById("trBTNgen").style.display = 'none';
		}
		else{
			document.getElementById("TDExp").style.display = 'none';
			document.getElementById("trBTNexp").style.display = 'none';
			document.getElementById("trBTNgen").style.display = '';
		}
	}
	
	var vnContadorListas1 = 0;
	//Función para agregar TDs con Objetos
	function sbAgregaTdInput (LprmTR, LprmClass, LprmValue, LprmType, LprmName){
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
	
	function fnTdValue(LprmNode){
	  var LvarNode = LprmNode;
	  while (LvarNode.hasChildNodes()){
		LvarNode = LvarNode.firstChild;
		if (document.all == null){
		  if (!LvarNode.firstChild && LvarNode.nextSibling != null &&
			LvarNode.nextSibling.hasChildNodes())
			LvarNode = LvarNode.nextSibling;
		}
	  }
	  if (LvarNode.value)
		return LvarNode.value;
	  else
		return LvarNode.nodeValue;
	}	
	
	function existeCalendario(v){
		var LvarTable = document.getElementById("tblcalendario1");
		for (var i=0; i<LvarTable.rows.length; i++){
			var value = new String(fnTdValue(LvarTable.rows[i]));
			var data = value.split('|');
			if (data[0] == v){
				return true;
			}
		}
		return false;
	}		
		
	//Función para agregar TDs con texto
	function sbAgregaTdText (LprmTR, LprmClass, LprmValue){
	  var LvarTD    = document.createElement("TD");
	  var LvarTxt   = document.createTextNode(LprmValue);
	  LvarTD.appendChild(LvarTxt);
	  if (LprmClass!="") LvarTD.className = LprmClass;
	  GvarNewTD = LvarTD;
	  LvarTD.noWrap = true;
	  LprmTR.appendChild(LvarTD);
	}		
	
	//Función para agregar Imagenes
	function sbAgregaTdImage (LprmTR, LprmClass, LprmNombre, align){
	  // Copia una imagen existente
	  var LvarTDimg    = document.createElement("TD");
	  var LvarImg = document.getElementById(LprmNombre).cloneNode(true);
	  LvarImg.style.display="";
	  LvarImg.align=align;
	  LvarTDimg.appendChild(LvarImg);
	  if (LprmClass != "") LvarTDimg.className = LprmClass;
	  GvarNewTD = LvarTDimg;
	  LprmTR.appendChild(LvarTDimg);
	}	
	
	//Función para eliminar TRs
	function sbEliminarTR1(e){
	  vnContadorListas1 = vnContadorListas1 - 1;
	  var LvarTR;
	  if (document.all)
		LvarTR = e.srcElement;
	  else
		LvarTR = e.currentTarget;
	  while (LvarTR.name != "XXXXX")
		LvarTR = LvarTR.parentNode;
	  LvarTR.parentNode.removeChild(LvarTR);
	}

	function getTdescripcion(Tcodigo){
		<cfloop query="rsTiposNominas">
		if (Tcodigo=="#trim(Tcodigo)#") return "#Tdescripcion#";
		</cfloop>
		return "";
	}
		
	function fnNuevoCalendario(){
	  //verifica que exista una nómina seleccionada
	  if (document.form1.Tcodigo1.value == '' && document.form1.CPid1.value == ''){
	  	return;
	  }
	  
		var LvarTable = document.getElementById("tblcalendario1");
		var LvarTbody = LvarTable.tBodies[0];
		var LvarTR    = document.createElement("TR");
		var Lclass 	= document.form1.LastOneCalendario;
 		var p1 = document.form1.CPid1.value.toString(); //id del calendario
 		var p2 = getTdescripcion(document.form1.Tcodigo1.value.toString()); //tipo de nomina
		var p3 = document.form1.CPcodigo1.value.toString(); //codigo de nomina
		var p4 = document.form1.CPdescripcion1.value.toString(); //descripcion de nomina
		var p5 = 1;
		var p6 = "CPidlist1";
		vnContadorListas1 = vnContadorListas1 + 1;
		document.form1.Tcodigo1.value = '';
		document.form1.CPid1.value = '';
		document.form1.CPcodigo1.value = '';
		document.form1.CPdescripcion1.value = '';

	  // Valida no agregar vacíos
	  if (p1=="") return;	  
	  // Valida no agregar repetidos
	  if (existeCalendario(p1,p5)) {alert('Este Calendario ya fue agregado.');return;}
  	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", p6);
	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value, p2);
	  // Agrega Columna 2
	  sbAgregaTdText (LvarTR, Lclass.value, p3);
	  // Agrega Columna 3
	  sbAgregaTdText  (LvarTR, Lclass.value, p4);
	  // Agrega Evento de borrado en Columna 3
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
	  if (p5==1) {
		  if (document.all)
			GvarNewTD.attachEvent ("onclick", sbEliminarTR1);
		  else
			GvarNewTD.addEventListener ("click", sbEliminarTR1, false);
	  } else {
		  if (document.all)
			GvarNewTD.attachEvent ("onclick", sbEliminarTR2);
		  else
			GvarNewTD.addEventListener ("click", sbEliminarTR2, false);
	  }
	  // Nombra el TR
	  LvarTR.name = "XXXXX";
	  // Agrega el TR al Tbody
	  LvarTbody.appendChild(LvarTR);
	  if (Lclass.value=="ListaNon")
		Lclass.value="ListaPar";
	  else
		Lclass.value="ListaNon";
	}
	/*función que actualiza el tipo de cambio y lo habilita/desahbilita*/
	<!---<cfif FindNoCase('SA',Gvar_action) GT 0>
		function setTipoCambio(){
			document.form1.TipoCambio.value='1.00';
			document.form1.TipoCambio.disabled=(document.form1.Mcodigo.value==#rsMonLoc.Mcodigo#);
		}
		setTipoCambio();
	</cfif>--->
	/*validar el formulario 1*/
	function _validateForm1(){
		if (!objForm._allowSubmitOnError) {
			if (vnContadorListas1<=0) objForm.CPidlist1.throwError("#JSMSG_La_lista_de_Nominas_es_requerida#");
			<!---<cfif FindNoCase('SA',Gvar_action) GT 0>
				if (objForm.Mcodigo.getValue()=='') objForm.Mcodigo.throwError("#JSMSG_El_campo# #JSMSG_Moneda# #JSMSG_es_requerido#");
				if (objForm.TipoCambio.getValue()=='') objForm.TipoCambio.throwError("#JSMSG_El_campo# #JSMSG_TipoCambio# #JSMSG_es_requerido#");
			</cfif>--->
		}
	}
	/*funcion antes de hacer submit*/
	function _submitForm1(){
		<!---<cfif FindNoCase('SA',Gvar_action) GT 0>
		document.form1.TipoCambio.disabled=false;
		</cfif>--->
	}
</script>
</cfoutput>
<cf_qforms onValidate="_validateForm1" onSubmit="_submitForm1">