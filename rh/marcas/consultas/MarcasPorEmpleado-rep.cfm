ï»¿<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_ReporteDeMarcasPorEmpleado" Default="Reporte de Marcas por Empleado" returnvariable="LB_ReporteDeMarcasPorEmpleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_NoHayDatosRelacionados" Default="No hay datos relacionados" returnvariable="LB_NoHayDatosRelacionados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Fecha" Default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaDesde" Default="Fecha Desde" returnvariable="LB_FechaDesde" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaHasta" Default="Fecha Hasta" returnvariable="LB_FechaHasta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Feriado" Default="Feriado" returnvariable="LB_Feriado" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
    <cfquery name="rsReporte" datasource="#session.DSN#" >
			select 	/*ojo si se modifica el orden de las columnas, modifcar el order by*/
				e.LTsalario,
                {fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )},  ' ' )}, b.DEnombre)} as Empleado, 
                b.DEidentificacion,b.DEid,g.CFid,
                a.CAMfdesde, a.CAMfhasta, a.CAMid,a.CAMpermiso,
                case when a.RHJid is not null then 
                    c.RHJdescripcion
                else
                    '#LB_Feriado#'
                end as Jornada,
                coalesce(round(<cf_dbfunction name="to_float" args="coalesce(a.CAMtotminutos,1)">/60.00, 2),0) as HT,
                coalesce(round(<cf_dbfunction name="to_float" args="coalesce(a.CAMociominutos,1)">/60.00, 2),0) as HO,
                coalesce(round(<cf_dbfunction name="to_float" args="coalesce(a.CAMtotminlab,1)">/60.00, 2),0) as HL,
                coalesce(a.CAMsuphorasreb,0) as HR,
                coalesce(a.CAMsuphorasjornada,0) as HN,
                coalesce(a.CAMsuphorasextA,0) as HEA,
                coalesce(a.CAMsuphorasextB,0) as HEB,
                coalesce(a.CAMsupmontoferiado,0) as MFeriado,
                case a.CAMpermiso
                when 1 then a.CAMid
                else null end as inactivecol,
                case a.CAMpermiso
                when 1 then '<img src=/cfmx/rh/imagenes/w-check.gif>'
                else '' end as permiso,
                g.Dcodigo
        from RHCMCalculoAcumMarcas a
        inner join LineaTiempo e
				on  a.Ecodigo  = e.Ecodigo
				and a.DEid     = e.DEid  
				and 	((({fn YEAR(a.CAMfdesde)} * 100 + {fn MONTH(a.CAMfdesde)} ) * 100 ) + {fn DAYOFMONTH(a.CAMfdesde)})  
				>=     ((({fn YEAR(e.LTdesde)} * 100   + {fn MONTH(e.LTdesde)}   ) * 100 ) + {fn DAYOFMONTH(e.LTdesde)})    
				
				and 	((({fn YEAR(a.CAMfdesde)} * 100 + {fn MONTH(a.CAMfdesde)} ) * 100 ) + {fn DAYOFMONTH(a.CAMfdesde)})  
				<=     ((({fn YEAR(e.LThasta)} * 100   + {fn MONTH(e.LThasta)}   ) * 100 ) + {fn DAYOFMONTH(e.LThasta)})  
				 
			inner join RHPlazas f
				on e.RHPid = f.RHPid
                <cfif isdefined('url.CFid')>
				and f.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
				</cfif>
			inner join CFuncional g
				on  f.Ecodigo  = g.Ecodigo
				and f.CFid = g.CFid
                <cfif isdefined('url.Dcodigo') and url.Dcodigo GT 0>
                    and g.Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Dcodigo#">
                </cfif>
                
            inner join DatosEmpleado b
                on a.DEid = b.DEid
                and a.Ecodigo = b.Ecodigo
            left outer join RHJornadas c
                on a.RHJid = c.RHJid
                and a.Ecodigo = c.Ecodigo
                <cfif isdefined('url.RHJid')>
				and c.RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHJid#">
				</cfif>
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            <!--- and a.CAMestado = 'A' --->
            <cfif isdefined("url.RHJid") and len(trim(url.RHJid))>
                and a.RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHJid#">
            </cfif>
            <cfif isdefined('url.DEid') and not isdefined('url.CFid') and not isdefined('url.Dcodigo') and not isdefined('url.Ocodigo')>
                and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
            </cfif>
            <cfif isdefined("url.Fdesde") and len(trim(url.Fdesde)) and isdefined("url.Fhasta") and len(trim(url.Fhasta))>
                <cfif url.Fdesde GT url.Fhasta>
                    and <cf_dbfunction name="date_format" args="a.CAMfdesde,yyyymmdd"> 
                        between <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(url.Fhasta),'yyyymmdd')#">
                        and  <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(url.Fdesde),'yyyymmdd')#">
                <cfelseif url.Fhasta GT url.Fdesde>
                    and <cf_dbfunction name="date_format" args="a.CAMfdesde,yyyymmdd"> 
                        between <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(url.Fdesde),'yyyymmdd')#">
                        and <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(url.Fhasta),'yyyymmdd')#">
                <cfelse>
                    and <cf_dbfunction name="date_format" args="a.CAMfdesde,yyyymmdd"> = <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(url.Fdesde),'yyyymmdd')#">
                </cfif>
            <cfelseif isdefined("url.Fdesde") and len(trim(url.Fdesde)) and (not isdefined("url.Fhasta") or  len(trim(url.Fhasta)) EQ 0)>
                and <cf_dbfunction name="date_format" args="a.CAMfdesde,yyyymmdd"> >= <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(url.Fdesde),'yyyymmdd')#">
            <cfelseif isdefined("url.Fhasta") and len(trim(url.Fhasta)) and (not isdefined("url.Fdesde") or  len(trim(url.Fdesde)) EQ 0)>
                and <cf_dbfunction name="date_format" args="a.CAMfdesde,yyyymmdd"> <= <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(url.Fdesde),'yyyymmdd')#">
            </cfif>	
        order by b.DEidentificacion, CAMfdesde
	</cfquery>

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
		font-size:15px;
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
        <tr><td align="center" colspan="4" class="titulo_empresa2"><strong>#rsEmpresa.Edescripcion#</strong></td></tr>
        <tr><td align="center" colspan="4" class="titulo_empresa2"><strong>#LB_ReporteDeMarcasPorEmpleado#</strong></td></tr>
        <tr><td align="center" colspan="4" class="titulo_empresa2"><strong>#LB_Fecha#: #LSDateFormat(Now(),'dd/mm/yyyy')#</strong></td></tr>
        <tr><td align="center" colspan="4" class="titulo_empresa2"><strong>#LB_FechaDesde#: #LSDateFormat(url.Fdesde,'dd/mm/yyyy')#&nbsp;&nbsp;#LB_FechaHasta#: #LSDateFormat(url.Fhasta,'dd/mm/yyyy')#</strong></td></tr>
        <tr><td colspan="4">&nbsp;</td></tr>
        </cfoutput>
      	<cfoutput query="rsReporte" group="Dcodigo">
        	<!--- DEPARTAMENTO --->
        	<cfquery name="rsDescDepto" datasource="#session.DSN#" >
            	select Ddescripcion
                from Departamentos
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                  and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsReporte.Dcodigo#">
            </cfquery>
			<tr><td width="100%" height="1" bgcolor="000000" ></td></tr>
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
                    <td>&nbsp;
                  <cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>  	  :&nbsp;#rsCFuncional.CFcodigo# - #rsCFuncional.CFdescripcion#</td>
                </tr>
                <tr><td  width="100%"  height="1" bgcolor="000000"></td>
                </tr>
				<!--- AGRUPADO POR EMPLEADO --->
                <cfset Lvar_TotalRebajadoEmp = 0>
                <cfoutput group="DEid">
                    <tr class="listaCorte2">
                        <td>&nbsp;
                      <cf_translate key="LB_Empleado">Empleado</cf_translate>:&nbsp;&nbsp;#DEidentificacion# - #Empleado#</td>
                    </tr>
                    <tr><td  width="100%"  height="1" bgcolor="000000"></td></tr>
                    <tr>
                        <td>
                            <table width="792" align="center" border="0" cellspacing="0" cellpadding="0">
                                <tr class="listaCorte">
                                    <td width="75" nowrap align="center"><cf_translate key="LB_FechaDesde">Fecha<br>Desde</cf_translate></td>
                                    <td width="75" nowrap align="center"><cf_translate key="LB_FechaHasta">Fecha<br />Hasta</cf_translate></td>
                                    <td width="180" nowrap align="center"><cf_translate key="LB_Jornada">Jornada</cf_translate></td>
									<td width="20" nowrap align="center"><cf_translate key="LB_LTSalario">Salario Contrat.</cf_translate></td>                                    
                                    <td width="40" nowrap align="center"><cf_translate key="LB_HT">HT</cf_translate></td>
                                    <td width="40" nowrap align="center"><cf_translate key="LB_HO">HO</cf_translate></td>
                                    <td width="40" nowrap align="center" ><cf_translate key="LB_HL">HL</cf_translate></td>
                                    <td width="40" nowrap align="center"><cf_translate key="LB_HR">HR</cf_translate></td>
                                    <td width="40" nowrap align="center"><cf_translate key="LB_HN">HN</cf_translate></td>
                                    <td width="40" nowrap align="center"><cf_translate key="LB_HEA">HEA</cf_translate></td>
                                    <td width="40" nowrap align="center"><cf_translate key="LB_HEB">HEB</cf_translate></td>
                                    <td width="42" nowrap align="center"><cf_translate key="LB_MontoFeriado">Monto<br>Feriado</cf_translate></td>
                                    <td width="50" nowrap align="center"><cf_translate key="LB_Permiso">Permiso</cf_translate></td>
                                </tr>
                                <tr><td width="100%" height="1" bgcolor="000000" colspan="12"></td></tr>
                                <cfsilent>
                                	<cfset Lvar_TotalHT = 0>
                                    <cfset Lvar_TotalHO = 0>
                                    <cfset Lvar_TotalHL = 0>
                                    <cfset Lvar_TotalHR = 0>
                                    <cfset Lvar_TotalHN = 0>
                                    <cfset Lvar_TotalHEA = 0>
                                    <cfset Lvar_TotalHEB = 0>
                                    <cfset Lvar_TotalMontoF = 0>
                                </cfsilent>
                                <cfoutput>
                                   	<tr>
                                        <td class="detallec">#LSDateFormat(CAMFdesde,'dd/mm/yyyy')#</td>
                                        <td class="detallec">#LSDateFormat(CAMFhasta,'dd/mm/yyyy')#</td>
                                        <td class="detalle" nowrap="nowrap">&nbsp;#Jornada#</td>
                                        <td class="detallec">&nbsp;#LSCurrencyFormat(LTsalario,'none')#</td>
                                        <td class="detallec">&nbsp;#LSCurrencyFormat(HT,'none')#</td>
                                        <td class="detallec">&nbsp;#LSCurrencyFormat(HO,'none')#</td>
                                        <td class="detallec">&nbsp;#LSCurrencyFormat(HL,'none')#</td>
                                        <td class="detallec">&nbsp;#LSCurrencyFormat(HR,'none')#</td>
                                        <td class="detallec">&nbsp;#LSCurrencyFormat(HN,'none')#</td>
                                        <td class="detallec">&nbsp;#LSCurrencyFormat(HEA,'none')#</td>
                                        <td class="detallec">&nbsp;#LSCurrencyFormat(HEB,'none')#</td>
                                        <td class="detaller">&nbsp;#LSCurrencyFormat(MFeriado,'none')#</td>
                                        <td class="detallec">&nbsp;#Permiso#</td>
                                    </tr>
                                    <cfsilent>
                                    	<cfset Lvar_TotalHT = Lvar_TotalHT + HT>
										<cfset Lvar_TotalHO = Lvar_TotalHO + HO>
										<cfset Lvar_TotalHL = Lvar_TotalHL + HL>
										<cfset Lvar_TotalHR = Lvar_TotalHR + HR>
										<cfset Lvar_TotalHN = Lvar_TotalHN + HN>
										<cfset Lvar_TotalHEA = Lvar_TotalHEA + HEA>
										<cfset Lvar_TotalHEB = Lvar_TotalHEB + HEB>
										<cfset Lvar_TotalMontoF = Lvar_TotalMontoF + MFeriado>
                                    </cfsilent>
                                </cfoutput>
								<tr>
                                	<td colspan="4"></td>
                                	<td height="1" bgcolor="000000" colspan="12"></td>
                                </tr>
                                <tr>
                                    <td class="detalle" colspan="4">&nbsp;</td>
                                    <td class="detallec">&nbsp;<strong>#LSCurrencyFormat(Lvar_TotalHT,'none')#</strong></td>
                                    <td class="detallec">&nbsp;<strong>#LSCurrencyFormat(Lvar_TotalHO,'none')#</strong></td>
                                    <td class="detallec">&nbsp;<strong>#LSCurrencyFormat(Lvar_TotalHL,'none')#</strong></td>
                                    <td class="detallec">&nbsp;<strong>#LSCurrencyFormat(Lvar_TotalHR,'none')#</strong></td>
                                    <td class="detallec">&nbsp;<strong>#LSCurrencyFormat(Lvar_TotalHN,'none')#</strong></td>
                                    <td class="detallec">&nbsp;<strong>#LSCurrencyFormat(Lvar_TotalHEA,'none')#</strong></td>
                                    <td class="detallec">&nbsp;<strong>#LSCurrencyFormat(Lvar_TotalHEB,'none')#</strong></td>
                                    <td class="detaller">&nbsp;<strong>#LSCurrencyFormat(Lvar_TotalMontoF,'none')#</strong></td>
                                    <td class="detallec">&nbsp;</td>
                                </tr>
                                <tr><td colspan="12">&nbsp;</td></tr>
                            </table>
                        </td>
                    </tr>
                </cfoutput><!--- AGRUPADO EMPLEADO --->
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
