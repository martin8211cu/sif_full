	<cfif not isdefined("url.formato") >
		<cfset tipoformato = "html">
	<cfelse>
		<cfset tipoformato = #url.formato#>
	</cfif>
	<cfif isdefined('url.TipoRep')>
		<cfif url.TipoRep EQ 1 or url.TipoRep EQ 2>
			<cfquery name="rsReporte" datasource="#session.DSN#">
				select rtrim(ltrim(cat.ACdescripcion)) AS CatDesc, 
					rtrim(ltrim(cla.ACdescripcion)) as clasedescripcion
					, b.CFid, b.TAid, TAmontolocadq as AFSvalrev
					, rtrim(cf.CFcodigo) as CFcodigo
					, rtrim(ltrim(cf.CFdescripcion)) as CFdescripcion
					, c.Edescripcion as Edescripcion
					, a.Aplaca 
					, <cf_dbfunction name="to_date" args="a.Afechainirev"> as Afechainirev 
					, a.Avutil 
					, <cf_dbfunction name="sPart" args="a.Adescripcion,1,30"> as Adescripcion
					, cla.ACcodigodesc as claseCodigo, cat.ACcodigodesc as categoria,cat.ACcodigo, cla.ACid
					from Activos a 
					inner join TransaccionesActivos b 
					   on b.Ecodigo = a.Ecodigo 
					  and b.Aid = a.Aid
					  and b.TAperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Periodo#">
					  and b.TAmes =  <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Mes#">
					  and b.IDtrans = 3
					inner join ACategoria cat 
					   on cat.Ecodigo = a.Ecodigo  
					  and cat.ACcodigo = a.ACcodigo
					inner join AClasificacion cla 
					   on cla.Ecodigo = a.Ecodigo  
					  and cla.ACcodigo = a.ACcodigo 
					  and cla.ACid = a.ACid
					inner join Empresas c
					   on a.Ecodigo = c.Ecodigo
					inner join CFuncional cf
					   on b.CFid = cf.CFid
					where a.Ecodigo =  #session.Ecodigo# 	
					  <cfif isdefined('url.CFid') and url.CFid GT 0>
					  and b.CFid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
					  </cfif>										
					  <cfif isdefined('url.ACcodigo') and LEN(TRIM(url.ACcodigo))>
					  and cat.ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ACcodigo#">
					  </cfif>
					   <cfif isdefined('url.ACid') and url.ACid GT 0>
					   and cla.ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ACid#">
					   </cfif>
					<cfif url.TipoRep EQ 1>
						order by b.CFid,cat.ACcodigo, cla.ACid
					<cfelseif url.TipoRep EQ 2>
						order by cat.ACcodigo,cla.ACid,b.CFid
					</cfif>
			</cfquery>
		<cfelseif url.TipoRep EQ 3 or url.TipoRep EQ 4> 
			<cfquery name="rsReporte" datasource="#session.DSN#">
				select e.CFid, rtrim(e.CFcodigo) as CFcodigo, 
					e.CFdescripcion, 
					d.ACcodigo,
					d.ACcodigodesc as categoria, 
					d.ACdescripcion as catDesc, 
					c.ACid,
					c.ACcodigodesc as claseCodigo, 
					c.ACdescripcion as clasedescripcion, 
					sum(round(a.TAmontolocadq,2)) as AFSvalrev 
					
					from TransaccionesActivos a
					inner join Activos b
						on b.Aid = a.Aid
						and b.Ecodigo = a.Ecodigo
						and a.IDtrans = 3 
					inner join AClasificacion c
						on c.ACid = b.ACid
						and c.Ecodigo = b.Ecodigo
					inner join ACategoria d
						on d.ACcodigo = b.ACcodigo
						and d.Ecodigo = b.Ecodigo
					inner join CFuncional e
						on e.CFid = a.CFid
						and e.Ecodigo = a.Ecodigo
					inner join Empresas f
						on f.Ecodigo = a.Ecodigo
					where a.Ecodigo =  #session.Ecodigo# 	
					  and a.TAperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Periodo#">
					  and a.TAmes =  <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Mes#">
					 <cfif isdefined('url.CFid') and url.CFid GT 0>
					  and a.CFid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
					  </cfif>										
					  <cfif isdefined('url.ACcodigo') and LEN(TRIM(url.ACcodigo))>
					  and b.ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ACcodigo#">
					  </cfif>
					   <cfif isdefined('url.ACid') and url.ACid GT 0>
					   and b.ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ACid#">
					   </cfif>
					<cfif url.TipoRep EQ 3>
						group by e.CFid, rtrim(e.CFcodigo), e.CFdescripcion, d.ACcodigo, d.ACcodigodesc, d.ACdescripcion, c.ACid,c.ACcodigodesc, c.ACdescripcion
						order by e.CFid, rtrim(e.CFcodigo), e.CFdescripcion, d.ACcodigo, d.ACcodigodesc, d.ACdescripcion, c.ACid,c.ACcodigodesc, c.ACdescripcion
					<cfelseif url.TipoRep EQ 4>
						group by  c.ACdescripcion,d.ACcodigo, c.ACid,c.ACcodigodesc, d.ACcodigodesc, d.ACdescripcion,  e.CFid, rtrim(e.CFcodigo), e.CFdescripcion
						order by  d.ACcodigo, d.ACcodigodesc, c.ACid,c.ACcodigodesc, c.ACdescripcion, d.ACdescripcion,  e.CFid, rtrim(e.CFcodigo), e.CFdescripcion
					</cfif>  
			</cfquery>
		</cfif>
	</cfif>
	<cfif rsReporte.RecordCount GT 10000>
		<cf_errorCode	code = "50053" msg = " Error. La consulta tiene muchos registros. Redefina los filtros e intente de nuevo.">
		<cfabort>
	</cfif>

	<cfquery name="rsMeses" datasource="sifControl">
		select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
		from Idiomas a, VSidioma b 
		where a.Icodigo = '#Session.Idioma#'
		and b.VSgrupo = 1
		and a.Iid = b.Iid
		and <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> = #url.mes#
	</cfquery>
	<!--- Busca nombre de la Empresa --->
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion
		from Empresas
		where Ecodigo =   #session.Ecodigo# 
	</cfquery>
	
	<cfset nombRep = "">
	<cfset nombreReporteJR = "">
	<cfif isdefined("url.TipoRep") and url.TipoRep EQ 1>
		<cfset nombRep = "revaluacionMesCF.cfr">
		<cfset nombreReporteJR = "revaluacionMesCF">
	<cfelseif  isdefined("url.TipoRep") and url.TipoRep EQ 2>
		<cfset nombRep = "revaluacionMesCC.cfr">
		<cfset nombreReporteJR = "revaluacionMesCC">
	<cfelseif  isdefined("url.TipoRep") and url.TipoRep EQ 3>
		<cfset nombRep = "revaluacionMesCFres.cfr">
		<cfset nombreReporteJR = "revaluacionMesCFres">
	<cfelseif  isdefined("url.TipoRep") and url.TipoRep EQ 4>
		<cfset nombRep = "revaluacionMesCCres.cfr">
		<cfset nombreReporteJR = "revaluacionMesCCres">
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
	  <cfif formato EQ "pdf">
		<cfset typeRep = 2>
	  </cfif>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "af.consultas.#nombreReporteJR#"/>
	<cfelse>
	<cfreport format="#formato#" template= "#nombRep#" query="rsReporte">
		<cfif isdefined("url.Periodo") and url.Periodo GT 0>
			<cfreportparam name="Periodo" value="#url.Periodo#">
		</cfif> 
		<cfif isdefined("url.Mes") and url.Mes GT 0>
			<cfreportparam name="Mes" value="#rsMeses.Pdescripcion#">
		</cfif>
		<cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
			<cfreportparam name="Empresa" value="#rsEmpresa.Edescripcion#">
		</cfif>
	</cfreport>
	</cfif>

