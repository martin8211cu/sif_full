<cfset params = "?EDPid=#form.EDPid#">

<cfif isdefined("form.ALTA")>
	<cftransaction>

	<cfinvoke component="rh.ExpDeportivo.componentes.Posiciones" method="ALTA" returnvariable="rs"  
	EDPdescripcion="#form.EDPdescripcion#" 
	EDPcodigo= "#form.EDPcodigo#" 
	conexion2="#session.dsn#"/>
	</cftransaction>
	<cfset params = params & "&EDPid=#form.EDPid#">

<cfelseif isdefined("form.CAMBIO")>
	<cf_dbtimestamp
		datasource="#session.dsn#"
		table="EDPosiciones"
		redirect="Posiciones.cfm"
		timestamp="#form.ts_rversion#"
		field1="EDPid,numeric,#form.EDPid#"
		>						
	
		<cftransaction>
		<cfinvoke component="rh.ExpDeportivo.componentes.Posiciones" 
		method="CAMBIO" returnvariable="rs" EDPdescripcion = "#form.EDPdescripcion#" EDPcodigo="#form.EDPcodigo#" EDPid="#form.EDPid#" />
		</cftransaction>
		<cfset params = params & "&EDPid=#form.EDPid#">

<cfelseif isdefined("form.BAJA")>
	<cftransaction>
	<cfinvoke component="rh.ExpDeportivo.componentes.Posiciones" method="BAJA" returnvariable="rs" 
	EDPid="#form.EDPid#" 
	EDPcodigo="#form.EDPcodigo#"
	EDPdescripcion="#form.EDPdescripcion#" 
	conexion="#session.dsn#"/>
	</cftransaction>
	<cfset params = params & "&EDPid=#form.EDPid#">

</cfif>
<cfif isdefined("form.popup") and form.popup eq "s">
<cfoutput>
<script>
var obj = window.parent.opener.document.getElementById('Posiciones');
obj.options[obj.length] = new Option("#form.EDPcodigo# - #form.EDPdescripcion#", "#form.EDPid#");
obj.selectedIndex=obj.length-1;
window.close();
</script>
</cfoutput>
<cfelse>
<cflocation url="Posiciones.cfm#params#">
</cfif>