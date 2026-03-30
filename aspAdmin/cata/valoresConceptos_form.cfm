<!--- Establecimiento del modoD --->
<cfif isdefined('form.LOCid') and len(trim(form.LOCid)) GT 0 and isdefined('form.LOVid') and len(trim(form.LOVid)) GT 0 and form.LOVid NEQ ''>
	<cfset modoD="CAMBIO">
<cfelse>
	<cfset modoD="ALTA">
</cfif>

<!---       Consultas      --->
<cfif modoD NEQ 'ALTA'>
	<cfquery name="rsFormD" datasource="#session.DSN#">
		Select convert(varchar,LOCid) as LOCid
			, convert(varchar,LOVid) as LOVid
			, Icodigo
			, convert(varchar, LOVsecuencia) as LOVsecuencia
			, LOVvalor
			, LOVdescripcion
		from LocaleValores
		where LOCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LOCid#">
			and LOVid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LOVid#">
	</cfquery>
</cfif>

<!--- <cfquery name="rsProxSecuencia" datasource="#Session.DSN#">
	Select (max(LOVsecuencia) + 1) as LOVsecuencia
	from LocaleValores
	where LOCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LOCid#">
		<cfif modoD NEQ 'CAMBIO'>
			and Icodigo='es'
		<cfelseif isdefined('form.Icodigo') and form.Icodigo NEQ ''>
			and Icodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">
		</cfif>
</cfquery> --->

<cfquery name="qryIdiomas" datasource="#Session.DSN#">
	Select Icodigo
		, Descripcion
	from Idioma
	where Iactivo = 1
<!--- 		and Icodigo not in(
			Select Icodigo
			from LocaleValores
			where LOCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LOCid#">
				and LOVsecuencia != 0
		) --->
</cfquery>

<cfdump var="#form#">

<script language="JavaScript" type="text/javascript" src="../js/qForms/qforms.js">//</script>
<script language="JavaScript" type="text/javascript" src="../js/utilesMonto.js">//</script>
<form action="conceptos_SQL.cfm" method="post" name="formValores" onSubmit="javascript: habIdioma();">
  <cfoutput>
	<input name="LOCid" id="LOCid" type="hidden" value="#form.LOCid#">
	<table width="95%" border="0" cellpadding="2" cellspacing="0" align="center">
		<tr> 
		  <td class="tituloMantenimiento" colspan="3" align="center"> <cfif modoD eq "ALTA">
			  Nuevo Valor
				  <cfelse>
			  Modificar Valor
			  <input name="LOVid" id="LOVid" type="hidden" value="#rsFormD.LOVid#">
		  </cfif> </td>
		</tr>
		<tr> 
		  <td align="right" valign="top"><strong>Idioma</strong>:&nbsp;</td>
		  <td valign="baseline">
			<select name="Icodigo" id="Icodigo" <cfif modoD NEQ "ALTA"> disabled</cfif>>
				<cfloop query="qryIdiomas">
					<option value="#qryIdiomas.Icodigo#" <cfif modoD NEQ 'ALTA' and qryIdiomas.Icodigo EQ rsFormD.Icodigo> selected<cfelseif modoD NEQ 'CAMBIO' and isdefined('form.Icodigo') and form.Icodigo NEQ '' and qryIdiomas.Icodigo EQ form.Icodigo> selected<cfelseif qryIdiomas.Icodigo EQ 'es'> selected</cfif>>#qryIdiomas.Descripcion#</option>
				</cfloop>
			</select>
		  </td>
		</tr>
		<tr> 
		  <td align="right" valign="top"><strong>Secuencia</strong>:&nbsp;</td>
		  <td valign="baseline">
			<input name="LOVsecuencia" tabindex="11" style="text-align: right;" type="text" id="LOVsecuencia" size="10" maxlength="8" value="<cfif modoD NEQ "ALTA">#rsFormD.LOVsecuencia#</cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,-1);"  onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}">
<!--- 			<input name="LOVsecuencia" type="text" id="LOVsecuencia" class="cajasinbordeb" readonly="true" value="<cfif modoD NEQ 'ALTA'>#rsFormD.LOVsecuencia#</cfif>" size="40" maxlength="40">		 --->
		  </td>
		</tr>
		<tr> 
		  <td align="right" valign="top"><strong>Valor</strong>:&nbsp;</td>
		  <td valign="baseline">
			<input name="LOVvalor" type="text" id="LOVvalor" onfocus="javascript:this.select();" value="<cfif modoD neq 'ALTA'>#rsFormD.LOVvalor#</cfif>" size="10" maxlength="10">
		  </td>
		</tr>
		<tr> 
		  <td align="right" valign="top"><strong>Descripci&oacute;n</strong>:&nbsp;</td>
		  <td valign="baseline">
			<input name="LOVdescripcion" type="text" id="LOVdescripcion" onfocus="javascript:this.select();" value="<cfif modoD neq 'ALTA'>#rsFormD.LOVdescripcion#</cfif>" size="40" maxlength="40">
		  </td>
		</tr>		
		<tr> 
		  <td align="center">&nbsp;</td>
		  <td align="center">&nbsp;</td>
		</tr>
		<tr> 
		  <td align="center" colspan="2"> 
		  	<cfset mensajeDelete = "¿Desea Eliminar el Idioma ?"> 

			<input type="hidden" name="botonSel" value="">
			<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
			<cfif modoD EQ "ALTA">
				<input type="submit" name="AltaD" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacionD) habilitarValidacionD();">
				<input type="reset" name="LimpiarD" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name">
			<cfelse>	
				<input type="submit" name="CambioD" onSelect="javascript: alert(select);" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacionD) habilitarValidacionD(); " value="Modificar">
				<input type="submit" name="BajaD" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('<cfoutput>#mensajeDelete#</cfoutput>') ){ if (window.deshabilitarValidacionD) deshabilitarValidacionD(); return true; }else{ return false;}">
				<input type="submit" name="NuevoD" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacionD) deshabilitarValidacionD(); ">
			</cfif>

		  </td>
		</tr>
	  </table>
	</cfoutput>
</form>	  

<script language="JavaScript">
	// Funciones para Manejo de Botones
	botonActual = "";
	
	function setBtn(obj) {
		botonActual = obj.name;
	}
	function btnSelected(name, f) {
		if (f != null) {
			return (f["botonSel"].value == name)
		} else {
			return (botonActual == name)
		}
	}
//---------------------------------------------------------------------------------------
	function habIdioma() {
		<cfif modoD NEQ "ALTA">
			document.formValores.Icodigo.disabled = false;
		</cfif>
	}
//---------------------------------------------------------------------------------------
	function deshabilitarValidacionD() {
		objFormD.Icodigo.required = false;
		objFormD.LOVsecuencia.required = false;	
		objFormD.LOVvalor.required = false;
		objFormD.LOVdescripcion.required = false;		
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacionD() {
		objFormD.Icodigo.required = true;	
		objFormD.LOVsecuencia.required = true;	
		objFormD.LOVvalor.required = true;		
		objFormD.LOVdescripcion.required = true;		
	}	
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	objFormD = new qForm("formValores");
//---------------------------------------------------------------------------------------
	objFormD.Icodigo.required = true;
	objFormD.Icodigo.description = "Idioma";		
	objFormD.LOVsecuencia.required = true;
	objFormD.LOVsecuencia.description = "Secuencia";	
	objFormD.LOVvalor.required = true;
	objFormD.LOVvalor.description = "Valor";
	objFormD.LOVdescripcion.required = true;
	objFormD.LOVdescripcion.description = "Descripción";		
</script>
