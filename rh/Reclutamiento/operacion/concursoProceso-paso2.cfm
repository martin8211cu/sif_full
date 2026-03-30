<cfif isDefined("url.RHCconcurso") and (len(trim(#url.RHCconcurso#)) NEQ 0) and not isDefined("form.RHCconcurso")>
	<cfset form.RHCconcurso = url.RHCconcurso>
</cfif>
<cfif isDefined("url.paso") and (len(trim(#url.paso#)) NEQ 0) and not isDefined("form.paso")>
	<cfset form.paso = url.paso>
</cfif>

<cfif isDefined("session.Ecodigo") and isDefined("Form.RHCconcurso") and Len(Trim(Form.RHCconcurso))>

    <cf_translatedata name="get" tabla="RHConcursos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">
    <cf_dbfunction name="spart" args="#LvarRHCdescripcion#°1°55" delimiters="°" returnvariable="LvaRHCdescripcion">
    <cf_translatedata name="get" tabla="CFuncional" col="CFdescripcion" returnvariable="LvarCFdescripcion">
    <cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
	<cfquery name="rsRHConcursos" datasource="#Session.DSN#">
		Select a.RHCconcurso, a.RHCcodigo, #LvarRHCdescripcion# as RHCdescripcion, 
			a.CFid, c.CFcodigo as CFcodigoresp, #LvarCFdescripcion# as CFdescripcionresp, 
			a.RHPcodigo, coalesce(b.RHPcodigoext,b.RHPcodigo) as RHPcodigoext, #LvarRHPdescpuesto# as RHPdescpuesto, a.RHCcantplazas, a.RHCfecha,
			a.RHCfapertura, a.RHCfcierre, a.RHCmotivo, a.RHCotrosdatos, a.RHCestado, a.Usucodigo, 
			a.ts_rversion
        from RHConcursos a

			left outer join RHPuestos b
				on b.RHPcodigo = a.RHPcodigo
				and b.Ecodigo  = a.Ecodigo

			left outer join CFuncional c
				on c.CFid	   = a.CFid
				and c.Ecodigo  = a.Ecodigo
				
		where a.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#" >
	</cfquery>
</cfif>

<cfoutput>
	<table width="65%" height="75%" align="center" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td width="16%" align="right" nowrap><strong>C&oacute;digo de Concurso:&nbsp;</strong></td>
			<td width="24%">
				#rsRHConcursos.RHCcodigo#
			</td>
			<td align="right" width="14%" nowrap><strong>&nbsp; &nbsp;Fecha Apertura:&nbsp;</strong></td>
			<td align="left" width="6%">
				<cfset fechaI = rsRHConcursos.RHCfapertura>
				#LSDateFormat(fechaI,'dd/mm/yyyy')#
			</td>
			<td width="23%" align="left" nowrap><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Fecha Cierre:</strong>&nbsp;</td>
			<td width="17%" align="left" >
				<cfset fechaF = rsRHConcursos.RHCfcierre>
				#LSDateFormat(fechaF,'dd/mm/yyyy')#
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="right" nowrap><strong>&nbsp; N&deg; Plazas:&nbsp;</strong></td>
			<td align="left" >
			#rsRHConcursos.RHCcantplazas#
			</td>
			<td align="right" nowrap><strong>Puesto:&nbsp;</strong></td>
			<td align="left" colspan="7">#rsRHConcursos.RHPcodigoext#- #rsRHConcursos.RHPdescpuesto#
			<a href="##" tabindex="-1" onClick='javascript: funcConsultaPuesto();'>
					<img src="/cfmx/rh/imagenes/findsmall.gif" alt="Información sobre el Puesto" name="imagen" width="18" 
					height="14" border="0" align="absmiddle"  title="Información sobre el Puesto"
					onClick='javascript: funcConsultaPuesto();'>
			</a></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="right"><strong><cf_translate key="LB_CentroFuncional" xmlFile="/rh/generales.xml">Centro Funcional</cf_translate>:&nbsp;</strong></td>
			<td align="left" nowrap >#rsRHConcursos.CFcodigoresp# - #rsRHConcursos.CFdescripcionresp#</td>
			<td align="right">&nbsp;&nbsp;<strong>Estado:</strong>&nbsp;</td>
			<td align="left"> 
				<cfswitch expression="#rsRHConcursos.RHCestado#">
					<cfcase value="0"><strong><cf_translate key="LB_EnProceso" xmlFile="/rh/generales.xml">En Proceso</cf_translate></strong></cfcase>
					<cfcase value="10"><strong><cf_translate key="LB_Solicitado" xmlFile="/rh/generales.xml">Solicitado</cf_translate></strong></cfcase>
					<cfcase value="20"><strong><cf_translate key="LB_Desierto" xmlFile="/rh/generales.xml">Desierto</cf_translate></strong></cfcase>
					<cfcase value="30"><strong><cf_translate key="LB_Cerrado" xmlFile="/rh/generales.xml">Cerrado</cf_translate>Cerrado</strong></cfcase>
					<cfcase value="15"><strong><cf_translate key="LB_Verificado" xmlFile="/rh/generales.xml">Verificado</cf_translate></strong></cfcase>
					<cfcase value="40"><strong><cf_translate key="LB_Revisión" xmlFile="/rh/generales.xml">Revisión</cf_translate></strong></cfcase>
					<cfcase value="50"><strong><cf_translate key="LB_Aplicado" xmlFile="/rh/generales.xml">Aplicado</cf_translate></strong></cfcase>
					<cfcase value="60"><strong<cf_translate key="LB_Evaluando" xmlFile="/rh/generales.xml">Evaluando</cf_translate>></strong></cfcase>
				</cfswitch>
			</td>
		</tr>
		<tr><td>&nbsp;</td><td colspan="7">&nbsp;</td></tr>
	</table>
</cfoutput>

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
	  if (existeCodigo(p1)) {alert('<cf_translate key="LB_EsteValorYaFueAgregado" xmlFile="/rh/generales.xml">Este valor ya fue agregado</cf_translate>.');return;}

	  // Valida agregar solamente las plazas autorizadas en el paso 1
	   if (validanplazas(p3)) {alert('<cf_translate key="LB_NoSePuedenAgregarMasPlazas" xmlFile="/rh/generales.xml">No se pueden agregar más plazas que la cantidad especificada en el paso 1</cf_translate>');return;}

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
	
	<!---
	function validanplazas(n){
		var LvarTablen = document.getElementById("tbldynamic");
		for (var c=0; c < LvarTablen.rows.length; c++)
		{
			if (c > n) {
				return true;
			}
		}
		return false;
	}
	--->
	function validanplazas(n){
		var LvarTablen = document.getElementById("tbldynamic");
		var disponible = n - LvarTablen.rows.length + 3; // 3 es la cantidad de líneas iniciales
		if (disponible <= 0) return true;
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
<form  action="#CurrentPage#" method="post" name="form1">
<cfif isdefined("Form.tab")>
	<input type="hidden" name="tab" value="#Form.tab#">
</cfif>
<input type="hidden" name="paso" value="<cfif isdefined("Gpaso")>#Gpaso#<cfelse>0</cfif>">
<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar Plaza" style="display:none;">
<input type="hidden" name="RHCcantplazas" value="#rsRHConcursos.RHCcantplazas#">
<input type="hidden" name="ORHPcodigo" value="#rsRHConcursos.RHPcodigo#">

<!--- El encabezado unicamente se observa en la pantalla de Registro de Solicitudes de Concurso --->

	<table width="75%" height="75%" align="center" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<cfif not isdefined("Form.tab")>
				<fieldset>
				<legend>Plazas:</legend>
			</cfif>
				<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0" id="tbldynamic">
					<tr align="center" valign="middle">
					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
				  </tr>
					<tr align="center" valign="middle">
						<td><strong>Plaza&nbsp;:&nbsp;</strong></td>
						<td><cf_rhplazaconcursos name="RHPcodigo2" id="RHPid2"></td>
						<td>&nbsp;</td>
						<td>
							<input type="button" name="Agregar" align="middle" value="+" 
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
						<td align="center">Presione&nbsp;el&nbsp;botón&nbsp;<strong>modificar</strong>&nbsp;para&nbsp;actualizar&nbsp;esta&nbsp;información</td>
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
	<!--- PANTALLA DE ADMINISTRACION DE CONCURSOS --->
	<cfif isdefined("Form.tab")>
		<p align="center">
			<input type="submit" name="btnAceptar" value="Aceptar">
		</p>
	<!--- PANTALLA DE REGISTRO DE SOLICITUDES DE CONCURSOS --->
	<cfelse>
		<cf_botones modo="CAMBIO" includebefore="Anterior" includebeforevalues="<< Anterior" exclude="Baja,Nuevo" include="Siguiente" includevalues="Siguiente >>" >
	</cfif>

	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsRHConcursos.ts_rversion#"/>
	</cfinvoke>
	<input name="ts_rversion" type="hidden" value="#ts#">
	<input type="hidden" name="LastOne" id="LastOne" value="ListaNon">
	<input name="RHCconcurso" type="hidden" 
		value="<cfif isdefined("form.RHCconcurso") and (form.RHCconcurso GT 0)><cfoutput>#form.RHCconcurso#</cfoutput></cfif>">
	<input name="pasoante" type="hidden" value="2">
</cfoutput>
</form>

<cf_qforms form="form1">
<script language="javascript" type="text/javascript">
	<!--//
	<cfif isDefined("session.Ecodigo") and isDefined("rsRHConcursos.RHPcodigo") and len(trim(#rsRHConcursos.RHPcodigo#)) NEQ 0>
		<cfoutput>
			objForm.RHPcodigo2.description="C#JSStringFormat('ó')#digo";		
			objForm.RHPdescripcion.description="Descripci#JSStringFormat('ó')#n";		
			objForm.RHPdescripcion.description = "Plaza";
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
		if (confirm('Si hay datos modificados se pueden perder. ¿Desea continuar?')){
			document.form1.paso.value =  1;
			deshabilitarValidacion()
			return true;
		}
		else {
			return true;
		}
	}	
	
	function funcSiguiente(){
	 if (validap()){document.form1.Cambio; return true;} else {return false;}
	
	} 

	function validap(){
	   var d3 = document.form1.RHCcantplazas.value;
		if (validacantidadplazas(d3)) {
			alert('Debe agregar la misma cantidad de plazas especificada en el paso 1');
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
