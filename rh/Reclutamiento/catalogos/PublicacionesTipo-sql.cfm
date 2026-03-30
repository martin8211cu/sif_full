
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_ErrorIntegridadReferencialPub"
	default="No se puede eliminar el tipo de publicación seleccionada ya que esta siendo utilizada por un funcionario"
	xmlFile="/rh/generales.xml"
	returnvariable="MSG_ErrorIntegridadReferencial"/>

<cfif isdefined ('Alta')>
	<cfquery name="rsExistCodPubTip" datasource="#session.dsn#">
		select count(1) as cantidad 
		from RHPublicacionTipo 
		where RHPTcodigo = upper(<cfqueryparam cfsqltype="cf_sql_char" value="#form.cod#" />)
	</cfquery>

	<cfif rsExistCodPubTip.cantidad gt 0 >
		<cf_errorCode	code="51867" msg="Error! Ese código ya fue registrado.">
	</cfif>

	<cfquery name="rsInsPubTip" datasource="#session.dsn#">
		insert into RHPublicacionTipo (RHPTcodigo,RHPTDescripcion)
		values(upper(<cfqueryparam cfsqltype="cf_sql_char" value="#form.cod#" />), <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.descrip#" />)
		<cf_dbidentity1 datasource="#session.DSN#" name="rsInsPubTip">
	</cfquery>

	<cf_dbidentity2 datasource="#session.DSN#" name="rsInsPubTip" returnvariable="LvarRHPTid">
    <cf_translatedata name="set" tabla="RHPublicacionTipo" col="RHPTDescripcion" valor="#form.descrip#" filtro=" RHPTid=#LvarRHPTid# ">
	<cflocation url="PublicacionesTipo.cfm?RHPTid=#LvarRHPTid#">
</cfif>

<cfif isdefined ('Nuevo')>
	<cflocation url="PublicacionesTipo.cfm">
</cfif>

<cfif isdefined ('Cambio')>
	<cfquery name="rsExistCodPubTip" datasource="#session.dsn#">
		select count(1) as cantidad 
		from RHPublicacionTipo 
		where RHPTcodigo = upper(<cfqueryparam cfsqltype="cf_sql_char" value="#form.cod#" />)
		and RHPTid not in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTid#" />)
	</cfquery>

	<cfif rsExistCodPubTip.cantidad gt 0 >
		<cf_errorCode	code="51867" msg="Error! Ese código ya fue registrado.">
	</cfif>

	<cfquery name="rsUpdPubTip" datasource="#session.dsn#">
		update RHPublicacionTipo 
			set RHPTcodigo = upper(<cfqueryparam cfsqltype="cf_sql_char" value="#form.cod#" />), 
			RHPTDescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.descrip#" />
		where RHPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTid#" />
	</cfquery>
    <cf_translatedata name="set" tabla="RHPublicacionTipo" col="RHPTDescripcion" valor="#form.descrip#" filtro=" RHPTid=#form.RHPTid# ">
	<cflocation url="PublicacionesTipo.cfm?RHPTid=#form.RHPTid#">
</cfif>

<cfif isdefined ('Baja')>
	<cfquery name="rsValIntegPubTip" datasource="#session.dsn#">
		select count(1) as exist 
		from RHPublicaciones
		where RHPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTid#" /> 
	</cfquery>

	<cfif !rsValIntegPubTip.exist>
		<cfquery name="rsDelPub" datasource="#session.dsn#">
			delete from RHPublicacionTipo 
			where RHPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTid#" />
		</cfquery>
	<cfelse>
		<cf_throw message="#MSG_ErrorIntegridadReferencial#" />
	</cfif>
	
	<cflocation url="PublicacionesTipo.cfm">
</cfif>
