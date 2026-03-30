<!---
	Modificado por Gustavo Fonseca Hernández.
		Fecha: 9-8-2005.
		Motivo: Se da tratamiento para que tome en cuenta los socios de negocios corporativos(Ecodigo is null)
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Hora 	= t.Translate('LB_Hora','Hora')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Clasif 		= t.Translate('LB_Clasif','Clasificación','SaldosxClasificacionCP.xml')>
<cfset LB_Valor = t.Translate('LB_Valor','Valor','/sif/generales.xml')>
<cfset LB_SaldoTot 	= t.Translate('LB_SaldoTot','Saldo Total')>
<cfset MSG_Codigo 	= t.Translate('MSG_Codigo','Código','/sif/generales.xml')>
<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>
<cfset LB_Totales 	= t.Translate('LB_Totales','Totales')>
<cfset LB_TotMon 	= t.Translate('LB_TotMon','Total Moneda')>
<cfset LB_Criterio 	= t.Translate('LB_Criterio','Criterio de Selección')>
<cfset LB_ClasifDesde	= t.Translate('LB_ClasifDesde','Valor Clasificación desde','SaldosxClasificacionCP.cfm')>
<cfset LB_ClasifHasta	= t.Translate('LB_ClasifHasta','Valor Clasificación hasta','SaldosxClasificacionCP.cfm')>
<cfset LB_Socio_Ini = t.Translate('LB_Socio_Ini','Socio de Negocios Inicial')>
<cfset LB_Socio_Fin = t.Translate('LB_Socio_Fin','Socio de Negocios Final')>
<cfset LB_OficIni	= t.Translate('LB_OficIni','Oficina Inicial','SaldosxClasificacionCP.cfm')>
<cfset LB_OficFin	= t.Translate('LB_OficFin','Oficina Final','SaldosxClasificacionCP.cfm')>
<cfset TIT_SaldoxClas 	= t.Translate('TIT_SaldoxClas','Saldos por Clasificación Proveedor (Resumido)')>
<cfset LB_CxP 		= t.Translate('LB_CxP','Cuentas por Pagar')>

<cfquery name="rsConsultaCorp" datasource="asp">
	select *
	from CuentaEmpresarial
	where Ecorporativa is not null
	  and CEcodigo =  #Session.CEcodigo#
</cfquery>
<cfif isdefined('session.Ecodigo') and
	  isdefined('session.Ecodigocorp') and
	  session.Ecodigo NEQ session.Ecodigocorp and
	  rsConsultaCorp.RecordCount GT 0>
	  <cfset filtro = " f.Ecodigo= #session.Ecodigo# ">
<cfelse>
	  <cfset filtro = " f.Ecodigo is null ">
</cfif>

<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="15001">
	select 	min(a.Ddocumento) as Ddocumento,
			min(a.Dfecha) as Dfecha,
			sum(case b.CPTtipo when 'C' then +(a.EDsaldo) else -(a.EDsaldo) end) as Saldo_Total,
			min(h.Mnombre) as Mnombre,
			a.Mcodigo,
			min(f.SNCEdescripcion) as SNCEdescripcion,
			<cfif isdefined('url.TClasif') and url.TClasif Eq 0>
			a.SNcodigo,
			min(c.SNnombre) as SNnombre,
			min(c.SNidentificacion) as SNidentificacion,
			min(c.SNnumero) as SNnumero,
			<cfelse>
			min(coalesce(ds.SNnombre,c.SNnombre)) as SNnombre,
			min(coalesce(ds.SNcodigo,c.SNcodigo)) as SNcodigo,
			'NA' as SNidentificacion,
			min(coalesce(ds.SNDcodigo,c.SNnumero)) as SNnumero,
			</cfif>
			f.SNCEid,
			min(f.SNCEcodigo) as SNCEcodigo,
			e.SNCDid,
			min(e.SNCDvalor) as SNCDvalor,
			min(e.SNCDdescripcion) as SNCDdescripcion

	from EDocumentosCP a
		inner join CPTransacciones b
			on b.Ecodigo = a.Ecodigo
		   and b.CPTcodigo = a.CPTcodigo
		inner join SNegocios c
			on c.Ecodigo = a.Ecodigo
		   and c.SNcodigo = a.SNcodigo
	 <cfif isdefined('url.TClasif') and url.TClasif Eq 0>
		inner join SNClasificacionSN d
			on d.SNid = c.SNid
	  <cfelse>
		inner join SNDirecciones ds
			on ds.SNid = c.SNid
		   and ds.Ecodigo = c.Ecodigo
		   and ds.SNcodigo = c.SNcodigo
		   and ds.id_direccion = a.id_direccion
		 inner join SNClasificacionSND d
			on d.SNid = ds.SNid
		   and d.id_direccion = ds.id_direccion
		</cfif>
		 inner join SNClasificacionD e
			on e.SNCDid = d.SNCDid
		 inner join SNClasificacionE f
			on f.SNCEid = e.SNCEid
		inner join Monedas h
			on h.Mcodigo = a.Mcodigo
		   and h.Ecodigo = a.Ecodigo
	where #filtro#
		and a.Ecodigo =  #session.Ecodigo#
		and a.EDsaldo <> 0
		<!--- Clasificación --->
		<cfif isdefined("url.SNCEid") and len(trim(url.SNCEid))>
			and f.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
		</cfif>
		<!--- Valores de Clasificación
		<cfif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1)) and isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
			<cfif url.SNCDvalor1 gt url.SNCDvalor2> <!--- si el primero es mayor que el segundo. --->
				and e.SNCDvalor between <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor2#">
								 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor1#">
			<cfelse>
				and e.SNCDvalor between <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor1#">
								 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor2#">
			</cfif>
		<cfelseif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1))>
			and e.SNCDvalor >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor1#">
		<cfelseif isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
			and e.SNCDvalor <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor2#">
		</cfif>--->
		<!--- Socio de negocios --->
		<cfif isdefined("url.SNnumero") and len(trim(url.SNnumero)) and isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2))>
			<cfif url.SNnumero gt SNnumerob2><!--- si el primero es mayor que el segundo. --->
					and c.SNnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumerob2#">
										and <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumero#">
			<cfelse>
					and c.SNnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumero#">
										and <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumerob2#">
			</cfif>
		<cfelseif isdefined("url.SNnumero") and len(trim(url.SNnumero))>
			and c.SNnumero >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumero#">
		<cfelseif isdefined("url.SNcodigob2") and len(trim(url.SNcodigob2))>
			and c.SNnumero <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumerob2#">
		</cfif>

		<!--- Oficina --->
		<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo)) and isdefined("url.Ocodigo2") and len(trim(url.Ocodigo2))>
			<cfif url.Ocodigo gt url.Ocodigo2>
				and a.Ocodigo between <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ocodigo2#">
								  and <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ocodigo#">
			<cfelse>
				and a.Ocodigo between <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ocodigo#">
								  and <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ocodigo2#">
			</cfif>
		<cfelseif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
			and a.Ocodigo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ocodigo#">
		<cfelseif isdefined("url.Ocodigo2") and len(trim(url.Ocodigo2))>
			and a.Ocodigo <=  <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ocodigo2#">
		</cfif>

	group by a.Mcodigo, f.SNCEid, e.SNCDid, a.SNcodigo
	order by a.Mcodigo, f.SNCEid, e.SNCDid, a.SNcodigo
</cfquery>

<cfif isdefined("rsReporte") and rsReporte.recordcount gt 15000>
	<cfset MSG_LimREg 	= t.Translate('MSG_LimREg','Se han generado mas de 15000 registros para este reporte.')>
	<cf_errorCode	code = "50239" msg = "#MSG_LimREg#">
	<cfabort>
</cfif>

<cfif isdefined('session.Ecodigo') and
	  isdefined('session.Ecodigocorp') and
	  session.Ecodigo NEQ session.Ecodigocorp and
	  rsConsultaCorp.RecordCount GT 0>
	  <cfset filtro = " Ecodigo=#session.Ecodigo# ">
<cfelse>
	  <cfset filtro = " Ecodigo is null ">
</cfif>

<!--- Busca la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo =  #session.Ecodigo#
</cfquery>

<!--- Busca descripción del Encabezado de la Clasificación --->
<cfif isdefined("url.SNCEid") and len(trim(url.SNCEid))>
	<cfquery name="rsSNCEid" datasource="#session.DSN#">
		select SNCEdescripcion
		from SNClasificacionE
		where #filtro#
		 and SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
	</cfquery>
</cfif>

<!--- Busca descripción del Detalle 1 de la Clasificación --->
<!---
<cfif isdefined("url.SNCDid1") and len(trim(url.SNCDid1))>
	<cfquery name="rsSNCDid1" datasource="#session.DSN#">
		select SNCDdescripcion
		from SNClasificacionD
		where SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCDid1#">
	</cfquery>
</cfif>
 --->

<!--- Busca descripción del Detalle 2 de la Clasificación --->
<!--- <cfif isdefined("url.SNCDid2") and len(trim(url.SNCDid2))>
	<cfquery name="rsSNCDid2" datasource="#session.DSN#">
		select SNCDdescripcion
		from SNClasificacionD
		where SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCDid2#">
	</cfquery>
</cfif> --->

<!--- Busca nombre del Socio de Negocios 1 --->
<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo))>
	<cfquery name="rsSNcodigo" datasource="#session.DSN#">
		select SNnombre
		from SNegocios
		where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
		and Ecodigo =   #session.Ecodigo#
	</cfquery>
</cfif>

<!--- Busca nombre del Socio de Negocios 2 --->
<cfif isdefined("url.SNcodigob2") and len(trim(url.SNcodigob2))>
	<cfquery name="rsSNcodigob2" datasource="#session.DSN#">
		select SNnombre
		from SNegocios
		where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigob2#">
		and Ecodigo =   #session.Ecodigo#
	</cfquery>
</cfif>

<!--- Busca nombre de la Oficina 1 --->
<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
	<cfquery name="rsOcodigo" datasource="#session.DSN#">
		select Odescripcion
		from Oficinas
		where Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo#">
		and Ecodigo =   #session.Ecodigo#
	</cfquery>
</cfif>

<!--- Busca nombre de la Oficina 2 --->
<cfif isdefined("url.Ocodigo2") and len(trim(url.Ocodigo2))>
	<cfquery name="rsOcodigo2" datasource="#session.DSN#">
		select Odescripcion
		from Oficinas
		where Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo2#">
		and Ecodigo =   #session.Ecodigo#
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
		fileName = "cp.consultas.reportes.SaldosxClasificacionResCP"
		headers = "empresa:#rsEmpresa.Edescripcion#"/>
	<cfelse>
		<cfreport format="#formatos#" template= "SaldosxClasificacionResCP.cfr" query="rsReporte">
		<cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
			<cfreportparam name="Edescripcion" value="#rsEmpresa.Edescripcion#">
		</cfif>
		<cfif isdefined("rsSNCEid") and rsSNCEid.recordcount gt 0>
			<cfreportparam name="SNCEdescripcion" value="#rsSNCEid.SNCEdescripcion#">
		</cfif>
		<!---
	<cfif isdefined("rsSNCDid1") and rsSNCDid1.recordcount gt 0>
			<cfreportparam name="SNCDdescripcion1" value="#rsSNCDid1.SNCDdescripcion#">
		</cfif>

		<cfif isdefined("rsSNCDid2") and rsSNCDid2.recordcount gt 0>
			<cfreportparam name="SNCDdescripcion2" value="#rsSNCDid2.SNCDdescripcion#">
		</cfif>
	--->

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
			<cfreportparam name="LB_Clasif" 	value="#LB_Clasif#">
			<cfreportparam name="LB_Valor" 		value="#LB_Valor#">
			<cfreportparam name="LB_SaldoTot" 	value="#LB_SaldoTot#">
			<cfreportparam name="MSG_Codigo" 	value="#MSG_Codigo#">
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
	</cfreport>
</cfif>

