<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Pruebas"
	Default="Pruebas"
	returnvariable="LB_Pruebas"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Prueba"
	Default="Prueba"
	returnvariable="LB_Prueba"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Competencia"
	Default="Competencia"
	returnvariable="LB_Competencia"/>

<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif isDefined("session.Ecodigo") and isDefined("Form.codigo") and len(trim(#Form.codigo#)) NEQ 0>
	<cf_translatedata name="get" tabla="RHCompetencias" col="descripcion" returnvariable="Lvardescripcion">
	<cfquery name="rsRHCompetencias" datasource="#Session.DSN#" >
		select id as ident, codigo, #Lvardescripcion# as descripcion, Tipo
		from RHCompetencias
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and upper(codigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Form.codigo)#"><!--- CON09 --->
		order by #Lvardescripcion# asc
	</cfquery>
	<cf_translatedata name="get" tabla="RHPruebas" col="RHPdescripcionpr" returnvariable="LvarRHPdescripcionpr">
	<cfquery name="rsValoresB" datasource="#session.DSN#">
		select a.id, a.Ecodigo, a.RHPcodigopr, a.RHPCtipo, #LvarRHPdescripcionpr# as RHPdescripcionpr
		from RHPruebasCompetencia a, RHPruebas b
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.Ecodigo = b.Ecodigo
		and a.RHPCtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsRHCompetencias.Tipo#">
		and a.RHPcodigopr = b.RHPcodigopr
		and a.id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHCompetencias.ident#">		
	</cfquery>
	
</cfif>

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
	  
	  var Lclass 	= document.form.LastOne;
	  
	  var p1 		= document.form.RHPcodigopr.value;//codigo
	  var p2 		= document.form.RHPdescripcionpr.value;//cod


	
	  // Valida no agregar vacíos
	  if (p1=="") return;
	  
	  // Valida no agregar repetidos
	  if (existeCodigo(p1)) {alert('<cfoutput>#MSG_EsteValorYaFueAgregado#</cfoutput>');return;}
	
	  // Agrega Columna 1
	  sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "RHCGidList");


	  // Agrega Columna 2
	  sbAgregaTdText  (LvarTR, Lclass.value, p1 + ' - ' + p2);

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



<form action="PruebasXCompetencia-SQL.cfm" method="post" name="form">
	<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar competencia." style="display:none;">
	<cfoutput>
	<table width="67%" height="75%" align="center" cellpadding="0" cellspacing="0">
		<tr><td colspan="5">&nbsp;</td></tr>
		<cfif modo NEQ "ALTA">
			<tr>
				<td width="13%" align="right" nowrap>&nbsp;</td>  
				<td width="16%" align="right" nowrap><strong>#LB_Codigo#:&nbsp;</strong></td>
				<td width="16%"> 
					<input name="codigo" type="text"  readonly="Y" onFocus="this.select();" 
						value="<cfif modo neq "ALTA" >#trim(rsRHCompetencias.codigo)#</cfif>" 
						size="10" maxlength="5" class ="cajasinbordeb">
				</td>
				<td width="15%" align="right" nowrap>&nbsp;</td>
				<td width="40%">&nbsp;</td>
			</tr>
			<tr>
				<td align="right" nowrap>&nbsp;</td>
				<td align="right" nowrap><strong>#LB_Descripcion#:&nbsp;</strong></td>
				<td colspan="3">
					<input name="descripcion" type="text" readonly="Y" 
						value="<cfif modo neq "ALTA">#trim(rsRHCompetencias.descripcion)#</cfif>" 
						size="60" maxlength="80" onFocus="this.select();" class ="cajasinbordeb">
				</td>
			</tr>
		</cfif>
	</table>
	<br>
	<cfif modo EQ "CAMBIO">
		<fieldset><legend>#LB_Pruebas#:</legend>
			<table width="90%" align="center" cellspacing="0" cellpadding="0" id="tbldynamic">
				<tr>
					<td><strong>#LB_Prueba#&nbsp;:&nbsp;</strong></td>
					<td><cf_rhpruebas form="form">	</td> 
					<td>&nbsp;
						<input type="button" name="Agregar" value="+" 
						onClick="javascript: habilitarValidacionMas(); if (objForm.validate()) fnNuevoTR();">
					</td>
				</tr>
				<tbody>
				</tbody>
			</table>
			<!--- ayuda --->
			<table width="90%" align="center" cellspacing="0" cellpadding="0" class="Ayuda">
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td align="center">
						<cf_translate key="AYUDA_PresioneElBotonModificarParaAcutalizarEstaInformacion">Presione&nbsp;el&nbsp;botón&nbsp;<strong>modificar</strong>&nbsp;para&nbsp;actualizar&nbsp;esta&nbsp;información</cf_translate>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		</fieldset>
		<br>
		<cf_botones modo=#modo# exclude = 'Baja,Nuevo' regresarMenu="true">
	<cfelseif modo eq 'ALTA'>
		<table width="90%" align="center" cellspacing="0" cellpadding="0" class="Ayuda">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td width="100%" align="center">
					<strong><cf_translate key="MSG_DebeSeleccionarUnaCompetenciaParaVerLasPruebas">Debe seleccionar una Competencia para ver la(s) Prueba(s).</cf_translate></strong>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
		<table width="90%" align="center" cellspacing="0" cellpadding="0">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td><cf_botones exclude = 'Alta,Baja,Nuevo,Limpiar' regresarMenu="true"></td>
			</tr>
		</table>
	</cfif>
	
	<input type="hidden" name="LastOne" id="LastOne" value="ListaNon">
	<input type="hidden" name="Ocodigo"value="<cfif modo neq "ALTA">#rsRHCompetencias.codigo#</cfif>" size="32">
	<input type="hidden" name="Tipo" value="<cfif modo neq "ALTA">#rsRHCompetencias.Tipo#</cfif>" size="32"> 
	<input type="hidden" name="Oid" value="<cfif modo NEQ "ALTA">#rsRHCompetencias.ident#</cfif>" size="32"> 
	</cfoutput>	
</form>



<cf_qforms form="form">
<script language="javascript" type="text/javascript">
	<!--//
<cfif isDefined("session.Ecodigo") and isDefined("Form.codigo") and len(trim(#Form.codigo#)) NEQ 0>
	<cfoutput>
		objForm.RHPcodigopr.description="#LB_Codigo#";		
		objForm.RHPdescripcionpr.description="#LB_Descripcion#";		
		<cfif modo NEQ "ALTA">
			objForm.descripcion.description = "#LB_Competencia#";
		</cfif>
	</cfoutput>
</cfif>
	<cfoutput>
	function habilitarValidacionMas(){
		objForm.required("RHPcodigopr,RHPdescripcionpr");		
	}
	
	function habilitarValidacion(){
		deshabilitarValidacion();
	}
	
	function deshabilitarValidacion(){
		objForm.required("RHPcodigopr,RHPdescripcionpr",false);
	}
	</cfoutput>	

	 <cfif isDefined("session.Ecodigo") and isDefined("Form.codigo") and len(trim(#Form.codigo#)) NEQ 0>
		<cfoutput query="rsValoresB">
			objForm.RHPcodigopr.obj.value = "#RHPcodigopr#";
			objForm.RHPdescripcionpr.obj.value = "#RHPdescripcionpr#";
			fnNuevoTR();
		</cfoutput>

		objForm.RHPcodigopr.obj.value = "";
		objForm.RHPdescripcionpr.obj.value = "";
		objForm.RHPcodigopr.obj.focus();
	</cfif>
	//-->
</script>