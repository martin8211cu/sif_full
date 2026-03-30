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
		Select convert(varchar,TFcodigo) as TFcodigo
			, TFdescripcion
--			, timestamp
		from TipoFuncionario
		where TFcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TFcodigo#">
	</cfquery>
</cfif>

<script language="JavaScript" src="../js/qForms/qforms.js">//</script>
<form action="tipoFuncionario_SQL.cfm" method="post" name="formTipoFuncionario">
	<cfif modo neq 'ALTA'>
		<cfoutput>
			<input type="hidden" name="TFcodigo" value="#rsForm.TFcodigo#">
<!--- 		<cfset ts = "">	
		
			<cfinvoke component="aspAdmin.componentes.DButils" method="toTimeStamp" returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.timestamp#"/>
			</cfinvoke>
			<input type="hidden" name="timestamp" value="#ts#" size="32">--->					
		</cfoutput> 
	</cfif>
	
	<table width="95%" border="0" cellpadding="2" cellspacing="0" align="center">
		<tr>
		  	<td class="tituloMantenimiento" colspan="3" align="center">
				<cfif modo eq "ALTA">
					Nuevo Tipo de Funcionario
					<cfelse>
					Modificar Tipo de Funcionario
				</cfif>
			</td>
		</tr>		
		<tr> 
		  <td align="right" valign="top"><strong>Descripci&oacute;n</strong>:&nbsp;</td>
		  <td valign="baseline"><input name="TFdescripcion" type="text" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.TFdescripcion#</cfoutput></cfif>" size="60" maxlength="60" onfocus="javascript:this.select();"></td>
		</tr>
		<tr> 
		  <td align="center">&nbsp;</td>
		  <td align="center">&nbsp;</td>
		</tr>
		<tr> 
		  <td align="center" colspan="2">
		  	<cfset mensajeDelete = "¿Desea Eliminar el Tipo de Funcionario?">
		  	<cfinclude template="../portlets/pBotones.cfm">
		  </td>
		</tr>
	  </table>
</form>	  

<script language="JavaScript">
//---------------------------------------------------------------------------------------		
	function deshabilitarValidacion() {
		objForm.TFdescripcion.required = false;		
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.TFdescripcion.required = true;		
	}	
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formTipoFuncionario");
//---------------------------------------------------------------------------------------
	objForm.TFdescripcion.required = true;
	objForm.TFdescripcion.description = "Nombre";		
</script>