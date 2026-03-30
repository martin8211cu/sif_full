<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EsteValorYaFueAgregado"
	Default="Este valor ya fue agregado."
	returnvariable="MSG_EsteValorYaFueAgregado"/>
	
<script language="JavaScript" type="text/javascript">
	<!--//
	//**********************************Tabla Dinámica**********************************************
	
	var GvarNewTD;
	
	//Función para agregar TRs
	function fnNuevoTR()
	{
	  var LvarTable = document.getElementById("tbldynamic");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOne;

	  var p1 		= document.form1.RHPcodigo2.value;//codigo
	  var p2 		= document.form1.RHPdescripcion.value;//desc
	  var p3		= document.form1.RHCcantplazas.value;//número de plazas
	  var p4		= document.form1.RHPid2.value;

	  // Valida no agregar vacíos
	  if (p1=="") return;
	  
	  // Valida no agregar repetidos
	  if (existeCodigo(p1)) {alert('<cfoutput>#MSG_EsteValorYaFueAgregado#</cfoutput>');return;}

	  // Agrega Columna 1
	  sbAgregaTdInput (LvarTR, Lclass.value, p1,  "hidden", "RHCGidList");

	  // Agrega Columna 2
	  sbAgregaTdText  (LvarTR, Lclass.value, p1 + ' - ' + p2);
	  
	   // Agrega Columna 3
  	  sbAgregaTdInput (LvarTR, Lclass.value, p4, "hidden", "RHPidList");
	  
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
	
	function existeCodigo(v){
		var LvarTable = document.getElementById("tbldynamic");
		for (var i=0; i<LvarTable.rows.length; i++)
		{
			if (fnTdValue(LvarTable.rows[i])==v){
				return true;
			}
		}
		return false;
	}
	
	function fnTdValue(LprmNode)
	{
	  var LvarNode = LprmNode;
	
	  while (LvarNode.hasChildNodes())
	  {
		LvarNode = LvarNode.firstChild;
		if (document.all == null)
		{
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
	//-->
</script> 

<cfif isDefined("session.Ecodigo") and isDefined("Form.RHCconcurso") and Len(Trim(Form.RHCconcurso))>
	<cfquery name="rsBuscaPlazas" datasource="#session.DSN#">
		select a.RHPid, a.RHPCid, b.RHPcodigo, b.RHPdescripcion
		from RHPlazasConcurso a inner join RHPlazas b
		  on a.Ecodigo = b. Ecodigo and
		     a.RHPid   = b.RHPid
		where a.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
		  and a.Usucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	</cfquery>
	<cfif rsBuscaPlazas.recordcount GT 0>
		<cfset bRHPid = rsBuscaPlazas.RHPid>
	</cfif>
	
	<cfquery name="rsvalidaPlazas" datasource="#session.dsn#">
	 	select count(1) as validaPlazas from RHPlazasConcurso
		where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
		  and Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

</cfif>

<cfoutput>
<form  action="ConcursosMng-sql.cfm" method="post" name="form1">
<cfinclude template="ConcursosMng-hiddens.cfm">
<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar Plaza" style="display:none;">
<input type="hidden" name="RHCcantplazas" value="#rsRHConcursos.RHCcantplazas#">
<input type="hidden" name="ORHPcodigo" value="#rsRHConcursos.RHPcodigo#">

<!--- El encabezado unicamente se observa en la pantalla de Registro de Solicitudes de Concurso --->

	<table width="75%" height="75%" align="center" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<cfif not isdefined("Form.tab")>
				<fieldset>
				<legend><cf_translate key="LB_Plazas">Plazas</cf_translate>:</legend>
			</cfif>
				<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0" id="tbldynamic">
					<tr align="center" valign="middle">
					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
				  </tr>
					<tr align="center" valign="middle">
						<td><strong><cf_translate key="Plaza">Plaza</cf_translate>&nbsp;:&nbsp;</strong></td>
						<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2115" default="" returnvariable="LvarValida"/>
						<cfif LvarValida gt 0>
							<cfset LvarOcupa=1>
						<cfelse>
							<cfset LvarOcupa=0>
						</cfif>
						<td><cf_rhplazaconcursos name="RHPcodigo2" id="RHPid2" NoCheckPlazaOcupada="#LvarOcupa#"></td>
						<td>&nbsp;</td>
						<td>
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Agregar"
								Default="Agregar"
								XmlFile="/rh/generales.xml"
								returnvariable="BTN_Agregar"/>

							<input type="button" name="<cfoutput>#BTN_Agregar#</cfoutput>" align="middle" value="+" 
							onClick="javascript: habilitarValidacionMas(); if (objForm.validate()) fnNuevoTR();">
						</td>
				  </tr>
				  <tr><td colspan="4">&nbsp;</td></tr>
				  <tbody>
				  </tbody>
				</table>
				
				<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0">
					<tr><td colspan="3">&nbsp;</td></tr>
					<tr bordercolor="000000"class="Ayuda">
						<td>&nbsp;</td>
						<td align="center">
							<cf_translate key="MSG_PresioneElBotonModificarParaActualizarEstaInformacion">Presione&nbsp;el&nbsp;botón&nbsp;<strong>modificar</strong>&nbsp;para&nbsp;actualizar&nbsp;esta&nbsp;información</cf_translate>
						</td>
						<td>&nbsp;</td>
					</tr>
				</table>
			<cfif not isdefined("Form.tab")>
				</fieldset>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td>
			<cf_rhconsultaplazaconcursos>
		</td>
	</tr>
</table>
	<br>
	<cf_botones modo="#modoAdmConcursos#" exclude="Baja,Nuevo">

	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsRHConcursos.ts_rversion#"/>
	</cfinvoke>
	<input name="ts_rversion" type="hidden" value="#ts#">
	<input type="hidden" name="LastOne" id="LastOne" value="ListaNon">
</cfoutput>
</form>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_SihayDatosModificadosSePuedenPerderDeseaContinuar"
	Default="Si hay datos modificados se pueden perder. ¿Desea continuar?"
	returnvariable="MSG_SihayDatosModificadosSePuedenPerderDeseaContinuar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeAgregarLaMismaCantidadDePlazasEspecificadaEnElPaso1"
	Default="Debe agregar la misma cantidad de plazas especificada en el paso 1"
	returnvariable="MSG_DebeAgregarLaMismaCantidadDePlazasEspecificadaEnElPaso1"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Plaza"
	Default="Plaza"
	returnvariable="LB_Plaza"/>	
<cf_qforms form="form1">
<script language="javascript" type="text/javascript">
	<!--//
	<cfif isDefined("session.Ecodigo") and isDefined("rsRHConcursos.RHPcodigo") and len(trim(#rsRHConcursos.RHPcodigo#)) NEQ 0>
		<cfoutput>
			objForm.RHPcodigo2.description="C#JSStringFormat('ó')#digo";		
			objForm.RHPdescripcion.description="Descripci#JSStringFormat('ó')#n";		
			objForm.RHPdescripcion.description = "<cfoutput>#LB_Plaza#</cfoutput>";
		</cfoutput>
	</cfif>
	<cfoutput>
	function habilitarValidacionMas(){
		objForm.required("RHPcodigo2,RHPdescripcion");		
		objForm.allowsubmitonerror = false;
	}
	
	function habilitarValidacion(){
		deshabilitarValidacion();
	}
	
	function funcAnterior(){
		if (confirm('<cfoutput>#MSG_SihayDatosModificadosSePuedenPerderDeseaContinuar#</cfoutput>')){
			document.form1.paso.value =  1;
			deshabilitarValidacion()
			return true;
		}
		else {
			return true;
		}
	}	
	
	function validap(){
	   var d3 = document.form1.RHCcantplazas.value;
		if (validacantidadplazas(d3)) {
			alert('<cfoutput>#MSG_DebeAgregarLaMismaCantidadDePlazasEspecificadaEnElPaso1#</cfoutput>');
			return false;
		} else {
			return true;
		}

	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindowRHCconcurso(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//Llama el conlis
	function doConsultarPlazasConcursoRHConcurso() {
		popUpWindowRHConcurso("/cfmx/rh/Utiles/Conlisareaevalconcurso.cfm"+250,200,650,400);
	}
		
	
	function validacantidadplazas(cp){
		var LvarTablecp = document.getElementById("tbldynamic"); 
		// Chequear la cantidad de filas en la tabla 
		if (LvarTablecp.rows.length -3 != cp) {
				document.form1.RHPcodigo2.value='';
				document.form1.RHPdescripcion.value='';
				return true;
			}
			
			return false;
			}
	}

	function deshabilitarValidacion(){
		objForm.required("RHPcodigo2,RHPdescripcion",false);
		objForm.allowsubmitonerror = true;
	}
	</cfoutput>	
	  <cfif isDefined("session.Ecodigo") and isDefined("rsRHConcursos.RHPcodigo") and len(trim(#rsRHConcursos.RHPcodigo#)) NEQ 0>
		<cfoutput query="rsBuscaPlazas">
			objForm.RHPid2.obj.value = "#RHPid#";
			objForm.RHPcodigo2.obj.value = "#RHPcodigo#";
			objForm.RHPdescripcion.obj.value = "#RHPdescripcion#";
			fnNuevoTR();
		</cfoutput>

		objForm.RHPcodigo2.obj.value = "";
		objForm.RHPdescripcion.obj.value = "";
		objForm.RHPcodigo2.obj.focus();
	</cfif>
	
	
	function funcConsultaPuesto(valor){
	var params ="";
		params = "<cfoutput>?RHPcodigo=#rsRHConcursos.RHPcodigo#</cfoutput>";
		popUpWindowPuestos("/cfmx/rh/Reclutamiento/operacion/consultaPuesto.cfm"+params,75,50,850,630);
	}
	
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindowPuestos(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popupWindow', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	
	//-->
</script>
