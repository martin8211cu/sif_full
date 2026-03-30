<cfif isdefined("url.dependencias")>
	<cfinvoke component="rh.Componentes.RH_Funciones" method="CFDependencias"
		CFid = "#url.CFid#"
		Nivel = 5
		returnvariable="Dependencias"/>
	<cfset Centros = ValueList(Dependencias.CFid)>
</cfif>

<cfquery name="reporte" datasource="#Session.DSN#">
	select {fn concat({fn concat(rtrim(d.CFcodigo) , ' - ' )},  d.CFdescripcion )}  as Centro,
		   {fn concat({fn concat({fn concat({fn concat(a.DEapellido1 , ' ' )}, a.DEapellido2 )}, ' ' )}, a.DEnombre )} as NombreCompleto,
		   e.RHAfecha, 
		   case when e.RHAtipo = 1 then '<cf_translate key="LB_Positivo">Positivo</cf_translate>' else '<cf_translate key="LB_Negativo">Negativo</cf_translate>' end as impacto,
		   e.RHAdescripcion
	from DatosEmpleado a
		 inner join LineaTiempo b
			on b.DEid = a.DEid
			and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between b.LTdesde and b.LThasta
		 inner join RHPlazas c
			on c.RHPid = b.RHPid
		 inner join CFuncional d
			on d.CFid = c.CFid
		<cfif isdefined('url.dependencias')>
			and d.CFid in (#Centros#)
		<cfelseif isdefined("url.CFid") and Len(Trim(url.CFid))>
			and c.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
		</cfif>
		 inner join RHAnotaciones e
			on e.DEid = a.DEid
		<cfif isdefined("url.Fdesde") and Len(Trim(url.Fdesde)) and isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
			and e.RHAfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fhasta)#">
		<cfelseif isdefined("url.Fdesde") and Len(Trim(url.Fdesde))>
			and e.RHAfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fdesde)#">
		<cfelseif isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
			and e.RHAfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fhasta)#">
		</cfif>
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfif isdefined("url.DEid") and Len(Trim(url.DEid))>
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	</cfif>
	order by d.CFcodigo, a.DEid, e.RHAfecha
</cfquery>
<cfset DescRangoFechas = "">
<cfif isdefined("url.Fdesde") and Len(Trim(url.Fdesde)) and isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
	<cfset DescRangoFechas = "Rango de Fechas: Desde #LSDateFormat(url.Fdesde,'dd/mm/yyyy')# Hasta #LSDateFormat(url.Fhasta,'dd/mm/yyyy')#">
<cfelseif isdefined("url.Fdesde") and Len(Trim(url.Fdesde))>
	<cfset DescRangoFechas = "Rango de Fechas: Desde #LSDateFormat(url.Fdesde,'dd/mm/yyyy')#">
<cfelseif isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
	<cfset DescRangoFechas = "Rango de Fechas: Hasta #LSDateFormat(url.Fhasta,'dd/mm/yyyy')#">
</cfif>

<cfreport format="#url.formato#" template= "anotaciones.cfr" query="reporte">
	<cfreportparam name="Edescripcion" value="#Session.Enombre#">
	<cfreportparam name="DescRangoFechas" value="#DescRangoFechas#">
</cfreport>
