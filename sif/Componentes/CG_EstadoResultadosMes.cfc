<!---------
	Modificado por: Ana Villavicencio
	Fecha de modificación: 28 de junio del 2005
	Motivo:	corrección de error en el tipo de datos en la linea 138 , 
			se cambio el tipo de datos de integer a numeric
	Modificado por: Gustavo Fonseca H.
		Fecha: 7-12-2005
		Motivo: se agrega el parámetro de oficina por que no respetaba el filtro por oficina.

----------->
<cfcomponent>
			<cffunction name="CreaCuentas" access="public" output="false" returntype="string">
			<cf_dbtemp name="CG6_Cer1">
				<cf_dbtempcol name="Ecodigo"  		type="int"    		mandatory="yes">			
				<cf_dbtempcol name="Ccuenta"		type="numeric"		mandatory="yes">
				<cf_dbtempcol name="periodo"		type="int"			mandatory="yes">
				<cf_dbtempcol name="corte"  		type="int">
				<cf_dbtempcol name="nivel"  		type="int">			<!--- 0 --->
				<cf_dbtempcol name="tipo"  			type="char(1)">	
				<cf_dbtempcol name="subtipo"  		type="int">
				<cf_dbtempcol name="ntipo"  		type="char(40)">
				<cf_dbtempcol name="mayor"  		type="char(4)">
				<cf_dbtempcol name="descrip"  		type="char(80)">
				<cf_dbtempcol name="formato"  		type="char(100)">

				<cfloop from="#mes#" to="1" index="i" step="-1">
					<cf_dbtempcol name="saldoini#i#"  	type="money">
					<cf_dbtempcol name="saldofin#i#"  	type="money">			
					<cf_dbtempcol name="debitos#i#"  	type="money">
					<cf_dbtempcol name="creditos#i#"	type="money">		
					<cf_dbtempcol name="movmes#i#"		type="money">
				</cfloop>

				<cf_dbtempcol name="Mcodigo"  		type="numeric">			
				<cf_dbtempcol name="Edescripcion" 	type="char(80)">			
				<cf_dbtempcol name="Cbalancen"  	type="char(1)">
	 
				<cf_dbtempkey cols="Ccuenta">
				<cf_dbtempkey cols="nivel, Ccuenta">
				
			</cf_dbtemp>
			
			<cfreturn temp_table>
		</cffunction>

	<cffunction name='estadoResultados' access='public' output='true' returntype="query">
		<cfargument name='Ecodigo' 	type='numeric' required="yes">
		<cfargument name='oficina' 	type='numeric' required="no">
		<cfargument name='periodo' 	type='numeric' required="yes">
		<cfargument name='mes'		type='numeric' required="yes">
		<cfargument name='nivel' 	type='numeric' default="0">
		<cfargument name='Mcodigo' 	type='numeric' default="-2">
		<cfargument name='ceros' 	type='string' default="S">
		<cfargument name='debug' 	type='string' default="N">								
		<cfargument name='conexion' type='string' required='false' default="#Session.DSN#">
		<cfargument name='unidades' type='numeric' required='false' default="1">
		<cfargument name='GOid' 	type='numeric' required='false' default="-1">

		<!---Argumentos para la traduccion--->
		<cfargument name='MSG_INGRESOS' 					type='string' default="INGRESOS" required="no">
		<cfargument name='MSG_UTILIDAD_BRUTA' 				type='string' default="UTILIDAD BRUTA" required="no">
		<cfargument name='MSG_UTILIDAD_DE_OPERACION' 		type='string' default="UTILIDAD DE OPERACION" required="no">
		<cfargument name='MSG_UTILIDAD_ANTES_DE_IMPUESTOS'	type='string' default="UTILIDAD ANTES DE IMPUESTOS" required="no">
		<cfargument name='MSG_UTILIDAD_NETA' 				type='string' default="UTILIDAD NETA" required="no">
		<cfargument name='MSG_COSTOS_DE_OPERACION' 			type='string' default="COSTOS DE OPERACION" required="no">
		<cfargument name='MSG_GASTOS_ADMINISTRATIVOS' 		type='string' default="GASTOS ADMINISTRATIVOS" required="no">
		<cfargument name='MSG_OTROS_INGRESOS_GRAVABLES' 	type='string' default="OTROS INGRESOS GRAVABLES" required="no">
		<cfargument name='MSG_OTROS_GASTOS_DEDUCIBLES' 		type='string' default="OTROS GASTOS DEDUCIBLES" required="no">
		<cfargument name='MSG_OTROS_INGRESOS_NO_GRAVABLES' 	type='string' default="OTROS INGRESOS NO GRAVABLES" required="no">
		<cfargument name='MSG_OTROS_GASTOS_NO_DEDUCIBLES' 	type='string' default="OTROS GASTOS NO DEDUCIBLES" required="no">
		<cfargument name='MSG_IMPUESTOS' 					type='string' default="IMPUESTOS" required="no">
		
		<cfset mes="#Arguments.mes#">
		<cfset LvarGrupoOficinas = false>
		<cfif isdefined("Arguments.GOid") and Arguments.GOid NEQ -1>
        	<cfset LvarGrupoOficinas = true>
        	<cfquery name="rsGOficinas" datasource="#arguments.conexion#">
            	select Ocodigo
                from AnexoGOficinaDet
                where Ecodigo = #Arguments.Ecodigo#
                  and GOid    = #Arguments.GOid#
                order by Ocodigo
            </cfquery>
			<cfset LvarGOficina = "">
            <cfloop query="rsGOficinas">
				<cfif len(trim(LvarGOficina)) GT 0>
	            	<cfset LvarGOficina = "#LvarGOficina#, #rsGOficinas.Ocodigo#">
				<cfelse>
                	<cfset LvarGoficina = rsGOficinas.Ocodigo>
                </cfif>
            </cfloop>
        </cfif>

		<!--- Creacion de la tabla temporal de Cuentas --->
		<cfset cuentas = this.CreaCuentas()>

		<!--- Variables --->
		<cfset Monloc = -1>
		<cfset titulo = "">
		<cfset rangotipos = "">		
		<cfset Cdescripcion = "">
		<cfset Edescripcion = "">
		<cfif isdefined("arguments.oficina") and arguments.oficina gt -1>
			<cfset ofiini = arguments.oficina>
			<cfset ofifin = arguments.oficina>
		<cfelseif not isdefined("arguments.oficina") or arguments.oficina eq -1>
			<cfset ofiini = -1>
			<cfset ofifin = -1>
		</cfif>
		
		<cfset nivelcuenta = -1>
		<cfset nivelactual = 1>
		<cfset nivelanteri = 0>
		<cfset utilidadsaldo = -1>
		<cfset utilidadmes = -1>
		<cfset Ccuenta = -1>		
		<cfset Cformato = "">
		

<!--- <cf_dump var="#temp_table#"> --->



		<!--- Consulta de Moneda Local --->
		<cfquery name="rs_Monloc" datasource="#arguments.conexion#">
			select Mcodigo 
			from Empresas 
			where Ecodigo = #arguments.Ecodigo#
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
		
		<cfif ofiini EQ -1>
			<cfquery name="rs_OcodigoMin" datasource="#arguments.conexion#">
				select min(Ocodigo) as Ocodigo
				from Oficinas where Ecodigo = #arguments.Ecodigo#
			</cfquery>

			<cfif isdefined('rs_OcodigoMin') and rs_OcodigoMin.recordCount GT 0>
				<cfset ofiini = rs_OcodigoMin.Ocodigo>
			</cfif>
		</cfif>
		
		<cfif ofifin EQ -1>
			<cfquery name="rs_OcodigoMax" datasource="#arguments.conexion#">
				select max(Ocodigo) as OcodigoMax
				from Oficinas 
				where Ecodigo = #arguments.Ecodigo#
			</cfquery>

			<cfif isdefined('rs_OcodigoMax') and rs_OcodigoMax.recordCount GT 0>
				<cfset ofifin = rs_OcodigoMax.OcodigoMax>
			</cfif>
		</cfif>		

		<cfquery name="rs_Par" datasource="#arguments.conexion#">
		 	Select Pvalor
			from Parametros
			where Ecodigo = #arguments.Ecodigo#
			  and Pcodigo = 10
		</cfquery>

		<cfif isdefined('rs_Par') and rs_Par.recordCount GT 0>
			<cfset Cformato = rs_Par.Pvalor>
		</cfif>		

		<cfquery name="rs_Par2" datasource="#arguments.conexion#">
		 	Select <cf_dbfunction name="to_number" datasource="#arguments.conexion#" args="Pvalor"> as Pvalor
			from Parametros
			where Ecodigo = #arguments.Ecodigo#
			  and Pcodigo = 290
		</cfquery>

		<cfif isdefined('rs_Par2') and rs_Par2.recordCount GT 0>
			<cfset Ccuenta = rs_Par2.Pvalor>
		</cfif>		

		<cfif Ccuenta NEQ ''>
			<cfquery name="rs_CContables" datasource="#arguments.conexion#">
				Select 1
				from CContables
				where Ecodigo = #arguments.Ecodigo#
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
			where Ecodigo = #arguments.Ecodigo#
		</cfquery>
			
		<cfif isdefined('rs_EmpresasDes') and rs_EmpresasDes.recordCount GT 0>
			<cfset Edescripcion = rs_EmpresasDes.Edescripcion>
		</cfif>		

		<!--- inserta las cuentas de Mayor --->	  
		<cfquery name="rs_EmpresasDes" datasource="#arguments.conexion#">
			INSERT INTO  	#cuentas# (
							Ecodigo, Edescripcion, mayor, descrip, Ccuenta, periodo, 
							formato,
							<cfloop from="#mes#" to="1" index="i" step="-1">
								saldoini#i#, debitos#i#, creditos#i#, movmes#i#, saldofin#i#,
							</cfloop>				 
							tipo, subtipo, Mcodigo, Cbalancen, nivel)
			SELECT 			#arguments.Ecodigo#
							, '#Edescripcion#'
							, b.Cmayor, b.Cdescripcion, a.Ccuenta, 
							#arguments.periodo#,
							a.Cformato,
							<cfloop from="#mes#" to="1" index="i" step="-1">
								0.00, 0.00, 0.00, 0.00, 0.00,
							</cfloop>
					 		b.Ctipo, b.Csubtipo * 10,
							<cfif arguments.Mcodigo EQ -3>
					  			#lvarMonedaConversion#
					  		<cfelseif arguments.Mcodigo NEQ -2>
								#arguments.Mcodigo#
					  		<cfelse>
                        	<cfif Application.dsinfo[arguments.conexion].type is 'db2'>
                        		CAST (NULL AS numeric)
                        	<cfelse>
                        		null
                        	</cfif> 
					  		</cfif>
							, a.Cbalancen
							, 0
			FROM 			CtasMayor b
								INNER JOIN CContables a 
					 				ON 	b.Ecodigo = a.Ecodigo
									AND b.Cmayor = a.Cmayor
									AND a.Cformato = a.Cmayor
			WHERE 			b.Ecodigo = #arguments.Ecodigo#
			  AND 			b.Ctipo in ('I', 'G') 
			  AND 			b.Csubtipo is not null
		</cfquery>	  

		<cfset nivelactual = 1>
		<cfset nivelanteri = 0>
		<cfloop condition = "nivelactual LESS THAN arguments.nivel">
			<cfquery name="A2_Cuentas" datasource="#arguments.conexion#">
				insert INTO  #cuentas# (
							Ecodigo, Edescripcion, nivel, mayor, descrip, Ccuenta, 
							periodo, 
							formato, 
							<cfloop from="#mes#" to="1" index="i" step="-1">
								saldoini#i#, debitos#i#, creditos#i#, movmes#i#, saldofin#i#,
							</cfloop> 
							tipo, subtipo, Mcodigo, Cbalancen)
				select 
					  		#arguments.Ecodigo#
							, '#Edescripcion#'
							, #nivelactual#
							, b.Cmayor, b.Cdescripcion, b.Ccuenta, 
							#arguments.periodo#,b.Cformato, 
							<cfloop from="#mes#" to="1" index="i" step="-1">
								0.00, 0.00, 0.00, 0.00, 0.00,
							</cfloop>
					a.tipo, a.subtipo
					, <cfif arguments.Mcodigo EQ -3>
						#lvarMonedaConversion#
					  <cfelseif arguments.Mcodigo NEQ -2>
						#arguments.Mcodigo#
					  <cfelse>
                       	<cfif Application.dsinfo[arguments.conexion].type is 'db2'>CAST (NULL AS numeric)<cfelse>null</cfif> 
					  </cfif>
					, b.Cbalancen
				from #cuentas# a
					inner join CContables b
							on b.Cpadre = a.Ccuenta
				where a.nivel = #nivelanteri#
			</cfquery>
		
			<cfset nivelanteri = nivelactual>
			<cfset nivelactual = nivelactual + 1>
		</cfloop>

		<cfquery name="rsCuenta" datasource="#Arguments.conexion#">
			select coalesce(max(Ccuenta), 0) + 1 as Ccuenta
			from #cuentas#
		</cfquery>
		<cfif rsCuenta.recordCount>
			<cfset next_cuenta = rsCuenta.Ccuenta>
		<cfelse>
			<cfset next_cuenta = 1>
		</cfif>

		<!--- INSERTAR UTILIDAD BRUTA LA CTA MAYOR APARECE CON UN 0 ASI QUE NO DEBE PINTARSE EN PANTALLA --->
		<cfquery name="rsUtil1" datasource="#Arguments.conexion#">
			insert INTO #cuentas# (
							Ecodigo, Edescripcion, nivel, mayor, descrip, Ccuenta, 
							periodo,
							formato, 
							<cfloop from="#mes#" to="1" index="i" step="-1">
								saldoini#i#, debitos#i#, creditos#i#, movmes#i#, saldofin#i#,
							</cfloop>
				tipo, subtipo, Mcodigo, Cbalancen, corte, ntipo)
			values (
							#arguments.Ecodigo#
							, ''
							, 0
							, '0', ''
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#next_cuenta#">
							, #arguments.periodo#
							,'0', 
							<cfloop from="#mes#" to="1" index="i" step="-1">
								0.00, 0.00, 0.00, 0.00, 0.00,
							</cfloop>
				'I', 25
				, <cfif arguments.Mcodigo EQ -3>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMonedaConversion#">
				  <cfelseif arguments.Mcodigo NEQ -2>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">
				  <cfelse>
					null
				  </cfif>
				, 'C'
				, 25
				, '#MSG_UTILIDAD_BRUTA#'
			)
		</cfquery>
		<cfset next_cuenta = next_cuenta + 1>


		<!--- INSERTAR UTILIDAD DE OPERACION LA CTA MAYOR APARECE CON UN 0 ASI QUE NO DEBE PINTARSE EN PANTALLA --->
		<cfquery name="rsUtil1" datasource="#Arguments.conexion#">
			insert INTO #cuentas# (
							Ecodigo, Edescripcion, nivel, mayor, descrip, Ccuenta, 
							periodo, 
							formato, 
							<cfloop from="#mes#" to="1" index="i" step="-1">
								saldoini#i#, debitos#i#, creditos#i#, movmes#i#, saldofin#i#,
							</cfloop>
				tipo, subtipo, Mcodigo, Cbalancen, corte, ntipo)
			values (
							#arguments.Ecodigo#
							, ''
							, 0
							, '0', ''
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#next_cuenta#">
							, #arguments.periodo#
							,'0', 
							<cfloop from="#mes#" to="1" index="i" step="-1">
								0.00, 0.00, 0.00, 0.00, 0.00,
							</cfloop>
				'I', 35
				, <cfif arguments.Mcodigo EQ -3>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMonedaConversion#">
				  <cfelseif arguments.Mcodigo NEQ -2>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">
				  <cfelse>
					null
				  </cfif>
				, 'C'
				, 35
				, '#MSG_UTILIDAD_DE_OPERACION#'
			)
		</cfquery>
		<cfset next_cuenta = next_cuenta + 1>

		<!--- INSERTAR UTILIDAD ANTES DE IMPUESTOS LA CTA MAYOR APARECE CON UN 0 ASI QUE NO DEBE PINTARSE EN PANTALLA --->
		<cfquery name="rsUtil2" datasource="#Arguments.conexion#">
			insert INTO #cuentas# (
							Ecodigo, Edescripcion, nivel, mayor, descrip, Ccuenta, 
							periodo,
							formato, 
							<cfloop from="#mes#" to="1" index="i" step="-1">
								saldoini#i#, debitos#i#, creditos#i#, movmes#i#, saldofin#i#,
							</cfloop>
				tipo, subtipo, Mcodigo, Cbalancen, corte, ntipo)
			values (
							#arguments.Ecodigo#
							, ''
							, 0
							, '0', ''
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#next_cuenta#">
							, #arguments.periodo#
							,'0', 
							<cfloop from="#mes#" to="1" index="i" step="-1">
								0.00, 0.00, 0.00, 0.00, 0.00,
							</cfloop>
				'I', 55
				, <cfif arguments.Mcodigo EQ -3>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMonedaConversion#">
				  <cfelseif arguments.Mcodigo NEQ -2>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">
				  <cfelse>
					null
				  </cfif>
				, 'C'
				, 55
				, '#MSG_UTILIDAD_ANTES_DE_IMPUESTOS#'
			)
		</cfquery>
		<cfset next_cuenta = next_cuenta + 1>

		<!--- INSERTAR UTILIDAD ANTES DE IMPUESTOS LA CTA MAYOR APARECE CON UN 0 ASI QUE NO DEBE PINTARSE EN PANTALLA --->
		<cfquery name="rsUtil3" datasource="#Arguments.conexion#">
			insert INTO #cuentas# (
							Ecodigo, Edescripcion, nivel, mayor, descrip, Ccuenta, 
							periodo,
							formato, 
							<cfloop from="#mes#" to="1" index="i" step="-1">
								saldoini#i#, debitos#i#, creditos#i#, movmes#i#, saldofin#i#,
							</cfloop> 
				tipo, subtipo, Mcodigo, Cbalancen, corte, ntipo)
			values (
							#arguments.Ecodigo#
							, ''
							, 0
							, '0', ''
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#next_cuenta#">
 							, #arguments.periodo#
							,'0', 
							<cfloop from="#mes#" to="1" index="i" step="-1">
								0.00, 0.00, 0.00, 0.00, 0.00,
							</cfloop> 
				'I', 85
				, <cfif arguments.Mcodigo EQ -3>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMonedaConversion#">
				  <cfelseif arguments.Mcodigo NEQ -2>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">
				  <cfelse>
					null
				  </cfif>
				, 'C'
				, 85
				, '#MSG_UTILIDAD_NETA#'
			)
		</cfquery>
				
		<cfif arguments.debug EQ 'S'>
			<cfquery name="All_Cuentas" datasource="#arguments.conexion#">
				select 		Ecodigo, corte, nivel, tipo, ntipo, mayor, Ccuenta, descrip, formato, 
							<cfloop from="#mes#" to="1" index="i" step="-1">
								saldoini#i#, debitos#i#, creditos#i#, movmes#i#, saldofin#i#,
							</cfloop> 
				Mcodigo, Edescripcion, Cbalancen 
				from #cuentas#
			</cfquery>
			
			<cfif isdefined('All_Cuentas') and All_Cuentas.recordCount GT 0>
				<cfdump var="#All_Cuentas#" label="Cuentas TMP">
			</cfif>
		</cfif>
		<cfset LvarRangoOficinas = "and Ocodigo between #Ofiini# and #ofifin#">
		<cfif LvarGrupoOficinas EQ true>
        	<cfset LvarRangoOficinas = " and Ocodigo in (#LvarGOficina#) ">
        </cfif>
		<cfif arguments.Mcodigo EQ -3 or arguments.Mcodigo EQ -4>
			<!--- Carga la informacion del mes--->
			<cfloop from="#mes#" to="1" index="i" step="-1">
				<cfquery datasource="#arguments.conexion#">
					update #cuentas# set 
						saldoini#i# = coalesce(( select sum(SLinicial)
							from SaldosContablesConvertidos
							where Ccuenta = #cuentas#.Ccuenta
							and Speriodo = #cuentas#.periodo
							and Smes = #i#
							#LvarRangoOficinas#
							and Mcodigo = #lvarMonedaConversion#
							and B15 = #lvarB15#
							), 0.00),
						debitos#i# =  coalesce((  select sum(DLdebitos)
							from SaldosContablesConvertidos
							where Ccuenta = #cuentas#.Ccuenta
							and Speriodo = #cuentas#.periodo
							and Smes = #i#
							#LvarRangoOficinas#
							and Mcodigo = #lvarMonedaConversion#
							and B15 = #lvarB15#
							), 0.00),
						creditos#i# =  coalesce((  select sum(CLcreditos)
											  from SaldosContablesConvertidos
											  where Ccuenta = #cuentas#.Ccuenta
											  and Speriodo = #cuentas#.periodo
											  and Smes = #i#
											  #LvarRangoOficinas#
											  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMonedaConversion#">
											  and B15 = #lvarB15#
												), 0.00)
				</cfquery>
			</cfloop>


		<cfelseif arguments.Mcodigo EQ -2>
			<!--- Carga la informacion del mes y año actual --->
			<cfloop from="#mes#" to="1" index="i" step="-1">
				<cfquery datasource="#arguments.conexion#">
					update #cuentas# set 
						saldoini#i# = coalesce(( select sum(SLinicial)
											from SaldosContables
											where Ccuenta = #cuentas#.Ccuenta
											  and Speriodo = #cuentas#.periodo
											  and Smes = #i#
											  #LvarRangoOficinas#
											  ), 0.00),
						debitos#i# =  coalesce((  select sum(DLdebitos)
											  from SaldosContables
											  where Ccuenta = #cuentas#.Ccuenta
											  and Speriodo = #cuentas#.periodo
											  and Smes = #i#
											  #LvarRangoOficinas#
												), 0.00),
						creditos#i# =  coalesce((  select sum(CLcreditos)
											  from SaldosContables
											  where Ccuenta = #cuentas#.Ccuenta
											  and Speriodo = #cuentas#.periodo
											  and Smes = #i#
											  #LvarRangoOficinas#
												), 0.00)
				</cfquery>
			</cfloop>
			
				
		<cfelse>
			<!--- Carga la informacion del mes y año actual --->
			<cfloop from="#mes#" to="1" index="i" step="-1">
				<cfquery datasource="#arguments.conexion#">
					 update #cuentas#
						 set 
							 saldoini#i# = coalesce(
								(select sum(SOinicial)
									from SaldosContables a
									where Ccuenta = #cuentas#.Ccuenta
									  and Speriodo = #cuentas#.periodo
									  and Smes = #i#
									  and a.Mcodigo = #cuentas#.Mcodigo
									  and a.Mcodigo = #arguments.Mcodigo#
									  #LvarRangoOficinas#
								)
								, 0.00),
							 debitos#i# =  coalesce(
							 	(select sum(DOdebitos)
									from SaldosContables a
									where Ccuenta = #cuentas#.Ccuenta
									  and Speriodo = #cuentas#.periodo
									  and Smes = #i#
									  and a.Mcodigo = #cuentas#.Mcodigo
									  and a.Mcodigo = #arguments.Mcodigo#
									  #LvarRangoOficinas#
								), 0.00),
							 creditos#i# =  coalesce(
							 	(select sum(COcreditos)
									from SaldosContables a
									where Ccuenta = #cuentas#.Ccuenta
									  and Speriodo = #cuentas#.periodo
									  and Smes = #i#
									  and a.Mcodigo = #cuentas#.Mcodigo
									  and a.Mcodigo = #arguments.Mcodigo#
									  #LvarRangoOficinas#
								), 0.00)
				</cfquery>
			</cfloop>			
		</cfif>
		<cfloop from="#mes#" to="1" index="i" step="-1">
			<cfquery datasource="#arguments.conexion#">
				UPDATE #cuentas# SET
					saldofin#i# = (saldoini#i# + debitos#i# - creditos#i#),
					movmes#i# = (coalesce(debitos#i#,0.00) - coalesce(creditos#i#,0.00))	
			</cfquery>
		</cfloop>

		<!--- Actualizar UTILIDAD BRUTA --->

		<cfloop from="#mes#" to="1" index="i" step="-1">
			<cfquery datasource="#arguments.conexion#">
				update #cuentas# 
					set saldofin#i# = (
						select sum(saldofin#i#)
						from #cuentas#
						where nivel = 0
						and subtipo < 25
						and subtipo in (10, 20)
					),
					movmes#i# = coalesce((
						select sum(movmes#i#)
						from #cuentas#
						where nivel = 0
						and subtipo < 25
						and subtipo in (10, 20)
					), 0.00)
				where subtipo = 25
			</cfquery>
		</cfloop>	


		<!--- Actualizar UTILIDAD DE OPERACION --->
		<cfloop from="#mes#" to="1" index="i" step="-1">
			<cfquery datasource="#arguments.conexion#">
				update #cuentas# 
					set saldofin#i# = (
						select sum(saldofin#i#)
						from #cuentas#
						where nivel = 0
						and subtipo < 35
						and subtipo in (10, 20, 30)
					),
					movmes#i# = coalesce((
						select sum(movmes#i#)
						from #cuentas#
						where nivel = 0
						and subtipo < 35
						and subtipo in (10, 20, 30)
					), 0.00)
				where subtipo = 35
			</cfquery>
		</cfloop>


		<!--- Actualizar UTILIDAD ANTES DE IMPUESTOS --->
		<cfloop from="#mes#" to="1" index="i" step="-1">
			<cfquery datasource="#arguments.conexion#">
				update #cuentas# 
					set saldofin#i# = (
						select sum(saldofin#i#)
						from #cuentas#
						where nivel = 0
						and subtipo < 55
						and subtipo in (10, 20, 30, 40, 50)
					),
					movmes#i# = coalesce((
						select sum(movmes#i#)
						from #cuentas#
						where nivel = 0
						and subtipo < 55
						and subtipo in (10, 20, 30, 40, 50)
					), 0.00)
				where subtipo = 55
			</cfquery>
		</cfloop>

		<!--- Actualizar UTILIDAD NETA --->
		<cfloop from="#mes#" to="1" index="i" step="-1">
			<cfquery datasource="#arguments.conexion#">
				update #cuentas# 
					set saldofin#i# = coalesce((
						select sum(saldofin#i#)
						from #cuentas#
						where nivel = 0
						and subtipo < 85
						and subtipo in (10, 20, 30, 40, 50, 60, 70, 80)
					), 0.00),
					movmes#i# = coalesce((
						select sum(movmes#i#)
						from #cuentas#
						where nivel = 0
						and subtipo < 85
						and subtipo in (10, 20, 30, 40, 50, 60, 70, 80)
					), 0.00)
				where subtipo = 85
			</cfquery>
		</cfloop>

		<cfif arguments.ceros NEQ 'S'>
			<cfquery datasource="#arguments.conexion#">
			    delete from #cuentas#
				where saldofin1 = 0.00 and movmes1 = 0.00
				<cfloop from="#mes#" to="1" index="i" step="-1">
					and saldofin#i# = 0.00 and movmes#i# = 0.00 
				</cfloop>
			</cfquery>
		</cfif>


		<cfif Arguments.Unidades NEQ 1>
			<cfloop from="#mes#" to="1" index="i" step="-1">
				<cfquery datasource="#arguments.conexion#">
					update #cuentas#
					set 
						saldofin#i# = saldofin#i# / #Arguments.Unidades#,
						movmes#i# = movmes#i# / #Arguments.Unidades#,
				</cfquery>
			</cfloop>
		</cfif>

		<cfloop from="#mes#" to="1" index="i" step="-1">
			<cfquery datasource="#arguments.conexion#">
				update #cuentas#
					set saldofin#i# = (saldofin#i# * -1), movmes#i# = (movmes#i# * -1)
				where Cbalancen = 'C'
			</cfquery>
		</cfloop>
	
		
		<cfquery datasource="#arguments.conexion#">
			update #cuentas#
				set corte = 10, ntipo = '#MSG_INGRESOS#'
			where tipo = 'I' and subtipo = 10
		</cfquery>		

		<cfquery datasource="#arguments.conexion#">
			update #cuentas#
				set corte = 20, ntipo = '#MSG_COSTOS_DE_OPERACION#'
			where tipo = 'G' and subtipo = 20
		</cfquery>		
		    
		<cfquery datasource="#arguments.conexion#">
			update #cuentas#
				set corte = 30, ntipo = '#MSG_GASTOS_ADMINISTRATIVOS#'
			where tipo = 'G' and subtipo = 30
		</cfquery>		

		<cfquery datasource="#arguments.conexion#">
			update #cuentas#
				set corte = 40, ntipo = '#MSG_OTROS_INGRESOS_GRAVABLES#'
			where tipo = 'I' and subtipo = 40
		</cfquery>		

		<cfquery datasource="#arguments.conexion#">
			update #cuentas#
				set corte = 50, ntipo = '#MSG_OTROS_GASTOS_DEDUCIBLES#'
			where tipo = 'G' and subtipo = 50
		</cfquery>		
	    
		<cfquery datasource="#arguments.conexion#">
			update #cuentas#
				set corte = 60, ntipo = '#MSG_OTROS_INGRESOS_NO_GRAVABLES#'
			where tipo = 'I' and subtipo = 60
		</cfquery>		

		<cfquery datasource="#arguments.conexion#">
			update #cuentas#
				set corte = 70, ntipo = '#MSG_OTROS_GASTOS_NO_DEDUCIBLES#'
			where tipo = 'G' and subtipo = 70
		</cfquery>		
	    
		<cfquery datasource="#arguments.conexion#">
			update #cuentas#
				set corte = 80, ntipo = '#MSG_IMPUESTOS#'
			where tipo = 'G' and subtipo = 80
		</cfquery>

		
		<cfquery name="rs_Resultante" datasource="#arguments.conexion#">
			select 
				periodo,
				Edescripcion as Empresa,
				corte,
				nivel,
				tipo,
				subtipo,
				ntipo,
				mayor,
				Ccuenta,
				descrip,
				formato,
				<cfloop from="#mes#" to="1" index="i" step="-1">
					saldoini#i#,
					debitos#i#,
					creditos#i#,
					movmes#i#,
					saldofin#i#,
				</cfloop>
				#now()# as fecha,
				Cbalancen
			from #cuentas# 
			order by corte, mayor, formato
		</cfquery>
		<cfreturn rs_Resultante>
	</cffunction>
</cfcomponent>