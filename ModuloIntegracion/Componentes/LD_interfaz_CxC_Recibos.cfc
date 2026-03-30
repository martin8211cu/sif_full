<cfcomponent extends="Interfaz_Base">
	<cffunction name="Ejecuta" access="public" returntype="string" output="yes">
		<!--cfargument name="Disparo" required="no" type="boolean" default="true"-->

		<!---cfquery datasource="sifinterfaces" result="Rupdate">
			update ESIFLD_MovBancariosCxC
			set Estatus = 10
			where
			<cfif isdefined("Arguments.Disparo") and Arguments.Disparo>
				Estatus = 1
				and not exists (select 1 from ESIFLD_MovBancariosCxC where Estatus in (10, 11,94,92,99,100))
			<cfelse>
				Estatus = 99
				and not exists (select 1 from ESIFLD_MovBancariosCxC where Estatus in (10, 11))
			</cfif>
		</cfquery---->

		<!--- Marca Registros para proceso --->
		<cfquery datasource="sifinterfaces" result="Rupdate">
			update 	ESIFLD_MovBancariosCxC
				set 	Estatus = 10 <!---Marca el estatus 11 =  en Proceso para evitar bloqueos --->
			where 				
				Estatus = 1
				and not exists (select 1 from ESIFLD_MovBancariosCxC where Estatus in (10, 11,94,92,99,100))			
		</cfquery>
		<!--- Extrae Encabezados de Recibos --->
		<cfquery name="rsIDERecibos" datasource="sifinterfaces">
			select 	ID_DocumentoM
			from 	ESIFLD_MovBancariosCxC
			where Estatus = 10
		</cfquery>

		<cfif isdefined("rsIDERecibos") and rsIDERecibos.recordcount GT 0>			
			<cfloop query="rsIDERecibos">
				<cftry>
					<!--- Lee encabezados --->
					<cfset varBorraRegistro = false>
					<cfset Maximus = 0>

					<cfquery name="rsERecibo" datasource="sifinterfaces">
						SELECT 	ID_DocumentoM, Ecodigo, Banco_Origen, Cuenta_Origen, Tipo_Operacion, Tipo_Movimiento,
								Importe_Movimiento, Fecha_Recibo, Referencia, Documento, Descripcion, Origen, Sucursal,
								Moneda, coalesce(Tipo_Cambio,1) as Tipo_Cambio, TpoSocio,Cliente
						FROM 	ESIFLD_MovBancariosCxC
						WHERE 	ID_DocumentoM = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIDERecibos.ID_DocumentoM#">
					</cfquery>
					
					<cfset MovBancario = rsERecibo.ID_DocumentoM>					

					<!--- Marca inicio de proceso --->
					<cfquery datasource="sifinterfaces">
						update 	ESIFLD_MovBancariosCxC
						set 	Fecha_Inicio_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						where 	ID_DocumentoM = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ID_DocumentoM#">
					</cfquery>

					<!---BUSCA EQUIVALENCIAS--->
					<!--- EMPRESAS --->
					<cfset Equiv = ConversionEquivalencia (rsERecibo.Origen, 'CADENA', rsERecibo.Ecodigo, rsERecibo.Ecodigo, 'Cadena')>
					<cfset varEcodigo 	 = Equiv.EQUidSIF>
					<cfset varEcodigoSDC = Equiv.EQUcodigoSIF>
					<!--- VALIDACION PARA CLIENTE --->
					<cfset VarCte = ExtraeCliente(rsERecibo.Cliente, varEcodigo)>
					<!---cfset session.dsn = getConexion(varEcodigo)---->
					<cfset varCEcodigo = getCEcodigo(rsERecibo.Ecodigo)>
					<!--- MONEDA --->					
					<cfset Equiv = ConversionEquivalencia (rsERecibo.Origen, 'MONEDA', rsERecibo.Ecodigo, rsERecibo.Moneda, 'Moneda')>
					<cfset varMoneda = Equiv.EQUcodigoSIF>
					

					<!---Verifica si debe insertar encabezado o no --->
					<cfquery name="rsVerificaE" datasource="sifinterfaces">
						select 	ID
						from 	SIFLD_IE921
						where 	EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigoSDC#">
						and 	Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsERecibo.Documento)#">
						and 	Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">
					</cfquery>

	
						<cfset RsMaximo = ExtraeMaximo("IE921","ID")>
						<cfif isdefined("RsMaximo.Maximo") AND RsMaximo.Maximo gt 0>
							<cfset Maximus = RsMaximo.Maximo + 1>
						<cfelse>
							<cfset Maximus = 1>
						</cfif>
						<cfset varBorraRegistro = true>


					<!--- Equivalencia Centro Funcional ---
					<cfset ParCF = Parametros(Ecodigo=varEcodigo,Pcodigo=2,Sucursal=rsERecibo.Sucursal,Parametro="Equivalencia Centro Funcional",ExtBusqueda=true, Sistema = rsERecibo.Origen)--->

					<!--- Obtiene los parametros ---
					<cfset ParOfic = Parametros(Ecodigo=varEcodigo,Pcodigo=1,Sucursal=rsERecibo.Sucursal,Parametro="Equivalencia Oficina",ExtBusqueda=true, Sistema = rsERecibo.Origen)>

					--- Oficina ---
					<cfif ParOfic>
						---OFICINA 
						<cfset Equiv = ConversionEquivalencia (rsERecibo.Origen, 'SUCURSAL', rsERecibo.Ecodigo, rsERecibo.Sucursal, 'Sucursal')>
						<cfset VarOcodigo = Equiv.EQUidSIF>
						<cfset VarOficina = Equiv.EQUcodigoSIF>
					<cfelse>
						 <cfset VarOficina = rsERecibo.Sucursal>
						 <cfquery name="rsOFid" datasource="#session.dsn#">
							select Ocodigo
							from Oficinas
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
							and Oficodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#VarOficina#">
						 </cfquery>
						 <cfif isdefined("rsOFid") and rsOFid.recordcount GT 0>
							<cfset VarOcodigo = rsOFid.Ocodigo>
						 </cfif>
					</cfif>					
								---->


					<!--- Borrar Registro 
					<cfset ParBorrado = Parametros(Ecodigo=varEcodigo,Pcodigo=4,Sucursal=rsERecibo.Sucursal,Parametro="Borrar Registros",ExtBusqueda=true, Sistema = rsERecibo.Origen)>--->


					<!--- Obtiene el usuario de Interfaz --->
					<cfset Usuario = UInterfaz (getCEcodigo(varEcodigo))> 
					<cfset varUlogin = Usuario.Usulogin>
					<cfset varUcodigo = Usuario.Usucodigo>


					<!--- Busca Tipo de Transaccion bancaria en Minisif --->
					<cfquery name="BuscaTipoTran" datasource="#session.dsn#">
						select 	b.BTcodigo
						from 	BTransacciones b							
						where 	Ecodigo = #varEcodigo# 
						and BTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsERecibo.Tipo_Operacion#">
					</cfquery>

					<cfif isdefined("BuscaTipoTran") and BuscaTipoTran.recordcount EQ 1>
						<cfset TTranBD = #BuscaTipoTran.BTcodigo#> <!--- Transaccion Origen --->
					<cfelse>
						<cfthrow message="La transaccion #rsERecibo.Tipo_Operacion# no existe">
					</cfif>	
					<!----BUSCA SI EL BANCO EXISTE ---->
					<cfquery name="rsCta_Banco" datasource="#session.dsn#">
							select 	CBcodigo, Iaba
							from 	CuentasBancos c
								inner join 	Bancos b
								on 	c.Ecodigo = b.Ecodigo
								and c.Bid = b.Bid
							where 	c.CBcc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsERecibo.Cuenta_Origen#">
							and 	c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
						</cfquery>


					<!--- Inserta Encabezado --->
					<cfif rsVerificaE.recordcount eq 0>
					<cfquery datasource="sifinterfaces">
								insert into SIFLD_IE921
										(ID, EcodigoSDC, Origen, Tipo_Operacion, Tipo_Movimiento,
										Documento, Referencia, Descripcion_Mov, Importe_Total_Mov,
										Banco_Origen, Cuenta_Origen, Moneda, Tipo_Cambio, Fecha_Mov,
										Estatus, CEcodigo, Usulogin, Usucodigo,Interfaz,NumeroSocio)
								values
								(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigoSDC#">,
								 'LDCOM',
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#TTranBD#">,
								 'D', <!---Deposito--->
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsERecibo.Documento#">,								
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsERecibo.Referencia#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsERecibo.Descripcion#">,
								 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsERecibo.Importe_Movimiento,'9.99')#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsERecibo.Banco_Origen#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsERecibo.Cuenta_Origen#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsERecibo.Tipo_Cambio#">,
								 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsERecibo.Fecha_Recibo,"yyyy/mm/dd")#">,
								 1,
								 <cfqueryparam cfsqltype ="cf_sql_numeric" value="#varCEcodigo#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varUlogin#">,
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varUcodigo#">,
								  <cfqueryparam cfsqltype="cf_sql_varchar" value="CG_RecibosCxC">,
								  '#rsERecibo.Cliente#')
					</cfquery>		
					</cfif>

					<cfquery datasource="sifinterfaces">						
							update 	ESIFLD_MovBancariosCxC
							set 	Estatus = 92,
									ID921 = #Maximus#,
									Fecha_Fin_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
							where 	ID_DocumentoM = #MovBancario#						
					</cfquery>

				<cfcatch type="any">
					<!--- Marca El registro con Error--->
					<cfquery datasource="sifinterfaces">
						update 	ESIFLD_MovBancariosCxC
						set 	Estatus = 3,
								Fecha_Fin_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						where 	ID_DocumentoM = #rsERecibo.ID_DocumentoM#
					</cfquery>

					<!--- Elimina Registros Insertados. --->					
						<cfif isdefined("Maximus") and Maximus NEQ 0>
							<cfquery datasource="sifinterfaces">
								delete SIFLD_IE921
								where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
							</cfquery>
						</cfif>					

					<cfif isdefined("cfcatch.Message")>
						<cfset Mensaje="#cfcatch.Message#">
					<cfelse>
						<cfset Mensaje="">
					</cfif>
					<cfif isdefined("cfcatch.Detail")>
						<cfset Detalle="#cfcatch.Detail#">
					<cfelse>
						<cfset Detalle="">
					</cfif>
					<cfif isdefined("cfcatch.sql")>
						<cfset SQL="#cfcatch.sql#">
					<cfelse>
						<cfset SQL="">
					</cfif>
					<cfif isdefined("cfcatch.where")>
						<cfset PARAM="#cfcatch.where#">
					<cfelse>
						<cfset PARAM="">
					</cfif>
					<cfif isdefined("cfcatch.StackTrace")>
						<cfset PILA="#cfcatch.StackTrace#">
					<cfelse>
						<cfset PILA="">
					</cfif>
					<cfset MensajeError= #Mensaje# & #Detalle#>
					<cfquery datasource="sifinterfaces">
						insert into SIFLD_Errores
						(Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam, MsgErrorPila, Ecodigo)
						values
						('CG_RecibosCxC',
						 'ESIFLD_MovBancariosCxC',
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsERecibo.ID_DocumentoM#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsERecibo.Ecodigo#">)
					</cfquery>
				</cfcatch>
				</cftry>
			</cfloop> <!--- Encabezado de Ventas --->
		</cfif>
			<cfquery name="rsVerifica" datasource="sifinterfaces">
				select 	count(1) as Registros from ESIFLD_MovBancariosCxC
				where 	Estatus in (92,10)
			</cfquery>

			<cfif rsVerifica.Registros gt 0>			
				<!---Se Dispara la Interfaz de forma Masiva--->
				<cftransaction action="begin">
				<cftry>					
					<!---Prepara los registros para ser insertados--->
					<cfquery datasource="sifinterfaces">
						update 	SIFLD_IE921
						set 	Interfaz = 'CG_RecibosCxC', Estatus = 1
					</cfquery>

					<cfquery datasource="sifinterfaces">
						insert into IE921
							(ID, EcodigoSDC, Origen, Tipo_Operacion, Tipo_Movimiento,
							Documento, Referencia, Descripcion_Mov, Importe_Total_Mov,
							Banco_Origen, Cuenta_Origen, Moneda, Tipo_Cambio, Fecha_Mov,
							Estatus,NumeroSocio,Usulogin,Usucodigo)
						 select a.ID, a.EcodigoSDC, a.Origen, a.Tipo_Operacion, a.Tipo_Movimiento,
							a.Documento, a.Referencia, a.Descripcion_Mov, a.Importe_Total_Mov,
							a.Banco_Origen, a.Cuenta_Origen, a.Moneda, a.Tipo_Cambio, a.Fecha_Mov,
							a.Estatus,a.NumeroSocio,a.Usulogin,a.Usucodigo
						 from SIFLD_IE921 a
						 where Interfaz = 'CG_RecibosCxC' and Estatus = 1
					</cfquery>


					<cfquery datasource="sifinterfaces">
						insert into InterfazColaProcesos (
							CEcodigo, NumeroInterfaz, IdProceso, SecReproceso,
							EcodigoSDC, OrigenInterfaz, TipoProcesamiento, StatusProceso,
							FechaInclusion, Cancelar, UsucodigoInclusion, UsuarioBdInclusion)
						select
							a.CEcodigo,
							921,
							ID,
							0 as SecReproceso,
							a.EcodigoSDC,
							'E' as OrigenInterfaz,
							'A' as TipoProcesamiento,
							1 as StatusProceso,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							0 as Cancelar,
							a.Usucodigo,
							a.Usulogin
						from SIFLD_IE921 a
						where Interfaz = 'CG_RecibosCxC' and Estatus = 1
					</cfquery>

					<cfquery datasource="sifinterfaces">
						update ESIFLD_MovBancariosCxC
							set Estatus = 2
						where Estatus in (92)
						and ID921 in (select ID from SIFLD_IE921
										where Interfaz = 'CG_RecibosCxC' and Estatus = 1)
					</cfquery>

					<cftransaction action="commit" />
				<cfcatch>
					<cftransaction action="rollback" />
					<cfif isdefined("cfcatch.Message")>
						<cfset Mensaje="#cfcatch.Message#">
					<cfelse>
						<cfset Mensaje="">
					</cfif>
					<cfif isdefined("cfcatch.Detail")>
						<cfset Detalle="#cfcatch.Detail#">
					<cfelse>
						<cfset Detalle="">
					</cfif>
					<cfif isdefined("cfcatch.sql")>
						<cfset SQL="#cfcatch.sql#">
					<cfelse>
						<cfset SQL="">
					</cfif>
					<cfif isdefined("cfcatch.where")>
						<cfset PARAM="#cfcatch.where#">
					<cfelse>
						<cfset PARAM="">
					</cfif>
					<cfif isdefined("cfcatch.StackTrace")>
						<cfset PILA="#cfcatch.StackTrace#">
					<cfelse>
						<cfset PILA="">
					</cfif>
					<cfset MensajeError= #Mensaje# & #Detalle#>
					<cfquery datasource="sifinterfaces">
						insert into SIFLD_Errores
									(Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL,
									MsgErrorParam, MsgErrorPila, Ecodigo, Usuario)
						select 'CG_RecibosCxC', 'ESIFLD_MovBancariosCxC', ID_DocumentoM
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,
								Ecodigo,
								Usuario
						from 	ESIFLD_MovBancariosCxC
					</cfquery>
					<cfquery datasource="sifinterfaces">
						update 	ESIFLD_MovBancariosCxC set Estatus = 3
						where 	Estatus in (92)
						and 	ID921 in (select ID from SIFLD_IE921
										where Interfaz = 'CG_RecibosCxC' and Estatus = 1)
					</cfquery>
				</cfcatch>
				</cftry>
				</cftransaction>

				<cfquery datasource="sifinterfaces">
					delete SIFLD_IE921					
				</cfquery>
			
		</cfif>
	</cffunction>
	
</cfcomponent>