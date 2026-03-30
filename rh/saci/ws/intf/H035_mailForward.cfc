<cfcomponent hint="Ver SACI-03-H035.doc" extends="base">
	<!---agregarMailForward--->
	<cffunction name="agregarMailForward" access="public" returntype="void">
		<cfargument name="LGnumero" type="numeric" required="yes">
		<cfargument name="LGmailForward" type="string" required="yes">
		<cfargument name="origen" type="string" default="saci">
		
		<cfset control_inicio( Arguments, 'H035a', Arguments.LGnumero & ' ' & Arguments.LGmailForward )>
		<cftry>
			<cfset ISBlogin = getISBlogin(Arguments.LGnumero)>
			<cfset control_asunto ( ISBlogin.LGlogin & ' ' & Arguments.LGmailForward )>
			<cfset control_servicio( 'correo' )>
			<!--- Invocar la función para agregar la dirección a la lista de forward --->
			<cfinvoke component="IPlanetService" method="addMailForward"
				usuario="#ISBlogin.LGlogin#"
				mailForwardAddress="#Arguments.LGmailForward#"/>
			<cfset control_final( )>
		<cfcatch type="any">
			<!--- cumplimiento / error --->
			<cfset control_catch( cfcatch )>
		</cfcatch>
		</cftry>
	</cffunction>
	<!---eliminarMailForward--->
	<cffunction name="eliminarMailForward" access="public" returntype="void">
		<cfargument name="LGnumero" type="numeric" required="yes">
		<cfargument name="LGmailForward" type="string" required="yes">
		<cfargument name="origen" type="string" default="saci">
		
		<cfset control_inicio( Arguments, 'H035b', Arguments.LGnumero & ' ' & Arguments.LGmailForward )>
		<cftry>
			<cfset ISBlogin = getISBlogin(Arguments.LGnumero)>
			<cfset control_asunto ( ISBlogin.LGlogin & ' ' & Arguments.LGmailForward )>
			<cfset control_servicio( 'correo' )>
			<!--- Invocar la función para eliminar la dirección a la lista de forward --->
			<cfinvoke component="IPlanetService" method="deleteMailForward"
				usuario="#ISBlogin.LGlogin#"
				mailForwardAddress="#Arguments.LGmailForward#"/>
			<cfset control_final( )>
		<cfcatch type="any">
			<!--- cumplimiento / error --->
			<cfset control_catch( cfcatch )>
		</cfcatch>
		</cftry>
	</cffunction>
	<!---cambioMailForward--->
	<cffunction name="cambioMailForward" access="public" returntype="void">
		<cfargument name="LGmailForward_old" type="string" required="yes">
		<cfargument name="LGnumero" type="numeric" required="yes">
		<cfargument name="LGmailForward" type="string" required="yes">
		<cfargument name="origen" type="string" default="saci">
		
		<cfset control_inicio( Arguments, 'H035c', Arguments.LGnumero & ' ' & Arguments.LGmailForward )>
		<cftry>
			<cfset ISBlogin = getISBlogin(Arguments.LGnumero)>
			<cfset control_asunto ( ISBlogin.LGlogin & ' ' & Arguments.LGmailForward )>
			<cfset control_servicio( 'correo' )>
			<!--- Invocar la función para eliminar la dirección a la lista de forward --->
			<cfinvoke component="IPlanetService" method="deleteMailForward"
				usuario="#ISBlogin.LGlogin#"
				mailForwardAddress="#Arguments.LGmailForward_old#"/>
			<!--- Invocar la función para agregar la dirección a la lista de forward --->
			<cfinvoke component="IPlanetService" method="addMailForward"
				usuario="#ISBlogin.LGlogin#"
				mailForwardAddress="#Arguments.LGmailForward#"/>
			<cfset control_final( )>
		<cfcatch type="any">
			<!--- cumplimiento / error --->
			<cfset control_catch( cfcatch )>
		</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>