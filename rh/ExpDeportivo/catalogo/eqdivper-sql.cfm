
<cfset params = "?EDPid=#form.EDPid#">

<cfif isdefined("form.ALTA")>
	<cftransaction>

	<cfinvoke component="rh.ExpDeportivo.componentes.EquipoDivPersona" method="ALTA" returnvariable="rs"  
	TPid="#form.TPid#" 
	Ecodigo= "#form.Ecodigo#"
	EDPdesde="#form.EDPdesde#"
	EDPhasta="#form.EDPhasta#"
	EDPposicion="#form.EDPposicion#"
	EDPnumero="#form.EDPnumero#"
	DEid="#form.DEid#"
	EDvid="#form.EDvid#"
	conexion2="#session.dsn#"/>
	</cftransaction>
	<cfset params = params & "&EDPid=#form.EDPid#">

<cfelseif isdefined("form.CAMBIO")>
	<cf_dbtimestamp
		datasource="#session.dsn#"
		table="EquipoDivPersona"
		redirect="eqdivper-form.cfm"
		timestamp="#form.ts_rversion#"
		field1="EDPid,numeric,#form.EDPid#"
		>						
	
		<cftransaction>
		<cfinvoke component="rh.ExpDeportivo.componentes.EquipoDivPersona" 
		method="CAMBIO" returnvariable="rs" TPid="#form.TPid#" 
		Ecodigo= "#form.Ecodigo#"
		EDPdesde="#form.EDPdesde#"
		EDPhasta="#form.EDPhasta#"
		EDPposicion="#form.EDPposicion#"
		EDPnumero="#form.EDPnumero#"
		DEid="#form.DEid#"
		EDvid="#form.EDvid#"
		EDPid="#form.EDPid#" />
		</cftransaction>
		<cfset params = params & "&EDPid=#form.EDPid#">

<cfelseif isdefined("form.BAJA")>
	<cftransaction>
	<cfinvoke component="rh.ExpDeportivo.componentes.EquipoDivPersona" method="BAJA" returnvariable="rs" 
	TPid="#form.TPid#" 
	Ecodigo= "#form.Ecodigo#"
	EDPdesde="#form.EDPdesde#"
	EDPhasta="#form.EDPhasta#"
	EDPposicion="#form.EDPposicion#"
	EDPnumero="#form.EDPnumero#"
	DEid="#form.DEid#"
	EDvid="#form.EDvid#"
	conexion="#session.dsn#"/>
	</cftransaction>
	<cfset params = params & "&EDPid=#form.EDPid#">

</cfif>
<cfif isdefined("form.popup") and form.popup eq "s">
<cfoutput>

<script>
var obj = window.parent.opener.document.getElementById('DEid');
obj.options[obj.length] = Option("#form.DEapellido1# #form.DEapellido2# #form.DEnombre#", "#form.DEid#");
obj.selectedIndex=obj.length-1;
window.close();
</script>
</cfoutput>
<cfelse>
<cflocation url="eqdivper.cfm#params#">
</cfif>