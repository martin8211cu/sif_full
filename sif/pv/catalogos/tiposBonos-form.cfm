<cfif isdefined('url.IdTipoBn') and not isdefined('form.IdTipoBn')>
	<cfparam name="form.IdTipoBn" default="#url.IdTipoBn#">
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined('form.IdTipoBn') and len(trim(form.IdTipoBn))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select IdTipoBn, BNCodigo, BNDescripcion, BNComplementoCF,BNFecha_Vence,ts_rversion
		from FATiposBono
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and  IdTipoBn = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdTipoBn#">
	</cfquery>
	
</cfif>	
	
<cfoutput>
<form name="form1" method="post" action="tiposBonos-sql.cfm">
	<table width="100%" cellpadding="3" cellspacing="0">
		
		<cfif isdefined('form.Descripcion_F') and len(trim(form.Descripcion_F))>
        	<input type="hidden" name="Descripcion_F" value="#form.Descripcion_F#">
      	</cfif>
		<tr>
			<td align="right"><strong>C&oacute;digo</strong></td>
        	<td>
				<input type="text" name="BNCodigo" size="10" maxlength="10" value="<cfif modo neq 'ALTA'>#rtrim(data.BNCodigo)#</cfif>">
			</td>
		</tr>
		
		<tr>
			<td align="right"><strong>Descripci&oacute;n</strong></td>
        	<td >
				<input type="text" name="BNDescripcion" size="50" maxlength="80" value="<cfif modo neq 'ALTA'>#data.BNDescripcion#</cfif>">
			</td>
		</tr>
		<tr>	
			<td align="right" nowrap><strong>Complemento</strong></td>			
			<td>
				<input type="text" name="BNComplemento" size="50" maxlength="100" value="<cfif modo neq 'ALTA'>#data.BNComplementoCF#</cfif>">
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Vencimiento</strong></td>
			<td>
				<cfif modo neq "ALTA">
					<cf_sifcalendario tabindex="5" form="form1" value="#LSDateFormat(data.BNFecha_Vence,'dd/mm/yyyy')#" name="BNFecha">
				<cfelse>
					<cf_sifcalendario tabindex="5" form="form1" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="BNFecha">
				</cfif>	
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<cfif modo neq 'ALTA'  >
					<cf_botones modo='CAMBIO'>
					<input type="hidden" name="IdTipoBn" value="#data.IdTipoBn#">
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
		<input type="hidden" name="ts_rversion_Bon" value="#ts#">
	</cfif>
</form>

<!-- MANEJA LOS ERRORES  NOTA:QUE REVISEN ESTO EN LA BD! --->
<cf_qforms>
<script language="javascript" type="text/javascript">
	<!--//
		objForm.BNCodigo.required = true;
		objForm.BNCodigo.description = "Codigo";
		objForm.BNDescripcion.required = true;
		objForm.BNDescripcion.description = "Descripción";
		objForm.BNComplemento.required = true;
		objForm.BNComplemento.description = "Complemento";
		objForm.BNFecha.required = true;		
		objForm.BNFecha.description = "Fecha de vencimiento";
		
		function deshabilitarValidacion(){
			objForm.BNCodigo.required = false;
			objForm.BNDescripcion.required = false;
			objForm.BNComplemento.required = false;
			objForm.BNFecha.required = false;				
		}
		
		function habilitarValidacion(){
			objForm.BNCodigo.required = true;
			objForm.BNDescripcion.required = true;
			objForm.BNComplemento.required = true;
			objForm.BNFecha.required = true;		
		}
	//-->
</script>
</cfoutput>