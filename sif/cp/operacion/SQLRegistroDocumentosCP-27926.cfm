<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
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

	<cfif isdefined('url.pintar')>
		<cfinvoke component="sif.Componentes.CP_PosteoDocumentosCxP"
				  method="PosteoDocumento"
					IDdoc	= "#url.IDdocumento#"
					Ecodigo = "#Session.Ecodigo#"
					usuario = "#Session.usuario#"
					PintaAsiento = "true"
		/>
        <cfset form.tipo = url.tipo>
        <cfabort>
	</cfif>

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
		where Ecodigo =  #Session.Ecodigo# 
		  and Pcodigo = 2
	</cfquery>

 	<cfif isdefined("Form.AgregarE") >
		<cfquery name="rsExisteEncab" datasource="#Session.DSN#">
			select count(1) as valor
              from EDocumentosCxP 
             where Ecodigo =  #Session.Ecodigo# 
               and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPTcodigo#">
               and EDdocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EDdocumento#">
               and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">				  
		</cfquery>
			
		<cfif rsExisteEncab.valor NEQ 0> 
			<cfset existe = true> <script>alert("El documento ya existe");</script> 
		<cfelse>
			<cfquery name="rsExisteEncabEnBitacora" datasource="#Session.DSN#">
				select count(1) as valor
                  from BMovimientosCxP 
                 where Ecodigo =  #Session.Ecodigo# 
                   and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPTcodigo#">	
                   and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EDdocumento#">
                   and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#"> 
			</cfquery>				

			<cfif rsExisteEncabEnBitacora.valor NEQ 0> 
				<cfset existe = true> <script>alert("El documento ya existe en la bitácora");</script> 			
			</cfif>		
		</cfif>									
		<cftransaction>
 			<cfif not existe>
				<cfquery name="TransaccionCP" datasource="#Session.DSN#">
					select CPTtipo 
					  from CPTransacciones 
						where Ecodigo =  #Session.Ecodigo# 
						  and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPTcodigo#">
				</cfquery>
				<cfquery name="rsInsertEDocCP" datasource="#session.DSN#">
					insert into EDocumentosCxP (Ecodigo, CPTcodigo, EDdocumento, SNcodigo, Mcodigo, EDtipocambio,
												EDdescuento, EDporcdescuento, EDimpuesto, EDtotal, Ocodigo, Ccuenta, EDfecha, 
												Rcodigo, EDusuario, EDselect, EDdocref, EDfechaarribo, id_direccion, TESRPTCid, BMUsucodigo,TESRPTCietu)
					values ( 	 #Session.Ecodigo# ,
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
								<cfif TransaccionCP.CPTtipo EQ 'C'>		<!--- 1=Documento Normal CR, 0=Documento Contrario DB --->
									,1
								<cfelse>
									,0
								</cfif>
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
				where Ecodigo =  #Session.Ecodigo# 
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
					delete from DDocumentosCxP 
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">			  
				</cfquery>
	
				<cfquery name="rsDeleteDDocCP" datasource="#session.DSN#">
					delete from EDocumentosCxP 
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">		
				</cfquery>
			</cftransaction>
			
			<cfset modo="ALTA">
			<cfset modoDet="ALTA">
			  			  
		<cfelseif isdefined("Form.AgregarD")>											
 			<cfif cambioEncab> 	
				<cf_dbtimestamp
				datasource="#session.dsn#"
				table="EDocumentosCxP" 
				redirect="RegistroFacturasCP.cfm"
				timestamp="#Form.timestampE#"
				field1="IDdocumento,numeric,#Form.IDdocumento#">
						
				<cftransaction>
				<cfquery name="rsUpdateEDocCP" datasource="#session.DSN#">
					update EDocumentosCxP 
					set	Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
						EDtipocambio = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.EDtipocambio#">,
						EDdescuento = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.EDdescuento#">,					
						EDimpuesto = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.EDimpuesto#">,
						EDtotal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDtotal#" scale="2">,					
						Rcodigo = <cfif isDefined("Form.Rcodigo") and Trim(Form.Rcodigo) NEQ "-1"><cfqueryparam cfsqltype="cf_sql_char" value="#Form.Rcodigo#">,<cfelse>null,</cfif>
						Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
						Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">,
						EDusuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
						EDfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.EDfecha,'YYYY/MM/DD')#">,
						EDdocref = <cfif isDefined("Form.EDdocref") and Trim(Form.EDdocref) NEQ ""><cfqueryparam cfsqltype="cf_sql_char" value="#Form.EDdocref#">,<cfelse>null,</cfif>
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
				 </cfquery>					 			 				  
				 </cftransaction>
			</cfif>

			<cfset LvarAlm_Aid = "">
			<cfif find(Form.DDtipo, "A,T")>
				<cfset LvarAlm_Aid = form.almacen>
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
						select <cf_dbfunction name="to_char" args="a.Pvalor"> as Pvalor, b.Cformato, b.Cdescripcion 
						from Parametros a inner join CContables b
						  on a.Ecodigo = b.Ecodigo and
							 <cf_dbfunction name="to_char" args="a.Pvalor"> = <cf_dbfunction name="to_char" args="b.Ccuenta">
						where a.Ecodigo =  #Session.Ecodigo# 
						  and a.Pcodigo = 240
					</cfquery>
					<cfset cuentaDetalle = rsCuentaActivo.Pvalor>
					<cfset cuentaFDetalle = "">
				<cfelse>
					<cfif isdefined('form.Cid') and LEN(TRIM(form.Cid))>
						<cfquery name="rsCCid" datasource="#session.DSN#">
							select CCid
							from Conceptos
							where Ecodigo =  #Session.Ecodigo# 
							  and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">
						</cfquery>
						<cfset Cconcepto = rsCCid.CCid>
					<cfelse>
						<cfset Cconcepto = "">
					</cfif>

				<!---	<cftransaction>--->
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
						<cfset cuentaFDetalle = Cuentas.CFcuenta>
					<!---</cftransaction>--->
				</cfif>
			<cfelse>
				<cfset cuentaDetalle = form.CcuentaD>
				<cfset cuentaFDetalle = form.CFcuentaD>
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
						Alm_Aid,  Dcodigo,
						DDcantidad,
						DDpreciou, 
						DDdesclinea,
						DDporcdesclin, 
						DDtotallinea, 
						DDtipo, 
						Ccuenta,
						CFcuenta,
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
					<cfif  isDefined("Form.DDtipo") and  Form.DDtipo eq 'A'>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
					<cfelseif isDefined("Form.DDtipo") and  Form.DDtipo eq 'T'>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AidT#">
					<cfelseif isDefined("Form.DDtipo") and  Form.DDtipo eq 'O'>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AidOD#">
					<cfelse>
						null
					</cfif>,
					<cfif  isDefined("Form.DDtipo") and  Form.DDtipo eq 'S'>
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

					<cfif LvarAlm_Aid NEQ "">
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAlm_Aid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsConsultaDepto.Dcodigo#">,
					<cfelse>
						null, null,
					</cfif>
					
					<cfqueryparam cfsqltype="cf_sql_float" value="#Form.DDcantidad#">,
					#LvarOBJ_PrecioU.enCF(Form.DDpreciou)#,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DDdesclinea#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#Form.DDporcdesclin#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#numberFormat(Form.DDtotallinea,"9.00")#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.DDtipo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#cuentaDetalle#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#cuentaFDetalle#" null="#cuentaFDetalle EQ ""#">,
					 #Session.Ecodigo# ,
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
			<cftransaction>
				<cfquery name="rsDeleteDDocCxP" datasource="#session.DSN#">
					delete from DDocumentosCxP 
					where Ecodigo =  #Session.Ecodigo# 
					  and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#"> 
					  and Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Linea#">
				</cfquery>			
	
			</cftransaction>
			
			<cfset modo="CAMBIO">
			<cfset modoDet="ALTA">								  

		<cfelseif isdefined("Form.Cambiar")>
			<cfif cambioEncab>
				<cfset cambiarEncabezado()>
			</cfif>
 			<cfset modo="CAMBIO">
			<cfset modoDet="ALTA">	
		<cfelseif isdefined("Form.CambiarD")>		
		
				<cfif cambioEncab>
					<cfset cambiarEncabezado()>
				</cfif>

				<cfset LvarAlm_Aid = "">
				<cfif find(Form.DDtipo, "A,T")>
					<cfset LvarAlm_Aid = form.almacen>
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
							select <cf_dbfunction name="to_char" args="a.Pvalor"> as Pvalor, b.Cformato, b.Cdescripcion 
							from Parametros a 
							  inner join CContables b
							    on a.Ecodigo = b.Ecodigo 
								and <cf_dbfunction name="to_char" args="a.Pvalor"> = <cf_dbfunction name="to_char" args="b.Ccuenta">
							where a.Ecodigo =  #Session.Ecodigo# 
							  and a.Pcodigo = 240
						</cfquery>
						<cfset cuentaDetalle = rsCuentaActivo.Pvalor>
						<cfset cuentaFDetalle = "">
					<cfelse>
						<cfquery name="rsCCid" datasource="#session.DSN#">
							select CCid
							from Conceptos
							where Ecodigo =  #Session.Ecodigo# 
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
							<cfset cuentaFDetalle = Cuentas.CFcuenta>
						</cfif>
				<cfelse>
					<cfset cuentaDetalle = form.CcuentaD>
					<cfset cuentaFDetalle = form.CFcuentaD>
				</cfif>
                
				<cf_dbtimestamp
					datasource="#session.dsn#"
					table="DDocumentosCxP" 
					redirect="RegistroFacturasCP.cfm"
					timestamp="#Form.timestampD#"
					field1="IDdocumento,numeric,#Form.IDdocumento#"
					field2="Ecodigo,numeric,#session.Ecodigo#"
					field3="Linea,numeric,#Form.Linea#">
					
			<cftransaction>
				<cfquery name="rsUpdateDDocCxP" datasource="#session.DSN#">
					update DDocumentosCxP set 
					<cfif  isDefined("Form.DDdescripcion") and  len(trim(form.DDdescripcion)) neq 0>
						DDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DDdescripcion#">,
					</cfif>
						<cfif  isDefined("Form.DDtipo") and  Form.DDtipo eq 'A'>
							 Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">,
						<cfelseif isDefined("Form.DDtipo") and  Form.DDtipo eq 'T'>
							 Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AidT#">,
						<cfelseif isDefined("Form.DDtipo") and  Form.DDtipo eq 'O'>
							 Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AidOD#">,
						<cfelseif  isDefined("Form.DDtipo") and  Form.DDtipo eq 'S'>
							 Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">,
						</cfif>	
					<cfif  isDefined("Form.DDdescalterna") and  len(trim(form.DDdescalterna)) neq 0>
						 DDdescalterna = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DDdescalterna#">,
					</cfif>
						 DDcantidad = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.DDcantidad#">,
						 DDpreciou = #LvarOBJ_PrecioU.enCF(Form.DDpreciou)#,
						 DDdesclinea = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DDdesclinea#">,
						 DDporcdesclin = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.DDporcdesclin#">,
						<cfif isDefined("Form.CFid") and LEN(Trim(Form.CFid)) NEQ 0>
							 CFid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">,
						<cfelse>
							 CFid = null,
						</cfif>
						<cfif LvarAlm_Aid NEQ "">
							 Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAlm_Aid#">,
							 Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsConsultaDepto.Dcodigo#">,						    
						<cfelse>
							 Alm_Aid = null,
							 Dcodigo = null,
						</cfif>
						
						 DDtotallinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#numberFormat(Form.DDtotallinea,"9.00")#" scale="2">,
						 DDtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.DDtipo#">,

						 Ecodigo =  #Session.Ecodigo#,

						Ccuenta  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuentaDetalle#">,
						CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuentaFDetalle#" null="#cuentaFDetalle EQ ""#">,

						<cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
							OCTtipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTtipo#">,
						<cfelse>
							OCTtipo =  null,
						</cfif>
						<cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
							OCTtransporte = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTtransporte#">,
						<cfelse>
							OCTtransporte = null,
						</cfif>
						<cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
							OCTfechaPartida = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.OCTfechaPartida,'YYYY/MM/DD')#">,
						<cfelse>
							OCTfechaPartida = null,
						</cfif>
						<cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
							OCTobservaciones =<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTobservaciones#">,
						<cfelse>
							OCTobservaciones = null,
						</cfif>
						<cfif  isDefined("Form.DDtipo") and  Form.DDtipo eq 'O'>
							OCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCCid#">,
						<cfelse>
							OCCid =  null,
						</cfif>
						<cfif  isDefined("Form.DDtipo") and  Form.DDtipo eq 'O'>
							OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCid#">,
						<cfelse>
							OCid = null,
						</cfif>
						<cfif isDefined("Form.Icodigo") and Len(Trim(Form.Icodigo)) GT 0 > 
							Icodigo =	<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Icodigo#">,
						<cfelse>	
							 Icodigo =	 null,
						</cfif>	
						 BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
					  and Ecodigo =  #Session.Ecodigo# 
					  and Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Linea#">
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
		<cfif isdefined('form.AgregarD') or isdefined('form.BorrarD') or isdefined('form.CambiarD') or isdefined('form.Cambiar')>
			<!--- PROCESO DE ACTUALIZACION DEL TOTAL DEL DOCUMENTO Y TOTAL DE IMPUESTOS --->
            <cfquery name="rsSQL" datasource="#session.DSN#">
                select  a.EDdescuento,
                        coalesce(
                            (
                                select sum(DDtotallinea)
                                  from DDocumentosCxP
                                 where IDdocumento = a.IDdocumento
                            ) 
                        ,0.00) as SubTotal
                  from EDocumentosCxP a
                 where a.IDdocumento	= #Form.IDdocumento#
            </cfquery>

			<cfif rsSQL.EDdescuento GT rsSQL.Subtotal>
                <cfquery datasource="#session.DSN#">
                    update EDocumentosCxP
                       set EDdescuento = 0
                   where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
                     and Ecodigo =  #Session.Ecodigo# 
                </cfquery>
			</cfif>
            
			<!--- CALCULO DEL TOTAL DE IMPUESTO y Descuento a nivel de documento POR LINEA DEL DOCUMENTO --->
			<!---ACTUALIZA EL ENCABEZADO DEL DOCUMENTO CON LOS TOTALES --->
			<!--- DDtotallin	= precio * cantidad - DDdesclinea --->
			<!--- EDtotal		= sum(DDtotallin) + Impuestos - EDdescuento --->
            <cfinvoke component="sif.Componentes.CP_PosteoDocumentosCxP"
                      method="CP_CalcularDocumento"
                        IDdoc				= "#Form.IDdocumento#"
                        CalcularImpuestos	= "true"
                        Ecodigo				= "#session.Ecodigo#"
                        conexion			= "#session.DSN#"
            />
		</cfif>
	<cfif isdefined('form.Calcular')>
        <cfinvoke component="sif.Componentes.CP_PosteoDocumentosCxP"
                  method="CP_CalcularDocumento"
                    IDdoc				= "#Form.IDdocumento#"
                    CalcularImpuestos	= "false"
                    Ecodigo				= "#session.Ecodigo#"
                    conexion			= "#session.DSN#"
        />

		<!--- Forma de Cálculo de Impuesto (0: Desc/Imp, 1: Imp/Desc.) --->
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo = #session.Ecodigo# 
			  and Pcodigo = 420
		</cfquery>
		<cfset LvarImpuestosAntesDescuento = rsSQL.Pvalor EQ "1">
		
		<cf_templatecss>
		<cfoutput>
		<table width="100%">
			<tr>
				<td colspan="10"><strong>PRORRATEO DE DESCUENTO DE DOCUMENTO Y CALCULO DE IMPUESTOS</strong></td>
			</tr>
			<tr>
				<td colspan="10">(Manejo del Descuento a nivel de Documento para calcular Impuestos: <cfif LvarImpuestosAntesDescuento>primero Impuestos y luego DescuentoDoc <cfelse>primero DescuentoDoc y luego Impuestos</cfif>)</strong></td>
			</tr>
			<tr>
				<td><strong>Lin</strong></td>
				<td><strong>Tipo</strong></td>
				<td><strong>Descripcion</strong></td>
				<td align="right"><strong>Subtotal</strong></td>
			<cfif NOT LvarImpuestosAntesDescuento>
				<td align="right"><strong>Descuen.Doc<BR>Prorrateado</strong></td>
			</cfif>
				<td align="right"><strong>Base del<br>Impuesto</strong></td>
				<td><strong>&nbsp;&nbsp;Tipo<br>&nbsp;&nbsp;Impuesto</strong></td>
				<td align="right"><strong>Impuesto<br>al Costo</strong></td>
				<td align="right"><strong>Impuesto<br>Fiscal</strong></td>
				<td align="right"><strong>Total<br>Impuesto</strong></td>
			<cfif LvarImpuestosAntesDescuento>
				<td align="right"><strong>Descuen.Doc<BR>Prorrateado</strong></td>
			</cfif>
				<td align="right"><strong>Costo<br>Linea</strong></td>
				<td align="right"><strong>Total Neto<br>Linea</strong></td>
			</tr>

		<cfquery name="rsSQL" datasource="#session.DSN#">
			select *
			from #request.CP_calculoLin# l
				inner join DDocumentosCxP d
				   on d.IDdocumento 	= l.iddocumento
				  and d.Linea			= l.linea
				left join #request.CP_impLinea# i
				  on i.linea = l.linea
		</cfquery>
		<cfset LvarLinea = "">
		<cfset LvarNumLinea			= 0>
		<cfset LvarSubtotal			= 0>
		<cfset LvarTotDescDoc		= 0>
		<cfset LvarTotImpuesto		= 0>
		<cfset LvarTotImpuestoCO	= 0>
		<cfset LvarTotImpuestoCF	= 0>
		<cfset LvarTotCosto			= 0>
		<cfset LvarTotLinea			= 0>
        
		<cfloop query="rsSQL">
			<cfif LvarLinea NEQ rsSQL.linea>
				<cfset LvarLinea = rsSQL.linea>
				<cfset LvarNumLinea ++>	
				<cfset LvarCostoLinea		=  (rsSQL.costoLinea)>
				<cfset LvarTotalLinea		=  (rsSQL.totalLinea)>

				<cfset LvarSubtotal			+= rsSQL.subtotalLinea>
				<cfset LvarTotDescDoc		+= rsSQL.descuentoDoc>
				<cfset LvarTotImpuesto		+= (rsSQL.impuestoCosto+rsSQL.impuestoCF)>
				<cfset LvarTotImpuestoCO	+= (rsSQL.impuestoCosto)>
				<cfset LvarTotImpuestoCF	+= (rsSQL.impuestoCF)>
				<cfset LvarTotCosto			+= LvarCostoLinea>
				<cfset LvarTotLinea			+= LvarTotalLinea>
				<tr>
					<td>#LvarNumLinea#</td>
					<td>#rsSQL.DDtipo#</td>
					<td>#rsSQL.DDdescripcion#</td>
					<td align="right">#numberFormat(rsSQL.subtotalLinea,",9.99")#</td>
				<cfif NOT LvarImpuestosAntesDescuento>
					<td align="right">#numberFormat(rsSQL.descuentoDoc,",9.99")#</td>
				</cfif>
					<td align="right">#numberFormat(rsSQL.impuestoBase,",9.99")#</td>
					<td>
						&nbsp;&nbsp;#trim(rsSQL.Icodigo)#
                    	<cfif rsSQL.impuestoBase EQ 0>
                        	= 0.00%
                        <cfelseif Icompuesto EQ '1'>
							<cfquery name="rsCompuesto" datasource="#session.DSN#">
								select sum(DIporcentaje) as porcentaje
								from DImpuestos
								where Ecodigo	= #session.Ecodigo#
								  and Icodigo	= '#rsSQL.Icodigo#'
							</cfquery>
	                    	= #numberFormat(rsCompuesto.porcentaje,",9.99")#%
						<cfelse>
	                    	= #numberFormat(porcentaje,",9.99")#%
                        </cfif>
                    </td>
					<cfif rsSQL.impuestoCosto EQ 0>
						<td align="right">-</td>
					<cfelse>
						<td align="right">#numberFormat(rsSQL.impuestoCosto,",9.99")#</td>
					</cfif>
					<cfif rsSQL.impuestoCF EQ 0>
						<td align="right">-</td>
					<cfelse>
						<td align="right">#numberFormat(rsSQL.impuestoCF,",9.99")#</td>
					</cfif>
					<td align="right">#numberFormat(rsSQL.impuestoCosto+rsSQL.impuestoCF,",9.99")#</td>
				<cfif LvarImpuestosAntesDescuento>
					<td align="right">#numberFormat(rsSQL.descuentoDoc,",9.99")#</td>
				</cfif>
					<td align="right">#numberFormat(LvarCostoLinea,",9.99")#</td>
					<td align="right">#numberFormat(LvarTotalLinea,",9.99")#</td>
				</tr>
			</cfif>
			<cfif rsSQL.Icompuesto EQ '1'>
				<cfset LvarLinea = rsSQL.linea>
					
				<tr>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				<cfif NOT LvarImpuestosAntesDescuento>
					<td></td>
				</cfif>
					<td></td>
					<td style="font-size:10px; color:##666666">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#trim(rsSQL.DIcodigo)#=#rsSQL.porcentaje#%</td>
					<cfif rsSQL.creditoFiscal EQ "0">
						<td align="right" style="font-size:10px; color:##666666;">#numberFormat(rsSQL.impuesto,",9.99")#</td>
						<td></td>
					<cfelse>
						<td></td>
						<td align="right" style="font-size:10px; color:##666666;">#numberFormat(rsSQL.impuesto,",9.99")#</td>
					</cfif>
					<td align="right" style="font-size:10px; color:##666666;">#numberFormat(rsSQL.impuesto,",9.99")#</td>
				</tr>
			</cfif>
		</cfloop>
				<tr>
					<td></td>
					<td></td>
					<td></td>
					<td align="right"><strong>#numberFormat(LvarSubtotal,",9.99")#</strong></td>
				<cfif NOT LvarImpuestosAntesDescuento>
					<td align="right"><strong>#numberFormat(LvarTotDescDoc,",9.99")#</strong></td>
				</cfif>
					<td></td>
					<td></td>
					<td align="right"><strong>#numberFormat(LvarTotImpuestoCO,",9.99")#</strong></td>
					<td align="right"><strong>#numberFormat(LvarTotImpuestoCF,",9.99")#</strong></td>
					<td align="right"><strong>#numberFormat(LvarTotImpuesto,",9.99")#</strong></td>
				<cfif LvarImpuestosAntesDescuento>
					<td align="right"><strong>#numberFormat(LvarTotDescDoc,",9.99")#</strong></td>
				</cfif>
					<td align="right"><strong>#numberFormat(LvarTotCosto,",9.99")#</strong></td>
					<td align="right"><strong>#numberFormat(LvarTotLinea,",9.99")#</strong></td>
				</tr>

				<tr>
					<td>&nbsp;</td>
				</tr>

				<tr>
					<td colspan="10" align="right"><strong>Subtotal</strong></td>
					<td></td>
					<td align="right"><strong>#numberFormat(LvarSubtotal,",9.99")#</strong></td>
				</tr>
			<cfif NOT LvarImpuestosAntesDescuento>
				<tr>
					<td colspan="10" align="right"><strong>Descuento Documento</strong></td>
					<td></td>
					<td align="right"><strong>#numberFormat(LvarTotDescDoc,",9.99")#</strong></td>
				</tr>
			</cfif>
				<tr>
					<td colspan="10" align="right"><strong>Impuestos</strong></td>
					<td></td>
					<td align="right"><strong>#numberFormat(LvarTotImpuesto,",9.99")#</strong></td>
				</tr>
			<cfif LvarImpuestosAntesDescuento>
				<tr>
					<td colspan="10" align="right"><strong>Descuento Documento</strong></td>
					<td></td>
					<td align="right"><strong>#numberFormat(LvarTotDescDoc,",9.99")#</strong></td>
				</tr>
			</cfif>
				<tr>
					<td colspan="10" align="right"><strong>Total Documento</strong></td>
					<td></td>
					<td align="right"><strong>#numberFormat(LvarTotLinea,",9.99")#</strong></td>
				</tr>
				<tr>
					<cfquery name="rsRetencion" datasource="#session.dsn#">
						select 	coalesce(r.Rporcentaje,0) / 100.0 *
								coalesce(
								(
									select sum(DDtotallinea)
									  from DDocumentosCxP d
									 inner join Impuestos i
										 on i.Ecodigo = d.Ecodigo
										and i.Icodigo = d.Icodigo
									 where d.IDdocumento = e.IDdocumento
									   and i.InoRetencion = 0
									 
								) 
							,0.00) as Monto
						from EDocumentosCxP e
							left join Retenciones r
							 on r.Ecodigo = e.Ecodigo
							and r.Rcodigo = e.Rcodigo
						where e.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
					</cfquery>
					<td colspan="10" align="right"><strong>Retención</strong></td>
					<td></td>
					<td align="right"><strong>#numberFormat(rsRetencion.Monto,",9.99")#</strong></td>
				</tr>
		</table>
        <table>
        	<tr>
            	<td>
                	<strong>RUBRO</strong>&nbsp;&nbsp;
                </td>
            	<td>
                	<strong>DEBITOS</strong>&nbsp;&nbsp;
                </td>
            	<td>
                	<strong>CREDITOS</strong>&nbsp;
                </td>
			</tr>
			<cfquery name="rsSQL" datasource="#session.DSN#">
				select CPTtipo
				 from EDocumentosCxP e
				inner join CPTransacciones t
					 on t.Ecodigo	= e.Ecodigo
					and t.CPTcodigo	= e.CPTcodigo
				where e.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and e.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">		
			</cfquery>
			<cfset LvarCPTtipo = rsSQL.CPTtipo>
        	<tr>
            	<td>
                	Cuenta por Pagar
                </td>
				<cfif LvarCPTtipo EQ "C">
					<td></td>
					<td align="right">
						#numberFormat(LvarTotLinea,",9.99")#
					</td>
				<cfelse>
					<td align="right">
						#numberFormat(LvarTotLinea,",9.99")#
					</td>
					<td></td>
				</cfif>
			</tr>
        	<tr>
            	<td>
                	Costos de las Lineas&nbsp;&nbsp;
                </td>
				<cfif LvarCPTtipo EQ "C">
					<td align="right">
						#numberFormat(LvarTotCosto,",9.99")#
					</td>
					<td></td>
				<cfelse>
					<td></td>
					<td align="right">
						#numberFormat(LvarTotCosto,",9.99")#
					</td>
				</cfif>
			</tr>
        	<tr>
            	<td>
                	Impuestos por Pagar&nbsp;&nbsp;
                </td>
				<cfif LvarCPTtipo EQ "C">
					<td align="right">
						#numberFormat(LvarTotImpuestoCF,",9.99")#
					</td>
					<td></td>
				<cfelse>
					<td></td>
					<td align="right">
						#numberFormat(LvarTotImpuestoCF,",9.99")#
					</td>
				</cfif>
			</tr>
			<cfquery name="rsSQL" datasource="#session.DSN#">
				select dicodigo, porcentaje, sum(impuesto) as impuesto
				from #request.CP_impLinea# i
				where creditofiscal = 1
				group by dicodigo, porcentaje
			</cfquery>
			<cfloop query="rsSQL">
				<tr>
					<td style="font-size:10px; color:##666666">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#trim(rsSQL.DIcodigo)#=#rsSQL.porcentaje#%</td>
				<cfif LvarCPTtipo NEQ "C">
					<td></td>
				</cfif>
					<td align="right" style="font-size:10px; color:##666666;">#numberFormat(rsSQL.impuesto,",9.99")#</td>
				</tr>
			</cfloop>
		</table>
		<input type="button" value="Ver Asiento" onClick="location.href='SQLRegistroDocumentosCP.cfm?Pintar&IDdocumento=#Form.IDdocumento#&tipo=#form.tipo#';" />
		</cfoutput>
		<cfabort>
	</cfif>
<cfif isdefined("form.IDdocumento") and len(trim(form.IDdocumento)) and not isdefined("Form.BorrarE")>
	<cfquery name="RScuenta" datasource="#session.DSN#">
		select * 
		from EDocumentosCxP 
		where Ecodigo =  #Session.Ecodigo# 
		and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocumento#">
	</cfquery>
	<cfif rscuenta.recordcount EQ 1>
		<cfquery name="rsSocioN_SQL" datasource="#session.DSN#">
			select SNidentificacion, SNcodigo, SNnumero, SNid, id_direccion
			from SNegocios
			where Ecodigo =  #Session.Ecodigo# 
			and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#RScuenta.SNcodigo#">
		</cfquery>
	</cfif>
</cfif>
<cfif isdefined("form.btnAgregar")>
    <cfif isdefined('form.chk')>
	<cfset arr = ListToArray(form.chk, ',', false)>
	<cfset LvarLen = ArrayLen(arr)>
	<cfset LvarIdEDocumento = #url.Edocumento#>	
		  <cfloop index="i" from="1" to="#LvarLen#">
			<cfset LvarLineaNum = "#ListGetAt(arr[i], 5 ,'|')#">  <!---Id de la linea de la factura --->	
			<cfset LvarLineaDoc  = "#ListGetAt(arr[i], 11 ,'|')#">  <!---Id del documento --->	 	
			
            <cftransaction>
			<cfquery name="rsLineaFact" datasource="#session.dsn#">
			 select     IDdocumento,
						DDlinea,
						Dcodigo,
						Ccuenta, 
						Aid,  
						DOlinea,  
						CFid, 
						DDescripcion, 
						DDdescalterna, 
						DDcantidad, 
						DDpreciou, 
						DDdesclinea, 						
						DDtotallin, 
						DDcoditem,
						DDtipo,
						Icodigo, 
						Ucodigo, 
						DDtransito,
						DDembarque, 
						DDfembarque, 
						DDobservaciones, 
						ContractNo,  
						CFcuenta,
						PCGDid,  
						FPAEid,
						CFComplemento,
						OBOid
				from DDocumentosCP   					
				  where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLineaDoc#"> 
				   and DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLineaNum#"> 
				and Ecodigo = #session.ecodigo#
			 </cfquery>										 	 	
			<cfquery name="rsInsLineasFact" datasource="#session.DSN#">
				insert into DDocumentosCxP 
					(	IDdocumento,
					    Cid,						
						Ecodigo,
						Dcodigo,
						Ccuenta,
						Aid,
						DOlinea,
						CFid,
						DDdescripcion,
						DDdescalterna,
						DDcantidad,
						DDpreciou,
						DDdesclinea,
						DDporcdesclin,
						DDtotallinea,
						DDtipo,
						BMUsucodigo,
						Icodigo,
						Ucodigo,
						DDtransito,
						DDfembarque,
						DDembarque,
						DDobservaciones,
						ContractNo,
						CFcuenta,
						PCGDid,
						FPAEid,
						CFComplemento,
						OBOid
						)
				values 
				   (
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#LvarIdEDocumento#">,
					<cfif rsLineaFact.DDtipo eq 'S'>
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#rsLineaFact.DDcoditem#" voidNull>,
					<cfelse>
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="null">,					
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric"  value="#session.ecodigo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#rtrim(rsLineaFact.Dcodigo)#" voidNull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#rsLineaFact.Ccuenta#">,
					<cfif rsLineaFact.DDtipo eq 'A'>
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#rsLineaFact.DDcoditem#" voidNull>,
					<cfelse>
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="null">,					
					</cfif>
					<!---<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#rsLineaFact.Aid#" 		voidNull>,--->
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#rsLineaFact.DOlinea#"   voidNull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#rsLineaFact.CFid#"	    voidNull>,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rsLineaFact.DDescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rsLineaFact.DDdescalterna#">,
					<cfqueryparam cfsqltype="cf_sql_float"    value="#rsLineaFact.DDcantidad#">,
					<cfqueryparam cfsqltype="cf_sql_float"    value="#rsLineaFact.DDpreciou#">,
					<cfqueryparam cfsqltype="cf_sql_money"    value="#rsLineaFact.DDdesclinea#">,
					0,					
					<cfqueryparam cfsqltype="cf_sql_numeric"  value="#rsLineaFact.DDtotallin#" scale="2">,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rsLineaFact.DDtipo#">,						
					<cfqueryparam cfsqltype="cf_sql_numeric"  value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rsLineaFact.Icodigo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#rsLineaFact.Ucodigo#"  voidNull>,
					<cfqueryparam cfsqltype="cf_sql_bit"  	  value="#rsLineaFact.DDtransito#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_timestamp"  value="#rsLineaFact.DDfembarque#" voidNull>,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rsLineaFact.DDembarque#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#rsLineaFact.DDobservaciones#"   voidNull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#rsLineaFact.ContractNo#"  voidNull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#rsLineaFact.CFcuenta#" 	  voidNull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#rsLineaFact.PCGDid#" 	  voidNull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#rsLineaFact.FPAEid#" 	  voidNull>,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rsLineaFact.CFComplemento#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#rsLineaFact.OBOid#" 	   voidNull>
				   ) 
			</cfquery>
			 </cftransaction>
					
		 </cfloop> 
		
		 <cfquery name="rsTotalLineas" datasource="#session.dsn#">
		   select sum(DDtotallinea) as TotalDet from DDocumentosCxP 
		   where IDdocumento=  <cfqueryparam cfsqltype="cf_sql_numeric"  value="#LvarIdEDocumento#"> 
		   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#session.ecodigo#">
		 </cfquery>
		 
		 
		 <cfquery name="rsImpuestoLinea" datasource="#session.dsn#">
		   select sum(a.DDtotallinea * (b.Iporcentaje/100)) as Impuestos from DDocumentosCxP a
		     inner join Impuestos b
			    on a.Icodigo =  b.Icodigo
				and a.Ecodigo =  b.Ecodigo
		   where IDdocumento=  <cfqueryparam cfsqltype="cf_sql_numeric"  value="#LvarIdEDocumento#"> 
		   and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#session.ecodigo#">
		 </cfquery> 
				 
		  <cfquery name="rsUpdate" datasource="#session.dsn#">
		    update EDocumentosCxP 
			   set EDtotal    = #rsTotalLineas.TotalDet# + #rsImpuestoLinea.Impuestos#,
			   EDimpuesto     = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#rsImpuestoLinea.Impuestos#" scale="2">
			where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#LvarIdEDocumento#">
		  </cfquery>
		 
			   
	</cfif>	
	<script language="javascript1.2" type="text/javascript">  		
		window.opener.location.reload();
		window.close();
	</script>
	<cf_dump var="">
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

<cffunction name="cambiarEncabezado" returntype="void">

	<cf_dbtimestamp
			datasource="#session.dsn#"
			table="EDocumentosCxP" 
			redirect="RegistroFacturasCP.cfm"
			timestamp="#Form.timestampE#"
			field1="IDdocumento,numeric,#Form.IDdocumento#">
           
     <cfif isDefined("Form.EDdocref") and Trim(Form.EDdocref) NEQ "">
	      <cfquery name="rsE" datasource="#session.dsn#">
		   	select  EDdocref from EDocumentosCxP where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
		  </cfquery>
          <cfif rsE.EDdocref NEQ Trim(Form.EDdocref)>
              <cfquery name="rsborrarLinea" datasource="#session.dsn#">
                delete from DDocumentosCxP where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
              </cfquery>
          </cfif>	 
	 </cfif>
				
	<cfquery name="rsUpdateEDocCxP" datasource="#session.DSN#">
		update EDocumentosCxP set
			Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
			EDtipocambio = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.EDtipocambio#">,
			EDdescuento = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.EDdescuento#">,					
			EDimpuesto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDimpuesto#" scale="2">,
			EDtotal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDtotal#" scale="2">,									
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
	 </cfquery>
</cffunction>