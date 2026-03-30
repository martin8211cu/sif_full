<cfcomponent>
	<cffunction name="IN_AjusteInventario" access="public" returntype="boolean">
		<cfargument name="EAid"			required="true" 			type="numeric" 	hint="Id de Ajuste">
		<cfargument name="Conexion"	required="false" 		type="string" 		hint="Datasource">
		<cfargument name="Ecodigo"	  	required="false" 		type="numeric" 	hint="Empresa">
		<cfargument name="Usucodigo"	required="false" 		type="numeric" 	hint="Usuario">
		<cfargument name="Debug" 		required="false"			type="boolean"	hint="Debug"													default="false">
		<cfargument name="RollBack"		required="false" 		type="boolean"	hint="RollBack"												default="false">
        <cfargument name="Ktipo"			required="false" 		type="string"		hint="Tipo Movimiento para el Kardex (E=entrada, S=Salida, A=Ajuste Inv, I=Inventario Fisico, R=Requisicion)"		default="E">
        
        
		<!--- Variables privadas del método --->
		<!--- Variables públicas creadas en el método --->
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
		
		<!--- Crea tablas temporales requeridas --->
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" returnvariable="INTARC"/>
		<cfinvoke component="sif.Componentes.IN_PosteoLin" method="CreaIdKardex"  returnvariable="IDKARDEX"/>

		<cfif arguments.debug>
			<cfdump var="#arguments#">
		</cfif>
		<!--- Inicio *** --->
			
			<!--- 1 Validaciones --->
			<!--- 1.1 Validación de integridad del Ajuste --->
			<cfquery name="rs" datasource="#Arguments.Conexion#">
				select 1 from EAjustes where EAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EAid#">
			</cfquery>
			<cfif rs.recordcount eq 0>
				<cf_errorCode	code = "51178" msg = "Error en IN_AjusteInventario. No existe la Requisición. Proceso Cancelado!">
			</cfif>
			
			<!--- 2 Definiciones --->
			<!--- 2.1 Ajuste y Detalles --->
			
			<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null" returnvariable="KardexTipo">
			<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null" returnvariable="TipoMov">
			<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null" returnvariable="TipoMovDesc">
			<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null" returnvariable="cuenta">
			<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null" returnvariable="TipoMovIngGas">
			<cfquery name="rsAjuste" datasource="#Arguments.Conexion#">
				select b.Aid, b.DALinea, c.Aid as Alm_Aid, c.Ocodigo, c.Dcodigo, a.EAdocumento , b.DAcantidad, b.DAcosto, a.EAfecha , 
					DAtipo, b.CFformato,
					<cf_dbfunction name="to_char" args="#KardexTipo#"> as KardexTipo, 
					0.00 as Monto, 
					<cf_dbfunction name="to_char" args="#TipoMov#"> as TipoMov, 
					<cf_dbfunction name="to_char" args="#TipoMovDesc#"> as TipoMovDesc, 
					<cf_dbfunction name="to_number" args="#cuenta#"> as cuenta, 
					<cf_dbfunction name="to_char" args="#TipoMovIngGas#"> as TipoMovIngGas
				from EAjustes a
					inner join DAjustes b
						on b.EAid = a.EAid
					inner join Almacen c
						on c.Aid = a.Aid
				where a.EAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EAid#">
			</cfquery>
			
			<cfif arguments.debug>
				<cf_dump var="#rsAjuste#" label="rsAjuste">
			</cfif>

			<!--- 2.2 Cantidad de salida menor a existencias --->
            
            <cfif rsAjuste.DAtipo eq 1> <!---Solo cuando son salidas--->

                <cfquery name="rsForm" datasource="#session.DSN#">
                    select Eexistmin, Eexistmax, Eexistencia, Ecostou 
                    from Existencias
                    where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
                      and Aid = <cfqueryparam value="#rsAjuste.Aid#" cfsqltype="cf_sql_numeric" >
                      and Alm_Aid = <cfqueryparam value="#rsAjuste.Alm_Aid#" cfsqltype="cf_sql_numeric" >
                </cfquery>
                
                <cfif rsAjuste.DAcantidad gt rsForm.Eexistencia>
                    <cfthrow message="Error: No se puede aplicar el documento ya que esta intentando realizar una salida de :#rsAjuste.DAcantidad# articulos  y es mayor de los que tiene en existencias (#rsForm.Eexistencia#) ">
                </cfif>
            </cfif>
            
			<!--- 2.3 Periodo de Auxiliares --->
			<cfquery name="rsPeriodo" datasource="#Arguments.Conexion#">
				select Pvalor as periodo from Parametros where Pcodigo = 50
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfquery>
			<cfif rsPeriodo.recordcount eq 0>
				<cf_errorCode	code = "51179" msg = "Error en IN_AjusteInventario. No se ha definido el Periodo de Auxiliares. Proceso Cancelado!">
			</cfif>
			<!--- 2.4 Mes de Auxiliares --->
			<cfquery name="rsMes" datasource="#Arguments.Conexion#">
				select Pvalor as mes from Parametros where Pcodigo = 60
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfquery>
			<cfif rsMes.recordcount eq 0>
				<cf_errorCode	code = "51180" msg = "Error en IN_AjusteInventario. No se ha definido el Mes de Auxiliares. Proceso Cancelado!">
			</cfif>
			<!--- 2.5 Moneda Local --->
			<cfquery name="rsMonLoc" datasource="#Arguments.Conexion#">
				select Mcodigo as monloc from Empresas where 
				Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfquery>
			
			<!--- 2.6 No Contabilizar Costo de Ventas ni Ajustes --->
			<cfquery name="rsNoContabiliza" datasource="#Arguments.Conexion#">
				select Pvalor as NoContabiliza from Parametros where Pcodigo = 740
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfquery>
			
			<cfif arguments.debug>
				<cfdump var="#rsNoContabiliza#">
			</cfif>

			<cfif rsNoContabiliza.recordcount eq 0>
				<cf_errorCode	code = "51181" msg = "Error en IN_AjusteInventario. No se ha definido si Contabiliza o no el Costo de Ventas ni Ajustes. Proceso Cancelado!">
			</cfif>

			<!--- 3 Operaciones --->
			<cfinvoke 
				component="sif.Componentes.IN_PosteoLin" 
				method="IN_MonedaValuacion"
				
				Conexion="#Arguments.Conexion#"
				Ecodigo="#Arguments.Ecodigo#"
				tcFecha="#rsAjuste.EAFecha#"			<!--- Fecha Tipo de Cambio --->

				returnvariable="LvarCOSTOS"
			/>
			
			<cfif arguments.debug>
				<cfdump var="#LvarCOSTOS#">
			</cfif>

			<cftransaction>
            <cfif isdefined("rsAjuste.CFformato") and len(trim(rsAjuste.CFformato)) gt 0>  
            	<cfquery name="rsCcuenta" datasource="#Arguments.Conexion#">
                	select Ccuenta
                    from CFinanciera
                    where CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#rsAjuste.CFformato#">
                    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                </cfquery>
            </cfif>
            
			<cfoutput query="rsAjuste">
				<!--- 3.1 Información de las Cuentas Contables --->
				<cfquery name="rsCuentas" datasource="#Arguments.Conexion#">
					select
                    <cfif isdefined("rsAjuste.CFformato") and len(trim(rsAjuste.CFformato)) gt 0>  
                    	<cfif NOT LEN(TRIM(rsCcuenta.Ccuenta))>
                			<cfthrow message="No se pudo recuperar la cuenta de Ajuste">
                		</cfif>
						#rsCcuenta.Ccuenta# as cuentaingreso, 
						#rsCcuenta.Ccuenta# as cuentagasto,
                    <cfelse>
                        b.IACingajuste as cuentaingreso, 
						b.IACgastoajuste as cuentagasto,
                    </cfif>
						b.IACinventario as cuentainv   
					from Existencias a
						inner join IAContables b 
							on b.IACcodigo = a.IACcodigo
							and b.Ecodigo = a.Ecodigo
					where a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAjuste.Aid#">
					and a.Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAjuste.Alm_Aid#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				</cfquery>
				
				<cfif arguments.debug>
					<cfdump var="#rsCuentas#" label="rsCuentas">
				</cfif>
				
				<cfif (rsCuentas.recordcount eq 0) or (len(rsCuentas.cuentaingreso) eq 0) or (len(rsCuentas.cuentagasto) eq 0) or (len(rsCuentas.cuentainv) eq 0) >
					<cf_errorCode	code = "51182" msg = "Error en IN_AjusteInventario. No se han definido las Cuentas Contables para el Artículo / Almacen. Proceso Cancelado!">
				</cfif>

				<!--- 3.2 Valida integridad de algunos datos --->
				<cfif (len(rsAjuste.EAfecha) EQ 0)><cfset QuerySetCell(rsAjuste,"EAfecha",CreateDate(Year(Now()),Month(Now()),Day(Now())))></cfif>
				<cfif (len(rsAjuste.DAtipo) EQ 0) or (rsAjuste.DAtipo NEQ "1")>
					<cfset QuerySetCell(rsAjuste,"KardexTipo","E",CurrentRow)>
					<cfset QuerySetCell(rsAjuste,"TipoMov","D",CurrentRow)>
					<cfset QuerySetCell(rsAjuste,"TipoMovIngGas","C",CurrentRow)>
					<cfset QuerySetCell(rsAjuste,"Monto",1,CurrentRow)>
					<cfset QuerySetCell(rsAjuste,"TipoMovDesc","Ingreso",CurrentRow)>
					<cfset QuerySetCell(rsAjuste,"cuenta",rsCuentas.cuentaingreso,CurrentRow)>
				<cfelse>
					<cfset QuerySetCell(rsAjuste,"KardexTipo","S",CurrentRow)>
					<cfset QuerySetCell(rsAjuste,"TipoMov","C",CurrentRow)>
					<cfset QuerySetCell(rsAjuste,"TipoMovIngGas","D",CurrentRow)>
					<cfset QuerySetCell(rsAjuste,"Monto",-1,CurrentRow)>
					<cfset QuerySetCell(rsAjuste,"TipoMovDesc","Gasto",CurrentRow)>
					<cfset QuerySetCell(rsAjuste,"cuenta",rsCuentas.cuentagasto,CurrentRow)>
				</cfif>
				
				<cfif arguments.debug>
					<cfdump var="#rsAjuste#" label="rsAjuste">
				</cfif>


				<!--- 3.3 Obtener Información del Artículo --->
				<cfquery name="rsArticulo" datasource="#Arguments.Conexion#">
					select Aid as id, Acodigo as codigo, Adescripcion as descripcion from Articulos where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAjuste.Aid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				</cfquery>

				<!--- 3.4 Información del Almacén --->
				<cfquery name="rsAlmacen" datasource="#Arguments.Conexion#">
					select Aid as id, Almcodigo as codigo, Bdescripcion as descripcion from Almacen where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAjuste.Alm_Aid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				</cfquery>

				<!--- 3.5 Ejecuta el PosteoLin para el ajuste --->
				<cfinvoke component="sif.Componentes.IN_PosteoLin" method="IN_PosteoLin" returnvariable="IN_PosteoLin_Ret">
                    <cfinvokeargument name="Aid" 							value="#rsAjuste.Aid#">
                    <cfinvokeargument name="Alm_Aid" 					value="#rsAjuste.Alm_Aid#">
                    <cfinvokeargument name="Tipo_Mov" 				value="#Arguments.Ktipo#">
                    <cfinvokeargument name="Cantidad" 				value="#rsAjuste.DAcantidad#">
                    <cfinvokeargument name="ObtenerCosto" 		value="false">
                    <cfinvokeargument name="McodigoOrigen" 		value="#LvarCOSTOS.VALUACION.Mcodigo#">
                    <cfinvokeargument name="CostoOrigen" 			value="#rsAjuste.DAcosto#">
                    <cfinvokeargument name="CostoLocal" 			value="#rsAjuste.DAcosto * LvarCOSTOS.VALUACION.TC#">
                    <cfinvokeargument name="Tipo_ES" 					value="#rsAjuste.KardexTipo#">
                    <cfinvokeargument name="Dcodigo" 					value="#rsAjuste.Dcodigo#">
                    <cfinvokeargument name="Ocodigo" 					value="#rsAjuste.Ocodigo#">
                    <cfinvokeargument name="Documento" 			value="#rsAjuste.EAdocumento#">
                    <cfinvokeargument name="FechaDoc" 				value="#rsAjuste.EAFecha#">
                    <cfinvokeargument name="Referencia" 				value="IN">
                    <cfinvokeargument name="Conexion" 				value="#Arguments.Conexion#">
                    <cfinvokeargument name="Ecodigo" 					value="#Arguments.Ecodigo#">
                    <cfinvokeargument name="EcodigoRequi" 		value="#Arguments.Ecodigo#">
                    <cfinvokeargument name="Debug" 					value="#Arguments.Debug#">
                    <cfinvokeargument name="RollBack" 					value="#Arguments.RollBack#">
                    <cfinvokeargument name="transaccionactiva" 	value="true">
                    <cfinvokeargument name="Usucodigo"         		value="#session.Usucodigo#"><!--- Usuario --->
                </cfinvoke>

				<!--- 3.6 Afectación de la Cuenta de Inventario en el asiento contable --->
				<cfquery datasource="#Arguments.Conexion#">
					INSERT INTO #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo, 
											Mcodigo, INTMOE, INTCAM, INTMON)
					values(
						'INAJ', 
						1, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#trim(rsAjuste.EAdocumento)#">, 
						<cfqueryparam cfsqltype="cf_sql_char" value="AJ">, 
						<cfqueryparam cfsqltype="cf_sql_char" value="D">,
						<cfqueryparam cfsqltype="cf_sql_char" value="Cuenta de Artículos de Inventario: #Mid(rsArticulo.descripcion, 1, 25)#">, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#LSDateFormat(rsAjuste.EAFecha,'yyyymmdd')#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPeriodo.periodo#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMes.mes#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentas.cuentainv#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjuste.Ocodigo#">,

						<cfqueryparam cfsqltype="cf_sql_numeric"	value="#IN_PosteoLin_Ret.VALUACION.Mcodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_money"		value="#IN_PosteoLin_Ret.VALUACION.Costo#">,
						<cfqueryparam cfsqltype="cf_sql_float"		value="#IN_PosteoLin_Ret.VALUACION.TC#">, 
						<cfqueryparam cfsqltype="cf_sql_money" 		value="#IN_PosteoLin_Ret.LOCAL.Costo#">
					)
				</cfquery>

				<!--- 3.7 Afectación de la Cuenta de Ingreso / Gasto en el asiento contable --->
				<cfquery datasource="#Arguments.Conexion#">
					INSERT INTO #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo, 
											Mcodigo, INTMOE, INTCAM, INTMON)
					values(
						'INAJ', 
						1, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#trim(rsAjuste.EAdocumento)#">, 
						<cfqueryparam cfsqltype="cf_sql_char" value="AJ">, 
						<cfqueryparam cfsqltype="cf_sql_char" value="C">,
						<cf_jdbcquery_param cfsqltype="cf_sql_char" value="Ajuste por #rsAjuste.TipoMovDesc#: #rsArticulo.descripcion#" len="80">, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#LSDateFormat(rsAjuste.EAFecha,'yyyymmdd')#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPeriodo.periodo#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMes.mes#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAjuste.cuenta#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjuste.Ocodigo#">,

						<cfqueryparam cfsqltype="cf_sql_numeric"	value="#IN_PosteoLin_Ret.VALUACION.Mcodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_money"		value="#IN_PosteoLin_Ret.VALUACION.Costo#">,
						<cfqueryparam cfsqltype="cf_sql_float"		value="#IN_PosteoLin_Ret.VALUACION.TC#">, 
						<cfqueryparam cfsqltype="cf_sql_money" 		value="#IN_PosteoLin_Ret.LOCAL.Costo#">
					)
				</cfquery>
			</cfoutput>
			<cfif arguments.debug>
				<cfquery name="Debug" datasource="#Arguments.Conexion#">
					select * from #INTARC#
				</cfquery>
				<cfdump var="#Debug#">
			</cfif>
					
			<!--- 3.8 Genera Asiento Contable --->
			<!--- 
			Hecho por: Rodolfo Jiménez Jara 
			Fecha: 02/09/2005
			Motivo: Se parametrizó a solicitud de Mauricio Esquivel, para Panamá --->
			<cfif isdefined("rsNoContabiliza") and rsNoContabiliza.NoContabiliza EQ 0>
			<cfif arguments.debug>
				<cfoutput>
						GeneraAsiento <br>
						Ecodigo #Arguments.Ecodigo# <br>
						Oorigen INAJ <br>
						Eperiodo #rsPeriodo.periodo#<br>
						Emes  #rsMes.mes# <br>
						Efecha #Now()# <br>
						Edescripcion IN: Ajuste de Inventario #trim(rsAjuste.EAdocumento)#<br>
						Edocbase #trim(rsAjuste.EAdocumento)# <br>
						Ereferencia AJ <br>
						Debug false <br>
				</cfoutput>
			</cfif>
			<cfquery name="rsOfi" datasource="#Arguments.Conexion#">
            	select min(Ocodigo) as Ocodigo from #INTARC#
            </cfquery>
            <cfif NOT rsOfi.RecordCount>
                <cfquery name="rsOfi" datasource="#Arguments.Conexion#">
                    select min(Ocodigo) as Ocodigo from Oficinas
                </cfquery>
           </cfif>
           <cfif NOT rsOfi.RecordCount>
           		<cfset rsOfi.Ocodigo = -1>
           </cfif>
           
				<cfinvoke component="CG_GeneraAsiento" method="GeneraAsiento" returnvariable="IDcontable">
                	<cfinvokeargument name="Ecodigo" 		value="#Arguments.Ecodigo#">
                    <cfinvokeargument name="Oorigen" 		value="INAJ">
                    <cfinvokeargument name="Eperiodo" 		value="#rsPeriodo.periodo#">
                    <cfinvokeargument name="Emes" 			value="#rsMes.mes#">
                    <cfinvokeargument name="Efecha" 		value="#rsAjuste.EAfecha#">
                    <cfinvokeargument name="Edescripcion" 	value="IN: Ajuste de Inventario #trim(rsAjuste.EAdocumento)#">
                    <cfinvokeargument name="Edocbase" 		value="#trim(rsAjuste.EAdocumento)#">
                    <cfinvokeargument name="Ereferencia" 	value="AJ">
                    <cfinvokeargument name="Debug" 			value="false">
                    <cfinvokeargument name="interfazconta" 	value="true">
                    <cfinvokeargument name="Ocodigo" 		value="#rsOfi.Ocodigo#">
                </cfinvoke>
			</cfif>
			<cfif arguments.debug>
				<cf_dump var="#IDcontable#">
			</cfif>
			
			
			<!--- devuelve el Inventario Fisico a su estado antes de aplicar  --->
			<cfquery datasource="#session.DSN#">
				update EFisico
					set EAid = null
				where EAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EAid#">
			</cfquery>
			
			<!--- 3.9 Elimina Ajuste de las tablas sin postear --->
			<cfquery datasource="#Arguments.Conexion#">
				delete from DAjustes where EAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EAid#">
			</cfquery>
			
			<cfquery datasource="#Arguments.Conexion#">
				delete from EAjustes where EAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EAid#">
			</cfquery>

			<cfif isdefined("rsNoContabiliza") and rsNoContabiliza.NoContabiliza EQ 0>
				<cfif isdefined("IDcontable") and len(trim(#IDcontable#))>
					<!--- 3.10 Actualiza el idcontable del Kardex --->
					<cfquery datasource="#Arguments.Conexion#">
						update Kardex
						set IDcontable = #IDcontable#
						where Kid in (
							select Kid from #IDKARDEX#
						)
					</cfquery>
					<cfquery datasource="#Arguments.Conexion#">
						update EFisico
						set IDcontable = #IDcontable#
						where EAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EAid#">
					</cfquery>
				<cfelse>
					<cf_errorCode	code = "51183" msg = "Error en IN_AjusteInventario. No se han definido las Cuentas Contables y/o de Presupuesto para el Artículo / Almacen. Proceso Cancelado!">
				</cfif>
				
			</cfif>
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
					select * from EAjustes where EAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EAid#">
				</cfquery>
				<cfdump var="#rsDebug#" label="EAjustes">
				<cfquery name="rsDebug" datasource="#Arguments.Conexion#">
					select * from DAjustes where EAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EAid#">
				</cfquery>
				<cfdump var="#rsDebug#" label="DAjustes">
			</cfif>

			<!--- RollBack: Deshace todos los cambios --->
			<cfif Arguments.RollBack>
				<cftransaction action="rollback"/>
			</cfif>
			</cftransaction>
			
		<!--- Fin    *** --->
		<!--- Retorno de Resultados --->
		<cfreturn true>
	</cffunction>
</cfcomponent>

