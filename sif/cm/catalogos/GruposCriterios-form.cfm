<cfset modo = 'ALTA' >
<cfif isdefined("form.GCcritid") and len(trim(form.GCcritid)) >
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
		select GCcritid, GCcritdesc, ts_rversion
		from GruposCriteriosCM
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and GCcritid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GCcritid#">
	</cfquery>
</cfif>

<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<cfoutput>
<form style="margin:0;" name="form1" action="GruposCriterios-sql.cfm" method="post">
	<table width="100%" cellpadding="4" cellspacing="0" border="0" >
		<tr>
			<td align="right"><strong>Descripci&oacute;n:</strong>&nbsp;</td>
			<td><input type="text" name="GCcritdesc" size="60" maxlength="100" value="<cfif modo neq 'ALTA'>#data.GCcritdesc#</cfif>" onfocus="this.select();"></td>
		</tr>
		
		<tr>
			<td colspan="2" align="center">
				<cfinclude template="../../portlets/pBotones.cfm">
			</td>
		</tr>

		<cfif modo neq "ALTA">
			<input name="GCcritid" type="hidden" value="#data.GCcritid#" >

			<cfset ts = "">
			<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#data.ts_rversion#" returnvariable="ts"></cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#"> 
		</cfif> 
		<!---<input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">	--->
	</table>
</form>
</cfoutput>

<cfif modo neq "ALTA">
	<cfinclude template="DetGruposCriterios-form.cfm">
</cfif>

<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.GCcritdesc.required = true;
	objForm.GCcritdesc.description="Descripción";
	
	function deshabilitarValidacion(){
		objForm.GCcritdesc.required = false;
	}
</script>