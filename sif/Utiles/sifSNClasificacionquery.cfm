<!--- Recibe conexion, form, name, desc, ecodigo, dato por URL  --->

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
		select SNCEid, rtrim(ltrim(SNCEcodigo)) as SNCEcodigo, SNCEdescripcion
		from SNClasificacionE
		where 
		CEcodigo=#session.CEcodigo# #filtro#
		and PCCEactivo = 1
		<!--- Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ecodigo#"> --->
		and rtrim(ltrim(upper(SNCEcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
	</cfquery>

	<script language="JavaScript">
		var descAnt = parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value;
		parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#rs.SNCEid#</cfoutput>";
		parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#rs.SNCEcodigo#</cfoutput>";
		parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rs.SNCEdescripcion#</cfoutput>";
		
		<!--- Esto es utilizado para limpiar el tag de SNClasificacion en CxC --->
		if (descAnt != parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value && parent.ClearPlaza) {
			parent.ClearPlaza();
		}
	</script>
</cfif>
