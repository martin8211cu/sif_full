<!---►►Balance General◄◄--->
<cfcomponent>
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
			<cf_dbtempcol name="saldofin"  		type="money">			
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
            <cf_dbtempcol name="PadreExclusion" type="char(1)"><!---Indica que es padre de alguna cuenta de exclusión--->
			<cf_dbtempkey cols="Ccuenta">
		</cf_dbtemp>
		
		<cfreturn temp_table>		
	</cffunction>	
	
	<cffunction name='balanceGeneral' access='public' output='true' returntype="query">
		<cfargument name='Ecodigo' 			type='numeric' required="false">
		<cfargument name='periodo' 			type='numeric' required="yes">
		<cfargument name='mes' 				type='numeric' required="yes">
		<cfargument name='nivel' 			type='numeric' required="yes"	default="0">
		<cfargument name='Mcodigo' 			type='numeric' required="yes"	default="-2">
		<cfargument name='Ocodigo' 			type='numeric' required="yes"	default="-1">		
		<cfargument name='GOid' 			type='numeric' required="yes"	default="-1">
		<cfargument name='ceros' 			type='string'  required="yes"	default="S">
		<cfargument name='debug' 			type='string'  required="yes"	default="N">	
        <cfargument name='TipoCalculo' 		type='string'  required="yes"	default="A" hint="A-Anual - M-Mensual">								
		<cfargument name='conexion' 		type='string'  required='false'>
        <cfargument name='MascarasExcluir' 	type="array"   required='false' hint="El listado de cuentas que se pasen en este Array se excluiran">
        <cfargument name='MascarasIncluir' 	type="array"   required='false' hint="El listado de cuentas que se pasen en este Array, son las unicas que se tomaran en cuenta">
		<cfargument name='DescAlt' 			type='string' required="yes">
		<cfargument name='TipoCmb' 			type='numeric' required="yes">
        
        <!---►►Las variables que no se enviaron, se buscan en session◄◄--->
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        
		<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
        <cfquery name="rsDescAlt" datasource="#Session.DSN#">
            select Pvalor
            from Parametros
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
                and Pcodigo = 99
        </cfquery>

		<!---►►Variables◄◄--->
        <cf_dbfunction name="OP_concat" returnvariable="_Cat">
		<cfset Monloc        	= -1>
		<cfset titulo        	= "">
		<cfset rangotipos    	= "">		
		<cfset Cdescripcion  	= "">
		<cfset Edescripcion  	= "">	
		<cfset nivelcuenta 	 	= -1>
		<cfset nivelactual 	 	= 1>
		<cfset nivelanteri 	 	= 0>
		<cfset utilidadsaldo 	= -1>
		<cfset utilidadmes   	= -1>
		<cfset Ccuenta       	= -1>		
		<cfset Cformato      	= "">
		<cfset ofi 			 	= -1>
		<cfset Ocodigos      	= "-1">
		<cfset utilidadmesA  	= 0>
		<cfset utilidadsaldoA 	= 0>
       
        <!---►►Se Calcula el Periodo y Mes Anterior, dependiendo si el tipo de Reporte sea Anual o Mensual◄◄--->
		<cfif Arguments.TipoCalculo EQ "A">
			<cfset periodoanterior = (arguments.periodo - 1)>
            <cfset Mesanterior = Arguments.mes>
        <cfelse>
        	<cfif Arguments.mes EQ 1>
            	<cfset periodoanterior = (arguments.periodo - 1)>
                <cfset Mesanterior = 12>
            <cfelse>
            	<cfset periodoanterior = arguments.periodo>
                <cfset Mesanterior = arguments.mes -1>
            </cfif>
        </cfif>
        
		<!---►►En caso de que el código de la oficina venga como parámetro◄◄--->
		<cfif arguments.Ocodigo NEQ -1>
			<cfset ofi = arguments.Ocodigo>
		</cfif>
       
		<!---►►Obtengo las oficinas del grupo◄◄--->
		<cfif isDefined("arguments.GOid") and arguments.GOid neq -1>
			<cfquery name="rsOficinasXGrupo" datasource="#Session.DSN#">
				select Ocodigo
				from AnexoGOficinaDet
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and GOid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.GOid#">
			</cfquery>	
			<cfif rsOficinasXGrupo.recordCount gt 0>
				<cfset arrTemp  = ArrayNew(1)>
				<cfloop query="rsOficinasXGrupo">
					<cfset temp = ArrayAppend(arrTemp,#rsOficinasXGrupo.Ocodigo#)>
				</cfloop>
				<cfset Ocodigos = ArrayToList(arrTemp)>						
			</cfif>						
		</cfif>
		
        <!---►►Obtencion de la moneda del reporte◄◄--->
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
				<cfset MSG_MonInfB15 = t.Translate('MSG_MonInfB15','No se ha definido la Moneda de Informe B15 en Parámetros')>
				<cfthrow message="#MSG_MonInfB15#">
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

		<!---►►Obtencion de la mascara generica◄◄--->
		<cfquery name="rs_Par" datasource="#arguments.conexion#">
		 	Select Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and Pcodigo = 10
		</cfquery>
		<cfif isdefined('rs_Par') and rs_Par.recordCount GT 0>
			<cfset Cformato = rs_Par.Pvalor>
		</cfif>		

		<!---►►◄◄--->
		<cfquery name="rs_Par2" datasource="#arguments.conexion#">
		 	Select <cf_dbfunction name="to_number" datasource="#arguments.conexion#" args="Pvalor"> as Pvalor
			 from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and Pcodigo = 290
		</cfquery>
		<cfif isdefined('rs_Par2') and rs_Par2.recordCount GT 0>
			<cfset Ccuenta = rs_Par2.Pvalor>
		</cfif>		
		<cfset MSG_NECuenta = t.Translate('MSG_NECuenta','No existe la cuenta indicada. Proceso Cancelado !')>
		<cfif Ccuenta NEQ ''>
			<cfquery name="rs_CContables" datasource="#arguments.conexion#">
				Select 1
				from CContables
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
				  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Ccuenta#">
			</cfquery>		
			<cfif isdefined('rs_CContables') and rs_CContables.recordCount EQ 0>
				<cf_errorCode	code = "51059" msg = "#MSG_NECuenta#">
			</cfif>
		<cfelse>
			<cf_errorCode	code = "51059" msg = "MSG_NECuenta">		
		</cfif>

		<!---►►Obtencion de la descripcion de la empresa◄◄--->
		<cfquery name="rs_EmpresasDes" datasource="#arguments.conexion#">
			Select Edescripcion
			from Empresas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
		<cfif isdefined('rs_EmpresasDes') and rs_EmpresasDes.recordCount GT 0>
			<cfset Edescripcion = rs_EmpresasDes.Edescripcion>
		</cfif>
        
        <!---►►Creacion de la tabla temporal de Cuentas◄◄--->
		<cfset cuentas = this.CreaCuentas()>
        
		<!---
			►►Mascaras de Exclusion e Inclusion◄◄
        	Por Ahora Unicamente esta implementado para Saldo Inicial, Saldo Final, Debitos y Creditos, en moneda local.
			Esta Funcionalidad se usa Unicamente en el Reporte de "Estado de Cambios en la Situación Financiera con Base de Efectivo", ya que se 
			Requiere eliminar las cuentas referentes al movimiento en Bancos y las referentes a las depreciaciones Acumuladas, ambas cuentas de ACTIVO.
			Si en algun momento se Usara estos Dos parametros en otro Reporte tener en cuenta que habria que expandir su funcionalidad.
        --->


		<!---(1) MascarasExcluir: Se Remplazan las Mascaras por Cuentas de Ultimo Nivel--->
		<cfif isdefined('Arguments.MascarasExcluir') and ARRAYLEN(Arguments.MascarasExcluir) GT 0>
            <cfquery name="rsCuentasExclusion" datasource="#Arguments.conexion#">
                select Cformato 
                    from CContables 
                where Cmovimiento = 'S' 
                  and Ecodigo     = #Arguments.Ecodigo# 
                  and (
                      <cfloop from="1" to="#ArrayLEN(Arguments.MascarasExcluir)#" index="IndiMask">
                        <cfif IndiMask GT 1>OR </cfif>
                          Rtrim(Cformato) like '#TRIM(Arguments.MascarasExcluir[IndiMask])#'
                      </cfloop>
                      )
            </cfquery>
            <cfset Arguments.MascarasExcluir = QueryToArray(rsCuentasExclusion)>
		</cfif>
        <!---(2)MascarasIncluir: Se Remplazan las Mascaras por Cuentas de Ultimo Nivel--->
		<cfif isdefined('Arguments.MascarasIncluir') and ARRAYLEN(Arguments.MascarasIncluir) GT 0>
            <cfquery name="rsCuentasInclusion" datasource="#Arguments.conexion#">
                select Cformato 
                    from CContables 
                where Cmovimiento = 'S' 
                  and Ecodigo     = #Arguments.Ecodigo# 
                  and (
                      <cfloop from="1" to="#ArrayLEN(Arguments.MascarasIncluir)#" index="IndiMask">
                        <cfif IndiMask GT 1>OR </cfif>
                          Rtrim(Cformato) like '#TRIM(Arguments.MascarasIncluir[IndiMask])#'
                      </cfloop>
                      )
            </cfquery>
            <cfset Arguments.MascarasIncluir = QueryToArray(rsCuentasInclusion)>
		</cfif>
        <!---(3)Where de las Cuentas de Exlusion--->
        <cfsavecontent variable="whereCuentasExclusion"> 
		 <cfif isdefined('Arguments.MascarasExcluir') and ARRAYLEN(Arguments.MascarasExcluir) GT 0>
              	and (
                	<cfloop from="1" to="#ArrayLEN(Arguments.MascarasExcluir)#" index="IndiMask">
                    	<cfif IndiMask GT 1>OR </cfif>
                        NOT <cf_dbfunction name="like"	args="'#Arguments.MascarasExcluir[IndiMask].Cformato#',Rtrim(b.Cformato)#_Cat# '%'">
                    </cfloop>
                	)
              </cfif>
       </cfsavecontent>
       <!---(4)Where de las Cuentas de Exlusion--->
       <cfsavecontent variable="whereCuentasInclusion">
		  <cfif isdefined('Arguments.MascarasIncluir') and ARRAYLEN(Arguments.MascarasIncluir) GT 0>
            and (
                <cfloop from="1" to="#ArrayLEN(Arguments.MascarasIncluir)#" index="IndiMask">
                    <cfif IndiMask GT 1>OR </cfif>
                     <cf_dbfunction name="like"	args="'#Arguments.MascarasIncluir[IndiMask].Cformato#',Rtrim(b.Cformato)#_Cat# '%'">
                </cfloop>
                ) 
          </cfif>
       </cfsavecontent>
       <!---Las cuentas Padres de la mascara, que se excluyen--->
   		<cfsavecontent variable="LvarMarcarPadreExlusion">
          <cfif isdefined('Arguments.MascarasExcluir') and ARRAYLEN(Arguments.MascarasExcluir) GT 0>
        	 CASE WHEN(
             <cfloop from="1" to="#ArrayLEN(Arguments.MascarasExcluir)#" index="IndiMask">
             	<cfif IndiMask GT 1>OR </cfif>
                <cf_dbfunction name="like"	args="'#REPLACE(Arguments.MascarasExcluir[IndiMask].Cformato,"%","","ALL")#',rtrim(b.Cformato)#_Cat#'%'">      
             </cfloop>
             		 )THEN '1' ELSE '0' END
           <cfelse>
           		'0'
           </cfif>
        </cfsavecontent>
	   <!---MascarasExcluir: Las cuentas Hijas de la mascara, que se excluyen--->
        <cfsavecontent variable="LvarMascarasExclusion">
        	<cfif isdefined('Arguments.MascarasExcluir') and ARRAYLEN(Arguments.MascarasExcluir) GT 0>
                    and (
                    <cfloop from="1" to="#ArrayLEN(Arguments.MascarasExcluir)#" index="IndiMask">
                        <cfif IndiMask GT 1>OR </cfif>
                         b.Cformato NOT like '#Arguments.MascarasExcluir[IndiMask].Cformato#'
                    </cfloop>
                    )
             </cfif>
        </cfsavecontent>
        <!---MascarasIncluir: Las cuentas Hijas de la mascara, que se Incluyen--->
        <cfsavecontent variable="LvarMascarasInclusion">
        	<cfif isdefined('Arguments.MascarasIncluir') and ARRAYLEN(Arguments.MascarasIncluir) GT 0>
                    and (
                    <cfloop from="1" to="#ArrayLEN(Arguments.MascarasIncluir)#" index="IndiMask">
                        <cfif IndiMask GT 1>OR </cfif>
                         b.Cformato like '#Arguments.MascarasIncluir[IndiMask].Cformato#'
                    </cfloop>
                    )
             </cfif>
        </cfsavecontent>
       
		<!---Suma de los Saldos de las Cuentas a Excluir--->
        <cfsavecontent variable="LvarSaldoExluidos">
        	<cfif isdefined('Arguments.MascarasExcluir') and ARRAYLEN(Arguments.MascarasExcluir) GT 0>
                SaldosContables sc
                     inner join CContables cc
                        on cc.Ecodigo = sc.Ecodigo
                        and cc.CCuenta = sc.CCuenta
                 <!---Cuentas que cumplan con los filtros  de entrada--->
                 where sc.Ecodigo  = #cuentas#.Ecodigo
                   and sc.Speriodo = #arguments.periodo#
                   and sc.Smes     = #arguments.mes#
                  <cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>and sc.Ocodigo in (#Ocodigos#)</cfif>
                  <cfif ofi NEQ -1> and sc.Ocodigo  = #ofi#</cfif>
                  <!---Cuentas que Acepten movimientos--->
                  and cc.Cmovimiento = 'S'
                 <!---Cuentas que cumplen con las mascaras de Exclusion--->
                   and (
                      <cfloop from="1" to="#ArrayLEN(Arguments.MascarasExcluir)#" index="IndiMask">
                        <cfif IndiMask GT 1>OR </cfif>
                        <cf_dbfunction name="like"	args="'#Arguments.MascarasExcluir[IndiMask].Cformato#',rtrim(cc.Cformato)#_Cat#'%'">
                      </cfloop>
                       )
                  <!---Cuentas Hijas de la cuenta que se esta procesando--->
                   and <cf_dbfunction name="like"	args="rtrim(cc.Cformato),rtrim(#cuentas#.formato) #_Cat#'%'">
               </cfif>
        </cfsavecontent>
        <!---Suma de los Saldos de las Cuentas a Excluir del Periodo o Mes anterior--->
        <cfsavecontent variable="LvarSaldoExluidosA">
            <cfif isdefined('Arguments.MascarasExcluir') and ARRAYLEN(Arguments.MascarasExcluir) GT 0>
                SaldosContables sc
                     inner join CContables cc
                        on cc.Ecodigo = sc.Ecodigo
                        and cc.CCuenta = sc.CCuenta
                 <!---Cuentas que cumplan con los filtros  de entrada--->
                 where sc.Ecodigo  = #cuentas#.Ecodigo
                   and sc.Speriodo = #periodoanterior#
                   and sc.Smes     = #mesanterior#
                  <cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>and sc.Ocodigo in (#Ocodigos#)</cfif>
                  <cfif ofi NEQ -1> and sc.Ocodigo  = #ofi#</cfif>
                  <!---Cuentas que Acepten movimientos--->
                  and cc.Cmovimiento = 'S'
                 <!---Cuentas que cumplen con las mascaras de Exclusion--->
                   and (
                      <cfloop from="1" to="#ArrayLEN(Arguments.MascarasExcluir)#" index="IndiMask">
                        <cfif IndiMask GT 1>OR </cfif>
                        <cf_dbfunction name="like"	args="'#Arguments.MascarasExcluir[IndiMask].Cformato#',rtrim(cc.Cformato)#_Cat#'%'">
                      </cfloop>
                       )
                  <!---Cuentas Hijas de la cuenta que se esta procesando--->
                   and <cf_dbfunction name="like"	args="rtrim(cc.Cformato),rtrim(#cuentas#.formato) #_Cat#'%'">
               </cfif>
        </cfsavecontent>
                        
		<!---►►insert a las cuentas de Mayor◄◄--->	  
		<cfquery name="rs_EmpresasDes" datasource="#arguments.conexion#">
			insert INTO  #cuentas# (Ecodigo, Edescripcion, mayor, descrip, Ccuenta, formato, saldoini, debitos, creditos, movmes, saldofin,
			saldoiniA, debitosA, creditosA, saldofinA,tipo, Mcodigo, Cbalancen, nivel,PadreExclusion)
			select 	#arguments.Ecodigo#
					, '#Edescripcion#'
					, a.Cmayor, 
                    <cfswitch expression = "#arguments.DescAlt#">
                        <cfcase value="L">
                            <cfif #rsDescAlt.Pvalor# eq 0> a.Cdescripcion, <cfelse> a.CdescripcionA, </cfif>
                        </cfcase>
                        <cfcase value="A">
                            <cfif #rsDescAlt.Pvalor# eq 0> a.CdescripcionA, <cfelse> a.Cdescripcion,</cfif>
                        </cfcase>
                    </cfswitch>
                    b.Ccuenta, b.Cformato, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, a.Ctipo
					, 	<cfif arguments.Mcodigo EQ -3>
							#lvarMonedaConversion#
						<cfelseif arguments.Mcodigo NEQ -2>
							#arguments.Mcodigo#
						<cfelse>
                        	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
						</cfif>
					, b.Cbalancen
					, 0
                    ,#PreserveSingleQuotes(LvarMarcarPadreExlusion)#
					
			from CtasMayor a
             inner join CContables b 
             	on b.Ecodigo  = a.Ecodigo
			   and b.Cformato = a.Cmayor
			where a.Ecodigo = #arguments.Ecodigo#
			  and a.Ctipo not in ('I', 'G', 'O')
              #PreserveSingleQuotes(whereCuentasInclusion)# 
		</cfquery>

		<!---►►Se insertan cada una de las cuentas◄◄--->
		<cfset nivelactual = 1>
		<cfset nivelanteri = 0>
		<cfloop condition = "nivelactual LESS THAN arguments.nivel">
			<cfquery name="A2_Cuentas" datasource="#arguments.conexion#">
				insert INTO  #cuentas# (Ecodigo, Edescripcion, nivel, mayor, descrip, Ccuenta, formato, saldoini, debitos, creditos, movmes, saldofin,
				saldoiniA, debitosA, creditosA, saldofinA,tipo, Mcodigo, Cbalancen,PadreExclusion)
				select #arguments.Ecodigo#
					, '#Edescripcion#'
					, #nivelactual#
					, b.Cmayor,
                    <cfswitch expression = "#arguments.DescAlt#">
                    	<cfcase value="L">
                        	<cfif #rsDescAlt.Pvalor# eq 0>  b.Cdescripcion, <cfelse> p.PCDdescripcionA, </cfif>
                        </cfcase>
                    	<cfcase value="A">
                        	<cfif #rsDescAlt.Pvalor# eq 0> p.PCDdescripcionA, <cfelse> b.Cdescripcion,</cfif>
                        </cfcase>
                    </cfswitch>
                      b.Ccuenta, b.Cformato, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, a.tipo
					, 	<cfif arguments.Mcodigo EQ -3>
							#lvarMonedaConversion#
						<cfelseif arguments.Mcodigo NEQ -2>
							#arguments.Mcodigo#
						<cfelse>
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
						</cfif>
					, b.Cbalancen
                    ,#PreserveSingleQuotes(LvarMarcarPadreExlusion)#
				from #cuentas# a
                	inner join CContables b
                    	on a.Ccuenta = b.Cpadre
				       and a.Ecodigo = b.Ecodigo
                    left join PCDCatalogo p   
                    	on p.PCDcatid = b.PCDcatid
				where a.nivel = #nivelanteri#
               #PreserveSingleQuotes(whereCuentasExclusion)#
               #PreserveSingleQuotes(whereCuentasInclusion)#
			</cfquery>
			<cfset nivelanteri = nivelactual>
			<cfset nivelactual = nivelactual + 1>
		</cfloop>
        
        
		
        <!---►►Informe B15◄◄--->		
		<cfif arguments.Mcodigo EQ -3 or arguments.Mcodigo EQ -4>
<!---			<cfquery datasource="#arguments.conexion#">
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
										  and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mesanterior#">										  										
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
											and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mesanterior#">
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
											and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mesanterior#">
											<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
												and Ocodigo in (#Ocodigos#)
											</cfif>
											<cfif ofi NEQ -1>
												and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
											</cfif>
											and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMonedaConversion#">
											and B15 = #lvarB15#
											), 0.00)									
			</cfquery>
			
			<!--- Calculo de Utilidades --->
			<cfquery name="utilSaldo" datasource="#arguments.conexion#">
				select (sum(a.SLinicial + a.DLdebitos - a.CLcreditos)) as utilSaldo
				 from SaldosContablesConvertidos a
                  inner join CContables b
                  	 on a.Ecodigo = b.Ecodigo
					and a.Ccuenta = b.Ccuenta
                  inner join CtasMayor c
                  	 on b.Ecodigo = c.Ecodigo
					and b.Cmayor  = c.Cmayor
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					and a.Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
					and a.Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
					<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
						and a.Ocodigo in (#Ocodigos#)
					</cfif>
					<cfif ofi NEQ -1>
						and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
					</cfif>
					and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMonedaConversion#">
					and b.Cformato = c.Cmayor
					and c.Ctipo in ('I','G')
					and a.B15 = #lvarB15#
			</cfquery>
			<cfif isdefined('utilSaldo') and utilSaldo.recordCount GT 0>
				<cfset utilidadsaldo = utilSaldo.utilSaldo>
			</cfif>
			<!--- ********************************************************************************************* --->
			<cfquery name="utilSaldoA" datasource="#arguments.conexion#">
				select (sum(a.SLinicial + a.DLdebitos - a.CLcreditos)) as utilSaldoA
				from SaldosContablesConvertidos a
                inner join CContables b
                	 on a.Ecodigo = b.Ecodigo
					and a.Ccuenta = b.Ccuenta
                inner join CtasMayor c
					 on b.Ecodigo  = c.Ecodigo
					and b.Cmayor   = c.Cmayor
					and b.Cformato = c.Cmayor
                where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					and a.Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#periodoanterior#">
					and a.Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mesanterior#">
					<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
						and a.Ocodigo in (#Ocodigos#)
					</cfif>
					<cfif ofi NEQ -1>
						and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
					</cfif>
					and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMonedaConversion#">
					and c.Ctipo in ('I','G')
					and a.B15 = #lvarB15#
			</cfquery>
			<cfif isdefined('utilSaldoA') and utilSaldoA.recordCount GT 0 and len(trim(utilSaldoA.utilSaldoA))>
				<cfset utilidadsaldoA = utilSaldoA.utilSaldoA>
			</cfif>
			<!--- ********************************************************************************************* --->
			<cfquery name="utilMes" datasource="#arguments.conexion#">
				select (sum(a.DLdebitos - a.CLcreditos)) as utilMes
				from SaldosContablesConvertidos a
                inner join CContables b
                	 on a.Ecodigo = b.Ecodigo
					and a.Ccuenta = b.Ccuenta
                inner join CtasMayor c
					 on b.Ecodigo  = c.Ecodigo
					and b.Cmayor   = c.Cmayor
					and b.Cformato = c.Cmayor
                where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					and a.Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
					and a.Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
					<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
						and a.Ocodigo in (#Ocodigos#)
					</cfif>
					<cfif ofi NEQ -1>
						and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
					</cfif>
					and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMonedaConversion#">
					and c.Ctipo in ('I','G')
					and a.B15 = #lvarB15#
			</cfquery>

			<cfif isdefined('utilMes') and utilMes.recordCount GT 0>
				<cfset utilidadmes = utilMes.utilMes>
			</cfif>
			<!--- ********************************************************************************************* --->
			<cfquery name="utilMesA" datasource="#arguments.conexion#">
				select (sum(a.DLdebitos - a.CLcreditos)) as utilMesA
				from SaldosContablesConvertidos a
                inner join CContables b
                	 on a.Ecodigo = b.Ecodigo
					and a.Ccuenta = b.Ccuenta
                inner join CtasMayor c
					 on b.Ecodigo  = c.Ecodigo
					and b.Cmayor   = c.Cmayor
					and b.Cformato = c.Cmayor
                where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					and a.Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#periodoanterior#">
					and a.Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mesanterior#">
					<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
						and a.Ocodigo in (#Ocodigos#)
					</cfif>
					<cfif ofi NEQ -1>
						and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
					</cfif>
					and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMonedaConversion#">
					and c.Ctipo in ('I','G')
					and a.B15 = #lvarB15#		
			</cfquery>

			<cfif isdefined('utilMesA') and utilMesA.recordCount GT 0 and len(trim(utilMesA.utilMesA))>
				<cfset utilidadmesA = utilMesA.utilMesA>
			</cfif>
            
---><!---►►INICIO MONEDA LOCAL◄◄--->
		<cfelseif arguments.Mcodigo EQ -2>
    
        <cfsavecontent variable="fromSumSaldos">
        	 <cfif isdefined('Arguments.MascarasIncluir') and ARRAYLEN(Arguments.MascarasIncluir) GT 0>
             	 from SaldosContables a
                    inner join CContables b
                         on b.Ccuenta = a.Ccuenta
                        and b.Ecodigo = #cuentas#.Ecodigo
                        and <cf_dbfunction name="like"	args="b.CFormato,Rtrim(#cuentas#.formato)#_Cat#'%'">
                 where a.Ecodigo     = #arguments.Ecodigo#
                   and a.Speriodo    = #arguments.periodo#
                   and a.Smes        = #arguments.mes#
                  <cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
                   and a.Ocodigo in (#Ocodigos#)
                  </cfif>
                  <cfif ofi NEQ -1>
                   and a.Ocodigo  = #ofi#
                  </cfif>
                   and (
                      <cfloop from="1" to="#ArrayLEN(Arguments.MascarasIncluir)#" index="IndiMask">
                        <cfif IndiMask GT 1>OR </cfif>
                          '#TRIM(Arguments.MascarasIncluir[IndiMask].Cformato)#' = Rtrim(b.Cformato)
                      </cfloop>
                      )
             <cfelse>
                from SaldosContables a
                    inner join CContables b
                        on b.Ccuenta = a.Ccuenta
                 where a.Ecodigo  = #arguments.Ecodigo#
                   and a.Ccuenta  = #cuentas#.Ccuenta
                   and a.Speriodo = #arguments.periodo#
                   and a.Smes     = #arguments.mes#
                  <cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
                   and a.Ocodigo in (#Ocodigos#)
                  </cfif>
                  <cfif ofi NEQ -1>
                   and a.Ocodigo  = #ofi#
                  </cfif>
             </cfif>
        </cfsavecontent>
        <cfsavecontent variable="fromSumSaldosA">
        <cfif isdefined('Arguments.MascarasIncluir') and ARRAYLEN(Arguments.MascarasIncluir) GT 0>
             	 from SaldosContables a
                    inner join CContables b
                         on b.Ccuenta = a.Ccuenta
                        and b.Ecodigo = #cuentas#.Ecodigo
                        and <cf_dbfunction name="like"	args="b.CFormato,Rtrim(#cuentas#.formato)#_Cat#'%'">
                 where a.Ecodigo     = #arguments.Ecodigo#
                   and a.Speriodo    = #periodoanterior#
                   and a.Smes     	 = #Mesanterior#
                   and b.Cmovimiento = 'S'
                  <cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
                   and a.Ocodigo in (#Ocodigos#)
                  </cfif>
                  <cfif ofi NEQ -1>
                   and a.Ocodigo  = #ofi#
                  </cfif>
                   and (
                      <cfloop from="1" to="#ArrayLEN(Arguments.MascarasIncluir)#" index="IndiMask">
                        <cfif IndiMask GT 1>OR </cfif>
                          '#TRIM(Arguments.MascarasIncluir[IndiMask].Cformato)#' = Rtrim(b.Cformato)
                      </cfloop>
                      )
		<cfelse>
        	from SaldosContables a
                inner join CContables b
                    on b.Ccuenta = a.Ccuenta
             where a.Ecodigo  = #Arguments.Ecodigo#
               and a.Ccuenta  = #cuentas#.Ccuenta
               and a.Speriodo = #periodoanterior#
               and a.Smes     = #Mesanterior#
              <cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
               and a.Ocodigo in (#Ocodigos#)
              </cfif>
              <cfif ofi NEQ -1>
               and a.Ocodigo  = #ofi#
              </cfif>
         	</cfif>
        </cfsavecontent>
			<cfquery datasource="#arguments.conexion#">
				update #cuentas# set
					saldoini = coalesce(( select sum(a.SLinicial) #PreserveSingleQuotes(fromSumSaldos)#)
                                     
                                          <cfif isdefined('Arguments.MascarasExcluir') and ARRAYLEN(Arguments.MascarasExcluir) GT 0>
                                          	- CASE WHEN #cuentas#.PadreExclusion = '0' THEN 0 
                                                   ELSE COALESCE((select sum(sc.SLinicial) from #PreserveSingleQuotes(LvarSaldoExluidos)#),0) END 
                                          </cfif>
                                          , 0.00) * #Arguments.TipoCmb#,
					debitos =  coalesce(( select sum(a.DLdebitos) #PreserveSingleQuotes(fromSumSaldos)#											)
                                            
										  <cfif isdefined('Arguments.MascarasExcluir') and ARRAYLEN(Arguments.MascarasExcluir) GT 0>
                                          	- CASE WHEN #cuentas#.PadreExclusion = '0' THEN 0 
                                                   ELSE COALESCE((select sum(sc.DLdebitos) from #PreserveSingleQuotes(LvarSaldoExluidos)#),0) END 
                                          </cfif>
                                          , 0.00) * #Arguments.TipoCmb#,
					creditos =  coalesce(( select sum(a.CLcreditos) #PreserveSingleQuotes(fromSumSaldos)#)
                                           <cfif isdefined('Arguments.MascarasExcluir') and ARRAYLEN(Arguments.MascarasExcluir) GT 0>
                                          	- CASE WHEN #cuentas#.PadreExclusion = '0' THEN 0 
                                                   ELSE COALESCE((select sum(sc.CLcreditos) from #PreserveSingleQuotes(LvarSaldoExluidos)#),0) END 
                                           </cfif>
                                           , 0.00) * #Arguments.TipoCmb#,
					<!---►►Saldos Anteriores◄◄--->
					saldoiniA = coalesce(( select sum(a.SLinicial) #PreserveSingleQuotes(fromSumSaldosA)#)
                    
                                          <cfif isdefined('Arguments.MascarasExcluir') and ARRAYLEN(Arguments.MascarasExcluir) GT 0>
                                            - CASE WHEN #cuentas#.PadreExclusion = '0' THEN 0 
                                                   ELSE COALESCE((select sum(sc.SLinicial) from #PreserveSingleQuotes(LvarSaldoExluidosA)#),0) END 
                                          </cfif>
                                          , 0.00) * #Arguments.TipoCmb#,
					debitosA =  coalesce(( select sum(a.DLdebitos) #PreserveSingleQuotes(fromSumSaldosA)#)
                                           
                                            <cfif isdefined('Arguments.MascarasExcluir') and ARRAYLEN(Arguments.MascarasExcluir) GT 0>
                                             - CASE WHEN #cuentas#.PadreExclusion = '0' THEN 0 
                                                    ELSE COALESCE((select sum(sc.DLdebitos) from #PreserveSingleQuotes(LvarSaldoExluidosA)#),0) END 
                                            </cfif>
                                            , 0.00) * #Arguments.TipoCmb#,
					creditosA =  coalesce(( select sum(a.CLcreditos) #PreserveSingleQuotes(fromSumSaldosA)#)
                                            
											<cfif isdefined('Arguments.MascarasExcluir') and ARRAYLEN(Arguments.MascarasExcluir) GT 0>
                                             - CASE WHEN #cuentas#.PadreExclusion = '0' THEN 0 
                                                    ELSE COALESCE((select sum(sc.CLcreditos) from #PreserveSingleQuotes(LvarSaldoExluidosA)#),0) END 
                                            </cfif>
                                            , 0.00) * #Arguments.TipoCmb#											
			</cfquery>
			
			<!--- Calculo de Utilidades --->
			<cfquery name="utilSaldo" datasource="#arguments.conexion#">
				select (sum(a.SLinicial + a.DLdebitos - a.CLcreditos) * #Arguments.TipoCmb#) as utilSaldo
				from SaldosContables a
                inner join CContables b
                	 on a.Ecodigo = b.Ecodigo
					and a.Ccuenta = b.Ccuenta
                inner join CtasMayor c
                	 on b.Ecodigo  = c.Ecodigo
					and b.Cmayor   = c.Cmayor
					and b.Cformato = c.Cmayor
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					and a.Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
					and a.Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
					<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
						and a.Ocodigo in (#Ocodigos#)
					</cfif>
					<cfif ofi NEQ -1>
						and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
					</cfif>
					and c.Ctipo in ('I','G')
                    #PreserveSingleQuotes(LvarMascarasExclusion)#
                    #PreserveSingleQuotes(LvarMascarasInclusion)#
			</cfquery>
			
			<cfif isdefined('utilSaldo') and utilSaldo.recordCount GT 0>
				<cfset utilidadsaldo = utilSaldo.utilSaldo>
			</cfif>
			<!--- ******************************************************************************** --->
			<cfquery name="utilSaldoA" datasource="#arguments.conexion#">
				select (sum(a.SLinicial + a.DLdebitos - a.CLcreditos)* #Arguments.TipoCmb#) as utilSaldoA
				from SaldosContables a, CContables b, CtasMayor c
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					and a.Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#periodoanterior#">
					and a.Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mesanterior#">
					<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
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
                    #PreserveSingleQuotes(LvarMascarasExclusion)#
                    #PreserveSingleQuotes(LvarMascarasInclusion)#
			</cfquery>
			
			<cfif isdefined('utilSaldoA') and utilSaldoA.recordCount GT 0 and len(trim(utilSaldoA.utilSaldoA))>
				<cfset utilidadsaldoA = utilSaldoA.utilSaldoA>
			</cfif>
			<!--- ******************************************************************************** --->
			<cfquery name="utilMes" datasource="#arguments.conexion#">
				select (sum(a.DLdebitos - a.CLcreditos) * #Arguments.TipoCmb#) as utilMes
				from SaldosContables a, CContables b, CtasMayor c
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					and a.Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
					and a.Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
					<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
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
                    #PreserveSingleQuotes(LvarMascarasExclusion)#
                    #PreserveSingleQuotes(LvarMascarasInclusion)#
			</cfquery>


			<cfif isdefined('utilMes') and utilMes.recordCount GT 0>
				<cfset utilidadmes = utilMes.utilMes>
			</cfif>
		    <!--- ******************************************************************************** --->
			<cfquery name="utilMesA" datasource="#arguments.conexion#">
				select (sum(a.DLdebitos - a.CLcreditos) * #Arguments.TipoCmb#) as utilMesA
				from SaldosContables a, CContables b, CtasMayor c
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					and a.Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#periodoanterior#">
					and a.Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mesanterior#">
					<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
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
                    #PreserveSingleQuotes(LvarMascarasExclusion)#
                    #PreserveSingleQuotes(LvarMascarasInclusion)#
			</cfquery>

			<cfif isdefined('utilMesA') and utilMesA.recordCount GT 0 and len(trim(utilMesA.utilMesA))>
				<cfset utilidadmesA = utilMesA.utilMesA>
			</cfif>			
            
<!---►►INICIO MONEDA ORIGEN◄◄--->			
		<cfelse>
		
<!---			<cfquery datasource="#arguments.conexion#">
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
									and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mesanterior#">
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
									and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mesanterior#">
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
									and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mesanterior#">
									and a.Mcodigo = #cuentas#.Mcodigo
									<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
										and Ocodigo in (#Ocodigos#)
									</cfif>
									<cfif ofi NEQ -1>
										and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ofi#">
									</cfif>
							), 0.00)							
			</cfquery>
			
			<cfquery name="utilSaldo2" datasource="#arguments.conexion#">
				select (sum(a.SOinicial + a.DOdebitos - a.COcreditos)) as utilidadSaldo
				from SaldosContables a, CContables b, CtasMayor c
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					and a.Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
					and a.Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
					and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Mcodigo#">
					<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
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
			</cfquery>
			<!--- ***************************************************************************************** --->
			<cfif isdefined('utilSaldo2') and utilSaldo2.recordCount GT 0>
				<cfset utilidadsaldo = utilSaldo2.utilidadSaldo>
			</cfif>			
			
			<cfquery name="utilSaldo2A" datasource="#arguments.conexion#">
				select (sum(a.SOinicial + a.DOdebitos - a.COcreditos)) as utilidadSaldoA
				from SaldosContables a, CContables b, CtasMayor c
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					and a.Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#periodoanterior#">
					and a.Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mesanterior#">
					and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Mcodigo#">
					<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
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
			</cfquery>

			<cfif isdefined('utilSaldo2A') and utilSaldo2A.recordCount GT 0 and len(trim(utilSaldo2A.utilidadSaldoA))>
				<cfset utilidadsaldoA = utilSaldo2A.utilidadSaldoA>
			</cfif>
			<!--- ***************************************************************************************** --->
			<cfquery name="utilMes2" datasource="#arguments.conexion#">
				select (sum(a.DOdebitos - a.COcreditos)) as utilesMes2
				from SaldosContables a, CContables b, CtasMayor c
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					and a.Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
					and a.Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
					and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Mcodigo#">
					<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
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
			</cfquery>			
			
			<cfif isdefined('utilMes2') and utilMes2.recordCount GT 0>
				<cfset utilidadmes = utilMes2.utilesMes2>
			</cfif>	
			<!--- ***************************************************************************************** --->
			<cfquery name="utilMes2A" datasource="#arguments.conexion#">
				select (sum(a.DOdebitos - a.COcreditos)) as utilesMes2A
				from SaldosContables a, CContables b, CtasMayor c
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					and a.Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#periodoanterior#">
					and a.Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mesanterior#">
					and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Mcodigo#">
					<cfif arguments.GOid NEQ -1 and len(trim(Ocodigos))>
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
			</cfquery>			
			
			<cfif isdefined('utilMes2A') and utilMes2A.recordCount GT 0 and len(trim(utilMes2A.utilesMes2A))>
				<cfset utilidadmesA = utilMes2A.utilesMes2A>
			</cfif>					
--->	
		</cfif>
		
		<cfif utilidadsaldo EQ ''>
			<cfset utilidadsaldo = 0>
		</cfif>		
		<cfif utilidadsaldoA EQ ''>
			<cfset utilidadsaldoA = 0>
		</cfif>	
		<cfif utilidadmes EQ ''>
			<cfset utilidadmes = 0>
		</cfif>
		<cfif utilidadmesA EQ ''>
			<cfset utilidadmesA = 0>
		</cfif>		
		
		<cfquery datasource="#arguments.conexion#">
			update #cuentas# set saldofin = (saldoini + debitos - creditos) ,saldofinA = (saldoiniA + debitosA - creditosA)
		</cfquery>
    
		<cfif arguments.ceros NEQ 'S'>
			<cfquery datasource="#arguments.conexion#">
			    delete from #cuentas# 
				where saldofin = 0.00 and saldofinA = 0.00		
			</cfquery>
		</cfif>
		
		<cfquery datasource="#arguments.conexion#">
			update #cuentas# 
				set movmes = (coalesce(debitos,0.00) - coalesce(creditos,0.00)),
				movmesA = (coalesce(debitosA,0.00) - coalesce(creditosA,0.00))
		</cfquery>		
		
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
				set corte = 2, ntipo = 'Pasivo'
			where tipo = 'P'
		</cfquery>

		<cfquery datasource="#arguments.conexion#">
			update #cuentas#
				set corte = 3, ntipo = 'Capital'
			where tipo = 'C'
		</cfquery>

		<cfquery datasource="#arguments.conexion#">
			<!---
			update #cuentas#
				set saldofin = (saldofin * -1), movmes = (movmes * -1)
			where Cbalancen = 'C'
			--->
			<!---  Poner el saldo de las cuentas que no son de pasivo en el signo contrario para efectos de despliegue!--->
			update #cuentas#
				set saldofin = (saldofin * -1), movmes = (movmes * -1),saldofinA = (saldofinA * -1)
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
				saldoini,
				debitos,
				creditos,
				movmes,
				movmesA,
				saldofin,
				saldoiniA,
				debitosA,
				creditosA,
				saldofinA,
				#now()# as fecha,
				Cbalancen,
				#utilidadmes*-1# as utilidadmes,
				#utilidadsaldo*-1# as utilidadsaldo,	
				#utilidadmesA*-1# as utilidadmesA,
				#utilidadsaldoA*-1# as utilidadsaldoA,							
				#Ccuenta# as cuentautil,
				'#Cformato#' as Cformato
			from #cuentas# 
			order by corte, mayor, formato
		</cfquery>
		
		<cfreturn rs_Resultante>
	</cffunction>
 <!---►►Query to Array◄◄--->
    <cffunction name="QueryToArray" access="public" returntype="array" output="false" hint="Esto convierte a una consulta en una matriz de estructuras">
    	<cfargument name="Data" type="query" required="yes" />
		<cfscript>    
			var LOCAL 	     = StructNew();
			LOCAL.Columns    = ListToArray( ARGUMENTS.Data.ColumnList );
			LOCAL.QueryArray = ArrayNew( 1 );
			for (LOCAL.RowIndex = 1 ; LOCAL.RowIndex LTE ARGUMENTS.Data.RecordCount ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)){
				LOCAL.Row = StructNew();
				for (LOCAL.ColumnIndex = 1 ; LOCAL.ColumnIndex LTE ArrayLen( LOCAL.Columns ) ; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)){
					LOCAL.ColumnName = LOCAL.Columns[ LOCAL.ColumnIndex ];
					LOCAL.Row[ LOCAL.ColumnName ] = ARGUMENTS.Data[ LOCAL.ColumnName ][ LOCAL.RowIndex ];
				}
				ArrayAppend( LOCAL.QueryArray, LOCAL.Row );
			}
			return( LOCAL.QueryArray );
        </cfscript>
	</cffunction>
</cfcomponent>