<cfif isdefined ('form.Lista')>
	<cflocation url="Cuentas.cfm">
</cfif>
<cfif isdefined('form.Importar')>
	<cflocation url="CuentasImportador.cfm">
</cfif>
<cfif isdefined ('form.ALTA')>
<cfquery name="rsValida" datasource="#session.dsn#">
	select rtrim(MIGCuecodigo) as MIGCuecodigo
	from MIGCuentas
	where MIGCuecodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.MIGCuecodigo)#">
	and Ecodigo=#session.Ecodigo#
</cfquery>
<cfif rsValida.recordCount EQ 0>
		<cftransaction>
			<cfinvoke component="mig.Componentes.Cuentas" method="Alta" returnvariable="LvarMIGCueid">
				<cfinvokeargument name="MIGCuecodigo" 	value="#form.MIGCuecodigo#"/>
				<cfinvokeargument name="MIGCuedescripcion" 	value="#form.MIGCuedescripcion#"/>
				<cfinvokeargument name="MIGCuetipo" 	value="#form.MIGCuetipo#"/>
				<cfinvokeargument name="MIGCuesubtipo" 	value="#form.MIGCuesubtipo#"/>
				<cfinvokeargument name="Dactiva" 		value="#form.Dactiva#"/>
				<cfinvokeargument name="CodFuente" 		value="1"/>
			</cfinvoke>	
		</cftransaction>
		<cfset modo='CAMBIO'>
		<cflocation url="Cuentas.cfm?MIGCueid=#LvarMIGCueid#&modo=#modo#">
<cfelse>
	<cfthrow type="toUser" message="El Código de Cuenta #rsValida.MIGCuecodigo# ya existe en Sistema.">
</cfif>

</cfif>
<cfif isdefined ('form.CAMBIO')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Cuentas" method="Cambio" >
			<cfinvokeargument name="MIGCuedescripcion" 	value="#form.MIGCuedescripcion#"/>
			<cfinvokeargument name="MIGCuetipo" 	value="#form.MIGCuetipo#"/>
			<cfinvokeargument name="MIGCuesubtipo" 	value="#form.MIGCuesubtipo#"/>
			<cfinvokeargument name="MIGCueid" 		value="#form.MIGCueid#"/>
			<cfinvokeargument name="Dactiva" 		value="#form.Dactiva#"/>
		</cfinvoke>	
	</cftransaction>
	<cfset modo='CAMBIO'>
	<cflocation url="Cuentas.cfm?MIGCueid=#form.MIGCueid#&modo=#modo#">
</cfif>
<cfif isdefined ('form.BAJA')>
<cfquery name="Valida" datasource="#Session.DSN#">
	select a.MIGMid, b.MIGMcodigo
	from MIGFiltrosmetricas a
		left join MIGMetricas b
			on a.MIGMid=b.MIGMid
			and a.Ecodigo=b.Ecodigo
	where a.MIGMdetalleid=<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.MIGCueid#" >
	and a.MIGMtipodetalle='C'
	and  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
</cfquery>
<cfquery name="Valida2" datasource="#Session.DSN#">
	select MIGMid
	from F_Datos
	where MIGCueid=<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.MIGCueid#" >
	and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
</cfquery>
<cfif Valida.recordCount GT 0 or Valida2.recordCount GT 0>
	<cfthrow type="toUser" message="La Cuenta no puede ser eliminada ya que tiene asociaciones.">	
<cfelse>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Cuentas" method="Baja" >
			<cfinvokeargument name="MIGCueid" 		value="#form.MIGCueid#"/>
		</cfinvoke>	
	</cftransaction>
	<cflocation url="Cuentas.cfm">
</cfif>

</cfif>
<cfif isdefined ('form.Nuevo')>
	<cflocation url="Cuentas.cfm?Nuevo">
</cfif>

