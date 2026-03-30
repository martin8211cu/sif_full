<cfcomponent output="no" hint="Tarea de Retiro de Login">
	<cffunction name="ejecutar" access="public" returntype="void" output="false">
		<cfargument name="datasource" type="string" required="yes">
		<cfargument name="TPid" type="numeric" required="yes">
		<cfargument name="CTid" type="numeric" required="yes">
		<cfargument name="Contratoid" type="numeric" required="yes">
		<cfargument name="LGnumero" type="numeric" required="yes">
		<cfargument name="TPxml" type="xml" required="yes">
		<cfargument name="TPorigen" type="string" required="No" default="SACI">
		
		<cfinvoke component="saci.comp.ISBtareaProgramadaRL" method="RetiroLoginProgramado">		<!--- ejecutar la tarea programada --->
			<cfinvokeargument name="datasource"value="#Arguments.datasource#">
		  	<cfinvokeargument name="Contratoid" value="#Arguments.Contratoid#">
		  	<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
		  	<cfinvokeargument name="MRid" value="#TPxml.retiroServicio.motivoRetiro.codigoMotivo.XmlText#">
			<cfinvokeargument name="TPorigen" value="#Arguments.TPorigen#">
		</cfinvoke>
		
	</cffunction>
	
	
	<cffunction name="RetiroLoginProgramado" access="public" returntype="void" output="false">
		<cfargument name="datasource" 	type="string" 	required="no" default="#session.DSN#">
		<cfargument name="Contratoid" 	type="numeric" 	required="yes">
		<cfargument name="LGnumero" 	type="numeric" 	required="yes">
		<cfargument name="MRid" 		type="string" 	required="yes">
		
		<cfargument name="BLautomatica" type="string" 	required="no" 	default="0"	 		displayname="BLautomatica">
		<cfargument name="BLobs" 		type="string" 	required="no" 	default="Retiro del login #Arguments.LGnumero# por tarea programada">
		
		<cfargument name="AGid" 		type="string" 	required="no" 	default="" 			displayname="Agente">
		<cfargument name="MSoperacion" 	type="string" 	required="no" 	default="B" 		displayname="Tipo de operacion">
	  	<cfargument name="MSfechaEnvio" type="string" 	required="no" 	default="#now()#" 	displayname="Fecha de envio del mensaje">
	  	<cfargument name="MSsaldo" 		type="numeric" 	required="no" 	default="0" 		displayname="Saldo_Mensajes_Cliente">
	 	<cfargument name="MSmotivo" 	type="string" 	required="no" 	default="I" 		displayname="Motivo_Mensajes_Cliente">
	  	<cfargument name="MStexto" 		type="string" 	required="no" 	default="" 			displayname="Texto_Mensajes_Cliente">
		<cfargument name="TPorigen" 	type="string" 	required="no" 	default="SACI" 		displayname="Origen de la tarea Programada (SIIC) o (SACI)">
		
		
		<cfinvoke component="saci.comp.ISBlogin" method="RetirarLogin">
			<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">									<!---datos necesarios para el retiro del login--->
		  	<cfinvokeargument name="datasource"value="#Arguments.datasource#">
		  	<cfinvokeargument name="MRid" value="#Arguments.MRid#">
		  	
			<cfinvokeargument name="BLautomatica" value="#Arguments.BLautomatica#">							<!---datos para la bitacora--->
			<cfinvokeargument name="BLobs" value="#Arguments.BLobs#">
		  	
			<cfif len(trim(Arguments.AGid))><cfinvokeargument name="AGid" value="#Arguments.AGid#"></cfif>	<!---datos para los mensajes al cliente--->
			<cfinvokeargument name="MSoperacion"  value="#Arguments.MSoperacion#">
			<cfinvokeargument name="MSfechaEnvio"  value="#Arguments.MSfechaEnvio#">
			<cfinvokeargument name="MSsaldo" 	value="#Arguments.MSsaldo#">
			<cfinvokeargument name="MSmotivo" 	value="#Arguments.MSmotivo#">
			<cfinvokeargument name="LGevento" 	value="#Arguments.TPorigen#">			
			<cfif len(trim(Arguments.MStexto))><cfinvokeargument name="MStexto" value="#Arguments.MStexto#"></cfif>
		</cfinvoke>
		
	</cffunction>
</cfcomponent>