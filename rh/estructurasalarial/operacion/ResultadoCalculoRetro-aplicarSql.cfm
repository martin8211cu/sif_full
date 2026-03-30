<cfif (isDefined("form.nAplica")) 
	and (form.nAplica EQ 1)
	and (isdefined("Form.RCNid"))
	and (isDefined("Form.CBcc"))>
<cfset Lvar_Regresar = "ResultadoCalculoRetro-lista.cfm">
	<cfif not isdefined("form.btnSeguir")>
		<!--- Borrar si ya hay registros para esta relacion --->
		<cfquery datasource="#session.DSN#">
			delete from RCuentasTipo
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
		</cfquery>
		
		<!--- Usa Interfaz con Contabilidad [Parametro 20] --->
		<cfset vInterfazContable = false >
		<cfquery name="usaConta" datasource="#session.DSN#">
			select Pvalor 
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 20
		</cfquery>
		<cfif usaConta.recordcount gt 0 and usaConta.Pvalor eq 1>
			<cfset vInterfazContable = true >
		</cfif>

		<!--- Validar Planilla Presupuestaria [Parametro 540] --->
		<cfset vValidaPresupuesto = false >	
		<cfquery name="validaPP" datasource="#session.DSN#">
			select Pvalor 
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 540
		</cfquery>
		<cfif validaPP.recordcount gt 0 and validaPP.Pvalor eq 1>
			<cfset vValidaPresupuesto = true >
		</cfif>
		
		<cfset tipo = 0 > <!--- 0: Conta, 10:Presupuesto[cuentas no validas], 20: Presupuesto[no hay presupuesto] --->
	
		<cfinvoke component="rh.Componentes.RH_CuentasTipo" method="CuentasTipo" returnvariable="cuentas_tipo">
			<cfinvokeargument name="conexion" value="#session.DSN#">		
			<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#">
			<cfinvokeargument name="RCNid" value="#Form.RCNid#">
			<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#">
			<cfinvokeargument name="CBid" value="#Form.CBid#">
			<cfinvokeargument name="debug" value="false">
		</cfinvoke>
		<!--- 1.1 VALIDACION DE CONTABILIDAD --->
		<cfif vInterfazContable and cuentas_tipo.recordcount gt 0 >
			<cfinclude template="../../nomina/operacion/ResultadoCalculo-errores.cfm">
			<cfabort>
		</cfif>
		
		<!--- 1.2 CUENTAS FINANCIERAS INVALIDAS --->
		<cfquery name="errores_pres" datasource="#session.DSN#">
			select Cformato, tiporeg, montores
			from RCuentasTipo
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
			  and CFcuenta = -1
			order by Cformato
		</cfquery>
	
		<cfif vInterfazContable and errores_pres.recordcount gt 0 >
			<cfset tipo = 10 >
			<cfinclude template="../../nomina/operacion/ResultadoCalculo-errores.cfm">
			<cfabort>
		</cfif>
	
		<!--- 2. VALIDACION DE PRESUPUESTO --->
		<cfif vValidaPresupuesto>
			<cfif errores_pres.recordcount gt 0 >
				<cfset tipo = 10 >
				<cfinclude template="../../nomina/operacion/ResultadoCalculo-errores.cfm">
				<cfabort>
			</cfif>

			<!--- 2.1 VALIDACION PRESUPUESTARIA: Cuentas Financieras con Presupuesto asociadas a Tiporeg que no verifican presupuesto  --->
			<cfquery name="errores_pres" datasource="#session.DSN#">
				select distinct ct.Cformato,cf.CFdescripcion,ct.Periodo,ct.Mes, ct.tiporeg, ct.montores
				  from RCuentasTipo ct
					inner join CFinanciera cf
						 ON cf.CFcuenta = ct.CFcuenta
					inner join CPVigencia v
						inner join PCEMascaras m
							 ON m.PCEMid 		= v.PCEMid
							AND m.PCEMformatoP 	is not null 
						 ON v.Ecodigo	= #session.Ecodigo#
						and v.Cmayor	= substring(ct.Cformato,1,4)
						and Periodo*100+Mes between CPVdesdeAnoMes and CPVhastaAnoMes
				 where ct.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
				   and ct.vpresupuesto = 0
			</cfquery>
			<cfif errores_pres.recordCount GT 0>
				<cfset tipo = 20> <!--- ERRORES --->
				<cfinclude template="../../nomina/operacion/ResultadoCalculo-errores.cfm">
				<cfabort>
			</cfif>
	
			<!--- Verfica la Moneda --->
			<cfquery name="rsSQL" datasource="#session.DSN#">
				select Mcodigo 
				  from Empresas
				 where Ecodigo = #session.Ecodigo# 
			</cfquery>
			<cfset LvarMcodigo 	= rsSQL.Mcodigo>
			<cfset LvarTC		= 1.00>
			
			<!--- 2.0 VALIDACION PRESUPUESTARIA: Verifica Disponible de la Cuenta  --->
			<!--- LLAMAR COMPONENTE DE PRES Y HACER LA VALIDACION PARA VER SI HAY PLATA O NO --->
			<cfquery name="rsDocumentos" datasource="#session.DSN#">
				select distinct Periodo, Mes
				  from RCuentasTipo
				 where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
			</cfquery>
			
			<cfinvoke component="sif.Componentes.PRES_Presupuesto" returnvariable="INT_PRESUPUESTO" method="CreaTablaIntPresupuesto" >
				<cfinvokeargument name="conIdentity" value="true" />
			</cfinvoke>
	
			<cfloop query="rsDocumentos">
				<cftransaction>
					<cfquery datasource="#session.DSN#">
						insert into #INT_PRESUPUESTO# 
							(
								ModuloOrigen,
								NumeroDocumento,
								NumeroReferencia,
								FechaDocumento,
								AnoDocumento,
								MesDocumento,
								CFcuenta,
								Ocodigo,
								Mcodigo,
								MontoOrigen,
								TipoCambio,
								Monto,
								TipoMovimiento
							)
						select 	'RHPN', '0', '0', 
								<cfqueryparam cfsqltype="cf_sql_date" value="#createDate(rsDocumentos.Periodo,rsDocumentos.Mes,1)#">, 
								#rsDocumentos.Periodo#, #rsDocumentos.Mes#,
								CFcuenta, Ocodigo,
								#LvarMcodigo#, sum(round(a.montores,2)), #LvarTC#, sum(round(a.montores*#LvarTC#,2)), 
								'E'
						  from RCuentasTipo a
						 where a.RCNid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
						   and a.Periodo 	= #rsDocumentos.Periodo#
						   and a.Mes 		= #rsDocumentos.Mes#
						   and a.vpresupuesto = 1
						group by a.Ocodigo, a.CFcuenta
					</cfquery>

					<cfinvoke
						 component		= "sif.Componentes.PRES_Presupuesto"
						 method			= "ControlPresupuestario"
						 returnvariable	= "LvarNAP">
								<cfinvokeargument name="ModuloOrigen"  		value="RHPN"/>
								<cfinvokeargument name="NumeroDocumento" 	value="0"/>
								<cfinvokeargument name="NumeroReferencia" 	value="0"/>
								<cfinvokeargument name="FechaDocumento" 	value="#createDate(rsDocumentos.Periodo,rsDocumentos.Mes,1)#"/>
								<cfinvokeargument name="AnoDocumento"		value="#rsDocumentos.Periodo#"/>
								<cfinvokeargument name="MesDocumento"		value="#rsDocumentos.Mes#"/>
								<cfinvokeargument name="SoloConsultar"		value="true"/>
								<cfinvokeargument name="VerErrores"			value="true"/>
					</cfinvoke>
				</cftransaction>
	
				<cfquery name="rsConError" dbtype="query">
					select 	count(1) as Cantidad
					  from Request.rsIntPresupuesto
					 where ConError = 2
				</cfquery>
	
				<cfquery name="errores_pres" dbtype="query">
					select 
							CuentaFinanciera 	as Cformato,
							CuentaPresupuesto 	as CPformato,
							CodigoOficina,
							AnoDocumento 		as Periodo,
							MesDocumento 		as Mes,
							DisponibleAnterior,
							SignoMovimiento * Monto as Monto,
							NRPsPendientes,
							ExcesoNeto,
							ConError,
							MSG
					  from Request.rsIntPresupuesto
					 where ConError <> 0
				</cfquery>
				<cfif errores_pres.recordcount gt 0>
					<cfif rsConError.Cantidad GT 0 OR LvarNAP LT 0>
						<cfset tipo = 21> <!--- ERRORES: si hay ConError=2 o se rechazó el Doc --->
						<cfinclude template="../../nomina/operacion/ResultadoCalculo-errores.cfm">
						<cfabort>
					<cfelse>
						<cfset tipo = 22> 	<!--- SOLO WARNINGS: solo hay ConError=1 (sin fondos) pero no hubo NRP. IGUAL QUE 21 PERO PONE FORM.btnSeguir --->
						<cfinclude template="../../nomina/operacion/ResultadoCalculo-errores.cfm">
						<cfabort>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>

	<cfset Form.CBcc = trim(Form.CBcc)>
	<!--- update a RCalculoNomina ( Bid, CBid, CBcc, Mcodigo, RCtc ) [BARODA] --->
	<cfquery datasource="#session.DSN#">
		update RCalculoNomina
		set Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">,
			CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">, 
			CBcc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CBcc#">,
			Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
			RCtc = <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.tipo_cambio, ',','','all')#">
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
	</cfquery>
	<cfinvoke component="rh.Componentes.RH_PosteoRelacion" method="PosteoRelacion" >
		<cfinvokeargument name="conexion" value="#session.DSN#">		
		<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#">
		<cfinvokeargument name="RCNid" value="#Form.RCNid#">
		<cfinvokeargument name="CBcc"  value="#Form.CBcc#" >
		<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#">
		<cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#">
		<cfinvokeargument name="debug" value="false">
	</cfinvoke>


</cfif>
<html><body>
<form action="RelacionCalculoRetro-lista.cfm" method="post">
<input name="a" type="hidden" value="0" />
</form>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body></html>
