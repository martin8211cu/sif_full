<cfcomponent extends="base">
	<cffunction name="moroso" access="public" returntype="void" output="false">
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="CUECUE" type="string" required="yes">
		<cfargument name="login" type="string" required="yes">
		<cfargument name="saldo" type="string" required="yes" default="0" hint="String por si viene vacío o inválido.">
		<cfargument name="S02FEC" type="date" required="yes">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		
		<cfset control_inicio( Arguments, 'H025', Arguments.login )>
		<cftry>
			<cfset validarOrigen(Arguments.origen)>
			<cfparam name="Arguments.CUECUE" type="numeric">
			<cfparam name="Arguments.saldo" type="numeric">
			<cfset LGnumero = getLGnumero(Arguments.login)>
			
			<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta"
				LGnumero="#LGnumero#"
				LGlogin="#Arguments.login#"
				BLautomatica="true"
				BLobs="#LGnumero#"
				BLfecha="#Arguments.S02FEC#" />
			<cfset control_mensaje( 'ISB-0025', 'Notificando gestión de cobro' )>
			<cfinvoke component="saci.comp.ISBmensajesCliente" method="Alta"
				LGnumero="#LGnumero#"
				MSoperacion="O"
				MSfechaEnvio="#Arguments.S02FEC#"
				MSsaldo="#Arguments.saldo#"
				MSmotivo="G"
				MStexto="Gestión de cobro" />
			
			<cfinvoke component="SSXS02" method="Cumplimiento"
				S02CON="#Arguments.S02CON#"
				EnviarHistorico="true"
				EnviarCumplimiento="false"/>
			<cfset control_final( )>
		<cfcatch type="any">
			<!--- cumplimiento / error --->
			<cfset control_catch( cfcatch )>
			<cfinvoke component="SSXS02" method="Error"
				S02CON="#Arguments.S02CON#" 
				Error="#Request._saci_intf.Error#"/>
		</cfcatch>
		</cftry>

	</cffunction>
</cfcomponent>