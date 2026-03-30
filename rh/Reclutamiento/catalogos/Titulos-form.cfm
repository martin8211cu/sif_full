
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

<cfif isDefined("session.CEcodigo") and isDefined("Form.RHOTid") and len(trim(#Form.RHOTid#)) NEQ 0>
	<cf_translatedata name="get" tabla="RHOTitulo" col="RHOTDescripcion" returnvariable="LvarRHOTDescripcion">
	<cf_translatedata name="validar" tabla="RHOTitulo" col="RHOTDescripcion" filtro="RHOTid= #Form.RHOTid#"/>
	<cf_dbfunction name="spart" args="#LvarRHOTDescripcion#|1|55" delimiters="|" returnvariable="LvarRHOTDescripcion">
	<cfquery name="rsRHOTitulo" datasource="#Session.DSN#" >
		Select RHOTid, #LvarRHOTDescripcion# as RHOTDescripcion, RHOTnf, ts_rversion
        from RHOTitulo
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and RHOTid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHOTid#" >		  
	</cfquery>
</cfif>

<form action="Titulos-SQL.cfm" method="post" name="form">
	<cfoutput>
	<table width="67%" height="75%" align="center" cellpadding="0" cellspacing="0">
		<tr><td colspan="5">&nbsp;</td></tr>
		<tr>
			<td align="right" nowrap>&nbsp;</td>
			<td align="right" nowrap><strong>#LB_Descripcion#:&nbsp;</strong></td>
			<td colspan="3">
				<input name="RHOTDescripcion" type="text"  size="60" maxlength="80" onFocus="this.select();"
				value="<cfif modo neq "ALTA"><cfoutput>#trim(rsRHOTitulo.RHOTDescripcion)#</cfoutput></cfif>" >
			</td>
		</tr>
		<tr>
			<td align="right" nowrap>&nbsp;</td>
			<td align="right" nowrap><strong>#LB_NFormal#:&nbsp;</strong></td>
			<td colspan="3">
				<input type="checkbox" id="RHOTnf" name="RHOTnf" value="RHOTnf" <cfif modo neq "ALTA" and rsRHOTitulo.RHOTnf eq "1" > checked</cfif>>
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
			<cfinvokeargument name="arTimeStamp" value="#rsRHOTitulo.ts_rversion#"/>
		</cfinvoke>
	</cfif>
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'>#ts#</cfif>"> 
	<cfif modo neq "ALTA">
		<input type="hidden" name="RHOTid"value="<cfif modo neq "ALTA">#rsRHOTitulo.RHOTid#</cfif>" size="32">
	</cfif>
	<input type="hidden" name="LastOne" id="LastOne" value="ListaNon">
	<input type="hidden" name="ORHOTid"value="<cfif modo neq "ALTA">#rsRHOTitulo.RHOTid#</cfif>" size="32">
	</cfoutput>
</form>

<cf_qforms form="form">
<script language="javascript" type="text/javascript">
	<!--//
	<cfoutput>
	objForm.RHOTDescripcion.required = true;
	objForm.RHOTDescripcion.description="#LB_Descripcion#";
	
	function habilitarValidacion(){
		objForm.required("RHOTDescripcion");		
	}
	
	function deshabilitarValidacion(){
		objForm.required("RHOTDescripcion",false);
	}
	</cfoutput>	
	//-->
</script>	