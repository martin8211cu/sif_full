<!--- Establecimiento del modo --->
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif isdefined("Session.Ecodigo") AND isdefined("Form.GECDid") AND Len(Trim(Form.GECDid)) GT 0 >
	<cfquery name="rsCategoriaDestinos" datasource="#Session.DSN#">
		SELECT 
             GECDid          
            ,Ecodigo
            ,GECDcodigo
            ,GECDdescripcion 
            ,GECDmonto       
		FROM GEcategoriaDestino 
		WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
			and GECDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GECDid#">
	</cfquery>
</cfif>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<!---Redireccion SQLTiposTransaccion.cfm o TCESQLTiposTransaccion.cfm--->
<form method="post" name="form1" action="GEcategoriaDestino-sql.cfm">
	<table align="center" width="100%" cellpadding="1" cellspacing="0">
		<tr> 
			<td nowrap align="right">C&oacute;digo:</td>
			<td><input name="GECDcodigo" tabindex="1" type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#trim(rsCategoriaDestinos.GECDcodigo)#</cfoutput></cfif>" size="10" maxlength="10" onfocus="javascript:this.select();"></td>
		</tr>

		<tr> 
			<td nowrap align="right">Descripci&oacute;n:&nbsp:</td>
			<td><input type="text" tabindex="1" name="GECDdescripcion" value="<cfif modo NEQ "ALTA"><cfoutput>#trim(rsCategoriaDestinos.GECDdescripcion)#</cfoutput></cfif>" size="50" maxlength="50" onfocus="javascript:this.select();"></td>
		</tr>

		<tr> 
			<td nowrap align="right">Monto:</td>
			<td><input type="text" tabindex="1" name="GECDmonto" value="<cfif modo NEQ "ALTA"><cfoutput>#trim(rsCategoriaDestinos.GECDmonto)#</cfoutput></cfif>" size="10" maxlength="8" onfocus="javascript:this.select();"></td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr> 
			<td colspan="2" align="center" nowrap>
					<input type="hidden" name="GECDid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsCategoriaDestinos.GECDid#</cfoutput></cfif>">	  
					<cfset tabindex= 2 >
					<cfinclude template="../../portlets/pBotones.cfm">
			</td>
		</tr>
	</table>
</form>

<script language="JavaScript">
	function deshabilitarValidacion(){
		objForm.GECDcodigo.required = false;
		objForm.GECDdescripcion.required = false;
		objForm.GECDmonto.required = false;
	}

	qFormAPI.errorColor = "#FFFFFF";
	objForm = new qForm("form1");

	objForm.GECDcodigo.required = true;
	objForm.GECDcodigo.description="Código";
	
	objForm.GECDdescripcion.required = true;
	objForm.GECDdescripcion.description="Descripción";
	
	objForm.GECDmonto.required = true;
	objForm.GECDmonto.description="Monto";

</script>