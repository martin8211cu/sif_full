<!--- Proveduria Corporativa --->
<cfif isdefined('url.Ecodigo') and url.Ecodigo eq -1>
	<cfparam name="form.EcodigoE" default="#session.Ecodigo#">
	<cfset lvarProvCorp = false>
	<cfset lvarFiltroEcodigo = #session.Ecodigo#>
	<cfquery name="rsProvCorp" datasource="#session.DSN#">
        select Pvalor 
        from Parametros 
        where Ecodigo=#session.Ecodigo#
        and Pcodigo=5100
	</cfquery>
	<cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
		<cfset lvarProvCorp = true>
		<cfquery name="rsEProvCorp" datasource="#session.DSN#">
            select EPCid
            from EProveduriaCorporativa
            where Ecodigo = #session.Ecodigo#
             and EPCempresaAdmin = #session.Ecodigo#
		</cfquery>
		<cfif rsEProvCorp.recordcount gte 1>
            <cfquery name="rsDProvCorp" datasource="#session.DSN#">
                select DPCecodigo as Ecodigo, Edescripcion
                from DProveduriaCorporativa dpc
                    inner join Empresas e
                        on e.Ecodigo = dpc.DPCecodigo
                where dpc.Ecodigo = #session.Ecodigo#
                 and dpc.EPCid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsEProvCorp.EPCid)#" list="yes">)
                union
                select e.Ecodigo, e.Edescripcion
                from Empresas e
                where e.Ecodigo = #session.Ecodigo#
                order by 2
			</cfquery>
            <cfloop from="1" to="#rsDProvCorp.recordcount#" index="i">
                <cfset Ecodigos = ValueList(rsDProvCorp.Ecodigo)>
            </cfloop>
		</cfif>    
		<cfif not isdefined('Session.Compras.ProcesoCompra.Ecodigo')>
            <cfset Session.Compras.ProcesoCompra.Ecodigo = session.Ecodigo>
        </cfif>
		<cfset url.Ecodigo =#Ecodigos#>	
        <cfelse>
            <cfparam name="url.Ecodigo" default="#session.Ecodigo#">
        </cfif>
<cfelse>
	 <cfparam name="url.Ecodigo" default="#session.Ecodigo#">
</cfif>
<cfparam name="url.formulario" default="form1">
<cfquery name="rs" datasource="#session.DSN#">
	select CMSid, CMScodigo, CMSnombre
	from CMSolicitantes
	where Ecodigo in (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#" list="yes">)
		and rtrim(CMScodigo)=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.CMScodigo)#">
</cfquery>

<cfset index = 1>
<cfif url.opcion eq 2>
	<cfset index = 2>
</cfif>

<cfoutput>
	<script language="javascript1.2" type="text/javascript">
		<cfif rs.recordCount gt 0>
			window.parent.document.#url.formulario#.CMSid.value = #rs.CMSid#;
			window.parent.document.#url.formulario#.CMScodigo.value = '#trim(rs.CMScodigo)#';
			window.parent.document.#url.formulario#.CMSnombre.value = '#trim(rs.CMSnombre)#';
		<cfelse>
			window.parent.document.#url.formulario#.CMSid.value = '';
			window.parent.document.#url.formulario#.CMScodigo.value = '';
			window.parent.document.#url.formulario#.CMSnombre.value = '';
		</cfif>
	</script>
</cfoutput>