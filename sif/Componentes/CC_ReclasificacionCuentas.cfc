<cfcomponent>
	<!--- Reclasificación de Cuentas --->
	<cffunction name="reclasificacionCuentas" access="public" output="true" returntype="numeric">
		<cfargument name="Ecodigo" 		type="numeric" required="yes">  <!--- Codigo de la Empresa --->
		<cfargument name="SNcodigo" 	type="numeric" required="yes">  <!--- Codigo del Socio de Negocios --->
		<cfargument name="id_direccion"	type="string"  required="no" default="">  <!--- Codigo del Socio de Negocios --->		
		<cfargument name="usuario" 		type="string"  required="no">	<!--- Usuario --->
		<cfargument name="conexion" 	type="string"  required="false" default="#Session.DSN#"> <!--- Conexion de la base de datos --->
		<cfargument name="debug" 		type="string"  required="false"  default="N">	<!--- Debug --->
		
		<cfif len(trim(arguments.SNcodigo)) eq 0>
			<cf_errorCode	code = "51011" msg = "Debe especificar el Socio de Negocios para la reclasificación.">
		</cfif>
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
				select 'Reclasificación CxC Socio: ' #_Cat# SNnombre as descripcion
				from SNegocios
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SNcodigo#">
			 </cfquery>
			 <cfif isdefined("rsDescripcion") and rsDescripcion.recordcount EQ 1>
				<cfset Descripcion = rsDescripcion.descripcion>
			 </cfif>
			 
			 <cfquery name="rsPeriodo" datasource="#Arguments.conexion#">
				select Pvalor as Periodo
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and Mcodigo = 'GN'
				  and Pcodigo = 50
			 </cfquery>
			 <cfif isdefined("rsPeriodo") and rsPeriodo.recordcount EQ 1>
				<cfset Periodo = rsPeriodo.Periodo>
			 </cfif>
			 <cfquery name="rsMes" datasource="#Arguments.conexion#">
				select Pvalor as Mes
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and Mcodigo = 'GN'
				  and Pcodigo = 60
			 </cfquery>
			 <cfif isdefined("rsMes") and rsMes.recordcount EQ 1>
				<cfset Mes = rsMes.Mes>
			 </cfif>
			  
			<!--- 1. Validaciones Generales --->
			<cfif Mes eq '' or Periodo eq ''>
				<cf_errorCode	code = "50983" msg = "No se ha definido el parámetro de Período o Mes para los sistemas Auxiliares! Proceso Cancelado!">
			</cfif>
			
			<cfquery name="rsData" datasource="#Arguments.conexion#">
				select a.IDbitacora,
					   a.Cuenta_Anterior as CcuentaAnt,
					   a.Cuenta_Nueva as CcuentaNueva,	
					   d.CCTcodigo, 
					   d.Ddocumento, 
					   d.Ocodigo, 
					   d.SNcodigo, 
					   d.Ecodigo, 
					   d.Ccuenta, 
					   d.Dtotal, 
					   d.Dsaldo, 
					   d.Mcodigo, 
					   d.Dtcultrev, 
					   d.id_direccionFact
				
				from RCBitacora a
				
				inner join Documentos d
				on d.Ecodigo=a.Ecodigo
				and d.CCTcodigo=a.CCTcodigo
				and d.Ddocumento=a.Ddocumento
				
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
				and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SNcodigo#">
				and a.RCBestado = 0
			</cfquery>

			<!--- Asiento. Para trasladar la cuenta--->
			<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" returnvariable="INTARC"/>

			<cfloop query="rsData">
				<!--- 1. Seleccionar los documentos (Facturas y Notas) de la tabla Documentos ---> 
				<!--- 1.a.1. Modificar la cuenta contable anterior del Documento x Cobrar  --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
					select 
						  'CCRC',
						  1,
						  a.Ddocumento,
						  a.CCTcodigo, 
						  case when #Monloc# != #rsData.Mcodigo# then round(#rsData.Dsaldo# * #rsData.Dtcultrev#,2) else #rsData.Dsaldo# end,
						  case when b.CCTtipo = 'D' then 'C' else 'D' end, 
						  'Reclasificación Documento ' #_Cat# <cfqueryparam cfsqltype="cf_sql_char" value="#rsData.CCTcodigo#"> #_Cat# ' - ' #_Cat# <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsData.Ddocumento#"> #_Cat# ' ' #_Cat# c.SNnombre #_Cat# ' C. Anterior' as descripcion,
						  <cf_dbfunction name="to_sdate" args="getdate()">,
						  #rsData.Dtcultrev#,
						  <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
						  <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
						  a.Ccuenta,
						  a.Mcodigo,
						  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsData.Ocodigo#">,
						  round(#rsData.Dsaldo#, 2),a.CFid
					from Documentos a, CCTransacciones b, SNegocios c
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsData.CCTcodigo#">
					  and a.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsData.Ddocumento#">
					  and b.CCTcodigo = a.CCTcodigo
					  and b.Ecodigo = a.Ecodigo
					  and c.Ecodigo = a.Ecodigo
					  and c.SNcodigo = a.SNcodigo
				</cfquery>
					
				<!--- 1.a.2. Modificar la cuenta contable nueva del Documento x Cobrar  --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,CFid)
					select 
						  'CCRC',
						  1,
						  a.Ddocumento,
						  a.CCTcodigo, 
						  case when #Monloc#!= #rsData.Mcodigo# then round(#rsData.Dsaldo# * #rsData.Dtcultrev#,2) else #rsData.Dsaldo# end,
						  case when b.CCTtipo = 'D' then 'D' else 'C' end, 
						  'Reclasificación Documento ' #_Cat# <cfqueryparam cfsqltype="cf_sql_char" value="#rsData.CCTcodigo#"> #_Cat# ' - ' #_Cat# <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsData.Ddocumento#"> #_Cat# ' ' #_Cat# c.SNnombre #_Cat# ' C. Nueva',
						  <cf_dbfunction name="to_sdate" args="getdate()">,
						  #rsData.Dtcultrev#,
						  <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
						  <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
						  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsData.CcuentaNueva#">,
						  a.Mcodigo,
						   <cfqueryparam cfsqltype="cf_sql_integer" value="#rsData.Ocodigo#">,
						  round(#rsData.Dsaldo#, 2),a.CFid
					from Documentos a, CCTransacciones b, SNegocios c
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsData.CCTcodigo#">
					  and a.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsData.Ddocumento#">
					  and b.CCTcodigo = a.CCTcodigo
					  and b.Ecodigo = a.Ecodigo
					  and c.Ecodigo = a.Ecodigo
					  and c.SNcodigo = a.SNcodigo
				</cfquery>
			  
				<!--- 2  Modificar la cuenta asignada al documento --->
				<!--- Se tiene que actualizar uno a uno por que si no escojen el CCTtipo y actualiza todos los tipos por ejemplo. --->
				<cfquery datasource="#Arguments.conexion#">
					update HDocumentos
					set Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsData.CcuentaNueva#">
					where Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsData.Ddocumento#">
					  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsData.CCTcodigo#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsData.SNcodigo#">
					  and Dsaldo <> 0.00
					  <cfif isdefined("rsData.CcuentaAnt") and len(trim(rsData.CcuentaAnt))>
					  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsData.CcuentaAnt#">
					  </cfif>
	
					  <!--- ver de donde saco esto --->
					  <cfif isdefined("Arguments.id_direccion") and len(trim(Arguments.id_direccion))>
						  and id_direccionFact = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_direccion#">
					  </cfif>
				</cfquery> 

				<cfquery datasource="#Arguments.conexion#">
					update Documentos
					set Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsData.CcuentaNueva#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsData.CCTcodigo#">
					  and Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsData.Ddocumento#">
					  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsData.SNcodigo#">
					  and Dsaldo <> 0.00
					  <cfif isdefined("Arguments.Ccuentaant") and len(trim(Arguments.Ccuentaant))>
						  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsData.CcuentaAnt#">
					  </cfif>
	
						<!--- ver de donde saco esto --->
					  <cfif isdefined("Arguments.id_direccion") and len(trim(Arguments.id_direccion))>
						  and id_direccionFact = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_direccion#">
					  </cfif>
				  </cfquery>
				  
				<!--- GRABAR EN LA BITACORA DE RECLASIFICACIONES.  NUEVA TABLA. --->
				<cfquery datasource="#Arguments.Conexion#">
					update RCBitacora
					set RCBestado = 10
					where IDbitacora = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsData.IDbitacora#">
				</cfquery>
			</cfloop>
			
			<!--- Actualiza Cuenta de CC, con al cuenta nueva,  para el socio de negocios --->
			<!--- ACTUALIZA LA CUENTA SOLO SI EL QUERY PRINCIPAL ENCONTRO DATOS PARA LA RECLASIFICACION --->
			<!--- CUAL CUENTA ACTUALIZAR!!!
			<cfif len(trim(arguments.SNcodigo))>
				<cfquery datasource="#session.DSN#">
					update SNegocios
					set SNcuentacxc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ccuentanue#">
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SNcodigo#">
				</cfquery>
			</cfif>
			--->
			
			<!--- 3 Genera Asiento --->
			<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="res_GeneraAsiento">
				<cfinvokeargument name="Ecodigo" value="#Arguments.Ecodigo#"/>
				<cfinvokeargument name="Oorigen" value="CCRC"/>
				<cfinvokeargument name="Eperiodo" value="#Periodo#"/>
				<cfinvokeargument name="Emes" value="#Mes#"/>
				<cfinvokeargument name="Efecha" value="#Fecha#"/>
				<cfinvokeargument name="Edescripcion" value="#Descripcion#"/>

				<cfinvokeargument name="Edocbase" value="#rsData.Ddocumento#"/> ***
				<cfinvokeargument name="Ereferencia" value="#rsData.CCTcodigo#"/> ***

				<cfinvokeargument name="Debug" value="#Arguments.Debug#"/>
			</cfinvoke>
	
			<cfif not isdefined("res_GeneraAsiento") or res_GeneraAsiento LT 1 or res_GeneraAsiento EQ ''>
				<cftransaction action="rollback"/>
				<cfif res_GeneraAsiento eq 0>
					<cf_errorCode	code = "51012" msg = "Error en la Generación del Asiento">
				<cfelse>
					<cf_errorCode	code = "51012" msg = "Error en la Generación del Asiento">
				</cfif>
				<cf_abort errorInterfaz="">
			</cfif> 
					  
			<cfif Arguments.Debug>
				<cftransaction action="rollback"/>
			</cfif>
		</cftransaction>
		 <cfreturn "1">

	</cffunction>
</cfcomponent>


