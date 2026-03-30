<cfcomponent>
	<cffunction name="CreaCuentasMoneda" access="public" output="false" returntype="string">
		<cf_dbtemp name="CG0004_cuentas">
			<cf_dbtempcol name="Ecodigo"  		type="int"    		mandatory="yes">			
			<cf_dbtempcol name="Ccuenta"		type="numeric"      mandatory ="yes">

			<cf_dbtempcol name="PeriodoD"		type="int">
			<cf_dbtempcol name="PeriodoH"		type="int">
			<cf_dbtempcol name="MesD"			type="int">
			<cf_dbtempcol name="MesH"			type="int">
			<cf_dbtempcol name="Oficina"		type="int" 			mandatory ="yes">
			
			<cf_dbtempcol name="corte"  		type="int">
			<cf_dbtempcol name="nivel"  		type="int">
			<cf_dbtempcol name="tipo"  			type="char(1)">						
			<cf_dbtempcol name="ntipo"  		type="char(20)">
			<cf_dbtempcol name="mayor"  		type="char(4)">
			<cf_dbtempcol name="descrip"  		type="char(80)">
			<cf_dbtempcol name="formato"  		type="char(100)">
			<cf_dbtempcol name="saldoini"  		type="money">
			<cf_dbtempcol name="debitos"  		type="money">
			<cf_dbtempcol name="creditos"		type="money">
			<cf_dbtempcol name="movmes"			type="money">			
			<cf_dbtempcol name="saldofin"  		type="money">			
			<cf_dbtempcol name="Mcodigo"  		type="numeric"		mandatory ="yes">			
 
			<cf_dbtempkey cols="Ccuenta, Oficina, Mcodigo">
			<cf_dbtempkey cols="nivel, Ccuenta, Oficina, Mcodigo">

		</cf_dbtemp>
		<cfreturn temp_table>		
	</cffunction>	
	
	<!--- Balance de Comprobacion --->
	<cffunction name='balanceComprob' access='public' output='false' returntype="numeric">
		<cfargument name='Ecodigo' type='numeric' required="yes">
		<cfargument name='Ocodigo' type='numeric' default="-1">		
		<cfargument name='periodoD' type='numeric' required="yes">
		<cfargument name='periodoH' type='numeric' required="yes">
		<cfargument name='mesD' type='numeric' required="yes">
		<cfargument name='mesH' type='numeric' required="yes">
		<cfargument name='nivel' type='numeric' default="1">
		<cfargument name='Mcodigo' type='numeric' default="-2">
		<cfargument name='cuentaini' type='string' default="">
		<cfargument name='cuentafin' type='string' default=""> 				
		<cfargument name='ceros' type='string' default="N">				
		<cfargument name='debug' type='string' default="N">								
		<cfargument name='conexion' type='string' required='false' default="#Session.DSN#">
		<cfargument name='incluirOficina' type="boolean" required="no" default="false">

		<!--- Para el manejo de grupos de empresas y oficinas --->
		<cfargument name='myGEid' type='numeric' default="-1">
		<cfargument name='myGOid' type='numeric' default="-1">
		<cfargument name='MesCierre' type='numeric' default="0">

		<cfset LvarMesReporteD = Arguments.mesD>
		<cfset LvarPeriodoReporteD = Arguments.periodoD>
		
		<cfset LvarMesReporteH = Arguments.mesH>
		<cfset LvarPeriodoReporteH = Arguments.periodoH>
		
		<!--- Variables --->
		<cfset Monloc = -1>
		<cfset titulo = "">
		<cfset rangotipos = "">		
		<cfset Cdescripcion = "">
		<cfset nivelcuenta = -1>
		<cfset nivelactual = -1>
		<cfset nivelanteri = -1>
		<cfset cuentapiv = "">
		<cfset RCVacio  = false>

		<cfquery name="rs_Monloc" datasource="#arguments.conexion#">
			select Mcodigo , Edescripcion
			from Empresas 
			where Ecodigo = #arguments.Ecodigo#
		</cfquery>
	
		<cfif isdefined('rs_Monloc') and rs_Monloc.recordCount GT 0>
			<cfset Monloc = rs_Monloc.Mcodigo>
			<cfset LvarEdescripcion = rs_Monloc.Edescripcion>
		</cfif>

		<cfquery name="rs_Monconv" datasource="#arguments.conexion#">
			select Pvalor 
			from Parametros
			where Ecodigo = #arguments.Ecodigo#
			  and Pcodigo = 660
		</cfquery>
	
		<cfif isdefined('rs_Monconv') and rs_Monconv.recordCount GT 0>
			<cfset lvarMonedaConversion = rs_Monconv.Pvalor>
		</cfif>

		<cfquery name="rs_DesMoneda2" datasource="#arguments.conexion#">
			Select Mnombre 
			from Monedas 
			<cfif arguments.Mcodigo EQ -3>
				where Mcodigo = #lvarMonedaConversion#
			<cfelseif arguments.Mcodigo EQ -2>
				where Mcodigo = #Monloc#
			<cfelse>
				where Mcodigo = #arguments.Mcodigo#
			</cfif>
		</cfquery>
		<cfif arguments.Mcodigo EQ -3>
			<cfset titulo = "Balance de Comprobación Expresado en " & rs_DesMoneda2.Mnombre>
		<cfelseif arguments.Mcodigo EQ -2>
			<cfset titulo = "Balance de Comprobación en Moneda Local: " & rs_DesMoneda2.Mnombre>
		<cfelseif arguments.Mcodigo EQ -1>
			<cfset titulo = "Balance de Comprobación en todas las Monedas">
		<cfelse>
			<cfif isdefined('rs_DesMoneda2') and rs_DesMoneda2.recordCount GT 0>
				<cfset titulo = "Balance de Comprobación en Moneda Origen: " & rs_DesMoneda2.Mnombre>
			<cfelse>
				<cfset titulo = "Balance de Comprobación en Moneda: #rs_DesMoneda2.Mnombre#">
			</cfif>
		</cfif>

		<cfset rangotipos = "">
		<cfif arguments.cuentaini EQ '' and arguments.cuentafin EQ ''>
			<cfset RCVacio =true>
			<cfset rangotipos = "Todas las Cuentas">
		</cfif>
			
		<cfif arguments.cuentaini NEQ ''>
			<cfquery name="rs_DesCContables" datasource="#arguments.conexion#">
				select Cformato  as Cdescripcion
				from CContables
				where Ecodigo  = #arguments.Ecodigo#
				  and Cformato = '#arguments.cuentaini#'
			</cfquery>

			<cfif isdefined('rs_DesCContables') and rs_DesCContables.recordCount GT 0>
				<cfset rangotipos = "Desde: #trim(rs_DesCContables.Cdescripcion)# ">
			</cfif>		
		</cfif>

		<cfif arguments.cuentafin NEQ ''>
			<cfquery name="rs_DesCContables" datasource="#arguments.conexion#">
				select Cformato  as Cdescripcion
				from CContables
				where Ecodigo = #arguments.Ecodigo#
				  and Cformato = '#arguments.cuentafin#'
			</cfquery>
	
			<cfif isdefined('rs_DesCContables') and rs_DesCContables.recordCount GT 0>
					<cfset rangotipos = rangotipos & " hasta la cuenta: " & trim(rs_DesCContables.Cdescripcion)>
			</cfif>
		</cfif>
	
			
		<cfset mySLinicial = "SLinicial">
		<cfset mySOinicial = "SOinicial">
		<!--- Obtiene las empresas del grupo seleccionado --->
		<cfset lstGE = "-1">
		<cfif arguments.myGEid neq -1>
			<cfset mySLinicial = "SLinicialGE">
			<cfset mySOinicial = "SOinicialGE">
			<cfquery name="rsGE" datasource="#session.DSN#">
				select gd.Ecodigo
				from AnexoGEmpresa ge
					join AnexoGEmpresaDet gd
						on ge.GEid = gd.GEid					
				where ge.GEid = #arguments.myGEid#									
			</cfquery>
			<cfif rsGE.recordCount gt 0>
				<cfset arrGE = ArrayNew(1)>
				<cfloop query="rsGE">
					<cfset temp = ArrayAppend(arrGE,#rsGE.Ecodigo#)>
				</cfloop>
				<cfset lstGE = ArrayToList(arrGE)>
			</cfif>
		</cfif>

		<!--- Obtiene las oficinas del grupo seleccionado --->
		<cfset lstGO = "-1">
		<cfif arguments.myGOid neq -1>
			<cfquery name="rsGO" datasource="#session.DSN#">				  
				select b.Ocodigo
				from AnexoGOficina a
					inner join AnexoGOficinaDet b on
						a.GOid = b.GOid and
						a.Ecodigo = b.Ecodigo
				where a.GOid = #arguments.myGOid#
				  and a.Ecodigo = #arguments.Ecodigo#  					  
			</cfquery>
			<cfif rsGO.recordCount gt 0>
				<cfset arrGO = ArrayNew(1)>
				<cfloop query="rsGO">
					<cfset temp = ArrayAppend(arrGO,#rsGO.Ocodigo#)>
				</cfloop>
				<cfset lstGO = ArrayToList(arrGO)>
			</cfif>
		</cfif>

		<!--- Creacion de la tabla temporal de Cuentas --->
		<cfset cuentasMoneda = this.CreaCuentasMoneda()>
		<cfset LvarTablaSaldos = "SaldosContables">
		<cfif arguments.Mcodigo EQ -3>
			<cfset LvarTablaSaldos = "SaldosContablesConvertidos">
		</cfif>
		<cfquery name="rsMonedas" datasource="#Session.DSN#">
				select Mcodigo as MonedaCodigo, Mnombre, Msimbolo, Miso4217, ts_rversion 
				from Monedas
				where Ecodigo = #Session.Ecodigo#
				<cfif arguments.Mcodigo EQ -3>
					and Mcodigo = #lvarMonedaConversion#
				<cfelseif arguments.Mcodigo EQ -2>
					and Mcodigo = #Monloc#
				<cfelseif arguments.Mcodigo gt 0>
					and Mcodigo = #arguments.Mcodigo#
				</cfif>
		</cfquery>
		
		<cfloop query="rsMonedas">
			<!--- Inserta las cuentas de Mayor --->
			<cfquery name="A_Cuentas" datasource="#arguments.conexion#">
				insert INTO #cuentasMoneda# (
						Ecodigo,    mayor, descrip, Ccuenta, PeriodoD, MesD,  PeriodoH, MesH, 
						Oficina, 
						formato, saldoini, debitos, creditos, movmes, saldofin, tipo, nivel, Mcodigo)
				select 	b.Ecodigo,	b.Cmayor, a.Cdescripcion, a.Ccuenta, #arguments.periodoD#, #arguments.mesD#, #arguments.periodoH#, #arguments.mesH#,
						<cfif Arguments.incluirOficina OR Arguments.myGOid NEQ -1>
							o.Ocodigo,
						<cfelse>
							<cfif arguments.Ocodigo EQ -1>
									-1,
							<cfelse>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ocodigo#">,
							</cfif>
						</cfif>
						a.Cformato, 0.00, 0.00, 0.00, 0.00, 0.00, b.Ctipo, case when a.Cformato = b.Cmayor then 0 else 1 end as nivel, 
						#MonedaCodigo#
				from CtasMayor b
					inner join CContables a
					 on a.Ecodigo  = b.Ecodigo
					and a.Cmayor   = b.Cmayor
					<cfif arguments.nivel GTE 0>
						and a.Cformato = b.Cmayor
					<cfelseif arguments.nivel EQ -2>
						and a.Cmovimiento = 'S' and a.Cformato <> b.Cmayor
					<cfelse>
						and (a.Cmovimiento = 'S' or a.Cformato = b.Cmayor)
					</cfif>
					<cfif Arguments.incluirOficina OR Arguments.myGOid NEQ -1>
						inner join Oficinas o
						on o.Ecodigo = a.Ecodigo
						<cfif Arguments.Ocodigo NEQ -1>
							and o.Ocodigo =	#arguments.Ocodigo#
						<cfelseif Arguments.myGOid NEQ -1>
							and o.Ocodigo in (#lstGO#)
						</cfif>
					</cfif>
				where <cfif Arguments.myGEid EQ -1>b.Ecodigo = #arguments.Ecodigo#<cfelse>b.Ecodigo in (#lstGE#)</cfif>
				<cfif not RCvacio>
					<cfif arguments.cuentaini NEQ ''>
						and b.Cmayor >= '#arguments.cuentaini#'
					</cfif>
					<cfif arguments.cuentafin NEQ ''>
						and b.Cmayor <= '#arguments.cuentafin#'
					</cfif>
				</cfif>
			</cfquery>
		</cfloop>
		<cfquery name="All_Cuentas" datasource="#arguments.conexion#">
			select *
			from #cuentasMoneda#
			order by Mcodigo, Ccuenta, Oficina
		</cfquery>
		<cfif arguments.nivel GTE 0>
			<cfset nivelactual = 1>
			<cfset nivelanteri = 0>
			<cfloop condition = "nivelactual LESS THAN arguments.nivel">
				<cfquery name="A2_Cuentas" datasource="#arguments.conexion#">
					insert INTO #cuentasMoneda# (
							Ecodigo, nivel, mayor, descrip, Ccuenta, 
							PeriodoD, MesD, PeriodoH, MesH, Oficina,
							formato, saldoini, debitos, creditos, movmes, saldofin, tipo, Mcodigo)					
					select 
						  b.Ecodigo, #nivelactual#, b.Cmayor, b.Cdescripcion, b.Ccuenta
						, #arguments.periodoD#, #arguments.mesD#, #arguments.periodoH#, #arguments.mesH#, a.Oficina
						, b.Cformato, 0.00, 0.00, 0.00, 0.00, 0.00, a.tipo, a.Mcodigo
					from #cuentasMoneda# a
						inner join CContables b
						on b.Cpadre = a.Ccuenta
					where a.nivel = #nivelanteri#
					<cfif Arguments.incluirOficina>
						and exists(
							select 1
							from #LvarTablaSaldos# s
							where s.Ccuenta  = b.Ccuenta
							  and ((s.Speriodo * 100) + s.Smes)  >= ((a.PeriodoD * 100) + a.MesD)
                              and ((s.Speriodo * 100) + s.Smes)  <= ((a.PeriodoH * 100) + a.MesH)
							  and s.Ocodigo  = a.Oficina
							)
					</cfif>
				</cfquery>
	
				<cfset nivelanteri = nivelactual>
				<cfset nivelactual = nivelactual + 1>
			</cfloop>
		</cfif>
		
		<cfif arguments.debug EQ 'S'>
			<cfquery name="All_Cuentas" datasource="#arguments.conexion#">
				select Ecodigo, corte, nivel, tipo, ntipo, mayor, Ccuenta, descrip, formato, saldoini, debitos, creditos, movmes, saldofin, Mcodigo
				from #cuentasMoneda#
			</cfquery>
			
			<cfif isdefined('All_Cuentas') and All_Cuentas.recordCount GT 0>
				<cfdump var="#All_Cuentas#" label="Cuentas TMP">
			</cfif>
		</cfif>
		<!--- Cálculo de Montos --->
		<cfif not arguments.MesCierre>
			<cfif arguments.Mcodigo EQ -3>
				<cfset LvarCalculoMontosConvertidos = CalculoMontosConvertidosMoneda(#arguments.periodoD#,#arguments.mesD#,#arguments.periodoH#,#arguments.mesH#,#arguments.conexion#,#arguments.incluirOficina#,#arguments.Ocodigo#,#arguments.myGOid#)>
			<cfelseif arguments.Mcodigo EQ -2>
				<cfset LvarCalculoMontoLocal = CalculoMontoLocalMoneda(#arguments.periodoD#,#arguments.mesD#,#arguments.periodoH#,#arguments.mesH#,#arguments.conexion#,#arguments.incluirOficina#,#arguments.Ocodigo#,#arguments.myGOid#)>
			<cfelse>
				<cfset LvarMonedaOrigen = MonedaOrigenMoneda(#arguments.periodoD#,#arguments.mesD#,#arguments.periodoH#,#arguments.mesH#,#arguments.conexion#,#arguments.incluirOficina#,#arguments.Ocodigo#,#arguments.myGOid#)>
			</cfif>
		</cfif>
			
		<cfquery datasource="#arguments.conexion#">
			update #cuentasMoneda# set 
				saldofin = coalesce(saldoini, 0.00) + coalesce(debitos, 0.00) - coalesce(creditos, 0.00),
				movmes = coalesce(debitos,0.00) - coalesce(creditos,0.00)
		</cfquery>

		<cfquery datasource="#arguments.conexion#">
			update #cuentasMoneda# set 
					corte = case 
						when tipo = 'A' 
							then 1
						when tipo = 'P'
							 then 2
						when tipo = 'C'
							 then 3
						when tipo = 'I'
							 then 4
						when tipo = 'G'
							 then 6
						when tipo = 'O'
							 then 7
						end
					, ntipo = case 
						when tipo = 'A' 
							then 'Activo'
						when tipo = 'P'
							 then 'Pasivo'
						when tipo = 'C'
							 then 'Capital'
						when tipo = 'I'
							 then 'Ingreso'
						when tipo = 'G'
							 then 'Gasto'
						when tipo = 'O'
							 then 'Orden'
						end
				<cfif arguments.nivel NEQ -2>
					where nivel = 0
					  and mayor = formato
				</cfif>
		</cfquery>

		<cfset m1 = 0>
		<cfset m2 = 0>	
		<cfset m3 = 0>	
		<cfset m4 = 0>	
		<cfset m5 = 0>	
	
		<cfquery name="All_CuentasTmp10" datasource="#arguments.conexion#">
			select coalesce(sum(saldoini),0) as SumSaldoini,
				coalesce(sum(debitos),0) as SumDebitos,
				coalesce(sum(creditos),0) as SumCreditos,
				coalesce(sum(saldoini + debitos - creditos),0) as SalDevCred
			from #cuentasMoneda#
			<cfif arguments.nivel NEQ -2>
				where nivel = 0
				  and mayor = formato
			</cfif>
		</cfquery>
	
		<cfif isdefined('All_CuentasTmp10') and All_CuentasTmp10.recordCount GT 0>
			<cfset m1 = All_CuentasTmp10.SumSaldoini>
			<cfset m2 = All_CuentasTmp10.SumDebitos>
			<cfset m3 = All_CuentasTmp10.SumCreditos>
			<cfset m4 = All_CuentasTmp10.SalDevCred>
			<cfset m5 = m2 - m3>
		</cfif>
	
		<cftransaction> 			
			<cfquery name="A_BalCompro" datasource="#arguments.conexion#">
				insert INTO CGRBalanceComprobacion (SessionID,Ecodigo,Usucodigo,fechareporte)
				values (
					#session.monitoreo.SessionID#
					, #arguments.Ecodigo#
					, #session.Usucodigo#
					, #now()#
				)

			  <cf_dbidentity1 datasource="#arguments.conexion#">
			</cfquery>
			
			<cf_dbidentity2 datasource="#arguments.conexion#" name="A_BalCompro">
		</cftransaction>
				
		<cfif isdefined('A_BalCompro') and A_BalCompro.identity NEQ ''>
			<cfquery name="A_BalComproD" datasource="#arguments.conexion#">
				insert INTO DCGRBalanceComprobacion 
					(
						Ccuenta,Ecodigo,CGRBCid, Ocodigo,
						corte,nivel,tipo,ntipo,
						mayor,descrip,formato,
						saldoini,saldofin,debitos,
						creditos, movmes,Mcodigo,Edescripcion, 
						totdebitos,totcreditos,totmovmes,totsaldofin,
						rango)
				select  
						Ccuenta, Ecodigo, #A_BalCompro.identity#, Oficina,
						corte, nivel, tipo, ntipo, 
						mayor, descrip, formato, 
						saldoini, saldofin, debitos, 
						creditos, movmes, Mcodigo, '#LvarEdescripcion#'
						, #m2# as totdebitos
						, #m3# as totcreditos
						, #m5# as totmovmes
						, #m4# as totsaldofin	
						, '#rangotipos#' as rango												
				from #cuentasMoneda#
				<cfif arguments.ceros EQ 'N'>
					where saldoini <> 0.00 
					  or debitos   <> 0.00 
					  or creditos  <> 0.00 
					  or movmes    <> 0.00
				</cfif>
			</cfquery>				
			<cfset varResult = A_BalCompro.identity>
		<cfelse>
			<cfset varResult = -1>
		</cfif>
		<cfreturn varResult>
	</cffunction>

	<cffunction name="CalculoMontosConvertidosMoneda" access='private' output="no">
		<cfargument name='periodoD' type='numeric' required="yes">
		<cfargument name='mesD' type='numeric' required="yes">
		<cfargument name='periodoH' type='numeric' required="yes">
		<cfargument name='mesH' type='numeric' required="yes">
		<cfargument name='conexion' type='string' required='false' default="#Session.DSN#">
		<cfargument name='incluirOficina' type="boolean" required="no" default="false">
		<cfargument name='Ocodigo' type='numeric' default="-1">
		<cfargument name='myGOid' type='numeric' default="-1">
		<cfquery datasource="#arguments.conexion#" name="rs">
			update #cuentasMoneda# set 
				saldoini = coalesce((select sum(#mySLinicial#)
						  from SaldosContablesConvertidos a
						  where a.Ccuenta = #cuentasMoneda#.Ccuenta
						  	and ((a.Speriodo * 100) + a.Smes)  >= ((#cuentasMoneda#.PeriodoD * 100) + #cuentasMoneda#.MesD)
                            and ((a.Speriodo * 100) + a.Smes)  <= ((#cuentasMoneda#.PeriodoD * 100) + #cuentasMoneda#.MesD)
							and a.Ecodigo = #cuentasMoneda#.Ecodigo
							and a.Mcodigo = #cuentasMoneda#.Mcodigo
							<cfif arguments.incluirOficina or arguments.Ocodigo NEQ -1 or arguments.myGOid NEQ -1>
								and a.Ocodigo = #cuentasMoneda#.Oficina
							</cfif>
							)
					, 0.00),
				debitos =  coalesce((select sum(DLdebitos)
						  from SaldosContablesConvertidos a
						  where a.Ccuenta = #cuentasMoneda#.Ccuenta
							and ((a.Speriodo * 100) + a.Smes)  >= ((#cuentasMoneda#.PeriodoD * 100) + #cuentasMoneda#.MesD)
                            and ((a.Speriodo * 100) + a.Smes)  <= ((#cuentasMoneda#.PeriodoH * 100) + #cuentasMoneda#.MesH)
							and a.Ecodigo = #cuentasMoneda#.Ecodigo
							and a.Mcodigo = #cuentasMoneda#.Mcodigo
							<cfif arguments.incluirOficina or arguments.Ocodigo NEQ -1 or arguments.myGOid NEQ -1>
								and a.Ocodigo = #cuentasMoneda#.Oficina
							</cfif>
							)
				
					, 0.00),
				
				creditos =  coalesce((select sum(CLcreditos)
						  from SaldosContablesConvertidos a
						  where a.Ccuenta = #cuentasMoneda#.Ccuenta
						  	and ((a.Speriodo * 100) + a.Smes)  >= ((#cuentasMoneda#.PeriodoD * 100) + #cuentasMoneda#.MesD)
                            and ((a.Speriodo * 100) + a.Smes)  <= ((#cuentasMoneda#.PeriodoH * 100) + #cuentasMoneda#.MesH)
							and a.Ecodigo = #cuentasMoneda#.Ecodigo
							and a.Mcodigo = #cuentasMoneda#.Mcodigo
							<cfif arguments.incluirOficina or arguments.Ocodigo NEQ -1 or arguments.myGOid NEQ -1>
								and a.Ocodigo = #cuentasMoneda#.Oficina
							</cfif>
							)
					, 0.00)			
			</cfquery>
	</cffunction>

	<cffunction name="CalculoMontoLocalMoneda" access='private' output="no">
		<cfargument name='periodoD' type='numeric' required="yes">
		<cfargument name='mesD' type='numeric' required="yes">
		<cfargument name='periodoH' type='numeric' required="yes">
		<cfargument name='mesH' type='numeric' required="yes">
		<cfargument name='conexion' type='string' required='false' default="#Session.DSN#">
		<cfargument name='incluirOficina' type="boolean" required="no" default="false">
		<cfargument name='Ocodigo' type='numeric' default="-1">
		<cfargument name='myGOid' type='numeric' default="-1">
		<cfquery datasource="#arguments.conexion#" name="rs">
			update #cuentasMoneda# set 
				saldoini = coalesce((
					select sum(#mySLinicial#)
					from SaldosContables a
					where a.Ccuenta = #cuentasMoneda#.Ccuenta
						and ((a.Speriodo * 100) + a.Smes)  >= ((#cuentasMoneda#.PeriodoD * 100) + #cuentasMoneda#.MesD)
                        and ((a.Speriodo * 100) + a.Smes)  <= ((#cuentasMoneda#.PeriodoD * 100) + #cuentasMoneda#.MesD)
					  	and a.Ecodigo = #cuentasMoneda#.Ecodigo
					<cfif arguments.incluirOficina or arguments.Ocodigo NEQ -1 or arguments.myGOid NEQ -1>
							and a.Ocodigo = #cuentasMoneda#.Oficina
					</cfif>
					), 0.00),
				
				debitos =  coalesce((
					select sum(DLdebitos)
					from SaldosContables a
					where a.Ccuenta = #cuentasMoneda#.Ccuenta
						and ((a.Speriodo * 100) + a.Smes)  >= ((#cuentasMoneda#.PeriodoD * 100) + #cuentasMoneda#.MesD)
                        and ((a.Speriodo * 100) + a.Smes)  <= ((#cuentasMoneda#.PeriodoH * 100) + #cuentasMoneda#.MesH)
					  	and a.Ecodigo = #cuentasMoneda#.Ecodigo
					<cfif arguments.incluirOficina or arguments.Ocodigo NEQ -1 or arguments.myGOid NEQ -1>
							and a.Ocodigo = #cuentasMoneda#.Oficina
					</cfif>
					), 0.00),
				
				creditos =  coalesce((
					select sum(CLcreditos)
					from SaldosContables a
					where a.Ccuenta = #cuentasMoneda#.Ccuenta
						and ((a.Speriodo * 100) + a.Smes)  >= ((#cuentasMoneda#.PeriodoD * 100) + #cuentasMoneda#.MesD)
                        and ((a.Speriodo * 100) + a.Smes)  <= ((#cuentasMoneda#.PeriodoH * 100) + #cuentasMoneda#.MesH)
					  	and a.Ecodigo = #cuentasMoneda#.Ecodigo
					<cfif arguments.incluirOficina or arguments.Ocodigo NEQ -1 or arguments.myGOid NEQ -1>
							and a.Ocodigo = #cuentasMoneda#.Oficina
					</cfif>
					), 0.00)			
		</cfquery>
	</cffunction>

	<cffunction name="MonedaOrigenMoneda" access='private' output="no">
		<cfargument name='periodoD' type='numeric' required="yes">
		<cfargument name='mesD' type='numeric' required="yes">
		<cfargument name='periodoH' type='numeric' required="yes">
		<cfargument name='mesH' type='numeric' required="yes">
		<cfargument name='conexion' type='string' required='false' default="#Session.DSN#">
		<cfargument name='incluirOficina' type="boolean" required="no" default="false">
		<cfargument name='Ocodigo' type='numeric' default="-1">
		<cfargument name='myGOid' type='numeric' default="-1">

		<cfquery datasource="#arguments.conexion#">
			 update #cuentasMoneda# set 
				saldoini = coalesce((
								select sum(#mySOinicial#)
								from SaldosContables a
								where a.Ccuenta = #cuentasMoneda#.Ccuenta
									and ((a.Speriodo * 100) + a.Smes)  >= ((#cuentasMoneda#.PeriodoD * 100) + #cuentasMoneda#.MesD)
                           			and ((a.Speriodo * 100) + a.Smes)  <= ((#cuentasMoneda#.PeriodoD * 100) + #cuentasMoneda#.MesD)
								  	and a.Ecodigo = #cuentasMoneda#.Ecodigo
								<cfif arguments.incluirOficina or arguments.Ocodigo NEQ -1 or arguments.myGOid NEQ -1>
										and a.Ocodigo = #cuentasMoneda#.Oficina
								</cfif>
								  and a.Mcodigo = #cuentasMoneda#.Mcodigo
							)
				, 0.00),
				
				debitos =  coalesce((
								select sum(DOdebitos)
								from SaldosContables a
								where a.Ccuenta = #cuentasMoneda#.Ccuenta
									and ((a.Speriodo * 100) + a.Smes)  >= ((#cuentasMoneda#.PeriodoD * 100) + #cuentasMoneda#.MesD)
                            		and ((a.Speriodo * 100) + a.Smes)  <= ((#cuentasMoneda#.PeriodoH * 100) + #cuentasMoneda#.MesH)
								  	and a.Ecodigo = #cuentasMoneda#.Ecodigo
								<cfif arguments.incluirOficina or arguments.Ocodigo NEQ -1 or arguments.myGOid NEQ -1>
										and a.Ocodigo = #cuentasMoneda#.Oficina
								</cfif>
								  and a.Mcodigo = #cuentasMoneda#.Mcodigo
							)
				, 0.00),
				
				creditos =  coalesce((
								select sum(COcreditos)
								from SaldosContables a
								where a.Ccuenta = #cuentasMoneda#.Ccuenta
									and ((a.Speriodo * 100) + a.Smes)  >= ((#cuentasMoneda#.PeriodoD * 100) + #cuentasMoneda#.MesD)
                            		and ((a.Speriodo * 100) + a.Smes)  <= ((#cuentasMoneda#.PeriodoH * 100) + #cuentasMoneda#.MesH)
								  	and a.Ecodigo = #cuentasMoneda#.Ecodigo
								<cfif arguments.incluirOficina or arguments.Ocodigo NEQ -1 or arguments.myGOid NEQ -1>
										and a.Ocodigo = #cuentasMoneda#.Oficina
								</cfif>
								  and a.Mcodigo = #cuentasMoneda#.Mcodigo
							)
				, 0.00)
		</cfquery>
	</cffunction>
</cfcomponent>