

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

<cfif isDefined("session.Ecodigo") and isDefined("Form.RHGcodigo") and len(trim(#Form.RHGcodigo#)) NEQ 0>
	<cf_translatedata name="get" tabla="RHGruposAreasEval" col="RHGdescripcion" returnvariable="LvarRHGdescripcion">
	<cfquery name="rsGruposAreasEval" datasource="#Session.DSN#" >
		Select RHGcodigo, substring(#LvarRHGdescripcion#,1,55) as RHGdescripcion, Usucodigo, ts_rversion
        from RHGruposAreasEval
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHGcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHGcodigo#" >		  
		order by #LvarRHGdescripcion# asc
	</cfquery>
</cfif>

<SCRIPT SRC="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//qFormAPI.include("validation");
	//qFormAPI.include("functions", null, "12");
	//-->
</SCRIPT>

<form action="GruposAreasEval-SQL.cfm" method="post" name="form" >
	<cfoutput>
	<table width="67%" height="75%" align="center" cellpadding="0" cellspacing="0">
		<tr><td colspan="5">&nbsp;</td></tr>
		<tr>
			<td width="13%" align="right" nowrap>&nbsp;</td> 
			<td width="16%" align="right" nowrap><strong>#LB_Codigo#:&nbsp;</strong></td>
			<td width="16%">
				<input name="RHGcodigo" type="text" 
				value="<cfif modo neq "ALTA" ><cfoutput>#rsGruposAreasEval.RHGcodigo#</cfoutput></cfif>" 
				size="10" maxlength="5"  alt="El C&oacute;digo del Concurso">
			</td>
			<td width="15%" align="right" nowrap>&nbsp;</td>
			<td width="40%">&nbsp;</td>
		</tr>
		<tr>
			<td align="right" nowrap>&nbsp;</td>
			<td align="right" nowrap><strong>#LB_Descripcion#:&nbsp;</strong></td>
			<td colspan="3">
				<input name="RHGdescripcion" type="text"  
				value="<cfif modo neq "ALTA"><cfoutput>#rsGruposAreasEval.RHGdescripcion#</cfoutput></cfif>" 
				size="60" maxlength="60" onFocus="this.select();"  alt="La Descripci&oacute;n del Concurso">
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr> 
			<td colspan="5" align="center" nowrap><cf_botones modo=#modo# regresarMenu="true"></td>
		</tr>
	</table>
	<cfset ts = "">
	  <cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsGruposAreasEval.ts_rversion#"/>
		</cfinvoke>
	</cfif>  
  <input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>" size="32">

	</cfoutput>
</form>
<SCRIPT LANGUAGE="JavaScript">
	function deshabilitar(){
		objForm.RHGcodigo.required = false;
		objForm.RHGdescripcion.required= false;
	}
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form");
		
	<cfif modo EQ "ALTA">
		<cfoutput>
		objForm.RHGcodigo.required = true;
		objForm.RHGcodigo.description="#LB_Codigo#";		
		objForm.RHGdescripcion.required= true;
		objForm.RHGdescripcion.description="#LB_Descripcion#";			
		</cfoutput>
	</cfif>
</script>