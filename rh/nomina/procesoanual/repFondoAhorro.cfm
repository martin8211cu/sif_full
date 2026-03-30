<!---<cf_dump var = "#url#">--->

<cfif isdefined ("URL.RHCFOAid") and URL.RHCFOAid NEQ ''>
	<cfset RHCFOAid = #URL.RHCFOAid#>
</cfif>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TituloReporte" Default="Reporte Previo de Fondo de Ahorro" returnvariable="LB_TituloReporte"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion" Default="Identificacion" returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre" Default="Nombre" returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaInicio" Default="Fecha Inicio" returnvariable="LB_FechaInicio"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaFin" Default="Fecha Fin" returnvariable="LB_FechaFin"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FOAEmpresa" Default="Fondo de Ahorro Empresa" returnvariable="LB_FOAEmpresa"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FOAEmpleado" Default="Fondo de Ahorro Empleado" returnvariable="LB_FOAEmpleado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoInteres" Default="Monto de Inter&eacute;s" returnvariable="LB_MontoInteres"/>

<cf_htmlReportsHeaders irA="FondoAhorro-form.cfm?RHCFOAid=#RHCFOAid#&tab=3" FileName="Reporte_detalle_Planilla.xls" title="#LB_TituloReporte#">

<!---<cfquery name="rsFOA" datasource="#session.DSN#">
	select RHCFOAid, RHCFOAcodigo,RHCFOAdesc,RHCFOAfechaInicio,RHCFOAfechaFinal, 
    case  when RHCFOAEstatus = 0 then 'En Proceso'
    	  else 'Aplicado'
    end as Estatus
	from RHCierreFOA
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHCFOAid#">
</cfquery>

	<cf_dbtemp name = "RHFOA" datasource = "#session.DSN#" returnvariable = "RHFOA">
    	<cf_dbtempcol name="DEid"				type="int"				mandatory="no">
    	<cf_dbtempcol name="DEidentificacion"	type="int"				mandatory="no">
        <cf_dbtempcol name="Nombre"				type="varchar(100)"		mandatory="no">
        <cf_dbtempcol name="FechaInicio" 		type="date"  			mandatory="no">
        <cf_dbtempcol name="FechaFinal" 		type="date"  			mandatory="no">
       	<cf_dbtempcol name="FOAEmpresa" 		type="money"  			mandatory="no">
        <cf_dbtempcol name="FOAEmpleado" 		type="money"  			mandatory="no">
        <cf_dbtempcol name="MontoInteres" 		type="money"  			mandatory="no">
    </cf_dbtemp>
    
    <cfquery name="rsInsertFOA" datasource="#session.DSN#">
    	insert into #RHFOA# (DEid,DEidentificacion,Nombre,FechaInicio,FechaFinal,MontoInteres)
        select a.DEid,a.DEidentificacion, 	
			{fn concat(a.DEapellido1,{fn concat(' ',{fn concat(a.DEapellido2,{fn concat(',',{fn concat(' ',a.DEnombre)})})})})} as Nombre_Empleado,
			c.RHCFOAfechaInicio,c.RHCFOAfechaFinal,b.RHDCFOAmonto
		from DatosEmpleado a 
			inner join RHDCierreFOA b on a.DEid = b.DEid 
			inner join RHCierreFOA c on c.RHCFOAid = b.RHCFOAid and a.Ecodigo=c.Ecodigo
		where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        	and c.RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHCFOAid#">
	</cfquery>
    
    <cfquery name="rsSelectFOA" datasource="#session.DSN#">
        select DEid,FechaInicio,FechaFinal
		from #RHFOA# 
	</cfquery>

    <cfloop query="rsSelectFOA">
    <cfquery name="rsRHFOAEmpleado" datasource="#session.DSN#">
        update #RHFOA# 
        set FOAEmpresa = coalesce((select coalesce(SUM(a.FAmonto),0) as monto
		from RHHFondoAhorro a inner join CalendarioPagos b
			on a.RCNid = b.CPid and a.Ecodigo = b.Ecodigo
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and FAEstatus = 0
			and CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFOA.RHCFOAfechaInicio#">
			and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFOA.RHCFOAfechaFinal#">
            and TDid in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = '01' 	
                            where c.RHRPTNcodigo = 'PR004'				
                              and c.Ecodigo = #session.Ecodigo#)
            and DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSelectFOA.DEid#">
		group by DEid,a.Tcodigo),0)
        where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSelectFOA.DEid#">
    </cfquery>
    
    <cfquery name="rsRHFOAEmpresa" datasource="#session.DSN#">
    	update #RHFOA# 
        set FOAEmpleado =
        coalesce((select coalesce(SUM(a.FAmonto),0) as monto
		from RHHFondoAhorro a inner join CalendarioPagos b
			on a.RCNid = b.CPid and a.Ecodigo = b.Ecodigo
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and FAEstatus = 0
			and CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFOA.RHCFOAfechaInicio#">
			and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFOA.RHCFOAfechaFinal#">
            and DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSelectFOA.DEid#">
            and TDid in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = '02' 	
                            where c.RHRPTNcodigo = 'PR004'				
                              and c.Ecodigo = #session.Ecodigo#)
		group by DEid,a.Tcodigo),0)
        where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSelectFOA.DEid#">
    </cfquery> 
    </cfloop>
    --->
    <cfquery name="rsSelectFOA" datasource="#session.DSN#">
        select a.RHCFOAid, a.RHCFOAcodigo, a.RHCFOAfechaInicio,a.RHCFOAfechaFinal, a.RHCFOAdesc,c.DEidentificacion, 	
			{fn concat(c.DEapellido1,{fn concat(' ',{fn concat(c.DEapellido2,{fn concat(',',{fn concat(' ',c.DEnombre)})})})})} as Nombre_Empleado,
            b.*
	from RHCierreFOA a inner join RHDCierreFOA b
		on a.RHCFOAid = b.RHCFOAid
        inner join DatosEmpleado c on c.DEid = b.DEid and c.Ecodigo = a.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHCFOAid#">
	</cfquery>

<!---<cf_dump var = #rsSelectFOA#>--->
<cf_templatecss>
<table width="100%" border="1" cellpadding="0" cellspacing="0" align="center">
<cfoutput>
	<tr>
    	<td colspan="100%">
        	<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>	
						<cf_EncReporte Titulo="#LB_TituloReporte#" Color="##E3EDEF" 
            filtro2="Desde:#lsdateformat(rsSelectFOA.RHCFOAfechaInicio,'dd/mm/yyyy')# al #lsdateformat(rsSelectFOA.RHCFOAfechaFinal,'dd/mm/yyyy')#">
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
        	<strong>#LB_Nombre#</strong>
        </td>
        <td nowrap class="tituloListas" valign="top" align="left">
        	<strong>#LB_FechaInicio#</strong>
        </td>
       	<td nowrap class="tituloListas" valign="top" align="left">
        	<strong>#LB_FechaFin#</strong>
        </td>
        <td nowrap class="tituloListas" valign="top" align="left">
        	<strong>#LB_FOAEmpresa#</strong>
        </td>
        <td nowrap class="tituloListas" valign="top" align="left">
        	<strong>#LB_FOAEmpleado#</strong>
        </td>
        <td nowrap class="tituloListas" valign="top" align="left">
        	<strong>#LB_MontoInteres#</strong>
        </td>
    </tr>
<cfloop query="rsSelectFOA">
	<tr>
        <td nowrap valign="top" align="left">
       		#rsSelectFOA.DEidentificacion#
        </td>
        <td nowrap valign="top" align="left">
        	#rsSelectFOA.Nombre_Empleado#
        </td>
        <td nowrap valign="top" align="left">
        	#LSDateFormat(rsSelectFOA.RHCFOAfechaInicio,'dd/MM/yyyy')#
        </td>
       	<td nowrap valign="top" align="left">
        	#LSDateFormat(rsSelectFOA.RHCFOAfechaFinal,'dd/MM/yyyy')#
        </td>
        <td nowrap valign="top" align="center">
        	#LSCurrencyFormat(rsSelectFOA.RHDCFOAempresa,'none')#
        </td>
        <td nowrap valign="top" align="center">
        	#LSCurrencyFormat(rsSelectFOA.RHDCFOAempleado,'none')#
        </td>
        <td nowrap valign="top" align="center">
        	#LSCurrencyFormat(rsSelectFOA.RHDCFOAmonto,'none')#
        </td>
    </tr>
</cfloop>
	<tr>
		<td colspan="100%" align="center"><strong><cf_translate key="LB_FinDelReporte">--Fin Del Reporte-- </cf_translate></strong></td>
    </tr>
</cfoutput>
</table>




