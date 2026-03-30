<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
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

 	<cfif not (isDefined("Form.EDfecha") and isDefined("Form._EDfecha") and Trim(Form.EDfecha) EQ Trim(Form._EDfecha)
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
				
				<cfquery name="rsEstado" datasource="#session.dsn#">
					select  FTidEstado 
					from EstadoFact 
					where FTcodigo = '1' <!---Registrada--->
				</cfquery>
				
				<cfquery name="rsInsertEDocCP" datasource="#session.DSN#">
					insert into EDocumentosCxP (Ecodigo, CPTcodigo, EDdocumento, SNcodigo, Mcodigo, EDtipocambio,
												EDdescuento, EDporcdescuento, EDimpuesto, EDtotal, Ocodigo, Ccuenta, EDfecha, 
												Rcodigo, EDusuario, EDselect, EDdocref, EDfechaarribo, id_direccion, TESRPTCid, BMUsucodigo,TESRPTCietu,EVestado)
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
									<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">,
							 	</cfif>
							 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
								0,
								<cfif isDefined("Form.EDdocref") and Trim(Form.EDdocref) NEQ "">
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDdocref#">,
								<cfelse>
									<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
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
									<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
								</cfif>
								<cfif isdefined("form.TESRPTCid") and len(trim(form.TESRPTCid))>
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#">,
								<cfelse>
									<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
								</cfif>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> 
								<cfif TransaccionCP.CPTtipo EQ 'C'>		<!--- 1=Documento Normal CR, 0=Documento Contrario DB --->
									,1
								<cfelse>
									,0
								</cfif>
								
								<cfif isdefined("form.EVestado") and len(trim(form.EVestado))>
									,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EVestado#">
								<cfelse>
									,#rsEstado.FTidEstado#
								</cfif>
								)
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="rsInsertEDocCP" returnvariable="IdEDocCP">

										
				<cfquery name="rsDato" datasource="#session.dsn#">
					select 
						b.SNnombre, 
						a.EDdocumento, 
						a.IDdocumento,
						a.EDfecha,
						a.SNcodigo,
						a.CPTcodigo 
					from 	EDocumentosCxP a
					inner join SNegocios b
						on b.SNcodigo = a.SNcodigo
						and b.Ecodigo = a.Ecodigo
					inner join CPTransacciones c
						 on c.CPTcodigo = a.CPTcodigo
						and c.Ecodigo = a.Ecodigo
						and c.CPTtipo = 'C'
					inner join Monedas m
						on m.Mcodigo = a.Mcodigo 
					where a.IDdocumento = #IdEDocCP#	
				</cfquery>
			
				<cfquery name="rsInsertaEventoA" datasource="#session.dsn#">
					insert into EventosFact (EVfactura,EVestado,SNcodigo,CPTcodigo,EVObservacion,BMUsucodigo,Ecodigo,BMfecha)
						values(
							<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#rsDato.EDdocumento#">,
							#rsEstado.FTidEstado#,	
							<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsDato.SNcodigo#">,	
							<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#rsDato.CPTcodigo#">,	
							<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
							<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,	
							<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">	
							)
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="rsInsertaEventoA" returnvariable="EVid">

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
				redirect="#root#"
				timestamp="#Form.timestampE#"
				field1="IDdocumento,numeric,#Form.IDdocumento#">
						
				<cftransaction>
				
				<cfquery name="rsEstado" datasource="#session.dsn#">
					select  FTidEstado 
					from EstadoFact 
					where FTcodigo = '1' <!---Registrada--->
				</cfquery>

				<cfquery name="rsUpdateEDocCP" datasource="#session.DSN#">
					update EDocumentosCxP 
					set	Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
						EDtipocambio = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.EDtipocambio#">,
						EDdescuento = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.EDdescuento#">,					
						EDimpuesto = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.EDimpuesto#">,
						EDtotal = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.EDtotal#">,					
						Rcodigo = <cfif isDefined("Form.Rcodigo") and Trim(Form.Rcodigo) NEQ "-1"><cfqueryparam cfsqltype="cf_sql_char" value="#Form.Rcodigo#">,<cfelse><cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">,</cfif>
						Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
						Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">,
						EDusuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
						EDfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.EDfecha,'YYYY/MM/DD')#">,
						EDdocref = <cfif isDefined("Form.EDdocref") and Trim(Form.EDdocref) NEQ ""><cfqueryparam cfsqltype="cf_sql_char" value="#Form.EDdocref#">,<cfelse>	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,</cfif>
						id_direccion = <cfif isdefined("form.id_direccion") and len(trim(form.id_direccion))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">,<cfelse><cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,</cfif>
						<cfif isdefined("Form.EDfechaarribo") and len(trim(Form.EDfechaarribo))>
							EDfechaarribo = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.EDfechaarribo,'YYYY/MM/DD')#">,
						<cfelse>
							EDfechaarribo = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.EDfecha,'YYYY/MM/DD')#">,<!--- EDfecha es obigatorio --->
						</cfif>
						TESRPTCid =	
						<cfif isdefined("form.TESRPTCid") and len(trim(form.TESRPTCid))>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#">,
						<cfelse>
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
						</cfif>
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						EVestado = 
						<cfif isdefined("form.EVestado") and len(trim(form.EVestado))>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EVestado#">
						<cfelse>
							#rsEstado.FTidEstado#
						</cfif>
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
						<cfset cuentaFDetalle = Cuentas.CFcuenta>
					</cftransaction>
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
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
					</cfif>,
					<cfif  isDefined("Form.DDtipo") and  Form.DDtipo eq 'S'>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">,
					<cfelse>	
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
					</cfif>				
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DDdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DDdescalterna#">,
					<cfif isDefined("Form.CFid") and Len(Trim(Form.CFid)) GT 0 > 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">,
					<cfelse>	
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
					</cfif>				

					<cfif LvarAlm_Aid NEQ "">
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAlm_Aid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsConsultaDepto.Dcodigo#">,
					<cfelse>
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
 						<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">,
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
					<cfelse><cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"></cfif>,
					<cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTtransporte#">
					<cfelse><cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"></cfif>,
					<cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.OCTfechaPartida,'YYYY/MM/DD')#">
					<cfelse><cf_jdbcquery_param cfsqltype="cf_sql_date" value="null"></cfif>,
					<cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTobservaciones#">
					<cfelse><cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"></cfif>,
					<cfif  isDefined("Form.DDtipo") and  Form.DDtipo eq 'O'>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCCid#">
					<cfelse><cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"></cfif>,
					<cfif  isDefined("Form.DDtipo") and  Form.DDtipo eq 'O'>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCid#">
					<cfelse><cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"></cfif>,
					<cfif isDefined("Form.Icodigo") and Len(Trim(Form.Icodigo)) GT 0 > 
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Icodigo#">,
					<cfelse>	
						<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">,
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
			<cftransaction>
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
					<cfif isDefined("Form.Cid") and LEN(Trim(Form.Cid)) EQ 0 or isDefined("Form.Aid") and LEN(Trim(Form.Aid)) EQ 0 >
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
					redirect="#root#"
					timestamp="#Form.timestampD#"
					field1="IDdocumento,numeric,#Form.IDdocumento#"
					field2="Ecodigo,numeric,#session.Ecodigo#"
					field3="Linea,numeric,#Form.Linea#">
					
				<cfquery name="rsUpdateDDocCxP" datasource="#session.DSN#">
					update DDocumentosCxP set 
						DDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DDdescripcion#">
						<cfif  isDefined("Form.DDtipo") and  Form.DDtipo eq 'A'>
							, Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
						<cfelseif isDefined("Form.DDtipo") and  Form.DDtipo eq 'T'>
							, Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AidT#">
						<cfelseif isDefined("Form.DDtipo") and  Form.DDtipo eq 'O'>
							, Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AidOD#">
						<cfelseif  isDefined("Form.DDtipo") and  Form.DDtipo eq 'S'>
							, Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">
						</cfif>								
						, DDdescalterna = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DDdescalterna#">
						, DDcantidad = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.DDcantidad#">
						, DDpreciou = #LvarOBJ_PrecioU.enCF(Form.DDpreciou)#
						, DDdesclinea = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DDdesclinea#">
						, DDporcdesclin = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.DDporcdesclin#">
						<cfif isDefined("Form.CFid") and LEN(Trim(Form.CFid)) NEQ 0>
							, CFid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
						<cfelse>
							, CFid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
						</cfif>
						<cfif LvarAlm_Aid NEQ "">
							, Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAlm_Aid#">
						    , Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsConsultaDepto.Dcodigo#">
						<cfelse>
							, Alm_Aid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
							, Dcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">
						</cfif>
						, DDtotallinea = <cfqueryparam cfsqltype="cf_sql_money" value="#numberFormat(Form.DDtotallinea,"9.00")#">
						, DDtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.DDtipo#">

						, Ecodigo =  #Session.Ecodigo# 

						, Ccuenta  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuentaDetalle#">
						, CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuentaFDetalle#" null="#cuentaFDetalle EQ ""#">

						<cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
							,OCTtipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTtipo#">
						<cfelse>
							,OCTtipo =  <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">
						</cfif>
						<cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
							,OCTtransporte = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTtransporte#">
						<cfelse>
							,OCTtransporte = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">
						</cfif>
						<cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
							,OCTfechaPartida = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.OCTfechaPartida,'YYYY/MM/DD')#">
						<cfelse>
							,OCTfechaPartida = <cf_jdbcquery_param cfsqltype="cf_sql_date" value="null">
						</cfif>
						<cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
							,OCTobservaciones =<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTobservaciones#">
						<cfelse>
							,OCTobservaciones = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">
						</cfif>
						<cfif  isDefined("Form.DDtipo") and  Form.DDtipo eq 'O'>
							,OCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCCid#">
						<cfelse>
							,OCCid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
						</cfif>
						<cfif  isDefined("Form.DDtipo") and  Form.DDtipo eq 'O'>
							,OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCid#">
						<cfelse>
							,OCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
						</cfif>
						<cfif isDefined("Form.Icodigo") and Len(Trim(Form.Icodigo)) GT 0 > 
							, Icodigo =	<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Icodigo#">
						<cfelse>	
							, Icodigo =	 <cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">
						</cfif>	
						, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
					  and Ecodigo =  #Session.Ecodigo# 
					  and Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Linea#">
				</cfquery>		
			</cftransaction>
						
 			<cfset modo="CAMBIO">
			<cfset modoDet="ALTA">	

		<cfelseif isdefined("Form.btnNuevo")>
			<cfif isdefined("form.tipoF") and len(trim(form.tipoF))>
				<cflocation addtoken="no" url="#root#?Nuevo&LvarIDdocumento=true#params#">
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
		<input type="button" value="Ver Asiento" onClick="location.href='SQLRegistroFacturasCP.cfm?Pintar&IDdocumento=#Form.IDdocumento#&tipo=#form.tipo#';" />
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


<form action="<cfoutput>#root#</cfoutput>" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="modoDet" type="hidden" value="<cfif isdefined("modoDet")><cfoutput>#modoDet#</cfoutput></cfif>">	
	<input name="tipo" type="hidden" value="<cfoutput>#form.tipo#</cfoutput>">
	
	<cfif isdefined("rsInsertEDocCP.identity")>
	   	<input name="IDdocumento" type="hidden" value="<cfif isdefined("rsInsertEDocCP.identity")><cfoutput>#rsInsertEDocCP.identity#</cfoutput></cfif>">
	<cfelse>
	   	<input name="IDdocumento" type="hidden" value="<cfif isdefined("Form.IDdocumento") and not isDefined("Form.BorrarE")><cfoutput>#Form.IDdocumento#</cfoutput></cfif>">		
	</cfif>
	
	<cfif isdefined("Form.root")>
   		<input name="root" type="hidden" value="<cfif isdefined("Form.root")><cfoutput>#Form.root#</cfoutput></cfif>">    	
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
	
	
		<cfif isDefined("Form.btnEnviar_a_Aplicar")>
			<cfif isdefined("form.chk") and len(trim(form.chk)) GT 0>
				<cfloop list="#form.chk#" index="chk">
					<cfquery name="rsSQL" datasource="#session.dsn#">
						select 1 as cantidad 
						from DDocumentosCxP a
						where a.IDdocumento = #chk#	
					</cfquery>
			
					<cfif rsSQL.cantidad LT 1>
						<cf_errorCode	code = "51153" msg = "No Existen Líneas para el Documento (DDdescripcion) Seleccionado. Proceso Cancelado!">
					</cfif>
				</cfloop>
										
			<cfloop list="#form.chk#" index="item">
				<cftransaction>
				
				<cfquery name="rsEstado" datasource="#session.dsn#">
					select  FTidEstado 
					from EstadoFact 
					where FTcodigo = '2' <!---Enviar a aprobar--->
				</cfquery>
			
				<cfquery datasource="#session.DSN#">
					update EDocumentosCxP
					set EVestado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstado.FTidEstado#">		
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">			  
				</cfquery>
				
				
					<cfquery name="rsDato" datasource="#session.dsn#">
						select 
						   a.CPTcodigo,
							a.SNcodigo,
							b.SNnombre, 
							a.EDdocumento, 
							a.EDfecha 
						from 	EDocumentosCxP a
						inner join SNegocios b
							on b.SNcodigo = a.SNcodigo
							and b.Ecodigo = a.Ecodigo
						inner join CPTransacciones c
							 on c.CPTcodigo = a.CPTcodigo
							and c.Ecodigo = a.Ecodigo
							and c.CPTtipo = 'C'
						inner join Monedas m
							on m.Mcodigo = a.Mcodigo 
						where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">	
					</cfquery>
				
					<cfquery name="rsInsertaEvento" datasource="#session.dsn#">
						insert into EventosFact (EVfactura,EVestado,SNcodigo,CPTcodigo,EVObservacion,BMUsucodigo,Ecodigo,BMfecha)
							values(
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsDato.EDdocumento#">,
								#rsEstado.FTidEstado#,	
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDato.SNcodigo#">,	
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsDato.CPTcodigo#">,	
								<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,	
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">	
								)
						<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
					</cfquery>
					<cf_dbidentity2 datasource="#Session.DSN#" name="rsInsertaEvento" verificar_transaccion="false" returnvariable="EVid">
			</cftransaction>
		</cfloop>
	</cfif>	
	
	<cfif isdefined("form.IDdocumento") and len(trim(form.IDdocumento)) GT 0>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select count(1) as cantidad
			from DDocumentosCxP a
			where a.IDdocumento =  #form.IDdocumento#	
		</cfquery>

		<cfif rsSQL.cantidad LT 1>
			<cf_errorCode	code = "51153" msg = "No Existen Líneas para el Documento Seleccionado. Proceso Cancelado!">
		</cfif>
									
				<cftransaction>
				
					<cfquery name="rsEstado" datasource="#session.dsn#">
						select  FTidEstado 
						from EstadoFact 
						where FTcodigo = '2' <!---Enviar a aprobar--->
					</cfquery>
			
					<cfquery datasource="#session.DSN#">
						update EDocumentosCxP
						set EVestado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstado.FTidEstado#">		
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						  and IDdocumento = #form.IDdocumento#			  
					</cfquery>
				
					<cfquery name="rsDato" datasource="#session.dsn#">
						select 
							b.SNnombre, 
							a.EDdocumento, 
							a.EDfecha ,
							a.SNcodigo,
							a.CPTcodigo
						from 	EDocumentosCxP a
						inner join SNegocios b
							on b.SNcodigo = a.SNcodigo
							and b.Ecodigo = a.Ecodigo
						inner join CPTransacciones c
							 on c.CPTcodigo = a.CPTcodigo
							and c.Ecodigo = a.Ecodigo
							and c.CPTtipo = 'C'
						inner join Monedas m
							on m.Mcodigo = a.Mcodigo 
						where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocumento#">	
					</cfquery>
					
					<cfquery name="rsInsertaEvento" datasource="#session.dsn#">
						insert into EventosFact (EVfactura,EVestado,SNcodigo,CPTcodigo,EVObservacion,BMUsucodigo,Ecodigo,BMfecha)
							values(
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsDato.EDdocumento#">,
								#rsEstado.FTidEstado#,	
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDato.SNcodigo#">,	
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsDato.CPTcodigo#">,	
								<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,	
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">	
								)
						<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
					</cfquery>
					<cf_dbidentity2 datasource="#Session.DSN#" name="rsInsertaEvento" verificar_transaccion="false" returnvariable="EVid">
			</cftransaction>
	</cfif>	
	<cflocation addtoken="no" url="#root#">			
</cfif>
	
	
	<cfif isDefined("Form.btnAnular")>

		<cfif isdefined("form.chk") and len(trim(form.chk)) GT 0>
		<cfloop list="#form.chk#" index="item">
			<cftransaction>
			<cfquery name="rsEstado" datasource="#session.dsn#">
				select  FTidEstado 
				from EstadoFact 
				where FTcodigo = '3' <!---Devuelta--->
			</cfquery>
		
			<cfquery datasource="#session.DSN#">
				update EDocumentosCxP
				set EVestado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstado.FTidEstado#">		
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">		  
			</cfquery>
			
				<cfquery name="rsDato" datasource="#session.dsn#">
					select 
						a.SNcodigo,
						a.CPTcodigo,
						b.SNnombre, 
						a.EDdocumento, 
						a.EDfecha 
					from 	EDocumentosCxP a
					inner join SNegocios b
						on b.SNcodigo = a.SNcodigo
						and b.Ecodigo = a.Ecodigo
					inner join CPTransacciones c
						 on c.CPTcodigo = a.CPTcodigo
						and c.Ecodigo = a.Ecodigo
						and c.CPTtipo = 'C'
					inner join Monedas m
						on m.Mcodigo = a.Mcodigo 
					where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">	
				</cfquery>
			
				<cfquery name="rsInsertaEventoD" datasource="#session.dsn#">
					insert into EventosFact (EVfactura,EVestado,SNcodigo,CPTcodigo,EVObservacion,BMUsucodigo,Ecodigo,BMfecha)
						values(
							<cfqueryparam cfsqltype="cf_sql_char" value="#rsDato.EDdocumento#">,
							#rsEstado.FTidEstado#,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDato.SNcodigo#">,	
							<cfqueryparam cfsqltype="cf_sql_char" value="#rsDato.CPTcodigo#">,	
							<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,	
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">	
							)
					<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
				</cfquery>
				<cf_dbidentity2 datasource="#Session.DSN#" name="rsInsertaEventoD" verificar_transaccion="false" returnvariable="EVid">
		</cftransaction>
	</cfloop>
</cfif>	
<cflocation addtoken="no" url="#root#">	
</cfif>	
							
	<cfif isDefined("Form.btnAnular2")>
			<cftransaction>
					<cfquery name="rsDato" datasource="#session.dsn#">
						select 
							c.CPTcodigo,
							b.SNcodigo,
							b.SNnombre, 
							a.EDdocumento, 
							a.EDfecha 
						from 	EDocumentosCxP a
						inner join SNegocios b
							on b.SNcodigo = a.SNcodigo
							and b.Ecodigo = a.Ecodigo
						inner join CPTransacciones c
							 on c.CPTcodigo = a.CPTcodigo
							and c.Ecodigo = a.Ecodigo
							and c.CPTtipo = 'C'
						inner join Monedas m
							on m.Mcodigo = a.Mcodigo 
						where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocumento#">	
					</cfquery>
					
				<cfquery name="rsEstado" datasource="#session.dsn#">
					select  FTidEstado 
					from EstadoFact 
					where FTcodigo = '3' <!---Devuelta--->
				</cfquery>
	
				<cfquery datasource="#session.DSN#">
					update EDocumentosCxP
					set EVestado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstado.FTidEstado#">		
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">		  
				</cfquery>
				
					<cfquery name="rsInsertaEventoD" datasource="#session.dsn#">
						insert into EventosFact (EVfactura,EVestado,SNcodigo,CPTcodigo,EVObservacion,BMUsucodigo,Ecodigo,BMfecha)
							values(
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsDato.EDdocumento#">,
								#rsEstado.FTidEstado#,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDato.SNcodigo#">,	
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsDato.CPTcodigo#">,	
								<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,	
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">	
								)
						<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
					</cfquery>
					<cf_dbidentity2 datasource="#Session.DSN#" name="rsInsertaEventoD" verificar_transaccion="false" returnvariable="EVid">
			</cftransaction>
		<cflocation addtoken="no" url="#root#">							
</cfif>
	
	<cfif isDefined("Form.btnAplicar")>
			<cfif isdefined("form.chk") and len(trim(form.chk)) GT 0>
			<cfloop list="#form.chk#" index="item">
				<cftransaction>
					<cfquery name="rsDato" datasource="#session.dsn#">
						select 
						   a.SNcodigo,
							a.CPTcodigo,
							b.SNnombre, 
							a.EDdocumento, 
							a.IDdocumento,
							a.EDfecha 
						from 	EDocumentosCxP a
						inner join SNegocios b
							on b.SNcodigo = a.SNcodigo
							and b.Ecodigo = a.Ecodigo
						inner join CPTransacciones c
							 on c.CPTcodigo = a.CPTcodigo
							and c.Ecodigo = a.Ecodigo
							and c.CPTtipo = 'C'
						inner join Monedas m
							on m.Mcodigo = a.Mcodigo 
						where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">	
					</cfquery>
					
					<cfquery name="rsEstado" datasource="#session.dsn#">
						select  FTidEstado 
						from EstadoFact 
						where FTcodigo = '4' <!---Aplicada--->
					</cfquery>
					
					<cfquery name="rsInsertaEventoA" datasource="#session.dsn#">
						insert into EventosFact (EVfactura,EVestado,SNcodigo,CPTcodigo,EVObservacion,BMUsucodigo,Ecodigo,BMfecha)
							values(
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsDato.EDdocumento#">,
									#rsEstado.FTidEstado#,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDato.SNcodigo#">,	
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsDato.CPTcodigo#">,	
								<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,	
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">	
								)
						<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
					</cfquery>
					<cf_dbidentity2 datasource="#Session.DSN#" name="rsInsertaEventoA" verificar_transaccion="false" returnvariable="EVid">
					
					<cfquery datasource="#session.DSN#">
						update EDocumentosCxP
						set EVestado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstado.FTidEstado#">		
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						  and IDdocumento  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">			  
					</cfquery>
	
					<cfquery datasource="#session.DSN#">
						update HEDocumentosCP
						set EVestado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstado.FTidEstado#">		
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						  and IDdocumento  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">		  
					</cfquery>
			</cftransaction>
		</cfloop>
	</cfif>	

	<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
	<cfif isdefined("Form.IDdocumento") and len(trim(Form.IDdocumento))>
		<cfparam name="Form.chk" default="#Form.IDdocumento#">
	</cfif>
	<cfif isDefined("Form.chk")>
		<cfset chequeados = ListToArray(Form.chk)>
		<cfset cuantos = ArrayLen(chequeados)>

		<!--- mismo doc.recurrente en varias facturas --->
		<cfquery name="parametroRec" datasource="#session.DSN#">
			select coalesce(Pvalor, '1') as Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo=880
		</cfquery>

		<!--- mes auxiliar --->
		<cfquery name="mes" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 60
		</cfquery>
		<!--- periodo auxiliar --->
		<cfquery name="periodo" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 50
		</cfquery>
		<cfif len(trim(mes.pvalor)) and len(trim(periodo.pvalor))>
			<cfset fecha = createdate(periodo.pvalor, mes.pvalor , 1) >
			<cfset fechaaplic = createdate( periodo.pvalor, mes.pvalor, DaysInMonth(fecha) ) >
		</cfif>	

		<cfloop index="CountVar" from="1" to="#cuantos#">
			<cfset valores = ListToArray(chequeados[CountVar],"|")>
			
			<!--- Valida las garantias, si la factura lo requiere--->
			<cfinvoke component="conavi.Componentes.garantia" method="fnProcesarGarantias" returnvariable="LvarAccion"
				Ecodigo	= "#session.Ecodigo#"
				tipo 	= "C"
				ID		= "#valores[1]#"
			/>
			<cfif parametroRec.Pvalor neq 0>
				<cfquery name="recurrente" datasource="#session.DSN#">
					select IDdocumentorec
					from EDocumentosCxP
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores[1]#">			  
				</cfquery>
				<cfif len(trim(recurrente.IDdocumentorec))>
					<cfquery name="rsFechaUltima" datasource="#session.DSN#">
						select HEDfechaultaplic
						from HEDocumentosCP
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						  and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#recurrente.IDdocumentorec#">			  
					</cfquery>
					<cfif len(trim(rsFechaUltima.HEDfechaultaplic)) and datecompare(fechaaplic, rsFechaUltima.HEDfechaultaplic) lte 0>
						<cfset request.Error.backs = 1 >
						<cf_errorCode	code = "50344"
							msg  = "El documento no puede ser aplicado, pues ya existe un documento aplicado con el mismo documento recurrente para el mes @errorDat_1@ y período @errorDat_2@."
							errorDat_1="#month(fechaaplic)#"
							errorDat_2="#year(fechaaplic)#"
						>
					</cfif>
				</cfif>
			</cfif>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select 
					a.EDdocumento as Ddocumento, 
					b.DDcantidad, 
					round(b.DDtotallinea * a.EDtipocambio,2)	as TotalLineaUnitLocal,
					b.DOlinea 
				from EDocumentosCxP a
					inner join DDocumentosCxP b
					 on b.IDdocumento = a.IDdocumento
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				  and a.IDdocumento = #valores[1]#
				  and b.DDtipo = 'F' 
			</cfquery>
			<!--- ejecuta el proc.--->
			<cfinvoke component="sif.Componentes.CP_PosteoDocumentosCxP"
					  method="PosteoDocumento"
						IDdoc = "#valores[1]#"
						Ecodigo = "#Session.Ecodigo#"
						usuario = "#Session.usuario#"
						debug = "N"
			/>

			<!--- INTERFAZ --->
			<cfquery name="rsDatos" datasource="#Session.Dsn#">
				select CPTcodigo as CXTcodigo, EDdocumento as Ddocumento, SNcodigo
				from EDocumentosCxP
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores[1]#">		
			</cfquery>
			<cfset LobjInterfaz.fnProcesoNuevoSoin(110,"CXTcodigo=#rsDatos.CXTcodigo#&Ddocumento=#rsDatos.Ddocumento#&SNcodigo=#rsDatos.SNcodigo#&MODULO=CP","R")>

			<!--- modifica la ultima fecha de aplicacion --->
			<cfif parametroRec.Pvalor neq 0>
				<cfif len(trim(recurrente.IDdocumentorec))>
					<cfif isdefined("fechaaplic")>
						<cfquery datasource="#session.DSN#">
							update HEDocumentosCP
							set HEDfechaultaplic = <cfqueryparam cfsqltype="cf_sql_date" value="#fechaaplic#">
							where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
							  and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#recurrente.IDdocumentorec#">			  
						</cfquery>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
	</cfif>
		<cflocation addtoken="no" url="#root#?sqlDone=ok#params#">
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
			redirect="#root#"
			timestamp="#Form.timestampE#"
			field1="IDdocumento,numeric,#Form.IDdocumento#">
				
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
					<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">,
				</cfif>                    					                    
			Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
			Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">,
			EDusuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
			EDfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.EDfecha,'YYYY/MM/DD')#">,
			EDdocref = 
				<cfif isDefined("Form.EDdocref") and Trim(Form.EDdocref) NEQ "">
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDdocref#">,
				<cfelse>
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
				</cfif>				
			id_direccion =
				<cfif isdefined("form.id_direccion") and len(trim(form.id_direccion))>
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">,
				<cfelse>
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
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
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
			</cfif>
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">					  				
	 </cfquery>
</cffunction>

