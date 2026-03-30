<cfcomponent>

<!---
NOTA IMPORTANTE:  OJO:
	PARA PODER LLAMAR AL GeneraAsiento HAY QUE CREAR LA TABLA TEMPORAL INTARC
	USANDO LA FUNCION CreaIntarc, NO SE VALE CREARLA A PATA.
	EJEMPLO:
	
	<cfset obj = CreateObject("component", "sif.Componentes.CG_GeneraAsiento") >
	<cfset intarc = obj.CreaIntarc()>
	<cfquery> insert INTO #intarc# (..) values (..) </cfquery>
	<cfset obj.GeneraAsiento ( ... ) >
	
	-- danim

	Este componente debe invocarse solamente dentro de un <cftransaction>

	property intarc:
	       Contiene el nombre de la tabla temporal de interfaz contable.
		   No debe accederse sin antes haber invocado la funcion CreaIntarc.
	function CreaIntarc:
			Crea o prepara la tabla temporal #Request.intarc#.
	function GeneraAsiento:
			ANTES DE USAR ESTA FUNCION HAY QUE CREAR Y LLENAR LA TABLA TEMPORAL
			*USANDO* CreaIntarc, NO LA GENEREN A PIE
			Genera un asiento contable a partir del contenido de la tabla #Request.intarc#.
			Regresa el ICcontable del asiento generado.
			Si no se genera el asiento, regresa 0.
	rendimiento:
					lineas	
		sybase		16200	13.4 s  16.7 s  20.1 s ~ 16.7 s ~ 1.03 ms / registro
		oracle      48960   54.9 s  54.1 s  54.8 s ~ 54.6 s ~ 1.11 ms / registro
				

	Medicion de tiempo de respuesta en desarrollo:
	Sybase - 16,200 lineas - 13.4s  13.3s  6.4s 10.5s 6.4s ~ 10.0s
	Oracle - 00,000 lineas - 0s 0s 0s ~ 0s

	Modificado por: Ana Villavicencio R.
	Fecha: 12 de julio del 2005
	Motivo: No hacia la validación de la fecha de cierre de contabilidad 
			y mostraba un error no adecuado.  Se hizo la validación y se 
			envia un error indicando q la fecha no ha sido definida.
	Lineas: 145-148

--->

	<cffunction name="CreaIntarc" access="public" output="false" returntype="string">
		<cfargument name='Conexion' type='string' required='false'>
		<cfargument name='CrearPresupuesto' type='boolean' required='false' default="true">
		
		<cfif (not isdefined("arguments.Conexion"))>
			<cfset arguments.Conexion = session.dsn>
		</cfif>
		<cf_dbtemp name="CG_INTARC_V9" returnvariable="CG_GeneraAsiento_INTARC_NAME" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="INTLIN"    type="numeric"      identity="yes">
			<cf_dbtempcol name="INTORI"    type="char(4)"      mandatory="yes">
			<cf_dbtempcol name="INTREL"    type="int"          mandatory="yes">
			<cf_dbtempcol name="INTDOC"    type="char(20)"     mandatory="yes">
			<cf_dbtempcol name="INTREF"    type="varchar(25)"  mandatory="yes">
			<cf_dbtempcol name="INTMON"    type="money"        mandatory="yes">
			<cf_dbtempcol name="INTTIP"    type="char(1)"      mandatory="yes">
			<cf_dbtempcol name="INTDES"    type="varchar(80)"  mandatory="yes">
			<cf_dbtempcol name="INTFEC"    type="varchar(8)"   mandatory="yes">
			<cf_dbtempcol name="INTCAM"    type="float"        mandatory="yes">
			<cf_dbtempcol name="Periodo"   type="int"          mandatory="yes">
			<cf_dbtempcol name="Mes"       type="int"          mandatory="yes">
			<cf_dbtempcol name="Ccuenta"   type="numeric"      mandatory="yes">
			<cf_dbtempcol name="Mcodigo"   type="numeric"      mandatory="yes">
			<cf_dbtempcol name="Ocodigo"   type="int"          mandatory="yes">
			<cf_dbtempcol name="INTMOE"    type="money"        mandatory="yes">
			<cf_dbtempcol name="Cgasto"    type="varchar(100)" mandatory="no">
			<cf_dbtempcol name="Cformato"  type="varchar(100)" mandatory="no">
			<cf_dbtempcol name="CFcuenta"  type="numeric"      mandatory="no">
			<cf_dbtempcol name="INTMON2"   type="money"        mandatory="no">

			<cf_dbtempcol name="LIN_IDREF" type="numeric"      mandatory="no">
			<cf_dbtempcol name="LIN_CAN"   type="float"        mandatory="no">

			<cf_dbtempcol name="Dlinea"     type="integer"     mandatory="no">
			<cf_dbtempcol name="DOlinea"    type="numeric"     mandatory="no">
			<cf_dbtempcol name="DDcantidad" type="float"        mandatory="no">
            
            <cf_dbtempcol name="CFid" type="numeric"        mandatory="no">

			<cf_dbtempkey cols="INTLIN">
		</cf_dbtemp>
		<cfset Request.intarc = CG_GeneraAsiento_INTARC_NAME>
 		
		<cfif arguments.CrearPresupuesto>
			<cfinvoke 
				 component		= "PRES_Presupuesto"
				 method			= "CreaTablaIntPresupuesto"

				 Conexion		= "#Arguments.Conexion#"
			/>
		</cfif>
		
		<cfreturn CG_GeneraAsiento_INTARC_NAME>
	</cffunction>
	
	<cffunction name='GeneraAsiento' access='public' output='true' returntype="numeric" hint="Regresa el IDcontable del asiento generado.  Si no se genera el asiento, regresa 0">
		<cfargument name='Oorigen' type="string" required='true'>		
		<cfargument name='Cconcepto' type="numeric" required='no' default="-10">		<!--- Concepto de Asiento --->
		<cfargument name='Eperiodo' type='numeric' required='true'>
		<cfargument name='Emes' type='numeric' required='true'>
		<cfargument name='Efecha' type='date' required='true'>
		<cfargument name='Edescripcion' type='string' required='true'>		
		<cfargument name='Edocbase' type='string' required='true'>
		<cfargument name='Ereferencia' type='string' required='true' default=''>
		<cfargument name='debug' type='boolean' required='false' default='no'>
		<cfargument name='interfazconta' type='boolean' required='false' default='yes'>
		<cfargument name='NAP' type='string' required='false' default="">

		<cfargument name='Ecodigo' type='numeric' required='false' default="0">
		<cfargument name='Conexion' type='string' required='false' default="">
		<cfargument name='Ocodigo' type='numeric' required='false' default="">		<!--- Oficina del Documento --->
		<cfargument name='Usucodigo' type='numeric' required='false' default='#Session.Usucodigo#'>
		
		<cfargument name='PintaAsiento' type='boolean' required='false' default='no'>
		<cfargument name='Retroactivo' type='boolean' required='false' default="#false#">	
		<cfargument name='Intercompany' type='boolean' 	required='false' default="false">	
		<cfargument name='CPNAPIid' type='string' 		required='false' default="">
		<cfargument name='CierreAnual' type='boolean' 	required='false' default="false">

		<cfset Resultado = fnGeneraAsientoPrivate(
				Arguments.Oorigen,		
				Arguments.Cconcepto,
				Arguments.Eperiodo,
				Arguments.Emes,
				Arguments.Efecha,
				Arguments.Edescripcion,	
				Arguments.Edocbase,
				Arguments.Ereferencia,
				Arguments.debug,
				Arguments.interfazconta,
				Arguments.NAP,
				Arguments.Ecodigo,
				Arguments.Conexion,
				Arguments.Ocodigo,
				Arguments.Usucodigo,
				Arguments.PintaAsiento,
				Arguments.Retroactivo,	
				Arguments.Intercompany,	
				Arguments.CPNAPIid,
				Arguments.CierreAnual
		)>

		<cfif resultado LT -50>
			<cfif Len(Trim(MonedasDesbalanceadas))>
				<cfset LvarVieneDeInterfaz = (isdefined("url.ID") AND isdefined("url.MODO"))>
				<cfif NOT LvarVieneDeInterfaz OR Arguments.PintaAsiento>
					<font color="##FF0000" style="font-size:18px">
						La póliza no esta Balanceada en las siguientes Monedas: #MonedasDesbalanceadas#. Proceso Cancelado!
						<BR><BR><BR>
					</font>
	
					<!--- Pinta el Asiento Contable --->
					<cfinvoke 	component		= "sif.Componentes.CG_GeneraAsiento" 
								method			= "PintaAsiento" 
					>
						<cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
						<cfinvokeargument name="Cconcepto"		value="#Arguments.Cconcepto#"/>
						<cfinvokeargument name="Eperiodo"		value="#Arguments.Eperiodo#"/>
						<cfinvokeargument name="Emes"			value="#Arguments.Emes#"/>
						<cfinvokeargument name="Efecha"			value="#Arguments.Efecha#"/>
						<cfinvokeargument name="Oorigen"		value="#Arguments.Oorigen#"/>
						<cfinvokeargument name="Edocbase"		value="#Arguments.Edocbase#"/>
						<cfinvokeargument name="Ereferencia"	value="#Arguments.Ereferencia#"/>						
						<cfinvokeargument name="Edescripcion"	value="#Arguments.Edescripcion#"/>
					</cfinvoke>
	
					<cftransaction action="rollback" />
					<cfabort>
				</cfif>
				<cf_errorCode	code = "51070"
								msg  = "La póliza no esta Balanceada en las siguientes Monedas: @errorDat_1@. Proceso Cancelado!"
								errorDat_1="#MonedasDesbalanceadas#"
				>
			</cfif>
	
			<cfif Arguments.PintaAsiento>
				<!--- Pinta el Asiento Contable --->
				<cfinvoke 	component		= "sif.Componentes.CG_GeneraAsiento" 
							method			= "PintaAsiento" 
				>
					<cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
					<cfinvokeargument name="Cconcepto"		value="#Arguments.Cconcepto#"/>
					<cfinvokeargument name="Eperiodo"		value="#Arguments.Eperiodo#"/>
					<cfinvokeargument name="Emes"			value="#Arguments.Emes#"/>
					<cfinvokeargument name="Efecha"			value="#Arguments.Efecha#"/>
					<cfinvokeargument name="Oorigen"		value="#Arguments.Oorigen#"/>
					<cfinvokeargument name="Edocbase"		value="#Arguments.Edocbase#"/>
					<cfinvokeargument name="Ereferencia"	value="#Arguments.Ereferencia#"/>						
					<cfinvokeargument name="Edescripcion"	value="#Arguments.Edescripcion#"/>
				</cfinvoke>
				<cftransaction action="rollback" />
				<cfabort>
			</cfif>
		</cfif>
		<cfreturn Resultado>
	</cffunction>

	<cffunction name='fnGeneraAsientoPrivate' access='public' output='false' returntype="numeric" hint="Regresa el IDcontable del asiento generado.  Si no se genera el asiento, regresa 0">
		<cfargument name='Oorigen' type="string" required='true'>		
		<cfargument name='Cconcepto' type="numeric" required='no' default="-10">		<!--- Concepto de Asiento --->
		<cfargument name='Eperiodo' type='numeric' required='true'>
		<cfargument name='Emes' type='numeric' required='true'>
		<cfargument name='Efecha' type='date' required='true'>
		<cfargument name='Edescripcion' type='string' required='true'>		
		<cfargument name='Edocbase' type='string' required='true'>
		<cfargument name='Ereferencia' type='string' required='true' default=''>
		<cfargument name='debug' type='boolean' required='false' default='no'>
		<cfargument name='interfazconta' type='boolean' required='false' default='yes'>
		<cfargument name='NAP' type='string' required='false' default="">

		<cfargument name='Ecodigo' type='numeric' required='false' default="0">
		<cfargument name='Conexion' type='string' required='false' default="">
		<cfargument name='Ocodigo' type='numeric' required='false' default="">		<!--- Oficina del Documento --->
		<cfargument name='Usucodigo' type='numeric' required='false' default='#Session.Usucodigo#'>
		
		<cfargument name='PintaAsiento' type='boolean' required='false' default='no'>
		<cfargument name='Retroactivo' type='boolean' required='false' default="#false#">	
		<cfargument name='Intercompany' type='boolean' 	required='false' default="false">	
		<cfargument name='CPNAPIid' type='string' 		required='false' default="">
		<cfargument name='CierreAnual' type='boolean' 	required='false' default="false">

		<!--- 
			Asiento  Retroactivo: Genera Asiento inverso en el primer día del siguientes mes, esto lo hace en 
			el Cierre de Mes de Contabilidad. En este Componente Afecta de la siguiente manera: 
				1. No Valida que  la fecha del  Asiento sea mayor al Periodo/Mes de La Conta y / o Auxiliares y / o 
				Fecha de Cierre de la Conta, 
				2. ECtipo = 2.

			Asiento  Intercompany: Genera Asiento intercompany 
				1. ECtipo = 20.

			CierreAnual:  Solo debe aplicar cuando es invocado desde Contabilidad.cfc, en los asientos de cierre de mes --->
		--->


		
		<cfif (not isdefined("arguments.ecodigo")) or arguments.Ecodigo EQ 0>
			<cfset arguments.ecodigo = session.Ecodigo>
		</cfif>
		<cfif (not isdefined("arguments.conexion")) or arguments.conexion EQ "">
			<cfset arguments.conexion = session.dsn>
		</cfif>
		<cfif (not isdefined("arguments.usuario"))>
			<cfset arguments.usuario = session.usuario>
		</cfif>

		<!--- ignora lineas sin monto --->
		<cfquery datasource="#Arguments.Conexion#">
			delete from #Request.intarc#
			 where INTMON = 0 AND INTMOE = 0 
		</cfquery>

		<!--- ignora los asientos sin líneas --->
		<cfquery datasource="#Arguments.Conexion#" name="INTARC_count">
			select count(1) INTARC_count from #Request.intarc#
		</cfquery>
		<cfif INTARC_count.INTARC_count is 0>
			<cfif Arguments.debug><cfdump var="#INTARC_count#" label="INTARC_count"></cfif>
			<cfif Arguments.PintaAsiento><cf_errorCode	code = "51060" msg = "No se puede pintar el asiento porque no contiene lineas"></cfif>
			<cfreturn 0>
		</cfif>
		<cfquery name="rsVerCtasPresupuesto" datasource="#arguments.conexion#">
			select count(1) as Cuentas
			from CPresupuesto
			where Ecodigo = #arguments.ecodigo#
		</cfquery>

		<!--- Inicializa Arguments.Intercompany --->

		<!--- Actualiza las CFcuenta en blanco para obtener de ahí el Ecodigo --->
		<cfquery name="rsIntercompany" datasource="#Arguments.Conexion#">
			update #Request.intarc#
			   set CFcuenta =
					(
						select min(cf2.CFcuenta) 
						  from CFinanciera cf2
						 where cf2.Ccuenta = #Request.intarc#.Ccuenta
					)
			 where #Request.intarc#.CFcuenta IS NULL
		</cfquery>

		<!--- Verifica que la corporacion tenga más de una empresa, para evitar bloqueos --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select cliente_empresarial as CEcodigo
			  from Empresas
			 where Ecodigo = #arguments.ecodigo#		
		</cfquery>

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select count(1) as CantidadEmpresas
			  from Empresas e
			 where e.cliente_empresarial = #rsSQL.CEcodigo#
		</cfquery>

		<cfif rsSQL.CantidadEmpresas GT 1>
			<!--- Determina si el Asiento es Intercompany, pero si no lo es y se indicó da error --->
			<cfquery name="rsIntercompany" datasource="#Arguments.Conexion#">
				select distinct cf.Ecodigo 
				  from #Request.intarc# i 
					inner join CFinanciera cf
					   on cf.CFcuenta = i.CFcuenta
			</cfquery>
	
			<cfif rsIntercompany.RecordCount GT 1>
				<cfset Arguments.Intercompany = true>
			<cfelseif Arguments.Intercompany>
				<cf_errorCode	code = "51061" msg = "Se envió a generar un asiento intercompany pero no se enviaron cuentas de diferentes empresas o se enviaron en cero">
			</cfif>
		<cfelseif Arguments.Intercompany>
			<cf_errorCode	code = "51062" msg = "Se envió a generar un asiento intercompany pero sólo existe una empresa">
		</cfif>

		<!--- Validacion de Cuentas (advv - 28 julio 2005) --->	
		<cfset Var_Efecha = dateformat(Arguments.Efecha,"yyyymm")>
		<cfif not Arguments.CierreAnual>
			<cfset CG_ValidacionesAsiento(Arguments.Efecha, Var_Efecha, Arguments.Conexion, (Arguments.Oorigen EQ "OBLQ"))>
		</cfif>
		<!--- 
			Parametro para verificar si hay que validar el periodo y mes contra la fecha del asiento a generar o aplicar
		--->
		<cfquery datasource="#Arguments.Conexion#" name="chkFechasGenAplicar">
			select Pvalor from Parametros
			where Ecodigo = #session.Ecodigo#
			  and Pcodigo = 700
		</cfquery>
		<cfif chkFechasGenAplicar.recordCount and chkFechasGenAplicar.Pvalor EQ 'S' and not arguments.Retroactivo and not arguments.CierreAnual>
			<!--- Validar que la fecha se encuentre dentro del mismo periodo y mes --->
			<cfif Year(Arguments.Efecha) NEQ Arguments.Eperiodo or Month(Arguments.Efecha) NEQ Arguments.Emes>
				<cf_errorCode	code = "51063" msg = "El período y el mes del asiento debe coincidir con la fecha del asiento a generar.">
			</cfif>
		</cfif>
		
		<!--- Revisar que la fecha del documento sea mayor a la fecha de cierre de la contabilidad --->
		<cfset FechaCierreConta = CreateDate(1900, 01, 01)>
		<cfquery name="rsParamCerrada" datasource="#Arguments.Conexion#">
			select Pvalor
			from Parametros
			where Ecodigo = #Arguments.Ecodigo#
			and Pcodigo = 670
		</cfquery>
		<!--- Revisar que la fecha de cierre de la contabilidad se haya definido --->		
		<cfif not isdefined('rsParamCerrada.Pvalor') or LEN(TRIM(rsParamCerrada.Pvalor)) EQ 0>
			<cf_errorCode	code = "51064" msg = "La fecha de cierre de la contabilidad no se ha definido.">
		</cfif>
		<cfif rsParamCerrada.recordCount and Len(Trim(rsParamCerrada.Pvalor))>
			<cfset FechaCierreConta = LSParseDateTime(rsParamCerrada.Pvalor)>
		</cfif>
		
		<cfif DateCompare(Arguments.Efecha, FechaCierreConta) LT 1 and not arguments.Retroactivo>
            <cf_errorCode	code = "51065"
            				msg  = "La fecha del asiento a generar @errorDat_1@ debe ser mayor a la fecha de cierre de la contabilidad (@errorDat_2@)."
            				errorDat_1="#DateFormat(Arguments.Efecha,'dd/mm/yyyy')#"
            				errorDat_2="#DateFormat(FechaCierreConta,'dd/mm/yyyy')#"
            >
		</cfif>
		
		<!--- Generacion de Asientos Contables desde Modulo Auxiliar --->
		<cfif Not IsDefined('Arguments.Cconcepto') or Arguments.Cconcepto EQ -10>
			<!--- Esta tabla no puede estar vacía --->
			<cfquery datasource="#Arguments.Conexion#" name="ConceptoContable">
				select Cconcepto
				from ConceptoContable
				where Ecodigo = #Arguments.Ecodigo#
				  and Oorigen = '#Arguments.Oorigen#'
			</cfquery>
			
			<cfif ConceptoContable.Cconcepto eq "">
				<cfquery datasource="#Arguments.Conexion#" name="rsSQL">
					select Odescripcion
					from Origenes
					where Oorigen = '#Arguments.Oorigen#'
				</cfquery>
				<cf_errorCode	code = "51066"
								msg  = "No se ha definido el Concepto Contable para el Origen '@errorDat_1@=@errorDat_2@'."
								errorDat_1="#Arguments.Oorigen#"
								errorDat_2="#rsSQL.Odescripcion#"
				>
			</cfif>

			<cfset Arguments.Cconcepto = ConceptoContable.Cconcepto>
		<cfelse>
			<!--- Se valida el concepto --->
			<cfquery datasource="#Arguments.Conexion#" name="rsValidaConcepto">
			select count(1) as encontrado
			from ConceptoContableE
			where Ecodigo   = #Arguments.Ecodigo#
			  and Cconcepto = #Arguments.Cconcepto#
			</cfquery>
			
			<cfif rsValidaConcepto.encontrado eq 0>
				<cf_errorCode	code = "51067" msg = "El concepto suministrado como parametro no existe para esta compañía.">
			</cfif>
			
		</cfif>

		<cfif Arguments.interfazconta>
			<!--- 1 Obtener el numero del asiento - Edocumento --->
			<cfinvoke component="Contabilidad" method="Nuevo_Asiento" returnvariable="Edocumento">
				<cfinvokeargument name="Ecodigo" value="#Arguments.Ecodigo#">
				<cfinvokeargument name="Conexion" value="#Arguments.Conexion#">
				<cfinvokeargument name="Cconcepto" value="#Arguments.Cconcepto#">
				<cfinvokeargument name="Oorigen" value="#Arguments.Oorigen#">
				<cfinvokeargument name="Eperiodo" value="#Arguments.Eperiodo#">
				<cfinvokeargument name="Emes" value="#Arguments.Emes#">
				<cfif isdefined("Arguments.Ocodigo")>
					<cfinvokeargument name="Ocodigo" value="#Arguments.Ocodigo#">
				</cfif>
				<cfif isdefined("Arguments.Usucodigo")>
					<cfinvokeargument name="Usucodigo" value="#Arguments.Usucodigo#">
				</cfif>
				<cfinvokeargument name="Efecha" value="#Arguments.Efecha#">
			</cfinvoke>
			<cfquery name="rsObtieneLvaridentity" datasource="#Arguments.Conexion#">
				select IDcontable 
				from EContables
				where Ecodigo = #Arguments.Ecodigo#
				  and Cconcepto = #Arguments.Cconcepto#
				  and Edocumento = #Edocumento#
				  and Eperiodo = #Arguments.Eperiodo#
				  and Emes = #Arguments.Emes#
				  and ECestado = 0
			</cfquery>
			<cfif rsObtieneLvaridentity.recordcount GT 0>
				<cfset Lvaridentity = rsObtieneLvaridentity.IDcontable>
			<cfelse>
				<cfset Lvaridentity = "">
			</cfif>
		</cfif><!--- Arguments.interfazconta --->
		<!--- <cf_dump var="Lvaridentity es: #Lvaridentity#"> --->
		<cfif Arguments.debug>
			<cfquery datasource="#Arguments.Conexion#" name="intarcquery">
				select * from #Request.intarc#
			</cfquery>
			<cfdump var="#intarcquery#" label="INTARC GeneraAsiento (antes)">

			<cfquery datasource="#Arguments.Conexion#" name="INTCAM2">
				select INTMON / INTMOE as INTCAM2, INTCAM, round(INTMOE * INTCAM, 2), round(INTMON, 2)
				from #Request.intarc#
				where INTMOE != 0
				  and round(INTMOE * INTCAM, 2) != round(INTMON, 2)
			</cfquery>
			<cfdump var="#INTCAM2#" label="INTCAM2 GeneraAsiento (antes)">
		</cfif>

		<cfquery datasource="#Arguments.Conexion#">
			update #Request.intarc#
			set INTCAM = INTMON / INTMOE
			where INTMOE != 0
			  and round(INTMOE * INTCAM, 2) != round(INTMON, 2)
		</cfquery>

		<!--- Redondea los montos a dos decimales --->
		<cfquery datasource="#Arguments.Conexion#">
			update #Request.intarc#
			set INTMON = round(INTMON, 2), INTMOE = round(INTMOE, 2)
		</cfquery>

		<!--- Modificar los datos según signo --->
		<cfquery datasource="#Arguments.Conexion#">
			update #Request.intarc#
			set INTTIP = 'D', INTMON = abs(INTMON), INTMOE = abs(INTMOE)
			where INTTIP = 'C'
			  and INTMON < 0
		</cfquery>
	
		<cfquery datasource="#Arguments.Conexion#">
			update #Request.intarc#
			set INTTIP = 'C', INTMON = abs(INTMON), INTMOE = abs(INTMOE)
			where INTTIP = 'D'
			  and INTMON < 0
		</cfquery>

		<!---
		3.  Insertar el Documento Contable 
		    Validar balance por moneda origen en #INTARC
		--->
		<cfquery datasource="#Arguments.Conexion#" name="Parametro100">
			select a.Pvalor, a.Ecodigo
			from Parametros a
			where a.Ecodigo = #Arguments.Ecodigo#
			  and a.Pcodigo = 100
		</cfquery>
		<cfif Len(Trim(Parametro100.Pvalor)) EQ 0>
		   	<cf_errorCode	code = "51068" msg = "No se ha definido correctamente la Cuenta Contable para<BR> saldos por redondeo de monedas en los Parámetros del Sistema. Proceso Cancelado! (Tabla: Parametros)">
		</cfif>
		<cfquery datasource="#Arguments.Conexion#" name="CuentaRedondeos">
			select b.Ccuenta
			from CContables b
			where b.Ecodigo = #Arguments.Ecodigo#
			  and b.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(Parametro100.Pvalor)#">
		</cfquery>
		<cfif Len(Trim(CuentaRedondeos.Ccuenta)) EQ 0>
			<cf_errorCode	code = "51069"
							msg  = "No existe la Cuenta Contable definida para saldos por <BR> redondeo de monedas en los Parámetros del Sistema. Proceso Cancelado! (Tabla: CContables, ID: @errorDat_1@)"
							errorDat_1="#Parametro100.Pvalor#"
			>
		</cfif>

		<cfquery datasource="#Arguments.Conexion#" name="cursorMonedas">
			select i.Mcodigo, m.Mnombre,
				sum(i.INTMOE * (case i.INTTIP when 'C' then -1 else 1 end)) as diferencia_original,
				sum(i.INTMON * (case i.INTTIP when 'C' then -1 else 1 end)) as diferencia_local
			from #Request.intarc# i join Monedas m
			  on i.Mcodigo = m.Mcodigo
			group by i.Mcodigo, m.Mnombre
		</cfquery>
		
		<cfif Arguments.debug and isdefined('cursorMonedas')>
			<cfdump var="#cursorMonedas#" label="cursorMonedas">
		</cfif>

		<cfset MonedasDesbalanceadas = "">
		<cfloop query="cursorMonedas">
			<cfif NumberFormat(cursorMonedas.diferencia_original, ',9.00') neq 0.00>
				<cfset MonedasDesbalanceadas = ListAppend(MonedasDesbalanceadas, cursorMonedas.Mnombre)>
			<cfelseif NumberFormat(cursorMonedas.diferencia_local, ',9.00') neq 0.00>
				<cfquery name = "rsMinLinea" datasource="#Arguments.Conexion#">
					select min(INTLIN) as MinLinea 
					from #Request.intarc#
					where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cursorMonedas.Mcodigo#">
				</cfquery>

				<cfset LvarMinLinea = rsMinLinea.MinLinea>

				<cfquery datasource="#Arguments.Conexion#">
					insert into #Request.intarc# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
					select a.INTORI, a.INTREL, 'AJ', 'AJ', 
						<cfqueryparam cfsqltype="cf_sql_money" value="#Abs(cursorMonedas.diferencia_local)#">,
						<cfif cursorMonedas.diferencia_local gt 0>'C'<cfelse>'D'</cfif>,
						'Balance de Saldos por Redondeo de Monedas', a.INTFEC, 0.00, a.Periodo, a.Mes,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#CuentaRedondeos.Ccuenta#">,
						a.Mcodigo, a.Ocodigo, 0.00
					from #Request.intarc# a
					where INTLIN = #LvarMinLinea#
				</cfquery>
			</cfif>
		</cfloop>

		<cfif Len(Trim(MonedasDesbalanceadas))>
			<cfreturn -101>
		</cfif>

		<!---
		3.1. Balance por Sucursal (Balance por Oficina) No se hace si es intercompany
		--->
		<cfif NOT Arguments.Intercompany>	
			<cfquery datasource="#Arguments.Conexion#" name="Parametro90">
				select a.Pvalor
				from Parametros a
				where a.Ecodigo = #Arguments.Ecodigo#
				  and a.Pcodigo = 90
			</cfquery>
			<cfif Len(Trim(Parametro90.Pvalor)) EQ 0>
				<cf_errorCode	code = "51071" msg = "No se ha definido correctamente la Cuenta Contable para<BR> movimiento entre sucursales en los Parámetros del Sistema. Proceso Cancelado! (Tabla: Parametros)">
			</cfif>
			<cfquery datasource="#Arguments.Conexion#" name="CuentaSaldosOficina">
				select b.Ccuenta
				from CContables b
				where b.Ecodigo = #Arguments.Ecodigo#
				  and b.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Parametro90.Pvalor#">
			</cfquery>
			<cfif Len(Trim(CuentaSaldosOficina.Ccuenta)) EQ 0>
				<cf_errorCode	code = "51072"
								msg  = "No existe la Cuenta Contable definida para movimiento entre<BR> sucursales en los Parámetros del Sistema. Proceso Cancelado! (Tabla: CContables, ID: @errorDat_1@)"
								errorDat_1="#Parametro90.Pvalor#"
				>
			</cfif>
			
			<cfquery datasource="#Arguments.Conexion#" name="distinctOcodigo">
				select count(distinct Ocodigo) cnt from #Request.intarc#
			</cfquery>
			<cfif distinctOcodigo.cnt gt 1>
				<!--- Insertar los créditos --->
				<cfquery datasource="#Arguments.Conexion#">
				insert into #Request.intarc# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
				select min(a.INTORI), min(a.INTREL), 'AJ', 'AJ', abs(sum(a.INTMON * (case a.INTTIP when 'C' then -1 else 1 end))),
					case when sum(a.INTMON * (case a.INTTIP when 'C' then -1 else 1 end)) > 0 then 'C' else 'D' end,
					'Balance de Saldos por Oficina', min(a.INTFEC), abs(min(a.INTMON/a.INTMOE)), min(a.Periodo), min(a.Mes),
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#CuentaSaldosOficina.Ccuenta#">,
					a.Mcodigo, a.Ocodigo, abs(sum(a.INTMOE * (case a.INTTIP when 'C' then -1 else 1 end)))
				from #Request.intarc# a
                where a.INTMOE <> 0
				group by a.Mcodigo, a.Ocodigo
				having abs(sum(a.INTMOE * (case a.INTTIP when 'C' then -1 else 1 end))) != 0
				</cfquery>
			</cfif>	
		</cfif>

		<cfif Arguments.debug>
			<cfquery datasource="#Arguments.Conexion#" name="intarcquery">
				select * from #Request.intarc#
			</cfquery>
			<cfdump var="#intarcquery#" label="INTARC GeneraAsiento (después)">
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#" name="balanceado">
			select abs(round(sum(case when INTTIP = 'C' then - INTMON else INTMON end),2)) balance
			from #Request.intarc#
		</cfquery>
		<!--- Validar que el asiento esté balanceado --->
		<cfif NumberFormat(balanceado.balance, ',9.00') neq 0.00>
			<cf_errorCode	code = "51073"
							msg  = "La póliza no esta Balanceada en Moneda Local. Hay una diferencia de @errorDat_1@. Proceso Cancelado!"
							errorDat_1="#balanceado.balance#"
			>
		</cfif>
		
		<cfset LvarBanderaBorrado = false>
		<!--- Verificar si tiene que borrar lineas en cero --->
		<cfquery name="rsLineasBorrar" datasource="#Arguments.Conexion#">
			select count(1) as CantidadLineas
			from #Request.intarc#
			where INTMON = 0.00 and INTMOE = 0.00
		</cfquery>

		<cfif rsLineasBorrar.CantidadLineas GT 0>
			<cfquery datasource="#Arguments.Conexion#">
				delete from #Request.intarc#
				where INTMON = 0.00 and INTMOE = 0.00
			</cfquery>
			<cfset LvarBanderaBorrado = true>
		</cfif>


		<cfif Arguments.debug>
			<cfquery datasource="#Arguments.Conexion#" name="intarcquery">
				select * from #Request.intarc#
			</cfquery>
			<cfdump var="#intarcquery#" label="INTARC PRES_Presupuesto (despues de borrar montos en cero)">
		</cfif>

		<!--- Validar que las cuentas existan antes de que se inserten los datos
			Aunque esto lo hace la integridad referencial, aquí podemos avisar cuál es la cuenta que da error
		--->
		<cfquery datasource="#Arguments.Conexion#" name="cuenta_no_existe">
			select distinct Ccuenta, INTDES 
			from #Request.intarc# x
			where CFcuenta is NULL 
			  AND not exists (select 1 from CContables y where x.Ccuenta = y.Ccuenta)
		</cfquery>
		
		<cfif cuenta_no_existe.RecordCount neq 0>
			<cf_errorCode	code = "51074"
							msg  = "Cuentas contables no existen: @errorDat_1@ para @errorDat_2@"
							errorDat_1="#ValueList(cuenta_no_existe.Ccuenta)#"
							errorDat_2="#ValueList(cuenta_no_existe.INTDES)#"
			>
			<cfdump var="#cuenta_no_existe#" label="Ccuenta que no existen">
			<cfabort>
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#" name="cuenta_no_existe">
			select distinct CFcuenta, INTDES 
			from #Request.intarc# x
			where CFcuenta is NOT NULL 
			  AND not exists (select 1 from CFinanciera y where x.CFcuenta = y.CFcuenta)
		</cfquery>
		
		<cfif cuenta_no_existe.RecordCount neq 0>
			<cf_errorCode	code = "51075"
							msg  = "Cuentas Financieras no existen: @errorDat_1@ para @errorDat_2@"
							errorDat_1="#ValueList(cuenta_no_existe.CFcuenta)#"
							errorDat_2="#ValueList(cuenta_no_existe.INTDES)#"
			>
			<cfdump var="#cuenta_no_existe#" label="CFcuenta que no existen">
			<cfabort>
		</cfif>

		<cfif Arguments.CierreAnual or rsVerCtasPresupuesto.Cuentas EQ 0>
			<cfset Arguments.NAP = "0">
			<cfset Arguments.CPNAPIid = "">
		</cfif>

		<cfif Arguments.NAP EQ "">
			<cfinvoke 
				 component		= "PRES_Presupuesto"
				 method			= "ControlPresupuestarioINTARC"
				 returnvariable	= "LvarIC">
						<cfinvokeargument name="ModuloOrigen"  		value="#Arguments.Oorigen#"/>
						<cfinvokeargument name="NumeroDocumento" 	value="#Arguments.Edocbase#"/>
						<cfinvokeargument name="NumeroReferencia" 	value="#Arguments.Ereferencia#"/>
						<cfinvokeargument name="FechaDocumento" 	value="#Arguments.Efecha#"/>
						<cfinvokeargument name="AnoDocumento"		value="#Arguments.Eperiodo#"/>
						<cfinvokeargument name="MesDocumento"		value="#Arguments.Emes#"/>
						<cfinvokeargument name="Conexion" 			value="#Arguments.Conexion#"/>
						<cfinvokeargument name="Ecodigo" 			value="#Arguments.Ecodigo#"/>
						<cfinvokeargument name="Intercompany" 		value="#Arguments.Intercompany#"/>
			</cfinvoke>

			<cfset LvarNAP = LvarIC.NAP>
			<cfif LvarIC.Intercompany>
				<cfset LvarCPNAPIid = LvarIC.CPNAPIid>
			<cfelse>
				<cfset LvarCPNAPIid = "">
			</cfif>

			<cfif LvarNAP LT 0>
				<cflocation url="/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=#abs(LvarNAP)#">
			</cfif>
		<cfelse>
			<cfset LvarNAP = Arguments.NAP>
			<cfset LvarCPNAPIid = Arguments.CPNAPIid>
		</cfif>
		
		<cfif Arguments.PintaAsiento>
			<cfreturn -102>
		</cfif>
		
		<cfif Arguments.interfazconta AND LvarNAP GTE 0>
			<cfif Lvaridentity EQ "">
				<cfquery datasource="#Arguments.Conexion#" name="insert_Econtables">
					insert into EContables (
						Ecodigo, Cconcepto,	Eperiodo, Emes,
						Edocumento, Efecha, Edescripcion,
						Edocbase, Ereferencia, ECauxiliar, ECusuario, 
						Oorigen, Ocodigo, ECusucodigo, ECfechacreacion, 
						ECipcrea, ECestado, BMUsucodigo, NAP, CPNAPIid
						<cfif arguments.retroactivo or Arguments.Intercompany>, ECtipo</cfif>
						)
					values ( 
						#Arguments.Ecodigo#, 
						#Arguments.Cconcepto#, 
						#Arguments.Eperiodo#, 
						#Arguments.Emes#, 
						
						#Edocumento#, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Efecha#">,
						'#Arguments.Edescripcion#',
						
						'#Left(Arguments.Edocbase, 20)#',
						'#Arguments.Ereferencia#',
						'S',
						'#Arguments.usuario#',
						'#Arguments.Oorigen#',
						<cfif isdefined("Arguments.Ocodigo") and Len(Trim(Arguments.Ocodigo)) GT 0 and Arguments.Ocodigo GT -1>
							#Arguments.Ocodigo#,
						<cfelse>
							null,
						</cfif>
						#Arguments.Usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						'#Session.sitio.ip#',
						0,
						#Arguments.Usucodigo#,
						#LvarNAP#,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPNAPIid#" null="#LvarCPNAPIid EQ ""#">
						
						<cfif arguments.retroactivo>, 2<cfelseif Arguments.Intercompany>, 20</cfif>
						)

					<cf_dbidentity1 verificar_transaccion="no" datasource="#Arguments.Conexion#">
				</cfquery>
				<cf_dbidentity2 name="insert_Econtables" verificar_transaccion="no" datasource="#Arguments.Conexion#">
				<cfset Lvaridentity = insert_Econtables.identity>
			</cfif>
			
			<!---
			4. Incluir la referencia del numero en la tabla #asiento para actualizar el sistema auxiliar 
			   // se cambia, ahora va a ser la variable de retorno //
			   // que pasaba antes si no habia registros en #asiento al regresar de aqui ? //
			   // el valor en el documento del auxiliar seguramente quedaba en null //
			--->
			
			<!---
			5. Insertar las lineas del documento, a partir de la ultima linea del asiento actual
			--->

			<cfset lvarlinea = 0>
			<cfquery name = "rsObtieneLinea" datasource="#Arguments.Conexion#">
				select max(Dlinea) as Linea
				from DContables d
				where d.IDcontable = #Lvaridentity#
			</cfquery>

			<cfif rsObtieneLinea.recordcount GT 0 and rsObtieneLinea.Linea GT 0>
				<cfset lvarLinea = rsObtieneLinea.Linea>
			<cfelse>
				<cfset lvarlinea = 0>
			</cfif>

			<cfif len(lvarlinea) lt 1>
				<cfset lvarLinea = 0>
			</cfif>

			<cfif ListFind('sybase,sqlserver', Application.dsinfo[Arguments.conexion].type)>
				<!--- renumerar las lineas en la tabla temporal para no dejar agujeros
					Aquí nos valemos de que:
					1) Sybase actualiza los registros en orden del indice clustered (IDcontable, Dlinea)
					2) el incremento de @n se realiza para cada registro
					
					Temporalmente, se fuerza a que se regeneren las lineas del asiento en tabla temporal
				--->
				<cfset LvarBanderaBorrado = true>
				<cfif LvarBanderaBorrado>
					<cfquery datasource="#Arguments.Conexion#">
						declare @n int
						select @n = #lvarLinea# + 1
	
						update #Request.intarc#
						set Dlinea = @n, @n = @n + 1
					</cfquery>
				<cfelse>				
					<cfquery datasource="#Arguments.Conexion#">
						update #Request.intarc#
						set Dlinea = INTLIN + #lvarLinea#
					</cfquery>
				</cfif>

			<cfelseif Application.dsinfo[Arguments.conexion].type is 'oracle'>
				<!--- Se usa rownum en el insert, y las secuencias estarán bien --->
			<cfelse>
				<cf_errorCode	code = "51076"
								msg  = "DBMS no soportada en CG_GeneraAsiento.GeneraAsiento: @errorDat_1@"
								errorDat_1="#Application.dsinfo[Arguments.conexion].type#"
				>
			</cfif>
			
			<cfquery datasource="#Arguments.Conexion#">
				insert into DContables (
					 IDcontable, Dlinea, Ecodigo, Cconcepto,
					 Eperiodo, Emes, Edocumento, Ddocumento,
					 Ocodigo, Ddescripcion, Dmovimiento, 
					 Ccuenta, CFcuenta,
					 Doriginal, Dlocal, Mcodigo, Dtipocambio, Dreferencia, CFid)
				select 
					#Lvaridentity#,
					<cfif ListFind('sybase,sqlserver', Application.dsinfo[Arguments.conexion].type)>
					Dlinea
					<cfelseif Application.dsinfo[Arguments.conexion].type is 'oracle'>
					ROWNUM + #lvarLinea#
					<cfelse>
						<cf_errorCode	code = "51076"
										msg  = "DBMS no soportada en CG_GeneraAsiento.GeneraAsiento: @errorDat_1@"
										errorDat_1="#Application.dsinfo[Arguments.conexion].type#"
						>
					</cfif>,
					#Arguments.Ecodigo#,
					#Arguments.Cconcepto#,
					
					#Arguments.Eperiodo#,
					#Arguments.Emes#,
					#Edocumento#,
					INTDOC,
					
					Ocodigo, INTDES, INTTIP, 
					CASE 
						WHEN CFcuenta IS NOT NULL AND Ccuenta = 0
						THEN 
							(select min(Ccuenta) 
							   from CFinanciera
							  where CFinanciera.CFcuenta = #Request.intarc#.CFcuenta
							)
						ELSE
							Ccuenta
					END,
					CASE 
						WHEN CFcuenta IS NOT NULL
							THEN CFcuenta
						ELSE
							(select min(CFcuenta) 
							   from CFinanciera
							  where CFinanciera.Ccuenta = #Request.intarc#.Ccuenta
							)
					END,
					round(INTMOE, 2), round(INTMON, 2), Mcodigo, INTCAM, INTREF, CFid
				from #Request.intarc#
				order by INTLIN
			</cfquery>

			<cfreturn Lvaridentity>

		</cfif><!--- Arguments.interfazconta --->
		
		<cfreturn 0>
	</cffunction>
	
	<!--- 
		Se incluyó esta funcion para realizar validaciones de:
			- Control de Obras               (Formato + Ocodigo)
			- Control de Plan de Cuentas     (Niveles + Ocodigo)
			- Control de Cuentas Inactivas   (Niveles)          
			- Control de Reglas Financieras  (Formato + Ocodigo)
	--->
	<cffunction name="CG_ValidacionesAsiento" access="public">
		<cfargument name="Efecha"			type="date" 	required="yes">
		<cfargument name="VEfecha"			type="numeric"	required="no">
		<cfargument name="Conexion"			type="string"	default="#session.dsn#">
		<cfargument name="NoVerificarObras"	type="boolean" 	default="false">
		<!--- OJO:	NoVerificarObras debe utilizarse únicamente en el Sistema de Obras, 
					para que se brinca el Control de Obras en la Liquidacion --->
		
		<cfif not isdefined("Arguments.VEfecha")>
			<cfset Var_Efecha = dateformat(Now(),"yyyymm")>
		<cfelse>
			<cfset Var_Efecha = Arguments.VEfecha>
		</cfif>
		
		<cfinvoke 	component		 = "PC_VerificaCuentasFinancieras"
					method			 = "VerificaINTARC"
					returnvariable	 = "LvarMSG"
					
					Efecha			 = "#Arguments.Efecha#"
					datasource		 = "#Arguments.Conexion#"
					NoVerificarObras = "#Arguments.NoVerificarObras#"
		>
		<cfif LvarMSG NEQ "OK">
			<cfthrow message="#LvarMSG#">
		</cfif>
		
		<cfreturn>

	</cffunction>
	
	<!--- Se incluyó funcion para validar querys (ADVV) --->
	<cffunction name="fnExists" output="false" access="private">
		<cfargument name="LvarSQL">

		<cfif isDefined("session.dsn") and not isDefined("arguments.LvarDatasource")>
			<cfset arguments.LvarDatasource = session.dsn>
		</cfif>

		<cfquery name="rsExists" datasource="#session.dsn#" >
			select count(1) as cantidad from dual where exists(#preservesinglequotes(LvarSQL)#)
		</cfquery>
		<cfreturn (rsExists.cantidad EQ 1)>
	</cffunction>	

	<cffunction name="PintaAsiento" output="true" access="public">
		<cfargument name='Oorigen' 		type="string" 	required='true'>		
		<cfargument name='Cconcepto' 	type="numeric" 	required='no'>		<!--- Concepto de Asiento --->
		<cfargument name='Eperiodo' 	type='numeric' 	required='true'>
		<cfargument name='Emes' 		type='numeric' 	required='true'>
		<cfargument name='Efecha' 		type='date' 	required='true'>
		<cfargument name='Edescripcion' type='string' 	required='true'>		
		<cfargument name='Edocbase' 	type='string' 	required='true'>
		<cfargument name='Ereferencia' 	type='string' 	required='true' default=''>

		<cfargument name='Ecodigo' 		type='numeric' 	required='false'>
		<cfargument name='Conexion' 	type='string' 	required='false'>

		<cfif (not isdefined("arguments.ecodigo"))>
			<cfset arguments.ecodigo = session.Ecodigo>
		</cfif>
		<cfif (not isdefined("arguments.conexion"))>
			<cfset arguments.conexion = session.dsn>
		</cfif>

		<!--- Generacion de Asientos Contables desde Modulo Auxiliar --->
		<cfif Not IsDefined('Arguments.Cconcepto') or Arguments.Cconcepto EQ -10>
			<!--- Esta tabla no puede estar vacía --->
			<cfquery datasource="#Arguments.Conexion#" name="ConceptoContable">
				select Cconcepto
				from ConceptoContable
				where Ecodigo = #Arguments.Ecodigo#
				  and Oorigen = '#Arguments.Oorigen#'
			</cfquery>
			
			<cfif ConceptoContable.Cconcepto eq "">
				<cfquery datasource="#Arguments.Conexion#" name="rsSQL">
					select Odescripcion
					from Origenes
					where Oorigen = '#Arguments.Oorigen#'
				</cfquery>
				<cf_errorCode	code = "51066"
								msg  = "No se ha definido el Concepto Contable para el Origen '@errorDat_1@=@errorDat_2@'."
								errorDat_1="#Arguments.Oorigen#"
								errorDat_2="#rsSQL.Odescripcion#"
				>
			</cfif>

			<cfset Arguments.Cconcepto = ConceptoContable.Cconcepto>
		</cfif>
		<!--- Se valida el concepto --->
		<cfquery datasource="#Arguments.Conexion#" name="rsConceptoContableE">
			select Cdescripcion
			  from ConceptoContableE
			 where Ecodigo   = #Arguments.Ecodigo#
			   and Cconcepto = #Arguments.Cconcepto#
		</cfquery>
		<cfif rsConceptoContableE.recordCount eq 0>
			<cf_errorCode	code = "51077"
							msg  = "El Concepto Contable '@errorDat_1@' no existe para esta compañía."
							errorDat_1="#Arguments.Cconcepto#"
			>
		</cfif>

		<!--- Modificar los datos según signo --->
		<cfquery datasource="#Arguments.Conexion#">
			update #Request.intarc#
			set INTTIP = 'D', INTMON = abs(INTMON), INTMOE = abs(INTMOE)
			where INTTIP = 'C'
			  and INTMON < 0
		</cfquery>
	
		<cfquery datasource="#Arguments.Conexion#">
			update #Request.intarc#
			set INTTIP = 'C', INTMON = abs(INTMON), INTMOE = abs(INTMOE)
			where INTTIP = 'D'
			  and INTMON < 0
		</cfquery>
	
		<cfquery name="rsEmpresa" datasource="#session.dsn#">
			select Edescripcion
			  from Empresas
			 where Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		
		<cfquery name="rsAsiento" datasource="#session.dsn#">
			select 	INTLIN,
					case 
						when coalesce(i.Ccuenta,0) = 0 then 
							( 
								select c.Cformato 
								  from CFinanciera cf 
									inner join CContables c 
										on c.Ccuenta = cf.Ccuenta 
								 where cf.CFcuenta = i.CFcuenta
							) 
						else
							( 
								select c.Cformato 
								  from CContables c
								 where c.Ccuenta = i.Ccuenta
							) 
					end as Cformato,
					i.Ccuenta, i.CFcuenta,
					INTDES,
					INTDOC,
					INTREF,
					INTTIP,
					Miso4217, Oficodigo,
					INTMOE,
					INTCAM,
					INTMON,
                    CFid
			  from #request.INTARC# i
				left join Monedas m
					 on m.Mcodigo = i.Mcodigo
				left join Oficinas o
					 on o.Ecodigo = #Arguments.Ecodigo#
					and o.Ocodigo = i.Ocodigo
		</cfquery>

		<cfquery name="rsBalXMoneda" datasource="#session.dsn#">
			select 	Miso4217, 
					sum(case when INTTIP='D' then INTMOE else 0 end) as DBs,
					sum(case when INTTIP='C' then INTMOE else 0 end) as CRs
			  from #request.INTARC# i
				left join Monedas m
					 on m.Mcodigo = i.Mcodigo
			group by Miso4217
		</cfquery>
		<cfquery name="rsBalXMonedaXOficina" datasource="#session.dsn#">
			select 	Miso4217, Oficodigo,
					sum(case when INTTIP='D' then INTMOE else 0 end) as DBs,
					sum(case when INTTIP='C' then INTMOE else 0 end) as CRs
			  from #request.INTARC# i
				left join Monedas m
					 on m.Mcodigo = i.Mcodigo
				left join Oficinas o
					 on o.Ecodigo = #Arguments.Ecodigo#
					and o.Ocodigo = i.Ocodigo
			group by Miso4217, Oficodigo
		</cfquery>
		<cf_templatecss>
			<font size="5">
				#Arguments.Edescripcion#
			</font>
			<BR>
			<font color="##0000FF" size="4">
				Empresa: #rsEmpresa.Edescripcion#
			</font>
			<BR>
		<table border="0" cellspacing="0" cellpadding="2" style="border:1px solid ##000000;">
			<tr>
				<td>
					Concepto:&nbsp;#rsConceptoContableE.Cdescripcion#&nbsp;
				</td>
				<td>
					Periodo:&nbsp;#Arguments.Eperiodo# Mes #Arguments.Emes#&nbsp;
				</td>
				<td>
					Fecha: #dateFormat(Arguments.Efecha,"DD/MM/YYYYY")#&nbsp;
				</td>
			</tr>
			<tr>
				<td>
					Origen: #Arguments.Oorigen#&nbsp;
				</td>
				<td>
					Referencia: #Arguments.Ereferencia#&nbsp;
				</td>
				<td>
					Documento: #Arguments.Edocbase#&nbsp;
				</td>
			</tr>
		</table>

		<table border="0" cellspacing="0" cellpadding="2" style="border:1px solid ##000000;">
			<tr>
				<td rowspan="2" style="background-color:##CCCCCC">
					Lin
				</td>
				<td rowspan="2" style="background-color:##CCCCCC">
					Descripcion
				</td>
				<td rowspan="2" style="background-color:##CCCCCC">
					Cuenta Contable
				</td>
				<td rowspan="2" style="background-color:##CCCCCC">
					Ref-Documento
				</td>
				<td rowspan="2" style="background-color:##CCCCCC">
					Oficina
				</td>
                <td rowspan="2" style="background-color:##CCCCCC">
					C. Funcional
				</td>
				<td rowspan="2" style="background-color:##CCCCCC">
					Tipo
				</td>
				<td rowspan="2" style="background-color:##CCCCCC">
					Moneda&nbsp;
				</td>
				<td colspan="2" align="center" style="background-color:##CCCCCC; border-bottom:1px solid ##000000">
					Monto Extranjero
				</td>
				<td rowspan="2" style="background-color:##CCCCCC" align="right">
					Tipo&nbsp;<BR>Cambio&nbsp;
				</td>
				<td colspan="2" align="center" style="background-color:##CCCCCC; border-bottom:1px solid ##000000">
					Monto Local
				</td>
			</tr>
			<tr>
				<td align="right" style="background-color:##CCCCCC; border-right:1px solid ##000000">
					Débito
				</td>
				<td style="background-color:##CCCCCC" align="right">
					Crédito
				</td>
				<td align="right" style="background-color:##CCCCCC; border-right:1px solid ##000000">
					Débito
				</td>
				<td align="right" style="background-color:##CCCCCC">
					Crédito
				</td>
			</tr>
		<cfset LvarDBs = 0>
		<cfset LvarCRs = 0>
		<cfloop query="rsAsiento">
			<tr>
				<td>
					#rsAsiento.INTLIN#
				</td>
				<td>
					#rsAsiento.INTDES#
				</td>
				<td>
					#trim(rsAsiento.Cformato)#
				</td>
				<td>
					#trim(rsAsiento.INTREF)# - #trim(rsAsiento.INTDOC)#
				</td>
				<td>
					#rsAsiento.Oficodigo#
				</td>
                <td>
					#rsAsiento.CFid#
				</td>
				<td align="center">
					#rsAsiento.INTTIP#
				</td>
				<td align="center">
					#rsAsiento.Miso4217#
				</td>
			<cfif rsAsiento.INTTIP EQ "D">
				<td align="right" style="border-right:1px solid ##000000">
					#numberformat(rsAsiento.INTMOE,",9.99")#
				</td>
				<td align="right">&nbsp;
					
				</td>
			<cfelse>
				<td align="right" style="border-right:1px solid ##000000">&nbsp;
					
				</td>
				<td align="right">
					#numberformat(rsAsiento.INTMOE,",9.99")#
				</td>
			</cfif>
				<td align="right">
					&nbsp;&nbsp;#numberformat(rsAsiento.INTCAM,",9.999999")#&nbsp;
				</td>
			<cfif rsAsiento.INTTIP EQ "D">
				<cfset LvarDBs = LvarDBs + INTMON>
				<td align="right" style="border-right:1px solid ##000000">
					#numberformat(rsAsiento.INTMON,",9.99")#
				</td>
				<td align="right">&nbsp;
					
				</td>
			<cfelse>
				<cfset LvarCRs = LvarCRs + INTMON>
				<td align="right" style="border-right:1px solid ##000000">&nbsp;
					
				</td>
				<td align="right">
					#numberformat(rsAsiento.INTMON,",9.99")#
				</td>
			</cfif>
			</tr>
		</cfloop>


			<tr>
				<td colspan="11" style="border-top:1px solid ##000000;border-bottom:1px solid ##000000;">
					<strong>BALANCE EN MONEDA LOCAL</strong>
				</td>
				<cfif numberformat(LvarDBs,",9.99") NEQ numberformat(LvarCRs,",9.99")>
					<cfset LvarColor = "color=##FF0000">
				<cfelse>
					<cfset LvarColor = "">
				</cfif>
				<td align="right" style="#LvarColor#;border-top:1px solid ##000000;border-bottom:1px solid ##000000;border-right:1px solid ##000000">
					&nbsp;&nbsp;<strong>#numberformat(LvarDBs,",9.99")#</strong>
				</td>
				<td align="right" style="#LvarColor#;border-top:1px solid ##000000;border-bottom:1px solid ##000000;">
					&nbsp;&nbsp;<strong>#numberformat(LvarCRs,",9.99")#</strong>
				</td>
			</tr>

			<tr style="height:1px;">
				<td colspan="13" style="border-top:1px solid ##000000; height:1px; font-size:1px;">&nbsp;
					
				</td>
			</tr>

			<tr>
				<td colspan="5" rowspan="#rsBalXMoneda.recordcount+1#" valign="top">
					<strong>BALANCE EN MONEDA EXTRANJERA</strong>
				</td>
			</tr>
			<cfloop query="rsBalXMoneda">
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>

				<td align="center">
					<strong>#rsBalXMoneda.Miso4217#</strong>
				</td>
	
				<cfif numberformat(rsBalXMoneda.DBs,",9.99") NEQ numberformat(rsBalXMoneda.CRs,",9.99")>
					<cfset LvarColor = "color=##FF0000">
				<cfelse>
					<cfset LvarColor = "">
				</cfif>
				<td align="right" style="#LvarColor#;border-right:1px solid ##000000">
					&nbsp;&nbsp;<strong>#numberformat(rsBalXMoneda.DBs,",9.99")#</strong>
				</td>
				<td align="right" style="#LvarColor#;">
					&nbsp;&nbsp;<strong>#numberformat(rsBalXMoneda.CRs,",9.99")#</strong>
				</td>
			</tr>
			</cfloop>


			<tr style="height:1px;">
				<td colspan="13" style="border-top:1px solid ##000000; height:1px; font-size:1px;">&nbsp;
					
				</td>
			</tr>

			<tr>
				<td colspan="4" rowspan="#rsBalXMonedaXOficina.recordcount+1#" valign="top">
					<strong>BALANCE EN MONEDA EXTRANJERA POR OFICINA</strong>
				</td>
			</tr>
			<cfloop query="rsBalXMonedaXOficina">
			<tr>
				<td>
					<strong>#rsBalXMonedaXOficina.Oficodigo#</strong>
				</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td align="center">
					<strong>#rsBalXMonedaXOficina.Miso4217#</strong>
				</td>
	
				<cfif numberformat(rsBalXMonedaXOficina.DBs,",9.99") NEQ numberformat(rsBalXMonedaXOficina.CRs,",9.99")>
					<cfset LvarColor = "color=##FF0000">
				<cfelse>
					<cfset LvarColor = "">
				</cfif>
				<td align="right" style="#LvarColor#;border-right:1px solid ##000000">
					&nbsp;&nbsp;<strong>#numberformat(rsBalXMonedaXOficina.DBs,",9.99")#</strong>
				</td>
				<td align="right" style="#LvarColor#;">
					&nbsp;&nbsp;<strong>#numberformat(rsBalXMonedaXOficina.CRs,",9.99")#</strong>
				</td>
			</tr>
			</cfloop>
		</table>
		<BR>
	</cffunction>

	<cffunction name="BalanceoMonedaOficina" output="false" access="public">
		<cfargument name='Ecodigo' type='numeric' required='false'>
		<cfargument name='Conexion' type='string' required='false'>

		<cfif (not isdefined("arguments.ecodigo"))>
			<cfset arguments.ecodigo = session.Ecodigo>
		</cfif>
		<cfif (not isdefined("arguments.conexion"))>
			<cfset arguments.conexion = session.dsn>
		</cfif>

		<!--- Verifica que el Asiento esté Balanceado en Moneda Local --->
		<cfquery name="rsBalXMonedaOficina" datasource="#arguments.conexion#">
			select 	sum(case when INTTIP = 'D' then INTMON else -INTMON end) 	as DIF, 
					sum(0.05) 													as PERMIT,  <!--- 0.005 --->
					sum(case when INTTIP = 'D' then INTMON end) 				as DBS, 
					sum(case when INTTIP = 'C' then INTMON end) 				as CRS
			  from #request.INTARC#
		</cfquery>
		<cfif rsBalXMonedaOficina.PERMIT EQ "" or rsBalXMonedaOficina.PERMIT EQ 0 >
		   <cf_errorCode	code = "51078" msg = "El Asiento Generado está vacío. Proceso Cancelado!">
		</cfif>
		
		<cfif abs(rsBalXMonedaOficina.DIF) GT rsBalXMonedaOficina.PERMIT>
		   <cf_errorCode	code = "51079"
		   				msg  = "El Asiento Generado no está balanceado en Moneda Local. Debitos=@errorDat_1@, Creditos=@errorDat_2@. Proceso Cancelado!"
		   				errorDat_1="#numberFormat(rsBalXMonedaOficina.DBS,",9.00")#"
		   				errorDat_2="#numberFormat(rsBalXMonedaOficina.CRS,",9.00")#"
		   >
		</cfif>
		<cf_dbfunction name="to_number" args="Pvalor" returnvariable="LvarPvalor">
		<cfquery datasource="#arguments.conexion#">
			insert into #request.INTARC#
				( 
					Ocodigo, Mcodigo, INTCAM, 
					INTORI, INTREL, INTDOC, INTREF, 
					INTFEC, Periodo, Mes, 
					INTTIP, INTDES, 
					CFcuenta, Ccuenta, 
					INTMOE, INTMON
				)
			select 
					Ocodigo, i.Mcodigo, round(INTCAM,10), 
					min(INTORI), min(INTREL), min(INTDOC), min(INTREF), 
					min(INTFEC), min(Periodo), min(Mes), 
					'D', 'Balance entre Monedas', 
					null, 
					(
						select #LvarPvalor# 
						  from Parametros 
						 where Ecodigo = #Arguments.Ecodigo#
						   and Pcodigo = 200
					),
					-sum(case when INTTIP = 'D' then INTMOE else -INTMOE end),
					-sum(case when INTTIP = 'D' then INTMON else -INTMON end)
			  from #request.INTARC# i
			 where i.Mcodigo in
				(
					select Mcodigo
					  from #request.INTARC#
					 group by Mcodigo
					having sum(case when INTTIP = 'D' then INTMOE else -INTMOE end) <> 0
				)
			group by i.Ocodigo, i.Mcodigo, round(INTCAM,10)
			having sum(case when INTTIP = 'D' then INTMOE else -INTMOE end) <> 0
		</cfquery>
	</cffunction>
</cfcomponent>

