<!--- 
	Este componente debe invocarse solamente dentro de un <cftransaction>

	Para Movimientos Intercompañía debe ejecutarse primero el procedimiento de este componente
	antes de invocar al CG_AplicaAsiento
	
	Los asientos generados no deberían permitir resumir, pero como no se envía el parámetro de Origen
	los asientos que se generan con el nuevo asiento nunca van a permitir la opción de Resumir

	Descripción del Proceso

	1.
	En un asiento intercompañía los datos de DContables que aparecen inicialmente cambiados cuando se inserta un detalle 
	acerca de otra empresa desde la pantalla de Registro de Documentos Contables son los siquientes:
	- Ocodigo
	- Ccuenta
	- CFcuenta
	
	2.
	En el proceso de aplicación del Asiento Contable este componente debe crear nuevos asientos para los detalles del asiento
	original que pertenecen a otra empresa, 1 asiento por cada empresa e insertando todos los detalles correspondientes
	a esa empresa actualizando los siguientes datos en el detalle de los nuevos asientos:
	- Ecodigo (Empresa Destino)
	- Cconcepto (debe tomarse de la tabla CIntercompany)
	- Eperiodo / Emes (obtenido de Parametros a partir de la empresa destino)
	- Mcodigo (Moneda equivalente a la moneda origen para la empresa destino)
	- Una vez insertado un detalle, hay que insertar el movimiento correspondiente que balancea el saldo del asiento
	
	3.
	Copiar los asientos creados para las otras empresas hacia las tablas de EControlDocInt y DControlDocInt
	
	4.
	Actualizar los registros de DContables para los nuevos asientos con los siguientes datos:
	- Ccuenta / CFcuenta (utilizar las cuentas almacenadas en CIntercompany para la Empresa Original y actualizar la cuenta dependiendo del tipo de movimiento)
	- Ocodigo (utilizar la Oficina almacenada en CIntercompany)
	
--->

<cfcomponent>

	<cffunction name="CG_AplicaIntercompany" access="public">
		<cfargument name="IDcontable" type="numeric" required="yes">
		<cfargument name="Conexion" type="string" default="#Session.DSN#">
		<cfargument name="debug" type="boolean" default="false">
		
		<cfset FechaHoy = Now()>
		<cfset EmpresaOrigen = Session.Ecodigo>
		
		<!--- Obtener las diferentes empresas que tienen que ver con el movimiento intercompañía --->
		<cfquery name="rsAsientos" datasource="#Arguments.Conexion#">
			select distinct c.Ecodigo, a.Ecodigo as EmpresaOrigen, a.Cconcepto
			from EContables a
				inner join DContables b
					on b.IDcontable = a.IDcontable
				inner join CContables c
					on c.Ccuenta = b.Ccuenta
					and c.Ecodigo <> a.Ecodigo
			where a.IDcontable = #Arguments.IDcontable#
		</cfquery>
		<cfif rsAsientos.recordCount GT 0>
			<cfset EmpresaOrigen = rsAsientos.EmpresaOrigen>
		</cfif>
		
		<cfif Arguments.debug>
			<!--- Asiento Origen --->
			<cfquery name="debugEContables" datasource="#Arguments.Conexion#">
				select *
				from EContables
				where IDcontable = #Arguments.IDcontable#
			</cfquery>
			<cfdump var="#debugEContables#" label="EContablesOrigen">
			
			<cfquery name="debugDContables" datasource="#Arguments.Conexion#">
				select *
				from DContables
				where IDcontable = #Arguments.IDcontable#
			</cfquery>
			<cfdump var="#debugDContables#" label="DContablesOrigen">
			
		</cfif>
		
		
		<!--- Guarda el detalle del asiento intercompañia original como historial--->
			<cfquery datasource="#session.dsn#">
				insert into HDContablesInt (
					IDcontable, Ecodigo, Eperiodo, Emes, Cconcepto, Edocumento, Dlinea, Ocodigo, Ddescripcion, Ddocumento, Dmovimiento,
					Ccuenta, CFcuenta, Doriginal, Dlocal, Mcodigo, Dtipocambio, Dreferencia, CFid)
				select 
					IDcontable, Ecodigo, Eperiodo, Emes, Cconcepto, Edocumento, Dlinea, Ocodigo, Ddescripcion, Ddocumento, Dmovimiento,
					Ccuenta, CFcuenta, Doriginal, Dlocal, Mcodigo, Dtipocambio, Dreferencia, CFid
				from DContables
				where IDcontable = #Arguments.IDcontable#
			</cfquery>
			<!--- --->

		<!--- Proceso de Creación de Asientos Nuevos para el resto de Empresas --->
		<cfloop query="rsAsientos">
			<cfset EmpresaDestino = rsAsientos.Ecodigo>
			
			<cfquery name="rsNAPsIntercompany" datasource="#Arguments.Conexion#">
				select 
					e.CPNAPIid, 
					i.CPNAPnum
				from EContables e
					left join CPNAPsIntercompany i
						 on i.CPNAPIid = e.CPNAPIid
						and i.Ecodigo = #EmpresaDestino#
				where e.IDcontable = #Arguments.IDcontable#
			</cfquery>
			<cfset LvarCPNAPIid = rsNAPsIntercompany.CPNAPIid>
			<cfif LvarCPNAPIid EQ "0">
				<cfset LvarNAP = "0">
			<cfelseif LvarCPNAPIid EQ "">
				<cfset LvarNAP = "">
			<cfelseif rsNAPsIntercompany.CPNAPnum NEQ "">
				<cfset LvarNAP = rsNAPsIntercompany.CPNAPnum>
			<cfelse>
				<cf_errorCode	code = "51033"
								msg  = "Error al generar los NAPs Intercompany, falta el NAP para la empresa Ecodigo=[@errorDat_1@]"
								errorDat_1="#EmpresaDestino#"
				>
			</cfif>
			
			<cfquery name="rsEmpresaDestino" datasource="#Arguments.Conexion#">
				select Edescripcion
				from Empresas
				where Ecodigo = #EmpresaDestino#
			</cfquery>
			
			<!--- Obtener todos los detalles que deben incluirse en el nuevo asiento --->
			<cfquery name="rsDetalle" datasource="#Arguments.Conexion#">
				select b.IDcontable, b.Dlinea, b.Mcodigo
				from EContables a
					inner join DContables b
						on b.IDcontable = a.IDcontable
					inner join CContables c
						on c.Ccuenta = b.Ccuenta
						and c.Ecodigo <> a.Ecodigo
						and c.Ecodigo = #EmpresaDestino#
				where a.IDcontable = #Arguments.IDcontable#
			</cfquery>

			<!--- Averiguar el Cconcepto --->
			<cfquery name="rsConcepto" datasource="#Arguments.Conexion#">
				select a.Cconceptodest
				from CIntercompany a
				where a.Ecodigo = #EmpresaOrigen#
				and a.Ecodigodest = #EmpresaDestino#
			</cfquery>
			<cfif rsConcepto.recordCount EQ 0>
				<cf_errorCode	code = "51034" msg = "No existe ningún concepto destino para registrar el movimiento intercompañía">
			</cfif>
			
			<!--- 
				Averiguar las cuentas intercompañía para la empresa destino donde se va a registrar los movimientos de balance de saldo
			    a la hora de insertar los detalles del asiento en la empresa destino
			--->
			<cfquery name="rsIntercompanyDestino" datasource="#Arguments.Conexion#">
				select a.CFcuentacxp, a.CFcuentacxc
				from CIntercompany a
				where a.Ecodigo = #EmpresaDestino#
				and a.Ecodigodest = #EmpresaOrigen#
			</cfquery>
			<cfif rsIntercompanyDestino.recordCount EQ 0>
				<cf_errorCode	code = "51035"
								msg  = "No existen cuentas intercompañía en la empresa @errorDat_1@ para registrar los movimientos intercompañía hacia la empresa @errorDat_2@"
								errorDat_1="#rsEmpresaDestino.Edescripcion#"
								errorDat_2="#Session.Enombre#"
				>
			</cfif>
			
			<!--- Averiguar el Periodo y Mes para la Empresa Destino --->
			<cfquery name="Periodo" datasource="#Arguments.Conexion#">
				select Pvalor from Parametros
				where Ecodigo = #EmpresaDestino#
				and Pcodigo = 30
			</cfquery>
			<cfquery name="Mes" datasource="#Arguments.Conexion#">
				select Pvalor from Parametros
				where Ecodigo = #EmpresaDestino#
				and Pcodigo = 40
			</cfquery>
			
			<!--- Crear el Asiento Nuevo --->
			<cfinvoke 
			 component="sif.Componentes.Contabilidad"
			 method="Nuevo_Asiento"
			 returnvariable="Nuevo_AsientoRet">
				<cfinvokeargument name="Ecodigo" value="#EmpresaDestino#"/>
				<cfinvokeargument name="Cconcepto" value="#rsConcepto.Cconceptodest#"/>
				<cfinvokeargument name="Oorigen" value=" "/>
				<cfinvokeargument name="Eperiodo" value="#Periodo.Pvalor#"/>
				<cfinvokeargument name="Emes" value="#Mes.Pvalor#"/>
			</cfinvoke>
			
			<cfquery name="AsientoOrigen" datasource="#Arguments.Conexion#">
				select 
					e.Cconcepto, 
					e.Edocumento, 
					e.Efecha, 
					e.Edescripcion, 
					e.Edocbase, 
					e.Ereferencia,
					e.ECreversible,
					c.Cdescripcion
				from EContables e
					inner join ConceptoContableE c
						on  c.Ecodigo   = e.Ecodigo
						and c.Cconcepto = e.Cconcepto
				where e.IDcontable = #Arguments.IDcontable#
			</cfquery>

			<cfset LvarCantCaracteres = len(trim(AsientoOrigen.Edocumento))>
			<cfset LvarCantCaracteres = 25 - 4 - 1 - LvarCantCaracteres>
			
			<cfset LvarReferencia   = "PO: " & trim(left(AsientoOrigen.Cdescripcion, LvarCantCaracteres)) & "-" & trim(AsientoOrigen.Edocumento)>
			<cfset LvarFecha        = AsientoOrigen.Efecha>

			<cfset LvarFechaMenor   = CreateDate(Periodo.Pvalor, Mes.Pvalor, 1)>
			<cfset LvarFechaMayor   = dateadd("m", 1, LvarFechaMenor)>			
			<cfset LvarFechaMayor   = dateadd("d", -1, LvarFechaMayor)>
			
			<cfif LvarFecha GT LvarFechaMayor>
				<cfset LvarFecha = LvarFechaMayor>
			</cfif>

			<cfif LvarFecha LT LvarFechaMenor>
				<cfset LvarFecha = LvarFechaMenor>
			</cfif>
			
			<!--- Asiento de Empresa Destino --->
			<cfquery name="insEContable" datasource="#Arguments.Conexion#">
				insert into EContables (
					Ecodigo, Cconcepto, 
					Eperiodo, Emes, 
					Edocumento, Efecha, 
					Edescripcion, Edocbase, 
					Ereferencia, ECauxiliar, 
					ECusuario, ECusucodigo, 
					ECfechacreacion, ECipcrea, 
					ECestado, ECreversible, 
					ECtipo, BMUsucodigo
					<cfif LvarCPNAPIid NEQ "">
						, NAP, CPNAPIid
					</cfif>
					)
				values(
						#EmpresaDestino#,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsConcepto.Cconceptodest#">, 
						<cfqueryparam cfsqltype="cf_sql_smallint" value="#Periodo.Pvalor#">, 
						<cfqueryparam cfsqltype="cf_sql_smallint" value="#Mes.Pvalor#">,
						#Nuevo_AsientoRet#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#AsientoOrigen.Edescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#AsientoOrigen.Edocbase#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarReferencia#">,
						'S',
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
						#Session.Usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaHoy#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.sitio.ip#">,
						0,
						#AsientoOrigen.ECreversible#,
						0,
						#Session.Usucodigo#
					<cfif LvarCPNAPIid NEQ "">
						, #LvarNAP#, #LvarCPNAPIid#
					</cfif>
					)
				<cf_dbidentity1 datasource="#Arguments.Conexion#" verificar_transaccion="false">
			</cfquery>
			<cf_dbidentity2 datasource="#Arguments.Conexion#" name="insEContable" verificar_transaccion="false">

			<!--- Obtener llave para el proximo Control de Documentos Intercompañía --->
			<cfquery name="rsECid" datasource="#Arguments.Conexion#">
				select coalesce(max(ECid)+1,1) as ECid 
				from EControlDocInt
			</cfquery>
			<cfset ECidDestino = rsECid.ECid>
				
			<!--- Insertar el encabezado de Control de Documentos Intercompañía --->
			<cfquery name="insEControlDocInt" datasource="#Arguments.Conexion#">
				insert into EControlDocInt (ECid, Ecodigo, Ecodigodest, fechalta, fechaasiento, Usucodigo, fechaaltadest, fechaasientodest, Usucodigodest, idcontableori, Idcontabledest)
				select
					#ECidDestino#,
					#EmpresaOrigen#,
					#EmpresaDestino#,
					a.ECfechacreacion, 
					a.Efecha,
					a.ECusucodigo,
					<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#FechaHoy#">, 
					<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#CreateDate(Periodo.Pvalor, Mes.Pvalor, 1)#">,
					#Session.Usucodigo#,
					a.IDcontable,
					#insEContable.identity#
				from EContables a
				where a.IDcontable = #Arguments.IDcontable#
			</cfquery>
			
			<!--- Por cada detalle --->
			<cfloop query="rsDetalle">

				<!--- Averiguar la moneda equivalente --->
				<cfquery name="rsMonedaEquiv" datasource="#Arguments.Conexion#">
					select b.Mcodigo
					from Monedas a
						inner join Monedas b
							on b.Miso4217 = a.Miso4217
							and b.Ecodigo = #EmpresaDestino#
					where a.Ecodigo = #EmpresaOrigen#
					  and a.Mcodigo = #rsDetalle.Mcodigo#
				</cfquery>
				<cfif rsMonedaEquiv.recordCount EQ 0>
					<cf_errorCode	code = "51036" msg = "No existe una Moneda equivalente en la Empresa Destino para registrar el movimiento intercompañía">
				</cfif>

				<!--- Calculo del Dlinea para el detalle del asiento nuevo --->
				<cfquery name="rsLinea" datasource="#Arguments.Conexion#">
					select coalesce(max(Dlinea)+1,1) as linea 
					from DContables
					where Ecodigo = #EmpresaDestino#
					and IDcontable = #insEContable.identity#
				</cfquery>
				
				<!--- Insertar el Detalle en el nuevo asiento --->
				<cfquery name="insDContables" datasource="#Arguments.Conexion#">
					insert into DContables (IDcontable, Dlinea, Ecodigo, Cconcepto, Eperiodo, Emes, Edocumento, Ocodigo, Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Doriginal, Dlocal, Mcodigo, Dtipocambio, BMUsucodigo)
					select 
						#insEContable.identity#, 
						#rsLinea.linea#, 
						#EmpresaDestino#,
						#rsConcepto.Cconceptodest#, 
						#Periodo.Pvalor#, 
						#Mes.Pvalor#,
						#Nuevo_AsientoRet#, 
						a.Ocodigo, 
						a.Ddescripcion, 
						a.Ddocumento, 
						a.Dreferencia, 
						a.Dmovimiento, 
						a.Ccuenta, 
						a.CFcuenta, 
						a.Doriginal, 
						a.Dlocal, 
						#rsMonedaEquiv.Mcodigo#,
						a.Dtipocambio, 
						#Session.Usucodigo#
					from DContables a
					where a.IDcontable = #rsDetalle.IDcontable#
					  and a.Dlinea     = #rsDetalle.Dlinea#
				</cfquery>
				
				<!--- Insertar el detalle de Control de Documentos Intercompañía para el asiento original --->
				<cfquery name="insDControlDocInt" datasource="#Arguments.Conexion#">
					insert into DControlDocInt (
						ECid, Ecodigo, Mcodigo, Ccuenta, CFcuenta, 
						DCmonto, tipomov, Dtipocambio, Ocodigodest, Usucodigo, fechaalta, 
						Dlinea, IDcontable)
					select 
						#ECidDestino#, 
						Ecodigo, 
						Mcodigo, 
						Ccuenta, 
						CFcuenta, 
						Doriginal, 
						Dmovimiento, 
						Dtipocambio, 
						Ocodigo, 
						#Session.Usucodigo#,
						<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#FechaHoy#">,
						Dlinea, 
						IDcontable
					from DContables a
					where a.IDcontable = #rsDetalle.IDcontable#
					and a.Dlinea = #rsDetalle.Dlinea#
				</cfquery>

				<!--- Calculo del Dlinea para el detalle del asiento nuevo --->
				<cfquery name="rsLinea" datasource="#Arguments.Conexion#">
					select coalesce(max(Dlinea)+1,1) as linea 
					from DContables
					where Ecodigo  = #EmpresaDestino#
					and IDcontable = #insEContable.identity#
				</cfquery>
				
				<!--- 
					Insertar el movimiento que balancea el saldo del movimiento anterior 
					A la hora de insertar los movimientos en los asientos de las empresas destino:
					Si el movimiento en el asiento original es un Débito(D) se inserta adicionalmente un Crédito contra un Cuenta por Pagar(CFcuentacxp)
					Si el movimiento en el asiento original es un Crédito(C) se inserta adicionalmente un Débito contra un Cuenta por Cobrar(CFcuentacxc)
				--->
				<cfquery name="insDContables" datasource="#Arguments.Conexion#">
					insert into DContables (IDcontable, Dlinea, Ecodigo, Cconcepto, Eperiodo, Emes, Edocumento, Ocodigo, Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Doriginal, Dlocal, Mcodigo, Dtipocambio, BMUsucodigo)
					select 
						#insEContable.identity#, 
						#rsLinea.linea#, 
						#EmpresaDestino#,
						#rsConcepto.Cconceptodest#, 
						#Periodo.Pvalor#, 
						#Mes.Pvalor#,
						#Nuevo_AsientoRet#, 
						a.Ocodigo, 
						a.Ddescripcion, 
						a.Ddocumento, 
						a.Dreferencia, 
						(case when a.Dmovimiento = 'D' then 'C' else 'D' end), 
						(case when a.Dmovimiento = 'D' 
							then ( select Ccuenta
									from CFinanciera
									where Ecodigo = #EmpresaDestino#
									and CFcuenta = #rsIntercompanyDestino.CFcuentacxp#
								  )
							else ( select Ccuenta
									from CFinanciera
									where Ecodigo = #EmpresaDestino#
									and CFcuenta = #rsIntercompanyDestino.CFcuentacxc#
								  )
						end), 
						(case when a.Dmovimiento = 'D' 
							then #rsIntercompanyDestino.CFcuentacxp#
							else #rsIntercompanyDestino.CFcuentacxc#
						end), 
						a.Doriginal, 
						a.Dlocal, 
						#rsMonedaEquiv.Mcodigo#,
						a.Dtipocambio, 
						#Session.Usucodigo#
					from DContables a
					where a.IDcontable = #rsDetalle.IDcontable#
					  and a.Dlinea     = #rsDetalle.Dlinea#
				</cfquery>
			</cfloop>
			
			<!--- DEBUG --->
			<cfif Arguments.debug>
				<!--- Asientos Nuevos para las demás empresas --->
				<cfquery name="debugEContables" datasource="#Arguments.Conexion#">
					select *
					from EContables
					where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insEContable.identity#">
				</cfquery>
				<cfdump var="#debugEContables#" label="EContables">
				
				<cfquery name="debugDContables" datasource="#Arguments.Conexion#">
					select *
					from DContables
					where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insEContable.identity#">
				</cfquery>
				<cfdump var="#debugDContables#" label="DContables">

				<cfquery name="debugEControlDocInt" datasource="#Arguments.Conexion#">
					select *
					from EControlDocInt
					where ECid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ECidDestino#">
				</cfquery>
				<cfdump var="#debugEControlDocInt#" label="EControlDocInt">

				<cfquery name="debugDControlDocInt" datasource="#Arguments.Conexion#">
					select *
					from DControlDocInt
					where ECid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ECidDestino#">
				</cfquery>
				<cfdump var="#debugDControlDocInt#" label="DControlDocInt">
			</cfif>
			
		</cfloop> <!--- <cfloop query="rsAsientos"> --->
		
		<!--- Buscar los detalles que corresponden a otras empresas en un movimiento Intercompañía --->
		<cfquery name="rsAllDetalles" datasource="#Arguments.Conexion#">
			select b.IDcontable, b.Dlinea, c.Ecodigo, b.Dmovimiento
			from EContables a
				inner join DContables b
					on b.IDcontable = a.IDcontable
				inner join CContables c
					on c.Ccuenta = b.Ccuenta
					and c.Ecodigo <> a.Ecodigo
			where a.IDcontable = #Arguments.IDcontable#
		</cfquery>
		
		<!--- Por cada detalle en el asiento original hay que actualizar las cuentas contables y la oficina --->
		<cfloop query="rsAllDetalles">
			<!--- Averiguar las cuentas contables y la oficina --->
			<cfquery name="getCuenta" datasource="#Arguments.Conexion#">
				select a.CFcuentacxp, a.CFcuentacxc, a.Ocodigo
				from CIntercompany a
				where a.Ecodigo = #EmpresaOrigen#
				and a.Ecodigodest = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAllDetalles.Ecodigo#">
			</cfquery>
			<cfif getCuenta.recordCount EQ 0>
				<cf_errorCode	code = "51037" msg = "No existen ninguna Cuenta Contable para registrar el movimiento intercompañía">
			</cfif>

			<!--- 
				En la empresa Origen se deben cambiar la oficina y las cuentas de los movimientos del asiento 
				Si el movimiento es de Débito debe seleccionarse una cuenta de Cuenta por Cobrar
				Si el movimiento es de Crédito debe seleccionarse una cuenta de Cuenta por Pagar
			--->

			<cfquery name="updDContable1" datasource="#Arguments.Conexion#">
				update DContables set
					Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#getCuenta.Ocodigo#">,
					<cfif rsAllDetalles.Dmovimiento EQ 'D'>
						CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#getCuenta.CFcuentacxc#">,
						Ccuenta = ( select Ccuenta
									from CFinanciera
									where Ecodigo = #EmpresaOrigen#
									and CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#getCuenta.CFcuentacxc#">
								  ),
					<cfelse>
						CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#getCuenta.CFcuentacxp#">,
						Ccuenta = ( select Ccuenta
									from CFinanciera
									where Ecodigo = #EmpresaOrigen#
									and CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#getCuenta.CFcuentacxp#">
								  ),
					</cfif>
					BMUsucodigo = #Session.Usucodigo#
				where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAllDetalles.IDcontable#">
				and Dlinea = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAllDetalles.Dlinea#">
			</cfquery>
		</cfloop>  <!--- <cfloop query="rsAllDetalles"> --->

		<!--- Obtener la cuenta contable de movimientos entre oficinas para registrar los movimientos de balance para el asiento origen --->
		<cfquery name="rsCuentaBalance" datasource="#Arguments.Conexion#">
			select rtrim(a.Pvalor) as Pvalor
			from Parametros a
			where a.Ecodigo = #EmpresaOrigen#
			and a.Pcodigo = 90
		</cfquery>
		<cfif rsCuentaBalance.recordCount EQ 0>
			<cf_errorCode	code = "51038"
							msg  = "No se ha definido una cuenta contable para movimientos entre oficinas para la empresa @errorDat_1@. Debe ingregar a Cuentas Contables de Operación en la opción de Administración del Sistema para definir esta cuenta."
							errorDat_1="#Session.Enombre#"
			>
		</cfif>

		<!--- Balancear detalle en el asiento de la empresa Origen --->
		<cfquery name="rsBalanceMov" datasource="#Arguments.Conexion#">
			select a.Ocodigo, a.Mcodigo, 
				   sum(a.Doriginal * (case when a.Dmovimiento = 'C' then -1 else 1 end)) as MontoOrig,
				   sum(a.Dlocal * (case when a.Dmovimiento = 'C' then -1 else 1 end)) as MontoLocal
			from DContables a
			where a.IDcontable = #Arguments.IDcontable#
			group by a.Ocodigo, a.Mcodigo
		</cfquery>
		
		<cfloop query="rsBalanceMov">
			<cfset Oficina = rsBalanceMov.Ocodigo>
			<cfset Moneda = rsBalanceMov.Mcodigo>
			<cfset MontoOriginal = rsBalanceMov.MontoOrig>
			<cfset MontoLocal = rsBalanceMov.MontoLocal>
			<!--- Si el monto por Oficina y Moneda no se encuentran balanceados, debe insertarse un detalle para el balanceo del saldo del asiento --->
			<cfif MontoOriginal NEQ 0 or MontoLocal NEQ 0>
				
				<!--- Calculo del Dlinea para el detalle del asiento nuevo --->
				<cfquery name="rsLinea" datasource="#Arguments.Conexion#">
					select coalesce(max(Dlinea)+1,1) as linea 
					from DContables
					where Ecodigo = #EmpresaOrigen#
					and IDcontable = #Arguments.IDcontable#
				</cfquery>
				
				<cfquery name="insBalance" datasource="#Arguments.Conexion#">
					insert into DContables (IDcontable, Dlinea, Ecodigo, Cconcepto, Eperiodo, Emes, Edocumento, Ocodigo, Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Doriginal, Dlocal, Mcodigo, Dtipocambio, BMUsucodigo)
					select
						a.IDcontable, 
						#rsLinea.linea#, 
						a.Ecodigo,
						a.Cconcepto, 
						a.Eperiodo, 
						a.Emes,
						a.Edocumento, 
						#Oficina#, 
						'Balance por Oficina y Moneda', 
						'', 
						'', 
						<cfif MontoOriginal GT 0 or MontoLocal GT 0>
						'C', 
						<cfelse>
						'D',
						</cfif>
						#rsCuentaBalance.Pvalor#,
						(select min(CFcuenta) from CFinanciera where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaBalance.Pvalor#">), 
						#Abs(MontoOriginal)#, 
						#Abs(MontoLocal)#, 
						#Moneda#,
						1.0, 
						#Session.Usucodigo#
					from EContables a
					where a.IDcontable = #Arguments.IDcontable#
				</cfquery>
			</cfif>
			
		</cfloop>
		

		<cfif Arguments.debug>
			<!--- Asiento Origen --->
			<cfquery name="debugEContables" datasource="#Arguments.Conexion#">
				select *
				from EContables
				where IDcontable = #Arguments.IDcontable#
			</cfquery>
			<cfdump var="#debugEContables#" label="EContablesOrigen">
			
			<cfquery name="debugDContables" datasource="#Arguments.Conexion#">
				select *
				from DContables
				where IDcontable = #Arguments.IDcontable#
			</cfquery>
			<cfdump var="#debugDContables#" label="DContablesOrigen">
			<cftransaction action="rollback"/>
			<cf_abort errorInterfaz="">
		</cfif>
		
	</cffunction>

</cfcomponent>

