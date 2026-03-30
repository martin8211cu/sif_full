<cfcomponent extends="base">
	<!--- 
		notación de los comentarios para identificar cada interfaz:
		intf:A999:dir:letra:Descripcion
		donde A999 es la interfaz, dir es la dirección: "in" para 
		"saci<-siic", y "out" para "saci->siic", y la letra es opcional, 
		para cuando la dirección sea "<"
	--->
	<!---selector--->
	<cffunction name="selector" access="public" returntype="void" output="true">
		<cfargument name="evento" type="struct" required="yes">
		<cfif Arguments.evento.tabla is 'SSXS02'>
			<cfif Arguments.evento.tipo is 'insert'>
				<cfset selectorSSXS02(Arguments.evento.newValues.S02CON)>
			<cfelse>
				<!--- ignorar delete y update --->
			</cfif>
		<cfelseif Arguments.evento.tipo is 'update' and Arguments.evento.tabla is 'ISBlogin'>
			<cfset selectorISBlogin(Arguments.evento)>
		<cfelseif Arguments.evento.tabla is 'ISBgarantia' and Arguments.evento.tipo is 'insert'>
			<cfset anuncia('H029b', 'in', '',  'Se Incluye el depósito de garantía')>
			<cfinvoke component="H029b_garantia" method="IngresaGarantia"
				origen="saci"
				Gid="#Arguments.evento.newValues.Gid#"
				TipoEvento="#Arguments.evento.tipo#"/> 
		<cfelseif Arguments.evento.tabla is 'ISBgarantia' and Arguments.evento.tipo is 'update'>
			<cfset anuncia('H029b', 'in', '',  'Se Actualiza el depósito de garantía')>
			<cfinvoke component="H029b_garantia" method="IngresaGarantia"
				origen="saci"
				Gid="#Arguments.evento.oldValues.Gid#"
				TipoEvento="#Arguments.evento.tipo#"/> 
		<cfelseif Arguments.evento.tabla is 'ISBprepago'>
			<cfset selectorISBprepago(Arguments.evento)>
		<cfelseif Arguments.evento.tipo is 'insert' and Arguments.evento.tabla is 'SSXSOB'>
			<cfset anuncia('H033', 'in', '', 'Generación de sobres de acceso')>
			<cfinvoke component="H033_sobre" method="generacionSobre"
				SOBCON="#Arguments.evento.newValues.SOBCON#"
				origen="siic"/>
		<cfelseif Arguments.evento.tipo is 'insert' and Arguments.evento.tabla is 'SSGTPP'>
			<cfset anuncia('H032', 'in', '',  'Generación de tarjetas de prepago')>
			<cfinvoke component="H032_tarjeta" method="generacionTarjeta"
				TPPLOG="#Arguments.evento.newValues.TPPLOG#"
				TPPPRE="#Arguments.evento.newValues.TPPPRE#"
				TPPFGN="#Arguments.evento.newValues.TPPFGN#"/>
		<cfelseif Arguments.evento.tipo is 'update' and Arguments.evento.tabla is 'SSXSSC'>
			<cfif IsDefined('Arguments.evento.newValues.ESCCOD') Or IsDefined('Arguments.evento.newValues.CONCGO')>
				<cfset anuncia('H036', 'in', '',  'Modificacion de estado de la cuenta (cuando ESCCOD/CONCGO se modifiquen)')>
				<cfinvoke component="H036_modEstados" method="modificacionEstados"
					origen="siic"
					SSCCOD="#Arguments.evento.oldValues.SSCCOD#"/>
					<!---ESCCOD="#Arguments.evento.newValues.ESCCOD#"
					CONCGO="#Arguments.evento.newValues.CONCGO#"/>--->
			<cfelseif IsDefined('Arguments.evento.newValues.CUECUE') And IsDefined('Arguments.evento.newValues.SERIDS')>
				<cfinvoke component="H037_modCuenta" method="modificacionCuenta"
					origen="siic"
					SSCCOD="#Arguments.evento.oldValues.SSCCOD#"
					CUECUE="#Arguments.evento.newValues.CUECUE#"
					SERIDS="#Arguments.evento.newValues.SERIDS#"/>
			</cfif>
		<cfelseif Arguments.evento.tipo is 'insert' and Arguments.evento.tabla is 'ISBpaquete'>
				<cfset anuncia('H042', 'out', '',  'Sincronización de paquetes')>
				<cfinvoke component="H042_sincronizaPaquetes" method="sincronizaPaquetes"
					PQcodigo="#Arguments.evento.newValues.PQcodigo#"
					TipoEvento="#Arguments.evento.tipo#"/> 
		<cfelseif  Arguments.evento.tipo is 'update' and Arguments.evento.tabla is 'ISBpaquete'>
				<cfset anuncia('H042', 'out', '',  'Sincronización de paquetes')>
				<cfinvoke component="H042_sincronizaPaquetes" method="sincronizaPaquetes"
					PQcodigo="#Arguments.evento.oldValues.PQcodigo#"
					updateCINCAT = "#IsDefined('Arguments.evento.newValues.CINCAT')#"
					TipoEvento="#Arguments.evento.tipo#"/> 
		<cfelseif  Arguments.evento.tipo is 'delete' and Arguments.evento.tabla is 'ISBpaquete'>
				<cfset anuncia('H042', 'out', '',  'Sincronización de paquetes')>
				<cfinvoke component="H042_sincronizaPaquetes" method="sincronizaPaquetes"
					PQcodigo="#Arguments.evento.oldValues.PQcodigo#"
					CINCAT ="#Arguments.evento.oldValues.CINCAT#"
					TipoEvento="#Arguments.evento.tipo#"/> 
		<cfelseif  Arguments.evento.tipo is 'update' and Arguments.evento.tabla is 'ISBsolicitudes'>
				<cfset anuncia('H019', 'out', '',  'Solicitudes de sobres/prepagos')>
				 <cfif IsDefined('Arguments.evento.newValues.SOenviada')> 
					<cfif Arguments.evento.newValues.SOenviada>
					<cfinvoke component="H019_Solicitud_Sobre_Prepagos" method="solicitud_sobres_prepagos"
						origen="saci"
						SOid ="#Arguments.evento.oldValues.SOid#"/>
					</cfif>
				</cfif>			
		<cfelseif Arguments.evento.tabla is 'ISBpaquete'>
			<!--- ignorar update/delete sobre ISBpaquete --->
		<cfelseif Arguments.evento.tipo is 'insert' and Arguments.evento.tabla is 'ISBmailForward'>
			<cfset anuncia('H035a', 'out', '',  'Agregar mail forwarding')>
			<cfinvoke component="H035_mailForward" method="agregarMailForward"
				LGnumero="#Arguments.evento.newValues.LGnumero#"
				LGmailForward="#Arguments.evento.newValues.LGmailForward#" />
		<cfelseif Arguments.evento.tipo is 'delete' and Arguments.evento.tabla is 'ISBmailForward'>
			<cfset anuncia('H035b', 'out', '',  'Eliminar mail forwarding')>
			<cfinvoke component="H035_mailForward" method="eliminarMailForward"
				LGnumero="#Arguments.evento.oldValues.LGnumero#"
				LGmailForward="#Arguments.evento.oldValues.LGmailForward#" />
		<cfelseif Arguments.evento.tipo is 'update' and Arguments.evento.tabla is 'ISBmailForward'>
			<cfset anuncia('H035b', 'out', '',  'Modificar mail forwarding')>
			<cfinvoke component="H035_mailForward" method="cambioMailForward"
				LGnumero="#Arguments.evento.newValues.LGnumero#"
				LGmailForward_old="#Arguments.evento.oldValues.LGmailForward#" 
				LGmailForward="#Arguments.evento.newValues.LGmailForward#" />
		<cfelseif Arguments.evento.tabla is 'ISBmedio'>
			<cfset anuncia('H038', 'out', '',  'Bloqueo y Desbloqueo de medios')>
			<cfset modificar = false>
			<cfif Arguments.evento.tipo is 'update'>
				<cfset modificar = '0'>
				<cfset modificarprepago = '0'>
				<cfif IsDefined('Arguments.evento.newValues.MDbloqueado')>
					<cfset modificar = Arguments.evento.newValues.MDbloqueado neq Arguments.evento.oldValues.MDbloqueado>
				</cfif>
				<cfif IsDefined('Arguments.evento.newValues.MDbloqueadoPrepago')>
					<cfset modificarprepago = Arguments.evento.newValues.MDbloqueadoPrepago neq Arguments.evento.oldValues.MDbloqueadoPrepago>
				</cfif>
					<cfif IsDefined('Arguments.evento.newValues.MDbloqueado')>
						<cfset MDbloqueado = Arguments.evento.newValues.MDbloqueado>
					<cfelseif IsDefined('Arguments.evento.newValues.MDbloqueadoPrepago')>
						<cfset MDbloqueado = Arguments.evento.newValues.MDbloqueadoPrepago>
					</cfif>
				<cfset MDref = Arguments.evento.oldValues.MDref>
			<cfelseif Arguments.evento.tipo eq 'insert'>
				<cfset modificar = Arguments.evento.newValues.MDbloqueado>
				<cfset modificarprepago = Arguments.evento.newValues.MDbloqueadoPrepago>
				<cfset MDbloqueado = true>
				<cfset MDref = Arguments.evento.newValues.MDref>
			<cfelseif Arguments.evento.tipo eq 'delete'>
				<cfset modificar = Arguments.evento.oldValues.MDbloqueado>
				<cfset modificaprepago = Arguments.evento.oldValues.MDbloqueadoPrepago>
				<cfset MDbloqueado = false>
				<cfset MDref = Arguments.evento.oldValues.MDref>
			</cfif>
			<cfif modificar or modificarPrepago>
				<cfinvoke component="H038_bloqueo900"
					method="bloqueo900"
					MDref="#MDref#"
					MDbloqueado="#MDbloqueado#"
					modificar="#modificar#"
					modificarprepago="#modificarprepago#"/>
			</cfif>
		
		<cfelseif Arguments.evento.tabla is 'ISBserviciosLogin'>
			<cfif Arguments.evento.tipo is 'insert'>
				<cfset anuncia('H014b', 'out', '', 'Cambio de servicios (#Arguments.evento.tipo#)')>
				<cfinvoke component="H014_cambioPaquete" method="cambioServiciosLogin"
					LGnumero="#Arguments.evento.newValues.LGnumero#"
					PQcodigo="#Arguments.evento.newValues.PQcodigo#"
					TScodigo="#Arguments.evento.newValues.TScodigo#"
					Habilitado="#Arguments.evento.newValues.Habilitado#"
					TipoEvento="insert" />
			<cfelseif Arguments.evento.tipo is 'delete'
					OR	(Arguments.evento.tipo is 'update'
								and IsDefined('Arguments.evento.newValues.Habilitado')
								and Len(Arguments.evento.newValues.Habilitado)
								and ISDefined('Arguments.evento.oldValues.Habilitado'))							
					OR	(Arguments.evento.tipo is 'update' 
								and IsDefined('Arguments.evento.newValues.SLpassword')
								and Len(Arguments.evento.newValues.SLpassword)
								and Arguments.evento.newValues.SLpassword neq '*')>								
				<cfset anuncia('H014b', 'out', '', 'Cambio de servicios (#Arguments.evento.tipo#)')>
				<cfinvoke component="H014_cambioPaquete" method="cambioServiciosLogin"
					LGnumero="#Arguments.evento.oldValues.LGnumero#"
					PQcodigo="#Arguments.evento.oldValues.PQcodigo#"
					TScodigo="#Arguments.evento.oldValues.TScodigo#"
					Habilitado="#Arguments.evento.oldValues.Habilitado#"
					TipoEvento="#Arguments.evento.tipo#" />
			</cfif>
		<cfelseif Arguments.evento.tabla is 'ISBproducto' and Arguments.evento.tipo is 'update'
			And IsDefined('Arguments.evento.newValues.PQcodigo')>
				
				<cfset isbevento ='SACI'>
				<cfif IsDefined('Arguments.evento.newValues.LGevento')>
					<cfset isbevento = Arguments.evento.newValues.LGevento>
				<cfelse>
					<cfset isbevento = Arguments.evento.oldValues.LGevento>
				</cfif>					
			<cfset anuncia('H014a', 'out', '', 'Cambio de paquete')>
			<cfinvoke component="H014_cambioPaquete" method="cambioPaqueteSACI"
				Contratoid="#Arguments.evento.oldValues.Contratoid#"
				isbevento="#isbevento#"/>
		<!--- No aplica está interfaz, los cambios en la forma de cobro se realizan desde otra aplicación
		<cfelseif Arguments.evento.tabla is 'ISBcuentaCobro' and Arguments.evento.tipo is 'update'>
			<cfset anuncia('H046', 'out', '', 'Forma de cobro')>
			<cfinvoke component="H046_formaCobro" method="replicarFormaCobro"
				origen="saci"
				operacion="C"
				CTid="#Arguments.evento.oldValues.CTid#"/>--->
		<cfelseif Arguments.evento.tabla is 'ISBpersona' and Arguments.evento.tipo is 'update'>
			<!---<cfset anuncia('H047', 'out', '', 'Datos Personales')>
			<cfinvoke component="H047_datosPersonales" method="replicarDatosPersonales"
				origen="saci"
				operacion="C"
				Pquien="#Arguments.evento.oldValues.Pquien#"/>--->
		<cfelseif Arguments.evento.tabla is 'ISBbloqueoLogin'>
			<cfset selectorISBbloqueoLogin(Arguments.evento)>
		<cfelse>
			<!--- ignorar evento --->
		</cfif>
	</cffunction>
	<!---getValueAt--->
	<cffunction name="getValueAt" access="private" returntype="any">
		<cfargument name="trama" type="array" required="yes">
		<cfargument name="index" type="numeric" required="yes">
		
		<cfif ArrayLen(Arguments.trama) ge index>
			<cfreturn trama[index]>
		<cfelse>
			<cfreturn "">	
		</cfif>
		
	</cffunction>
	<!---selectorSSXS02--->
	<cffunction name="selectorSSXS02" access="public" returntype="void" output="true">
		<cfargument name="S02CON" type="numeric" required="yes">
		
		<!--- 
			Invocación de interfaces, llamadas desde SACISIIC.
			Inserciones en la tabla SSXS02 se toman como tareas
			por realizar en SACI. Se debe determinar la tarea de acuerdo
			al valor de la solumna SSXS02.S02ACC 
		--->
		<cfset var i = 0>
		
		<cfinvoke component="SSXS02" method="getTarea"
			S02CON="#Arguments.S02CON#" returnvariable="selectorSSXS02_Q"/>
		
		<cfset S02ACC = UCase(selectorSSXS02_Q.S02ACC)>
		<cfset trama = ListToArray(selectorSSXS02_Q.S02VA1,'*')>
		<cfset S02VA2 = ListToArray(selectorSSXS02_Q.S02VA2,'*')>
		<cfif ArrayLen(trama)>
			<cfloop from="1" to="#ArrayLen(trama)#" index="i">
				<cfset trama[i] = Trim(trama[i])>
			</cfloop>
		</cfif>
		<cfif ArrayLen(S02VA2)>
			<cfloop from="1" to="#ArrayLen(S02VA2)#" index="i">
				<cfset S02VA2[i] = Trim(S02VA2[i])>
			</cfloop>
		</cfif>
		
		<!--- Variable global para ISBmensajesCliente --->
		<cfset Request.S02CON = Arguments.S02CON>
		<cfswitch expression="#S02ACC#">
			<cfcase value="P">
				<cfset anuncia('H005', 'in', 'P', 'Reprogramación de login')>
				<!--- 
				Posibles combinaciones para la trama
				1.	S02VA1 = "Cta SIIC*login*paquete*#sobre*opción"
				2.	S02VA1 = "Cta SIIC*login*paquete*#sobre*opción*saldo"
				3.	S02VA1 = "Cta SIIC*login*paquete*#sobre*opción*saldo*INTPAD"
				--->
				<cfinvoke component="H005_reprogramacionLogin" method="reprogramacionLogin"
					origen="siic"
					login="#getValueAt(trama,2)#"
					paquete="#getValueAt(trama,3)#"
					sobre="#getValueAt(trama,4)#"
					saldo="#getValueAt(trama,6)#"
					INTPAD="#getValueAt(trama,7)#"
					S02CON="#Arguments.S02CON#"/>
			</cfcase>
			<cfcase value="I"> 
				<cfset anuncia('H007', 'in', 'I', 'Borrado / programación de internet dedicado')>
				<!--- Debe determinarse la acción según la opción de la trama --->
				<!---
				Posibles combianciones para la trama
				1.	S02VA1 = “cta SIIC*paquete*opción"
				--->
				<cfif UCase(getValueAt(trama,3)) is 'P'> <!--- Es programación --->
					<cfinvoke component="H007_internetDedicado" method="internetDedicado"
						origen="siic"
						opcion="P"
						CUECUE="#getValueAt(trama,1)#"
						paquete="#getValueAt(trama,2)#"
						S02CON="#Arguments.S02CON#"/>
				<cfelseif UCase(getValueAt(trama,3)) is 'B'> <!--- Es borrado --->
					<cfinvoke component="H007_internetDedicado" method="internetDedicado"
						origen="siic"
						opcion="B"
						CUECUE="#getValueAt(trama,1)#"
						paquete="#getValueAt(trama,2)#"
						S02CON="#Arguments.S02CON#"/>
				<cfelse>
					<cfthrow message="La opción especificada(#getValueAt(trama,3)#) es inválida. Debe ser P ó B">
				</cfif>
			</cfcase>
			<cfcase value="E"> 
				<cfset anuncia('H008', 'in', 'E', 'Cambio de cédula')>
				<!---
				Posibles combinaciones para la trama
				1.	S02VA1 = “cédula anterior*cédula nueva "
				--->
				<cfinvoke component="H008_cambioCedula" method="cambioCedula"
					origen="siic"
					PidAnterior="#getValueAt(trama,1)#"
					PidNuevo="#getValueAt(trama,2)#"
					S02CON="#Arguments.S02CON#"/>					
			</cfcase>
			<cfcase value="4"> 
				<cfset anuncia('H015', 'in', '4', 'Reutilización de Login')>
				<!---
				Posibles combinaciones para la trama
				1.	S02VA1 = = "cuenta_siic*login"
				--->
				<cfinvoke component="H015_reutilizacion" method="reutilizacion_Login"
					origen="siic"
					cuecue="#getValueAt(trama,1)#"
					login="#getValueAt(trama,2)#"
					S02CON="#Arguments.S02CON#"/>					
			</cfcase>
			<cfcase value="6"> 
				<cfset anuncia('H021', 'in', '6', 'Anotaciones de Agente')>
				<!---
				Posibles combinaciones para la trama
				1.	S02VA1 = “Código error*códigodeagente*login*estado*fecha_creación*usuario_crea_anotación*fecha_correción*Observación"--->

				<cfinvoke component="H021_Agente_Anotaciones" method="registro_de_anotaciones"
					origen="siic"
					lid ="#getValueAt(trama,1)#"
					AGid ="#getValueAt(trama,2)#"
					login ="#getValueAt(trama,3)#"
					IEstado ="#getValueAt(trama,4)#"
					INfechaCrea ="#getValueAt(trama,5)#"
					INusuarioCrea ="#getValueAt(trama,6)#"
					INfechaCorrige ="#getValueAt(trama,7)#"
					INobsCrea ="#getValueAt(trama,8)#"
					S02CON="#Arguments.S02CON#"/>					
			</cfcase>			
			<cfcase value="5"> 
				<cfset anuncia('H038a', 'in', '5', 'bloqueo/desbloqueo de Teléfonos (Prepago o Internet900')>
				<!---
					Posibles combinaciones para la trama
				1.	S02VA1 = = "servicio*acción*teléfono"
				--->
				<cfinvoke component="H038a_bloqueo900" method="bloqueo900"
					origen="siic"
					paquete="#getValueAt(trama,1)#"
					MDbloqueado="#getValueAt(trama,2) is 'L'#"
					telefono="#getValueAt(trama,3)#"
					S02CON="#Arguments.S02CON#"/>					
			</cfcase>
			<cfcase value="8"> 
				<cfset anuncia('H019b', 'in', '5', 'Respuesta Solicitud de sobres/prepago')>
				<!---
					S02VA1 = código_solicitud_saci*código_solicitud_siic*código_agente*estado
				--->
				<cfinvoke component="H019b_respuesta_solicitud" method="respuesta_sobres_prepagos"
					origen="siic"
					SOid="#getValueAt(trama,1)#"
					SOidexterno="#getValueAt(trama,2)#"
					AGid="#getValueAt(trama,3)#"
					estado="#getValueAt(trama,4)#"
					S02CON="#Arguments.S02CON#"/>					
			</cfcase>

			<cfcase value="K"> 
				<cfset anuncia('H009', 'in', 'K', 'Cambio de cuenta en SiiC')>
				<!--- 
				Posibles combinaciones para la trama
				1.	S02VA1 = “login*cta SIIC actual*cta SIIC nueva*nombreCta*cédula"
				2.	S02VA2 = “nombreCta_SSXINT*cédula_SSXINT”
				--->
				<cfinvoke component="H009_cambioCuentaSiiC" method="cambioCuentaSiiC"
					CUECUEnuevo="#getValueAt(trama,3)#"
					CUECUEviejo="#getValueAt(trama,2)#"
					cedula="#getValueAt(trama,5)#"
					login="#getValueAt(trama,1)#"
					nombreCuenta="#getValueAt(trama,4)#"
					nombreCta_SSXINT="#getValueAt(S02VA2,1)#"
					S02CON="#Arguments.S02CON#"/>
			</cfcase>
			<cfcase value="L">
				<cfset anuncia('H010', 'in', 'L', 'Bloqueo de login')>
				<!--- 
				Posibles combinaciones para la trama
				1.	S02VA1 = "login*"
				2.	S02VA1 = "cta SIIC*login*saldo"
				3.	S02VA1 = "cta SIIC*login*saldo*spam"
				--->
				<cfif ArrayLen(trama) is 1>
					<cfinvoke component="H010_bloqueoLogin" method="bloqueoLogin"
						origen="siic"
						login="#getValueAt(trama,1)#"
						motivo="DG"
						S02CON="#Arguments.S02CON#"/>
				<cfelseif ArrayLen(trama) is 3>
					<cfinvoke component="H010_bloqueoLogin" method="bloqueoLogin"
						origen="siic"
						login="#getValueAt(trama,2)#"
						saldo="#getValueAt(trama,3)#"
						motivo="#Left(selectorSSXS02_Q.S02VA2,1)#"
						S02CON="#Arguments.S02CON#"/>						
				<cfelseif ArrayLen(trama) is 4>
					<cfinvoke component="H010_bloqueoLogin" method="bloqueoLogin"
						origen="siic"
						login="#getValueAt(trama,2)#"
						saldo="#getValueAt(trama,3)#"
						spam="true"
						motivo="#Left(selectorSSXS02_Q.S02VA2,1)#"
						S02CON="#Arguments.S02CON#"/>						
				<cfelse>
					<cfthrow message="Tamaño inesperado de la trama (#S02VA1#) es de #ArrayLen(trama)# en bloqueo de login">
				</cfif>
			</cfcase>
			<cfcase value="D">
				<cfset anuncia('H011', 'in', 'D', 'desbloqueo de login')>
				<!--- 
				Posibles combinaciones para la trama
				1.	S02VA1 = "login*"
				2.	S02VA1 = "cta SIIC*login*saldo"
				3.	S02VA1 = "cta SIIC*login*saldo*spam"
				--->
				<cfif ArrayLen(trama) is 1>
					<cfinvoke component="H011_desbloqueoLogin" method="desbloqueoLogin"
						origen="siic"
						login="#getValueAt(trama,1)#"
						motivo="DG"
						S02CON="#Arguments.S02CON#"/>
				<cfelseif ArrayLen(trama) is 3>
					<cfinvoke component="H011_desbloqueoLogin" method="desbloqueoLogin"
						origen="siic"
						login="#getValueAt(trama,2)#"
						saldo="#getValueAt(trama,3)#"
						motivo="#Left(selectorSSXS02_Q.S02VA2,1)#"
						S02CON="#Arguments.S02CON#"/>
				<cfelseif ArrayLen(trama) is 4>
					<cfinvoke component="H011_desbloqueoLogin" method="desbloqueoLogin"
						origen="siic"
						login="#getValueAt(trama,2)#"
						saldo="#getValueAt(trama,3)#"
						spam="true"
						motivo="#Left(selectorSSXS02_Q.S02VA2,1)#"
						S02CON="#Arguments.S02CON#"/>
				<cfelse>
					<cfthrow message="Tamaño inesperado de la trama (#S02VA1#) es de #ArrayLen(trama)# en desbloqueo de login">
				</cfif>
			</cfcase>
			<cfcase value="B">
				<cfset anuncia('H012', 'in', 'B', 'Borrado de login')>
				<!---
				Posibles combinaciones para la trama							
					1.	S02VA1 = "cta SIIC*login" 
					2.	S02VA1 = "cta SIIC*login*fecha*Operador*saldo"
					3.	S02VA1 = "cta SIIC*login*fecha*Operador*saldo*spam"

				--->
				<cfinvoke component="H012_borradoLogin" method="borradoLogin"
					origen="siic"
					login="#getValueAt(trama,2)#"
					S02CON="#Arguments.S02CON#"/>
			</cfcase>
			<cfcase value="G">
				<cfset anuncia('H013', 'in', 'G', 'Cambio de login')>
				<!---
				Posibles combinaciones para la trama
				1.	S02VA1 = "cta SIIC*login_actual*login_nuevo""
				--->
				<cfinvoke component="H013_cambioLogin" method="cambioLogin"
					origen="siic"
					loginAnterior="#getValueAt(trama,2)#"
					loginNuevo="#getValueAt(trama,3)#"
					S02CON="#Arguments.S02CON#"/>
			</cfcase>
			<cfcase value="Q">
				<cfset anuncia('H014a', 'in', 'Q', 'Cambio de paquete')>
				<!---
				Posibles combinaciones para la trama
				1.	S02VA1 = "cta SIIC*login*paquete*Estruct_telef"" 4
				2.	S02VA1 = “cta SIIC*login*paquete*Estruct_telef*saldo 5
				3.	S02VA1 = "cta SIIC*login*paquete*Estruct_telef*saldo*usuario” 6
				4.	S02VA1 = “cta SIIC*login*paquete*Estruct_telef*saldo*usuario*intpad” 7
				--->
				<cfif ListFind('4,5,6,7', ArrayLen(trama))>
					<cfinvoke component="H014_cambioPaquete" method="cambioPaquete">
						<cfinvokeargument name="origen" value="siic"/>
						<cfinvokeargument name="login" value="#getValueAt(trama,2)#"/>
						<cfinvokeargument name="CINCAT" value="#getValueAt(trama,3)#"/>
						<cfinvokeargument name="telefono" value="#getValueAt(trama,4)#"/>
						<cfinvokeargument name="S02CON" value="#Arguments.S02CON#"/>
						<cfif ArrayLen(trama) ge 5>
							<cfinvokeargument name="saldo" value="#getValueAt(trama,5)#"/>
						</cfif>
						<cfif ArrayLen(trama) ge 7>
							<cfinvokeargument name="INTPAD" value="#getValueAt(trama,7)#"/>
						</cfif>
					</cfinvoke>
				<cfelse>
					<cfthrow message="Tamaño inesperado de la trama (#S02VA1#) es de #ArrayLen(trama)# en el cambio de paquete">
				</cfif>
			</cfcase>
			<cfcase value="A">
				<cfset anuncia('H016a', 'in', 'A', 'Activación/desactivación de tarjetas prepago')>
				<!--- Debe determinarse la acción según el SSXS02.S02VA2: A / D --->
				<cfinvoke component="H016_prepago" method="prepagosMasivo"
					origen="siic"
					prefijo="#getValueAt(trama,1)#"
					rango_inicial="#getValueAt(trama,2)#"
					rango_final="#getValueAt(trama,3)#"
					agente="#getValueAt(trama,4)#"
					estado="#getValueAt(S02VA2,1)#"
					S02CON="#Arguments.S02CON#"/>
			</cfcase>
			<cfcase value="M">
				<cfset anuncia('H017', 'in', 'M', 'Crear dominio VPN')>
				<!---1.S02VA1 = “cta SIIC*dominio*tipo*opción*“ident_tunel*IP_tunel*Tip_tunel*pass_tunel*cant_tunel--->
				<cfinvoke component="H017_crearDominioVpnSACI" method="crearDominioVpnInterfaz"
					origen="siic"
					ctaSIIC="#getValueAt(trama,1)#"
					dominio="#getValueAt(trama,2)#"
					tipo="#getValueAt(trama,3)#"
					opcion="#getValueAt(trama,4)#"
			
					ident_tunel="#getValueAt(trama,5)#"
					IP_tunel="#getValueAt(trama,6)#"
					Tip_tunel="#getValueAt(trama,7)#"
					pass_tunel="#getValueAt(trama,8)#"
					cant_tunel="#getValueAt(trama,9)#"
					ODT="#getValueAt(S02VA2,1)#"
					S02CON="#Arguments.S02CON#"/>
			</cfcase>
			<cfcase value="U">
				<cfset anuncia('H018', 'in', 'U', 'Crear login en saci')>
				<!---1.	S02VA1 = “cta SIIC*login*dominio*#sobre*opción*max-sessions"--->
				<cfinvoke component="H018_usuarioVPN" method="usuarioVPN"
					origen="siic"
					CUECUE="#getValueAt(trama,1)#"
					login="#getValueAt(trama,2)#"
					dominioVPN="#getValueAt(trama,3)#"
					sobre="#getValueAt(trama,4)#"
					opcion="#getValueAt(trama,5)#"
					maxsession="#getValueAt(trama,6)#"
					S02VA2="#selectorSSXS02_Q.S02VA2#"
					S02CON="#Arguments.S02CON#"/>
			</cfcase>
			<cfcase value="H">
				<cfset anuncia('H020', 'in', 'H', 'Cambio de teléfono')>
				<cfinvoke component="H020_cambioTelefono" method="cambioTelefono"
					origen="siic"
					SERIDS="#getValueAt(trama,1)#"
					telefono="#IIf(ArrayLen(trama) GE 2, 'getValueAt(trama,2)', DE(''))#"
					S02CON="#Arguments.S02CON#"/>
			</cfcase>
			<cfcase value="Y">
				<cfset anuncia('H039', 'in', 'Y', 'Cambio de password por sobre')><!--- *** LETRA ASIGNADA TEMPORALMENTE *** --->
				<cfinvoke component="H039_cambioPasswordSobre" method="cambioPassword"
					origen="siic"
					login="#getValueAt(trama,1)#"
					sobre="#getValueAt(trama,2)#"
					tipocambio="#getValueAt(trama,3)#"
					clave="#getValueAt(trama,4)#"
					S02CON="#Arguments.S02CON#" />
			</cfcase>
			<cfcase value="R">
				<cfset anuncia('H040', 'in', 'R', 'Cambio de RealName')><!--- *** LETRA ASIGNADA TEMPORALMENTE *** --->
				<cfinvoke component="H040_cambioRealName" method="cambioRealName"
					origen="siic"
					login="#getValueAt(trama,1)#"
					realName="#getValueAt(trama,2)#"
					S02CON="#Arguments.S02CON#" />
			</cfcase>
			<cfcase value="O">
				<cfset anuncia('H025', 'in', 'O', 'Identificar usuarios de cable módem morosos')>
				<cfinvoke component="H025_cableModem" method="moroso"
					origen="siic"
					CUECUE="#getValueAt(trama,1)#"
					login="#getValueAt(trama,2)#"
					saldo="#getValueAt(trama,3)#"
					S02FEC="#selectorSSXS02_Q.S02FEC#" 
					S02CON="#Arguments.S02CON#" />
			</cfcase>
			<cfcase value="1">
				<cfset anuncia('H043', 'in', '1', 'Comisiones a agentes')>
				<cfinvoke component="H043_comisiones" method="comision"
					origen="siic"
					cedula_agente="#getValueAt(trama,1)#"
					cuenta_siic_cliente="#getValueAt(trama,2)#"
					login="#getValueAt(trama,3)#"
					paquete="#getValueAt(trama,4)#"
					comision_pagada="#getValueAt(trama,5)#"
					comision_original="#getValueAt(trama,6)#"
					tipo_de_cambio="#getValueAt(trama,7)#"
					periodo="#getValueAt(trama,8)#"
					observacion="#getValueAt(trama,9)#"
					moneda="#getValueAt(trama,10)#"
					S02CON="#Arguments.S02CON#" />
			</cfcase>
			<cfcase value="2">
				<cfset anuncia('H044', 'in', '',  'Aprobación de servicios')>
				<cfinvoke component="H044_aprobacionServicios" method="aprobacionServicios"
					origen="siic"
					login="#getValueAt(trama,1)#"
					serids="#getValueAt(trama,2)#"
					CUECUE="#getValueAt(trama,3)#"
					paquete="#getValueAt(trama,4)#"
					fecha="#getValueAt(trama,5)#"
					accion="#getValueAt(trama,6)#"
					S02CON="#Arguments.S02CON#" />
			</cfcase>
			<cfcase value="3">
				<cfset anuncia('H045', 'in', '',  'Aprobación de agentes')>
				<cfinvoke component="H045_agente" method="aprobacionServicios"
					origen="siic"
					AGid="#getValueAt(S02VA2,1)#"
					CUECUE="#getValueAt(S02VA2,2)#"
					S02CON="#Arguments.S02CON#" />
			</cfcase>
			<cfcase value="7">
				<cfset anuncia('H006', 'in', '',  'Sincronización de Catálogos')>
				<cfinvoke component="H006_catalogos" method="sincroniza_catalogos"
					origen="siic"
					tabla="#getValueAt(trama,1)#"
					operacion="#getValueAt(trama,2)#"
					S02VA2="#selectorSSXS02_Q.S02VA2#"
					S02CON="#Arguments.S02CON#" />
			</cfcase>
			<cfcase value="F,J">
				<cfthrow message="Las tareas en SSXS02 con S02ACC=F ó J deben reemplazarse por una tarea A">
			</cfcase>
			<cfdefaultcase>
				<cfthrow message="No me esperaba la tarea en SSXS02 con S02ACC=#S02ACC#">
			</cfdefaultcase>
		</cfswitch>
	</cffunction>
	
	<!---selectorISBbloqueoLogin--->
	<cffunction name="selectorISBbloqueoLogin" access="public" returntype="void" output="true">
		<cfargument name="evento" type="struct" required="yes">


		<cfif Arguments.evento.tipo is 'insert'>
		<cfquery datasource="#session.dsn#" name="selectorISBbloqueoLogin">
			select BLorigen
			from ISBbloqueoLogin 
			where BLQid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.evento.newValues.BLQid#">
		</cfquery>
		<cfelse>
		<cfquery datasource="#session.dsn#" name="selectorISBbloqueoLogin">
			select BLorigen
			from ISBbloqueoLogin 
			where BLQid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.evento.oldValues.BLQid#">
		</cfquery>		
		</cfif>

			<cfif Arguments.evento.tipo is 'insert'>
				<!--- insert/bloqueo, usa newValues --->								
					<cfset OrigenbloqueoLogin = 'SACI'>
					<cfif IsDefined('Arguments.evento.newValues.BLorigen')>
						<cfif Arguments.evento.newValues.BLorigen eq 'SIIC'>
							<cfset OrigenbloqueoLogin = 'SIIC'>
						</cfif>		
					<cfelse>
						<cfif Arguments.evento.oldValues.BLorigen eq 'SIIC'>
							<cfset OrigenbloqueoLogin = 'SIIC'>
						</cfif>							
					</cfif>
				
				<cfset anuncia('H010', 'out',  '', 'Bloqueo de login (item,insert)')>
				<cfinvoke component="H010_bloqueoLogin" method="bloqueoLGnumero"
					origen="saci" login="" 
					LGnumero="#Arguments.evento.newValues.LGnumero#"
					motivo="#Arguments.evento.newValues.MBmotivo#"
					OrigenbloqueoLogin = "#OrigenbloqueoLogin#"/>
			<cfelseif Arguments.evento.tipo is 'update' and
					IsDefined('Arguments.evento.newValues.BLQdesbloquear') and
					Arguments.evento.newValues.BLQdesbloquear is false>
				<!--- update/bloqueo, usa oldValues --->
					<cfset OrigenbloqueoLogin = 'SACI'>

					<cfset OrigenbloqueoLogin = 'SACI'>
					<cfif IsDefined('Arguments.evento.newValues.BLorigen')>
						<cfif Arguments.evento.newValues.BLorigen eq 'SIIC'>
							<cfset OrigenbloqueoLogin = 'SIIC'>
						</cfif>		
					<cfelse>
						<cfif Arguments.evento.oldValues.BLorigen eq 'SIIC'>
							<cfset OrigenbloqueoLogin = 'SIIC'>
						</cfif>							
					</cfif>

				<cfset anuncia('H010', 'out',  '', 'Bloqueo de login (item,update)')>
				<cfinvoke component="H010_bloqueoLogin" method="bloqueoLGnumero"
					origen="saci" login="" soloNotificar="true"
					LGnumero="#Arguments.evento.oldValues.LGnumero#"
					motivo="#Arguments.evento.oldValues.MBmotivo#"
					OrigenbloqueoLogin = "#OrigenbloqueoLogin#"/>
			<cfelseif Arguments.evento.tipo is 'delete' OR (
					Arguments.evento.tipo is 'update' and
					IsDefined('Arguments.evento.newValues.BLQdesbloquear') and
					Arguments.evento.newValues.BLQdesbloquear is true )>
				<!--- delete o update/desbloqueo, usa oldValues --->
					
					<cfset OrigenbloqueoLogin = 'SACI'>
					<cfif IsDefined('Arguments.evento.newValues.BLorigen')>
						<cfif Arguments.evento.newValues.BLorigen eq 'SIIC'>
							<cfset OrigenbloqueoLogin = 'SIIC'>
						</cfif>		
					<cfelse>
						<cfif Arguments.evento.oldValues.BLorigen eq 'SIIC'>
							<cfset OrigenbloqueoLogin = 'SIIC'>
						</cfif>							
					</cfif>

				<cfset anuncia('H011', 'out',  '', 'Desbloqueo de login (item)')>
				<cfinvoke component="H011_desbloqueoLogin" method="desbloqueoLGnumero"
					origen="saci" login=""
					LGnumero="#Arguments.evento.oldValues.LGnumero#"
					motivo="#Arguments.evento.oldValues.MBmotivo#"
					OrigenbloqueoLogin = "#OrigenbloqueoLogin#"/>
			<cfelse>
				<!--- de otra manera se ignora el evento --->
			</cfif>
	
	</cffunction>
		
	
	<!---selectorISBlogin--->
	<cffunction name="selectorISBlogin" access="public" returntype="void" output="true">
		<cfargument name="evento" type="struct" required="yes">
		<!--- 
			Invocación de interfaces originadas al modificar la tabla ISBlogin (UPDATE)
			Todas son interfaces de salida, es decir, desde SACI hacia fuera.
		--->
		<cfquery datasource="#session.dsn#" name="selectorISBlogin_Q">
			select l.LGnumero, p.PQcodigo, coalesce (l.Snumero, 0) as Snumero,
				p.CNnumero, l.LGtelefono, l.LGrealName, l.LGlogin, l.LGserids as INTPAD, l.Habilitado, l.LGevento
			from ISBlogin l
				join ISBproducto p on p.Contratoid = l.Contratoid
			where l.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.evento.oldValues.LGnumero#">
		</cfquery>
		<cfif IsDefined('Arguments.evento.newValues.Habilitado')>
			<cfif Arguments.evento.oldValues.Habilitado is 2 And
					Arguments.evento.newValues.Habilitado is 1>
					
					<cfset NotificarSACI = true>
					<cfif IsDefined('Arguments.evento.newValues.LGevento')>
						<cfif Arguments.evento.newValues.LGevento eq 'SIIC'>
							<cfset NotificarSACI = false>
						</cfif>		
					<cfelse>
						<cfif Arguments.evento.oldValues.LGevento eq 'SIIC'>
							<cfset NotificarSACI = false>
						</cfif>							
					</cfif>					
					<cfset anuncia('H005', 'out',  '', 'Reprogramación de login')>
					<cfinvoke component="H005_reprogramacionLogin" method="reprogramacionLoginLGnumero"
						origen="saci"
						login="#selectorISBlogin_Q.LGlogin#"
						LGnumero="#selectorISBlogin_Q.LGnumero#"
						paquete="#selectorISBlogin_Q.PQcodigo#"
						sobre="#selectorISBlogin_Q.Snumero#"
						INTPAD="#selectorISBlogin_Q.CNnumero#"
						NotificarSACI="#NotificarSACI#">
			<cfelseif Arguments.evento.oldValues.Habilitado is 0 And
					Arguments.evento.newValues.Habilitado is 1>
					<!--- No se hace nada, la interfaz H001 se invoca manualmente desde el SACI --->
			<cfelseif Arguments.evento.oldValues.Habilitado is 2 And
					Arguments.evento.newValues.Habilitado is 4>
				 <!--- Reutilización de Login --->
			<cfelseif Arguments.evento.oldValues.Habilitado is 1 And
					Arguments.evento.newValues.Habilitado is 2>									
					
					<cfset NotificarSACI = true>
					<cfif IsDefined('Arguments.evento.newValues.LGevento')>
						<cfif Arguments.evento.newValues.LGevento eq 'SIIC'>
							<cfset NotificarSACI = false>
						</cfif>		
					<cfelse>
						<cfif Arguments.evento.oldValues.LGevento eq 'SIIC'>
							<cfset NotificarSACI = false>
						</cfif>							
					</cfif>
					<cfset anuncia('H012', 'out',  '', 'Borrado de login')>
					<cfinvoke component="H012_borradoLogin" method="borradoLoginLGnumero"
						origen="saci"
						LGnumero="#selectorISBlogin_Q.LGnumero#"
						login="#selectorISBlogin_Q.LGlogin#"
						NotificarSACI="#NotificarSACI#">
			<cfelse>
				<cfthrow message="Cambio de estado inválido: ISBlogin.Habilitado pasa de #Arguments.evento.oldValues.Habilitado# a #Arguments.evento.newValues.Habilitado#">
			</cfif>
		<cfelseif IsDefined('Arguments.evento.newValues.LGbloqueado') And
				Arguments.evento.newValues.LGbloqueado is 1>
				<cfset anuncia('H010', 'out',  '', 'Bloqueo de login')>
				<cfinvoke component="H010_bloqueoLogin" method="bloqueoLogin"
					origen="saci"
					login="#selectorISBlogin_Q.LGlogin#" />
		<cfelseif IsDefined('Arguments.evento.newValues.LGbloqueado') And
				Arguments.evento.newValues.LGbloqueado is 0>
				<cfset anuncia('H011', 'out',  '', 'Desbloqueo de login')>
				<cfinvoke component="H011_desbloqueoLogin" method="desbloqueoLogin"
					origen="saci"
					login="#selectorISBlogin_Q.LGlogin#" />
		<cfelseif IsDefined('Arguments.evento.newValues.LGlogin') And
				Arguments.evento.oldValues.Habilitado neq 0>
				<cfset anuncia('H013', 'out',  '', 'Cambio de login')>
				
					<cfset NotificarSACI = true>
					<cfif IsDefined('Arguments.evento.newValues.LGevento')>
						<cfif Arguments.evento.newValues.LGevento eq 'SIIC'>
							<cfset NotificarSACI = false>
						</cfif>		
					<cfelse>
						<cfif Arguments.evento.oldValues.LGevento eq 'SIIC'>
							<cfset NotificarSACI = false>
						</cfif>							
					</cfif>
				<cfinvoke component="H013_cambioLogin" method="cambioLoginLGnumero"
					origen="saci"
					loginAnterior="#Arguments.evento.oldValues.LGlogin#"
					loginNuevo="#Arguments.evento.newValues.LGlogin#"
					LGnumero="#selectorISBlogin_Q.LGnumero#" 
					NotificarSACI="#NotificarSACI#">
		<cfelseif IsDefined('Arguments.evento.newValues.LGtelefono') And
				  selectorISBlogin_Q.Habilitado neq 0>
				<cfset anuncia('H020', 'out',  '', 'Modificación de telefono')>
				<cfinvoke component="H020_cambioTelefono" method="cambioTelefonoLGnumero"
					origen="saci"
					LGnumero="#selectorISBlogin_Q.LGnumero#"
					LGlogin="#selectorISBlogin_Q.LGlogin#"
					telefono="#selectorISBlogin_Q.LGtelefono#"/>
		<cfelseif IsDefined('Arguments.evento.newValues.Snumero') and selectorISBlogin_Q.Habilitado neq 0>
				<cfset anuncia('H039', 'out',  '', 'Cambio de password por sobre')>
				<cfinvoke component="H039_cambioPasswordSobre" method="cambioPasswordLGnumero"
					origen="saci"
					LGlogin="#selectorISBlogin_Q.LGlogin#"
					LGnumero="#selectorISBlogin_Q.LGnumero#"
					Snumero="#selectorISBlogin_Q.Snumero#"
					tipocambio="global"/>
		<cfelseif IsDefined('Arguments.evento.newValues.LGrealName')>
				<cfset anuncia('H040', 'out',  '', 'Cambio de real name')>
				<cfinvoke component="H040_cambioRealName" method="cambioRealNameLGnumero"
					origen="saci"
					LGlogin="#selectorISBlogin_Q.LGlogin#"
					LGnumero="#selectorISBlogin_Q.LGnumero#"
					LGrealName="#selectorISBlogin_Q.LGrealName#" />
		<cfelseif IsDefined('Arguments.evento.newValues.Contratoid')>									
				
				<cfset anuncia('H014', 'out',  '', 'Cambio de Paquete - Contrato Nuevo')>
				<cfinvoke component="H014_cambioPaquete" method="cambioPaquete"
					origen="saci"
					login ="#selectorISBlogin_Q.LGlogin#"
					CINCAT="#selectorISBlogin_Q.PQcodigo#"
					telefono="#selectorISBlogin_Q.LGtelefono#"
					INTPAD = "#selectorISBlogin_Q.INTPAD#"
					S02CON = "0"
					notificarSIIC="true">
		</cfif>
	</cffunction>
	<!---selectorISBprepago--->
	<cffunction name="selectorISBprepago" returntype="void" output="false">
		<cfargument name="evento" type="struct" required="yes">
		<!--- 
			Invocación de interfaces originadas al modificar la tabla ISBprepago
			Todas son interfaces de salida, es decir, desde SACI hacia fuera.
		--->
		<cfif (Arguments.evento.tipo is 'update') and
				(		IsDefined('Arguments.evento.newValues.TJestado')
				or		IsDefined('Arguments.evento.newValues.TJdsaldo')
				or		IsDefined('Arguments.evento.newValues.AGid'))>
			<cfset anuncia('H016b', 'out',  '', 'Modificar estado prepagos')>
			<cfinvoke component="H016_prepago" method="updateIndividual"
				TJid="#Arguments.evento.oldValues.TJid#"
				updateEstado="#IsDefined('Arguments.evento.newValues.TJestado')#"
				updateSaldo="#IsDefined('Arguments.evento.newValues.TJdsaldo')#"
				updateAgente="#IsDefined('Arguments.evento.newValues.AGid')#"
				/>
		</cfif>
	</cffunction>
	<!---anuncia--->
	<cffunction name="anuncia">
		<cfargument name="interfaz" required="yes">
		<cfargument name="direccion" required="yes">
		<cfargument name="letra" required="yes">
		<cfargument name="descripcion" required="yes">

		<cflog file="repconn" text="anuncia interfaz #interfaz#:#direccion#:#letra#:#descripcion#">
		
	</cffunction>
</cfcomponent>
