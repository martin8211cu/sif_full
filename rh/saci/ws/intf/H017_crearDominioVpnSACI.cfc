<cfcomponent extends="crearLoginSACI" hint="SACI-03-H017.doc">
	<cffunction name="crearDominioVpnInterfaz">
		<!--- crea en SACI,iplanet,cisco,ipass un login que ya existe en siic .
				Por tanto origen se asume como 'siic' --->
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="ctaSIIC" type="string" required="yes">
		<cfargument name="dominio" type="string" required="yes">
		<cfargument name="tipo" type="string" required="yes">
		<cfargument name="opcion" type="string" required="yes">

		<cfargument name="ident_tunel" type="string" required="yes">
		<cfargument name="IP_tunel" type="string" required="yes">
		<cfargument name="Tip_tunel" type="string" required="yes">
		<cfargument name="pass_tunel" type="string" required="yes">
		<cfargument name="cant_tunel" type="string" required="yes">
		<cfargument name="ODT" type="string" required="yes">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		
		<cfset control_inicio( Arguments, 'H017', Arguments.dominio )>
		<cftry>
			<cfset validarOrigen(Arguments.origen, 'siic')>
			<cfset control_servicio( 'saci' )>
			<cfif Arguments.opcion is 'P'>
				<cfquery datasource="SACISIIC" name="SSXINT">
					select CINCAT, <!--- codigo en siic --->
						CINCMI, <!---cuota mínima --->
						CINCAH, <!--- Horas Cuota Mínima --->
						CINHCM, <!--- Monto por Horas Cuota Mínima --->
						CINECM, <!--- Monto por Horas Excedente Cuota Mínima --->
						CINDES <!--- Descripción  --->
					from SSXCIN
					where CINDES = <cfqueryparam cfsqltype="cf_sql_varchar" value="Usuarios_#Arguments.dominio#">
				</cfquery>
				<cfif SSXINT.RecordCount is 0>
					<cfthrow message="No existe el paquete Usuarios_#Arguments.dominio# en SSXCIN" errorcode="ISB-0013">
				</cfif>
				<cfquery datasource="#session.dsn#" name="paquetes">
					select PQcodigo from ISBpaquete
					where CINCAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#SSXINT.CINCAT#">
				</cfquery>
				<cfif paquetes.RecordCount>
					<cfset PQcodigo = paquetes.PQcodigo>
				<cfelse>
					<cfset PQcodigo = NumberFormat(SSXINT.CINCAT, '0000')>
					<cfset control_mensaje( 'ISB-0019', 'Creando paquete #PQcodigo#' )>
					<cfinvoke component="saci.comp.ISBpaquete" method="Alta"
						PQcodigo="#PQcodigo#"
						Miso4217="USD"
						PQnombre="#SSXINT.CINDES#"
						PQdescripcion="#SSXINT.CINDES#"
						PQinicio="#Now()#"
						PQtarifaBasica="#SSXINT.CINCMI#"
						PQcompromiso="true"
						PQhorasBasica="#SSXINT.CINCAH#"
						PQprecioExc="#SSXINT.CINECM#"
						PQcomisionTipo="0"
						PQinterfaz="false"
						PQtelefono="false"
						Habilitado="1"
						PQroaming="true"
						PQmailQuota="0"
						CINCAT="#SSXINT.CINCAT#" />
					<cfinvoke component="saci.comp.ISBservicio" method="Alta"
						TScodigo="ACCS"
						PQcodigo="#PQcodigo#"
						SVcantidad="1"
						Habilitado="1"/>
				</cfif>				

				<!--- Buscar el codigo del dominio si es que ya existía  --->
				<cfquery datasource="#session.dsn#" name="existeVPN">
					SELECT VPNid, VPNdominio
					FROM ISBdominioVPN
					WHERE VPNdominio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.dominio#">
				</cfquery>
				
				<!--- Leer datos del login reusando crearLoginSACI.cfc
							Le paso el dominio si existe, si no va vacío y lo creo luego --->
				<cfset datosLogin = leerDatosLoginSACISIIC(Arguments.dominio, '', existeVPN.VPNdominio, Arguments.ctaSIIC)>
				
				<cftransaction>
					<!--- Crear cuenta en SACI reusando crearLoginSACI.cfc
							Le paso el dominio si existe, si no va vacío y lo creo luego --->
					<cfset crearEnSaci(Arguments.dominio, datosLogin, 0, existeVPN.VPNdominio,
						"Creación de dominio VPN por interfaz, orden núm #Arguments.S02CON#")>
						
					<cfif Len(existeVPN.VPNid) is 0 >
						<!--- crear dominio en saci --->
						<cfinvoke component="saci.comp.ISBdominioVPN"
							method="Alta"  returnvariable="VPNid_inserted">
							<cfinvokeargument name="VPNdominio" value="#Arguments.dominio#">
							<cfinvokeargument name="CTid" value="#datosLogin.CTid#">
							<cfinvokeargument name="VPNdescripcion" value="#Arguments.dominio#">
							<cfinvokeargument name="VPNexterno" value="#IsDefined('form.VPNexterno')#">
							<cfinvokeargument name="VPNtunelId" value="#Arguments.ident_tunel#">
							<cfinvokeargument name="VPNtunelIp" value="#Arguments.IP_tunel#">
							<cfinvokeargument name="VPNtunelTipo" value="#Arguments.Tip_tunel#">
							<cfinvokeargument name="VPNtunelPass" value="****"><!--- no quiero guardar contraseñas --->
							<cfinvokeargument name="VPNtunelCant" value="#Arguments.cant_tunel#">
						</cfinvoke>
						<cfquery datasource="#session.dsn#">
							update ISBproducto
							set VPNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VPNid_inserted#">
							where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datosLogin.Contratoid#">
						</cfquery>
					</cfif>
				</cftransaction>
				
 				<!--- Actualizar referencia en SACISIIC --->
				
				<cfset control_servicio( 'siic' )>
				<cfset control_mensaje( 'SIC-0004', 'SSCCTA=#datosLogin.CTid# para SERCLA=#dominio#' )>
				<cfquery datasource="SACISIIC">
					update SSXSSC
					set SSCCTA = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datosLogin.CTid#">
					where SERCLA= <cfqueryparam cfsqltype="cf_sql_varchar" value="#dominio#">
				</cfquery>
				
				<!--- cisco: acceso A => Acceso --->
				<cfset control_servicio( 'acceso' )>
				<cfinvoke component="CiscoService" method="createPackage"
					grupo="Usuarios_#Arguments.dominio#"
					clave="Usuarios_#Arguments.dominio#"
					parentGroup="VPDNs"
					maxSession="#Arguments.cant_tunel#" />
					
				<cfinvoke component="CiscoService" method="createPackage"
					grupo="#Arguments.dominio#"
					clave="#Arguments.dominio#"
					parentGroup="Conf_VPDN"
					maxSession="#Arguments.cant_tunel#"
					tunnelID="#Arguments.ident_tunel#" 
					tunelIP="#Arguments.IP_tunel#" 
					tunelType="#Arguments.Tip_tunel#" 
					tunelPassword="#Arguments.pass_tunel#" />
				
			<cfelseif Arguments.opcion is 'B'>
				<!--- Se verifica que no existan contratos asociados al paquete: Usuarios_ + dominio --->
				<cfquery datasource="#session.dsn#" name="contratos_asociados">
					select count(1) as existen
					from ISBpaquete pq
						join ISBproducto pr
							on pr.PQcodigo = pq.PQcodigo
					where pq.PQnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="Usuarios_#Arguments.dominio#">
					  and pr.Habilitado != 2
				</cfquery>
				<cfif contratos_asociados.existen>
					<cfthrow message="Existen contratos asociados al paquete Usuarios_#Arguments.dominio#" errorcode="ISB-0022">
				</cfif>
				
				<!--- inhabilitar parquete --->
				<cfset control_mensaje( 'ISB-0023', 'Paquete Usuarios_#Arguments.dominio#' )>
				<cfquery datasource="#session.dsn#">
					update ISBpaquete
					set Habilitado = 2
					where PQnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="Usuarios_#Arguments.dominio#">
				</cfquery>
				
				<!--- Borrar perfil del VPN y del grupo en CISCO --->
				<cfset control_servicio( 'acceso' )>
				<cfinvoke component="CiscoService" method="deleteUser"
					usuario="#Arguments.dominio#" />
				<cfinvoke component="CiscoService" method="deletePackage"
					grupo="Usuarios_#Arguments.dominio#" />
			<cfelse>
				<cfthrow message="La opción #Arguments.opcion# no es válida. Los valores válidos con P y B para Programación y Borrado respectivamente" errorcode="ARG-0002">
			</cfif>
		
			<cfset control_servicio( 'siic' )>
			<cfinvoke component="SSXS02" method="Cumplimiento"
				S02CON="#Arguments.S02CON#"/>
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