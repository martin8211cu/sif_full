<!--- Establecimiento del modoD --->
<cfif isdefined("form.LOEid") and form.LOEid NEQ '' and isdefined('form.LOTid') and form.LOTid NEQ ''>
	<cfset modoD="CAMBIO">
<cfelse>
	<cfset modoD="ALTA">
</cfif>

<!---       Consultas      --->
<cfif modoD NEQ 'ALTA'>
 	<cfquery name="rsFormD" datasource="#session.DSN#">
		Select convert(varchar,lt.LOEid) as LOEid
			, convert(varchar,LOTid) as LOTid
			, lt.Icodigo
			, LOTdescripcion	
		from LocaleTraduccion lt
			, LocaleEtiqueta le
			, Idioma i
		where lt.LOEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LOEid#">
			and lt.LOTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LOTid#">
			and lt.LOEid=le.LOEid
			and lt.Icodigo=i.Icodigo
	</cfquery>
</cfif>

<cfquery name="rsIdiomas" datasource="#session.DSN#">
	Select Icodigo
		, (Icodigo + ' -- ' + Descripcion) as Descripcion
	from Idioma
	where Iactivo = 1
		<cfif modoD NEQ 'ALTA'>
			and Icodigo not in(
					Select lt.Icodigo
					from LocaleTraduccion lt
						, LocaleEtiqueta le
						, Idioma i
					where lt.LOEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LOEid#">
						and lt.LOEid=le.LOEid
						and lt.Icodigo=i.Icodigo
						and lt.LOTid!=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LOTid#">
				)
		<cfelse>
			and Icodigo not in(
					Select lt.Icodigo
					from LocaleTraduccion lt
						, LocaleEtiqueta le
						, Idioma i
					where lt.LOEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LOEid#">
						and lt.LOEid=le.LOEid
						and lt.Icodigo=i.Icodigo
				)
		</cfif>
</cfquery>

<link href="/cfmx/sif/css/estilos.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript" src="../js/qForms/qforms.js">//</script>
<form action="etiquetas_SQL.cfm" method="post" name="formTraduciconEtiquetas" onSubmit="javascript: activarIdioma();">
	<cfoutput>
		<input name="LOEid" id="LOEid" type="hidden" value="#form.LOEid#">
		<table width="95%" border="0" cellpadding="2" cellspacing="0" align="center">
			<tr>
				<td class="tituloMantenimiento" colspan="3" align="center">
					<cfif modoD eq "ALTA">
						Nueva Traducci&oacute;n
						  <cfelse>
						<input name="LOTid" id="LOTid" type="hidden" value="#rsFormD.LOTid#">
						Modificar Traducci&oacute;n
					</cfif>
				</td>
			</tr>		
			<tr> 
			  <td align="right" valign="top"><strong>Idioma:</strong>&nbsp;</td>
			  <td valign="baseline"><select name="Icodigo" id="Icodigo" <cfif modoD NEQ 'ALTA' and trim(rsFormD.Icodigo) EQ 'es'> disabled</cfif>>
			  	<cfloop query="rsIdiomas">
					<option value="#rsIdiomas.Icodigo#" <cfif modoD NEQ 'ALTA' and rsIdiomas.Icodigo EQ rsFormD.Icodigo> selected</cfif>>#rsIdiomas.Descripcion#</option>
				</cfloop>
		      </select></td>
			</tr>				
			<tr> 
			  <td align="right" valign="top"><strong>Traducci&oacute;n:&nbsp;</strong></td>
			  <td align="left">
			  	<textarea name="LOTdescripcion" cols="40" rows="4" id="LOTdescripcion" onFocus="javascript:this.select();" ><cfif modoD NEQ 'ALTA'>#rsFormD.LOTdescripcion#</cfif></textarea>
			  </td>
			</tr>
			<tr> 
			  <td align="left">&nbsp;</td>
			  <td align="left">&nbsp;</td>
			</tr>			
			<tr> 
			  <td align="center" colspan="2">
				<cfset mensajeDeleteD = "¿Desea Eliminar la traducci&oacute;n ?">
			
				<input type="hidden" name="botonSel" value="">
				<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
				<cfif modoD EQ "ALTA">
					<input type="submit" name="AltaD" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacionD) habilitarValidacionD();">
					<input type="reset" name="Limpiar" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name">
				<cfelse>	
					<input name="CambioD" type="submit" onSelect="javascript: alert(select);" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacionD) habilitarValidacionD(); " value="Modificar">
					<cfif isdefined('rsFormD') and trim(rsFormD.Icodigo) NEQ 'es'>
						<input type="submit" name="BajaD" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('<cfoutput>#mensajeDeleteD#</cfoutput>') ){ if (window.deshabilitarValidacionD) deshabilitarValidacionD(); return true; }else{ return false;}">
					</cfif>
					<input type="submit" name="NuevoD" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacionD) deshabilitarValidacionD(); ">
				</cfif>
			  </td>
			</tr>
	  </table>
	</cfoutput>		  
</form>	  

<script language="JavaScript">
	// Funciones para Manejo de Botones
/*	botonActualD = "";
	
	function setBtn(obj) {
		botonActualD = obj.name;
	}
	function btnSelected(name, f) {
		if (f != null) {
			return (f["botonSel"].value == name)
		} else {
			return (botonActual == name)
		}
	}*/
//---------------------------------------------------------------------------------------		
	function activarIdioma(){
		<cfif modoD NEQ 'ALTA' and trim(rsFormD.Icodigo) EQ 'es'>
			document.formTraduciconEtiquetas.Icodigo.disabled = false;
		</cfif>
	}
	
	function deshabilitarValidacionD() {
		objFormD.Icodigo.required = false;		
		objFormD.LOTdescripcion.required = false;
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacionD() {
		objFormD.Icodigo.required = true;		
		objFormD.LOTdescripcion.required = true;		
	}	
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	objFormD = new qForm("formTraduciconEtiquetas");
//---------------------------------------------------------------------------------------
	objFormD.Icodigo.required = true;
	objFormD.Icodigo.description = "Idioma";
	objFormD.LOTdescripcion.required = true;
	objFormD.LOTdescripcion.description = "Traducción";	
</script>
