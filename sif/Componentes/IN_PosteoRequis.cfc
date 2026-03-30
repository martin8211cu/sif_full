<cfcomponent>
	<cffunction name="IN_PosteoRequis" access="public" returntype="boolean">
		<cfargument name="ERid"			required="true"		type="numeric"	hint="Id de Requisición">
		<cfargument name="Conexion"		required="false"	type="string"	hint="Datasource">
		<cfargument name="Ecodigo"		required="false"	type="numeric"	hint="Empresa">
		<cfargument name="Usucodigo"	required="false"	type="numeric"	hint="Usuario">
		<cfargument name="Debug" 		required="false"	type="boolean"	default="false" hint="Debug"   >
		<cfargument name="RollBack"		required="false"	type="boolean"	default="false" hint="RollBack"   >
        <cfargument name="Intercompany"	required="false"	type="boolean"	default="false" hint="Intercompany"   >
       
		<!--- Defaults para parámetros. No se pusieron en el cfargument porque cuando vienen porque no hay session, siempre ejecuta la sentencia del default y se cae. --->
		<cfif (not isdefined("Arguments.Conexion"))>
			<cfset Arguments.Conexion = Session.Dsn>
		</cfif>
		<cfif (not isdefined("Arguments.Ecodigo"))>
			<cfset Arguments.Ecodigo = Session.Ecodigo>
		</cfif>
		<cfif (not isdefined("Arguments.Usucodigo"))>
			<cfset Arguments.Usucodigo = Session.Usucodigo>
		</cfif>
        
        <!--- Valida si es intercompañia --->
        <cfquery name="rsEsInter" datasource="#Arguments.Conexion#">
            select count(1) as cantidad
            from ERequisicion 
            where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
            and EcodigoRequi != Ecodigo
        </cfquery>
        <cfif rsEsInter.cantidad eq 0 and Arguments.Intercompany>
        	<cfthrow message="La requisición no es de tipo intercompañia">
        </cfif>
		
		<!----Obtiene parametro 'Activar Transaccionabilidad de Actividad Empresarial'----->
		<cfquery name="rsParTransaActEmpr" datasource="#session.DSN#">
			select Pvalor 
			from Parametros 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
				and Pcodigo = 2200
		</cfquery>
		
		<!--- Crea tablas temporales requeridas --->
		
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento"	method="CreaIntarc" 				returnvariable="INTARC"/>
		<cfinvoke component="sif.Componentes.IN_PosteoLin" 		method="CreaIdKardex"  				returnvariable="IDKARDEX"/>
		<cfinvoke component="sif.Componentes.PRES_Presupuesto"	method="CreaTablaIntPresupuesto" 	returnvariable="INT_PRES"/>
		
		<!--- Inicio *** --->
        <cfinclude template="../Utiles/sifConcat.cfm">
			
			<!--- 1 Validaciones --->
			<!--- 1.1 Validación de integridad de Requisición --->
			<cfquery name="rs" datasource="#Arguments.Conexion#">
				select 1 from ERequisicion where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfquery>
			<cfif rs.recordcount eq 0>
				<cf_errorCode	code = "51219" msg = "Error en IN_PosteoRequis. No existe la Requisición. Proceso Cancelado!">
			</cfif>
			<cfquery name="rs" datasource="#Arguments.Conexion#">
				select 1 from DRequisicion where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
			</cfquery>
			<cfif rs.recordcount eq 0>
				<cf_errorCode	code = "51220" msg = "Error en IN_PosteoRequis. La Requisición no tiene líneas de detalle. Proceso Cancelado!">
			</cfif>

			<!---Se salva el Ecodigo requi--->
			<cfquery name="rsEcodigoRequi" datasource="#Arguments.Conexion#">
				select EcodigoRequi from ERequisicion where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfquery>
            
            <cfset LvarEcodigoRequi = rsEcodigoRequi.EcodigoRequi>

			<!--- 2 Definiciones --->
			<!--- 2.1 Requisicion y Detalles --->
			<cfquery datasource="#Arguments.Conexion#">
				update ERequisicion
				   set EcodigoRequi = Ecodigo
				 where ERid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
				   and Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				   and EcodigoRequi is null
			</cfquery>
			<cfquery datasource="#Arguments.Conexion#">
				delete from DRequisicion
				where ERid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
				  and DRcantidad = 0
			</cfquery>
			<cfquery name="rsEDRequi" datasource="#Arguments.Conexion#">
				select a.Aid as Alm_Aid, a.ERdocumento, a.Dcodigo, a.Ocodigo, a.TRcodigo, a.ERFecha, 
		            b.DRlinea, b.Aid, b.DRcantidad, b.DRcosto, b.DSlinea, a.EcodigoRequi, coalesce(b.CFid, 0) as CFid, a.ERidref, b.Kid, coalesce(b.FPAEid,-1) as FPAEid, coalesce(b.CFComplemento,'') as CFComplemento, 
                    coalesce(b.CFcuenta, -1) as CFcuenta
				from ERequisicion a 
					inner join DRequisicion b 
						on a.ERid = b.ERid
				where a.ERid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
				  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfquery>

			<!--- 2.2 Periodo de Auxiliares --->
			<cfquery name="rsPeriodo" datasource="#Arguments.Conexion#">
				select Pvalor as periodo from Parametros where Pcodigo = 50
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfquery>
			<cfif rs.recordcount eq 0>
				<cf_errorCode	code = "51221" msg = "Error en IN_PosteoRequis. No se ha definido el Periodo de Auxiliares. Proceso Cancelado!">
			</cfif>

			<!--- 2.3 Mes de Auxiliares --->
			<cfquery name="rsMes" datasource="#Arguments.Conexion#">
				select Pvalor as mes from Parametros where Pcodigo = 60
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfquery>
			<cfif rs.recordcount eq 0>
				<cf_errorCode	code = "51222" msg = "Error en IN_PosteoRequis. No se ha definido el Mes de Auxiliares. Proceso Cancelado!">
			</cfif>

			<!--- 2.4 Moneda Local --->
			<cfquery name="rsMonLoc" datasource="#Arguments.Conexion#">
				select Mcodigo as monloc from Empresas where 
				Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfquery>
						
			<!--- 2.5 Plan de Compras --->
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select Pvalor
				  from Parametros
				 where Ecodigo = #Arguments.Ecodigo#
				   and Pcodigo = 2300
			</cfquery>
			<cfset LvarPlanComprasActivo = (rsSQL.Pvalor EQ '1')>
			<cfif LvarPlanComprasActivo>
				<cfset request.CP_Automatico = true>
			</cfif>
            
			<!--- 2.6 Complemento del Socio por Default --->
			<cfquery name="rsComplSD" datasource="#Arguments.Conexion#">
				select Pvalor
				  from Parametros
				 where Ecodigo = #Arguments.Ecodigo#
				   and Pcodigo = 1370
   			</cfquery>
            
			<!--- 2.7 Construcción de Cuentas para Consumo de Inventarios --->
			<cfquery name="rsCtaConsInv" datasource="#Arguments.Conexion#">
				select Pvalor
				  from Parametros
				 where Ecodigo = #Arguments.Ecodigo#
				   and Pcodigo = 892
   			</cfquery>
            <cfif rsCtaConsInv.Pvalor eq '2' and len(rsComplSD.Pvalor) eq 0>
            	<cfthrow message="No está definido el Complemento del Socio por Default">
            </cfif>
            

			<!--- Debug: Antes de las operaciones --->
			<cfif Arguments.Debug>
				<cfdump var="#Arguments#" label="Argumentos antes de las operaciones">
			</cfif>
			
            <!---►►Valida las Cuentas Financieras en las que se envio el CFcuenta◄◄--->
            <cfquery name="rsError" datasource="#Arguments.Conexion#">
				select count(1) cantidad
				from ERequisicion er
					inner join DRequisicion dr
						on er.ERid = dr.ERid
				where er.ERid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
                  and dr.CFcuenta is not null
                  and (select count(1) from CFinanciera where CFcuenta = dr.CFcuenta) =  0
			</cfquery>
            <cfif rsError.cantidad GT 0>
            	<cfthrow message="Existen lineas de la requisicion, que se especificaron cuentas Invalidas">
            </cfif>
            
			<!---►►Creación de Cuentas del detalle, en las que no se envio el CFcuenta◄◄--->
			<cfquery name="rsCuentas" datasource="#Arguments.Conexion#">
				select aa.ERFecha, a.DRlinea, coalesce(b.CFcuentainventario,b.CFcuentac) as cuenta, d.cuentac, a.CFComplemento as cfcomplemento, a.DSlinea,aa.TRcodigo, d.Cformato, b.CFComplementoCtaGastoCS
				from ERequisicion aa
					inner join DRequisicion a
						on a.ERid = aa.ERid
                        
					inner join CFuncional b
						on b.CFid = a.CFid
                        
					inner join Articulos c
						on c.Aid = a.Aid
					inner join Clasificaciones d
						on d.Ccodigo = c.Ccodigo
						and d.Ecodigo = c.Ecodigo
				where aa.ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
                  and a.CFcuenta is null
			</cfquery>
            
            <cfset LvarFormatoCuenta ="">
            <cfquery name="rsTRcodigo" datasource="#Arguments.Conexion#">
            	select TRcodigo from ERequisicion 
                where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
            </cfquery>
            <cfquery name="rsctafinanciera" datasource="#Arguments.Conexion#">
                select cf.CFformato from CTipoRequisicion ctr
                inner join CFinanciera cf
                on cf.Ecodigo=ctr.Ecodigo and ctr.CFcuenta = cf.CFcuenta  
                where ctr.TRcodigo='#rsTRcodigo.TRcodigo#'
            </cfquery>
            <cfif len(rsctafinanciera.CFformato) gt 0>
                <cfset LvarFormatoCuenta =#rsctafinanciera.CFformato#>
            </cfif>
			<cfobject component="sif.Componentes.AplicarMascara" name="mascara">

			<cfloop query="rsCuentas">
				<!--- Obtener Cuenta --->
				<cfif Arguments.Debug>
					<cfoutput>Obteniendo: #rsCuentas.cuenta#-#rsCuentas.cuentac#...<br></cfoutput>
				</cfif>
                
				<cfif rsParTransaActEmpr.Pvalor EQ 'S'>
                    <cfset LvarFormatoCuenta = mascara.AplicarMascara(mascara.AplicarMascara(rsCuentas.cuenta,rsCuentas.cuentac),REReplace(rsCuentas.cfcomplemento,"-","","ALL"), '_')>
                <cfelse>
                    <cfif LvarFormatoCuenta eq ''>  						<!---Formato definido en Cuenta por Tipo de Requisición--->
                        <cfset LvarFormatoCuenta = mascara.AplicarMascara(rsCuentas.cuenta,rsCuentas.cuentac)> <!---Formato default--->
                        <cfif rsCtaConsInv.Pvalor eq '2' and len(rsComplSD.Pvalor) gt 0>
                        	<cfset LvarFormatoCuenta = mascara.AplicarMascara(rsCuentas.CFormato,rsCuentas.CFComplementoCtaGastoCS,"!")>
                            
                        	<cfset LvarFormatoCuenta = mascara.AplicarMascara(LvarFormatoCuenta,rsComplSD.Pvalor,"?")>
                        </cfif>
                        
                    </cfif>	
                </cfif>
                
				<cftransaction>
                        <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
                                <cfinvokeargument name="Lprm_CFformato" 		value="#LvarFormatoCuenta#"/>
                                <cfinvokeargument name="Lprm_fecha" 			value="#rsCuentas.ERFecha#"/>
                                <cfinvokeargument name="Lprm_TransaccionActiva" value="yes"/>
                        </cfinvoke>
					<cfif rsEDRequi.EcodigoRequi NEQ Arguments.Ecodigo>
						<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
                                <cfinvokeargument name="Lprm_CFformato" 		value="#LvarFormatoCuenta#"/>
                                <cfinvokeargument name="Lprm_fecha" 			value="#rsCuentas.ERFecha#"/>
                                <cfinvokeargument name="Lprm_Ecodigo" 			value="#rsEDRequi.EcodigoRequi#"/>
                                <cfinvokeargument name="Lprm_TransaccionActiva" value="yes"/>
						</cfinvoke>
					</cfif>
				</cftransaction>
				<cfif LvarError neq 'NEW' and LvarError neq 'OLD'>
					<cf_errorCode	code = "50314"
									msg  = "@errorDat_1@ [@errorDat_2@]"
									errorDat_1="#LvarError#"
									errorDat_2="#LvarFormatoCuenta#"
					>
				<cfelse>
					<!--- trae el id de la cuenta financiera --->
					<cfquery name="rsTraeCuenta" datasource="#Arguments.Conexion#">
						select CFcuenta
						from CFinanciera a
                        	inner join CPVigencia b
                            	on b.CPVid = a.CPVid
						where a.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEDRequi.EcodigoRequi#">
						  and a.CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarFormatoCuenta#">
						  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsCuentas.ERFecha#"> between b.CPVdesde and b.CPVhasta
					</cfquery>
					<cfset LvarCuentaFinanciera = rsTraeCuenta.CFcuenta>
					<cfif Len(Trim(LvarCuentaFinanciera))>
						<cfquery name="updateSolicitud" datasource="#Arguments.Conexion#">
							update DRequisicion
							set CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCuentaFinanciera#">
							where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
							and DRlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentas.DRlinea#">
						</cfquery>
					<cfelse>
						<cf_errorCode	code = "51223"
										msg  = "No se pudo obtener correctamente la cuenta financiera para la linea @errorDat_1@ de la Requición."
										errorDat_1="#rsCuentas.DRlinea#"
						>
					</cfif>
				</cfif>
            	<cfset LvarFormatoCuenta ="">
			</cfloop>

			<cfquery name="rsError" datasource="#Arguments.Conexion#">
				select 1 
				from DRequisicion
				where CFcuenta is null
				and ERid    = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
			</cfquery>
			<cfif rsError.recordcount>
				<cf_errorCode	code = "51224" msg = "No se pudo generar todas las cuentas contables de la Requisición. Proceso Cancelado!">
			</cfif>
			
            <!---►►Obtencion de los datos de la requisicion, ya con las cuentas Actualizadas◄◄--->
            <cfquery name="rsEDRequi" datasource="#Arguments.Conexion#">
				select a.Aid as Alm_Aid, a.ERdocumento, a.Dcodigo, a.Ocodigo, a.TRcodigo, a.ERFecha, 
		            b.DRlinea, b.Aid, b.DRcantidad, b.DRcosto, b.DSlinea, a.EcodigoRequi, coalesce(b.CFid, 0) as CFid, a.ERidref, b.Kid, coalesce(b.FPAEid,-1) as FPAEid, coalesce(b.CFComplemento,'') as CFComplemento, 
                    coalesce(b.CFcuenta, -1) as CFcuenta,
					t.TRreversaCreditoFiscal
				from ERequisicion a 
					inner join DRequisicion b 
						on a.ERid = b.ERid
					left join TRequisicion t
						 on t.Ecodigo	= a.Ecodigo
						and t.TRcodigo	= a.TRcodigo
				where a.ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
			</cfquery>
            
			<!--- 3 Operaciones --->
			<cftransaction>
				<cfoutput query="rsEDRequi">
					<!--- 3.0 Valida integridad de algunos datos --->
					<cfif (len(rsEDRequi.ERFecha) EQ 0)><cfset QuerySetCell(rsEDRequi,"ERFecha",CreateDate(Year(Now()),Month(Now()),Day(Now())))></cfif>

					<!--- 3.1 Actualizar la cantidad surtida por línea de solicitud --->
					<cfif len(rsEDRequi.DSlinea) GT 0>
						<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
							select DScant - DScantsurt as DSnoSurtido
							  from DSolicitudCompraCM 
							 where DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEDRequi.DSlinea#">
							   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
						</cfquery>
						<cfif rsSQL.recordCount NEQ 0>
							<cfif rsSQL.DSnoSurtido LT rsEDRequi.DRcantidad>
								<cfthrow message="La cantidad requisada (#rsEDRequi.DRcantidad#) es mayor a la cantidad no surtida de la Solicitud de Compra (#rsSQL.DSnoSurtido#)">
							</cfif>
							<cfquery datasource="#Arguments.Conexion#">
								update DSolicitudCompraCM set DScantsurt = coalesce(DScantsurt,0.00) + <cfqueryparam cfsqltype="cf_sql_money" value="#rsEDRequi.DRcantidad#"> 
								 where DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEDRequi.DSlinea#">
								   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
							</cfquery>
						</cfif>
					</cfif>

					<!--- 3.2 Obtener Información del Artículo --->
					<cfquery name="rsArticulo" datasource="#Arguments.Conexion#">
						select Aid as id, Acodigo as codigo, Adescripcion as descripcion from Articulos where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEDRequi.Aid#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					</cfquery>

					<!--- 3.3 Información del Almacén --->
					<cfquery name="rsAlmacen" datasource="#Arguments.Conexion#">
						select Aid as id, Almcodigo as codigo, Bdescripcion as descripcion from Almacen where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEDRequi.Alm_Aid#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					</cfquery>

					<!--- 3.4 Obtener existencias y costos del Artículo Antes del Movimiento --->
					<cfquery name="rsAntes" datasource="#Arguments.Conexion#">
						select coalesce(Eexistencia,0) as Eexistencia
						from Existencias where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEDRequi.Aid#">
						and Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEDRequi.Alm_Aid#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					</cfquery>
					<cfif rsAntes.recordcount EQ 0>
						<cf_errorCode	code = "51225"
										msg  = "Error en IN_PosteoRequis. No existen existencias para al Artículo @errorDat_1@ - @errorDat_2@ en el Almacén @errorDat_3@ - @errorDat_4@. Proceso Cancelado!"
										errorDat_1="#rsArticulo.codigo#"
										errorDat_2="#rsArticulo.descripcion#"
										errorDat_3="#rsAlmacen.codigo#"
										errorDat_4="#rsAlmacen.descripcion#"
						>
					</cfif>

					<!--- 3.5 Obtener existencias y costos del Artículo después del movimiento --->
					<cfquery name="rsDespues" datasource="#Arguments.Conexion#">
						select round(coalesce(Eexistencia-<cfqueryparam cfsqltype="cf_sql_money" value="#rsEDRequi.DRcantidad#">,0),6) as Eexistencia
						from Existencias where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEDRequi.Aid#">
						and Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEDRequi.Alm_Aid#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					</cfquery>
                    
                    <!---►►No existan Existencias y que no sea una requisicion de Devolucion◄◄--->
					<cfif rsDespues.Eexistencia LT 0 and NOT (len(trim(rsEDRequi.ERidref)) and len(trim(rsEDRequi.Kid)))>
						<cf_errorCode	code = "51226"
										msg  = "Error en IN_PosteoRequis. Las existencias quedarán negativas para al Artículo @errorDat_1@ - @errorDat_2@ en el Almacén @errorDat_3@ - @errorDat_4@. Proceso Cancelado!"
										errorDat_1="#rsArticulo.codigo#"
										errorDat_2="#rsArticulo.descripcion#"
										errorDat_3="#rsAlmacen.codigo#"
										errorDat_4="#rsAlmacen.descripcion#"
						>
					</cfif>

					<!--- REQUISICION DE DEVOLUCION --->
					<!--- 	Si la requisicion es de devolucion, se debe validar que la cantidad del articulo digitada en la requis., sea igual o menor
							a la cantidad de la requis de referencia (o sea al Kunidades de la tabla Kardex, donde el ERid es el de la requis de referencia)	
					 --->
					<cfset vObtener			= true>
					<cfset vCantidad 		= rsEDRequi.DRcantidad>
					<cfset vMcodigoOrigen	= -1 >
					<cfset vCostoOrigen		= 0 >
					<cfset vCostoLocal		= 0 >
					<cfif len(trim(rsEDRequi.ERidref)) and len(trim(rsEDRequi.Kid))>
					 	<cfquery name="rsUnidades" datasource="#Arguments.Conexion#">
							select coalesce(abs(Kunidades), 0) as Kunidades, 
									Kcosto,
									KcostoLocal,
									KcostoOrigen,
									McodigoOrigen
							from Kardex
							where Kid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEDRequi.Kid#">
						</cfquery>
												
						<cfif rsEDRequi.DRcantidad gt rsUnidades.Kunidades>
							<cf_errorCode	code = "51227"
											msg  = "La cantidad del artículo @errorDat_1@ - @errorDat_2@ (@errorDat_3@), no puede ser mayor a la cantidad de la requisición de referencia(@errorDat_4@)."
											errorDat_1="#trim(rsArticulo.codigo)#"
											errorDat_2="#rsArticulo.descripcion#"
											errorDat_3="#rsEDRequi.DRcantidad#"
											errorDat_4="#rsUnidades.Kunidades#"
							>
						</cfif>
						<cfset vCantidad = vCantidad * -1>
						
						<!--- 	Calculo del costo de la linea de devolucion
								Este calculo es de la siguiente forma:
									(Costo Kardex/Unidades Kardex)*Unidades Requi
						--->
						<cfif len(trim(rsUnidades.Kunidades))>
							<cfset vObtener			= false>
							<cfset vCostoValuacion	= (rsUnidades.Kcosto/rsUnidades.Kunidades)*rsEDRequi.DRcantidad >

							<cfset vMcodigoOrigen	= rsUnidades.McodigoOrigen >
							<cfset vCostoOrigen		= (rsUnidades.KcostoOrigen/rsUnidades.Kunidades)*rsEDRequi.DRcantidad >
							<cfset vCostoLocal		= (rsUnidades.KcostoLocal/rsUnidades.Kunidades)*rsEDRequi.DRcantidad >
						</cfif>
					</cfif>

					<!--- 3.6 Ejecuta el PosteoLin para la requisición --->
					<cfinvoke component="sif.Componentes.IN_PosteoLin" method="IN_PosteoLin" returnvariable="LvarCOSTOS">
                            <cfinvokeargument name="Aid" 			value="#rsEDRequi.Aid#">
                            <cfinvokeargument name="Alm_Aid" 		value="#rsEDRequi.Alm_Aid#">
                            <cfinvokeargument name="Tipo_Mov" 		value="R">
                            <cfinvokeargument name="Cantidad" 		value="#vCantidad#">

							<cfinvokeargument name="ObtenerCosto" 	value="#vObtener#">
							<cfinvokeargument name="McodigoOrigen" 	value="#vMcodigoOrigen#">
							<cfinvokeargument name="CostoOrigen" 	value="#vCostoOrigen#">
							<cfinvokeargument name="CostoLocal" 	value="#vCostoLocal#">

							<cfinvokeargument name="Tipo_ES" 		value="S">
							<cfinvokeargument name="Dcodigo" 		value="#rsEDRequi.Dcodigo#">
							<cfinvokeargument name="Ocodigo" 		value="#rsEDRequi.Ocodigo#">
							<cfinvokeargument name="TipoCambio" 	value="1">
							<cfinvokeargument name="Documento" 		value="#rsEDRequi.ERdocumento#">
							<cfinvokeargument name="FechaDoc" 		value="#rsEDRequi.ERFecha#">
							<cfinvokeargument name="Referencia" 	value="#rsEDRequi.TRcodigo#">
							<cfinvokeargument name="ERid" 			value="#Arguments.ERid#">
							<cfinvokeargument name="CFid" 			value="#rsEDRequi.CFid#">
							<cfinvokeargument name="Conexion" 		value="#Arguments.Conexion#">
							<cfinvokeargument name="Ecodigo" 		value="#Arguments.Ecodigo#">
							<cfinvokeargument name="EcodigoRequi" 	value="#LvarEcodigoRequi#">		
							<cfinvokeargument name="Debug" 			value="false">
							<cfinvokeargument name="RollBack" 		value="#Arguments.RollBack#">
						
							<cfinvokeargument name="transaccionactiva" value="true">
							<cfinvokeargument name="FPAEid" 		value="#rsEDRequi.FPAEid#">
							<cfinvokeargument name="CFComplemento" 	value="#rsEDRequi.CFComplemento#">
                            <cfinvokeargument name="Usucodigo"         		value="#session.Usucodigo#"><!--- Usuario --->
                        <cfif isdefined('rsEDRequi.DSlinea') and LEN(TRIM(rsEDRequi.DSlinea))>
                       		<cfinvokeargument name="DSlinea" 		value="#rsEDRequi.DSlinea#">
                        </cfif>
                        	<cfinvokeargument name="CFcuenta" 		value="#rsEDRequi.CFcuenta#">
					</cfinvoke>
					<!--- 3.7 El costo de la Requisicion viene negativo cuando es salida, se invierte para efectos del asiento --->
					<cfset LvarCOSTOS.VALUACION.Costo 	= -(LvarCOSTOS.VALUACION.Costo)>
					<cfset LvarCOSTOS.LOCAL.Costo 		= -(LvarCOSTOS.LOCAL.Costo)>
					
					<!--- 3.9 Afectación de la Cuenta de Inventario en el asiento contable --->
					<cfquery datasource="#Arguments.Conexion#">
						INSERT INTO #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo, 
												Mcodigo, INTMOE, INTCAM, INTMON,CFid
											  )
						select 'INRQ'
								, 1 
								, <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#rsEDRequi.ERdocumento#">
								, <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.ERid#">
								, 'C'
								, <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsArticulo.codigo# - #rsArticulo.descripcion#" len="80">
								, <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#DateFormat(rsEDRequi.ERFecha,'yyyymmdd')#">
								, <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsPeriodo.periodo#">
								, <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsMes.mes#">
								, c.IACinventario
								, al.Ocodigo

								, <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#LvarCOSTOS.VALUACION.Mcodigo#">
								, <cf_jdbcquery_param cfsqltype="cf_sql_float"	value="#LvarCOSTOS.VALUACION.Costo#">
								, <cf_jdbcquery_param cfsqltype="cf_sql_money"	value="#LvarCOSTOS.VALUACION.TC#">  
								, <cf_jdbcquery_param cfsqltype="cf_sql_money"	value="#LvarCOSTOS.LOCAL.Costo#">
                                ,a.CFid
						from DRequisicion a 
						
						inner join Existencias b 
						on a.Aid = b.Aid 
						and b.Alm_Aid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsEDRequi.Alm_Aid#">
						
						inner join Almacen al
						on al.Aid=b.Alm_Aid
						
						inner join IAContables c 
						on b.IACcodigo = c.IACcodigo 
						
						where a.ERid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
						  and a.DRlinea = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsEDRequi.DRlinea#">
					</cfquery>

					<!--- 3.9 Afectación de la Cuenta de Gasto en el asiento contable --->
					<cfquery datasource="#Arguments.Conexion#">
						INSERT INTO #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, CFcuenta, Ocodigo, 
												Mcodigo, INTMOE, INTCAM, INTMON 
											  ,	LIN_IDREF, LIN_CAN, CFid
											  )
						SELECT 'INRQ'
								, 1
								, a.ERdocumento
								, a.ERdocumento #_Cat# '-' #_Cat# <cf_dbfunction name="to_char" args="b.DRlinea">
								, 'D'
								, c.Acodigo #_Cat# ' - ' #_Cat# c.Adescripcion
								, <cf_dbfunction name="to_sdate" args="a.ERFecha">
								, <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsPeriodo.periodo#">
								, <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsMes.mes#">
								, 0
								, b.CFcuenta
								, a.Ocodigo

								, <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#LvarCOSTOS.VALUACION.Mcodigo#">
								, <cf_jdbcquery_param cfsqltype="cf_sql_float"	value="#LvarCOSTOS.VALUACION.Costo#">
								, <cf_jdbcquery_param cfsqltype="cf_sql_money"	value="#LvarCOSTOS.VALUACION.TC#">  
								, <cf_jdbcquery_param cfsqltype="cf_sql_money"	value="#LvarCOSTOS.LOCAL.Costo#">

								, b.DSlinea, b.DRcantidad,b.CFid
						FROM ERequisicion a 
							inner join DRequisicion b
								on b.ERid = a.ERid
								and b.DRlinea = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsEDRequi.DRlinea#">
							inner join Articulos c
								on c.Aid = b.Aid
						WHERE a.ERid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
					</cfquery>

					<!--- Reversa los Impuestos Creditos Fiscal cuando la Requisicion es de Consumo interno --->
					<cfif rsEDRequi.TRreversaCreditoFiscal EQ 1>
						<!--- Acredita/Reversa la cuenta del Impuesto con el round(#LvarCOSTOS.Costo# * i.Iporcentaje/100,2)  --->
						<cfquery datasource="#Arguments.Conexion#">
							INSERT INTO #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo, 
													Mcodigo, INTMOE, INTCAM, INTMON,CFid 
												  )
							select 'INRQ' 
									,1
									,<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#rsEDRequi.ERdocumento#"> 
									,e.TRcodigo 
									,'C'
									, a.Acodigo #_Cat# ' - Impuesto ' #_Cat# a.Adescripcion
									,<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LSDateFormat(rsEDRequi.ERFecha,'yyyymmdd')#">
									, <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsPeriodo.periodo#">
									, <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsMes.mes#">
									,i.Ccuenta 
									, al.Ocodigo
	
									, <cf_jdbcquery_param cfsqltype="cf_sql_numeric"		value="#LvarCOSTOS.LOCAL.Mcodigo#">
									, round(<cf_jdbcquery_param cfsqltype="cf_sql_float"	value="#LvarCOSTOS.LOCAL.Costo#"> * i.Iporcentaje/100,2) 
									, 1.00
									, round(<cf_jdbcquery_param cfsqltype="cf_sql_money"	value="#LvarCOSTOS.LOCAL.Costo#"> * i.Iporcentaje/100,2) 
                                    ,d.CFid	
							from DRequisicion d
								inner join ERequisicion e
									on e.ERid = d.ERid
								inner join Almacen al
									on al.Aid=e.Aid
								inner join Articulos a
									on a.Aid = d.Aid
								inner join Impuestos i
									on i.Ecodigo = a.Ecodigo
									and i.Icodigo = a.Icodigo
									and i.Icreditofiscal = 1
								inner join CContables c
									on c.Ccuenta = i.Ccuenta
							where d.ERid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
							   and d.DRlinea = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsEDRequi.DRlinea#">					   
						</cfquery>
						<!--- Debita/Aumenta la cuenta del Gasto con el round(#LvarCOSTOS.Costo# * i.Iporcentaje/100,2)  --->
						<cfquery datasource="#Arguments.Conexion#">
							INSERT INTO #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, CFcuenta, Ocodigo, 
													Mcodigo, INTMOE, INTCAM, INTMON,CFid 
												  )
							select 'INRQ' 
									,1
									,a.ERdocumento
									,a.ERdocumento #_Cat# '-' #_Cat# <cf_dbfunction name="to_char" args="b.DRlinea">	
									,'D'
									,'Impuesto: ' #_Cat# c.Acodigo #_Cat# ' - ' #_Cat# c.Adescripcion
									,<cf_dbfunction name="to_sdate" args="a.ERFecha">
									, <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsPeriodo.periodo#">
									, <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsMes.mes#">
									, 0
									, b.CFcuenta 
									, a.Ocodigo
	
									, <cf_jdbcquery_param cfsqltype="cf_sql_numeric"		value="#LvarCOSTOS.LOCAL.Mcodigo#">
									, round(<cf_jdbcquery_param cfsqltype="cf_sql_float"	value="#LvarCOSTOS.LOCAL.Costo#"> * i.Iporcentaje/100,2) 
									, 1.00
									, round(<cf_jdbcquery_param cfsqltype="cf_sql_money"	value="#LvarCOSTOS.LOCAL.Costo#"> * i.Iporcentaje/100,2) 
                                    ,b.CFid
							FROM ERequisicion a 
								inner join DRequisicion b
									on b.ERid = a.ERid
									and b.DRlinea = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsEDRequi.DRlinea#">
								inner join Articulos c
									on c.Aid = b.Aid
								inner join Impuestos i
									on i.Icodigo = c.Icodigo
									and i.Ecodigo = c.Ecodigo
									and i.Icreditofiscal = 1
								where a.ERid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
						</cfquery>
					</cfif>
				</cfoutput>
			
				<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
				<cf_dbfunction name="sPart"		args="INTFEC,1,4" returnvariable="INTFEC_ANO">
				<cf_dbfunction name="sPart"		args="INTFEC,5,2" returnvariable="INTFEC_MES">
				<cf_dbfunction name="sPart"		args="INTFEC,7,2" returnvariable="INTFEC_DIA">
			
				<!--- 10a. CONTROL DE PRESUPUESTO --->

				<!--- Obtiene Tipo Control de Presupuesto en Compras de Articulos de Inventario--->
				<!--- 	Si controlar Consumo Inventario: No controlar Compras sin Consumo (SC sin requisición = Compras de Inventario sin consumo) --->
				<!--- 	Si controlar Compras Inventario: No controlar Consumo/Requisicion sin compra (lo que se requiza = Consumo, no se compra) --->
				<cfquery name="rsSQL" datasource="#session.DSN#">
					select Pvalor
					  from Parametros
					 where Ecodigo	= #Arguments.Ecodigo#
					   and Pcodigo	= 548
				</cfquery>
				<cfset LvarCPconsumoInventario = rsSQL.Pvalor NEQ 1>
				<cfset LvarCPcomprasInventario = NOT LvarCPconsumoInventario>
		
				<cfif LvarCPcomprasInventario>
					<cfset LvarNAP = 0>
				<cfelse>
					<!--- Obtiene el CFcuenta para utilizarla con el LvarSignoDB_CR --->
					<cfquery datasource="#Arguments.Conexion#">
						update #INTARC#
						   set CFcuenta =
								(
									select min(CFcuenta) 
									  from CFinanciera
									 where Ccuenta = #INTARC#.Ccuenta
								)
						 where CFcuenta IS NULL
					</cfquery>
					<!--- Determina el signo de los montos de DB/CR a Ejecutar --->
					<cfinvoke 	component			= "sif.Componentes.PRES_Presupuesto"	
								method				= "fnSignoDB_CR" 	
								returnvariable		= "LvarSignoDB_CR"
								
								INTTIP				= "i.INTTIP"
								Ctipo				= "m.Ctipo"
								CPresupuestoAlias	= "cp"
								
								Ecodigo				= "#Arguments.Ecodigo#"
								AnoDocumento		= "#rsPeriodo.periodo#"
								MesDocumento		= "#rsMes.mes#"
					/>
			
					<!--- 10a.1. Registra la Ejecucion que se hace del Asiento: con CFcuenta --->
					<cfquery datasource="#Arguments.Conexion#">
						insert into #INT_PRES#
							(
								ModuloOrigen,
								NumeroDocumento,
								NumeroReferencia,
								FechaDocumento,
								AnoDocumento,
								MesDocumento,
								NumeroLinea, 
								CFcuenta, CPcuenta,
								Ocodigo,
								Mcodigo,
								MontoOrigen,
								TipoCambio,
								Monto,
								TipoMovimiento
							)
						select 
								INTORI,
								INTDOC,
								INTREF,
								cast(Convert(datetime,convert(varchar,#INTFEC_ANO#) #_Cat# '-' #_Cat# convert(varchar,#INTFEC_MES#) #_Cat# '-' #_Cat# convert(varchar,#INTFEC_DIA#)) as date),
								
								i.Periodo,
								i.Mes,
								INTLIN,
								i.CFcuenta, cp.CPcuenta,
								i.Ocodigo,
								i.Mcodigo,
								#PreserveSingleQuotes(LvarSignoDB_CR)# * INTMOE as MontoOrigen, 
								INTCAM,
								#PreserveSingleQuotes(LvarSignoDB_CR)# * INTMON as Monto, 
								'E'
						  from  #INTARC# i
							inner join CFinanciera cf
								left join CPresupuesto cp
								   on cp.CPcuenta = cf.CPcuenta
								inner join CtasMayor m
								   on m.Ecodigo = cf.Ecodigo
								  and m.Cmayor	= cf.Cmayor
							   on cf.CFcuenta = i.CFcuenta
					</cfquery>
	
					<!--- 10a.2. Registra la DesReserva que se hace de las Solicitudes de Compra Referenciadas --->
					<cfquery datasource="#Arguments.Conexion#">
						insert into #INT_PRES#
							(
								ModuloOrigen,
								NumeroDocumento,
								NumeroReferencia,
								FechaDocumento,
								AnoDocumento,
								MesDocumento,
								NumeroLinea, 
								CFcuenta,
								Ocodigo,
								Mcodigo,
								MontoOrigen,
								TipoCambio,
								Monto,
								TipoMovimiento,
								NAPreferencia,	LINreferencia
							)
						select 
								INTORI,
								INTDOC,
								INTREF,
								cast(Convert(datetime,convert(varchar,#INTFEC_ANO#) #_Cat# '-' #_Cat# convert(varchar,#INTFEC_MES#) #_Cat# '-' #_Cat# convert(varchar,#INTFEC_DIA#)) as date),
								c.Periodo,
								c.Mes,
								-INTLIN,
								<!--- Proporción cantidad requisición con respecto a la cantidad SC original, maximo cantidad reservada original: --->
									 <!--- Prop. Cant. requisición:  CANTIDAD_REQUISICION / CANTIDAD_ORIGINAL --->
									 <!--- CANTIDAD_REQUISICION =    c.LIN_CAN --->
									 <!--- CANTIDAD_ORIGINAL    =    d.DScantidadNAP --->
									 <!--- Prop. Cant. requisición:  c.LIN_CAN / (d.DScantidadNAP --->
									 <!--- 
											Se usa napSC.CPNAPmontoOri en lugar de (DStotallinest+DSimpuestoCosto) 
											porque en algunos lugares se recalculaMontos: 
												DStotallinest = round(DScant * DSmontoest,2) 
											El máximo a DesReservar es el Monto No Utilizado de la Reserva
									--->
								napSC.CFcuenta,
								napSC.Ocodigo,
								napSC.Mcodigo,
								<!--- La idea es realizar el cálculo a partir del monto en  moneda origen * TC, sin embargo, 
									el máximo lo determina CPNAPDutilizado que sólo se tiene en moneda local, por tanto,
									el máximo se determina como napSC.CPNAPDmonto-napSC.CPNAPDutilizado.
									Basicamente:
										MonedaOrigen: max(MontoOrigen * Proporcion,      (napSC.CPNAPDmonto-napSC.CPNAPDutilizado) / TC)
										MonedaLocal:  max(MontoOrigen * Proporcion * TC, (napSC.CPNAPDmonto-napSC.CPNAPDutilizado) 
								--->
								-round (
									case
										when napSC.CPNAPDmonto-napSC.CPNAPDutilizado < round(napSC.CPNAPDtipoCambio * napSC.CPNAPDmontoOri * c.LIN_CAN / d.DScantidadNAP,2) then 
											(napSC.CPNAPDmonto-napSC.CPNAPDutilizado)
											/ napSC.CPNAPDtipoCambio
										else 
											(napSC.CPNAPDmontoOri * c.LIN_CAN / d.DScantidadNAP)
									end
								,2) as MontoOrigen,
								napSC.CPNAPDtipoCambio,
								-round (
									case
										when napSC.CPNAPDmonto-napSC.CPNAPDutilizado < round(napSC.CPNAPDtipoCambio * napSC.CPNAPDmontoOri * c.LIN_CAN / d.DScantidadNAP,2) then 
											(napSC.CPNAPDmonto-napSC.CPNAPDutilizado)
										else 
											(napSC.CPNAPDmontoOri * c.LIN_CAN / d.DScantidadNAP)
											* napSC.CPNAPDtipoCambio
									end
								,2) as MontoLocal,

								'RC',
								napSC.CPNAPnum, napSC.CPNAPDlinea
						  from  #INTARC# c
							inner join DSolicitudCompraCM d
								inner join ESolicitudCompraCM e
								   on e.ESidsolicitud	= d.ESidsolicitud
								inner join CPNAPdetalle napSC
								   on napSC.Ecodigo		= e.Ecodigo
								  and napSC.CPNAPnum	= e.NAP
								  and napSC.CPNAPDlinea	= d.DSconsecutivo
							on d.DSlinea = c.LIN_IDREF
						 where c.LIN_IDREF is not null 
						   and e.NAP is not null
						   and e.NAP <> 0
					</cfquery>
					
					<!--- 10a.3. Afectación Presupuestaria --->
                    <cfset lvarMethod = "ControlPresupuestario">
					<cfif Arguments.Intercompany>
                    	 <cfset lvarMethod = "ControlPresupuestarioIntercompany">
                    </cfif>
					<cfinvoke 	component			= "sif.Componentes.PRES_Presupuesto"	
								method				= "#lvarMethod#" 	
								returnvariable		= "LvarNAP"
								
								Ecodigo				= "#Arguments.Ecodigo#"
								ModuloOrigen 		= "INRQ"
								NumeroDocumento		= "#rsEDRequi.ERdocumento#"
								NumeroReferencia	= "IR"
								FechaDocumento		= "#rsEDRequi.ERFecha#"
								AnoDocumento		= "#rsPeriodo.periodo#"
								MesDocumento		= "#rsMes.mes#"
                                Intercompany	    = "#Arguments.Intercompany#"
					/>
				</cfif>
				
				<cfset lvarOorigenQ="INRQ">
                <cfif Arguments.Intercompany>
                	<cfset LvarNAP = LvarNAP.NAP>
					<cfset lvarOorigenQ="INRI">
                </cfif>
				
				<cfif LvarNAP GTE 0>
					<cfquery datasource="#Arguments.Conexion#">
						update ERequisicion
						   set NAP  = #LvarNAP#
						 where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
					</cfquery>
				<cfelse>
					<cfquery datasource="#Arguments.Conexion#">
						update ERequisicion
						   set NRP  = #-LvarNAP#
						 where ERid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
					</cfquery>
					<cftransaction action="commit" />
		
					<cflocation url="/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=#abs(LvarNAP)#">
				</cfif>

				<!--- 3.10b Genera Asiento Contable --->
				<cfinvoke component="CG_GeneraAsiento" method="GeneraAsiento" returnvariable="IDcontable">
                    <cfinvokeargument name="Ocodigo" 		value="#rsEDRequi.Ocodigo#">
                    <cfinvokeargument name="Ecodigo" 		value="#Arguments.Ecodigo#">
                    <cfinvokeargument name="Oorigen" 		value="#lvarOorigenQ#">
                    <cfinvokeargument name="Edocbase" 		value="#rsEDRequi.ERdocumento#">
                    <cfinvokeargument name="Ereferencia" 	value="IR">
                    <cfinvokeargument name="Efecha" 		value="#rsEDRequi.ERFecha#">
                    <cfinvokeargument name="Eperiodo" 		value="#rsPeriodo.periodo#">
                    <cfinvokeargument name="Emes" 			value="#rsMes.mes#">
                    <cfinvokeargument name="Edescripcion" 	value="IN: Requisición #rsEDRequi.ERdocumento#">
                    <cfinvokeargument name="NAP" 			value="#LvarNAP#">
                    <cfinvokeargument name="CPNAPIid" 		value="0">
                    <cfinvokeargument name="Debug" 			value="#Arguments.Debug#">
                    <cfinvokeargument name="Intercompany" 	value="#Arguments.Intercompany#">
                </cfinvoke>


				<!--- 3.11 Actualiza el idcontable del Kardex --->
				<cfquery datasource="#Arguments.Conexion#">
					update Kardex
					set IDcontable = #IDcontable#
					where Kid in (
						select Kid from #IDKARDEX#
					)
				</cfquery>
				<!--- 3.12 Inserta en el Histórico de Requisiciones --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into HERequisicion (ERid, ERdescripcion, Ecodigo, Aid, ERdocumento, Ocodigo, TRcodigo, Dcodigo, ERFecha, ERtotal, ERusuario, EReferencia, PRJAid, EcodigoRequi, ERidref, UsucodigoD,UsucodigoA, CFid, Externo, Observaciones)
					select ERid, ERdescripcion, Ecodigo, Aid, ERdocumento, Ocodigo, TRcodigo, Dcodigo, ERFecha, ERtotal, ERusuario, EReferencia, PRJAid, EcodigoRequi, ERidref, UsucodigoD,UsucodigoA,CFid, Externo, Observaciones from ERequisicion
					where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				</cfquery>
				<!--- 3.13 Borra el Registro de Requisiciones --->
				<cfquery datasource="#Arguments.Conexion#">
					delete from DRequisicion where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
				</cfquery>
				<cfquery datasource="#Arguments.Conexion#">
					delete from ERequisicion where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				</cfquery>				
				<!--- Debug: Después de las operaciones --->
				<cfif Arguments.Debug>
					<cfquery name="rsDebug" datasource="#Arguments.Conexion#">
						select * from #INTARC#
					</cfquery>
					<cfdump var="#rsDebug#" label="INTARC">
					<cfquery name="rsDebug" datasource="#Arguments.Conexion#">
						select * from Kardex
						where Kid in (
							select Kid from #IDKARDEX#
						)
					</cfquery>
					<cfdump var="#rsDebug#" label="Kardex">
					<cfquery name="rsDebug" datasource="#Arguments.Conexion#">
						select * from ERequisicion where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					</cfquery>
					<cfdump var="#rsDebug#" label="ERequisicion">
					<cfquery name="rsDebug" datasource="#Arguments.Conexion#">
						select * from HERequisicion where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					</cfquery>
					<cfdump var="#rsDebug#" label="HERequisicion">
				</cfif>
				<!--- RollBack: Deshace todos los cambios --->
				<cfif Arguments.RollBack>
					<cftransaction action="rollback"/>
				</cfif>
			</cftransaction>
			<!---►►Si existe y esta Activa la Interfaz 921,realiza el llamdo◄◄--->
			<cfquery name="rsInterfaz" datasource="sifinterfaces">
				select Activa
				  from Interfaz
				 where NumeroInterfaz = <cfqueryparam cfsqltype="cf_sql_integer" value="921">
			</cfquery>
			<cfif rsInterfaz.RecordCount and rsInterfaz.Activa EQ 1>
				<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
				<cfset LobjInterfaz.fnProcesoNuevoSoin(921,"ERid=#Arguments.ERid#","R")>
			</cfif>
		<cfreturn true>
	</cffunction>
</cfcomponent>