<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Desde"
	Default="Desde"
	returnvariable="LB_Desde"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Hasta"
	Default="Hasta"
	returnvariable="LB_Hasta"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"
	returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CentroFuncional"
	Default="Centro Funcional"
	returnvariable="LB_CentroFuncional"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificacion"
	returnvariable="LB_Identificacion"/>    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Total"
	Default="Total"
	returnvariable="LB_Total"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Totales"
	Default="Totales"
	returnvariable="LB_Totales"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Subtotal"
	Default="SubTotal"
	returnvariable="LB_Subtotal"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Aguinaldo"
	Default="Aguinaldo"
	returnvariable="LB_Aguinaldo"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ReporteDeAquinaldos"
	Default="Reporte de Aguinaldo"
	returnvariable="LB_ReporteDeAquinaldos"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ReporteDeAportesAcumulados"
	Default="Reporte de Aportes Acumulados por Empleado"
	returnvariable="LB_ReporteDeAportesAcumulados"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ReporteDeAquinaldoPorEmpleadoYCentroFuncional"
	Default="Reporte de Aguinaldo por Empleado y Centro Funcional"
	returnvariable="LB_ReporteDeAquinaldoPorEmpleadoYCentroFuncional"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ReporteDeAquinaldoPorCentroFuncional"
	Default="Reporte de Aguinaldo por Centro Funcional"
	returnvariable="LB_ReporteDeAquinaldoPorCentroFuncional"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaDesde"
	Default="Fecha Desde"
	returnvariable="LB_FechaDesde"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaHasta"
	Default="Fecha Hasta"
	returnvariable="LB_FechaHasta"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ParaNomina"
	Default="Para N&oacute;mina"
	returnvariable="LB_ParaNomina"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ParaNomina"
	Default="Para N&oacute;mina"
	returnvariable="LB_ParaNomina"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ReporteAporteAcumulado"
	Default="Reporte de Aportes Acumulados"
	returnvariable="LB_ReporteAporteAcumulado"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_AportePatronal"
	Default="Aportes Patronal"
	returnvariable="LB_AportePatronal"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_AporteEmpleado"
	Default="Aportes Empleado"
	returnvariable="LB_AporteEmpleado"/>	
		
<cfif isdefined("url.back")>
    <cf_htmlReportsHeaders 
    back="false"
    irA=""
    FileName="ReporteAporteAcumulado.xls"
    method="url"
    title="#LB_ReporteAporteAcumulado#">
<cfelse>
    <cf_htmlReportsHeaders 
	irA="ReporteAportesFuncionarioPatrono.cfm"
	FileName="ReporteAporteAcumulado.xls"
	method="url"
	title="#LB_ReporteAporteAcumulado#">
</cfif>
<!--- FIN VARIABLES DE TRADUCCION --->

<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2696" default="0" returnvariable="LvarMostrarColDolar"> 


<!--- SE VERIFICA CON CUAL TIPO DE NOMINA SE VA A TIRAR EL REPORTE, NOMINAS APLICADAS O SIN APLICAR --->
<cfset prefijo = ''>
<cfif isdefined("chk_NominaAplicada")>
	<cfset prefijo = 'H'>
</cfif>

<!---SQL--->
<cfinclude template="ReporteAportesFuncionarioPatrono_SQL.cfm">

<cfset vfiltro0=''>
<cfif isdefined("url.Tipo") and url.Tipo EQ 1><!---Funcionario--->
	<cfset vfiltro0='#LB_AporteEmpleado#'>
</cfif>
<cfif isdefined("url.Tipo") and url.Tipo EQ 0><!---Patrono--->
	<cfset vfiltro0='#LB_AportePatronal#'>
</cfif>

<cfset vfiltro1=''>
<cfif isdefined("url.PorFechas")>
	<cfif isdefined("url.Fdesde") and len(trim(url.Fdesde))>
		<cfset vfiltro1= vfiltro1 & '#LB_FechaDesde#: #url.Fdesde# '>
	</cfif>
	<cfif isdefined("url.Fhasta") and len(trim(url.Fhasta))>
		<cfset vfiltro1= vfiltro1 & '#LB_FechaHasta#: #url.Fhasta#'>
	</cfif>
<cfelse>
	<cfquery name="rsEncabezado" datasource="#session.dsn#">
			select e.Edescripcion,b.CPhasta, b.CPdesde,b.CPfpago,b.CPcodigo,b.CPperiodo, b.CPmes,b.CPdescripcion, a.RCDescripcion,tn.Tcodigo,tn.Tdescripcion,a.RCtc
			from #prefijo#RCalculoNomina a
			inner join CalendarioPagos b
				on a.RCNid = b.CPid
			inner join Empresas e 
					on b.Ecodigo = e.Ecodigo
			inner join TiposNomina tn 
					on b.Ecodigo = tn.Ecodigo
					and b.Tcodigo = tn.Tcodigo 
			where a.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ListaNomina#" list="true">)
	</cfquery>
	<cfloop query="rsEncabezado">
		<cfif RCtc neq 1 >
			<cfset vTC = "(TC: #RCtc#)">
		<cfelse>
			<cfset vTC = "" >   
		</cfif>
		<cfset vfiltro1 &= '#Edescripcion# - #CPcodigo# - #Tcodigo# - #Tdescripcion# - #CPdescripcion# #vTC#. <br/>'>
	</cfloop>
</cfif>

<cfinvoke key="LB_TipoDeCambio" default="Tipo de Cambio" returnvariable="LB_TipoDeCambio" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>	
<cfif LvarMostrarColDolar>
	<cfset LvarTipoCambio = 1>
<cfelse>	
	<cfset LvarTipoCambio = 1>
</cfif>

<cfset LvarHTTP = 'http://'>
<cfif isdefined("session.sitio.ssl_todo") and session.sitio.ssl_todo> <cfset LvarHTTP = 'https://'> </cfif>
<link href="<cfoutput>#LvarHTTP##cgi.server_name#<cfif len(trim(cgi.SERVER_PORT))>:#cgi.SERVER_PORT#</cfif></cfoutput>/cfmx/plantillas/IICA/css/reports.css" rel="stylesheet" type="text/css">
        
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style>
    thead { display: table-header-group; }
    tfoot { display: table-footer-group; }
    
    @media print {
    thead { display: table-header-group; }
    tfoot { display: table-footer-group; }
    }
    @media screen {
        thead { display: none; }
        tfoot { display: none; }
    }
    table { page-break-inside:auto }
    tr { page-break-inside:avoid; page-break-after:auto }
</style>
<title>#LB_Corp#</title>
</head>
<body>
	<!---<cfif isdefined('url.Corte') and url.Corte EQ '0'>--->
		<!--- ENCABEZADO --->
		<cfset vColspan = Columnas.recordcount + 3>
		<cfquery name="rsTipoNomina" datasource="#session.DSN#">
			select Tdescripcion
			from TiposNomina
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and Tcodigo in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" value="#url.ListaTipoNomina1#">)            
		</cfquery>
        <cf_HeadReport
        Titulo="#Trim(LB_ReporteDeAportesAcumulados)#"
        addTitulo1="#LB_Corp#"
        filtro1="#vfiltro1#"	
		filtro2="#vfiltro0#"	
        Color="##E3EDEF"
        showline="false">
	                                        
	<table width="100%" class="reporte">
		<thead style="display: table-header-group">
        <tr class="titulo_columnar">
			<th nowrap><cfoutput>#LB_Identificacion#</cfoutput></th>        
			<th nowrap><cfoutput>#LB_Nombre#</cfoutput></th>
		  	<cfoutput query="columnas" group="codigo">
			<th align="right" nowrap><span class="style5">#codigo#</span></th>
		  	</cfoutput>
			<th align="right" nowrap><cfoutput><span class="style5">#LB_Total#</span></cfoutput></th>
            <cfif LvarMostrarColDolar>
            <th align="right" nowrap><cfoutput><span class="style5">#LB_Total# $</span></cfoutput></th>
            </cfif>
		  	
	  	</tr>
        </thead>
		<cfset vTotal = 0>
		<cfset vTotales = 0>
		<cfset vTotalesA = 0>
		<cfset vTotalP = 0>
		<cfset vTotalesP = 0>
		<cfset vTotalesPA = 0>
		<cfset cont=0>

		<cfoutput query="rsReporte" group="DEid">
			<cfset cont = cont +1>
			<cfset vDEid = rsReporte.DEid>
			<cfset vTotalEmp = 0>
			<cfquery name="rsTotal" dbtype="query">
				select MontoEmp,MontoPat, DEid
				from rsReporte
				where DEid = #vDEid#
			</cfquery>

			<cfquery name="rsTotal" dbtype="query">
				select sum(MontoEmp) as Total, sum(MontoPat) as Total2, DEid
				from rsReporte
				where DEid = #vDEid#
				group by DEid
			</cfquery>
			<cfset vTotalEmp = 0>
			<cfset vTotal = vTotal + vTotalEmp>
			<cfset vTotalPat = 0>
			<cfset vTotalP = vTotalP + vTotalPat>
			<tr <cfif not cont MOD 2>bgcolor="##E2E2E2"<cfelse>bgcolor="##E4E4E4"</cfif>>
				<td nowrap>&nbsp;#Ucase(DEidentificacion)#</td>            
				<td nowrap>#Ucase(Nombre)#</td>
				<cfloop query="columnas" group="codigo">
	
					<cfquery name="rsCP" dbtype="query">
						select sum(MontoEmp) as MontoEmp, sum(MontoPat) as MontoPat
						from rsReporte
						where DEid = #vDEid#
						  and codigo = '#trim(codigo)#'
					</cfquery>
					<td align="right">
						<cfif rsCP.RecordCount GT 0>
							<cfif url.Tipo EQ 1>
								#LSCurrencyFormat(rsCP.MontoEmp,'none')#
							<cfelse>
								#LSCurrencyFormat(rsCP.MontoPat,'none')#
							</cfif>	
						<cfelse><div align="center">-</div></cfif>					
					</td>
					<cfif len(trim(rsCP.MontoEmp))>
						<cfset vTotalEmp = vTotalEmp + rsCP.MontoEmp >
					</cfif>
					<cfif len(trim(rsCP.MontoPat))>
						<cfset vTotalPat = vTotalPat + rsCP.MontoPat>
					</cfif>
				</cfloop>
				
				<cfif url.Tipo EQ 1>
					<td align="right" bgcolor="##CCCCCC" >#LSCurrencyFormat(vTotalEmp,'none')#</td>
					<cfif LvarMostrarColDolar>
						<td align="right" bgcolor="##CCCCCC" >#LSCurrencyFormat(vTotalEmp/LvarTipoCambio,'none')#</td>
					</cfif>
				<cfelse>
					<td align="right" bgcolor="##CCCCCC" >#LSCurrencyFormat(vTotalPat,'none')#</td>
					<cfif LvarMostrarColDolar>
						<td align="right" bgcolor="##CCCCCC" >#LSCurrencyFormat(vTotalPat/LvarTipoCambio,'none')#</td>
					</cfif>
				</cfif>	
			</tr>
			<cfset vTotales = vTotales + vTotalEmp>
			<cfset vTotalesA = vTotalesA + vTotalEmp/12>
			<cfset vTotalesP = vTotalesP + vTotalPat>
			<cfset vTotalesPA = vTotalesPA + vTotalPat/12>
		</cfoutput>

		<cfoutput>
			<tr style="font-weight:bold;">
				<td bgcolor="##CCCCCC">#LB_Totales#</td>
				<td bgcolor="##CCCCCC">&nbsp;</td>                            
				<cfloop query="columnas" group="codigo">
					<cfquery name="rsCP2" dbtype="query">
						select distinct *
						from rsReporte
						where codigo = '#trim(codigo)#'
					</cfquery>
					<cfquery name="rsCP" dbtype="query">
						select codigo, sum(MontoEmp) as TotalCP, sum(MontoPat) as TotalCP_Pat
						from rsCP2
						where codigo = '#trim(codigo)#'
						group by codigo
					</cfquery>
					<td align="right" bgcolor="##CCCCCC">
						<cfif url.Tipo EQ 1>
							<cfif rsCP.RecordCount GT 0>#LSCurrencyFormat(rsCP.TotalCP,'none')#<cfelse><div align="center">-</div></cfif>	
						<cfelse>
							<cfif rsCP.RecordCount GT 0>#LSCurrencyFormat(rsCP.TotalCP_Pat,'none')#<cfelse><div align="center">-</div></cfif>	
						</cfif>				
					</td>
				</cfloop>
				<cfif url.Tipo EQ 1>
					<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotales,'none')#</td>
				<cfelse>
					<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotalesP,'none')#</td>
				</cfif>
				
                <cfif LvarMostrarColDolar>
					<cfif url.Tipo EQ 1>
						<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotales/LvarTipoCambio,'none')#</td>
					<cfelse>
						<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotalesP/LvarTipoCambio,'none')#</td>
					</cfif>
					
				</cfif>
			</tr>
		</cfoutput>
	</table>
</body> 
</html>	