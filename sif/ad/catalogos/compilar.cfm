<cfsetting enablecfoutputonly="yes">
<cfparam name="url.FMT01COD" default="">
<cfquery datasource="#session.dsn#" name="lista_query">
	select a.FMT01COD, a.FMT01DES
	from FMT001 a
	where (a.Ecodigo is null or a.Ecodigo=#session.Ecodigo#)
	<cfif Len(url.FMT01COD)>
	  and a.FMT01COD=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.FMT01COD#">
	<cfelse>
		<cfif isdefined("url.fFMT01COD") and len(trim(url.fFMT01COD)) gt 0  >
			 and upper(FMT01COD) like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(url.fFMT01COD)#%">
		</cfif>
		
		<cfif isdefined("url.fFMT01DES") and len(trim(url.fFMT01DES)) gt 0 >
			 and upper(rtrim(FMT01DES)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(url.fFMT01DES)#%">
		</cfif>
		
		<cfif isdefined("url.fFMT01TIP") and url.fFMT01TIP NEQ "-1" >
			 and FMT01TIP = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.fFMT01TIP#">
		</cfif>
	</cfif>
	order by a.FMT01COD
</cfquery>

<!--- Imagenes del formato--->
<cfquery datasource="#session.DSN#" name="rs_imagenes" >
	select b.FMT01COD, b.FMT03IMG 
	from FMT003 b
	<cfif Len(url.FMT01COD)>
	where b.FMT01COD=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.FMT01COD#">
	</cfif>
	order by b.FMT01COD
</cfquery>

<cfoutput query="rs_imagenes" group="FMT01COD">
	<cfset i = 1>
	<cfoutput>
		<cfif not Len(rs_imagenes.FMT03IMG) LE 1>
			<cfset tempfileurl = '/sif/reportes/i' & session.Ecodigo & '_' & Trim(rs_imagenes.FMT01COD) & '_' & i & '.gif'>
			<cfset tempfile = ExpandPath(tempfileurl)>
			<cffile action="write" file="#tempfile#" output="#rs_imagenes.FMT03IMG#" nameconflict="overwrite" >
		</cfif>
		<cfset i = i + 1>
	</cfoutput>
</cfoutput>

<cfloop query="lista_query">
	<!--- COMPILACION --->
	<cfset EMPRESA = session.Ecodigo >
	<cfset FORMATO = trim(lista_query.FMT01COD)>
	<cfset DATASOURCE = session.dsn >
	<cfset args="EMPRESA=" & URLEncodedFormat( EMPRESA ) &
		"&FORMATO=" & URLEncodedFormat( FORMATO ) &
		"&CONTEXT_ROOT=/cfmx" &
		"&CONTEXT_PATH="& Replace(ExpandPath('/sif/reportes/'),'\','/','all') &
		"&DATASOURCE=" & URLEncodedFormat( DATASOURCE ) >
	
	<cftransaction>
		<cfquery datasource="asp" name="newid">
			insert into ReporteFO(FOxml, FOcreado, FOusuario)
			values (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#args#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">)
			<cf_dbidentity1 datasource="asp">
		</cfquery>
		<cf_dbidentity2 datasource="asp" name="newid">
	</cftransaction>
	
	<cfoutput><!---Compilando #HTMLEditFormat(lista_query.FMT01COD)# - #HTMLEditFormat(lista_query.FMT01DES)#--->
	<iframe src="/jr/compile.jsp?id=#newid.identity#" width="575"></iframe>
	<!--- <iframe src="/cfmx/sif/cfreports/compile.jsp?id=#newid.identity#" width="575"></iframe> --->
	</cfoutput>
</cfloop>
