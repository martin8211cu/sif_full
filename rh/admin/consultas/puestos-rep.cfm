<!--- FORMATO: html/pdf/xls --->
<cfif isdefined("url.tipo1")>
 	<cfset url.tipo = 1>
<cfelseif isdefined("url.tipo2")>
	 	<cfset url.tipo = 0>
</cfif>

<cfif url.tipo eq 0>
	<cfset reporte_id = "valoracionpuestosd.cfr">
<cfelse>
	<cfset reporte_id = "valoracionpuestosr.cfr">

</cfif>

<cfquery name="rsjasper" datasource="#session.dsn#">
		select porcSP as ptstotal
		from RHPuestos
		where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfset ptstotala = rsjasper.ptstotal>

<cfset fecha = dateformat(#now()#,"DD/MM/YYYY")>

<cfquery name="rsReporte" datasource="#session.DSN#">
	select	Edescripcion , RHPdescpuesto,
		HYHEcodigo, HYHGcodigo, HYIHgrado, ptsHabilidad,
		HYMRcodigo,HYCPgrado, porcSP, ptsSP, #fecha# as fecha,
		HYLAcodigo, HYMgrado, HYIcodigo, ptsResp,
		coalesce(ptsTotal,-9999) as ptotal, ptsTotal,
		HYHEvalor,
		HYHGvalor,
		HYCPvalor,
		HYLAvalor,
		HYMvalor,
		HYIvalor,
		RHPcodigo
	from RHPuestos a, Empresas b
	where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.Ecodigo = b.Ecodigo
	and a.RHPactivo = 1
	<cfif isdefined('url.RHTPid') and LEN(TRIM(url.RHTPid))>
	and a.RHTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHTPid#">
	</cfif>
	<cfif isdefined('url.CFid') and LEN(TRIM(url.CFid))>
	and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
	</cfif>
	order by ptotal  desc
</cfquery>

<cfreport format="#url.formato#" template= "#reporte_id#" query="rsReporte">
	<cfreportparam name="fecha1" value="#fecha#">
	<cfreportparam name="ptstotala" value="#ptstotala#">
	<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
</cfreport>

