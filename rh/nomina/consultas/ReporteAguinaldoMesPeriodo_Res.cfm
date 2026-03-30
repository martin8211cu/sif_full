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
	Key="LB_ReporteDeAquinaldoPorEmpleado"
	Default="Reporte de Aguinaldo por Empleado"
	returnvariable="LB_ReporteDeAquinaldoPorEmpleado"/>	
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
<cfif isdefined("url.back")>
    <cf_htmlReportsHeaders 
    back="false"
    irA=""
    FileName="ReporteAguinaldosMesPeriodo.xls"
    method="url"
    title="#LB_ReporteDeAquinaldos#">
<cfelse>
    <cf_htmlReportsHeaders 
	irA="ReporteAguinaldoMesPeriodo.cfm"
	FileName="ReporteAguinaldosMesPeriodo.xls"
	method="url"
	title="#LB_ReporteDeAquinaldos#">
</cfif>
<!--- FIN VARIABLES DE TRADUCCION --->

<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2696" default="0" returnvariable="LvarMostrarColDolar"> 

<!---SQL--->
<cfinclude template="ReporteAguinaldo_SQL.cfm">

<cfinvoke key="LB_TipoDeCambio" default="Tipo de Cambio" returnvariable="LB_TipoDeCambio" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>	
<cfif LvarMostrarColDolar>
	<cfset LB_TipoDeCambio &= ': #LSNumberFormat(LvarTipoCambio,'9,999,999.99')#'>
<cfelse>	
	<cfset LB_TipoDeCambio = ''>
</cfif>

<cfset filtro3=''>
<cfif LvarMostrarColDolar>
	<cfset filtro3 = LB_TipoDeCambio>
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
	<cfif isdefined('url.Corte') and url.Corte EQ '0'>
		<!--- ENCABEZADO --->
		<cfset vColspan = Columnas.recordcount + 3>
		<cfquery name="rsTipoNomina" datasource="#session.DSN#">
			select Tdescripcion
			from TiposNomina
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and Tcodigo in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" value="#url.ListaTipoNomina1#">)            
		</cfquery>
        <cf_HeadReport
        Titulo="#Trim(LB_ReporteDeAquinaldoPorEmpleado)#"
        addTitulo1="#LB_Corp#"
        filtro1="#LB_FechaDesde#: #url.Fdesde#  #LB_FechaHasta#: #url.Fhasta#"	
        filtro2="#LB_ParaNomina#: #valueList(rsTipoNomina.Tdescripcion)#"
        filtro3="#filtro3#"
        Color="##E3EDEF"
        showline="false">
                                            
	<table width="100%" class="reporte">
		<thead style="display: table-header-group">
        <tr class="titulo_columnar">
			<th nowrap><cfoutput>#LB_Nombre#</cfoutput></th>
		  	<cfoutput query="columnas" group="CPcodigo">
			<th align="right"><span class="style5">#CPcodigo#</span></th>
		  	</cfoutput>
			<th align="right"><cfoutput><span class="style5">#LB_Total#</span></cfoutput></th>
            <cfif LvarMostrarColDolar>
            <th align="right"><cfoutput><span class="style5">#LB_Total# $</span></cfoutput></th>
            </cfif>
		  	<th align="right" nowrap><cfoutput><span class="style5">#LB_Aguinaldo#</span></cfoutput></th>
          	<cfif LvarMostrarColDolar>
           	<th align="right" nowrap><cfoutput><span class="style5">#LB_Aguinaldo# $</span></cfoutput></th>
            </cfif>	
	  	</tr>
        </thead>
		<cfset vTotal = 0>
		<cfset vTotales = 0>
		<cfset vTotalesA = 0>
		<cfset cont=0>

		<cfoutput query="rsReporte" group="DEid">
			<cfset cont = cont +1>
			<cfset vDEid = rsReporte.DEid>
			<cfset vTotalEmp = 0>
			<cfquery name="rsTotal" dbtype="query">
				select MontoAg, DEid
				from rsReporte
				where DEid = #vDEid#
			</cfquery>

			<cfquery name="rsTotal" dbtype="query">
				select sum(MontoAg) as Total, DEid
				from rsReporte
				where DEid = #vDEid#
				group by DEid
			</cfquery>
			<!---<cfset vTotalEmp = rsTotal.Total>--->
			<cfset vTotalEmp = 0>
			<cfset vTotal = vTotal + vTotalEmp>
			<tr <cfif not cont MOD 2>bgcolor="##E2E2E2"<cfelse>bgcolor="##E4E4E4"</cfif>>
				<td nowrap>#Ucase(Nombre)#</td>
				<cfloop query="columnas" group="CPcodigo">
	
					<cfquery name="rsCP" dbtype="query">
						select sum(MontoAg) as MontoAg
						from rsReporte
						where DEid = #vDEid#
						  and codigo = '#trim(CPcodigo)#'
					</cfquery>
					<td align="right">
						<cfif rsCP.RecordCount GT 0>#LSCurrencyFormat(rsCP.MontoAg,'none')#<cfelse><div align="center">-</div></cfif>					
					</td>
					<cfif len(trim(rsCP.MontoAg))>
						<cfset vTotalEmp = vTotalEmp + rsCP.MontoAg >
					</cfif>
				</cfloop>
				<td align="right" bgcolor="##CCCCCC" >#LSCurrencyFormat(vTotalEmp,'none')#</td>
                <cfif LvarMostrarColDolar>
					<td align="right" bgcolor="##CCCCCC" >#LSCurrencyFormat(vTotalEmp/LvarTipoCambio,'none')#</td>
				</cfif>
				<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotalEmp/12,'none')#</td>
                <cfif LvarMostrarColDolar>
					<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat((vTotalEmp/LvarTipoCambio)/12,'none')#</td>
				</cfif>
			</tr>
			<cfset vTotales = vTotales + vTotalEmp>
			<cfset vTotalesA = vTotalesA + vTotalEmp/12>
		</cfoutput>

		<cfoutput>
			<tr style="font-weight:bold;">
				<td bgcolor="##CCCCCC">#LB_Totales#</td>
				<cfloop query="columnas" group="CPcodigo">
					<cfquery name="rsCP2" dbtype="query">
						select distinct *
						from rsReporte
						where codigo = '#trim(CPcodigo)#'
					</cfquery>
					<cfquery name="rsCP" dbtype="query">
						select codigo, sum(MontoAg) as TotalCP
						from rsCP2
						where codigo = '#trim(CPcodigo)#'
						group by codigo
					</cfquery>
					<td align="right" bgcolor="##CCCCCC">
						<cfif rsCP.RecordCount GT 0>#LSCurrencyFormat(rsCP.TotalCP,'none')#<cfelse><div align="center">-</div></cfif>					
					</td>
				</cfloop>
				<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotales,'none')#</td>
                <cfif LvarMostrarColDolar>
					<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotales/LvarTipoCambio,'none')#</td>
				</cfif>
				<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotalesA,'none')#</td>
                <cfif LvarMostrarColDolar>
					<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotalesA/LvarTipoCambio,'none')#</td>
				</cfif>
			</tr>
		</cfoutput>
	</table>

	<!--- CORTE POR CENTRO FUNCIONAL/EMEPLADO --->
    <cfelseif url.Corte EQ '1'>
	
		<!--- ENCABEZADO --->
		<cfset vColspan = columnas.RecordCount + 3>
		<cfquery name="rsTipoNomina" datasource="#session.DSN#">
			select Tdescripcion
			from TiposNomina
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			  and Tcodigo in( <cfqueryparam cfsqltype="cf_sql_char"  list="yes" value="#url.ListaTipoNomina1#">)
		</cfquery>
		
        <cf_HeadReport
            Titulo="#Trim(LB_ReporteDeAquinaldoPorEmpleadoYCentroFuncional)#"
            Color="##E3EDEF"
            addTitulo1="#LB_Corp#"
            filtro1="#LB_FechaDesde#: #url.Fdesde#  #LB_FechaHasta#: #url.Fhasta#"	
            filtro2="#LB_ParaNomina#: #valueList(rsTipoNomina.Tdescripcion)#"
            filtro3="#filtro3#"
            showline="false">
           
		<cfset vTotal = 0>
		<cfset vTotalCF = 0>
		<cfset vTotales_1 = 0>
		<cfset vTotales = 0>
		<cfset vTotalesEmpl = 0>	
		
        <table width="100%" class="reporte">
		<cfoutput query="rsReporte" group="CFid">
			<cfset vCFid = rsReporte.CFid>
			<cfset cont=0>
			<tr ><td colspan="<cfoutput>#vColspan#</cfoutput>"nowrap><strong>#LB_CentroFuncional#&nbsp;:&nbsp;#CFdescripcion#</strong></td></tr>
			<!--- TITULOS --->
		  	<thead style="display: table-header-group">
    	    <tr bgcolor="##CCCCCC" >
				<td nowrap ><span class="style5"><strong>#LB_Nombre#</strong></span></td>
				<cfloop query="columnas" group="CPcodigo">
					<td align="right" nowrap ><span class="style5"><strong>#CPcodigo#</strong></span></td>
				</cfloop>
                <td align="right" ><span class="style5"><strong>#LB_Total#</strong></span></td>
		 	  	<cfif LvarMostrarColDolar>
				<td align="right"><span class="style5"><strong>#LB_Total# $</strong></span></td>
				</cfif>
                <td align="right" nowrap><span class="style5"><strong>#LB_Aguinaldo#</span></strong></td>	
               	<cfif LvarMostrarColDolar>
                    <td align="right" nowrap><span class="style5"><strong>#LB_Aguinaldo# $</strong></span></td>
                </cfif>	
		  	</tr>
            </thead>
			<cfoutput group="DEid">
				<cfset vDEid = rsReporte.DEid>
				<cfset vTotalEmp = 0>
				<cfset cont = cont +1>
				<cfquery name="rsTotal" dbtype="query">
					select sum(MontoAg) as Total
					from rsReporte
					where DEid = #vDEid#
					  and CFid = #vCFid#
				</cfquery>
				<!---<cfset vTotalEmp = rsTotal.Total>--->
				<cfset vTotalEmp = 0>
				<cfset vTotal = vTotal + vTotalEmp>
				<tr <cfif not cont MOD 2>bgcolor="##E2E2E2"<cfelse>bgcolor="##E4E4E4"</cfif>>
					<td nowrap>#Ucase(Nombre)#</td>
					<cfloop query="columnas" group="CPcodigo">
		
						<cfquery name="rsCP" dbtype="query">
							select sum(MontoAg) as MontoAg
							from rsReporte
							where DEid = #vDEid#
							  and codigo = '#trim(CPcodigo)#'
							  and CFid = #vCFid#
						</cfquery>
						<td align="right">
							<cfif rsCP.RecordCount GT 0>#LSCurrencyFormat(rsCP.MontoAg,'none')#<cfelse><div align="center">-</div></cfif>						
						</td>
						<cfif len(trim(rsCP.MontoAg))>
							<cfset vTotalEmp = vTotalEmp + rsCP.MontoAg >
						</cfif>
					</cfloop>
					<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotalEmp,'none')#</td>
                    <cfif LvarMostrarColDolar>
						<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotalEmp/LvarTipoCambio,'none')#</td>
					</cfif>
					<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotalEmp/12,'none')#</td>
                   <cfif LvarMostrarColDolar>
						<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat((vTotalEmp/LvarTipoCambio)/12,'none')#</td>
					</cfif>
					
				</tr>
				<cfset vTotales = vTotales + vTotalEmp>
				<cfset vTotalCF = VTotalCF + vTotalEmp>
				<cfset vTotalesEmpl = vTotalesEmpl + (vTotalEmp/12)>	
			</cfoutput>

			<!--- datos --->
			<tr style="font-weight:bold;">
				<td bgcolor="##CCCCCC">#LB_Subtotal# #CFdescripcion#</td>
				<cfloop query="columnas" group="CPcodigo">
					<cfquery name="rsCP2" dbtype="query">
						select distinct *
						from rsReporte
						where codigo = '#trim(CPcodigo)#'
						  and CFid = #vCFid#
					</cfquery>
					<cfquery name="rsCP" dbtype="query">
						select sum(MontoAg) as TotalCP
						from rsCP2
						where codigo = '#trim(CPcodigo)#'
						  and CFid = #vCFid#
					</cfquery>
					<td align="right" bgcolor="##CCCCCC">
						<cfif rsCP.RecordCount GT 0>#LSCurrencyFormat(rsCP.TotalCP,'none')#<cfelse><div align="center">-</div></cfif>
					</td>
				</cfloop>
				<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotalCF,'none')#</td>
                <cfif LvarMostrarColDolar>
					<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotalCF/LvarTipoCambio,'none')#</td>
				</cfif>
				<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotalCF/12,'none')#</td>	
                <cfif LvarMostrarColDolar>
					<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat((vTotalCF/LvarTipoCambio)/12,'none')#</td>		
				</cfif>			
			</tr>
			<tr><td colspan="<cfoutput>#vColspan#</cfoutput>">&nbsp;</td></tr>
			<cfset vTotalCF = 0>
		</cfoutput>
		<cfoutput>

		<!--- linea de totales--->
		<tr style="font-weight:bold;" bgcolor="##CCCCCC">
			<td>#LB_Totales#</td>
			<cfloop query="columnas" group="CPcodigo">
				<cfquery name="rsCP2" dbtype="query">
					select distinct *
					from rsReporte
					where codigo = '#trim(CPcodigo)#'
				</cfquery>

				<cfquery name="rsCP" dbtype="query">
					select sum(MontoAg) as TotalCP
					from rsCP2
					where codigo = '#trim(CPcodigo)#'
				</cfquery>
				<td align="right">
					<cfif rsCP.RecordCount GT 0>#LSCurrencyFormat(rsCP.TotalCP,'none')#<cfelse><div align="center">-</div></cfif>
				</td>
			</cfloop>
			<td align="right">#LSCurrencyFormat(vTotales,'none')#</td>
            <cfif LvarMostrarColDolar>
				<td align="right">#LSCurrencyFormat(vTotales/LvarTipoCambio,'none')#</td>
			</cfif>
			<td align="right">#LSCurrencyFormat(vTotales/12,'none')#</td>
            <cfif LvarMostrarColDolar>
				<td align="right">#LSCurrencyFormat((vTotales/LvarTipoCambio)/12,'none')#</td>
			</cfif>
		</tr>
		</cfoutput>
	</table>

	<!--- CORTE POR CENTRO FUNCIONAL --->
    <cfelseif url.Corte EQ '2'>
		<!--- ENCABEZADO --->
		<cfset vColspan = columnas.RecordCount + 3>
		<cfquery name="rsTipoNomina" datasource="#session.DSN#">
			select Tdescripcion
			from TiposNomina
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			  and Tcodigo in (<cfqueryparam cfsqltype="cf_sql_char" value="#url.ListaTipoNomina1#" list="yes">)
		</cfquery>
		
        <cf_HeadReport
            Titulo="#Trim(LB_ReporteDeAquinaldoPorCentroFuncional)#"
            Color="##E3EDEF"
            filtro1="#LB_FechaDesde#: #url.Fdesde#  #LB_FechaHasta#: #url.Fhasta#"	
            filtro2="#LB_ParaNomina#: #rsTipoNomina.Tdescripcion#"
            filtro3="#filtro3#"
            showline="false">
									
		
	  <!--- TITULOS --->
	  <table width="100%" class="reporte">
		<thead style="display: table-header-group">
    	<tr bgcolor="#CCCCCC">
			<td bgcolor="#CCCCCC" nowrap="nowrap"><cfoutput><span class="style5"><strong>#LB_CentroFuncional#</strong></span></cfoutput></td>
			<cfoutput query="columnas" group="CPcodigo">
				<td align="right" bgcolor="##CCCCCC"><span class="style5"><strong>#CPcodigo#</strong></span></td>
			</cfoutput>
			<td bgcolor="#CCCCCC" align="right" ><cfoutput><span class="style5"><strong>#LB_Total#</strong></span></cfoutput></td>
            <cfif LvarMostrarColDolar>
            	<td align="right"><cfoutput><span class="style5"><strong>#LB_Total# $</strong></span></cfoutput></td>
            </cfif>
	 	    <td align="right"  bgcolor="#CCCCCC"nowrap><cfoutput><span class="style5"><strong>#LB_Aguinaldo#</span></strong></cfoutput></td>
            <cfif LvarMostrarColDolar>
                <td align="right" nowrap><cfoutput><span class="style5"><strong>#LB_Aguinaldo# $</strong></span></cfoutput></td>
            </cfif>			
	  	</tr>
		</thead>
		<cfset vTotal = 0>
		<cfset vTotalCF = 0>
		<cfset vTotales = 0>
		<cfset vTotalesAgui = 0>
		<cfset cont = 0>
		<cfoutput query="rsReporte" group="CFid">
			<cfset vCFid = rsReporte.CFid>
			<cfset cont = cont +1>
			<tr <cfif not cont MOD 2>bgcolor="##E2E2E2"<cfelse>bgcolor="##E4E4E4"</cfif>>
				<td nowrap>#CFdescripcion#</td>
				<cfloop query="columnas" group="CPcodigo">
					<cfquery name="rsCP" dbtype="query">
						select sum(MontoAg) as TotalCP
						from rsReporte
						where codigo = '#trim(CPcodigo)#'
						  and CFid = #vCFid#
					</cfquery>
				  <cfif rsCP.RecordCount GT 0>
						<cfset vTotalCP = rsCP.TotalCP>
					<cfelse>
						<cfset vTotalCP = 0>
				  </cfif>
					<td align="right">
						<cfif rsCP.RecordCount GT 0>#LSCurrencyFormat(rsCP.TotalCP,'none')#<cfelse><div align="center">-</div></cfif>					</td>
					<cfset vTotal = vTotal + vTotalCP>
				</cfloop>
                <td align="right">#LSCurrencyFormat(vTotal,'none')#</td>
                <cfif LvarMostrarColDolar>
                <td align="right">#LSCurrencyFormat(vTotal/LvarTipoCambio,'none')#</td>
                </cfif>
               	<td align="right">#LSCurrencyFormat(vTotal/12,'none')#</td>		
                <cfif LvarMostrarColDolar>
                    <td align="right">#LSCurrencyFormat((vTotal/LvarTipoCambio)/12,'none')#</td>
                </cfif>
				
						
				<cfset vTotales = vTotales + vTotal>
				<cfset vTotalesAgui = vTotalesAgui + (vTotal/12)>				
				<cfset vTotal = 0>
			</tr>
		</cfoutput>
		<cfoutput>
		<tr style="font-weight:bold;">
			<td bgcolor="##CCCCCC">#LB_Totales#</td>
			<cfloop query="columnas" group="CPcodigo">
				<cfquery name="rsCP" dbtype="query">
					select sum(MontoAg) as TotalCP
					from rsReporte
					where codigo = '#trim(CPcodigo)#'
				</cfquery>
				<td align="right" bgcolor="##CCCCCC">
					<cfif rsCP.RecordCount GT 0>#LSCurrencyFormat(rsCP.TotalCP,'none')#<cfelse><div align="center">-</div></cfif>				</td>
			</cfloop>
			<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotales,'none')#</td>
            <cfif LvarMostrarColDolar>
                <td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotales/LvarTipoCambio,'none')#</td>
            </cfif>
			<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotalesAgui,'none')#</td>
            <cfif LvarMostrarColDolar>
				<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotalesAgui/LvarTipoCambio,'none')#</td>
			</cfif>
			
		</tr>
		</cfoutput>
	</table>	
	</cfif>	

</body> 
</html>	