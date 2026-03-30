<cfif isdefined('url.FAM12COD') and not isdefined('form.FAM12COD')>
	<cfparam name="form.FAM12COD" default="#url.FAM12COD#">
</cfif>


<cfset modo = 'ALTA'>
<cfif isdefined('form.FAM12COD') and len(trim(form.FAM12COD))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select FAM12COD, FAM12CODD, FAM12DES, ts_rversion
		from FAM012
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and FAM12COD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAM12COD#">
	</cfquery>
</cfif> 


<cfoutput>
<form name="form1" method="post" action="impresoras-sql.cfm">
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="FAM12COD" value="#data.FAM12COD#">
	</cfif>
	<table width="100%" cellpadding="3" cellspacing="0">
		<tr>
			<td align="right"><strong>Código</strong></td>
			<td><input type="text" name="FAM12CODD" size ="10" maxlength="4" value="<cfif modo neq 'ALTA'>#data.FAM12CODD#</cfif>"></td>
		</tr>
		<tr>
			<td align="right"><strong>Descripci&oacute;n</strong></td>
			<td><input type="text" name="FAM12DES" size="50" maxlength="50" value="<cfif modo neq 'ALTA'>#data.FAM12DES#</cfif>"></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<cfif modo neq 'ALTA'  >
					<cf_botones modo='CAMBIO'>
				<cfelse>
					<cf_botones modo='ALTA'>
				</cfif>
			</td>
		</tr>
	</table>
	<cfif modo neq 'ALTA'>
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#data.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
</form>


<cf_qforms>
<script language="javascript">
	<!--//
	
	objForm.FAM12CODD.description = "Codigo";
	objForm.FAM12DES.description = "Descricion";
	
	function habilitarValidacion(){
		objForm.FAM12CODD.required = true;
		objForm.FAM12DES.required = true;
	}
	function deshabilitarValidacion(){
		objForm.FAM12CODD.required = false;
		objForm.FAM12DES.required = false;
	}
	habilitarValidacion();
	//-->
</script>

</cfoutput>