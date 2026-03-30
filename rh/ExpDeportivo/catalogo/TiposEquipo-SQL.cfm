<cfset params = "?TEid=#form.TEid#">

<cfif isdefined("form.ALTA")>
	<cftransaction>
	
	<cfinvoke component="rh.ExpDeportivo.componentes.EDTiposEquipo" method="ALTA" returnvariable="rs"  
	TEdescripcion="#form.TEdescripcion#" 
	TEcodigo= "#form.TEcodigo#" 
	conexion2="#session.dsn#"/>
	</cftransaction>
	<cfset params = params & "&TEid=#form.TEid#">

<cfelseif isdefined("form.CAMBIO")>
	<cf_dbtimestamp
		datasource="#session.dsn#"
		table="EDTiposEquipo"
		redirect="TiposEquipo.cfm"
		timestamp="#form.ts_rversion#"
		field1="TEid,numeric,#form.TEid#"
		>						
	
		<cftransaction>
		<cfinvoke component="rh.ExpDeportivo.componentes.EDTiposEquipo" 
		method="CAMBIO" returnvariable="rs" TEdescripcion = "#form.TEdescripcion#" TEcodigo="#form.TEcodigo#" TEid="#form.TEid#" />
		</cftransaction>
		<cfset params = params & "&TEid=#form.TEid#">

<cfelseif isdefined("form.BAJA")>
	<cftransaction>
	<cfinvoke component="rh.ExpDeportivo.componentes.EDTiposEquipo" method="BAJA" returnvariable="rs" 
	TEid="#form.TEid#" 
	TEcodigo="#form.TEcodigo#"
	TEdescripcion="#form.TEdescripcion#" 
	conexion="#session.dsn#"/>
	</cftransaction>
	<cfset params = params & "&TEid=#form.TEid#">

</cfif>

<cfif isdefined("form.popup") and form.popup eq "s">
<cfoutput>
<script>
var obj = window.parent.opener.document.getElementById('TiposEquipo');
obj.options[obj.length] = new Option("#form.TEcodigo# - #form.TEdescripcion#", "#form.TEid#");
obj.selectedIndex=obj.length-1;
window.close();
</script>
</cfoutput>
<cfelse>
<cflocation url="TiposEquipo.cfm#params#">
</cfif>