<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<html>
<head>
<title>Ordenes de Compra</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
	<cfset title = "Orden de Compra">
	<cfinclude template="AREA_HEADER.cfm">
	<cfif isdefined("url.EOidorden") and url.EOidorden neq "" >
				
		<cfquery name="rsDatos" datasource="#session.dsn#">
			select 
				cm.EOidorden,
				eo.EOnumero as Orden,
				cm.DOlinea,
				coalesce(cm.DOmontoCancelado,0) as DOmontoCancelado,
				do.DOconsecutivo as Linea,
				(select Edescripcion from Empresas e where  e.Ecodigo = cm.Ecodigo) as Empresa,
				cantCancel,
				cm.Justificacion,
				cm.NAPAsociado,
				cm.fechaalta,
				(select Pnombre#_Cat#' '#_Cat#Papellido1#_Cat#' '#_Cat#Papellido2 
					from Usuario u  
						inner join DatosPersonales dp on u.datos_personales = dp.datos_personales
					where  Usucodigo = cm.BMUsucodigo) as Usuario
				
		from CMOrdenesCanceladas cm
			inner join EOrdenCM eo
				on eo.EOidorden = cm.EOidorden
				and eo.Ecodigo = cm.Ecodigo
			inner join DOrdenCM do
				on do.DOlinea = cm.DOlinea
				and do.EOidorden = eo.EOidorden
		where cm.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOidorden#">
			<cfif isdefined("url.DOlinea") and url.DOlinea neq "">
					and cm.DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DOlinea#">
			</cfif>
		</cfquery>

		<cf_templatecss>
			<table align="center" border="0" cellspacing="0" cellpadding="2" width="100%">
			<cfif rsDatos.recordcount gt 0>	
					<tr>
						<td align="center" class="tituloListas" ><strong>Orden</strong></td>
						<td align="center" class="tituloListas"><strong>Linea</strong></td>
						<td align="center" class="tituloListas"><strong>Justificaci&oacute;n</strong></td>
						<td align="center" class="tituloListas"><strong>Cant.<br/>Cancel</strong></td>
						<td align="center" class="tituloListas"><strong>Monto<br/>Cancel</strong></td>
						<td align="center" class="tituloListas"><strong>Fecha</strong></td>
						<td align="center" class="tituloListas"><strong>Usuario</strong></td>
						<!---<td><strong>Empresa</strong></td>--->
					</tr>	
					<cfoutput query="rsDatos">
						<tr>
							<td align="center">#rsDatos.Orden#</td>
							<td align="center">#rsDatos.Linea#</td>
							<td align="center">#rsDatos.Justificacion#</td>
							<td align="center">#rsDatos.cantCancel#</td>
							<td align="center">#rsDatos.DOmontoCancelado#</td>
							<td align="center"># LSDateFormat(rsDatos.fechaalta,"dd/mm/yyyy")#</td>
							<td align="center">#rsDatos.Usuario#</td>
							<!---<td align="center">#rsDatos.Empresa#</td>--->
						</tr>
					</cfoutput>
			<cfelse>
				<tr>
					<td colspan="6" align="center">No se encontraron registros de cancelaci&oacute;n para la orden escogida</td>
				</tr>
			</cfif>
				<tr>
					<td colspan="6"  align="center"><input name="button" type="button" class="btnNormal" onclick="window.close();" value="Cerrar" /></td>
				</tr>
			</table>
	</cfif>
	</body>
</html>
