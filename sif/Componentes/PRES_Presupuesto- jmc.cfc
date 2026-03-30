<cfcomponent>  
 	<cffunction name="CreaTablaIntPresupuesto" output="no" returntype="string" access="public">
		<cfargument name='Conexion' type='string' required='false'>
		<cfargument name='conIndices' type='boolean' required='false' default="no">
		<cfargument name='conIdentity' type='boolean' required='false' default="no">
		<cfargument name='ContaPresupuestaria' type='boolean' required='false' default="no">

		<cfif not isdefined("Arguments.Conexion")>
			<cfset Arguments.Conexion = session.DSN>
		</cfif>
		<cfset LvarNombre = "IntPre_11">
		<cfif Arguments.conIdentity>
			<cfset LvarNombre = LvarNombre & 'b'>
		</cfif>
		<cf_dbtemp name="#LvarNombre#" returnvariable="CP_Interfase_Presupuesto_NAME" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="EcodigoDst" 		type="numeric"      mandatory="no">

			<cf_dbtempcol name="EcodigoOrigen" 		type="numeric"      mandatory="no">
			<cf_dbtempcol name="ModuloOrigen"		type="char(4)"      mandatory="yes">
			<cf_dbtempcol name="NumeroDocumento"	type="char(20)"     mandatory="yes">
			<cf_dbtempcol name="NumeroReferencia"	type="varchar(25)"  mandatory="yes">
			<cf_dbtempcol name="DocumentoPagado"	type="varchar(50)"  mandatory="no">
			<cf_dbtempcol name="FechaDocumento"		type="datetime"		mandatory="yes">
			<cf_dbtempcol name="AnoDocumento"		type="int"          mandatory="yes">
			<cf_dbtempcol name="MesDocumento"		type="int"          mandatory="yes">
			<cf_dbtempcol name="NAPreversado"		type="numeric"     	mandatory="no">
			<cf_dbtempcol name="NAP"				type="numeric"      mandatory="no">
			<cf_dbtempcol name="NRP"				type="numeric"      mandatory="no">
			<cfif Arguments.conIdentity>
				<cf_dbtempcol name="NumeroLinea" identity="yes"	type="numeric" mandatory="yes">
			<cfelse>
				<cf_dbtempcol name="NumeroLinea"		type="numeric"      mandatory="yes">
			</cfif>
			<cf_dbtempcol name="NumeroLineaID"		type="numeric"      mandatory="yes" default="0">
			<cf_dbtempcol name="CuentaFinanciera" 	type="varchar(100)" mandatory="no">
			<cf_dbtempcol name="CFcuenta" 			type="numeric"      mandatory="no">
			<cf_dbtempcol name="Ccuenta"			type="numeric"      mandatory="no">
			<cf_dbtempcol name="CodigoOficina"	 	type="varchar(10)"  mandatory="no">
			<cf_dbtempcol name="Ocodigo"		 	type="numeric"      mandatory="no">
			<cf_dbtempcol name="CodigoMoneda"		type="char(3)"      mandatory="no">
			<cf_dbtempcol name="Mcodigo"			type="numeric"      mandatory="no">
			<cf_dbtempcol name="MontoOrigen"		type="money"        mandatory="yes">
			<cf_dbtempcol name="TipoCambio"			type="float"        mandatory="yes">
			<cf_dbtempcol name="Monto"				type="money"        mandatory="yes">
			<cf_dbtempcol name="NAPreferencia"		type="numeric"      mandatory="no">
			<cf_dbtempcol name="LINreferencia"		type="numeric"      mandatory="no">

			<cf_dbtempcol name="TipoMovimiento" 	type="char(2)" 		mandatory="no">
			<cf_dbtempcol name="SignoMovimiento" 	type="int" 			mandatory="no">
			<cf_dbtempcol name="CPPid"  			type="int"          mandatory="no">
			<cf_dbtempcol name="CPCano"    			type="int"          mandatory="no">
			<cf_dbtempcol name="CPCmes"    			type="int"          mandatory="no">
			<cf_dbtempcol name="CuentaPresupuesto" 	type="varchar(100)" mandatory="no">
			<cf_dbtempcol name="CPcuenta" 			type="numeric"      mandatory="no">
			<cf_dbtempcol name="TipoControl"		type="int"          mandatory="no">
			<cf_dbtempcol name="CalculoControl"		type="int"          mandatory="no">
			<cf_dbtempcol name="DisponibleAnterior" type="money"        mandatory="no">
			<cf_dbtempcol name="DisponibleGenerado" type="money"        mandatory="no">
			<cf_dbtempcol name="ExcesoGenerado" 	type="money"        mandatory="no">
			<cf_dbtempcol name="NRPsPendientes" 	type="money"        mandatory="no">
			<cf_dbtempcol name="DisponibleNeto" 	type="money"        mandatory="no">
			<cf_dbtempcol name="ExcesoNeto"			type="money"        mandatory="no">

			<cf_dbtempcol name="ExcesoConRechazo" 	type="int"        	mandatory="no">
			<cf_dbtempcol name="ConError"			type="int"        	mandatory="no">
			<cf_dbtempcol name="MSG"	 			type="varchar(255)" mandatory="no">

			<cf_dbtempcol name="CPCanoMes"			type="int"        	mandatory="no">
			<cf_dbtempcol name="MontoAcum"			type="money"        mandatory="no">
			<cf_dbtempcol name="CalculoIni"			type="int"	        mandatory="no">
			<cf_dbtempcol name="CalculoFin"			type="int"        	mandatory="no">

			<cf_dbtempcol name="PCGDid"					type="numeric"		mandatory="no">
			<cf_dbtempcol name="PCGDcantidad"			type="float"        mandatory="yes" default="0">
			<cf_dbtempcol name="PCGDcantidadAntes"		type="float"        mandatory="yes" default="0">
			<cf_dbtempcol name="PCGDdisponibleAntes"	type="money"        mandatory="yes" default="0">
			<cf_dbtempcol name="CENTRO_FUNCIONAL"	    type="varchar(10)"        mandatory="no">
			<cf_dbtempcol name="CONCEPTO_GASTO"	 	   type="varchar(30)"        mandatory="no">
		
			<cf_dbtempkey cols="NumeroLinea,NumeroLineaID">
			<cfif Arguments.conIndices>
				<cf_dbtempindex cols="CPCano,CPCmes,CPcuenta,Ocodigo">
				<cf_dbtempindex cols="CPcuenta,Ocodigo,CPCanoMes">
			</cfif>
		</cf_dbtemp>
		<cfset Request.intPresupuesto = CP_Interfase_Presupuesto_NAME>

		<cf_dbtemp name="O#LvarNombre#" returnvariable="CP_SaldoOriginal_NAME" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="CPcuenta"			type="numeric"      mandatory="no">
			<cf_dbtempcol name="Ocodigo"		 	type="numeric"      mandatory="no">
			<cf_dbtempcol name="CPCano"    			type="int"          mandatory="no">
			<cf_dbtempcol name="CPCmes"    			type="int"          mandatory="no">
			<cf_dbtempcol name="DisponibleOriginal" type="money"        mandatory="no">
		</cf_dbtemp>
		<cfset Request.intSaldoOriginal = CP_SaldoOriginal_NAME>

		<cf_dbtemp name="T#LvarNombre#" returnvariable="CP_Interfase_Presupuesto_NAMET" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="EcodigoDst" 		type="numeric"      mandatory="no">

			<cf_dbtempcol name="EcodigoOrigen" 		type="numeric"      mandatory="no">
			<cf_dbtempcol name="ModuloOrigen"		type="char(4)"      mandatory="yes">
			<cf_dbtempcol name="NumeroDocumento"	type="char(20)"     mandatory="yes">
			<cf_dbtempcol name="NumeroReferencia"	type="varchar(25)"  mandatory="yes">
			<cf_dbtempcol name="FechaDocumento"		type="datetime"		mandatory="yes">
			<cf_dbtempcol name="AnoDocumento"		type="int"          mandatory="yes">
			<cf_dbtempcol name="MesDocumento"		type="int"          mandatory="yes">
			<cf_dbtempcol name="NAPreversado"		type="numeric"     	mandatory="no">
			<cf_dbtempcol name="NAP"				type="numeric"      mandatory="no">
			<cf_dbtempcol name="NRP"				type="numeric"      mandatory="no">
			<cf_dbtempcol name="NumeroLinea"		type="numeric"      mandatory="yes">
			<cf_dbtempcol name="CuentaFinanciera" 	type="varchar(100)" mandatory="no">
			<cf_dbtempcol name="CFcuenta" 			type="numeric"      mandatory="no">
			<cf_dbtempcol name="Ccuenta"			type="numeric"      mandatory="no">
			<cf_dbtempcol name="CodigoOficina"	 	type="varchar(10)"  mandatory="no">
			<cf_dbtempcol name="Ocodigo"		 	type="numeric"      mandatory="no">
			<cf_dbtempcol name="CodigoMoneda"		type="char(3)"      mandatory="no">
			<cf_dbtempcol name="Mcodigo"			type="numeric"      mandatory="no">
			<cf_dbtempcol name="MontoOrigen"		type="money"        mandatory="yes">
			<cf_dbtempcol name="TipoCambio"			type="float"        mandatory="yes">
			<cf_dbtempcol name="Monto"				type="money"        mandatory="yes">
			<cf_dbtempcol name="NAPreferencia"		type="numeric"      mandatory="no">
			<cf_dbtempcol name="LINreferencia"		type="numeric"      mandatory="no">
			<cf_dbtempcol name="TipoMovimiento" 	type="char(2)" 		mandatory="no">
			<cf_dbtempcol name="SignoMovimiento" 	type="int" 			mandatory="no">
			<cf_dbtempcol name="CPPid"  			type="int"          mandatory="no">
			<cf_dbtempcol name="CPCano"    			type="int"          mandatory="no">
			<cf_dbtempcol name="CPCmes"    			type="int"          mandatory="no">
			<cf_dbtempcol name="CuentaPresupuesto" 	type="varchar(100)" mandatory="no">
			<cf_dbtempcol name="CPcuenta" 			type="numeric"      mandatory="no">
			<cf_dbtempcol name="TipoControl"		type="int"          mandatory="no">
			<cf_dbtempcol name="CalculoControl"		type="int"          mandatory="no">
			<cf_dbtempcol name="DisponibleAnterior" type="money"        mandatory="no">
			<cf_dbtempcol name="DisponibleGenerado" type="money"        mandatory="no">
			<cf_dbtempcol name="ExcesoGenerado" 	type="money"        mandatory="no">
			<cf_dbtempcol name="NRPsPendientes" 	type="money"        mandatory="no">
			<cf_dbtempcol name="DisponibleNeto" 	type="money"        mandatory="no">
			<cf_dbtempcol name="ExcesoNeto"			type="money"        mandatory="no">
			<cf_dbtempcol name="ExcesoConRechazo" 	type="int"        	mandatory="no">
			<cf_dbtempcol name="ConError"			type="int"        	mandatory="no">
			<cf_dbtempcol name="MSG"	 			type="varchar(255)" mandatory="no">
			<cf_dbtempcol name="CPCanoMes"			type="int"        	mandatory="no">
			<cf_dbtempcol name="MontoAcum"			type="money"        mandatory="no">
			<cf_dbtempcol name="CalculoIni"			type="int"	        mandatory="no">
			<cf_dbtempcol name="CalculoFin"			type="int"        	mandatory="no">

			<cf_dbtempcol name="PCGDid"					type="numeric"		mandatory="no" >
			<cf_dbtempcol name="PCGDcantidad"			type="float"        mandatory="yes" default="0">

			<cf_dbtempkey cols="NumeroLinea">
			<cf_dbtempindex cols="EcodigoDst, NumeroLinea">
		</cf_dbtemp>
		<cfset Request.intPresupuestoT	 = CP_Interfase_Presupuesto_NAMET>
		
		<cfif Arguments.ContaPresupuestaria>
			<!--- Generar Contabilidad Presupuestaria --->
			<cfquery name="rsSQL" datasource="#session.DSN#">
				select Pvalor
				  from Parametros
				 where Ecodigo = #session.Ecodigo#
				   and Pcodigo = 1140
			</cfquery>
			<cfset LvarContaPresupuestaria = (rsSQL.Pvalor EQ "S")>
			<cfif LvarContaPresupuestaria>
				<cfset request.PRES_ContaPresupuestaria = true>
				<cfinvoke	component="CG_GeneraAsiento"	
							method="CreaIntarc" 
							CrearPresupuesto="false"
				/>
			</cfif>
		</cfif>

		<cfreturn CP_Interfase_Presupuesto_NAME>
	</cffunction>
	
	<cffunction name="ControlPresupuestarioIntercompany" output="no" returntype="struct" access="public">
		<cfargument name='ModuloOrigen' 	type="string" 	required='true'>		
		<cfargument name='NumeroDocumento' 	type='string' 	required='true'>
		<cfargument name='NumeroReferencia' type='string' 	required='true'>
		<cfargument name='FechaDocumento' 	type='date'   	required='true'>
		<cfargument name='AnoDocumento'	 	type='numeric' 	required='true'>
		<cfargument name='MesDocumento'	 	type='numeric' 	required='true'>

		<cfargument name="Conexion" 		type="string"  	required='false'>
		<cfargument name="Ecodigo" 			type="numeric" 	required="false">		

		<cfargument name='NAPreversado'	 	type='numeric' 	required='false' default="-1">
		<cfargument name='SoloConsultar' 	type='boolean' 	required='false' default="False">
		<cfargument name='VerErrores' 		type='boolean' 	required='false' default="False">

		<cfargument name='Intercompany' 	type='boolean' 	required='false' default="False">

		<cfset var LvarIC = structNew()>
		
		<cfif not isdefined("Arguments.Conexion")>
			<cfset Arguments.Conexion = session.DSN>
		</cfif>
		<cfif not isDefined("Arguments.Ecodigo")>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>

		<!--- INTERCOMPANY --->		
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			update #Request.intPresupuesto#
			   set EcodigoOrigen = #Arguments.Ecodigo#
			     , EcodigoDst = 
						CASE 
							WHEN #Request.intPresupuesto#.CPcuenta IS NOT NULL then
								(
									select Ecodigo 
									  from CPresupuesto
									 where CPcuenta = #Request.intPresupuesto#.CPcuenta
								)
							WHEN #Request.intPresupuesto#.CFcuenta IS NOT NULL then
								(
									select Ecodigo 
									  from CFinanciera
									 where CFcuenta = #Request.intPresupuesto#.CFcuenta
								)
							ELSE
								(
									select Ecodigo
									  from CContables
									 where Ccuenta = #Request.intPresupuesto#.Ccuenta
								)
						END
		</cfquery>

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select distinct EcodigoDst from #Request.intPresupuesto#
		</cfquery>
		<cfif rsSQL.recordCount LTE 1>
			<cfset Arguments.Intercompany = false>
			<cfset LvarIC.NAP = ControlPresupuestario (	
								ModuloOrigen, NumeroDocumento, NumeroReferencia, 
								FechaDocumento, AnoDocumento, MesDocumento, 
								Conexion, Ecodigo,
								NAPreversado, SoloConsultar, VerErrores,
								Intercompany, Ecodigo
								)>
			<cfset LvarIC.Intercompany = false>
			<cfset LvarIC.CPNAPIid = 0>
			<cfreturn LvarIC>
		<cfelseif NOT Arguments.Intercompany>
			<cf_errorCode	code = "51283" msg = "ERROR EN CONTROL PRESUPUESTARIO INTERCOMPANY: Se envió a Controlar un documento que contenía cuentas de diferentes empresas y no se indicó intercompany">
		</cfif>

		<!--- Se copian los registros de trabajo en una tabla temporal para poder borrar la tabla de interfaz --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #Request.intPresupuestoT# (
					EcodigoDst,

					EcodigoOrigen,	
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					
					NumeroLinea, 
					
					CFcuenta, 
					CPcuenta, 
					Ccuenta, 
					
					Ocodigo, 
					TipoMovimiento,
					
					Mcodigo, 	
					MontoOrigen, 
					TipoCambio, 
					Monto,
					
					NAPreversado, 
					NAPreferencia, 
					LINreferencia,

					PCGDid, PCGDcantidad
				)
			select 	
					EcodigoDst,

					EcodigoOrigen,	
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					
					NumeroLinea, 
					
					CFcuenta, 
					CPcuenta, 
					Ccuenta, 
					
					Ocodigo, 
					TipoMovimiento,
					
					Mcodigo, 	
					MontoOrigen, 
					TipoCambio, 
					Monto,
					
					NAPreversado, 
					NAPreferencia, 
					LINreferencia,

					PCGDid, PCGDcantidad
			from #request.intPresupuesto#
		</cfquery>

		<cfquery name="LvarIC.rsIntPresupuesto" datasource="#Arguments.Conexion#">
			select distinct a.EcodigoDst, e.Edescripcion
			  from #Request.intPresupuesto# a
				inner join Empresas e
				   on e.Ecodigo = a.EcodigoDst
			 order by a.EcodigoDst
		</cfquery>
		
		<cfset LvarIC.HuboNAPs = false>
		<cfset LvarIC.MSG = "">
		<cfset LvarIC.MSGNAP = "">
		<cfset LvarIC.NAPs = arrayNew(1)>
		<cfset LvarIC.NRPs = arrayNew(1)>

		<cfloop query="LvarIC.rsIntPresupuesto">
			<!--- Nuevo EcodigoDst --->
			<cfquery datasource="#Arguments.Conexion#">
				delete from #Request.intPresupuesto#
			</cfquery>
			<!--- Inserta las lineas para el EcodigoDst --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #request.intPresupuesto#
					(
						EcodigoDst,

						EcodigoOrigen,	
						ModuloOrigen,
						NumeroDocumento,
						NumeroReferencia,
						FechaDocumento,
						AnoDocumento,
						MesDocumento,
						
						NumeroLinea, 
						
						CFcuenta, 
						CPcuenta, 
						Ccuenta, 
						
						Ocodigo, 
						TipoMovimiento,
						
						Mcodigo, 	
						MontoOrigen, 
						TipoCambio, 
						Monto,
						
						NAPreversado, 
						NAPreferencia, 
						LINreferencia,
						
						PCGDid, PCGDcantidad
					)
				select 	
						EcodigoDst,
	
						EcodigoOrigen,	
						ModuloOrigen,
						NumeroDocumento,
						NumeroReferencia,
						FechaDocumento,
						AnoDocumento,
						MesDocumento,
						
						NumeroLinea, 
						
						CFcuenta, 
						CPcuenta, 
						Ccuenta, 
						
						Ocodigo, 
						TipoMovimiento,
						
						Mcodigo, 	
						MontoOrigen, 
						TipoCambio, 
						Monto,
						
						NAPreversado, 
						NAPreferencia, 
						LINreferencia,

						PCGDid, PCGDcantidad
				from #request.intPresupuestoT#
				where EcodigoDst = #LvarIC.rsIntPresupuesto.EcodigoDst#
			</cfquery>

			<cftry>
				<cfset LvarIC.NAP = ControlPresupuestario (	
									ModuloOrigen, NumeroDocumento, NumeroReferencia, 
									FechaDocumento, AnoDocumento, MesDocumento, 
									Conexion, LvarIC.rsIntPresupuesto.EcodigoDst, 
									NAPreversado, SoloConsultar, VerErrores,
									Intercompany, Arguments.Ecodigo
									)>
				<cfif LvarIC.NAP LT 0>
					<cfset LvarIC.Idx = arrayLen(LvarIC.NRPs)+1>
					<cfset LvarIC.NRPs[LvarIC.Idx]			= structNew()>
					<cfset LvarIC.NRPs[LvarIC.Idx].Ecodigo	= LvarIC.rsIntPresupuesto.EcodigoDst>
					<cfset LvarIC.NRPs[LvarIC.Idx].CPNRPnum	= -LvarIC.NAP>
					<cfset LvarIC.NRPs[LvarIC.Idx].rsPre	= Request.rsIntPresupuesto>
					<cfset LvarIC.MSG = LvarIC.MSG & "- Empresa '#LvarIC.rsIntPresupuesto.Edescripcion#': se generó Rechazo Presupuestario NRP=#-LvarIC.NAP#<BR>">
					<!--- Al generarse un NRP se ejecuta un ROLLBACK, con lo que se pierden los datos de las tablas temporales, ya no hay nada que procesar --->
					<cfbreak>
				<cfelse>
					<cfif LvarIC.NAP GT 0>
						<cfset LvarIC.HuboNAPs = true>
					</cfif>
					<cfset LvarIC.Idx = arrayLen(LvarIC.NAPs)+1>
					<cfset LvarIC.NAPs[LvarIC.Idx]			= structNew()>
					<cfset LvarIC.NAPs[LvarIC.Idx].Ecodigo	= LvarIC.rsIntPresupuesto.EcodigoDst>
					<cfset LvarIC.NAPs[LvarIC.Idx].CPNAPnum	= LvarIC.NAP>
					<cfset LvarIC.NAPs[LvarIC.Idx].rsPre	= Request.rsIntPresupuesto>
					<cfset LvarIC.MSGNAP = LvarIC.MSGNAP & "- Empresa '#LvarIC.rsIntPresupuesto.Edescripcion#': OK (#LvarIC.NAP#)<BR>">
				</cfif>
			<cfcatch type="any">
				<cfset LvarMSG = "ERROR EN CONTROL PRESUPUESTARIO: ">
				<cfif find(LvarMSG, cfcatch.Message) GT 0>
					<cfset LvarMSG = mid(cfcatch.Message, len(LvarMSG)+1,255)>
				<cfelse>
					<cfset LvarMSG = cfcatch.Message>
				</cfif>
				<cfset LvarIC.MSG = LvarIC.MSG & "- Empresa '#LvarIC.rsIntPresupuesto.Edescripcion#': #LvarMSG#<BR>">
			</cfcatch>
			</cftry>
		</cfloop>
		
		<cfset LvarIC.Res = StructNew()>
		<cfif LvarIC.MSG NEQ "">
			<cftransaction action="rollback" />
			<cf_errorCode	code = "51284"
							msg  = "ERROR EN CONTROL PRESUPUESTARIO INTERCOMPANY: <BR>@errorDat_1@@errorDat_2@"
							errorDat_1="#LvarIC.MSG#"
							errorDat_2="#LvarIC.MSGNAP#"
			>
		<cfelseif NOT LvarIC.HuboNAPs>
			<cfset LvarIC.Res.NAP 			= 0>
			<cfset LvarIC.Res.CPNAPIid 		= 0>
			<cfset LvarIC.Res.Intercompany 	= true>
		<cfelse>
			<cfset LvarIC.CPNAPIid = fnSiguienteCPNAPIid(Arguments.Conexion)>

			<cfloop index="i" from="1" to="#arrayLen(LvarIC.NAPs)#">
				<cfquery datasource="#Arguments.Conexion#">
					insert into CPNAPsIntercompany
						( CPNAPIid, Ecodigo, CPNAPnum, CPNAPIorigen )
					values (
						  #LvarIC.CPNAPIid#
						, #LvarIC.NAPs[i].Ecodigo#
						, #LvarIC.NAPs[i].CPNAPnum#
					<cfif LvarIC.NAPs[i].Ecodigo EQ Arguments.Ecodigo>
						, 1
						<cfset LvarIC.res.NAP = LvarIC.NAPs[i].CPNAPnum>
					<cfelse>
						, 0
					</cfif>
						)
				</cfquery>
			</cfloop>
			<cfset LvarIC.res.CPNAPIid 		= LvarIC.CPNAPIid>
			<cfset LvarIC.res.Intercompany 	= true>

			<cfinvoke 	component	= "PRES_ContaPresupuestaria" 
						method		= "sbAgregaEnAsiento" 
						Ecodigo		= "#Arguments.Ecodigo#" 
						CPNAPIid	= "#LvarIC.CPNAPIid#"
						Conexion	= "#Arguments.Conexion#"
			>
		</cfif>

		<cfquery name="Request.rsIntPresupuesto" dbtype="query">
			<cfloop index="i" from="1" to="#arrayLen(LvarIC.NAPs)#">
				<cfif i GT 1>
				UNION
				</cfif>
				<cfset rsPre = LvarIC.NAPs[i].rsPre>
				select * from rsPre
			</cfloop>
			<cfloop index="i" from="1" to="#arrayLen(LvarIC.NRPs)#">
				<cfif arrayLen(LvarIC.NAPs) + i GT 1>
				UNION
				</cfif>
				<cfset rsPre = LvarIC.NRPs[i].rsPre>
				select * from rsPre
			</cfloop>
		</cfquery>
		
		<cfreturn LvarIC.res>
	</cffunction>

	<cffunction name="rsCPresupuestoPeriodo" output="no" returntype="query" access="public">
		<cfargument name='Ecodigo'		 	type='numeric' 	required='true'>
		<cfargument name='ModuloOrigen' 	type="string" 	required='true'>		
		<cfargument name='FechaDocumento' 	type='date'   	required='true'>
		<cfargument name='AnoDocumento'	 	type='numeric' 	required='true'>
		<cfargument name='MesDocumento'	 	type='numeric' 	required='true'>
		<cfargument name="Conexion" 		type="string"  	required='false'>
		<cfif not isdefined("Arguments.Conexion")>
			<cfset Arguments.Conexion = session.DSN>
		</cfif>

		<cfset LvarAnoMesDocumento 	= Arguments.AnoDocumento*100+Arguments.MesDocumento>
		<cf_dbfunction name="OP_concat"	returnvariable="_Cat" datasource="#Arguments.Conexion#" >
		<cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}" datasource="#Arguments.Conexion#" returnVariable="LvarDesde">
		<cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}" datasource="#Arguments.Conexion#" returnVariable="LvarHasta">
		
		<cfparam name="session.Ecodigo" default="#Arguments.Ecodigo#">
		<cfif Arguments.Ecodigo EQ session.Ecodigo>
			<cfset LvarEmpresa = "">
		<cfelse>
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select Edescripcion from Empresas where Ecodigo = #Arguments.Ecodigo#
			</cfquery>
			<cfset LvarEmpresa = " en la Empresa '#rsSQL.Edescripcion#' ">
		</cfif>
				
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select CPPid, CPPestado, CPPfechaDesde, CPPfechaHasta, CPPanoMesDesde, CPPanoMesHasta,
				CPPcrearCtaCalculo, CPPcrearFrmCalculo,
				case CPPtipoPeriodo when 1 then 'Mensual' 
				                    when 2 then 'Bimestral' 
									when 3 then 'Trimestral' 
									when 4 then 'Cuatrimestral' 
									when 6 then 'Semestral' 
									when 12 then 'Anual' else '' end
					#_Cat# ' de '#_Cat#  case {fn month(CPPfechaDesde)} 
					                when 1 then 'Enero' 
									when 2 then 'Febrero' 
									when 3 then 'Marzo' 
									when 4 then 'Abril' 
									when 5 then 'Mayo' 
									when 6 then 'Junio' 
									when 7 then 'Julio' 
									when 8 then 'Agosto' 
									when 9 then 'Setiembre' 
									when 10 then 'Octubre' 
									when 11 then 'Noviembre' 
									when 12 then 'Diciembre' else '' end
					#_Cat#  ' ' #_Cat#  #PreserveSingleQuotes(LvarDesde)# #_Cat#  ' a ' #_Cat#  case {fn month(CPPfechaHasta)} 
					                when 1 then 'Enero' 
									when 2 then 'Febrero' 
									when 3 then 'Marzo' 
									when 4 then 'Abril' 
									when 5 then 'Mayo' 
									when 6 then 'Junio' 
									when 7 then 'Julio' 
									when 8 then 'Agosto' 
									when 9 then 'Setiembre' 
									when 10 then 'Octubre' 
									when 11 then 'Noviembre' 
									when 12 then 'Diciembre' else '' end
					#_Cat#  ' ' #_Cat#  #PreserveSingleQuotes(LvarHasta)# as CPPdescripcion
			  from CPresupuestoPeriodo
			 where Ecodigo = #Arguments.Ecodigo#
			   and #LvarAnoMesDocumento# between CPPanoMesDesde and CPPanoMesHasta
		</cfquery>
		<cfset LvarCPPdescripcion = rsSQL.CPPdescripcion>
		<cfif rsSQL.CPPid EQ "" AND ModuloOrigen NEQ 'PRFO'>
			<!--- Si no ha habido Periodo de Presupuesto anterior, entonces esta bien --->
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select count(1) as cantidad
				  from CPresupuestoPeriodo
				 where Ecodigo			= #Arguments.Ecodigo#
				   and CPPanoMesHasta	< #LvarAnoMesDocumento#
				   and CPPestado		<> 0
			</cfquery>
			<cfif rsSQL.cantidad GT 0>
				<cf_errorCode	code = "51285"
								msg  = "ERROR EN CONTROL PRESUPUESTARIO: No se ha definido el nuevo Período de Presupuesto para el mes @errorDat_1@/@errorDat_2@"
								errorDat_1="#Arguments.AnoDocumento#"
								errorDat_2="#Arguments.MesDocumento##LvarEmpresa#"
				>
			</cfif>
			<cfset rsSQL = QueryNew("CPPid")>
		<cfelseif rsSQL.CPPestado EQ "5">
			<cfif mid(ModuloOrigen,1,2) EQ "PR">
				<cf_errorCode	code = "51286"
								msg  = "ERROR EN CONTROL PRESUPUESTARIO: El Período de Presupuesto @errorDat_1@ está configurado sin presupuesto"
								errorDat_1="#LvarCPPdescripcion##LvarEmpresa#"
				>
			</cfif>
			<cfset rsSQL = QueryNew("CPPid")>
		<cfelseif NOT (rsSQL.CPPestado EQ "1" OR (ModuloOrigen EQ 'PRFO' AND rsSQL.CPPestado EQ "0"))>
			<cf_errorCode	code = "51287"
							msg  = "ERROR EN CONTROL PRESUPUESTARIO: El Período de Presupuesto @errorDat_1@ no está Abierto (Estado=@errorDat_2@)"
							errorDat_1="#LvarCPPdescripcion##LvarEmpresa#"
							errorDat_2="#rsSQL.CPPestado#"
			>
		<cfelseif Arguments.FechaDocumento LT rsSQL.CPPfechaDesde OR Arguments.FechaDocumento GT rsSQL.CPPfechaHasta>
			<!---
			<cf_errorCode	code = "51288"
							msg  = "ERROR EN CONTROL PRESUPUESTARIO: La fecha de documento '@errorDat_1@' no pertenece al Período de Presupuesto @errorDat_2@"
							errorDat_1="#DateFormat(Arguments.FechaDocumento,"DD/MM/YYYY")#"
							errorDat_2="#LvarCPPdescripcion#"
			>
			--->
 		</cfif>
		
		<cfreturn rsSQL>
	</cffunction>
	
	<cffunction name="ControlPresupuestario" output="no" returntype="numeric" access="public">
		<cfargument name='ModuloOrigen' 	type="string" 	required='true'>		
		<cfargument name='NumeroDocumento' 	type='string' 	required='true'>
		<cfargument name='NumeroReferencia' type='string' 	required='true'>
		<cfargument name='FechaDocumento' 	type='date'   	required='true'>
		<cfargument name='AnoDocumento'	 	type='numeric' 	required='true'>
		<cfargument name='MesDocumento'	 	type='numeric' 	required='true'>

		<cfargument name="Conexion" 		type="string"  	required='false'>
		<cfargument name="Ecodigo" 			type="numeric" 	required="false">		

		<cfargument name='NAPreversado'	 	type='numeric' 	required='false' default="-1">
		<cfargument name='SoloConsultar' 	type='boolean' 	required='false' default="False">
		<cfargument name='VerErrores' 		type='boolean' 	required='false' default="False">

		<cfargument name='Intercompany' 	type='boolean' 	required='false' default="False">
		<cfargument name='EcodigoOrigen'	type='numeric' 	required='false' default="-1">

		<cfargument name='Usucodigo'		type='numeric' 	required='false'>
		<cfargument name='PagadoAutomatico'	type='boolean' 	default='false'>

		<cfif not isdefined("Arguments.Conexion")>
			<cfset Arguments.Conexion = session.DSN>
		</cfif>
		<cfif not isDefined("Arguments.Ecodigo")>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif isDefined("Arguments.Usucodigo")>
			<cfset GvarUsucodigo = Arguments.Usucodigo>
		<cfelse>
			<cfset GvarUsucodigo = session.Usucodigo>
		</cfif>

		<cfif Arguments.Intercompany and Arguments.EcodigoOrigen EQ "-1">
			<cf_errorCode	code = "51289" msg = "The parameter [EcodigoOrigen] to function PRES_Presupuesto.ControlPresupuesto is required when [Intercompany=true] but was not passed in or passed ''.">
		<cfelseif NOT Arguments.Intercompany and Arguments.EcodigoOrigen NEQ "-1" AND Arguments.EcodigoOrigen NEQ Arguments.Ecodigo>
			<cf_errorCode	code = "51290" msg = "The parameter [EcodigoOrigen] to function PRES_Presupuesto.ControlPresupuesto is prohibited when [Intercompany=false].">
		<cfelseif Arguments.EcodigoOrigen EQ "-1">
			<cfset Arguments.EcodigoOrigen = Arguments.Ecodigo>
		</cfif>
		<cfif NOT Arguments.Intercompany>
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				update #Request.intPresupuesto#
				   set EcodigoOrigen = #Arguments.Ecodigo#
					 , EcodigoDst = #Arguments.Ecodigo#
			</cfquery>
		</cfif>
		
		<cfif trim(Arguments.NumeroReferencia) EQ "">
			<cfset Arguments.NumeroReferencia = "n/a">
		</cfif>

		<cfif NOT Arguments.SoloConsultar and Arguments.VerErrores>
			<cf_errorCode	code = "51291" msg = "The parameter [SoloConsultar] to function PRES_Presupuesto.ControlPresupuesto is required when [VerErrores] but was not passed in or passed 'false'.">
		</cfif>

		<cfset LvarFechaDocumento	= Arguments.FechaDocumento>
		<cfset LvarAnoMesDocumento 	= Arguments.AnoDocumento*100+Arguments.MesDocumento>

  		<!--- Se obtiene el Período de Presupuesto --->
		<cfset rsSQL = rsCPresupuestoPeriodo(Arguments.Ecodigo, Arguments.ModuloOrigen, Arguments.FechaDocumento, Arguments.AnoDocumento, Arguments.MesDocumento, Arguments.Conexion)>
		<cfif rsSQL.CPPid EQ "">
			<!--- Si no hay un Periodo de Presupuesto no se requiere ningun Control --->
			<cfquery name="rsPRES" datasource="#Arguments.Conexion#">
				select * from #Request.intPresupuesto# where 1=2
			</cfquery>
	
			<cfset sbGeneraRsIntPresupuesto (0,0, Arguments.Conexion, Arguments.Ecodigo)>
			<cfreturn 0>
 		</cfif>

		<cfset LvarCPPid			= rsSQL.CPPid>
		<cfset LvarCPPdescripcion	= rsSQL.CPPdescripcion>
		<cfset LvarCPPanoMesDesde	= rsSQL.CPPanoMesDesde>
		<cfset LvarCPPanoMesHasta	= rsSQL.CPPanoMesHasta>

		<!--- Se procesa cada Linea del documento --->
		<cfquery name="rsPRFO" datasource="#Arguments.Conexion#">
			select distinct TipoMovimiento
			  from #Request.intPresupuesto#
			 where TipoMovimiento in ('A','M','VC')
			 group by TipoMovimiento
		</cfquery>

		<cfif rsPRFO.recordCount GT 0>
			<cfif  ModuloOrigen EQ 'PRFO' AND rsPRFO.recordCount EQ 1>
				<cfset sbGeneracionMasiva(trim(rsPRFO.TipoMovimiento),Arguments.Conexion)>
<cflog file="FormulacionAplica" text="Inicia Generación de NAP">
				<cfset LvarNAP = fnGeneraNAP(Arguments.EcodigoOrigen, Arguments.ModuloOrigen, Arguments.NumeroDocumento, Arguments.NumeroReferencia, 
											 Arguments.FechaDocumento, Arguments.AnoDocumento, Arguments.MesDocumento, Arguments.NAPreversado, 
										 	 Arguments.Conexion, Arguments.Ecodigo)>
				<cfinvoke 	component	= "PRES_ContaPresupuestaria" 
							method		= "sbAgregaEnAsiento" 
							Ecodigo		= "#Arguments.Ecodigo#" 
							NAP			= "#LvarNAP#"
							Conexion	= "#Arguments.Conexion#"
				>
<cflog file="FormulacionAplica" text="fnGeneraNAP">
				<cfreturn LvarNAP>
			<cfelse>
				<cf_errorCode	code = "51292" msg = "ERROR EN CONTROL PRESUPUESTARIO: Se enviaron Movimientos de Formulacion, Modificación o Variacion Cambiaria, en forma incorrecta">
			</cfif>
		</cfif>

		<!--- Verifica que todas las lineas de una cancelacion referencien al NAP cancelado --->
		<cfif Arguments.NAPreversado EQ -1>
			<cfset LvarReversion = false>
		<cfelse>
			<cfset LvarReversion = true>
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select count(1) as cantidad
				  from #Request.intPresupuesto#
				 where TipoMovimiento NOT IN ('P','EJ','PA')
				   AND 	(
						   NAPreferencia <> #Arguments.NAPreversado#
						OR NAPreferencia IS NULL
						OR LINreferencia IS NULL
						)
			</cfquery>
			<cfif rsSQL.cantidad NEQ 0>
				<cf_errorCode	code = "51293"
								msg  = "ERROR EN CONTROL PRESUPUESTARIO: Existen Lineas en el Documento de Reversion que no están referenciando al NAP Reversado '@errorDat_1@'"
								errorDat_1="#Arguments.NAPreversado#"
				>
			</cfif>
		</cfif>

		<!--- SoloConsultar: Realiza un ROLLBACK para no realizar ni afectación presupuestaria ni afecta NAPreferencia ni genera NAP o NRP --->
		<cfset LvarSoloConsultar = Arguments.SoloConsultar>

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select Mcodigo
			  from Empresas
			 where Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfset LvarMcodigoLocal = rsSQL.Mcodigo>

		<!--- Plan de Compras --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #Arguments.Ecodigo#
			   and Pcodigo = 2300
		</cfquery>
		<cfset LvarPlanComprasActivo = (rsSQL.Pvalor EQ '1')>

		<!--- Se verifica que el AnoMes del Documento no sea Menor al AnoMes de Auxiliares (o AnoMes de Conta si el origen es CGCM o CGDC) --->

		<!--- Obtiene el mes de Actual del Movimiento Contabilidad o Auxiliares --->
		<!--- Obtiene el mes de Auxiliares --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #Arguments.Ecodigo#
			   and Pcodigo = 50
		</cfquery>
		<cfset LvarAuxAno = rsSQL.Pvalor>
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #Arguments.Ecodigo#
			   and Pcodigo = 60
		</cfquery>
		<cfset LvarAuxMes = rsSQL.Pvalor>
		<cfset LvarAuxAnoMes = LvarAuxAno*100+LvarAuxMes>

		<cfif mid(Arguments.ModuloOrigen,1,2) EQ "CG" OR mid(Arguments.ModuloOrigen,1,2) EQ "PR">
			<!--- Obtiene el mes de Contabilidad --->
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select Pvalor
				  from Parametros
				 where Ecodigo = #Arguments.Ecodigo#
				   and Pcodigo = 30
			</cfquery>
			<cfset LvarContaAno = rsSQL.Pvalor>
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select Pvalor
				  from Parametros
				 where Ecodigo = #Arguments.Ecodigo#
				   and Pcodigo = 40
			</cfquery>
			<cfset LvarContaMes = rsSQL.Pvalor>
			<cfset LvarAnoMesInferior = LvarContaAno*100+LvarContaMes>
			<cfset LvarAuxiliares = "Contabilidad">
		<cfelse>
			<cfset LvarAnoMesInferior = LvarAuxAnoMes>
			<cfset LvarAuxiliares = "Auxiliares">
		</cfif>

		<!--- Se Verifica si existe un NAP para el documento --->
		<cfquery name="rsNAP" datasource="#Arguments.Conexion#">
			select CPNAPnum
			  from CPNAP
			 where Ecodigo 				= #Arguments.Ecodigo#
			   and EcodigoOri		 	= #Arguments.EcodigoOrigen#
			   and CPNAPmoduloOri 		= '#Arguments.ModuloOrigen#'
			   and CPNAPdocumentoOri	= '#Arguments.NumeroDocumento#'
			   and CPNAPreferenciaOri	= '#Arguments.NumeroReferencia#'
		</cfquery>
		<cfif rsNAP.recordCount GT 0>
			<cf_errorCode	code = "51295"
							msg  = "ERROR EN CONTROL PRESUPUESTARIO: El documento ya fue aprobado y aplicado con el NAP=@errorDat_1@"
							errorDat_1="#rsNAP.CPNAPnum#"
			>
		</cfif>

		<!--- Se Verifica si existe un NRP anterior para el documento --->
		<cfquery name="rsNRPanterior" datasource="#Arguments.Conexion#">
			select CPNRPnum, UsucodigoAutoriza
			  from CPNRP
			 where Ecodigo 				= #Arguments.Ecodigo#
			   and EcodigoOri	 		= #Arguments.EcodigoOrigen#
			   and CPNRPmoduloOri 		= '#Arguments.ModuloOrigen#'
			   and CPNRPdocumentoOri	= '#Arguments.NumeroDocumento#'
			   and CPNRPreferenciaOri	= '#Arguments.NumeroReferencia#'
			   and CPNRPtipoCancela		= 0
		</cfquery>
		<cfif rsNRPanterior.UsucodigoAutoriza NEQ "">
			<cfset sbCancelaPendientesNrp(rsNRPanterior.CPNRPnum, Arguments.Conexion, Arguments.Ecodigo)>
		</cfif>

		<cfset LvarCrearFrm_NRP = arrayNew(1)>
		<!------------------------------------------------------------------------------------------------------------------------------>
		<!--- INICIALIZACION DE BANDERAS --->
		<!------------------------------------------------------------------------------------------------------------------------------>
		<!--- LvarControlPresupuestario: 	Bandera que indica que por lo menos hay una cuenta de presupuesto --->
		<!--- 								Y por tanto hay que generar NAP o NRP --->
		<cfset LvarControlPresupuestario = false>
		<!--- LvarAutorizado: 				Bandera que indica que no ha habido ningun rechazo presupuestario --->
		<cfset LvarAutorizado = true>
		<!--- LvarExcesoConOrigenAbierto: 	Bandera que indica que se generó un Exceso, pero no se rechazó porque hay una Autorizacion de Origen Abierto --->
		<cfset LvarExcesoConOrigenAbierto = false>

		<cfquery name="rsOrigenAbierto" datasource="#Arguments.Conexion#">
			select CPOid, Usucodigo
			  from CPOrigenesControlAbierto
			 where Ecodigo = #Arguments.Ecodigo#
			   and Oorigen = '#Arguments.ModuloOrigen#'
			   and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
					between CPOdesde and coalesce(CPOhasta, <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(2100,01,01)#">)
			   and CPOborrado = 0
		</cfquery>
		<!------------------------------------------------------------------------------------------------------------------------------>

		<cfquery datasource="#Arguments.Conexion#">
			update #Request.intPresupuesto#
			   set 	SignoMovimiento =
						case 
							when TipoMovimiento in ('A','M','ME','VC','T','TE') 
								then +1
								else -1
						end

					,CPCano	= case when CPCano is NULL then AnoDocumento else CPCano end
					,CPCmes	= case when CPCano is NULL then MesDocumento else CPCmes end

				    ,EcodigoOrigen	 	= #Arguments.EcodigoOrigen#
					,ModuloOrigen		= '#Arguments.ModuloOrigen#'
					,NumeroDocumento	= '#Arguments.NumeroDocumento#'
					,NumeroReferencia	= '#Arguments.NumeroReferencia#'
					,FechaDocumento		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaDocumento#">
					,AnoDocumento		= #Arguments.AnoDocumento#
					,MesDocumento		= #Arguments.MesDocumento#
					,NAPreversado		= #Arguments.NAPreversado#
					,MontoOrigen 		= round(MontoOrigen, 2)
					,Monto 				= round(Monto, 2)
					,CalculoIni =
						case CalculoControl
							when 1 then CPCanoMes
							when 2 then 0
							when 3 then 0
						end
					,CalculoFin =
						case CalculoControl
							when 1 then CPCanoMes
							when 2 then CPCanoMes
							when 3 then 999999
						end
		</cfquery>

		<!---
			Los movimientos se aplican en el siguiente orden:
				Orden cronológico Ano+Mes: con el fin de que al calcular el Disponible Original de un Mes, ya se hayan procesado los movimientos de meses anteriores.
				De mayor a menor monto: con el fin de que primero se procesen los movimientos que le dan fondos a la cuenta (movimientos positivos), y después se procesen los movimientos que utilizan fondos y que pueden generar NRPs (movimientos negativos).
		--->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
			  from #Request.intPresupuesto# p
		</cfquery>
		<cfif rsSQL.cantidad EQ 0>
			<cf_errorCode	code = "51296"
							msg  = "ERROR EN CONTROL PRESUPUESTARIO: Se envio a controlar un documento vacio (sin lineas de detalle): Origen=@errorDat_1@, Documento=@errorDat_2@, Referencia=@errorDat_3@"
							errorDat_1="#Arguments.ModuloOrigen#"
							errorDat_2="#Arguments.NumeroDocumento#"
							errorDat_3="#Arguments.NumeroReferencia#"
			>
		</cfif>

		<cfquery name="rsPRES" datasource="#Arguments.Conexion#">
			select p.*
			  from #Request.intPresupuesto# p
			<cfif Arguments.ModuloOrigen EQ "CGDC">
				<!--- 
					Como vienen de contabilidad, solo procesar líneas con Cuentas Financieras que tengan cuenta de Presupuesto:
					Los asientos contables ( que pueden ser transacciones grandes ) ya tienen CFcuenta asignada!
				 --->
					inner join CFinanciera cf
						 on cf.CFcuenta = p.CFcuenta
						and cf.CPcuenta is not null
			</cfif>
			 order by p.CPCano, p.CPCmes, p.SignoMovimiento*Monto desc
		</cfquery>

<cfset session.CPresupuestoControl.Total = rsPRES.recordCount>
		<cfloop query="rsPRES">
<cfset session.CPresupuestoControl.Avance = rsPRES.currentRow>
			<cfif isdefined("session.objInterfazSoin")>
				<cfset session.objInterfazSoin.sbReportarActividad(session.InterfazSoin.NI, session.InterfazSoin.ID)>
			</cfif>
			<cfset LvarMcodigo 	= fnObtenerMcodigo(rsPRES.Mcodigo, rsPRES.CodigoMoneda, Arguments.Conexion, Arguments.Ecodigo)>
			<cfset rsOficina 	= fnObtenerOficina(rsPRES.Ocodigo, rsPRES.CodigoOficina, Arguments.Conexion, Arguments.Ecodigo)>
			<cfset LvarCtas 	= fnObtenerCuentas(rsPRES.CFcuenta, rsPRES.Ccuenta, rsPRES.CPcuenta, rsPRES.CuentaFinanciera, Arguments.Conexion, Arguments.Ecodigo, rsPres.CPCano, rsPres.CPCmes, trim(rsPRES.TipoMovimiento) NEQ "A" AND trim(rsPRES.TipoMovimiento) NEQ "M")>

			<cfset rsPRES.Mcodigo 			= LvarMcodigo>
			<cfset rsPRES.Ocodigo  			= rsOficina.Ocodigo>
			<cfset rsPRES.CodigoOficina		= rsOficina.Oficodigo>

			<cfset rsPRES.CFcuenta 			= LvarCtas.CFcuenta>
			<cfset rsPRES.Ccuenta  			= LvarCtas.Ccuenta>
			<cfset rsPRES.CPcuenta 			= LvarCtas.CPcuenta>
			<cfset rsPRES.CuentaFinanciera	= LvarCtas.CFformato>
			<cfset rsPRES.CuentaPresupuesto	= LvarCtas.CPformato>

			<cfif LvarCtas.CPcuenta EQ "">
				<!--- Registra en blanco el detalle del Movimiento cuando no es de Presupuesto --->
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					update #Request.intPresupuesto#
					   set CFcuenta 			= <cfif LvarCtas.CFcuenta EQ ""> NULL<cfelse>#LvarCtas.CFcuenta#</cfif>
						 , Ccuenta  			= <cfif LvarCtas.Ccuenta EQ "">	 NULL<cfelse>#LvarCtas.Ccuenta#</cfif>
						 , CPcuenta 			= NULL
						 , CuentaFinanciera 	= <cfif LvarCtas.CFformato EQ "">NULL<cfelse>'#LvarCtas.CFformato#'</cfif>
						 , CuentaPresupuesto	= NULL
						 <cfif LvarMcodigo NEQ "">
						 , Mcodigo 				= #LvarMcodigo#
						 </cfif>
							 <cfif rsOficina.Ocodigo NEQ "">
							 , Ocodigo 				= #rsOficina.Ocodigo#
							 </cfif>
							 <cfif rsOficina.Oficodigo NEQ "">
							 , CodigoOficina		= '#rsOficina.Oficodigo#'
							 </cfif>
						 , ExcesoConRechazo		= 0
						 , ConError	= 0
						 , MSG = 'OK (Cuenta no tiene Control de Presupuesto)'
					 where NumeroLinea = #rsPRES.NumeroLinea#
					   and NumeroLineaID = #rsPRES.NumeroLineaID#
				</cfquery>
			<cfelse>
				<!--- Bandera que indica que hay que generar un NAP o un NRP --->
				<cfset LvarControlPresupuestario = true>	
				<cfset LvarCtaConPlanCompras 		 = false>
				
				<cfset rsPRES.CPPid = LvarCPPid>
				
				<cfif rsPRES.CPCano*100+rsPRES.CPCmes LT LvarCPPanoMesDesde OR rsPRES.CPCano*100+rsPRES.CPCmes GT LvarCPPanoMesHasta>
					<cf_errorCode	code = "51297"
									msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Linea '@errorDat_1@' del Documento no pertenece al Período de Presupuesto @errorDat_2@: mes de la linea='@errorDat_3@-@errorDat_4@'"
									errorDat_1="#rsPRES.NumeroLinea#"
									errorDat_2="#LvarCPPdescripcion#"
									errorDat_3="#rsPRES.CPCano#"
									errorDat_4="#rsPRES.CPCmes#"
					>
				<cfelseif rsPRES.CPCano*100+rsPRES.CPCmes LT LvarAnoMesInferior AND rsPRES.TipoMovimiento NEQ "RP" AND trim(rsPRES.TipoMovimiento) NEQ "E">
					<cfset LvarAuxAno = left ("#LvarAnoMesInferior#",4)>
					<cfset LvarAuxMes = right("#LvarAnoMesInferior#",2)>
					<cf_errorCode	code = "51299"
									msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Linea '@errorDat_1@' del Documento intenta afectar un mes anterior al Mes Actual de @errorDat_2@ '@errorDat_3@-@errorDat_4@': mes de la linea='@errorDat_5@-@errorDat_6@'"
									errorDat_1="#rsPRES.NumeroLinea#"
									errorDat_2="#LvarAuxiliares#"
									errorDat_3="#LvarAuxAno#"
									errorDat_4="#LvarAuxMes#"
									errorDat_5="#rsPRES.CPCano#"
									errorDat_6="#rsPRES.CPCmes#"
					>
				<cfelseif rsPRES.CPCano*100+rsPRES.CPCmes GT LvarAuxAnoMes AND rsPRES.TipoMovimiento NEQ "RP" AND rsPRES.TipoMovimiento NEQ "VC" AND trim(rsPRES.TipoMovimiento) NEQ "T" AND rsPRES.TipoMovimiento NEQ "TE">
					<cf_errorCode	code = "51298"
									msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Linea '@errorDat_1@' del Documento intenta afectar un mes posterior al Mes Actual de @errorDat_2@ '@errorDat_3@-@errorDat_4@': mes de la linea='@errorDat_5@-@errorDat_6@'"
									errorDat_1="#rsPRES.NumeroLinea#"
									errorDat_2="Auxiliares"
									errorDat_3="#LvarAuxAno#"
									errorDat_4="#LvarAuxMes#"
									errorDat_5="#rsPRES.CPCano#"
									errorDat_6="#rsPRES.CPCmes#"
					>
				<cfelseif rsPRES.TipoCambio LT 0>
					<cf_errorCode	code = "51300"
									msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Linea '@errorDat_1@' del Documento intenta afectar el presupuesto con un tipo de cambio negativo: '@errorDat_2@'"
									errorDat_1="#rsPRES.NumeroLinea#"
									errorDat_2="#numberFormat(rsPRES.TipoCambio,"0.0000")#"
					>
				<cfelseif abs( numberFormat( (rsPRES.MontoOrigen*rsPRES.TipoCambio - rsPRES.Monto),"0.00") ) GT 0.01>
					<cfif NOT (rsPRES.Mcodigo NEQ LvarMcodigoLocal AND rsPRES.MontoOrigen EQ 0 AND (rsPRES.TipoCambio EQ 0 OR rsPRES.TipoCambio EQ 1))>
						<cf_errorCode	code = "51301"
										msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Linea '@errorDat_1@' del Documento intenta afectar el presupuesto con un error cambiario: '@errorDat_2@ x @errorDat_3@ = @errorDat_4@' que no corresponde al monto en colones enviado de '@errorDat_5@'"
										errorDat_1="#rsPRES.NumeroLinea#"
										errorDat_2="#numberFormat(rsPRES.MontoOrigen,"0.00")#"
										errorDat_3="#numberFormat(rsPRES.TipoCambio,"0.0000")#"
										errorDat_4="#numberFormat(rsPRES.MontoOrigen*rsPRES.TipoCambio,"0.00")#"
										errorDat_5="#numberFormat(rsPRES.Monto,"0.00")#"
						>
					</cfif>
				<cfelseif LvarPlanComprasActivo>
					<cfif rsPRES.PCGDid NEQ "">
						<cfquery name="rsPCG" datasource="#Arguments.Conexion#">
							select 	c.CPcuenta, c.CPformato, PCGDxPlanCompras, 
									PCGDcantidad,	PCGDcantidadCompras, PCGDcantidadPendiente,
									PCGDautorizado, PCGDreservado, PCGDcomprometido, PCGDejecutado, PCGDpendiente, PCGDxCantidad
							  from PCGDplanCompras pcg
								inner join PCGcuentas c
									on c.PCGcuenta = pcg.PCGcuenta
							 where PCGDid = #rsPRES.PCGDid#
						</cfquery>
				
						<cfif rsPCG.CPcuenta NEQ LvarCtas.CPcuenta>
							<cfthrow message="ERROR EN CONTROL PRESUPUESTARIO: Cuenta de Presupuesto '#LvarCtas.CPformato#' no corresponde a la definida en Plan de Compras indicado">
						</cfif>
						<cfset LvarCtaConPlanCompras = (rsPCG.PCGDxPlanCompras EQ "1")>
					<cfelse>
						<cfset LvarCtaConPlanCompras = false>
						<cfquery name="rsPCG" datasource="#Arguments.Conexion#">
							select pcg.PCGDxPlanCompras, min(PCGDid) as PCGDid , count(1) as cantidad
							  from PCGDplanCompras pcg
								inner join PCGcuentas c
									on c.PCGcuenta = pcg.PCGcuenta
								inner join PCGplanCompras E
									on E.PCGEid = pcg.PCGEid
							 where pcg.Ecodigo	= #session.Ecodigo#
							   and E.CPPid		= #LvarCPPid#
							   and c.CPcuenta 	= #LvarCtas.CPcuenta#
							 group by pcg.PCGDxPlanCompras
						</cfquery>

						<cfif rsPCG.recordCount EQ 0>
							<!--- Inicialmente no se permitian cuentas si no estaban en el plan de compra: en veremos
							<cfthrow message="Cuenta de Presupuesto '#LvarCtas.CPformato#' no sido definida en el Plan de Compras">
							--->
						<cfelseif rsPCG.recordCount GT 1>
							<cfthrow message="Cuenta de Presupuesto '#LvarCtas.CPformato#' está definida tanto como control por Plan de Compras como por Cuenta de Presupuesto">
						<cfelseif rsPCG.PCGDxPlanCompras EQ 1>
							<cfthrow message="Cuenta de Presupuesto '#LvarCtas.CPformato#' requiere Plan de Compras y no se envío la referencia">
						<cfelseif rsPCG.cantidad GT 1>
							<cfthrow message="Cuenta de Presupuesto '#LvarCtas.CPformato#' está asociado a más de un Detalle de Plan de Compras con Control por Cuenta de Presupuesto">
						<cfelseif rsPCG.cantidad EQ 1 AND (rsPRES.TipoMovimiento EQ "A" OR rsPRES.TipoMovimiento EQ "M" OR rsPRES.TipoMovimiento EQ "ME" OR rsPRES.TipoMovimiento EQ "VC" OR rsPRES.TipoMovimiento EQ "T" OR rsPRES.TipoMovimiento EQ "TE")>
							<cfthrow message="Cuenta de Presupuesto '#LvarCtas.CPformato#' sólo puede Autorizar presupuesto si se envía la referencia al Plan de Compras">
						</cfif>
					</cfif>
				</cfif>

				<!--- Verifica la Linea de NAP referenciada y actualiza el Monto Utilizado --->
				<cfset LvarREF = fnProcesaNAPReferencia(rsPRES.NumeroLinea, rsPRES.NAPreferencia, rsPRES.LINreferencia, rsPRES.CPcuenta, rsOficina.Ocodigo, rsPRES.TipoMovimiento, rsPRES.Monto, Arguments.Conexion, Arguments.Ecodigo)>
				
				<cfif LvarREF.TipoMovimiento EQ "*">
					<!--- Registra en blanco el detalle del Movimiento cuando es Anulacion y el NAPReferencia es de Otro Período y no fue Liquidado en el Período Actual --->
					<cfquery datasource="#Arguments.Conexion#">
						update #Request.intPresupuesto#
						   set CFcuenta 			= <cfif LvarCtas.CFcuenta EQ ""> NULL<cfelse>#LvarCtas.CFcuenta#</cfif>
							 , Ccuenta  			= <cfif LvarCtas.Ccuenta EQ "">	 NULL<cfelse>#LvarCtas.Ccuenta#</cfif>
							 , CPcuenta 			= NULL
							 , CuentaFinanciera 	= <cfif LvarCtas.CFformato EQ "">NULL<cfelse>'#LvarCtas.CFformato#'</cfif>
							 , CuentaPresupuesto	= NULL
							 <cfif LvarMcodigo NEQ "">
							 , Mcodigo 				= #LvarMcodigo#
							 </cfif>
							 <cfif rsOficina.Ocodigo NEQ "">
							 , Ocodigo 				= #rsOficina.Ocodigo#
							 </cfif>
							 <cfif rsOficina.Oficodigo NEQ "">
							 , CodigoOficina		= '#rsOficina.Oficodigo#'
							 </cfif>
							 , ExcesoConRechazo		= 0
							 , ConError	= 0
							 , MSG = 'Movimiento de Anulacion de otro periodo no liquidado en el actual'
						 where NumeroLinea = #rsPRES.NumeroLinea#
						   and NumeroLineaID = #rsPRES.NumeroLineaID#
					</cfquery>
				<cfelse>
					<cfset rsPRES.TipoMovimiento = LvarREF.TipoMovimiento>
					<cfset rsPRES.NAPreferencia  = LvarREF.NAPreferencia>
					<cfset rsPRES.LINreferencia  = LvarREF.LINreferencia>
					<cfset rsPRES.Monto			 = LvarREF.Monto>
					
					<!--- Controla Plan de Compras --->
					<cfset LvarPCG = fnControlPlanCompras()>

					<!--- Calcula el Disponible, Exceso y determina si hay o no Autorización --->
					<cfset LvarControl = fnAutorizacionPresupuestaria (
											Arguments.ModuloOrigen, 
											Arguments.FechaDocumento,
											LvarCPPid,
											rsPRES.CPCano,
											rsPRES.CPCmes,
											LvarCtas.CPcuenta,
											rsOficina.Ocodigo,
											LvarREF.Monto,
											LvarREF.TipoMovimiento,
											Arguments.Conexion, Arguments.Ecodigo,
											Arguments.VerErrores)>

					<!--- Afecta las cuentas de control de presupuesto --->
					<cfif NOT LvarControl.OK>
						<cfset LvarAutorizado = false>
					</cfif>
	
					<cfif NOT LvarControl.ConError>
						<cfset sbAfectacionPresupuestaria (
									LvarCPPid,
									rsPRES.CPCano,
									rsPRES.CPCmes,
									LvarCtas.CPcuenta,
									rsOficina.Ocodigo,
									LvarREF.Monto,
									LvarREF.TipoMovimiento,
									Arguments.Conexion, Arguments.Ecodigo)>
					</cfif>
					
					<!--- Registra el detalle del Movimiento --->
					<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
						update #Request.intPresupuesto#
						   set CFcuenta 			= <cfif LvarCtas.CFcuenta EQ ""> NULL<cfelse>#LvarCtas.CFcuenta#</cfif>
							 , Ccuenta  			= <cfif LvarCtas.Ccuenta EQ "">	 NULL<cfelse>#LvarCtas.Ccuenta#</cfif>
							 , CPcuenta 			= <cfif LvarCtas.CPcuenta EQ ""> NULL<cfelse>#LvarCtas.CPcuenta#</cfif>
							 , CuentaFinanciera 	= <cfif LvarCtas.CFformato EQ "">NULL<cfelse>'#LvarCtas.CFformato#'</cfif>
							 , CuentaPresupuesto 	= <cfif LvarCtas.CPformato EQ "">NULL<cfelse>'#LvarCtas.CPformato#'</cfif>
							 <cfif LvarMcodigo NEQ "">
							 , Mcodigo 				= #LvarMcodigo#
							 </cfif>
							 <cfif rsOficina.Ocodigo NEQ "">
							 , Ocodigo 				= #rsOficina.Ocodigo#
							 </cfif>
							 <cfif rsOficina.Oficodigo NEQ "">
							 , CodigoOficina		= '#rsOficina.Oficodigo#'
							 </cfif>
							 , CPPid 				= #LvarControl.CPPid#
							 , CPCano 				= #LvarControl.CPCano#
							 , CPCmes 				= #LvarControl.CPCmes#

							 , SignoMovimiento		= #LvarControl.SignoMovimiento#
							 , DisponibleAnterior 	= #LvarControl.Disponible#
							 , NRPsPendientes		= #LvarControl.NRPsPendientes#

							 , Monto				= #LvarREF.Monto#

							 , PCGDid				= <cfif LvarPCG.PCGDid EQ "">NULL<cfelse>#LvarPCG.PCGDid#</cfif>
							 , PCGDcantidad			= #LvarPCG.PCGDcantidad#
							 , PCGDcantidadAntes	= #LvarPCG.CantidadAntes#
							 , PCGDdisponibleAntes	= #LvarPCG.DisponibleAntes#

						<cfif LvarRet.ConError>
							 , ConError = 2
							 , MSG					= '#LvarRet.MsgError#'
						<cfelse>
							<cfif LvarControl.ExcesoConRechazo>
							 , ConError = 1
							 , MSG = 'El movimiento generó un Exceso Neto que provoca un NRP'
							<cfelse>
							 , ConError = 0
							 , MSG = 'OK'
							</cfif>
							 , TipoControl 			= #LvarControl.CPCPtipoControl#
							 , CalculoControl 		= #LvarControl.CPCPcalculoControl#
							 , DisponibleGenerado 	= #LvarControl.DisponibleGenerado#
							 , ExcesoGenerado 		= #LvarControl.ExcesoGenerado#
							 , DisponibleNeto		= #LvarControl.DisponibleNeto#
							 , ExcesoNeto	 		= #LvarControl.ExcesoNeto#
							 , ExcesoConRechazo		= <cfif LvarControl.ExcesoConRechazo>1<cfelse>0</cfif>
						</cfif>
						<cfif rsPRES.NAPreferencia NEQ "">
							 , TipoMovimiento = '#LvarREF.TipoMovimiento#'
							 , NAPreferencia  = #LvarREF.NAPreferencia#
							 , LINreferencia  = #LvarREF.LINreferencia#
						<cfelse>
							 , NAPreferencia = NULL
							 , LINreferencia = NULL
						</cfif>
						 where NumeroLinea = #rsPRES.NumeroLinea#
						   and NumeroLineaID = #rsPRES.NumeroLineaID#
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>

		<cfset LvarCambioNrpAnterior = false>
		<cfif LvarExcesoConOrigenAbierto>
			<!--- CUANDO HAY ORIGEN ABIERTO Y HUBO RECHAZO --->
			<!--- SE GENERA EL NAP DE EXCESO Y SE AJUSTA EL DISPONIBLE DEL DETALLE NAP Y SE MANDA A GENERAR EL NAP --->
			<cfset LvarNAPexceso = fnGeneraNAPexceso (Arguments.Conexion, Arguments.Ecodigo)>
			<cfset LvarAutorizado = true>
			<cfif rsNRPanterior.CPNRPnum NEQ "">
				<!--- SE CANCELA EL NRP ANTERIOR PORQUE EL ORIGEN ES ABIERTO --->
				<cfset sbCancelaNrpAnterior (3, Arguments.Conexion, Arguments.Ecodigo)>
			</cfif>
		<cfelseif rsNRPanterior.CPNRPnum NEQ "">
			<cfif LvarAutorizado>
				<!--- CUANDO NO HAY CONTROL PRESUPUESTO O EL CONTROL LO AUTORIZO --->
				<!--- SE CANCELA EL NRP ANTERIOR PORQUE NO SE RECHAZO DE NUEVO EL DOCUMENTO --->
				<cfset sbCancelaNrpAnterior (2, Arguments.Conexion, Arguments.Ecodigo)>
			<cfelse>
				<!--- CUANDO HAY CONTROL PRESUPUESTO Y LO RECHAZO --->
				<!--- VERIFICA QUE EL NRP ANTERIOR SEA IGUAL AL ACTUAL --->
				<cfset LvarNRPanteriorOK = fnVerificaNRPanterior (Arguments.Conexion, Arguments.Ecodigo)>

				<cfif LvarNRPanteriorOK>
					<cfif rsNRPanterior.UsucodigoAutoriza EQ "">
						<!--- SE ENVIA ERROR PORQUE ES EL MISMO RECHAZO ANTERIOR --->
						<cf_errorCode	code = "51302"
										msg  = "ERROR EN CONTROL PRESUPUESTARIO: El documento fue rechazado anteriormente y no se ha aprobado el NRP=@errorDat_1@"
										errorDat_1="#rsNRPanterior.CPNRPnum#"
						>
					<cfelse>
						<!--- SE GENERA EL NAP DE EXCESO Y SE AJUSTA EL DISPONIBLE DEL DETALLE NAP Y SE MANDA A GENERAR EL NAP --->
						<cfset LvarNAPexceso = fnGeneraNAPexceso (Arguments.Conexion, Arguments.Ecodigo)>
						<cfset LvarAutorizado = true>
					</cfif>
				<cfelse>
					<!--- SE CANCELA EL NRP ANTERIOR PORQUE SE MODIFICO EL DOCUMENTO Y SE GENERA UN NUEVO NRP--->
					<!--- HAY QUE HACERLO DESPUES DEL ROLLBACK --->
					<cfset LvarCambioNrpAnterior = true>
				</cfif>
			</cfif>
		</cfif>
			
		<cfquery name="rsPRES" datasource="#Arguments.Conexion#">
			select * from #Request.intPresupuesto#
		</cfquery>

		<cfif LvarControlPresupuestario>
			<cfif LvarSoloConsultar>
				<cftransaction action="rollback" />

				<cfif LvarAutorizado>
					<cfset sbGeneraRsIntPresupuesto (1,0, Arguments.Conexion, Arguments.Ecodigo)>
					<cfreturn 1>
					<!--- DEVUELVE NAP=1 para indicar que se puede aprobar presupuestariamente --->
				<cfelse>
					<cfset sbGeneraRsIntPresupuesto (-1,-1, Arguments.Conexion, Arguments.Ecodigo)>
					<cfreturn -1>
					<!--- DEVUELVE NAP=-1 para indicar que se va a rechazar presupuestariamente --->
				</cfif>
			<cfelseif LvarAutorizado>
				<!--- GENERAR NAP --->
				<cfset LvarNAP = fnGeneraNAP(Arguments.EcodigoOrigen, Arguments.ModuloOrigen, Arguments.NumeroDocumento, Arguments.NumeroReferencia, 
											 Arguments.FechaDocumento, Arguments.AnoDocumento, Arguments.MesDocumento, Arguments.NAPreversado, 
										 	 Arguments.Conexion, Arguments.Ecodigo)>
				<cfset sbGeneraRsIntPresupuesto (LvarNAP,0, Arguments.Conexion, Arguments.Ecodigo)>

				<cfif NOT Arguments.Intercompany>
					<cfinvoke 	component	= "PRES_ContaPresupuestaria" 
								method		= "sbAgregaEnAsiento" 
								Ecodigo		= "#Arguments.Ecodigo#" 
								NAP			= "#LvarNAP#"
								Conexion	= "#Arguments.Conexion#"
					>
				</cfif>
				
				<!--- DEVUELVE NAP>0 para indicar que hubo una autorizacion en Control Presupuestario --->
				<cfreturn LvarNAP>
			<cfelse>
				<!--- DEVUELVE LA TRANSACCION --->
				<cftransaction action="rollback" />

				<cfif LvarCambioNrpAnterior>
					<cfif rsNRPanterior.UsucodigoAutoriza NEQ "">
						<!--- Se repite la cancelación de Pendientes porque se hizo un ROLLBACK --->
						<cfset sbCancelaPendientesNrp(rsNRPanterior.CPNRPnum, Arguments.Conexion, Arguments.Ecodigo)>
					</cfif>
					<cfset sbCancelaNrpAnterior (1, Arguments.Conexion, Arguments.Ecodigo)>
				</cfif>
	
				<!--- GENERAR NRP y vuelve a construir el intPresupuesto--->
				<cfset LvarNRP = fnGeneraNRP(Arguments.EcodigoOrigen, Arguments.ModuloOrigen, Arguments.NumeroDocumento, Arguments.NumeroReferencia, 
											 Arguments.FechaDocumento, Arguments.AnoDocumento, Arguments.MesDocumento, 
											 Arguments.Conexion, Arguments.Ecodigo)>
				<cfset sbGeneraRsIntPresupuesto (-1,LvarNRP, Arguments.Conexion, Arguments.Ecodigo)>

				<!--- DEVUELVE NAP<0 para indicar que hubo un rechazo en Control Presupuestario --->
				<cfreturn -LvarNRP>
			</cfif>
		<cfelse>
			<cfset sbGeneraRsIntPresupuesto (0,0, Arguments.Conexion, Arguments.Ecodigo)>

			<!--- DEVUELVE NAP=0 para indicar que no hubo Control Presupuestario --->
			<cfreturn 0>
		</cfif>
	</cffunction>
	
	<cffunction name="fnControlPlanCompras" output="no" returntype="struct" access="private">
		<cfargument name="Conexion"		type="string"  	required="no">

		<cfset var LvarPCG = structNew()>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfset LvarPCG.PCGDid		= rsPRES.PCGDid>
		<cfset LvarPCG.CUENTAPRESUPUESTO		= rsPRES.CUENTAPRESUPUESTO>
		<cfset LvarPCG.PCGDcantidad	= rsPRES.PCGDcantidad>

		<cfif NOT LvarCtaConPlanCompras>
			<cfset LvarPCG.DisponibleAntes		= 0>
			<cfset LvarPCG.CantidadAntes		= 0>
			<cfset LvarPCG.DisponibleGenerado	= 0>
			<cfset LvarPCG.CantidadGenerada		= 0>
		<cfelse>		
			<cfset LvarPCG.DisponibleAntes		= rsPCG.PCGDautorizado	- rsPCG.PCGDreservado-rsPCG.PCGDcomprometido-rsPCG.PCGDejecutado>
			<cfset LvarPCG.CantidadAntes		= rsPCG.PCGDcantidad	- rsPCG.PCGDcantidadCompras>
	
			<cfif rsPRES.TipoMovimiento EQ "A" OR rsPRES.TipoMovimiento EQ "M" OR rsPRES.TipoMovimiento EQ "ME" OR rsPRES.TipoMovimiento EQ "VC" OR rsPRES.TipoMovimiento EQ "T" OR rsPRES.TipoMovimiento EQ "TE">
				<cfset LvarPCG.DisponibleGenerado	= LvarPCG.DisponibleAntes 	+ LvarREF.Monto>
				<cfset LvarPCG.CantidadGenerada		= LvarPCG.CantidadAntes 	+ LvarPCG.PCGDcantidad>
			<cfelse>
				<cfset LvarPCG.DisponibleGenerado	= LvarPCG.DisponibleAntes 	- LvarREF.Monto>
				<cfset LvarPCG.CantidadGenerada		= LvarPCG.CantidadAntes 	- LvarPCG.PCGDcantidad>
			</cfif>
	
	
			<cfif LvarREF.Monto GT 0 AND LvarPCG.PCGDcantidad LT 0 OR LvarREF.Monto LT 0 AND LvarPCG.PCGDcantidad GT 0>
				<cfthrow message="Control de Plan de Compras: Monto (#LvarREF.Monto#) y cantidad (#LvarPCG.PCGDcantidad#) deben ser del mismo signo">
			<cfelseif rsPCG.PCGDxCantidad EQ 1 AND LvarREF.Monto NEQ 0 AND LvarPCG.PCGDcantidad EQ 0>
				<cfthrow message="Control de Plan de Compras: Cantidad debe ser diferente de CERO">
			<cfelseif rsPCG.PCGDxCantidad EQ 1 AND LvarPCG.CantidadGenerada-rsPCG.PCGDcantidadPendiente LT 0>
				<cfthrow message="Control de Plan de Compras: Cantidad Disponible Neto es menor a la cantidad a consumir (Cantidades: Disponible=#LvarPCG.CantidadAntes#, Pendiente=#rsPCG.PCGDcantidadPendiente#, Movimiento=#LvarPCG.PCGDcantidad#)">
			<cfelseif LvarPCG.DisponibleGenerado-rsPCG.PCGDpendiente LT 0>
				<cfthrow message="Control de Plan de Compras: Monto Disponible Neto es menor al monto a consumir #LvarPCG.PCGDid#(#LvarPCG.CUENTAPRESUPUESTO#)(Disponible Generado:#LvarPCG.DisponibleGenerado#  Disponible Pendiente:#rsPCG.PCGDpendiente#)">
			</cfif>
			
			<cfif rsPCG.PCGDxCantidad EQ 1>
				<cfset LvarCant = #LvarPCG.PCGDcantidad#>
			<cfelse>
				<cfset LvarCant = 0>
			</cfif>
			<cfquery datasource="#Arguments.Conexion#">
				update PCGDplanCompras
				<cfif rsPRES.TipoMovimiento EQ "A" OR rsPRES.TipoMovimiento EQ "M" OR rsPRES.TipoMovimiento EQ "ME" OR rsPRES.TipoMovimiento EQ "VC" OR rsPRES.TipoMovimiento EQ "T" OR rsPRES.TipoMovimiento EQ "TE">
				   set 	PCGDcantidad		= PCGDcantidad	 		+ #LvarCant#,
						PCGDautorizado		= PCGDautorizado 		+ #LvarREF.Monto#,
						PCGDcostoOri		= PCGDcostoOri			+ #rsPRES.MontoOrigen#
				<cfelseif rsPRES.TipoMovimiento EQ "RA" OR rsPRES.TipoMovimiento EQ "RP" OR rsPRES.TipoMovimiento EQ "RC">
				   set 	PCGDcantidadCompras	= PCGDcantidadCompras	+ #LvarCant#,
						PCGDreservado 		= PCGDreservado 		+ #LvarREF.Monto#
				<cfelseif rsPRES.TipoMovimiento EQ "CA" OR rsPRES.TipoMovimiento EQ "CC">
				   set 	PCGDcantidadCompras	= PCGDcantidadCompras	+ #LvarCant#,
						PCGDcomprometido	= PCGDcomprometido		+ #LvarREF.Monto#
				<cfelseif trim(rsPRES.TipoMovimiento) EQ "E">
				   set 	PCGDcantidadCompras	= PCGDcantidadCompras	+ #LvarCant#,
						PCGDejecutado		= PCGDejecutado 		+ #LvarREF.Monto#
				<cfelse>
				   set 	PCGDcantidad		= PCGDcantidad
				</cfif>
				 where PCGDid = #rsPRES.PCGDid#
			</cfquery>
		</cfif>

		<cfreturn LvarPCG>
	</cffunction>					

	<cffunction name="fnProcesaNAPReferencia" output="no" returntype="struct" access="private">
		<cfargument name="NumeroLinea"    type="numeric" required="yes">
		<cfargument name="NAPreferencia"  type="string" required="yes">
		<cfargument name="LINreferencia"  type="string" required="yes">
		<cfargument name="CPcuenta" 	  type="numeric" required="yes">
		<cfargument name="Ocodigo"	 	  type="numeric" required="yes">
		<cfargument name="TipoMovimiento" type="string"  required="yes">
		<cfargument name="Monto" 		  type="numeric" required="yes">
		
		<cfargument name="Conexion" 		type="string"  	required="yes">
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes">

		<cfset LvarRet.TipoMovimiento = trim(Arguments.TipoMovimiento)>
		<cfset LvarRet.NAPreferencia  = Arguments.NAPreferencia>
		<cfset LvarRet.LINreferencia  = Arguments.LINreferencia>
		<cfset LvarRet.Monto 		  = Arguments.Monto>

		<!--- Un NAPNAPreferencia = 0 con LINreferencia se da cuando arranca presupuesto despues de compras --->
		<cfif LvarRet.NAPreferencia EQ "0" AND LvarRet.LINreferencia NEQ "">
			<cfset LvarRet.TipoMovimiento = "*">
			<cfset LvarRet.NAPreferencia = "">
			<cfset LvarRet.LINreferencia = "">
			<cfreturn LvarRet>
		</cfif>

		<cfif LvarRet.NAPreferencia EQ "0">
			<cfset LvarRet.NAPreferencia = "">
			<cfset LvarRet.LINreferencia = "">
		</cfif>

		<cfif LvarRet.NAPreferencia EQ "" AND LvarRet.LINreferencia EQ "">
			<cfif (LvarRet.TipoMovimiento EQ "RP" OR LvarRet.TipoMovimiento EQ "RC" OR LvarRet.TipoMovimiento EQ "CC") AND Arguments.Monto LT 0>
				<cf_errorCode	code = "51303"
								msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Linea '@errorDat_1@' del Documento está tratando de utilizar fondos reservados sin indicar ninguna Linea de NAP de Referencia"
								errorDat_1="#Arguments.NumeroLinea#"
				>
			</cfif>
			<cfreturn LvarRet>
		</cfif>

		<cfif LvarRet.NAPreferencia EQ "" OR LvarRet.LINreferencia EQ "">
			<cfif LvarRet.NAPreferencia EQ ""><cfset LvarNAPref = "***"><cfelse><cfset LvarNAPref = LvarRet.NAPreferencia></cfif>
			<cfif LvarRet.LINreferencia EQ ""><cfset LvarLINref = "***"><cfelse><cfset LvarLINref = LvarRet.LINreferencia></cfif>
			<cf_errorCode	code = "51304"
							msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Linea '@errorDat_1@' del Documento esta referenciando incorrectamente una Linea de NAP = '@errorDat_2@-@errorDat_3@'"
							errorDat_1="#Arguments.NumeroLinea#"
							errorDat_2="#LvarNAPref#"
							errorDat_3="#LvarLINref#"
			>
		<cfelseif LvarRet.TipoMovimiento EQ "A" OR LvarRet.TipoMovimiento EQ "M" OR LvarRet.TipoMovimiento EQ "ME" OR LvarRet.TipoMovimiento EQ "VC" OR LvarRet.TipoMovimiento EQ "T" OR LvarRet.TipoMovimiento EQ "TE">
			<cf_errorCode	code = "51305"
							msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Linea '@errorDat_1@' del Documento esta referenciando una Linea de NAP = '@errorDat_2@-@errorDat_3@' cuyo tipo de Movimiento no es permitido '@errorDat_4@'"
							errorDat_1="#Arguments.NumeroLinea#"
							errorDat_2="#LvarRet.NAPreferencia#"
							errorDat_3="#LvarRet.LINreferencia#"
							errorDat_4="#LvarRet.TipoMovimiento#"
			>
		</cfif>
		
		<cfset LvarNAPref = Arguments.NAPreferencia>
		<cfset LvarLINref = Arguments.LINreferencia>
		<cfloop condition="LvarNAPref NEQ ''">
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select 	d.CPPid, d.CPNAPnum, d.CPNAPDlinea, d.Ocodigo,
						d.CPNAPDtipoMov, d.CPcuenta,
						
						round(d.CPNAPDmonto, 2) as CPNAPDmonto, 
						round(d.CPNAPDutilizado, 2) as CPNAPDutilizado, 
						round(d.CPNAPDmonto - d.CPNAPDutilizado, 2) as CPNAPDsaldo, 
						
						d.CPNAPnumRef, d.CPNAPDlineaRef, d.CPPidLiquidacion,
						e.CPNAPcongelado
				  from CPNAPdetalle d, CPNAP e
				 where d.Ecodigo 	 = #Arguments.Ecodigo#
				   and d.CPNAPnum 	 = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarNAPref#">
				   and d.CPNAPDlinea = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarLINref#">
				   and e.Ecodigo 	 = d.Ecodigo
				   and e.CPNAPnum 	 = d.CPNAPnum
			</cfquery>
			<cfif rsSQL.recordCount EQ 0>
				<cf_errorCode	code = "51306"
								msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Linea '@errorDat_1@' del Documento esta referenciando una Linea de NAP = '@errorDat_2@-@errorDat_3@' que no existe"
								errorDat_1="#Arguments.NumeroLinea#"
								errorDat_2="#LvarNAPref#"
								errorDat_3="#LvarLINref#"
				>
			<cfelseif rsSQL.CPNAPnumRef EQ LvarNAPref>
				<cf_errorCode	code = "51307"
								msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Linea '@errorDat_1@' del Documento esta referenciando una Linea de NAP = '@errorDat_2@-@errorDat_3@' al mismo NAP"
								errorDat_1="#Arguments.NumeroLinea#"
								errorDat_2="#LvarNAPref#"
								errorDat_3="#LvarLINref#"
				>
			<cfelseif LvarReversion AND rsSQL.CPNAPnum EQ Arguments.NAPreferencia>
				<cfif (Arguments.Monto LT 0 AND rsSQL.CPNAPDmonto LT 0) OR (Arguments.Monto GT 0 AND rsSQL.CPNAPDmonto GT 0)>
					<cf_errorCode	code = "51308"
									msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Linea '@errorDat_1@' del Documento de reversion no esta reversando la Linea de NAP referencida = '@errorDat_2@-@errorDat_3@' (no son de signo contrario). Referenciado=@errorDat_4@, Reversión=@errorDat_5@"
									errorDat_1="#Arguments.NumeroLinea#"
									errorDat_2="#LvarNAPref#"
									errorDat_3="#LvarLINref#"
									errorDat_4="#fnNumberFormat(rsSQL.CPNAPDmonto)#"
									errorDat_5="#fnNumberFormat(Arguments.Monto)#"
					>">
				<cfelseif abs(Arguments.Monto) - 0.02 GTE abs(rsSQL.CPNAPDmonto)>
					<cf_errorCode	code = "51309"
									msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Linea '@errorDat_1@' del Documento de reversion esta reversando un monto mayor a la Linea de NAP refenciada = '@errorDat_2@-@errorDat_3@'. Referenciado=@errorDat_4@, Reversión=@errorDat_5@"
									errorDat_1="#Arguments.NumeroLinea#"
									errorDat_2="#LvarNAPref#"
									errorDat_3="#LvarLINref#"
									errorDat_4="#fnNumberFormat(rsSQL.CPNAPDmonto)#"
									errorDat_5="#fnNumberFormat(Arguments.Monto)#"
					>
				<cfelseif abs(Arguments.Monto) - 0.02 GTE abs(rsSQL.CPNAPDmonto)>
					<cfset Arguments.Monto = -rsSQL.CPNAPDmonto>
				</cfif>
			<cfelseif NOT LvarReversion and rsSQL.CPNAPcongelado EQ 1 AND (rsSQL.CPNAPnum EQ Arguments.NAPreferencia OR rsSQL.CPNAPnumRef EQ "")>
				<cf_errorCode	code = "51310"
								msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Linea '@errorDat_1@' del Documento esta referenciando un NAP congelado = '@errorDat_2@'"
								errorDat_1="#Arguments.NumeroLinea#"
								errorDat_2="#LvarNAPref#"
				>
			</cfif>
			<cfset LvarNAPref = rsSQL.CPNAPnumRef>
			<cfset LvarLINref = rsSQL.CPNAPDlineaRef>
		</cfloop>
		
		<cfset LvarRet.NAPreferencia = rsSQL.CPNAPnum>
		<cfset LvarRet.LINreferencia = rsSQL.CPNAPDlinea>
		
		<cfif NOT (trim(rsSQL.CPNAPDtipoMov) EQ LvarRet.TipoMovimiento OR (trim(rsSQL.CPNAPDtipoMov) EQ "E" AND listFind("P,EJ,PA",LvarRet.TipoMovimiento)))>
			<cf_errorCode	code = "51311"
							msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Linea '@errorDat_1@' del Documento esta referenciando una Linea de NAP = '@errorDat_2@-@errorDat_3@' de diferente Tipo de Movimiento presupuestario"
							errorDat_1="#Arguments.NumeroLinea#"
							errorDat_2="#LvarRet.NAPreferencia#"
							errorDat_3="#LvarRet.LINreferencia#"
			>
		</cfif>

		<cfif rsSQL.CPPid NEQ LvarCPPid>
			<cfif rsSQL.CPPidLiquidacion NEQ LvarCPPid AND LvarReversion>
				<cfset LvarRet.TipoMovimiento = '*'>	<!--- Se ignora cuando se Anula un NAPreferenciado de Otro Periodo no Liquidado en este --->
			<cfelseif rsSQL.CPPidLiquidacion NEQ LvarCPPid>
				<cf_errorCode	code = "51312"
								msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Linea '@errorDat_1@' del Documento esta intentando utilizar fondos reservados de una Linea de NAP = '@errorDat_2@-@errorDat_3@' de otro Periodo Presupuestario que no fue Liquidado en el Actual"
								errorDat_1="#Arguments.NumeroLinea#"
								errorDat_2="#LvarRet.NAPreferencia#"
								errorDat_3="#LvarRet.LINreferencia#"
				>
			<cfelseif LvarRet.TipoMovimiento EQ 'RC'>	<!--- OR LvarRet.TipoMovimiento EQ 'RA' --->
				<cfset LvarRet.TipoMovimiento = 'RA'>
			<cfelseif LvarRet.TipoMovimiento EQ 'CC'>	<!--- OR LvarRet.TipoMovimiento EQ 'CA' --->
				<cfset LvarRet.TipoMovimiento = 'CA'>
			<cfelse>
				<cf_errorCode	code = "51313"
								msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Linea '@errorDat_1@' del Documento esta intentando utilizar fondos reservados de una Linea de NAP = '@errorDat_2@-@errorDat_3@' de otro Periodo Presupuestario con un tipo de movimiento no permitido = '@errorDat_4@'"
								errorDat_1="#Arguments.NumeroLinea#"
								errorDat_2="#LvarRet.NAPreferencia#"
								errorDat_3="#LvarRet.LINreferencia#"
								errorDat_4="#LvarRet.TipoMovimiento#"
				>
			</cfif> 
		</cfif>

		<cfif rsSQL.CPcuenta NEQ Arguments.CPcuenta>
			<cf_errorCode	code = "51314"
							msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Linea '@errorDat_1@' del Documento esta referenciando una Linea de NAP = '@errorDat_2@-@errorDat_3@' de diferente Cuenta de Presupuesto"
							errorDat_1="#Arguments.NumeroLinea#"
							errorDat_2="#LvarRet.NAPreferencia#"
							errorDat_3="#LvarRet.LINreferencia#"
			>
		</cfif>
		<cfif rsSQL.Ocodigo NEQ Arguments.Ocodigo>
			<cf_errorCode	code = "51315"
							msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Linea '@errorDat_1@' del Documento esta referenciando una Linea de NAP = '@errorDat_2@-@errorDat_3@' de diferente Oficina"
							errorDat_1="#Arguments.NumeroLinea#"
							errorDat_2="#LvarRet.NAPreferencia#"
							errorDat_3="#LvarRet.LINreferencia#"
			>
		</cfif>
		
		<cfif not listFind("P,EJ,PA",LvarRet.TipoMovimiento)>
			<cfif LvarRet.Monto LT 0>
				<!--- Un Monto <= 0 referenciando una linea significa que va a utilizar fondos del saldo de la referencia --->
				<cfif rsSQL.CPNAPDsaldo EQ 0>
					<cf_errorCode	code = "51316"
									msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Linea '@errorDat_1@' del Documento esta intentando utilizar fondos reservados de la Linea de NAP = '@errorDat_2@-@errorDat_3@' que ya no tiene saldo. Original=@errorDat_4@, Saldo=@errorDat_5@, Movimiento=@errorDat_6@"
									errorDat_1="#Arguments.NumeroLinea#"
									errorDat_2="#LvarRet.NAPreferencia#"
									errorDat_3="#LvarRet.LINreferencia#"
									errorDat_4="#fnNumberFormat(rsSQL.CPNAPDmonto)#"
									errorDat_5="#fnNumberFormat(rsSQL.CPNAPDsaldo)#"
									errorDat_6="#fnNumberFormat(-LvarRet.Monto)#"
					>
				<cfelseif abs(LvarRet.Monto) - 0.02 GTE rsSQL.CPNAPDsaldo>
					<cf_errorCode	code = "51317"
									msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Linea '@errorDat_1@' del Documento esta intentando utilizar fondos reservados de la Linea de NAP = '@errorDat_2@-@errorDat_3@' cuyo saldo es menor al monto requerido. Original=@errorDat_4@, Saldo=@errorDat_5@, Movimiento=@errorDat_6@"
									errorDat_1="#Arguments.NumeroLinea#"
									errorDat_2="#LvarRet.NAPreferencia#"
									errorDat_3="#LvarRet.LINreferencia#"
									errorDat_4="#fnNumberFormat(rsSQL.CPNAPDmonto)#"
									errorDat_5="#fnNumberFormat(rsSQL.CPNAPDsaldo)#"
									errorDat_6="#fnNumberFormat(-LvarRet.Monto)#"
					>
				<!--- Ajusta monto cuando es .01 o .02 mas grande que el saldo --->
				<cfelseif rsSQL.CPNAPDsaldo - abs(LvarRet.Monto) LT 0>
					<cfset LvarRet.Monto = -rsSQL.CPNAPDsaldo>
				</cfif>
			<cfelseif LvarRet.Monto GT 0>
				<!--- Un Monto > 0 referenciando una linea significa que va a devolver fondos al saldo de la referencia --->
				<cfif rsSQL.CPNAPDutilizado EQ 0>
					<cf_errorCode	code = "51318"
									msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Linea '@errorDat_1@' del Documento esta intentando devolver fondos a la reserva de la Linea de NAP = '@errorDat_2@-@errorDat_3@' que no han sido utilizados. Original=@errorDat_4@, Utilizado=@errorDat_5@, Movimiento=@errorDat_6@"
									errorDat_1="#Arguments.NumeroLinea#"
									errorDat_2="#LvarRet.NAPreferencia#"
									errorDat_3="#LvarRet.LINreferencia#"
									errorDat_4="#fnNumberFormat(rsSQL.CPNAPDmonto)#"
									errorDat_5="#fnNumberFormat(rsSQL.CPNAPDutilizado)#"
									errorDat_6="#fnNumberFormat(LvarRet.Monto)#"
					>
				<cfelseif LvarRet.Monto - 0.02 GTE rsSQL.CPNAPDutilizado>
					<cf_errorCode	code = "51319"
									msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Linea '@errorDat_1@' del Documento esta intentando devolver fondos a la reserva de la Linea de NAP = '@errorDat_2@-@errorDat_3@' mayores a los utilizados. Original=@errorDat_4@, Utilizado=@errorDat_5@, Movimiento=@errorDat_6@"
									errorDat_1="#Arguments.NumeroLinea#"
									errorDat_2="#LvarRet.NAPreferencia#"
									errorDat_3="#LvarRet.LINreferencia#"
									errorDat_4="#fnNumberFormat(rsSQL.CPNAPDmonto)#"
									errorDat_5="#fnNumberFormat(rsSQL.CPNAPDutilizado)#"
									errorDat_6="#fnNumberFormat(LvarRet.Monto)#"
					>
				<!--- Ajusta monto cuando es .01 o .02 mas grande que utilizado --->
				<cfelseif LvarRet.Monto GT rsSQL.CPNAPDutilizado>
					<cfset LvarRet.Monto = rsSQL.CPNAPDutilizado>
				</cfif>
			</cfif>
	
			<cfquery datasource="#Arguments.Conexion#">
				update CPNAPdetalle
				   set CPNAPDreferenciado = 1
					 , CPNAPDutilizado = round(CPNAPDutilizado, 2) - #LvarRet.Monto#
				 where Ecodigo = #Arguments.Ecodigo#
				   and CPNAPnum 	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarRet.NAPreferencia#">
				   and CPNAPDlinea 	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarRet.LINreferencia#">
			</cfquery>
		</cfif>
		
		<cfreturn LvarRet>
	</cffunction>

	<cffunction name="fnNumberFormat" returntype="string" output="no">
		<cfargument name="Number" type="string">
		
		<cfset var LvarNumber = Numberformat(Arguments.Number,",0.0000")>
		<cfset var LvarNumberN = len(LvarNumber)>
		
		<cfif mid(LvarNumber,LvarNumberN,1) NEQ "0">
			<cfreturn LvarNumber>
		<cfelseif mid(LvarNumber,LvarNumberN-1,1) NEQ "0">
			<cfreturn mid(LvarNumber,1,LvarNumberN-1)>
		<cfelse>
			<cfreturn mid(LvarNumber,1,LvarNumberN-2)>
		</cfif>
	</cffunction>

	<cffunction name="CalculoDisponible" output="no" returntype="struct" access="public">
		<cfargument name="CPPid"	 			type="string"  required="yes">
		<cfargument name="CPCano" 				type="string"  required="yes">
		<cfargument name="CPCmes"	 			type="string"  required="yes">
		<cfargument name="CPcuenta" 			type="string"  required="yes">
		<cfargument name="Ocodigo"	 			type="numeric" required="yes">
		<cfargument name="TipoMovimiento" 	    type="string"  required="yes">

		<cfargument name="Conexion" 		type="string"  	required="yes">
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes">

		<cfreturn fnCalculoDisponible(Arguments.CPPid,Arguments.CPCano,Arguments.CPCmes,Arguments.CPcuenta,Arguments.Ocodigo,Arguments.TipoMovimiento,Arguments.Conexion,Arguments.Ecodigo,false)>
	</cffunction>	
	
	<cffunction name="fnCalculoDisponible" output="no" returntype="struct" access="public">
		<cfargument name="CPPid"	 			type="string"  required="yes">
		<cfargument name="CPCano" 				type="string"  required="yes">
		<cfargument name="CPCmes"	 			type="string"  required="yes">
		<cfargument name="CPcuenta" 			type="string"  required="yes">
		<cfargument name="Ocodigo"	 			type="numeric" required="yes">
		<cfargument name="TipoMovimiento" 	    type="string"  required="yes">

		<cfargument name="Conexion" 		type="string"  	required="yes">
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes">

		<cfargument name="VerErrores" 		type="boolean" 	required="yes">
	
		<cfset LvarRet = StructNew()>

		<cfset LvarRet.ConError			= false>
		<cfset LvarRet.MsgError			= "">
		<cfset LvarRet.CPPid 			= Arguments.CPPid>
		<cfset LvarRet.CPCano			= Arguments.CPCano>
		<cfset LvarRet.CPCmes			= Arguments.CPCmes>
		<cfset LvarRet.CPcuenta			= Arguments.CPcuenta>
		<cfset LvarRet.Ocodigo			= Arguments.Ocodigo>
		<cfset LvarRet.Mes 				= structNew()>
		<cfset LvarRet.Autorizado 		= 0>
		<cfset LvarRet.Utilizado  		= 0>
		<cfset LvarRet.Disponible 		= 0>
		<cfset LvarRet.NRPsPendientes 	= 0>

		<!--- Obtiene el mes de Actual del Movimiento Contabilidad o Auxiliares --->
		<cfif not isdefined("LvarAuxAnoMes")>
			<!--- Obtiene el mes de Auxiliares --->
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select Pvalor
				  from Parametros
				 where Ecodigo = #Arguments.Ecodigo#
				   and Pcodigo = 50
			</cfquery>
			<cfset LvarAuxAno = rsSQL.Pvalor>
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select Pvalor
				  from Parametros
				 where Ecodigo = #Arguments.Ecodigo#
				   and Pcodigo = 60
			</cfquery>
			<cfset LvarAuxMes = rsSQL.Pvalor>
			<cfset LvarAuxAnoMes = LvarAuxAno*100+LvarAuxMes>
		</cfif>

		<cfset LvarMesFuturo = (LvarRet.CPCano*100+LvarRet.CPCmes GT LvarAuxAnoMes)>
		<cfset LvarMesPasado = (LvarRet.CPCano*100+LvarRet.CPCmes LT LvarAuxAnoMes)>
		
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select CPPanoMesDesde, CPPanoMesHasta, CPPcrearFrmCalculo
			  from CPresupuestoPeriodo
			 where Ecodigo = #Arguments.Ecodigo#
			   and CPPid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#Arguments.CPPid#">
		</cfquery>
		<cfif rsSQL.recordCount EQ 0>
			<cf_errorCode	code = "51320"
							msg  = "ERROR EN CONTROL PRESUPUESTARIO: No existe el Periodo de Presupuesto id='[@errorDat_1@]'"
							errorDat_1="#Arguments.CPPid#"
			>
		</cfif>
		
		<cfif isdefined("request.CP_Automatico")>
			<cfset LvarCrearFormulacion 		= true>
			<cfset LvarRet.CPCPtipoControl 		= 0>
			<cfset LvarRet.CPCPcalculoControl 	= 3>
		<cfelse>
			<cfset LvarCrearFormulacion 		= (rsSQL.CPPcrearFrmCalculo NEQ 0)>
			<cfset LvarRet.CPCPtipoControl 		= 0>
			<cfset LvarRet.CPCPcalculoControl 	= rsSQL.CPPcrearFrmCalculo>
		</cfif>
		
		<cftry>
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select rtrim(CPformato) as CPformato
				  from CPresupuesto
				 where Ecodigo = #Arguments.Ecodigo#
				   and CPcuenta = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#Arguments.CPcuenta#">
			</cfquery>
	
			<cfif rsSQL.recordCount EQ 0>
				<cf_errorCode	code = "51321"
								msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Cuenta de Presupuesto id='[@errorDat_1@]' no Existe"
								errorDat_1="#Arguments.CPcuenta#"
				>
			</cfif>
	
			<cfset LvarCPformato = rsSQL.CPformato>
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select 	CPCPtipoControl, 
						CPCPcalculoControl
				  from CPCuentaPeriodo
				 where Ecodigo = #Arguments.Ecodigo#
				   and CPPid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#Arguments.CPPid#">
				   and CPcuenta = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#Arguments.CPcuenta#">
			</cfquery>
	
			<cfif rsSQL.recordCount NEQ 0>
				<cfset LvarRet.CPCPtipoControl 		= rsSQL.CPCPtipoControl>
				<cfset LvarRet.CPCPcalculoControl 	= rsSQL.CPCPcalculoControl>
			<cfelse>
				<cfif LvarCrearFormulacion>
					<!--- Se permite crear formulación en linea por lo que se agrega al período --->
					<cfquery datasource="#Arguments.Conexion#">
						insert into CPCuentaPeriodo
							(
								Ecodigo, CPPid, CPcuenta, 
								CPCPtipoControl, CPCPcalculoControl
							)
						values
							(
								#Arguments.Ecodigo#,
								<cfqueryparam  cfsqltype="cf_sql_numeric" value="#Arguments.CPPid#">,
								<cfqueryparam  cfsqltype="cf_sql_numeric" value="#Arguments.CPcuenta#">,
								#LvarRet.CPCPtipoControl#,
								#LvarRet.CPCPcalculoControl#
							)
					</cfquery>
				<cfelse>
					<cf_errorCode	code = "51322"
									msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Cuenta de Presupuesto '@errorDat_1@' no Existe en Período @errorDat_2@"
									errorDat_1="#LvarCPformato#"
									errorDat_2="#LvarCPPdescripcion#"
					>
				</cfif>
			</cfif>
	
			<!--- ========================================================
					CPCPtipoControl:
					0	Abierto:		No hay Control (registra el movimiento sin verificar disponible, no genera NAP)
					1	Restringido:	Permite excederse con autorizacion (Si se excede el disponible, se genera un CPNumeroRechazoPresup que puede ser autorizado o rechazado manualmente)
					2	Restrictivo:	No permite excederse (Si se excede el disponible, se genera un CPNumeroRechazoPresup rechazado automaticamente)
	
					CPCPcalculoControl:
					1	Mensual:		No puede exceder el disponible del mes correspondiente
					2	Acumulado:		No puede exceder la suma de disponibles del inicio de periodo al mes correspondiente
					3	Total:			No puede exceder la suma de disponibles de todo el periodo
				  ======================================================== --->
	

			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select	CPcuenta,
						CPCpresupuestado, CPCmodificado, CPCmodificacion_Extraordinaria, CPCvariacion, CPCtrasladado, CPCtrasladadoE,
						CPCreservado_Anterior, CPCcomprometido_Anterior, 
						CPCreservado_Presupuesto, 
						CPCreservado, CPCcomprometido, 
						CPCejecutado,
						CPCnrpsPendientes					
				  from CPresupuestoControl
				 where Ecodigo = #Arguments.Ecodigo#
				   and CPPid 	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarRet.CPPid#">
				   and CPCano 	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarRet.CPCano#">
				   and CPCmes 	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarRet.CPCmes#">
				   and CPcuenta = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarRet.CPcuenta#">
				   and Ocodigo  = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarRet.Ocodigo#">
			</cfquery>
	
			<cfif rsSQL.CPcuenta EQ "">
				<cfset LvarCrearSaldos = LvarCrearFormulacion>

				<cfif LvarRet.CPCPcalculoControl EQ "3" AND NOT LvarCrearFormulacion>
					<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
						select count(1) as cant
						  from CPresupuestoControl
						 where Ecodigo = #Arguments.Ecodigo#
						   and CPPid 	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarRet.CPPid#">
						   and CPcuenta = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarRet.CPcuenta#">
						   and Ocodigo  = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarRet.Ocodigo#">
					</cfquery>
					<cfif rsSQL.cant EQ 0>
						<cfset LvarRet.CPCmes = "#LvarRet.CPCmes# (ni en ningun otro mes)">
					<cfelse>
						<cfset LvarCrearSaldos = true>
					</cfif>
				</cfif>
				
				<cfif LvarCrearSaldos>
					<!--- Guarda las formulaciones a crear en caso de un NRP --->
					<cfparam name="LvarCrearFrm_NRP" default="#arraynew(1)#">
					<cfset LvarIdx = arrayLen(LvarCrearFrm_NRP)+1>
					<cfset LvarCrearFrm_NRP [LvarIdx] = structNew()>
					<cfset LvarCrearFrm_NRP [LvarIdx].CPcuenta			= LvarRet.CPcuenta>
					<cfset LvarCrearFrm_NRP [LvarIdx].Ocodigo			= LvarRet.Ocodigo>
					<cfset LvarCrearFrm_NRP [LvarIdx].CPCPcalculoControl= LvarRet.CPCPcalculoControl>
					<!--- --->
					<cfquery datasource="#Arguments.Conexion#">
						insert into CPresupuestoControl
							(
								Ecodigo, CPPid, CPCano, CPCmes, CPcuenta, Ocodigo, CPCanoMes
							)
						select	Ecodigo, CPPid, CPCano, CPCmes, #LvarRet.CPcuenta#, #LvarRet.Ocodigo#, CPCano*100+CPCmes
						  from CPmeses mm
						 where Ecodigo  = #Arguments.Ecodigo#
						   and CPPid 	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarRet.CPPid#">
						   and (
						   		select count(1)
								  from CPresupuestoControl
								 where Ecodigo	= mm.Ecodigo
								   and CPPid	= mm.CPPid
								   and CPCano	= mm.CPCano
								   and CPCmes	= mm.CPCmes
								   and CPcuenta	= #LvarRet.CPcuenta#
								   and Ocodigo	= #LvarRet.Ocodigo#
								) = 0
					</cfquery>
					<cfset LvarRet.Mes.Autorizado		= 0>
					<cfset LvarRet.Mes.Utilizado		= 0>
					<cfset LvarRet.Mes.Disponible		= 0>
					<cfset LvarRet.Mes.NRPsPendientes	= 0>
					<cfset LvarRet.Mes.Neto				= 0>
				<cfelse>
					<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
						select	CPformato, Oficodigo, Odescripcion
						  from CPresupuesto c, Oficinas o
						 where c.CPcuenta = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarRet.CPcuenta#">
						   and o.Ecodigo = #Arguments.Ecodigo#
						   and o.Ocodigo  = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarRet.Ocodigo#">
					</cfquery>
					<cf_errorCode	code = "51323"
									msg  = "ERROR EN CONTROL PRESUPUESTARIO: No ha sido Formulado Presupuesto para cuenta '@errorDat_1@' en la Oficina '@errorDat_2@=@errorDat_3@' durante el mes '@errorDat_4@-@errorDat_5@'"
									errorDat_1="#trim(rsSQL.CPformato)#"
									errorDat_2="#trim(rsSQL.Oficodigo)#"
									errorDat_3="#rsSQL.Odescripcion#"
									errorDat_4="#LvarRet.CPCano#"
									errorDat_5="#LvarRet.CPCmes#"
					>
				</cfif>
			<cfelse>
				<cfset LvarRet.Mes.Autorizado		= rsSQL.CPCpresupuestado + rsSQL.CPCmodificado + rsSQL.CPCmodificacion_Extraordinaria + rsSQL.CPCvariacion + rsSQL.CPCtrasladado + rsSQL.CPCtrasladadoE>
				<cfset LvarRet.Mes.Utilizado		= rsSQL.CPCreservado_Anterior + rsSQL.CPCcomprometido_Anterior
													+ rsSQL.CPCreservado_Presupuesto 
													+ rsSQL.CPCreservado + rsSQL.CPCcomprometido
													+ rsSQL.CPCejecutado>
				<cfset LvarRet.Mes.Disponible		= LvarRet.Mes.Autorizado - LvarRet.Mes.Utilizado>
				<cfset LvarRet.Mes.NRPsPendientes	= rsSQL.CPCnrpsPendientes>
				<cfset LvarRet.Mes.Neto				= LvarRet.Mes.Disponible + LvarRet.Mes.NRPsPendientes>
			</cfif>
			
	
			<cfif LvarRet.CPCPcalculoControl EQ "1">
				<!--- ========================================================
						Presupuesto Autorizado = CPCpresupuestado + CPCmodificado + CPCvariacion + CPCtrasladado + CPCtrasladadoE + CPCmodificacion_Extraordinaria
						Presupuesto Consumido  = CPCreservado_Anterior + CPCcomprometido_anterior + CPCreservado + CPCcomprometido + CPCejecutado + CPCreservado_presupuesto 
						Presupuesto Disponible = Autorizado - Consumido
						Disponible  NETO       = Disponible - CPCnrpsPendientes
					  ======================================================== --->
				<cfset LvarRet.Autorizado		= LvarRet.Mes.Autorizado>
				<cfset LvarRet.Utilizado		= LvarRet.Mes.Utilizado>
				<cfset LvarRet.Disponible		= LvarRet.Mes.Disponible>
				<cfset LvarRet.NRPsPendientes	= LvarRet.Mes.NRPsPendientes>
				<cfset LvarRet.Neto				= LvarRet.Mes.Neto>
			<cfelse>
				<!--- ========================================================
						Presupuesto Autorizado = sum(CPCpresupuestado + CPCmodificado + CPCvariacion + CPCtrasladado + CPCtrasladadoE + CPCmodificacion_Extraordinaria)
						Presupuesto Disponible = Autorizado - sum(CPCreservado_Anterior + CPCcomprometido_anterior + CPCreservado + CPCcomprometido + CPCejecutado + CPCreservado_presupuesto)
					  ======================================================== --->
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select	sum(CPCpresupuestado) as CPCpresupuestado, 
							sum(CPCmodificado) as CPCmodificado, sum(CPCmodificacion_Extraordinaria) as CPCmodificacion_Extraordinaria, sum(CPCvariacion) as CPCvariacion, sum(CPCtrasladado) as CPCtrasladado, sum(CPCtrasladadoE) as CPCtrasladadoE, 
							sum(CPCreservado_Anterior) as CPCreservado_Anterior, sum(CPCcomprometido_Anterior) as CPCcomprometido_Anterior, 
							sum(CPCreservado_Presupuesto) as CPCreservado_Presupuesto, 
							sum(CPCreservado) as CPCreservado, sum(CPCcomprometido) as CPCcomprometido, 
							sum(CPCejecutado) as CPCejecutado,
							sum(CPCnrpsPendientes) as CPCnrpsPendientes
					  from CPresupuestoControl
					 where Ecodigo = #Arguments.Ecodigo#
					   and CPPid 	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarRet.CPPid#">
					<cfif LvarRet.CPCPcalculoControl EQ "2">
					   and CPCanoMes <=  <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarRet.CPCano*100+LvarRet.CPCmes#">
					</cfif>
					   and CPcuenta = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarRet.CPcuenta#">
					   and Ocodigo  = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarRet.Ocodigo#">
				</cfquery>
	
				<cfset LvarRet.Autorizado		= rsSQL.CPCpresupuestado + rsSQL.CPCmodificado + rsSQL.CPCmodificacion_Extraordinaria + rsSQL.CPCvariacion + rsSQL.CPCtrasladado + rsSQL.CPCtrasladadoE>
				<cfset LvarRet.Utilizado		= rsSQL.CPCreservado_Anterior + rsSQL.CPCcomprometido_Anterior
												+ rsSQL.CPCreservado_Presupuesto 
												+ rsSQL.CPCreservado + rsSQL.CPCcomprometido
												+ rsSQL.CPCejecutado>
				<cfset LvarRet.Disponible		= LvarRet.Autorizado - LvarRet.Utilizado>
				<cfset LvarRet.NRPsPendientes	= rsSQL.CPCnrpsPendientes>
				<cfset LvarRet.Neto				= LvarRet.Disponible + LvarRet.NRPsPendientes>
			</cfif>

			<!--- Mes Futuro para Acumulados: En Provisiones y Traslados, el máximo disponible es el disponible en el mes --->
			<cfif  LvarMesFuturo AND LvarRet.CPCPcalculoControl EQ "2" AND (Arguments.TipoMovimiento EQ "RP" OR trim(Arguments.TipoMovimiento) EQ "T" OR trim(Arguments.TipoMovimiento) EQ "TE")>
				<cfif LvarRet.Disponible GT LvarRet.Mes.Disponible>
					<cfset LvarRet.Disponible = LvarRet.Mes.Disponible>
				</cfif>
			</cfif>
		<cfcatch type="any">
			<cfif VerErrores>
				<cfset LvarRet.ConError	= true>
				<cfset LvarRet.MsgError	= cfcatch.Message>
			<cfelse>
				<cfrethrow>
			</cfif>
		</cfcatch>
		</cftry>
		
		<cfreturn LvarRet>
	</cffunction>

	<cffunction name="fnAutorizacionPresupuestaria" output="no" returntype="struct" access="private">
		<!--- Se debe pasar o Arguments.CFcuenta o Arguments.Ccuenta --->
		<cfargument name="ModuloOrigen" 		type="string"  required="yes">
		<cfargument name="FechaDocumento" 		type="date"    required="yes">
		<cfargument name="CPPid"				type="numeric" required="yes">
		<cfargument name="CPCano"				type="numeric" required="yes">
		<cfargument name="CPCmes"				type="numeric" required="yes">
		<cfargument name="CPcuenta" 			type="numeric" required="yes">
		<cfargument name="Ocodigo"	 			type="numeric" required="yes">
		<cfargument name="Monto"			 	type="numeric" required="yes">
		<cfargument name="TipoMovimiento" 	    type="string"  required="yes">

		<cfargument name="Conexion" 		type="string"  	required="yes">
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes">

		<cfargument name='VerErrores' 		type='boolean' 	required="true">

		<cfset LvarControl = fnCalculoDisponible (Arguments.CPPid, Arguments.CPCano, Arguments.CPCmes, Arguments.CPcuenta, Arguments.Ocodigo, Arguments.TipoMovimiento, Arguments.Conexion, Arguments.Ecodigo, Arguments.VerErrores)>

		<cfset LvarControl.TipoMovimiento = trim(Arguments.TipoMovimiento)>
		<cfset LvarControl.Monto = Arguments.Monto>
		<cfif LvarControl.TipoMovimiento EQ "A" OR LvarControl.TipoMovimiento EQ "M" OR LvarControl.TipoMovimiento EQ "ME" OR LvarControl.TipoMovimiento EQ "VC" OR LvarControl.TipoMovimiento EQ "T" OR LvarControl.TipoMovimiento EQ "TE">
			<cfset LvarControl.SignoMovimiento = +1>
		<cfelse>
			<cfset LvarControl.SignoMovimiento = -1>
		</cfif>

		<cfif LvarControl.ConError>
			<cfset LvarControl.OK = false>
			<cfreturn LvarControl>
		</cfif>
		

		<cfset LvarControl.MontoSigno = Arguments.Monto * LvarControl.SignoMovimiento>

		<!--- Movimientos Anteriores al MesAux --->
		<cfif LvarMesPasado> 	 						
			<!--- En Movimientos negativos Retroactivos se verifica que ninguna cuenta Restringida o Restrictiva genere disponible acumulado negativo al futuro --->
			<!--- Si el monto aumenta el saldo no da error aunque la cuenta ya posea un disponible acumulado negativo --->
			<cfif 	 	LvarControl.MontoSigno LT 0				<!--- Disminución ---> 
				  AND 	LvarControl.CPCPtipoControl NEQ "0"		<!--- No es control Abierto ---> 
				  AND 	LvarControl.CPCPcalculoControl EQ "2"	<!--- Es Acumulado --->
				  AND 	rsOrigenAbierto.CPOid EQ ""				<!--- No tiene Origen Abierto ---> 
			>
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select 	CPCano, CPCmes, CPCano*100+CPCmes as CPCanoMes,
							(
								select coalesce(
									     sum( s.CPCpresupuestado
											+ s.CPCmodificado
											+ s.CPCmodificacion_Extraordinaria
											+ s.CPCvariacion
											+ s.CPCtrasladado
											+ s.CPCtrasladadoE
											- s.CPCreservado_Anterior
											- s.CPCcomprometido_Anterior
											- s.CPCreservado_Presupuesto
											- s.CPCreservado	
											- s.CPCcomprometido	
											- s.CPCejecutado				
											+ s.CPCnrpsPendientes
											)
										,0) 
								  from CPresupuestoControl s
								 where s.Ecodigo = m.Ecodigo
								   and s.CPPid = m.CPPid
								   and s.CPcuenta = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarControl.CPcuenta#">
								   and s.Ocodigo  = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarControl.Ocodigo#">
								   and (   	 s.CPCano < m.CPCano OR
											(s.CPCano = m.CPCano and s.CPCmes <= m.CPCmes)
									   )
							) as DisponibleAcumulado
					  from CPmeses m
					 where Ecodigo	= #Arguments.Ecodigo#
					   and CPPid 	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarControl.CPPid#">
				</cfquery>
				<cfquery name="rsSQL" dbtype="query">
					select	CPCano, CPCmes, DisponibleAcumulado
					  from rsSQL
					 where CPCanoMes > <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarControl.CPCano*100+LvarControl.CPCmes#">
					   and DisponibleAcumulado >= 0
					   and DisponibleAcumulado + #LvarControl.MontoSigno# < 0
				</cfquery>
				<cfset LvarFaltante = LvarControl.MontoSigno - DisponibleAcumulado>
				<cfif rsSQL.recordCount GT 0>
					<cfset LvarMesError = "#rsSQL.CPCano#-#rsSQL.CPCmes#">
					<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
						select	CPformato, Oficodigo, Odescripcion
						  from CPresupuesto c, Oficinas o
						 where c.CPcuenta = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarControl.CPcuenta#">
						   and o.Ecodigo = #Arguments.Ecodigo#
						   and o.Ocodigo  = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarControl.Ocodigo#">
					</cfquery>
					<cf_errorCode	code = "51324"
									msg  = "ERROR EN CONTROL PRESUPUESTARIO: El movimiento retroactivo al '@errorDat_1@-@errorDat_2@' está generando un disponible acumulado negativo en un mes posterior: cuenta '@errorDat_3@', Oficina '@errorDat_4@=@errorDat_5@', mes '@errorDat_6@'"
									errorDat_1="#LvarControl.CPCano#"
									errorDat_2="#LvarControl.CPCmes#"
									errorDat_3="#trim(rsSQL.CPformato)#"
									errorDat_4="#trim(rsSQL.Oficodigo)#"
									errorDat_5="#rsSQL.Odescripcion#"
									errorDat_6="#LvarMesError#, faltante=#numberFormat(LvarFaltante,",9.99")#"
					>
				</cfif>
			</cfif>
		</cfif>
		<!--- FIN Movimientos Pasados --->


		<!--- 
			Un NRP se genera cuando al aplicar cada línea de un documento, existe aunque sea una línea que cumpla con todas las siguientes condiciones:
			1.	Es una Cuenta con Control Restrictivo o Restringido
			2.	El módulo origen no tiene definido Control Abierto
			3.	El Movimiento es Negativo
			4.	El Disponible Neto Generado es Negativo
			5.	El Disponible Neto Generado es menor que el Disponible Neto Original (Disponible Neto inicial de la primera línea a procesar, del mismo: Ano + Mes + Cuenta + Oficina),
				o bien, el Disponible Real Generado es Negativo
		--->

		<!--- Disponible Real Generado: se debe redondear a 2 decimales para que lo convierta a float tipo +/-0.00000000000011 --->
		<cfset LvarControl.DisponibleGenerado = round((LvarControl.Disponible + LvarControl.MontoSigno)*100)/100>
		<cfif LvarControl.MontoSigno GTE 0 OR LvarControl.DisponibleGenerado GTE 0>
			<cfset LvarControl.ExcesoGenerado = 0>
		<cfelse>
			<cfset LvarControl.ExcesoGenerado = abs(LvarControl.DisponibleGenerado)>
		</cfif>

		<!--- Disponible Neto Generado (tomando en cuenta los pendientes) --->
		<cfparam name="LvarPCG.PCGDpendiente" default="0">
		<cfset LvarControl.DisponibleNeto 				= LvarControl.DisponibleGenerado + LvarControl.NRPsPendientes 
														- LvarPCG.PCGDpendiente>
		<cfset LvarControl.DisponibleNetoOriginal 	= fnDisponibleNetoOriginal(LvarControl, Arguments.Conexion)>

		<cfif 	LvarControl.MontoSigno GTE 0 OR 
				LvarControl.DisponibleNeto GTE 0 OR 
				(LvarControl.DisponibleNeto GTE LvarControl.DisponibleNetoOriginal AND LvarControl.DisponibleGenerado GTE 0)
		>
			<cfset LvarControl.ExcesoNeto = 0>
		<cfelse>
			<cfset LvarControl.ExcesoNeto = abs(LvarControl.DisponibleNeto)>
		</cfif>
		
		<!--- OK 				= Sin Exceso, o control Abierto, u Origen Abierto --->
		<!--- ExcesoConRechazo 	= Con Exceso y no hay control/origen Abierto --->
		<cfif LvarControl.ExcesoNeto EQ 0 OR LvarControl.CPCPtipoControl EQ "0">
			<cfset LvarControl.ExcesoConRechazo = false>
		<cfelse>
			<cfset LvarControl.ExcesoConRechazo = true>
			<cfif rsOrigenAbierto.CPOid NEQ "">
				<cfset LvarExcesoConOrigenAbierto = true>
			</cfif>
		</cfif>
	
		<cfset LvarControl.OK = (NOT LvarControl.ExcesoConRechazo)>

		<cfreturn LvarControl>
	</cffunction>

	<cffunction name="fnDisponibleNetoOriginal" output="no" returntype="numeric" access="private">
		<cfargument name="Control"	 		type="struct"  required="yes">
		<cfargument name="Conexion" 		type="string"  	required="yes">

		<cfset var LvarRet = Arguments.Control>
		
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select DisponibleOriginal
			  from #Request.intSaldoOriginal#
			 where CPcuenta	= #LvarRet.CPcuenta#
			   and Ocodigo	= #LvarRet.Ocodigo#
			   and CPCano	= #LvarRet.CPCano#
			   and CPCmes	= #LvarRet.CPCmes#
		</cfquery>
		<cfif rsSQL.DisponibleOriginal EQ "">
			<cfparam name="LvarPCG.PCGDpendiente" default="0">
			<cfset LvarDisponibleNetoOriginal 	= LvarRet.Disponible + LvarRet.NRPsPendientes  
												- LvarPCG.PCGDpendiente>
			<cfquery datasource="#Arguments.Conexion#">
				insert into #Request.intSaldoOriginal#
					(CPcuenta,	Ocodigo, CPCano, CPCmes, DisponibleOriginal)
				values 
					(#LvarRet.CPcuenta#, #LvarRet.Ocodigo#, #LvarRet.CPCano#, #LvarRet.CPCmes#, #LvarDisponibleNetoOriginal#)
			</cfquery>
		<cfelse>
			<cfset LvarDisponibleNetoOriginal = rsSQL.DisponibleOriginal>
		</cfif>
		<cfreturn LvarDisponibleNetoOriginal>
	</cffunction>
	
	<cffunction name="sbAfectacionPresupuestaria" output="no" access="private">
		<!--- Se debe pasar o Arguments.CFcuenta o Arguments.Ccuenta --->
		<cfargument name="CPPid"				type="numeric" required="yes">
		<cfargument name="CPCano"				type="numeric" required="yes">
		<cfargument name="CPCmes"				type="numeric" required="yes">
		<cfargument name="CPcuenta" 			type="numeric" required="yes">
		<cfargument name="Ocodigo"	 			type="numeric" required="yes">
		<cfargument name="Monto"			 	type="numeric" required="yes">
		<cfargument name="TipoMovimiento" 	    type="string"  required="yes">

		<cfargument name="Conexion" 		type="string"  	required="yes">
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes">

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			update CPresupuestoControl
			   set 
				<cfswitch expression="#trim(Arguments.TipoMovimiento)#">
 			   		<cfcase value="A">
						CPCpresupuestado = round(CPCpresupuestado + #Arguments.Monto#, 2)
					</cfcase>
			   		<cfcase value="M">
						CPCmodificado = round(CPCmodificado + #Arguments.Monto#, 2)
					</cfcase>
			   		<cfcase value="ME">
						CPCmodificacion_Extraordinaria = round(CPCmodificacion_Extraordinaria + #Arguments.Monto#, 2)
					</cfcase>
			   		<cfcase value="VC">
						CPCvariacion = round(CPCvariacion + #Arguments.Monto#, 2)
					</cfcase>
			   		<cfcase value="T">
						CPCtrasladado = round(CPCtrasladado + #Arguments.Monto#, 2)
					</cfcase>
			   		<cfcase value="TE">
						CPCtrasladadoE = round(CPCtrasladadoE + #Arguments.Monto#, 2)
					</cfcase>
			   		<cfcase value="RA">
						CPCreservado_Anterior = round(CPCreservado_Anterior + #Arguments.Monto#, 2)
					</cfcase>
			   		<cfcase value="CA">
						CPCcomprometido_Anterior = round(CPCcomprometido_Anterior + #Arguments.Monto#, 2)
					</cfcase>
			   		<cfcase value="RP">
						CPCreservado_Presupuesto = round(CPCreservado_Presupuesto + #Arguments.Monto#, 2)
					</cfcase>
			   		<cfcase value="RC">
						CPCreservado = round(CPCreservado + #Arguments.Monto#, 2)
					</cfcase>
			   		<cfcase value="CC">
						CPCcomprometido = round(CPCcomprometido + #Arguments.Monto#, 2)
					</cfcase>
			   		<cfcase value="E">
						CPCejecutado = round(CPCejecutado + #Arguments.Monto#, 2)
					</cfcase>
			   		<cfcase value="P">
						CPCpagado = round(CPCpagado + #Arguments.Monto#, 2)
					</cfcase>
			   		<cfcase value="EJ">
						CPCejercido = round(CPCejercido + #Arguments.Monto#, 2)
					</cfcase>
			   		<cfcase value="PA">
						CPCejercido = round(CPCejercido + #Arguments.Monto#, 2)
					</cfcase>
			   		<cfdefaultcase>
						<cf_errorCode	code = "51325" msg = "ERROR EN CONTROL PRESUPUESTARIO: Se indicó un Tipo de Movimiento Presupuestario incorrecto">
					</cfdefaultcase>
				</cfswitch>
					, BMFecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			 where Ecodigo = #Arguments.Ecodigo#
			   and CPPid 	= #Arguments.CPPid#
			   and CPCano 	= #Arguments.CPCano#
			   and CPCmes 	= #Arguments.CPCmes#
			   and CPcuenta = #Arguments.CPcuenta#
			   and Ocodigo  = #Arguments.Ocodigo#
		</cfquery>
	</cffunction>
	
	<cffunction name="fnVerificaNRPanterior" output="no" returntype="boolean" access="private">
		<cfargument name="Conexion" 		type="string"  	required="yes">
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes">
		
		<cfquery name="rsNRPdetalleAct" datasource="#Arguments.Conexion#">
			select count(*) as cantidad
			  from #Request.intPresupuesto#
			 where CPcuenta is not null
			   and TipoMovimiento NOT IN ('P','EJ','PA')
		</cfquery>
		
		<cfquery name="rsNRPdetalleAnt" datasource="#Arguments.Conexion#">
			select count(*) as cantidad
			  from CPNRPdetalle ant, #Request.intPresupuesto# act
			 where ant.Ecodigo 		= #Arguments.Ecodigo#
			   and ant.CPNRPnum 	= #rsNRPanterior.CPNRPnum#
			   and ant.CPNRPDlinea	= act.NumeroLinea
			   and ant.CPPid 		= act.CPPid
			   and ant.CPCano 		= act.CPCano
			   and ant.CPCmes 		= act.CPCmes
			   and ant.CPcuenta		= act.CPcuenta
			   and ant.Ocodigo		= act.Ocodigo

			   and ant.CPNRPDtipoMov= act.TipoMovimiento
			   and ant.Mcodigo		= act.Mcodigo
			   and ant.CPNRPDmonto	= act.Monto

			   and act.TipoMovimiento NOT IN ('P','EJ','PA')
		</cfquery>

		<cfif (rsNRPdetalleAnt.Cantidad EQ rsNRPdetalleAct.Cantidad)>
			<cfquery name="rsNRPdetalleAct" datasource="#Arguments.Conexion#">
				select rtrim(<cf_dbfunction name="to_char" args="act.NumeroLinea">) as NumeroLinea
				  from #Request.intPresupuesto# act
				 where act.ExcesoConRechazo = 1
				   and act.TipoMovimiento NOT IN ('P','EJ','PA')
				 order by NumeroLinea
			</cfquery>
			
			<cfquery name="rsNRPdetalleAnt" datasource="#Arguments.Conexion#">
				select rtrim(<cf_dbfunction name="to_char" args="ant.CPNRPDlinea">) as CPNRPDlinea
				  from CPNRPdetalle ant
				 where ant.Ecodigo 	= #Arguments.Ecodigo#
				   and ant.CPNRPnum = #rsNRPanterior.CPNRPnum#
				   and ant.CPNRPDconExceso	= 1
				 order by CPNRPDlinea
			</cfquery>
			
			<cfreturn valueList(rsNRPdetalleAct.NumeroLinea) EQ valueList(rsNRPdetalleAnt.CPNRPDlinea)>
		</cfif>
		
		<cfreturn false>
	</cffunction>
	
	<cffunction name="sbCancelaPendientesNrp" output="no" access="public">
		<cfargument name="NRP" 				type="numeric"  required="yes">
		<cfargument name="Conexion" 		type="string"  	required="yes">
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes">

		<!--- Obtiene las cuentas del documento que en total consumieron Presupuesto para eliminarlos de CPCnrpsPendientes --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select d.Ecodigo, d.CPPid, d.CPCano, d.CPCmes, d.CPcuenta, d.Ocodigo, round(sum(d.CPNRPDsigno*d.CPNRPDmonto),2) as Monto
			  from CPNRPdetalle d
			 where d.Ecodigo	= #Arguments.Ecodigo#
			   and d.CPNRPnum	= #Arguments.NRP#
			 group by d.Ecodigo, d.CPPid, d.CPCano, d.CPCmes, d.CPcuenta, d.Ocodigo
			having sum(CPNRPDsigno*CPNRPDmonto) < 0
		</cfquery>
		<cfloop query="rsSQL">
			<cfquery datasource="#Arguments.Conexion#">
				update CPresupuestoControl
				   set  CPCnrpsPendientes = CPCnrpsPendientes - #rsSQL.Monto#
						, BMFecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				 where Ecodigo	= #rsSQL.Ecodigo#
				   and CPPid	= #rsSQL.CPPid#
				   and CPCano	= #rsSQL.CPCano#
				   and CPCmes	= #rsSQL.CPCmes#
				   and CPcuenta	= #rsSQL.CPcuenta#
				   and Ocodigo	= #rsSQL.Ocodigo#
			</cfquery>
		</cfloop>
	</cffunction>
	
	<cffunction name="sbAjustaNrpAprobar" output="no" access="public">
		<cfargument name="NRP" 				type="numeric"  required="yes">
		<cfargument name="Conexion" 		type="string"  	required="yes">
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes">
	
		<cfquery datasource="#Arguments.Conexion#">
			update CPNRPdetalle
			   set CPNRPDdisponibleAntesAprobar = 0.00 +
				round((
					select	sum(
								CPCpresupuestado + CPCmodificado + CPCmodificacion_Extraordinaria + CPCvariacion + CPCtrasladado + CPCtrasladadoE
								-
								(
									CPCreservado_Anterior + CPCcomprometido_Anterior +
									CPCreservado_Presupuesto +
									CPCreservado + CPCcomprometido +
									CPCejecutado
								)
							)
					  from CPresupuestoControl c
					 where c.Ecodigo	= CPNRPdetalle.Ecodigo
					   and c.CPPid		= CPNRPdetalle.CPPid
					   and c.CPCanoMes 	>= 
							case CPNRPdetalle.CPCPcalculoControl
								when 1 then CPNRPdetalle.CPCano*100 + CPNRPdetalle.CPCmes
								when 2 then 0
								when 3 then 0
							end
					   and c.CPCanoMes 	<= 
							case CPNRPdetalle.CPCPcalculoControl
								when 1 then CPNRPdetalle.CPCano*100 + CPNRPdetalle.CPCmes
								when 2 then CPNRPdetalle.CPCano*100 + CPNRPdetalle.CPCmes
								when 3 then 999901
							end
					   and c.CPcuenta 	= CPNRPdetalle.CPcuenta
					   and c.Ocodigo 	= CPNRPdetalle.Ocodigo
				)
				+
				(
					select	coalesce(sum(CPNRPDsigno*CPNRPDmonto),0)
					  from	CPNRPdetalle d
					 where	d.Ecodigo		= CPNRPdetalle.Ecodigo
					   and 	d.CPNRPnum		= CPNRPdetalle.CPNRPnum
					   and 	d.CPcuenta 	= CPNRPdetalle.CPcuenta
					   and 	d.Ocodigo 	= CPNRPdetalle.Ocodigo
					   and 	d.CPCano*100+d.CPCmes 	>= 
							case CPNRPdetalle.CPCPcalculoControl
								when 1 then CPNRPdetalle.CPCano*100 + CPNRPdetalle.CPCmes
								when 2 then 0
								when 3 then 0
							end
					   and 	d.CPCano*100+d.CPCmes 	<= 
							case CPNRPdetalle.CPCPcalculoControl
								when 1 then CPNRPdetalle.CPCano*100 + CPNRPdetalle.CPCmes
								when 2 then CPNRPdetalle.CPCano*100 + CPNRPdetalle.CPCmes
								when 3 then 999901
							end

					   and 	
					   		(
					   			 d.CPNRPDsigno*d.CPNRPDmonto	> CPNRPdetalle.CPNRPDsigno*CPNRPdetalle.CPNRPDmonto
						   	OR 
								 d.CPNRPDsigno*d.CPNRPDmonto	= CPNRPdetalle.CPNRPDsigno*CPNRPdetalle.CPNRPDmonto
					   		 and d.CPNRPDlinea					< CPNRPdetalle.CPNRPDlinea
							)
				), 2)
				 , CPNRPDpendientesAntesAprobar =
				round((
					select sum(CPCnrpsPendientes)
					  from CPresupuestoControl c
					 where c.Ecodigo	= CPNRPdetalle.Ecodigo
					   and c.CPPid		= CPNRPdetalle.CPPid
					   and c.CPCanoMes 	>= 
							case CPNRPdetalle.CPCPcalculoControl
								when 1 then CPNRPdetalle.CPCano*100 + CPNRPdetalle.CPCmes
								when 2 then 0
								when 3 then 0
							end
					   and c.CPCanoMes 	<= 
							case CPNRPdetalle.CPCPcalculoControl
								when 1 then CPNRPdetalle.CPCano*100 + CPNRPdetalle.CPCmes
								when 2 then CPNRPdetalle.CPCano*100 + CPNRPdetalle.CPCmes
								when 3 then 999901
							end
					   and c.CPcuenta 	= CPNRPdetalle.CPcuenta
					   and c.Ocodigo 	= CPNRPdetalle.Ocodigo
				), 2)
				 , CPNRPDextraordinAntesAprobar =
				round((
					select sum(CPCmodificacion_Extraordinaria)
					  from CPresupuestoControl c
					 where c.Ecodigo	= CPNRPdetalle.Ecodigo
					   and c.CPPid		= CPNRPdetalle.CPPid
					   and c.CPCanoMes 	>= 
							case CPNRPdetalle.CPCPcalculoControl
								when 1 then CPNRPdetalle.CPCano*100 + CPNRPdetalle.CPCmes
								when 2 then 0
								when 3 then 0
							end
					   and c.CPCanoMes 	<= 
							case CPNRPdetalle.CPCPcalculoControl
								when 1 then CPNRPdetalle.CPCano*100 + CPNRPdetalle.CPCmes
								when 2 then CPNRPdetalle.CPCano*100 + CPNRPdetalle.CPCmes
								when 3 then 999901
							end
					   and c.CPcuenta 	= CPNRPdetalle.CPcuenta
					   and c.Ocodigo 	= CPNRPdetalle.Ocodigo
				), 2)
			where	Ecodigo = #Arguments.Ecodigo# 
			  and 	CPNRPnum = #Arguments.NRP#
			  and	CPcuenta is not null
		</cfquery>
	</cffunction>
	
	<cffunction name="sbAgregaPendientesNrp" output="no" access="public">
		<cfargument name="NRP" 				type="numeric"  required="yes">
		<cfargument name="Conexion" 		type="string"  	required="yes">
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes">

		<!--- Obtiene las cuentas del documento que en total consumieron Presupuesto para acumularlos de CPCnrpsPendientes --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select d.Ecodigo, d.CPPid, d.CPCano, d.CPCmes, d.CPcuenta, d.Ocodigo, round(sum(d.CPNRPDsigno*d.CPNRPDmonto),2) as Monto
			  from CPNRPdetalle d
			 where d.Ecodigo	= #Arguments.Ecodigo#
			   and d.CPNRPnum	= #Arguments.NRP#
			 group by d.Ecodigo, d.CPPid, d.CPCano, d.CPCmes, d.CPcuenta, d.Ocodigo
			having sum(CPNRPDsigno*CPNRPDmonto) < 0
		</cfquery>
		<cfloop query="rsSQL">
			<cfquery datasource="#Arguments.Conexion#">
				update CPresupuestoControl
				   set  CPCnrpsPendientes = CPCnrpsPendientes + #rsSQL.Monto#
						, BMFecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				 where Ecodigo	= #rsSQL.Ecodigo#
				   and CPPid	= #rsSQL.CPPid#
				   and CPCano	= #rsSQL.CPCano#
				   and CPCmes	= #rsSQL.CPCmes#
				   and CPcuenta	= #rsSQL.CPcuenta#
				   and Ocodigo	= #rsSQL.Ocodigo#
			</cfquery>
		</cfloop>
	</cffunction>
	
	<cffunction name="sbCancelaNrpAnterior" output="no" access="private">
		<cfargument name="TipoCancelacion" 	type="numeric"	required="yes">
		<cfargument name="Conexion" 		type="string"  	required="yes">
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes">

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			update CPNRP
			   set  CPNRPtipoCancela = #TipoCancelacion#
			   		, CPNRPfechaCancela = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					, UsucodigoCancela = #GvarUsucodigo#
			 where Ecodigo  = #Arguments.Ecodigo#
			   and CPNRPnum = #rsNRPanterior.CPNRPnum#
		</cfquery>
		<cfset rsNRPanterior.CPNRPnum = "">
	</cffunction>

	<cffunction name="fnGeneraNAPexceso" output="no" access="private" returntype="numeric">
		<cfargument name="Conexion" 		type="string"  	required="yes">
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes">

		<cfset var LvarNAP = -1>

		<!--- Determina si Existen Rechazos que requieren Aprobacion de Excesos (ExcesoGenerado > 0) --->
		<cfquery name="rsExcesos" datasource="#Arguments.Conexion#">
			select *
			  from #Request.intPresupuesto# e
			 where e.ExcesoGenerado > 0
			   and e.ExcesoConRechazo = 1
		</cfquery>

		<!--- Recordar que el Rechazo presupuestario depende del ExcesoNeto --->
		<!--- pero el Exceso a Aprobar depende del ExcesoGenerado --->
		<cfif rsExcesos.recordCount GT 0>
			<cf_dbtemp name="CP_Excesos_V02" returnvariable="Excesos" datasource="#Arguments.Conexion#">
				<cf_dbtempcol name="NumeroLinea" identity="yes"	type="numeric" mandatory="yes">
				<cf_dbtempcol name="CPCano"    			type="int"		mandatory="yes">
				<cf_dbtempcol name="CPCmes"    			type="int"		mandatory="yes">
				<cf_dbtempcol name="CPcuenta"			type="numeric"	mandatory="yes">
				<cf_dbtempcol name="Ocodigo"			type="numeric"	mandatory="yes">
				<cf_dbtempcol name="TipoControl"		type="int"		mandatory="yes">
				<cf_dbtempcol name="CalculoControl"		type="int"		mandatory="yes">
				<cf_dbtempcol name="UltimoDisponible" 	type="money"	mandatory="yes">
				<cf_dbtempcol name="TotalMontos"	 	type="money"	mandatory="yes">
				<cf_dbtempcol name="UltimoExceso"		type="money"	mandatory="yes">
			</cf_dbtemp>
			
			<!--- Calcula los Excesos a Aprobar con todos los movimientos de las CPCano+CPCmes+CPcuenta+Ocodigo con rechazos que requieren aprobar Excesos (ExcesoGenerado > 0) --->
			<!--- El DisponibleAnterior = DisponibleActual - sum(Signo*Monto) (de todos lo movimientos aunque no tengan rechazo) --->
			<!--- El ExcesoAprobar = sum(ExcesoGenerado) --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #Excesos#
					(CPCano, CPCmes, CPcuenta, Ocodigo, TipoControl, CalculoControl, 
						UltimoDisponible, TotalMontos, UltimoExceso)
				select d.CPCano, d.CPCmes, d.CPcuenta, d.Ocodigo, d.TipoControl, d.CalculoControl,
						min(d.DisponibleGenerado),
						sum(d.SignoMovimiento*d.Monto),
						max(d.ExcesoGenerado)
				  from #Request.intPresupuesto# d
				 where exists
						(
							select 1
							  from #Request.intPresupuesto# e
							 where e.CPCano		= d.CPCano
							   and e.CPCmes		= d.CPCmes
							   and e.CPcuenta	= d.CPcuenta
							   and e.Ocodigo	= d.Ocodigo
							   and e.ExcesoGenerado > 0
							   and e.ExcesoConRechazo = 1
						)
				group by d.CPCano, d.CPCmes, d.CPcuenta, d.Ocodigo, d.TipoControl, d.CalculoControl
			</cfquery>

			<cfquery name="rsMonedaEmpresa" datasource="#Arguments.Conexion#">
				select Mcodigo
				  from Empresas
				 where Ecodigo = #Arguments.Ecodigo#
			</cfquery>

			<!--- Genera el NAP de Modificacion Extraordinaria --->
			<cfset LvarNAP = fnSiguienteCPNAPnum (Arguments.Conexion, Arguments.Ecodigo)>
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				insert into CPNAP
						(Ecodigo, CPNAPnum, 
						 CPPid, CPCano, CPCmes, CPNAPfecha, 
						 EcodigoOri, CPNAPmoduloOri, CPNAPdocumentoOri, CPNAPreferenciaOri, CPNAPfechaOri,
						 UsucodigoOri, UsucodigoAutoriza, CPOid
						 )
				values 	(#Arguments.Ecodigo#, #LvarNAP#, 
						 #LvarCPPid#, #rsExcesos.AnoDocumento#, #rsExcesos.MesDocumento#, 
						 <cfqueryparam cfsqltype="cf_sql_timestamp"	value="#now()#">,

						 <cfqueryparam cfsqltype="cf_sql_integer" 	value="#rsExcesos.EcodigoOrigen#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsExcesos.ModuloOrigen#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#trim(rsExcesos.NumeroDocumento)#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsExcesos.NumeroReferencia#">,
						 <cfqueryparam cfsqltype="cf_sql_date" 		value="#rsExcesos.FechaDocumento#">,
						 #GvarUsucodigo#, 
						<cfif LvarExcesoConOrigenAbierto>
							#rsOrigenAbierto.Usucodigo#, #rsOrigenAbierto.CPOid#
						<cfelse>
							 #rsNRPanterior.UsucodigoAutoriza#, null
						</cfif>
						)
			</cfquery>
	
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				insert into CPNAPdetalle
						(Ecodigo, CPNAPnum, CPNAPDlinea, 
						 CPPid, CPCano, CPCmes, CPcuenta, Ocodigo,
						 CPNAPDtipoMov, 
						 Mcodigo, 
						 CPNAPDsigno, CPNAPDmontoOri, CPNAPDtipoCambio, CPNAPDmonto, 
						 CPCPtipoControl, CPCPcalculoControl,
						 CPNAPDdisponibleAntes, 
						 CPNAPDconExceso, 
						 CPNAPDutilizado
						 )
				select 	#Arguments.Ecodigo#, #LvarNAP#, NumeroLinea,
						#LvarCPPid#, CPCano, CPCmes, CPcuenta, Ocodigo,
						'ME',
						#rsMonedaEmpresa.Mcodigo#, 
						+1, UltimoExceso, 1, UltimoExceso, 
						TipoControl, CalculoControl,
						UltimoDisponible - TotalMontos, 
						0, 
						0
				  from #Excesos#
			</cfquery>

			<!--- Ejecuta la Afectación Presupuestaria del NAP ME --->
			<cfquery datasource="#Arguments.Conexion#">
				update CPresupuestoControl
				   set 	CPCmodificacion_Extraordinaria = CPCmodificacion_Extraordinaria + 
						(
							select UltimoExceso
							  from #Excesos# e
							 where e.CPCano		= CPresupuestoControl.CPCano
							   and e.CPCmes		= CPresupuestoControl.CPCmes
							   and e.CPcuenta	= CPresupuestoControl.CPcuenta
							   and e.Ocodigo	= CPresupuestoControl.Ocodigo
						)
						, BMFecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				 where CPresupuestoControl.Ecodigo 	= #Arguments.Ecodigo#
				   and CPresupuestoControl.CPPid 	= #LvarCPPid#
				   and exists
						(
							select 1
							  from #Excesos# e
							 where e.CPCano		= CPresupuestoControl.CPCano
							   and e.CPCmes		= CPresupuestoControl.CPCmes
							   and e.CPcuenta	= CPresupuestoControl.CPcuenta
							   and e.Ocodigo	= CPresupuestoControl.Ocodigo
						)
			</cfquery>

			<!--- Actualiza el Disponible Anterior del NAP actual con la Afectación Anterior del NAP ME --->
			<cfquery datasource="#Arguments.Conexion#">
				update #Request.intPresupuesto#
				   set 	DisponibleAnterior = DisponibleAnterior +
						(
							select UltimoExceso
							  from #Excesos# e
							 where e.CPCano		= #Request.intPresupuesto#.CPCano
							   and e.CPCmes		= #Request.intPresupuesto#.CPCmes
							   and e.CPcuenta	= #Request.intPresupuesto#.CPcuenta
							   and e.Ocodigo	= #Request.intPresupuesto#.Ocodigo
						)
				 where exists
						(
							select 1
							  from #Excesos# e
							 where e.CPCano		= #Request.intPresupuesto#.CPCano
							   and e.CPCmes		= #Request.intPresupuesto#.CPCmes
							   and e.CPcuenta	= #Request.intPresupuesto#.CPcuenta
							   and e.Ocodigo	= #Request.intPresupuesto#.Ocodigo
						)
			</cfquery>
		</cfif>

		<cfreturn LvarNAP>
	</cffunction>

	<cffunction name="fnGeneraNAP" output="no" returntype="numeric" access="public">
		<cfargument name='EcodigoOrigen'	type='numeric' 	required='true'>
		<cfargument name='ModuloOrigen' 	type="string" 	required='true'>		
		<cfargument name='NumeroDocumento' 	type='string' 	required='true'>
		<cfargument name='NumeroReferencia' type='string' 	required='true'>
		<cfargument name='FechaDocumento' 	type='date'   	required='true'>
		<cfargument name='AnoDocumento'	 	type='numeric' 	required='true'>
		<cfargument name='MesDocumento'	 	type='numeric' 	required='true'>
		<cfargument name='NAPreversado'	 	type='numeric' 	required='true'>

		<cfargument name="Conexion" 		type="string"  	required="yes">
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes">


		<cfargument name="LvarCPPid" 		type="numeric" 	required="no">
		
		<cfif not isdefined("LvarCPPid")>
			<cfset LvarCPPid = Arguments.LvarCPPid>
		</cfif>

		<cfif not isdefined("GvarUsucodigo")>
			<cfset GvarUsucodigo = session.Usucodigo>
		</cfif>

		<!--- Se Verifica si existe un NAP para el documento --->
		<cfparam name="LvarNAPexceso" default="-1">
		<cfquery name="rsNAP" datasource="#Arguments.Conexion#">
			select CPNAPnum
			  from CPNAP
			 where Ecodigo 				= #Arguments.Ecodigo#
			   and EcodigoOri		 	= #Arguments.EcodigoOrigen#
			   and CPNAPmoduloOri 		= '#Arguments.ModuloOrigen#'
			   and CPNAPdocumentoOri	= '#Arguments.NumeroDocumento#'
			   and CPNAPreferenciaOri	= '#Arguments.NumeroReferencia#'
			   
			   and CPNAPnum<>#LvarNAPexceso#
		</cfquery>

		<cfif rsNAP.recordCount GT 0>
			<cf_errorCode	code = "51295"
							msg  = "ERROR EN CONTROL PRESUPUESTARIO: El documento ya fue aprobado y aplicado con el NAP=@errorDat_1@"
							errorDat_1="#rsNAP.CPNAPnum#"
			>
		</cfif>

		<!--- Genera el NAP del Documento Origen en la Empresa solicitante --->
		<cfset LvarNAP = fnSiguienteCPNAPnum (Arguments.Conexion, Arguments.Ecodigo)>
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			insert into CPNAP
					(Ecodigo, CPNAPnum, 
					 CPPid, CPCano, CPCmes, CPNAPfecha, 
					 EcodigoOri, CPNAPmoduloOri, CPNAPdocumentoOri, CPNAPreferenciaOri, CPNAPfechaOri,
					 UsucodigoOri, UsucodigoAutoriza, CPOid, CPNAPnumReversado
					 )
			values 	(#Arguments.Ecodigo#, #LvarNAP#, 
					 #LvarCPPid#, #Arguments.AnoDocumento#, #Arguments.MesDocumento#, 
					 <cfqueryparam cfsqltype="cf_sql_timestamp"	value="#now()#">,

					 #Arguments.EcodigoOrigen#,
					 '#Arguments.ModuloOrigen#',
					 '#trim(Arguments.NumeroDocumento)#',
					 '#Arguments.NumeroReferencia#',
					 <cfqueryparam cfsqltype="cf_sql_date" 		value="#Arguments.FechaDocumento#">,
					 #GvarUsucodigo#, 
					<cfif isdefined("LvarExcesoConOrigenAbierto") and LvarExcesoConOrigenAbierto>
					 	#rsOrigenAbierto.Usucodigo#, #rsOrigenAbierto.CPOid#,
					<cfelse>
						 <cfif not isdefined("rsNRPanterior") or rsNRPanterior.UsucodigoAutoriza EQ "">#GvarUsucodigo#<cfelse>#rsNRPanterior.UsucodigoAutoriza#</cfif>, null,
					</cfif>
					<cfif isdefined("LvarReversion") and LvarReversion>
						 #Arguments.NAPreversado#
					<cfelse>
						null
					</cfif>
					)
		</cfquery>

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			insert into CPNAPdetalle
					(Ecodigo, CPNAPnum, CPNAPDlinea, 
					 CFcuenta, CPPid, CPCano, CPCmes, CPcuenta, Ocodigo,
					 CPNAPDtipoMov, 
					 Mcodigo, CPNAPDmontoOri, CPNAPDtipoCambio, CPNAPDmonto, 
					 CPNAPDsigno,
					 CPCPtipoControl, CPCPcalculoControl,
					 CPNAPDdisponibleAntes, 
					 CPNAPDconExceso, 
					 CPNAPDutilizado,
					 CPNAPnumRef, CPNAPDlineaRef,

	 				 PCGDid, PCGDcantidad, PCGDcantidadAntes, PCGDdisponibleAntes
					 )
			select 	#Arguments.Ecodigo#, #LvarNAP#, NumeroLinea,
					CFcuenta, CPPid, CPCano, CPCmes, CPcuenta, Ocodigo,
					rtrim(TipoMovimiento),
					Mcodigo, MontoOrigen, TipoCambio, Monto, 
					SignoMovimiento,
					TipoControl, CalculoControl,
					DisponibleAnterior, 
					coalesce(ExcesoConRechazo,0), 
					0,
					NAPreferencia, LINreferencia,
					
	 				PCGDid, PCGDcantidad, PCGDcantidadAntes, PCGDdisponibleAntes
			  from #Request.intPresupuesto# 
			 where CPcuenta IS NOT NULL
			   and TipoMovimiento NOT in ('P','EJ','PA')
		</cfquery>
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			insert into CPNAPdetallePagado
					(Ecodigo, CPNAPnum,
					 CPNAPDPdocumento,
					 CPCano,CPCmes,CPcuenta, Ocodigo,
					 CPNAPDPtipoMov, 
					 Mcodigo, CPNAPDPmontoOri, CPNAPDPtipoCambio, CPNAPDPmonto, 
					 CPNAPDPconExceso
					 )
			select 	#Arguments.Ecodigo#, #LvarNAP#,
					DocumentoPagado,
					CPCano,CPCmes,CPcuenta, Ocodigo,
					rtrim(TipoMovimiento),
					Mcodigo, MontoOrigen, TipoCambio, Monto, 
					coalesce(ExcesoConRechazo,0)
			  from #Request.intPresupuesto# 
			 where CPcuenta IS NOT NULL
			   and TipoMovimiento in ('P','EJ','PA')
		</cfquery>
		<cfif isdefined("rsNRPanterior.CPNRPnum") AND rsNRPanterior.CPNRPnum NEQ "">
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				update CPNRP
				   set CPNAPnum = #LvarNAP#
				 where Ecodigo  = #Arguments.Ecodigo#
				   and CPNRPnum = #rsNRPanterior.CPNRPnum#
			</cfquery>
		</cfif>
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			update #Request.intPresupuesto#
			   set NAP = #LvarNAP#, NRP = 0
		</cfquery>

		<cfif LvarNAPexceso GT 0>
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				update CPNAP
				   set CPNAPnumModificado = #LvarNAP#
				 where Ecodigo	= #Arguments.Ecodigo#
				   and CPNAPnum	= #LvarNAPexceso#
			</cfquery>
		</cfif>
		<cfreturn LvarNAP>
	</cffunction>

	<cffunction name="fnGeneraNRP" output="no" returntype="numeric" access="private">
		<cfargument name='EcodigoOrigen'	type='numeric' 	required='true'>
		<cfargument name='ModuloOrigen' 	type="string" 	required='true'>		
		<cfargument name='NumeroDocumento' 	type='string' 	required='true'>
		<cfargument name='NumeroReferencia' type='string' 	required='true'>
		<cfargument name='FechaDocumento' 	type='date'   	required='true'>
		<cfargument name='AnoDocumento'	 	type='numeric' 	required='true'>
		<cfargument name='MesDocumento'	 	type='numeric' 	required='true'>

		<cfargument name="Conexion" 		type="string"  	required="yes">
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes">

		<!--- Regenera las formulaciones dinámicas, borradas por rollback --->
		<cfloop index="LvarIdx" from="1" to="#arrayLen(LvarCrearFrm_NRP)#">
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select count(1) as cantidad
				  from CPCuentaPeriodo
				 where Ecodigo	= #Arguments.Ecodigo#
				   and CPPid	= #LvarCPPid#
				   and CPcuenta = #LvarCrearFrm_NRP[LvarIdx].CPcuenta#
			</cfquery>
			<cfif rsSQL.cantidad EQ 0>
				<cfquery datasource="#Arguments.Conexion#">
					insert into CPCuentaPeriodo
						(
							Ecodigo, CPPid, CPcuenta, 
							CPCPtipoControl, CPCPcalculoControl
						)
					values
						(
							#Arguments.Ecodigo#,
							#LvarCPPid#,
							#LvarCrearFrm_NRP[LvarIdx].CPcuenta#,
							0, #LvarCrearFrm_NRP[LvarIdx].CPCPcalculoControl#
						)
				</cfquery>
			</cfif>
			<cfquery datasource="#Arguments.Conexion#">
				insert into CPresupuestoControl
					(
						Ecodigo, CPPid, CPCano, CPCmes, CPcuenta, Ocodigo, CPCanoMes
					)
				select	Ecodigo, CPPid, CPCano, CPCmes, #LvarCrearFrm_NRP[LvarIdx].CPcuenta#, #LvarCrearFrm_NRP[LvarIdx].Ocodigo#, CPCano*100+CPCmes
				  from CPmeses
				 where Ecodigo	= #Arguments.Ecodigo#
				   and CPPid	= #LvarCPPid#
			</cfquery>
		</cfloop>
		
		<cflock name="sigNRP_#Arguments.Ecodigo#" timeout="20" throwontimeout="yes" type="exclusive">
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select coalesce(max(CPNRPnum), 0) + 1 as NRP
				  from CPNRP
				 where Ecodigo = #Arguments.Ecodigo#
			</cfquery>
			<cfset LvarNRP = rsSQL.NRP>
			
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				insert into CPNRP
						(Ecodigo, CPNRPnum, 
						 CPPid, CPCano, CPCmes, CPNRPfecha, 
						 EcodigoOri, CPNRPmoduloOri, CPNRPdocumentoOri, CPNRPreferenciaOri, CPNRPfechaOri,
						 UsucodigoOri, 
						 UsucodigoAutoriza, CPNAPnum)
				values 	(#Arguments.Ecodigo#, #LvarNRP#, 
						 #LvarCPPid#, #Arguments.AnoDocumento#, #Arguments.MesDocumento#, 
						 <cfqueryparam cfsqltype="cf_sql_timestamp"	value="#now()#">,
	
						 #Arguments.EcodigoOrigen#,
						 '#Arguments.ModuloOrigen#',
						 '#Arguments.NumeroDocumento#',
						 '#Arguments.NumeroReferencia#',
						 <cfqueryparam cfsqltype="cf_sql_date" 		value="#Arguments.FechaDocumento#">,
						 #GvarUsucodigo#, 
						 null, null
						)
			</cfquery>
			
			<cfloop query="rsPRES">
				<cfif rsPRES.CPcuenta NEQ "" AND rsPRES.trim(rsPRES.TipoMovimiento) NEQ "P" AND trim(rsPRES.TipoMovimiento) NEQ "EJ" AND trim(rsPRES.TipoMovimiento) NEQ "PA">
					<cfset LvarCFnull = true>
					<cfif rsPRES.CFcuenta NEQ "">
						<cfquery name="rsCFcuenta" datasource="#Arguments.Conexion#">
							select CFcuenta
							  from CFinanciera
							 where CFcuenta = #rsPRES.CFcuenta#
						</cfquery>
						<cfset LvarCFnull = (rsCFcuenta.CFcuenta EQ "")>
					</cfif>
					<cfquery datasource="#Arguments.Conexion#">
						insert into CPNRPdetalle
								(Ecodigo, CPNRPnum, CPNRPDlinea, 
								 CFcuenta, CPPid, CPCano, CPCmes, CPcuenta, Ocodigo,
								 CPNRPDtipoMov, 
								 Mcodigo, CPNRPDmontoOri, CPNRPDtipoCambio, CPNRPDmonto, CPNRPDsigno,
								 CPCPtipoControl, CPCPcalculoControl,
								 CPNRPDdisponibleAntes, CPNRPDpendientesAntes, 
								 CPNRPDconExceso,
								 CPNAPnumRef, CPNAPDlineaRef,
			 	 				
								 PCGDid, PCGDcantidad, PCGDcantidadAntes, PCGDdisponibleAntes
								)
						values	(
								#Arguments.Ecodigo#, #LvarNRP#, #rsPRES.NumeroLinea#,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPRES.CFcuenta#" null="#LvarCFnull#">,
								#rsPRES.CPPid#, #rsPRES.CPCano#, #rsPRES.CPCmes#, #rsPRES.CPcuenta#, #rsPRES.Ocodigo#,
								'#trim(rsPRES.TipoMovimiento)#',
								#rsPRES.Mcodigo#, #rsPRES.MontoOrigen#, #rsPRES.TipoCambio#, #rsPRES.Monto#, #rsPRES.SignoMovimiento#, 
								#rsPRES.TipoControl#, #rsPRES.CalculoControl#,
								#rsPRES.DisponibleAnterior#, #rsPRES.NRPsPendientes#, 
								<cfif rsPRES.ExcesoConRechazo EQ "0">0<cfelse>1</cfif>, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPRES.NAPreferencia#" null="#rsPRES.NAPreferencia EQ ''#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPRES.LINreferencia#" null="#rsPRES.LINreferencia EQ ''#">,
								
								<cfif LvarPCG.PCGDid EQ "">NULL<cfelse>#LvarPCG.PCGDid#</cfif>,
			 	 				#LvarPCG.PCGDcantidad#, #LvarPCG.CantidadAntes#, #LvarPCG.DisponibleAntes#
								)
					</cfquery>
				</cfif>	
			</cfloop>
		</cflock>

		<cfreturn LvarNRP>
	</cffunction>
    
	<cffunction name="sbGeneraRsIntPresupuesto" output="no" access="private">
		<cfargument name='NAP' 			type="string" 	required='true'>		
		<cfargument name='NRP' 			type="string" 	required='true'>		

		<cfargument name="Conexion" 		type="string"  	required="yes">
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes">
	
		<cfquery name="Request.rsIntPresupuesto" dbtype="query">
			select	
					EcodigoDst,
					EcodigoOrigen,
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					#Arguments.NAP# as NAP,
					#Arguments.NRP# as NRP,

					NumeroLinea,
					CFcuenta,
					Ccuenta,
					CuentaFinanciera,
					CuentaPresupuesto,
					Mcodigo, CodigoMoneda,
					CodigoMoneda,
					MontoOrigen,
					TipoCambio,
					Monto,
					NAPreferencia,
					LINreferencia,

					TipoMovimiento,
					CPPid,
					CPCano,
					CPCmes,
					CPcuenta,
					Ocodigo, CodigoOficina,
					TipoControl,
					CalculoControl,
					SignoMovimiento,
					DisponibleAnterior,

					DisponibleGenerado,
					ExcesoGenerado,

					NRPsPendientes,
					DisponibleNeto
					ExcesoNeto,

					ExcesoConRechazo,
					
					ConError,
					MSG,
					
					CENTRO_FUNCIONAL,
					CONCEPTO_GASTO
			  from rsPRES
			 where CPcuenta is not null
		</cfquery>
	</cffunction>
	
	<cffunction name="fnObtenerMcodigo" output="no" returntype="string" access="private">
		<!--- Se debe pasar o Arguments.Mcodigo o Arguments.CodigoMoneda --->
		<cfargument name="Mcodigo" 		type="string"  default="">  
		<cfargument name="CodigoMoneda"	type="string"  default="">

		<cfargument name="Conexion" 		type="string"  	required="yes">
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes">

		<cfif Arguments.Mcodigo EQ "" AND Arguments.CodigoMoneda EQ "">
			<cf_errorCode	code = "51326" msg = "The parameter [Mcodigo] OR [CodigoMoneda] to function PRES_Presupuesto.fnObtenerMcodigo is required but was not passed in or passed in blank.">
		</cfif>
		
		<cfif Arguments.Mcodigo NEQ "">
			<!---
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select Mcodigo
				  from Monedas
				 where Ecodigo = #Arguments.Ecodigo#
				   and Mcodigo = #Arguments.Mcodigo#
			</cfquery>
			<cfif rsSQL.recordCount EQ 0>
				<cf_errorCode	code = "51327"
								msg  = "ERROR EN CONTROL PRESUPUESTARIO: Se indicó un Codigo de Moneda id='[@errorDat_1@]' incorrecto"
								errorDat_1="#Arguments.Mcodigo#"
				>
			</cfif>
			--->
 			<cfreturn "#Arguments.Mcodigo#">
		<cfelse>
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select Mcodigo
				  from Monedas
				 where Ecodigo = #Arguments.Ecodigo#
				   and Miso4217 = '#Arguments.CodigoMoneda#'
			</cfquery>
			<cfif rsSQL.recordCount EQ 0>
				<cf_errorCode	code = "51328"
								msg  = "ERROR EN CONTROL PRESUPUESTARIO: Se indicó una Moneda Codigo='@errorDat_1@' incorrecta"
								errorDat_1="#Arguments.CodigoMoneda#"
				>
			</cfif>
			<cfreturn rsSQL.Mcodigo>
		</cfif>
	</cffunction>			

	<cffunction name="fnObtenerOficina" output="no" returntype="query" access="private">
		<!--- Se debe pasar o Arguments.Mcodigo o Arguments.CodigoMoneda --->
		<cfargument name="Ocodigo" 			type="string"  default="">  
		<cfargument name="CodigoOficina"	type="string"  default="">

		<cfargument name="Conexion" 		type="string"  	required="yes">
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes">

		<cfif Arguments.Ocodigo EQ "" AND Arguments.CodigoOficina EQ "">
			<cf_errorCode	code = "51329" msg = "The parameter [CodigoOficina] OR [CodigoOficina] to function PRES_Presupuesto.fnObtenerOficina is required but was not passed in or passed in blank.">
		</cfif>
		
		<cfif Arguments.Ocodigo NEQ "">
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select Ocodigo, Oficodigo, Odescripcion
				  from Oficinas
				 where Ecodigo = #Arguments.Ecodigo#
				   and Ocodigo = #Arguments.Ocodigo#
			</cfquery>
			<cfif rsSQL.recordCount EQ 0>
				<cf_errorCode	code = "51330"
								msg  = "ERROR EN CONTROL PRESUPUESTARIO: Se indicó un Codigo de Oficina id='[@errorDat_1@]' incorrecto"
								errorDat_1="#Arguments.Ocodigo#"
				>
			</cfif>
		<cfelse>
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select Ocodigo, Oficodigo, Odescripcion
				  from Oficinas
				 where Ecodigo = #Arguments.Ecodigo#
				   and Oficodigo = '#Arguments.CodigoOficina#'
			</cfquery>
			<cfif rsSQL.recordCount EQ 0>
				<cf_errorCode	code = "51331"
								msg  = "ERROR EN CONTROL PRESUPUESTARIO: Se indicó una Oficina Codigo='@errorDat_1@' incorrecta"
								errorDat_1="#Arguments.CodigoOficina#"
				>
			</cfif>
		</cfif>
		<cfreturn rsSQL>
	</cffunction>			

	<cffunction name="fnObtenerCuentas" output="no" returntype="struct" access="private">
		<!--- Se debe pasar o Arguments.CFcuenta o Arguments.Ccuenta --->
		<cfargument name="CFcuenta" 		type="string"  required="true">
		<cfargument name="Ccuenta"			type="string"  required="true">
		<cfargument name="CPcuenta"			type="string"  required="true">
		<cfargument name="CFformato"		type="string"  required="true">

		<cfargument name="Conexion" 		type="string"  	required="true">
		<cfargument name="Ecodigo" 			type="numeric" 	required="true">

		<cfargument name="CPCano"			type="string"  	required="no" default="">
		<cfargument name="CPCmes"			type="string"  	required="no" default="">
		<cfargument name="VerificarInactiva" type="string"  required="no" default="yes">

		<cfif Arguments.CFcuenta EQ "" AND Arguments.Ccuenta EQ "" AND Arguments.CPcuenta EQ "" AND Arguments.CFformato EQ "">
			<cf_errorCode	code = "51332" msg = "The parameter [CFcuenta] OR [Ccuenta] OR [CPcuenta] OR [CFformato] to function PRES_Presupuesto.fnObtenerCuentas is required but was not passed in.">
		</cfif>

		<cfif Arguments.CFcuenta EQ "">
			<cfif Arguments.CPcuenta NEQ "">
				<!--- Es un movimiento directo a las Cuentas de Presupuesto --->
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select Cmayor, CPcuenta, CPformato
					  from CPresupuesto
					 where CPcuenta = #Arguments.CPcuenta#
					   and Ecodigo = #Arguments.Ecodigo#
				</cfquery>
				<cfif rsSQL.recordCount EQ 0>
					<cf_errorCode	code = "51333"
									msg  = "ERROR EN CONTROL PRESUPUESTARIO: Cuenta de Presupuesto id='[@errorDat_1@]' no Existe"
									errorDat_1="#Arguments.CPcuenta#"
					>
				</cfif>
				<cfset LvarCtas.Cmayor   	= rsSQL.Cmayor>
				<cfset LvarCtas.CPcuenta 	= rsSQL.CPcuenta>
				<cfset LvarCtas.CPformato  	= rsSQL.CPformato>
				<cfset LvarCtas.Ccuenta  = "">
				<cfset LvarCtas.CFcuenta = "">
				<cfset LvarCtas.CFformato  = "">
				<cfif Arguments.VerificarInactiva>
					<cfset fnVerificarCuentaInactiva(LvarCtas.CPcuenta, Arguments.CPCano, Arguments.CPCmes, Arguments.Conexion)>
				</cfif>
				<cfreturn LvarCtas>
			<cfelseif Arguments.Ccuenta NEQ "">
				<!--- Se utiliza Ccuenta para guardar compatibilidad  con 
				      movimientos viejos que no han sido actualizados con CFcuenta --->
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select min(CFcuenta) as CFcuenta
					  from CFinanciera
					 where Ccuenta = #Arguments.Ccuenta#
					   and Ecodigo = #Arguments.Ecodigo#
				</cfquery>
				<cfif rsSQL.CFcuenta EQ "">
					<cf_errorCode	code = "51334"
									msg  = "ERROR EN CONTROL PRESUPUESTARIO: Cuenta Contable id='[@errorDat_1@]' no Existe"
									errorDat_1="#Arguments.Ccuenta#"
					>
				</cfif>
				<cfset LvarCFcuenta = rsSQL.CFcuenta>
			<cfelse>
				<!--- Se utiliza CFformato para interfases externas al SIF --->
				<cfinvoke 	component		= "PC_GeneraCuentaFinanciera"
							method			= "fnGeneraCuentaFinanciera"
							returnvariable	= "LvarMSG"
				>
					<cfinvokeargument name="Lprm_CFformato" 		value="#Arguments.CFformato#">
					<cfinvokeargument name="Lprm_fecha" 			value="#now()#">
					<cfinvokeargument name="Lprm_TransaccionActiva" value="true">
				</cfinvoke>
				
				<cfif LvarMSG EQ "OLD" OR LvarMSG EQ "NEW">
					<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
						select min(CFcuenta) as CFcuenta
						  from CFinanciera
						 where Ecodigo = #Arguments.Ecodigo#
						   and CFformato = '#Arguments.CFformato#'
					</cfquery>
					<cfif rsSQL.CFcuenta EQ "">
						<cf_errorCode	code = "51335"
										msg  = "ERROR EN CONTROL PRESUPUESTARIO: Cuenta Financiera '@errorDat_1@' no Existe"
										errorDat_1="#Arguments.CFformato#"
						>
					</cfif>
					<cfset LvarCFcuenta = rsSQL.CFcuenta>
				<cfelse>
					<cf_errorCode	code = "51336"
									msg  = "ERROR EN CONTROL PRESUPUESTARIO: @errorDat_1@"
									errorDat_1="#LvarMSG#"
					>
				</cfif>
			</cfif>
		<cfelse>
			<cfset LvarCFcuenta = Arguments.CFcuenta>
		</cfif>

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select f.Cmayor, f.CFcuenta, f.Ccuenta, f.CPcuenta, f.CFmovimiento, 
				f.CFformato as CFformato, 
				((select min(p.CPformato) from CPresupuesto p where p.CPcuenta = f.CPcuenta)) as CPformato
			  from CFinanciera f
			 where f.CFcuenta = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarCFcuenta#">
			   and f.Ecodigo = #Arguments.Ecodigo#
   		</cfquery>
		
		<cfif rsSQL.recordCount EQ 0>
			<cf_errorCode	code = "51337"
							msg  = "ERROR EN CONTROL PRESUPUESTARIO: Cuenta Financiera id='[@errorDat_1@]' no Existe"
							errorDat_1="#LvarCFcuenta#"
			>
		</cfif>
		<cfif rsSQL.CFmovimiento NEQ "S">
			<cf_errorCode	code = "51338"
							msg  = "ERROR EN CONTROL PRESUPUESTARIO: Cuenta Financiera '@errorDat_1@' no es de ultimo nivel y por tanto no acepta movimientos"
							errorDat_1="#rsSQL.CFformato#"
			>
		</cfif>
		<cfset LvarCtas.Cmayor    = rsSQL.Cmayor>
		<cfset LvarCtas.CFcuenta  = rsSQL.CFcuenta>
		<cfset LvarCtas.Ccuenta   = rsSQL.Ccuenta>
		<cfset LvarCtas.CPcuenta  = rsSQL.CPcuenta>
		<cfset LvarCtas.CFformato = trim(rsSQL.CFformato)>
		<cfset LvarCtas.CPformato = trim(rsSQL.CPformato)>
		<cfif Arguments.VerificarInactiva>
			<cfset fnVerificarCuentaInactiva(LvarCtas.CPcuenta, Arguments.CPCano, Arguments.CPCmes, Arguments.Conexion)>
		</cfif>
		<cfreturn LvarCtas>
	</cffunction>

	<cffunction name="fnVerificarCuentaInactiva" output="no" access="private">
		<cfargument name="CPcuenta"			type="string"  required="true">
		<cfargument name="CPCano"			type="string"  	required="true">
		<cfargument name="CPCmes"			type="string"  	required="true">
		<cfargument name="Conexion" 		type="string"  	required="true">

		<cfif Arguments.CPcuenta EQ "">
			<cfreturn>
		</cfif>
		<cfif Arguments.CPCano EQ "" OR Arguments.CPCmes EQ "">
			<cfset LvarAnoMes = LvarAnoMesDocumento>
		<cfelse>
			<cfset LvarAnoMes = Arguments.CPCano*100 + Arguments.CPCmes>
		</cfif>
		<cfif LvarAnoMes EQ LvarAnoMesDocumento AND LvarAnoMes EQ dateFormat(LvarFechaDocumento,"YYYYMM")>
			<cfset LvarFecha1 = LvarFechaDocumento>
			<cfset LvarFecha2 = LvarFechaDocumento>
		<cfelse>
			<cfset LvarAno = int(LvarAnoMes/100)>
			<cfset LvarMes = LvarAnoMes - LvarAno*100>
			<cfset LvarFecha1 = CreateDate(LvarAno,LvarMes,1)>
			<cfset LvarFecha2 = DateAdd("m",1,LvarFecha1)>
			<cfset LvarFecha2 = DateAdd("d",-1,LvarFecha2)>
		</cfif>
		
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select c.CPformato, i.CPIdesde, i.CPIhasta
			  from PCDCatalogoCuentaP cubo
			  	inner join CPInactivas i
					inner join CPresupuesto c
						on c.CPcuenta = i.CPcuenta
					on i.CPcuenta = cubo.CPcuentaniv
				   and <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha1#">
				   		>= i.CPIdesde
				   and <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha2#">
				   		<= i.CPIhasta
			 where cubo.CPcuenta = #Arguments.CPcuenta#
			<!--- order by cubo.PCDCniv --->
		</cfquery>
		<cfif rsSQL.recordCount GT 0>
			<cf_errorCode	code = "51339"
							msg  = "ERROR EN CONTROL PRESUPUESTARIO: Cuenta de Presupuesto '@errorDat_1@' está inactiva desde @errorDat_2@ hasta @errorDat_3@"
							errorDat_1="#trim(rsSQL.CPformato)#"
							errorDat_2="#dateFormat(rsSQL.CPIdesde,"DD/MM/YYYY")#"
							errorDat_3="#dateFormat(rsSQL.CPIhasta,"DD/MM/YYYY")#"
			>
		</cfif>
	</cffunction>

	
	<!-------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="sbGeneracionMasiva" access="private" output="no">
		<cfargument name="TipoMovimiento" required="yes">
		<cfargument name="Conexion" required="yes">

		<cfset rsNRPanterior.CPNRPNUM = "">
		<cfset rsNRPanterior.UsucodigoAutoriza = "">
		<cfset LvarExcesoConOrigenAbierto = false>
		<cfset LvarReversion = false>

		<cfquery name="rsPRES" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
			  from #Request.intPresupuesto#
		</cfquery>
<cflog file="FormulacionAplica" text="Inicio sbGeneracionMasiva: Tipo Movimiento=#Arguments.TipoMovimiento#, Cantidad Detalle=#rsPRES.cantidad#">

		<cfif Arguments.TipoMovimiento EQ "A">
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select m.CPcuenta, p.CPformato, o.Oficodigo, o.Odescripcion, m.CPCano, m.CPCmes
				  from #Request.intPresupuesto# m
				  	inner join CPresupuestoControl s
						on s.CPCano		= m.CPCano
					   and s.CPCmes		= m.CPCmes
					   and s.CPcuenta	= m.CPcuenta
					   and s.Ocodigo	= m.Ocodigo
					   and s.CPCpresupuestado <> 0
					inner join Oficinas o
					    on o.Ecodigo	= #session.Ecodigo#
					   and o.Ocodigo	= m.Ocodigo
					inner join CPresupuesto p
					    on p.CPcuenta	= m.CPcuenta
			</cfquery>
			<cfif rsSQL.CPcuenta NEQ "">
				<cf_errorCode	code = "51340"
								msg  = "Cuenta de Presupuesto no puede volverse a Formular con Presupuesto Ordinario: @errorDat_1@, @errorDat_2@ - @errorDat_3@, @errorDat_4@ - @errorDat_5@"
								errorDat_1="#rsSQL.CPformato#"
								errorDat_2="#rsSQL.CPCano#"
								errorDat_3="#rsSQL.CPCmes#"
								errorDat_4="#rsSQL.Oficodigo#"
								errorDat_5="#rsSQL.Odescripcion#"
				>
			</cfif>
		</cfif>
		
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			update  CPresupuestoControl
			<cfif Arguments.TipoMovimiento EQ "A">
			   set	CPCpresupuestado 	= 
			<cfelseif Arguments.TipoMovimiento EQ "M">
			   set	CPCmodificado 		= round(CPCmodificado, 2) +
			<cfelseif Arguments.TipoMovimiento EQ "VC">
			   set	CPCvariacion 		= round(CPCvariacion, 2) +
			</cfif>
			   			(
							select round(Monto, 2)
							  from #Request.intPresupuesto#
							 where CPCano	= CPresupuestoControl.CPCano
							   and CPCmes	= CPresupuestoControl.CPCmes
							   and CPcuenta	= CPresupuestoControl.CPcuenta
							   and Ocodigo	= CPresupuestoControl.Ocodigo
						)
			 where	Ecodigo	= #session.Ecodigo#
			   and	CPPid	= #LvarCPPid#
			   and	exists
			   			(
							select 1
							  from #Request.intPresupuesto#
							 where CPCano	= CPresupuestoControl.CPCano
							   and CPCmes	= CPresupuestoControl.CPCmes
							   and CPcuenta	= CPresupuestoControl.CPcuenta
							   and Ocodigo	= CPresupuestoControl.Ocodigo
						)
		</cfquery>
<cflog file="FormulacionAplica" text="update CPresupuestoControl">

		<!--- 
			Si es una version de Modificacion, debe mantener
			el TipoContro y CalculoControl del periodo
		--->
		<cfif Arguments.TipoMovimiento NEQ "A">
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				update  #Request.intPresupuesto#
				   set	CalculoControl = 
							(
								select CPCPcalculoControl
								  from CPCuentaPeriodo p
								 where p.Ecodigo	= #session.Ecodigo#
								   and p.CPPid		= #LvarCPPid#
								   and p.CPcuenta	= #Request.intPresupuesto#.CPcuenta
							)
						,TipoControl = 
							(
								select CPCPtipoControl
								  from CPCuentaPeriodo p
								 where p.Ecodigo	= #session.Ecodigo#
								   and p.CPPid		= #LvarCPPid#
								   and p.CPcuenta	= #Request.intPresupuesto#.CPcuenta
							)
			</cfquery>
		</cfif>
		
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			update  #Request.intPresupuesto#
			   set	MontoAcum = 
						case CalculoControl
							when 1 then round(Monto, 2)
							else
								(
									select sum(round(Monto, 2))
									  from #Request.intPresupuesto# d
									 where d.CPcuenta = #Request.intPresupuesto#.CPcuenta
									   and d.Ocodigo  = #Request.intPresupuesto#.Ocodigo
									   and d.CPCanoMes <= #Request.intPresupuesto#.CPCanoMes
								)
						end
					,CalculoIni =
						case CalculoControl
							when 1 then CPCanoMes
							when 2 then 0
							when 3 then 0
						end
					,CalculoFin =
						case CalculoControl
							when 1 then CPCanoMes
							when 2 then CPCanoMes
							when 3 then 999999
						end
		</cfquery>
<cflog file="FormulacionAplica" text="update intPresupuesto set MontoAcum">
		<cfif Arguments.TipoMovimiento EQ "A">
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				update  #Request.intPresupuesto#
				   set	DisponibleAnterior = round(MontoAcum, 2) - round(Monto, 2),
				   		DisponibleGenerado = round(MontoAcum, 2)
			</cfquery>
<cflog file="FormulacionAplica" text="update intPresupuesto set Disponibles">
		<cfelse>
			<cf_dbtemp 	name="CP_DISPACT_V4" 
						returnvariable="DISPONIBLES"
						datasource="#session.dsn#"
			>
				<cf_dbtempcol name="CPPid"				type="numeric">			<!--- Valor en el Nivel --->
				<cf_dbtempcol name="CPcuenta"			type="numeric"	mandatory="yes">
				<cf_dbtempcol name="Ocodigo"			type="numeric"	mandatory="yes">
				<cf_dbtempcol name="CPCanoMes" 			type="int"		mandatory="yes">
				<cf_dbtempcol name="Disponible"			type="money"	mandatory="yes">
				<cf_dbtempcol name="Pendientes"			type="money"	mandatory="yes">

				<cf_dbtempindex cols="CPPid, CPcuenta, Ocodigo, CPCanoMes">
			</cf_dbtemp>			
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				insert into #DISPONIBLES# (CPPid, CPcuenta, Ocodigo, CPCanoMes, Disponible, Pendientes)
				select	#Request.intPresupuesto#.CPPid, 
						#Request.intPresupuesto#.CPcuenta,
						#Request.intPresupuesto#.Ocodigo,
						#Request.intPresupuesto#.CPCanoMes,
					(
						select
							coalesce(
								sum(
									CPCpresupuestado + CPCmodificado + CPCmodificacion_Extraordinaria + CPCvariacion + CPCtrasladado + CPCtrasladadoE
									-
									(
										CPCreservado_Anterior + CPCcomprometido_Anterior +
										CPCreservado_Presupuesto +
										CPCreservado + CPCcomprometido +
										CPCejecutado
									)
								)
							, 0)
						  from CPresupuestoControl d
						 where d.Ecodigo	= #session.Ecodigo#
						   and d.CPPid		= #Request.intPresupuesto#.CPPid
						   and d.CPcuenta	= #Request.intPresupuesto#.CPcuenta
						   and d.Ocodigo	= #Request.intPresupuesto#.Ocodigo
						   and d.CPCanoMes	>= #Request.intPresupuesto#.CalculoIni
						   and d.CPCanoMes	<= #Request.intPresupuesto#.CalculoFin
					),
					(
						select
							coalesce(
								sum(CPCnrpsPendientes)
							, 0)
						  from CPresupuestoControl d
						 where d.Ecodigo	= #session.Ecodigo#
						   and d.CPPid		= #Request.intPresupuesto#.CPPid
						   and d.CPcuenta	= #Request.intPresupuesto#.CPcuenta
						   and d.Ocodigo	= #Request.intPresupuesto#.Ocodigo
						   and d.CPCanoMes	>= #Request.intPresupuesto#.CalculoIni
						   and d.CPCanoMes	<= #Request.intPresupuesto#.CalculoFin
					)
				  from #Request.intPresupuesto#
			</cfquery>

			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				update  #Request.intPresupuesto#
				   set	DisponibleGenerado = 
							(
								select	Disponible
								  from 	#DISPONIBLES#
								 where 	CPPid		= #Request.intPresupuesto#.CPPid
								   and 	CPcuenta 	= #Request.intPresupuesto#.CPcuenta
								   and 	Ocodigo		= #Request.intPresupuesto#.Ocodigo
								   and 	CPCanoMes	= #Request.intPresupuesto#.CPCanoMes
							)
				   ,	DisponibleNeto =
							(
								select	Disponible + Pendientes
								  from 	#DISPONIBLES#
								 where 	CPPid		= #Request.intPresupuesto#.CPPid
								   and 	CPcuenta 	= #Request.intPresupuesto#.CPcuenta
								   and 	Ocodigo		= #Request.intPresupuesto#.Ocodigo
								   and 	CPCanoMes	= #Request.intPresupuesto#.CPCanoMes
							)
			</cfquery>

<cflog file="FormulacionAplica" text="update intPresupuesto set Disponible Generado">
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				update  #Request.intPresupuesto#
				   set	DisponibleAnterior = DisponibleGenerado - Monto
			</cfquery>

<cflog file="FormulacionAplica" text="update intPresupuesto set Disponible Anterior">

			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select	*
				  from	#Request.intPresupuesto#
				 where	DisponibleNeto < 0
				   and	TipoControl <> 0
			</cfquery>
			<cfif rsSQL.recordCount GT 0>
				<cfloop query="rsSQL">
					<cflog file="FormulacionAplica" text="Cuenta sin Disponible Neto: #rsSQL.CuentaPresupuesto#, Tipo Control=#rsSQL.TipoControl#, Calculo Control=#rsSQL.CalculoControl#, Oficina=#rsSQL.CodigoOficina#, Mes=#rsSQL.CPCano#-#rsSQL.CPCmes#, Disponible Anterior=#numberFormat(rsSQL.DisponibleAnterior,",9.99")#, Movimiento=#numberFormat(rsSQL.Monto,",9.99")#, Pendientes=#numberFormat(rsSQL.DisponibleNeto - rsSQL.DisponibleGenerado,",9.99")#, Disponible Neto Generado=#numberFormat(rsSQL.DisponibleNeto,",9.99")#">
				</cfloop>
				<cf_errorCode	code = "51341" msg = "ERROR EN CONTROL PRESUPUESTARIO: Hay cuentas con control Restringido o Restrictivo que generaron un disponible neto menor que cero <BR>(ver log en CFMX/WEB-INF/cfusion/logs/FormulacionAplica.log)">
			</cfif>
<cflog file="FormulacionAplica" text="Verificacion Excesos">
		</cfif>
	</cffunction>
 
	<cffunction name="fnReversarNAPcompleto" access="public" returntype="numeric" output="no">
		<cfargument name='ModuloOrigen' 	type="string" 	required='true'>		
		<cfargument name='NumeroDocumento' 	type='string' 	required='true'>
		<cfargument name='NumeroReferencia' type='string' 	required='true'>

		<cfargument name='FechaDocumento' 	type='date'   	required='true'>
		<cfargument name='AnoDocumento'	 	type='numeric' 	required='true'>
		<cfargument name='MesDocumento'	 	type='numeric' 	required='true'>

		<cfargument name='NAPreversado'	 	type='numeric' 	required='true'>
		<cfargument name='DOCreversado'	 	type='numeric' 	required='true'>

		<cfargument name="Conexion" 		type="string"  	required='true'>
		<cfargument name="Ecodigo" 			type="numeric" 	required='true'>		

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select n.CPNAPnum, n.CPNAPmoduloOri, n.CPNAPdocumentoOri, coalesce(sum(d.CPNAPDutilizado),0) as Utilizado
			  from CPNAP n
				left join CPNAPdetalle d
					 on d.Ecodigo 	= n.Ecodigo
					and d.CPNAPnum 	= n.CPNAPnum
			 where n.Ecodigo	= #Arguments.Ecodigo#
			   and n.CPNAPnum	= #Arguments.NAPreversado#
			 group by n.CPNAPnum, n.CPNAPmoduloOri, n.CPNAPdocumentoOri
		</cfquery>
		
		<cfif rsSQL.CPNAPnum EQ "">
			<cf_errorCode	code = "51342"
							msg  = "El NAP @errorDat_1@ no existe"
							errorDat_1="#Arguments.NAPreversado#"
			>
		<cfelseif rsSQL.CPNAPmoduloOri NEQ Arguments.ModuloOrigen>
			<cfif (rsSQL.CPNAPmoduloOri EQ "TEGE" OR rsSQL.CPNAPmoduloOri EQ "TECH") AND Arguments.ModuloOrigen EQ "TESP">
				<!--- SP GE.Anticipo --->
				<cfquery name="rsDet" datasource="#Arguments.Conexion#">
					select count(1)
					  from TESsolicitudPago sp
					  	inner join TESdetallePago dp on dp.TESSPid = sp.TESSPid
					 where sp.EcodigoOri			= #Arguments.Ecodigo#
					   and sp.TESSPnumero			= #Arguments.DOCreversado#
					   and dp.TESDPtipoDocumento	in (6,7,8,9)
					   and dp.TESDPmoduloOri		= '#rsSQL.CPNAPmoduloOri#'
					   and dp.TESDPdocumentoOri		= '#rsSQL.CPNAPdocumentoOri#'
				</cfquery>
				<cfset LvarError = (rsDet.recordcount EQ 0)>
			<cfelse>
				<cfset LvarError = true>
			</cfif>
			<cfif LvarError>
				<cf_errorCode	code = "51343"
								msg  = "El NAP @errorDat_1@ pertenece a otro Modulo Origen: @errorDat_2@ <> @errorDat_3@"
								errorDat_1="#Arguments.NAPreversado#"
								errorDat_2="#rsSQL.CPNAPmoduloOri#"
								errorDat_3="#Arguments.ModuloOrigen#"
				>
			</cfif>
		<cfelseif rsSQL.CPNAPdocumentoOri NEQ Arguments.DOCreversado>
			<cf_errorCode	code = "51344"
							msg  = "El NAP @errorDat_1@ pertenece a otro Documento: @errorDat_2@ <> @errorDat_3@"
							errorDat_1="#Arguments.NAPreversado#"
							errorDat_2="#rsSQL.CPNAPdocumentoOri#"
							errorDat_3="#Arguments.DOCreversado#"
			>
		<cfelseif rsSQL.Utilizado NEQ 0>
			<cf_errorCode	code = "51345"
							msg  = "El NAP @errorDat_1@ ya ha sido utilizado y no puede reversarse en forma total"
							errorDat_1="#Arguments.NAPreversado#"
			>
		</cfif>

		<!--- inserta la tabla temporal --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #request.intPresupuesto#
				( 	
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					NumeroLinea, 
					CFcuenta,
					CPcuenta,
					Ocodigo,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					TipoMovimiento,
					NAPreferencia,
					LINreferencia,

					PCGDid, PCGDcantidad
				)
			select  '#Arguments.ModuloOrigen#',
					'#Arguments.NumeroDocumento#',
					'#Arguments.NumeroReferencia#',
					<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#Arguments.FechaDocumento#">,
					#Arguments.AnoDocumento#,
					#Arguments.MesDocumento#,
					d.CPNAPDlinea, 
					d.CFcuenta,
					d.CPcuenta,
					d.Ocodigo,
					d.Mcodigo,
					-d.CPNAPDmontoOri,
					d.CPNAPDtipoCambio,
					-d.CPNAPDmonto,
					d.CPNAPDtipoMov,
					d.CPNAPnum,
					d.CPNAPDlinea,

					d.PCGDid, -d.PCGDcantidad
			from CPNAP n
				inner join CPNAPdetalle d
					 on d.Ecodigo	= n.Ecodigo
					and d.CPNAPnum	= n.CPNAPnum
			where n.Ecodigo		= #Arguments.Ecodigo#
			  and n.CPNAPnum	= #Arguments.NAPreversado#
		</cfquery>

		<cfquery datasource="#Arguments.Conexion#">
			insert into #request.intPresupuesto#
				( 	
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					DocumentoPagado,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					NumeroLinea, 
					NumeroLineaID, 

					CPcuenta,
					Ocodigo,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					TipoMovimiento
				)
			<!--- 'EJ/P:PAGADO' --->
			select  '#Arguments.ModuloOrigen#',
					'#Arguments.NumeroDocumento#',
					'#Arguments.NumeroReferencia#',
					d.CPNAPDPdocumento,
					<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#Arguments.FechaDocumento#">,
					#Arguments.AnoDocumento#,
					#Arguments.MesDocumento#,
					coalesce((select max(NumeroLinea) from #request.intPresupuesto#),0)+1 as NumeroLinea,
					d.CPNAPDPid,

					d.CPcuenta,
					d.Ocodigo,
					d.Mcodigo,
					-d.CPNAPDPmontoOri,
					d.CPNAPDPtipoCambio,
					-d.CPNAPDPmonto,
					d.CPNAPDPtipoMov
			  from CPNAPdetallePagado d
			 where d.Ecodigo	= #Arguments.Ecodigo#
			   and d.CPNAPnum	= #Arguments.NAPreversado#
		</cfquery>

		<cfreturn ControlPresupuestario	
			(	
				Arguments.ModuloOrigen,
				Arguments.NumeroDocumento,
				Arguments.NumeroReferencia,

				Arguments.FechaDocumento,
				Arguments.AnoDocumento,
				Arguments.MesDocumento,

				Arguments.Conexion,
				Arguments.Ecodigo,
				
				Arguments.NAPreversado
			)>
	</cffunction>

	<!--- 
		fnSignoDB_CR: 
			Presupuesto de Egresos = 
				Compras de Activos				Debitos A
				Realización de Gastos			Debitos G
				Excepciones:
				  Realización de Costos			Debitos I
				  Amortización de Pasivos		Debitos P
				  Distribución de Utilidades	Debitos C
			Presupuesto de Ingresos = 
				Ingresos por Ventas				Creditos I
				Aumento de Pasivos				Creditos P
				Ingresos de Capital				Creditos C
				Excepciones:
				  Venta de Activos Fijos		Creditos A
				  Amortización de Bonos			Creditos A
				
		TIPO DE CUENTA:
		CASE (SELECT min(CPTCtipo) from CPtipoCtas WHERE #Arguments.CFformato# like CPTCmascara)
			WHEN 'C' THEN 'C'
			WHEN 'E' THEN 'E'
			WHEN 'I' THEN 'I'
			WHEN #Arguments.Ctipo# IN ('A','G') THEN 'E' ELSE 'I'
		END
		
		Determina el signo a aplicar al monto dependiendo si la cuenta es Ingreso, Egreso o Costo y si es DB o CR:
		CASE (SELECT min(CPTCtipo) from CPtipoCtas WHERE #Arguments.CFformato# like CPTCmascara)
			WHEN 'C' THEN CASE WHEN #esDebito# THEN 1 ELSE -1 END
			WHEN 'E' THEN CASE WHEN #esDebito# THEN 1 ELSE -1 END
			WHEN 'I' THEN CASE WHEN #esDebito# THEN -1 ELSE 1 END
			WHEN #Arguments.Ctipo# IN ('A','G') 
			         THEN CASE WHEN #esDebito# THEN 1 ELSE -1 END
			         ELSE CASE WHEN #esDebito# THEN -1 ELSE 1 END
		END
	--->
	<!--- 
		INTTIPxMonto:
						xINTIP							xMONTO
			esDebito:	INTTIP = 'D'	equivale a		MONTO >= 0
			esCredtio:	INTTIP = 'C'	equivale a		MONTO <  0
	--->
	<cffunction name="fnTipoPresupuesto" output="no" returntype="string" access="public">
		<cfargument name="CPPid" 				type="numeric" >
		<cfargument name="Ctipo" 				type="string" >
		<cfargument name="CPresupuestoAlias"	type="string" >

		<cf_dbfunction name="LIKE" args="#Arguments.CPresupuestoAlias#.CPformato,CPTCmascara" returnvariable="LvarWhere">
		<cfset LvarWhere	= "CPPid = #Arguments.CPPid# AND Ecodigo = #Arguments.CPresupuestoAlias#.Ecodigo AND Cmayor = #Arguments.CPresupuestoAlias#.Cmayor AND #LvarWhere# AND CPTCtipo <> 'X'">

		<cfset LvarTipPres = "">
		<cfset LvarTipPres = LvarTipPres & "CASE (SELECT min(CPTCtipo) from CPtipoCtas WHERE #LvarWhere#) ">
		<cfset LvarTipPres = LvarTipPres &   "WHEN 'E' THEN 'E' ">
		<cfset LvarTipPres = LvarTipPres &   "WHEN 'C' THEN 'C' ">
		<cfset LvarTipPres = LvarTipPres &   "WHEN 'I' THEN 'I' ">
		<cfset LvarTipPres = LvarTipPres &   "ELSE CASE WHEN #Arguments.Ctipo# IN ('A','G') THEN 'E' ELSE 'I' END ">
		<cfset LvarTipPres = LvarTipPres & "END">
		<cfreturn LvarTipPres>
	</cffunction>
	
	<cffunction name="fnSignoDB_CR" output="no" returntype="string" access="public">
		<cfargument name="INTTIP" 				type="string" >
		<cfargument name="Ctipo" 				type="string" >
		<cfargument name="CPresupuestoAlias"	type="string" >
		<cfargument name="Ecodigo" 				type="numeric">
		<cfargument name="AnoDocumento" 		type="numeric">
		<cfargument name="MesDocumento" 		type="numeric">
		<cfargument name="INTTIPxMonto"			type="boolean" default="false">		

		<cfset var LvarSigno = "">

		<!--- OJO : Codigo 2800 = Cuenta de Egresos por Amortización de préstamos (excepcion a PASIVO) PASAR A CPtipoCtas --->

		<cfquery name="rsCPP" datasource="#session.dsn#">
			select CPPid
			  from CPresupuestoPeriodo
			 where Ecodigo = #Arguments.Ecodigo#
			   and #Arguments.AnoDocumento*100+Arguments.MesDocumento# between CPPanoMesDesde and CPPanoMesHasta
		</cfquery>

		<cfif Arguments.INTTIPxMonto>
			<cfset LvarEsDB	= "#Arguments.INTTIP# >= 0">
		<cfelse>
			<cfset LvarEsDB	= "#Arguments.INTTIP# = 'D'">
		</cfif>

		<cfset LvarSigno = LvarSigno & "CASE #fnTipoPresupuesto(rsCPP.CPPid, Arguments.Ctipo, Arguments.CPresupuestoAlias)# ">
		<cfset LvarSigno = LvarSigno &   "WHEN 'E' THEN CASE WHEN #LvarEsDB# THEN 1 ELSE -1 END ">
		<cfset LvarSigno = LvarSigno &   "WHEN 'C' THEN CASE WHEN #LvarEsDB# THEN 1 ELSE -1 END ">
		<cfset LvarSigno = LvarSigno &   "WHEN 'I' THEN CASE WHEN #LvarEsDB# THEN -1 ELSE 1 END ">
		<cfset LvarSigno = LvarSigno & "END">

		<cfreturn LvarSigno>						
	</cffunction>

 	<cffunction name="ControlPresupuestarioINTARC" output="no" returntype="struct" access="public">
		<cfargument name='ModuloOrigen' 	type="string" 	required='true'>		
		<cfargument name='NumeroDocumento' 	type='string' 	required='true'>
		<cfargument name='NumeroReferencia' type='string' 	required='true'>
		<cfargument name='FechaDocumento' 	type='date'   	required='true'>
		<cfargument name='AnoDocumento'	 	type='numeric' 	required='true'>
		<cfargument name='MesDocumento'	 	type='numeric' 	required='true'>

		<cfargument name="Conexion" 		type="string"  	required='false'>
		<cfargument name="Ecodigo" 			type="numeric" 	required="false">		

		<cfargument name="Intercompany" 	type="boolean" 	required="false">		
		<cfargument name="BorrarIntPres" 	type="boolean" 	default="true">		
		
		<cfif not isdefined("Arguments.Conexion")>
			<cfset Arguments.Conexion = session.DSN>
		</cfif>
		<cfif not isDefined("Arguments.Ecodigo")>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>

		<!--- Obtiene el CFcuenta para utilizarla con el LvarSignoDB_CR --->
		<cfquery datasource="#Arguments.Conexion#">
			update #Request.intarc#
			   set CFcuenta =
					(
						select min(CFcuenta) 
						  from CFinanciera
						 where Ccuenta = #Request.intarc#.Ccuenta
					)
			 where CFcuenta IS NULL
		</cfquery>
		<!--- Determina el signo de los montos de DB/CR a Ejecutar --->
		<cfset LvarSignoDB_CR = fnSignoDB_CR("i.INTTIP","m.Ctipo","cp", session.Ecodigo, Arguments.AnoDocumento, Arguments.MesDocumento)>

		<cfif Arguments.BorrarIntPres>
			<cfquery datasource="#Arguments.Conexion#">
				delete from #request.intPresupuesto#
			</cfquery>
		</cfif>
				
		<cfquery datasource="#Arguments.Conexion#">
			insert into #request.intPresupuesto#
				(
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					
					NumeroLinea, CFcuenta, Ccuenta, Ocodigo,
					TipoMovimiento,
					Mcodigo, 	MontoOrigen, 
					TipoCambio, Monto,
					
					CPCano, CPCmes, PCGDid
				)
			select 	'#Arguments.ModuloOrigen#', '#Arguments.NumeroDocumento#', '#Arguments.NumeroReferencia#',
					<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#Arguments.FechaDocumento#">,
					#Arguments.AnoDocumento#, #Arguments.MesDocumento#,
					INTLIN, 
					cf.CFcuenta,
					i.Ccuenta, 
					i.Ocodigo,
					'E',
					i.Mcodigo,	
					#PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMOE,2) as MontoOrigen, 
					INTCAM,
					#PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMON,2) as Monto, 
					#Arguments.AnoDocumento#, #Arguments.MesDocumento#, i.PCGDid
			  from  #Request.intarc# i
			  		inner join CFinanciera cf
						left join CPresupuesto cp
						   on cp.CPcuenta = cf.CPcuenta
						inner join CtasMayor m
						   on m.Ecodigo	= cf.Ecodigo
						  and m.Cmayor	= cf.Cmayor
					   on cf.CFcuenta = i.CFcuenta
		</cfquery>

		<cfif listfind("MBMV,MBTR,CPRE,CCRE",Arguments.ModuloOrigen)>
			<cfset GenerarEjecucionConPago(Arguments.Conexion,Arguments.Ecodigo)>
		</cfif>
		
		<cfreturn ControlPresupuestarioIntercompany
										(Arguments.ModuloOrigen, Arguments.NumeroDocumento, Arguments.NumeroReferencia, 
										 Arguments.FechaDocumento, Arguments.AnoDocumento, Arguments.MesDocumento, 
										 Arguments.Conexion, Arguments.Ecodigo, 
										 -1,false,false,
										 Arguments.Intercompany)>
	</cffunction>

	<cffunction name="ControlPresupuestarioEContables" output="no" returntype="void" access="public">
		<cfargument name='IDcontable'	 	type='numeric' 	required='true'>

		<cfargument name="Conexion" 		type="string"  	required='false'>
		<cfargument name="Ecodigo" 			type="numeric" 	required="false">		
		
		<cfif not isdefined("Arguments.Conexion")>
			<cfset Arguments.Conexion = session.DSN>
		</cfif>
		<cfif not isDefined("Arguments.Ecodigo")>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		
		<cfquery name="EContables" datasource="#Arguments.Conexion#">
			select 	 Eperiodo, Emes, Cconcepto, Edocumento, Efecha, NAP, ECtipo
			 from EContables
			where IDcontable = #Arguments.IDcontable#
			  and Ecodigo 	 = #Arguments.Ecodigo#
		</cfquery>

		<cfif EContables.NAP NEQ "">
			<!--- Si ya hay un NAP para el asiento no se requiere volver a controlar --->
			<cfquery name="Request.rsIntPresupuesto" datasource="#Arguments.Conexion#">
				select * from #Request.IntPresupuesto#
				 where 1 = 2
			</cfquery>
			<cfreturn>
		</cfif>

		<cfset LvarIntercompany = (EContables.ECtipo EQ 20)>

		<!--- Obtiene el CFcuenta para utilizarla con el LvarSignoDB_CR --->
		<cfquery datasource="#Arguments.Conexion#">
			update DContables
			   set CFcuenta =
					(
						select min(CFcuenta) 
						  from CFinanciera
						 where Ccuenta = DContables.Ccuenta
					)
			 where IDcontable 	= #Arguments.IDcontable#
			   and CFcuenta		IS NULL
		</cfquery>
		<!--- Determina el signo de los montos de DB o CR a Ejecutar --->
		<cfset LvarSignoDB_CR = fnSignoDB_CR("d.Dmovimiento","m.Ctipo","cp", Arguments.Ecodigo, EContables.Eperiodo, EContables.Emes)>

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
			  from 	DContables d 
			 where d.IDcontable = #Arguments.IDcontable#
		</cfquery>

		<cfif rsSQL.cantidad LT 1000>
			<cfquery datasource="#Arguments.Conexion#">
				insert into #request.intPresupuesto#
					(
						ModuloOrigen,
						NumeroDocumento,
						NumeroReferencia,
						FechaDocumento,
						AnoDocumento,
						MesDocumento,
						
						NumeroLinea, 
						Ccuenta, CFcuenta, CPcuenta, 
						Ocodigo,
						TipoMovimiento,
						Mcodigo, 	MontoOrigen, 
						TipoCambio, Monto,
						
						CPCano, CPCmes
					)
				select 	'CGDC', '#EContables.Edocumento#', '#EContables.Eperiodo#-#EContables.Emes#-#EContables.Cconcepto#',
						<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#EContables.Efecha#">,
						#EContables.Eperiodo#, #EContables.Emes#,
						d.Dlinea, 
						d.Ccuenta, d.CFcuenta, cp.CPcuenta,
						Ocodigo,
						'E',
						d.Mcodigo,		
						#PreserveSingleQuotes(LvarSignoDB_CR)# * d.Doriginal as MontoOrigen, 
						d.Dtipocambio,
						#PreserveSingleQuotes(LvarSignoDB_CR)# * d.Dlocal as MontoLocal, 
						#EContables.Eperiodo#, #EContables.Emes#
				  from 	DContables d 
					inner join CFinanciera cf
						left join CPresupuesto cp
						   on cp.CPcuenta = cf.CPcuenta
						inner join CtasMayor m
							 on m.Ecodigo	= cf.Ecodigo
							and m.Cmayor	= cf.Cmayor
					   on cf.CFcuenta = d.CFcuenta
				 where d.IDcontable = #Arguments.IDcontable#
			</cfquery>
		<cfelse>
			<cfquery datasource="#Arguments.Conexion#">
				delete from #request.intPresupuestoT#
			</cfquery>

			<cfquery datasource="#Arguments.Conexion#">
				insert into #request.intPresupuestoT#
					(
						ModuloOrigen,
						NumeroDocumento,
						NumeroReferencia,
						FechaDocumento,
						AnoDocumento,
						MesDocumento,
						
						NumeroLinea, 
						Ccuenta, CFcuenta, CPcuenta,
						Ocodigo,
						TipoMovimiento,
						Mcodigo, 	MontoOrigen, 
						TipoCambio, Monto,
						
						CPCano, CPCmes
					)
				select 	'CGDC', '#EContables.Edocumento#', '#EContables.Eperiodo#-#EContables.Emes#-#EContables.Cconcepto#',
						<cfqueryparam cfsqltype="cf_sql_date" value="#EContables.Efecha#">,
						#EContables.Eperiodo#, #EContables.Emes#,
						d.Dlinea, 
						d.Ccuenta, d.CFcuenta, cp.CPcuenta,
						Ocodigo,
						'E',
						d.Mcodigo,		
						#PreserveSingleQuotes(LvarSignoDB_CR)# * d.Doriginal as MontoOrigen, 
						d.Dtipocambio,
						#PreserveSingleQuotes(LvarSignoDB_CR)# * d.Dlocal as MontoLocal, 
						#EContables.Eperiodo#, #EContables.Emes#
				  from 	DContables d 
					inner join CFinanciera cf
						left join CPresupuesto cp
						   on cp.CPcuenta = cf.CPcuenta
						inner join CtasMayor m
							 on m.Ecodigo	= cf.Ecodigo
							and m.Cmayor	= cf.Cmayor
					   on cf.CFcuenta = d.CFcuenta
				 where d.IDcontable = #Arguments.IDcontable#
			</cfquery>

			<cfquery datasource="#Arguments.Conexion#">
				insert into #request.intPresupuesto#
					(
						ModuloOrigen,
						NumeroDocumento,
						NumeroReferencia,
						FechaDocumento,

						AnoDocumento, MesDocumento,
						CPCano, CPCmes,
						
						Ccuenta, CFcuenta, CPcuenta, 
						Ocodigo,
						TipoMovimiento,
						Mcodigo, 	
						TipoCambio, 

						NumeroLinea, 
						MontoOrigen,
						Monto 
					)
				select 	'CGDC', '#EContables.Edocumento#', '#EContables.Eperiodo#-#EContables.Emes#-#EContables.Cconcepto#',
						<cfqueryparam cfsqltype="cf_sql_date" value="#EContables.Efecha#">,

						#EContables.Eperiodo#, #EContables.Emes#,
						#EContables.Eperiodo#, #EContables.Emes#,
						
						i.Ccuenta, i.CFcuenta, i.CPcuenta, 
						i.Ocodigo,
						i.TipoMovimiento,
						i.Mcodigo, 	
						i.TipoCambio, 

						min(i.NumeroLinea), 
						sum(i.MontoOrigen), 
						sum(i.Monto)
				from #request.intPresupuestoT# i
				group by
						i.Ccuenta, i.CFcuenta, i.CPcuenta, i.Ocodigo,
						i.TipoMovimiento,
						i.Mcodigo, 	
						i.TipoCambio
			</cfquery>

			<cfquery datasource="#Arguments.Conexion#">
				delete from #request.intPresupuestoT#
			</cfquery>
		</cfif>
		
		<cfset LvarIC = ControlPresupuestarioIntercompany
										('CGDC', "#EContables.Edocumento#", "#EContables.Eperiodo#-#EContables.Emes#-#EContables.Cconcepto#", 
										 EContables.Efecha, EContables.Eperiodo, EContables.Emes, 
										 Arguments.Conexion, Arguments.Ecodigo,
										 -1,false,false,
										 LvarIntercompany)>

		<cfset LvarNAP = LvarIC.NAP>
		<cfif LvarIC.Intercompany>
			<cfset LvarCPNAPIid = LvarIC.CPNAPIid>
		<cfelse>
			<cfset LvarCPNAPIid = "">
		</cfif>

		<cfif LvarNAP LT 0>
			<cfquery name="EContables" datasource="#Arguments.Conexion#">
			   update EContables
				  set NRP   = #-LvarNAP#
				where Ecodigo 	 = #Arguments.Ecodigo#
				  and IDcontable = #Arguments.IDcontable#
			</cfquery>
			<cftransaction action="commit" />

			<cflocation url="/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=#abs(LvarNAP)#">
		</cfif>

		<cfquery name="EContables" datasource="#Arguments.Conexion#">
		   update EContables
			  set NAP   = #LvarNAP#
			  	<cfif LvarCPNAPIid NEQ "">
			    , CPNAPIid = #LvarCPNAPIid#
				</cfif>
			where Ecodigo 	 = #Arguments.Ecodigo#
			  and IDcontable = #Arguments.IDcontable#
		</cfquery>

		<cfreturn>
	</cffunction>

	<cffunction name="fnSiguienteCPNAPIid" access="public" output="no" returntype="numeric">
		<cfargument name="Conexion" 		type="string"  	required='true'>

		<cfinvoke 	component		= "sif.Componentes.OriRefNextVal"
					method			= "nextVal"
					returnvariable	= "LvarCPNAPIid"
					
					ORI				= "PRCO"
					REF				= "CPNAPIid"
					Ecodigo			= "0"
					datasource		= "#Arguments.Conexion#"
		/>
		<cfreturn LvarCPNAPIid>
	</cffunction>

	<cffunction name="fnSiguienteCPNAPnum" access="public" output="no" returntype="numeric">
		<cfargument name="Conexion" 		type="string"  	required='true'>
		<cfargument name="Ecodigo"	 		type="numeric"  required='true'>

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select coalesce(max(CPNAPnum), 0) + 1 as NAP
			  from CPNAP
			 where Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfset LvarNAP = rsSQL.NAP>
		<cfset LvarTime = getTickCount()>
		<cfquery datasource="#Arguments.Conexion#">
			update CPNAP
			   set CPNAPnum	= CPNAPnum
			 where Ecodigo	= #Arguments.Ecodigo#
			   and CPNAPnum	= #LvarNAP-1#
		</cfquery>
		<cfif getTickCount()-LvarTime GT 500>
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select coalesce(max(CPNAPnum), 0) + 1 as NAP
				  from CPNAP
				 where Ecodigo = #Arguments.Ecodigo#
			</cfquery>
			<cfset LvarNAP = rsSQL.NAP>
		</cfif>
		
		<cfreturn LvarNAP>
	</cffunction>

	<cffunction name="GenerarEjecucionConPago" output="no" returntype="void" access="public">
		<cfargument name="Conexion" 		type="string"  	required='false'>
		<cfargument name="Ecodigo" 			type="numeric" 	required="false">		

		<cfif not isdefined("Arguments.Conexion")>
			<cfset Arguments.Conexion = session.DSN>
		</cfif>
		<cfif not isDefined("Arguments.Ecodigo")>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #Arguments.Ecodigo#
			   and Pcodigo = 1140
		</cfquery>
		<cfset LvarGenerarEjercido = (rsSQL.Pvalor EQ "S")>

		<cf_dbfunction name="to_char" args="NumeroLinea" returnVariable="LvarNumeroLinea">
		<cfif LvarGenerarEjercido>
			<cfquery datasource="#Arguments.Conexion#">
				insert into #request.intPresupuesto#
					(
						ModuloOrigen,
						NumeroDocumento,
						NumeroReferencia,
						DocumentoPagado,
						FechaDocumento,
						AnoDocumento,
						MesDocumento,
						NumeroLinea, 
						NumeroLineaID, 
						CFcuenta, CPcuenta,
						Ocodigo,
						Mcodigo,
						MontoOrigen,
						TipoCambio,
						Monto,
						TipoMovimiento
					)
				<!--- 'EJ/P:PAGADO' --->
				select  ModuloOrigen,
						NumeroDocumento,
						NumeroReferencia,
						<cf_dbfunction name="concat" args="'NAP,LIN ';#LvarNumeroLinea#" delimiters=";">,
						FechaDocumento,
						AnoDocumento,
						MesDocumento,
						NumeroLinea,
						1, 
						CFcuenta, CPcuenta,
						Ocodigo,
						Mcodigo,
						MontoOrigen,
						TipoCambio,
						Monto,
						'EJ'
				  from #request.intPresupuesto#
				 where TipoMovimiento = 'E'
			</cfquery>
		</cfif>
		<cfquery datasource="#Arguments.Conexion#">
			insert into #request.intPresupuesto#
				(
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					DocumentoPagado,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					NumeroLinea, 
					NumeroLineaID, 
					CFcuenta, CPcuenta,
					Ocodigo,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					TipoMovimiento
				)
			<!--- 'EJ/P:PAGADO' --->
			select  ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					<cf_dbfunction name="concat" args="'NAP,LIN ';#LvarNumeroLinea#" delimiters=";">,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					NumeroLinea,
					2, 
					CFcuenta, CPcuenta,
					Ocodigo,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					'P'
			  from #request.intPresupuesto#
			 where TipoMovimiento = 'E'
		</cfquery>
	</cffunction>
</cfcomponent>
