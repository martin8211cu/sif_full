<cfset params = "?TEid=#form.TEid#">

<cfif isdefined("form.ALTA")>

<cfquery name="rsExisteEmpleado" datasource="#Session.DSN#"> 
		select 1
		from DivisionEquipo
		where TEcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TEcodigo#"> or
		TEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TEdescripcion#">
	
		</cfquery>
			
		<cfif rsExisteEmpleado.recordCount GT 0>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_ElEquipoYaExiste"
				Default="El Equipo ya existe"
				returnvariable="MSG_ElEquipoYaExiste"/>
			<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#MSG_ElEquipoYaExiste#." addtoken="no">
			<cfabort> 
		</cfif>

	<cftransaction>

	<cfinvoke component="rh.ExpDeportivo.componentes.DivisionEquipo" method="ALTA" returnvariable="rs"  
	TEdescripcion="#form.TEdescripcion#" 
	TEcodigo= "#form.TEcodigo#" 
	conexion2="#session.dsn#"/>
	</cftransaction>
	<cfset params = params & "&TEid=#form.TEid#">

<cfelseif isdefined("form.CAMBIO")>
	<cf_dbtimestamp
		datasource="#session.dsn#"
		table="DivisionEquipo"
		redirect="DivisionEquipo.cfm"
		timestamp="#form.ts_rversion#"
		field1="TEid,numeric,#form.TEid#"
		>						
	
		<cftransaction>
		<cfinvoke component="rh.ExpDeportivo.componentes.DivisionEquipo" 
		method="CAMBIO" returnvariable="rs" TEdescripcion = "#form.TEdescripcion#" TEcodigo="#form.TEcodigo#" TEid="#form.TEid#" />
		</cftransaction>
		<cfset params = params & "&TEid=#form.TEid#">

<cfelseif isdefined("form.BAJA")>
	<cftransaction>
	<cfinvoke component="rh.ExpDeportivo.componentes.DivisionEquipo" method="BAJA" returnvariable="rs" 
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
var obj = window.parent.opener.document.getElementById('TEid');
obj.options[obj.length] = new Option("#form.TEcodigo# - #form.TEdescripcion#", "#rs.identity#");
obj.selectedIndex=obj.length-1;
window.close();
</script>
</cfoutput>
<cfelse>
<cflocation url="DivisionEquipo.cfm#params#">
</cfif>