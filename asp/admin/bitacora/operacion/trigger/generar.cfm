<cfparam name="form.ck" default="">

<cfquery datasource="asp" name="lista">
	select PBtabla
	from PBitacora
	where PBtabla in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ck#" list="yes">)
	order by PBtabla
</cfquery>

<cfif Not lista.RecordCount>
	<cfthrow message="No se han especificado las tablas por generar">
</cfif>

<cfquery datasource="asp" name="caches">
	select distinct c.Ccache as cache
	from Caches c
		join Empresa e
			on c.Cid = e.Cid
	where c.Ccache in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.dsn#" list="yes">)
	order by cache
</cfquery>
<cfloop query="caches">
	<cfset el_cache = caches.cache>
	<cfoutput query="lista">
		Generando #el_cache# #lista.PBtabla#
		<cfinvoke component="trigger_text" method="create_triggers" returnvariable="the_text" 
			table_name="#lista.PBtabla#" datasource="#el_cache#" />
	</cfoutput><hr>
</cfloop>

<cflocation url="results.cfm?ck=#URLEncodedFormat(form.ck)#&dsn=#URLEncodedFormat(form.dsn)#">