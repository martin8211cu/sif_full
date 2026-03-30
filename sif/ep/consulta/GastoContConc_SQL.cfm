<!--- 
	Creado por E. Raúl Bravo Gómez
		Fecha: 08-01-2013.
	Reporte Concentrado de Gastos Contables
 --->
<!--- <cf_dump var = #url#>--->
<cfoutput>
<cfif isdefined("url.mes") and not isdefined("form.mes")>
	<cfparam name="form.mes" default="#url.mes#"></cfif>
<cfif isdefined("url.periodo") and not isdefined("form.periodo")>
	<cfparam name="form.periodo" default="#url.periodo#"></cfif>    
<cfif isdefined("url.TipoFormato") and not isdefined("form.TipoFormato")>
	<cfparam name="form.TipoFormato" default="#url.TipoFormato#"></cfif>
<cfif isdefined("url.TGasto") and not isdefined("form.TGasto")>
	<cfparam name="form.TGasto" default="#url.TGasto#"></cfif>         
</cfoutput>

<cfif form.periodo lt year(NOW())>
	<cfif form.mes eq 12>
    	<cfset nextm = 1>
    <cfelse>
    	<cfset nextm = form.mes+1>    
    </cfif>
	<cfset LabelFechaFin = #DateFormat(CreateDate(form.periodo,#nextm#,01)-1,"dd/mm/yyyy")#>
<cfelse>
	<cfif form.mes lt month(NOW())>
    	<cfset LabelFechaFin = #DateFormat(CreateDate(form.periodo,form.mes+1,01)-1,"dd/mm/yyyy")#>
    <cfelse>
        <cfset LabelFechaFin = #DateFormat(CreateDate(year(NOW()),month(NOW()),day(NOW())),"dd/mm/yyyy")#>
    </cfif>
</cfif>

<cfinvoke key="MSG_Titulo" default="Concentrado de Gastos Contables"	returnvariable="MSG_Titulo"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="CMB_Enero" 			default="Enero" 			returnvariable="CMB_Enero" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Febrero" 		default="Febrero"			returnvariable="CMB_Febrero"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Marzo" 			default="Marzo" 			returnvariable="CMB_Marzo" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Abril" 			default="Abril"				returnvariable="CMB_Abril"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Mayo" 			default="Mayo"				returnvariable="CMB_Mayo"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Junio" 			default="Junio" 			returnvariable="CMB_Junio" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Julio" 			default="Julio"				returnvariable="CMB_Julio"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Agosto" 			default="Agosto" 			returnvariable="CMB_Agosto" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Setiembre"		default="Setiembre"			returnvariable="CMB_Setiembre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Octubre" 		default="Octubre"			returnvariable="CMB_Octubre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Noviembre" 		default="Noviembre" 		returnvariable="CMB_Noviembre" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Diciembre" 		default="Diciembre"			returnvariable="CMB_Diciembre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>

<cfset LvarIrA = 'GastoContConc.cfm'>
<cfset LvarFile = 'GastoContConc'>
<cfset Request.LvarTitle = #MSG_Titulo#>

<cfoutput>
    <cfswitch expression="#form.mes#">
        <cfcase value="1"><cfset strMesI = "#CMB_Enero#"></cfcase>
        <cfcase value="2"><cfset strMesI = "#CMB_Febrero#"></cfcase>
        <cfcase value="3"><cfset strMesI = "#CMB_Marzo#"></cfcase>
        <cfcase value="4"><cfset strMesI = "#CMB_Abril#"></cfcase>
        <cfcase value="5"><cfset strMesI = "#CMB_Mayo#"></cfcase>
        <cfcase value="6"><cfset strMesI = "#CMB_Junio#"></cfcase>
        <cfcase value="7"><cfset strMesI = "#CMB_Julio#"></cfcase>
        <cfcase value="8"><cfset strMesI = "#CMB_Agosto#"></cfcase>
        <cfcase value="9"><cfset strMesI = "#CMB_Setiembre#"></cfcase>
        <cfcase value="10"><cfset strMesI = "#CMB_Octubre#"></cfcase>
        <cfcase value="11"><cfset strMesI = "#CMB_Noviembre#"></cfcase>										
        <cfcase value="12"><cfset strMesI = "#CMB_Diciembre#"></cfcase>
    </cfswitch>
    <cfset varMes = #form.mes#>
    <cfset varPeriodo = "#form.periodo#">
    <cfif varMes eq 1>
    	<cfset varMes = 12>
        <cfset varPeriodo = "#form.periodo#"-1>
    <cfelse>
    	<cfset varMes = #varMes#-1>
    </cfif>
    <cfswitch expression="#varMes#">
        <cfcase value="1"><cfset strMesF = "#CMB_Enero#"></cfcase>
        <cfcase value="2"><cfset strMesF = "#CMB_Febrero#"></cfcase>
        <cfcase value="3"><cfset strMesF = "#CMB_Marzo#"></cfcase>
        <cfcase value="4"><cfset strMesF = "#CMB_Abril#"></cfcase>
        <cfcase value="5"><cfset strMesF = "#CMB_Mayo#"></cfcase>
        <cfcase value="6"><cfset strMesF = "#CMB_Junio#"></cfcase>
        <cfcase value="7"><cfset strMesF= "#CMB_Julio#"></cfcase>
        <cfcase value="8"><cfset strMesF = "#CMB_Agosto#"></cfcase>
        <cfcase value="9"><cfset strMesF = "#CMB_Setiembre#"></cfcase>
        <cfcase value="10"><cfset strMesF = "#CMB_Octubre#"></cfcase>
        <cfcase value="11"><cfset strMesF = "#CMB_Noviembre#"></cfcase>										
        <cfcase value="12"><cfset strMesF = "#CMB_Diciembre#"></cfcase>
    </cfswitch>
</cfoutput>

<cfquery name="rsNombreEmpresa" datasource="#session.dsn#">
    select e.Edescripcion,e.Mcodigo
    from Empresas e
    where e.Ecodigo = #session.Ecodigo#
</cfquery>

<cfset varCondition = true>
<cfloop condition="varCondition">
    <cfquery name="rsNumEst" datasource="#session.dsn#">
        select r.ID_Estr from CGReEstrProg r where r.SPcodigo='#session.menues.SPCODIGO#'
    </cfquery>
	<cfif rsNumEst.RecordCount neq 0>
    	<cfset varCondition = false> 
	</cfif>
</cfloop>


<cfinvoke returnvariable="rsEPQueryF" component="sif.ep.componentes.EP_EstructuraRep" method="CG_EstructuraSaldo">
	<cfinvokeargument name="IDEstrPro"	value="#rsNumEst.ID_Estr#">
    <cfinvokeargument name="PerInicio" 	value="#form.periodo#">
    <cfinvokeargument name="MesInicio" 	value="#form.mes#">
    <cfinvokeargument name="PerFin" 	value="#form.periodo#">
    <cfinvokeargument name="MesFin" 	value="#form.mes#">
    <cfinvokeargument name="MonedaLoc" 	value="true">
    <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">
</cfinvoke>

<!---<cf_dumptofile select="select * from #rsEPQueryF#">--->

<!---component="sif.ep.componentes.EP_EstruturaRep" --->

<cfinvoke returnvariable="rsEPQueryI" component="sif.ep.componentes.EP_EstructuraRep" method="CG_EstructuraSaldo">
	<cfinvokeargument name="IDEstrPro"	value="#rsNumEst.ID_Estr#">
    <cfinvokeargument name="PerInicio" 	value="#varPeriodo#">
    <cfinvokeargument name="MesInicio" 	value="#varMes#">
    <cfinvokeargument name="PerFin" 	value="#varPeriodo#">
    <cfinvokeargument name="MesFin" 	value="#varMes#">
    <cfinvokeargument name="MonedaLoc" 	value="true">
    <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">    
</cfinvoke>

<!---<cfquery name="RESULT" datasource="#session.dsn#">
	select * from 
    #rsEPQueryF#
</cfquery>
<cf_dump var="#RESULT#">--->

<!---<cf_dumptofile select="select * from #rsEPQueryI#">--->

<cf_dbtemp name="ConcGtos" returnVariable="ConcGtos" datasource="#session.dsn#">
	<cf_dbtempcol name="ID_EstrCtaVal"  type="int">
	<cf_dbtempcol name="Cmayor"  		type="char(4)">
    <cf_dbtempcol name="PCDvalor"    	type="int">
    <cf_dbtempcol name="PCDvalorH"    	type="int">
    <cf_dbtempcol name="MovMesIni" 	 	type="money">
    <cf_dbtempcol name="MovMesFin" 	 	type="money">
    <cf_dbtempcol name="SaldoIni" 	 	type="money">
    <cf_dbtempcol name="SaldoFin" 	 	type="money">
    <cf_dbtempcol name="SoloHijo"    	type="int">
</cf_dbtemp>

<cfquery datasource="#session.dsn#">
	insert into #ConcGtos# (ID_EstrCtaVal,PCDvalor,PCDvalorH,SoloHijo)
        select c.ID_EstrCtaVal,
         coalesce(d.PCDcatid,0), coalesce(cgdd.PCDcatidref,0),c.SoloHijos 
        from CGEstrProgVal c
        left join CGReEstrProg r
            on r.ID_Estr=c.ID_Estr
        left join CGDEstrProgVal d
        on d.ID_EstrCtaVal=c.ID_EstrCtaVal
        left join CGDDetEProgVal cgdd
        on d.ID_DEstrCtaVal= cgdd.ID_DEstrCtaVal
        where r.SPcodigo='#session.menues.SPCODIGO#'
</cfquery>
<!----Actualizar saldos ----->
<cfquery datasource="#session.DSN#" name="CG">
	select * from #ConcGtos#
    order by ID_EstrCtaVal,PCDvalor,PCDvalorH
</cfquery>

<cfquery datasource="#session.DSN#" name="TpoGast5111">
    select distinct cc.PCCDclaid, cd.PCCDvalor from PCECatalogo e
    inner join PCDCatalogoCuenta c on e.PCEcatid = c.PCEcatid
    inner join PCDClasificacionCatalogo cc on c.PCDcatid = cc.PCDcatid
    inner join PCClasificacionD cd on cd.PCCEclaid = cc.PCCEclaid and cc.PCCDclaid = cd.PCCDclaid
    where c.PCEcatid = (
    select ep.PCEcatidClasificado from CGEstrProg ep
            inner join CGReEstrProg r
            on ep.ID_Estr= r.ID_Estr
                where r.SPcodigo='#session.menues.SPCODIGO#') 
<cfif isdefined('form.TGasto') and form.TGasto neq 'T'>
    and cc.PCCDclaid = #form.TGasto#               	
</cfif>    
</cfquery>


<cfloop query="CG">
<cfset SH = #CG.SoloHijo#>

<cfquery datasource="#session.dsn#">
	update #ConcGtos#
    set 
    MovMesIni =(select sum(coalesce(DLdebitos, 0.00)-coalesce(CLcreditos, 0.00)) from #rsEPQueryI#
                where #rsEPQueryI#.ID_EstrCtaVal=#ConcGtos#.ID_EstrCtaVal and
                        #rsEPQueryI#.PCDcatid=#ConcGtos#.PCDvalor
                        <cfif SH eq 1>
                            and #rsEPQueryI#.PCDcatidH = #CG.PCDvalorH#
                        </cfif>
                        <cfif isdefined('url.CmayorI') and len(url.CmayorI)>
                             and #rsEPQueryI#.Cmayor >= #url.CmayorI#
                        </cfif>
                        <cfif isdefined('url.CmayorF') and len(url.CmayorF)>
                            and #rsEPQueryI#.Cmayor <= #url.CmayorF#
                        </cfif>
                        <cfif isdefined('form.TGasto') and form.TGasto neq 'T'>
                            and ((#rsEPQueryI#.Cmayor <> '5111' and #rsEPQueryI#.ClasCatCon = #form.TGasto#) or 
                                (#rsEPQueryI#.Cmayor = '5111' and substring(#rsEPQueryI#.Cformato,7,3) = '#TpoGast5111.PCCDvalor#'))
                        </cfif>
                       ),                            
	MovMesFin =(select sum(coalesce(DLdebitos, 0.00)-coalesce(CLcreditos, 0.00)) from #rsEPQueryF#
    				where #rsEPQueryF#.ID_EstrCtaVal=#ConcGtos#.ID_EstrCtaVal and
                          #rsEPQueryF#.PCDcatid=#ConcGtos#.PCDvalor
							<cfif SH eq 1>
                                and #rsEPQueryF#.PCDcatidH = #CG.PCDvalorH#
                            </cfif>
							<cfif isdefined('url.CmayorI') and len(url.CmayorI)>
                                 and #rsEPQueryF#.Cmayor >= #url.CmayorI#
                            </cfif>
                            <cfif isdefined('url.CmayorF') and len(url.CmayorF)>
                                and #rsEPQueryF#.Cmayor <= #url.CmayorF#
                            </cfif>
                            <cfif isdefined('form.TGasto') and form.TGasto neq 'T'>
                                and ((#rsEPQueryF#.Cmayor <> '5111' and #rsEPQueryF#.ClasCatCon = #form.TGasto#) or 
                                (#rsEPQueryF#.Cmayor = '5111' and substring(#rsEPQueryF#.Cformato,7,3) = '#TpoGast5111.PCCDvalor#'))
                            </cfif>
                           ),
    SaldoIni =(select sum(coalesce(SLinicial, 0.00)+coalesce(DLdebitos, 0.00)-coalesce(CLcreditos, 0.00)) from #rsEPQueryI#
    				where #rsEPQueryI#.ID_EstrCtaVal=#ConcGtos#.ID_EstrCtaVal and
                          #rsEPQueryI#.PCDcatid=#ConcGtos#.PCDvalor
							<cfif SH eq 1>
                                and #rsEPQueryI#.PCDcatidH = #CG.PCDvalorH#
                            </cfif>
							<cfif isdefined('url.CmayorI') and len(url.CmayorI)>
                                 and #rsEPQueryI#.Cmayor >= #url.CmayorI#
                            </cfif>
                            <cfif isdefined('url.CmayorF') and len(url.CmayorF)>
                                and #rsEPQueryI#.Cmayor <= #url.CmayorF#
                            </cfif>
                            <cfif isdefined('form.TGasto') and form.TGasto neq 'T'>
                                and ((#rsEPQueryI#.Cmayor <> '5111' and #rsEPQueryI#.ClasCatCon = #form.TGasto#) or 
                                (#rsEPQueryI#.Cmayor = '5111' and substring(#rsEPQueryI#.Cformato,7,3) = '#TpoGast5111.PCCDvalor#'))
                            </cfif>
                           ),
    SaldoFin =(select sum(coalesce(SLinicial, 0.00)+coalesce(DLdebitos, 0.00)-coalesce(CLcreditos, 0.00)) from #rsEPQueryF#
    				where #rsEPQueryF#.ID_EstrCtaVal=#ConcGtos#.ID_EstrCtaVal and
                          #rsEPQueryF#.PCDcatid=#ConcGtos#.PCDvalor
							<cfif SH eq 1>
                                and #rsEPQueryF#.PCDcatidH = #CG.PCDvalorH#
                            </cfif>
							<cfif isdefined('url.CmayorI') and len(url.CmayorI)>
                                 and #rsEPQueryF#.Cmayor >= #url.CmayorI#
                            </cfif>
                            <cfif isdefined('url.CmayorF') and len(url.CmayorF)>
                                and #rsEPQueryF#.Cmayor <= #url.CmayorF# 
                            </cfif>
                            <cfif isdefined('form.TGasto') and form.TGasto neq 'T'>
                                and ((#rsEPQueryF#.Cmayor <> '5111' and #rsEPQueryF#.ClasCatCon = #form.TGasto#) or 
                                (#rsEPQueryF#.Cmayor = '5111' and substring(#rsEPQueryF#.Cformato,7,3) = '#TpoGast5111.PCCDvalor#'))
                            </cfif>
                           ) 
	where #ConcGtos#.PCDvalor = #CG.PCDvalor# and  #ConcGtos#.ID_EstrCtaVal = #CG.ID_EstrCtaVal#
		<cfif SH eq 1>
            and #ConcGtos#.PCDvalorH = coalesce(#CG.PCDvalorH#,0)
        </cfif>
</cfquery>

</cfloop>
 
<!---<cf_dumptofile select="select * from #ConcGtos#">--->

<cfif #form.TipoFormato# eq 1>
    <cfquery name="rsdetalle" datasource="#session.dsn#">
        select epv.EPCPcodigo,c.ID_EstrCtaVal,epv.EPCPdescripcion,
        sum(coalesce(c.MovMesIni, 0.00)) as MovMesIni,
        sum(coalesce(c.MovMesFin, 0.00)) as MovMesFin,sum(coalesce(c.SaldoIni, 0.00)) as SaldoIni,
        sum(coalesce(c.SaldoFin, 0.00)) as SaldoFin
        from #ConcGtos# c
        inner join CGEstrProgVal epv
            on epv.ID_EstrCtaVal=c.ID_EstrCtaVal
        left join PCDCatalogo p
                on c.PCDvalor=p.PCDcatid
        where 1=1       
        <cfif isdefined('url.Area') and url.Area neq "T">
            and c.ID_EstrCtaVal = #url.Area#
        </cfif>
        group by epv.EPCPcodigo,c.ID_EstrCtaVal,epv.EPCPdescripcion
        order by epv.EPCPcodigo+100,c.ID_EstrCtaVal
    </cfquery>
<cfelse>		
    <cfquery name="rsdetalle" datasource="#session.dsn#">
        select epv.EPCPcodigo,c.ID_EstrCtaVal,epv.EPCPdescripcion,c.PCDvalor,
        case c.SoloHijo
        when 0 then
        	(select coalesce(PCDdescripcion,'No Parametrizado') from PCDCatalogo p where p.PCDcatid=c.PCDvalor)
        when 1 then
        	(select coalesce(PCDdescripcion,'No Parametrizado') from PCDCatalogo p where p.PCDcatid=c.PCDvalorH)
        end as PCDdescripcion,
        
        coalesce(c.MovMesIni, 0.00) as MovMesIni,
        coalesce(c.MovMesFin, 0.00) as MovMesFin,coalesce(c.SaldoIni, 0.00) as SaldoIni,coalesce(c.SaldoFin, 0.00) as SaldoFin
        from #ConcGtos# c
        inner join CGEstrProgVal epv
            on epv.ID_EstrCtaVal=c.ID_EstrCtaVal
            
<!---        left join PCDCatalogo p
                on c.PCDvalor=p.PCDcatid
--->        
        where 1=1       
        <cfif isdefined('url.Area') and url.Area neq "T">
            and c.ID_EstrCtaVal = #url.Area#
        </cfif>
        order by epv.EPCPcodigo+100
    </cfquery>
</cfif>
<!---<cf_dump var="#rsdetalle#">--->

<cfquery name="rsTotArea" datasource="#session.dsn#">
	select coalesce(c.MovMesIni, 0.00) as MovMesIni,
    coalesce(c.MovMesFin, 0.00) as MovMesFin,coalesce(c.SaldoIni, 0.00) as SaldoIni,coalesce(c.SaldoFin, 0.00) as SaldoFin
    from #ConcGtos# c
</cfquery>

<cfoutput>
	<cf_htmlreportsheaders
		title="#request.LvarTitle#" 
		filename="#LvarFile#-#Session.Usucodigo#.xls" 
		ira="#LvarIrA#"  >
	<cfif not isdefined("btnDownload")>  
		<cf_templatecss>
	</cfif>	
</cfoutput>
<cfflush interval="20">
<cfoutput>
	<style type="text/css" >
		.corte {
			font-weight:bold; 
		}
	</style>
    
	<table width="100%" cellpadding="0" cellspacing="0"  bgcolor="##99CCFF">
		<tr>
			<td style="font-size:16px" align="center" colspan="7">
			<strong>#rsNombreEmpresa.Edescripcion#</strong>	
			</td>
		</tr>
		<tr>
			<td style="font-size:16px" align="center" colspan="7">
				<strong>#MSG_Titulo#</strong>
			</td>
		</tr>
		<tr>
			<td style="font-size:16px" align="center" colspan="7" nowrap="nowrap">
				<strong>Al #LabelFechaFin#</strong>
			</td>
		</tr>
	</table>
	<table width="100%">
    	<tr>
        	<td align="left" colspan="3"><strong>CONCEPTO</strong></td>
            <td align="center"><strong>Movimientos</strong></td>
            <td align="center"><strong>Movimientos</strong></td>
            <td align="center"><strong>Diferencia a</strong></td>
            <td align="center"><strong>Total</strong></td>
            <td align="center"><strong>Total</strong></td>
            <td align="center"><strong>Diferencia</strong></td>            
        </tr>
        <tr>
        	<td colspan="3">&nbsp;</td>
            <td align="center"><strong>#strMesF#</strong></td>
            <td align="center"><strong>#strMesI#</strong></td>
            <td align="center"><strong>Movimientos</strong></td>
            <td align="center"><strong>#strMesF#</strong></td>
            <td align="center"><strong>#strMesI#</strong></td>
            <td align="center"><strong> a Totales</strong></td>            
        </tr>
<!---        <tr>
        	<td colspan="4">&nbsp;</td>
            <td align="center"><strong>del Mes</strong></td>
            <td colspan="2">&nbsp;</td>
            <td align="center"><strong>del Mes</strong></td>            
        </tr>
--->		<cfif #form.TipoFormato# eq 1>
        <!---	<cfdump var =#varMes#>
            <cfdump var =#varPeriodo#>
            <cf_dump var = #url#>
        --->    
			<cfset Tot_MovMesIni   = 0>
            <cfset Tot_MovMesFin   = 0>
            <cfset Tot_DifAnt      = 0>
            <cfset Tot_SaldoMesIni = 0>
            <cfset Tot_SaldoMesFin = 0>
            <cfset Tot_DifAntSaldo = 0>
            <cfloop query="rsdetalle">
                <tr>
                    <td>#rsdetalle.EPCPcodigo#</td>
                    <td>#rsdetalle.EPCPdescripcion#</td>
                    <td colspan="1">&nbsp;</td> 
                    <td nowrap align="right">#numberformat(rsdetalle.MovMesIni, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.MovMesFin, ",9.00")#</td>
                    <td nowrap align="right">#numberformat((rsdetalle.MovMesFin-rsdetalle.MovMesIni), ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.SaldoIni, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.SaldoFin, ",9.00")#</td>
                    <td nowrap align="right">#numberformat((rsdetalle.SaldoFin-rsdetalle.SaldoIni), ",9.00")#</td>
                    <cfset Tot_MovMesIni   = Tot_MovMesIni + #rsdetalle.MovMesIni#>
                    <cfset Tot_MovMesFin   = Tot_MovMesFin + #rsdetalle.MovMesFin#>
                    <cfset Tot_DifAnt      = Tot_DifAnt + (#rsdetalle.MovMesFin#-#rsdetalle.MovMesIni#)>
                    <cfset Tot_SaldoMesIni = Tot_SaldoMesIni + #rsdetalle.SaldoIni#>
                    <cfset Tot_SaldoMesFin = Tot_SaldoMesIni + #rsdetalle.SaldoFin#>
                    <cfset Tot_DifAntSaldo = Tot_DifAntSaldo + (#rsdetalle.SaldoFin#-#rsdetalle.SaldoIni#)>
                </tr>
            </cfloop>
        <cfelse>
        	<cfset vs_Area=''>
            <cfset vs_tot='false'>
			<cfset Tot_Area_MovMesIni = 0>
            <cfset Tot_Area_MovMesFin = 0>
            <cfset Tot_Area_DifAnt    = 0>
            <cfset Tot_Area_SaldoMesIni = 0>
            <cfset Tot_Area_SaldoMesFin = 0>
            <cfset Tot_Area_DifAntSaldo = 0>
			<cfset Tot_MovMesIni   = 0>
            <cfset Tot_MovMesFin   = 0>
            <cfset Tot_DifAnt      = 0>
            <cfset Tot_SaldoMesIni = 0>
            <cfset Tot_SaldoMesFin = 0>
            <cfset Tot_DifAntSaldo = 0>
             
            <cfloop query="rsdetalle">
            	<cfif vs_Area eq '' or vs_Area neq rsdetalle.ID_EstrCtaVal>
					<cfif vs_Area neq ''>
                        <tr>
                            <td colspan="2">&nbsp;</td> 
                            <td>TOTAL</td>
                            <td nowrap align="right">#numberformat(Tot_Area_MovMesIni, ",9.00")#</td>
                            <td nowrap align="right">#numberformat(Tot_Area_MovMesFin, ",9.00")#</td>
                            <td nowrap align="right">#numberformat(Tot_Area_DifAnt, ",9.00")#</td>
                            <td nowrap align="right">#numberformat(Tot_Area_SaldoMesIni, ",9.00")#</td>
                            <td nowrap align="right">#numberformat(Tot_Area_SaldoMesFin, ",9.00")#</td>
                            <td nowrap align="right">#numberformat(Tot_Area_DifAntSaldo, ",9.00")#</td>
                        </tr>
                        
                        <cfset Tot_MovMesIni   = Tot_MovMesIni+Tot_Area_MovMesIni>
                        <cfset Tot_MovMesFin   = Tot_MovMesFin +Tot_Area_MovMesFin>
                        <cfset Tot_DifAnt      = Tot_DifAnt + Tot_Area_DifAnt>
                        <cfset Tot_SaldoMesIni = Tot_SaldoMesIni + Tot_Area_SaldoMesIni>
                        <cfset Tot_SaldoMesFin = Tot_SaldoMesFin + Tot_Area_SaldoMesFin>
                        <cfset Tot_DifAntSaldo = Tot_DifAntSaldo + Tot_Area_DifAntSaldo>
                        <cfif vs_Area neq ''>
                            <cfset Tot_Area_MovMesIni = 0>
                            <cfset Tot_Area_MovMesFin = 0>
                            <cfset Tot_Area_DifAnt    = 0>
                            <cfset Tot_Area_SaldoMesIni = 0>
                            <cfset Tot_Area_SaldoMesFin = 0>
                            <cfset Tot_Area_DifAntSaldo = 0>
                        </cfif>   
                    </cfif>
                    <cfset vs_Area='#rsdetalle.ID_EstrCtaVal#'>
                    <tr>
                        <td>#rsdetalle.EPCPcodigo#</td>
                        <td>#rsdetalle.EPCPdescripcion#</td>
                    </tr>
                </cfif>
                <tr>    
                    <cfif len(rsdetalle.PCDdescripcion)>
                        <td colspan="2">&nbsp;</td> 
                        <td>#rsdetalle.PCDdescripcion#</td>
                        <td nowrap align="right">#numberformat(rsdetalle.MovMesIni, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(rsdetalle.MovMesFin, ",9.00")#</td>
                        <td nowrap align="right">#numberformat((rsdetalle.MovMesFin-rsdetalle.MovMesIni), ",9.00")#</td>
                        <td nowrap align="right">#numberformat(rsdetalle.SaldoIni, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(rsdetalle.SaldoFin, ",9.00")#</td>
                        <td nowrap align="right">#numberformat((rsdetalle.SaldoFin-rsdetalle.SaldoIni), ",9.00")#</td>
                        <cfset Tot_Area_MovMesIni = Tot_Area_MovMesIni + #rsdetalle.MovMesIni#>
                        <cfset Tot_Area_MovMesFin = Tot_Area_MovMesFin + #rsdetalle.MovMesFin#>
                        <cfset Tot_Area_DifAnt    = Tot_Area_DifAnt + (#rsdetalle.MovMesFin#-#rsdetalle.MovMesIni#)>
                        <cfset Tot_Area_SaldoMesIni = Tot_Area_SaldoMesIni + #rsdetalle.SaldoIni#>
                        <cfset Tot_Area_SaldoMesFin = Tot_Area_SaldoMesFin + #rsdetalle.SaldoFin#>
                        <cfset Tot_Area_DifAntSaldo = Tot_Area_DifAntSaldo + (#rsdetalle.SaldoFin#-#rsdetalle.SaldoIni#)>
                    </cfif>
                </tr>
            </cfloop>
            <tr>
                <td colspan="2">&nbsp;</td> 
                <td>TOTAL</td>
                <td nowrap align="right">#numberformat(Tot_Area_MovMesIni, ",9.00")#</td>
                <td nowrap align="right">#numberformat(Tot_Area_MovMesFin, ",9.00")#</td>
                <td nowrap align="right">#numberformat(Tot_Area_DifAnt, ",9.00")#</td>
                <td nowrap align="right">#numberformat(Tot_Area_SaldoMesIni, ",9.00")#</td>
                <td nowrap align="right">#numberformat(Tot_Area_SaldoMesFin, ",9.00")#</td>
                <td nowrap align="right">#numberformat(Tot_Area_DifAntSaldo, ",9.00")#</td>
				<cfset Tot_MovMesIni   = Tot_MovMesIni+Tot_Area_MovMesIni>
                <cfset Tot_MovMesFin   = Tot_MovMesFin +Tot_Area_MovMesFin>
                <cfset Tot_DifAnt      = Tot_DifAnt + Tot_Area_DifAnt>
                <cfset Tot_SaldoMesIni = Tot_SaldoMesIni + Tot_Area_SaldoMesIni>
                <cfset Tot_SaldoMesFin = Tot_SaldoMesFin + Tot_Area_SaldoMesFin>
                <cfset Tot_DifAntSaldo = Tot_DifAntSaldo + Tot_Area_DifAntSaldo>                
            </tr>
        </cfif>
        <tr>
            <td colspan="3">&nbsp;</td> 
            <td nowrap align="right">#numberformat(Tot_MovMesIni, ",9.00")#</td>
            <td nowrap align="right">#numberformat(Tot_MovMesFin, ",9.00")#</td>
            <td nowrap align="right">#numberformat(Tot_DifAnt, ",9.00")#</td>
            <td nowrap align="right">#numberformat(Tot_SaldoMesIni, ",9.00")#</td>
            <td nowrap align="right">#numberformat(Tot_SaldoMesFin, ",9.00")#</td>
            <td nowrap align="right">#numberformat(Tot_DifAntSaldo, ",9.00")#</td>
        </tr>        
    </table>
</cfoutput>