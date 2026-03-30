<cfset params = "?EDid=#form.EDid#">
<cfif isdefined("form.ALTA")>
<cfquery name="rsExisteEmpleado" datasource="#Session.DSN#"> 
		select 1
		from Equipo
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ecodigo#"> and
		Edescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Edescripcion#">
	
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

</cfif>
<cfif isdefined("form.ALTA")>
	<cftransaction>

	<cfinvoke component="rh.ExpDeportivo.componentes.Equipos" method="ALTA" returnvariable="rs"  
	Edescripcion="#form.Edescripcion#" 
	Ecodigo= "#trim(form.Ecodigo)#"
	Etelefono1="#form.Etelefono1#"
	Efax="#form.Efax#"
	Edireccion="#form.Edireccion1#"
	Eciudad="#form.Eciudad#"
	Eprovincia="#form.Eprovincia#"
	Ppais="#form.Ppais#"
	BMUsucodigo ="#session.Usucodigo#" />
	conexion2="#session.dsn#"/>
	</cftransaction>
	<cfset params = params & "&EDid=#form.EDid#">

<cfelseif isdefined("form.CAMBIO")>
	<cf_dbtimestamp
		datasource="#session.dsn#"
		table="Equipo"
		redirect="Equipos.cfm"
		timestamp="#form.ts_rversion#"
		field1="EDid,numeric,#form.EDid#"
		>						
	
		<cftransaction>
		<cfinvoke component="rh.ExpDeportivo.componentes.Equipos" 
		method="CAMBIO" returnvariable="rs" Edescripcion = "#form.Edescripcion#" Ecodigo="#trim(form.Ecodigo)#" EDid="#form.EDid#"
		Etelefono1="#form.Etelefono1#"
		Efax="#form.Efax#"
		Edireccion="#form.Edireccion1#"
		Eciudad="#form.Eciudad#"
		Eprovincia="#form.Eprovincia#"
		Ppais="#form.Ppais#"
		BMUsucodigo ="#session.Usucodigo#" />
		</cftransaction>
		<cfset params = params & "&EDid=#form.EDid#">

<cfelseif isdefined("form.BAJA")>
	<cftransaction>
	<cfinvoke component="rh.ExpDeportivo.componentes.Equipos" method="BAJA" returnvariable="rs" 
	EDid="#form.EDid#" 
	Ecodigo="#form.Ecodigo#"
	Edescripcion="#form.Edescripcion#" 
	conexion="#session.dsn#"
	Etelefono1="#form.Etelefono1#"
	Efax="#form.Efax#"
	Edireccion="#form.Edireccion1#"
	Eciudad="#form.Eciudad#"
	Eprovincia="#form.Eprovincia#"
	Ppais="#form.Ppais#" />
	</cftransaction>
	<cfset params = params & "&EDid=#form.EDid#">

</cfif>

<cfif isdefined("form.popup") and form.popup eq "s">
<cfoutput>
<script>
var obj = window.parent.opener.document.getElementById('EDid');
obj.options[obj.length] = new Option("#form.Ecodigo# - #form.Edescripcion#", "#rs.identity#");
obj.selectedIndex=obj.length-1;
window.close();
</script>
</cfoutput>
<cfelse>
<cflocation url="Equipos.cfm#params#">
</cfif>


