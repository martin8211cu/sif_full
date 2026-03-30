<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
<cf_web_portlet_start titulo=" Comparaci&oacute;n Salarios vs Encuestas" width="100%">
	<cfinclude template="/home/menu/pNavegacion.cfm">
	
	<!--- empresas encuestadoras --->
	<cfquery name="empresas" datasource="#session.DSN#">
		select a.EEid, b.EEcodigo, b.EEnombre
		from RHEncuestadora a
		inner join EncuestaEmpresa b
		on a.EEid=b.EEid
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif  not isdefined("url.EEid")>
		<cfset url.EEid = empresas.EEid>
	</cfif>
	
	<!--- tipo de Organizacion --->
	<cfquery name="TipoOrg" datasource="#session.DSN#">
		select  ETid, ETdescripcion
		from EmpresaOrganizacion 
		where EEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EEid#">
	</cfquery>

	<cfif  not isdefined("url.ETid")>
		<cfset url.ETid = TipoOrg.ETid>
	</cfif>

	<!--- encuestas --->
	<cfquery name="encuestas" datasource="#session.DSN#">
		select Eid ,Edescripcion 
		from Encuesta
		where EEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EEid#">
	</cfquery>
	
	<cfif  not isdefined("url.Eid")>
		<cfset url.Eid = encuestas.Eid>
	</cfif>

	<!--- monedas --->
	<cfquery name="monedas" datasource="#session.DSN#">
		select distinct Moneda, Mnombre 
		from EncuestaSalarios a
		
		inner join Monedas b
		on b.Mcodigo=a.Moneda
		and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Eid#"> 
		where a.Moneda in ( select distinct Moneda 
							from EncuestaSalarios a
							
							inner join EncuestaEmpresa b
							on a.EEid=b.EEid
							
							inner join RHEncuestadora c
							on b.EEid=c.EEid
							and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
	</cfquery>

	<cfif  not isdefined("url.Mcodigo")>
		<cfset url.Mcodigo = monedas.Moneda>
	</cfif>

	<cfif  isdefined("url.CFid") and len(trim(url.CFid))>
		<!--- Centro funcional --->
		<cfquery name="rsCF" datasource="#session.DSN#">
			select CFid ,CFcodigo,CFdescripcion 
			from CFuncional
			where  CFid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
			and   Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>	
	</cfif>



<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js"></script>
	<cfoutput>
	<form method="get" name="form1" action="ComparaSalario-filtro.cfm" style="MARGIN:0;">
	<table width="100%" cellpadding="2" cellspacing="0" border="0">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="right" width="50%"><strong>Empresa Encuestadora:&nbsp;</strong></td>
			<td colspan="2">
				<select name="EEid" onChange="javascript:document.form1.submit();">
					<cfloop query="empresas">
						<option value="#empresas.EEid#" <cfif url.EEid eq empresas.EEid> selected </cfif>  >#empresas.EEnombre#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		
		<tr>
			<td align="right" ><strong>Tipo de Organizaci&oacute;n:&nbsp;</strong></td>
			<td colspan="2">
				<select name="ETid" id="ETid" >
					<cfloop query="TipoOrg">
						<option value="#TipoOrg.ETid#" <cfif url.ETid eq TipoOrg.ETid> selected </cfif>  >#TipoOrg.ETdescripcion#</option>
					</cfloop>
				</select>
			</td>
		</tr>

 		<tr>
			<td align="right" ><strong>Encuesta:&nbsp;</strong></td>
			<td colspan="2">
				<select name="Eid" onChange="javascript:document.form1.submit();">
					<cfloop query="encuestas">
						<option value="#encuestas.Eid#" <cfif url.Eid eq encuestas.Eid> selected </cfif>  >#encuestas.Edescripcion#</option>
					</cfloop>				
				</select>
			</td>
		</tr>

		<tr>
			<td align="right" ><strong>Moneda:&nbsp;</strong></td>
			<td colspan="2">
				<select name="Mcodigo" id="Mcodigo">
					<cfloop query="monedas">
						<option value="#monedas.moneda#" <cfif url.Mcodigo eq monedas.moneda> selected </cfif>  >#monedas.Mnombre#</option>
					</cfloop>					
				</select>
			</td>
		</tr>
		<tr>
		  <td><div align="right"><strong>Centro Funcional: </strong></div></td>
		  <td colspan="2">
			<cfif isdefined("url.CFid") and len(trim(url.CFid))>
				<cf_rhcfuncional query="#rsCF#">
			<cfelse>
				<cf_rhcfuncional>
			</cfif>
		  </td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td  colspan="2" align="left"><input  onClick="Pintalista()" type="checkbox" id="AllPuestos" name="AllPuestos" checked>
			&nbsp;Todos los Puestos</td>
		</tr>
		<tr id="TDPUESTOS" style="display:none">
			<td><div align="right"><strong>Puesto: </strong></div></td>
			<td colspan="2">
				<table>
					<tr>
						<td  align="left">
							<cf_rhpuesto name="RHPcodigo">
						</td>
						<td  nowrap align="left">
							<input type="button"  id="AgregarPuesto" name="AgregarPuesto" value="+" onClick="javascript:if (window.fnNuevoPuesto) fnNuevoPuesto();">
							<input type="hidden" name="LastOnePuesto" id="LastOneAPuesto" value="ListaNon">
						</td>
					</tr>
				</table> 
			</td>
		</tr>
		<tr id="TDPUESTOS2" style="display:none">
			<td></td>
			<td>
				<table width="100%" border="0"  id="tblPuesto">
				<tr><td></td></tr>
				</table>
			</td>
		</tr>
		<tr>
		<td align="right" w><strong>Nivel Salarial:&nbsp;</strong></td>
			<td colspan="2">
				<select name="NivelS" id="NivelS">
					<option value="25" <cfif isdefined("url.NivelS") and url.NivelS eq 25> selected </cfif>  >P25</option>
					<option value="50" <cfif isdefined("url.NivelS") and url.NivelS eq 50> selected </cfif>  >P50</option>
					<option value="75" <cfif isdefined("url.NivelS") and url.NivelS eq 75> selected </cfif>  >P75</option>
					<option value="1"  <cfif isdefined("url.NivelS") and url.NivelS eq 1> selected </cfif>   >Promedio Anterior</option>
					<option value="0"  <cfif isdefined("url.NivelS") and url.NivelS eq 0> selected </cfif>   >Promedio Actual</option>
					<option value="10" <cfif isdefined("url.NivelS") and url.NivelS eq 10> selected </cfif>  >Otro Percentil</option>
				</select>
			</td>
		</tr>		
		<td align="right" ><strong>Tipo de Reporte:&nbsp;</strong></td>
			<td colspan="2">
				<select name="FORMATO" id="FORMATO">
					<option value="1" <cfif isdefined("url.FORMATO") and url.FORMATO eq 1> selected </cfif>  >Flash Paper</option>
					<option value="2" <cfif isdefined("url.FORMATO") and url.FORMATO eq 2> selected </cfif>  >PDF</option>
					<option value="3" <cfif isdefined("url.FORMATO") and url.FORMATO eq 3> selected </cfif>  >Excel</option>
				</select>
			</td>
		</tr>		
		<tr>
			<td colspan="3" align="center">
				<!--- <input type="submit" name="Consultar" value="Consultar"> --->
				<input type="button"  id="Consultar" name="Consultar" value="Consultar" onClick="javascript:if (window.Consultarjs) Consultarjs();">
			</td>
		</tr>

		<tr><td>&nbsp;</td></tr>
	</table>
	</form>
	<input type="image" id="imgDel"src="/cfmx/rh/imagenes/Borrar01_S.gif"    title="Eliminar" style="display:none;" tabindex="9">
	</cfoutput>
	<script language="JavaScript1.2">
		<!--//
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");
		function Consultarjs(){
			document.form1.action = 'ComparaSalario-query.cfm';
			document.form1.submit();
		}
		function Pintalista() {
			var TDPUESTOS = document.getElementById("TDPUESTOS");
			var TDPUESTOS2 = document.getElementById("TDPUESTOS2");
			if(document.form1.AllPuestos.checked){
				TDPUESTOS.style.display = 'none';
				TDPUESTOS2.style.display = 'none';
			}
			else{
				TDPUESTOS.style.display = ''
				TDPUESTOS2.style.display = '';
			}
		}
		Pintalista();
		//-->
		/*	
		function Lista() {
			location.href = 'listaDatosEncuestas.cfm';
		}
		
		function setBtn(obj) {
			botonActual = obj.name;
		}

		qFormAPI.errorColor = "#FFFFCC";
		objForm = new qForm("form1");
	
		objForm.EEid.required = true;
		objForm.EEid.description="Empresa Encuestadora";
		objForm.ETid.required = true;
		objForm.ETid.description="Tipo de Organización";
		objForm.Eid.required = true;
		objForm.Eid.description="Encuesta";
		objForm.Mcodigo.required = true;
		objForm.Mcodigo.description="Moneda";
	*/
	function fnNuevoPuesto() 
	{
		var LvarTable = document.getElementById("tblPuesto");
		var LvarTbody = LvarTable.tBodies[0];
		var LvarTR    = document.createElement("TR");
		var Lclass 	= document.form1.LastOnePuesto;
		var p1 		= document.form1.RHPcodigo.value;			// Código
		var p2 		= document.form1.RHPdescpuesto.value;		// Descripción
		document.form1.RHPcodigo.value = "";
		document.form1.RHPdescpuesto.value = "";
		// Valida no agregar vacíos
		if (p1=="") {
			return;
		}	  
		// Valida no agregar repetidos
		if (existeCodigoPuesto(p1)) {
			alert('El Puesto ya fue agregado.');
			return;
		}
		// Agrega Columna 0
		sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "PuestoidList");
		// Agrega Columna 1
		sbAgregaTdText  (LvarTR, Lclass.value, p1 + ' - ' + p2);
		// Agrega Evento de borrado en Columna 2
		sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "left");
		if (document.all) {
			GvarNewTD.attachEvent ("onclick", sbEliminarTR);
		}
		else {
			GvarNewTD.addEventListener ("click", sbEliminarTR, false);
		}

		// Nombra el TR
		LvarTR.name = "XXXXX";
		
		// Agrega el TR al Tbody
		LvarTbody.appendChild(LvarTR);
	  
		if (Lclass.value=="ListaNon") {
			Lclass.value="ListaPar";
		}
		else {
			Lclass.value="ListaNon";
		}
	}
	
	/***************************************************************************************************/
	// Funcion que valida que no exista el puesto en la Lista
	function existeCodigoPuesto(v) 
	{
		var LvarTable = document.getElementById("tblPuesto");
		
		for (var i=0; i<LvarTable.rows.length; i++)
		{
			var value = new String(fnTdValue(LvarTable.rows[i]));
			var data = value.split('|');
		
			if (data[0] == v) {
				return true;
			}
		}
		return false;
	}
	
	/***************************************************************************************************/
	function sbAgregaTdInput (LprmTR, LprmClass, LprmValue, LprmType, LprmName) 
	{
		var LvarTD    = document.createElement("TD");
		var LvarInp   = document.createElement("INPUT");
		
		LvarInp.type = LprmType;
		if (LprmName != "") {
			LvarInp.name = LprmName;
		}
		if (LprmValue != "") { 
			LvarInp.value = LprmValue;
		}

		LvarTD.appendChild(LvarInp);
		if (LprmClass!="") { 
			LvarTD.className = LprmClass;
		}
		GvarNewTD = LvarTD;
		LprmTR.appendChild(LvarTD);
	}

	// Función para agregar TDs con texto
	function sbAgregaTdText (LprmTR, LprmClass, LprmValue) 
	{
		var LvarTD    = document.createElement("TD");
		var LvarTxt   = document.createTextNode(LprmValue);
	  
		LvarTD.appendChild(LvarTxt);
		if (LprmClass!="") {
			LvarTD.className = LprmClass;
		}
		GvarNewTD = LvarTD;
		LvarTD.noWrap = true;
		LprmTR.appendChild(LvarTD);
	}

	// Función para agregar Imagenes
	function sbAgregaTdImage (LprmTR, LprmClass, LprmNombre, align) 
	{
		// Copia una imagen existente
		var LvarTDimg 	= document.createElement("TD");
		var LvarImg 	= document.getElementById(LprmNombre).cloneNode(true);
		LvarImg.style.display="";
		LvarImg.align=align;
		LvarTDimg.appendChild(LvarImg);
		if (LprmClass != "") {
			LvarTDimg.className = LprmClass;
		}
		GvarNewTD = LvarTDimg;
		LprmTR.appendChild(LvarTDimg);
	}

	//Función para eliminar TRs
	function sbEliminarTR(e) 
	{
		var LvarTR;

		if (document.all) {
			LvarTR = e.srcElement;
		}
		else {
			LvarTR = e.currentTarget;
		}
	
		while (LvarTR.name != "XXXXX") {
			LvarTR = LvarTR.parentNode;
		}
		LvarTR.parentNode.removeChild(LvarTR);
	}

	function fnTdValue(LprmNode) 
	{
		var LvarNode = LprmNode;

		while (LvarNode.hasChildNodes()) {
			LvarNode = LvarNode.firstChild;
			if (document.all == null) {
				if (!LvarNode.firstChild && LvarNode.nextSibling != null && LvarNode.nextSibling.hasChildNodes()) {
					LvarNode = LvarNode.nextSibling;
				}
			}
		}
		
		if (LvarNode.value) {
			return LvarNode.value;
		} 
		else {
			return LvarNode.nodeValue;
		}
	}
	</script>	
<cf_web_portlet_end>
<cf_templatefooter>	