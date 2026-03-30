<cfif isdefined('url.FechaDesde') and not isdefined('form.FechaDesde')>
	<cfset form.FechaDesde = url.FechaDesde>
</cfif>	

<cfif isdefined('url.FechaHasta') and not isdefined('form.FechaHasta')>
	<cfset form.FechaHasta = url.FechaHasta>
</cfif>	

<cfif not isdefined('form.dependencias')>
	<cfset form.dependencias = ''>
</cfif>	

<cfif isdefined('url.CFid') and not isdefined('form.CFid')>
	<cfset form.CFid = url.CFid>
</cfif>	

<cfif isdefined("form.CFid") and #form.CFid# NEQ ''  >
	<cfquery name="rsCFuncional" datasource="#session.DSN#">
		select CFpath
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
	</cfquery>
	<cfset vRuta = rsCFuncional.CFpath >
</cfif>	

<cfquery name="rsReporte" datasource="#session.DSN#">
	select  
		<cf_dbfunction name="concat" args="DE.DEapellido1,' ',DE.DEapellido2,'  ',DE.DEnombre"> as DEnombre,
		DE.DEidentificacion,
		CF.CFdescripcion,
		RHP.RHPdescpuesto,
		CF.CFcodigo,
		coalesce(ltrim(rtrim(RHP.RHPcodigoext)),ltrim(rtrim(RHP.RHPcodigo))) as RHPcodigo,
		LT.LTsalario as Salario,
		DE.DEfechanac,
		coalesce(ve.EVfantig,ve.EVfecha) as Antiguedad,
		Banc.Bid,
		Banc.Bdescripcion as Banco,
		DE.DEcuenta as Cuenta,
		case when DE.CBTcodigo = 0 then 'Corriente' else 'Ahorro' end as TipoCuenta,
		CBcc as cuentaCliente
	from LineaTiempo LT
		inner join DatosEmpleado DE
		on DE.DEid = LT.DEid
			LEFT OUTER JOIN Bancos Banc
			ON Banc.Bid = DE.Bid
		inner join RHPlazas RHPL
			inner join CFuncional CF
			on CF.CFid = RHPL.CFid
		on RHPL.RHPid = LT.RHPid
		inner join  RHPuestos RHP
		on RHP.RHPcodigo = LT.RHPcodigo
		and RHP.Ecodigo = LT.Ecodigo
		inner join EVacacionesEmpleado ve
			on ve.DEid = DE.DEid
	where LT.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaHasta)#"> between LTdesde and LThasta
	<cfif isdefined("form.CFid") and #form.CFid# NEQ ''  >
		<cfif #form.dependencias# NEQ ''>
			and (upper(CF.CFpath) like '#ucase(vRuta)#/%' or CF.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">)
		<cfelse>
			and CF.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">				
		</cfif>
	</cfif>
	order by  #form.OrderBy#
</cfquery>

<!----================ PINTA EL REPORTE ================---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteGeneraldeEmpleadosResumido" Default="Reporte General de Empleados Resumido" returnvariable="LB_ReporteGeneraldeEmpleadosResumido"/>
<cfinclude template="generalEmpleadosResumido-html.cfm">
