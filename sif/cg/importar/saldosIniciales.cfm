<!--- JMRV. Importador para la conversión de saldos. 02/09/2014. --->
<!--- IMPSALDINI: Importador de Saldos Iniciales --->
<!--- <cf_dumptable var="#table_name#"> --->

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="msg_archivo" Default= "El archivo de importación esta vacio" XmlFile="saldosIniciales.xml" returnvariable="msg_archivo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="msg_ecodigo" Default= "El archivo contiene registros donde el codigo de la empresa no esta definido" XmlFile="saldosIniciales.xml" returnvariable="msg_ecodigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="msg_periodo" Default= "El archivo contiene registros donde el periodo presupuestal no esta definido" XmlFile="saldosIniciales.xml" returnvariable="msg_periodo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="msg_mes" Default= "El archivo contiene registros donde el mes en el periodo presupuestal no esta definido" XmlFile="saldosIniciales.xml" returnvariable="msg_mes"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="msg_moneda" Default= "El archivo contiene registros donde el código de moneda no esta definido" XmlFile="saldosIniciales.xml" returnvariable="msg_moneda"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="msg_monto" Default= "El archivo contiene registros donde almenos uno de los montos no esta definido" XmlFile="saldosIniciales.xml" returnvariable="msg_monto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="msg_cuentas" Default= "El archivo contiene registros donde la cuenta no esta definida" XmlFile="saldosIniciales.xml" returnvariable="msg_cuentas"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="msg_ccuentas" Default= "Una o mas cuentas del archivo no tienen asociada una cuenta contable" XmlFile="saldosIniciales.xml" returnvariable="msg_ccuentas"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="msg_diferentesTC" Default= "Existen diferentes tipos de cambio para una misma moneda en un mismo periodo" XmlFile="saldosIniciales.xml" returnvariable="msg_diferentesTC"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="msg_Ocodigo" Default= "Existen registros sin un código de oficina definido" XmlFile="saldosIniciales.xml" returnvariable="msg_Ocodigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="msg_ccuentasVigentes" Default= "Existen cuentas que no estan vigentes" XmlFile="saldosIniciales.xml" returnvariable="msg_ccuentasVigentes"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="msg_OcodigoNoValido" Default= "El código de oficina asignado a algunos registros no es válido" XmlFile="saldosIniciales.xml" returnvariable="msg_OcodigoNoValido"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="msg_montoLocal" Default= "Uno o más montos locales no están definidos" XmlFile="saldosIniciales.xml" returnvariable="msg_montoLocal"/>


<!--- Tabla temporal de saldos --->
<cf_dbtemp name="saldos" returnvariable="saldos" datasource="#session.dsn#">
	<cf_dbtempcol name="empresa" 			type="int" 			mandatory="yes">
	<cf_dbtempcol name="oficina" 			type="int" 			mandatory="yes">
	<cf_dbtempcol name="periodo" 			type="int" 			mandatory="yes">
	<cf_dbtempcol name="mes" 				type="int" 			mandatory="yes">
	<cf_dbtempcol name="ccuenta" 			type="int" 			mandatory="yes">
	<cf_dbtempcol name="mcodigo" 			type="numeric" 		mandatory="yes">
	<cf_dbtempcol name="cuenta" 			type="varchar(100)" mandatory="yes">
	<cf_dbtempcol name="moneda" 			type="varchar(3)"  	mandatory="yes">
	<cf_dbtempcol name="saldoconvertido" 	type="money" 		mandatory="yes">
	<cf_dbtempcol name="saldomoneda" 		type="money" 		mandatory="yes">
	<cf_dbtempcol name="importepesos"	 	type="money" 		mandatory="yes">
	<cf_dbtempcol name="importedolares" 	type="money" 		mandatory="yes">
	<cf_dbtempcol name="CTCconversion"	 	type="int" 			mandatory="yes">
	<cf_dbtempcol name="Ctipo"			 	type="varchar(1)"	mandatory="yes">
	<cf_dbtempcol name="B15" 				type="numeric" 		mandatory="yes">
	<cf_dbtempcol name="MontoLocal" 		type="money" 		mandatory="yes">
</cf_dbtemp>

<!--- Tabla de errores --->
<cf_dbtemp name="ERRORES_TEMP" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" 	type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="ErrorNum" 	type="numeric" 		mandatory="yes">
</cf_dbtemp>

<!--- VALIDA QUE EL ARCHIVO A IMPORTAR NO VENGA VACIO --->
<cfquery name="rsCheck1" datasource="#Session.DSN#">
	select 1
	from #table_name#
</cfquery>

<cfif isdefined("rsCheck1") and  rsCheck1.recordcount EQ 0>
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		values('#msg_archivo#',1)
	</cfquery>
</cfif>

<!--- VALIDACION GENERAL --->
<cffunction name="Validacion" returntype="boolean">
<cfargument name="valida" 		type="string"	mandatory="yes">
<cfargument name="mensajeError" type="string"	mandatory="yes">
<cfargument name="numError" 	type="numeric"	mandatory="yes">

	<cfquery name="rsCheck1" datasource="#Session.DSN#">
		select 1
		from #table_name#
		where #Arguments.valida#
	</cfquery>

	<cfif isdefined("rsCheck1") and rsCheck1.recordcount NEQ 0>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
			values('#Arguments.mensajeError#',#Arguments.numError#)
		</cfquery>
		<cfset LB_error = true>
	<cfelse>
		<cfset LB_error = false>
	</cfif>
	<cfreturn LB_error>
</cffunction>

<!--- VERIFICA LA EXISTENCIA DE ERRORES --->
<cffunction name="VerificaErrores" returntype="boolean">
	<cfquery name="rsCheck1" datasource="#Session.DSN#">
		select 1
		from #ERRORES_TEMP#
	</cfquery>

	<cfif isdefined("rsCheck1") and rsCheck1.recordcount NEQ 0>
		<cfset LB_error = true>
	<cfelse>
		<cfset LB_error = false>
	</cfif>
	<cfreturn LB_error>
</cffunction>

<!--- VALIDA QUE TRAIGA EL MONTO EN MONEDA LOCAL --->
<cfset LB_error = Validacion("MontoLocal is null", '#msg_montoLocal#', 13)>

<!--- VALIDA QUE EL CODIGO DE EMPRESA ESTE DEFINIDO EN TODAS LAS LINEAS --->
<cfset LB_error = Validacion("Ecodigo is null", '#msg_ecodigo#', 2)>

<!--- VALIDA QUE EL PERIODO PRESUPUESTAL ESTE DEFINIDO EN TODAS LAS LINEAS --->
<cfset LB_error = Validacion("Periodo is null", '#msg_periodo#', 3)>

<!--- VALIDA QUE EL MES DEL PERIODO PRESUPUESTAL ESTE DEFINIDO EN TODAS LAS LINEAS --->
<cfset LB_error = Validacion("Mes is null", '#msg_mes#', 4)>

<!--- VALIDA EL CODIGO DE MONEDA EN LAS LINEAS --->
<cfset LB_error = Validacion("Miso4217 is null", '#msg_moneda#', 5)>

<!--- VALIDA QUE NINGUN MONTO VENGA VACIO --->
<cfset LB_error = Validacion("MontoOri is null or MontoFuncional is null or MontoInforme is null", '#msg_monto#', 6)>

<!--- VALIDA QUE NO VENGAN REGISTROS SIN CUENTAS --->
<cfset LB_error = Validacion("Cformato is null", '#msg_cuentas#', 7)>

<!--- VALIDA QUE NO VENGAN REGISTROS SIN OCODIGO --->
<cfset LB_error = Validacion("Ocodigo is null", '#msg_Ocodigo#', 8)>

<!--- VALIDA QUE EL OCODIGO SEA VALIDO --->
<cfquery name="validaOcodigo" datasource="#session.dsn#">
	select 1
	from #table_name# a
		inner join Oficinas b
		on a.Ecodigo = b.Ecodigo
		and a.Ocodigo = b.Ocodigo
</cfquery>

<cfquery name="validaDatosImportados" datasource="#session.dsn#">
	select 1
	from #table_name# a
</cfquery>

<cfif validaOcodigo.recordcount neq validaDatosImportados.recordcount>
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		values('#msg_OcodigoNoValido#', 9)
	</cfquery>
</cfif>

<!--- VALIDA QUE NO SE TENGAN DIFERENTES TIPOS DE CAMBIO EN UN MISMO PERIODO PARA UNA MISMA MONEDA --->
<cfquery name="valida1" datasource="#session.dsn#">
	select a.Ecodigo, a.Periodo, a.Mes, b.Mcodigo
	from #table_name# a
		inner join Monedas b
		on a.Ecodigo = b.Ecodigo
		and a.Miso4217 = b.Miso4217
	group by a.Ecodigo, a.Periodo, a.Mes, b.Mcodigo
</cfquery>

<cfquery name="valida2" datasource="#session.dsn#">
	select 	a.Ecodigo,
			a.Periodo,
			a.Mes,
			b.Mcodigo,
			a.TCCompraC1,
			a.TCVentaC1,
			a.TCPromedioC1,
			a.TCCompraC2,
			a.TCVentaC2,
			a.TCPromedioC2
	from #table_name# a
		inner join Monedas b
		on a.Ecodigo = b.Ecodigo
		and a.Miso4217 = b.Miso4217
	group by 	a.Ecodigo,
				a.Periodo,
				a.Mes,
				b.Mcodigo,
				a.TCCompraC1,
				a.TCVentaC1,
				a.TCPromedioC1,
				a.TCCompraC2,
				a.TCVentaC2,
				a.TCPromedioC2
</cfquery>

<cfif valida1.recordcount neq valida2.recordcount>
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		values('#msg_diferentesTC#', 10)
	</cfquery>
</cfif>

<!--- SI NO SE TIENEN ERRORES HASTA EL MOMENTO --->
<cfif not (VerificaErrores())>

	<!--- Valores para B15 y las monedas --->
	<cfquery name="ParaMcodigoFuncional" datasource="#session.dsn#">
		select a.Pvalor
		from Parametros a
		where a.Pcodigo = '3810'
		and a.Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfquery name="ParaMcodigoInforme" datasource="#session.dsn#">
		select a.Pvalor
		from Parametros a
		where a.Pcodigo = '3900'
		and a.Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfquery name="ParaMonedaFuncional" datasource="#session.dsn#">
		select a.Miso4217
		from Monedas a
		where a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ParaMcodigoFuncional.Pvalor#">
		and a.Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfquery name="ParaMonedaInforme" datasource="#session.dsn#">
		select a.Miso4217
		from Monedas a
		where a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ParaMcodigoInforme.Pvalor#">
		and a.Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfset McodigoFuncional  = #ParaMcodigoFuncional.Pvalor#>
	<cfset McodigoInforme    = #ParaMcodigoInforme.Pvalor#>
	<cfset MonedaFuncional   = #ParaMonedaFuncional.Miso4217#>
	<cfset MonedaInforme     = #ParaMonedaInforme.Miso4217#>
	<cfset B15_1aConversion  = 1>
	<cfset B15_2aConversion  = 2>

	<!--- Inserta las dos conversiones --->
	<cfloop index = "LoopCount" from = "1" to = "2">

		<!--- Borrar #saldos# --->
		<cfquery name="borrarSaldosConvertidos" datasource="#session.dsn#">
			delete #saldos#
		</cfquery>

		<cfquery name="registrosImportados" datasource="#session.dsn#">
			insert into #saldos# (	empresa,
									oficina,
									periodo,
									mes,
									ccuenta,
									mcodigo,
									B15,
									cuenta,
									moneda,
									saldoconvertido,
									saldomoneda,
									importedolares,
									importepesos,
									CTCconversion,
									Ctipo,
									MontoLocal)

						select 	a.Ecodigo,
								a.Ocodigo,
								a.Periodo,
								a.Mes,
								b.Ccuenta,
								mon.Mcodigo,
								case
									when #LoopCount# = 1 then #B15_1aConversion#
									else #B15_2aConversion#
								end as B15,
								a.Cformato,
								case
									when #LoopCount# = 1 then a.Miso4217
									else '#MonedaFuncional#'
								end as moneda,
								case
									when #LoopCount# = 1 then round(a.MontoFuncional,2)
									else round(a.MontoInforme,2)
								end as saldoconvertido,
								case
									when #LoopCount# = 1 then round(a.MontoOri,2)
									else round(a.MontoFuncional,2)
								end as saldomoneda,
								case
									when #LoopCount# = 1 then case when a.Miso4217 = 'USD' then round(a.MontoOri,2) else 0 end
									else round(a.MontoFuncional,2)
								end as importedolares,
								case
									when #LoopCount# = 1 then case when a.Miso4217 = 'USD' then 0 else round(a.MontoOri,2) end
									else 0
								end as importepesos,
								c.CTCconversion,
								c.Ctipo,
								round(a.MontoLocal,2)

						from #table_name# a
								inner join CContables b
								on a.Ecodigo = b.Ecodigo
								and a.Cformato = b.Cformato
									inner join CtasMayor c
									on b.Ecodigo = c.Ecodigo
									and b.Cmayor = c.Cmayor
							inner join Monedas mon
							on mon.Ecodigo = a.Ecodigo
							and mon.Miso4217 = case
													when #LoopCount# = 1 then a.Miso4217
													else '#MonedaFuncional#'
												end
		</cfquery>

		<!--- VERIFICA QUE EL CFORMATO TENGA ASOCIADA UNA CCUENTA VALIDA --->
		<cfquery name="tablaTemporal" datasource="#session.dsn#">
			select count(*) as registros from #table_name#
		</cfquery>

		<cfquery name="tablaSaldos" datasource="#session.dsn#">
			select count(*) as registros from #saldos#
		</cfquery>

		<cfif tablaTemporal.registros neq tablaSaldos.registros>
			<cfquery name="INS_Error" datasource="#session.DSN#">
				insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
				values('#msg_ccuentas#', 11)
			</cfquery>
		</cfif>

		<!--- VALIDA QUE LAS CUENTAS ESTEN VIGENTES --->
		<cfquery name="validaCcuenta" datasource="#session.DSN#">
			select 1
			from #saldos# a
				inner join CCInactivas b
				on a.ccuenta = b.Ccuenta
			where b.CCIdesde <= <cf_dbfunction name="now">
			and b.CCIhasta > <cf_dbfunction name="now">
		</cfquery>

		<cfif validaCcuenta.recordcount gt 0>
			<cfquery name="INS_Error" datasource="#session.DSN#">
				insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
				values('#msg_ccuentasVigentes#', 12)
			</cfquery>
		</cfif>

		<!--- Mayoriza los saldos iniciales --->
		<cfquery name="mayorizaSaldos" datasource="#session.dsn#">
			insert #saldos#(empresa,
							oficina,
							periodo,
							mes,
							ccuenta,
							mcodigo,
							cuenta,
							moneda,
							saldoconvertido,
							saldomoneda,
							importedolares,
							importepesos,
							CTCconversion,
							Ctipo,
							B15,
							MontoLocal)
					select 	empresa,
							oficina,
							periodo,
							mes,
							cu.Ccuentaniv,
							mcodigo,
							'',
							moneda,
							sum(saldoconvertido),
							sum(saldomoneda),
							sum(importedolares),
							sum(importepesos),
							CTCconversion,
							Ctipo,
							B15,
							sum(MontoLocal)

					from #saldos# s
						inner join PCDCatalogoCuenta cu
						on cu.Ccuenta = s.ccuenta
						and cu.Ccuentaniv <> cu.Ccuenta
							inner join CContables c
							on c.Ccuenta = cu.Ccuentaniv
					group by empresa, oficina, periodo, mes, cu.Ccuentaniv, mcodigo, moneda, CTCconversion, Ctipo, B15
		</cfquery>

		<!---  inserta en Saldos Contables Convertidos (si no se tienen errores)--->
		<cfif not (VerificaErrores())>
			<cfif LoopCount eq 1>
				<!--- Borrar los saldos convertidos de TODAS las cuentas contables --->
				<cfquery name="borrarSaldosConvertidos" datasource="#session.dsn#">
					delete SaldosContablesConvertidos
					where Ecodigo = #session.Ecodigo#
					and B15 in (1,2)
				</cfquery>
			</cfif>
			<cfquery name="insertaSaldosContables" datasource="#session.dsn#">
				insert SaldosContablesConvertidos (	Ccuenta,
													Speriodo,
													Smes,
													Ecodigo,
													Ocodigo,
													Mcodigo,
													McodigoOri,
													SOinicial,
													DOdebitos,
													COcreditos,
													SLinicial,
													DLdebitos,
													CLcreditos,
													BMUsucodigo,
													CTCconversion,
													Ctipo,
		    										B15,
		    										SMLinicial)
											select 	ccuenta,
													periodo,
													mes,
													empresa,
													oficina,
													case when #LoopCount# = 1 then #McodigoFuncional# else #McodigoInforme# end as Mcodigo,
													mcodigo,
													sum(saldomoneda),
													0.00,
													0.00,
													sum(saldoconvertido),
													0.00,
													0.00,
													#session.Usucodigo#,
													CTCconversion,
													Ctipo,
		    										B15,
		    										sum(MontoLocal)
											from #saldos# s
												group by ccuenta, periodo, mes, empresa, oficina, mcodigo, CTCconversion, Ctipo, B15
										</cfquery>
		</cfif>
	</cfloop>
</cfif>

<!--- SI NO SE TIENEN ERRORES HASTA EL MOMENTO --->
<cfif not (VerificaErrores())>
	<!--- Borra del histórico los registros que sean iguales a los importados --->
	<cfquery name="borrar" datasource="#session.dsn#">
		select * from #table_name#
	</cfquery>
	<cfloop query="borrar">
		<cfquery name="borrarHistoricoTiposCambio" datasource="#session.dsn#">
			delete HtiposcambioConversionB15
			where Ecodigo = #borrar.Ecodigo#
			and Speriodo = #borrar.Periodo#
			and Smes = #borrar.Mes#
			and Mcodigo = (select Mcodigo from Monedas where Ecodigo = #borrar.Ecodigo# and Miso4217 = '#borrar.Miso4217#')
		</cfquery>
	</cfloop>

	<!--- Llenar la tabla de Tipos de Cambio Históricos usados en la conversión --->
	<cfquery name="insertaSaldosContables" datasource="#session.dsn#">
		insert HtiposcambioConversionB15 	(Ecodigo,
											Speriodo,
											Smes,
											Mcodigo,
											TCcompra,
											TCventa,
											BMfecha,
											BMUsucodigo,
											TCpromedio,
											TCcompra2,
											TCventa2,
											TCpromedio2)
							select	a.Ecodigo,
									a.Periodo,
									a.Mes,
									b.Mcodigo,
									a.TCCompraC1 as TCcompra,
									a.TCVentaC1 as TCventa,
									<cf_dbfunction name="now"> as BMfecha,
									#session.Usucodigo# as BMUsucodigo,
									TCPromedioC1 as TCpromedio,
									TCCompraC2,
									TCVentaC2,
									TCPromedioC2
							from #table_name# a
								inner join Monedas b
								on a.Ecodigo = b.Ecodigo
								and a.Miso4217 = b.Miso4217
							group by 	a.Ecodigo,
										a.Periodo,
										a.Mes,
										b.Mcodigo,
										a.TCCompraC1,
										a.TCVentaC1,
										a.TCPromedioC1,
										a.TCCompraC2,
										a.TCVentaC2,
										a.TCPromedioC2
	</cfquery>

<!--- SI SE TIENEN ERRORES --->
<cfelse>
	<cfoutput><font color="red">La importación no se realizó</cfoutput>
	<cfoutput><p></p>Error(es) en el proceso de importación:</font></cfoutput>
	<cfquery name="errores" datasource="#session.DSN#">
		select * from #ERRORES_TEMP#
		group by Mensaje, ErrorNum
		order by ErrorNum
	</cfquery>
	<cfset contadorErrores = 1>
	<cfloop query="errores">
		  <cfoutput><p></p>#contadorErrores#. #errores.Mensaje#</cfoutput> <cfset contadorErrores = contadorErrores + 1>
	</cfloop>
	<cf_abort errorInterfaz="">
</cfif>

