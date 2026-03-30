<cfif isdefined("form.ALTA")>
	<cftransaction>
	<cfset vfecha = createdatetime( year(LSParseDateTime(form.BUfecha)) , month(LSParseDateTime(form.BUfecha)), day((LSParseDateTime(form.BUfecha))), hour(now()), minute(now()), second(now()) ) >  
	<cfquery name="insert" datasource="sifcontrol">
		insert BenzigerUsuario(	BUidentificacion, 
								BUnombre, 
								BUapellido1, 
								BUapellido2, 
								BUfecha, 
								BUcompanyname, 
								BUbuAddress, 
								BUbuphone, 
								BUbuemail, 
								BUphone, 
								BUaddress, 
								BUemail )
		values (	<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.BUidentificacion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.BUnombre#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.BUapellido1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.BUapellido2#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp"	value="#vfecha#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.BUcompanyname#"	null="#len(trim(form.BUcompanyname)) eq 0#" >,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.BUbuAddress#" 		null="#len(trim(form.BUbuAddress)) eq 0#" >,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.BUbuphone#" 		null="#len(trim(form.BUbuphone)) eq 0#" >,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.BUbuemail#" 		null="#len(trim(form.BUbuemail)) eq 0#" >,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.BUphone#" 			null="#len(trim(form.BUphone)) eq 0#" >,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.BUaddress#" 		null="#len(trim(form.BUaddress)) eq 0#" >,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.BUemail#" 			null="#len(trim(form.BUemail)) eq 0#" > )

		<cf_dbidentity1 datasource="sifcontrol">
	</cfquery>	
	<cf_dbidentity2 datasource="sifcontrol" name="insert">
	</cftransaction>
	<cflocation url="pccontestar.cfm?BUid=#insert.identity#&PCcodigo=#form.PCcodigo#">
<cfelseif isdefined("form.CAMBIO")>
	<cfquery name="insert" datasource="sifcontrol">
		update BenzigerUsuario
		set BUidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.BUidentificacion#">, 
			BUnombre = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.BUnombre#">, 
			BUapellido1 = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.BUapellido1#">, 
			BUapellido2 = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.BUapellido2#">, 
			BUcompanyname = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.BUcompanyname#"	null="#len(trim(form.BUcompanyname)) eq 0#" >,
			BUbuAddress = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.BUbuAddress#" 		null="#len(trim(form.BUbuAddress)) eq 0#" >,
			BUbuphone = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.BUbuphone#" 		null="#len(trim(form.BUbuphone)) eq 0#" >,
			BUbuemail = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.BUbuemail#" 		null="#len(trim(form.BUbuemail)) eq 0#" >,
			BUphone = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.BUphone#" 			null="#len(trim(form.BUphone)) eq 0#" >,
			BUaddress = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.BUaddress#" 		null="#len(trim(form.BUaddress)) eq 0#" >, 
			BUemail = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.BUemail#" 			null="#len(trim(form.BUemail)) eq 0#" > 
		where BUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BUid#">
	</cfquery>	
	<cflocation url="pccontestar.cfm?BUid=#form.BUid#&PCcodigo=#form.PCcodigo#">

<cfelseif isdefined("form.GENERAR")>
	
	<cfparam name="form.PCcodigo" default="BTSAes">
	<cfset form.PCid = 0 >
	<cfif isdefined("form.PCcodigo") and len(trim(form.PCcodigo))>
		<cfquery name="rsCuestionario" datasource="sifcontrol" >
			select PCid
			from PortalCuestionario
			where upper(PCcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(form.PCcodigo)#">
		</cfquery>
		<cfif len(trim(rsCuestionario.PCid)) eq 0 >
			<cfthrow message="No se ha definido el cuestionario.">
		</cfif>
		<cfset form.PCid = rsCuestionario.PCid >
	</cfif>
	
	<cfset form.PCUid = 0 >
	<cfif isdefined("form.BUid") and len(trim(form.BUid)) >
		<cfquery name="rsContestado" datasource="sifcontrol">
			select a.PCUid
			from PortalCuestionarioU a
			where a.BUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BUid#">
		</cfquery>
		<cfif len(trim(rsContestado.PCUid))>
			<cfset form.PCUid = rsContestado.PCUid >
		</cfif>
	</cfif>	

	<cfinvoke component="sif.rh.Componentes.RH_Benziger" method="procesar_persona">
		<cfinvokeargument name="PCid" 	value="#form.PCid#">
		<cfinvokeargument name="PCUid" 	value="#form.PCUid#">
		<cfinvokeargument name="BUid" 	value="#form.BUid#">	
	</cfinvoke>
</cfif>



