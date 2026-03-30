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
<cfparam name="url.formulario" default="form1">
<cfquery name="rs" datasource="#session.DSN#">
	select CMCid, CMCcodigo, CMCnombre
	from CMCompradores
	where Ecodigo in (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#" list="yes">)
		and rtrim(CMCcodigo)=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.CMCcodigo)#">
</cfquery>

<cfset index = 1>
<cfif url.opcion eq 2>
	<cfset index = 2>
</cfif>

<cfoutput>
	<script language="javascript1.2" type="text/javascript">
		<cfif rs.recordCount gt 0>
			window.parent.document.#url.formulario#.CMCid#index#.value = #rs.CMCid#;
			window.parent.document.#url.formulario#.CMCcodigo#index#.value = '#trim(rs.CMCcodigo)#';
			window.parent.document.#url.formulario#.CMCnombre#index#.value = '#trim(rs.CMCnombre)#';
		<cfelse>
			window.parent.document.#url.formulario#.CMCid#index#.value = '';
			window.parent.document.#url.formulario#.CMCcodigo#index#.value = '';
			window.parent.document.#url.formulario#.CMCnombre#index#.value = '';
		</cfif>
	</script>
</cfoutput>