<cfparam name="Attributes.datasource" 			type="string" default="">
<cfparam name="Attributes.datasourcepackage" 	type="string" default=""><!----- indica el datasoruce donde se encuentra el paquete----->
<cfparam name="Attributes.name"       			type="string">
<cfparam name="Attributes.returnvariable" 		type="string" default="">
 
<!--- Validar el datasource --->
<cfif Len(Attributes.datasource) Is 0>
	<cfif IsDefined('session.dsn') and Len(session.dsn) neq 0>
		<cfset Attributes.datasource = session.dsn>
	<cfelse>
		<cf_errorCode	code = "50597" msg = "Falta el atributo datasource, y session.dsn no está definida.">
	</cfif>
</cfif>

<!--- Asegurarse de que la informacion sobre las conexiones este disponible --->
<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" datasource="#Attributes.datasource#"  />
</cfif>
<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
	<cf_errorCode	code = "50599"
					msg  = "Datasource no definido: @errorDat_1@"
					errorDat_1="#HTMLEditFormat(Attributes.datasource)#"
	>
</cfif>

<!--- Validar el name --->
<cfif Len(Attributes.name) Is 0>
	<cf_errorCode	code = "50640" msg = "Debe especificar el atributo name">
</cfif>
<cfif Not IsDefined('Caller.dbidentity1_invoked') Or Caller.dbidentity1_invoked Neq 1>
	<cf_errorCode	code = "50641" msg = "Antes de usar cf_dbidentity2 debe haber usado cf_dbidentity1.">
</cfif>

<cfset Caller.dbidentity1_invoked = 0>

<cfif (Application.dsinfo[Attributes.datasource].type is 'sybase') >
	<!--- desenmascarar el dato que viene desde dbidentity1.cfm --->
	<cftry>
			<cfset newidentity = Caller[Attributes.name].dbidentity_tmp>
		<cfcatch type="any">
			<cfset newidentity = Caller[Attributes.name][ListGetAt(Caller[Attributes.name].columnList,1)]>
		</cfcatch>
	</cftry>

<cfelseif Application.dsinfo[Attributes.datasource].type is 'sqlserver'>

	<cftry>
		<cfset newidentity = Caller[Attributes.name].dbidentity_tmp>
		<cfcatch type="any">
			<cftry>
				<cfset newidentity = Caller[Attributes.name][ListGetAt(Caller[Attributes.name].columnList,1)]>
	 
				<cfcatch type="any">
								<!--- funciona distinto a sybase.  Ver nota en dbidentity1.cfm --->
					<cfquery datasource="#Attributes.datasource#" name="dbidentity">
						select @@identity as dbidentity
					</cfquery>
					<cfset newidentity = dbidentity.dbidentity>
				</cfcatch>	
			</cftry>

		</cfcatch>
	</cftry>


<cfelseif Application.dsinfo[Attributes.datasource].type is 'db2'>
	<cfquery datasource="#Attributes.datasource#" name="dbidentity">
		select identity_val_local() as dbidentity from dual
	</cfquery>
	<cfset newidentity = dbidentity.dbidentity>
<cfelseif Application.dsinfo[Attributes.datasource].type is 'oracle'>
	<cfquery datasource="#Attributes.datasource#" name="dbidentity">
		<cfif len(trim(Attributes.datasourcepackage))><!---- este atributo permite indicar dónde se encuentra el paquete----->
			select <cf_dbdatabase table="soinpk.identity" datasource="#Attributes.datasourcepackage#"> as dbidentity from dual
		<cfelse>	
			select  soinpk.identity as dbidentity from dual
		</cfif>
	</cfquery>
	<cfset newidentity = dbidentity.dbidentity>
<cfelse>
	<cf_errorCode	code = "50628"
					msg  = "DBMS no soportado: @errorDat_1@"
					errorDat_1="#Application.dsinfo[Attributes.datasource].type#"
	>
</cfif>

<cfif Not IsDefined('newidentity') Or Len(newidentity) Is 0 Or newidentity Is 0>
	<cf_errorCode	code = "50642"
					msg  = "No se puede obtener un consecutivo. Datasource: @errorDat_1@, Query: @errorDat_2@"
					errorDat_1="#Attributes.datasource#"
					errorDat_2="#Attributes.name#"
	>
</cfif>
<cfset retquery = QueryNew("identity")>
<cfset QueryAddRow(retquery)>
<cfset retquery.identity = newidentity>
<cfset Caller[Attributes.name] = retquery>
<cfif Attributes.returnvariable NEQ "">
	<cfset Caller[Attributes.returnvariable] = newidentity>
</cfif>


