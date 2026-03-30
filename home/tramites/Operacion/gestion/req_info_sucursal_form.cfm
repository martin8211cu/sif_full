
<cfoutput>
<cfinclude template="payment_header.cfm">

<cfquery name="data" datasource="#session.tramites.dsn#">
	select s.codigo_sucursal, s.nombre_sucursal, d.ciudad, d.estado
	from TPSucursal s
	inner join TPDirecciones d
	on d.id_direccion=s.id_direccion	
	where id_inst=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_inst#">
</cfquery>


<table width="100%" border="0" cellpadding="2" cellspacing="2">
	<tr><td colspan="2" bgcolor="##ECE9D8" style="padding:3px; font-size:14px;"><strong>Banco de Costa Rica</strong></td></tr>	
	<tr><td colspan="2" bgcolor="##ECE9D8" style="padding:3px; font-size:14px;"><strong>Sucursales donde puede realizar el requisito</strong></td></tr>	
	<cfif data.recordcount gt 0>
		<cfloop query="data">
			<tr class="<cfif data.currentrow mod 2>listaPar<cfelse>listaNon</cfif>" >
				<td style="font-size:14px">#data.nombre_sucursal#</td>
				<td style="font-size:14px">#data.ciudad#, #data.estado#</td>
			</tr>
		</cfloop>
	<cfelse>
		<tr>
			<td style="font-size:12px" >No se encontraron registros</td>
		</tr>
	</cfif>
	<tr><td><input type="button" name="Regresar" value="Regresar" onClick="javascript:location.href='req_info.cfm?id_instancia=#url.id_instancia#&id_persona=#url.id_persona#&id_requisito=#url.id_requisito#&id_tramite=#url.id_tramite#';"></td></tr>
</table>		
</cfoutput>
</script>
