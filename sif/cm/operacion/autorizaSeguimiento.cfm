<html>
<head>
<title>Seguimiento de Autorizaciones</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<cf_templatecss>

<cfquery name="dataOrden" datasource="#session.DSN#">
	select EOnumero, Observaciones, coalesce(EOtotal,0) as EOtotal
	from EOrdenCM
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOidorden#">
</cfquery>

<cfquery name="data" datasource="#session.DSN#">
	select CMCnombre, Nivel, CMAestado, CMAestadoproceso, case CMAestado when 0 then 'Pendiente' when 1 then 'Rechazada' when 2 then 'Aprobada' end as Estado 
	from CMAutorizaOrdenes a
	
	inner join CMCompradores b
	on a.CMCid=b.CMCid
	
	where CMAestadoproceso <> 10
	  and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOidorden#">
	order by Nivel
</cfquery>

<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0" border="0"> 
	<tr><td colspan="3" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">Segumiento de Autorizaci&oacute;n de Ordenes de Compra</strong></td></tr>
	<tr>
		<td align="right" width="1%"><strong>Orden:</strong></td>
		<td colspan="3" align="left">#dataOrden.EOnumero#</td>
	</tr>
	<tr>
		<td align="right" ><strong>Descripci&oacute;n:</strong></td>
		<td colspan="3" align="left" >#dataOrden.Observaciones#</td>
	</tr>
	<tr>
		<td align="right" ><strong>Monto:</strong></td>
		<td colspan="3" align="left" >#LSNumberFormat(dataOrden.EOtotal,',9.00')#</td>
	</tr>

	<tr><td>&nbsp;</td></tr>

	<tr class="tituloListas">
		<td><strong>Nivel</strong></td>
		<td><strong>Comprador</strong></td>
		<td><strong>Estado</strong></td>
	</tr>
	<cfloop query="data">
		<tr class="<cfif data.currentRow mod 2>listaNon<cfelse>listaPar</cfif>">
			<td>#data.Nivel#</td>
			<td nowrap>#data.CMCnombre#</td>
			<td>#data.Estado#</td>
		</tr>
	</cfloop>

	<tr><td colspan="3" align="center">&nbsp;</td></tr>
	<tr><td colspan="3" align="center"><input type="button" name="Cerrar" value="Cerrar" onClick="window.close();"></td></tr>
</table>
</cfoutput>

</body>
</html>