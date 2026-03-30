
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

<cfif isDefined("session.CEcodigo") and isDefined("Form.RHOIid") and len(trim(#Form.RHOIid#)) NEQ 0>
	<cf_translatedata name="get" tabla="RHOIndustria" col="RHOIDescripcion" returnvariable="LvarRHOIDescripcion">
	<cf_translatedata name="validar" tabla="RHOIndustria" col="RHOIDescripcion" filtro="RHOIid= #Form.RHOIid#"/>
	<cf_dbfunction name="spart" args="#LvarRHOIDescripcion#|1|55" delimiters="|" returnvariable="LvarRHOIDescripcion">
	<cfquery name="rsRHOIndustria" datasource="#Session.DSN#" >
		Select RHOIid, #LvarRHOIDescripcion# as RHOIDescripcion, ts_rversion
        from RHOIndustria
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and RHOIid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHOIid#" >		  
	</cfquery>
</cfif>

<form action="Industrias-SQL.cfm" method="post" name="form">
	<cfoutput>
	<table width="67%" height="75%" align="center" cellpadding="0" cellspacing="0">
		<tr><td colspan="5">&nbsp;</td></tr>
		<tr>
			<td align="right" nowrap>&nbsp;</td>
			<td align="right" nowrap><strong>#LB_Descripcion#:&nbsp;</strong></td>
			<td colspan="3">
				<input name="RHOIDescripcion" type="text"  size="60" maxlength="80" onFocus="this.select();"
				value="<cfif modo neq "ALTA"><cfoutput>#trim(rsRHOIndustria.RHOIDescripcion)#</cfoutput></cfif>" >
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
			<cfinvokeargument name="arTimeStamp" value="#rsRHOIndustria.ts_rversion#"/>
		</cfinvoke>
	</cfif>
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'>#ts#</cfif>"> 
	<cfif modo neq "ALTA">
		<input type="hidden" name="RHOIid"value="<cfif modo neq "ALTA">#rsRHOIndustria.RHOIid#</cfif>" size="32">
	</cfif>
	<input type="hidden" name="LastOne" id="LastOne" value="ListaNon">
	<input type="hidden" name="ORHOIid"value="<cfif modo neq "ALTA">#rsRHOIndustria.RHOIid#</cfif>" size="32">
	</cfoutput>
</form>

<cf_qforms form="form">
<script language="javascript" type="text/javascript">
	<!--//
	<cfoutput>
	objForm.RHOIDescripcion.required = true;
	objForm.RHOIDescripcion.description="#LB_Descripcion#";
	
	function habilitarValidacion(){
		objForm.required("RHOIDescripcion");		
	}
	
	function deshabilitarValidacion(){
		objForm.required("RHOIDescripcion",false);
	}
	</cfoutput>	
	//-->
</script>	