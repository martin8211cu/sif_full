<cfparam name="Attributes.datasource" 	type="string"	default="">
<cfparam name="Attributes.setting" 		type="string" 	default="">
<cfparam name="Attributes.table" 		type="string" 	default="">

<!--- Validar el datasource --->
<cfif Len(Attributes.datasource) Is 0>
	<cfif IsDefined('session.dsn') and Len(session.dsn) neq 0>
		<cfset Attributes.datasource = session.dsn>
	<cfelse>
		<cfthrow message="Falta el atributo datasource, y session.dsn no est&aacute; definida.">
	</cfif>
</cfif>

<!--- Validar el setting --->
<cfif Len(Attributes.setting) Is 0>
	<cfthrow message="Falta el atributo 'setting' (ON,OFF).">
<cfelseif ucase(Attributes.setting) NEQ "ON" AND ucase(Attributes.setting) NEQ "OFF">
	<cfthrow message="El atributo 'setting' solo puede tener los valores: ON,OFF.">
</cfif>
<!--- Validar el table --->
<cfif Len(Attributes.table) Is 0>
	<cfthrow message="Falta el atributo 'table'.">
</cfif>

<!--- Asegurarse de que la informacion sobre las conexiones este disponible --->
<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
	<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" datasource="#Attributes.datasource#" />
</cfif>
<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
	<cfthrow message="Datasource no definido: #HTMLEditFormat(Attributes.datasource)#">
</cfif>

<cfif ListFind('sybase,sqlserver', Application.dsinfo[Attributes.datasource].type)>
	<cfquery datasource="#Attributes.datasource#">
		set identity_insert #Attributes.Table# #Attributes.Setting#
	</cfquery>
<cfelseif Application.dsinfo[Attributes.datasource].type is 'oracle'>
	<cfstoredproc procedure="SOINPK.SET_IDENTITY_INSERT_#Attributes.Setting#" datasource="#Attributes.datasource#" />
<cfelse>
	<cfthrow message="No se ha implementado para esta base de datos">
</cfif>
