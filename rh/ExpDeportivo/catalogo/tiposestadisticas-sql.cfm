<cfset params = "?EDTEid=#form.EDTEid#">

<cfif isdefined("form.ALTA")>
<cfquery name="rsExisteEmpleado" datasource="#Session.DSN#"> 
		select 1
		from EDTipoEstadisticas
		where EDTEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EDTEdescripcion#">
	
		</cfquery>
			
		
			
		<cfif rsExisteEmpleado.recordCount GT 0>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_LaEstadisticaYaExiste"
				Default="La estadística ya existe"
				returnvariable="MSG_LaEstadisticaYaExiste"/>
			<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#MSG_LaEstadisticaYaExiste#." addtoken="no">
			<cfabort> 
		</cfif>
</cfif>
<cfif isdefined("form.ALTA")>
	<cftransaction>

	<cfinvoke component="rh.ExpDeportivo.componentes.EDTipoEstadisticas" method="ALTA" returnvariable="rs"  
	EDTEdescripcion="#form.EDTEdescripcion#" 
	BMUsucodigo= "#session.Usucodigo#" 
	conexion2="#session.dsn#"/>
	</cftransaction>
	<cfset params = params & "&EDTEid=#form.EDTEid#">

<cfelseif isdefined("form.CAMBIO")>
	<cf_dbtimestamp
		datasource="#session.dsn#"
		table="EDTipoEstadisticas"
		redirect="tiposestadisticas.cfm"
		timestamp="#form.ts_rversion#"
		field1="EDTEid,numeric,#form.EDTEid#"
		>						
	
		<cftransaction>
		<cfinvoke component="rh.ExpDeportivo.componentes.EDTipoEstadisticas" 
		method="CAMBIO" returnvariable="rs" EDTEdescripcion = "#form.EDTEdescripcion#" EDTEid="#form.EDTEid#" />
		</cftransaction>
		<cfset params = params & "&EDTEid=#form.EDTEid#">

<cfelseif isdefined("form.BAJA")>
	<cftransaction>
	<cfinvoke component="rh.ExpDeportivo.componentes.EDTipoEstadisticas" method="BAJA" returnvariable="rs" 
	EDTEid="#form.EDTEid#" 
	EDTEdescripcion="#form.EDTEdescripcion#" 
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
<cflocation url="tiposestadisticas.cfm#params#">
</cfif>

