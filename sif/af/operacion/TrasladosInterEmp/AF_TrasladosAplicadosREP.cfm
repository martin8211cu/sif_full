<cfquery name="rsReporte" datasource="#session.dsn#">
	select 
	x.AFMovsDescripcion,
	x.AFMovsExplicacion,
	x.AFMovsPeriodo,
	case x.AFMovsMes 
	when 1 then  'Enero'
	when 2 then  'Febrero'
	when 3 then  'Marzo'
	when 4 then  'Abril'
	when 5 then  'Mayo'
	when 6 then  'Junio'
	when 7 then  'julio'
	when 8 then  'Agosto'
	when 9 then  'Setiembre'
	when 10 then 'Octubre'
	when 11 then 'Noviembre'
	when 12 then 'Diciembre'
	end as AFMovsMes,	
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Enombre#"> as Destino,
	b.Enombre Origen,
	AFRdescripcion  as Razon,
	{fn concat({fn concat({fn LTRIM({fn RTRIM(c.Aplaca)})} , ' - ' )},  c.Adescripcion )} as Activo,
	{fn concat({fn concat({fn LTRIM({fn RTRIM(l.ACcodigodesc)})} , ' - ' )},  l.ACdescripcion )} as Categoria,
	{fn concat({fn concat({fn LTRIM({fn RTRIM(m.ACcodigodesc)})} , ' - ' )},  m.ACdescripcion  )} as Clase,
	{fn concat({fn concat({fn LTRIM({fn RTRIM(n.CFcodigo)})} , ' - ' )},  n.CFdescripcion  )} as CentroFuncional,
	a.AFMovsDSaldoAdq,
	a.AFMovsDSaldoRev,
	a.AFMovsDSaldoMej,
	(a.AFMovsDSaldoAdq + a.AFMovsDSaldoRev + a.AFMovsDSaldoMej) as total,
	a.AFMovsDVidaUtil,
	a.AFMovsVUusado

from AFMovsEmpresasD a
	inner join Empresa b
		on 	a.Ecodigo_O = b.Ereferencia
		and CEcodigo = #session.CEcodigo#

	inner join Activos c
		on a.Aid = c.Aid
		and a.Ecodigo_O = c.Ecodigo

	inner join AFRetiroCuentas e
		on a.AFRmotivo = e.AFRmotivo
		and a.Ecodigo_O = e.Ecodigo

	inner join ACategoria l
		on  a.ACcodigo = l.ACcodigo
		and a.Ecodigo = l.Ecodigo

	inner join AClasificacion m
		on  a.ACcodigo = m.ACcodigo
		and a.ACid = m.ACid
		and a.Ecodigo = m.Ecodigo

	inner join CFuncional n
		on  a.CFid  = n.CFid 
		and a.Ecodigo = n.Ecodigo

	inner join AFMovsEmpresasE x
		on  x.Ecodigo = a.Ecodigo
		and x.AFMovsID = a.AFMovsID
	where a.AFMovsID  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AFMovsID#">
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

	order by b.Enombre, c.Aplaca
</cfquery>

<cfif isdefined("url.Formato") and url.Formato eq "xls">
	<cf_exportQueryToFile query="#rsReporte#" separador="#chr(9)#" filename="Reporte_De_Trasalados_Activos_Empresas_#session.Usucodigo#_#LSDateFormat(Now(),'ddmmyyyy')#_#LSTimeFormat(Now(),'hh:mm:ss')#.txt" jdbc="false">
<cfelse>
    <cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	  <cfset typeRep = 1>
	  <cfif url.Formato EQ "pdf">
		<cfset typeRep = 2>
	  </cfif>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "af.consultas.AF_TrasladosAplicadosREP"/>
	<cfelse>
	<cfreport format="#url.Formato#" template= "AF_TrasladosAplicadosREP.cfr" query="rsReporte">
	</cfreport>
	</cfif>
</cfif>