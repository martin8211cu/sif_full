<!---
	En el mantenimiento del agente solamente se registran agentes externos y son habilitados automáticamente
	Debería existir un proceso que inabilite un agente, el cual implica adicionalmente inhabilitar su cuenta de acceso y cuenta de SACI
--->

<cfinclude template="agente-params.cfm">

<cfif isdefined("Form.Guardar")>
	
	<cfset form.Pid = form.PidSinMask>
	
	<!--- busca si el Pid de la persona existe en la base de datos, si existe lo modifica y si no lo agrega --->
	<cfquery datasource="#session.dsn#" name="rsVerifica">
		select Pquien from ISBpersona
		where Pid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Pid)#">
	</cfquery>
		
	
	<!--- busca el nivel mas alto de division politica para generar el nombre del compo de la localidad que vamos a almacenar en la tabla de personas --->
	<cfquery datasource="#session.dsn#" name="rsDivPolitica">
		select max(DPnivel) as nivel 
		from DivisionPolitica
		where Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.saci.pais#">
	</cfquery>

	<!--- nombre del campo que posee el valor de la localidad --->
	<cfset localidad = "LCid_" & rsDivPolitica.nivel>
	
	<cfif rsDivPolitica.RecordCount eq 0>
		<cfthrow message="Error: La división política no se ha definido.">
	<cfelse>
		
		<cfif len(trim(form[localidad])) EQ false>
			<cfthrow message="Error: Debe llenar los campos de Localidad, no pueden quedar en blanco.">
		</cfif>
		
		
		<cfif isdefined("form.tipo") and form.tipo eq 'Interno'>
			<cfset AAinterno = true>
		<cfelse>
			<cfset AAinterno = false>
		</cfif>	



		<cftransaction>
			<cfif isdefined("rsVerifica.Pquien") and len(trim(rsVerifica.Pquien))>		
				<cfset form.Pquien = rsVerifica.Pquien>
				<!--- Modifica los datos de la persona --->
				<cfinvoke component="saci.comp.ISBpersona" method="Cambio">
					<cfinvokeargument name="Pquien" value="#form.Pquien#">
					<cfinvokeargument name="Ppersoneria" value="#form.Ppersoneria#">
					<cfinvokeargument name="Pid" value="#form.Pid#">
					<cfif form.Ppersoneria EQ 'J'>
						<cfinvokeargument name="Pnombre" value="#trim(form.PrazonSocial)#">
						<cfinvokeargument name="PrazonSocial" value="#trim(form.PrazonSocial)#">
					<cfelse>
						<cfinvokeargument name="Pnombre" value="#trim(form.Pnombre)#">
						<cfinvokeargument name="Papellido" value="#trim(form.Papellido)#">
						<cfinvokeargument name="Papellido2" value="#trim(form.Papellido2)#">
					</cfif>
					<cfif form.Ppersoneria EQ 'F' or form.Ppersoneria EQ 'J'>
						<cfinvokeargument name="Ppais" value="#session.saci.pais#">
					<cfelse>
						<cfinvokeargument name="Ppais" value="#form.Ppais#">
					</cfif>
					<!---<cfinvokeargument name="Pobservacion" value="#form.Pobservacion#">--->
					<cfif isdefined("Form.AEactividad") and Len(Trim(Form.AEactividad))>
					<cfinvokeargument name="AEactividad" value="#form.AEactividad#">
					</cfif>
					<cfif isdefined("Form.CPid") and Len(Trim(Form.CPid))>
						<cfinvokeargument name="CPid" value="#form.CPid#">
					</cfif>
					
					<cfinvokeargument name="cambialocalizacion" value="false">
					
					<!---Cambio solo actualiza la localizacion del Agente--->
					<!---<cfinvokeargument name="Papdo" value="#form.Papdo#">
					<cfinvokeargument name="LCid" value="#form[localidad]#">
					<cfinvokeargument name="Pdireccion" value="#form.Pdireccion#">
					<cfinvokeargument name="Pbarrio" value="#form.Pbarrio#">
					<cfinvokeargument name="Ptelefono1" value="#trim(form.Ptelefono1)#">
					<cfinvokeargument name="Ptelefono2" value="#trim(form.Ptelefono2)#">
					<cfinvokeargument name="Pfax" value="#trim(form.Pfax)#">
					<cfinvokeargument name="Pemail" value="#trim(form.Pemail)#">--->
					<cfinvokeargument name="ts_rversion" value="#trim(form.ts_rversionp)#">
				</cfinvoke>	
			
			<cfelse>	
				
				<!--- Agrega los datos de la persona --->	
				<cfinvoke component="saci.comp.ISBpersona" method="Alta"  returnvariable="idReturn">
					<cfinvokeargument name="Ppersoneria" value="#form.Ppersoneria#">
					<cfinvokeargument name="Pid" value="#form.Pid#">
					<cfif form.Ppersoneria EQ 'J'>
						<cfinvokeargument name="Pnombre" value="#trim(form.PrazonSocial)#">
						<cfinvokeargument name="PrazonSocial" value="#trim(form.PrazonSocial)#">
					<cfelse>
						<cfinvokeargument name="Pnombre" value="#trim(form.Pnombre)#">
						<cfinvokeargument name="Papellido" value="#trim(form.Papellido)#">
						<cfinvokeargument name="Papellido2" value="#trim(form.Papellido2)#">
					</cfif>
					<cfif form.Ppersoneria EQ 'F' or form.Ppersoneria EQ 'J'>
						<cfinvokeargument name="Ppais" value="#session.saci.pais#">
					<cfelse>
						<cfinvokeargument name="Ppais" value="#form.Ppais#">
					</cfif>
					<cfif isdefined("Form.AEactividad") and Len(Trim(Form.AEactividad))>
					<cfinvokeargument name="AEactividad" value="#form.AEactividad#">
					</cfif>
					<cfif isdefined("Form.CPid") and Len(Trim(Form.CPid))>
						<cfinvokeargument name="CPid" value="#form.CPid#">
					</cfif>
					<cfinvokeargument name="Papdo" value="#form.Papdo#">
					<cfinvokeargument name="LCid" value="#form[localidad]#">
					<cfinvokeargument name="Pdireccion" value="#form.Pdireccion#">
					<cfinvokeargument name="Pbarrio" value="#form.Pbarrio#">
					<cfinvokeargument name="Ptelefono1" value="#trim(form.Ptelefono1)#">
					<cfinvokeargument name="Ptelefono2" value="#trim(form.Ptelefono2)#">
					<cfinvokeargument name="Pfax" value="#trim(form.Pfax)#">
					<cfinvokeargument name="Pemail" value="#trim(form.Pemail)#">
				</cfinvoke>
				<cfif idReturn eq -1>
					<cfthrow message="Error: No se pudo agregar la persona, verifique los datos.">
				<cfelse>
					<cfset form.Pquien = idReturn>  
				</cfif>
				
			</cfif>

			<!--- Registro de Atributos Extendidos de Persona --->
			<cfif isdefined("Form.Ppersoneria") and (Form.Ppersoneria EQ "F" or Form.Ppersoneria EQ "J")>
				<cfset tipo = Iif(Form.Ppersoneria EQ "F", DE("1"), DE("2"))>
				<cfinvoke component="saci.comp.atrExtendidosPersona" method="Alta_Cambio">
					<cfinvokeargument 	name="id" 				value="#form.Pquien#">
					<cfinvokeargument 	name="identificacion" 	value="#form.Pid#">
					<cfinvokeargument 	name="tipo" 			value="#tipo#">
					<cfinvokeargument 	name="Usuario" 			value="#session.Usucodigo#">
					<cfinvokeargument 	name="Ecodigo" 			value="#session.Ecodigo#">
					<cfinvokeargument	name="Conexion" 		value="#session.DSN#">
					<cfinvokeargument 	name="form" 			value="#form#">
				</cfinvoke>
			</cfif>

			<!--- verifica si existe el agente--->
			<cfquery datasource="#session.dsn#" name="rsVerificaAgente">
				select AGid,AAinterno
				from ISBagente
				where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Pquien#">
			</cfquery>	
			
			<cfif isdefined("rsVerificaAgente.AGid") and len(trim(rsVerificaAgente.AGid))> 
				<cfif rsVerificaAgente.AAinterno neq #AAinterno#>
					<cfthrow message="Error en la modificación, el agente no está asociado al grupo #form.tipo#">
				</cfif>
			</cfif>
			<cfif isdefined("rsVerificaAgente.AGid") and len(trim(rsVerificaAgente.AGid))>	
		
				<cfset form.AGid = rsVerificaAgente.AGid>

				<!--- Modifica el agente--->
				<cfinvoke component="saci.comp.ISBagente" method="Cambio">
					<cfinvokeargument name="AGid" value="#form.AGid#">
					<cfinvokeargument name="Pquien" value="#form.Pquien#">
					<cfinvokeargument name="AAplazoDocumentacion" value="#form.AAplazoDocumentacion#">
					<cfinvokeargument name="AAcomisionTipo" value="#form.AAcomisionTipo#">
					<cfif isdefined("form.AAcomisionTipo") and form.AAcomisionTipo EQ 1>
						<cfif isdefined("form.AAcomisionPctj") and len(trim(form.AAcomisionPctj))>
							<cfinvokeargument name="AAcomisionPctj" value="#form.AAcomisionPctj#">
						</cfif>
					</cfif>
					<cfif isdefined("form.AAcomisionTipo") and form.AAcomisionTipo EQ 2>
						<cfif isdefined("form.AAcomisionMnto") and len(trim(form.AAcomisionMnto))>
							<cfinvokeargument name="AAcomisionMnto" value="#form.AAcomisionMnto#">
						</cfif>
					</cfif>
					<cfinvokeargument name="AAprospecta" value="#IsDefined('form.AAprospecta')#">
					<cfif isdefined("form.AAfechacontrato")>
					<cfinvokeargument name="AAfechacontrato" value="#form.AAfechacontrato#">
					</cfif>
					<cfinvokeargument name="AAinterno" value="#AAinterno#">
					<cfinvokeargument name="Habilitado" value="true">
					<cfinvokeargument name="ts_rversion" value="#trim(form.ts_rversion_agente)#">
				</cfinvoke>

				<cfquery name="rsVendedor" datasource="#session.dsn#">
					select Vid
					from ISBvendedor
					where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGid#">
					and Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Pquien#">
					and Vprincipal = 1
				</cfquery>

				<!--- Modifica el vendedor --->
				<cfif rsVendedor.recordCount GT 0>
					<cfinvoke component="saci.comp.ISBvendedor" method="Cambio">
						<cfinvokeargument name="Vid" value="#rsVendedor.Vid#">
						<cfinvokeargument name="Pquien" value="#form.Pquien#">
						<cfinvokeargument name="AGid" value="#form.AGid#">
						<cfinvokeargument name="Vprincipal" value="true">
						<cfinvokeargument name="Habilitado" value="true">
					</cfinvoke>
				</cfif>
					
			<cfelse>
				<!-------------------------------- ALTA DE CUENTA DE ACCESO DEL AGENTE ----------------------->
				<cfinvoke component="saci.comp.ISBcuenta" method="Alta" returnvariable="cuenta">
					<cfinvokeargument name="Pquien" value="#form.Pquien#">
					<cfinvokeargument name="CUECUE" value="0">
					<cfinvokeargument name="CTapertura" value="#Now()#">
					<cfinvokeargument name="CTdesde" value="#Now()#">
					<cfinvokeargument name="CTcobrable" value="C">
					<!---
					<cfinvokeargument name="CCclaseCuenta" value="#form.CCclaseCuenta#">
					<cfinvokeargument name="GCcodigo" value="#form.GCcodigo#">
					--->
					<cfinvokeargument name="CTpagaImpuestos" value="false">
					<cfinvokeargument name="Habilitado" value="false">
					<cfinvokeargument name="CTobservaciones" value="Cuenta de Acceso para el Agente">
					<cfinvokeargument name="CTcomision" value="0">
					<cfinvokeargument name="CTtipoUso" value="A">
				</cfinvoke>
				<cfset Form.CTidAcceso = cuenta>

				<!------------------------------- ALTA DE MECANISMOS DE ENVIO -------------------------------->
				<cfinvoke component="saci.comp.ISBcuentaNotifica" method="Alta">
					<cfinvokeargument name="CTid" value="#form.CTidAcceso#">
					<cfinvokeargument name="CTcopiaModo" value="S">
				</cfinvoke>
	
				<!--------------------------------- ALTA DE FORMAS DE COBRO ---------------------------------->
				<cfinvoke component="saci.comp.ISBcuentaCobro" method="Alta">
					<cfinvokeargument name="CTid" value="#form.CTidAcceso#">
					<cfinvokeargument name="CTcobro" value="2">
				</cfinvoke>

				<!----------------------------- ALTA DE PAQUETE DE ACCESO DEL AGENTE ------------------------->
				<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="paqueteAgente">
					<cfinvokeargument name="Pcodigo" value="100">
				</cfinvoke>
				<cfif Len(Trim(paqueteAgente))>
					<!-------------------------------- ALTA DE PRODUCTO ------------------------------------------>
					<cfinvoke component="saci.comp.ISBproducto" method="Alta" returnvariable="contrato">
						<cfinvokeargument name="CTid" value="#form.CTidAcceso#">
						<cfinvokeargument name="CTidFactura" value="#form.CTidAcceso#">
						<cfinvokeargument name="PQcodigo" value="#Trim(paqueteAgente)#">
						<cfinvokeargument name="CTcondicion" value="C">
						<cfinvokeargument name="CNnumero" value="0">
						<cfinvokeargument name="CNapertura" value="#Now()#">
					</cfinvoke>

					<!-------------------------------- ALTA DE GARANTIA ------------------------------------------>
					<cfinvoke component="saci.comp.ISBgarantia" method="Alta">
						<cfinvokeargument name="Gid" value="T#contrato#">
						<cfinvokeargument name="Contratoid" value="#contrato#">
						<cfinvokeargument name="Gtipo" value="3">
						<cfinvokeargument name="Gmonto" value="0">
						<cfinvokeargument name="Gvence" value="#CreateDate(6100, 01, 01)#">
						<cfinvokeargument name="Gestado" value="S">
					</cfinvoke>
				
				<cfelse>
					<cfthrow message="No se ha parametrizado el paquete de acceso para agente en Parámetros Globales.">
				</cfif>
				
				<!------------------------------- ALTA DE CUENTA DE FACTURACION DEL AGENTE ---------------------->
				<cfinvoke component="saci.comp.ISBcuenta" method="Alta" returnvariable="cuenta">
					<cfinvokeargument name="Pquien" value="#form.Pquien#">
					<cfinvokeargument name="CUECUE" value="0">
					<cfinvokeargument name="CTapertura" value="#Now()#">
					<cfinvokeargument name="CTdesde" value="#Now()#">
					<cfinvokeargument name="CTcobrable" value="C">
					<!---
					<cfinvokeargument name="CCclaseCuenta" value="#form.CCclaseCuenta#">
					<cfinvokeargument name="GCcodigo" value="#form.GCcodigo#">
					--->
					<cfinvokeargument name="CTpagaImpuestos" value="false">
					<cfinvokeargument name="Habilitado" value="false">
					<cfinvokeargument name="CTobservaciones" value="Cuenta de Facturación para el Agente">
					<cfinvokeargument name="CTcomision" value="0">
					<cfinvokeargument name="CTtipoUso" value="F">
				</cfinvoke>
				<cfset Form.CTidFactura = cuenta>
				
				<!------------------------------- ALTA DE MECANISMOS DE ENVIO -------------------------------->
				<cfinvoke component="saci.comp.ISBcuentaNotifica" method="Alta">
					<cfinvokeargument name="CTid" value="#form.CTidFactura#">
					<cfinvokeargument name="CTcopiaModo" value="S">
				</cfinvoke>
	
				<!--------------------------------- ALTA DE FORMAS DE COBRO ---------------------------------->
				<cfinvoke component="saci.comp.ISBcuentaCobro" method="Alta">
					<cfinvokeargument name="CTid" value="#form.CTidFactura#">
					<cfinvokeargument name="CTcobro" value="2">
				</cfinvoke>

				<!-------------------------------------- ALTA DEL AGENTE ------------------------------------->
				<cfinvoke component="saci.comp.ISBagente" method="Alta"  returnvariable="idReturn">
					<cfinvokeargument name="Pquien" value="#form.Pquien#">
					<cfinvokeargument name="CTidAcceso" value="#form.CTidAcceso#">
					<cfinvokeargument name="CTidFactura" value="#form.CTidFactura#">
					<cfinvokeargument name="AAplazoDocumentacion" value="#form.AAplazoDocumentacion#">
					<cfinvokeargument name="AAcomisionTipo" value="#form.AAcomisionTipo#">
					<cfif isdefined("form.AAcomisionTipo") and form.AAcomisionTipo EQ 1> 
						<cfif isdefined("form.AAcomisionPctj") and len(trim(form.AAcomisionPctj))>
							<cfinvokeargument name="AAcomisionPctj" value="#form.AAcomisionPctj#">
						</cfif>
					</cfif>
					<cfif isdefined("form.AAcomisionTipo") and form.AAcomisionTipo EQ 2>
						<cfif isdefined("form.AAcomisionMnto") and len(trim(form.AAcomisionMnto))>
							<cfinvokeargument name="AAcomisionMnto" value="#form.AAcomisionMnto#">
						</cfif>
					</cfif>
					<cfif isdefined("form.AAprospecta")>
					<cfinvokeargument name="AAprospecta" value="#IsDefined('form.AAprospecta')#">
					</cfif>
					<cfif isdefined("form.AAfechacontrato")>
					<cfinvokeargument name="AAfechacontrato" value="#form.AAfechacontrato#">
					</cfif>
					<cfinvokeargument name="AAinterno" value="#AAinterno#">
					<cfinvokeargument name="Habilitado" value="true">
				</cfinvoke>
					
				<cfif idReturn eq -1>
					<cfthrow message="Error: No se pudo agregar el agente, verifique los datos.">
				<cfelse>
					<cfset form.AGid = idReturn>  
				</cfif>

				<!--------------------------- AGREGARSE COMO VENDEDOR PRINCIPAL ---------------------------->
				<cfinvoke component="saci.comp.ISBvendedor" method="Alta"  returnvariable="idReturn">
					<cfinvokeargument name="Pquien" value="#form.Pquien#">
					<cfinvokeargument name="AGid" value="#form.AGid#">
					<cfinvokeargument name="Vprincipal" value="true">
					<cfinvokeargument name="Habilitado" value="true">
				</cfinvoke>
				<cfif idReturn eq -1>
					<cfthrow message="Error: No se pudo agregar el vendedor, verifique los datos.">
				<cfelse>
					<cfset form.Vid = idReturn>
				</cfif>

			</cfif>
				
			<!--- agrega o modifica los atributos extendidos del agente --->
			<cfinvoke component="saci.comp.atrExtendidosPersona" method="Alta_Cambio">
				<cfinvokeargument 	name="id" 				value="#form.AGid#">
				<cfinvokeargument 	name="identificacion" 	value="#form.Pid#">
				<cfinvokeargument 	name="tipo" 			value="3">
				<cfinvokeargument 	name="Usuario" 			value="#session.Usucodigo#">
				<cfinvokeargument 	name="Ecodigo" 			value="#session.Ecodigo#">
				<cfinvokeargument	name="Conexion" 		value="#session.DSN#">
				<cfinvokeargument 	name="form" 			value="#form#">
				<cfinvokeargument 	name="sufijo" 			value="2">
			</cfinvoke>

			<cfif isdefined("form.Lid") and len(trim(form.Lid))>	
					
				<!--- Modifica los datos de la ISBlocalizacion --->
				<cfinvoke component="saci.comp.ISBlocalizacion" method="Cambio">
					<cfinvokeargument name="Lid" value="#form.Lid#">
					<cfinvokeargument name="RefId" value="#form.AGid#">
					<cfinvokeargument name="Ltipo" value="A">
					
					<cfif isdefined("Form.CPid") and Len(Trim(Form.CPid))>
						<cfinvokeargument name="CPid" value="#form.CPid#">
					</cfif>
					<cfinvokeargument name="Papdo" value="#form.Papdo#">
					<cfinvokeargument name="LCid" value="#form[localidad]#">
					<cfinvokeargument name="Pdireccion" value="#form.Pdireccion#">
					<cfinvokeargument name="Pbarrio" value="#form.Pbarrio#">
					<cfinvokeargument name="Ptelefono1" value="#trim(form.Ptelefono1)#">
					<cfinvokeargument name="Ptelefono2" value="#trim(form.Ptelefono2)#">
					<cfinvokeargument name="Pfax" value="#trim(form.Pfax)#">
					<cfinvokeargument name="Pemail" value="#trim(form.Pemail)#">
					<cfinvokeargument name="Pobservacion" value="#trim(form.Pobservacion)#">
					<cfinvokeargument name="ts_rversion" value="#trim(form.ts_rversionl)#">
				</cfinvoke>	
			
			<cfelse>	
				
				<!--- Agrega los datos de la ISBlocalizacion --->	
				<cfinvoke component="saci.comp.ISBlocalizacion" method="Alta"  returnvariable="idReturn">
					
					<cfinvokeargument name="RefId" value="#form.AGid#">
					<cfinvokeargument name="Ltipo" value="A">					
					
					<cfif isdefined("Form.CPid") and Len(Trim(Form.CPid))>
						<cfinvokeargument name="CPid" value="#form.CPid#">
					</cfif>
					<cfinvokeargument name="Papdo" value="#form.Papdo#">
					<cfinvokeargument name="LCid" value="#form[localidad]#">
					<cfinvokeargument name="Pdireccion" value="#form.Pdireccion#">
					<cfinvokeargument name="Pbarrio" value="#form.Pbarrio#">
					<cfinvokeargument name="Ptelefono1" value="#trim(form.Ptelefono1)#">
w					<cfinvokeargument name="Ptelefono2" value="#trim(form.Ptelefono2)#">
					<cfinvokeargument name="Pfax" value="#trim(form.Pfax)#">
					<cfinvokeargument name="Pemail" value="#trim(form.Pemail)#">
					<cfinvokeargument name="Pobservacion" value="#trim(form.Pobservacion)#">
				</cfinvoke>
				<cfif idReturn eq -1>
					<cfthrow message="Error: No se pudo agregar la persona, verifique los datos.">
				<cfelse>
					<cfset form.Lid = idReturn>  
				</cfif>
				
			</cfif>

		</cftransaction>
	</cfif>

	<!--- Replicar el cambio del agente en el SACISIIC --->	
	<cfinvoke component="saci.ws.intf.H045_agente"
		method="replicarAgente"
		origen="saci"
		operacion="C"
		AGid="#Form.AGid#"/>
</cfif>

<cfif isdefined("Form.Eliminar")>

		<cfinvoke component="saci.comp.ISBparametros" method="Get" Pcodigo="228" returnvariable="motivobloqueo"/>
		
		<cfif isdefined("form.AGid") and len(trim(form.AGid))>	
			<cfquery datasource="#Session.DSN#" name="rs">
				select count(1) as tot
					from ISBagente agen
						inner join ISBcuenta cue
					on agen.Pquien = cue.Pquien
						inner join ISBproducto pro
					on cue.CTid = pro.CTid
				where agen.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
				  and cue.CTtipoUso in ('A','F')
				  and pro.CTcondicion not in ('C')
			</cfquery>
		</cfif>	
		
		<cfquery datasource="#Session.DSN#" name="rsVentas">
				select count(1) as totales
					from ISBagente agen
						inner join ISBvendedor ven
					on agen.AGid = ven.AGid	
						inner join ISBproducto pro
					on ven.Vid = pro.Vid
				where agen.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
		</cfquery>
		
		<cfif (isdefined('form.tipo') and form.tipo eq 'Externo'  and  rs.tot eq 0) 
				or (isdefined('form.tipo') and form.tipo eq 'Interno' and rsVentas.totales eq 0)>
			
			<cftransaction>
				
				<cfinvoke component="saci.comp.ISBsobres" method="DesasignarDeCuenta">
					<cfinvokeargument name="CTid" value="#form.CTid#">
				</cfinvoke>
				
				<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Desasignar">
					<cfinvokeargument name="CTid" value="#form.CTid#">
				</cfinvoke>
				
				<cfinvoke component="saci.comp.ISBlogin" method="BajaCuenta">
					<cfinvokeargument name="CTid" value="#form.CTid#">
					<cfinvokeargument name="soloEnCaptura" value="1">
					<cfinvokeargument name="registrar_en_bitacora" value="false">
				</cfinvoke>
		
				<cfinvoke component="saci.comp.ISBgarantia" method="BajaCuenta">
					<cfinvokeargument name="CTid" value="#form.CTid#">
					<cfinvokeargument name="soloEnCaptura" value="1">	
				</cfinvoke>
				
				<cfinvoke component="saci.comp.ISBproducto" method="BajaCuenta">
					<cfinvokeargument name="CTid" value="#form.CTid#">
					<cfinvokeargument name="soloEnCaptura" value="1">
				</cfinvoke>
			
				<!----Para sacar la 2da cuenta del agente.---->
				<cfquery name="rs" datasource="#Session.DSN#">
					select coalesce(CTidFactura,-1) as CTidFactura
						from ISBagente
					where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
				</cfquery>
				<cfset CTidFactura = -1>
				<cfif isdefined('rs') and rs.recordCount gt 0>
					<cfset CTidFactura = rs.CTidFactura>
				</cfif>
				
				<!-----Actualizacion de los campos llave de agente para poder borrar las cuentas----->
				<cfquery name="rs" datasource="#Session.DSN#">
					update ISBagente
						set CTidFactura = null, CTidAcceso = null
					where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
				</cfquery>
				
				
				<cfquery name="hayProductos" datasource="#Session.DSN#">
					Select count(1) as cantProd
						from ISBproducto
					where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
				</cfquery>
				<!--- Solo se borrara la cuenta si no existen productos asociados a esta --->
				<cfif isdefined('hayProductos') and hayProductos.cantProd EQ 0>
			
					<cfinvoke component="saci.comp.ISBcuentaNotifica" method="Baja">
						<cfinvokeargument name="CTid" value="#form.CTid#">
					</cfinvoke>
			
					<cfinvoke component="saci.comp.ISBcuentaCobro" method="Baja">
						<cfinvokeargument name="CTid" value="#form.CTid#">
					</cfinvoke>
			
						<!--- Borra los atributos extendidos de la Cuenta --->
					<cfquery name="eliminaAtributo" datasource="#Session.DSN#">
						Delete ISBcuentaAtributo
						where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
					</cfquery>
		
			
					<cfinvoke component="saci.comp.ISBcuenta" method="Baja">
						<cfinvokeargument name="CTid" value="#form.CTid#">
					</cfinvoke>
			
					<cfset Form.CTid = "">
					<cfset Form.cue = "">		
			
				</cfif>
			
				
				<cfquery name="hayProductos" datasource="#Session.DSN#">
					Select count(1) as cantProd
					from ISBproducto
					where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CTidFactura#">
				</cfquery>
				<!--- Solo se borrara la cuenta 2 si no existen productos asociados a esta --->
				<cfif isdefined('hayProductos') and hayProductos.cantProd EQ 0 and CTidFactura neq -1>
					
					<cfinvoke component="saci.comp.ISBcuentaNotifica" method="Baja">
						<cfinvokeargument name="CTid" value="#CTidFactura#">
					</cfinvoke>
			
					<cfinvoke component="saci.comp.ISBcuentaCobro" method="Baja">
						<cfinvokeargument name="CTid" value="#CTidFactura#">
					</cfinvoke>
					
					<cfinvoke component="saci.comp.ISBcuenta" method="Baja">
						<cfinvokeargument name="CTid" value="#CTidFactura#">
					</cfinvoke>
					
				</cfif>
				
				
				<!-----Borrado del agente   **VALIDACIONES PREVIAS!!!------>
				<cfset i = 0>
				<cfset msgError ="Validaciones Previas para el borrado del Agente:<br>">
				
				<!------Validacion 1------->
				<cfquery name="rs" datasource="#Session.DSN#">
					Select count(1) as t
						from ISBagenteAtributo
					where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
				</cfquery>
				<cfif rs.t gt 0>
					<cfset i = i + 1>
					<cfset msgError ="#msgError#<br>-El agente tiene atributos asociados">
				</cfif>
				
				<!------Validacion 2------->
				<cfquery name="rs" datasource="#Session.DSN#">
					Select count(1) as t
						from ISBagenteCobertura
					where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
				</cfquery>
				<cfif rs.t gt 0>
					<cfset i = i + 1>
					<cfset msgError ="#msgError#<br>-El agente tiene localidades de cobertura asociadas">
				</cfif>
				
				<!------Validacion 3------->
				<cfquery name="rs" datasource="#Session.DSN#">
					Select count(1) as t
						from ISBagenteIncidencia
					where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
				</cfquery>
				<cfif rs.t gt 0>
					<cfset i = i + 1>
					<cfset msgError ="#msgError#<br>-El agente tiene incidencias asociadas">
				</cfif>
				
				<!------Validacion 4------->
				<cfquery name="rs" datasource="#Session.DSN#">
					Select count(1) as t
						from ISBagenteOferta
					where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
				</cfquery>
				<cfif rs.t gt 0>
					<cfset i = i + 1>
					<cfset msgError ="#msgError#<br>-El agente tiene ofertas asociadas">
				</cfif>
				
				<!------Validacion 5------->
				<cfquery name="rs" datasource="#Session.DSN#">
					Select count(1) as t
						from ISBagentePrevio
					where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
				</cfquery>
				<cfif rs.t gt 0>
					<cfset i = i + 1>
					<cfset msgError ="#msgError#<br>-El agente esta asociado a un agente previo">
				</cfif>
				
				<!------Validacion 6------->
				<cfquery name="rs" datasource="#Session.DSN#">
					Select count(1) as t
						from ISBagenteValoracion
					where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
				</cfquery>
				<cfif rs.t gt 0>
					<cfset i = i + 1>
					<cfset msgError ="#msgError#<br>-El agente tiene valoraciones asociadas">
				</cfif>
				
				<!------Validacion 7------->
				<cfquery name="rs" datasource="#Session.DSN#">
					Select count(1) as t
						from ISBagentecontactos
					where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
				</cfquery>
				<cfif rs.t gt 0>
					<cfset i = i + 1>
					<cfset msgError ="#msgError#<br>-El agente tiene contactos asociados">
				</cfif>
				
				<!------Validacion 8------->
				<cfquery name="rs" datasource="#Session.DSN#">
					Select count(1) as t
						from ISBmensajesCliente
					where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
				</cfquery>
				<cfif rs.t gt 0>
					<cfset i = i + 1>
					<cfset msgError ="#msgError#<br>-El agente tiene mensajes de clientes asociados">
				</cfif>
				
				<!------Validacion 9------->
				<cfquery name="rs" datasource="#Session.DSN#">
					Select count(1) as t
						from ISBprepago
					where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
				</cfquery>
				<cfif rs.t gt 0>
					<cfset i = i + 1>
					<cfset msgError ="#msgError#<br>-El agente tiene tarjetas de prepago asociadas">
				</cfif>
				
				<!------Validacion 10------->
				<cfquery name="rs" datasource="#Session.DSN#">
					Select count(1) as t
						from ISBprospectos
					where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
				</cfquery>
				<cfif rs.t gt 0>
					<cfset i = i + 1>
					<cfset msgError ="#msgError#<br>-El agente tiene prospectos asociados">
				</cfif>
				
				<!------Validacion 11------->
				<cfquery name="rs" datasource="#Session.DSN#">
					Select count(1) as t
						from ISBsobres
					where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
				</cfquery>
				<cfif rs.t gt 0>
					<cfset i = i + 1>
					<cfset msgError ="#msgError#<br>-El agente tiene sobres asociados">
				</cfif>
				
				
				<!------Validacion 12------>
				<cfquery name="rs" datasource="#Session.DSN#">
					Select count(1) as t
						from ISBsolicitudes
					where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
				</cfquery>
				<cfif rs.t gt 0>
					<cfset i = i + 1>
					<cfset msgError ="#msgError#<br>-El agente tiene solicitudes asociadas">
				</cfif>
				
				<!------Validacion 13.0 Eliminacion de Localizaciones de Representatentes del Vendedor------->
				<cfquery name="rs" datasource="#Session.DSN#">
					delete ISBlocalizacion
						where RefId in (select b.Rid
											from ISBvendedor a
											 inner join ISBpersonaRepresentante b
											 on a.Pquien = b.Pquien
											where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
											  and a.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
										)
						   and Ltipo = 'R'
				</cfquery>
				<cfquery name="rs" datasource="#Session.DSN#">
					select count(1) as t 
						from ISBlocalizacion
					where RefId in (select b.Rid
										from ISBvendedor a
										 inner join ISBpersonaRepresentante b
										 on a.Pquien = b.Pquien
										where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
										  and a.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">)
						and Ltipo = 'R'
				</cfquery>
				<cfif rs.t gt 0>
					<cfset i = i + 1>
					<cfset msgError ="#msgError#<br>-El agente tiene Representantes asociados al Vendedor">
				</cfif>
				
				<!------Validacion 13.1 Eliminacion de Localizaciones del Vendedor------->
				<cfquery name="rs" datasource="#Session.DSN#">
					delete ISBlocalizacion
						from ISBvendedor
					where ISBlocalizacion.RefId = ISBvendedor.Vid
					  and ISBvendedor.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
					  and ISBlocalizacion.Ltipo = 'V'
				</cfquery>
				<cfquery name="rs" datasource="#Session.DSN#">
					select count(1) as t
						from ISBlocalizacion, ISBvendedor
					where ISBlocalizacion.RefId = ISBvendedor.Vid
					  and ISBvendedor.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
					  and ISBlocalizacion.Ltipo = 'V'
				</cfquery>
				<cfif rs.t gt 0>
					<cfset i = i + 1>
					<cfset msgError ="#msgError#<br>-El agente tiene localizaciones asociados al Vendedor">
				</cfif>
				
				<!------Validacion 13.2 Eliminacion del Representante del Vendedor------->
				<cfquery name="rs" datasource="#Session.DSN#">
					delete ISBpersonaRepresentante
						from ISBvendedor a
					where ISBpersonaRepresentante.Pquien = a.Pquien
					  and a.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
				</cfquery>
				<cfquery name="rs" datasource="#Session.DSN#">
					select count(1) as t 
						from  ISBpersonaRepresentante a, ISBvendedor b
					where a.Pquien = b.Pquien
					  and b.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
				</cfquery>
				<cfif rs.t gt 0>
					<cfset i = i + 1>
					<cfset msgError ="#msgError#<br>-El Vendedor tiene Representantes asociados">
				</cfif>
				
				<!------Validacion 13.3 Eliminacion del Vendedor------->
				<cfquery name="rs" datasource="#Session.DSN#">
					delete ISBvendedor
					where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
					  and Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pquien#">
				</cfquery>
				<cfquery name="rs" datasource="#Session.DSN#">
					Select count(1) as t
						from ISBvendedor
					where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
				</cfquery>
				<cfif rs.t gt 0>
					<cfset i = i + 1>
					<cfset msgError ="#msgError#<br>-El agente tiene vendedores asociados">
				</cfif>
				
				<!------Validacion 14.0 Eliminacion de Localizaciones del Representante del Agente------->
				<cfquery name="rs" datasource="#Session.DSN#">
					delete ISBlocalizacion
						where RefId in (select b.Rid
											from ISBagente a
											 inner join ISBpersonaRepresentante b
											 on a.Pquien = b.Pquien
											where a.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
										)
						   and Ltipo = 'R'
				</cfquery>
				<cfquery name="rs" datasource="#Session.DSN#">
					select count(1) as t 
						from ISBlocalizacion
					where RefId in (select b.Rid
										from ISBagente a
										 inner join ISBpersonaRepresentante b
										 on a.Pquien = b.Pquien
										where a.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">)
						and Ltipo = 'R'
				</cfquery>
				<cfif rs.t gt 0>
					<cfset i = i + 1>
					<cfset msgError ="#msgError#<br>-El agente tiene localizaciones asociadas">
				</cfif>
				
				<!------Validacion 14.1 Eliminacion del Representante del Vendedor------->
				<cfquery name="rs" datasource="#Session.DSN#">
					delete ISBpersonaRepresentante
						from ISBagente a
					where ISBpersonaRepresentante.Pquien = a.Pquien
					  and a.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
				</cfquery>
				<cfquery name="rs" datasource="#Session.DSN#">
					select count(1) as t 
						from  ISBpersonaRepresentante a, ISBagente b
					where a.Pquien = b.Pquien
					  and b.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
				</cfquery>
				<cfif rs.t gt 0>
					<cfset i = i + 1>
					<cfset msgError ="#msgError#<br>-El Agente tiene Representantes asociados">
				</cfif>
				
				<!------Validacion 14.2 Eliminicion de Localizaciones del Agente------->
				<cfquery name="rs" datasource="#Session.DSN#">
					delete ISBlocalizacion
					where RefId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
					  and Ltipo = 'A'
				</cfquery>
				<cfquery name="rs" datasource="#Session.DSN#">
					Select count(1) as t
						from ISBlocalizacion
					where RefId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
					  and Ltipo = 'A'
				</cfquery>
				<cfif rs.t gt 0>
					<cfset i = i + 1>
					<cfset msgError ="#msgError#<br>-El agente tiene localizaciones asociadas">
				</cfif>
				
				<!------Invocacion al borrado o mostrar error------->
				<cfif i gt 0>
					<!---------<cftransaction action="rollback"/>------->
					<cfthrow message="#msgError#<br><br>AGid:(#Form.AGid#)  Proceso Cancelado!!">
				<cfelse>
					<cfinvoke component="saci.comp.ISBagente" method="Baja">
						<cfinvokeargument name="AGid" value="#Form.AGid#">
					</cfinvoke>
				</cfif>
			</cftransaction>
		<cfelse>

				<cfquery name="rsBorrarExterno" datasource="#Session.DSN#">
					Update ISBagente Set Habilitado = 2
					Where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
				</cfquery>

				<cfinvoke component="saci.comp.ISBagente"
				method="inhabilitarAgente" 
				AGid="#Form.AGid#"
				MBmotivo= "#motivobloqueo#"
				Habilitado= "2"
				BLobs="Inhabilitación Automática de Agente #Form.AGid#, Se borro el  - #LSDateFormat(now(),'dd/mm/yyyy')#"/>
		</cfif>
</cfif>
<cfif isdefined("Form.Habilitar")>
	<cfinvoke component="saci.comp.ISBagente"
	method="inhabilitarAgente" 
	AGid="#form.AG#"
	Habilitado="1"/>
</cfif>

<cfif isdefined("Form.Inhabilitar")>
	<cfinvoke component="saci.comp.ISBagente"
	method="inhabilitarAgente" 
	AGid="#form.AG#"
	Habilitado="0"/>
</cfif>
<cfinclude template="agente-redirect.cfm">
