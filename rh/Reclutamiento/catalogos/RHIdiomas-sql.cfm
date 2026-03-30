<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_ErrorIntegridadReferencialO"
	default="No se puede eliminar el idioma seleccionado ya que esta siendo utilizado por un oferente"
	xmlFile="/rh/generales.xml"
	returnvariable="MSG_ErrorIntegridadReferencial"/>

<cfif isdefined ('Alta')>
	<cfquery name="rsExistCod" datasource="#session.dsn#">
		select count(1) as cantidad 
		from RHIdiomas 
		where RHIcodigo = upper(<cfqueryparam cfsqltype="cf_sql_char" value="#form.cod#" />)
	</cfquery>

	<cfif rsExistCod.cantidad gt 0 >
		<cf_errorCode	code="51867" msg="Error! Ese código ya fue registrado.">
	</cfif>

	<cfquery name="rsIns" datasource="#session.dsn#">
		insert into RHIdiomas (RHIcodigo,RHDescripcion)
		values(upper(<cfqueryparam cfsqltype="cf_sql_char" value="#form.cod#" />), <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.descrip#" />)
		<cf_dbidentity1 datasource="#session.DSN#" name="rsIns">
	</cfquery>

	<cf_dbidentity2 datasource="#session.DSN#" name="rsIns" returnvariable="LvarRHIid">
    <cf_translatedata name="set" tabla="RHIdiomas" col="RHDescripcion" valor="#form.descrip#" filtro=" RHIid=#LvarRHIid# ">
	<cflocation url="RHIdiomas.cfm?RHIid=#LvarRHIid#">
</cfif>

<cfif isdefined ('Nuevo')>
	<cflocation url="RHIdiomas.cfm">
</cfif>

<cfif isdefined ('Cambio')>
	<cfquery name="rsExistCod" datasource="#session.dsn#">
		select count(1) as cantidad 
		from RHIdiomas 
		where RHIcodigo = upper(<cfqueryparam cfsqltype="cf_sql_char" value="#form.cod#" />)
		and RHIid not in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIid#" />) 
	</cfquery>

	<cfif rsExistCod.cantidad gt 0 >
		<cf_errorCode	code="51867" msg="Error! Ese código ya fue registrado.">
	</cfif>

	<cfquery name="rsUpd" datasource="#session.dsn#">
		update RHIdiomas 
			set RHIcodigo = upper(<cfqueryparam cfsqltype="cf_sql_char" value="#form.cod#" />), 
			RHDescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.descrip#" />
		where RHIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIid#" />
	</cfquery>
    <cf_translatedata name="set" tabla="RHIdiomas" col="RHDescripcion" valor="#form.descrip#" filtro=" RHIid=#form.RHIid# ">
	<cflocation url="RHIdiomas.cfm?RHIid=#form.RHIid#">
</cfif>
		
<cfif isdefined ('Baja')>
	<cfquery name="rsValInteg" datasource="#session.dsn#">
		select count(1) as exist 
		from DatosOferentes
		where RHOIdioma1 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIid#" />
		or RHOIdioma2 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIid#" />
		or RHOIdioma3 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIid#" />
		or RHOIdioma4 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIid#" /> 
	</cfquery>

	<cfif !rsValInteg.exist>
		<cfquery name="rsDel" datasource="#session.dsn#">
			delete from RHIdiomas 
			where RHIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIid#" />
		</cfquery>
	<cfelse>
		<cf_throw message="#MSG_ErrorIntegridadReferencial#" />
	</cfif>
	
	<cflocation url="RHIdiomas.cfm">
</cfif>
