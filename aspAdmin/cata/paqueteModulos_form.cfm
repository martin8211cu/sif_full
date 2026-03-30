<!--- Establecimiento del modoD --->
<cfif isdefined("form.PAcodigo") and form.PAcodigo NEQ '' and isdefined('form.modulo') and form.modulo NEQ ''>
	<cfset modoD="CAMBIO">
<cfelse>
	<cfset modoD="ALTA">
</cfif>

<!---       Consultas      --->
<cfif modoD NEQ 'ALTA'>
	<cfquery name="rsFormD" datasource="#session.DSN#">
		select convert(varchar, pm.PAcodigo) as PAcodigo
			, pm.modulo
			, nombre
		from PaqueteModulo pm
			, Paquete p
			, Modulo m
		where pm.PAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PAcodigo#">
			and activo = 1
			and pm.PAcodigo=p.PAcodigo
			and pm.modulo=m.modulo
		order by orden	
	</cfquery>
</cfif>

<cfquery name="rsModulos" datasource="#session.DSN#">
	Select  modulo
		, nombre
	from Modulo
	where activo = 1
		<cfif modoD NEQ 'CAMBIO'>
			and modulo not in (
				select pm.modulo
				from PaqueteModulo pm
					, Paquete p
					, Modulo m
				where pm.PAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PAcodigo#">
					and pm.PAcodigo=p.PAcodigo
					and pm.modulo=m.modulo
				)
		</cfif>
	order by orden
</cfquery>

<script language="JavaScript" type="text/javascript" src="../js/qForms/qforms.js">//</script>
<form action="paquete_SQL.cfm" method="post" name="formModulosXPaquete" onSubmit="javascript: habilModulo();">
	<cfoutput>
		  <input type="hidden" name="PAcodigo" value="#form.PAcodigo#">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td colspan="3" align="center" class="tituloMantenimiento">
				<cfif modoD eq "ALTA">
					Nuevo M&oacute;dulo
				<cfelse>
					Modificar M&oacute;dulo
				</cfif>			
			</td>
		  </tr>		
		  <tr>
			<td width="3%">&nbsp;</td>
			<td width="19%">&nbsp;</td>
			<td width="11%" rowspan="4" align="center" valign="middle">
				<cfif not isdefined('modoD')>
					<cfset modoD = "ALTA">
			  </cfif>
				
				<input type="hidden" name="botonSel" value="">
				<cfif modoD EQ "ALTA">
					<input type="submit" name="AltaD" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name">
				<cfelse>	
					<input type="submit" name="BajaD" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Desea Eliminar el Registro?') ){ if (window.deshabilitarValidacionD) deshabilitarValidacionD(); return true; }else{ return false;}">
					<input type="submit" name="NuevoD" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacionD) deshabilitarValidacionD(); ">
				</cfif>		
			</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td><strong>M&oacute;dulo</strong></td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td>
				<select name="modulo" id="modulo" <cfif modoD NEQ 'ALTA'> disabled</cfif>>
					<cfloop query="rsModulos">
						  <option value="#rsModulos.modulo#" <cfif modoD NEQ 'ALTA' and rsFormD.modulo EQ rsModulos.modulo> selected</cfif>>#rsModulos.nombre#</option>					
					</cfloop>
				</select>
			</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>		  
		</table>
  </cfoutput>		
</form>

<script language="JavaScript">
//---------------------------------------------------------------------------------------			
	function habilModulo(){
		document.formModulosXPaquete.modulo.disabled = false;
	}
//---------------------------------------------------------------------------------------				
	function deshabilitarValidacionD() {
		objFormDet.modulo.required = false;
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacionD() {
		objFormDet.modulo.required = true;		
	}	
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	objFormDet = new qForm("formModulosXPaquete");
//---------------------------------------------------------------------------------------
	objFormDet.modulo.required = true;
	objFormDet.modulo.description = "Módulo";		
</script>