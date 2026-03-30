
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

<cfif isDefined("session.CEcodigo") and isDefined("Form.RHOEid") and len(trim(#Form.RHOEid#)) NEQ 0>
	<cf_translatedata name="get" tabla="RHOEnfasis" col="RHOEDescripcion" returnvariable="LvarRHOEDescripcion">
	<cf_translatedata name="validar" tabla="RHOEnfasis" col="RHOEDescripcion" filtro="RHOEid= #Form.RHOEid#"/>
	<cf_dbfunction name="spart" args="#LvarRHOEDescripcion#|1|55" delimiters="|" returnvariable="LvarRHOEDescripcion">
	<cfquery name="rsRHOEnfasis" datasource="#Session.DSN#" >
		Select RHOEid, #LvarRHOEDescripcion# as RHOEDescripcion, ts_rversion
        from RHOEnfasis
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and RHOEid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHOEid#" >		  
	</cfquery>
</cfif>

<form action="Enfasis-SQL.cfm" method="post" name="form">
	<cfoutput>
	<table width="67%" height="75%" align="center" cellpadding="0" cellspacing="0">
		<tr><td colspan="5">&nbsp;</td></tr>
		<tr>
			<td align="right" nowrap>&nbsp;</td>
			<td align="right" nowrap><strong>#LB_Descripcion#:&nbsp;</strong></td>
			<td colspan="3">
				<input name="RHOEDescripcion" type="text"  size="60" maxlength="80" onFocus="this.select();"
				value="<cfif modo neq "ALTA"><cfoutput>#trim(rsRHOEnfasis.RHOEDescripcion)#</cfoutput></cfif>" >
			</td>
		</tr>
	</table>
	<br>
	
	<cf_botones modo=#modo# regresarMenu="True">
	<cfset ts = "">	
	<cfif modo neq "ALTA">
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsRHOEnfasis.ts_rversion#"/>
		</cfinvoke>
	</cfif>
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'>#ts#</cfif>"> 
	<cfif modo neq "ALTA">
		<input type="hidden" name="RHOEid"value="<cfif modo neq "ALTA">#rsRHOEnfasis.RHOEid#</cfif>" size="32">
	</cfif>
	<input type="hidden" name="LastOne" id="LastOne" value="ListaNon">
	<input type="hidden" name="ORHOEid"value="<cfif modo neq "ALTA">#rsRHOEnfasis.RHOEid#</cfif>" size="32">
	</cfoutput>
</form>

<cf_qforms form="form">
<script language="javascript" type="text/javascript">
	<!--//
	<cfoutput>
	objForm.RHOEDescripcion.required = true;
	objForm.RHOEDescripcion.description="#LB_Descripcion#";
	
	function habilitarValidacion(){
		objForm.required("RHOEDescripcion");		
	}
	
	function deshabilitarValidacion(){
		objForm.required("RHOEDescripcion",false);
	}
	</cfoutput>	
	//-->
</script>	