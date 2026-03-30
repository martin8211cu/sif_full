<cfcomponent>
<!--- 
	Este SP seleccionara un conjunto de registros el cual sera el Balance de Comprobacion
--->
 	
	<cffunction name="CreaCuentas" access="public" output="false" returntype="string">
		<cf_dbtemp name="CG0004_cuentas">
			<cf_dbtempcol name="Ecodigo"  		type="int"    		mandatory="yes">			
			<cf_dbtempcol name="Ccuenta"		type="numeric">
			<cf_dbtempcol name="corte"  		type="int">
			<cf_dbtempcol name="nivel"  		type="int">
			<cf_dbtempcol name="tipo"  			type="char(1)">						
			<cf_dbtempcol name="ntipo"  		type="char(20)">
			<cf_dbtempcol name="mayor"  		type="char(4)">
			<cf_dbtempcol name="descrip"  		type="char(80)">
			<cf_dbtempcol name="formato"  		type="char(100)">
			<cf_dbtempcol name="saldoini"  		type="money">
			<cf_dbtempcol name="saldofin"  		type="money">			
			<cf_dbtempcol name="debitos"  		type="money">
			<cf_dbtempcol name="creditos"		type="money">
			<cf_dbtempcol name="movmes"			type="money">			
			<cf_dbtempcol name="Mcodigo"  		type="numeric">			
			<cf_dbtempcol name="Edescripcion" 	type="char(80)">			
			<cf_dbtempcol name="totdebitos"  	type="money">
			<cf_dbtempcol name="totcreditos"  	type="money">			
			<cf_dbtempcol name="totmovmes"  	type="money">
			<cf_dbtempcol name="totsaldofin"  	type="money">

 
			<cf_dbtempkey cols="Ccuenta">
		</cf_dbtemp>
		
		<cfreturn temp_table>		
	</cffunction>	
	
	<!--- Balance de Comprobacion --->
	<cffunction name='balanceComprob' access='public' output='true' returntype="query">
		<cfargument name='Ecodigo' type='numeric' required="yes">
		<cfargument name='Ocodigo' type='numeric' default="-1">		
		<cfargument name='periodo' type='numeric' required="yes">
		<cfargument name='mes' type='numeric' required="yes">
		<cfargument name='nivel' type='numeric' default="1">
		<cfargument name='Mcodigo' type='numeric' default="-2">
		<cfargument name='cuentaini' type='string' default="">
		<cfargument name='cuentafin' type='string' default=""> 				
		<cfargument name='ceros' type='string' default="N">				
		<cfargument name='debug' type='string' default="N">								
		<cfargument name='conexion' type='string' required='false' default="#Session.DSN#">
		
		<cftransaction>		
			<!--- Creacion de la tabla temporal de Cuentas --->
			<cfset cuentas = this.CreaCuentas()>
			
			<!--- Variables --->
			<cfset Monloc = -1>
			<cfset titulo = "">
			<cfset rangotipos = "">		
			<cfset Cdescripcion = "">
			<cfset nivelcuenta = -1>
			<cfset nivelactual = -1>
			<cfset nivelanteri = -1>
			<cfset cuentapiv = "">
	
			<cfquery name="rs_Monloc" datasource="#arguments.conexion#">
				select Mcodigo 
				from Empresas 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			</cfquery>
	
			<cfif isdefined('rs_Monloc') and rs_Monloc.recordCount GT 0>
				<cfset Monloc = rs_Monloc.Mcodigo>
			</cfif>
			
	
			<cfif arguments.cuentaini EQ ''>
				<cfquery name="rs_CuentaIni" datasource="#arguments.conexion#">
					select min(Cformato) as CformatoMin
					from CContables 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
				</cfquery>
	
				<cfif isdefined('rs_CuentaIni') and rs_CuentaIni.recordCount GT 0>
					<cfset arguments.cuentaini = rs_CuentaIni.CformatoMin>
				</cfif>
			</cfif>
			
			<cfif arguments.cuentafin EQ ''>
				<cfquery name="rs_Cuentafin" datasource="#arguments.conexion#">
					select max(Cformato) as CformatoMax
					from CContables 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
				</cfquery>
	
				<cfif isdefined('rs_Cuentafin') and rs_Cuentafin.recordCount GT 0>
					<cfset arguments.cuentafin = rs_Cuentafin.CformatoMax>
				</cfif>
			</cfif>			
			
			<cfif arguments.Mcodigo EQ Monloc>
				<cfset titulo = "Balance de Comprobación en Moneda Local">
			<cfelse>
				<cfquery name="rs_DesMoneda2" datasource="#arguments.conexion#">
					Select Mnombre 
					from Monedas 
					<cfif arguments.Mcodigo NEQ -2>
						where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">
					</cfif>
				</cfquery>
				
				<cfif isdefined('rs_DesMoneda2') and rs_DesMoneda2.recordCount GT 0>
					<cfset titulo = "Balance de Comprobación en Moneda " & rs_DesMoneda2.Mnombre>
				<cfelse>
					<cfset titulo = "Balance de Comprobación en Moneda X">
				</cfif>
			</cfif>
	
			<cfif arguments.cuentaini EQ '' and arguments.cuentafin EQ ''>
				<cfset rangotipos = "Todas las cuentas de Mayor">
			</cfif>
			
			<cfif arguments.cuentaini GT arguments.cuentafin>
				<cfset cuentapiv = arguments.cuentaini>
				<cfset arguments.cuentaini = arguments.cuentafin>				
				<cfset arguments.cuentafin = cuentapiv>				
			</cfif>
			
			<cfif arguments.cuentaini NEQ '' and  arguments.cuentafin EQ ''>
				<cfquery name="rs_DesCContables" datasource="#arguments.conexion#">
					select Cdescripcion
					from CContables
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					  and Cformato = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.cuentaini#">
				</cfquery>
	
				<cfif isdefined('rs_DesCContables') and rs_DesCContables.recordCount GT 0>
					<cfset rangotipos = "Desde la cuenta " & rs_DesCContables.Cdescripcion & " hasta el final del catálogo">
				<cfelse>
					<cfset rangotipos = "Desde la cuenta 'X' hasta el final del catálogo">
				</cfif>		
			</cfif>
	
			<cfif arguments.cuentaini EQ '' and  arguments.cuentafin NEQ ''>
				<cfquery name="rs_DesCContablesFin" datasource="#arguments.conexion#">
					select Cdescripcion
					from CContables
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					  and Cformato = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.cuentafin#">
				</cfquery>
	
				<cfif isdefined('rs_DesCContablesFin') and rs_DesCContablesFin.recordCount GT 0>
					<cfset rangotipos = "Desde el inicio del catálogo hasta la cuenta " & rs_DesCContablesFin.Cdescripcion>
				<cfelse>
					<cfset rangotipos = "Desde el inicio del catálogo hasta la cuenta 'X'">
				</cfif>		
			</cfif>
	
			<cfif arguments.cuentaini NEQ '' and  arguments.cuentafin NEQ ''>
				<cfquery name="rs_DesCContablesIni" datasource="#arguments.conexion#">
					select Cdescripcion 
					from CContables 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					  and Cformato = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.cuentaini#">
				</cfquery>
	
				<cfif isdefined('rs_DesCContablesIni') and rs_DesCContablesIni.recordCount GT 0>
					<cfset Cdescripcion = rs_DesCContablesIni.Cdescripcion>
				</cfif>		
	
				<cfquery name="rs_DesCContablesFin2" datasource="#arguments.conexion#">
					select Cdescripcion
					from CContables
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					  and Cformato = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.cuentafin#">
				</cfquery>
	
				<cfif isdefined('rs_DesCContablesFin2') and rs_DesCContablesFin2.recordCount GT 0>
					<cfset rangotipos = "Desde la Cuenta " & Cdescripcion & " hasta la Cuenta " & rs_DesCContablesFin2.Cdescripcion>
				<cfelse>
					<cfset rangotipos = "Desde la Cuenta " & Cdescripcion & " hasta la Cuenta 'X'">
				</cfif>		
			</cfif>

			<!--- Inserta las cuentas de Mayor --->
			<cfquery name="A_Cuentas" datasource="#arguments.conexion#">
				insert INTO #cuentas# (Ecodigo, mayor, descrip, Ccuenta, formato, saldoini, debitos, creditos, movmes, saldofin, tipo, nivel, Mcodigo)
				select #arguments.Ecodigo#, b.Cmayor, b.Cdescripcion, a.Ccuenta, a.Cformato, 0.00, 0.00, 0.00, 0.00, 0.00, b.Ctipo, 0, <cfif arguments.Mcodigo NEQ -2>#arguments.Mcodigo#<cfelse>null</cfif>
				from CtasMayor b, CContables a 
				where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
				  and b.Ecodigo = a.Ecodigo
				  and b.Cmayor = a.Cformato
			</cfquery>		
		

		
			<cfquery name="A_Cuentas" datasource="#arguments.conexion#">
				delete #cuentas#
				where mayor not in 	(
										select distinct Cmayor 
										from CContables 
										where Cformato between <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.cuentaini#">
											and <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.cuentafin#">
									)
			</cfquery>
			
			<cfset nivelactual = 1>
			<cfset nivelanteri = 0>
			<cfloop condition = "nivelactual LESS THAN arguments.nivel">
				<cfquery name="A2_Cuentas" datasource="#arguments.conexion#">
					insert INTO #cuentas# (Ecodigo, nivel, mayor, descrip, Ccuenta, formato, saldoini, debitos, creditos, movmes, saldofin, tipo, Mcodigo)					
					select 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
						, <cfqueryparam cfsqltype="cf_sql_integer" value="#nivelactual#">
						, b.Cmayor, b.Cdescripcion, b.Ccuenta, b.Cformato, 0.00, 0.00, 0.00, 0.00, 0.00, a.tipo
						, 	<cfif arguments.Mcodigo NEQ -2>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">
							<cfelse>
								null
							</cfif>
					from #cuentas# a, CContables b
					where a.nivel = <cfqueryparam cfsqltype="cf_sql_integer" value="#nivelanteri#">
					  and a.Ccuenta = b.Cpadre
					  and a.Ecodigo = b.Ecodigo
				</cfquery>

				<cfset nivelanteri = nivelactual>
				<cfset nivelactual = nivelactual + 1>
			</cfloop>

			<cfif arguments.debug EQ 'S'>
				<cfquery name="All_Cuentas" datasource="#arguments.conexion#">
					select Ecodigo, corte, nivel, tipo, ntipo, mayor, Ccuenta, descrip, formato, saldoini, debitos, creditos, movmes, saldofin, Mcodigo, Edescripcion, totdebitos, totcreditos, totmovmes, totsaldofin 
					from #cuentas#
				</cfquery>
				
				<cfif isdefined('All_Cuentas') and All_Cuentas.recordCount GT 0>
					<cfdump var="#All_Cuentas#" label="Cuentas TMP">
				</cfif>
			</cfif>
	
			<!--- Cálculo de Montos --->
			<cfif arguments.Mcodigo EQ -2>
				<cfquery name="C_CuentasTmp" datasource="#arguments.conexion#">
					update #cuentas# set 
									 saldoini = coalesce((select sum(SLinicial)
														  from SaldosContables
														  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
															<cfif arguments.Ocodigo EQ -1>
																and Ocodigo = Ocodigo
															<cfelse>
																and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ocodigo#">
															</cfif>
															and Ccuenta = #cuentas#.Ccuenta
															and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
															and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">)
													, 0.00),
							
									 debitos =  coalesce((select sum(DLdebitos)
														  from SaldosContables
														  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
															<cfif arguments.Ocodigo EQ -1>
																and Ocodigo = Ocodigo
															<cfelse>
																and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ocodigo#">
															</cfif>													  
															and Ccuenta = #cuentas#.Ccuenta
															and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
															and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">)
													, 0.00),
			
									 creditos =  coalesce((select sum(CLcreditos)
														  from SaldosContables
														  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
															<cfif arguments.Ocodigo EQ -1>
																and Ocodigo = Ocodigo
															<cfelse>
																and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ocodigo#">
															</cfif>
															and Ccuenta = #cuentas#.Ccuenta
															and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
															and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">)
													, 0.00)			
				</cfquery>
			<cfelse>
				<cfquery name="C_CuentasTmp" datasource="#arguments.conexion#">
					 update #cuentas# set 
						 saldoini = coalesce((select sum(SOinicial)
											  from SaldosContables a
											  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
												<cfif arguments.Ocodigo EQ -1>
													and Ocodigo = Ocodigo
												<cfelse>
													and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ocodigo#">
												</cfif>
												and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">											
												and Ccuenta = #cuentas#.Ccuenta
												and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
												and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
												and a.Mcodigo = #cuentas#.Mcodigo)
									, 0.00),
				
						 debitos =  coalesce((select sum(DOdebitos)
											  from SaldosContables a
											  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
												<cfif arguments.Ocodigo EQ -1>
													and Ocodigo = Ocodigo
												<cfelse>
													and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ocodigo#">
												</cfif>
												and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">
												and Ccuenta = #cuentas#.Ccuenta
												and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
												and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
												and a.Mcodigo = #cuentas#.Mcodigo)
									, 0.00),
				
						 creditos =  coalesce((select sum(COcreditos)
											  from SaldosContables a
											  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
												<cfif arguments.Ocodigo EQ -1>
													and Ocodigo = Ocodigo
												<cfelse>
													and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ocodigo#">
												</cfif>
												and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">
												and Ccuenta = #cuentas#.Ccuenta
												and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
												and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
												and a.Mcodigo = #cuentas#.Mcodigo)
									, 0.00)
				</cfquery>
			</cfif>
	
			<cfquery name="C_CuentasTmp2" datasource="#arguments.conexion#">
				update #cuentas# set 
					saldofin = saldoini + debitos - creditos,
					movmes = coalesce(debitos,0.00) - coalesce(creditos,0.00)
			</cfquery>
	
			<cfquery name="C_CuentasTmp3" datasource="#arguments.conexion#">
				update #cuentas# set 
						corte = 1, ntipo = 'Activo'
				where tipo = 'A'
			</cfquery>
	
			<cfquery name="C_CuentasTmp4" datasource="#arguments.conexion#">
				update #cuentas# set
						corte = 2, ntipo = 'Pasivo'
				where tipo = 'P'
			</cfquery>
	
			<cfquery name="C_CuentasTmp5" datasource="#arguments.conexion#">
				update #cuentas# set 
						corte = 3, ntipo = 'Capital'
				where tipo = 'C'
			</cfquery>
	
			<cfquery name="C_CuentasTmp6" datasource="#arguments.conexion#">
				update #cuentas# set
					corte = 4, ntipo = 'Ingreso'
				where tipo = 'I'
			</cfquery>
	
			<cfquery name="C_CuentasTmp7" datasource="#arguments.conexion#">
				update #cuentas# set
					corte = 6, ntipo = 'Gasto'
				where tipo = 'G'
			</cfquery>
	
			<cfquery name="C_CuentasTmp8" datasource="#arguments.conexion#">
				update #cuentas# set 
					corte = 7, ntipo = 'Orden'
				where tipo = 'O'
			</cfquery>
	
			<cfquery name="C_CuentasTmp9" datasource="#arguments.conexion#">
				update #cuentas# set
						 Edescripcion = (	select Edescripcion
											from Empresas a
											where  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
										)
			</cfquery>
		
			<cfset m1 = 0>
			<cfset m2 = 0>	
			<cfset m3 = 0>	
			<cfset m4 = 0>	
			<cfset m5 = 0>	
		
			<cfquery name="All_CuentasTmp10" datasource="#arguments.conexion#">
					select sum(saldoini) as SumSaldoini, sum(debitos) as SumDebitos, sum(creditos) as SumCreditos, sum(saldoini + debitos - creditos) as SalDevCred
				from #cuentas#
				where mayor = ltrim(rtrim(formato))
			</cfquery>
	
			<cfif isdefined('All_CuentasTmp10') and All_CuentasTmp10.recordCount GT 0>
				<cfset m1 = All_CuentasTmp10.SumSaldoini>
				<cfset m2 = All_CuentasTmp10.SumDebitos>
				<cfset m3 = All_CuentasTmp10.SumCreditos>
				<cfset m4 = All_CuentasTmp10.SalDevCred>
			</cfif>
	
			<cfset m5 = m2 - m3>
	
			<!--- Actualizar montos globales --->
			<cfquery name="All_Totales" datasource="#arguments.conexion#">
				Select (coalesce(sum(debitos), 0)) as todDev
						, (coalesce(sum(creditos), 0)) as totCred
						, (coalesce( (sum(debitos)-sum(creditos)), 0)) as  totDebCred
				from #cuentas#
				where mayor = ltrim(rtrim(formato))
			</cfquery>
	
			<cfquery name="C_Totales" datasource="#arguments.conexion#">
				update #cuentas# set 
					totdebitos = <cfqueryparam cfsqltype="cf_sql_money" value="#All_Totales.todDev#">,
					totcreditos = <cfqueryparam cfsqltype="cf_sql_money" value="#All_Totales.totCred#">,
					totmovmes = <cfqueryparam cfsqltype="cf_sql_money" value="#All_Totales.totDebCred#">
				where mayor = ltrim(rtrim(formato))
			</cfquery>
	
			<cfquery name="All_TotSaldoFin" datasource="#arguments.conexion#">
				select (sum(saldofin)) as TotSaldoFin
				from #cuentas#
			</cfquery>
		
			<cfquery name="All_CuentasTmp11" datasource="#arguments.conexion#">
				update #cuentas# set totsaldofin = <cfqueryparam cfsqltype="cf_sql_money" value="#All_TotSaldoFin.TotSaldoFin#">
			</cfquery>
			
			<cfif arguments.ceros EQ 'N'>
				<cfquery name="All_CuentasTmp12" datasource="#arguments.conexion#">
					delete #cuentas# 
					where saldoini = 0.00 
						and debitos = 0.00 
						and creditos = 0.00 
						and movmes = 0.00
				</cfquery>
			</cfif>

			<cfquery name="rs_Resultante" datasource="#arguments.conexion#">
				select 
					Edescripcion as Empresa,
					corte,
					nivel,
					tipo,
					ntipo,
					mayor,
					Ccuenta,
					descrip,
					formato,
					saldoini as saldoini,
					debitos as debitos,
					creditos as creditos,
					movmes as movmes,
					saldofin as saldofin,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#titulo#"> as titulo,	
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rangotipos#"> as rango,
					getDate() as fecha,
					<cfqueryparam cfsqltype="cf_sql_money" value="#m2#"> as totdebitos,
					<cfqueryparam cfsqltype="cf_sql_money" value="#m3#"> as totcreditos,
					<cfqueryparam cfsqltype="cf_sql_money" value="#m5#"> as totmovmes,
					<cfqueryparam cfsqltype="cf_sql_money" value="#m4#"> as totsaldofin
				from #cuentas#
				order by corte, mayor, formato	
			</cfquery>
		</cftransaction>

		<cfreturn rs_Resultante>
	</cffunction>
</cfcomponent>