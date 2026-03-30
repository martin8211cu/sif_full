<cfif isdefined('url.FAM23COD') and not isdefined('form.FAM23COD')>
	<cfparam name="form.FAM23COD" default="#url.FAM23COD#">
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined('form.FAM23COD') and len(trim(form.FAM23COD))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select FAM23COD, FAM23DES, ts_rversion
		from FAM023
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and  FAM23COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FAM23COD#">
	</cfquery>
</cfif>	
	
<cfoutput>
<form name="form1" method="post" action="mensajes-sql.cfm" onSubmit="javascript: return validaMon();">
	<table width="100%" cellpadding="3" cellspacing="0">
		
		<cfif isdefined('form.FAM23DES_F') and len(trim(form.FAM23DES_F))>
        	<input type="hidden" name="FAM23DES_F" value="#form.FAM23DES_F#">
      	</cfif>
			
		<tr>
			<td align="right"><strong>Descripci&oacute;n</strong></td>
        	<td>
				<input type="text" name="FAM23DES" size="20" maxlength="20" value="<cfif modo neq 'ALTA'>#data.FAM23DES#</cfif>">
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<cfif modo neq 'ALTA'  >
					<cf_botones modo='CAMBIO'>
					<input type="hidden" name="FAM23COD" value="#data.FAM23COD#">
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

<!-- MANEJA LOS ERRORES--->
<cf_qforms>
<script language="javascript" type="text/javascript">
	<!--//
	objForm.FAM23DES.description = "Descripci&oacute;n";

	function validaMon(){
		return true;
	}	
	
	function habilitarValidacion(){
		objForm.FAM23DES.required = true;
	}
	function deshabilitarValidacion(){
		objForm.FAM23DES.required = false;
	}
	habilitarValidacion();
	//-->
</script>
</cfoutput>