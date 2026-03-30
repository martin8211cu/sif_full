<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfquery name="rsActivos" datasource="#Session.DSN#" maxrows="3001">
	select 	a.Aplaca as Placa, 
			a.Adescripcion as Descripcion, 
			rtrim(a.Aplaca) #_Cat# ' - ' #_Cat# a.Adescripcion as Activo,
			a.Aserie as Serie, 
			rtrim(afm.AFMcodigo) as Marca,
			rtrim(afm.AFMdescripcion) as DescMarca, 
			rtrim(afmm.AFMMcodigo) as Modelo,
			rtrim(afmm.AFMMdescripcion) as DescModelo,
			( select afc.AFCdescripcion
				from AFClasificaciones afc
				where afc.AFCcodigo = a.AFCcodigo 
				and afc.Ecodigo = a.Ecodigo
			) as Tipo, 			
			( select afc.AFCcodigoclas
				from AFClasificaciones afc
				where afc.AFCcodigo = a.AFCcodigo 
				and afc.Ecodigo = a.Ecodigo
			) as Codtipo,
			(select rtrim(ac.ACcodigodesc) #_Cat# ' ' #_Cat# ac.ACdescripcion 
			from ACategoria ac 
			where ac.Ecodigo = a.Ecodigo
				and ac.ACcodigo = a.ACcodigo
			) as CategoriaDesc,	
			
			(select rtrim(acl.ACcodigodesc) #_Cat#' ' #_Cat# acl.ACdescripcion
			from AClasificacion acl
			where acl.ACid = a.ACid 
			and acl.Ecodigo = a.Ecodigo
			and acl.ACcodigo = a.ACcodigo
			) as ClaseDesc
			
	from Activos a
		inner join AFMarcas afm
			on a.AFMid = afm.AFMid
			and a.Ecodigo = afm.Ecodigo
		<cfif isdefined("url.AFMdescripcion") and Len(Trim(url.AFMdescripcion))>
			and upper(afm.AFMdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(url.AFMdescripcion))#%">
		</cfif>
		inner join AFMModelos afmm
			on a.AFMMid = afmm.AFMMid
			and a.Ecodigo = afmm.Ecodigo
		<cfif isdefined("url.AFMMdescripcion") and Len(Trim(url.AFMMdescripcion))>
			and upper(afmm.AFMMdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(url.AFMMdescripcion))#%">
		</cfif>
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.Astatus = 0
	<cfif isdefined("url.Aplaca") and Len(Trim(url.Aplaca))>
		and upper(a.Aplaca) = <cfqueryparam cfsqltype="cf_sql_char" value="%#UCase(Trim(url.Aplaca))#%">
	</cfif>
	<cfif isdefined("url.Aserie") and Len(Trim(url.Aserie))>
		and upper(a.Aserie) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(url.Aserie))#%">
	</cfif>
	<cfif isdefined("url.Adescripcion") and Len(Trim(url.Adescripcion))>
		and upper(a.Adescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(url.Adescripcion))#%">
	</cfif>
	order by a.Aplaca
</cfquery>


<cfif isdefined("rsActivos") and rsActivos.recordcount gt 3000>
	<cf_errorCode	code = "50051" msg = "Se han generado mas de 3000 registros para este reporte.">
	<cfabort>
<cfelseif isdefined("rsActivos") and rsActivos.recordcount eq 0>
	<cf_errorCode	code = "50349" msg = "No se han generado registros para este reporte.">
	<cfabort>
</cfif>

<cfif url.formato NEQ "txt">
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
	  <cf_js_reports_service_tag queryReport = "#rsActivos#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "af.consultas.activosAdq"
		headers = "empresa:#Session.Enombre#"/>
	<cfelse>
	<cfreport format="#url.Formato#" template= "activos.cfr" query="#rsActivos#">
		<cfreportparam name="Edescripcion" value="#session.Enombre#">
	</cfreport>
	</cfif>
<cfelse>
	<cf_exportQueryToFile query="#rsActivos#" separador="#chr(9)#" filename="Reporte_De_Activos_#session.Usucodigo#_#LSDateFormat(Now(),'ddmmyyyy')#_#LSTimeFormat(Now(),'hh:mm:ss')#.txt" jdbc="false">
</cfif>

