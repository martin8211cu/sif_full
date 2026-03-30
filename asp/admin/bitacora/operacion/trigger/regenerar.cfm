<h1>Regenerar Triggers Modificados</h1>

<cfif not isdefined("url.CK")>
	<cfset url.CK = ''>	
</cfif>	
<cfquery datasource="asp" name="lista">
	select distinct c.Ccache, b.PBtabla
	from Caches c
		right join Empresa e
			on c.Cid = e.Cid,
		PBitacora b
	where c.Ccache in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyList(Application.dsinfo)#" list="yes">)
    <cfif isdefined("url.CK") and len(trim(url.ck)) gt 0>
    	and b.PBtabla in ('#url.CK#') 
    </cfif>
	<cfif Not IsDefined('url.forzar')>
	  and not exists (
			select 1 from PBitacoraTrg t
			where t.cache = c.Ccache
			  and t.PBtabla = b.PBtabla
			  and t.regenerar = 0 
			)
	</cfif>
	order by Ccache, PBtabla
</cfquery>


<cfoutput query="lista">
	<strong>Generando #lista.Ccache# #lista.PBtabla#: </strong>
	<cftry>
	<cfinvoke component="trigger_text" method="create_triggers" returnvariable="the_text" 
		table_name="#lista.PBtabla#" datasource="#lista.Ccache#" />
	#the_text#
	<cfcatch type="any">#cfcatch.Message#</cfcatch>
	</cftry>
	<br>
</cfoutput>

<cfoutput>
	<hr>
	<cfif lista.RecordCount is 0>
    	<cfset LvarParams = '&CK='&url.ck>
		No hay triggers por regenerar.  <a href="regenerar.cfm?forzar=true#LvarParams#">forzar.</a>
	<cfelse>
		Generados Triggers para #lista.RecordCount# tablas
	</cfif>
	<br>
    <cfset LvarParams = '?CK='&url.ck>
	<a href="regenerar.cfm#LvarParams#">Ejecutar de nuevo.</a>
</cfoutput>
