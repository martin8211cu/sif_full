<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Proyectos para donaciones
</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="pMenu.cfm">
</cf_templatearea>
<cf_templatearea name="body">
	<cfset navBarItems = ArrayNew(1)>
	<cfset navBarLinks = ArrayNew(1)>
	<cfset navBarStatusText = ArrayNew(1)>
		
	<cfset ArrayAppend(navBarItems,'Donaciones')>
	<cfset ArrayAppend(navBarLinks,'/cfmx/hosting/iglesias/donacion.cfm')>
	<cfset ArrayAppend(navBarStatusText,'Menú de Donaciones')>
	<cfset Regresar = "/cfmx/hosting/iglesias/donacion.cfm">
	<cfinclude template="pNavegacion.cfm">

	<cfif isdefined("url.MEDproyecto") and len(trim(url.MEDproyecto)) gt 0>
		<cfset form.MEDproyecto  = url.MEDproyecto>
	</cfif>
	<cfif isdefined("form.MEDproyecto") and len(trim(form.MEDproyecto)) gt 0 >
		<cfset modo = "CAMBIO">
	<cfelse>
		<cfset modo = "ALTA">
	</cfif>
	<cfquery name="rsMonedas" datasource="#session.dsn#">
		select Mnombre +' ('+ Msimbolo + ')' as Mnombre, Miso4217 from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	</cfquery>
	<cfif ucase(modo) neq 'ALTA'>
<!---  MEM 10/12/03
		 <cfquery name="rsMEDProyecto" datasource="#session.dsn#">  
			select MEDproyecto, a.MEEid, b.MEEnombre, MEDnombre, MEDinicio, MEDfinal, MEDprioridad, MEDmoneda, MEDmeta
			from MEDProyecto a, MEEntidad b
			where MEDproyecto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEDproyecto#">
			and a.MEEid *= b.MEEid
		</cfquery>
--->
		<cfquery name="rsMEDProyecto" datasource="#session.dsn#">
			select MEDproyecto, MEDnombre, MEDinicio, MEDfinal, MEDprioridad, MEDmoneda, MEDmeta
			from MEDProyecto a
			where MEDproyecto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEDproyecto#">
		</cfquery>

	</cfif>
	<!---
		Reglas:
			-
			-
			-
			-
	--->
	<script language="javascript1.4" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
	<script language="javascript1.4" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
	<script language="JavaScript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	<!---
	
	//Muestra conlis de Entidades Beneficiadas
	function doConlisEntidad(ContName,METEid,MEEid) {
		var width = 600;
		var height = 400;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		var nuevo = window.open('conlis_beneficiados.cfm?form=form1&id=MEEid&desc=MEEnombre','ListaEntidades','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		nuevo.focus();
	}
	--->
	</script>
	<div  style="border-bottom:1px solid"><FONT face="arial, helvetica, verdana" size=2><cfif ucase(modo) neq 'ALTA'>Actualizaci&oacute;n de <cfelse>Nuevo </cfif> Proyecto</FONT></div>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td width="5%" rowspan="2" nowrap>&nbsp;</td>
	<td width="90%" nowrap>
	<cfoutput>
	<form name="form1" action="donacion_proyecto_apply.cfm" style="border-style:none " method="post" onSubmit="javascript:finalizar();">
	<cfif ucase(modo) neq 'ALTA'><input type="hidden" name="MEDproyecto" id="MEDproyecto" value="#rsMEDProyecto.MEDproyecto#"></cfif>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="5%" nowrap>&nbsp;</td>
		
		<td width="10" nowrap>&nbsp;</td>
		<td width="30" nowrap>&nbsp;</td>
		
		<td width="10%" nowrap>&nbsp;</td>
		
		<td width="10" nowrap>&nbsp;</td>
		<td width="30" nowrap>&nbsp;</td>
		
		<td width="5%" nowrap>&nbsp;</td>
	</tr>
	<tr>
		<td nowrap>&nbsp;</td>
		
		<td nowrap>Proyecto: </td>
		<td nowrap><input type="text" name="MEDnombre" id="MEDnombre" size="40" maxlength="60" <cfif ucase(modo) neq 'ALTA'>value="#rsMEDProyecto.MEDnombre#"</cfif> onfocus="this.select();"></td>
		
		<td nowrap>&nbsp;</td>
		
		<td nowrap>&nbsp;<!---Beneficiario (opcional): ---></td>
		<td nowrap>&nbsp;<!---
			<!--- <input readonly="true" type="text" name="MEEnombre" <cfif ucase(modo) neq "ALTA">value="#iif(len(trim(rsMEDProyecto.MEEnombre)) gt 0,rsMEDProyecto.MEEnombre,DE('Ninguna'))#"<cfelse>value="Ninguna"</cfif>> --->
			<input readonly="true" type="text" name="MEEnombre" <cfif ucase(modo) neq "ALTA">value="Ninguna"<cfelse>value="Ninguna"</cfif>>
			<input type="hidden" name="MEEid" <!--- <cfif ucase(modo) neq "ALTA">value="#rsMEDProyecto.MEEid#"</cfif>--->>
			<cfif ucase(modo) eq "ALTA">
			<a href="javascript:doConlisEntidad()">
			<img src="/cfmx/sif/imagenes/DATE_D.gif" alt="Seleccionar beneficiario" border="0" width="16" height="14" onClick="doConlisEntidad()"></a>
			</cfif>			
			--->
		</td>
					
		<td nowrap>&nbsp;</td>
		
	</tr>
	<tr>
		<td nowrap>&nbsp;</td>
		
		<td nowrap>Fecha de Inicio : </td>
		<td nowrap><cfif ucase(modo) neq 'ALTA'><cfset fecha = rsMEDProyecto.MEDinicio><cfelse><cfset fecha = Now()></cfif><cf_sifcalendario name="MEDinicio" value="#LSDateFormat(fecha,'dd/mm/yyyy')#" onfocus="this.select();"></td>
		
		<td nowrap>&nbsp;</td>
		
		<td nowrap>Fecha de Fin : </td>
		<td nowrap><cfif ucase(modo) neq 'ALTA'><cfset fecha = rsMEDProyecto.MEDfinal><cfelse><cfset fecha = ''></cfif><cf_sifcalendario name="MEDfinal" value="#LSDateFormat(fecha,'dd/mm/yyyy')#" onfocus="this.select();"></td>
		
		<td nowrap>&nbsp;</td>
	</tr>
	<tr>
		<td nowrap>&nbsp;</td>
		
		<td nowrap>Meta : </td>
		<td nowrap colspan="5"><input name="MEDmeta" id="MEDmeta" type="text" size="20" 
				maxlength="18" 
				<cfif ucase(modo) neq 'ALTA'>
					value="#LSCurrencyFormat(rsMEDProyecto.MEDmeta,'none')#" 
				<cfelse>
					value="#LSCurrencyFormat(0,'none')#" 
				</cfif>
				style="text-align: right"  
				onfocus="this.value=qf(this); this.select();" 
				onblur="javascript: fm(this,2);" 
				onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
<select name="MEDmoneda" id="MEDmoneda">
				<cfloop query="rsMonedas">
					<option value="#Miso4217#" <cfif ucase(modo) neq 'ALTA' and rsMEDProyecto.MEDmoneda eq Miso4217>selected</cfif>>#Mnombre#</option>
				</cfloop>
			  </select>
</td>
		
 
		
		<td nowrap>&nbsp;</td>
	</tr>
	<tr>
		<td nowrap>&nbsp;</td>
		
		<td nowrap>Prioridad : </td>
		<td nowrap><input name="MEDprioridad" id="MEDprioridad" type="text" size="5" 
									maxlength="3" 
									<cfif ucase(modo) neq 'ALTA'>
										value="#rsMEDProyecto.MEDprioridad#" 
									<cfelse>
										value="0"
									</cfif>
									style="text-align: right"  
									onKeyPress="return acceptNum(event)"  
									onfocus="this.select();"></td>
		
		<td nowrap>&nbsp;</td>
		
		<td nowrap>&nbsp;</td>
		<td nowrap>&nbsp;</td>
		
		<td nowrap>&nbsp;</td>
	</tr>
	<tr>
		<td nowrap>&nbsp;</td>
		
		<td nowrap>&nbsp;</td>
		<td nowrap>&nbsp;</td>
		
		<td nowrap>&nbsp;</td>
		
		<td nowrap>&nbsp;</td>
		<td nowrap>&nbsp;</td>
		
		<td nowrap>&nbsp;</td>
	</tr>
	<tr>
		<td nowrap>&nbsp;</td>
		
		<td colspan="5" align="center" nowrap><cfinclude template="/sif/portlets/pBotones.cfm"></td>
		
		<td nowrap>&nbsp;</td>
	</tr>
	<tr>
		<td nowrap>&nbsp;</td>
		
		<td nowrap>&nbsp;</td>
		<td nowrap>&nbsp;</td>
		
		<td nowrap>&nbsp;</td>
		
		<td nowrap>&nbsp;</td>
		<td nowrap>&nbsp;</td>
		
		<td nowrap>&nbsp;</td>
	</tr>
	</table>
	</form>
	</cfoutput>	</td>
	<td width="5%" rowspan="2" nowrap>&nbsp;</td>
	</tr>
	<tr>
	<td nowrap>	
	<cfinvoke 
		component="sif.Componentes.pListas"
		method="pLista"
		returnvariable="pLista">
		<cfinvokeargument name="tabla" value="MEDProyecto"/>
		<cfinvokeargument name="columnas" value="MEDprioridad, MEDproyecto, MEDnombre, MEDinicio, isnull(convert(varchar,MEDfinal,103),'Indefinido') as MEDfinal, MEDmeta"/>
		<cfinvokeargument name="filtro" value="Ecodigo = #session.ecodigo# and METSid = #session.METSid# and getdate() <= isnull(MEDfinal,'01/01/6100') order by MEDprioridad, MEDinicio"/>
		<cfinvokeargument name="desplegar" value="MEDprioridad, MEDnombre, MEDinicio, MEDfinal, MEDmeta"/>
		<cfinvokeargument name="etiquetas" value="Prioridad, Nombre, Fecha Inicio, Fecha Final, Meta"/>
		<cfinvokeargument name="formatos" value="I, S, D, S, M"/>
		<cfinvokeargument name="align" value="left, left, center, center, right"/>
		<cfinvokeargument name="ajustar" value="S"/>
		<cfinvokeargument name="irA" value="donacion_proyecto.cfm"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="keys" value="MEDproyecto"/>
	</cfinvoke>	</td>
	</tr>
</table>
	<script language="javascript1.4" type="text/javascript">
	//Validaciones del Encabezado Registro de Nomina
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	var min = 0; max = 0;
	//Funciones adicionales de validación
	function _Field_isAlfaNumerico()
	{
		var validchars=" áéíóúabcdefghijklmnñopqrstuvwxyz1234567890/*-+.:,;{}[]|°!$&()=?";
		var tmp="";
		var string = this.value;
		var lc=string.toLowerCase();
		for(var i=0;i<string.length;i++) {
			if(validchars.indexOf(lc.charAt(i))!=-1)tmp+=string.charAt(i);
		}
		if (tmp.length!=this.value.length)
		{
			this.error="El valor para "+this.description+" debe contener solamente caracteres alfanuméricos,\n y los siguientes simbolos: (/*-+.:,;{}[]|°!$&()=?).";
		}
	}
	function _Field_isFecha(){
		fechaBlur(this.obj);
		if (this.obj.value.length!=10)
			this.error = "El campo " + this.description + " debe contener una fecha válida.";
	}
	_addValidator("isAlfaNumerico", _Field_isAlfaNumerico);
	_addValidator("isFecha", _Field_isFecha);	
	//descripciones
	objForm.MEDnombre.description = "Nombre del proyecto";
	//objForm.MEEid.description = "Entidad beneficiada";
	objForm.MEDinicio.description = "Fecha de inicio";
	objForm.MEDfinal.description = "Fecha final";
	objForm.MEDmeta.description = "Meta";
	objForm.MEDmoneda.description = "Moneda";
	objForm.MEDprioridad.description = "Prioridad";
	//requeridos
	objForm.MEDnombre.required = true;
	objForm.MEDinicio.required = true;
	objForm.MEDmeta.required = true;
	objForm.MEDmoneda.required = true;
	objForm.MEDprioridad.required = true;
	//validaciones de tipos de dato
	objForm.MEDnombre.validateAlfaNumerico();
	objForm.MEDinicio.validateFecha();
	objForm.MEDfinal.validateFecha();
	//min = 1; max = 999999999; objForm.MEDmeta.validateRange(min,max,'El campo ' + objForm.MEDmeta.description + ' contiene un valor fuera del rango permitido ('+min+' - '+max+').');
	min = 1; max = 999; objForm.MEDprioridad.validateRange(min,max,'El campo ' + objForm.MEDprioridad.description + ' contiene un valor fuera del rango permitido ('+min+' - '+max+').');
	//Define Foco
	objForm.MEDnombre.focus();
	//Function Finalizar
	function finalizar(){
		objForm.MEDmeta.obj.value = qf(objForm.MEDmeta.obj);
		return true;
	}
	function deshabilitarValidacion(){
		objForm.MEDnombre.required = false;
		objForm.MEDinicio.required = false;
		objForm.MEDmeta.required = false;
		objForm.MEDmoneda.required = false;
		objForm.MEDprioridad.required = false;
	}
	</script>
</cf_templatearea>
</cf_template>
