<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 06 de marzo del 2006
	Motivo: Agregar el parámetro del Titulo del reporte segun el filtro de Clasificación por dirección.
			Se creo un nuevo reporte .cfr para cuando se selecciona por direccion.

	Modificado por Gustavo Fonseca Hernández.
		Fecha: 9-8-2005.
		Motivo: Se da tratamiento para que tome en cuenta los socios de negocios corporativos(Ecodigo is null)
	Modificado por Gustavo Fonseca Hernández.
		Fecha: 11-10-2005.
		Motivo: Se arregla los filtros de Socio de negocio y valores de clasificación que antes se hacían por SNcodigo, SNCDid y Ocodigo (estaba mal) y quedó con SNnumero, SNCDvalor y Oficodigo.
		También se arregló para que filtrara los socios de negocios por empresa.
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Hora 	= t.Translate('LB_Hora','Hora')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Cobrador 	= t.Translate('LB_Cobrador','Cobrador')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_ClasifSA 		= t.Translate('LB_Clasif','Clasificación')>
<cfset LB_Valor = t.Translate('LB_Valor','Valor','/sif/generales.xml')>
<cfset LB_SaldoTot 	= t.Translate('LB_SaldoTot','Saldo Total')>
<cfset MSG_Codigo 	= t.Translate('MSG_Codigo','Código','/sif/generales.xml')>
<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>
<cfset LB_Totales 	= t.Translate('LB_Totales','Totales')>
<cfset LB_TotMon 	= t.Translate('LB_TotMon','Total Moneda')>
<cfset LB_Criterio 	= t.Translate('LB_Criterio','Criterio de Selección')>
<cfset BTN_Clasificacion = t.Translate('BTN_Clasificacion','Clasificación','/sif/generales.xml')>
<cfset LB_ClasifDesde	= t.Translate('LB_ClasifDesde','Valor Clasificación desde')>
<cfset LB_ClasifHasta	= t.Translate('LB_ClasifHasta','Valor Clasificación hasta')>
<cfset LB_Socio_Ini = t.Translate('LB_Socio_Ini','Socio de Negocios Inicial')>
<cfset LB_Socio_Fin = t.Translate('LB_Socio_Fin','Socio de Negocios Final')>
<cfset LB_OficIni		= t.Translate('LB_OficIni','Oficina Inicial')>
<cfset LB_OficFin		= t.Translate('LB_OficFin','Oficina Final')>

<cfquery name="rsConsultaCorp" datasource="asp">
	select *
	from CuentaEmpresarial
	where Ecorporativa is not null
	  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
</cfquery>
<cfif isdefined('session.Ecodigo') and isdefined('session.Ecodigocorp') and session.Ecodigo NEQ session.Ecodigocorp and rsConsultaCorp.RecordCount GT 0>
	  <cfset filtro = " f.Ecodigo=#session.Ecodigo# ">
<cfelse>
	  <cfset filtro = " f.Ecodigo is null ">								  
</cfif>

<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="5001">
	select sum(case b.CCTtipo when 'D' then +(a.Dsaldo) else -(a.Dsaldo) end) as Saldo_Total, 
		min(g.Edescripcion) as Edescripcion, 
		min(h.Mnombre) as Mnombre, a.Mcodigo, 
		min(f.SNCEdescripcion) as SNCEdescripcion, 
		min(c.SNidentificacion) as SNidentificacion, f.SNCEid, 
		min(f.SNCEcodigo) as SNCEcodigo, e.SNCDid,
		min(e.SNCDvalor) as SNCDvalor, min(e.SNCDdescripcion) as SNCDdescripcion
		<cfif isdefined('url.TClasif') and url.TClasif EQ 1>
			,min(coalesce(ds.SNnombre,c.SNnombre)) as SNnombre, 
			min(coalesce(ds.SNDcodigo,c.SNnumero)) as SNnumero		
		<cfelse>
			,min(c.SNnombre) as SNnombre, 	
			min(c.SNnumero) as SNnumero 
		</cfif>
	 from SNegocios c
        inner join Documentos a 
			on a.Ecodigo = c.Ecodigo 
         	and a.SNcodigo = c.SNcodigo
		<cfif isdefined('url.TClasif') and url.TClasif Eq 0><!---Cl. socios--->
			inner join SNClasificacionSN d
					on d.SNid = c.SNid
		<cfelse>											<!---Cl. Dirección de Socio--->
            	inner join SNDirecciones ds                
			 on ds.Ecodigo = a.Ecodigo
			 and ds.SNcodigo = a.SNcodigo
			 and ds.id_direccion = a.id_direccionFact	 
		inner join SNClasificacionSND d
			on d.SNid = ds.SNid
			and d.id_direccion = ds.id_direccion
		</cfif>	
		<cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>
		inner join DatosEmpleado gg
			on gg.DEid = c.DEidCobrador
		</cfif>	
		inner join SNClasificacionD e
                    	on e.SNCDid = d.SNCDid 
		inner join SNClasificacionE f 
			on f.SNCEid = e.SNCEid 
        inner join CCTransacciones b
        on b.Ecodigo = a.Ecodigo
		and b.CCTcodigo = a.CCTcodigo
		inner join Empresas g
			on g.Ecodigo = a.Ecodigo
		inner join Monedas h
			on h.Mcodigo = a.Mcodigo
			and h.Ecodigo = a.Ecodigo
		inner join Oficinas o
			on o.Ecodigo = a.Ecodigo
			and o.Ocodigo = a.Ocodigo
	where #filtro#
		and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.Dsaldo <> 0
		<!--- Cobrador --->
		<cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>
				and gg.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEidCobrador#">
		</cfif>
		<!--- Clasificación --->
		<cfif isdefined("url.SNCEid") and len(trim(url.SNCEid))>
			and f.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
		</cfif>
		<!--- Valores de Clasificación --->
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
			and rtrim(ltrim(e.SNCDvalor)) <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor2)#"> 
		</cfif>
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
		<cfelseif isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2))>
			and c.SNnumero <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumerob2#">
		</cfif>
		
		<!--- Oficina --->
		<cfif isdefined("url.Oficodigo") and len(trim(url.Oficodigo)) and isdefined("url.Oficodigo2") and len(trim(url.Oficodigo2))>
			<cfif url.Oficodigo gt url.Oficodigo2>
				and o.Oficodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo2#">
								  and <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo#">
			<cfelse>
				and o.Oficodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo#">
								  and <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo2#">
			</cfif>
		<cfelseif isdefined("url.Oficodigo") and len(trim(url.Oficodigo))>
			and o.Oficodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo#">
		<cfelseif isdefined("url.Oficodigo2") and len(trim(url.Oficodigo2))>
			and o.Oficodigo <=  <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo2#">
		</cfif>
	group by a.Mcodigo, f.SNCEid, e.SNCDid, a.SNcodigo
	order by a.Mcodigo, f.SNCEid, e.SNCDid, a.SNcodigo
</cfquery>

<cfset MSG_LimREg 	= t.Translate('MSG_LimREg','Se han generado mas de 5000 registros para este reporte.')>
<cfif isdefined("rsReporte") and rsReporte.recordcount gt 5000>
	<cf_errorCode	code = "50196" msg = "#MSG_LimREg#">
	<cfabort>
</cfif>

<!--- Busca descripción del Encabezado de la Clasificación --->
<cfif isdefined("url.SNCEid") and len(trim(url.SNCEid))>
	<cfquery name="rsSNCEid" datasource="#session.DSN#">
		select SNCEdescripcion 
		from SNClasificacionE
		where SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
		and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
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
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	  <cfset typeRep = 1>
	  <cfif formatos EQ "pdf">
		<cfset typeRep = 2>
	  </cfif>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "cc.reportes.SaldosxClasificacionRes"/>
	<cfelse>
	<cfreport format="#formatos#" template= "SaldosxClasificacionRes.cfr" query="rsReporte">
	<cfif isdefined("rsSNCEid") and rsSNCEid.recordcount gt 0>
		<cfreportparam name="SNCEdescripcion" value="#rsSNCEid.SNCEdescripcion#">
	</cfif>
	<cfif isdefined("rsSNCDid1") and rsSNCDid1.recordcount gt 0>
		<cfreportparam name="SNCDdescripcion1" value="#rsSNCDid1.SNCDdescripcion#">
	</cfif>
	
	<cfif isdefined("rsSNCDid2") and rsSNCDid2.recordcount gt 0>
		<cfreportparam name="SNCDdescripcion2" value="#rsSNCDid2.SNCDdescripcion#">
	</cfif>
	<cfif isdefined("url.Cobrador") and len(trim(url.Cobrador)) eq 0>
		<cfset url.cobrador = 'Todos'>
	</cfif>
	<cfreportparam name="Cobrador" value="#url.Cobrador#">
	
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
	<cfif isdefined("url.TClasif") and url.TClasif EQ 0>
		<cfset TIT_SalXClas = t.Translate('TIT_SalXClas','Saldos por Clasificación: Resumido por Socio')>
		<cfreportparam name="Titulo" value="#TIT_SalXClas#">
	<cfelse>
		<cfset TIT_SalXClas = t.Translate('TIT_SalXClas','Saldos por Clasificación: Resumido por Dirección')>
		<cfreportparam name="Titulo" value="#TIT_SalXClas#">
	</cfif>
	<cfreportparam name="TClasif" value="#url.TClasif#">
    <cfreportparam name="LB_Fecha" 		value="#LB_Fecha#">
    <cfreportparam name="LB_Hora" 		value="#LB_Hora#">
    <cfreportparam name="LB_Cobrador" 	value="#LB_Cobrador#">
    <cfreportparam name="LB_Moneda" 	value="#LB_Moneda#">
    <cfreportparam name="LB_ClasifSA" 	value="#LB_ClasifSA#">
    <cfreportparam name="LB_Valor" 		value="#LB_Valor#">
    <cfreportparam name="LB_SaldoTot" 	value="#LB_SaldoTot#">
    <cfreportparam name="MSG_Codigo" 	value="#MSG_Codigo#">
    <cfreportparam name="LB_SocioNegocio" 	value="#LB_SocioNegocio#">
	<cfreportparam name="LB_Totales" 	value="#LB_Totales#">
	<cfreportparam name="LB_TotMon" 	value="#LB_TotMon#">
	<cfreportparam name="LB_Criterio" 	value="#LB_Criterio#">
    <cfreportparam name="BTN_Clasificacion" 	value="#BTN_Clasificacion#">
    <cfreportparam name="LB_ClasifDesde" 	value="#LB_ClasifDesde#">
    <cfreportparam name="LB_ClasifHasta" 	value="#LB_ClasifHasta#">
    <cfreportparam name="LB_Socio_Ini" 	value="#LB_Socio_Ini#">
    <cfreportparam name="LB_Socio_Fin" 	value="#LB_Socio_Fin#">
    <cfreportparam name="LB_OficIni" 	value="#LB_OficIni#">
    <cfreportparam name="LB_OficFin" 	value="#LB_OficFin#">
</cfreport>
</cfif>

