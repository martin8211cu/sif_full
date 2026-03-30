<cfif isdefined("form.alta")>
    <cfquery name="rssql" datasource="#session.dsn#">
        insert into DCGDistribucion 
        (Ecodigo,	DCdescripcion,	Oorigen)
        values (#session.Ecodigo#,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.DCdescripcion)#">, 
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DCorigen#">)
    </cfquery>

	<cfset paginared = "formgrupos.cfm">
		
<cfelseif isdefined("form.cambio")>
	<cf_dbtimestamp
				datasource="#session.dsn#"
				table="DCGDistribucion" 
				redirect="formgrupos.cfm?IDgd=#form.IDgd#"
				timestamp="#form.ts_rversion#"
				field1="Ecodigo,numeric,#session.Ecodigo#"
				field2="IDgd,numeric,#form.IDgd#">
	<cftransaction>
		<cfquery name="rssql" datasource="#session.dsn#">
			update DCGDistribucion 
			set DCdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DCdescripcion#">,
				Oorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DCorigen#">
			where Ecodigo = #session.Ecodigo#
			  and IDgd  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDgd#">
		</cfquery>
	</cftransaction>
	<cfset paginared = "formgrupos.cfm?IDgd=#form.IDgd#">

<cfelseif isdefined("form.baja")>

	<cfquery name="rsExiste" datasource="#session.dsn#">
	Select 1
	from DCGDistribucion a, DCDistribucion b
	where a.IDgd = b.IDgd
	  and a.IDgd = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDgd#">
	</cfquery>
	<cfif rsExiste.recordcount>
		<cf_errorCode	code = "50358" msg = "El grupo tiene distribuciones asociadas, pimero debe eliminar las distribuciones. Proceso Cancelado!">
	</cfif>
		
	<cfquery name="rssql" datasource="#session.dsn#">
	delete from DCGDistribucion
	where IDgd = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDgd#">
 	  and Ecodigo = #session.Ecodigo#
	</cfquery>

</cfif>
<cfif not isdefined("paginared")>
	<cflocation url="formgrupos.cfm">
<cfelse>	
	<cflocation url="#paginared#">
</cfif>

