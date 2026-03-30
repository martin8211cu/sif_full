<cfif isdefined('url.IdTipoAd') and not isdefined('form.IdTipoAd')>
	<cfparam name="form.IdTipoAd" default="#url.IdTipoAd#">
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined('form.IdTipoAd') and len(trim(form.IdTipoAd))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select 	IdTipoAd, 
				CodInterno, 
				Descripcion, 
				CFcuenta,
				ReqReferencia, 
				ReqCotizacion,
				TipoTrans,
				ts_rversion
		from FATiposAdelanto
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and  IdTipoAd = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdTipoAd#">
	</cfquery>
	
	<!--- QUERY PARA el tag de Cuenta Contable--->
	
	<cfif len(trim(data.CFcuenta))>
		<cfquery name="rsCuentas" datasource="#Session.DSN#" >
			Select Ccuenta, 
				   CFcuenta, 
				   CFformato, 
				   CFdescripcion
			from CFinanciera
			where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and CFcuenta=<cfqueryparam value="#data.CFcuenta#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>
</cfif>	
	
<cfoutput>
<form name="form1" method="post" action="tiposAdelantos-sql.cfm" onSubmit="javascript: return validaMon();">
	<table width="100%" cellpadding="3" cellspacing="0">
		
		<cfif isdefined('form.Descripcion_F') and len(trim(form.Descripcion_F))>
        	<input type="hidden" name="Descripcion_F" value="#form.Descripcion_F#">
      	</cfif>
		<tr>
			<td align="right"><strong>C&oacute;digo</strong></td>
        	<td>
				<input type="text" name="CodInterno" size="20" maxlength="10" value="<cfif modo neq 'ALTA'>#data.CodInterno#</cfif>">
			</td>
		</tr>
		
		<tr>
			<td align="right"><strong>Descripci&oacute;n</strong></td>
        	<td >
				<input type="text" name="Descripcion" size="40" maxlength="80" value="<cfif modo neq 'ALTA'>#data.Descripcion#</cfif>">
			</td>
		</tr>
		<tr>	
			<td align="right" nowrap><strong>Cuenta Contable</strong></td>			
			<td >
				 <cfif modo NEQ "ALTA" and len(trim(data.CFcuenta))>
			        <cf_cuentas query="#rsCuentas#" Ccuenta="c1" CFcuenta="CFcuenta" Cmayor="Cmayor1" Cformato="Cformato1" Cdescripcion="Cdescripcion1" frame="iframe1"> 
	
				<cfelse>
					<cf_cuentas Ccuenta="c1" CFcuenta="CFcuenta" Cmayor="Cmayor1" Cformato="Cformato1" Cdescripcion="Cdescripcion1" frame="iframe1">
				</cfif>
			</td>
		</tr>

		<tr>
			<td align="right"><strong>Tipo</strong></td>
			<td>
				<select name="TipoTrans" >
					<option value="" >-Seleccionar-</option>
					<option value="0" <cfif modo neq 'ALTA' and data.TipoTrans eq 0 >selected</cfif> >Adelanto</option>
					<option value="1" <cfif modo neq 'ALTA' and data.TipoTrans eq 1 >selected</cfif> >Recibo CxC</option>
					<option value="2" <cfif modo neq 'ALTA' and data.TipoTrans eq 2 >selected</cfif> >Otro</option>
				</select>
			</td>
		</tr>

		<tr>
			<td align="right"></td>
			<td>
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1%">
								<input name="reqReferencia" type="checkbox"
								<cfif modo neq 'ALTA'>
								<cfif data.ReqReferencia EQ 1>checked</cfif></cfif>>
						</td>
						<td ><strong>Requiere Referencia</strong></td>
					</tr>	
					<tr>
						<td width="1%">
								<input name="ReqCotizacion" type="checkbox"
								<cfif modo neq 'ALTA'>
								<cfif data.ReqCotizacion EQ 'S'>checked</cfif></cfif>>
						</td>
						<td ><strong>Requiere Cotización</strong></td>
					</tr>	
				</table>		
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<cfif modo neq 'ALTA'  >
					<cf_botones modo='CAMBIO'>
					<input type="hidden" name="IdTipoAd" value="#data.IdTipoAd#">
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
		<input type="hidden" name="ts_rversion_Ade" value="#ts#">
	</cfif>
</form>

<!-- MANEJA LOS ERRORES  NOTA:QUE REVISEN ESTO EN LA BD! --->
<cf_qforms>
<script language="javascript" type="text/javascript">
	<!--//
	objForm.Descripcion.description = "Descripción";
	objForm.TipoTrans.description = "Tipo";	

	function validaMon(){
		return true;
	}	
	
	function habilitarValidacion(){
		objForm.Descripcion.required = true;
		objForm.CFcuenta.required = true;
		objForm.CFcuenta.description = "Cuenta Contable";
		objForm.TipoTrans.required = true;		
	}
	function deshabilitarValidacion(){
		objForm.Descripcion.required = false;
		objForm.CFcuenta.required = false;
		objForm.TipoTrans.required = false;		
	}
	habilitarValidacion();
	//-->
</script>
</cfoutput>