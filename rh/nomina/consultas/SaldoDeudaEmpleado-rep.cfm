<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_ReporteDeSaldosDeDeudaPorEmpleado" Default="Reporte de Saldos de Deuda por Empleado" returnvariable="LB_ReporteDeSaldosDeDeudaPorEmpleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_NoHayDatosRelacionados" Default="No hay datos relacionados" returnvariable="LB_NoHayDatosRelacionados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Fecha" Default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cfquery name="rsReporte" datasource="#session.DSN#">
    select de.TDid,TDcodigo, TDdescripcion,d.DEid,d.DEidentificacion,de.Did,de.Ddescripcion,
    	{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})} as nombre,	
        Dmonto, Dsaldo, CPcodigo, cn.RCdesde, cn.RChasta,DCvalor,  sum(DCvalor) as Rebajado,
        cf.Dcodigo,cf.CFid
    from DeduccionesEmpleado de
        inner join LineaTiempo lt
            on de.DEid = lt.DEid
            and getdate() between lt.LTdesde and lt.LThasta
        inner join DatosEmpleado d
            on d.DEid = de.DEid
        inner join TDeduccion td
            on de.TDid = td.TDid
        inner join HDeduccionesCalculo hdc
            on de.Did = hdc.Did
            and de.DEid = hdc.DEid
        inner join HRCalculoNomina cn
            on cn.RCNid = hdc.RCNid
        inner join CalendarioPagos cp
            on cn.RCNid = cp.CPid
        inner join RHPlazas p
            on p.RHPid = lt.RHPid
        <cfif isdefined('url.CFid')>
            and p.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
        </cfif>
        inner join CFuncional cf
            on cf.CFid = p.CFid
    	 <cfif isdefined('url.Dcodigo') and url.Dcodigo GT 0>
            and cf.Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Dcodigo#">
        </cfif>
    where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
      and de.Dcontrolsaldo = 1
      and de.Dsaldo >= 0
     <cfif isdefined('url.DEid') and not isdefined('url.CFid') and not isdefined('url.Dcodigo') and not isdefined('url.Ocodigo')>
      and de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
     </cfif>
	<cfif isdefined('url.TDidDesde') and  isdefined('url.TDidHasta')>
      and de.TDid between  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TDidDesde#"> and  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TDidHasta#">
	<cfelseif isdefined('url.TDidDesde') >  
	   and de.TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TDidDesde#"> 
    </cfif>
        and de.Dactivo = 1

    group by  de.TDid,d.DEid,de.Did,TDcodigo, TDdescripcion,d.DEidentificacion,de.Ddescripcion,
    {fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})},	
        Dmonto, Dsaldo, CPcodigo, cn.RCdesde, cn.RChasta,DCvalor,cf.Dcodigo,cf.CFid
    order by cf.Dcodigo, cf.CFid,d.DEidentificacion,de.TDid,cn.RCdesde
</cfquery>

<!---<cf_dump var="#rsReporte#">--->

<!--- Busca el nombre de la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>


<style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.tituloAlterno {
		font-size:20px;
		font-weight:bold;
		text-align:center;}
	.titulo_empresa2 {
		font-size:18px;
		font-weight:bold;
		text-align:center;}
	.titulo_reporte {
		font-size:16px;
		font-style:italic;
		text-align:center;}
	.titulo_filtro {
		font-size:14px;
		font-style:italic;
		text-align:center;}
	.titulolistas {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		}
	.titulo_columnar {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:right;}
	.listaCorte {
		font-size:15px;
		font-weight:bold;
		background-color: #F4F4F4;
		text-align:left;}
	.listaCorte3 {
		font-size:15px;
		font-weight:bold;
		background-color:  #E8E8E8;
		text-align:left;}
	.listaCorte2 {
		font-size:15px;
		font-weight:bold;
		background-color: #D8D8D8;
		text-align:left;}
	.listaCorte1 {
		font-size:16px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:left;}
	.total {
		font-size:14px;
		font-weight:bold;
		background-color:#C5C5C5;
		text-align:right;}

	.detalle {
		font-size:15px;
		text-align:left;}
	.detaller {
		font-size:15px;
		text-align:right;}
	.detallec {
		font-size:15x;
		text-align:center;}	
		
	.mensaje {
		font-size:14px;
		text-align:center;}
	.paginacion {
		font-size:14px;
		text-align:center;}
</style>

<cfif rsReporte.RecordCount>
    <table width="792" align="center" border="0" cellspacing="0" cellpadding="2">
        <cfoutput>
        <tr>
			<td colspan="4">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr><td>
						<cf_EncReporte
							Titulo="#LB_ReporteDeSaldosDeDeudaPorEmpleado#"
							Color="##E3EDEF"
						>
					</td></tr>
				</table>
			</td>
		</tr>		
        </cfoutput>
      	<cfoutput query="rsReporte" group="Dcodigo">
        	<!--- DEPARTAMENTO --->
        	<cfquery name="rsDescDepto" datasource="#session.DSN#" >
            	select Ddescripcion
                from Departamentos
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                  and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsReporte.Dcodigo#">
            </cfquery>
        	<tr class="listaCorte1">
                <td >&nbsp;
              <cf_translate key="LB_Departamento">Departamento</cf_translate>  	  :&nbsp;#Dcodigo# - #rsDescDepto.Ddescripcion#</td>
            </tr>
            <tr><td height="1" bgcolor="000000"></td>
     		<cfoutput group="CFid">
            	<cfset Lvar_CFid = CFid>
            	<!--- CENTRO FUNCIONAL --->
            	<cfquery name="rsCFuncional" datasource="#session.DSN#">
                	select  CFcodigo, CFdescripcion
                    from CFuncional
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                      and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CFid#">
                </cfquery>
            	<tr class=	"listaCorte1">
                    <td >&nbsp;
                  <cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>  	  :&nbsp;#rsCFuncional.CFcodigo# - #rsCFuncional.CFdescripcion#</td>
                </tr>
                <tr><td height="1" bgcolor="000000"></td>
				<cfoutput  group="TDid">
                <!--- TIPO DE DEDUCCION --->
                <tr class="listaCorte1">
                    <td >&nbsp;
                  <cf_translate key="LB_TipoDeDeduccion">Tipo de Deducci&oacute;n</cf_translate>  	  :&nbsp;#TDcodigo# - #TDdescripcion#</td>
                </tr>
                <tr><td height="1" bgcolor="000000"></td>
                </tr>
                    <!--- AGRUPADO POR EMPLEADO --->
					<cfset Lvar_TotalRebajadoEmp = 0>
                    <cfoutput group="DEid">
                        <tr class="listaCorte2">
                            <td>&nbsp;
                          <cf_translate key="LB_Empleado">Empleado</cf_translate>:&nbsp;&nbsp;#DEidentificacion# - #nombre#</td>
                        </tr>
                        <tr><td height="1" bgcolor="000000" colspan="2"></td>
                        </tr>
                        <!--- AGRUPADO POR DEDUCCION --->
                        <cfoutput group="Did">
                            <cfquery name="rsMontoRebajado" dbtype="query">
                                select sum(DCvalor) as monto
                                from rsReporte
                                where DEid = #DEid#
                                  and Did = #Did#
                            </cfquery>
                            <cfset Lvar_TotalRebajadoEmp = Lvar_TotalRebajadoEmp + rsMontoRebajado.monto>
                          <tr><td class="listaCorte3">&nbsp;&nbsp;#Ddescripcion#</td></tr>
                          <tr><td height="1" bgcolor="000000"></td>
                          </tr>
                            <tr>
                                <td>
                                    <table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
                                        <tr class="listaCorte">
                                            <td>&nbsp;<cf_translate key="LB_MontoDeLaDeuda">Monto de la Deuda: #LSCurrencyFormat(Dmonto,'none')#</cf_translate></td>
                                            <td>&nbsp;<cf_translate key="LB_MontoRebajado">Monto Rebajado: #LSCurrencyFormat(rsMontoRebajado.monto,'none')#</cf_translate></td>
                                            <td colspan="2">&nbsp;<cf_translate key="LB_MontoPendienteARebajar">Monto Pendiente a Rebajar: #LSCurrencyFormat(Dsaldo,'none')#</cf_translate></td>
                                        </tr>
                                        <tr class="listaCorte">
                                            <td>&nbsp;<cf_translate key="LB_CalendarioDePago">Calendario de Pago</cf_translate></td>
                                            <td>&nbsp;<cf_translate key="LB_FechaDeInicio">Fecha de Inicio</cf_translate></td>
                                            <td>&nbsp;<cf_translate key="LB_FechaFinal">Fecha Final</cf_translate></td>
                                            <td class="detaller">&nbsp;<cf_translate key="LB_MontoRebajado">Monto Rebajado</cf_translate></td>
                                        </tr>
                                        <tr><td width="100%" height="1" bgcolor="000000" colspan="4"></td></tr>
                                        <cfoutput>
                                            <tr>
                                                <td class="detalle">&nbsp;#CPcodigo#</td>
                                                <td class="detalle">&nbsp;#LSDateFormat(RCdesde,'dd/mm/yyyy')#</td>
                                                <td class="detalle">&nbsp;#LSDateFormat(RChasta,'dd/mm/yyyy')#</td>
                                              <td class="detaller">#LSCurrencyFormat(DCvalor,'none')#</td>
                                            </tr>
                                        </cfoutput>
                                    </table>
                                </td>
                            </tr>
                        </cfoutput>
                        <!--- TOTAL POR EMPLEADO POR DEDUCCION --->
                        <tr><td height="1" bgcolor="000000"></td>
                        <tr class="listaCorte">
                            <td class="detaller">Total Rebajado:&nbsp;&nbsp;&nbsp;#LSCurrencyFormat(Lvar_TotalRebajadoEmp,'none')#</td>
                        </tr>
                        <tr><td>&nbsp;</td></tr>
                    </cfoutput><!--- AGRUPADO EMPLEADO --->
                </cfoutput><!--- AGRUPADO DEDUCCION --->
        	</cfoutput><!--- AGRUPADO CENTRO FUNCIONAL --->
    	</cfoutput><!--- AGRUPADO DEPARTAMENTO --->
    </table>
<cfelse>
	 <table width="792" align="center" border="0" cellspacing="0" cellpadding="2">
     	<cfoutput>
        <tr><td align="center"class="titulo_empresa2"><strong>#LB_NoHayDatosRelacionados#</strong></td></tr>
        </cfoutput>
	</table>
</cfif>