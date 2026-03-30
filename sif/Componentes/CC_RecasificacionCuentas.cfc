<!--- 
	Creado por Gustavo Fonseca H.	
		Fecha: 16-12-2005.
		Motivo: Nuevo preceso de Reclasificación de cuentas.
 --->

<cfcomponent>
 	
	<!--- Reclasificación de Cuentas --->
	<cffunction name="reclasificacionCuentas" access="public" output="true" returntype="numeric">
		<cfargument name="Ecodigo" 		type="numeric" required="yes">  		<!--- Codigo de la Empresa --->
		<cfargument name="SNcodigo" 	type="numeric" required="yes">  	<!--- Codigo del Socio de Negocios --->
		<cfargument name="Ccuentanue" 	type="numeric" required="yes">	<!--- Cuenta Nueva de los documentos (seleccionada) --->
		
		<cfargument name="id_direccion" type="numeric" required="no">	<!--- Direccion del socio de negocios (Opcional) --->
		<cfargument name="Ocodigo" 		type="numeric" required="no">		<!--- Oficina que se desea reclasificar.  Opcional --->
		<cfargument name="antiguedad" 	type="numeric" required="no">		<!--- Antiguedad en dias que se desea reclasificar (Opcional) --->
		<cfargument name="Ccuentaant" 	type="numeric" required="no">		<!--- Cuenta Anterior de los documentos (Opcional) --->
		<cfargument name="CCTcodigo" 	type="string"  required="no">						<!--- Tipo de Transaccion (opcional) --->
		<cfargument name="Ddocumento" 	type="string"  required="no">					<!--- Documento (Opcional) --->
		<cfargument name="usuario" 		type="string"  required="no">			<!--- Usuario --->
		<cfargument name="conexion" 	type="string"  required="false" default="#Session.DSN#"> <!--- Conexion de la base de datos --->
		<cfargument name="debug" 		type="string"  required="false"  default="N">	<!--- Debug --->
		
        <cfinclude template="../Utiles/sifConcat.cfm">
		<!--- Inserción del débito --->
		<cftransaction>
			<cfquery name="rsMcodigo" datasource="#Arguments.conexion#">
				select Mcodigo
				from Empresas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfquery>
			<cfif isdefined("rsMcodigo")  and rsMcodigo.recordcount EQ 1>
				<cfset Monloc = rsMcodigo.Mcodigo>
			</cfif>
			
			<cfset error = 0>
			<cfset Fecha = now()>
			
			<cfquery name="rsDescripcion" datasource="#Arguments.conexion#">
				select SNnombre as descripcion
				from SNegocios
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SNcodigo#">
			 </cfquery>
			 <cfif isdefined("rsDescripcion") and rsDescripcion.recordcount EQ 1>
			 	<cfset Descripcion = "Reclasificación CxC Socio: #rsDescripcion.descripcion#">
			 </cfif>
			 
			 <cfquery name="rsPeriodo" datasource="#Arguments.conexion#">
				select convert(int, Pvalor) as Periodo
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and Mcodigo = 'GN'
				  and Pcodigo = 50
			 </cfquery>
			 <cfif isdefined("rsPeriodo") and rsPeriodo.recordcount EQ 1>
			 	<cfset Periodo = rsPeriodo.Periodo>
			 </cfif>
			 <cfquery name="rsMes" datasource="#Arguments.conexion#">
				select convert(int, Pvalor) as Mes
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and Mcodigo = 'GN'
				  and Pcodigo = 60
			 </cfquery>
			 <cfif isdefined("rsMes") and rsMes.recordcount EQ 1>
			 	<cfset Mes = rsMes.Mes>
			 </cfif>
			  
			<!--- 1) Validaciones Generales --->
			<cfif Mes eq '' or Periodo eq ''>
				<cf_errorCode	code = "50983" msg = "No se ha definido el parámetro de Período o Mes para los sistemas Auxiliares! Proceso Cancelado!">
			</cfif>
			
			
			<!--- Obtención del Usucodigo --->
			<cfquery name="rsUsucodigo" datasource="#Arguments.conexion#">
				select a.Usucodigo
				from Usuario a, Empresa b
				where a.Usulogin = #Arguments.usuario#
					and b.CEcodigo = a.CEcodigo
					and b.Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfquery>
			<cfif isdefined("rsUsucodigo") and rsUsucodigo.recordcount EQ 1>
			 	<cfset Usucodigo = rsUsucodigo.Usucodigo>
			 </cfif>
			 
			<cfquery name="rsData" datasource="#Arguments.conexion#">
				select d.CCTcodigo, d.Ddocumento, d.Ocodigo, d.SNcodigo, d.Ecodigo, d.Dtotal, d.Dsaldo, d.Mcodigo, d.Dtcultrev, d.id_direccionFact
				from Documentos d
				where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and d.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SNcodigo#">
				  and d.id_direccionFact = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_direccion#">
				  and d.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ccuentaant#">
				  and d.Dsaldo <> 0.00
			</cfquery>
			
			
			<!--- Asiento. Para trasladar la cuenta--->
			<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" returnvariable="INTARC"/>
				<!--- 1. Seleccionar los documentos (Facturas y Notas) de la tabla Documentos ---> 
				<!--- 1.a.1. Modificar la cuenta contable anterior del Documento x Cobrar  --->
						<cfquery datasource="#Arguments.Conexion#">
							insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
							select 
								  'CCRC',
								  1,
								  a.Ddocumento,
								  a.CCTcodigo, 
								  case when #Monloc# != #rsData.moneda# then round(#rsData.saldo# * #rsData.tipocambio#,2) else #rsData.saldo# end,
								  case when b.CCTtipo = "D" then "C" else "D" end, 
								  'Reclasificacion de Documento ' #_Cat# #rsData.CCTcodigo# #_Cat# '-' #_Cat# #rsData.Ddocumento# #_Cat# ' ' #_Cat# c.SNnombre,
								  convert(varchar(8),getdate(),112),
								  #rsData.tipocambio",
								  #Periodo#,
								  #Mes#,
								  a.Ccuenta,
								  a.Mcodigo,
								  #rsData.Ocodigo#,
								  round(#rsData.saldo#, 2)
							from Documentos a, CCTransacciones b, SNegocios c
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
							  and a.CCTcodigo = #rsData.CCTcodigo#
							  and a.Ddocumento = #rsData.Ddocumento#
							  and b.Ecodigo = a.Ecodigo
							  and b.CCTcodigo = a.CCTcodigo
							  and c.Ecodigo = a.Ecodigo
							  and c.SNcodigo = a.SNcodigo
							<!--- Condiciones Opcionales --->
							<cfif isdefined("Arguments.Ocodigo") and len(trim(Arguments.Ocodigo))>
							  and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ocodigo#">
							</cfif>
							<cfif isdefined("Arguments.id_direccion") and len(trim(Arguments.id_direccion))>
							  and a.id_direccionFact = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_direccion#">
							</cfif>
							<cfif isdefined("Arguments.antiguedad") and len(trim(Arguments.antiguedad))>
							  and (datediff(dd, 'Dvencimiento', getdate())) < #Arguments.antiguedad# <!--- La antigüedad --->
							</cfif>
							<cfif isdefined("Arguments.Ccuentaant") and len(trim(Arguments.Ccuentaant))>
							  and a.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ccuentaant#">
							</cfif>
							<cfif isdefined("Arguments.CCTcodigo") and len(trim(Arguments.CCTcodigo))>
							  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="Arguments.CCTcodigo">
							</cfif>
							<cfif isdefined("Arguments.Ddocumento") and len(trim(Arguments.Ddocumento))>
							  and a.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="Arguments.Ddocumento">
							</cfif>
						</cfquery>
						
				<!--- 1.a.2. Modificar la cuenta contable nueva del Documento x Cobrar  --->
					<cfquery datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
						select 
							  'CCRC',
							  1,
							  a.Ddocumento,
							  a.CCTcodigo, 
							  case when #Monloc#!= #rsData.moneda# then round(#rsData.saldo# * #rsData.tipocambio#,2) else #rsData.saldo# end,
							  case when b.CCTtipo = "D" then "D" else "C" end, 
							  'Reclasificacion de Documento ' #_Cat# #rsData.CCTcodigo# #_Cat# '-' #_Cat# #rsData.Ddocumento# #_Cat# ' ' #_Cat# c.SNnombre,
							  convert(varchar(8),getdate(),112),
							  #rsData.tipocambio",
							  #Periodo#,
							  #Mes#,
							  #Arguments.Ccuentanue#,
							  a.Mcodigo,
							   #rsData.Ocodigo#,
							  round(#rsData.saldo#, 2)
						from Documentos a, CCTransacciones b, SNegocios c
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
						  and a.CCTcodigo = #rsData.CCTcodigo#
						  and a.Ddocumento = #rsData.Ddocumento#
						  and b.Ecodigo = a.Ecodigo
						  and b.CCTcodigo = a.CCTcodigo
						  and c.Ecodigo = a.Ecodigo
						  and c.SNcodigo = a.SNcodigo
					  <!--- Condiciones Opcionales --->
						<cfif isdefined("Arguments.Ocodigo") and len(trim(Arguments.Ocodigo))>
						  and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ocodigo#">
						</cfif>
						<cfif isdefined("Arguments.id_direccion") and len(trim(Arguments.id_direccion))>
						  and a.id_direccionFact = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_direccion#">
						</cfif>
						<cfif isdefined("Arguments.antiguedad") and len(trim(Arguments.antiguedad))>
						  and (datediff(dd, 'Dvencimiento', getdate())) < #Arguments.antiguedad# <!--- La antigüedad --->
						</cfif>
						<cfif isdefined("Arguments.Ccuentaant") and len(trim(Arguments.Ccuentaant))>
						  and a.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ccuentaant#">
						</cfif>
						<cfif isdefined("Arguments.CCTcodigo") and len(trim(Arguments.CCTcodigo))>
						  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="Arguments.CCTcodigo">
						</cfif>
						<cfif isdefined("Arguments.Ddocumento") and len(trim(Arguments.Ddocumento))>
						  and a.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="Arguments.Ddocumento">
						</cfif>
				  </cfquery>
		
					<!--- 2.b  Modificar la cuenta asignada al documento --->
					<cfquery datasource="#Arguments.conexion#">
						update HDocumentos
						set Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ccuentanue#">
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
						  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SNcodigo#">
						  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CCTcodigo#">
						  and Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ddocumento#">
						  and id_direccionFact = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Argumentsid_direccion#">
					</cfquery>

					<cfquery datasource="#Arguments.conexion#">
						update Documentos
						set Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ccuentanue#">
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
						  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SNcodigo#">
						  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CCTcodigo#">
						  and Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ddocumento#">
						  and id_direccionFact = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Argumentsid_direccion#">
					  </cfquery>										  
				<!--- /********  GRABAR EN LA BITACORA DE RECLASIFICACIONES.  NUEVA TABLA  ******/ --->

			<cfif Arguments.Debug>
				<cfquery name="rsDebugDocumentos" datasource="#Arguments.Conexion#">
					select 'Documentos', d.Ecodigo, d.CCTcodigo, d.Ddocumento, d.Ocodigo, d.SNcodigo, d.Mcodigo, d.Ccuenta, d.Rcodigo, d.Icodigo, d.Dtipocambio, d.Dtotal, d.Dsaldo, d.Dfecha, d.Dvencimiento, d.DfechaAplicacion, d.Dtcultrev, d.Dusuario, d.Dtref, d.Ddocref, d.Dmontoretori, d.Dretporigen, d.Dreferencia, d.DEidVendedor, d.DEidCobrador, d.id_direccionFact, d.id_direccionEnvio, d.CFid, d.DEdiasVencimiento, d.DEordenCompra, d.DEnumReclamo, d.DEobservacion, d.DEdiasMoratorio, d.BMUsucodigo, d.ts_rversion, d.DdocumentoId, d.TESDPaprobadoPendiente 
						from Documentos d
						where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
						  and d.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SNcodigo#">
						  <cfif isdefined("Arguments.id_direccion") and len(trim(Arguments.id_direccion))>
						  	and d.id_direccionFact = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_direccion#">
						  </cfif>
						  and d.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ccuentanue#">
						  and d.Dsaldo <> 0.00
				</cfquery>
					  
				<cfquery name="rsDebugDocumentos" datasource="#Arguments.Conexion#">
					select 'Documentos', d.HDid, d.Ecodigo, d.CCTcodigo, d.Ddocumento, d.Ocodigo, d.SNcodigo, d.Mcodigo, d.Ccuenta, d.Rcodigo, d.Icodigo, d.Dtipocambio, d.Dtotal, d.Dsaldo, d.Dfecha, d.Dvencimiento, d.DfechaAplicacion, d.Dtcultrev, d.Dusuario, d.Dtref, d.Ddocref, d.Dmontoretori, d.Dretporigen, d.Dreferencia, d.DEidVendedor, d.DEidCobrador, d.id_direccionFact, d.id_direccionEnvio, d.CFid, d.DEdiasVencimiento, d.DEordenCompra, d.DEnumReclamo, d.DEobservacion, d.DEdiasMoratorio, d.BMUsucodigo, d.ts_rversion, d.FAM01COD, d.FAX01NTR, d.CDCcodigo 
					from HDocumentos d
					where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					  and d.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SNcodigo#">
					  <cfif isdefined("Arguments.id_direccion") and len(trim(Arguments.id_direccion))>
					  	and d.id_direccionFact = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_direccion#">
					  </cfif>
					  and d.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ccuentanue#">
					  and d.Dsaldo <> 0.00
				</cfquery>

			
				<cfquery name="rsDebugINTARC" datasource="#Arguments.Conexion#">
					select * from #INTARC#
				</cfquery>
				<cfdump var="#rsDebug#" label="Antes de GeneraAsiento">
			</cfif>
			<!--- 3.5 Genera Asiento --->
			<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="res_GeneraAsiento">
				<cfinvokeargument name="Ecodigo" value="#Arguments.Ecodigo#"/>
				<cfinvokeargument name="Oorigen" value="CCRC"/>
				<cfinvokeargument name="Eperiodo" value="#Periodo#"/>
				<cfinvokeargument name="Emes" value="#Mes#"/>
				<cfinvokeargument name="Efecha" value="#Fecha#"/>
				<cfinvokeargument name="Edescripcion" value="#Descripcion#"/>
				<cfinvokeargument name="Edocbase" value="#rsData.Ddocumento#"/>
				<cfinvokeargument name="Ereferencia" value="#rsData.CCTcodigo#"/>
				<cfinvokeargument name="Debug" value="#Arguments.Debug#"/>
			</cfinvoke>
		</cfif>
					  
			<cfif Arguments.Debug>
				<cftransaction action="rollback"/>
			</cfif>
		</cftransaction>
		
		<cfreturn "OK">

	</cffunction>
</cfcomponent>


