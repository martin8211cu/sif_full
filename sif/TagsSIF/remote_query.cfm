<cfparam name="Attributes.datasource" 	type="string">
<cfparam name="Attributes.name" 		type="string" default="rs">
<cfparam name="Attributes.update" 		type="boolean" default="no">

<cfif Not ThisTag.HasEndTag>
	<cf_errorCode	code = "50690" msg = "cf_jdbcquery debe tener un tag de cierre">
</cfif>

<cfif LCase( ThisTag.ExecutionMode ) is 'end'>
	<cfset LvarSQL = ThisTag.GeneratedContent>
	<cfset ThisTag.GeneratedContent = "">
	<cfset LvarWSsec = createobject("component","sif.Componentes.WS.Componentes")>
	<cfset LvarWSkey = LvarWSsec.AuthorizedKey()>
	<cftry>
		<cfinvoke 	webservice		= "http://#SERVER_NAME#:#SERVER_PORT#/cfmx/sif/Componentes/WS/Componentes.cfc?WSDL"
					method			= "remote_query"
					returnvariable	= "rsSQL"
					
					WSkey			= "#LvarWSkey#" 
					datasource		= "#Attributes.datasource#"
					sql				= "#LvarSQL#"
		/>
	<cfcatch type="any">
		<cfset LvarWSsec = createobject("component","sif.Componentes.WS.Componentes")>
		<cfthrow object="#LvarWSsec.getWSerror(cfcatch)#"> 
	</cfcatch>
	</cftry>
	<cfset Caller[Attributes.name] = rsSQL>			
	<cfreturn rsSQL>
</cfif>