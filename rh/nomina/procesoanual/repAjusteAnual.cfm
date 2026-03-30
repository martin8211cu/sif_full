<!---<cf_dump var = "#url#">--->
<cfif isdefined ("URL.RHAAid") and URL.RHAAid NEQ ''>
	<cfset form.RHAAid = #URL.RHAAid#>
</cfif>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TituloReporte" Default="Reporte Informativo de Ajuste Anual" returnvariable="LB_TituloReporte"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion" Default="Identificacion" returnvariable="LB_Identificacion"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Apellido1" Default="Apellido Paterno" returnvariable="LB_Apellido1"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Apellido2" Default="Apellido Materno" returnvariable="LB_Apellido2"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre" Default="Nombre" returnvariable="LB_Nombre"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Sindicalizado" Default="Sindicalizado" returnvariable="LB_Sindicalizado"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MesInicio" Default="Mes Inicio" returnvariable="LB_MesInicio"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MesFinal" Default="Mes Final" returnvariable="LB_MesFinal"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TAcumGrav" Default="Acumulado Gravable Anual" returnvariable="LB_TAcumGrav"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TAcumExe" Default="Acumulado Exento Anual" returnvariable="LB_TAcumExe"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TAcumSub" Default="Acumulado Subsidio Tablas" returnvariable="LB_TAcumSub"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_AcumSub" Default="Acumulado Subsidio Anual" returnvariable="LB_AcumSub"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TAcumISR" Default="Acumulado ISR Retenido Anual" returnvariable="LB_TAcumISR"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ISRCargo" Default="ISR a Cargo" returnvariable="LB_ISRCargo"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ISRFavor" Default="ISR a Favor" returnvariable="LB_ISRFavor"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RealizoAjuste" Default="Se realizo Ajuste" returnvariable="LB_RealizoAjuste"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ISRanual" Default="ISR Calculado Anual" returnvariable="LB_ISRanual"/>

<cfquery name = "rsSelectFechas" datasource ="#session.DSN#">
    select RHAAfecharige,RHAAfechavence,RHAAEstatus
    from RHAjusteAnual 
    where RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
	     and Ecodigo = #session.Ecodigo#
</cfquery>
<cfif isdefined ("form.RHAAid") and form.RHAAid NEQ ''>
<cfquery name="rsSelectAjusteAnual" datasource="#session.DSN#">
	<!---insert into #ReporteAjusteAnual#(DEidentificacion,Apellido1,Apellido2,Nombre,Sindicalizado,MesInicio,MesFinal,AcumuladoG,AcumuladoE,SubsidioT,AcumuladoISR,ISRAjuste,Estatus)--->
	select de.DEid,de.DEidentificacion, de.DEapellido1, de.DEapellido2, de.DEnombre, rhaaa.Tcodigo, rhaaa.RHAAAMesInicio,rhaaa.RHAAAMesFinal, rhaaa.RHAAAcumuladoSG,
		rhaaa.RHAAAcumuladoExento, rhaaa.RHAAAcumuladoSubsidio,isnull(rhaaa.RHAAAcumuladoRenta,0) RHAAAcumuladoRenta,
		rhaaa.RHAAAcumuladoISPT,rhaaa.RHAAAcumuladoISR,
        isnull(rhaaa.RHAAAcumuladoISR-(rhaaa.RHAAAcumuladoRenta),0) as calEisr1,
        isnull(rhaaa.RHAAAcumuladoISR-(rhaaa.RHAAAcumuladoSubsidio+rhaaa.RHAAAcumuladoRenta),0) as calEisr2,
        case rhaaa.RHAAAEstatus
        when 0 then 'No'
        when 1 then 'Si'
        end as Estatus
	from DatosEmpleado de inner join RHAjusteAnualAcumulado rhaaa on rhaaa.DEid = de.DEid 
    	<!---inner join RHAjusteAnualSalario rhaas on rhaas.RHAAid = rhaaa.RHAAid and  rhaas.DEid = rhaaa.DEid--->
	where de.Ecodigo = #session.Ecodigo#
	  and rhaaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
	order by de.DEapellido1, de.DEapellido2, de.DEnombre 
</cfquery>
</cfif>






<cfif isdefined ("rsSelectFechas") and rsSelectFechas.RHAAEstatus EQ 0> 
	<cfif isdefined ("rsSelectAjusteAnual") and rsSelectAjusteAnual.RecordCount GT 0>
		<cf_htmlReportsHeaders irA="AjusteAnual-form.cfm?RHAAid=#Form.RHAAid#&tab=4&Reporte=true"
		FileName="Reporte_detalle_Planilla.xls" title="#LB_TituloReporte#">
    </cfif>
<cfelse> 
<cf_htmlReportsHeaders irA="AjusteAnual-lista.cfm"
FileName="Reporte_detalle_Planilla.xls" title="#LB_TituloReporte#">
</cfif>

<cf_dbtemp name = "Subsidio" datasource = "#session.DSN#" returnvariable = "Subsidio">
        <cf_dbtempcol name = "DEid" 			type = "int"			mandatory = "no">
        <cf_dbtempcol name = "Monto"			type = "money"			mandatory = "no">
        <cf_dbtempcol name = "RCNid"			type = "money"			mandatory = "no">
</cf_dbtemp>

<cf_dbtemp name = "Incidencias" datasource = "#session.DSN#" returnvariable = "Incidencias">
        <cf_dbtempcol name = "DEid"             type = "int"            mandatory = "no">
        <cf_dbtempcol name = "Monto"            type = "money"          mandatory = "no">
        <cf_dbtempcol name = "RCNid"            type = "money"          mandatory = "no">
</cf_dbtemp>

<cfquery name="rsInsertSub" datasource="#session.DSN#">
    insert into #Incidencias# (DEid,Monto,RCNid)
    select  hic.DEid,hic.ICmontores,hic.RCNid from 
    HIncidenciasCalculo hic
    inner  join CIncidentes ic
    on ic.CIid =hic.CIid
where ic.CIcodigo ='09'
and hic.RCNid IN
       (SELECT CPid
        FROM CalendarioPagos
        WHERE Ecodigo = 1
          and CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsSelectFechas.RHAAfecharige#">
          and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsSelectFechas.RHAAfechavence#">
          AND CPtipo = 0)
    GROUP BY hic.DEid,
            hic.ICmontores,
            hic.RCNid
</cfquery>

<cfquery name="rsInsertSub" datasource="#session.DSN#">
	insert into #Subsidio# (DEid,Monto,RCNid)
    (select a.DEid,a.DCvalor,a.RCNid
 	from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion c 
 	where a.DEid = b.DEid
	 and c.Ecodigo = b.Ecodigo
	 and c.TDid = b.TDid
     and RCNid in (select CPid from CalendarioPagos
                   where Ecodigo = #session.Ecodigo#
						and CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsSelectFechas.RHAAfecharige#">
						and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsSelectFechas.RHAAfechavence#">
						and CPtipo = 0)
	<!---and b.TDid  in (21)--->
	and c.Ecodigo = #session.Ecodigo#
	and a.DCvalor < 0
 	group by a.DEid,a.DCvalor,a.RCNid)
    union
   (select a.DEid,a.DCvalor,a.RCNid
 	from DeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion c 
 	where a.DEid = b.DEid
	 and c.Ecodigo = b.Ecodigo
	 and c.TDid = b.TDid
     and RCNid in (select CPid from CalendarioPagos
                   where Ecodigo = #session.Ecodigo#
						and CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsSelectFechas.RHAAfecharige#">
						and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsSelectFechas.RHAAfechavence#">
						and CPtipo = 0)
	<!---and b.TDid  in (21)--->
	and c.Ecodigo = #session.Ecodigo#
	and a.DCvalor < 0
 	group by a.DEid,a.DCvalor,a.RCNid)
</cfquery>

<!---<cfquery name="rsReporte" datasource="#session.DSN#">
	select * from #subsidio#
    where DEid = 436
</cfquery>

<cf_dump var = #rsReporte#>
--->
<cf_templatecss>
<table width="100%" border="1" cellpadding="0" cellspacing="0" align="center">
<input type="hidden" name="RHAAid" value="#form.RHAAid#">
<cfoutput>
	<tr>
    	<td colspan="100%">
        	<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>	
						<cf_EncReporte Titulo="#LB_TituloReporte#" Color="##E3EDEF" 
            filtro2="Desde:#lsdateformat(rsSelectFechas.RHAAfecharige,'dd/mm/yyyy')# al #lsdateformat(rsSelectFechas.RHAAfechavence ,'dd/mm/yyyy')#">
					</td>
				</tr>
			</table>	
        </td>
    </tr>
	<tr>
        <td nowrap class="tituloListas" valign="top" align="left">
       		<strong>#LB_Identificacion#</strong>
        </td>
		<td nowrap class="tituloListas" valign="top" align="left">
        	<strong>#LB_Apellido1#</strong>
		</td>
		<td nowrap class="tituloListas" valign="top" align="left">
        	<strong>#LB_Apellido2#</strong>
        </td>
        <td nowrap class="tituloListas" valign="top" align="left">
        	<strong>#LB_Nombre#</strong>
        </td>
        <td nowrap class="tituloListas" valign="top" align="left">
         	<strong>#LB_Sindicalizado#</strong>
        </td>
        <td nowrap class="tituloListas" valign="top" align="left">
        	<strong>#LB_MesInicio#</strong>
        </td>
        <td nowrap class="tituloListas" valign="top" align="left">
        	<strong>#LB_MesFinal#</strong>
        </td>
        <td nowrap class="tituloListas" valign="top" align="left">
        	<strong>#LB_TAcumGrav#</strong>
        </td>
       	<td nowrap class="tituloListas" valign="top" align="left">
        	<strong>#LB_TAcumExe#</strong>
        </td>
        <td nowrap class="tituloListas" valign="top" align="left">
        	<strong>#LB_TAcumSub#</strong>
        </td>
        <td nowrap class="tituloListas" valign="top" align="left">
        	<strong>#LB_AcumSub#</strong>
        </td>
        <td nowrap class="tituloListas" valign="top" align="left">
        	<strong>#LB_TAcumISR#</strong>
        </td>
         <td nowrap class="tituloListas" valign="top" align="left">
            <strong>#LB_ISRanual#</strong>
        </td>
        <td nowrap class="tituloListas" valign="top" align="left">
        	<strong>#LB_ISRFavor#</strong>
        </td>   
       	<td nowrap class="tituloListas" valign="top" align="left">
        	<strong>#LB_ISRCargo#</strong>
        </td>  
        <td nowrap class="tituloListas" align="left">
        	<strong>#LB_RealizoAjuste#</strong>
        </td> 
    </tr>
    <cfset Totalfavor=0>
    <cfset Totalcargo=0>    
<cfloop query="rsSelectAjusteAnual">
	<tr>
        <td nowrap align="left">
       		#rsSelectAjusteAnual.DEidentificacion#
        </td>
		<td nowrap align="left">
        	#rsSelectAjusteAnual.DEapellido1#
		</td>
		<td nowrap align="left">
        	#rsSelectAjusteAnual.DEapellido2#
        </td>
        <td nowrap align="left">
        	#rsSelectAjusteAnual.DEnombre#
        </td>
        <td nowrap align="left">
        	<cfquery name = "rsTipoNomina" datasource="#session.DSN#">
            	select Tdescripcion 
                from TiposNomina where Ecodigo = #session.Ecodigo# and Tcodigo = #rsSelectAjusteAnual.Tcodigo#
            </cfquery>
         	#rsTipoNomina.Tdescripcion#
        </td>
        <td nowrap align="left">
        	#rsSelectAjusteAnual.RHAAAMesInicio#
        </td>
        <td nowrap align="left">
        	#rsSelectAjusteAnual.RHAAAMesFinal#
        </td>
        <td nowrap align="left">
	        #LSCurrencyformat(rsSelectAjusteAnual.RHAAAcumuladoSG,'none')#
        </td>
       	<td nowrap align="left">
        	#LSCurrencyformat(rsSelectAjusteAnual.RHAAAcumuladoExento,'none')#
        </td>
        <td nowrap align="left">
        	#LSCurrencyformat(rsSelectAjusteAnual.RHAAAcumuladoSubsidio,'none')#
        </td>
        <td nowrap align="left">
        	<cfquery name="rsReporte" datasource="#session.DSN#">
                    select isnull(sum(t.Monto),0.00 )as Monto
                    from(
                    select sum(Monto) * -1 as Monto from #Subsidio#
					where DEid = #rsSelectAjusteAnual.DEid#
                    union all
                    select sum(Monto) as Monto from #Incidencias#
                    where DEid = #rsSelectAjusteAnual.DEid#)t

            </cfquery>
            #LSCurrencyformat(rsReporte.Monto,'none')#
        </td>
        <td nowrap align="left">
            #LSCurrencyformat(rsSelectAjusteAnual.RHAAAcumuladoRenta,'none')#
        </td>
        <cfset favor=0>
        <cfset cargo=0>
        <!--- <cfif rsReporte.Monto EQ 0 and rsSelectAjusteAnual.calEisr1 gt 0>
            <cfset cargo=rsSelectAjusteAnual.calEisr1>
        <cfelseif rsReporte.Monto EQ 0 and rsSelectAjusteAnual.calEisr1 lt 0>
            <cfset favor=rsSelectAjusteAnual.calEisr1>
        <cfelseif rsReporte.Monto gt 0 and rsSelectAjusteAnual.calEisr2 gt 0>
            <cfset cargo=rsSelectAjusteAnual.calEisr2>
        <cfelseif rsReporte.Monto gt 0 and rsSelectAjusteAnual.calEisr2 lt 0>
             <cfset favor=rsSelectAjusteAnual.calEisr2>
        </cfif> --->
        <cfif rsSelectAjusteAnual.RHAAAcumuladoSubsidio gt rsSelectAjusteAnual.RHAAAcumuladoISR>
            <cfset favor=0>
            <cfset cargo=0>
        <cfelse>
            <cfif rsSelectAjusteAnual.RHAAAcumuladoSubsidio gt 0>
                <cfset favor=((rsSelectAjusteAnual.RHAAAcumuladoISR - rsSelectAjusteAnual.RHAAAcumuladoSubsidio - rsSelectAjusteAnual.RHAAAcumuladoRenta)lt 0) ? LSCurrencyformat((rsSelectAjusteAnual.RHAAAcumuladoISR - rsSelectAjusteAnual.RHAAAcumuladoSubsidio - rsSelectAjusteAnual.RHAAAcumuladoRenta),'none'):0>
                <cfset cargo=((rsSelectAjusteAnual.RHAAAcumuladoISR - rsSelectAjusteAnual.RHAAAcumuladoSubsidio - rsSelectAjusteAnual.RHAAAcumuladoRenta) gt 0)? LSCurrencyformat((rsSelectAjusteAnual.RHAAAcumuladoISR - rsSelectAjusteAnual.RHAAAcumuladoSubsidio - rsSelectAjusteAnual.RHAAAcumuladoRenta),'none'):0>
            </cfif>
            <cfif rsSelectAjusteAnual.RHAAAcumuladoSubsidio lt 0 or rsSelectAjusteAnual.RHAAAcumuladoSubsidio eq 0>
                <cfset favor=((rsSelectAjusteAnual.RHAAAcumuladoISR - rsSelectAjusteAnual.RHAAAcumuladoRenta) lt 0)?LSCurrencyformat((rsSelectAjusteAnual.RHAAAcumuladoISR - rsSelectAjusteAnual.RHAAAcumuladoRenta),'none'):0>
                <cfset cargo=((rsSelectAjusteAnual.RHAAAcumuladoISR - rsSelectAjusteAnual.RHAAAcumuladoRenta) gt 0)?LSCurrencyformat((rsSelectAjusteAnual.RHAAAcumuladoISR - rsSelectAjusteAnual.RHAAAcumuladoRenta),'none'):0>
            </cfif>
        </cfif> 
        <td nowrap align="left">
            #LSCurrencyformat(rsSelectAjusteAnual.RHAAAcumuladoISR,'none')#
        </td>
        <td nowrap align="left">
            #Abs(LSParseNumber(favor))#
        </td>
        <td nowrap align="left">
           #Abs(LSParseNumber(cargo))#
        </td>
        <td nowrap align="left">
        	#rsSelectAjusteAnual.Estatus#
        </td> 
    </tr>
    <cfset Totalfavor=Totalfavor+LSParseNumber(favor)>
    <cfset Totalcargo=Totalcargo+LSParseNumber(cargo)>  
</cfloop>
<cfquery name="rsSelectISRFavor" datasource="#session.DSN#">
	select coalesce(sum(RHAAAcumuladoISPT),0.00) as Favor
	from RHAjusteAnualAcumulado
	where RHAAAcumuladoISPT  > 0
		and RHAAid =  '#form.RHAAid#'
</cfquery>

<cfquery name="rsSelectISRCargo" datasource="#session.DSN#">
	select -(coalesce(sum(RHAAAcumuladoISPT),0.00)) as Cargo
	     from RHAjusteAnualAcumulado as Cargo
	     where RHAAAcumuladoISPT  < 0
	     and RHAAid =  '#form.RHAAid#'
</cfquery>

<tr><td colspan="100%" align="left"><strong><cf_translate key="LB_TotalFavor">Total de ISR a Cargo :  #LSCurrencyformat(Abs(Totalfavor),'none')#</cf_translate></strong></td></tr>
<tr><td colspan="100%" align="left"><strong><cf_translate key="LB_TotalCargo">Total de ISR a Favor :  #LSCurrencyformat(Totalcargo,'none')#</cf_translate></strong></td></tr>
<tr><td colspan="100%" align="center"><strong><cf_translate key="LB_FinDelReporte">--Fin Del Reporte-- </cf_translate></strong></td></tr>
</cfoutput>
</table>




