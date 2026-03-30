<!---
Parametros que se Usan:
_____________________________________________________________________________
|Pcodigo|                       Descripcion									|
| 45    |Ultimo Mes de Cierre Fiscal Contable								|
| 200   |Cuenta Balance Multimoneda											|
| 300   |Cuenta de Utilidad Acumulada										|
| 660   |Conversión de Moneda de Estados Financieros						|
| 810   |Cuenta de diferencial cambiario para conversión de estados			|
| 3600  |Cuenta de Diferencial Cambiario Primera conversión de estados B15	|
| 3700  |Cuenta de Diferencial Cambiario segunda conversión de estados B15	|
| 3810  |Moneda de Diferencial Cambiario segunda conversión de estados B15	|
| 3900  |Moneda de Diferencial Cambiario segunda conversión de estados B15	|
_____________________________________________________________________________
--->
<cfcomponent>
	<cffunction name="CG_ConversionEF" access="public">
		<cfargument name="Periodo" 		  type="numeric" required="yes" hint="Periodo a Procesar">
		<cfargument name="Mes" 			  type="numeric" required="yes" hint="Mes a Procesar">
		<cfargument name="Tipo" 	 	  type="string"  required="yes" hint="Tipo de Calculo(N-Normal,F-Funcional,I-Informe)" default="N">
        <cfargument name="Ecodigo" 		  type="numeric" required="no"  hint="Empresa que está ejecutando el proceso">
        <cfargument name="Usucodigo" 	  type="numeric" required="no"  hint="Usuario Conectado">
		<cfargument name="Conexion" 	  type="string"  required="no"  hint="Conexion de Base de Datos">
       
		<!---►►►Variables Empresa, Usuario y Coneccion◄◄◄--->
		<cfif NOT ISDEFINED('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif NOT ISDEFINED('Arguments.Usucodigo')>
        	<cfset Arguments.Usucodigo = session.Usucodigo>
        </cfif>
        <cfif NOT ISDEFINED('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.DSN>
        </cfif>
        
        <!---►►►Tipo de Conversion: N(Conversion Normal)◄◄◄--->
        <cfif Arguments.Tipo EQ 'N'>
        	<cfset LvarB15  = 0>
            <cfset LabelB15 = "">
            <cfset LvarMonedaConversion  = GetParam(660)>
            <cfset lvarCuentaDiferencial = GetParam(810)>
            
         <!---►►►Tipo de Conversion: F(Conversion NIF B15 a Moneda Funcional)◄◄◄--->
		<cfelseif Arguments.Tipo EQ 'F'>
        	<cfset LvarB15  = 1>
            <cfset LabelB15 = "B15">
            <cfset lvarCuentaDiferencial = GetParam(3600)>
			<cfset LvarMonedaConversion  = GetParam(3810)>
        <!---►►►Tipo de Conversion: I(Conversion NIF B15 a Moneda Informe)◄◄◄--->
		<cfelseif Arguments.Tipo EQ 'I'>
			<cfset LvarB15      		 = 2>
            <cfset LvarB15Funcional   	 = 1>
            <cfset LabelB15 			 = "B15">
            <cfset lvarCuentaDiferencial = GetParam(3700)>
            <cfset LvarMonedaFuncional   = GetParam(3810)>
            <cfset LvarMonedaConversion  = GetParam(3900)>
            <cfset lvarCuentaFluctuacion = GetParam(4000)>
         <!---►►►Cualquier otro Tipo Distinto N(Conversion Normal),F(Conversion NIF B15 a Moneda Funcional), I(Conversion NIF B15 a Moneda Informe)◄◄◄--->  
        <cfelse>
        	<cfthrow message="Tipo #Arguments.Tipo# no implementado">
        </cfif>

	   <!---►►►Obtiene el Ccuenta basado en el parametro obtenido con CFcuenta◄◄◄--->
		<cfquery name="rsGet_Ccuenta" datasource="#Session.DSN#">
			select Ccuenta
			  from CFinanciera a
			 where CFcuenta = #lvarCuentaDiferencial#
		</cfquery>
		<cfset lvarCuentaDiferencial = #rsGet_Ccuenta.Ccuenta#>
        

	    <!---►►►Ultimo Periodo/Mes Procesado◄◄◄--->
			<cfset Arguments.PeriodoCerrado = Arguments.Periodo>
            <cfset Arguments.MesCerrado 	= Arguments.Mes - 1>
        <cfif Arguments.MesCerrado EQ 0>
            <cfset Arguments.PeriodoCerrado = Arguments.Periodo - 1>
            <cfset Arguments.MesCerrado 	= 12>
        </cfif>
        
		<!---►►►Ultimo Mes de Cierre Fiscal Contable◄◄◄--->
        	<cfset LvarMesFiscal = GetParam(45)>
            
   		<!---►►►Cuenta de Utilidad Acumulada◄◄◄--->
			<cfset LvarCuentaUtilidad = GetParam(300)>
            
		<!---►►►Cuenta de Balance Multimoneda◄◄◄--->
        	<cfset lvarCtaMultimoneda = GetParam(200)>
            
		<!---►►►Verifica si es el Cierre Anual◄◄◄--->
		<cfif Arguments.MesCerrado EQ LvarMesFiscal and LEN(TRIM(LvarCuentaUtilidad))>
			<cfset LvarCierreAnual = true>
		<cfelse>
        	<cfset LvarCierreAnual = false>
        </cfif>
        <!---►►►Considerar Cuentas de Orden ◄◄◄--->
        	<cfset LvarCtasOrden = GetParam(200012)>
            <cfif LEN(TRIM(LvarCtasOrden)) and LvarCtasOrden EQ 1>
				<cfset LvarCtasOrden = true>
            <cfelse>
                <cfset LvarCtasOrden = false>
            </cfif>
            

        
		<!---►►►Se eliminan los Saldos Convertidos para este Periodo/Mes/Moneda en caso de que existieran◄◄◄--->
        <cfquery datasource="#Arguments.Conexion#">
            delete from SaldosContablesConvertidos
             where Ecodigo  = #Arguments.Ecodigo#
              and Speriodo = #Arguments.Periodo#
              and Smes     = #Arguments.Mes#
              and B15 	   = #LvarB15#
              and Mcodigo  = #LvarMonedaConversion#
        </cfquery>

		<cfquery datasource="#Arguments.Conexion#" name="HistoricoB15">
            select Pvalor
                from Parametros
             where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
               and Pcodigo = 200011
        </cfquery>


		<!---►►Inserta los saldos iniciales Convertidos tomando los saldos convertidos del mes anterior, únicamente para 
               las cuentas que aceptan  movimientos y si es el cierre anual se excluyen las cuentas de Ingresos y Gastos.◄◄◄--->
        <cfquery datasource="#Arguments.Conexion#">
            insert into SaldosContablesConvertidos (
                Ccuenta, 
                Speriodo, 
                Smes, 
                Ecodigo, 
                Ocodigo, 
                Mcodigo, 
                McodigoOri, 
                SOinicial, 
                DOdebitos, 
                COcreditos, 
                SLinicial, 
                DLdebitos, 
                CLcreditos,
                SOSaldoFinal,
                SLSaldoFinal, 
                BMUsucodigo,
                CTCconversion,
                Ctipo, 
                B15,
                TCHid,
                SMLinicial)
            select 
                sc.Ccuenta,
                #Arguments.Periodo#,
                #Arguments.Mes#,
                sc.Ecodigo,
                sc.Ocodigo,
                sc.Mcodigo,
                sc.McodigoOri,
                (sc.SOinicial + sc.DOdebitos - sc.COcreditos),
                0.00,
                0.00,
                (sc.SLinicial + sc.DLdebitos - sc.CLcreditos),
                0.00,
                0.00,
                0.00,
                0.00,
                #Arguments.Usucodigo#,
                m.CTCconversion,
                m.Ctipo, 
                #LvarB15#,
                m.TCHid,
               sc.SLSaldoFinal
            from SaldosContablesConvertidos sc
                inner join CContables c
                    inner join CtasMayor m
                             on m.Ecodigo = c.Ecodigo
                            and m.Cmayor  = c.Cmayor
                    on c.Ccuenta = sc.Ccuenta
                   and c.Cmovimiento = 'S'
            where sc.Ecodigo  = #Arguments.Ecodigo#
              and sc.Speriodo = #Arguments.PeriodoCerrado#
              and sc.Smes     = #Arguments.MesCerrado#
              <cfif LvarCierreAnual>
                    and m.Ctipo not in ('I', 'G')
              </cfif>
             and sc.B15 	 = #LvarB15#
             and sc.Mcodigo  = #LvarMonedaConversion#
             <cfif not LvarCtasOrden>
	             and m.Ctipo not in ('O')
             </cfif>
        </cfquery>
   
		<cfif listfind('N,F',Arguments.Tipo)>
			<!---►►►(Normal,Funcional)Inserta los saldos iniciales de cuentas que no existieron el mes Pasado, 
					 Únicamente las cuentas que aceptan movimientos, obtienen los Saldos Iniciales de Saldos Contables◄◄◄--->
			<cfquery datasource="#Arguments.Conexion#">
				insert into SaldosContablesConvertidos (
					Ccuenta, 
					Speriodo, 
					Smes, 
					Ecodigo, 
					Ocodigo, 
					Mcodigo, 
					McodigoOri, 
					SOinicial, 
					DOdebitos,COcreditos,SLinicial,DLdebitos,CLcreditos,SOSaldoFinal,SLSaldoFinal, 
					BMUsucodigo,
                    CTCconversion,
                    Ctipo, 
                    B15,
                    TCHid

                    )
				select 
					s.Ccuenta,
					s.Speriodo,
					s.Smes,
					s.Ecodigo,
					s.Ocodigo,
					#LvarMonedaConversion#,
					s.Mcodigo,
					<cfif LEN(TRIM(LvarCuentaUtilidad)) and LvarCierreAnual>
						case when s.Ccuenta = #LvarCuentaUtilidad# then 0.00 else s.SOinicial end,
					<cfelse>
						s.SOinicial,
					</cfif>
					0.00,0.00,0.00,0.00,0.00,0.00,0.00,
					#Arguments.Usucodigo#,
                    m.CTCconversion,
                    m.Ctipo, 
                    #LvarB15#,
                    m.TCHid
				from SaldosContables s
					inner join CContables c
						on c.Ccuenta = s.Ccuenta
					   and c.Cmovimiento = 'S'
                    inner join CtasMayor m
                        on m.Ecodigo = c.Ecodigo
                       and m.Cmayor  = c.Cmayor
				where s.Ecodigo  = #Arguments.Ecodigo#
				  and s.Speriodo = #Arguments.Periodo#
				  and s.Smes     = #Arguments.Mes#
				  and not exists ( select 1 
                                    from SaldosContablesConvertidos s1 
                                    where s1.Ccuenta    = s.Ccuenta
                                      and s1.Speriodo   = s.Speriodo
                                      and s1.Smes       = s.Smes
                                      and s1.Ecodigo    = s.Ecodigo
                                      and s1.Ocodigo    = s.Ocodigo
                                      and s1.McodigoOri = s.Mcodigo
                                      and s1.B15 	    = #LvarB15#
                                      and s1.Mcodigo    = #LvarMonedaConversion#)
                  <cfif not LvarCtasOrden>
		             and m.Ctipo not in ('O')
    	         </cfif>
			</cfquery>

       <cfelseif listfind('I',Arguments.Tipo)>

       		<!---►►►(Informe)Inserta los saldos iniciales de cuentas que no existieron el mes Pasado.
			 		Únicamente las cuentas que aceptan movimientos, las toma de la Conversion a moneda Funcional del mes Actual. 
					La moneda Local Ahora es la moneda de Informe y la moneda Origen es la moneda Funcional◄◄◄--->

			<cfquery datasource="#Arguments.Conexion#">
				insert into SaldosContablesConvertidos (
					Ccuenta, 
					Speriodo, 
					Smes, 
					Ecodigo, 
					Ocodigo, 
					Mcodigo, 
					McodigoOri, 
					SOinicial, 
				    DOdebitos,COcreditos,SLinicial,DLdebitos,CLcreditos,SOSaldoFinal,SLSaldoFinal, 
					BMUsucodigo,
                    CTCconversion,
                    Ctipo, 
                    B15)
				select 
					s.Ccuenta,
					s.Speriodo,
					s.Smes,
					s.Ecodigo,
					s.Ocodigo,
					#LvarMonedaConversion#,
					s.Mcodigo,
					SUM(s.SLinicial),
					0.00,0.00,0.00,0.00,0.00,0.00,0.00,
					#Arguments.Usucodigo#,
                    m.CTCconversion,
                    m.Ctipo, 
                    #LvarB15#
				from SaldosContablesConvertidos s
					inner join CContables c
						inner join CtasMayor m
                        	on m.Ecodigo = c.Ecodigo
                           and m.Cmayor  = c.Cmayor
                       on c.Ccuenta      = s.Ccuenta
					  and c.Cmovimiento  = 'S'
                    
				where s.Ecodigo  = #Arguments.Ecodigo#
				  and s.Speriodo = #Arguments.Periodo#
				  and s.Smes     = #Arguments.Mes#
                  and s.Mcodigo  = #LvarMonedaFuncional#
				  and not exists (select 1 
                  					from SaldosContablesConvertidos s1 
                                   where s1.Ccuenta    = s.Ccuenta
                                     and s1.Speriodo   = s.Speriodo
                                     and s1.Smes       = s.Smes
                                     and s1.Ecodigo    = s.Ecodigo
                                     and s1.Ocodigo    = s.Ocodigo
                                     and s1.B15 	   = #LvarB15#
                                     and s1.Mcodigo    = #LvarMonedaConversion#) 
                <cfif not LvarCtasOrden>
	             and m.Ctipo not in ('O')
             	</cfif>
                 group by s.Ccuenta,s.Speriodo,s.Smes,s.Ecodigo,s.Ocodigo,s.Mcodigo,m.CTCconversion,m.Ctipo
			</cfquery>
       </cfif>
       
			<!---►►►Solo si es el Cierre Anual, se Actualiza la cuenta de utilidad Acumulada (PASO 2) de la siguiente manera◄◄◄ 
	     			 Saldo Ini Ori = Saldos ini Ori + sumatoria(Saldos Ini Ori + Débitos Ori-Créditos Ori ) del Mes anterior de las Ctas de gastos e Ingresos
         			 Saldo Ini Loc = Saldos ini Loc + sumatoria(Saldos Ini Loc + Debitos Ori-Creditos Ori ) del Mes anterior de las Ctas de gastos e Ingresos
					 Esto Solo para las cuentas de Mayor, es decir Cformato = Cmayor--->
			<cfif LEN(TRIM(LvarCuentaUtilidad)) and LvarCierreAnual>
					<cfquery datasource="#Arguments.Conexion#">
							update SaldosContablesConvertidos
								set 
									  SOinicial = SOinicial + coalesce((
									  				select sum((sc.SOinicial + sc.DOdebitos - sc.COcreditos))
													from CtasMayor m
															inner join CContables c
																	inner join SaldosContablesConvertidos sc
																		 on sc.Ccuenta    = c.Ccuenta
																		and sc.Speriodo   = #Arguments.PeriodoCerrado#
																		and sc.Smes       = #Arguments.MesCerrado#
																		and sc.Ecodigo    = c.Ecodigo
																		and sc.Ocodigo    = s.Ocodigo
																		and sc.Mcodigo    = s.Mcodigo
																		and sc.McodigoOri = s.McodigoOri
                                                                        and sc.B15 		  = s.B15
																 on c.Ecodigo   = m.Ecodigo
																and c.Cmayor    = m.Cmayor
																and c.Cformato  = m.Cmayor
													where m.Ecodigo = s.Ecodigo
													  and m.Ctipo in ('I', 'G')
												), 0.00)
									, SLinicial = SLinicial + coalesce((
									  				select sum((sc.SLinicial + sc.DLdebitos - sc.CLcreditos))
													from CtasMayor m
															inner join CContables c
																	inner join SaldosContablesConvertidos sc
																		 on sc.Ccuenta    = c.Ccuenta
																		and sc.Speriodo   = #Arguments.PeriodoCerrado#
																		and sc.Smes       = #Arguments.MesCerrado#
																		and sc.Ecodigo    = c.Ecodigo
																		and sc.Ocodigo    = s.Ocodigo
																		and sc.Mcodigo    = s.Mcodigo
																		and sc.McodigoOri = s.McodigoOri
                                                                        and sc.B15 		  = s.B15
																 on c.Ecodigo    = m.Ecodigo
																and c.Cmayor     = m.Cmayor
																and c.Cformato   = m.Cmayor
													where m.Ecodigo = s.Ecodigo
													  and m.Ctipo in ('I', 'G')
												), 0.00)
                                      <!--- ,  SMLinicial = SMLinicial + coalesce((
									  				select sum((sc.SMLinicial + sc.SMLdebitos - sc.SMLcreditos))
													from CtasMayor m
															inner join CContables c
																	inner join SaldosContablesConvertidos sc
																		 on sc.Ccuenta    = c.Ccuenta
																		and sc.Speriodo   = #Arguments.PeriodoCerrado#
																		and sc.Smes       = #Arguments.MesCerrado#
																		and sc.Ecodigo    = c.Ecodigo
																		and sc.Ocodigo    = s.Ocodigo
																		and sc.Mcodigo    = s.Mcodigo
																		and sc.McodigoOri = s.McodigoOri
                                                                        and sc.B15 		  = s.B15
																 on c.Ecodigo    = m.Ecodigo
																and c.Cmayor     = m.Cmayor
																and c.Cformato   = m.Cmayor
													where m.Ecodigo = s.Ecodigo
													  and m.Ctipo in ('I', 'G')
												), 0.00)--->
							from SaldosContablesConvertidos s
							where s.Ccuenta  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCuentaUtilidad#">
							  and s.Speriodo = #Arguments.Periodo#
							  and s.Smes     = #Arguments.Mes#
							  and s.Ecodigo  = #Arguments.Ecodigo#
                              and s.B15 	 = #LvarB15#
                 		      and s.Mcodigo  = #LvarMonedaConversion#
					</cfquery>
			</cfif>

			<!---►►►Eliminar la cuenta de balance multimoneda del proceso, porque no debe considerase para efectos de la conversión◄◄◄
					porque esta representa el proceso normal de operación entre monedas en el sistema de Contabilidad General--->
			<cfif LEN(TRIM(lvarCtaMultimoneda))>
				<cfquery datasource="#Arguments.Conexion#">
					delete from SaldosContablesConvertidos
					where Ccuenta   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarCtaMultimoneda#">
                      and Speriodo  = #Arguments.Periodo#
                      and Smes      = #Arguments.Mes#
                      and Ecodigo   = #Arguments.Ecodigo#
					  and Mcodigo   = #LvarMonedaConversion#
                      and B15       = #LvarB15#
				</cfquery>
			</cfif>

           	<cfif Arguments.Ecodigo EQ "22" and  #session.cenombre# EQ 'PMI'>
	            <cfquery datasource="#Arguments.Conexion#">
                    delete from SaldosContablesConvertidos
                        where Ccuenta   in(select Ccuenta
                                              from CFinanciera a
                                             where Cmayor = 2171
                                             and Ecodigo = #Arguments.Ecodigo#
                                             and CFpadre is not null
                                             and CFmovimiento = 'S')
                          and Speriodo  = #Arguments.Periodo#
                          and Smes      = #Arguments.Mes#
                          and Ecodigo   = #Arguments.Ecodigo#
                          and Mcodigo   = #LvarMonedaConversion#
                          and B15       = #LvarB15#
				</cfquery>
                          
            </cfif>
	
			<cfif listfind('N,F',Arguments.Tipo)>
				<!---►►►Actualiza los Débitos y Créditos Origen convertidos, con la sumatoria de los saldos Contables de la moneda Origen Convertida◄◄◄--->
                <cfquery datasource="#Arguments.Conexion#">
                    update SaldosContablesConvertidos
                    set 
                        DOdebitos  = 
                            coalesce((select sum(s.DOdebitos)
                            from SaldosContables s
                            where s.Ccuenta  = SaldosContablesConvertidos.Ccuenta
                              and s.Speriodo = SaldosContablesConvertidos.Speriodo
                              and s.Smes     = SaldosContablesConvertidos.Smes
                              and s.Ecodigo  = SaldosContablesConvertidos.Ecodigo
                              and s.Ocodigo  = SaldosContablesConvertidos.Ocodigo
                              and s.Mcodigo  = SaldosContablesConvertidos.McodigoOri
                            ), 0.00),
                        COcreditos  = 
                            coalesce((select sum(s.COcreditos)
                            from SaldosContables s
                            where s.Ccuenta  = SaldosContablesConvertidos.Ccuenta
                              and s.Speriodo = SaldosContablesConvertidos.Speriodo
                              and s.Smes     = SaldosContablesConvertidos.Smes
                              and s.Ecodigo  = SaldosContablesConvertidos.Ecodigo
                              and s.Ocodigo  = SaldosContablesConvertidos.Ocodigo
                              and s.Mcodigo  = SaldosContablesConvertidos.McodigoOri
                            ), 0.00)
                            ,<!---Inicia Cambio RVD--->
                        SMLdebitos  = 
                            coalesce((select sum(s.DLdebitos)
                            from SaldosContables s
                            where s.Ccuenta  = SaldosContablesConvertidos.Ccuenta
                              and s.Speriodo = SaldosContablesConvertidos.Speriodo
                              and s.Smes     = SaldosContablesConvertidos.Smes
                              and s.Ecodigo  = SaldosContablesConvertidos.Ecodigo
                              and s.Ocodigo  = SaldosContablesConvertidos.Ocodigo
                              and s.Mcodigo  = SaldosContablesConvertidos.McodigoOri
                            ), 0.00),
                        SMLcreditos  = 
                            coalesce((select sum(s.CLcreditos)
                            from SaldosContables s
                            where s.Ccuenta  = SaldosContablesConvertidos.Ccuenta
                              and s.Speriodo = SaldosContablesConvertidos.Speriodo
                              and s.Smes     = SaldosContablesConvertidos.Smes
                              and s.Ecodigo  = SaldosContablesConvertidos.Ecodigo
                              and s.Ocodigo  = SaldosContablesConvertidos.Ocodigo
                              and s.Mcodigo  = SaldosContablesConvertidos.McodigoOri
                            ), 0.00)
                    where SaldosContablesConvertidos.Ecodigo  = #Arguments.Ecodigo#
                      and SaldosContablesConvertidos.Speriodo = #Arguments.Periodo#
                      and SaldosContablesConvertidos.Smes     = #Arguments.Mes#
                      and SaldosContablesConvertidos.Mcodigo  = #LvarMonedaConversion#
                      and SaldosContablesConvertidos.B15      = #LvarB15#       
                </cfquery>
                <!---Termina Cambio RVD--->
                
            <cfelseif listfind('I',Arguments.Tipo)>

            	<cfquery datasource="#Arguments.Conexion#">
                    update SaldosContablesConvertidos
                    set 
                    	<!---<cfif  HistoricoB15.recordcount EQ 0 or HistoricoB15.Pvalor EQ 0> --->
                            DOdebitos  =
                                coalesce((select sum(s.DLdebitos)
                                            from SaldosContablesConvertidos s
                                            where s.Ccuenta  = SaldosContablesConvertidos.Ccuenta
                                              and s.Speriodo = SaldosContablesConvertidos.Speriodo
                                              and s.Smes     = SaldosContablesConvertidos.Smes
                                              and s.Ecodigo  = SaldosContablesConvertidos.Ecodigo
                                              and s.Ocodigo  = SaldosContablesConvertidos.Ocodigo
                                              and s.B15		 = #LvarB15Funcional#
                                              and s.Mcodigo  = #LvarMonedaFuncional#
                                            ), 0.00),
                            COcreditos  = 
                                coalesce((select sum(s.CLcreditos)
                                from SaldosContablesConvertidos s
                                where s.Ccuenta  = SaldosContablesConvertidos.Ccuenta
                                  and s.Speriodo = SaldosContablesConvertidos.Speriodo
                                  and s.Smes     = SaldosContablesConvertidos.Smes
                                  and s.Ecodigo  = SaldosContablesConvertidos.Ecodigo
                                  and s.Ocodigo  = SaldosContablesConvertidos.Ocodigo
                                  and s.B15		 = #LvarB15Funcional#
                                  and s.Mcodigo  = #LvarMonedaFuncional#
                                ), 0.00),
                             SMLdebitos =   coalesce((select sum(s.SMLdebitos)
                                from SaldosContablesConvertidos s
                                where s.Ccuenta  = SaldosContablesConvertidos.Ccuenta
                                  and s.Speriodo = SaldosContablesConvertidos.Speriodo
                                  and s.Smes     = SaldosContablesConvertidos.Smes
                                  and s.Ecodigo  = SaldosContablesConvertidos.Ecodigo
                                  and s.Ocodigo  = SaldosContablesConvertidos.Ocodigo
                                  and s.B15		 = #LvarB15Funcional#
                                  and s.Mcodigo  = #LvarMonedaFuncional#
                                ), 0.00),
                              SMLcreditos =   coalesce((select sum(s.SMLcreditos)
                                from SaldosContablesConvertidos s
                                where s.Ccuenta  = SaldosContablesConvertidos.Ccuenta
                                  and s.Speriodo = SaldosContablesConvertidos.Speriodo
                                  and s.Smes     = SaldosContablesConvertidos.Smes
                                  and s.Ecodigo  = SaldosContablesConvertidos.Ecodigo
                                  and s.Ocodigo  = SaldosContablesConvertidos.Ocodigo
                                  and s.B15		 = #LvarB15Funcional#
                                  and s.Mcodigo  = #LvarMonedaFuncional#
                                ), 0.00) <!---,
                           SMLinicial =   coalesce((select sum(s.SMLinicial)
                            from SaldosContablesConvertidos s
                            where s.Ccuenta  = SaldosContablesConvertidos.Ccuenta
                              and s.Speriodo = SaldosContablesConvertidos.Speriodo
                              and s.Smes     = SaldosContablesConvertidos.Smes
                              and s.Ecodigo  = SaldosContablesConvertidos.Ecodigo
                              and s.Ocodigo  = SaldosContablesConvertidos.Ocodigo
                              and s.B15		 = #LvarB15Funcional#
                              and s.Mcodigo  = #LvarMonedaFuncional#
                            ), 0.00)
             --->
                    where SaldosContablesConvertidos.Ecodigo  = #Arguments.Ecodigo#
                      and SaldosContablesConvertidos.Speriodo = #Arguments.Periodo#
                      and SaldosContablesConvertidos.Smes     = #Arguments.Mes#
                      and SaldosContablesConvertidos.Mcodigo  = #LvarMonedaConversion#
                      and SaldosContablesConvertidos.B15      = #LvarB15#
                </cfquery>
            </cfif>
    
				<!---►►►TIPO NORMAL Y FUNCIONAL: Se Actualiza el Tipo de Cambio de la Moneda Original con Respecto a la moneda Origen de conversion◄◄◄
                    Moneda Ori = Moneda Conversion-> (Tipo cambio 1)
                    Moneda Ori!= Moneda Conversion ->
                                       CTCconversion = 1 -> (Tipo Cambio Compra)
                                       CTCconversion = 2 -> (Tipo Cambio Venta)
                                       CTCconversion = 3 -> (Tipo Cambio Promedio)
									   CTCconversion = 4 -> (Tipo Cambio Historico)
                                       CTCconversion = 0 -> 
                                                            Cuenta De Activo	         -> (Tipo Cambio Compra)
                                                            Cuenta Pasivo		         -> (Tipo Cambio Venta)
                                                            Cuenta Capital,Ingreso,Gasto -> (Tipo Cambio Promedio)
                                                            Otras (cuentas de Orden)     -> (Tipo Cambio Venta)
                --->
           
        	<!---►►►TIPO INFORME: Se Actualiza el Tipo de Cambio de la Moneda Original con Respecto a la moneda Origen de conversion◄◄◄
                    Moneda Ori = Moneda Conversion-> (Tipo cambio 1)
                    Moneda Ori!= Moneda Conversion ->
                                                     Cuenta De Activo	          -> (Tipo Cambio Compra)
                                                     Cuenta Pasivo		          -> (Tipo Cambio Venta)
                                                     Cuenta Capital,Ingreso,Gasto -> (Tipo Cambio Promedio)
                                                     Otras (cuentas de Orden)     -> (Tipo Cambio Venta)
                --->
                <cfquery datasource="#Arguments.Conexion#">
                    UPDATE SaldosContablesConvertidos 
                     SET SCtipocambio = 
						<cfif listfind('N,F',Arguments.Tipo)>	
                        	COALESCE(CASE 
                       			WHEN McodigoOri = Mcodigo THEN 1.00 
                       				ELSE (SELECT CASE SaldosContablesConvertidos.CTCconversion 
                                    				WHEN 0 THEN CASE SaldosContablesConvertidos.Ctipo 
                                                    			   WHEN 'A' THEN m.TCcompra 
                                                   				   WHEN 'P' THEN m.TCventa 
                                                    			   WHEN 'C' THEN m.TCpromedio
                                                    			   WHEN 'I' THEN m.TCpromedio
                                                    			   WHEN 'G' THEN m.TCpromedio 
                                                    			   ELSE m.TCventa END
                                              	    WHEN 1 THEN  m.TCcompra 
                                                    WHEN 2 THEN  m.TCventa 
                                              	    WHEN 3 THEN  m.TCpromedio 
                                                    WHEN 4 THEN  (select TCHvalor
                                                    			  from HtiposcambioConversionD 
                                                                  WHERE Ecodigo  = SaldosContablesConvertidos.Ecodigo 
                                        							AND Speriodo = SaldosContablesConvertidos.Speriodo 
                							                        AND Smes     = SaldosContablesConvertidos.Smes 
							                                        AND Mcodigo  = SaldosContablesConvertidos.McodigoOri
                                                                    AND TCHid    = SaldosContablesConvertidos.TCHid
																	AND TCHtipo = 0
                                                    			  )
                                                    END 
                                      FROM HtiposcambioConversion#LabelB15# m 
                                      WHERE m.Ecodigo  = SaldosContablesConvertidos.Ecodigo 
                                        AND m.Speriodo = SaldosContablesConvertidos.Speriodo 
                                        AND m.Smes     = SaldosContablesConvertidos.Smes 
                                        AND m.Mcodigo  = SaldosContablesConvertidos.McodigoOri
										<cfif len(trim(LabelB15)) eq 0>
											AND m.TCtipo = 0	
										</cfif>
										) END, 1.00) 
						<cfelseif listfind('I',Arguments.Tipo)>					
                        	COALESCE(CASE 
                            	WHEN McodigoOri = Mcodigo THEN 1.00 
                                	ELSE (SELECT CASE SaldosContablesConvertidos.Ctipo 
                                                WHEN 'A' THEN  m.TCcompra2 
                                                WHEN 'P' THEN  m.TCventa2 
                                                WHEN 'C' THEN  m.TCpromedio2
                                                WHEN 'I' THEN  m.TCpromedio2
                                                WHEN 'G' THEN  m.TCpromedio2
                                                ELSE m.TCventa2 END
                                       FROM HtiposcambioConversionB15 m 
                                        WHERE m.Ecodigo  = SaldosContablesConvertidos.Ecodigo 
                                          AND m.Speriodo = SaldosContablesConvertidos.Speriodo 
                                          AND m.Smes     = SaldosContablesConvertidos.Smes 
                                          AND m.Mcodigo  = SaldosContablesConvertidos.McodigoOri) END , 1.00) 
                        </cfif>
                    WHERE SaldosContablesConvertidos.Ecodigo  = #Arguments.Ecodigo# 
                      AND SaldosContablesConvertidos.Speriodo = #Arguments.Periodo#
                      AND SaldosContablesConvertidos.Smes     = #Arguments.Mes#
                      AND SaldosContablesConvertidos.Mcodigo  = #LvarMonedaConversion#
                      AND SaldosContablesConvertidos.B15      = #LvarB15#
                </cfquery>
			<!---►►►Actualiza los débitos y Créditos Locales convertidos, Multiplicando los Débitos y Créditos Orígenes por el Tipo de cambio◄◄◄--->
            <cfif  (HistoricoB15.recordcount EQ 0 or HistoricoB15.Pvalor EQ 0 or HistoricoB15.Pvalor EQ 1)  and listfind('N,F,I',Arguments.Tipo)>

                        <cfquery datasource="#Arguments.Conexion#">
                            update SaldosContablesConvertidos
                            set 
						        DLdebitos  = round(DOdebitos  * SCtipocambio, 2), 
                                CLcreditos = round(COcreditos * SCtipocambio, 2)
						     where SaldosContablesConvertidos.Ecodigo    = #Arguments.Ecodigo#
                              and SaldosContablesConvertidos.Speriodo   = #Arguments.Periodo#
                              and SaldosContablesConvertidos.Smes       = #Arguments.Mes#
                              AND SaldosContablesConvertidos.Mcodigo    = #LvarMonedaConversion#
                              AND SaldosContablesConvertidos.B15        = #LvarB15#							  
                        </cfquery>
					
             </cfif>

			<cfif HistoricoB15.recordcount GT 0 and  HistoricoB15.Pvalor EQ 1 and listfind('I',Arguments.Tipo)>
                  
            			    <cfquery datasource="#Arguments.Conexion#">                                                    
                            update SaldosContablesConvertidos
                            set 
                                
							DLdebitos  = case SaldosContablesConvertidos.Ctipo 
                                					when 'I' then coalesce(round(SMLdebitos  * 1.00,2),0.00)
                                                    when 'C' then coalesce(round(SMLdebitos  * 1.00,2),0.00)
                                                    when 'G' then coalesce(round(SMLdebitos  * 1.00,2),0.00)
                                                    else coalesce(round(DOdebitos  * SCtipocambio, 2),0.00)
                                                    end
            
                                                                        
                                                                        
                                    , CLcreditos = case SaldosContablesConvertidos.Ctipo 
                                					when 'I' then coalesce(round(SMLcreditos  * 1.00,2),0.00)
                                                    when 'C' then coalesce(round(SMLcreditos  * 1.00,2),0.00)
                                                    when 'G' then coalesce(round(SMLcreditos  * 1.00,2),0.00)
                                                    else coalesce(round(CLcreditos  * SCtipocambio, 2),0.00)
                                                    end
                               <!---                     
                                    ,SLinicial  = case SaldosContablesConvertidos.Ctipo 
                                                	when 'I' then coalesce(round(SMLinicial  * 1.00,2),0.00)
                                                when 'C' then coalesce(round(SMLinicial  * 1.00,2),0.00)
                                                when 'G' then coalesce(round(SMLinicial  * 1.00,2),0.00)
                                                else (SLinicial + DLdebitos - CLcreditos)
                                                end
                                --->
                                                    
                                     
                            where SaldosContablesConvertidos.Ecodigo    = #Arguments.Ecodigo#
                              and SaldosContablesConvertidos.Speriodo   = #Arguments.Periodo#
                              and SaldosContablesConvertidos.Smes       = #Arguments.Mes#
                              AND SaldosContablesConvertidos.Mcodigo    = #LvarMonedaConversion#
                              AND SaldosContablesConvertidos.B15        = #LvarB15#
                            <cfif isdefined("lvarCuentaFluctuacion")>
                              AND SaldosContablesConvertidos.Ccuenta    not in (select Ccuenta
                                                                                  from CFinanciera a
                                                                                 where Cmayor in (select distinct(Cmayor) from CContables c
																								  inner join Parametros p on p.Pvalor = c.Ccuenta
																								  where  Pcodigo in (110,130,120,140)
																								  and c.Ecodigo = #Arguments.Ecodigo#) 
																						and Cmayor not in (#lvarCuentaFluctuacion#)
                                                                                 and Ecodigo = #Arguments.Ecodigo#
                                                                                 and CFpadre is not null
                                                                                 and CFmovimiento = 'S'
                                                                                )
                            </cfif>

                        </cfquery>
					                        
                        <cfquery datasource="#Arguments.Conexion#">
                            update SaldosContablesConvertidos
                            set 
                                DLdebitos  = round(DOdebitos  * SCtipocambio, 2), 
                                CLcreditos = round(COcreditos * SCtipocambio, 2)
                            where SaldosContablesConvertidos.Ecodigo    = #Arguments.Ecodigo#
                              and SaldosContablesConvertidos.Speriodo   = #Arguments.Periodo#
                              and SaldosContablesConvertidos.Smes       = #Arguments.Mes#
                              AND SaldosContablesConvertidos.Mcodigo    = #LvarMonedaConversion#
                              AND SaldosContablesConvertidos.B15        = #LvarB15#
                              AND SaldosContablesConvertidos.Ccuenta    in (select Ccuenta
                                                                                  from CFinanciera a
                                                                             where  Cmayor in (select distinct(Cmayor) from CContables c
																								  inner join Parametros p on p.Pvalor = c.Ccuenta
																								  where  Pcodigo in (110,130,120,140)
																								  and c.Ecodigo = #Arguments.Ecodigo#) 
																					 or Cmayor = #lvarCuentaFluctuacion#
                                                                             and Ecodigo = #Arguments.Ecodigo#
                                                                             and CFpadre is not null
                                                                             and CFmovimiento = 'S'
                                                                            )
                        </cfquery>
            
            			
            </cfif>

 
			<!---  
				Actualizar el movimiento en Debitos y Creditos de otras monedas 
				por el tipo de cambio de conversion, definido en la tabla de Tipos de Cambio
				comparandolo con los saldos finales de la moneda local
				cuando son Activos o Pasivos
				El saldo final convertido debe ser igual al saldo de la cuenta en la moneda por el tipo de cambio para estas cuentas!
					saldo final convertido = saldo en moneda por Tipo de Cambio de la tabla SaldosContablesConvertidos.

				Pasos:
					1.  Se obtienen los saldos finales del mes para cada registro insertado.
					2.  Se obiene el saldo final de las cuentas de activo / pasivo igual al saldo en la moneda * el tipo de cambio
					3.  Se compara el saldo final del mes con el saldo final de la moneda convertida para Activos o Pasivos y se ajustan los saldos
				
			--->
			
			<!---►►►PASO 1:Actualiza el saldos Final Local y el Saldo Final Origen de la siguiente manera◄◄◄
					Saldo Final Local  = Saldo Inicial Inicial Local  + Debitos Locales   - Creditos Locales
            		Saldo Final Origen = Saldo Inicial Inicial Origen + Debitos Origenes  - Creditos Origenes--->
			<cfquery datasource="#Arguments.Conexion#">
				update SaldosContablesConvertidos
				set 
					SLSaldoFinal = SLinicial + DLdebitos - CLcreditos,
					SOSaldoFinal = SOinicial + DOdebitos - COcreditos
				where SaldosContablesConvertidos.Ecodigo  = #Arguments.Ecodigo#
				  and SaldosContablesConvertidos.Speriodo = #Arguments.Periodo#
				  and SaldosContablesConvertidos.Smes     = #Arguments.Mes#
                  AND SaldosContablesConvertidos.Mcodigo  = #LvarMonedaConversion#
                  AND SaldosContablesConvertidos.B15      = #LvarB15#
			</cfquery>
		
			<!---►►►PASO 2:Actualiza el saldo Final Local con el Saldo Final Origen * Tipo de cambio para las cuentas de Activo y Pasivo. En caso de la Conversion a Moneda Funcional No se realiza este proceso para los Activos y Pasivos No monetarios, es decir aquellos que utilizan el TC promedio◄◄◄--->
			<cfquery datasource="#Arguments.Conexion#">
				update SaldosContablesConvertidos
				set 
					SLSaldoFinal = round(SOSaldoFinal * SCtipocambio, 2)
				where SaldosContablesConvertidos.Ecodigo     = #Arguments.Ecodigo#
				  and SaldosContablesConvertidos.Speriodo    = #Arguments.Periodo#
				  and SaldosContablesConvertidos.Smes        = #Arguments.Mes#
				  and SaldosContablesConvertidos.McodigoOri  <> #LvarMonedaConversion#
                  AND SaldosContablesConvertidos.Mcodigo     = #LvarMonedaConversion#
                  AND SaldosContablesConvertidos.B15         = #LvarB15#
				  and exists(
  				  		select 1
						from CContables c
							inner join CtasMayor cm
								 on cm.Ecodigo = c.Ecodigo
								and cm.Cmayor  = c.Cmayor
								and cm.Ctipo in ('A', 'P')
                                <cfif listfind('N,F',Arguments.Tipo)>
                                	and cm.CTCconversion != 3
                                </cfif>
						where c.Ccuenta = SaldosContablesConvertidos.Ccuenta
					)
			</cfquery>
 

			<!---►►►PASO 3.1:  Ajuste de Debitos Locales, para las cuentas de Activos y Pasivo◄◄◄
				Cuando: 
					Saldo Final Original * Tipo de cambio  ES MAYOR A Saldo Inicial Local + Debitos Locales - Creditos Locales
				Como: 
					A los Debitos Locales se le suma la Diferencia entre (Saldo Fin Ori * Tipo de cambio) y (Saldo Inicial Loc + Debitos Loc - Creditos Loc)--->
			<cfquery datasource="#Arguments.Conexion#">
				update SaldosContablesConvertidos
				set 
					DLdebitos  =  DLdebitos + (SLSaldoFinal - (SLinicial + DLdebitos - CLcreditos))
				where SaldosContablesConvertidos.Ecodigo     = #Arguments.Ecodigo#
				  and SaldosContablesConvertidos.Speriodo    = #Arguments.Periodo#
				  and SaldosContablesConvertidos.Smes        = #Arguments.Mes#
				  and SaldosContablesConvertidos.McodigoOri  <> #LvarMonedaConversion#
                  AND SaldosContablesConvertidos.Mcodigo     = #LvarMonedaConversion#
                  AND SaldosContablesConvertidos.B15         = #LvarB15#
				  and exists(
				  		select 1
						from CContables c
							inner join CtasMayor cm
								 on cm.Ecodigo = c.Ecodigo
								and cm.Cmayor  = c.Cmayor
								and cm.Ctipo in ('A', 'P')
                                <cfif listfind('N,F',Arguments.Tipo)>
                                	and cm.CTCconversion != 3
                                </cfif>
						where c.Ccuenta = SaldosContablesConvertidos.Ccuenta
					)
					and SLSaldoFinal > (SLinicial + DLdebitos - CLcreditos)
			</cfquery>

                       
           
			<!---►►►PASO 3.2:  Ajuste de Creditos Locales, para las cuentas de Activos y Pasivo◄◄◄
				Cuando: 
					Saldo Final Original * Tipo de cambio  ES MENOR A Saldo Inicial Local + Debitos Locales - Creditos Locales
				Como: 
					A los Creditos Locales se le suma la Diferencia entre (Saldo Fin Ori * Tipo de cambio) y (Saldo Inicial Loc + Debitos Loc - Creditos Loc)--->
			<cfquery datasource="#Arguments.Conexion#">
				update SaldosContablesConvertidos
				set 
					CLcreditos  =  CLcreditos + ((SLinicial + DLdebitos - CLcreditos) - SLSaldoFinal)
				where SaldosContablesConvertidos.Ecodigo     = #Arguments.Ecodigo#
				  and SaldosContablesConvertidos.Speriodo    = #Arguments.Periodo#
				  and SaldosContablesConvertidos.Smes        = #Arguments.Mes#
				  and SaldosContablesConvertidos.McodigoOri  <> #LvarMonedaConversion#
                  AND SaldosContablesConvertidos.Mcodigo     = #LvarMonedaConversion#
                  AND SaldosContablesConvertidos.B15         = #LvarB15#
				  and exists(
				  		select 1
						from CContables c
							inner join CtasMayor cm
								 on cm.Ecodigo = c.Ecodigo
								and cm.Cmayor  = c.Cmayor
								and cm.Ctipo in ('A', 'P')
                                <cfif listfind('N,F',Arguments.Tipo)>
                                	and cm.CTCconversion != 3
                                </cfif>
						where c.Ccuenta = SaldosContablesConvertidos.Ccuenta
					)
					and (SLinicial + DLdebitos - CLcreditos) > SLSaldoFinal
			</cfquery>

			<!---►►►Generar la cuentas de Diferencial cambiario para el Periodo si no existen en la tabla de SaldosContablesConvertidos
				tomando la cuenta registrada como cuenta de conversión de Estados Financieros 
				--->
				<cfquery datasource="#Arguments.Conexion#">
					insert into SaldosContablesConvertidos (
							Ccuenta, 
							Speriodo, 
							Smes, 
							Ecodigo, 
							Ocodigo, 
							Mcodigo, McodigoOri, 
							SOinicial, DOdebitos, COcreditos, 
							SLinicial, DLdebitos, CLcreditos, 
                            SMLinicial,SMLdebitos,SMLcreditos,
							SOSaldoFinal,
							SLSaldoFinal,
							BMUsucodigo, 
                            B15)
					select distinct 
							#lvarCuentaDiferencial#, 
							#Arguments.Periodo#, 
							#Arguments.Mes#, 
							#Arguments.Ecodigo#, 
							s.Ocodigo, 
							#LvarMonedaConversion#, 
							s.McodigoOri,
							0.00, 0.00, 0.00,
							0.00, 0.00, 0.00,
                            0.00, 0.00, 0.00,
							0.00, 0.00,
							#Arguments.Usucodigo#, 
                            #LvarB15#
					from SaldosContablesConvertidos s
					where s.Ecodigo  = #Arguments.Ecodigo#
					  and s.Speriodo = #Arguments.Periodo#
					  and s.Smes     = #Arguments.Mes#
                      AND s.Mcodigo  = #LvarMonedaConversion#
                      AND s.B15      = #LvarB15#
					  and not exists(
							select 1 
							from SaldosContablesConvertidos sc
							where sc.Ccuenta    = #lvarCuentaDiferencial#
							  and sc.Speriodo   = #Arguments.Periodo#
							  and sc.Smes       = #Arguments.Mes#
							  and sc.Ecodigo    = #Arguments.Ecodigo#
							  and sc.Mcodigo    = #LvarMonedaConversion#
							  and sc.Ocodigo    = s.Ocodigo
							  and sc.McodigoOri = s.McodigoOri
                              and sc.B15 		= s.B15)
				</cfquery>
	
				<cfquery datasource="#Arguments.Conexion#">
					update SaldosContablesConvertidos
					  set 
							CLcreditos = CLcreditos 
								+ case when coalesce((
									select sum(round(a.DLdebitos - a.CLcreditos, 2)) 
									from SaldosContablesConvertidos a
									where a.Ecodigo     = SaldosContablesConvertidos.Ecodigo
									  and a.Speriodo    = SaldosContablesConvertidos.Speriodo
									  and a.Smes        = SaldosContablesConvertidos.Smes
									  and a.Mcodigo     = SaldosContablesConvertidos.Mcodigo
									  and a.McodigoOri  = SaldosContablesConvertidos.McodigoOri
									  and a.Ocodigo     = SaldosContablesConvertidos.Ocodigo
                                      and a.B15 		= SaldosContablesConvertidos.B15
									), 0.00) > 0.00 
								then 
									coalesce((
									select sum(round(a.DLdebitos - a.CLcreditos, 2)) 
									from SaldosContablesConvertidos a
									where a.Ecodigo     = SaldosContablesConvertidos.Ecodigo
									  and a.Speriodo    = SaldosContablesConvertidos.Speriodo
									  and a.Smes        = SaldosContablesConvertidos.Smes
									  and a.Mcodigo     = SaldosContablesConvertidos.Mcodigo
									  and a.McodigoOri  = SaldosContablesConvertidos.McodigoOri
									  and a.Ocodigo     = SaldosContablesConvertidos.Ocodigo
                                      and a.B15 		= SaldosContablesConvertidos.B15
									), 0.00)
								else
									0.00
								end,
							DLdebitos = DLdebitos 
								+ case when coalesce((
									select sum(round(a.DLdebitos - a.CLcreditos, 2)) 
									from SaldosContablesConvertidos a
									where a.Ecodigo     = SaldosContablesConvertidos.Ecodigo
									  and a.Speriodo    = SaldosContablesConvertidos.Speriodo
									  and a.Smes        = SaldosContablesConvertidos.Smes
									  and a.Mcodigo     = SaldosContablesConvertidos.Mcodigo
									  and a.McodigoOri  = SaldosContablesConvertidos.McodigoOri
									  and a.Ocodigo     = SaldosContablesConvertidos.Ocodigo
                                      and a.B15 		= SaldosContablesConvertidos.B15
									), 0.00) < 0.00 
								then 
									coalesce((
									select sum(round(a.CLcreditos - a.DLdebitos, 2)) 
									from SaldosContablesConvertidos a
									where a.Ecodigo     = SaldosContablesConvertidos.Ecodigo
									  and a.Speriodo    = SaldosContablesConvertidos.Speriodo
									  and a.Smes        = SaldosContablesConvertidos.Smes
									  and a.Mcodigo     = SaldosContablesConvertidos.Mcodigo
									  and a.McodigoOri  = SaldosContablesConvertidos.McodigoOri
									  and a.Ocodigo     = SaldosContablesConvertidos.Ocodigo
                                      and a.B15 		= SaldosContablesConvertidos.B15
									), 0.00)
								else
									0.00
								end,
                           SMLcreditos = SMLcreditos 
								+ case when coalesce((
									select sum(round(a.SMLdebitos - a.SMLcreditos, 2)) 
									from SaldosContablesConvertidos a
									where a.Ecodigo     = SaldosContablesConvertidos.Ecodigo
									  and a.Speriodo    = SaldosContablesConvertidos.Speriodo
									  and a.Smes        = SaldosContablesConvertidos.Smes
									  and a.Mcodigo     = SaldosContablesConvertidos.Mcodigo
									  and a.McodigoOri  = SaldosContablesConvertidos.McodigoOri
									  and a.Ocodigo     = SaldosContablesConvertidos.Ocodigo
                                      and a.B15 		= SaldosContablesConvertidos.B15
									), 0.00) > 0.00 
								then 
									coalesce((
									select sum(round(a.SMLdebitos - a.SMLcreditos, 2)) 
									from SaldosContablesConvertidos a
									where a.Ecodigo     = SaldosContablesConvertidos.Ecodigo
									  and a.Speriodo    = SaldosContablesConvertidos.Speriodo
									  and a.Smes        = SaldosContablesConvertidos.Smes
									  and a.Mcodigo     = SaldosContablesConvertidos.Mcodigo
									  and a.McodigoOri  = SaldosContablesConvertidos.McodigoOri
									  and a.Ocodigo     = SaldosContablesConvertidos.Ocodigo
                                      and a.B15 		= SaldosContablesConvertidos.B15
									), 0.00)
								else
									0.00
								end,
                           SMLdebitos = SMLdebitos 
								+ case when coalesce((
									select sum(round(a.SMLdebitos - a.SMLcreditos, 2)) 
									from SaldosContablesConvertidos a
									where a.Ecodigo     = SaldosContablesConvertidos.Ecodigo
									  and a.Speriodo    = SaldosContablesConvertidos.Speriodo
									  and a.Smes        = SaldosContablesConvertidos.Smes
									  and a.Mcodigo     = SaldosContablesConvertidos.Mcodigo
									  and a.McodigoOri  = SaldosContablesConvertidos.McodigoOri
									  and a.Ocodigo     = SaldosContablesConvertidos.Ocodigo
                                      and a.B15 		= SaldosContablesConvertidos.B15
									), 0.00) < 0.00 
								then 
									coalesce((
									select sum(round(a.SMLcreditos - a.SMLdebitos, 2)) 
									from SaldosContablesConvertidos a
									where a.Ecodigo     = SaldosContablesConvertidos.Ecodigo
									  and a.Speriodo    = SaldosContablesConvertidos.Speriodo
									  and a.Smes        = SaldosContablesConvertidos.Smes
									  and a.Mcodigo     = SaldosContablesConvertidos.Mcodigo
									  and a.McodigoOri  = SaldosContablesConvertidos.McodigoOri
									  and a.Ocodigo     = SaldosContablesConvertidos.Ocodigo
                                      and a.B15 		= SaldosContablesConvertidos.B15
									), 0.00)
								else
									0.00
								end
                                
                                
					where Ccuenta  = #lvarCuentaDiferencial#
					  and Ecodigo  = #Arguments.Ecodigo#
					  and Speriodo = #Arguments.Periodo#
					  and Smes     = #Arguments.Mes#
                      AND Mcodigo  = #LvarMonedaConversion#
                      AND B15      = #LvarB15#
				</cfquery>

		
				<!--- 
					Actualizar el saldo final de la cuenta de diferencial cambiario, para que quede 
					el campo SLSaldoFinal como SLsaldoFinal + DLdebitos - CLcreditos
				--->
				<cfquery datasource="#Arguments.Conexion#">
					update SaldosContablesConvertidos
					set 
						SLSaldoFinal = SLinicial + DLdebitos - CLcreditos,
						SOSaldoFinal = SOinicial + DOdebitos - COcreditos
					where Ccuenta  = #lvarCuentaDiferencial#
					  and Ecodigo  = #Arguments.Ecodigo#
					  and Speriodo = #Arguments.Periodo#
					  and Smes     = #Arguments.Mes#
                      AND Mcodigo  = #LvarMonedaConversion#
                      AND B15      = #LvarB15#
				</cfquery>
		
			<!---►►►Realiza la Sumarización, Omitiendo las cuentas de Ultimo Nivel, pues ya existian◄◄◄--->
			<cfquery datasource="#Arguments.Conexion#">
				insert into SaldosContablesConvertidos (
					Ccuenta, Speriodo, Smes, Ecodigo, Ocodigo, Mcodigo, McodigoOri, BMUsucodigo,
					SOinicial, DOdebitos, COcreditos, SLinicial, DLdebitos, CLcreditos,SMLinicial, SMLdebitos, SMLcreditos,
					SOSaldoFinal, SLSaldoFinal, B15)
				select cu.Ccuentaniv, sc.Speriodo, sc.Smes, sc.Ecodigo, sc.Ocodigo, sc.Mcodigo, sc.McodigoOri, sc.BMUsucodigo,
					sum(sc.SOinicial), sum(sc.DOdebitos), sum(sc.COcreditos), sum(sc.SLinicial), sum(sc.DLdebitos), sum(sc.CLcreditos),
                    sum(sc.SMLinicial), sum(sc.SMLdebitos), sum(sc.SMLcreditos),
					sum(sc.SOSaldoFinal), sum(sc.SLSaldoFinal), #LvarB15#
				from SaldosContablesConvertidos sc
					inner join PCDCatalogoCuenta cu
						on cu.Ccuenta = sc.Ccuenta
				where sc.Ecodigo  = #Arguments.Ecodigo#
				  and sc.Speriodo = #Arguments.Periodo#
				  and sc.Smes	  =  #Arguments.Mes#
				  and cu.Ccuenta  <> cu.Ccuentaniv
                  and Mcodigo  	  = #LvarMonedaConversion#
                  and B15      	  = #LvarB15#
				group by cu.Ccuentaniv, sc.Speriodo, sc.Smes, sc.Ecodigo, sc.Ocodigo, sc.Mcodigo, sc.McodigoOri, sc.BMUsucodigo
			</cfquery>

			<!--- B15: siempre se ejecuta primero Tipo=F y luego Tipo=I --->
			<cfif Arguments.Tipo NEQ 'F'>
				<cfset sbCalculaSaldoCorp (Arguments.Tipo EQ 'I', Arguments.Periodo, Arguments.Mes)>
			</cfif>
	</cffunction>
	<!---►►►Funcion GetParam◄◄◄--->
    <cffunction name="GetParam" returntype="string" access="private" hint="Funcion para recuperar un parametro del Sistema">
        <cfargument name="Pcodigo"  type="numeric" required="yes" hint="Codigo">
        <cfargument name="Ecodigo"  type="string"  required="no" hint="Empresa">
        <cfargument name="Conexion" type="string"  required="no" hint="Conexion">
        <cfif NOT ISDEFINED("Arguments.Ecodigo")>
            <CFSET Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif NOT ISDEFINED("Arguments.Conexion")>
            <CFSET Arguments.Conexion = session.DSN>
        </cfif>
        <cfquery datasource="#Arguments.Conexion#" name="param">
            select coalesce(Pvalor,'') Pvalor
                from Parametros
             where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
               and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pcodigo#">
        </cfquery>
        <cfreturn param.Pvalor>
    </cffunction>

	<cffunction name="fnParametrosCorp" returntype="struct" access="public" output="false">
		<cfargument name="B15">
	
		<cfset LvarB15=Arguments.B15>
		<cfquery name="rsCuentaUtilidad" datasource="#session.dsn#">
			select Pvalor as cuenta
			from Parametros
			where Pcodigo = 300
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfif rsCuentaUtilidad.recordcount EQ 0 or len(rsCuentaUtilidad.cuenta) EQ 0>
			<cfthrow message="Error. No esta definida la Cuenta de Utilidad Acumulada. Proceso Cancelado!!">
		</cfif>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select Ccuentaniv from PCDCatalogoCuenta where Ccuenta=#rsCuentaUtilidad.cuenta#
		</cfquery>
		<cfset LvarCtasNivUtilidad = valueList(rsSQL.Ccuentaniv)>
		
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select Pvalor as mes
			  from Parametros
			 where Ecodigo = #session.Ecodigo#
			   and Pcodigo = 45
		</cfquery>
		<cfset LvarMesFiscal = rsSQL.mes> 
		
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select Pvalor as mes
			  from Parametros
			 where Ecodigo = #session.Ecodigo#
			   and Pcodigo = 46
		</cfquery>
		<cfset LvarMesCorporativo = rsSQL.mes>
		<cfif LvarMesCorporativo EQ "">
			<cfthrow type="toUser" message="No se han arrancado el Período Corporativo de Contabilidad">
		<cfelseif LvarMesCorporativo LT 0>
			<cfthrow type="toUser" message="El proceso de Arranque del Período Corporativo de Contabilidad está pendiente">
		</cfif>
		
		<cfif NOT LvarB15>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select Pvalor as fecha
				  from Parametros
				 where Ecodigo = #session.Ecodigo#
				   and Pcodigo = 48
			</cfquery>
			<cfif rsSQL.recordCount EQ 0>
				<cfquery datasource="#session.dsn#">
					insert into Parametros 
					(Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
					select Ecodigo, 48, Mcodigo, 'Fecha de Arranque de Saldos Convertidos Corporativos', null
					  from Parametros
					 where Ecodigo = #session.Ecodigo#
					   and Pcodigo = 47
				</cfquery>
			</cfif>
			<cfset LvarFechaArranque = trim(rsSQL.fecha)>
		<cfelse>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select Pvalor as fecha
				  from Parametros
				 where Ecodigo = #session.Ecodigo#
				   and Pcodigo = 49
			</cfquery>
			<cfif rsSQL.recordCount EQ 0>
				<cfquery datasource="#session.dsn#">
					insert into Parametros 
					(Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
					select Ecodigo, 49, Mcodigo, 'Fecha de Arranque de Saldos Convertidos Corporativos B15', null
					  from Parametros
					 where Ecodigo = #session.Ecodigo#
					   and Pcodigo = 47
				</cfquery>
			</cfif>
			<cfset LvarFechaArranque = trim(rsSQL.fecha)>
		</cfif>
	
		<cfset LvarRes = structNew()>
		<cfset LvarRes.LvarCtasNivUtilidad	= LvarCtasNivUtilidad>
		<cfset LvarRes.LvarMesFiscal		= LvarMesFiscal>
		<cfset LvarRes.LvarMesCorporativo	= LvarMesCorporativo>
		<cfset LvarRes.LvarFechaArranque	= LvarFechaArranque>
		
		<cfreturn LvarRes>
	</cffunction>
	
	<cffunction name="sbCalculaSaldoCorp" returntype="void" access="public" output="false">
		<cfargument name="B15"	 		type="boolean" required="yes">
		<cfargument name="Speriodo"		type="numeric" required="yes">
		<cfargument name="Smes"			type="numeric" required="yes">
		<cfargument name="Parametros"	type="struct"  required="no">
		<cfargument name="Aperiodo"		type="numeric" required="no">
		<cfargument name="Ames"			type="numeric" required="no">
		<cfargument name="Faltan"		type="boolean" required="no">
	
		
		<cfif isdefined("Arguments.Parametros")>
			<cfset LvarFechaArranque = Arguments.Parametros.LvarFechaArranque>
			<cfset LvarFaltan		 = Arguments.Faltan>
		<cfelse>
			<cfset Arguments.Parametros = fnParametrosCorp(Arguments.B15)>
			<cfset LvarFechaArranque = Arguments.Parametros.LvarFechaArranque>
			<cfset Arguments.Faltan  = (LvarFechaArranque EQ "")>
			<cfif Arguments.Faltan>
				<cfset Arguments.Aperiodo = 0>
				<cfset Arguments.Ames 	= 0>
			<cfelse>
				<cfset LvarFechaArranque	= LSparseDateTime(LvarFechaArranque)>
				<cfset Arguments.Aperiodo	= datepart("y",LvarFechaArranque)>
				<cfset Arguments.Ames		= datepart("m",LvarFechaArranque)>
			</cfif>
		</cfif>
		<cfset LvarB15				= Arguments.B15>
		<cfset LvarCtasNivUtilidad	= Arguments.Parametros.LvarCtasNivUtilidad>
		<cfset LvarMesFiscal		= Arguments.Parametros.LvarMesFiscal>
		<cfset LvarMesCorporativo	= Arguments.Parametros.LvarMesCorporativo>
		<cfset LvarAnoArranque		= Arguments.Aperiodo>
		<cfset LvarMesArranque		= Arguments.Ames>
		
		<cfset LvarMesAnt = Arguments.Smes - 1>
		<cfif LvarMesAnt eq 0>
			<cfset LvarMesAnt = 12>
			<cfset LvarPerAnt = Arguments.Speriodo - 1>
		<cfelse>
			<cfset LvarPerAnt = Arguments.Speriodo>
		</cfif>
	
		<cfif LvarMesCorporativo EQ LvarMesFiscal>
			<!--- Corporativo = Fiscal: copia Saldos Fiscales --->
			<cfquery datasource="#session.dsn#">
				update SaldosContablesConvertidos
				   set SLinicialGE = SLinicial,
					   SOinicialGE = SOinicial
				 where Ecodigo	= #session.Ecodigo#
				   and Speriodo = #Arguments.Speriodo#
				   and Smes		= #Arguments.Smes#
				<cfif LvarB15>
				   and B15		> 0
				<cfelse>
				   and B15		= 0
				</cfif>
			</cfquery>
		<cfelseif LvarMesArranque EQ 0 or LvarFaltan>
			<!--- Antes de Arranque: limpia saldos corporativos en CERO --->
			<cfquery datasource="#session.dsn#">
				update SaldosContablesConvertidos
				   set SLinicialGE = 0,
					   SOinicialGE = 0
				 where Ecodigo	= #session.Ecodigo#
				   and Speriodo = #Arguments.Speriodo#
				   and Smes		= #Arguments.Smes#
				<cfif LvarB15>
				   and B15		> 0
				<cfelse>
				   and B15		= 0
				</cfif>
			</cfquery>
		<cfelse>
			<!--- Saldos nuevos de Resultados que en periodo anterior con Saldo Final Corporativo --->
			<cfquery datasource="#session.dsn#">
				insert into SaldosContablesConvertidos (
						Ccuenta, 
						Speriodo, 
						Smes, 
						Ecodigo, 
						Ocodigo, 
						Mcodigo, McodigoOri, 
						SOinicial, DOdebitos, COcreditos, SOSaldoFinal, 
						SLinicial, DLdebitos, CLcreditos, SLSaldoFinal,
						SLinicialGE, SOinicialGE,
						BMUsucodigo, 
						B15
					)
				select distinct
						s.Ccuenta, 
						#Arguments.Speriodo#, 
						#Arguments.Smes#, 
						s.Ecodigo, 
						s.Ocodigo, 
						s.Mcodigo, McodigoOri, 
						0, 0, 0, 0, 
						0, 0, 0, 0,
						0, 0,
						s.BMUsucodigo, 
						s.B15
				  from SaldosContablesConvertidos s
					inner join CContables c
						inner join CtasMayor m
							 on m.Ecodigo	= c.Ecodigo
							and m.Cmayor	= c.Cmayor
							and m.Ctipo		in ('I','G')
						 on c.Ccuenta = s.Ccuenta
				 where s.Ecodigo	= #session.Ecodigo#
				   and s.Speriodo 	= #LvarPerAnt#
				   and s.Smes		= #LvarMesAnt#
				<cfif LvarB15>
				   and s.B15		> 0
				<cfelse>
				   and s.B15		= 0
				</cfif>
				   and SOinicialGE + DOdebitos-COcreditos <> 0
				   and (
						select count(1)
						  from SaldosContablesConvertidos act
						 where act.Ccuenta		= s.Ccuenta
						   and act.Speriodo		= s.Speriodo
						   and act.Smes			= s.Smes
						   and act.Ecodigo		= s.Ecodigo
						   and act.Ocodigo		= s.Ocodigo
						   and act.McodigoOri	= s.McodigoOri
						   and act.B15			= s.B15
						) = 0
			</cfquery>
			<!--- Saldos nuevos de Utilidad que existen en periodo anterior con Saldo Final Corporativo --->
			<cfquery datasource="#session.dsn#">
				insert into SaldosContablesConvertidos (
						Ccuenta, 
						Speriodo, 
						Smes, 
						Ecodigo, 
						Ocodigo, 
						Mcodigo, McodigoOri, 
						SOinicial, DOdebitos, COcreditos, SOSaldoFinal, 
						SLinicial, DLdebitos, CLcreditos, SLSaldoFinal,
						SLinicialGE, SOinicialGE,
						BMUsucodigo, 
						B15
					)
				select 
						Ccuenta, 
						#Arguments.Speriodo#, 
						#Arguments.Smes#, 
						Ecodigo, 
						Ocodigo, 
						Mcodigo, McodigoOri, 
						0, 0, 0, 0, 
						0, 0, 0, 0,
						0, 0,
						BMUsucodigo, 
						B15
				  from SaldosContablesConvertidos
				 where Ecodigo	= #session.Ecodigo#
				   and Speriodo = #LvarPerAnt#
				   and Smes		= #LvarMesAnt#
				<cfif LvarB15>
				   and B15		> 0
				<cfelse>
				   and B15		= 0
				</cfif>
				   and Ccuenta	in (#LvarCtasNivUtilidad#)
				   and SOinicialGE + DOdebitos-COcreditos <> 0
				   and (
						select count(1)
						  from SaldosContablesConvertidos ant
						 where ant.Ccuenta		= SaldosContablesConvertidos.Ccuenta
						   and ant.Speriodo		= #Arguments.Speriodo#
						   and ant.Smes			= #Arguments.Smes#
						   and ant.Ecodigo		= SaldosContablesConvertidos.Ecodigo
						   and ant.Ocodigo		= SaldosContablesConvertidos.Ocodigo
						   and ant.McodigoOri	= SaldosContablesConvertidos.McodigoOri
						   and ant.B15			= SaldosContablesConvertidos.B15
						) = 0
			</cfquery>
			<!--- Corporativo <> Fiscal: Arrastra saldo final mes anterior --->
			<cfif LvarAnoArranque EQ Arguments.Speriodo AND LvarMesArranque EQ Arguments.Smes>
				<!--- Cuando es el arranque se toma como base los Saldos Fiscales porque no hay mes anterior --->
				<cfquery datasource="#session.dsn#">
					update SaldosContablesConvertidos
					   set SLinicialGE = SLinicial,
						   SOinicialGE = SOinicial
					 where Ecodigo	= #session.Ecodigo#
					   and Speriodo = #Arguments.Speriodo#
					   and Smes		= #Arguments.Smes#
					<cfif LvarB15>
					   and B15		> 0
					<cfelse>
					   and B15		= 0
					</cfif>
				</cfquery>
			<cfelse>
				<!--- Excepto el primero, arrastra el saldo final corporativo del mes anterior --->
				<cfquery datasource="#session.dsn#">
					update SaldosContablesConvertidos
					   set SLinicialGE = 
							coalesce(
							(
								select SLinicialGE + DLdebitos-CLcreditos
								  from SaldosContablesConvertidos ant
								 where ant.Ccuenta		= SaldosContablesConvertidos.Ccuenta
								   and ant.Speriodo		= #LvarPerAnt#
								   and ant.Smes			= #LvarMesAnt#
								   and ant.Ecodigo		= SaldosContablesConvertidos.Ecodigo
								   and ant.Ocodigo		= SaldosContablesConvertidos.Ocodigo
								   and ant.McodigoOri	= SaldosContablesConvertidos.McodigoOri
								   and ant.B15			= SaldosContablesConvertidos.B15
							), 0)
						 , SOinicialGE = 
							coalesce(
							(
								select SOinicialGE + DOdebitos-COcreditos
								  from SaldosContablesConvertidos ant
								 where ant.Ccuenta		= SaldosContablesConvertidos.Ccuenta
								   and ant.Speriodo		= #LvarPerAnt#
								   and ant.Smes			= #LvarMesAnt#
								   and ant.Ecodigo		= SaldosContablesConvertidos.Ecodigo
								   and ant.Ocodigo		= SaldosContablesConvertidos.Ocodigo
								   and ant.McodigoOri	= SaldosContablesConvertidos.McodigoOri
								   and ant.B15			= SaldosContablesConvertidos.B15
							), 0)
					 where Ecodigo	= #session.Ecodigo#
					   and Speriodo = #Arguments.Speriodo#
					   and Smes		= #Arguments.Smes#
					<cfif LvarB15>
					   and B15		> 0
					<cfelse>
					   and B15		= 0
					</cfif>
				</cfquery>
			</cfif>
	
			<!--- Inicio de Periodo Corporativo: Cierre Virtual --->
			<cfif LvarMesArranque EQ Arguments.Smes>
				<!--- Cierre virtual 0: Saldos nuevos de Utilidad que existen en Resultados y deben cerrarse --->
				<cfquery datasource="#session.dsn#">
					insert into SaldosContablesConvertidos (
							Ccuenta, 
							Speriodo, 
							Smes, 
							Ecodigo, 
							Ocodigo, 
							Mcodigo, McodigoOri, 
							SOinicial, DOdebitos, COcreditos, SOSaldoFinal, 
							SLinicial, DLdebitos, CLcreditos, SLSaldoFinal,
							SLinicialGE, SOinicialGE,
							BMUsucodigo, 
							B15
						)
					select distinct
							u.Ccuenta, 
							s.Speriodo, 
							s.Smes, 
							s.Ecodigo, 
							s.Ocodigo, 
							s.Mcodigo, McodigoOri, 
							0, 0, 0, 0, 
							0, 0, 0, 0,
							0, 0,
							s.BMUsucodigo, 
							s.B15
					  from SaldosContablesConvertidos s
						inner join CContables c
							inner join CtasMayor m
								 on m.Ecodigo	= c.Ecodigo
								and m.Cmayor	= c.Cmayor
								and m.Ctipo		in ('I','G')
							 on c.Ccuenta = s.Ccuenta
						inner join CContables u
							 on u.Ccuenta	in (#LvarCtasNivUtilidad#)
					 where s.Ecodigo	= #session.Ecodigo#
					   and s.Speriodo 	= #Arguments.Speriodo#
					   and s.Smes		= #Arguments.Smes#
					<cfif LvarB15>
					   and s.B15		> 0
					<cfelse>
					   and s.B15		= 0
					</cfif>
					   and (
							select count(1)
							  from SaldosContablesConvertidos act
							 where act.Ccuenta		= u.Ccuenta
							   and act.Speriodo		= s.Speriodo
							   and act.Smes			= s.Smes
							   and act.Ecodigo		= s.Ecodigo
							   and act.Ocodigo		= s.Ocodigo
							   and act.McodigoOri	= s.McodigoOri
							   and act.B15			= s.B15
							) = 0
				</cfquery>
				<!--- Cierre virtual 1: Acumula en la cuenta de utilidad la suma de ingresos y gastos --->
				<cfquery datasource="#session.dsn#">
					update SaldosContablesConvertidos
					   set SLinicialGE = SLinicialGE + 
							coalesce(
							(
								select sum(SLinicialGE)
								  from SaldosContablesConvertidos IyG
									inner join CContables c
										inner join CtasMayor m
											 on m.Ecodigo	= c.Ecodigo
											and m.Cmayor	= c.Cmayor
											and m.Ctipo		in ('I','G')
										 on c.Ccuenta = IyG.Ccuenta
								 where IyG.Ecodigo		= SaldosContablesConvertidos.Ecodigo
								   and IyG.Speriodo		= SaldosContablesConvertidos.Speriodo
								   and IyG.Smes			= SaldosContablesConvertidos.Smes
								   and IyG.Ocodigo		= SaldosContablesConvertidos.Ocodigo
								   and IyG.McodigoOri	= SaldosContablesConvertidos.McodigoOri
								   and IyG.B15			= SaldosContablesConvertidos.B15
							), 0)
						 , SOinicialGE = SOinicialGE +
							coalesce(
							(
								select sum(SOinicialGE)
								  from SaldosContablesConvertidos IyG
									inner join CContables c
										inner join CtasMayor m
											 on m.Ecodigo	= c.Ecodigo
											and m.Cmayor	= c.Cmayor
											and m.Ctipo		in ('I','G')
										 on c.Ccuenta = IyG.Ccuenta
								 where IyG.Ecodigo		= SaldosContablesConvertidos.Ecodigo
								   and IyG.Speriodo		= SaldosContablesConvertidos.Speriodo
								   and IyG.Smes			= SaldosContablesConvertidos.Smes
								   and IyG.Ocodigo		= SaldosContablesConvertidos.Ocodigo
								   and IyG.McodigoOri	= SaldosContablesConvertidos.McodigoOri
								   and IyG.B15			= SaldosContablesConvertidos.B15
							), 0)
					 where Ecodigo	= #session.Ecodigo#
					   and Speriodo = #Arguments.Speriodo#
					   and Smes		= #Arguments.Smes#
					<cfif LvarB15>
					   and B15		> 0
					<cfelse>
					   and B15		= 0
					</cfif>
					   and Ccuenta	in (#LvarCtasNivUtilidad#)
				</cfquery>
				<!--- Cierre virtual 2: Inicializa en cero las Cuentas de Ingresos y Gastos --->
				<cfquery datasource="#session.dsn#">
					update SaldosContablesConvertidos
					   set SLinicialGE = 0,
						   SOinicialGE = 0
					 where Ecodigo	= #session.Ecodigo#
					   and Speriodo = #Arguments.Speriodo#
					   and Smes		= #Arguments.Smes#
					<cfif LvarB15>
					   and B15		> 0
					<cfelse>
					   and B15		= 0
					</cfif>
					   and (
							select count(1)
							  from CContables c
								inner join CtasMayor m
									 on m.Ecodigo	= c.Ecodigo
									and m.Cmayor	= c.Cmayor
									and m.Ctipo		in ('I','G')
							 where c.Ccuenta = SaldosContablesConvertidos.Ccuenta
							) > 0
				</cfquery>
			</cfif>
		</cfif>
	</cffunction>
</cfcomponent>