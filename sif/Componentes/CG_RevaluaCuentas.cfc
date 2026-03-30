<!--- 
	Componente de Revaluación de Cuentas
--->
<cfcomponent>
	<cffunction name="RevaluaCuentas" access="public" returntype="string" output="true">
		<!--- Parámetros Requeridos --->
		<cfargument name="periodo" type="numeric" required="true">
		<cfargument name="mes" type="numeric" required="true">
		<cfargument name="aplicar" type="boolean" required="no" default="#false#">
		<cfargument name="debug" type="boolean" required="no" default="#false#">
		
		<!--- Variables Locales --->
		<cfset args = structnew()>
		<cfset args = arguments>
		<cfset LvarResult = "OK">
		
		<cfset periodo_valido = args.periodo>
		<cfset mes_valido = args.mes>
		<cfset mesperiodo = periodo_valido * 12 + mes_valido>
		
		<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
		
		<!--- 1.	Paso Cero Validaciones Iniciales --->
		<!--- 1.1	validar que el periodo mes sea válido --->
		<cfset rs = QueryNew("")>
		<cfquery name="rs" datasource="#session.dsn#">
			select Pvalor
			from Parametros
			where Ecodigo = #session.ecodigo#
			and Pcodigo = 30
		</cfquery>
		<cfif rs.recordcount and len(rs.Pvalor) and rs.Pvalor>
			<cfset periodo_contable = rs.Pvalor>
		<cfelse>
			<!--- Mensaje de Error: --->
			<cf_errorCode	code = "51080" msg = "El Periodo Contable no está definido. Proceso Cancelado!">
		</cfif>
		<cfset rs = QueryNew("")>
		<cfquery name="rs" datasource="#session.dsn#">
			select Pvalor
			from Parametros
			where Ecodigo = #session.ecodigo#
			and Pcodigo = 40
		</cfquery>
		<cfif rs.recordcount and len(rs.Pvalor)>
			<cfset mes_contable = rs.Pvalor>
		<cfelse>
			<!--- Mensaje de Error: --->
			<cf_errorCode	code = "51081" msg = "El Mes Contable no está definido. Proceso Cancelado!">
		</cfif>
		<cfif (mesperiodo) GT (periodo_contable*12+mes_contable)>
			<!--- Mensaje de Error: --->
			<cf_errorCode	code = "51082" msg = "El Proceso no se puede ejecutar para un mes posterior al vigente de la Contabilidad General. Proceso Cancelado!">
		</cfif>
		<!--- 1.2	validar que en periodo mes no existan asientos sin aplicar en la conta --->
		<cfset rs = QueryNew("")>
		<cfquery name="rs" datasource="#session.dsn#">
			select 1
			from EContables
			where Ecodigo = #session.Ecodigo#
			  and Eperiodo <= #periodo_valido#
			  and (Eperiodo * 12 + Emes) <= #mesperiodo#
		</cfquery>
		 <cfif rs.recordcount>
			<!--- Mensaje de Error: --->
			<cf_errorCode	code = "51083"
							msg  = "Existen Documentos Sin Aplicar en El Periodo @errorDat_1@ / Mes @errorDat_2@. Proceso Cancelado!"
							errorDat_1="#periodo_valido#"
							errorDat_2="#mes_valido#"
			>
		</cfif>
	
		<!--- Para evitar que se dejen valores en cero, se incializa la información del tipo de cambio para aquellas monedas que se encuentren en cero --->
		<cfquery datasource="#session.dsn#">
			update TipoCambioEmpresa
			set TCEtipocambio = 1
			where Ecodigo    = #Session.Ecodigo#
			  and Periodo  =   #periodo_valido#
			  and Mes      =   #mes_valido#
			  and TCEtipocambio = 0.00
		</cfquery>

		<cfquery datasource="#session.dsn#">
			update TipoCambioEmpresa
			set TCEtipocambioventa = TCEtipocambio
			where Ecodigo    = #Session.Ecodigo#
			  and Periodo  =   #periodo_valido#
			  and Mes      =   #mes_valido#
			  and TCEtipocambioventa = 0.00
		</cfquery>

		<cfquery datasource="#session.dsn#">
			update TipoCambioEmpresa
			set TCEtipocambioprom = TCEtipocambio
			where Ecodigo    = #Session.Ecodigo#
			  and Periodo  =   #periodo_valido#
			  and Mes      =   #mes_valido#
			  and TCEtipocambioprom = 0.00
		</cfquery>
	
		
		<!--- 2.	Construir la tabla temporal de Asientos Contables --->
		<!--- 2.1	Crea tabla temporal para crear el asiento #INTARC# --->
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" Conexion="#session.dsn#" method="CreaIntarc" returnvariable="INTARC"/>
		
		<!--- 3.	Llenar la tabla temportal de Asientos Contables con las cuentas que deben revaluarse --->
		<!--- 3.1	Proceso de Revaluacion de cuentas revaluables con saldos en moneda extranjera --->
		<cf_dbfunction name="to_char" returnvariable="LvarSperiodo" args="s.Speriodo">
		<cf_dbfunction name="to_char" returnvariable="LvarSmes" args="s.Smes">
		
		
		<cfquery datasource="#session.dsn#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
			select 
				'CGRC' as INTORI,
				0 as INTREL,
				#PreserveSingleQuotes(LvarSperiodo)# #_Cat# ' - ' #_Cat# #PreserveSingleQuotes(LvarSmes)# as INTDOC,
				#PreserveSingleQuotes(LvarSperiodo)# #_Cat# ' - ' #_Cat# #PreserveSingleQuotes(LvarSmes)# as INTREF,
				round(
						(s.SOinicial + s.DOdebitos - s.COcreditos) * 
						case m.Crevaluable
							when 1 then TCEtipocambio
							when 2 then TCEtipocambioventa
							when 3 then TCEtipocambioprom
							else 1.00
						end
						, 2) 
				- 
				round(
						(s.SLinicial + s.DLdebitos - s.CLcreditos), 2)
				as INTMON,
				'D' as INTTIP,
				'Revaluacion Cuenta ' #_Cat# c.Cformato as INTDES,
				'#dateformat(CreateDate(periodo_valido,mes_valido,DaysInMonth(CreateDate(periodo_valido,mes_valido,1))),'yyyymmdd')#' as INTFEC,
				
				0.00 as INTCAM,
				s.Speriodo as Periodo,
				s.Smes as Mes,
				s.Ccuenta as Ccuenta,
				s.Mcodigo as Mcodigo,
				s.Ocodigo as Ocodigo,
				0.00 as INTMOE
			from 
				CtasMayor m <cf_dbforceindex name="PK_CTASMAYOR"> 
			
				inner join CContables c <cf_dbforceindex name="CContables_FK1">
						on c.Ecodigo     = m.Ecodigo
					   and c.Cmayor      = m.Cmayor
					    and c.Cmovimiento <> 'N'
			
					inner join Empresas e
						on e.Ecodigo = c.Ecodigo
			
						inner join SaldosContables s <cf_dbforceindex name="PK_SALDOSCONTABLES">
							 on s.Ccuenta   =   c.Ccuenta
							and s.Ecodigo   =   c.Ecodigo
							and s.Speriodo  =   #periodo_valido#
							and s.Smes      =   #mes_valido#
			
							 inner join TipoCambioEmpresa tc <cf_dbforceindex name="PK_TIPOCAMBIOEMPRESA">
							   on tc.Ecodigo    = s.Ecodigo
							  and tc.Periodo    = s.Speriodo
							  and tc.Mes        = s.Smes
							  and tc.Mcodigo    = s.Mcodigo 
			
			where m.Ecodigo     = #Session.Ecodigo#
			  and m.Crevaluable > 0
			  and s.Mcodigo   <>  e.Mcodigo
		</cfquery>

		 <cfquery datasource="#session.dsn#">
			delete from #INTARC#
			where INTMON = 0.00
		</cfquery> 

		 <cfquery datasource="#session.dsn#">
			update #INTARC#
				set INTMON = - INTMON, INTTIP = 'C'
			where INTMON < 0.00
		</cfquery> 

		
		<!--- Tercer paso.  Insertar la cuenta de Ganancia / Perdida por Diferencial cambiario en la tabla temporal --->
        <cf_dbfunction name="to_number" args="Pvalor" returnvariable="LvarPvalor">
		<cfquery datasource="#session.dsn#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
			select
				'CGRC' as INTORI,
				0 as INTREL,
				INTDOC as INTDOC,
				INTREF as INTREF,
				sum(INTMON),
				case when INTTIP = 'D' then 'C' else 'D' end as INTTIP,
				case when INTTIP = 'D' then 'Ganancia Cambiaria ' else 'Perdida Cambiaria' end as INTDES,
 				'#dateformat(CreateDate(periodo_valido,mes_valido,DaysInMonth(CreateDate(periodo_valido,mes_valido,1))),'yyyymmdd')#' as INTFEC, 
				0.00 as INTCAM,
				Periodo as Periodo,
				Mes as Mes,
				case when INTTIP = 'D' 
					then 
						((select #LvarPvalor# from Parametros p1 where p1.Ecodigo = #Session.Ecodigo# and p1.Pcodigo = 260))
					else 
						((select #LvarPvalor# from Parametros p2 where p2.Ecodigo = #Session.Ecodigo# and p2.Pcodigo = 270))
					end as Ccuenta,
				Mcodigo as Mcodigo,
				Ocodigo as Ocodigo,
				0.00 as INTMOE
			from #INTARC# a
			group by INTTIP, Ocodigo, Mcodigo, INTDOC, INTREF, Periodo, Mes
			 having sum(INTMON) <> 0.00 
		</cfquery>
		
		<cfif arguments.debug>
			<cfset rs = QueryNew("")>
			<cfquery name="rs" datasource="#session.dsn#">
				select * from #INTARC#
			</cfquery>
			<cfdump var="#args#">
			<cfdump var="#rs#">
			<cf_abort errorInterfaz="">
		</cfif>
		
		<cfset rs = QueryNew("")>
		<cfquery name="rs" datasource="#session.dsn#">
			select count(1) as Cantidad 
            from #INTARC#
		</cfquery>


		<cfif rs.recordcount gt 0 and rs.cantidad gt 1>
			<!--- Paso 4.  Enviar el llamado a GeneraAsiento con Fecha = #CreateDate(Periodo, Mes, Days(Mes))#, con Nuevo Origen CGRV
				Se debe incluir en el GeneraAsiento un parametro adicional para permitir crear asientos retroactivos 
				Si el mes y periodo de #INTARC es el mes actual, se debe indicar que el campo ECtipo es cero
				Si el mes y periodo de #INTARC es diferente al mes actual, se debe indicar que el campo ECtipo es 2
			--->
			<!--- De aquí en adelante se requiere Transaction --->
			<cftransaction>
			
                <cfinvoke component="sif.Componentes.CG_GeneraAsiento" Conexion="#session.dsn#" method="GeneraAsiento" returnvariable="IDcontable" 
                    Ecodigo="#session.ecodigo#" Usuario="#session.Usulogin#" Oorigen="CGRC" Eperiodo="#periodo_valido#" Emes="#mes_valido#" 
                    Efecha="#CreateDate(periodo_valido,mes_valido,DaysInMonth(CreateDate(periodo_valido,mes_valido,1)))#" 
                    Edescripcion="Revaluación de Cuentas: #LSdateformat(CreateDate(periodo_valido,mes_valido,DaysInMonth(CreateDate(periodo_valido,mes_valido,1))),'DD/MM/YYYY')#." 
                    Edocbase="RC: #LSdateformat(CreateDate(periodo_valido,mes_valido,DaysInMonth(CreateDate(periodo_valido,mes_valido,1))),'DD/MM/YYYY')#"
                    Ereferencia="#Dateformat(now(),'YYYY-MM-DD')# #timeformat(now(),'hh:mm:ss')#"
					Retroactivo="#not (periodo_valido eq periodo_contable and mes_valido eq mes_contable)#"
					/>

			</cftransaction>

			<!--- Aplica el Asiento contable IDcontable --->
			<cfif arguments.aplicar>
				<cfinvoke 
				 component="sif.Componentes.CG_AplicaAsiento"
				 method="CG_AplicaAsiento"
				 IDcontable="#IDcontable#"
				 CtlTransaccion="true"/>
			</cfif>
		</cfif>
		<cfreturn LvarResult>
	</cffunction>
</cfcomponent>


