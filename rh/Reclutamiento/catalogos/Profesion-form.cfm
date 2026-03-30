
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

<cfif isDefined("session.CEcodigo") and isDefined("Form.RHOPid") and len(trim(#Form.RHOPid#)) NEQ 0>
	<cf_translatedata name="get" tabla="RHOPuesto" col="RHOPDescripcion" returnvariable="LvarRHOPDescripcion">
	<cf_translatedata name="validar" tabla="RHOPuesto" col="RHOPDescripcion" filtro="RHOPid= #Form.RHOPid#"/>
	<cf_dbfunction name="spart" args="#LvarRHOPDescripcion#|1|55" delimiters="|" returnvariable="LvarRHOPDescripcion">
	<cfquery name="rsRHOPuesto" datasource="#Session.DSN#" >
		Select RHOPid, #LvarRHOPDescripcion# as RHOPDescripcion, ts_rversion
        from RHOPuesto
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and RHOPid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHOPid#" >		  
	</cfquery>
</cfif>

<form action="Profesion-SQL.cfm" method="post" name="form">
	<cfoutput>
	<table width="67%" height="75%" align="center" cellpadding="0" cellspacing="0">
		<tr><td colspan="5">&nbsp;</td></tr>
		<tr>
			<td align="right" nowrap>&nbsp;</td>
			<td align="right" nowrap><strong>#LB_Descripcion#:&nbsp;</strong></td>
			<td colspan="3">
				<input name="RHOPDescripcion" type="text"  size="60" maxlength="80" onFocus="this.select();"
				value="<cfif modo neq "ALTA"><cfoutput>#trim(rsRHOPuesto.RHOPDescripcion)#</cfoutput></cfif>" >
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
			<cfinvokeargument name="arTimeStamp" value="#rsRHOPuesto.ts_rversion#"/>
		</cfinvoke>
	</cfif>
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'>#ts#</cfif>"> 
	<cfif modo neq "ALTA">
		<input type="hidden" name="RHOPid"value="<cfif modo neq "ALTA">#rsRHOPuesto.RHOPid#</cfif>" size="32">
	</cfif>
	<input type="hidden" name="LastOne" id="LastOne" value="ListaNon">
	<input type="hidden" name="ORHOPid"value="<cfif modo neq "ALTA">#rsRHOPuesto.RHOPid#</cfif>" size="32">
	</cfoutput>
</form>

<cf_qforms form="form">
<script language="javascript" type="text/javascript">
	<!--//
	<cfoutput>
	objForm.RHOPDescripcion.required = true;
	objForm.RHOPDescripcion.description="#LB_Descripcion#";
	
	function habilitarValidacion(){
		objForm.required("RHOPDescripcion");		
	}
	
	function deshabilitarValidacion(){
		objForm.required("RHOPDescripcion",false);
	}
	</cfoutput>	
	//-->
</script>	