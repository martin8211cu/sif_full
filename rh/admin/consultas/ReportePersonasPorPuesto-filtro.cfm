<!--- --------------------------------------------- --->
<!--- Archivo: 	ReportePersonasPorPuesto-filtro.cfm --->
<!--- Hecho:	Randall Colomer Villalta            --->
<!--- Fecha:	17 Mayo del 2005                    --->
<!--- --------------------------------------------- --->

<cfif isdefined("url.CFid") and len(trim(url.CFid)) and isdefined("url.dependencias")>
	<cfquery name="rsCFuncional" datasource="#session.DSN#">
		select CFpath
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
	</cfquery>
	<cfset vRuta = rsCFuncional.CFpath >
</cfif>

<cfquery name="rsPersonasPuesto" datasource="#session.dsn#">	
	select 	cf.CFid,
			rtrim(cf.CFcodigo) as CFcodigo, 
			cf.CFdescripcion, 
			de.DEid, 
			de.DEidentificacion, 
			{fn concat(de.DEapellido1,{fn concat(' ', {fn concat(de.DEapellido2,{fn concat(' ' ,de.DEnombre)})})})} as nombre,
			pu.RHPcodigo as codpuesto, 
			pu.RHPdescpuesto, 
			pl.RHPid, 
			{fn concat(rtrim(pl.RHPcodigo),{fn concat(' - ', pl.RHPdescripcion)})} as plaza,
			e.Edescripcion
	from DatosEmpleado de
		inner join LineaTiempo lt		
			on de.DEid = lt.DEid
			and de.Ecodigo = lt.Ecodigo
		inner join CFuncional cf
			on cf.Ecodigo = lt.Ecodigo
			<cfif isdefined("vRuta")>
				and ( upper(cf.CFpath) like '#ucase(vRuta)#/%' or cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">)
			<cfelseif isdefined("url.CFid") and len(trim(url.CFid))>
				and cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
			</cfif>
		inner join RHPuestos pu
			on lt.Ecodigo = pu.Ecodigo
			and lt.RHPcodigo = pu.RHPcodigo
			<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo))>
				and pu.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHPcodigo#">
			</cfif>

		inner join 	RHPlazas pl
			on lt.RHPid = pl.RHPid
			and lt.Ecodigo = pl.Ecodigo
			and pl.CFid = cf.CFid
			and pl.Ecodigo = cf.Ecodigo
		inner join 	Empresas e	 	
			on e.Ecodigo = lt.Ecodigo		
	where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between lt.LTdesde and lt.LThasta
	order by CFdescripcion, RHPdescpuesto, nombre
</cfquery>
<cfreport format="flashpaper" template="ReportePersonasPorPuesto.cfr" query="rsPersonasPuesto">
</cfreport>

