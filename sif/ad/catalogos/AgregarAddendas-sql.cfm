<HTML>
	<head>
		<title>Agregar Addenda al Cliente</title>
	</head>
<body>
	<form name="lista" action="">
	<cfquery datasource="#session.dsn#" name="Validacion">
		select count(*) as valor
		from Addendas a
		where (a.Ecodigo is null or a.Ecodigo=#session.Ecodigo# )
		<cfif len(trim(form.ADDNombre)) gt 0  >
			 and upper(ADDNombre) like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(form.ADDNombre)#%">
		</cfif>

		<cfif len(trim(form.ADDcodigo)) gt 0  >
			 and upper(ADDcodigo) like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(form.ADDcodigo)#%">
		</cfif>
	</cfquery>

	<cfif #validacion.valor# neq 0 and len(trim(form.ADDNombre)) gt 0 and len(trim(form.ADDcodigo)) gt 0>
		<cfset Aux = #Validacion.valor# & " Ya hay una addenda con el mismo nombre y clave en la base de datos">
		<cfdump var=#Aux#>
		 <cfthrow message = #Aux#>
		<cflocation url="AgregarAddendas.cfm">
	<cfelseif len(trim(form.ADDNombre)) gt 0 and len(trim(form.ADDcodigo)) gt 0>
		<cfquery name="rsCliente" datasource="#session.DSN#">
			insert into Addendas (Ecodigo,ADDcodigo,ADDNombre,ADDdesc,XML_)
			VALUES (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ADDcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ADDNombre#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ADDdesc#">,
			null)
		</cfquery>

			
		<cfset content='<cfcomponent extends="sif.ad.Componentes.AD_Addenda">
				<cffunction name="init" access="private" returntype="ADDENDAEJEMPLO"> 
					<cfargument name="DSN" 	   type="string" default="#Session.DSN#" >
					<cfargument name="Ecodigo" type="string" default="#Session.Ecodigo#" >		
					<cfset Super.init(arguments.DSN, arguments.Ecodigo)>
					<cfreturn this>
				</cffunction>	

				<cffunction name="fnGeneraXML" access="public" output="yes" returntype="xml">
					<cfargument name="HXML" type="xml" required="true" /><!--- xml sin nodo --->
					
					<cfset struHXML = StructNew()>
					<cfset struHXML = leeXML(HXML)>
					

					<!--- Plantilla Addenda --->
			        <cfxml variable="xmlobject">
			        	<cfloop index="i" from="1" to="TamDet" >
			        	</cfloop>
					</cfxml>

					<cfreturn xmlobject>    
			    </cffunction>

			    <!--- Funcion que regresa Estructura del XML --->
			    <cffunction name="leeXML" access="public" output="yes" returntype="struct">
					<cfargument name="xmlNode" type="string" required="true" />

			    	<cfset objUxml = createObject( "component","home.public.api.components.utils")>
					<cfset  stru = StructNew()>

					<cfset  stru = objUxml.CFDIToStruct(Arguments.xmlNode,StructNew())>
					<cfreturn stru>
				</cffunction>
			</cfcomponent>'>

		<cfset vsPath_R = "#ExpandPath( GetContextRoot() )#">
        <cfif REFind('(cfmx)$',vsPath_R) gt 0>
            <cfset vsPath_R = "#Replace(vsPath_R,'cfmx','')#">
        <cfelse>
            <cfset vsPath_R = "#vsPath_R#\">
        </cfif>


		<cfset archivoname=#vsPath_R#&"\sif\ad\Componentes\AddendasCC\#form.ADDNombre#.cfc">
		<CFFILE ACTION="WRITE" FILE="#archivoname#" OUTPUT="#ToString(content)#" charset="utf-8">

		<cflocation url = "listaAddendas.cfm" addtoken = "false">
	</cfif>
</form>
</body>
</HTML>

