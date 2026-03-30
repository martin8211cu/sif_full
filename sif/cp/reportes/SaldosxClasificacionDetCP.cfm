<!--- 
	Modificado por Gustavo Fonseca Hernández.
		Fecha: 9-8-2005.
		Motivo: Se da tratamiento para que tome en cuenta los socios de negocios corporativos(Ecodigo is null)
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Hora 		= t.Translate('LB_Hora','Hora','SaldosxClasificacionResCP.cfm')>
<cfset LB_Fecha 	= t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_ClasifSA 	= t.Translate('LB_Clasif','Clasificación','SaldosxClasificacionCP.cfm')>
<cfset LB_Valor 	= t.Translate('LB_Valor','Valor','/sif/generales.xml')>
<cfset LB_SaldoTot 	= t.Translate('LB_SaldoTot','Saldo Total','SaldosxClasificacionResCP.cfm')>
<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>
<cfset LB_Totales 	= t.Translate('LB_Totales','Totales','SaldosxClasificacionResCP.cfm')>
<cfset LB_TotMon 	= t.Translate('LB_TotMon','Total Moneda','SaldosxClasificacionResCP.cfm')>
<cfset LB_Criterio 	= t.Translate('LB_Criterio','Criterio de Selección','SaldosxClasificacionResCP.cfm')>
<cfset LB_ClasifDesde	= t.Translate('LB_ClasifDesde','Valor Clasificación desde','SaldosxClasificacionCP.cfm')>
<cfset LB_ClasifHasta	= t.Translate('LB_ClasifHasta','Valor Clasificación hasta','SaldosxClasificacionCP.cfm')>
<cfset LB_Socio_Ini = t.Translate('LB_Socio_Ini','Socio de Negocios Inicial','SaldosxClasificacionResCP.cfm')>
<cfset LB_Socio_Fin = t.Translate('LB_Socio_Fin','Socio de Negocios Final','SaldosxClasificacionResCP.cfm')>
<cfset LB_OficIni	= t.Translate('LB_OficIni','Oficina Inicial','SaldosxClasificacionCP.cfm')>
<cfset LB_OficFin	= t.Translate('LB_OficFin','Oficina Final','SaldosxClasificacionCP.cfm')>
<cfset TIT_SaldoxClas 	= t.Translate('TIT_SaldoxClas','Saldos por Clasificación Proveedor (Detallado)')>
<cfset LB_CxP 		= t.Translate('LB_CxP','Cuentas por Pagar','SaldosxClasificacionResCP.cfm')>
<cfset MSG_LimREg 	= t.Translate('MSG_LimREg','Se han generado mas de 15000 registros para este reporte.','SaldosxClasificacionResCP.cfm')>
<cfset MSG_SeGen 	= t.Translate('MSG_SeGen','Se han generado')>
<cfset TIT_LimCons 	= t.Translate('TIT_LimCons','registros. Se limitó la consulta a 15,000 registros para este reporte.')>
<cfset LB_Debito 	= t.Translate('LB_Debito','Débito')>
<cfset LB_Credito 	= t.Translate('LB_Credito','Crédito')>
<cfset LB_FecDoc 	= t.Translate('LB_FecDoc','Fecha Doc.')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_FecVenc 	= t.Translate('LB_FecVenc','Fecha Venc.')>
<cfset LB_Tipo 		= t.Translate('LB_Tipo','Tipo','/sif/generales.xml')>
<cfset LB_Monto		= t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_Saldo 	= t.Translate('LB_Saldo','Saldo')>

<cfquery name="rsConsultaCorp" datasource="asp">
	select *
	from CuentaEmpresarial
	where Ecorporativa is not null
	  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#" >
</cfquery>
<cfif isdefined('session.Ecodigo') and 
	  isdefined('session.Ecodigocorp') and
	  session.Ecodigo NEQ session.Ecodigocorp and
	  rsConsultaCorp.RecordCount GT 0>
	  <cfset filtro = " h.Ecodigo=#session.Ecodigo# ">
<cfelse>
	  <cfset filtro = " h.Ecodigo is null ">						  
</cfif>

<cfquery name="rsReporte" datasource="#session.DSN#">
	select 	count(1) as Cantidad
	from SNClasificacionE h
		inner join SNClasificacionD g
		on g.SNCEid = h.SNCEid	
		<cfif isdefined('url.TClasif') and url.TClasif EQ 0>
			inner join SNClasificacionSN f
				on  f.SNCDid = g.SNCDid
		<cfelse>
			inner join SNClasificacionSND f
				on  f.SNCDid = g.SNCDid
		</cfif>			
			inner join SNegocios c
				on c.SNid = f.SNid

			inner join EDocumentosCP a
				on a.Ecodigo = c.Ecodigo
				and a.SNcodigo = c.SNcodigo
			<cfif isdefined('url.TClasif') and url.TClasif EQ 1>
				and a.id_direccion = f.id_direccion
			</cfif>			

			inner join CPTransacciones b
				on  b.Ecodigo = a.Ecodigo
				and b.CPTcodigo = a.CPTcodigo		

			inner join Monedas d
				on d.Mcodigo = a.Mcodigo

	where h.SNCEid = #url.SNCEid#
	  and c.Ecodigo = #session.Ecodigo#
	<cfif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1)) and isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
		and g.SNCDvalor between '#url.SNCDvalor1#' and '#url.SNCDvalor2#'
	<cfelseif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1))>
		and g.SNCDvalor >= '#url.SNCDvalor1#'
	<cfelseif isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
		and g.SNCDvalor <= '#url.SNCDvalor2#'
	</cfif>
	and #filtro#
	and a.EDsaldo <> 0
	<!--- Socio de negocios --->
	<cfif isdefined("url.SNnumero") and len(trim(url.SNnumero)) and isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2))>
		and c.SNnumero between '#url.SNnumero#' and '#url.SNnumerob2#'
	<cfelseif isdefined("url.SNnumero") and len(trim(url.SNnumero))>
		and c.SNnumero >= '#url.SNnumero#'
	<cfelseif isdefined("url.SNcodigob2") and len(trim(url.SNcodigob2))>
		and c.SNnumero <= '#url.SNnumerob2#'
	</cfif>
	<!--- Oficina --->
	<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo)) and isdefined("url.Ocodigo2") and len(trim(url.Ocodigo2))>
		and a.Ocodigo between #url.Ocodigo# and #url.Ocodigo2#
	<cfelseif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
		and a.Ocodigo >= #url.Ocodigo#
	<cfelseif isdefined("url.Ocodigo2") and len(trim(url.Ocodigo2))>
		and a.Ocodigo <=  '#url.Ocodigo2#'
	</cfif>
</cfquery>
<cfif isdefined("rsReporte") and rsReporte.Cantidad gt 15000>
	<cf_errorCode	code = "50348"
					msg  = "#MSG_SeGen# @errorDat_1@ #TIT_LimCons#"
					errorDat_1="#rsReporte.Cantidad#"
	>
	<cfabort>
</cfif>

<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="15001">
	select 	a.Ddocumento, 
			a.Dfecha,   
			a.Dfechavenc as Dvencimiento, 
			a.Dtotal,   
			a.EDsaldo as Dsaldo, 
			c.SNcodigo, 
			<cfif isdefined('url.TClasif') and url.TClasif EQ 0>
			c.SNnombre,  
			c.SNnumero, 
			c.SNidentificacion,
			<cfelse>
			coalesce(ds.SNDcodigo,c.SNnumero) as SNnumero,
			coalesce(ds.SNnombre,c.SNnombre) as SNnombre,
			'NA' as SNidentificacion,
			</cfif>
			case b.CPTtipo when 'D' then '#LB_Debito#' else '#LB_Credito#' end as CCTtipo, 
			b.CPTcodigo as CCTcodigo, 
			d.Mcodigo, 
			d.Mnombre,
			case b.CPTtipo when  'C' then +(a.EDsaldo)else -(a.EDsaldo)end as Dsaldodc,
			h.SNCEdescripcion, 
			h.SNCEid, 
			h.SNCEcodigo,  
			g.SNCDid, 
			g.SNCDvalor, 
			g.SNCDdescripcion
	from SNClasificacionE h
		inner join SNClasificacionD g
		on g.SNCEid = h.SNCEid	
		<cfif isdefined('url.TClasif') and url.TClasif EQ 0>
			inner join SNClasificacionSN f
				on  f.SNCDid = g.SNCDid
		<cfelse>
			inner join SNClasificacionSND f
				on  f.SNCDid = g.SNCDid
			inner join SNDirecciones ds
				on ds.SNid = f.SNid
				and ds.id_direccion = f.id_direccion
		</cfif>			
			inner join SNegocios c
				on c.SNid = f.SNid

			inner join EDocumentosCP a
				on a.Ecodigo = c.Ecodigo
				and a.SNcodigo = c.SNcodigo
 			<cfif isdefined('url.TClasif') and url.TClasif EQ 1>
				and a.id_direccion = f.id_direccion
			</cfif>
			inner join CPTransacciones b
				on  b.Ecodigo = a.Ecodigo
				and b.CPTcodigo = a.CPTcodigo		

			inner join Monedas d
				on d.Mcodigo = a.Mcodigo
	
	where h.SNCEid = #url.SNCEid#
	  and c.Ecodigo = #session.Ecodigo#
	<cfif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1)) and isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
		and g.SNCDvalor between '#url.SNCDvalor1#' and '#url.SNCDvalor2#'
	<cfelseif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1))>
		and g.SNCDvalor >= '#url.SNCDvalor1#'
	<cfelseif isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
		and g.SNCDvalor <= '#url.SNCDvalor2#'
	</cfif>
	and #filtro#
	and a.EDsaldo <> 0
	<!--- Socio de negocios --->
	<cfif isdefined("url.SNnumero") and len(trim(url.SNnumero)) and isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2))>
		and c.SNnumero between '#url.SNnumero#' and '#url.SNnumerob2#'
	<cfelseif isdefined("url.SNnumero") and len(trim(url.SNnumero))>
		and c.SNnumero >= '#url.SNnumero#'
	<cfelseif isdefined("url.SNcodigob2") and len(trim(url.SNcodigob2))>
		and c.SNnumero <= '#url.SNnumerob2#'
	</cfif>
	<!--- Oficina --->
	<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo)) and isdefined("url.Ocodigo2") and len(trim(url.Ocodigo2))>
		and a.Ocodigo between #url.Ocodigo# and #url.Ocodigo2#
	<cfelseif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
		and a.Ocodigo >= #url.Ocodigo#
	<cfelseif isdefined("url.Ocodigo2") and len(trim(url.Ocodigo2))>
		and a.Ocodigo <=  '#url.Ocodigo2#'
	</cfif>
	order by a.Mcodigo, g.SNCEid, g.SNCDvalor, c.SNnombre, a.SNcodigo
	<cfif isdefined("url.ordenarpor")>
		<cfif url.ordenarpor eq 'D' >
			,a.Ddocumento 
		<cfelse>
			,a.Dfecha
		</cfif>
	</cfif>
</cfquery>
<cfif isdefined("rsReporte") and rsReporte.recordcount gt 15000>
	<cf_errorCode	code = "50239" msg = "#MSG_LimREg#">
	<cfabort>
</cfif>
	
<!--- Busca la Empresa --->	
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>	
	
<!--- Busca descripción del Encabezado de la Clasificación --->

<cfquery name="rsConsultaCorp" datasource="asp">
	select *
	from CuentaEmpresarial
	where Ecorporativa is not null
	  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#" >
</cfquery>
<cfif isdefined('session.Ecodigo') and 
	  isdefined('session.Ecodigocorp') and
	  session.Ecodigo NEQ session.Ecodigocorp and
	  rsConsultaCorp.RecordCount GT 0>
	  <cfset filtro = " Ecodigo=#session.Ecodigo# ">
<cfelse>
	  <cfset filtro = " Ecodigo is null ">								  
</cfif>

<cfif isdefined("url.SNCEid") and len(trim(url.SNCEid))>
	<cfquery name="rsSNCEid" datasource="#session.DSN#">
		select SNCEdescripcion 
		from SNClasificacionE
		where #filtro#
		and SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
	</cfquery>
</cfif>

<!--- Busca descripción del Detalle 1 de la Clasificación --->
<cfif isdefined("url.SNCDid1") and len(trim(url.SNCDid1))>
	<cfquery name="rsSNCDid1" datasource="#session.DSN#">
		select SNCDdescripcion 
		from SNClasificacionD
		where SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCDid1#">
	</cfquery>
</cfif>

<!--- Busca descripción del Detalle 2 de la Clasificación --->
<cfif isdefined("url.SNCDid2") and len(trim(url.SNCDid2))>
	<cfquery name="rsSNCDid2" datasource="#session.DSN#">
		select SNCDdescripcion 
		from SNClasificacionD
		where SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCDid2#">
	</cfquery>
</cfif>

<!--- Busca nombre del Socio de Negocios 1 --->
<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo))>
	<cfquery name="rsSNcodigo" datasource="#session.DSN#">
		select SNnombre
		from SNegocios
		where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
		and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<!--- Busca nombre del Socio de Negocios 2 --->
<cfif isdefined("url.SNcodigob2") and len(trim(url.SNcodigob2))>
	<cfquery name="rsSNcodigob2" datasource="#session.DSN#">
		select SNnombre
		from SNegocios
		where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigob2#">
		and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<!--- Busca nombre de la Oficina 1 --->
<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
	<cfquery name="rsOcodigo" datasource="#session.DSN#">
		select Odescripcion
		from Oficinas
		where Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo#">
		and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<!--- Busca nombre de la Oficina 2 --->
<cfif isdefined("url.Ocodigo2") and len(trim(url.Ocodigo2))>
	<cfquery name="rsOcodigo2" datasource="#session.DSN#">
		select Odescripcion
		from Oficinas
		where Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo2#">
		and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<!--- Invoca el Reporte --->
	<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
		<cfset formatos = "flashpaper">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
		<cfset formatos = "pdf">
	</cfif>
	<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018 and formatos EQ "excel">
	  <cfset typeRep = 1>
	  <cfif formatos EQ "pdf">
		<cfset typeRep = 2>
	  </cfif>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
			isLink = False 
			typeReport = #typeRep#
			fileName = "cp.consultas.reportes.SaldosxClasificacionDetCP"
			headers = "empresa:#rsEmpresa.Edescripcion#"/>
	<cfelse>
		<cfreport format="#formatos#" template= "SaldosxClasificacionDetCP.cfr" query="rsReporte">
		<cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
			<cfreportparam name="Edescripcion" value="#rsEmpresa.Edescripcion#">
		</cfif>
		<cfif isdefined("rsSNCEid") and rsSNCEid.recordcount gt 0>
			<cfreportparam name="SNCEdescripcion" value="#rsSNCEid.SNCEdescripcion#">
		</cfif>
		<cfif isdefined("rsSNCDid1") and rsSNCDid1.recordcount gt 0>
			<cfreportparam name="SNCDdescripcion1" value="#rsSNCDid1.SNCDdescripcion#">
		</cfif>
		<cfif isdefined("rsSNCDid2") and rsSNCDid2.recordcount gt 0>
			<cfreportparam name="SNCDdescripcion2" value="#rsSNCDid2.SNCDdescripcion#">
		</cfif>
		
		<cfif isdefined("rsSNcodigo") and rsSNcodigo.recordcount gt 0>
			<cfreportparam name="SNcodigo" value="#rsSNcodigo.SNnombre#">
		</cfif>
		<cfif isdefined("rsSNcodigob2") and rsSNcodigob2.recordcount gt 0>
			<cfreportparam name="SNcodigob2" value="#rsSNcodigob2.SNnombre#">
		</cfif>
		
		<cfif isdefined("rsOcodigo") and rsOcodigo.recordcount gt 0>
			<cfreportparam name="Ocodigo" value="#rsOcodigo.Odescripcion#">
		</cfif>
		<cfif isdefined("rsOcodigo2") and rsOcodigo2.recordcount gt 0>
			<cfreportparam name="Ocodigo2" value="#rsOcodigo2.Odescripcion#">
		</cfif>
			<cfreportparam name="LB_Fecha" 		value="#LB_Fecha#">
			<cfreportparam name="LB_Hora" 		value="#LB_Hora#">
			<cfreportparam name="LB_Moneda" 	value="#LB_Moneda#">
			<cfreportparam name="LB_ClasifSA" 	value="#LB_ClasifSA#">
			<cfreportparam name="LB_Valor" 		value="#LB_Valor#">
			<cfreportparam name="LB_SaldoTot" 	value="#LB_SaldoTot#">
			<cfreportparam name="LB_SocioNegocio" 	value="#LB_SocioNegocio#">
		<cfreportparam name="LB_Totales" 	value="#LB_Totales#">
		<cfreportparam name="LB_TotMon" 	value="#LB_TotMon#">
		<cfreportparam name="LB_Criterio" 	value="#LB_Criterio#">
			<cfreportparam name="LB_ClasifDesde" 	value="#LB_ClasifDesde#">
			<cfreportparam name="LB_ClasifHasta" 	value="#LB_ClasifHasta#">
			<cfreportparam name="LB_Socio_Ini" 	value="#LB_Socio_Ini#">
			<cfreportparam name="LB_Socio_Fin" 	value="#LB_Socio_Fin#">
			<cfreportparam name="LB_OficIni" 	value="#LB_OficIni#">
			<cfreportparam name="LB_OficFin" 	value="#LB_OficFin#">
			<cfreportparam name="TIT_SaldoxClas" 	value="#TIT_SaldoxClas#">
			<cfreportparam name="LB_CxP" 		value="#LB_CxP#">
			<cfreportparam name="LB_Documento" 	value="#LB_Documento#">
			<cfreportparam name="LB_FecVenc" 	value="#LB_FecVenc#">
			<cfreportparam name="LB_Tipo" 		value="#LB_Tipo#">
			<cfreportparam name="LB_Monto" 		value="#LB_Monto#">
			<cfreportparam name="LB_Saldo" 		value="#LB_Saldo#">
	</cfreport>
</cfif>

