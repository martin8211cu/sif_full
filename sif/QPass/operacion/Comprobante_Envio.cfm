<cfparam name="form.irA" default="">
<cf_htmlReportsHeaders 
		title="Impresion de Comprobante de Envío" 
		filename="Traslado.xls"
		irA="#form.irA#"
		download="#form.irA NEQ ''#"
		preview="no"
		back = "#form.irA NEQ ''#"
		close= "#form.irA EQ ''#" 
		>
<cfif not isdefined("form.btnDownload")>  
	<cf_templatecss>
</cfif>
<cfif isDefined("Url.QPTid") >
  <cfset form.QPTid = Url.QPTid>
</cfif>

<cfif isDefined("Url.Imprimir")>
  <cfset form.Imprimir = Url.Imprimir>
</cfif>

<style type="text/css">
<!--
.style3 {font-size: 12px}
-->
</style>

<!---<cfset Fecha = DateFormat(Now(),"dd/mm/yyyy") & TimeFormat(Now()," hh:mm tt")>
--->	<cfquery name="rsEnc" datasource="#session.dsn#">
		select 
			coalesce(od.responsable,
				(
					select min(<cf_dbfunction name="concat" args="pD.Pnombre + ' ' + pD.Papellido1 + ' ' + pD.Papellido2 " delimiters = "+">)
					from QPassUsuarioOficina x
						inner join Usuario uD
							on x.Usucodigo = uD.Usucodigo
						inner join DatosPersonales pD 
							on pD.datos_personales = uD.datos_personales 
					where e.Ecodigo = x.Ecodigo
					  and e.OcodigoDest = x.Ocodigo
				)
			) as destino,
			e.QPTtrasDocumento,
			<cf_dbfunction name="concat" args="pO.Pnombre + ' ' + pO.Papellido1 + ' ' + pO.Papellido2 " delimiters = "+"> as usuarioOrigen,
			QPTtrasDocumento, 
			QPTtrasDescripcion, 
			oo.Ocodigo as OficinaO,  
			oo.Odescripcion as OficinaOri,
			od.Odescripcion as OficinaDest,
			od.Oficodigo as OficinaD, 
			e.BMFecha as Fecha
			from QPassTraslado e
				inner join Oficinas oo
					on oo.Ecodigo = e.Ecodigo
					and oo.Ocodigo = e.OcodigoOri
				inner join Usuario u
					on e.Usucodigo = u.Usucodigo
				inner join DatosPersonales pO 
					on pO.datos_personales = u.datos_personales 
				inner join Oficinas od
					on od.Ecodigo = e.Ecodigo
					and od.Ocodigo = e.OcodigoDest
			where e.QPTid = #form.QPTid#
		</cfquery>

	<cfquery name="rscantidad" datasource="#session.dsn#">
		select count(1) as cantidad 
			from QPassTrasladoOfi 
			where QPTid=#form.QPTid#
	</cfquery>

	<cfquery datasource="#session.DSN#" name="rsForm">
		select 
			x.QPEdescripcion,
			a.QPTEstadoActivacion, 
			l.QPLdescripcion,
			a.Ocodigo,
			a.QPTidTag, 
			l.QPLcodigo,
			a.QPTPAN, 
			a.QPTNumSerie
				from QPassTag a
				inner join QPassLote l
					on a.QPidLote = l.QPidLote
				inner join QPassTrasladoOfi b
					on a.QPTidTag  =b.QPTidTag 
				inner join QPassEstado x
					on a.QPidEstado = x.QPidEstado
			where a.Ecodigo = #session.Ecodigo#
			and b.QPTid = #form.QPTid#	
	</cfquery>
	<style type="text/css">
		 .RLTtopline {
		  border-bottom-width: 1px;
		  border-bottom-style: solid;
		  border-bottom-color:#000000;
		  border-top-color: #000000;
		  border-top-width: 1px;
		  border-top-style: solid;
		  
		 } 
	</style>
<cfoutput>
	<table align="center" width="100%" border="0" summary="ImpresioTraslado">
		
		<tr>
			<td align="center" valign="top" colspan="3"><strong>#session.Enombre#</strong></td>
		</tr>
		<tr>
			<td align="center" valign="top" colspan="3"><strong>Trasiego de dispositivos QuickPass</strong></td>
		</tr>
		<tr>
			<td align="center" valign="top" colspan="3"><strong>Documento: #rsEnc.QPTtrasDocumento#</strong></td>
		</tr>
		<tr>
			<td align="center" valign="top" colspan="3"><strong>&nbsp;</strong></td>
		</tr>

		<tr>
			<td align="left" nowrap="nowrap" colspan="2"></td>
		</tr>
		<tr>
			<td colspan="3">Fecha del trasiego: <strong> #DateFormat(rsEnc.Fecha,'dd/MM/yyyy')# #TimeFormat(rsEnc.Fecha, 'hh:mm:tt')#</strong></td>
		</tr>
		<tr>
			<td colspan="3">Desde: <strong>#rsEnc.OficinaOri#</strong></td>
		</tr>
		<tr>
			<td  colspan="2" >Responsable: <strong>#rsEnc.usuarioOrigen#</strong></td>
			<td align="right"><strong>Firma: _______________________</strong></td>
		</tr>

		<tr>
			<td colspan="3">Hacia: <strong>#rsEnc.OficinaDest#</strong></td>
		</tr>
		
		<tr>
			<td  colspan="2" >Responsable: <strong>#rsEnc.destino#</strong></td>
			<td align="right"><strong>Firma: _______________________</strong></td>
		</tr>
		<tr>
			<td></td>
		</tr>
		<tr>
			<td align="center" valign="top" colspan="3"><strong>&nbsp;</strong></td>
		</tr>
		<tr>
			<td align="center" valign="top" colspan="3"><strong>&nbsp;</strong></td>
		</tr>
			<td align="left"valign="top" colspan="3"><strong>Estado activaci&oacute;n:</strong> En traslado sucurcal/PuntoVenta</td>
		<tr>
			<td align="left" valign="top" colspan="3"><strong>Cantidad de dispositivos: [#rscantidad.cantidad#] </strong></td>
		</tr>
		<tr>
			<td align="center" valign="top" colspan="3"><strong>Detalle del Envío</strong></td>
		</tr>

		<tr>
			<td align="center" valign="top" colspan="3">&nbsp;</td>
		</tr>
		<tr>
			<td><strong>PAN</strong></td>
			<td><strong>Caja de empaque</strong></td>			
			<td><strong>Estado inventario</strong></td>
		</tr>
	<cfloop query="rsForm">
		<tr>
			<td><span class="style3">&nbsp;#rsForm.QPTPAN#</span></td>
			<td><span class="style3">#rsForm.QPLdescripcion#</span></td>			
			<td><span class="style3">#rsForm.QPEdescripcion#</span></td>
		</tr>	
	</cfloop>
		<tr>
			<td align="center" nowrap="nowrap" colspan="3"><span class="style3">****** Ultima Linea *******</span></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap" colspan="2"></td>
		</tr>
	
	</table>
</cfoutput>
