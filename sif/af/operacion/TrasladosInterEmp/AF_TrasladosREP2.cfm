<cfquery name="rsReporte" datasource="#session.dsn#">
	select 
	x.AFMovsDescripcion,
	x.AFMovsExplicacion,
	<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#session.Enombre#"> as Destino,
	b.Enombre Origen,
	AFRdescripcion  as Razon,
	{fn concat({fn concat({fn LTRIM({fn RTRIM(c.Aplaca)})} , ' - ' )},  c.Adescripcion )} as Activo,
	{fn concat({fn concat({fn LTRIM({fn RTRIM(l.ACcodigodesc)})} , ' - ' )},  l.ACdescripcion )} as Categoria,
	{fn concat({fn concat({fn LTRIM({fn RTRIM(m.ACcodigodesc)})} , ' - ' )},  m.ACdescripcion  )} as Clase,
	{fn concat({fn concat({fn LTRIM({fn RTRIM(n.CFcodigo)})} , ' - ' )},  n.CFdescripcion  )} as CentroFuncional
	from AFMovsEmpresasD a
	inner join Empresa b
		on 	a.Ecodigo_O = b.Ereferencia
		and CEcodigo = #session.CEcodigo#
	inner join Activos c
		on a.Aid = c.Aid
		and a.Ecodigo_O = c.Ecodigo
	inner join AFSaldos d
		on a.Aid = d.Aid
		and a.Ecodigo_O = d.Ecodigo
<!---and d.AFSperiodo =  (  select convert(integer,p.Pvalor) from Parametros p 
			   where p.Ecodigo = a.Ecodigo_O
			   and p.Pcodigo = 50)
		and d.AFSmes     =  (  select convert(integer,m.Pvalor)  from Parametros m 
			   where m.Ecodigo = a.Ecodigo_O
			   and m.Pcodigo = 60)--->	
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
	
	and d.AFSperiodo =  (  select <cf_dbfunction name="to_integer" args="p.Pvalor"> from Parametros p 
							   where p.Ecodigo = a.Ecodigo_O
							   and p.Pcodigo = 50)
	and d.AFSmes     =  (  select <cf_dbfunction name="to_integer" args="m.Pvalor"> from Parametros m 
							where m.Ecodigo = a.Ecodigo_O
							and m.Pcodigo = 60)
	order by b.Enombre, c.Aplaca
</cfquery>

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
		fileName = "af.consultas.AF_TrasladosREP"/>
	<cfelse>
<cfreport format="#url.Formato#" template= "AF_TrasladosREP.cfr" query="rsReporte">
</cfreport>
</cfif>
