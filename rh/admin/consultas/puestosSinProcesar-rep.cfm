<!--- FORMATO: html/pdf/xls --->
<cfif isdefined("url.tipo1")>
 	<cfset url.tipo = 1>
<cfelseif isdefined("url.tipo2")>
	 	<cfset url.tipo = 0>
</cfif>

<cfif url.tipo eq 0>
	<cfset reporte_id = "valoracionpuestosdSinP.cfr">
<cfelse>
	<cfset reporte_id = "valoracionpuestosrSinP.cfr">
</cfif>

<cfquery name="rsjasper" datasource="#session.dsn#">
	select porcSP as ptstotal
	from RHPuestos
	where Ecodigo= 1
</cfquery>

<cfset ptstotala = rsjasper.ptstotal>

<cfset fecha = dateformat(#now()#,"DD/MM/YYYY")>

<cfquery name="rsReporte" datasource="#session.DSN#">
	select he.HYERVid,hd.RHPcodigo,
		Edescripcion , RHPdescpuesto,
		HYERVdescripcion,
		hd.HYHEcodigo, hd.HYHGcodigo, hd.HYIHgrado, hd.ptsHabilidad,
		hd.HYMRcodigo,hd.HYCPgrado, hd.porcSP, hd.ptsSP, #fecha# as fecha,
		hd.HYLAcodigo,hd.HYMgrado, hd.HYIcodigo, hd.ptsResp,
		coalesce(hd.ptsTotal,-9999) as ptotal, hd.ptsTotal,
		(select RHPcodigo
		from RHPuestos x
		where x.Ecodigo = hd.Ecodigo
		  and x.RHPcodigo = hd.RHPcodigo
		  and (x.HYLAcodigo != hd.HYLAcodigo
		   or coalesce(x.HYMgrado,0) != hd.HYMgrado
		   or coalesce(x.HYIcodigo,'') != hd.HYIcodigo
		   or coalesce(x.HYHEcodigo,'') != hd.HYHEcodigo
		   or coalesce(x.HYHGcodigo,'') != hd.HYHGcodigo 
		   or coalesce(x.HYIHgrado,0) != hd.HYIHgrado 
		   or coalesce(x.HYCPgrado,0) != hd.HYCPgrado
		   or coalesce(x.HYMRcodigo,'') != hd.HYMRcodigo
		   or coalesce(x.ptsHabilidad,0) != hd.ptsHabilidad
		   or coalesce(x.ptsSP,0) != hd.ptsSP
		   or coalesce(x.porcSP,0) != hd.porcSP
		   or coalesce(x.ptsResp,0) != hd.ptsResp
		   or coalesce(x.ptsTotal,0) != hd.ptsTotal
		   or coalesce(x.HYperfilnivel,'') != hd.HYperfilnivel
		   or coalesce(x.HYperfilvalor,0) != hd.HYperfilvalor
		   or coalesce(x.HYERVjustificacion,'') != hd.HYERVjustificacion
		   or coalesce(x.HYHEvalor,'') != hd.HYHEvalor
		   or coalesce(x.HYHGvalor,'') != hd.HYHGvalor
		   or coalesce(x.HYCPvalor,'') != hd.HYCPvalor
		   or coalesce(x.HYLAvalor,'') != hd.HYLAvalor
		   or coalesce(x.HYMvalor,'') != hd.HYMvalor
		   or coalesce(x.HYIvalor,'') != hd.HYIvalor<!------> ) 
		  ) as EnProceso,
		  hd.HYHEvalor,
		  hd.HYHGvalor,
		  hd.HYCPvalor,
		  hd.HYLAvalor,
		  hd.HYMvalor,
		  hd.HYIvalor,
		  p.CFid
	from HYERelacionValoracion he
	inner join HYDRelacionValoracion hd
	   on hd.HYERVid = he.HYERVid
	  and hd.Ecodigo = he.Ecodigo
	inner join RHPuestos p
	   on p.RHPcodigo = hd.RHPcodigo
	  and p.Ecodigo = he.Ecodigo
	inner join Empresas e
	   on e.Ecodigo = he.Ecodigo
	where he.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and HYERVestado = 0
	<cfif isdefined('url.HYERVid') and url.HYERVid GT 0>
	  and he.HYERVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.HYERVid#">
	</cfif>
	<cfif isdefined('url.RHTPid') and LEN(TRIM(url.RHTPid))>
	and p.RHTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHTPid#">
	</cfif>
	<cfif isdefined('url.CFid') and LEN(TRIM(url.CFid))>
	and p.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
	</cfif>	  
	order by he.HYERVid, ptotal  desc
</cfquery>

<cfreport format="#url.formato#" template= "#reporte_id#" query="rsReporte">	<cfreportparam name="fecha1" value="#fecha#">	<cfreportparam name="Ecodigo" value="#session.Ecodigo#"></cfreport>
