<cfparam name="Attributes.datasource" type="string" default="">
<cfparam name="Attributes.name"       type="string">
<cfparam name="Attributes.returnvariable" type="string" default="">

<!--- Validar el datasource --->
<cfif Len(Attributes.datasource) Is 0>
	<cfif IsDefined('session.dsn') and Len(session.dsn) neq 0>
		<cfset Attributes.datasource = session.dsn>
	<cfelse>
		<cfthrow message="Falta el atributo datasource, y session.dsn no est&aacute; definida.">
	</cfif>
</cfif>

<!--- Asegurarse de que la informacion sobre las conexiones este disponible --->
<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" datasource="#Attributes.datasource#"  />
</cfif>
<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
	<cfthrow message="Datasource no definido: #HTMLEditFormat(Attributes.datasource)#">
</cfif>

<!--- Validar el name --->
<cfif Len(Attributes.name) Is 0>
	<cfthrow message="Debe especificar el atributo name">
</cfif>
<cfif Not IsDefined('Caller.dbidentity1 _invoked') Or Caller.dbidentity1 _invoked Neq 1>
	<cfthrow message="Antes de usar cf_dbidentity2  debe haber usado cf_dbidentity1 .">
</cfif>

<cfset Caller.dbidentity1 _invoked = 0>

<cfif Application.dsinfo[Attributes.datasource].type is 'sybase'>
	<!--- desenmascarar el dato que viene desde dbidentity1 .cfm --->
	<cfset newidentity = Caller[Attributes.name].dbidentity_tmp>
<cfelseif Application.dsinfo[Attributes.datasource].type is 'sqlserver'>
	<!--- funciona distinto a sybase.  Ver nota en dbidentity1 .cfm --->
	<cfquery datasource="#Attributes.datasource#" name="dbidentity">
		select @@identity as dbidentity
	</cfquery>
	<cfset newidentity = dbidentity.dbidentity>
<cfelseif Application.dsinfo[Attributes.datasource].type is 'db2'>
	<cfquery datasource="#Attributes.datasource#" name="dbidentity">
		select identity_val_local() as dbidentity from dual
	</cfquery>
	<cfset newidentity = dbidentity.dbidentity>
<cfelseif Application.dsinfo[Attributes.datasource].type is 'oracle'>
	<cfquery datasource="#Attributes.datasource#" name="dbidentity">
		select soinpk.identity dbidentity from dual
	</cfquery>
	<cfset newidentity = dbidentity.dbidentity>
<cfelse>
	<cfthrow message="DBMS no soportado: #Application.dsinfo[Attributes.datasource].type#">
</cfif>

<cfif Not IsDefined('newidentity') Or Len(newidentity) Is 0 Or newidentity Is 0>
	<cfthrow message="No se puede obtener un consecutivo.  Datasource: #Attributes.datasource#, Query: #Attributes.name#">
</cfif>
<cfset retquery = QueryNew("identity")>
<cfset QueryAddRow(retquery)>
<cfset retquery.identity = newidentity>
<cfset Caller[Attributes.name] = retquery>
<cfif Attributes.returnvariable NEQ "">
	<cfset Caller[Attributes.returnvariable] = newidentity>
</cfif>
