<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<!--- Caso Proveduria Corporativa --->
<cfif url.Ecodigo eq -1>
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
            <cfset url.Ecodigo = Ecodigos>
        </cfif>    
        <cfif not isdefined('Session.Compras.ProcesoCompra.Ecodigo')>
            <cfset Session.Compras.ProcesoCompra.Ecodigo = session.Ecodigo>
        </cfif>
    </cfif>
</cfif>
<cfif isdefined("Url.GSNid") and Url.GSNid gt 0 and not isdefined("Form.GSNid")>
	<cfparam name="Form.GSNid" default="#Url.GSNid#">
</cfif>
<cfif isdefined("Url.SNid") and not isdefined("Form.SNid")>
	<cfparam name="Form.SNid" default="#Url.SNid#">
</cfif>
<cfparam name="url.Ecodigo" default="#session.Ecodigo#">
<cfif isdefined("Url.Ecodigo") and not isdefined("Form.Ecodigo")>
	<cfparam name="Form.Ecodigo" default="#Url.Ecodigo#">
</cfif>
<cfif isdefined("url.codigo") and len(trim(url.codigo))>
	<cfquery name="rs" datasource="#session.DSN#">
		select SNcodigo, SNnumero, SNnombre, SNid, SNidentificacion
		from SNegocios
		where Ecodigo in (<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ecodigo#" list="yes">)
		and SNidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.codigo)#">
		<cfif isdefined("url.tipo") and len(trim(url.tipo))>
			<cfif url.tipo neq 'A'>
				and SNtiposocio in ('A', '#url.tipo#')
			<cfelse>
				and SNtiposocio = 'A'
			</cfif>
		</cfif> 
		<cfif isdefined("url.GSNid") and len(trim(url.GSNid))>
			and GSNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GSNid#">
		</cfif>
	</cfquery>

	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="<cfoutput>#rs.SNidentificacion#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.numero#</cfoutput>.value="<cfoutput>#rs.SNidentificacion#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#rs.SNnombre#</cfoutput>";
			<cfif isdefined('form.SNid')>window.parent.document.<cfoutput>#url.formulario#.#url.SNid#</cfoutput>.value="<cfoutput>#rs.SNid#</cfoutput>";</cfif>
			<cfoutput>if (window.parent.func#url.numero#) {window.parent.func#url.numero#()}</cfoutput>
		</script>
	<cfelse>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.numero#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";
			<cfif isdefined('form.SNid')>window.parent.document.<cfoutput>#url.formulario#.#url.SNid#</cfoutput>.value="";</cfif>
			<cfoutput>if (window.parent.func#url.numero#) {window.parent.func#url.numero#()}</cfoutput>
		</script>
	</cfif>
</cfif>