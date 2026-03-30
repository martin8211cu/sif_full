<cfset params = "?TPid=#form.TPid#">

<cfif isdefined("form.ALTA")>
	<cftransaction>

	<cfinvoke component="rh.ExpDeportivo.componentes.EDTiposPersona" method="ALTA" returnvariable="rs"  
	TPdescripcion="#form.TPdescripcion#" 
	TPcodigo= "#form.TPcodigo#" 
	conexion2="#session.dsn#"/>
	</cftransaction>
	<cfset params = params & "&TPid=#form.TPid#">

<cfelseif isdefined("form.CAMBIO")>
	<cf_dbtimestamp
		datasource="#session.dsn#"
		table="EDTiposPersona"
		redirect="TiposPersona.cfm"
		timestamp="#form.ts_rversion#"
		field1="TPid,numeric,#form.TPid#"
		>						
	
		<cftransaction>
		<cfinvoke component="rh.ExpDeportivo.componentes.EDTiposPersona" 
		method="CAMBIO" returnvariable="rs" TPdescripcion = "#form.TPdescripcion#" TPcodigo="#form.TPcodigo#" TPid="#form.TPid#" />
		</cftransaction>
		<cfset params = params & "&TPid=#form.TPid#">

<cfelseif isdefined("form.BAJA")>
	<cftransaction>
	<cfinvoke component="rh.ExpDeportivo.componentes.EDTiposPersona" method="BAJA" returnvariable="rs" 
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
var obj = window.parent.opener.document.getElementById('TiposPersona');
obj.options[obj.length] = new Option("#form.TPcodigo# - #form.TPdescripcion#", "#form.TPid#");
obj.selectedIndex=obj.length-1;
window.close();
</script>
</cfoutput>
<cfelse>
<cflocation url="TiposPersona.cfm#params#">
</cfif>