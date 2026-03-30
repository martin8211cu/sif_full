<cfcomponent>
<!--- 	Balance General	Detallado--->

	<cffunction name="CreaCuentas" access="public" output="false" returntype="string">
		<cf_dbtemp name="CG0005ctasV1">
			<cf_dbtempcol name="Ecodigo"  		type="int"    		mandatory="yes">			
			<cf_dbtempcol name="Ccuenta"		type="numeric"		mandatory="yes">
			<cf_dbtempcol name="corte"  		type="int">
			<cf_dbtempcol name="nivel"  		type="int">		<!--- 0 --->
			<cf_dbtempcol name="tipo"  			type="char(1)">						
			<cf_dbtempcol name="ntipo"  		type="char(20)">
			<cf_dbtempcol name="mayor"  		type="char(4)">
			<cf_dbtempcol name="descrip"  		type="char(80)">
			<cf_dbtempcol name="formato"  		type="char(100)">
			<cf_dbtempcol name="saldoini"  		type="money">
			<cf_dbtempcol name="saldoFin"  		type="money">
            <cf_dbtempcol name="saldoFinMA"  	type="money">
            <cf_dbtempcol name="saldoFinFA"  	type="money">
            <cf_dbtempcol name="saldoFinPA"  	type="money">			
			<cf_dbtempcol name="debitos"  		type="money">
			<cf_dbtempcol name="creditos"		type="money">
			<cf_dbtempcol name="saldoiniA" 		type="money">
			<cf_dbtempcol name="saldofinA" 		type="money">			
			<cf_dbtempcol name="debitosA"  		type="money">
			<cf_dbtempcol name="creditosA"		type="money">
			<cf_dbtempcol name="movmesA"		type="money">	
			<cf_dbtempcol name="movmes"			type="money">			
			<cf_dbtempcol name="Mcodigo"  		type="numeric">			
			<cf_dbtempcol name="Edescripcion" 	type="char(80)">			
			<cf_dbtempcol name="Cbalancen"  	type="char(1)">
 
			<cf_dbtempkey cols="Ccuenta">
		</cf_dbtemp>
		
		<cfreturn temp_table>		
	</cffunction>	
	
	<cffunction name='balanceGeneral' access='public' output='true' returntype="query">
		<cfargument name='Ecodigo' type='numeric' required="yes">
		<cfargument name='periodo' type='numeric' required="yes">
		<cfargument name='mes' type='numeric' required="yes">
		<cfargument name='nivel' type='numeric' default="0">
		<cfargument name='Mcodigo' type='numeric' default="-2">
		<cfargument name='Ocodigo' type='numeric' default="-1" required="no">		
		<cfargument name='GOid' type='numeric' default="-1">
		<cfargument name='ceros' type='string' default="S">
		<cfargument name='debug' type='string' default="N">								
		<cfargument name='conexion' type='string' required='false' default="#Session.DSN#">
		
		<!--- Creacion de la tabla temporal de Cuentas --->
		<cfset cuentas = this.CreaCuentas()>

		<!--- Variables --->
		<cfset Monloc = -1>
		<cfset titulo = "">
		<cfset rangotipos = "">		
		<cfset Cdescripcion = "">
		<cfset Edescripcion = "">	
		<cfset nivelcuenta = -1>
		<cfset nivelactual = 1>
		<cfset nivelanteri = 0>
		<cfset utilidadsaldo = -1>
		<cfset utilidadmes = -1>
		<cfset Ccuenta = -1>		
		<cfset Cformato = "">
		<cfset ofi = -1>
		<cfset Ocodigos = "-1">
		
		<cfset utilidadmesA = 0>
		<cfset utilidadsaldoA = 0>

		<!--- En caso de que el código de la oficina venga como parámetro. --->
		<cfif arguments.Ocodigo NEQ -1>
			<cfset ofi = arguments.Ocodigo>
		</cfif>
		
        
        <cfquery name="rsMesFiscal" datasource="#arguments.conexion#">
            select Pvalor 
            from Parametros
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
              and Pcodigo = 45
        </cfquery>
    
    
		<cfset periodoanterior = (arguments.periodo - 1)>        

        <cfif arguments.mes eq 1>
        	<cfset MesAnterior = 12>
			<cfset periodoMesAnterior = (arguments.periodo - 1)>
        <cfelse> 
        	<cfset MesAnterior = (arguments.mes - 1)>
			<cfset periodoMesAnterior = (arguments.periodo)>
        </cfif>

        <cfset MesFinAnterior = rsMesFiscal.Pvalor>
        <cfif arguments.mes gt MesFinAnterior>
        	<cfset periodoFinAnterior = (arguments.periodo)>
        <cfelse>
        	<cfset periodoFinAnterior = (arguments.periodo - 1)>
        </cfif>    
        	
        
		<!--- Obtengo las oficinas del grupo --->
		<cfif isDefined("arguments.GOid") and arguments.GOid neq -1>
			<cfquery name="rsOficinasXGrupo" datasource="#Session.DSN#">
				select Ocodigo
				from AnexoGOficinaDet
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and GOid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.GOid#">
			</cfquery>
			
			<cfif rsOficinasXGrupo.recordCount gt 0>
				<cfset arrTemp = ArrayNew(1)>
				<cfloop query="rsOficinasXGrupo">
					<cfset temp = ArrayAppend(arrTemp,#rsOficinasXGrupo.Ocodigo#)>
				</cfloop>
				<cfset Ocodigos = ArrayToList(arrTemp)>						
			</cfif>								
		</cfif>
															
		<cfquery name="rs_Monloc" datasource="#arguments.conexion#">
			select Mcodigo 
			from Empresas 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
		
		<cfif isdefined('rs_Monloc') and rs_Monloc.recordCount GT 0>
			<cfset Monloc = rs_Monloc.Mcodigo>
		</cfif>		
		
		<cfif arguments.Mcodigo EQ -4>
			<cfquery name="rs_Monconv" datasource="#arguments.conexion#">
				select Pvalor 
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
				  and Pcodigo = 3900
			</cfquery>
			<cfif rs_Monconv.recordCount eq 0 or len(trim(rs_Monconv.Pvalor)) EQ 0>
				<cfthrow message="No se ha definido la Moneda de Informe B15 en Parámetros">
			</cfif>
			<cfset lvarB15 = 2>
		<cfelse>
			<cfquery name="rs_Monconv" datasource="#arguments.conexion#">
				select Pvalor 
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
				  and Pcodigo = 660
			</cfquery>
			<cfset lvarB15 = 0>
		</cfif>

		<cfif isdefined('rs_Monconv') and rs_Monconv.recordCount GT 0>
			<cfset lvarMonedaConversion = rs_Monconv.Pvalor>
		</cfif>

		<cfquery name="rs_Par" datasource="#arguments.conexion#">
		 	Select Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and Pcodigo = 10
		</cfquery>

		<cfif isdefined('rs_Par') and rs_Par.recordCount GT 0>
			<cfset Cformato = rs_Par.Pvalor>
		</cfif>		

		<cfquery name="rs_Par2" datasource="#arguments.conexion#">
		 	Select <cf_dbfunction name="to_number" datasource="#arguments.conexion#" args="Pvalor"> as Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and Pcodigo = 290
		</cfquery>

		<cfif isdefined('rs_Par2') and rs_Par2.recordCount GT 0>
			<cfset Ccuenta = rs_Par2.Pvalor>
		</cfif>		

		<cfif Ccuenta NEQ ''>
			<cfquery name="rs_CContables" datasource="#arguments.conexion#">
				Select 1
				from CContables
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					and Ccuenta=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Ccuenta#">
			</cfquery>		
			
			<cfif isdefined('rs_CContables') and rs_CContables.recordCount EQ 0>
				<cf_errorCode	code = "51059" msg = "No existe la cuenta indicada. Proceso Cancelado !">
			</cfif>
		<cfelse>
			<cf_errorCode	code = "51059" msg = "No existe la cuenta indicada. Proceso Cancelado !">		
		</cfif>


		<cfquery name="rs_EmpresasDes" datasource="#arguments.conexion#">
			Select Edescripcion
			from Empresas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
			
		<cfif isdefined('rs_EmpresasDes') and rs_EmpresasDes.recordCount GT 0>
			<cfset Edescripcion = rs_EmpresasDes.Edescripcion>
		</cfif>		

		<!--- insert a las cuentas de Mayor --->	  
		<cfquery name="rs_EmpresasDes" datasource="#arguments.conexion#">
			insert INTO  #cuentas# (Ecodigo, Edescripcion, mayor, descrip, Ccuenta, formato, saldoini, debitos, creditos, movmes, saldoFin,
			saldoiniA, debitosA, creditosA, saldofinA,tipo, Mcodigo, Cbalancen, nivel)
			select 	#arguments.Ecodigo#
					, '#Edescripcion#'
					, b.Cmayor, b.Cdescripcion, a.Ccuenta, a.Cformato, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, b.Ctipo
					, 	<cfif arguments.Mcodigo EQ -3>
							#lvarMonedaConversion#
						<cfelseif arguments.Mcodigo NEQ -2>
							#arguments.Mcodigo#
						<cfelse>
                        	<cfif Application.dsinfo[arguments.conexion].type is 'db2'>CAST (NULL AS numeric)<cfelse>null</cfif> 
						</cfif>
					, a.Cbalancen
					, 0
			from CtasMayor b, CContables a 
			where b.Ecodigo = #arguments.Ecodigo#
			  and b.Ctipo not in ('I', 'G', 'O') 
			  and b.Ecodigo = a.Ecodigo
			  and b.Cmayor = a.Cformato 
		</cfquery>

		<cfset nivelactual = 1>
		<cfset nivelanteri = 0>
		<cfloop condition = "nivelactual LESS THAN arguments.nivel">
			<cfquery name="A2_Cuentas" datasource="#arguments.conexion#">
				insert INTO  #cuentas# (Ecodigo, Edescripcion, nivel, mayor, descrip, Ccuenta, formato, saldoini, debitos, creditos, movmes, saldoFin,
				saldoiniA, debitosA, creditosA, saldofinA,tipo, Mcodigo, Cbalancen)
				select #arguments.Ecodigo#
					, '#Edescripcion#'
					, #nivelactual#
					, b.Cmayor, b.Cdescripcion, b.Ccuenta, b.Cformato, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, a.tipo
					, 	<cfif arguments.Mcodigo EQ -3>
							#lvarMonedaConversion#
						<cfelseif arguments.Mcodigo NEQ -2>
							#arguments.Mcodigo#
						<cfelse>
							<cfif Application.dsinfo[arguments.conexion].type is 'db2'>CAST (NULL AS numeric)<cfelse>null</cfif>
						</cfif>
					, b.Cbalancen
				from #cuentas# a, CContables b
				where a.nivel = #nivelanteri#
				  and a.Ccuenta = b.Cpadre
				  and a.Ecodigo = b.Ecodigo
			</cfquery>
		
			<cfset nivelanteri = nivelactual>
			<cfset nivelactual = nivelactual + 1>
		</cfloop>
				
		<cfif arguments.debug EQ 'S'>
			<cfquery name="All_Cuentas" datasource="#arguments.conexion#">
				select Ecodigo, corte, nivel, tipo, ntipo, mayor, Ccuenta, descrip, formato, saldoini, debitos, creditos, movmes, saldoFin, Mcodigo, Edescripcion, Cbalancen 
				from #cuentas#
			</cfquery>
			
			<cfif isdefined('All_Cuentas') and All_Cuentas.recordCount GT 0>
				<cfdump var="#All_Cuentas#" label="Cuentas TMP">
			</cfif>
		</cfif>

		<cfif arguments.Mcodigo EQ -3 or arguments.Mcodigo EQ -4>
			
			<cfset UtilSaldo 	= fnSelectSaldos (arguments.Ecodigo,	"SL", arguments.periodo,	Arguments.mes, 	true, LvarMonedaConversion, arguments.conexion)>
            <cfset UtilSaldoPA 	= fnSelectSaldos (arguments.Ecodigo,	"SL", periodoanterior,		Arguments.mes, 	true, LvarMonedaConversion, arguments.conexion)>
            <cfset UtilSaldoMA 	= fnSelectSaldos (arguments.Ecodigo,	"SL", periodoMesAnterior,	MesAnterior,	true, LvarMonedaConversion, arguments.conexion)>
            <cfset UtilSaldoFA 	= fnSelectSaldos (arguments.Ecodigo,	"SL", periodoFinAnterior,	MesFinAnterior,	true, LvarMonedaConversion, arguments.conexion)>
			<cfquery datasource="#arguments.conexion#">
				update #cuentas# set 
					saldoFin	= #fnActualizaCuentas (arguments.Ecodigo,	"SL", arguments.periodo,	Arguments.mes, 	true, LvarMonedaConversion, Arguments.GOid, Arguments.conexion)#,
					saldoFinPA	= #fnActualizaCuentas (arguments.Ecodigo,	"SL", periodoanterior,		Arguments.mes, 	true, LvarMonedaConversion, Arguments.GOid, Arguments.conexion)#,
					saldoFinMA	= #fnActualizaCuentas (arguments.Ecodigo,	"SL", periodoMesAnterior,	MesAnterior, 	true, LvarMonedaConversion, Arguments.GOid, Arguments.conexion)#,
					saldoFinFA	= #fnActualizaCuentas (arguments.Ecodigo,	"SL", periodoFinAnterior,	MesFinAnterior,	true, LvarMonedaConversion, Arguments.GOid, Arguments.conexion)#
            </cfquery>
			<!---<cfquery datasource="#arguments.conexion#">
				update #cuentas# set 
					saldoini = coalesce(( select sum(SLinicial)
										from SaldosContablesConvertidos
										where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
										  and Ccuenta = #cuentas#.Ccuenta
										  and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
										  and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">										  										
										  <cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
											and Ocodigo in (#Ocodigos#)
										  </cfif>
										  <cfif ofi NEQ -1>
											and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
										  </cfif>												
										  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMonedaConversion#">
										  and B15 = #lvarB15#
										  ), 0.00),
					debitos =  coalesce((  select sum(DLdebitos)
										  from SaldosContablesConvertidos
										  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
											and Ccuenta = #cuentas#.Ccuenta
											and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
											and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
											<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
												and Ocodigo in (#Ocodigos#)
											</cfif>
											<cfif ofi NEQ -1>
												and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
											</cfif>
											and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMonedaConversion#">
											and B15 = #lvarB15#
											), 0.00),
					creditos =  coalesce((  select sum(CLcreditos)
										  from SaldosContablesConvertidos
										  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
											and Ccuenta = #cuentas#.Ccuenta
											and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
											and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
											<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
												and Ocodigo in (#Ocodigos#)
											</cfif>
											<cfif ofi NEQ -1>
												and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
											</cfif>
											and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMonedaConversion#">
											and B15 = #lvarB15#
											), 0.00),
					<!--- **************************************************************************************************** --->
					saldoiniA = coalesce(( select sum(SLinicial)
										from SaldosContablesConvertidos
										where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
										  and Ccuenta = #cuentas#.Ccuenta
										  and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#periodoanterior#">
										  and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">										  										
										  <cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
											and Ocodigo in (#Ocodigos#)
										  </cfif>
										  <cfif ofi NEQ -1>
											and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
										  </cfif>												
										  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMonedaConversion#">
										  and B15 = #lvarB15#
										  ), 0.00),
					debitosA =  coalesce((  select sum(DLdebitos)
										  from SaldosContablesConvertidos
										  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
											and Ccuenta = #cuentas#.Ccuenta
											and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#periodoanterior#">
											and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
											<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
												and Ocodigo in (#Ocodigos#)
											</cfif>
											<cfif ofi NEQ -1>
												and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
											</cfif>
											and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMonedaConversion#">
											and B15 = #lvarB15#
											), 0.00),
					creditosA =  coalesce((  select sum(CLcreditos)
										  from SaldosContablesConvertidos
										  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
											and Ccuenta = #cuentas#.Ccuenta
											and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#periodoanterior#">
											and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
											<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
												and Ocodigo in (#Ocodigos#)
											</cfif>
											<cfif ofi NEQ -1>
												and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
											</cfif>
											and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMonedaConversion#">
											and B15 = #lvarB15#
											), 0.00)									
			</cfquery>--->
			
			<!--- Calculo de Utilidades --->
			<cfset UtilSaldo 	= fnSelectSaldos (arguments.Ecodigo,	"SL", arguments.periodo,	arguments.mes, 	true, lvarMonedaConversion, arguments.conexion)>
            <cfset UtilSaldoPA 	= fnSelectSaldos (arguments.Ecodigo,	"SL", periodoanterior,		arguments.mes, 	true, lvarMonedaConversion, arguments.conexion)>
            <cfset UtilSaldoMA 	= fnSelectSaldos (arguments.Ecodigo,	"SL", periodoMesAnterior,	MesAnterior,	true, lvarMonedaConversion, arguments.conexion)>
            <cfset UtilSaldoFA 	= fnSelectSaldos (arguments.Ecodigo,	"SL", periodoFinAnterior,	MesFinAnterior,	true, lvarMonedaConversion, arguments.conexion)>
		<cfelseif arguments.Mcodigo EQ -2>
			<cfquery datasource="#arguments.conexion#">
				update #cuentas# set 
					saldoFin	= #fnActualizaCuentas (arguments.Ecodigo,	"SL", arguments.periodo,	Arguments.mes, 	false, -1, Arguments.GOid, Arguments.conexion)#,
					saldoFinPA	= #fnActualizaCuentas (arguments.Ecodigo,	"SL", periodoanterior,		Arguments.mes, 	false, -1, Arguments.GOid, Arguments.conexion)#,
					saldoFinMA	= #fnActualizaCuentas (arguments.Ecodigo,	"SL", periodoMesAnterior,	MesAnterior, 	false, -1, Arguments.GOid, Arguments.conexion)#,
					saldoFinFA	= #fnActualizaCuentas (arguments.Ecodigo,	"SL", periodoFinAnterior,	MesFinAnterior,	false, -1, Arguments.GOid, Arguments.conexion)#
            </cfquery>
            
			<!---<cfquery datasource="#arguments.conexion#">
				update #cuentas# set 
					saldoini = coalesce(( select sum(SLinicial)
										from SaldosContables
										where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
										  and Ccuenta = #cuentas#.Ccuenta
										  and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
										  and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">										  
										  <cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
											and Ocodigo in (#Ocodigos#)
										  </cfif>
										  <cfif ofi NEQ -1>
											and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
										  </cfif>
										  ), 0.00),
					debitos =  coalesce((  select sum(DLdebitos)
										  from SaldosContables
										  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
											and Ccuenta = #cuentas#.Ccuenta
											and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
											and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
											<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
												and Ocodigo in (#Ocodigos#)
											</cfif>
											<cfif ofi NEQ -1>
												and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
											</cfif>
											), 0.00),
					creditos =  coalesce((  select sum(CLcreditos)
										  from SaldosContables
										  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
											and Ccuenta = #cuentas#.Ccuenta
											and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
											and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
											<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
												and Ocodigo in (#Ocodigos#)
											</cfif>
											<cfif ofi NEQ -1>
												and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
											</cfif>
											), 0.00),
					<!--- *********************************************************************************************** --->						
					saldoiniA = coalesce(( select sum(SLinicial)
										from SaldosContables
										where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
										  and Ccuenta = #cuentas#.Ccuenta
										  and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#periodoanterior#">
										  and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">										  
										  <cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
											and Ocodigo in (#Ocodigos#)
										  </cfif>
										  <cfif ofi NEQ -1>
											and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
										  </cfif>
										  ), 0.00),
					debitosA =  coalesce((  select sum(DLdebitos)
										  from SaldosContables
										  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
											and Ccuenta = #cuentas#.Ccuenta
											and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#periodoanterior#">
											and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
											<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
												and Ocodigo in (#Ocodigos#)
											</cfif>
											<cfif ofi NEQ -1>
												and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
											</cfif>
											), 0.00),
					creditosA =  coalesce((  select sum(CLcreditos)
										  from SaldosContables
										  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
											and Ccuenta = #cuentas#.Ccuenta
											and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#periodoanterior#">
											and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
											<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
												and Ocodigo in (#Ocodigos#)
											</cfif>
											<cfif ofi NEQ -1>
												and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
											</cfif>
											), 0.00)											
			</cfquery>--->
			
			<!--- Calculo de Utilidades --->
            <cfset UtilSaldo 	= fnSelectSaldos (arguments.Ecodigo,	"SL", arguments.periodo,	arguments.mes, 	false, -1, arguments.conexion)>
            <cfset UtilSaldoPA 	= fnSelectSaldos (arguments.Ecodigo,	"SL", periodoanterior,		arguments.mes, 	false, -1, arguments.conexion)>
            <cfset UtilSaldoMA 	= fnSelectSaldos (arguments.Ecodigo,	"SL", periodoMesAnterior,	MesAnterior,	false, -1, arguments.conexion)>
            <cfset UtilSaldoFA 	= fnSelectSaldos (arguments.Ecodigo,	"SL", periodoFinAnterior,	MesFinAnterior,	false, -1, arguments.conexion)>
			
		<cfelse>
			<cfquery datasource="#arguments.conexion#">
				update #cuentas# set 
					saldoFin	= #fnActualizaCuentas (arguments.Ecodigo,	"SO", arguments.periodo,	Arguments.mes, 	false, arguments.Mcodigo, Arguments.GOid, Arguments.conexion)#,
					saldoFinPA	= #fnActualizaCuentas (arguments.Ecodigo,	"SO", periodoanterior,		Arguments.mes, 	false, arguments.Mcodigo, Arguments.GOid, Arguments.conexion)#,
					saldoFinMA	= #fnActualizaCuentas (arguments.Ecodigo,	"SO", periodoMesAnterior,	MesAnterior, 	false, arguments.Mcodigo, Arguments.GOid, Arguments.conexion)#,
					saldoFinFA	= #fnActualizaCuentas (arguments.Ecodigo,	"SO", periodoFinAnterior,	MesFinAnterior,	false, arguments.Mcodigo, Arguments.GOid, Arguments.conexion)#
            </cfquery>
            
			<!---<cfquery datasource="#arguments.conexion#">
				 update #cuentas#
					 set 
						 saldoini = coalesce(
							(select sum(SOinicial)
								from SaldosContables a
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
									and Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Mcodigo#">
									and Ccuenta = #cuentas#.Ccuenta
									and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
									and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
									and a.Mcodigo = #cuentas#.Mcodigo
									<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
										and a.Ocodigo in (#Ocodigos#)
									</cfif>
									<cfif ofi NEQ -1>
										and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
									</cfif>
							)
							, 0.00),

						 debitos =  coalesce(
						 	(select sum(DOdebitos)
								from SaldosContables a
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
									and Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Mcodigo#">
									and Ccuenta = #cuentas#.Ccuenta
									and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
									and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
									and a.Mcodigo = #cuentas#.Mcodigo
									<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
										and a.Ocodigo in (#Ocodigos#)
									</cfif>
									<cfif ofi NEQ -1>
										and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
									</cfif>
							), 0.00),
							
						 creditos =  coalesce(
						 	(select sum(COcreditos)
								from SaldosContables a
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
									and Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Mcodigo#">
									and Ccuenta = #cuentas#.Ccuenta
									and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
									and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
									and a.Mcodigo = #cuentas#.Mcodigo
									<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
										and Ocodigo in (#Ocodigos#)
									</cfif>
									<cfif ofi NEQ -1>
										and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
									</cfif>
							), 0.00),
						<!--- ***************************************************************************************** --->	
						saldoiniA = coalesce(
							(select sum(SOinicial)
								from SaldosContables a
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
									and Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Mcodigo#">
									and Ccuenta = #cuentas#.Ccuenta
									and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#periodoanterior#">
									and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
									and a.Mcodigo = #cuentas#.Mcodigo
									<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
										and a.Ocodigo in (#Ocodigos#)
									</cfif>
									<cfif ofi NEQ -1>
										and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
									</cfif>
							)
							, 0.00),

						 debitosA =  coalesce(
						 	(select sum(DOdebitos)
								from SaldosContables a
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
									and Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Mcodigo#">
									and Ccuenta = #cuentas#.Ccuenta
									and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#periodoanterior#">
									and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
									and a.Mcodigo = #cuentas#.Mcodigo
									<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
										and a.Ocodigo in (#Ocodigos#)
									</cfif>
									<cfif ofi NEQ -1>
										and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
									</cfif>
							), 0.00),
							
						 creditosA =  coalesce(
						 	(select sum(COcreditos)
								from SaldosContables a
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
									and Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Mcodigo#">
									and Ccuenta = #cuentas#.Ccuenta
									and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#periodoanterior#">
									and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
									and a.Mcodigo = #cuentas#.Mcodigo
									<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
										and Ocodigo in (#Ocodigos#)
									</cfif>
									<cfif ofi NEQ -1>
										and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
									</cfif>
							), 0.00)							
			</cfquery>--->
			
			<cfset UtilSaldo 	= fnSelectSaldos (arguments.Ecodigo,	"SO", arguments.periodo,	arguments.mes, 	false, arguments.Mcodigo, arguments.conexion)>
            <cfset UtilSaldoPA 	= fnSelectSaldos (arguments.Ecodigo,	"SO", periodoanterior,		arguments.mes, 	false, arguments.Mcodigo, arguments.conexion)>
            <cfset UtilSaldoMA 	= fnSelectSaldos (arguments.Ecodigo,	"SO", periodoMesAnterior,	MesAnterior,	false, arguments.Mcodigo, arguments.conexion)>
            <cfset UtilSaldoFA 	= fnSelectSaldos (arguments.Ecodigo,	"SO", periodoFinAnterior,	MesFinAnterior,	false, arguments.Mcodigo, arguments.conexion)>
		</cfif>
		
		<cfif arguments.ceros NEQ 'S'>
			<cfquery datasource="#arguments.conexion#">
			    delete from #cuentas# 
				where saldoFin	 = 0.00 
                  and saldoFinPA = 0.00 
                  and saldoFinMA = 0.00 
                  and saldoFinFA = 0.00
			</cfquery>
		</cfif>
		
		<cfquery datasource="#arguments.conexion#">
			update #cuentas#
				set corte = 1, ntipo = 'Activo'
			where tipo = 'A'		
		</cfquery>		
		    
		<cfquery datasource="#arguments.conexion#">
			update #cuentas#
				set corte = 2, ntipo = 'Pasivo'
			where tipo = 'P'
		</cfquery>
				
		<cfquery datasource="#arguments.conexion#">
			update #cuentas#
				set corte = 3, ntipo = 'Capital'
			where tipo = 'C'
		</cfquery>

		<cfquery datasource="#arguments.conexion#">
			<!---  Poner el saldo de las cuentas que no son de que "no son de Activo" en el signo contrario para efectos de despliegue!--->
			update #cuentas#
				set saldoFin	= -saldoFin,
					saldoFinPA	= -saldoFinPA,
					saldoFinMA	= -saldoFinMA,
					saldoFinFA	= -saldoFinFA
			where tipo <> 'A'			
		</cfquery>		
		
		<!--- Se Agrega un Límite de Registros de salida (max 2500) MDM 26/06/2006--->
		<cfquery name="rs_Resultante" datasource="#arguments.conexion#" maxrows="2500">
			select 
				Edescripcion as Empresa,
				corte,
				nivel,
				tipo,
				ntipo,
				mayor,
				<cf_dbfunction name="to_char" args="Ccuenta"> as Ccuenta,
				descrip,
				formato,

				<!--- Saldos de cada linea del Reporte --->
				saldoFin,
                saldoFinMA,
				saldoFinFA,
				saldoFinPA,

				<!--- Saldos de la linea de Utilidad --->
				#-UtilSaldo#	as utilidadsaldo,
                #-UtilSaldoMA#	as utilidadSaldoMA,
                #-UtilSaldoFA#	as utilidadSaldoFA,
				#-UtilSaldoPA#	as utilidadSaldoPA,	
				
				#now()# as fecha,
				Cbalancen,
				#Ccuenta# 		as cuentaUtil,
				'#Cformato#' 	as Cformato
			from #cuentas# 
			order by corte, mayor, formato
		</cfquery>
		
		<cfreturn rs_Resultante>
	</cffunction>
	<cffunction name="fnSelectSaldos" returntype="numeric">
		<cfargument name='Ecodigo' 	type='numeric' 	required="yes">
		<cfargument name='campos' 	type='string' 	required="yes">
		<cfargument name='periodo' 	type='numeric' 	required="yes">
		<cfargument name='mes' 		type='numeric' 	required="yes">
		<cfargument name='B15' 		type='boolean' 	required="yes">
		<cfargument name='Mcodigo' 	type='numeric' 	required="yes">
		<cfargument name='conexion' type='string' 	required='false' default="#Session.DSN#">

		<cfif Arguments.campos EQ "SL">
            <cfset LvarCampos = "a.SLinicial + a.DLdebitos - a.CLcreditos">
        <cfelseif Arguments.campos EQ "SO">
            <cfset LvarCampos = "a.SOinicial + a.DOdebitos - a.COcreditos">
        </cfif>
            
        <cfquery name="rsMonto" datasource="#arguments.conexion#">
            select sum(#LvarCampos#) as SaldoFinal
            from SaldosContables<cfif Arguments.B15>Convertidos</cfif> a, CContables b, CtasMayor c
            where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                and a.Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
                and a.Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
                <cfif GOid NEQ -1 and len(trim(Ocodigos))>
                    and a.Ocodigo in (#Ocodigos#)
                </cfif>
                <cfif ofi NEQ -1>
                    and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
                </cfif>
                and a.Ecodigo = b.Ecodigo
                and a.Ccuenta = b.Ccuenta
                and b.Ecodigo = c.Ecodigo
                and b.Cmayor = c.Cmayor
                and b.Cformato = c.Cmayor
                and c.Ctipo in ('I','G')
            <cfif Arguments.B15>
                and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMonedaConversion#">
                and a.B15 = #lvarB15#
            <cfelseif Arguments.Mcodigo NEQ -1>
                and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Mcodigo#">
            </cfif>
        </cfquery>
        <cfif rsMonto.SaldoFinal EQ "">
        	<cfreturn 0>
        </cfif>		
    	<cfreturn rsMonto.SaldoFinal>
    </cffunction>
    
    
	<cffunction name="fnActualizaCuentas" returntype="string">
		<cfargument name='Ecodigo' 	type='numeric' 	required="yes">
		<cfargument name='campos' 	type='string' 	required="yes">
		<cfargument name='periodo' 	type='numeric' 	required="yes">
		<cfargument name='mes' 		type='numeric' 	required="yes">
		<cfargument name='B15' 		type='boolean' 	required="yes">
		<cfargument name='Mcodigo' 	type='numeric' 	required="yes">
        <cfargument name='GOid' 	type='numeric' 	default="-1">
		<cfargument name='conexion' type='string' 	required='false' default="#Session.DSN#">

		<cfif Arguments.campos EQ "SL">
            <cfset LvarCampos = "SLinicial + DLdebitos - CLcreditos">
        <cfelseif Arguments.campos EQ "SO">
            <cfset LvarCampos = "SOinicial + DOdebitos - COcreditos">
        <cfelseif Arguments.campos EQ "ML">
            <cfset LvarCampos = "DLdebitos - CLcreditos">
        <cfelseif Arguments.campos EQ "MO">
            <cfset LvarCampos = "DOdebitos - COcreditos">
        </cfif>

		<cfsavecontent variable="LvarSubQuery">
        	<cfoutput>
        	coalesce(
            	( 
                	select sum(#LvarCampos#)
                      from SaldosContables<cfif Arguments.B15>Convertidos</cfif>
                      where Ecodigo		= #arguments.Ecodigo#<!---<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">--->
                        and Ccuenta		= #cuentas#.Ccuenta
                        and Speriodo	= #arguments.periodo#<!---<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">--->
                        and Smes		= #arguments.mes#<!---<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">	--->									  										
                    <cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
                        and Ocodigo in (#Ocodigos#)
                    </cfif>
                    <cfif ofi NEQ -1>
                        and Ocodigo 	= #ofi#<!---<cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">--->
                    </cfif>
                    <cfif Arguments.B15>												
                        and Mcodigo		= #lvarMonedaConversion#<!---<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMonedaConversion#">--->
                        and B15			= #lvarB15#
                    <cfelseif Arguments.Mcodigo NEQ -1>
                    	and Mcodigo = #arguments.Mcodigo#<!---<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Mcodigo#">--->
                        and Mcodigo = #cuentas#.Mcodigo    
                    </cfif>
            	)
			, 0.00)
			</cfoutput>
		</cfsavecontent>
        <cfreturn LvarSubQuery>
    </cffunction>
            
</cfcomponent>


