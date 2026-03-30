<cfif isdefined('url.FAD01COD') and not isdefined('form.FAD01COD')>
	<cfparam name="form.FAD01COD" default="#url.FAD01COD#">
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined('form.FAD01COD') and len(trim(form.FAD01COD))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select  FAD01COD, FAD01DES, FAD01REF, FAD01GEN, FAD01PRE, FAD01PRS, FAD01INT, ts_rversion 
		from FAD001
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and  FAD01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FAD01COD#">
	</cfquery>
</cfif>	
	
<cfoutput>
<form name="form1" method="post" action="documentos-sql.cfm" onSubmit="javascript: return validaMon();">
	<table width="100%" cellpadding="3" cellspacing="0">
		
		<cfif isdefined('form.FAD01COD_F') and len(trim(form.FAD01COD_F))>
        	<input type="hidden" name="FAD01COD_F" value="#form.FAD01COD_F#">
      	</cfif>
		<cfif isdefined('form.FAD01DES_F') and len(trim(form.FAD01DES_F))>
        	<input type="hidden" name="FAD01DES_F" value="#form.FAD01DES_F#">
      	</cfif>
				
		<tr>
			<td align="right"><strong>C&oacute;digo</strong></td>
       		<td>
				<input type="text" name="FAD01COD" size="10" maxlength="4" <cfif modo neq 'ALTA'> readonly="true"</cfif> value="<cfif modo neq 'ALTA'>#data.FAD01COD#</cfif>">
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Descripci&oacute;n</strong></td>
    	    <td>
				<input type="text" name="FAD01DES" size="30" maxlength="20" value="<cfif modo neq 'ALTA'>#data.FAD01DES#</cfif>">
			</td>
		</tr>
		<tr>
			<td width="18%" align="right"><strong>Referencia</strong></td>
			<td width="82%"><input name="FAD01REF" type="checkbox" value="1" <cfif modo NEQ "ALTA" and data.FAD01REF eq 1> checked</cfif>></td>			  
		</tr>
		<tr>
			<td width="18%" align="right"><strong>Docs al Portador</strong></td>
			<td width="82%"><input name="FAD01GEN" type="checkbox" value="1" <cfif modo NEQ "ALTA" and data.FAD01GEN eq 1> checked</cfif>></td>			  
		</tr>
		<tr>
			<td align="right"><strong>Interfaz de Sistema Externo</strong></td>
        	<td><input name="FAD01INT" type="checkbox" value="1" <cfif modo NEQ "ALTA" and data.FAD01INT eq 1> checked</cfif>></td>
		</tr>
		<tr>
			<td align="right" nowrap><strong>Proceso de Verificaci&oacute;n de Entrada</strong></td>
        	<td><input type="text" name="FAD01PRE" size="30" maxlength="20" value="<cfif modo neq 'ALTA'>#data.FAD01PRE#</cfif>"></td>
		</tr>
		<tr>
		  <td align="right"><strong>Proceso de Verificaci&oacute;n de Salida</strong></td>
		  <td><input type="text" name="FAD01PRS" size="30" maxlength="20" value="<cfif modo neq 'ALTA'>#data.FAD01PRS#</cfif>"></td>
	  	</tr>
		<tr>
			<td align="right">&nbsp;</td>
        	<td width="82%">&nbsp;</td>			  
		</tr>
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

<!-- MANEJA LOS ERRORES--->
<cf_qforms>
<script language="javascript" type="text/javascript">
<!--//
	objForm.FAD01COD.description = "Código";
	objForm.FAD01DES.description = "Descripción";
	objForm.FAD01PRS.description = "Proceso de Verificación de Salida";
	
	function validaMon(){
		return true;
	}	
	
	function habilitarValidacion(){
		objForm.FAD01COD.required = true;
		objForm.FAD01DES.required = true;
		objForm.FAD01PRS.required = true;
		
	}
	function deshabilitarValidacion(){
		objForm.FAD01COD.required = false;
		objForm.FAD01DES.required = false;
		objForm.FAD01PRS.required = false;
	}
	habilitarValidacion();
	//-->
</script>
</cfoutput>
