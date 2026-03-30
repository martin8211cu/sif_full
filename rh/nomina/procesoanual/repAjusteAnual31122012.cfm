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

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TAcumSub" Default="Acumulado Subsidio Anual" returnvariable="LB_TAcumSub"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TAcumISR" Default="Acumulado ISR Retenido Anual" returnvariable="LB_TAcumISR"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ISRCargo" Default="ISR a Cargo" returnvariable="LB_ISRCargo"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ISRFavor" Default="ISR a Favor" returnvariable="LB_ISRFavor"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RealizoAjuste" Default="Se realizo Ajuste" returnvariable="LB_RealizoAjuste"/>

<cfquery name = "rsSelectFechas" datasource ="#session.DSN#">
    select RHAAfecharige,RHAAfechavence,RHAAEstatus
    from RHAjusteAnual 
    where RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
	     and Ecodigo = #session.Ecodigo#
</cfquery>

<cfif isdefined ("form.RHAAid") and form.RHAAid NEQ ''>
<cfquery name="rsSelectAjusteAnual" datasource="#session.DSN#">
	select de.DEidentificacion, de.DEapellido1, de.DEapellido2, de.DEnombre, rhaaa.Tcodigo, rhaaa.RHAAAMesInicio,rhaaa.RHAAAMesFinal, rhaaa.RHAAAcumuladoSG,
		rhaaa.RHAAAcumuladoExento, rhaaa.RHAAAcumuladoSubsidio,rhaaa.RHAAAcumuladoRenta,
		rhaaa.RHAAAcumuladoISPT, 
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
        	<strong>#LB_TAcumISR#</strong>
        </td>
       	<td nowrap class="tituloListas" valign="top" align="left">
        	<strong>#LB_ISRCargo#</strong>
        </td>  
        <td nowrap class="tituloListas" valign="top" align="left">
        	<strong>#LB_ISRFavor#</strong>
        </td>   
        <td nowrap class="tituloListas" align="left">
        	<strong>#LB_RealizoAjuste#</strong>
        </td> 
    </tr>
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
        	#LSCurrencyformat(rsSelectAjusteAnual.RHAAAcumuladoRenta,'none')#
        </td>
       	<td nowrap align="left">
        	<cfif rsSelectAjusteAnual.RHAAAcumuladoISPT LT 0>
        		#LSCurrencyformat(rsSelectAjusteAnual.RHAAAcumuladoISPT,'none')# 
            <cfelseif rsSelectAjusteAnual.RHAAAcumuladoISPT GTE 0>
            	#LSCurrencyformat(0.00,'none')# 
            </cfif> 
        </td> 
        <td nowrap align="left">
        	<cfif rsSelectAjusteAnual.RHAAAcumuladoISPT GT 0>
        		#LSCurrencyformat(rsSelectAjusteAnual.RHAAAcumuladoISPT,'none')#
            <cfelseif rsSelectAjusteAnual.RHAAAcumuladoISPT LTE 0>
            	#LSCurrencyformat(0.00,'none')# 
            </cfif>
        </td>   
        <td nowrap align="left">
        	#rsSelectAjusteAnual.Estatus#
        </td> 
    </tr>
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

<tr><td colspan="100%" align="left"><strong><cf_translate key="LB_TotalFavor">Total de ISR a Favor :  #LSCurrencyformat(rsSelectISRFavor.Favor,'none')#</cf_translate></strong></td></tr>
<tr><td colspan="100%" align="left"><strong><cf_translate key="LB_TotalCargo">Total de ISR a Cargo :  #LSCurrencyformat(rsSelectISRCargo.Cargo,'none')#</cf_translate></strong></td></tr>
<tr><td colspan="100%" align="center"><strong><cf_translate key="LB_FinDelReporte">--Fin Del Reporte-- </cf_translate></strong></td></tr>
</cfoutput>
</table>




