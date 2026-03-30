<!---
	Creado por Gustavo Fonseca / Muaricio E.
	Fecha: 1-32-007.
	Motivo: Soportar el proceso de Cierre Anual.
--->

<cfcomponent>
	<cffunction name="AsientoLiquida" access="public" output="true">
		<cfargument name="CMayor" 			type="string" 	required="yes"><!--- Cuenta Mayor --->
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes"><!--- Código de Empresa (sif) --->
		<cfargument name="NivelParametro" 	type="numeric" 	required="yes"><!--- Nivel en estructura de la cuenta --->
		<cfargument name="Periodo" 			type="numeric" 	required="yes"><!--- Periódo --->
		<cfargument name="Mes" 				type="numeric" 	required="yes"><!--- Mes --->
		<cfargument name="Cconcepto"		type="numeric" 	required="yes"><!--- Mes --->
		<cfargument name="Ocodigo" 			type="numeric" 	default="-1" 			required="no"><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="conexion"			type="string" 	default="#Session.DSN#" required="no">
		<cfargument name="debug" 			type="boolean" 	default="false" 		required="no">

		<!--- Asiento Tipo 1 (Liquidación) --->
		
		<!--- Parametros:  
			-Cuenta Mayor
			-Empresa (Ecodigo)
			-NivelParametro
			-Periodo 
			-Mes
		 --->
        <cfinclude template="../Utiles/sifConcat.cfm">
		<cfset Arguments.CMayor = right("0000" & trim(Arguments.CMayor), 4)>

		<cfif arguments.debug>
			<cfdump var="#arguments#" label="arguments">
		</cfif>
		
		<cfset LvarSiguientePeriodo = Arguments.Periodo>
		<cfset LvarSiguienteMes = Arguments.Mes + 1>
		<cfif LvarSiguienteMes GT 12>
			<cfset LvarSiguientePeriodo = LvarSiguientePeriodo + 1>
			<cfset LvarSiguienteMes =  1>
		</cfif>
        <cfset LvarMilisegundos = gettickcount()>
		<br>Generando Tablas de Trabajo ...... <cfoutput>Inicio #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>
		<cf_dbtemp name="cuentas" returnvariable="cuentas" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="Ecodigo"  	type="int"      	mandatory="yes">
			<cf_dbtempcol name="Cmayor"   	type="char(4)"     	mandatory="yes">
			<cf_dbtempcol name="Ccuenta"   	type="numeric"      mandatory="yes">
			<cf_dbtempcol name="Nivel"   	type="int"     		mandatory="yes">
		</cf_dbtemp>
		
		
		<cf_dbtemp name="ctasceroV3" returnvariable="ctascero" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="Ccuenta"   	      type="numeric"  mandatory="yes">
			<cf_dbtempcol name="Ocodigo"  	      type="int"      mandatory="yes">
			<cf_dbtempcol name="Periodo"   	      type="int"      mandatory="yes">
			<cf_dbtempcol name="Mes"   		      type="int"      mandatory="yes">
			<cf_dbtempcol name="Mcodigo"   	      type="numeric"  mandatory="yes">
			<cf_dbtempcol name="Ecodigo"   	      type="int"      mandatory="yes">
			<cf_dbtempcol name="SaldoInicial"     type="money"    mandatory="yes">
			<cf_dbtempcol name="SaldoInicialCalc" type="money"    mandatory="yes">
			<cf_dbtempcol name="CantidadHijas"    type="int"      mandatory="yes">
			
		</cf_dbtemp>
		
		<!--- Insertar el Nivel de Cuenta de Mayor --->
		<cfset LvarNivel = 0>
        <cfoutput>Fin #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>

	    <cfset LvarMilisegundos = gettickcount()>
		<br>Insertando Cuenta  de Nivel <strong>Mayor</strong> para la cuenta #arguments.cmayor# en la tabla de trabajo......<cfoutput>Inicio #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>
		<cfflush>
		<cfflush interval="10">
		<cfquery datasource="#arguments.conexion#">
			insert into #cuentas# (Ecodigo, Cmayor, Ccuenta, Nivel)
				select c.Ecodigo, c.Cmayor, c.Ccuenta, 0
				from CtasMayor m
					inner join CContables c
						on  c.Ecodigo  = m.Ecodigo
						and c.Cmayor   = m.Cmayor
						and c.Cformato = m.Cmayor
				where m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">	
				  and m.Cmayor  = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.cmayor#">	
		</cfquery>
	
		<cfloop condition="LvarNivel LT arguments.NivelParametro"> 
	    	<cfset LvarMilisegundos2 = gettickcount()>
			<br>Insertando Cuentas de Nivel <strong>#LvarNivel + 1#</strong> para la cuenta #arguments.cmayor# en la tabla de trabajo......<cfoutput>#dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>

			<cfquery datasource="#arguments.conexion#">
				insert into #cuentas# (Ecodigo, Cmayor, Ccuenta, Nivel)
					select c.Ecodigo, c.Cmayor, c.Ccuenta, #LvarNivel + 1# 
					from #cuentas# a
						inner join CContables c
							on c.Cpadre = a.Ccuenta
					where a.Nivel = #LvarNivel#
			</cfquery>

            <cfoutput>Fin #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos2#</cfoutput><br>
			<cfset LvarNivel = LvarNivel + 1>
		</cfloop>
		<br>

	    <cfset LvarMilisegundos = gettickcount()>
		<br>Borrando las Cuenta Menores del Nivel <strong>#LvarNivel#</strong> para la cuenta #arguments.cmayor# en la tabla de trabajo...... <cfoutput>#dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>
		<cfquery datasource="#arguments.conexion#">
			delete 
			from #cuentas#
			where Nivel <> #arguments.NivelParametro#
		</cfquery>
        <cfoutput>Fin #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>

		<cfif arguments.debug>
			<cfquery name="rsdebug" datasource="#arguments.conexion#">
				select c.Cformato 
				from #cuentas# a
					inner join CContables c
						on c.Ccuenta = a.Ccuenta
				where a.Nivel = #arguments.NivelParametro#
				order by c.Cformato
			</cfquery>
			<cfdump var="#rsdebug#">
		</cfif>

		<!--- Mauricio Esquivel.  Bitácora adicional 7/Feb/2011 --->
		<cfquery name="rsdebug" datasource="#arguments.conexion#">
			select count(1) as Cantidad from #cuentas#
		</cfquery>
		<br>Se encontraron: <cfoutput>#rsdebug.Cantidad# cuentas del nivel #arguments.NivelParametro# para la Cuenta #arguments.cmayor#</cfoutput> en la tabla de trabajo...... <br>
		<!--- Mauricio Esquivel.  Fin Bitácora adicional 7/Feb/2011 --->


	    <cfset LvarMilisegundos = gettickcount()>
		<br>Insertar las oficinas (Segmento) para generar todas las cuentas a procesar de la Cuenta #arguments.cmayor# en la tabla de trabajo...... <cfoutput>Inicio #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>
		<cfquery datasource="#arguments.conexion#">
			insert into #ctascero# (Ccuenta, Ocodigo, Periodo, Mes, Mcodigo, Ecodigo, SaldoInicial, SaldoInicialCalc, CantidadHijas)
			select a.Ccuenta, o.Ocodigo, #LvarSiguientePeriodo#, #LvarSiguienteMes#, m.Mcodigo, a.Ecodigo, 0.00, 0.00, 0
			from #cuentas# a
				inner join Oficinas o
					on o.Ecodigo = a.Ecodigo
					<cfif arguments.Ocodigo GTE 0>
					and o.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ocodigo#">
					</cfif>
				inner join Monedas m
					on m.Ecodigo = a.Ecodigo
		</cfquery>
        <cfoutput>Fin #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>

		<!--- Mauricio Esquivel.  Bitácora adicional 7/Feb/2011 --->
		<cfquery name="rsdebug" datasource="#arguments.conexion#">
			select count(1) as Cantidad from #ctascero#
		</cfquery>
		<br>Se encontraron: <cfoutput>#rsdebug.Cantidad#</cfoutput> combinaciones de cuenta - Oficina para la Cuenta <cfoutput>#arguments.cmayor#</cfoutput> en la tabla de trabajo...... <br>
		<!--- Mauricio Esquivel.  Fin Bitácora adicional 7/Feb/2011 --->
		
	    <cfset LvarMilisegundos = gettickcount()>
		<br>Determinando el saldo inicial a #LvarSiguientePeriodo#-#LvarSiguienteMes# de las cuentas del nivel para la Cuenta #arguments.cmayor# en la tabla de trabajo...... <cfoutput>Inicio #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>
		<!--- 
			Generar el saldo inicial de las cuentas, 
			sumarizando el saldo de las cuentas de detalle ( pues las cuentas con saldo en cero no están en SaldosContables ) 
			
			Las cuentas que no se encuentran ( no tienen hijas ) se generan con un valor de 0.001 para que sean eliminadas!.  Esto se genera con el coalesce
		--->
		<cfquery datasource="#arguments.conexion#">
			update #ctascero# 
			set 
				SaldoInicialCalc = coalesce(( 
						select sum(s.SLinicial)
						from PCDCatalogoCuenta cu
							inner join CContables c
							   on c.Ccuenta     = cu.Ccuenta
							inner join SaldosContables s
							   on s.Ccuenta   = c.Ccuenta
							  and s.Ocodigo   = #ctascero#.Ocodigo
							  and s.Speriodo  = #ctascero#.Periodo
							  and s.Smes      = #ctascero#.Mes
							  and s.Mcodigo   = #ctascero#.Mcodigo
							  and s.Ecodigo   = c.Ecodigo
						where cu.Ccuentaniv   = #ctascero#.Ccuenta
						  and cu.PCDCniv = #arguments.NivelParametro#
						  and c.Cmovimiento   = 'S'
					), 0.00),
				CantidadHijas = coalesce(( 
						select count(1)
						from PCDCatalogoCuenta cu
							inner join CContables c
							   on c.Ccuenta     = cu.Ccuenta
							inner join SaldosContables s
							   on s.Ccuenta   = c.Ccuenta
							  and s.Ocodigo   = #ctascero#.Ocodigo
							  and s.Speriodo  = #ctascero#.Periodo
							  and s.Smes      = #ctascero#.Mes
							  and s.Mcodigo   = #ctascero#.Mcodigo
							  and s.Ecodigo   = c.Ecodigo
						where cu.Ccuentaniv   = #ctascero#.Ccuenta
						  and cu.PCDCniv = #arguments.NivelParametro#
						  and c.Cmovimiento   = 'S'
					), 0.00)
		</cfquery>
        <cfoutput>Fin #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#<br></cfoutput>
		<cfquery datasource="#arguments.conexion#">
			update #ctascero# 
			set SaldoInicial = coalesce(( 
						select sum(s.SLinicial)
						from SaldosContables s
						where s.Ccuenta       = #ctascero#.Ccuenta
						  and s.Ocodigo       = #ctascero#.Ocodigo
						  and s.Speriodo      = #ctascero#.Periodo
						  and s.Smes          = #ctascero#.Mes
						  and s.Mcodigo       = #ctascero#.Mcodigo
						  and s.Ecodigo       = #ctascero#.Ecodigo
					), 0.00)
		</cfquery>
        <cfoutput>Fin #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#<br></cfoutput>

	    <cfset LvarMilisegundos = gettickcount()>
		<br>Borrar las cuentas que tienen saldo inicial diferente de cero de la Cuenta #arguments.cmayor# en la tabla de trabajo...... <cfoutput>Inicio #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>
		<!--- 
			Borrar las cuentas que se insertaron y que no estén en cero, 
			sea en la suma de las cuentas hijas (mayorización) 
			o en el saldo propio de la cuenta que se está evaluando
		--->
		<cfquery datasource="#arguments.conexion#">
			delete from #ctascero#
			where SaldoInicialCalc <> 0 
			   or SaldoInicial <> 0
			   or SaldoInicial <> SaldoInicialCalc
			   or CantidadHijas = 0
		</cfquery>
        <cfoutput>Fin #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#<br></cfoutput>

		<!--- Mauricio Esquivel.  Bitácora adicional 7/Feb/2011 --->
		<cfquery name="rsdebug" datasource="#arguments.conexion#">
			select count(1) as Cantidad from #ctascero#
		</cfquery>
		<br>Se encontraron: <cfoutput>#rsdebug.Cantidad#</cfoutput> cuentas con saldo inicial igual a cero para la Cuenta <cfoutput>#arguments.cmayor#</cfoutput> en la tabla de trabajo...... <br>
		<!--- Mauricio Esquivel.  Fin Bitácora adicional 7/Feb/2011 --->

		<!--- Mauricio Esquivel.  Bitácora adicional 7/Feb/2011 --->
		<cfquery name="rsdebug" datasource="#arguments.conexion#">
			select c.Cformato as Cuenta, a.Ocodigo as Oficina, a.Mcodigo as Moneda, a.SaldoInicial as SaldoInicial, a.SaldoInicialCalc as SaldoInicialCalc, a.CantidadHijas as CantidadHijas 
			from #ctascero# a
				inner join CContables c
				on c.Ccuenta = a.Ccuenta
			order by c.Cformato, a.Ocodigo, a.Mcodigo
		</cfquery>
		<br>
		<table>
			<td>Cuenta</td>
			<td>Oficina</td>
			<td>Moneda</td>
			<td>Saldo Inicial</td>
			<td>Saldo Inicial Mayorizado</td>
			<td>Cantidad Hijas</td>
			<cfoutput query="rsdebug">
				<td>#rsdebug.Cuenta#</td>
				<td>#rsdebug.Oficina#</td>
				<td>#rsdebug.Moneda#</td>
				<td>#rsdebug.SaldoInicial#</td>
				<td>#rsdebug.SaldoInicialCalc#</td>
				<td>#rsdebug.CantidadHijas#</td>
			</cfoutput>
		</table>
		<br>Se encontraron: <cfoutput>#rsdebug.recordcount#</cfoutput> cuentas con saldo inicial igual a cero para la Cuenta <cfoutput>#arguments.cmayor#</cfoutput> en la tabla de trabajo...... <br>
		<!--- Mauricio Esquivel.  Fin Bitácora adicional 7/Feb/2011 --->


	    <cfset LvarMilisegundos = gettickcount()>
		<br>Buscar si existen asientos sin aplicar para las cuentas que tienen saldo cero de la Cuenta #arguments.cmayor# en la tabla de trabajo...... <cfoutput>Inicio #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>
		<cfquery name="rsVerificaAsientosPendientes" datasource="#arguments.conexion#">
			select count(1) as Cantidad
			from #ctascero# a
				inner join PCDCatalogoCuenta cu
					inner join DContables da
					 on da.Ccuenta = cu.Ccuenta
					and da.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Periodo#">
					and da.Emes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Mes#">
				on cu.Ccuentaniv = a.Ccuenta
		</cfquery>
		<cfif rsVerificaAsientosPendientes.Cantidad GT 0>
			<cf_errorCode	code = "51040"
							msg  = "Se encontraron @errorDat_1@ movimientos en Asientos de Diario sin aplicar, que corresponden a cuentas que se desean procesar. El proceso no se puede ejecutar!"
							errorDat_1="#rsVerificaAsientosPendientes.Cantidad#"
			>
		</cfif>
		<!--- Mauricio Esquivel.  Bitácora adicional 7/Feb/2011 --->
		<br>Se encontraron: <cfoutput>#rsVerificaAsientosPendientes.Cantidad#</cfoutput> movimientos posteriores para la Cuenta <cfoutput>#arguments.cmayor#</cfoutput> en la tabla de trabajo...... <br>
		<!--- Mauricio Esquivel.  Fin Bitácora adicional 7/Feb/2011 --->
		
		<cfif arguments.debug>
			<cfquery name="rsdebug" datasource="#arguments.conexion#">
				select 
					cu.Ccuenta, 
					a.Ocodigo, 
					a.Mcodigo, 
					abs(s.SLinicial) as Local,
					abs(s.SOinicial) as Extranjero,
					case when s.SLinicial > 0.00 then 'C' else 'D' end as Tipo
				from #ctascero# a
					inner join PCDCatalogoCuenta cu
						on cu.Ccuentaniv = a.Ccuenta
					inner join SaldosContables s
						 on s.Ccuenta   = cu.Ccuenta
						and s.Mcodigo   = a.Mcodigo
						and s.Speriodo  = a.Periodo
						and s.Smes      = a.Mes
						and s.Ocodigo   = a.Ocodigo
						and s.SLinicial <> 0
				 <cfif arguments.Ocodigo GTE 0>
					where a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ocodigo#">
				</cfif>
			</cfquery>

			<cfquery name="rsdebug2" datasource="#arguments.conexion#">
				select * from #ctascero#
			</cfquery>
			
			<cfquery name="rsdebug3" datasource="#arguments.conexion#">
				select 
						'CGDC',
						1,
						'Cierre Anual ' #_Cat# c.Cmayor,
						c.Cmayor,
						abs(s.SLinicial) as Local,
						case when s.SLinicial > 0.00 then 'C' else 'D' end as Tipo,
						'Liquidación Cuenta ' #_Cat# rtrim(ltrim(c.Cdescripcion)),
						convert(varchar,getdate(),112),
						1.00,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Periodo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Mes#">,
						cu.Ccuenta, 
						a.Mcodigo, 
						a.Ocodigo, 
						abs(s.SOinicial) as Extranjero
					from #ctascero# a
						inner join PCDCatalogoCuenta cu <cf_dbforceindex name="PCDCatalogoCuenta_04">

								inner join CContables c <cf_dbforceindex name="PK_CCONTABLES">
								 on c.Ccuenta = cu.Ccuenta
								and c.Cmovimiento = 'S'

						 on cu.Ccuentaniv = a.Ccuenta
						and cu.PCDCniv    = #arguments.NivelParametro#

						inner join SaldosContables s <cf_dbforceindex name="PK_SALDOSCONTABLES">
						 on s.Ccuenta   = c.Ccuenta
						and s.Speriodo  = a.Periodo
						and s.Smes      = a.Mes
						and s.Ecodigo   = c.Ecodigo
						and s.Ocodigo   = a.Ocodigo
						and s.Mcodigo   = a.Mcodigo
						and s.SLinicial <> 0
			</cfquery>
			<cfdump var="#arguments#">
			<cfdump var="#rsdebug#"  label="rsdebug">
			<cfdump var="#rsdebug2#" label="RSDEBUG2">
			<cfdump var="#rsdebug3#" label="rsdebug3">
			<cf_abort errorInterfaz="">
		</cfif>
		
		<!---  Creación de la tabla INTARC ----->
		<cfinvoke component="CG_GeneraAsiento" returnvariable="Intarc" method="CreaIntarc" ></cfinvoke>	
        <cfoutput>Fin #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>

	    <cfset LvarMilisegundos = gettickcount()>
        
		<br>Insertando la información del Asiento para la Cuenta #arguments.cmayor# ...... <cfoutput>Inicio #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>
		<!--- Inserta el asiento contable --->
		<cfquery name="rsInsertAsientoCont" datasource="#arguments.conexion#">
			insert INTO #Intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
				select 
					'CGDC',
					1,
					'Cierre Anual ' #_Cat# c.Cmayor,
					c.Cmayor,
					abs(s.SLinicial) as Local,
					case when s.SLinicial > 0.00 then 'C' else 'D' end as Tipo,
					'Liquidación Cuenta ' #_Cat# rtrim(ltrim(c.Cdescripcion)),
					'#dateformat(now(), "DDMMYYYY")#',
					1.00,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Periodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Mes#">,
					c.Ccuenta, 
					a.Mcodigo, 
					a.Ocodigo, 
					abs(s.SOinicial) as Extranjero
				from #ctascero# a
					inner join PCDCatalogoCuenta cu <!--- <cf_dbforceindex name="PCDCatalogoCuenta_04"> --->
						on  cu.Ccuentaniv = a.Ccuenta
					inner join CContables c <!--- <cf_dbforceindex name="PK_CCONTABLES"> --->
						on c.Ccuenta = cu.Ccuenta
					inner join SaldosContables s <!--- <cf_dbforceindex name="PK_SALDOSCONTABLES"> --->
						 on s.Ccuenta   = c.Ccuenta
						and s.Speriodo  = a.Periodo
						and s.Smes      = a.Mes
						and s.Ecodigo   = c.Ecodigo
						and s.Ocodigo   = a.Ocodigo
						and s.Mcodigo   = a.Mcodigo
				where s.SLinicial <> 0
				  and cu.PCDCniv = #arguments.NivelParametro#
				  and c.Cmovimiento = 'S'
		</cfquery>

		<cfif arguments.debug>
			<cfquery name="verificaINTARC" datasource="#Arguments.Conexion#">
				select count(1) as Cantidad 
				from #Intarc#
				where INTMOE <> 0.00 or INTMON <> 0.00
			</cfquery>
			<cfdump var="#verificaINTARC#">
			<cf_abort errorInterfaz="">
		</cfif>
        
        <cfoutput>Fin #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#<br></cfoutput>

	    <cfset LvarMilisegundos = gettickcount()>
		<br>Generando el Asiento para la Cuenta #arguments.cmayor# ...... <cfoutput>Inicio #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>
		<cftransaction>
			<!--- Genera Asiento --->
			<cfif arguments.Ocodigo GTE 0>
				<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="IDcontable">
					<cfinvokeargument name="Conexion" value="#Arguments.Conexion#"/>
					<cfinvokeargument name="Ecodigo" value="#Arguments.Ecodigo#"/>
					<cfinvokeargument name="Oorigen" value="CGDC"/>
					<cfinvokeargument name="Cconcepto" value="#arguments.Cconcepto#"/>
					<cfinvokeargument name="Eperiodo" value="#arguments.Periodo#"/>
					<cfinvokeargument name="Emes" value="#arguments.Mes#"/>
					<cfinvokeargument name="Efecha" value="#CreateDate(arguments.Periodo, arguments.Mes, 1)#"/>
					<cfinvokeargument name="Edescripcion" value="Cierre Anual Liquidación:  Cuenta:  #arguments.Cmayor#"/>
					<cfinvokeargument name="Edocbase" value="Cierre Anual"/>
					<cfinvokeargument name="Ereferencia" value="#arguments.CMayor#"/>
					<cfinvokeargument name="Ocodigo" value="#arguments.Ocodigo#"/>
					<cfinvokeargument name="CierreAnual" value="true"/>
					<cfinvokeargument name="Debug" value="#arguments.Debug#"/>
				</cfinvoke>
			<cfelse>
				<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="IDcontable">
					<cfinvokeargument name="Conexion" value="#Arguments.Conexion#"/>
					<cfinvokeargument name="Ecodigo" value="#Arguments.Ecodigo#"/>
					<cfinvokeargument name="Oorigen" value="CGDC"/>
					<cfinvokeargument name="Cconcepto" value="#arguments.Cconcepto#"/>
					<cfinvokeargument name="Eperiodo" value="#arguments.Periodo#"/>
					<cfinvokeargument name="Emes" value="#arguments.Mes#"/>
					<cfinvokeargument name="Efecha" value="#CreateDate(arguments.Periodo, arguments.Mes, 1)#"/>
					<cfinvokeargument name="Edescripcion" value="Cierre Anual Liquidación:  Cuenta:  #arguments.Cmayor#"/>
					<cfinvokeargument name="Edocbase" value="Cierre Anual"/>
					<cfinvokeargument name="Ereferencia" value="#arguments.CMayor#"/>
					<cfinvokeargument name="CierreAnual" value="true"/>
					<cfinvokeargument name="Debug" value="#arguments.Debug#"/>
				</cfinvoke>
			</cfif>
			
			<cfquery name="updEContable" datasource="#Arguments.Conexion#">
				update EContables
				set ECtipo = 1
				where IDcontable = #IDcontable#
			</cfquery>
		</cftransaction>
        <cfoutput>Fin #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>

		<!--- Mauricio Esquivel.  Bitácora adicional 7/Feb/2011 --->
		<cfquery name="rsdebug" datasource="#arguments.conexion#">
			select IDcontable as IDcontable, Cconcepto as Cconcepto, Edocumento as Edocumento, (( select count(1) from DContables d where d.IDcontable = EContables.IDcontable )) as cantidadlineas
			from EContables
			where IDcontable = #IDcontable#
		</cfquery>
		<cfif rsdebug.recordcount EQ 1>
			<br>El asiento fue generado con el número: <cfoutput>#rsdebug.Cconcepto# - #rsdebug.Edocumento#</cfoutput>, conteniendo #rsdebug.cantidadlineas# lineas para la Cuenta <cfoutput>#arguments.cmayor#</cfoutput><br>
		<cfelse>
			<br>NO se generó el asiento para la Cuenta <cfoutput>#arguments.cmayor#</cfoutput>.  Revise los mensajes anteriores ...... <br>
		</cfif>
		<!--- Mauricio Esquivel.  Fin Bitácora adicional 7/Feb/2011 --->


	</cffunction>
	
	<cffunction name="AsientoLimpia" access="public" output="true">
		<cfargument name="CMayor" 			type="string" 	required="yes"><!--- Cuenta Mayor --->
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes"><!--- Código de Empresa (sif) --->
		<cfargument name="mascara" 			type="string" 	required="yes"><!--- Mascara Cuenta Origen --->
		<cfargument name="mascara2" 		type="string" 	required="yes"><!--- Mascara ContraCuenta --->
		<cfargument name="Periodo" 			type="numeric" 	required="yes"><!--- Periódo --->
		<cfargument name="Mes" 				type="numeric" 	required="yes"><!--- Mes --->
		<cfargument name="Cconcepto"		type="numeric" 	required="yes"><!--- Mes --->
		<cfargument name="Ocodigo" 			type="numeric" 	required="no"    default="-1"><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name='conexion' 		type='string' 	required='false' default="#Session.DSN#">
		<cfargument name="debug" 			type="boolean"  required="no"	 default="false"><!--- si se prende simula la transacción, pinta los resultados y desahace los cambios --->
		
        <cfset var lVarErrorCta = 0>
		<cfset var lVarCtasError = ''>
        
		<cfinclude template="../Utiles/sifConcat.cfm">
		
		<cfset posicion1 = ''>
		<cfset posicion2 = ''>

		<cfset LvarSiguientePeriodo = Arguments.Periodo>
		<cfset LvarSiguienteMes = Arguments.Mes + 1>
		<cfif LvarSiguienteMes GT 12>
			<cfset LvarSiguientePeriodo = LvarSiguientePeriodo + 1>
			<cfset LvarSiguienteMes =  1>
		</cfif>

		<cfset Descripcion_Asiento = arguments.mascara>
		<cfset arguments.mascara = arguments.mascara & "%">
		
		<cfset LvarMilisegundos = gettickcount()>        
		<br>Generando Tablas de Trabajo para el proceso de limpieza ...... <cfoutput> Inicio #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>
		<!--- Asiento Tipo 2 --->
		<cf_dbtemp name="asiento2" returnvariable="asiento2" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="Ecodigo"  	type="int"      	mandatory="yes">
			<cf_dbtempcol name="Ccuenta"   	type="numeric"      mandatory="yes">
			<cf_dbtempcol name="Cformato"   type="varchar(100)" mandatory="yes">
			<cf_dbtempcol name="Ocodigo"   	type="int"     		mandatory="yes">
			<cf_dbtempcol name="Mcodigo"   	type="numeric"     	mandatory="yes">
			<cf_dbtempcol name="Local"   	type="money"     	mandatory="yes">
			<cf_dbtempcol name="Extranjero" type="money"     	mandatory="yes">
			<cf_dbtempcol name="Tipo"   	type="char(1)"     	mandatory="yes">
		</cf_dbtemp>
		<cfoutput> Fin #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>

        <cfset LvarMilisegundos = gettickcount()>        
		<br>Insertando información del asiento para el proceso de limpieza ...... <cfoutput>Inicio #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>
		<cfflush>
		<cfflush interval="10">
		<!--- Limpieza --->
		<cfquery datasource="#arguments.conexion#">
			insert into #asiento2# (Ecodigo, Ccuenta, Cformato, Ocodigo, Mcodigo, Local, Extranjero, Tipo)
			select 
				c.Ecodigo,
				c.Ccuenta, 
				c.Cformato,
				s.Ocodigo, 
				s.Mcodigo, 
				abs(s.SLinicial) as Local,
				abs(s.SOinicial) as Extranjero,
				case when s.SLinicial > 0.00 then 'C' else 'D' end as Tipo
			from CContables c <!--- <cf_dbforceindex name="CContables_04"> --->
				inner join SaldosContables s <!--- <cf_dbforceindex name="PK_SALDOSCONTABLES"> --->
				 on s.Ccuenta = c.Ccuenta
			where c.Cmayor       = '#arguments.Cmayor#'
			  and c.Ecodigo      =  #arguments.Ecodigo#
			  and c.Cformato  like '#arguments.mascara#'
			  and c.Cmovimiento  = 'S'
			  and s.Speriodo     = #LvarSiguientePeriodo#
			  and s.Smes         = #LvarSiguienteMes#
			  and s.SLinicial <> 0
		</cfquery>		
		
		<cfif arguments.debug>
			<cfquery name="rsasiento2" datasource="#arguments.conexion#">
				select *
				from #asiento2#
			</cfquery>
			<cfdump var="#rsasiento2#">
		</cfif>
		<cfoutput>Fin #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>

        <cfset LvarMilisegundos = gettickcount()>
		<br>Verificando que las cuentas seleccionadas para el proceso de limpieza no existan en un asiento sin aplicar ...... <cfoutput>Inicio #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>
		<cfquery name="rsVerificaAsientosPendientes" datasource="#arguments.conexion#">
			select count(1) as Cantidad
			from #asiento2# a
					inner join DContables da
					 on da.Ccuenta  = a.Ccuenta
					and da.Eperiodo = #arguments.Periodo#
					and da.Emes     = #arguments.Mes#
		</cfquery>

		<cfif rsVerificaAsientosPendientes.Cantidad GT 0>
			<cf_errorCode	code = "51040"
							msg  = "Se encontraron @errorDat_1@ movimientos en Asientos de Diario sin aplicar, que corresponden a cuentas que se desean procesar. El proceso no se puede ejecutar!"
							errorDat_1="#rsVerificaAsientosPendientes.Cantidad#"
			>
		</cfif>

		<cfoutput>Fin #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>

		<cfset LvarMilisegundos = gettickcount()>
        <br>Generando la contrapartida del asiento para las cuentas seleccionadas para el proceso de limpieza ...... <cfoutput>Inicio #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>
		<!--- Contracuenta --->
		<cfset LvarMasMide =  len(arguments.mascara2)>
		<cfset i = 0>

		<cfinvoke 
			method="FormatoDinamico"
			returnvariable="LvarvariableCformato"
			mascara="#Arguments.mascara#"
			mascara2="#Arguments.mascara2#"/>
		
		<cfoutput>Fin #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>
        
		<cfset LvarMilisegundos = gettickcount()>
		<br>Insertar la contrapartida del asiento para las cuentas seleccionadas para el proceso de limpieza ...... <cfoutput>#dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>
		<cfquery datasource="#arguments.conexion#">
			insert into #asiento2# (Ecodigo, Ccuenta, Cformato, Ocodigo, Mcodigo, Local, Extranjero, Tipo)
			select 
				Ecodigo,
				-1, 
				#PreserveSingleQuotes(LvarvariableCformato)# as Cuenta,
				Ocodigo, 
				Mcodigo, 
				sum(Local) as Local,
				sum(Extranjero) as Extranjero,
				case when Tipo = 'D' then 'C' else 'D' end as Tipo
			from #asiento2#
			group by 
				  Ecodigo
				<cfif find("substring", LvarvariableCformato)>
				, #PreserveSingleQuotes(LvarvariableCformato)#
				</cfif>
				, Ocodigo
				, Mcodigo
				, Tipo
		</cfquery>

		<cfif arguments.debug>
			<cfquery name="rsasiento2" datasource="#arguments.conexion#">
				select *
				from #asiento2#
			</cfquery>
			<cfdump var="#rsasiento2#">
		</cfif>

		<cfoutput>Fin #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>

		<cfset LvarMilisegundos = gettickcount()>
		<br>Complementar la información necesaria para el asiento a generar ...... <cfoutput> Inicio #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>
		<!---  Actualizacion del numero de cuenta para las que se encuentren --->
		<cfquery datasource="#arguments.conexion#">
			update #asiento2#
			set Ccuenta = coalesce(( select c.Ccuenta from CContables c where c.Cformato = #asiento2#.Cformato and c.Ecodigo = #asiento2#.Ecodigo) , -1)
			where Ccuenta = -1
		</cfquery>
		
		<cfoutput>Fin #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>

        <cfset LvarMilisegundos2 = gettickcount()>
		<br>Generando la cuenta para las contrapartidas que no existan en el Catalogo de Cuentas ...... <cfoutput>Inicio #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>
		<!--- Llamar a GeneraCuentaFinanciera para todos los registros que no se actualizaron (Ccuenta = -1) --->
		<cfquery name="rsGeneraCuentaFinanciera" datasource="#arguments.conexion#">
			select distinct 
				Ecodigo,
				Cformato
			from #asiento2#
			where Ccuenta = -1
		</cfquery>

		<cfif arguments.debug>
			<cfdump var="#rsGeneraCuentaFinanciera#">
		</cfif>
		
		<cfif rsGeneraCuentaFinanciera.recordcount gt 0>
			<cfset lVarCtasError = ''>
			<cfset Lprm_Fecha = createdate(Arguments.Periodo,Arguments.Mes,1)>
			<cfset Lprm_Fecha = dateadd('m', 1, Lprm_Fecha)>
			<cfset Lprm_Fecha = dateadd('d', -1, Lprm_Fecha)>

			<cfloop query="rsGeneraCuentaFinanciera">
	            <cfset LvarMilisegundos = gettickcount()>
				<br>Generando la cuenta #rsGeneraCuentaFinanciera.Cformato# que no existe en el Catalogo de Cuentas ...... <cfoutput>#dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>
				<cftransaction>
					<cfinvoke component="PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
						<cfinvokeargument name="Lprm_Cmayor"   value="#Left(Cformato,4)#"/>
						<cfinvokeargument name="Lprm_Cdetalle" value="#mid(Cformato,6,100)#"/>
						<cfinvokeargument name="Lprm_Fecha"    value="#Lprm_Fecha#"/>		
						<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
						<cfinvokeargument name="Lprm_DSN" value="#Arguments.Conexion#"/>
						<cfinvokeargument name="Lprm_Ecodigo" value="#Arguments.Ecodigo#"/>
						<cfinvokeargument name="Lprm_NoVerificarSinOfi" value="true"/>
						<cfinvokeargument name="Lprm_NoVerificarObras" value="true"/>
					</cfinvoke>
				</cftransaction>
				
				<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
					<cfset lVarCtasError = lVarCtasError & '<li> ' & Left(Cformato,4) & ' ' & LvarError & "</li>">
					<cfset lVarErrorCta = 1>
				</cfif>
		
        		<cfoutput>Fin Generando la cuenta #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>

		        <cfset LvarMilisegundos = gettickcount()>
				<br>Actualizar el número de la cuenta #rsGeneraCuentaFinanciera.Cformato# en la tabla de proceso ...... <cfoutput>#dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>
				<cfquery datasource="#arguments.conexion#">
					update #asiento2#
					set Ccuenta = coalesce(( select c.Ccuenta from CContables c where c.Cformato = #asiento2#.Cformato and c.Ecodigo = #asiento2#.Ecodigo) , -1)
					where Ccuenta = -1
					  and Cformato = '#rsGeneraCuentaFinanciera.Cformato#'
				</cfquery>
				<cfoutput>Fin Actualizar el número de la cuenta... #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput> <br>
			</cfloop>
		</cfif>
		<cfoutput><br>Fin de Generando la cuenta para las contrapartidas que no existan en el Catalogo de Cuentas #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos2#</cfoutput><br>

		<cfif Lvarerrorcta eq 1>
			<p><h3>Error! Existen Cuentas Incorrectas! Proceso Cancelado!</h3></p>
			<cfoutput>
			<ul>
			 #Replace(lVarCtasError,'<br>','</li><li>','all')#
			</ul>
			</cfoutput>
			<cf_abort errorInterfaz="">
		</cfif>
		
		<cfif arguments.debug>
			<cfquery name="rsdebug" datasource="#arguments.conexion#">
				select * from #asiento2#
			</cfquery>
			<cf_dump var="#rsdebug#">
		</cfif>
		
		<!---  Creación de la tabla INTARC ----->
		<cfinvoke component="CG_GeneraAsiento" returnvariable="Intarc" method="CreaIntarc" ></cfinvoke>	

		<cfset LvarMilisegundos = gettickcount()>
        
		<br>Construyendo información del asiento contable ...... <cfoutput>Inicio #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>
		<!--- Inserta el asiento contable --->
		<cfquery name="rsInsertAsientoCont" datasource="#arguments.conexion#">
			insert INTO #Intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
				select 
					'CGDC',
					1,
					'Cierre Anual' #_Cat# c.Cmayor,
					c.Cmayor,
					Local,
					Tipo,
					'Limpieza Cuenta ' #_Cat# rtrim(ltrim(c.Cdescripcion)),
					'#dateformat(now(), "YYYYMMDD")#',
					1.00,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Periodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Mes#">,
					a.Ccuenta, 
					a.Mcodigo, 
					a.Ocodigo, 
					Extranjero
				from #asiento2# a
						inner join CContables c
						on c.Ccuenta = a.Ccuenta
		</cfquery>
		<cfquery name="verificaINTARC" datasource="#Arguments.Conexion#">
			select count(1) as Cantidad 
			from #Intarc#
			where INTMOE <> 0.00 or INTMON <> 0.00
		</cfquery>
		<cfif arguments.debug>
			<cfdump var="#verificaINTARC#" label="verificaINTARC">
			<cf_abort errorInterfaz="">
		</cfif>
		<cfoutput>Fin #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>

	    <cfset LvarMilisegundos = gettickcount()>
		<br>Generando el asiento contable para la Limpieza Generada ...... <cfoutput>inicio #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>
		<cftransaction>
			<!--- Genera Asiento --->
			<cfif arguments.Ocodigo GTE 0>
				<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="IDcontable">
					<cfinvokeargument name="Conexion" 		value="#Arguments.Conexion#"/>
					<cfinvokeargument name="Ecodigo" 		value="#Arguments.Ecodigo#"/>
					<cfinvokeargument name="Oorigen" 		value="CGDC"/>
					<cfinvokeargument name="Cconcepto" 		value="#arguments.Cconcepto#"/>
					<cfinvokeargument name="Eperiodo" 		value="#arguments.Periodo#"/>
					<cfinvokeargument name="Emes" 			value="#arguments.Mes#"/>
					<cfinvokeargument name="Efecha" 		value="#CreateDate(arguments.Periodo, arguments.Mes, 1)#"/>
					<cfinvokeargument name="Edescripcion" 	value="Cierre Anual Limpieza:  Cuenta: #Descripcion_Asiento#"/>
					<cfinvokeargument name="Edocbase" 	 	value="Cierre Anual"/>
					<cfinvokeargument name="Ereferencia" 	value="#arguments.CMayor#"/>
					<cfinvokeargument name="Ocodigo" 	 	value="#arguments.Ocodigo#"/>
					<cfinvokeargument name="CierreAnual" 	value="true"/>
					<cfinvokeargument name="Debug" 		 	value="#arguments.Debug#"/>
				</cfinvoke>
			<cfelse>
				<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="IDcontable">
					<cfinvokeargument name="Conexion" 		value="#Arguments.Conexion#"/>
					<cfinvokeargument name="Ecodigo" 		value="#Arguments.Ecodigo#"/>
					<cfinvokeargument name="Oorigen" 		value="CGDC"/>
					<cfinvokeargument name="Cconcepto" 		value="#arguments.Cconcepto#"/>
					<cfinvokeargument name="Eperiodo" 		value="#arguments.Periodo#"/>
					<cfinvokeargument name="Emes" 			value="#arguments.Mes#"/>
					<cfinvokeargument name="Efecha" 		value="#CreateDate(arguments.Periodo, arguments.Mes, 1)#"/>
					<cfinvokeargument name="Edescripcion" 	value="Cierre Anual Limpieza:  Cuenta: #Descripcion_Asiento#"/>
					<cfinvokeargument name="Edocbase" 		value="Cierre Anual"/>
					<cfinvokeargument name="Ereferencia" 	value="#arguments.CMayor#"/>
					<cfinvokeargument name="CierreAnual" 	value="true"/>
					<cfinvokeargument name="Debug" 			value="#arguments.Debug#"/>
				</cfinvoke>
			</cfif>
			<cfquery name="updEContable" datasource="#Arguments.Conexion#">
				update EContables
				set ECtipo = 1
				where IDcontable = #IDcontable#
			</cfquery>
		</cftransaction>
        TERMINÓ con éxito... <cfoutput> FIN #dateformat(now(), 'dd/mm/yyyy hh:mm:ss')# Milisegundos: #gettickcount() - LvarMilisegundos#</cfoutput><br>
        
        
	</cffunction>
	
	<!--- 
	Ejemplo de lo que devuelve esta función:
	0012-__-0_-2584-_____-01% Máscara 1
	____-__-__-0___-999__-22-__ Máscara 2
	27 LvarMasMide:  Cuanto mide máscara 2
	substring(Cformato, 1, 5) + '-' + substring(Cformato, 6, 2) + '-' 
	+ substring(Cformato, 9, 2) + '-0' + substring(Cformato, 13, 3) + '-999' + substring(Cformato, 20, 2) 
	+ '-22-99' --->
	<cffunction name="FormatoDinamico" access="private" returntype="string" output="no">
		<cfargument name="mascara" type="string" required="yes"><!--- Nivel en estructura de la cuenta --->
		<cfargument name="mascara2" type="string" required="yes"><!--- Nivel --->
		
		<cfset issqlserver = false>
		
		<cfset posicion1 = 0>
		<cfset posicion2 = ''>
		
		<cfset mascara  = arguments.mascara>
		<cfset mascara2 = arguments.mascara2>
		
		<cfset LvarCarConcat = _Cat>
		
		<!--- Asegurarse de que la informacion sobre las conexiones este disponible --->
		<cfif not StructKeyExists(Application.dsinfo, #session.DSN#)>
			<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" datasource="#session.DSN#" />
		</cfif>
		<cfif not StructKeyExists(Application.dsinfo, #session.DSN#)>
			<cf_errorCode	code = "50599"
							msg  = "Datasource no definido: @errorDat_1@"
							errorDat_1="#HTMLEditFormat(Attributes.datasource)#"
			>
		</cfif>

		<!--- Contracuenta --->
				<cfset LvarMasMide =  len(mascara2)>
				<cfset i = 0>
				<!--- Saco las posiciones donde está el "_" de la máscara 1 --->
				<cfset posicion1 = FindNoCase('_',#mascara2#,#i#)-1>
				<cfset posicion2 = "">
				<cfset bandera = 0>
				<cfset variable = "'">
			
				<cfloop from="1" to="#Lvarmasmide#" index="i">
					<cfif bandera EQ 1>
						<cfif mid(mascara2,i,1) NEQ "_" >
							<cfif variable NEQ "'">
								<cfset variable = variable & " #LvarCarConcat# ">
							<cfelse>
								<cfset variable = "">
							</cfif>
							<cfset variable = variable & " substring(Cformato, #posinicial#, #i - posinicial #) #LvarCarConcat# '#mid(mascara2,i,1)#">
							<cfset bandera = 0>
						</cfif>
					<cfelse>
						<cfif mid(mascara2,i,1) EQ "_">
							<cfset posinicial = i>
							<cfset bandera = 1>
							<cfset variable = variable & "'">
						<cfelse>
							<cfset variable = variable & mid(mascara2, i, 1)>
						</cfif>
						
					</cfif>
				</cfloop>
				<cfif bandera EQ 1>
					<cfif len(variable)>
						<cfset variable = variable & #_Cat#>
					</cfif>
					<cfset variable = variable & " substring(Cformato, #posinicial#, #Lvarmasmide - posinicial + 1#) ">
				<cfelse>
					<cfset variable = variable & "'">
				</cfif>
		 <cfreturn variable>
	</cffunction>
</cfcomponent>

