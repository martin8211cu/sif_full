<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_ReporteMensualAlIGSS" default="Reporte Mensual al IGSS" returnvariable="LB_ReporteMensualAlIGSS" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_NoHayDatosRelacionados" default="No hay datos relacionados" returnvariable="LB_NoHayDatosRelacionados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Periodo" default="Periodo" returnvariable="LB_Periodo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Mes" default="Mes" returnvariable="LB_Mes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Nomina" default="N&oacute;mina" returnvariable="LB_Nomina" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<!--- CREACION DEL RANGO DE FECHAS --->
<cfset Lvar_FechaInicio = CreateDate(#url.anno#,#url.Mes#,1)>
<cfset Lvar_FechaFin = DateAdd('d',-1,DateAdd('m',1,Lvar_FechaInicio))>

	<!--- TABLA TEMPORAL PARA CALENDARIOS DE PAGO --->
	<cf_dbtemp name="calendarioMT" returnvariable="calendarioMT">
		<cf_dbtempcol name="RCNid"      type="int"        mandatory="yes">
		<cf_dbtempcol name="RCdesde"    type="datetime"   mandatory="no">
		<cf_dbtempcol name="RChasta"    type="datetime"   mandatory="no">
		<cf_dbtempcol name="Tcodigo"    type="char(5)"    mandatory="no">
		<cf_dbtempcol name="FechaPago"  type="datetime"   mandatory="no">
		<cf_dbtempkey cols="RCNid">
	</cf_dbtemp>

	<!--- TABLA TEMPORAL PARA LOS EMPLEADOS ---> 
    <cf_dbtemp name="salidaMensualIGSS" returnvariable="salidaIGSS">
    	<cf_dbtempcol name="DEid"   		type="numeric"     	mandatory="yes">
        <cf_dbtempcol name="NoAfiliacion"	type="varchar(30)"  mandatory="no">
        <cf_dbtempcol name="Nombre"   		type="varchar(100)" mandatory="no">
		<cf_dbtempcol name="SalarioOrd"		type="money"     	mandatory="no">
		<cf_dbtempcol name="SalarioExtra"	type="money"     	mandatory="no">
        <cf_dbtempcol name="FechaObs"		type="date"			mandatory="no">
        <cf_dbtempcol name="Obs"			type="varchar(255)"	mandatory="no">
    </cf_dbtemp>

    <cfset fecha = Now()>
    <cfset fecha1_temp = createdate( 6100, 01, 01 )>
   
   	<!---  SE LLENA LA TABLA DE CALENARIOS  --->
    <cfquery datasource="#session.dsn#">	
		insert into #calendarioMT#(RCNid, RCdesde, RChasta, Tcodigo, FechaPago)
		select CPid, CPdesde, CPhasta, Tcodigo, CPfpago
		from CalendarioPagos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		  and CPperiodo = #trim(url.anno)#
          and CPmes = #trim(url.mes)#
		  <cfif isdefined('url.Tcodigo') and len(trim(url.Tcodigo))>
		  		and Tcodigo ='#url.Tcodigo#'
		  </cfif>
		  and CPnocargasley = 0
		  and CPtipo <> 2
	</cfquery>
	
    <!---  SE LLENA LA TABLA CON LOS EMPLEADOS QUE ESTAN EN LOS CALENDARIOS DE PAGOS DEL PERIODO--->
    <cfquery name="rsEmpleados" datasource="#session.DSN#">
    	insert into #salidaIGSS#(DEid,NoAfiliacion,Nombre)
        	select distinct pe.DEid,
            	DEdato1,
            	{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})}
            from #calendarioMT# cp
            inner join HPagosEmpleado pe
                on pe.RCNid = cp.RCNid
            inner join DatosEmpleado de
                on pe.DEid = de.DEid
			inner join CargasEmpleado ce
				on ce.DEid = de.DEid
			inner join DCargas dc
				on dc.DClinea = ce.DClinea
			inner join ECargas ec
				on ec.ECid = dc.ECid
   		where ec.ECauto = 1
		  and dc.DCprovision = 0
		<cfif isdefined('url.Tipo') and url.Tipo EQ 'R'>
		  and CEvaloremp is not null
		  and CEvalorpat is not null
		<cfelseif isdefined('url.Tipo') and url.Tipo EQ 'U'>
		  and CEvaloremp is null
		  and CEvalorpat is null
		</cfif>
    </cfquery>

	<!--- SALARIO ORDINARIO --->
	<!--- SALARIO BRUTO --->
     <cfquery name="rsSalarioOrd" datasource="#session.DSN#">
    	update #salidaIGSS#
        set SalarioOrd = coalesce((select sum(SEsalariobruto)
        							 from #calendarioMT# cp
									 inner join HSalarioEmpleado hse
									 	on hse.RCNid = cp.RCNid
                                     where hse.DEid = #salidaIGSS#.DEid
        							),0.00)
   	</cfquery>
	<!--- LO DEFINIDO EN LA CONFIGURACIÓN DEL REPORTE --->
	<cfquery name="rsSalarioOrd" datasource="#session.DSN#">
    	update #salidaIGSS#
        set SalarioOrd = SalarioOrd + (select coalesce(sum(ICmontores),0.00)
                            from #calendarioMT# cp
                            inner join HIncidenciasCalculo hic
                            	on hic.RCNid = cp.RCNid
                            where DEid = #salidaIGSS#.DEid
							  and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'SALORDINARIO'
											where c.RHRPTNcodigo = 'RMI'
											  and c.Ecodigo = #session.Ecodigo#))
    </cfquery>
	<!--- SALARIO EXTRA --->
	<cfquery name="rsSalarioExtra" datasource="#session.DSN#">
    	update #salidaIGSS#
        set SalarioExtra = (select coalesce(sum(ICmontores),0.00)
                            from #calendarioMT# cp
                            inner join HIncidenciasCalculo hic
                            	on hic.RCNid = cp.RCNid
                            where DEid = #salidaIGSS#.DEid
							  and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'SALEXTRA'
											where c.RHRPTNcodigo = 'RMI'
											  and c.Ecodigo = #session.Ecodigo#))
	</cfquery>
	
    <!--- SI UN EMPLEADO HA SIDO CESADO EN ESTE PERIODO SE AGREGA AL FECHA Y OBSEVACIONES--->
    <cfquery name="rsSalarioOrd" datasource="#session.DSN#">
    	update #salidaIGSS#
        set FechaObs = (select max(DLfvigencia)
                        from DLaboralesEmpleado le
                            inner join RHTipoAccion ta
                            on ta.Ecodigo = le.Ecodigo
                            and ta.RHTid = le.RHTid
                            and ta.RHTcomportam in(1,2)
                        where le.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                          and le.DLfvigencia  between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
                              				and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
                          and le.DEid = #salidaIGSS#.DEid
        
        )
    </cfquery>
	<!--- SI UN EMPLEADO HA SIDO CESADO EN ESTE PERIODO SE AGREGA AL FECHA Y OBSEVACIONES--->
    <cfquery name="rsSalarioOrd" datasource="#session.DSN#">
    	update #salidaIGSS#
        set Obs = (select case RHTcomportam when 1 then 'A' else 'B' end
                        from DLaboralesEmpleado le
                            inner join RHTipoAccion ta
                            on ta.Ecodigo = le.Ecodigo
                            and ta.RHTid = le.RHTid
                            and ta.RHTcomportam in(1,2)
                        where le.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                          and le.DLfvigencia = #salidaIGSS#.FechaObs
                          and le.DEid = #salidaIGSS#.DEid
        )
        
    </cfquery>
    <cfquery name="rsReporte" datasource="#session.DSN#">
    	select *
        from #salidaIGSS#
		order by NoAfiliacion
    </cfquery>

	<cfquery name="rsTotales" datasource="#session.DSN#">
		select sum(SalarioOrd) as Ordinario,sum(SalarioExtra) Extra, sum(SalarioOrd) + sum(SalarioExtra) Total
		from #salidaIGSS#
	</cfquery>
    <!--- FIN DE RECOLECCION DE DATOS DEL REPORTE --->
    <!--- Busca el nombre de la Empresa --->
    <cfquery name="rsEmpresa" datasource="#session.DSN#">
        select Edescripcion
        from Empresas
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    </cfquery>
     <!--- NUMERO PATRONAL --->
    <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="300" default="" returnvariable="NoPatronal"/>
    <cfif Not Len(NoPatronal)>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_No_se_ha_definido_el_numero_patronal"
			Default="Error!, No se ha definido el n&uacute;mero patronal. Proceso Cancelado!!"
			returnvariable="LB_No_se_ha_definido_el_numero_patronal"/> 
	
		<cf_throw message="#LB_No_se_ha_definido_el_numero_patronal#" errorCode="1020">
	</cfif>
	<cfquery name="rsFechas" datasource="#session.DSN#">
		select min(RCdesde) as Fdesde, max(RChasta) as Fhasta
		from #calendarioMT#
	</cfquery>
    
    <style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.titulo_empresa2 {
		font-size:18px;
		font-weight:bold;
		text-align:center;}
	.titulo_empresa3 {
		font-size:18px;
		font-weight:bold;
		text-align:right;}
	.listaCorte {
		font-size:10px;
		font-weight:bold;
		background-color: #F4F4F4;
		text-align:left;}
	.listaCorte3 {
		font-size:10px;
		font-weight:bold;
		background-color:  #E8E8E8;
		text-align:left;}
	.listaCorte2 {
		font-size:10px;
		font-weight:bold;
		background-color: #D8D8D8;
		text-align:left;}
	.listaCorte1 {
		font-size:14px;
		font-weight:bold;
		background-color: #CCCCCC;
		text-align:left;}
	.total {
		font-size:14px;
		font-weight:bold;
		text-align:right;}

	.detalle {
		font-size:14px;
		text-align:left;}
	.detaller {
		font-size:14px;
		text-align:right;}
	.detallec {
		font-size:14px;
		text-align:center;}	
	.mensaje {
		font-size:14px;
		text-align:center;}
	.paginacion {
		font-size:14px;
		text-align:center;}
	</style>
	<cfif rsReporte.RecordCount>
		<cfif isdefined('url.Tipo') and url.Tipo EQ 'R'>
			<cfset Lvar_PorcIGSS = 0.0667>
			<cfset Lvar_PorcEmpIGSS = 0.0283>
		<cfelseif isdefined('url.Tipo') and url.Tipo EQ 'U'>
			<cfset Lvar_PorcIGSS = 0.1067>
			<cfset Lvar_PorcEmpIGSS = 0.0483>
		</cfif>
        <table width="90%" border="0" align="center" cellpadding="2" cellspacing="0">
            <cfoutput>
            <tr><td align="center" class="titulo_empresa2" colspan="7"><strong>#LB_ReporteMensualAlIGSS#</strong></td></tr>
            <tr><td align="center" class="titulo_empresa2" colspan="7"><strong>#LB_Periodo#:&nbsp;#url.Mes#/#url.anno#</strong></td></tr>
            <tr><td align="center" class="titulo_empresa2" colspan="7"><cf_translate key="LB_Del"><strong>Del</strong></cf_translate>:&nbsp;#LSDateFormat(rsFechas.Fdesde,'dd/mm/yyyy')#<cf_translate key="LB_Al"><strong>Al</strong></cf_translate>:&nbsp;#LSDateFormat(rsFechas.Fhasta,'dd/mm/yyyy')#</td></tr>
            <tr><td class="titulo_empresa2" width="50%" colspan="7"><cf_translate key="LB_NoPatronal">No Patronal</cf_translate>:&nbsp;#NoPatronal#&nbsp;<strong>&nbsp;&nbsp;#rsEmpresa.Edescripcion#</strong></td></tr>
            <tr><td colspan="7" class="titulo_empresa3"><strong><cf_translate key="LB_Fecha">Fecha</cf_translate>:&nbsp;#LSDateFormat(fecha,'dd/mm/yyyy')#</strong></td></tr>
			<tr><td colspan="7" ><strong><cf_translate key="LB_Observaciones">Observaciones</cf_translate>:&nbsp;#url.Obsv#</strong></td></tr>
            <tr><td colspan="7">&nbsp;</td></tr>
            </cfoutput>
        
            <tr><td height="1" bgcolor="000000" colspan="7"></td>
            <tr class="listaCorte1"  style="border-bottom: 1px solid black;">
                <td><cf_translate key="LB_No">No</cf_translate></td>
                <td align="left" nowrap><cf_translate key="LB_NoAfiliacion">No Afiliaci&oacute;n</cf_translate></td>
                <td align="left" nowrap><cf_translate key="LB_Nombre">Nombre</cf_translate></td>
                <td align="right" nowrap><cf_translate key="LB_SalarioTotal">Salario Total</cf_translate></td>
                <td align="center" nowrap><cf_translate key="LB_FechaAb">Fecha Ab</cf_translate></td>
                <td align="left" nowrap><cf_translate key="LB_Observaciones">Observaciones</cf_translate></td>
            </tr>
            <tr><td height="1" bgcolor="000000" colspan="7"></td>
            <cfoutput query="rsReporte">
            <tr>
                <td class="detallec">#CurrentRow#</td>
                <td class="detalle">#NoAfiliacion#</td>
                <td class="detalle">#Ucase(Nombre)#</td>
                <td class="detaller">#LSCurrencyFormat(SalarioOrd+SalarioExtra,'none')#</td>
                <td class="detallec">#LSDateFormat(FechaObs,'dd/mm/yyyy')#</td>
                <td class="detalle">#Obs#</td>
            </tr>
            </cfoutput>
			<tr><td style="border-bottom: 1px solid black;" colspan="7">&nbsp;</td>
			<tr><td colspan="7">&nbsp;</td></tr>
			<tr>
				<td colspan="7">
					<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
						<tr>
							<td><cf_translate key="LB_NoDeTrabajadores">No de Trabajadores</cf_translate>:&nbsp;<cfoutput>#rsReporte.RecordCount#</cfoutput></td>
							<td><cf_translate key="LB_SalarioOrdinario">Salario Ordinario</cf_translate>:&nbsp;<cfoutput>#LSCurrencyFormat(rsTotales.Ordinario,'none')#</cfoutput></td>
							<td><cf_translate key="LB_TotalOrdinarioyExtra">Total Ordinario y Extra</cf_translate>:&nbsp;<cfoutput>#LSCurrencyFormat(rsTotales.Total,'none')#</cfoutput></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="7">
					<cfset Lvar_TotalIGSS = (rsTotales.Total*Lvar_PorcIGSS)+(rsTotales.Total*Lvar_PorcEmpIGSS)>
					<cfset Lvar_TotalPat = (rsTotales.Total*Lvar_PorcIGSS) + (rsTotales.Total*0.01) + (rsTotales.Total*0.01)>
					<cfset Lvar_TotalEmp = (rsTotales.Total*Lvar_PorcEmpIGSS)>
					<cfset Lvar_Total = Lvar_TotalPat + Lvar_TotalEmp>
					<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
						<tr>
							<td><cf_translate key="LB_LIQUIDACION">LIQUIDACION</cf_translate></td>
							<td align="right"><cf_translate key="LB_CUOTAPATRONAL">CUOTA PATRONAL</cf_translate></td>
							<td align="right"><cf_translate key="LB_CUOTALABORAL">CUOTA LABORAL</cf_translate></td>
							<td align="right"><cf_translate key="LB_TOTAL">TOTAL</cf_translate></td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td><cf_translate key="LB_IGSS">IGSS</cf_translate>(<cfoutput>#Lvar_PorcIGSS*100#%)</cfoutput></td>
							<td align="right"><cfoutput>#LSCurrencyFormat(rsTotales.Total*Lvar_PorcIGSS,'none')#</cfoutput></td>
							<td align="right"><cfoutput>#LSCurrencyFormat(Lvar_TotalEmp,'none')#</cfoutput></td>
							<td align="right"><cfoutput>#LSCurrencyFormat(Lvar_TotalIGSS,'none')#</cfoutput></td>
						</tr>
						<tr>
							<td><cf_translate key="LB_IRTRA">IRTRA</cf_translate>(1%)</td>
							<td align="right"><cfoutput>#LSCurrencyFormat(rsTotales.Total*0.01,'none')#</cfoutput></td>
							<td>&nbsp;</td>
							<td align="right"><cfoutput>#LSCurrencyFormat(rsTotales.Total*0.01,'none')#</cfoutput></td>
						</tr>
						<tr>
							<td><cf_translate key="LB_INTECAP">INTECAP</cf_translate>(1%)</td>
							<td align="right"><cfoutput>#LSCurrencyFormat(rsTotales.Total*0.01,'none')#</cfoutput></td>
							<td>&nbsp;</td>
							<td align="right"><cfoutput>#LSCurrencyFormat(rsTotales.Total*0.01,'none')#</cfoutput></td>
						</tr>
						<tr><td height="1" bgcolor="000000" colspan="4"></td>
						<tr>
							<td><cf_translate key="LB_TOTAL">TOTAL</cf_translate></td>
							<td align="right"><cfoutput>#LSCurrencyFormat(Lvar_TotalPat,'none')#</cfoutput></td>
							<td align="right"><cfoutput>#LSCurrencyFormat(rsTotales.Total*0.0483,'none')#</cfoutput></td>
							<td align="right"><cfoutput>#LSCurrencyFormat(Lvar_Total,'none')#</cfoutput>&nbsp;</td>
						</tr>
					</table>
				</td>
			</tr>
        </table>
    <cfelse>
    	<table width="800" border="0" align="center" cellpadding="2" cellspacing="0" style="border-color:000000; border-width:thin;">
            <tr><td align="center" class="titulo_empresa2" colspan="6"><strong><cfoutput>#LB_NoHayDatosRelacionados#</cfoutput></strong></td></tr>
        </table>
	</cfif>
