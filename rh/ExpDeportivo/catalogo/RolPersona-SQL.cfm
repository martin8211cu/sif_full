<cfset params = "?TPid=#form.TPid#">

<cfif isdefined("form.ALTA")>
<cfquery name="rsExisteEmpleado" datasource="#Session.DSN#"> 
		select 1
		from EDRolesPersonas
		where TPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TPcodigo#"> or
		TPdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TPdescripcion#">
	
		</cfquery>
			
		
			
		<cfif rsExisteEmpleado.recordCount GT 0>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_ElRolYaExiste"
				Default="El Rol ya existe"
				returnvariable="MSG_ElRolYaExiste"/>
			<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#MSG_ElRolYaExiste#." addtoken="no">
			<cfabort> 
		</cfif>
</cfif>
<cfif isdefined("form.ALTA")>
	<cftransaction>

	<cfinvoke component="rh.ExpDeportivo.componentes.EDRolesPersonas" method="ALTA" returnvariable="rs"  
	TPdescripcion="#form.TPdescripcion#" 
	TPcodigo= "#form.TPcodigo#" 
	conexion2="#session.dsn#"/>
	</cftransaction>
	<cfset params = params & "&TPid=#form.TPid#">

<cfelseif isdefined("form.CAMBIO")>
	<cf_dbtimestamp
		datasource="#session.dsn#"
		table="EDRolesPersonas"
		redirect="RolPersona.cfm"
		timestamp="#form.ts_rversion#"
		field1="TPid,numeric,#form.TPid#"
		>						
	
		<cftransaction>
		<cfinvoke component="rh.ExpDeportivo.componentes.EDRolesPersonas" 
		method="CAMBIO" returnvariable="rs" TPdescripcion = "#form.TPdescripcion#" TPcodigo="#form.TPcodigo#" TPid="#form.TPid#" />
		</cftransaction>
		<cfset params = params & "&TPid=#form.TPid#">

<cfelseif isdefined("form.BAJA")>
	<cftransaction>
	<cfinvoke component="rh.ExpDeportivo.componentes.EDRolesPersonas" method="BAJA" returnvariable="rs" 
	TPid="#form.TPid#" 
	TPcodigo="#form.TPcodigo#"
	TPdescripcion="#form.TPdescripcion#" 
	conexion="#session.dsn#"/>
	</cftransaction>
	<cfset params = params & "&TPid=#form.TPid#">

</cfif>
<cfif isdefined("form.popup") and form.popup eq "s">
<cfoutput>
<script>
var obj = window.parent.opener.document.getElementById('TPid');
obj.options[obj.length] = new Option("#form.TPcodigo# - #form.TPdescripcion#", "#rs.identity#");
obj.selectedIndex=obj.length-1;
window.close();
</script>
</cfoutput>
<cfelse>
<cflocation url="RolPersona.cfm#params#">
</cfif>

