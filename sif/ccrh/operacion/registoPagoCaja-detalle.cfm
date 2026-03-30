<cfquery name="rsRecibos" datasource="#session.DSN#">
	select 	a.Id,
			a.NoDocumento,
			a.fechaalta,
			a.MontoTotalPagado,
			c.Miso4217,
			d.Cformato,
			x.PERid,
			x.montoAplicado			
			
	from PagoPorCaja a
		inner join TDeduccion b
			on a.TDid = b.TDid
		inner join Monedas c
			on a.Mcodigo = c.Mcodigo
		inner join CContables d
			on a.Ccuenta = d.Ccuenta

		inner join ccrhPagoRecibos	x
			on a.Id = x.idRecibo
			
			and  x.documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EPEdocumento#">

	where a.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfoutput>
	<input type="hidden" name="PERid" value=""/>
	<input type="hidden" name="ID_Eliminar" value=""/>
</cfoutput>
<table width="80%" cellpadding="0" cellspacing="0">
	<tr class="tituloListas">
		<td><strong>Documento (Recibo)</strong></td>
		<td><strong>Cuenta</strong></td>
		<td><strong>Monto Recibido</strong></td>
		<td><strong>Monto Aplicado(Deducción)</strong></td>
		<td>&nbsp;</td>
	</tr>
	<cfif rsRecibos.RecordCount NEQ 0>
		<cfoutput query="rsRecibos">
			<tr>
				<td>#NoDocumento#</td>
				<td>#Cformato#</td>
				<td>#LSNumberFormat(MontoTotalPagado,',9.00')#</td>
				<td>#LSNumberFormat(montoAplicado,',9.00')#</td>
				<td><a href="javascript: funcEliminar('#PERid#','#Id#')"><img src="/cfmx/sif/imagenes/Borrar01_S.gif" border="0"/></a></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr><td colspan="5" align="center"><b>---- No se encontraron registros ----</b></td></tr>
	</cfif>
</table>

<script type="text/javascript" language="javascript1.2">
	function funcEliminar(prn_PERid,prn_Id){
		document.form1.PERid.value = prn_PERid;
		document.form1.ID_Eliminar.value = prn_Id;
		document.form1.submit();
	}
</script>

