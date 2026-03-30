<cfif isdefined('form.ALTA')>
	<cfquery name="rsExiste" datasource="#session.dsn#">
		select count(1) as existe from Peaje 
			where Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codPeaje#">
	</cfquery>
	<cfif rsExiste.existe>
		<cfoutput>
		<script language="javascript1.2" type="text/javascript">
			alert("El código del Peaje digitado ya existe. Digite otro código.");
			history.back(-1);
		</script>
		</cfoutput>
	<cfelse>
		<cfinvoke component="conavi.Componentes.peajes"
			method="ALTA"
			Pcodigo="#form.codPeaje#"
			Ecodigo="#form.Ecodigo#"
			CFid="#form.CFid#"
			Pcarriles="#form.cantCarriles#"
			cuentac="#form.codCuentaC#"
			Pdescripcion="#form.descripcion#"
			MBUsucodigo="#form.MBUsucodigo#"
			FPAEid="#form.Cfcomplemento_AllID#"
			CFComplemento="#form.Cfcomplemento_All_Valores#"
			returnvariable="LvarId"
		/>
		<cflocation url="peajes.cfm?modo=CAMBIO&Pid=#LvarId#">
	</cfif>
<cfelseif isdefined('form.CAMBIO')>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="Peaje"
		redirect="peajes.cfm?modo=CAMBIO&Pid=#form.Pid#"
		timestamp="#form.ts_rversion#"
		field1="Pid" 
		type1="numeric" 
		value1="#form.Pid#"
		field2="Ecodigo" 
		type2="numeric" 
		value2="#form.Ecodigo#">
	<cfquery name="rsExiste" datasource="#session.dsn#">
		select count(1) as existe from Peaje 
			where Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codPeaje#">
			and Pid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Pid#">
	</cfquery>
	<cfif rsExiste.existe>
		<cfoutput>
		<script language="javascript1.2" type="text/javascript">
			alert("El código del Peaje digitado ya existe. Digite otro código.");
			history.back(-1);
		</script>
		</cfoutput>
	<cfelse>
	<cfif len(#form.Cfcomplemento_AllID#) eq 0>
	  <cfset form.Cfcomplemento_AllID = -1>
	</cfif>
		<cfinvoke component="conavi.Componentes.peajes"
			method="CAMBIO"
			Pid="#form.Pid#"
			Pcodigo="#form.codPeaje#"
			Ecodigo="#form.Ecodigo#"
			CFid="#form.CFid#"
			Pcarriles="#form.cantCarriles#"
			cuentac="#form.codCuentaC#"
			Pdescripcion="#form.descripcion#"
			MBUsucodigo="#form.MBUsucodigo#"
			FPAEid="#form.Cfcomplemento_AllID#"
			CFComplemento="#form.Cfcomplemento_All_Valores#"
			returnvariable="LvarId"
		/>
		<cflocation url="peajes.cfm?modo=CAMBIO&Pid=#LvarId#">
	</cfif>
<cfelseif isdefined('form.BAJA')>
	<cfinvoke component="conavi.Componentes.peajes"
		method="BAJA"
		Pid="#form.Pid#"
		Pcodigo="#form.codPeaje#"
		Ecodigo="#form.Ecodigo#"
		returnvariable="LvarId"
	/>
	<cflocation url="peajes.cfm?modo=ALTA">
<cfelse>
	<cflocation url="peajes.cfm?modo=ALTA">
</cfif>