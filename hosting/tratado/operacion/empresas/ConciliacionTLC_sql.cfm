<cfdump var="#form#">
<cfdump var="#url#">

<!--- TLCEmpresasImp --->
<cfquery name="rsTLCEmpresasImp" datasource="#session.DSN#" maxrows="1">
	select 
		Rep,
		Tel,
		Fax,
		Address,
		POBox,
		email
	from TLCEmpresasImp
	where Company = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Company#">
</cfquery>
<cfdump var="#rsTLCEmpresasImp#" label="Datos para hacer el update">

<cftransaction action="begin">
	<cfquery name="rs" datasource="#session.DSN#">
		select ETLCnomRepresentante,
				ETLCtel1Representante,
				ETLCtel2Representante,
				ETLCdir1Representante,
				ETLCdir2Representante,
				ETLCdir3Representante 
		from EmpresasTLC where ETLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETLCid#">
	</cfquery>
	<cfdump var="#rs#" label="EmpresasTLC Antes del update">

	<cfif isdefined("rsTLCEmpresasImp") and rsTLCEmpresasImp.recordcount gt 0>
		<cfquery datasource="#session.DSN#">
			update EmpresasTLC set
				ETLCnomRepresentante =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTLCEmpresasImp.Rep#">,
				ETLCtel1Representante = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTLCEmpresasImp.Tel#">,
				ETLCtel2Representante = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTLCEmpresasImp.Fax#">,
				<!--- ETLCdir1Representante = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTLCEmpresasImp.Address#">, como es un varchar de 20 guandan el id_direccion del tag de direcciones :( --->
				ETLCdir2Representante = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTLCEmpresasImp.POBox#">,
				ETLCdir3Representante = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTLCEmpresasImp.email#">
			where ETLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETLCid#">
		</cfquery>
	</cfif>
	<cfquery name="rs" datasource="#session.DSN#">
		select ETLCnomRepresentante,
				ETLCtel1Representante,
				ETLCtel2Representante,
				ETLCdir1Representante,
				ETLCdir2Representante,
				ETLCdir3Representante
		from EmpresasTLC where ETLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETLCid#">
	</cfquery>
	<cfdump var="#rs#" label="EmpresasTLC Despues del Update">
	
	<!--- EmpresasTLC --->  
	
	<cfquery name="rs" datasource="#session.DSN#">
		select * from TLCEmpresasImp where Company = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Company#">
	</cfquery>
	<cfdump var="#rs#" label="TLCEmpresasImp Antes del Update">
	
	<cfquery name="rsEmpresasTLC" datasource="#session.DSN#">
		select ETLCpatrono
		from EmpresasTLC
		where ETLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETLCid#">
	</cfquery>
	 <cfif isdefined("rsEmpresasTLC") and rsEmpresasTLC.recordcount gt 0>
		<cfquery datasource="#session.DSN#">
			update TLCEmpresasImp
				set Encontrado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpresasTLC.ETLCpatrono#">
			where Company = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Company#">
		</cfquery>
	</cfif>
	
	<cfquery name="rs" datasource="#session.DSN#">
		select * from TLCEmpresasImp where Company = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Company#">
	</cfquery>
	<cfdump var="#rs#" label="TLCEmpresasImp Despues del Update">

	<cftransaction action="rollback"/>
</cftransaction>