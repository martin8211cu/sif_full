<cfif isdefined("url.RHIAid") and len(trim(url.RHIAid)) and not isdefined("form.RHIAid")>
	<cfset form.RHIAid = url.RHIAid >
</cfif>
<cfset modo = 'ALTA'>
<cfif isdefined("form.RHIAid") and len(trim(form.RHIAid))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfset v_factor = 0 >
<cfif modo neq 'ALTA'>
	<cfquery name="rs_datos" datasource="#session.DSN#">
		select RHIAid, CIid, RHIAexcluir, RHIAaplicarFactor, RHIAfactor
		from RHIncidenciasAguinaldo
		where RHIAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIAid#">
	</cfquery>
	
	<cfquery name="rs_incidencia" datasource="#session.DSN#">
		select CIid, CIcodigo, CIdescripcion
		from CIncidentes
		where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_datos.CIid#">
	</cfquery>
	<cfset v_factor = rs_datos.RHIAfactor >
</cfif>
<form name="form1" method="post" action="IncidenciasAguinaldo-sql.cfm" style="margin:0;" onsubmit="return valida()">
	<cfoutput>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td width="1%" nowrap="nowrap"><strong>#LB_concepto#:</strong></td>
			<td><cfif modo neq 'ALTA'><cf_rhcincidentes query="#rs_incidencia#"><cfelse><cf_rhcincidentes></cfif></td>
		</tr>
		<tr>
			<td><strong>#LB_comportamiento#:</strong></td>
			<td>
				<table width="1%" cellpadding="2" cellspacing="0">
					<tr>
						<tr>
							<td><input type="radio" name="opcion" value="E" <cfif modo neq 'ALTA' ><cfif rs_datos.RHIAexcluir eq 1>checked="checked"</cfif><cfelse>checked="checked"</cfif> onClick="javascript:mostrar_factor(this);"></td>
							<td nowrap="nowrap"><label>#LB_excluir#</label></td>
							<td><input type="radio" name="opcion" value="F" <cfif modo neq 'ALTA' and rs_datos.RHIAaplicarFactor eq 1>checked="checked"</cfif> onClick="javascript:mostrar_factor(this);"></td>
							<td nowrap="nowrap"><label>#LB_AplicarFactor#</label></td>
						</tr>
					</tr>
				</table>
			</td>
		</tr>
		<tr id="lb_factor" <cfif modo neq 'ALTA' and rs_datos.RHIAaplicarFactor eq 1> style="display:inline;"<cfelse> style="display:none;"</cfif>  >
			<td><strong>#lb_factor#:</strong></td>
			<td><cf_inputNumber name="RHIAfactor" enteros="3" decimales="2" value="#v_factor#"></td>
		</tr>
		<tr><td colspan="2" align="center"><cf_botones modo="#modo#"></td></tr>
	</table>
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="RHIAid" value="#rs_datos.RHIAid#">
	</cfif>
	</cfoutput>
</form>

<script language="javascript1.2" type="text/javascript">
	function valida(){
		if (document.getElementById('CIcodigo').value == ''){
			alert('Debe seleccionar un concepto incidente.')
			return false;
		}
		else{
			return true;
		}
		
	}
	function mostrar_factor(obj){
		if ( obj.value == 'E' ){
			document.getElementById('lb_factor').style.display = 'none';
		}
		else{
			document.getElementById('lb_factor').style.display = '';		
		}
	}
</script>


