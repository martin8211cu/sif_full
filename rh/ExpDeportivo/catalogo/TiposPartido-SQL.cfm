<cfset params = "?EDTPid=#form.EDTPid#">

<cfif isdefined("form.ALTA")>
	<cftransaction>

	<cfinvoke component="rh.ExpDeportivo.componentes.EDTiposPartido" method="ALTA" returnvariable="rs"  
	TPdescripcion="#form.EDTPdescripcion#" 
	TPcodigo= "#form.EDTPcodigo#" 
	conexion2="#session.dsn#"/>
	</cftransaction>
	<cfset params = params & "&EDTPid=#form.EDTPid#">

<cfelseif isdefined("form.CAMBIO")>
	<cf_dbtimestamp
		datasource="#session.dsn#"
		table="EDTiposPartido"
		redirect="TiposPartido.cfm"
		timestamp="#form.ts_rversion#"
		field1="EDTPid,numeric,#form.EDTPid#"
		>						
	
		<cftransaction>
		<cfinvoke component="rh.ExpDeportivo.componentes.EDTiposPartido" 
		method="CAMBIO" returnvariable="rs" TPdescripcion = "#form.EDTPdescripcion#" TPcodigo="#form.EDTPcodigo#" TPid="#form.EDTPid#" />
		</cftransaction>
		<cfset params = params & "&EDTPid=#form.EDTPid#">

<cfelseif isdefined("form.BAJA")>
	<cftransaction>
	<cfinvoke component="rh.ExpDeportivo.componentes.EDTiposPartido" method="BAJA" returnvariable="rs" 
	TPid="#form.EDTPid#" 
	TPcodigo="#form.EDTPcodigo#"
	TPdescripcion="#form.EDTPdescripcion#" 
	conexion="#session.dsn#"/>
	</cftransaction>
	<cfset params = params & "&EDTPid=#form.EDTPid#">

</cfif>
<cfif isdefined("form.popup") and form.popup eq "s">
<cfoutput>
<script>
var obj = window.parent.opener.document.getElementById('TiposPartido');
obj.options[obj.length] = new Option("#form.EDTPcodigo# - #form.EDTPdescripcion#", "#form.EDTPid#");
obj.selectedIndex=obj.length-1;
window.close();
</script>
</cfoutput>
<cfelse>
<cflocation url="TiposPartido.cfm#params#">
</cfif>