<!---- Lista de Reportes----->
<cfset ArrayReportes=arrayNew(1)>

<cfset addRep('DATSAL','RH.NOMINA.EXPDATSAL')>
<cfset addRep('ASOCT','RH.NOMINA.DEDUCCASOC')>
<cfset addRep('AUXPV','RH.NOMINA.CONPROVACA')>
<cfset addRep('CERT','')>
<cfset addRep('CTI','RH.NOMINA.REPCERTRA')>
<cfset addRep('DEDAS','')>
<cfset addRep('DHC','RH.NOMINA.ENCONODHC')>
<cfset addRep('Escol','RH.NOMINA.REPSALESCO')>
<cfset addRep('GLRB','RH.AUTO.AUTOPROY')>
<cfset addRep('GLRB','RH.NOMINA.PROYECCREN')>
<cfset addRep('GLRD','RH.AUTO.AUTOPROY')>
<cfset addRep('GLRD','RH.NOMINA.PROYECCREN')>
<cfset addRep('INC','RH.NOMINA.REPNOMBINC')>
<cfset addRep('INFON','')>
<cfset addRep('LS','')>
<cfset addRep('LSCR','RH.NOMINA.REPLSALARI')>
<cfset addRep('MT','')>
<cfset addRep('MX001','RH.NOMINA.RDSAL')>
<cfset addRep('MX002','RH.NOMINA.RNDMX')>
<cfset addRep('PR001','CLOUD.Nomina.GeneNomina')>
<cfset addRep('PR002','')>
<cfset addRep('RENTA','RH.NOMINA.ENCORELQRE')>
<cfset addRep('REPRE','')>
<cfset addRep('RMI','')>
<cfset addRep('RNP','RH.NOMINA.REPNOMPLA')>
<cfset addRep('SA','RH.NOMINA.REPNOMBSA')>
<cfset addRep('SA','RH.NOMINA.RHENMOEMP')>
<cfset addRep('SSP','RH.NOMINA.REPSEGSPAN')>

<!--- 20150527 - ljimenez se crea para ser utilizada como insumos para la generacion de las certificaciones 
de Rh aca tenemos asociado las cargas de ley 
(CSiLey) donde agregamos lo que nos rebaja por conceptos de cargas (9.34%)
(CNoLey) asociamos otras cargas que se deben de rebajar del salario del empelado 
(Embargo) asociamos la deduccion utilizada para el rebajo de embargos al empleado --->
<cfset addRep('CERTRRHH','RH.PARAM.FMT')> 

<!--- 20150714 - ljimenez se crea para ser utilizada como insumos para la generacion de el Reporte General de Planillas 
que es particular para SUTEL--->
<cfset addRep('RepGenPlan','RH.NOMINA.REPLASU')>
<!--- 20151229 - ljimenez se crea para ser utilizada como insumos para la generacion de las Certificaciones de RH en FundaTec--->
<cfset addRep('FundaTec','RH.PARAM.FMT')>

<cfquery datasource="#session.dsn#" name="rsRF">
    select '' as cod from dual where 1=2
    <cfloop from="1" to="#arrayLen(ArrayReportes)#" index = "i">
        <cfif len(trim(ArrayReportes[i].proceso))>
        union
        select '#ArrayReportes[i].cod#' as cod from dual 
        where exists( 
                        select 1 from vUsuarioProcesos 
                        where SScodigo = '#listGetAt(ArrayReportes[i].proceso, 1,'.')#'
                        and SMcodigo = '#listGetAt(ArrayReportes[i].proceso, 2,'.')#'
                        and SPcodigo = '#listGetAt(ArrayReportes[i].proceso, 3,'.')#'
                        and Ecodigo=#session.EcodigoSDC#
                        and Usucodigo=#session.Usucodigo#
                    ) 
        </cfif>
    </cfloop>
</cfquery>



 
<!----- pregunta si existe algun reporte pendiente de agregar----->
<cfquery datasource="#session.dsn#" name="rsRF">
    select '' as id from dual where 1=2
    <cfloop query="#rsRF#">
        union
        select '#rsRF.cod#' as id from dual where not exists( select 1 from RHReportesNomina where RHRPTNcodigo = '#rsRF.cod#' and Ecodigo=#session.Ecodigo#) 
    </cfloop>
</cfquery>

<cfloop query="rsRF">
    <cftransaction>
        <cfif len(trim(rsRF.id))>
            <!----- obtiene toda la info de las columnas----->
            <cfset RepCols = getInfoRep(rsRF.id)>
            <cfquery datasource="#session.dsn#" name="rsInsertReport">
                insert into RHReportesNomina(Ecodigo,RHRPTNcodigo,RHRPTNdescripcion,RHRPTNlineas,BMUsucodigo,fechaalta)
                values(
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRF.id#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#RepCols.enc#">,
                        50,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                        <cf_dbfunction name="today">
                    )
                <cf_dbidentity1>
            </cfquery>
            <cf_dbidentity2 name="rsInsertReport">
            <cfquery datasource="#session.dsn#">
                insert into RHColumnasReporte(RHRPTNid,RHCRPTcodigo,RHCRPTdescripcion,RHRPTNcolumna,BMUsucodigo,fechaalta,RHRPTNOrigen)
                <cfloop from="1" to="#arrayLen(RepCols.cols)#" index="i">
                    select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsertReport.identity#"> as RHRPTNid,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAt(RepCols.cols[i],1,':')#"> as RHCRPTcodigo,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAt(RepCols.cols[i],2,':')#"> as RHCRPTdescripcion,
                            0 as RHRPTNcolumna,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> as BMUsucodigo,
                            <cf_dbfunction name="today"> as fechaalta,
                            0 as RHRPTNOrigen
                    from dual
                    <cfif arrayLen(RepCols.cols) neq i>
                        union
                    </cfif>
                </cfloop>
            </cfquery>            
        </cfif>
    </cftransaction>
</cfloop>


<!--- 2015-12-29 - ljimenez se insertan las columnas que no existen en los reportes por que fueron creadas porteriormente --->
<cfquery datasource="#session.dsn#" name="rsRF">
    select '' as id from dual where 1=2
    <cfloop from="1" to="#arrayLen(ArrayReportes)#" index = "i">
        <cfif len(trim(ArrayReportes[i].proceso))>
        union
        select '#ArrayReportes[i].cod#' as id from dual 
        where exists( 
                        select 1 from vUsuarioProcesos 
                        where SScodigo = '#listGetAt(ArrayReportes[i].proceso, 1,'.')#'
                        and SMcodigo = '#listGetAt(ArrayReportes[i].proceso, 2,'.')#'
                        and SPcodigo = '#listGetAt(ArrayReportes[i].proceso, 3,'.')#'
                        and Ecodigo=#session.EcodigoSDC#
                        and Usucodigo=#session.Usucodigo#
                    ) 
        </cfif>
    </cfloop>
</cfquery>

<cfloop query="rsRF">
    <cftransaction>
        <cfif len(trim(rsRF.id))>
            <!----- obtiene toda la info de las columnas----->
            <cfset RepCols = getInfoRep(rsRF.id)>

            <cfquery datasource="#session.dsn#" name="rsInsertReport">
                select RHRPTNid from RHReportesNomina where RHRPTNcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRF.id#">
                and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            </cfquery>

            <cfloop from="1" to="#arrayLen(RepCols.cols)#" index="i">
                <cfquery datasource="#session.dsn#">
                    update RHColumnasReporte set RHCRPTdescripcion = 
                        (select  <cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAt(RepCols.cols[i],2,':')#"> as RHCRPTdescripcion
                        from dual )
                    where RHColumnasReporte.RHRPTNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsertReport.RHRPTNid#">
                        and RHColumnasReporte.RHCRPTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAt(RepCols.cols[i],1,':')#">
                </cfquery> 
            </cfloop>
            
            <cfquery datasource="#session.dsn#">
                insert into RHColumnasReporte(RHRPTNid,RHCRPTcodigo,RHCRPTdescripcion,RHRPTNcolumna,BMUsucodigo,fechaalta,RHRPTNOrigen)
                <cfloop from="1" to="#arrayLen(RepCols.cols)#" index="i">
                    select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsertReport.RHRPTNid#"> as RHRPTNid,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAt(RepCols.cols[i],1,':')#"> as RHCRPTcodigo,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAt(RepCols.cols[i],2,':')#"> as RHCRPTdescripcion,
                            0 as RHRPTNcolumna,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> as BMUsucodigo,
                            <cf_dbfunction name="today"> as fechaalta,
                            0 as RHRPTNOrigen
                    from dual where not exists (select 1 from RHColumnasReporte a 
                                                where a.RHRPTNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsertReport.RHRPTNid#">
                                                and a.RHCRPTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAt(RepCols.cols[i],1,':')#">)
                    <cfif arrayLen(RepCols.cols) neq i>
                        union
                    </cfif>
                </cfloop>
            </cfquery>

            
        </cfif> 
    </cftransaction>
</cfloop>



<cffunction name="getInfoRep" returntype="struct">
    <cfargument name="enc" type="string" required="true">

    <cfset x=structNew()>
    <cfset x.cols=arrayNew(1)>

    <cfswitch expression="#arguments.enc#">
        <cfcase value="DATSAL">
            <cfset x.enc='Reporte DATSAL'>
            <cfset arrayAppend(x.cols,'SalarioBruto:Salario bruto (Salario base incluido)')> 
            <cfset arrayAppend(x.cols,'HorasExtra:Horas extra')> 
            <cfset arrayAppend(x.cols,'Incapacidades:Incapacidades')> 
            <cfset arrayAppend(x.cols,'CarreraProfe:Carrera profesional')> 
            <cfset arrayAppend(x.cols,'Guardias:Guardias')> 
            <cfset arrayAppend(x.cols,'DedicacionExc:Dedicación Exclusiva')>
        </cfcase>
        <cfcase value="ASOCT">
            <cfset x.enc='Deducciones Asociación Solidarista'>
            <cfset arrayAppend(x.cols,'AHORD:Ahorro Ordinario')>
            <cfset arrayAppend(x.cols,'AHORVAC:Ahorro Vacacional')>
            <cfset arrayAppend(x.cols,'ASOCT:Reporte de Aportes y Deducciones Asociacion')>
            <cfset arrayAppend(x.cols,'CXC:Cuenta .x.Cobrar (C x C)')>
            <cfset arrayAppend(x.cols,'PREST:Préstamos')>    
        </cfcase>
        <cfcase value="AUXPV">
            <cfset x.enc='Auxiliar de provisión de vacaciones'>
            <cfset arrayAppend(x.cols,'MPROV:Monto provisionado')>
            <cfset arrayAppend(x.cols,'VPAGA:Vacaciones pagadas')>
        </cfcase>
        <cfcase value="CERT">
            <cfset x.enc='Certificaciones'>
            <cfset arrayAppend(x.cols,'ASOC:Asociación Solidarista')>
            <cfset arrayAppend(x.cols,'CCSSE:Cargas Sociales Empleado')>
            <cfset arrayAppend(x.cols,'COM:Comisiones')>
            <cfset arrayAppend(x.cols,'EMB:Embargo')>
            <cfset arrayAppend(x.cols,'IncNO:Incidencias que No afectan')>
            <cfset arrayAppend(x.cols,'PEN:Pensión Alimenticia')>
        </cfcase>
        <cfcase value="CTI">
            <cfset x.enc='RCertificado de Trabajo IGSS'>
            <cfset arrayAppend(x.cols,'DEDUCADIC:Deducciones Adicionales')>
            <cfset arrayAppend(x.cols,'SALEXTRA:Salario Extra')>
            <cfset arrayAppend(x.cols,'SALORDINARIO:Salario Ordinario')>
        </cfcase>
        <cfcase value="DEDAS">
            <cfset x.enc='Deducciones Asociación Coopelesca'>
            <cfset arrayAppend(x.cols,'DEDUC:Deducciones de asociación Coopelesca')>
        </cfcase>
        <cfcase value="DHC">
            <cfset x.enc='Reporte Planilla DHC'>
            <cfset arrayAppend(x.cols,'AJ:Ajustes (Adjustments)')>
            <cfset arrayAppend(x.cols,'CO:Comisión')>
            <cfset arrayAppend(x.cols,'CS:Cargas Sociales')>
            <cfset arrayAppend(x.cols,'DE:Deducciones Empleado (Employed Advance)')>
            <cfset arrayAppend(x.cols,'DN:Día Nacional (National Day)')>
            <cfset arrayAppend(x.cols,'EE:Educación Empleado')>
            <cfset arrayAppend(x.cols,'HD:Horas Domingo (Hours Sunday)')>
            <cfset arrayAppend(x.cols,'OT:Tiempo Extra (Overtime)')>
            <cfset arrayAppend(x.cols,'SSE:Seguro Social Empleado (Employed Social Security)')>
            <cfset arrayAppend(x.cols,'VA:Vacaciones (Vacactions)')>
            <cfset arrayAppend(x.cols,'XIII:XIII')>
            <cfset arrayAppend(x.cols,'alala:Total de Horas Regulares (Total Regular Hours)')>
        </cfcase>
        <cfcase value="Escol">
            <cfset x.enc='Salario Escolar'>
            <cfset arrayAppend(x.cols,'MontoReb:MontoReb')>
        </cfcase>
        <cfcase value="GLRB">
            <cfset x.enc='Declaración Renta GT (Renta Bruta)'>
            <cfset arrayAppend(x.cols,'Boni37:Bonificacion Dto 37-2001')>
            <cfset arrayAppend(x.cols,'Boni78:Bonificación Dto 78-89')>
            <cfset arrayAppend(x.cols,'BonoAgu:Bono 14 y Aguinaldo')>
            <cfset arrayAppend(x.cols,'Comisiones:Comisiones')>
            <cfset arrayAppend(x.cols,'E1:Renta Neta Ex Patrono1')>
            <cfset arrayAppend(x.cols,'E2:Renta Neta Ex Patrono2')>
            <cfset arrayAppend(x.cols,'E3:Renta Neta Ex Patrono3')>
            <cfset arrayAppend(x.cols,'OP1:Renta Neta Otro Patrono1')>
            <cfset arrayAppend(x.cols,'OP2:Renta Neta Otro Patrono2')>
            <cfset arrayAppend(x.cols,'OP3:Renta Neta Otro Patrono3')>
            <cfset arrayAppend(x.cols,'SalarioBruto:Salario Bruto')>
        </cfcase>
        <cfcase value="GLRD">
            <cfset x.enc='Declaración Renta GT (Deducciones)'>
            <cfset arrayAppend(x.cols,'BonoAGui:Bono y Aguinaldo')>
            <cfset arrayAppend(x.cols,'Cuotas:Cuotas IGSS')>
            <cfset arrayAppend(x.cols,'DeducPer:Deducciones Personales')>
            <cfset arrayAppend(x.cols,'Pension:Valor de cuotas por penciones alimenticias')>
            <cfset arrayAppend(x.cols,'gastosM:Gastos Médicos')>
            <cfset arrayAppend(x.cols,'otros:Otros gastos')>
        </cfcase>
        <cfcase value="INC">
            <cfset x.enc='Pago de Planilla (INC.)'>
            <cfset arrayAppend(x.cols,'Ajustes:Monto de  Incidencias que determinaran la Columnas de Adjustments, Excluyendo al')>
            <cfset arrayAppend(x.cols,'Comisiones:Monto de  las Incidencias que pagan Comisiones')>
            <cfset arrayAppend(x.cols,'Deducciones:Monto de  Deducciones')>
            <cfset arrayAppend(x.cols,'Deducciones1:Monto de  Incidencias que determinaran la Columnas de Adjustments, Excluyendo al')>
            <cfset arrayAppend(x.cols,'RebajoSA:Monto de  Incidencia SA (utilizada para el Traslado de Incidencias entre Empresa')>
            <cfset arrayAppend(x.cols,'SalaryVac:Monto Vacaciones x Salario Fijo')>
            <cfset arrayAppend(x.cols,'Salary_Holiday:Monto de  Feriado con el Monto Pagado por la Incidencia')>
            <cfset arrayAppend(x.cols,'THorasOrd:Horas a quienes se les paga por Hora')>
            <cfset arrayAppend(x.cols,'TotalSalHor:Monto pagado por Horas Trabajadas')>
            <cfset arrayAppend(x.cols,'Vacaciones:Monto de  las Incidencias que pagan Vacaciones')>
            <cfset arrayAppend(x.cols,'Vacaciones2:Monto de  las Incidencias que pagan Vacaciones x Salario Fijo')>
        </cfcase>
        <cfcase value="INFON">
            <cfset x.enc='Calculo de Deduccion de Infonavit'>
            <cfset arrayAppend(x.cols,'01:Deduccion de Infonavit')>
        </cfcase>
        <cfcase value="LS">
            <cfset x.enc='Reporte Libro de Salarios'>
            <cfset arrayAppend(x.cols,'Aguinaldo:Monto pagado por aguinaldo, adelantos y rebajos del mismo')>
            <cfset arrayAppend(x.cols,'Asoc:MONTO PAGADO POR AGUINALDO, ADELANTOS Y REBAJOS DE modifica')>
            <cfset arrayAppend(x.cols,'BanTrab:Monto que se descuenta por concepto de Banco de los trabajadores')>
            <cfset arrayAppend(x.cols,'Bonifica:MONTO PAGADO POR CONCEPTO DE PAGO DE BONIFICACION')>
            <cfset arrayAppend(x.cols,'Comisiones:Monto pagado por incidencia de Comision')>
            <cfset arrayAppend(x.cols,'HorasExtraA:Monto Pagado por horas extra A')>
            <cfset arrayAppend(x.cols,'HorasExtraB:Monto Pagado por horas extra B')>
            <cfset arrayAppend(x.cols,'ISR:Monto que se retuvo por renta y descuentos de renta pendiente')>
            <cfset arrayAppend(x.cols,'Indemniza:Lo pagado por indemnizacion en la liquidacion')>
            <cfset arrayAppend(x.cols,'Ordinario:MONTO PAGADO POR EL CONCEPTO DE SALARIO BASE MAS INCIDENCIAS')>
            <cfset arrayAppend(x.cols,'Otros:Lo pagado por bono 14, bonificacion target y los adelantos y rebajos de bono 14')>
            <cfset arrayAppend(x.cols,'OtrosDesc:Todos los demás descuentos no aplicados')>
            <cfset arrayAppend(x.cols,'Septimo:MONTO PAGADO POR CONCEPTO DE SEPTIMO')>
            <cfset arrayAppend(x.cols,'Sind:Monto pagado por concepto de sindicato')>
            <cfset arrayAppend(x.cols,'Vacaciones:Monto pagado por el concepto de pago de vacaciones o conceptos de finiquito')>
        </cfcase>
        <cfcase value="LSCR">
            <cfset x.enc='Libro de salarios (CR)'>
            <cfset arrayAppend(x.cols,'Ajustes:Ajustes')>
            <cfset arrayAppend(x.cols,'Bonificacion:Bonificacion')>
            <cfset arrayAppend(x.cols,'Comisiones:Comisiones')>
            <cfset arrayAppend(x.cols,'Ordinario:Ordinario')>
            <cfset arrayAppend(x.cols,'Otros:Otros')>
            <cfset arrayAppend(x.cols,'Prohibicion:Prohibicion')>
        </cfcase>
        <cfcase value="MT">
            <cfset x.enc='Ministerio de Trabajo'>
            <cfset arrayAppend(x.cols,'Aguinaldo:MONTO PAGADO POR AGUINALDO Y BONO 14')>
            <cfset arrayAppend(x.cols,'OtrosPagos:MONTO RECIBIDO POR OTRAS INCIDENCIAS DE PAGO, INDEMNIZACION,COMISION,VACACIONES,')>
        </cfcase>
        <cfcase value="MX001">
            <cfset x.enc='Reporte de Salario Detallado'>
            <cfset arrayAppend(x.cols,'ValesDespens:Vales Despensa')>    
        </cfcase>
        <cfcase value="MX002">
            <cfset x.enc='Reporte Detalle de Nomina'>
            <cfset arrayAppend(x.cols,'AguiPag:Aguinaldo Pagado')>
            <cfset arrayAppend(x.cols,'AntiNomin:Anticipo de Nomina')>
            <cfset arrayAppend(x.cols,'AyuSindical:Ayuda Sindical')>
            <cfset arrayAppend(x.cols,'BonEmpleado:Bono Empleado')>
            <cfset arrayAppend(x.cols,'CargaIMSS:IMSS')>
            <cfset arrayAppend(x.cols,'Comision:Comision sobre Ventas')>
            <cfset arrayAppend(x.cols,'CuoSindical:Cuota Sindical')>
            <cfset arrayAppend(x.cols,'DescEquSeg:Dscto Equipo de Seguridad')>
            <cfset arrayAppend(x.cols,'DescHerTrab:Dscto Herramientas de Trab')>
            <cfset arrayAppend(x.cols,'DescLabo:Descanso Laborado')>
            <cfset arrayAppend(x.cols,'DevDtoHer:Devol. Dscto Herramientas')>
            <cfset arrayAppend(x.cols,'DevInfona:Devolucion Credito Infonavit')>
            <cfset arrayAppend(x.cols,'FestLab:Festivo Laboral')>
            <cfset arrayAppend(x.cols,'HExDobleE:Horas Extras Dobles Excentas')>
            <cfset arrayAppend(x.cols,'HExDobleG:Horas Extras Dobles Gravables')>
            <cfset arrayAppend(x.cols,'HExTriple:Horas Extras Triples')>
            <cfset arrayAppend(x.cols,'Indemnisacio:Incidencia Indemnisacion')>
            <cfset arrayAppend(x.cols,'InfonaSDI:Credito Infonavit Porcentaje SDI')>
            <cfset arrayAppend(x.cols,'InfonaSMG:Credito Infonavit VSM')>
            <cfset arrayAppend(x.cols,'OtraPrest:Otras Prestaciones')>
            <cfset arrayAppend(x.cols,'OtrasDeduc:Otras Deducciones')>
            <cfset arrayAppend(x.cols,'PTUDias:PTU en Dias')>
            <cfset arrayAppend(x.cols,'PTUImp:PTU Importe')>
            <cfset arrayAppend(x.cols,'PagAguiExc:Pago Aguinaldo Excento')>
            <cfset arrayAppend(x.cols,'PagAguiGrv:Pago Aguinaldo Gravable')>
            <cfset arrayAppend(x.cols,'PensionAlime:Pension Alimenticia')>
            <cfset arrayAppend(x.cols,'PieMaquina:Pie de Maquina')>
            <cfset arrayAppend(x.cols,'PreAsist:Premios de Asistencia')>
            <cfset arrayAppend(x.cols,'PrePunt:Premios de Puntualidad')>
            <cfset arrayAppend(x.cols,'PrestPerso:Prestamo Pesonal')>
            <cfset arrayAppend(x.cols,'PriAntigueda:Prima de Antiguedad')>
            <cfset arrayAppend(x.cols,'PriDomExc:Prima Dominical Excenta')>
            <cfset arrayAppend(x.cols,'PriDomGrv:Prima Dominical Gravable')>
            <cfset arrayAppend(x.cols,'PriVacExc:Prima Vacacional Excenta')>
            <cfset arrayAppend(x.cols,'PriVacGrv:Prima Vacacional Gravable')>
            <cfset arrayAppend(x.cols,'ProPrVacExc:Propocional Prima Vacaciones Excenta')>
            <cfset arrayAppend(x.cols,'ProPrVacGrv:Propocional Prima Vacaciones Gravable')>
            <cfset arrayAppend(x.cols,'ProVacFin:Proporcion Vacaciones Finiquito')>
            <cfset arrayAppend(x.cols,'PropAguiExc:Propocional Aguinaldo Excento')>
            <cfset arrayAppend(x.cols,'PropAguiGrv:Propocional Aguinaldo Gravado')>
            <cfset arrayAppend(x.cols,'PropVacExc:Propocional Vacaciones Excenta')>
            <cfset arrayAppend(x.cols,'PropVacGrv:Propocional Vacaciones Gravable')>
            <cfset arrayAppend(x.cols,'RetDiaFest:Retroactivo Dia Festivo')>
            <cfset arrayAppend(x.cols,'RetIMSS:Retroactivo IMSS')>
            <cfset arrayAppend(x.cols,'RetPieMaq:Retroactivo Pie de Maquina')>
            <cfset arrayAppend(x.cols,'RetPreAgui:Retroactivo Aguinaldo')>
            <cfset arrayAppend(x.cols,'RetPreAsist:Retroactivo Premio de Asistencia')>
            <cfset arrayAppend(x.cols,'RetPrePunt:Retroactivo Premio de Puntualidad')>
            <cfset arrayAppend(x.cols,'RetPrimDom:Retroactivo P.Dominical')>
            <cfset arrayAppend(x.cols,'RetPrimVac:Retroactivo Prima Vac')>
            <cfset arrayAppend(x.cols,'RetReteSind:Retroactivo Retencion Sindical')>
            <cfset arrayAppend(x.cols,'RetSal:Retroactivo Salario')>
            <cfset arrayAppend(x.cols,'RetTED:Retroactivo TED')>
            <cfset arrayAppend(x.cols,'RetTET:Retroactivo TET')>
            <cfset arrayAppend(x.cols,'RetVac:Retroactivo Vacaciones')>
            <cfset arrayAppend(x.cols,'RetValDesp:Retroactivo Vales Despensa')>
            <cfset arrayAppend(x.cols,'Retardo:Retardo')>
            <cfset arrayAppend(x.cols,'SalAntic:Salida Anticipada')>
            <cfset arrayAppend(x.cols,'Separacion:Incidencia Separacion')>
            <cfset arrayAppend(x.cols,'SubSalario:Subsidio al Salario')>
            <cfset arrayAppend(x.cols,'Vac0910:Vacaciones 2009-2010')>
            <cfset arrayAppend(x.cols,'Vac1011:Vacaciones 2010-2011')>
            <cfset arrayAppend(x.cols,'Vac1112:Vacaciones 2011-12')>
            <cfset arrayAppend(x.cols,'ValesDespens:Vales Despensa')>
        </cfcase>
        <cfcase value="PR001">
            <cfset x.enc='Parametros DBC calculo IMSS Vacaciones'>
            <cfset arrayAppend(x.cols,'IVacaciones:Incidencia Vacaciones')>
        </cfcase>
        <cfcase value="PR002">
            <cfset x.enc='Parametro Incidencia Pago de Vacaciones'>
            <cfset arrayAppend(x.cols,'IncVac:Incidencia Pago Vacaciones')>
        </cfcase>
        <cfcase value="RENTA">
            <cfset x.enc='Reporte de Renta (DHC)'>
            <cfset arrayAppend(x.cols,'SR:Salarios Recibidos')>
            <cfset arrayAppend(x.cols,'SRXIII:Salarios recibidos por XIII mes')>
        </cfcase>
        <cfcase value="REPRE">
            <cfset x.enc='Reporte de Presupuesto'>
            <cfset arrayAppend(x.cols,'ANTDAD:Antigüedad')>
            <cfset arrayAppend(x.cols,'DEDICEXCL:Dedicación exclusiva')>
            <cfset arrayAppend(x.cols,'OTROSINCENT:Otros incentivos')>
            <cfset arrayAppend(x.cols,'PROHB:Prohibición')>
            <cfset arrayAppend(x.cols,'SEXNIO:Sexenio')>
        </cfcase>
        <cfcase value="RMI">
            <cfset x.enc='Reporte Mensual del IGSS'>
            <cfset arrayAppend(x.cols,'SALEXTRA:Salario Extra')>
            <cfset arrayAppend(x.cols,'SALORDINARIO:Salario Ordinario')>
        </cfcase>
        <cfcase value="RNP">
            <cfset x.enc='Reporte Nómina y Planilla'>
            <cfset arrayAppend(x.cols,'ANTICIPOS:Lo pagado por anticipo quincenal')>
            <cfset arrayAppend(x.cols,'ASOC:Ahorro y Prestamo')>
            <cfset arrayAppend(x.cols,'BANTRAB:Descuenta Banco Trabajadores')>
            <cfset arrayAppend(x.cols,'BONIFICACION:Bonificación Q250 y Bonificación Fija')>
            <cfset arrayAppend(x.cols,'BP:Banco Popula')>
            <cfset arrayAppend(x.cols,'COMISION:PAGO POR CONCEPTO DE COMISION')>
            <cfset arrayAppend(x.cols,'EXTRAD:HORAS EXTRA D')>
            <cfset arrayAppend(x.cols,'EXTRAS:HORAS EXTRAS A')>
            <cfset arrayAppend(x.cols,'HORASEXTRAD:CANTIDAD DE HORAS EXTRA D')>
            <cfset arrayAppend(x.cols,'HORASEXTRAS:CANTIDAD DE HORAS EXTRA S')>
            <cfset arrayAppend(x.cols,'ISR:PAGO POR ISR')>
            <cfset arrayAppend(x.cols,'ORDINARIO:SueldoBase')>
            <cfset arrayAppend(x.cols,'OTROS:Bono 14')>
            <cfset arrayAppend(x.cols,'SEPTIMO:PAGO POR SEPTIMO')>
            <cfset arrayAppend(x.cols,'VACACIONES:Lo que se pague por finiquito de vacaciones')>
            <cfset arrayAppend(x.cols,'VARIOSDESC:Cualquier tipo de descuento que no se visualice por aparte')>
            <cfset arrayAppend(x.cols,'VARIOSINC:Pasajes o Viáticos')>
            <cfset arrayAppend(x.cols,'VENTASTIENDA:Descuento de Electrodomésticos')>
        </cfcase>
        <cfcase value="SA">
            <cfset x.enc='Pago de Planilla (S.A.)'>
            <cfset arrayAppend(x.cols,'Embargo:EMBARGO')>
            <cfset arrayAppend(x.cols,'OtrasDed:COLUMNA DEDUCCIONES (EXCEPTO EMBARGO)')>
            <cfset arrayAppend(x.cols,'RebIncap:COLUMNA SUMA TODO LO REBAJADO POR MATERNIDAD E INCAPACIDAD')>
            <cfset arrayAppend(x.cols,'SalIncap:COLUMNA SUMA LOS MONTOS POR INCAPACIDAD O MATERNIDAD QUE SE DEBEN REBAJAR')>
            <cfset arrayAppend(x.cols,'SalIncidencias:COLUMNA SALARIO NETO PARTE B SE SUMARIZA AL FINAL A LA PARTE A')>
            <cfset arrayAppend(x.cols,'SubVacaciones:COLUMNA VACACIONES')>
        </cfcase>
        <cfcase value="SSP">
            <cfset x.enc='Reporte de seguro social (Panama)'>
            <cfset arrayAppend(x.cols,'DTM:Decimo T. Mes')>
            <cfset arrayAppend(x.cols,'OT:Otros Ingresos')>
            <cfset arrayAppend(x.cols,'SAL:Salarios recibidos')>
        </cfcase>
        <cfcase value="CERTRRHH">
            <cfset x.enc='Parametros utizados para las certificaciones de RH'>
            <cfset arrayAppend(x.cols,'CSiLey:Cargas a rebajar de ley')>
            <cfset arrayAppend(x.cols,'CNoLey:Cargas a rebajar que no son de ley ')>
            <cfset arrayAppend(x.cols,'EMBARGO:Deduccion utilizada para el cobro de Embargo ')>
            <cfset arrayAppend(x.cols,'PENSION:Deduccion utilizada para el cobro de Pensión ')>
        </cfcase>

        <cfcase value="RepGenPlan">
            <cfset x.enc='Configuracion Reporte General de Planilla (SUTEL)'>
            <cfset arrayAppend(x.cols,'Afar:Deducción Utilizada para el cobro AFAR')>
            <cfset arrayAppend(x.cols,'Anualidad:Conceptos usuados para el pago de anualidad')>
            <cfset arrayAppend(x.cols,'Asar:Cargas utilizada para la retencion ASAR')>
            <cfset arrayAppend(x.cols,'AsarClub:Deducción Utilizada para el cobro ASAR - Club de Ahorro')>
            <cfset arrayAppend(x.cols,'AsarConting:Deducción Utilizada para el cobro ASAR - Fondo Contingencia')>
            <cfset arrayAppend(x.cols,'AsarEspec:Deducción Utilizada para el cobro ASAR - Ahorro Especial')>
            <cfset arrayAppend(x.cols,'AsarExtra:Deducción Utilizada para el cobro ASAR - Ahorro Extraordinario')>
            <cfset arrayAppend(x.cols,'AsarNav:Deducción Utilizada para el cobro ASAR - Ahorro Navideño')>
            <cfset arrayAppend(x.cols,'AsarOtros:Deducción Utilizada para el cobro ASAR - Otros')>
            <cfset arrayAppend(x.cols,'Asiar:Deducción Utilizada para el cobro ASIAR')>
            <cfset arrayAppend(x.cols,'BancPopular:Deducción Utilizada para el cobros Banco Popular')>
            <cfset arrayAppend(x.cols,'BnVital:Deducción Utilizada para el cobro BN-Vital OPC')>
            <cfset arrayAppend(x.cols,'CargaCCSS:Cargas utilizada para la retencion CCSS')>
            <cfset arrayAppend(x.cols,'CarreraProf:Conceptos usuados para el pago de Carrera Profesional')>
            <cfset arrayAppend(x.cols,'Colegios:Deducción Utilizada para el cobro Colegios (Incorporataciones)')>
            <cfset arrayAppend(x.cols,'ComiteSocial:Deducción Utilizada para el cobro de Comite Social Sutel')>
            <cfset arrayAppend(x.cols,'Coopenae:Deducción Utilizada para el cobro Coopenae')>
            <cfset arrayAppend(x.cols,'CoopeServ:Deducción Utilizada para el cobro CoopeServidores')>
            <cfset arrayAppend(x.cols,'CoopeSNE:Deducción Utilizada para el cobro CoopeSNE')>
            <cfset arrayAppend(x.cols,'DiasVac:Conceptos usados para pago vacaciones')>
            <cfset arrayAppend(x.cols,'Embargo:Deducción Utilizada para el cobro Embargos')>
            <cfset arrayAppend(x.cols,'FondoSolid:Deducción Utilizada para el cobro Fondo Solidario')>
            <cfset arrayAppend(x.cols,'Ins:Deducción Utilizada para el cobro INS')>
            <cfset arrayAppend(x.cols,'PermDietOtro:Conceptos usados para pago Permisos, dietas, otros')>
            <cfset arrayAppend(x.cols,'PlusVacac:Conceptos usuados para el pago de Plus de Vacaciones')>
            <cfset arrayAppend(x.cols,'Prohibicion:Conceptos usados para pago Prohibicion')>
            <cfset arrayAppend(x.cols,'RebDieta:Conceptos usados para Rebajo Monto  Dieta en Total Devengado')>
            <cfset arrayAppend(x.cols,'RentaDieta:Deducción Utilizada para el Cobro de Renta de Dieta')>
            <cfset arrayAppend(x.cols,'Roblealto:Deducción Utilizada para el cobro Roble Alto')>
            <cfset arrayAppend(x.cols,'SubsIncap:Conceptos usuados para el pago de Subsidio Incapacidad')>
        </cfcase>

        <cfcase value="FundaTec">
            <cfset x.enc='Configuracion Para Certificaciones RH - FundaTec'>
            <cfset arrayAppend(x.cols,'CNoLey: Cargas / Deducción Utilizadas para las retenciones de No Ley')>
            <cfset arrayAppend(x.cols,'CSiLey: Cargas / Deducción Utilizadas para las retenciones de Ley')>
            <cfset arrayAppend(x.cols,'Embargo: Deduccion Utilizada para el rebajo de Embargos')>
            <cfset arrayAppend(x.cols,'Escolar: Carga / Deducción Utilizada para la retencion de Salario Escolar')>
            <cfset arrayAppend(x.cols,'Extras: Conceptos para el pago de Horas Extras')>
            <cfset arrayAppend(x.cols,'RSalBruto: Incidencias que no aplican para la suma del salario bruto')>
            <cfset arrayAppend(x.cols,'Prestamos: Deduccion Utilizada para el rebajo de Prestamos')>
            <cfset arrayAppend(x.cols,'Ahorro: Carga / Deduccion Utilizada para la retencion Ahorros')>
            <cfset arrayAppend(x.cols,'Poliza: Carga / Deduccion Utilizada para la retencion Polizas')>
            <cfset arrayAppend(x.cols,'Uniformes: Deduccion Utilizada para la retencion pago Uniformes')>
        </cfcase>
    </cfswitch>

    <cfreturn x>
</cffunction>

<cffunction name="addRep">
    <cfargument name="cod" type="string">
    <cfargument name="proceso" type="string">
    <cfset x=structNew()>
    <cfset x.cod=arguments.cod>
    <cfset x.proceso=arguments.proceso>
    <cfset arrayAppend(ArrayReportes,x)>
</cffunction>