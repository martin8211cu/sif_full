
<!---------
	Modificado por: Ana Villavicencio
		Fecha de modificación: 12 de mayo del 2005
		Motivo: corrección en el proceso de calculo de impuesto y actualización del totales del encabezado del
			documento. Ademas de corrección en la estructura de la consulta para que no de problemas en Oracle.
	Modificado por Gustavo Fonseca H.
		Fecha de modificación: 16 de mayo del 2005
		Motivo: se agrega el campo Fecha de Arribo, para tomarlo en cuenta en el cálculo de los días de vencimiento.
	Modificado por: Ana Villavicencio
		Fecha de modificación: 20 junio del 2005
		Motivo: modificación en la forma de obtener la cuenta contable para las lineas de detalle del documento.
			Se esta utilizando el nuevo componente CG_Complementos, metodo TraeCuenta.
			Se agregó el campo Centro funcional dentro de las consultas q lo necesiten, Insert y update.		
	Modificado por Gustavo Fonseca H.
		Fecha de modificación: 23-6-2005
		Motivo: se agrega el campo Direccion de Factura (id_direccion).			
	Modificado por Gustavo Fonseca H.
		Fecha de modificación: 12-7-2005
		Motivo: Se modifican los tipos de datos de EDdocref, estaban de tipo numeric y se cambió a tipo char (como está en la base de datos).			
	- Modificado por Gustavo Fonseca H.
		Fecha: 4-8-2005
		Motivo: - Se modifica para arreglar la seguridad de CxP en los procesos de facturas y notas de crédito, para que seguridad sepa 
				con cual de los dos procesos está trabajando. Esto porque se estaba trabajando con un archivo para los dos procesos.
				- Se agrega el botón nuevo en el form para que no tenga que salir hasta la lista para hacer uno nuevo (CHAVA).
	Modificado por:Ana Villavicencio
		Fecha: 22 de agosto del 2005
		Motivo: Cambio del proceso de asignación de cuentas para los proveedores, se toma la cuenta asignada por el sistema dependiendo 
				del  CPTcodigo+ SNcodigo, SNcodigo, en caso q la asignacion sea automatica.
				Se quito la consulta sobre la tabla SNegocios para tomas la cuenta asignada a cada proveedor para CxP y se toma la cuenta 
				del form.
				Se quitaron validaciones de Aid y Cid, las cuales hacian la comparación de Aid = "null" y Cid = "null".
				Correccion en el envio de los datos para la asignación automatica de la cuenta contable para las lineas de detalle. 
				Para el caso de una linea de detalle de concepto, solamente enviaba el concepto y nola clasificación. Se hace la consulta 
				en Conceptos de la clasificacion  a la q pertenece y luego se envia enlos parametros del componente de cuentas.
	Modificador por: Ana Villavicencio
	Fecha: 29 de agosto del 2005
	Motivo: La generación automática de la cuenta para el detalle del documento lo estaba realizando de forma erronea, 
			esto porque no estaba realizando una validación correctamente. Cuando se selecciona un ACTIVO la cuenta q genera es la
			asignada en cuentas contables de operacion (parametro 240), para esta condición se debia validar q no se estaba seleccionando
			ni un concepto ni un artículo, pero se estaba condicionando a q podia seleccionar al menos uno. Se cambio a condición para que 
			fuera solamente en el caso de q se seleccionara un activo.
			
----------->

	<cfset Request.error.backs = 1 >

	<cfset existe = false>
	<cfset cambioEncab = false>
	
	<cfset params = '' >
	<cfif isdefined('form.fecha') and len(trim(form.fecha))>
		<cfset params = params & '&fecha=#form.fecha#' >
	</cfif>
	<cfif isdefined('form.transaccion') and len(trim(form.transaccion))>
		<cfset params = params & '&transaccion=#form.transaccion#' >
	</cfif>
	<cfif isdefined('form.documento') and len(trim(form.documento))>
		<cfset params = params & '&documento=#form.documento#' >
	</cfif>
	<cfif isdefined('form.usuario') and len(trim(form.usuario))>
		<cfset params = params & '&usuario=#form.usuario#' >
	</cfif>
	<cfif isdefined('form.moneda') and len(trim(form.moneda))>
		<cfset params = params & '&moneda=#form.moneda#' >
	</cfif>
	<cfif isdefined('form.pageNum_lista') and len(trim(form.pageNum_lista))>
		<cfset params = params & '&pageNum_lista=#form.pageNum_lista#' >
	</cfif>
	<cfif isdefined('form.registros') and len(trim(form.registros))>
		<cfset params = params & '&registros=#form.registros#' >
	</cfif>
	<cfif isdefined('form.tipo') and len(trim(form.tipo))>
		<cfset params = params & '&tipo=#form.tipo#' >
	</cfif>

 	<cfif not (isDefined("Form.EDfecha") and Trim(Form.EDfecha) EQ Trim(Form._EDfecha)
		and isDefined("Form.EDfechaarribo") and Trim(Form.EDfechaarribo) EQ Trim(Form._EDfechaarribo)
		and isDefined("Form.Mcodigo") and Trim(Form.Mcodigo) EQ Trim(Form._Mcodigo)
		and isDefined("Form.EDtipocambio") and Trim(Form.EDtipocambio) EQ Trim(Form._EDtipocambio)
		and isDefined("Form.Ocodigo") and Trim(Form.Ocodigo) EQ Trim(Form._Ocodigo)
		and isDefined("Form.Rcodigo") and Trim(Form.Rcodigo) EQ Trim(Form._Rcodigo)
		and isDefined("Form.EDdescuento") and Trim(Form.EDdescuento) EQ Trim(Form._EDdescuento)
		and isDefined("Form.Ccuenta") and Trim(Form.Ccuenta) EQ Trim(Form._Ccuenta)
		and isDefined("Form.EDimpuesto") and Trim(Form.EDimpuesto) EQ Trim(Form._EDimpuesto)		
		and isDefined("Form.EDtotal") and Trim(Form.EDtotal) EQ Trim(Form._EDtotal)
		and isDefined("Form.id_direccion") and Trim(Form.id_direccion) EQ Trim(Form._id_direccion)
		and isDefined("Form.EDdocref") and Trim(Form.EDdocref) EQ Trim(Form._EDdocref)
		and isDefined("Form.TESRPTCid") and Trim(Form.TESRPTCid) EQ Trim(Form._TESRPTCid))>
		<cfset cambioEncab = true>
	</cfif>
	
	<cfquery name="rsParam" datasource="#session.DSN#">
		select *
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and Pcodigo = 2
	</cfquery>

 	<cfif isdefined("Form.AgregarE") >
		<cfquery name="rsExisteEncab" datasource="#Session.DSN#">
			if exists (	select 1 from EDocumentosCxP 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  		  and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPTcodigo#">
				  		  and EDdocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EDdocumento#">
				  		  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#"> )				  
				select 1 as valor				
			else
				select 0 as valor
		</cfquery>
			
		<cfif rsExisteEncab.valor EQ 1> 
			<cfset existe = true> <script>alert("El documento ya existe");</script> 
		<cfelse>
			<cfquery name="rsExisteEncabEnBitacora" datasource="#Session.DSN#">
				if exists (	select 1 from BMovimientosCxP 
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						  	  and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPTcodigo#">	
						  	  and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EDdocumento#">
						  	  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#"> )
 					select 1 as valor				
				else
					select 0 as valor
			</cfquery>				

			<cfif rsExisteEncabEnBitacora.valor EQ 1> 
				<cfset existe = true> <script>alert("El documento ya existe en la bitácora");</script> 			
			</cfif>		
		</cfif>									
	</cfif>

		<cfif isDefined("Form.AgregarE")>
			<cftransaction>
 			<cfif not existe>
				<cfquery name="rsInsertEDocCP" datasource="#session.DSN#">
					insert into EDocumentosCxP (Ecodigo, CPTcodigo, EDdocumento, SNcodigo, Mcodigo, EDtipocambio,
												EDdescuento, EDporcdescuento, EDimpuesto, EDtotal, Ocodigo, Ccuenta, EDfecha, 
												Rcodigo, EDusuario, EDselect, EDdocref, EDfechaarribo, id_direccion, TESRPTCid, BMUsucodigo)
					values ( 	<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
							 	<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPTcodigo#">,
							 	<cfqueryparam cfsqltype="cf_sql_char" value="#Form.EDdocumento#">,
							 	<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">,
							 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
							 	<cfqueryparam cfsqltype="cf_sql_float" value="#Form.EDtipocambio#">,
							 	<cfqueryparam cfsqltype="cf_sql_money" value="#Form.EDdescuento#">,
							 	0.00,
							 	<cfqueryparam cfsqltype="cf_sql_money" value="#Form.EDimpuesto#">,
							 	<cfqueryparam cfsqltype="cf_sql_money" value="#Form.EDtotal#">,
							 	<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">, 
							 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccuenta#">,
							 	<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.EDfecha,'YYYY/MM/DD')#">,
							 	<cfif isDefined("Form.Rcodigo") and Trim(Form.Rcodigo) NEQ "-1">
							 		<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Rcodigo#">,
							 	<cfelse>
							 		null,
							 	</cfif>
							 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
								0,
								<cfif isDefined("Form.EDdocref") and Trim(Form.EDdocref) NEQ "">
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDdocref#">,
								<cfelse>
									null,
								</cfif>		
								<cfif isdefined("Form.EDfechaarribo") and len(trim(Form.EDfechaarribo))>
									<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.EDfechaarribo,'YYYY/MM/DD')#">,
								<cfelse>
									<!--- EDfecha es obigatorio --->
									<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.EDfecha,'YYYY/MM/DD')#">,  
								</cfif>
								<cfif isdefined("form.id_direccion") and len(trim(form.id_direccion))>
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">,
								<cfelse>
									null,
								</cfif>
								<cfif isdefined("form.TESRPTCid") and len(trim(form.TESRPTCid))>
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#">,
								<cfelse>
									null,
								</cfif>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> 
								)
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="rsInsertEDocCP">

				<cfset modo="CAMBIO">
				<cfset modoDet="ALTA">
		 	</cfif>
			</cftransaction>

		<cfelseif isdefined("Form.BorrarE")>
			<cfquery name="parametroRec" datasource="#session.DSN#">
				select coalesce(Pvalor, '1') as Pvalor
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Pcodigo=880
			</cfquery>

			<cftransaction>
				<!--- SOLO SI PARAMETRO ES NULO O 1--->
				<cfif parametroRec.Pvalor neq 0>
					<!--- Si usa documento recurrente, limpia su ultima fecha de uso --->
					<cfquery name="recurrente" datasource="#session.DSN#">
						select IDdocumentorec
						from EDocumentosCxP
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						  and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">			  
					</cfquery>
					<cfif len(trim(recurrente.IDdocumentorec))>
						<cfquery name="rsDeleteEDocCP" datasource="#session.DSN#">
							update HEDocumentosCP
							set HEDfechaultuso = null
							where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
							  and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#recurrente.IDdocumentorec#">			  
						</cfquery>
					</cfif>
				</cfif>

				<cfquery name="rsDeleteEDocCP" datasource="#session.DSN#">
					delete DDocumentosCxP 
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">			  
				</cfquery>
	
				<cfquery name="rsDeleteDDocCP" datasource="#session.DSN#">
					delete EDocumentosCxP 
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">		
				</cfquery>
			</cftransaction>
			
			<cfset modo="ALTA">
			<cfset modoDet="ALTA">
			  			  
		<cfelseif isdefined("Form.AgregarD")>											
 			<cfif cambioEncab> 				
				<cftransaction>
				<cfquery name="rsUpdateEDocCP" datasource="#session.DSN#">
					update EDocumentosCxP 
					set	Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
						EDtipocambio = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.EDtipocambio#">,
						EDdescuento = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.EDdescuento#">,					
						EDimpuesto = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.EDimpuesto#">,
						EDtotal = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.EDtotal#">,					
						Rcodigo = <cfif isDefined("Form.Rcodigo") and Trim(Form.Rcodigo) NEQ "-1"><cfqueryparam cfsqltype="cf_sql_char" value="#Form.Rcodigo#">,<cfelse>null,</cfif>
						Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
						Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">,
						EDusuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
						EDfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.EDfecha,'YYYY/MM/DD')#">,
						EDdocref = <cfif isDefined("Form.EDdocref") and Trim(Form.EDdocref) NEQ ""><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDdocref#">,<cfelse>null,</cfif>
						id_direccion = <cfif isdefined("form.id_direccion") and len(trim(form.id_direccion))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">,<cfelse>null,</cfif>
						<cfif isdefined("Form.EDfechaarribo") and len(trim(Form.EDfechaarribo))>
							EDfechaarribo = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.EDfechaarribo,'YYYY/MM/DD')#">,
						<cfelse>
							EDfechaarribo = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.EDfecha,'YYYY/MM/DD')#">,<!--- EDfecha es obigatorio --->
						</cfif>
						TESRPTCid =	
						<cfif isdefined("form.TESRPTCid") and len(trim(form.TESRPTCid))>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#">,
						<cfelse>
							null,
						</cfif>
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
					  and ts_rversion = convert(varbinary,#lcase(Form.timestampE)#)				  							  			
				 </cfquery>
				 </cftransaction>
			</cfif>

			<cfif isDefined("Form.Aid") and LEN(Trim(Form.Aid)) and form.DDtipo eq 'A'>
				<cfquery name="rsConsultaDepto" datasource="#session.DSN#">
					select Dcodigo
					from Almacen
					where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.almacen#">
				</cfquery>
			</cfif>
			
			<cfif isdefined('rsParam') and rsParam.RecordCount GT 0 and rsParam.Pvalor EQ 'N'>
				<!--- SE TIENE Q PONER EL TAG DE CUENTA--->
				<cfif isDefined("Form.Cid") and LEN(Trim(Form.Cid)) EQ 0 and isDefined("Form.Aid") and LEN(Trim(Form.Aid)) EQ 0>
					<cfquery name="rsCuentaActivo" datasource="#Session.DSN#">
						select convert(varchar,a.Pvalor) as Pvalor, b.Cformato, b.Cdescripcion 
						from Parametros a inner join CContables b
						  on a.Ecodigo = b.Ecodigo and
							 convert(varchar,a.Pvalor) = convert(varchar,b.Ccuenta)
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						  and a.Pcodigo = 240
					</cfquery>
					<cfset cuentaDetalle = rsCuentaActivo.Pvalor>
				<cfelse>
					<cfif isdefined('form.Cid') and LEN(TRIM(form.Cid))>
						<cfquery name="rsCCid" datasource="#session.DSN#">
							select CCid
							from Conceptos
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							  and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">
						</cfquery>
						<cfset Cconcepto = rsCCid.CCid>
					<cfelse>
						<cfset Cconcepto = "">
					</cfif>

					<cftransaction>
						<cfinvoke returnvariable="Cuentas"
						component="sif.Componentes.CG_Complementos" method="TraeCuenta" 
							Oorigen="CPFC"
							Ecodigo="#Session.Ecodigo#"
							Conexion="#Session.DSN#"
							Oficinas = "#form.Ocodigo#"
							SNegocios = "#form.SNcodigo#"
							CPTransacciones = "#form.CPTcodigo#"
							Articulos = "#Form.Aid#"
							Almacen = "#Form.Almacen#"
							Conceptos  = "#form.Cid#"
							CFuncional = "#Form.CFid#"
							Monedas="form.Mcodigo"
							Clasificaciones=""
							CConceptos="#Cconcepto#"/> 
						<cfset cuentaDetalle = Cuentas.Ccuenta>
					</cftransaction>
				</cfif>
			<cfelse>
				<cfset cuentaDetalle = form.CcuentaD>
			</cfif>

			<!--- <cf_dump var="#rsConsultaDepto#"> --->
			<cftransaction>
			<cfquery name="rsInsertDDocCP" datasource="#session.DSN#">
				insert into DDocumentosCxP 
					(	IDdocumento,
						Aid,
						Cid,
						DDdescripcion,
						DDdescalterna,
						CFid,
						Dcodigo,
						DDcantidad,
						DDpreciou, 
						DDdesclinea,
						DDporcdesclin, 
						DDtotallinea, 
						DDtipo, 
						Ccuenta, 
						Alm_Aid, 
						Ecodigo, 
						OCTtipo,
						OCTtransporte,
						OCTfechaPartida,
						OCTobservaciones,
						OCCid,
						OCid,						
						Icodigo,
						BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">,
					<cfif  isDefined("Form.DDtipo") and  Form.DDtipo eq 'O'>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AidOD#">
					<cfelse>
						<cfif isDefined("Form.Aid") and Len(Trim(Form.Aid)) GT 0 and LEN(Trim(Form.Aid)) NEQ 0> 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">
						<cfelse>	
							null
						</cfif>				
					</cfif>,
					<cfif isDefined("Form.Cid") and Len(Trim(Form.Cid)) GT 0 and LEN(Trim(Form.Cid)) NEQ 0> 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">,
					<cfelse>	
						null, 
					</cfif>				
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DDdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DDdescalterna#">,
					<cfif isDefined("Form.CFid") and Len(Trim(Form.CFid)) GT 0 > 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">,
					<cfelse>	
						null,
					</cfif>				
					<cfif isDefined("Form.DDtipo") and Form.DDtipo eq 'A' and isdefined("rsConsultaDepto")> <!--- Articulo--->
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsConsultaDepto.Dcodigo#">,
					<cfelse>
						null,
					</cfif>
					
					<cfqueryparam cfsqltype="cf_sql_float" value="#Form.DDcantidad#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DDpreciou#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DDdesclinea#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#Form.DDporcdesclin#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DDtotallinea#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.DDtipo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#cuentaDetalle#">,
					<cfif isDefined("Form.Almacen") and Len(Trim(Form.Almacen)) GT 0 > 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Almacen#">,
					<cfelse>	
						null, 
					</cfif>				
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTtipo#">
					<cfelse>null</cfif>,
					<cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTtransporte#">
					<cfelse>null</cfif>,
					<cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.OCTfechaPartida,'YYYY/MM/DD')#">
					<cfelse>null</cfif>,
					<cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTobservaciones#">
					<cfelse>null</cfif>,
					<cfif  isDefined("Form.DDtipo") and  Form.DDtipo eq 'O'>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCCid#">
					<cfelse>null</cfif>,
					<cfif  isDefined("Form.DDtipo") and  Form.DDtipo eq 'O'>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCid#">
					<cfelse>null</cfif>,
					<cfif isDefined("Form.Icodigo") and Len(Trim(Form.Icodigo)) GT 0 > 
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Icodigo#">,
					<cfelse>	
						null,
					</cfif>	
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				) 
			</cfquery>
			
			</cftransaction>
			
			
			<cfset modo="CAMBIO">
			<cfset modoDet="ALTA">				

		<cfelseif isdefined("Form.BorrarD")>		
			<cfquery name="rsConsulta" datasource="#session.DSN#">
				select Icodigo, DDtotallinea, DDdesclinea
				from DDocumentosCxP
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#"> 
				  and Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Linea#">
			</cfquery>

			<cftransaction>
				<cfquery name="rsDeleteDDocCxP" datasource="#session.DSN#">
					delete DDocumentosCxP 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#"> 
					  and Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Linea#">
				</cfquery>			
	
			</cftransaction>
			
			<cfset modo="CAMBIO">
			<cfset modoDet="ALTA">								  

		<cfelseif isdefined("Form.CambiarD")>		
			<cftransaction>
				<cfif cambioEncab>
					<cfquery name="rsUpdateEDocCxP" datasource="#session.DSN#">
						update EDocumentosCxP set
							Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
							EDtipocambio = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.EDtipocambio#">,
							EDdescuento = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.EDdescuento#">,					
							EDimpuesto = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.EDimpuesto#">,
							EDtotal = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.EDtotal#">,									
							Rcodigo = 
								<cfif isDefined("Form.Rcodigo") and Trim(Form.Rcodigo) NEQ "-1">
									<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Rcodigo#">,
								<cfelse>
									null,
								</cfif>                    					                    
							Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
							Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">,
							EDusuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
							EDfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.EDfecha,'YYYY/MM/DD')#">,
							EDdocref = 
								<cfif isDefined("Form.EDdocref") and Trim(Form.EDdocref) NEQ "">
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDdocref#">,
								<cfelse>
									null,
								</cfif>				
							id_direccion =
								<cfif isdefined("form.id_direccion") and len(trim(form.id_direccion))>
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">,
								<cfelse>
									null,
								</cfif>
							<cfif isdefined("Form.EDfechaarribo") and len(trim(Form.EDfechaarribo))>
								EDfechaarribo = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.EDfechaarribo,'YYYY/MM/DD')#">,
							<cfelse>
								EDfechaarribo = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.EDfecha,'YYYY/MM/DD')#">,<!--- EDfecha es obigatorio --->
							</cfif>
							TESRPTCid =
							<cfif isdefined("form.TESRPTCid") and len(trim(form.TESRPTCid))>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#">,
							<cfelse>
								null,
							</cfif>
							BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
						  and ts_rversion = convert(varbinary,#lcase(Form.timestampE)#)							  				
					 </cfquery>
				</cfif>
				<cfif isDefined("Form.Aid") and LEN(Trim(Form.Aid)) and Form.DDtipo eq 'A'>
					<cfquery name="rsConsultaDepto" datasource="#session.DSN#">
						select Dcodigo 
						from Almacen
						where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.almacen#">
					</cfquery>
				</cfif>
	
				<cfif isdefined('rsParam') and rsParam.RecordCount GT 0 and rsParam.Pvalor EQ 'N'>
					<!--- SE TIENE Q PONER EL TAG DE CUENTA --->
					<cfif isDefined("Form.Cid") and LEN(Trim(Form.Cid)) EQ 0 and isDefined("Form.Aid") and LEN(Trim(Form.Aid)) EQ 0 >
						<cfquery name="rsCuentaActivo" datasource="#Session.DSN#">
							select convert(varchar,a.Pvalor) as Pvalor, b.Cformato, b.Cdescripcion 
							from Parametros a inner join CContables b
							  on a.Ecodigo = b.Ecodigo and
								 convert(varchar,a.Pvalor) = convert(varchar,b.Ccuenta)
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							  and a.Pcodigo = 240
						</cfquery>
						<cfset cuentaDetalle = rsCuentaActivo.Pvalor>
					<cfelse>
						<cfquery name="rsCCid" datasource="#session.DSN#">
							select CCid
							from Conceptos
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							  and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">
						</cfquery>
						<cfinvoke returnvariable="Cuentas"
						component="sif.Componentes.CG_Complementos" method="TraeCuenta" 
							Oorigen="CPFC"
							Ecodigo="#Session.Ecodigo#"
							Conexion="#Session.DSN#"
							Oficinas = "#form.Ocodigo#"
							SNegocios = "#form.SNcodigo#"
							CPTransacciones = "#form.CPTcodigo#"
							Articulos = "#Form.Aid#"
							Almacen = "#Form.Almacen#"
							Conceptos  = "#form.Cid#"
							CFuncional = "#Form.CFid#"
							Monedas="form.Mcodigo"
							Clasificaciones=""
							CConceptos="#rsCCid.CCid#"/> 
							<cfset cuentaDetalle = Cuentas.Ccuenta>
						</cfif>
				<cfelse>
					<cfset cuentaDetalle = form.CcuentaD>
				</cfif>
	
				<cfquery name="rsUpdateDDocCxP" datasource="#session.DSN#">
					update DDocumentosCxP set 
						DDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DDdescripcion#">
						<cfif  isDefined("Form.DDtipo") and  Form.DDtipo eq 'O'>
							, Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AidOD#">
						<cfelse>
							<cfif isDefined("Form.Aid") and Len(Trim(Form.Aid)) GT 0 and LEN(Trim(Form.Aid)) NEQ 0> 
								, Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">
							<cfelse>	
								, Aid =null
							</cfif>				
						</cfif>						
						<cfif isDefined("Form.Cid") and Len(Trim(Form.Cid)) GT 0>	
							, Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">
						</cfif>								
						, DDdescalterna = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DDdescalterna#">
						, DDcantidad = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.DDcantidad#">
						, DDpreciou = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DDpreciou#">
						, DDdesclinea = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DDdesclinea#">
						, DDporcdesclin = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.DDporcdesclin#">
						<cfif isDefined("Form.CFid") and LEN(Trim(Form.CFid)) NEQ 0>
							, CFid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
						<cfelse>
							, CFid = null
						</cfif>
						<cfif isDefined("Form.DDtipo") and Form.DDtipo eq 'A' and isdefined("rsConsultaDepto")>
						    , Dcodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#rsConsultaDepto.Dcodigo#">
						<cfelse>
							, Dcodigo = null
						</cfif>
						, DDtotallinea = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DDtotallinea#">
						, DDtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.DDtipo#">
						<cfif isDefined("Form.Almacen") and LEN(Trim(Form.Almacen)) NEQ 0>
							, Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Almacen#">
						<cfelse>
							, Alm_Aid = null
						</cfif>                    					                    								
						, Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						, Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuentaDetalle#">
						<cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
							,OCTtipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTtipo#">
						<cfelse>
							,OCTtipo =  null
						</cfif>
						<cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
							,OCTtransporte = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTtransporte#">
						<cfelse>
							,OCTtransporte = null
						</cfif>
						<cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
							,OCTfechaPartida = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.OCTfechaPartida,'YYYY/MM/DD')#">
						<cfelse>
							,OCTfechaPartida = null
						</cfif>
						<cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
							,OCTobservaciones =<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTobservaciones#">
						<cfelse>
							,OCTobservaciones = null
						</cfif>
						<cfif  isDefined("Form.DDtipo") and  Form.DDtipo eq 'O'>
							,OCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCCid#">
						<cfelse>
							,OCCid =  null
						</cfif>
						<cfif  isDefined("Form.DDtipo") and  Form.DDtipo eq 'O'>
							,OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCid#">
						<cfelse>
							,OCid = null
						</cfif>
						<cfif isDefined("Form.Icodigo") and Len(Trim(Form.Icodigo)) GT 0 > 
							, Icodigo =	<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Icodigo#">
						<cfelse>	
							, Icodigo =	 null
						</cfif>	
						, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Linea#">
					  and ts_rversion = convert(varbinary,#lcase(Form.timestampD)#)
				</cfquery>		
			</cftransaction>
						
 			<cfset modo="CAMBIO">
			<cfset modoDet="ALTA">	

		<cfelseif isdefined("Form.btnNuevo")>
			<cfif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo EQ 'D'>
				<cflocation addtoken="no" url="RegistroNotasCreditoCP.cfm?LvarIDdocumento=true#params#">		
			<cfelseif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo EQ 'C'>
				<cflocation addtoken="no" url="RegistroFacturasCP.cfm?LvarIDdocumento=true#params#">
			</cfif>						
		<cfelseif isdefined("form.NuevoD")>
			<cfset modo="CAMBIO">
			<cfset modoDet="ALTA">
		</cfif>
		<cfif isdefined('form.AgregarD') or isdefined('form.BorrarD') or isdefined('form.CambiarD')>
			<!--- PROCESO DE ACTUALIZACION DEL TOTAL DEL DOCUMENTO Y TOTAL DE IMPUESTOS --->
			
			<!--- CALCULO DE IMPUESTO PARA LAS LINEAS DE DOCUMENTO QUE TIENEN IMPUESTO DE CREDITO FISCAL --->
			<cf_dbtemp name="TT_Impuestos" returnvariable="TT_Impuestos" datasource="#session.dsn#">
			  <cf_dbtempcol name="Icodigo" type="char(5)"> 
			  <cf_dbtempcol name="DDtotallinea" type="money">
			  <cf_dbtempcol name="Porcentaje" type="float"> 
			   <cf_dbtempcol name="Linea" type="numeric"> 
			   <cf_dbtempcol name="totallinea" type="money"> 
			</cf_dbtemp>
	
			<cfquery name="rsImpuestos" datasource="#session.DSN#">
				insert into #TT_Impuestos#(Icodigo, DDtotallinea,Porcentaje,Linea,totallinea)
				select d.DIcodigo, b.DDtotallinea, d.DIporcentaje,b.Linea,b.DDtotallinea*d.DIporcentaje/100.00
				from EDocumentosCxP a 
					inner join DDocumentosCxP b
						  on b.IDdocumento    = a.IDdocumento
						 and b.Ecodigo = a.Ecodigo
					inner join Impuestos c
						  on c.Ecodigo = b.Ecodigo
						 and c.Icodigo = b.Icodigo 
					inner join DImpuestos d
						on d.Ecodigo = c.Ecodigo 
					   and d.Icodigo = c.Icodigo
				where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
				  and c.Icompuesto = 1
				  and c.Icreditofiscal = 1 
			</cfquery>
			
			<cfquery name="rsTotalImpuesto" datasource="#session.DSN#">
				insert into #TT_Impuestos#(Icodigo, DDtotallinea,Porcentaje,Linea,totallinea)
				select c.Icodigo, b.DDtotallinea, c.Iporcentaje, Linea, b.DDtotallinea*c.Iporcentaje/100.00
				from EDocumentosCxP a 
					inner join DDocumentosCxP b
						  on b.Ecodigo = a.Ecodigo
						 and b.IDdocumento    = a.IDdocumento 
					inner join Impuestos c
						  on c.Ecodigo = b.Ecodigo
						 and c.Icodigo = b.Icodigo
				where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
				  and c.Icompuesto = 0
				  and c.Icreditofiscal = 1
			</cfquery>
			<cfquery name="rsConsulta" datasource="#session.DSN#">
				select *
				from #TT_Impuestos#
			</cfquery>

			<cfquery name="rsTotalImpuestos" datasource="#session.DSN#">
				select round(sum(DDtotallinea) * Porcentaje / 100.00,2) as TotalImpuestos
				from #TT_Impuestos#
				group by Icodigo,Porcentaje
			</cfquery>
			<cfquery name="rsTotalI" dbtype="query">
				select sum(TotalImpuestos) as TotalImpuestos
				from rsTotalImpuestos
			</cfquery>
			<cfif rsTotalI.RecordCount GT 0>
				<cfset LvarTotalImpuestos = rsTotalI.TotalImpuestos>
			<cfelse>
				<cfset LvarTotalImpuestos = 0>
			</cfif>

			<cfquery name="rsTotalCF" datasource="#session.DSN#">
				select coalesce(sum(a.DDtotallinea),0.00) as Total
				from DDocumentosCxP a 
					inner join EDocumentosCxP b
					   on b.IDdocumento    = a.IDdocumento
					  and b.Ecodigo = a.Ecodigo
					inner join Impuestos c
					   on c.Ecodigo = a.Ecodigo
					  and c.Icodigo = a.Icodigo
				where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
				  and c.Icreditofiscal = 1
			</cfquery>
			<!--- CALCULO DEL TOTAL DE LAS LINEAS QUE TIENEN IMPUESTO QUE NO ES DE CREDITO FISCAL --->
			<cfquery name="rsTotal" datasource="#session.DSN#">
				select coalesce(sum(a.DDtotallinea + round((a.DDtotallinea*c.Iporcentaje/100),2)),0.00) as Total
				from DDocumentosCxP a 
					inner join EDocumentosCxP b
					   on b.IDdocumento    = a.IDdocumento
					  and b.Ecodigo = a.Ecodigo
					inner join Impuestos c
					   on c.Ecodigo = a.Ecodigo
					  and c.Icodigo = a.Icodigo
				where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
				  and c.Icreditofiscal = 0
			</cfquery>
			<!--- CALCULO DEL IMPUESTO PARA LAS LINEAS DEL DOCUMENTO QUE TIENEN IMPUESTO QUE NO ES DE CREDITO FISCAL --->
			<cfquery name="rsTotalISCF" datasource="#session.DSN#">
				select coalesce(round(sum(a.DDtotallinea*c.Iporcentaje/100),2),0.00) as TotalISCF
				from DDocumentosCxP a 
					inner join EDocumentosCxP b
					   on b.IDdocumento    = a.IDdocumento
					  and b.Ecodigo = a.Ecodigo
					inner join Impuestos c
					   on c.Ecodigo = a.Ecodigo
					  and c.Icodigo = a.Icodigo
				where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
				  and c.Icreditofiscal = 0
			</cfquery>

			<!---ACTUALIZA EL ENCABEZADO DEL DOCUMENTO CON LOS TOTALES --->
			<cfquery name="rsUpdateE" datasource="#session.DSN#">
				update EDocumentosCxP
				set 
					 EDimpuesto = coalesce(#LvarTotalImpuestos#, 0.00) + coalesce(#rsTotalISCF.TotalISCF#, 0.00) 
					,EDtotal    = coalesce(#rsTotal.Total#, 0.00) + coalesce(#rsTotalCF.Total#, 0.00)
								+ coalesce(#LvarTotalImpuestos#, 0.00)
								- coalesce(EDdescuento, 0.00)
			   where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
				 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			
		</cfif>
<cfif isdefined("form.IDdocumento") and len(trim(form.IDdocumento)) and not isdefined("Form.BorrarE")>
	<cfquery name="RScuenta" datasource="#session.DSN#">
		select * 
		from EDocumentosCxP 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocumento#">
	</cfquery>
	<cfif rscuenta.recordcount EQ 1>
		<cfquery name="rsSocioN_SQL" datasource="#session.DSN#">
			select SNidentificacion, SNcodigo, SNnumero, SNid, id_direccion
			from SNegocios
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#RScuenta.SNcodigo#">
		</cfquery>
	</cfif>
</cfif>

<form action="<cfif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo EQ 'D'>RegistroNotasCreditoCP.cfm<cfelseif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo EQ 'C'>RegistroFacturasCP.cfm</cfif>" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="modoDet" type="hidden" value="<cfif isdefined("modoDet")><cfoutput>#modoDet#</cfoutput></cfif>">	
	<input name="tipo" type="hidden" value="<cfoutput>#form.tipo#</cfoutput>">
	
	<cfif isdefined("rsInsertEDocCP.identity")>
	   	<input name="IDdocumento" type="hidden" value="<cfif isdefined("rsInsertEDocCP.identity")><cfoutput>#rsInsertEDocCP.identity#</cfoutput></cfif>">
	<cfelse>
	   	<input name="IDdocumento" type="hidden" value="<cfif isdefined("Form.IDdocumento") and not isDefined("Form.BorrarE")><cfoutput>#Form.IDdocumento#</cfoutput></cfif>">		
	</cfif>
	
	<cfif isdefined("Form.Linea")>
   		<input name="Linea" type="hidden" value="<cfif isdefined("Form.Linea")><cfoutput>#Form.Linea#</cfoutput></cfif>">    	
	</cfif>

	<cfif isdefined("Form.SNnumero") and len(trim(form.SNnumero)) and not isdefined("Form.BorrarE")>
   		<input name="SNnumero" type="hidden" value="<cfif isdefined("Form.SNnumero") and len(trim(form.SNnumero))><cfoutput>#Form.SNnumero#</cfoutput></cfif>">    	
	<cfelse>
		<input name="SNnumero" type="hidden" value="<cfif isdefined("rsSocioN_SQL") and rsSocioN_SQL.recordcount EQ 1><cfoutput>#rsSocioN_SQL.SNnumero#</cfoutput></cfif>">    		
	</cfif>

	<cfif isdefined("Form.id_direccion") and len(trim(form.id_direccion)) and not isdefined("Form.BorrarE")>
   		<input name="id_direccion" type="hidden" value="<cfif isdefined("Form.id_direccion") and len(trim(form.id_direccion))><cfoutput>#Form.id_direccion#</cfoutput></cfif>">    	
	<cfelse>
   		<input name="id_direccion" type="hidden" value="<cfif isdefined("rsSocioN_SQL") and rsSocioN_SQL.recordcount EQ 1><cfoutput>#rsSocioN_SQL.id_direccion#</cfoutput></cfif>">    	
	</cfif>

	
	<cfif isdefined("Form.SNidentificacion") and len(trim(form.SNidentificacion)) and not isdefined("Form.BorrarE")>
   		<input name="SNidentificacion" type="hidden" value="<cfif isdefined("Form.SNidentificacion") and len(trim(form.SNidentificacion))><cfoutput>#Form.SNidentificacion#</cfoutput></cfif>">    	
	<cfelse>
   		<input name="SNidentificacion" type="hidden" value="<cfif isdefined("rsSocioN_SQL") and rsSocioN_SQL.recordcount EQ 1><cfoutput>#rsSocioN_SQL.SNidentificacion#</cfoutput></cfif>">    	
	</cfif>
	
	<cfif isdefined("Form.btnAplicar")>
   		<input name="btnAplicar" type="hidden" value="<cfif isdefined("Form.btnAplicar")><cfoutput>#Form.btnAplicar#</cfoutput></cfif>">    	
	</cfif>

	<!--- ======================================================================= --->
	<!--- NAVEGACION --->
	<!--- ======================================================================= --->
	<cfoutput>
	<input type="hidden" name="fecha" value="<cfif isdefined('form.fecha') and len(trim(form.fecha)) >#form.fecha#</cfif>" />
	<input type="hidden" name="transaccion" value="<cfif isdefined('form.transaccion') and len(trim(form.transaccion))>#form.transaccion#</cfif>" />
	<input type="hidden" name="documento" value="<cfif isdefined('form.documento') and len(trim(form.documento))>#form.documento#</cfif>" />
	<input type="hidden" name="usuario" value="<cfif isdefined('form.usuario') and len(trim(form.usuario))>#form.usuario#</cfif>" />
	<input type="hidden" name="moneda" value="<cfif isdefined('form.moneda') and len(trim(form.moneda))>#form.moneda#</cfif>" />
	<input type="hidden" name="pageNum_lista" value="<cfif isdefined('form.pageNum_lista') >#form.pageNum_lista#</cfif>" />
	<input type="hidden" name="registros" value="<cfif isdefined('form.registros')>#form.registros#</cfif>" />
	</cfoutput>
	<!--- ======================================================================= --->
	<!--- ======================================================================= --->
	
</form>

<HTML><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>

