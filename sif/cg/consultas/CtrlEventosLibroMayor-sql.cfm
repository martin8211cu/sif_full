<!---<cfabort showerror="FIN QUERY">--->
<cfif not isdefined("form.corte")> 
	<cfset form.corte = 0>
</cfif>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Libro Mayor" 
returnvariable="LB_Titulo" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default="Fecha" 
returnvariable="LB_Fecha" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Hora" default="Hora" 
returnvariable="LB_Hora" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Periodo" default="Periodo" 
returnvariable="LB_Periodo" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mes" default="Mes" 
returnvariable="LB_Mes" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mlocal" default="Moneda Local" 
returnvariable="LB_Mlocal" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Morigen" default="Moneda Origen" 
returnvariable="LB_Morigen" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Incluye" default="Incluye Eventos Relacionados" 
returnvariable="LB_Incluye" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mayor" default="Cuenta Mayor" 
returnvariable="LB_Mayor" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descrip" default="Descripción" 
returnvariable="LB_Descrip" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Montos" default="Montos" 
returnvariable="LB_Montos" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Evento" default="Evento" 
returnvariable="LB_Evento" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_DesLin" default="Descripción" 
returnvariable="LB_DesLin" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Debito" default="Débitos" 
returnvariable="LB_Debito" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Credito" default="Créditos" 
returnvariable="LB_Credito" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mov" default="Saldo" 
returnvariable="LB_Mov" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Total" default="Gran Total" 
returnvariable="LB_Total" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Pie" default="Fin de la Consulta" 
returnvariable="LB_Pie" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_noreg" default="No se encontraron registros que cumplan los filtros" 
returnvariable="LB_noreg" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_cifras" default="(Cifras en Pesos y Centavos)" 
returnvariable="LB_cifras" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Pagina" default="Pagina" 
returnvariable="LB_Pagina" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TotalPagina" default="Sub-Total" 
returnvariable="LB_TotalPagina" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Desde" default="Desde" 
returnvariable="LB_Desde" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Hasta" default="Hasta" 
returnvariable="LB_Hasta" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>

<!--- Con la finalidad de Paginar se establece una tabla temporal --->
<cf_dbtemp name="CG_LMAYOR_EV" returnvariable="CG_LMAYOR_EV_NAME" datasource="#session.dsn#">
	<cf_dbtempcol name="Pagina"			type="int"				mandatory="yes">
    <cf_dbtempcol name="LineaP"			type="int"				mandatory="yes">
    <cf_dbtempcol name="Cmayor"			type="char(4)"			mandatory="yes">
    <cf_dbtempcol name="Cdescripcion"	type="varchar(80)"		mandatory="yes">
    <cf_dbtempcol name="Efecha"			type="datetime"			mandatory="yes">
    <cf_dbtempcol name="Ddescripcion"	type="varchar(100)"		mandatory="yes">
    <cf_dbtempcol name="NumeroEvento"	type="varchar(25)"		mandatory="yes">
    <cf_dbtempcol name="Debitos"		type="money"			mandatory="yes">
    <cf_dbtempcol name="Creditos"		type="money"			mandatory="yes">
    <cf_dbtempcol name="Moneda"			type="char(3)"			mandatory="yes">
    <cf_dbtempcol name="Eperiodo"		type="int"				mandatory="yes">
    <cf_dbtempcol name="Emes"			type="int"				mandatory="yes">
</cf_dbtemp>

<cfsetting requesttimeout="3600">
<cfset ubiDescripcion = "">
<!---Moneda Origen del reporte
<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2 and isdefined("form.Mcodigo") and Len(form.Mcodigo) GT 0>
    <cfquery name="rsMonedas" datasource="#Session.DSN#">
        select Mcodigo as Mcodigo, Mnombre, Msimbolo, Miso4217, ts_rversion 
        from Monedas
        where Ecodigo = #Session.Ecodigo#
        and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
    </cfquery>
</cfif>--->

<cfquery name="rsLibroMayorI" datasource="#session.dsn#">
    insert into #CG_LMAYOR_EV_NAME#
        (Pagina, LineaP, Cmayor, Cdescripcion,  Efecha,
         Ddescripcion, NumeroEvento, Debitos, Creditos,
         Moneda, Eperiodo, Emes)
    select  0,0, cm.Cmayor, cm.Cdescripcion, 
    hec.Efecha, hdc.Ddescripcion,
    coalesce(hdc.NumeroEvento,'-') as NumeroEvento,
    <cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2>
            case when Dmovimiento = 'D' then Doriginal else 0.00 end as Debitos,
            case when Dmovimiento='C' then Doriginal else 0.00 end as Creditos,
    <cfelse>
            case when Dmovimiento = 'D' then Dlocal else 0.00 end as Debitos,
            case when Dmovimiento='C' then Dlocal else 0.00 end as Creditos,
    </cfif>
    m.Miso4217 as Moneda,
    hdc.Eperiodo, hdc.Emes
    from HDContables hdc
    inner join HEContables hec 
    on hdc.Ecodigo = hec.Ecodigo and hdc.IDcontable=hec.IDcontable
    inner join CContables c
        on hdc.Ecodigo = c.Ecodigo 
        and hdc.Ccuenta = c.Ccuenta
    inner join CtasMayor cm 
        on c.Ecodigo = cm.Ecodigo and cm.Cmayor = c.Cmayor 
    inner join Monedas m 
    on hdc.Ecodigo = m.Ecodigo 
    and hdc.Mcodigo = m.Mcodigo
    
    where hdc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
    <!--- dependiendo del valor de la moneda que se haya dado, cuando el reporte sea por moneda origen--->    
    <cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2 and isdefined("form.Mcodigo") and Len(form.Mcodigo) GT 0>
        and hdc.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
    </cfif>
    and hdc.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodoini#">
    and hdc.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mesini#">
    <cfif isdefined("form.fechaini") and #len(form.fechaini)# GT 1>
        and convert(char(8),hec.Efecha,112) >= '#LSDateFormat(form.fechaini,'yyyymmdd')#'
    </cfif>
    <cfif isdefined("form.fechafin") and #len(form.fechafin)# GT 1>
        and convert(char(8),hec.Efecha,112) <= '#LSDateFormat(form.fechafin,'yyyymmdd')#' 
    </cfif>
    
    <cfif isdefined("form.cmayor_ccuenta1") and len(trim(form.cmayor_ccuenta1))>
        and cm.Cmayor >= #form.cmayor_ccuenta1#
    </cfif>
    <cfif isdefined("form.cmayor_ccuenta2") and len(trim(form.cmayor_ccuenta2))>
        and cm.Cmayor <= #form.cmayor_ccuenta2#
    </cfif>
    <cfif (isdefined("form.ID_Evento") and form.ID_Evento neq -1) OR (isdefined("form.ID_NEvento") and Len(Trim(form.ID_NEvento)))>
        and 
    <cfif isdefined("form.incluiroperaciones")>
        (
    </cfif>
            hdc.NumeroEvento in (
            Select a.NumeroEvento 
            from EventosControlDetalle a 
                inner join EventosControl b  
                on a.ID_NEvento = b.ID_NEvento 
            where 1=1 
            <cfif isdefined("form.ID_Evento") and form.ID_Evento neq -1>
                and b.ID_Evento = #form.ID_Evento#
            </cfif>
            <cfif isdefined("form.ID_NEvento") and Len(Trim(form.ID_NEvento))>	 
                and b.ID_NEvento = #form.ID_NEvento#
            </cfif>)
    </cfif>
    
    <cfif isdefined("form.incluiroperaciones")>
        or hdc.NumeroEvento in (
            Select a.NumeroEventoRef
            from EventosControlDetalle a 
                inner join EventosControl b  
                on a.ID_NEvento = b.ID_NEvento 
            where 1=1 
            <cfif isdefined("form.ID_Evento") and form.ID_Evento neq -1>
                and b.ID_Evento = #form.ID_Evento#
            </cfif>
            <cfif isdefined("form.ID_NEvento") and Len(Trim(form.ID_NEvento))>	 
                and b.ID_NEvento = #form.ID_NEvento#
            </cfif>)
        )
    </cfif>
    <!---group by  cm.Cmayor, cm.Cdescripcion, NumeroEvento--->
    order by cm.Cmayor, NumeroEvento
</cfquery>

<cfquery name="rsLibroMayorU" datasource="#session.dsn#">
	declare @Pagina int, @NumLin int 
	select @Pagina = 0, @NumLin = 0
	update #CG_LMAYOR_EV_NAME# 
    	set @NumLin = case when @NumLin = 40 then 1 else @NumLin + 1 end,
        @Pagina = case when @NumLin = 1 then @Pagina + 1 else @Pagina end,
        Pagina = 
        <cfif form.corte EQ 0>
        	1,
        <cfelseif form.corte EQ 1>
        	@Pagina, 
        <cfelse>
        	Cmayor,
        </cfif>
        LineaP = @NumLin
</cfquery>

<cfquery name="rsLibroMayor" datasource="#session.dsn#">
select * from #CG_LMAYOR_EV_NAME# 
</cfquery>

<cfif #form.mesini# eq 1><cfset Mes = "Enero"></cfif>
<cfif #form.mesini# eq 2><cfset Mes = "Febrero"></cfif>
<cfif #form.mesini# eq 3><cfset Mes = "Marzo"></cfif>
<cfif #form.mesini# eq 4><cfset Mes = "Abril"></cfif>
<cfif #form.mesini# eq 5><cfset Mes = "Mayo"></cfif>
<cfif #form.mesini# eq 6><cfset Mes = "Junio"></cfif>
<cfif #form.mesini# eq 7><cfset Mes = "Julio"></cfif>
<cfif #form.mesini# eq 8><cfset Mes = "Agosto"></cfif>
<cfif #form.mesini# eq 9><cfset Mes = "Septiembre"></cfif>
<cfif #form.mesini# eq 10><cfset Mes = "Octubre"></cfif>
<cfif #form.mesini# eq 11><cfset Mes = "Noviembre"></cfif>
<cfif #form.mesini# eq 12><cfset Mes = "Diciembre"></cfif>


<cfset Title = "Libro Mayor">
<cfset FileName = "LibroDeMayor_CE">
<cfset FileName = FileName & Session.Usucodigo & "-" & DateFormat(Now(),'yyyymmdd') & "-" & TimeFormat(Now(),'hhmmss') & ".xls">
<cfset FileNameTab = "LibroDeMayor_CE">
<cfset FileNameTab = FileNameTab & Session.Usucodigo & "-" & DateFormat(Now(),'yyyymmdd') & "-" & TimeFormat(Now(),'hhmmss')>

<cf_templatecss>
<cfoutput>
<style type="text/css">
	.Titulos {
		font-size:18px;
	}
	.Titulos2 {
		font-size:12px;
	}
	.encabReporteLine {
		background-color: ##006699;
		color: ##FFFFFF;
		padding-top: 2px;
		padding-bottom: 2px;
		font-size: 11px; 
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: ##CCCCCC;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: ##CCCCCC;
		font-weight:bold;
	}
	.imprimeDatos {
		font-size: 10px;	
		padding-left: 5px; 
	}
	.imprimeDatosLinea {
		color: ##FF0000;
		font-size: 10px;
		font-weight: bold;
		padding-left: 5px; 
	}
	.imprimeMonto {
		font-size: 10px;
		text-align: right;
	}
	.imprimeMontoBold {
		font-size: 10px;
		text-align: right;
		font-weight: bold;
	}
	.imprimeMontoLinea {
		color: ##FF0000;
		font-size: 10px;
		text-align: right;
		font-weight: bold;
	}
</style>
</cfoutput>
<html>
<body>
<cfif rsLibroMayor.recordCount GT 0>
<cfflush interval="16000">
<cfquery dbtype="query" name="rsCuentasM">
	select min(Cmayor) as Mayor1, max(Cmayor) as Mayor2,
    max(Pagina) as PaginaMax 
    from rsLibroMayor
</cfquery>
<cfset varPaginaMax = rsCuentasM.PaginaMax>
	<!--- Pinta el Reporte de Libro de Mayor --->	
    <cfoutput>
        <table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
        	<tr>
            	<td colspan="7" align="right">
                	<!--- Pinta los botones de regresar, impresion y exportar a excel. --->
                    <cf_htmlreportsheaders
                        title="#Title#" 
                        filename="#FileName#" 
                        ira="CtrlEventosLibroMayor-Form.cfm?conlisnew=1">
                </td>
            </tr>
            <cfif form.corte NEQ 1>
                <tr><td align="center" colspan="7"><cfinclude template="RetUsuarioEve.cfm"></td></tr>
                <tr><td colspan="7" align="center"><strong class="Titulos">#session.Enombre#</strong></td></tr>
                <tr><td align="center" colspan="7"><strong class="Titulos">#LB_Titulo#</strong></td></tr>
                <cfif isdefined("form.fechaini") and  isdefined("form.fechafin") and #len(form.fechaini)# gt 1 and #len(form.fechafin)# gt 1>
                    <tr><td align="center" colspan="7"><strong class="Titulos2">Periodo del #form.fechaini#  al #form.fechafin#</strong></td></tr>
                <cfelse>
                    <tr><td align="center" colspan="7"><strong class="Titulos2">#LB_Periodo#: #form.periodoini#  #LB_Mes#: #Mes#</strong></td></tr>
                </cfif>
                <tr>
                	<td align="center" colspan="7">
                    	<strong class="Titulos2">#LB_Mayor#:&nbsp;#rsCuentasM.Mayor1#&nbsp;-&nbsp;#rsCuentasM.Mayor2#</strong>
                    </td>
                </tr>
                <cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2 and isdefined("form.Mcodigo") and Len(form.Mcodigo) GT 0>
                    <tr><td align="center" colspan="7"><strong class="Titulos2">#LB_Morigen#: #rsLibroMayor.Moneda#</strong></td></tr>
                <cfelse>
                    <tr><td align="center" colspan="7"><strong class="Titulos2">#LB_Mlocal#</strong></td></tr>
                </cfif>
                <cfif isdefined("form.incluiroperaciones")>
                    <tr><td align="center" colspan="7"><strong class="Titulos2">#LB_Incluye#</strong></td></tr>
                </cfif>
                <tr><td align="center" colspan="7"><strong class="Titulos2">#LB_cifras#</strong></td></tr>
                <tr><td align="center" colspan="6"><hr></td></tr>
            </cfif>
        </table>
    </cfoutput>
	<cfset TotalDebitosTot = 0>	
    <cfset TotalCreditosTot = 0>	
    <cfset TotalMovimientosTot = 0>	
	<cfif isdefined("form.cortes")>			
        <cfoutput  query="rsLibroMayor" group="Cmayor">
            <table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
                <cfset TotalDebitos = 0>	
                <cfset TotalCreditos = 0>	
                <cfset TotalMovimientos = 0>
                <cfset saldo = 0>
                <tr>
                    <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine" colspan="1">#LB_Mayor#: #rsLibroMayor.Cmayor#</td>
                    <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine" colspan="1">#LB_Descrip#: #rsLibroMayor.Cdescripcion#</td>
                    <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine" colspan="3" align="center">#LB_Montos#</td>
                </tr>
    
                <tr>
                    <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine" colspan="2">#LB_Evento#</td>
                    <td align="right" <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine" colspan=1>#LB_Debito#</td>
                    <td align="right" <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine" colspan=1>#LB_Credito#</td>
                    <td align="right" <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine" colspan=1>#LB_Mov#</td>
                </tr>	
                <cfoutput group="NumeroEvento">
                     <cfset varDebitos = 0>
                    <cfset varCreditos = 0>		
                    <cfset varmovimientos = 0>
                    <tr>
                        <cfoutput>
                            <cfset varDebitos = varDebitos+rsLibroMayor.debitos>
                            <cfset varCreditos = varCreditos+rsLibroMayor.creditos>
                            <cfset movimientos = Debitos-Creditos>    		
                            <cfset movimientos = Debitos-Creditos>
                            <cfset varmovimientos = varmovimientos+movimientos>
                            <cfset saldo = saldo + movimientos>
                        </cfoutput>
                        <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="imprimeDatos" colspan="2">#rsLibroMayor.NumeroEvento#</td>
                        <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="imprimeMonto" colspan="1">#LSCUrrencyFormat(varDebitos,'none')#</td>
                        <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="imprimeMonto" colspan="1">#LSCUrrencyFormat(varCreditos,'none')#</td>
                        <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="imprimeMonto" colspan="1">#LSCUrrencyFormat(saldo,'none')#</td>
                        <cfset TotalDebitos = TotalDebitos+varDebitos>	
                        <cfset TotalCreditos = TotalCreditos+varCreditos>	
                        <cfset TotalMovimientos = TotalMovimientos+varmovimientos>
                    </tr>
                    <tr></tr>
                </cfoutput>
            
                <td colspan="2">&nbsp;</td>
                <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="imprimeMontoBold">#LSCUrrencyFormat(TotalDebitos,'none')#</td>
                <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="imprimeMontoBold">#LSCUrrencyFormat(TotalCreditos,'none')#</td>
                <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="imprimeMontoBold">#LSCUrrencyFormat(saldo,'none')#</td>
                <tr><td>&nbsp;</td></tr>
                <cfset TotalDebitosTot = TotalDebitosTot + TotalDebitos>	
                <cfset TotalCreditosTot = TotalCreditosTot + TotalCreditos>	
                <cfset TotalMovimientosTot = TotalMovimientosTot + TotalMovimientos>
            </table>
        </cfoutput>
    <cfelse>
        <cfif isdefined("form.corte") and form.corte EQ 0>
            <cfoutput>
                <table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
                    <tr>
                        <td colspan="3">&nbsp;</td>
                        <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine" colspan="3" align="center">#LB_Montos#</td>
                    </tr>
                    <tr>
                        <td width="10%" <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine">#LB_Fecha#</td>
                        <td width="10%" <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine">#LB_Evento#</td>
                        <td width="35%" <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine">#LB_DesLin#</td>
                        <td width="15%" align="right" <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine" colspan=1>#LB_Debito#</td>
                        <td width="15%" align="right" <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine" colspan=1>#LB_Credito#</td>
                        <td width="15%" align="right" <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine" colspan=1>#LB_Mov#</td>
                    </tr>
            </cfoutput>
        </cfif>
        <cfset saldo = 0>
        <cfoutput  query="rsLibroMayor" group="Pagina">
            <cfset TotalDebitosPag = 0>	
            <cfset TotalCreditosPag = 0>	
            <cfset TotalMovimientosPag = 0>
            <cfif form.corte EQ 1>
                <table <cfif form.corte EQ 1> width="1500"<cfelse>width="100%"</cfif> align="center"  border="0" cellspacing="0" cellpadding="2" <cfif rsLibroMayor.Pagina NEQ 1>style="page-break-before:always"</cfif>>
                    <tr>
                        <td colspan="6">
                            <table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
                                <tr><td align="center" colspan="7"><cfinclude template="RetUsuarioEve.cfm"></td></tr>
                                <tr><td colspan="7" align="center"><strong class="Titulos">#session.Enombre#</strong></td></tr>
                                <tr><td align="center" colspan="7"><strong class="Titulos">#LB_Titulo#</strong></td></tr>
                                <cfif isdefined("form.fechaini") and  isdefined("form.fechafin") and #len(form.fechaini)# gt 1 and #len(form.fechafin)# gt 1>
                                    <tr><td align="center" colspan="7"><strong class="Titulos2">Periodo del #form.fechaini#  al #form.fechafin#</strong></td></tr>
                                <cfelse>
                                    <tr><td align="center" colspan="7"><strong class="Titulos2">#LB_Periodo#: #form.periodoini#  #LB_Mes#: #Mes#</strong></td></tr>
                                </cfif>
                                <tr>
                                    <td align="center" colspan="7">
                                        <strong class="Titulos2">#LB_Mayor#:&nbsp;#rsCuentasM.Mayor1#&nbsp;-&nbsp;#rsCuentasM.Mayor2#</strong>
                                    </td>
                                </tr>
                                <cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2 and isdefined("form.Mcodigo") and Len(form.Mcodigo) GT 0>
                                    <tr><td align="center" colspan="7"><strong class="Titulos2">#LB_Morigen#: #rsLibroMayor.Moneda#</strong></td></tr>
                                <cfelse>
                                    <tr><td align="center" colspan="7"><strong class="Titulos2">#LB_Mlocal#</strong></td></tr>
                                </cfif>
                                <tr><td align="center" colspan="7"><strong class="Titulos2">#LB_cifras#</strong></td></tr>
                                <tr><td align="center" colspan="6">&nbsp;</td></tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">&nbsp;</td>
                        <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine" colspan="3" align="center">#LB_Montos#</td>
                    </tr>
        
                    <tr>
                        <td width="10%" <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine">#LB_Fecha#</td>
                        <td width="10%" <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine">#LB_Evento#</td>
                        <td width="35%" <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine">#LB_DesLin#</td>
                        <td width="15%" align="right" <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine" colspan=1>#LB_Debito#</td>
                        <td width="15%" align="right" <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine" colspan=1>#LB_Credito#</td>
                        <td width="15%" align="right" <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine" colspan=1>#LB_Mov#</td>
                    </tr>
            <cfelse>
            	<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
            </cfif>
            <cfoutput group="Cmayor">
                <cfset TotalDebitos = 0>	
                <cfset TotalCreditos = 0>	
                <cfset TotalMovimientos = 0>
                <cfif isdefined("form.corte") and form.corte EQ 2>
                    <cfset saldo = 0>
                </cfif>
                <cfif isdefined("form.corte") and form.corte EQ 2>
                    <tr>
                        <td align="center" <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> colspan="6"><strong class="Titulos2">#rsLibroMayor.Cmayor#</strong></td>
                    </tr>
                    <tr>
                        <td align="center" <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> colspan="6"><strong class="Titulos2">#rsLibroMayor.Cdescripcion#</strong></td>
                    </tr>
                
                    <tr>
                        <td colspan="3">&nbsp;</td>
                        <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine" colspan="3" align="center">#LB_Montos#</td>
                    </tr>
        
                    <tr>
                        <td width="10%" <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine">#LB_Fecha#</td>
                        <td width="10%" <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine">#LB_Evento#</td>
                        <td width="35%" <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine">#LB_DesLin#</td>
                        <td width="15%" align="right" <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine" colspan=1>#LB_Debito#</td>
                        <td width="15%" align="right" <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine" colspan=1>#LB_Credito#</td>
                        <td width="15%" align="right" <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="encabReporteLine" colspan=1>#LB_Mov#</td>
                    </tr>
                </cfif>
                <cfoutput group="NumeroEvento">
                    <cfset varDebitos = 0>
                    <cfset varCreditos = 0>		
                    <cfset varmovimientos = 0>
                    
                    <cfoutput>
                        <cfset varDebitos = varDebitos+rsLibroMayor.debitos>
                        <cfset varCreditos = varCreditos+rsLibroMayor.creditos>		
                        <cfset movimientos = Debitos-Creditos>
                        <cfset varmovimientos = varmovimientos+movimientos>
                         <cfset saldo = saldo + movimientos>

                        <tr>
                            <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="imprimeDatos">#LSDateFormat(rsLibroMayor.Efecha,'dd/mm/yyyy')#</td>
                            <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="imprimeDatos">#rsLibroMayor.NumeroEvento#</td>
                            <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="imprimeDatos">#rsLibroMayor.Ddescripcion#</td>
                            <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="imprimeMonto" colspan="1">#LSCUrrencyFormat(rsLibroMayor.debitos,'none')#</td>
                            <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="imprimeMonto" colspan="1">#LSCUrrencyFormat(rsLibroMayor.creditos,'none')#</td>
                            <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="imprimeMonto" colspan="1">#LSCUrrencyFormat(saldo,'none')#</td>
                        </tr>
                    </cfoutput>
                       
                    <cfset TotalDebitos = TotalDebitos+varDebitos>	
                    <cfset TotalCreditos = TotalCreditos+varCreditos>	
                    <cfset TotalMovimientos = TotalMovimientos+varmovimientos>
                </cfoutput>
                
                <cfif isdefined("form.corte") and form.corte EQ 2>
                    <tr  ><td align="right" colspan="3"><strong class="Titulos2">Total Mayor: #Cmayor#</strong></td>
                    <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="imprimeMontoBold">#LSCUrrencyFormat(TotalDebitos,'none')#</td>
                    <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="imprimeMontoBold">#LSCUrrencyFormat(TotalCreditos,'none')#</td>
                    <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="imprimeMontoBold">#LSCUrrencyFormat(saldo,'none')#</td>
                    <tr><td>&nbsp;</td></tr>
                </cfif>
                
                <cfset TotalDebitosPag = TotalDebitosPag + TotalDebitos>	
                <cfset TotalCreditosPag = TotalCreditosPag + TotalCreditos>	
                <cfset TotalMovimientosPag = TotalMovimientosPag + TotalMovimientos>
            </cfoutput>
            
            <cfif isdefined("form.corte") and form.corte EQ 1>
                <tr  ><td align="right" colspan="3"><strong class="Titulos">#LB_TotalPagina#:</strong></td>
                <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="imprimeMontoBold">#LSCUrrencyFormat(TotalDebitosPag,'none')#</td>
                <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="imprimeMontoBold">#LSCUrrencyFormat(TotalCreditosPag,'none')#</td>
                <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="imprimeMontoBold">#LSCUrrencyFormat(saldo,'none')#</td>
                <tr><td>&nbsp;</td></tr>
            </cfif>
            <cfset TotalDebitosTot = TotalDebitosTot + TotalDebitosPag>	
            <cfset TotalCreditosTot = TotalCreditosTot + TotalCreditosPag>	
            <cfset TotalMovimientosTot = TotalMovimientosTot + TotalMovimientosPag>
            </table>    
        </cfoutput>
    </cfif>
    <!--- Imprime al final de la lnea los totales de los montos --->
    <cfoutput>    
        <cfif form.corte NEQ 1>
            <tr><td>&nbsp;</td></tr>
        </cfif>
        <tr>
            <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="imprimeDatos" align="right" colspan="3"><strong class="Titulos">#LB_Total#</strong></td>
            <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="imprimeMontoBold"><strong>#LSCUrrencyFormat(TotalDebitosTot,'none')#</strong></td>
            <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="imprimeMontoBold"><strong>#LSCUrrencyFormat(TotalCreditosTot,'none')#</strong></td>
            <td <cfif form.corte NEQ 1>nowrap="nowrap"</cfif> class="imprimeMontoBold"><strong>#LSCUrrencyFormat(TotalMovimientosTot,'none')#</strong></td>
            
        </tr>
    </cfoutput>
    <cfif form.corte NEQ 1>
        <tr>
            <td colspan="15" align="center" class="niv3">
                ------------------------------------------- Fin de la Consulta -------------------------------------------
            </td>
        </tr>
    </cfif>
<cfelse>
	<div align="center"> ------------------------------------------- No se encontraron registros -------------------------------------------</div>
</cfif>
</body>
</html>