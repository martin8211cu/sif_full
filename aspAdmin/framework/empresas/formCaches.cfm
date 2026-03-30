<!--- <cfdump var="#form#"> --->

<cfquery name="rsForm" datasource="sdc">
	select isnull(a.nombre_cache, 'NULL') as nombre_cache, b.nombre_comercial, c.nombre, b.cliente_empresarial, d.nombre as cnombre
	from EmpresaID a, Empresa b, Sistema c, CuentaClienteEmpresarial d
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.sdcEcodigo#" >
	and a.sistema   = <cfqueryparam cfsqltype="cf_sql_char" value="#form.sdcSistema#" >
	and a.Ecodigo   = b.Ecodigo
	and a.sistema   = c.sistema
    and b.cliente_empresarial = d.cliente_empresarial
</cfquery>

<cfif rsForm.nombre_cache eq 'NULL' >
	<cfset modo = 'ALTA'>
<cfelse>
	<cfset modo = 'CONSULTA'>
</cfif>

<!--- arreglo de datasources --->
<cfinclude template="query_caches.cfm">

<cfoutput>
<form name="form1" method="post" action="SQLCaches.cfm" onSubmit="return validar(this);" >
	<input type="hidden" name="Ecodigo" value="#form.sdcEcodigo#">
	<input type="hidden" name="sistema" value="#form.sdcSistema#">

	<cfif isdefined("form.sql_error")>
		<input type="hidden" name="sdcEcodigo" value="#form.sdcEcodigo#">
		<input type="hidden" name="sdcSistema" value="#form.sdcSistema#">
	</cfif>

	<cfif modo eq 'ALTA'>
		<input type="hidden" name="cliente_empresarial" value="#rsForm.cliente_empresarial#">
	</cfif>

<cfif not isdefined("form.sql_error")>
	<table width="100%" cellpadding="0" cellspacing="0" border="0" >
		<tr><td align="center">&nbsp;</td></tr>
		<tr><td align="center">
			<table width="60%" cellpadding="0" cellspacing="0" class="ayuda" align="center">
				<tr><td align="center" colspan="2"><b><font size="2"><cfif modo neq 'ALTA'>Cache Asignado<cfelse>Asignar Cache</cfif></font></b></td></tr>
				<tr><td align="center" colspan="2">Cliente Empresarial: #rsForm.cnombre#</td></tr>
				<tr><td align="center" colspan="2">Empresa: #rsForm.nombre_comercial#</td></tr>
				<tr><td align="center" colspan="2">Sistema: #Ucase(form.sdcSistema)# - #rsForm.nombre#</td></tr>
		
				<tr>
					<td align="right" width="45%">Cache:&nbsp;</td>
					<td>
						<cfif modo eq 'ALTA'>
							<select name="nombre_cache">
								<option value="">Seleccionar...</option>												
									<cfloop From="1" To="#ArrayLen(datasources)#" index="i">
										<option value="#datasources[i]#" <cfif rsForm.nombre_cache eq datasources[i] >selected</cfif> >#datasources[i]#</option>
									</cfloop>
							</select>
						<cfelse>
							#rsForm.nombre_cache#	
						</cfif>
					</td>
				</tr>
				
				<tr><td>&nbsp;</td></tr>

				<cfif modo neq 'ALTA'>
					<tr><td colspan="2" align="center"><b>El Cache no puede ser modificado.</b></td></tr>
					<tr><td colspan="2" align="center">&nbsp;</td></tr>
				</cfif>	

			</table>
		</td></tr>
		
		<cfif modo neq 'ALTA'>
			<tr><td colspan="2" align="center">&nbsp;</td></tr>
			<tr><td colspan="2" align="center"><input type="button" name="Regresar" value="Regresar" onClick="javascript:document.form1.action='listaCaches.cfm'; document.form1.submit(); "></td></tr>
		<cfelse>
			<tr><td colspan="2" align="center">&nbsp;</td></tr>
			<tr><td colspan="2" align="center"><input type="submit" name="btnAsignar" value="Asignar"></td></tr>
		</cfif>
	</table>
<cfelse>
	<table width="100%" cellpadding="0" cellspacing="0" border="0" >
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<table width="60%" cellpadding="0" cellspacing="0"  class="ayuda" align="center">
					<tr><td>&nbsp;</td></tr>
					<tr><td align="center"><b><font size="2">Error al asignar Cache</font></b></td></tr>
					<tr><td align="center">Cliente Empresarial: #rsForm.cnombre#</td></tr>
					<tr><td align="center">Empresa: #rsForm.nombre_comercial#</td></tr>
					<tr><td align="center">Sistema: #Ucase(form.sdcSistema)# - #rsForm.nombre#</td></tr>
					<tr><td align="center">
						<cfif form.sql_error eq 1>
							El Cache que desea asignar (#form.nombre_cache#) es de uso exclusivo por Cuenta Empresarial.<br>La Cuenta Empresarial en proceso no corresponde a la definida para el cache.
						<cfelse>
							El Cache que desea asignar (#form.nombre_cache#) no corresponde al sistema en proceso. <br>Revise los datos.
						</cfif>
					</td></tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</td>
		</tr>
		<tr><td colspan="2" align="center">&nbsp;</td></tr>
		<tr><td colspan="2" align="center"><input type="button" name="Regresar" value="Regresar" onClick="javascript:document.form1.action=''; document.form1.submit(); "></td></tr>
	</table>
</cfif>	

</form>
</cfoutput>

<script language="javascript1.2" type="text/javascript">
	function validar(objForm){
		if (objForm.nombre_cache.value == '' ){
			var mensaje = "Se presentaron los siguientes errores:\n";
			    mensaje += " - Debe seleccionar un valor para el campo Cache."
			alert(mensaje);
			return false;
		}
		return true;
	}
</script>