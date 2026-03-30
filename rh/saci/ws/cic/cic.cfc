<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Wrappers para CIC" output="no">

	<!--- Funciones para ser invocadas desde CIC.  Su modificación debe coordinarse con el CIC. --->

	<!---cambiarRealName--->
	<cffunction name="cambiarRealName" access="remote" output="false" returntype="void" hint="Cambia el real name">
		<cfargument name="usuario" type="string" required="yes" hint="Usuario cuyo real name se cambiará">
		<cfargument name="realName" type="string" required="yes" hint="Nuevo real name por asignar">
		
		<cfinvoke component="saci.ws.intf.H040_cambioRealName"
			method="cambioRealName"
			origen="cic"
			login="#Arguments.usuario#"
			realName="#Arguments.realName#"
			rethrow="yes" />

	</cffunction>

	<!---cambiarPassword--->
	<cffunction name="cambiarPassword" access="remote" output="false" returntype="void" hint="Cambia el password">
		<cfargument name="usuario" type="string" required="yes">
		<cfargument name="sobre" type="numeric" required="yes">
		<cfargument name="servicio" type="string" required="yes">
		<cfargument name="clave" type="string" required="yes">
		
		<cfinvoke component="saci.ws.intf.H039_cambioPasswordSobre"
			method="cambioPassword"
			origen="cic"
			login="#Arguments.usuario#"
			sobre="#Arguments.sobre#"
			tipocambio="#Arguments.servicio#"
			clave="#Arguments.clave#"
			rethrow="yes" />

	</cffunction>
	<cffunction name="GetRealName" access="remote" output="false" returntype="string" hint="Get Real Name">
		<cfargument name="usuario" type="string" required="yes">
				
		<cfinvoke component="saci.ws.intf.H049_getRealName" returnvariable="varRealName"
			method="MostrarRealName"
			origen="cic"
			login="#Arguments.usuario#"
			rethrow="yes" />
	<cfreturn varRealName>
	</cffunction>

</cfcomponent>
