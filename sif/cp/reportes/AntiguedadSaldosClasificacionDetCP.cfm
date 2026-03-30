 <!---
	Creado  por Gustavo Fonseca H.
		Fecha: 13-5-2005.
		Motivo: Nuevo reporte de Antigüedad de Saldos por Clasificación para CxP (Detallado)
	Modificado por Gustavo Fonseca Hernández.
		Fecha: 9-8-2005.
		Motivo: Se da tratamiento para que tome en cuenta los socios de negocios corporativos(Ecodigo is null)
	Modificado por Gustavo Fonseca Hernández.
		Fecha: 11-10-2005.
		Motivo: Se filtra los socios por empresa.
--->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset MSG_DefPer1 = t.Translate('MSG_DefPer1','Debe definir el primer período en los parámetros.')>
<cfset MSG_DefPer2 = t.Translate('MSG_DefPer2','Debe definir el segundo período en los parámetros')>
<cfset MSG_DefPer3 = t.Translate('MSG_DefPer3','Debe definir el tercer período en los parámetros')>
<cfset MSG_DefPer4 = t.Translate('MSG_DefPer4','Debe definir el cuarto período en los parámetros')>


<cf_dbfunction name="now" returnvariable="hoy">
<cf_dbfunction name="date_part"	args="mm, d.Dfecha" returnvariable="mmDfecha">
<cf_dbfunction name="date_part"	args="mm, #hoy#" returnvariable="mmHoy">
<cfquery name="rsParametros1" datasource="#session.DSN#">
		select Pvalor as p1
		from Parametros
		where Ecodigo =  #session.Ecodigo#
			and Pcodigo = 310
	</cfquery>
	<cfif isdefined("rsParametros1") and rsParametros1.recordcount gt 0>
		<cfset p1 = rsParametros1.p1>
	<cfelse>
		<cf_errorCode	code = "50178" msg = "#MSG_DefPer1#">
	</cfif>

	<cfquery name="rsParametros2" datasource="#session.DSN#">
		select Pvalor as p2
		from Parametros
		where Ecodigo =  #session.Ecodigo#
			and Pcodigo = 320
	</cfquery>

	<cfif isdefined("rsParametros2") and rsParametros2.recordcount gt 0>
		<cfset p2 = rsParametros2.p2>
	<cfelse>
		<cf_errorCode	code = "50179" msg = "#MSG_DefPer2#">
	</cfif>

	<cfquery name="rsParametros3" datasource="#session.DSN#">
		select Pvalor as p3
		from Parametros
		where Ecodigo =  #session.Ecodigo#
			and Pcodigo = 330
	</cfquery>
	<cfif isdefined("rsParametros3") and rsParametros3.recordcount gt 0>
		<cfset p3 = rsParametros3.p3>
	<cfelse>
		<cf_errorCode	code = "50180" msg = "#MSG_DefPer3#">
	</cfif>

	<cfquery name="rsParametros4" datasource="#session.DSN#">
		select Pvalor as p4
		from Parametros
		where Ecodigo =  #session.Ecodigo#
			and Pcodigo = 340
	</cfquery>
	<cfif isdefined("rsParametros4") and rsParametros4.recordcount gt 0>
		<cfset p4 = rsParametros4.p4>
	<cfelse>
		<cf_errorCode	code = "50181" msg = "#MSG_DefPer4#">
	</cfif>

<cfoutput>

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
	  <cfset filtro = " ec.Ecodigo=#session.Ecodigo# ">
<cfelse>
	  <cfset filtro = " ec.Ecodigo is null ">
</cfif>
<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="5001">
select
	 ec.SNCEdescripcion,
	 ec.SNCEcodigo,
	 m.Mnombre,
	 dc.SNCDvalor,
	 dc.SNCDdescripcion,
	 <cfif isdefined('url.TClasif') and url.TClasif EQ 0>
	 s.SNnombre,
	 s.SNnumero as SNnumero,
	 <cfelse>
	 coalesce(snd.SNnombre,s.SNnombre) as SNnombre,
	 coalesce(snd.SNDcodigo, s.SNnumero) as SNnumero,
	 </cfif>
	 d.Dfecha,
	 d.Dfechavenc as Dvencimiento,
	 d.CPTcodigo as CCTcodigo,
	 d.Ddocumento,
	 d.Ocodigo,
	 d.Dtotal * case when t.CPTtipo = 'C' then 1.00 else -1.00 end as Total,
	 d.EDsaldo * case when t.CPTtipo = 'C' then 1.00 else -1.00 end as Saldo,

	case when
		d.Dfechavenc >= #hoy#
		and #PreserveSingleQuotes(mmDfecha)# = #PreserveSingleQuotes(mmHoy)#
		then EDsaldo else 0.00 end * case when t.CPTtipo = 'C' then 1.00 else -1.00 end
		as Corriente,
	case when
		d.Dfechavenc >= #hoy#
		and #PreserveSingleQuotes(mmDfecha)# <> #PreserveSingleQuotes(mmHoy)#
		then EDsaldo else 0.00 end * case when t.CPTtipo = 'C' then 1.00 else -1.00 end
		as SinVencer,
	case when
		<cf_dbfunction name="datediff" args="d.Dfechavenc, #hoy#">
		between 1 and <cfqueryparam cfsqltype="cf_sql_integer" value="#p1#">
		then EDsaldo else 0.00 end * case when t.CPTtipo = 'C' then 1.00 else -1.00 end
		as P1,
	case when
		  <cf_dbfunction name="datediff" args="d.Dfechavenc, #hoy#"> between <cfqueryparam cfsqltype="cf_sql_integer" value="#p1 + 1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#p2#">
		  then EDsaldo else 0.00 end * case when t.CPTtipo = 'C' then 1.00 else -1.00 end
		  as P2,
	 case when
		  <cf_dbfunction name="datediff" args="d.Dfechavenc, #hoy#"> between <cfqueryparam cfsqltype="cf_sql_integer" value="#p2 + 1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#p3#">
		  then EDsaldo else 0.00 end * case when t.CPTtipo = 'C' then 1.00 else -1.00 end
		  as P3,
	 case when
		  <cf_dbfunction name="datediff" args="d.Dfechavenc, #hoy#"> between <cfqueryparam cfsqltype="cf_sql_integer" value="#p3 + 1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#p4#">
		  then EDsaldo else 0.00 end * case when t.CPTtipo = 'C' then 1.00 else -1.00 end
		  as P4,
	 case when
		  <cf_dbfunction name="datediff" args="d.Dfechavenc, #hoy#"> > <cfqueryparam cfsqltype="cf_sql_integer" value="#p4#">
		  then EDsaldo else 0.00 end * case when t.CPTtipo = 'C' then 1.00 else -1.00 end
		  as P5,
	 case when
		  d.Dfechavenc < #hoy#
		  then EDsaldo else 0.00 end * case when t.CPTtipo = 'C' then 1.00 else -1.00 end
		  as Morosidad

	from SNClasificacionE ec
	inner join SNClasificacionD dc
		on ec.SNCEid = dc.SNCEid
		<!--- Valores de Clasificación --->
		<cfif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1)) and isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
			<cfif url.SNCDvalor1 gte url.SNCDvalor2> <!--- si el primero es mayor que el segundo. --->
				and upper(dc.SNCDvalor) between <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(url.SNCDvalor2)#">
								 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(url.SNCDvalor1)#">
			<cfelse>
				and upper(dc.SNCDvalor) between <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(url.SNCDvalor1)#">
								 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(url.SNCDvalor2)#">
			</cfif>
		<cfelseif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1))>
			and upper(dc.SNCDvalor) >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor1#">
		<cfelseif isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
			and upper(dc.SNCDvalor) <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(url.SNCDvalor2)#">
		</cfif>
	<cfif isdefined('url.TClasif') and url.TClasif EQ 1>
		inner join SNClasificacionSND cs
			on dc.SNCDid = cs.SNCDid
		inner join SNDirecciones snd
			on snd.SNid = cs.SNid
			and snd.id_direccion = cs.id_direccion
	<cfelse>
		inner join SNClasificacionSN cs
			on dc.SNCDid = cs.SNCDid
	</cfif>
	inner join SNegocios s
		on s.SNid = cs.SNid
		<!--- Socio de negocios --->
		<cfif isdefined("url.SNnumero") and len(trim(url.SNnumero)) and isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2))>
			<cfif url.SNnumero gte SNnumerob2><!--- si el primero es mayor que el segundo. --->
					and upper(s.SNnumero) between <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(url.SNnumero)#">
										and <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumerob2#">
			<cfelse>
					and upper(s.SNnumero) between <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(url.SNnumero)#">
										and <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(url.SNnumerob2)#">
			</cfif>
		<cfelseif isdefined("url.SNnumero") and len(trim(url.SNnumero))>
			and upper(s.SNnumero) >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumero#">
		<cfelseif isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2))>
			and upper(s.SNnumero) <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumerob2#">
		</cfif>
	inner join EDocumentosCP d
		on d.Ecodigo = s.Ecodigo
		and d.SNcodigo = s.SNcodigo
		and d.EDsaldo <> 0.00
	inner join CPTransacciones t
		on t.Ecodigo = d.Ecodigo
		and t.CPTcodigo = d.CPTcodigo
	inner join Monedas m
		on m.Mcodigo = d.Mcodigo
		and m.Ecodigo = d.Ecodigo
	inner join Oficinas o
		on o.Ecodigo = d.Ecodigo
		and o.Ocodigo = d.Ocodigo
		<!--- Oficina --->
		<cfif isdefined("url.Oficodigo") and len(trim(url.Oficodigo)) and isdefined("url.Oficodigo2") and len(trim(url.Oficodigo2))>
			<cfif url.Oficodigo gt url.Oficodigo2>
				and o.Oficodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo2#">
								  and <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo#">
			<cfelse>
				and o.Oficodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo#">
								  and <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo2#">
			</cfif>
		<cfelseif isdefined("url.Ocodigo") and len(trim(url.Oficodigo))>
			and o.Oficodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo#">
		<cfelseif isdefined("url.Ocodigo2") and len(trim(url.Oficodigo2))>
			and o.Oficodigo <=  <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo2#">
		</cfif>
	where #filtro#
	  and ec.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
	  and s.Ecodigo=  #session.Ecodigo#

	order by d.Mcodigo, ec.SNCEid, dc.SNCDid,  s.SNnombre

</cfquery>


</cfoutput>
<cfif isdefined("rsReporte") and rsReporte.recordcount gt 5000>
    <cfset MSG_GeneraMas5000 = t.Translate('MSG_GeneraMas5000','Se han generado mas de 5000 registros para este reporte.')>
	<cf_errorCode	code = "50196" msg = "#MSG_GeneraMas5000#">
	<cfabort>
</cfif>

<!--- Busca descripción del Encabezado de la Clasificación --->
<cfif isdefined("url.SNCEid") and len(trim(url.SNCEid))>
	<cfquery name="rsSNCEid" datasource="#session.DSN#">
		select SNCEdescripcion
		from SNClasificacionE
		where SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
		and Ecodigo =   #session.Ecodigo#
	</cfquery>
</cfif>

<!--- Busca descripción del Detalle 1 de la Clasificación --->
<!--- <cfif isdefined("url.SNCDid1") and len(trim(url.SNCDid1))>
	<cfquery name="rsSNCDid1" datasource="#session.DSN#">
		select SNCDdescripcion
		from SNClasificacionD
		where SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCDid1#">
	</cfquery>
</cfif> --->

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

<!--- Busca nombre de la Empresa --->
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion
		from Empresas
		where Ecodigo =   #session.Ecodigo#
	</cfquery>

<!--- Invoca el Reporte --->
	<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
		<cfset formatos = "flashpaper">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
		<cfset formatos = "pdf">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 3>
		<cfset formatos = "excel">
	</cfif>

    <cfset LB_CuentasporPagar = t.Translate('LB_CuentasporPagar','Cuentas por Pagar')>
    <cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
    <cfset LB_Hora = t.Translate('LB_Hora','Hora')>
    <cfset LB_Cobrador = t.Translate('LB_Cobrador','Cobrador')>
    <cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
	<cfset LB_Valor = t.Translate('LB_Valor','Valor','/sif/generales.xml')>
    <cfset LB_Codigo = t.Translate('LBR_CODIGO','Código','/sif/generales.xml')>
	<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocios','/sif/generales.xml')>
    <cfset LB_Corriente = t.Translate('LB_Corriente','Corriente')>
	<cfset LB_SinVencer = t.Translate('LB_SinVencer','Sin Vencer')>
	<cfset LB_121omas = t.Translate('LB_151omas','121 o mas')>
	<cfset LB_Morosidad = t.Translate('LB_Morosidad','Morosidad')>
	<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo')>
    <cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
	<cfset LB_Criterio = t.Translate('LB_Criterio','Criterios de Selección:')>
	<cfset LB_Clasificacion = t.Translate('LB_Clasificacion','Clasificación')>
	<cfset LB_ValorClasDesde = t.Translate('LB_ValorClasDesde','Valor Clasificación desde')>
	<cfset LB_ValorClasHasta = t.Translate('LB_ValorClasHasta','Valor Clasificación hasta')>
	<cfset LB_SocioNegocioI = t.Translate('LB_SocioNegocioI','Socio de Negocios Inicial')>
    <cfset LB_SocioNegocioF = t.Translate('LB_SocioNegocioF','Socio de Negocios Final')>
    <cfset LB_OficinaInicial = t.Translate('LB_OficinaInicial','Oficina Inicial')>
    <cfset LB_OficinaFinal = t.Translate('LB_OficinaFinal','Oficina Final')>
	<cfset LB_Hasta = t.Translate('LB_a','a')>
	<cfset LB_Totales 	= t.Translate('LB_Totales','Totales')>
    <cfset LB_TotMoneda = t.Translate('LB_TotMoneda','Total Moneda')>
	<cfset LB_omas = t.Translate('LB_omas',' o más')>
	<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
	<cfset LB_Fecha_Vence = t.Translate('LB_Fecha_Vence','Fecha Venc.','/sif/generales.xml')>

<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018 and  formatos eq "excel">
	  <cfset typeRep = 1>
	 
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "cp.consultas.reportes.AntiguedadSaldosxClasDetCP"
		headers = "empresa:#rsEmpresa.Edescripcion#"/>
	<cfelse>
	<cfreport format="#formatos#" template= "AntiguedadSaldosxClasDetCP.cfr" query="rsReporte">
	<cfif isdefined("rsSNCEid") and rsSNCEid.recordcount gt 0>
		<cfreportparam name="SNCEdescripcion" value="#rsSNCEid.SNCEdescripcion#">
	</cfif>
	<!--- <cfif isdefined("rsSNCDid1") and rsSNCDid1.recordcount gt 0>
		<cfreportparam name="SNCDdescripcion1" value="#rsSNCDid1.SNCDdescripcion#">
	</cfif>

	<cfif isdefined("rsSNCDid2") and rsSNCDid2.recordcount gt 0>
		<cfreportparam name="SNCDdescripcion2" value="#rsSNCDid2.SNCDdescripcion#">
	</cfif> --->

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
	<cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
		<cfreportparam name="Empresa" value="#rsEmpresa.Edescripcion#">
	</cfif>
	<cfif isdefined("P1")>
		<cfreportparam name="P1" value="#P1#">
	</cfif>
	<cfif isdefined("P2")>
		<cfreportparam name="P2" value="#P2#">
	</cfif>
	<cfif isdefined("P3")>
		<cfreportparam name="P3" value="#P3#">
	</cfif>
	<cfif isdefined("P4")>
		<cfreportparam name="P4" value="#P4#">
	</cfif>
	<cfif isdefined("url.TClasif") and url.TClasif EQ 0>
		<cfset LB_TituloRep = t.Translate('LB_TituloDetxSoc','Antigüedad de Saldos por Clasificación: Detallado por Socio')>
		<cfreportparam name="Titulo" value="#LB_TituloRep#">
	<cfelse>
		<cfset LB_TituloRep = t.Translate('LB_TituloDetxDir','Antigüedad de Saldos por Clasificación: Detallado por Dirección')>
		<cfreportparam name="Titulo" value="#LB_TituloRep#">
	</cfif>
	<cfreportparam name="TClasif" value="#url.TClasif#">
    <cfreportparam name="LB_CuentasporPagar" value="#LB_CuentasporPagar#">
    <cfreportparam name="LB_Fecha" value="#LB_Fecha#">
    <cfreportparam name="LB_Hora" value="#LB_Hora#">
    <cfreportparam name="LB_Moneda" value="#LB_Moneda#">
    <cfreportparam name="LB_Clasificacion" value="#LB_Clasificacion#">
    <cfreportparam name="LB_Valor" value="#LB_Valor#">
    <cfreportparam name="LB_Corriente" value="#LB_Corriente#">
    <cfreportparam name="LB_SinVencer" value="#LB_SinVencer#">
    <cfreportparam name="LB_Morosidad" value="#LB_Morosidad#">
    <cfreportparam name="LB_Saldo" value="#LB_Saldo#">
    <cfreportparam name="LB_Criterio" value="#LB_Criterio#">
    <cfreportparam name="LB_ValorClasDesde" value="#LB_ValorClasDesde#">
    <cfreportparam name="LB_ValorClasHasta" value="#LB_ValorClasHasta#">
    <cfreportparam name="LB_OficinaInicial" value="#LB_OficinaInicial#">
    <cfreportparam name="LB_OficinaFinal" 	value="#LB_OficinaFinal#">
    <cfreportparam name="LB_Codigo" value="#LB_Codigo#">
    <cfreportparam name="LB_SocioNegocio" value="#LB_SocioNegocio#">
    <cfreportparam name="LB_SocioNegocioI" value="#LB_SocioNegocioI#">
    <cfreportparam name="LB_SocioNegocioF" value="#LB_SocioNegocioF#">
    <cfreportparam name="LB_Hasta" value="#LB_Hasta#">
    <cfreportparam name="LB_Totales" value="#LB_Totales#">
    <cfreportparam name="LB_TotMoneda" value="#LB_TotMoneda#">
    <cfreportparam name="LB_omas" value="#LB_omas#">
    <cfreportparam name="LB_Documento" value="#LB_Documento#">
    <cfreportparam name="LB_Fecha_Vence" value="#LB_Fecha_Vence#">

  </cfreport>
</cfif>
