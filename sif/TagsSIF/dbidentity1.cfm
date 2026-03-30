<cfparam name="Attributes.datasource" type="string" default="">
 
<!--- Validar el datasource --->
<cfif Len(Attributes.datasource) Is 0>
	<cfif IsDefined('session.dsn') and Len(session.dsn) neq 0>
		<cfset Attributes.datasource = session.dsn>
	<cfelse>
		<cf_errorCode	code = "50597" msg = "Falta el atributo datasource, y session.dsn no está definida.">
	</cfif>
</cfif>

<!--- Asegurarse de que la informacion sobre las conexiones este disponible --->
<cfif (Not IsDefined('Application.dsinfo')) OR (Not StructKeyExists(Application.dsinfo, Attributes.datasource))>
	<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" datasource="#Attributes.datasource#" />
</cfif>
<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
	<cf_errorCode	code = "50599"
					msg  = "Datasource no definido: @errorDat_1@"
					errorDat_1="#HTMLEditFormat(Attributes.datasource)#"
	>
</cfif>

<cfif Application.dsinfo[Attributes.datasource].type is 'sybase'><!---
		no puedo usar identityval() con preparedStatement en ciertos casos, porque daría
		el siguiente error de Sybase:
			"Variable is not allowed in procedure"
		Esto ocurrió con sybase 12.5.1, usando jconnect
		No aplica para mssql.  Se probó y en algunos casos no funciona.  Específicamente en el
		botón de aplicar en adquisición de activos, AF_AltaActivosAdq.cfc:319.
	 --->
	<cfoutput>
		select @@identity dbidentity_tmp
	</cfoutput>
<cfelseif Application.dsinfo[Attributes.datasource].type is 'sqlserver'>
	<cfoutput>
		select SCOPE_IDENTITY() as dbidentity_tmp 	
	</cfoutput>

<cfelse>





	<!--- Hay que llamar al cf_dbidentity2 --->
</cfif>

<cfset Caller.dbidentity1_invoked = 1>


