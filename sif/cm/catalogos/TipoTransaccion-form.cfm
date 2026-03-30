<cfset modo = "ALTA">

<cfif isdefined("form.CPcodigo") and len(trim(form.CPcodigo))>
	<cfset modo = "CAMBIO">
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
		select CPcodigo, CPdescripcion, ts_rversion
		from TTransaccionI
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.CPcodigo)#">
	</cfquery>
</cfif>

<script language="JavaScript1.2" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<cfoutput>
<form style="margin:0;" name="form1" action="TipoTransaccion-sql.cfm" method="post">
	<table align="center" width="100%" cellpadding="2" cellspacing="0" border="0" >
		<tr>
			<td nowrap align="right"><strong>C&oacute;digo:&nbsp;</strong></td>
			<td nowrap>
				<input type="text" name="CPcodigo" size="5" maxlength="2" value="<cfif modo neq 'ALTA'>#data.CPcodigo#</cfif>" onfocus="this.select();" <cfif modo neq 'ALTA'>readonly</cfif> >
			</td>
		</tr>
		
		<tr>
			<td nowrap align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
			<td nowrap>
				<input type="text" name="CPdescripcion" size="80" maxlength="80" value="<cfif modo neq 'ALTA'>#data.CPdescripcion#</cfif>" onfocus="this.select();">
			</td>
		</tr>

		<tr><td nowrap colspan="2">&nbsp;</td></tr>
		
		<!--- Portles de Botones --->
		<tr>
			<td nowrap colspan="2" align="center">
				<cfinclude template="../../portlets/pBotones.cfm">
			</td>
		</tr>

		<tr><td colspan="2">&nbsp;</td></tr>

		<cfif modo neq "ALTA">
      		<cfset ts = "">
      		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#data.ts_rversion#" returnvariable="ts">
      		</cfinvoke>
      		<input type="hidden" name="ts_rversion" value="#ts#">
    	</cfif>

	</table>
</form>
</cfoutput>

<script language="JavaScript1.2" type="text/javascript">	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	<cfif modo EQ 'ALTA'>
		objForm.CPcodigo.required = true;
		objForm.CPcodigo.description="Código";
	</cfif>

	objForm.CPdescripcion.required = true;
	objForm.CPdescripcion.description="Descripción";

	function deshabilitarValidacion(){
		objForm.CPcodigo.required = false;
		objForm.CPdescripcion.required = false;
	}

</script>
