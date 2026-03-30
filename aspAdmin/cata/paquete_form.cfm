<!--- Establecimiento del modo --->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif #form.modo# EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!---       Consultas      --->
<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		select convert(varchar,PAcodigo) as PAcodigo
			, PAdescripcion
			, PAcod
			, PAtexto
		from Paquete
		where PAcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PAcodigo#">
	</cfquery>
</cfif>

<script language="JavaScript" src="../js/qForms/qforms.js">//</script>
<form action="paquete_SQL.cfm" method="post" name="formPaquetes">
	<cfif modo NEQ 'ALTA'>
		<input name="PAcodigo" type="hidden" value="<cfoutput>#form.PAcodigo#</cfoutput>">
	</cfif>
	<table width="95%" border="0" cellpadding="2" cellspacing="0" align="center">
		<tr>
		  	<td class="tituloMantenimiento" colspan="3" align="center">
				<cfif modo eq "ALTA">
					Nuevo Paquete
					<cfelse>
					Modificar Paquete
				</cfif>
			</td>
		</tr>
		<tr> 
		  
      <td align="right" valign="top"><strong>Codigo</strong>:&nbsp;</td>
		  <td valign="baseline"><input name="PAcod" type="text" id="PAcod" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.PAcod#</cfoutput></cfif>" size="15" maxlength="15"></td>
		</tr>
		<tr> 
		  <td align="right" valign="top"><strong>Nombre</strong>:&nbsp;</td>
		  <td valign="baseline"><input name="PAdescripcion" type="text" id="PAdescripcion" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.PAdescripcion#</cfoutput></cfif>" size="60" maxlength="60"></td>
		</tr>
		<tr> 
		  
      <td align="right" valign="top"><strong>Explicaci&oacute;n</strong>:&nbsp;</td>
		  <td valign="baseline"> 
			<textarea name="PAtexto" cols="60" rows="6" id="textarea4" style="font-size: xx-small;font-family: Verdana, Arial, Helvetica, sans-serif;"><cfif modo neq 'ALTA'><cfoutput>#rsForm.PAtexto#</cfoutput></cfif></textarea>
		  </td>
		</tr>
		<tr> 
		  <td align="center">&nbsp;</td>
		  <td align="center">&nbsp;</td>
		</tr>
		<tr> 
		  <td align="center" colspan="2">
		  	<cfset mensajeDelete = "¿Desea Eliminar el paquete ?">
		  	<cfinclude template="../portlets/pBotones.cfm">
			<input type="submit" value="Ir a lista" name="btnLista"
			 		 onClick="javascript:document.formPaquetes.action='paquete.cfm'; <cfif modo NEQ 'ALTA'>document.formPaquetes.PAcodigo.value = '';</cfif>deshabilitarValidacion();">
			<cfif modo NEQ 'ALTA'>
        </cfif>
		  </td>
		</tr>
	  </table>
</form>	  


<script language="JavaScript">
	function ligaTarifas(){
		<cfif modo NEQ 'ALTA'>
			location.href="/cfmx/aspAdmin/cata/paqueteTarifas.cfm?PAcodigo=" + <cfoutput>#form.PAcodigo#</cfoutput>
		</cfif>
	}
//---------------------------------------------------------------------------------------		
	function deshabilitarValidacion() {
		objForm.PAdescripcion.required = false;		
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.PAdescripcion.required = true;		
	}	
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formPaquetes");
//---------------------------------------------------------------------------------------
	objForm.PAdescripcion.required = true;
	objForm.PAdescripcion.description = "Nombre";		
</script>