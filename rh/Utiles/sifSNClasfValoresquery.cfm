<!--- Recibe conexion, form, name, desc, ecodigo, dato por URL  --->

<cfif not isdefined("url.SNCEid") or len(trim(url.SNCEid)) LTE 0>
	<cfthrow message="La&nbsp;Clasificaci&oacute;n&nbsp;no&nbsp;ha&nbsp;sido&nbsp;Escogida."
		detail="Debe&nbsp;escoger&nbsp;la&nbsp;Clasificaci&oacute;n." >
</cfif>


<cfquery name="rsConsultaCorp" datasource="asp">
	select *
	from CuentaEmpresarial
	where Ecorporativa is not null
	  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#" >
</cfquery>
<cfif isdefined('session.Ecodigo') and 
	  isdefined('session.Ecodigocorp') and
	  session.Ecodigo NEQ session.Ecodigocorp and
	  rsConsultaCorp.RecordCount GT 0>
	  <cfset filtro = " and Ecodigo=#session.Ecodigo#">
<cfelse>
	  <cfset filtro = " and Ecodigo is null">								  
</cfif>



<cfif isdefined("url.dato") and Len(Trim(url.dato))>
	<cfquery name="rs" datasource="#url.conexion#">
		select <!--- a.SNCEid, --->  b.SNCDid, rtrim(ltrim(b.SNCDvalor)) as SNCDvalor, b.SNCDdescripcion
		from SNClasificacionE a,  SNClasificacionD b
		where  CEcodigo=#session.CEcodigo# #filtro#
			and a.SNCEid= b.SNCEid
			<!--- <cfif isdefined("url.SNCEid") and len(trim(url.SNCEid))> --->
			and a.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
			<!--- </cfif> --->
			and rtrim(ltrim(upper(b.SNCDvalor))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
			and SNCDactivo = 1
		order by 1
	</cfquery>

	<script language="JavaScript">
		var descAnt = parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value;
		parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#rs.SNCDid#</cfoutput>";
		parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#rs.SNCDvalor#</cfoutput>";
		parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rs.SNCDdescripcion#</cfoutput>";
		
		<!--- Esto es utilizado para limpiar el tag de SNClasificacion en CxC --->
		if (descAnt != parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value && parent.ClearPlaza) {
			parent.ClearPlaza();
		}
	</script>
</cfif>
