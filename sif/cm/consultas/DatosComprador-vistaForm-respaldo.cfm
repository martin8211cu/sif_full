<!--- Consultas para pintar los datos del Reporte --->
<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">

<cfif isdefined("url.CMCid") and not isdefined("form.CMCid")>
	<cfset form.CMCid = Url.CMCid>
</cfif>

<cfquery name="rsComprador" datasource="#session.dsn#">
	select a.CMCid, a.CMCcodigo, a.CMCnombre, 
			b.DEtelefono1, b.DEtelefono2, b.DEemail   
	from CMCompradores a
		inner join DatosEmpleado b
			on a.Ecodigo = b.Ecodigo
			and a.DEid = b.DEid 	 
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">
</cfquery>

<cfquery name="rsIntegracion" datasource="#session.DSN#">
	select Pvalor 
	from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		and Pcodigo = 520
</cfquery>

<cfset checked   = "<img border='0' src='/cfmx/sif/imagenes/checked.gif'>" >
<cfset unchecked = "<img border='0' src='/cfmx/sif/imagenes/unchecked.gif'>" >
<cfquery name="qryLista" datasource="#session.dsn#">
	select 	a.ESnumero,
		   	a.CMTScodigo, 
			b.CMTSdescripcion,
			case when a.ESestado = -10 then 'En trámite de aprobación por rechazo'
				 when a.ESestado = 0 then 'Pendiente'
				 when a.ESestado = 10 then 'En espera de aprobación'
				 when a.ESestado = 20 then 'Solicitud aplicada'			 
				 when a.ESestado = 25 then 'Solicitud aplicada (OC Directa)'
				 when a.ESestado = 40 then 'Parcialmente Atendida'
				 when a.ESestado = 50 then 'Completamente Atendida'
				 when a.ESestado = 60 then 'Cancelada'
			end as Estado, 
			case b.CMTStarticulo when 1 then '#checked#' else '#unchecked#' end as CMTStarticulo,
			case b.CMTSservicio when 1 then '#checked#' else '#unchecked#' end as CMTSservicio,
			case b.CMTSactivofijo when 1 then '#checked#' else '#unchecked#' end as CMTSactivofijo,
			case b.CMTScompradirecta when 1 then '#checked#' else '#unchecked#' end as CMTScompradirecta,
			c.Mnombre,
			b.CMTSmontomax
	from ESolicitudCompraCM a
			inner join CMTiposSolicitud b
				on a.Ecodigo = b.Ecodigo
				and a.CMTScodigo = b.CMTScodigo
			inner join Monedas c
				on b.Ecodigo = c.Ecodigo
				and b.Mcodigo = c.Mcodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">
</cfquery>

<cfsavecontent variable="encabezado1">
	<cfoutput>
		<tr><td nowrap colspan="9" class="tituloIndicacion"><strong>Datos del Comprador </strong></td></tr>
  		<tr><td nowrap colspan="9">&nbsp;</td></tr> 
		<tr>
			<td nowrap colspan="9">
				<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="2">
					<tr valign="top">
						<td nowrap align="right"><strong>Comprador&nbsp;:&nbsp;</strong></td>
						<td nowrap>#rsComprador.CMCcodigo# - #rsComprador.CMCnombre#</td>
						<td nowrap align="right"><strong>Fecha Consulta&nbsp;:&nbsp;</strong></td>
						<td nowrap>#LSDateFormat(Now(), 'dd/mm/yyyy')#</td>
					</tr>
					<tr valign="top">
						<td nowrap align="right"><strong>Tel&eacute;fono&nbsp;:&nbsp;</strong></td>
						<cfif rsIntegracion.Pvalor EQ 'N'>
							<cfset rh = sec.getUsuarioByRef (rsComprador.CMCid, session.EcodigoSDC, 'CMCompradores') >
							<td nowrap>#rh.Pcasa#</td>
						<cfelse>
							<td nowrap>#rsComprador.DEtelefono1#</td>
						</cfif>
						<td nowrap align="right"><strong>Hora&nbsp;:&nbsp;</strong></td>
						<td nowrap>#TimeFormat(Now(),'medium')#</td>
					</tr>
					<tr valign="top">
						<cfif rsIntegracion.Pvalor EQ 'N'>
							<cfset rh = sec.getUsuarioByRef (rsComprador.CMCid, session.EcodigoSDC, 'CMCompradores') >
							<td nowrap align="right"><strong>Fax&nbsp;:&nbsp;</strong></td>
							<td nowrap>#rh.Pfax#</td>
							<td nowrap align="right"><strong>E-mail&nbsp;:&nbsp;</strong></td>
							<td nowrap>#rh.Pemail1#</td>
						<cfelse>
							<td nowrap align="right"><strong>Fax&nbsp;:&nbsp;</strong></td>
							<td nowrap>#rsComprador.DEtelefono2#</td>
							<td nowrap align="right"><strong>E-mail&nbsp;:&nbsp;</strong></td>
							<td nowrap>#rsComprador.DEemail#</td>
						</cfif>
					</tr>
				</table>
			</td>
		</tr>
  		<tr><td nowrap colspan="9">&nbsp;</td></tr> 
		<tr><td nowrap colspan="9" class="tituloIndicacion"><strong>Solicitudes Asociadas al Comprador</strong></td></tr>
		<tr valign="baseline">
			<td nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black;">Solicitud</td>
			<td nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">Descripci&oacute;n</td>
			<td nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">Estado</td>
			<td nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;" align="center">Activo</td>
			<td nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;" align="center">Art&iacute;culo</td>
			<td nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;" align="center">Servicio</td>
			<td nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;" align="center">Compra<br>Directa </td>
			<td nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;" align="center">Moneda</td>
			<td nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;" align="right" >Monto M&aacute;ximo </td> 
		</tr>
	</cfoutput>
</cfsavecontent>

<cfoutput>
	<cfinclude template="AREA_HEADER.cfm"><br>
	<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="2">
		<cfif qryLista.RecordCount EQ 0>
			#encabezado1#
		</cfif>
		
		<cfif qryLista.RecordCount GT 0>
			<cfloop query="qryLista">
				<cfif currentRow mod 35 EQ 1>
					<cfif currentRow NEQ 1>
						<tr class="pageEnd"><td colspan="8">&nbsp;</td></tr>
					</cfif>
					#encabezado1#
				</cfif>

				<tr class="<cfif qryLista.CurrentRow mod 2>listaNon<cfelse>listaPar</cfif>">
					<td nowrap style="padding-right: 5px; border-bottom: 1px solid black;">&nbsp;#qryLista.ESnumero#&nbsp;</td>
					<td nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#trim(qryLista.CMTScodigo)# - #qryLista.CMTSdescripcion#&nbsp;</td>
					<td nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#qryLista.Estado#&nbsp;</td>
					<td nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;" align="center">&nbsp;#qryLista.CMTStarticulo#&nbsp;</td>
					<td nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;" align="center">&nbsp;#qryLista.CMTSservicio#&nbsp;</td>
					<td nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;" align="center">&nbsp;#qryLista.CMTSactivofijo#&nbsp;</td> 
					<td nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;" align="center">&nbsp;#qryLista.CMTScompradirecta#&nbsp;</td>
					<td nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;" align="center">&nbsp;#qryLista.Mnombre#&nbsp;</td>
					<td nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;" align="right" >&nbsp;#LSCurrencyFormat(qryLista.CMTSmontomax,'none')#&nbsp;</td> 
				</tr>
			</cfloop>
			<tr><td colspan="9" nowrap>&nbsp;</td></tr>
			<tr><td colspan="9" nowrap align="center" class="listaCorte"><strong>&nbsp;--- Fin de la Consulta ---&nbsp;</strong></td></tr>
		<cfelse>
			<tr><td colspan="9" nowrap>&nbsp;</td></tr>				
			<tr class="<cfif qryLista.CurrentRow mod 2>listaNon<cfelse>listaPar</cfif>">
				<td colspan="9" align="center" class="listaCorte"><strong>&nbsp;--- No hay Solicitudes Asociadas al Comprador ---&nbsp;</strong></td>
			</tr>
		</cfif>
	</table>
</cfoutput>
