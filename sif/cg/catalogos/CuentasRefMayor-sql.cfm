
<!---***** Determina si el modo es tipo cambio, si es asi, reliza la operacion de modificar *******--->
<cfif IsDefined("form.Cambio")>	
	<cf_dbtimestamp datasource="#session.DSN#"
		table="PCDCatalogoRefMayor"
		redirect="CuentasRefMayor.cfm"
		timestamp="#form.ts_rversion#"
		
		field1="PCDcatid"
		type1="numeric"
		value1="#form.PCDcatid#"
		
		field2="Ecodigo"
		type2="integer"
		value2="#Session.Ecodigo#"
		
		field3="Cmayor"
		type3="char"
		value3="#form.Cmayor_ant#"
		
		field4="PCEcatidref"
		type4="numeric"
		value4="#form.PCEcatidref_ant#">
		

	<cfquery name="update" datasource="#session.DSN#">
		update PCDCatalogoRefMayor
		set 
		Cmayor= <cfqueryparam value="#Form.Cmayor#" cfsqltype="cf_sql_char">,
		PCEcatidref = <cfqueryparam value="#Form.PCEcatidref#" cfsqltype="cf_sql_numeric">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
		and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor_ant#">
		and PCEcatidref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatidref_ant#">
	</cfquery> 

<!---***** Determina si el modo es tipo Baja, si es asi, reliza la operacion de elimianar *******--->
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from PCDCatalogoRefMayor
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and  PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
			and  Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">
			and  PCEcatidref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatidref#">
	</cfquery>

<!---***** Determina si el modo es tipo Alta, si es asi, reliza la operacion de insertar *******--->
<cfelseif IsDefined("form.Alta")>
	<cfquery name="rsValida" datasource="#session.DSN#">
		select  
			count(1) as cantidad
		from PCDCatalogoRefMayor 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">
			and  PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
	</cfquery>
	
	<cfif isdefined("rsValida") and rsValida.cantidad gt 0>
		<cf_errorCode	code = "50217" msg = "La cuenta mayor que intenta agregar ya existe">
		<cfabort>
	<cfelse>
		<cfquery datasource="#session.dsn#">
			insert into PCDCatalogoRefMayor (PCDcatid,  Ecodigo, Cmayor, PCEcatidref, BMUsucodigo)
			   values(	
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">,
					<cfqueryparam cfsqltype= "cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatidref#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
		</cfquery>
	</cfif>
</cfif>
<!---************** Se encarga de mandar por url, los parametros al formulario ****************--->
<cfset LvarIncVal = "">
<cfif isdefined("Form.IncVal")>
	<cfset LvarIncVal = "&IncVal=1">
</cfif>
<cflocation url="CuentasRefMayor.cfm?PCEcatid=#form.PCEcatid#&PCDcatid=#form.PCDcatid#&Cmayor=#form.Cmayor#&PCEcatidref=#form.PCEcatidref##LvarIncVal#">

