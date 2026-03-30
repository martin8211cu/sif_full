<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>Aplica Envio de Correo Garant&iacute; por vencer a la cola de envio de correos ASP</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<cfset start = Now()>
Iniciando proceso <cfoutput> #TimeFormat(start,"HH:MM:SS")#</cfoutput><br>
<cfsetting requesttimeout="1800">
<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="No"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>
<cfset res = setLocale("English (Canadian)")>
<cfheader name="Expires" value="0">
<cfheader name="Cache-control" value="no-cache">
<cfparam name="Session.Idioma" default="es_CR">
<cfquery name="rsEmpresaASP" datasource="asp">
	select distinct e.Ecodigo as EcodigoSDC, lower(c.Ccache) as dsn
	from Empresa e
		inner join Caches c on c.Cid=e.Cid
	 where e.Eactiva = 1
</cfquery>
<cfloop query="rsEmpresaASP">
	<cftry>
		<cfquery name="rsEmpresas" datasource="#rsEmpresaASP.dsn#">
			select e.Ecodigo, e.Edescripcion
			from Empresas e 
			where e.EcodigoSDC = #rsEmpresaASP.EcodigoSDC#
		</cfquery>
		<cfif  len(trim(rsEmpresaASP.dsn)) and len(trim(rsEmpresas.Ecodigo))>
			<cfset dias = ObtenerDato(1900,rsEmpresaASP.dsn,rsEmpresas.Ecodigo)>
			<cfset responsable = ObtenerDato(1950,rsEmpresaASP.dsn,rsEmpresas.Ecodigo)>
			<cfset correo = ObtenerDato(2100,rsEmpresaASP.dsn,rsEmpresas.Ecodigo)>
			<cfif len(trim(dias.Pvalor)) and len(trim(correo.Pvalor))>
				<cfset rs = ObtenerGarantias(dias.Pvalor,rsEmpresaASP.dsn,rsEmpresas.Ecodigo)>
				<cfif rs.Recordcount GT 0 and len(trim(dias.Pvalor))>
					<cfset hora=now()>
					<cfset texto='<table border="0" width="100%">
					<tr>
						<td>
							<strong>Sr(a) <cfoutput>#responsable.Pvalor#</cfoutput>,</strong><br><br>
						</td>
						<td align="right">
							Fecha de generaci&oacute;n del correo: <strong>#DateFormat(hora, "dd/mm/yyyy")# #TimeFormat(hora,'hh:mm tt')#</strong>.<br><br>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							&nbsp;&nbsp;&nbsp;Este correo es enviado de manera autom&aacute;tica por el sistema.<br><br>
							&nbsp;&nbsp;&nbsp;Las siguientes garant&iacute;as estan a <strong><cfoutput>#dias.Pvalor#</cfoutput> d&iacute;as de vencer</strong>:
						</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;
					  </td>
					</tr>
					<tr><td colspan="2"><table border="1" width="100%">
					<tr align="center" bgcolor="##99CC33"><td><strong>Num. Garant&iacute;a/Versi&oacute;n</strong></td><td><strong>Proveedor</strong></td><td><strong>Proceso/Linea</strong></td><td><strong>Monto</strong></td><td><strong>Banco</strong></td><td><strong>Fecha Vencimiento</strong></td><td><strong>Estado</strong></td></tr>
					'>
					<cfset i=0>
					<cfloop query="rs">
						<cfset texto&='<tr>
							<td align="center">
								#COEGReciboGarantia# / #COEGVersion#
							</td>
							<td align="center">
								#SNnombre#&nbsp;(#SNnumero#)
							</td>
							<td align="center">
								#CMPProceso# / #CMPLinea#</cfoutput>
							</td>
							<td align="right">
								#Msimbolo#&nbsp;#numberFormat(CODGMonto,',9.00')#
							</td>
							<td align="center">
								#Bdescripcion#</cfoutput>
							</td>
							<td align="center">
								#DateFormat(CODGFechaFin, "dd/mm/yyyy")#
							</td>
							<td align="center">
								#Estado#
							</td>
						</tr>'>
						<cfset i+=1>
					</cfloop>
					<cfset texto&='</table></td></tr>
					<tr>
						<td>
							<br><br>Empresa:&nbsp;<strong>#rsEmpresas.Edescripcion#</strong><br><br>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<br><strong>Total</strong> de garant&iacute;as a vencer: <strong>#i#</strong>.
						</td>
					</tr>
					<tr>
						<td>
							<br><strong>Si este correo a llegado por equivocaci&oacute;n le solicitamos eliminarlo.</strong>
						</td>
					</tr></table>'>	
					<cftransaction>
						<cfinvoke component="sif.Componentes.garantia"
							method="CORREO_GARANTIA"
							remitente="gestion@soin.co.cr"
							destinario="#correo.Pvalor#"
							asunto="Aviso vencimiento garantias."
							texto="#texto#"
							usuario="-1"
							returnvariable="LvarId"
						/>
					</cftransaction>
					<cfoutput>Correo enviado a Empresa:&nbsp;#rsEmpresas.Edescripcion#, email:&nbsp;#correo.Pvalor#<br></cfoutput>
				</cfif>
			</cfif>
		</cfif>
		<cfcatch>
			Ocurri&oacute; un Error en el Cache <cfoutput>#rsEmpresaASP.dsn#.</cfoutput><br>
			<cfdump var="#cfcatch#">
		</cfcatch>
	</cftry>
</cfloop>
<cfset finish = Now()>
<br>Proceso Terminado<cfoutput> #TimeFormat(finish,"HH:MM:SS")#</cfoutput>
</body>
</html>
<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" 	type="numeric" 	required="true">
	<cfargument name="Conexion" type="string" 	required="true">
	<cfargument name="Ecodigo" 	type="numeric" 	required="true">
	<cfquery name="rs" datasource="#Arguments.Conexion#">
		select Pvalor
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<cffunction name="ObtenerGarantias" returntype="query">
	<cfargument name="dias" 	type="numeric" 	required="true">	
	<cfargument name="Conexion" type="string" 	required="true">
	<cfargument name="Ecodigo" 	type="numeric" 	required="true">
	<cfquery name="rs" datasource="#Arguments.Conexion#">
		select  e.SNnumero,e.SNnombre,
				d.COTRCodigo, 
				c.Bdescripcion, 
				b.COEGReciboGarantia,b.COEGVersion,
				a.CODGid, a.COEGid, a.CODGMonto, a.CODGFechaFin,
				g.COTRCodigo, g.COTRDescripcion,
				f.Msimbolo,
				h.CMPProceso,h.CMPLinea,
				case b.COEGEstado
					when 1 then 'Vigente'
					when 2 then 'Edici&oacute;n'
					when 3 then 'En proceso de Ejecuci&oacute;n'
					when 4 then 'En Ejecuci&oacute;n'
					when 5 then 'Ejecutada'
					when 6 then 'En proceso Liberaci&oacute;n'
					when 7 then 'Liberada'
					when 8 then 'Devuelta'
				end as Estado
			from CODGarantia  a
				inner join COEGarantia b
					on b.COEGid =a.COEGid<!--- and b.COEGVersion = a.COEGVersion--->
				inner join Bancos c
					on c.Bid = a.Bid
				inner join COTipoRendicion d
					on d.COTRid = a.COTRid
				inner join SNegocios e
               	 	on e.SNid = b.SNid
                inner join Monedas f
                	on f.Mcodigo = a.CODGMcodigo
				inner join COTipoRendicion g
            		on g.COTRid = a.COTRid
				inner join CMProceso h
					on h.CMPid = b.CMPid
		where b.COEGVersionActiva = 1 <!--- Version activa --->
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			and <cf_dbfunction name="datediff" args="#now()#,a.CODGFechaFin" datasource="#Arguments.Conexion#"> = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.dias#">
		order by a.COEGid
	</cfquery>
	<cfreturn #rs#>
</cffunction>