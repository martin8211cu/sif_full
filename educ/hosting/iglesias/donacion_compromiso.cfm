<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Compromisos para donaciones
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

	<cfif isdefined("url.MEDcompromiso") and len(trim(url.MEDcompromiso)) gt 0>
		<cfset form.MEDcompromiso = url.MEDcompromiso>
	</cfif>
	<cfif isdefined("form.MEDcompromiso") and len(trim(form.MEDcompromiso)) gt 0 >
		<cfset modo = "CAMBIO">
	<cfelse>
		<cfset modo = "ALTA">
	</cfif>
	<cfquery name="rsMonedas" datasource="#session.dsn#">
		select Mnombre +' ('+ Msimbolo + ')' as Mnombre, Miso4217 from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	</cfquery>
	<cfquery name="rsProyectos" datasource="#session.DSN#">
		select MEDproyecto, MEDnombre
		from MEDProyecto
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and getdate() between MEDinicio and MEDfinal
	</cfquery>
	<cfquery name="rsCompromisos" datasource="#session.dsn#" maxrows="10">
		select a.MEDcompromiso, b.MEEnombre, c.MEDnombre, a.MEDimporte, a.MEDmoneda, a.MEDultima, a.MEDsiguiente
		from MEDCompromiso a, MEEntidad b, MEDProyecto c
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and b.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			and MEDactivo = 1
			and getdate() between MEDinicio and MEDfinal
			and a.MEEid = b.MEEid
			and a.MEDproyecto = c.MEDproyecto
		order by MEDcompromiso desc
	</cfquery>
	<cfif ucase(modo) neq 'ALTA'>
		<cfquery name="rsMEDCompromiso" datasource="#session.dsn#">
			select a.MEDcompromiso, a.MEEid, a.MEDproyecto, a.MEDtipo_periodo, a.MEDperiodo, a.MEDimporte, a.MEDmoneda, a.MEDultima, a.MEDsiguiente, a.MEDfechaini, a.MEDfechafin, a.MEDactivo, b.MEEnombre
			from MEDCompromiso a, MEEntidad b
			where MEDcompromiso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEDcompromiso#">
			and a.MEEid = b.MEEid
		</cfquery>
		<cfquery name="rsMEDDonaciones" datasource="#session.dsn#">
			select 1 from MEDDonacion
			where MEDcompromiso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEDcompromiso#">
		</cfquery>
	</cfif>
	<!---
		Reglas:
			- En modo cambio chquear si existen Donaciones y no poner botones ni permitir modificaciones solamente se permite cesar.
	--->
	<script language="javascript1.4" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
	<script language="javascript1.4" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
	<script language="JavaScript" type="text/javascript">
	<!--
	
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	function doConlisEntidad(ContName,METEid,MEEid) {
		var width = 600;
		var height = 400;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		var nuevo = window.open('conlis_donadores.cfm?form=form1&id=MEEid&desc=MEEnombre','ListaEntidades','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		nuevo.focus();
	}
	
	function Procesar(p1) {
		document.fLista.MEDcompromiso.value = p1;
		document.fLista.submit();
	}
	-->
	</script>
	<div  style="border-bottom:1px solid"><FONT face="arial, helvetica, verdana" size=2><cfif ucase(modo) neq 'ALTA'><cfif rsMEDDonaciones.RecordCount gt 0>Cese <cfelse>Actualizaci&oacute;n</cfif> de <cfelse>Nuevo </cfif> Compromiso</FONT></div>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td>
	<cfoutput>
	<form name="fLista" action="donacion_compromiso.cfm" style="border-style:none " method="post">
		<input type="hidden" name="MEDcompromiso" id="MEDcompromiso" value="">
	</form>
	<form name="form1" action="donacion_compromiso_apply.cfm" style="border-style:none " method="post" onSubmit="javascript:finalizar();">
	<cfif ucase(modo) neq 'ALTA'><input type="hidden" name="MEDcompromiso" id="MEDcompromiso" value="#rsMEDCompromiso.MEDcompromiso#"></cfif>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>&nbsp;</td>
		
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		
		<td>&nbsp;</td>
		
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		
		<td>Donante : </td>
	    <td><input readonly="true" type="text" name="MEEnombre" onFocus="this.select()" <cfif ucase(modo) neq 'ALTA'>value="#rsMEDCompromiso.MEEnombre#"</cfif>>
		<input type="hidden" name="MEEid" <cfif ucase(modo) neq 'ALTA'>value="#rsMEDCompromiso.MEEid#"</cfif>>
		<a href="javascript:doConlisEntidad()">
		<img src="/cfmx/sif/imagenes/DATE_D.gif" alt="Seleccionar donante" border="0" width="16" height="14" onClick="doConlisEntidad()"></a></td>
		
		<td>&nbsp;</td>
		
		<td>Proyecto : </td>
		<td><select name="MEDproyecto">
				<cfloop query="rsProyectos">
					<option value="#rsProyectos.MEDproyecto#" <cfif ucase(modo) neq 'ALTA' and rsMEDCompromiso.MEDproyecto eq rsProyectos.MEDproyecto >selected</cfif>>#rsProyectos.MEDnombre#</option> 
				</cfloop>
		</select> </td>
		
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		
		<td>Tipo de periodo : </td>
		<td><select name="MEDtipo_periodo">
			<option value="d" <cfif ucase(modo) neq 'ALTA' and rsMEDCompromiso.MEDtipo_periodo eq 'd'>selected</cfif>>Día</option>
			<option value="w" <cfif ucase(modo) neq 'ALTA' and rsMEDCompromiso.MEDtipo_periodo eq 'w'>selected</cfif>>Semana</option>
			<option value="m" <cfif ucase(modo) neq 'ALTA' and rsMEDCompromiso.MEDtipo_periodo eq 'm'>selected</cfif>>Mes</option>
			<option value="y" <cfif ucase(modo) neq 'ALTA' and rsMEDCompromiso.MEDtipo_periodo eq 'y'>selected</cfif>>Año</option>
		</select></td>
		
		<td>&nbsp;</td>
		
		<td>Periodicidad : </td>
		<td><input name="MEDperiodo" id="MEDperiodo" type="text" size="5" 
									maxlength="3" 
									<cfif ucase(modo) neq 'ALTA'>
										value="#rsMEDCompromiso.MEDperiodo#" 
									<cfelse>
										value="0"
									</cfif>
									style="text-align: right"  
									onKeyPress="return acceptNum(event)"  
									onfocus="this.select();"></td>
		
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		
		<td>Importe : </td>
		<td><input name="MEDimporte" id="MEDimporte" type="text" size="20" 
				maxlength="18" 
				<cfif ucase(modo) neq 'ALTA'>
					value="#LSCurrencyFormat(rsMEDCompromiso.MEDimporte,'none')#" 
				<cfelse>
					value="#LSCurrencyFormat(0,'none')#" 
				</cfif>
				style="text-align: right"  
				onfocus="this.value=qf(this); this.select();" 
				onblur="javascript: fm(this,2);" 
				onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"></td>
		
		<td>&nbsp;</td>
		
		<td>Moneda : </td>
		<td><select name="MEDmoneda" id="MEDmoneda">
				<cfloop query="rsMonedas">
					<option value="#Miso4217#" <cfif ucase(modo) neq 'ALTA' and rsMEDCompromiso.MEDmoneda eq Miso4217>selected</cfif>>#Mnombre#</option>
				</cfloop>
				</select></td>
		
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		
		<td>Apartir de : </td>
		<td><cfif ucase(modo) neq 'ALTA'><cfset fecha = rsMEDCompromiso.MEDsiguiente><cfelse><cfset fecha = Now()></cfif><cf_sifcalendario name="MEDsiguiente" value="#LSDateFormat(fecha,'dd/mm/yyyy')#" onfocus="this.select();"></td>
		
		<td>&nbsp;</td>
		
		<td>Hasta : </td>
		<td><cfif ucase(modo) neq 'ALTA'><cfset fecha = rsMEDCompromiso.MEDfechafin><cfelse><cfset fecha = ''></cfif><cf_sifcalendario name="MEDfechafin" value="#LSDateFormat(fecha,'dd/mm/yyyy')#" onfocus="this.select();"></td>
		
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		
		<td>&nbsp;</td>
		
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		
		<td colspan="5"><div align="center">
			<cfinclude template="/sif/portlets/pBotones.cfm">
			<cfif ucase(modo) neq 'ALTA' and rsMEDDonaciones.RecordCount gt 0>
				<input type="submit" name="Cese" value="Cesar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Desea Cesar el Compromiso?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
			</cfif>
        </div></td>
		
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		
		<td>&nbsp;</td>
		
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		
		<td>&nbsp;</td>
	</tr>
	</table>
	</form>
	</cfoutput>
	</td>
	</tr>
	<tr>
	<td>	
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td colspan="6"><strong>&Uacute;ltimos 10 Compromisos</strong></td>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td><strong>Donador</strong></td>
			<td><strong>Proyecto</strong></td>
			<td><strong>Importe</strong></td>
			<td><strong>Moneda</strong></td>
			<td><strong>F. &Uacute;ltima Donaci&oacute;n</strong></td>
			<td><strong>F. Siguiente Donaci&oacute;n</strong></td>
			<td>&nbsp;</td>
		  </tr>
		  <cfif rsCompromisos.Recordcount gt 0>
		  <cfoutput query="rsCompromisos">
		  <tr class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
			<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="left" width="18" height="18" nowrap>
				<cfif ucase(modo) neq 'ALTA' and rsCompromisos.MEDcompromiso eq form.MEDcompromiso>
					<img src="/cfmx/sif/imagenes/addressGo.gif" width="18" height="18">
				</cfif>
			</td>
			<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>align="left" nowrap onclick="javascript: Procesar(#MEDcompromiso#);"><a href="javascript:Procesar(#MEDcompromiso#);" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">#rsCompromisos.MEEnombre#</a></td>
			<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>align="left" nowrap onclick="javascript: Procesar(#MEDcompromiso#);"><a href="javascript:Procesar(#MEDcompromiso#);" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">#rsCompromisos.MEDnombre#</a></td>
			<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>align="right" nowrap onclick="javascript: Procesar(#MEDcompromiso#);"><a href="javascript:Procesar(#MEDcompromiso#);" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">#LSCurrencyFormat(rsCompromisos.MEDimporte,'none')#</a></td>
			<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>align="left" nowrap onclick="javascript: Procesar(#MEDcompromiso#);"><a href="javascript:Procesar(#MEDcompromiso#);" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">#rsCompromisos.MEDmoneda#</a></td>
			<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>align="center" nowrap onclick="javascript: Procesar(#MEDcompromiso#);"><a href="javascript:Procesar(#MEDcompromiso#);" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1"><cfif len(trim(rsCompromisos.MEDultima)) gt 0>#LSDateFormat(rsCompromisos.MEDultima,'dd/mm/yyyy')#<cfelse>Ninguna</cfif></a></td>
			<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>align="center" nowrap onclick="javascript: Procesar(#MEDcompromiso#);"><a href="javascript:Procesar(#MEDcompromiso#);" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">#LSDateFormat(rsCompromisos.MEDsiguiente,'dd/mm/yyy')#</a></td>
			<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="left" width="1%">&nbsp;</td>
		  </tr>
		  </cfoutput>
		  <cfelse>
		  <tr>
			<td>&nbsp;</td>
			<td colspan="6"><strong>No hay registros</strong></td>
			<td>&nbsp;</td>
		  </tr>
		  </cfif>
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>
		</table>


	</td>
	</tr>
	</table>
	<script language="javascript1.4" type="text/javascript">
	//Validaciones del Encabezado Registro de Nomina
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	var min = 0; max = 0;
	//Funciones adicionales de validación
	function _Field_isFecha(){
		fechaBlur(this.obj);
		if (this.obj.value.length!=10)
			this.error = "El campo " + this.description + " debe contener una fecha válida.";
	}
	_addValidator("isFecha", _Field_isFecha);	
	//descripciones
	objForm.MEEid.description = "Donante";
	objForm.MEDproyecto.description = "Proyecto";
	objForm.MEDtipo_periodo.description = "Tipo de periodo";
	objForm.MEDperiodo.description = "Periodicidad";
	objForm.MEDimporte.description = "Importe";
	objForm.MEDmoneda.description = "Moneda";
	objForm.MEDsiguiente.description = "Fecha de primer donación";
	//requeridos
	<!---
	<cfif modo neq 'ALTA' and rsMEDDonaciones.RecordCount gt 0>
	objForm.MEEid.obj.disabled = true;
	objForm.MEEnombre.obj.disabled = true;
	objForm.MEDproyecto.obj.disabled = true;
	objForm.MEDtipo_periodo.obj.disabled = true;
	objForm.MEDperiodo.obj.disabled = true;
	objForm.MEDimporte.obj.disabled = true;
	objForm.MEDmoneda.obj.disabled = true;
	objForm.MEDsiguiente.obj.disabled = true;
	objForm.MEDfechafin.obj.disabled = true;
	<cfelse>
	--->
	objForm.MEEid.required = true;
	objForm.MEDproyecto.required = true;
	objForm.MEDtipo_periodo.required = true;
	objForm.MEDperiodo.required = true;
	objForm.MEDimporte.required = true;
	objForm.MEDmoneda.required = true;
	objForm.MEDsiguiente.required = true;
	//validaciones de tipos de dato
	min = 1; max = 999; objForm.MEDperiodo.validateRange(min,max,'El campo ' + objForm.MEDperiodo.description + ' contiene un valor fuera del rango permitido ('+min+' - '+max+').');
	min = 1; max = 999999999; objForm.MEDimporte.validateRange(min,max,'El campo ' + objForm.MEDimporte.description + ' contiene un valor fuera del rango permitido ('+min+' - '+max+').');
	objForm.MEDsiguiente.validateFecha();
	//Define Foco
	objForm.MEEnombre.focus();
	<!---
	</cfif>
	--->
	//Function Finalizar
	function finalizar(){
		objForm.MEDimporte.obj.value = qf(objForm.MEDimporte.obj);
		return true;
	}
	function deshabilitarValidacion(){
		objForm.MEEid.required = false;
		objForm.MEDproyecto.required = false;
		objForm.MEDtipo_periodo.required = false;
		objForm.MEDperiodo.required = false;
		objForm.MEDimporte.required = false;
		objForm.MEDmoneda.required = false;
		objForm.MEDsiguiente.required = false;
	}
	</script>
</cf_templatearea>
</cf_template>
