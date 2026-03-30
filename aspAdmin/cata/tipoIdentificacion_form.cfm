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
		Select TIcodigo
			, TInombre
--			, timestamp
		from TipoIdentificacion
		where TIcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TIcodigo#">
	</cfquery>
</cfif>

<script language="JavaScript" src="../js/qForms/qforms.js">//</script>
<form action="tipoIdentificacion_SQL.cfm" method="post" name="formTipoIdentificacion">
<!--- 	<cfif modo neq 'ALTA'>
		<cfset ts = "">	
		<cfoutput>
			<cfinvoke component="aspAdmin.componentes.DButils" method="toTimeStamp" returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.timestamp#"/>
			</cfinvoke>
			<input type="hidden" name="timestamp" value="#ts#" size="32">					
		</cfoutput>
	</cfif> --->
	
	<table width="95%" border="0" cellpadding="2" cellspacing="0" align="center">
		<tr>
		  	<td class="tituloMantenimiento" colspan="3" align="center">
				<cfif modo eq "ALTA">
					Nuevo Tipo de Identificaci&oacute;n
					<cfelse>
					Modificar Tipo de Identificaci&oacute;n
				</cfif>
			</td>
		</tr>
		<tr> 
		  <td width="28%" align="right" valign="baseline"><strong>C&oacute;digo</strong>:&nbsp;</td>
		  <td width="72%" valign="baseline"><input name="TIcodigo" type="text" id="TIcodigo" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.TIcodigo#</cfoutput></cfif>" size="3" maxlength="3"></td>
		</tr>		
		<tr> 
		  <td align="right" valign="top"><strong>Descripci&oacute;n</strong>:&nbsp;</td>
		  <td valign="baseline"><input name="TInombre" type="text" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.TInombre#</cfoutput></cfif>" size="60" maxlength="60" onfocus="javascript:this.select();"></td>
		</tr>
		<tr> 
		  <td align="center">&nbsp;</td>
		  <td align="center">&nbsp;</td>
		</tr>
		<tr> 
		  <td align="center" colspan="2">
		  	<cfset mensajeDelete = "¿Desea Eliminar el Tipo de Identificaci&oacute;n?">
		  	<cfinclude template="../portlets/pBotones.cfm">
		  </td>
		</tr>
	  </table>
</form>	  

<script language="JavaScript">
//---------------------------------------------------------------------------------------		
	function deshabilitarValidacion() {
		objForm.TIcodigo.required = false;
		objForm.TInombre.required = false;		
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.TIcodigo.required = true;
		objForm.TInombre.required = true;		
	}	
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formTipoIdentificacion");
//---------------------------------------------------------------------------------------
	objForm.TIcodigo.required = true;
	objForm.TIcodigo.description = "Código";
	objForm.TInombre.required = true;
	objForm.TInombre.description = "Nombre";		
</script>