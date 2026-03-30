 <!---
Creado por Alejandro Bolaños 30/julio/2012 --->
<!--- RR	corrección filtro fecha, cambio de columna documento en tabla temporal para que acepte campos null --->
<cfif not isdefined("form.corte")> 
	<cfset form.corte = 0>
</cfif>

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Libro Diario Eventos" 
returnvariable="LB_Titulo" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mlocal" default="Moneda Local" 
returnvariable="LB_Mlocal" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Morigen" default="Moneda Origen" 
returnvariable="LB_Morigen" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Incluye" default="Incluye Eventos Relacionados" 
returnvariable="LB_Incluye" xmlfile="CtrlEventosLibroMayor-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mayor" default="Mayor" 
returnvariable="LB_Mayor" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cuenta" default="Cuenta" 
returnvariable="LB_Cuenta" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Periodo" default="Periodo" 
returnvariable="LB_Periodo" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mes" default="Mes" 
returnvariable="LB_Mes" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Desde" default="Desde" 
returnvariable="LB_Desde" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Hasta" default="Hasta" 
returnvariable="LB_Hasta" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default="Fecha" 
returnvariable="LB_Fecha" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Lote" default="Lote" 
returnvariable="LB_Lote" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Poliza" default="P&oacute;liza" 
returnvariable="LB_Poliza" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Oficina" default="Oficina" 
returnvariable="LB_Oficina" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Documento" default="Documento" 
returnvariable="LB_Documento" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Configura" default="Configuración y Nombre de la Cuenta" 
returnvariable="LB_Configura" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Contable" default="Contable" 
returnvariable="LB_Contable" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Presupuesto" default="Presupuestal" 
returnvariable="LB_Presupuesto" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripci&oacute;n" 
returnvariable="LB_Descripcion" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Monto" default="Montos" 
returnvariable="LB_Monto" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Moneda" default="Moneda" 
returnvariable="LB_Moneda" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Debitos" default="D&eacute;bitos" 
returnvariable="LB_Debitos" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Creditos" default="Cr&eacute;ditos" 
returnvariable="LB_Creditos" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Movimiento" default="Movimiento" 
returnvariable="LB_Movimiento" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Acumulado" default="Acumulado" 
returnvariable="LB_Acumulado" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TotalCuenta" default="Total Cuenta" 
returnvariable="LB_TotalCuenta" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TotalMayor" default="Total Mayor" 
returnvariable="LB_TotalMayor" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TotalPagina" default="Sub-Total" 
returnvariable="LB_TotalPagina" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Total" default="Gran Total" 
returnvariable="LB_Total" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_NumeroEvento" default="Número Evento" 
returnvariable="LB_NumeroEvento" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_cifras" default="(Cifras en Pesos y Centavos)" 
returnvariable="LB_cifras" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Usuario" default="Usuario" 
returnvariable="LB_Usuario" xmlfile="CtrlLibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Pagina" default="Pagina" 
returnvariable="LB_Pagina" xmlfile="CtrlLibroDeDiario-SQL.xml"/>

<!--- Con la finalidad de Paginar se establece una tabla temporal --->
<cf_dbtemp name="CG_LDIRARIO_EV" returnvariable="CG_LDIARIO_EV_NAME" datasource="#session.dsn#">
	<cf_dbtempcol name="Pagina"			type="int"				mandatory="yes">
    <cf_dbtempcol name="LineaP"			type="int"				mandatory="yes">
    <cf_dbtempcol name="Mayor"			type="char(4)"			mandatory="yes">
    <cf_dbtempcol name="Formato"		type="varchar(100)"		mandatory="yes">
    <cf_dbtempcol name="DescCuenta"		type="varchar(80)"		mandatory="yes">
    <cf_dbtempcol name="FormatoP"		type="varchar(100)"		mandatory="no">
    <cf_dbtempcol name="DescCuentaP"	type="varchar(80)"		mandatory="no">
    <cf_dbtempcol name="Edocumento"		type="int"				mandatory="yes">
    <cf_dbtempcol name="Efecha"			type="datetime"			mandatory="yes">
    <cf_dbtempcol name="Edescripcion"	type="varchar(100)"		mandatory="yes">
    <cf_dbtempcol name="Periodo"		type="int"				mandatory="yes">
    <cf_dbtempcol name="Mes"			type="int"				mandatory="yes">
    <cf_dbtempcol name="Concepto"		type="int"				mandatory="yes">
    <cf_dbtempcol name="Documento"		type="varchar(20)"		mandatory="no">
    <cf_dbtempcol name="Dreferencia"	type="varchar(25)"		mandatory="yes">
    <cf_dbtempcol name="PeriodoMes"		type="varchar(10)"		mandatory="yes">
    <cf_dbtempcol name="Monto"			type="money"			mandatory="yes">
    <cf_dbtempcol name="TipoCambio"		type="float"			mandatory="yes">
    <cf_dbtempcol name="Debitos"		type="money"			mandatory="yes">
    <cf_dbtempcol name="Creditos"		type="money"			mandatory="yes">
    <cf_dbtempcol name="Ddescripcion"	type="varchar(100)"		mandatory="yes">
    <cf_dbtempcol name="Moneda"			type="char(3)"			mandatory="yes">
    <cf_dbtempcol name="NumeroEvento"	type="varchar(25)"		mandatory="yes">
</cf_dbtemp>
    
<!---<cfsetting requesttimeout="36000">--->
<cfif isdefined("url.mcodigoopt") and url.mcodigoopt EQ "0">
	<cfset varMcodigo = url.Mcodigo>
<cfelse>
	<cfset varMcodigo = -1>
</cfif>

<cfset lvarCformato1 = "">
<cfset lvarCformato2 = "">

<cfif isdefined('form.cformato1') and len(trim(form.cformato1)) GT 0 and isdefined("form.cmayor_ccuenta1") and len(form.cmayor_ccuenta1) GT 0>
	<cfset lvarCformato1 = "#cmayor_ccuenta1#-#form.cformato1#">
<cfelse>
	<cfif isdefined('form.Ccuenta1') and len(trim(form.Ccuenta1)) GT 0>
        <cfquery datasource="#session.dsn#" name="rsSQL">
            select Cformato
            from CContables
            where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccuenta1#">
        </cfquery>
        <cfset lvarCformato1 = rsSQL.Cformato>
    </cfif>
</cfif>
<cfif isdefined('form.cformato2') and len(trim(form.cformato2)) GT 0 and isdefined("form.cmayor_ccuenta2") and len(form.cmayor_ccuenta2) GT 0>
	<cfset lvarCformato2 = "#cmayor_ccuenta2#-#form.cformato2#">
<cfelse>
	<cfif isdefined('form.Ccuenta2') and len(trim(form.Ccuenta2)) GT 0>
        <cfquery datasource="#session.dsn#" name="rsSQL">
            select Cformato
            from CContables
            where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccuenta2#">
        </cfquery>
        <cfset lvarCformato2 = rsSQL.Cformato>
    </cfif>
</cfif>
<cfset rangotipos = ''>

<cfif len(trim(lvarCformato1)) GT 0>
	<cfset rangotipos = "Desde la cuenta " & lvarCformato1>
</cfif>		
<cfif len(trim(lvarCformato2)) GT 0>
	<cfset rangotipos = rangotipos & " Hasta la cuenta " & lvarCformato2>
</cfif>		

	<cf_dbfunction name='to_char' args="hd.Eperiodo" returnvariable='LvarEperiodo'>
    <cf_dbfunction name='to_char' args="hd.Emes" returnvariable='LvarEmes'>
    <cf_dbfunction name='length' args="#LvarEmes#" returnvariable="LvarLEmes">
    <cf_dbfunction name='op_concat' returnvariable="opconcat">
    <cfif len(form.mes1) GT 1>
    	<cfset Mes1 = form.mes1>
    <cfelse>
    	<cfset Mes1 = "0" & form.mes1>
    </cfif>
    
	<cfif len(form.mes2) GT 1>
    	<cfset Mes2 = form.mes2>
    <cfelse>
    	<cfset Mes2 = "0" & form.mes2>
    </cfif>
    
	<cfset PeriodoMes1 = form.periodo1 & Mes1>
    <cfset PeriodoMes2 = form.periodo2 & Mes2>

<cfquery name="rsReporteI" datasource="#session.dsn#">
	insert into #CG_LDIARIO_EV_NAME# 
    	(Pagina, LineaP, Mayor, Formato, DescCuenta,
         FormatoP, DescCuentaP, Edocumento, Efecha, Edescripcion,
         Periodo, Mes, Concepto, Documento, Dreferencia,
         PeriodoMes, Monto, TipoCambio, Debitos, Creditos,
         Ddescripcion, Moneda, NumeroEvento)
	select 0,0,
    	cc.Cmayor as Mayor, 
        cc.Cformato as Formato, 
        <cfif form.corte EQ 1>
            left(cc.Cdescripcion,35) as DescCuenta,
        <cfelse>
            cc.Cdescripcion as DescCuenta,
        </cfif>
        case 
        	when cpm.Cmayor is null then '-'
            else cc.Cformato end as FormatoP, 
        case 
        	when cpm.Cmayor is null then '-'
            else cpt.CPTMdescripcion end as DescCuentaP,
    	<!---coalesce(cp.CPformato,'-') as FormatoP, 
        <cfif form.corte EQ 1>
	        left(coalesce(cp.CPdescripcion,'-'),35) as DescCuentaP,
        <cfelse>
        	coalesce(cp.CPdescripcion,'-') as DescCuentaP,
        </cfif>--->
        he.Edocumento as Edocumento, he.Efecha as Efecha , 
		<cfif form.corte EQ 1>
        	left(he.Edescripcion,35) as Edescripcion,
        <cfelse>
        	he.Edescripcion,
        </cfif>
        hd.Eperiodo as Periodo, hd.Emes as Mes, hd.Cconcepto as Concepto, hd.Ddocumento as Documento,
        coalesce(hd.Dreferencia,'') as Dreferencia,
        <cf_dbfunction name='concat' args="#LvarEperiodo# + ' - ' + #LvarEmes#" delimiters='+'> as PeriodoMes, 
        hd.Doriginal as Monto,
        <cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2 and isdefined("form.Mcodigo") and Len(form.Mcodigo) GT 0>
        	'1' as TipoCambio,
        <cfelse>
        	hd.Dtipocambio as TipoCambio,
        </cfif>
        case Dmovimiento 
        when 'D' then
			<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2 and isdefined("form.Mcodigo") and Len(form.Mcodigo) GT 0>
            	hd.Doriginal
            <cfelse>
            	hd.Dlocal
            </cfif>
        else 
        	0
        end as Debitos,
        case Dmovimiento 
        when 'C' then
			<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2 and isdefined("form.Mcodigo") and Len(form.Mcodigo) GT 0>
            	hd.Doriginal
            <cfelse>
            	hd.Dlocal
            </cfif>
        else 
        	0
        end as Creditos,
        hd.Ddescripcion,
        m.Miso4217 as Moneda,
        coalesce(hd.NumeroEvento,'-') as NumeroEvento
	from HDContables hd 
    	inner join HEContables he 
        on hd.Ecodigo = he.Ecodigo and hd.IDcontable = he.IDcontable
        inner join CContables cc
        on he.Ecodigo = cc.Ecodigo and hd.Ccuenta = cc.Ccuenta
        left join CPresupuestoPeriodo cpp
        on hd.Ecodigo = cpp.Ecodigo 
        and cpp.CPPestado = 1
        and #LvarEPeriodo# #opconcat# 
            case  
            when #LvarLEmes# > 1 then #LvarEmes#
            else '0' #opconcat# #LvarEmes# end 
        between cpp.CPPanoMesDesde and cpp.CPPanoMesHasta
        left join CPtipoMovContable cpm
            inner join CPtipoMov cpt
            on cpm.CPTMtipoMov = cpt.CPTMtipoMov
        on cc.Ecodigo = hd.Ecodigo and cc.Cmayor = cpm.Cmayor and cpp.CPPid = cpm.CPPid
        <!--- Las cuentas presupuestales se toman de acuerdo a la logica establecida para PMI --->
        <!---
        inner join CFinanciera cf
        	left join CPresupuesto cp
            	inner join CPtipoMovContable cpm
                on cp.Ecodigo = cpm.Ecodigo and 
            on cf.Ecodigo = cp.Ecodigo and cf.CPcuenta = cp.CPcuenta
        on hd.Ecodigo = cf.Ecodigo and hd.CFcuenta = cf.CFcuenta--->
        inner join Monedas m
        on hd.Ecodigo = m.Ecodigo and hd.Mcodigo = m.Mcodigo
    where hd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
    	<!--- dependiendo del valor de la moneda que se haya dado, cuando el reporte sea por moneda origen--->    
		<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2 and isdefined("form.Mcodigo") and Len(form.Mcodigo) GT 0>
            and hd.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
        </cfif>
        <cfif isdefined("form.fechaini") and #len(form.fechaini)# GT 1>
            and convert(char(8),he.Efecha,112) >= '#LSDateFormat(form.fechaini,'yyyymmdd')#'
        </cfif>
        <cfif isdefined("form.fechafin") and #len(form.fechafin)# GT 1>
            and convert(char(8),he.Efecha,112) <= '#LSDateFormat(form.fechafin,'yyyymmdd')#' 
        </cfif>
        and #LvarEPeriodo# #opconcat# 
        	case  
        		when #LvarLEmes# > 1 then #LvarEmes#
                else '0' #opconcat# #LvarEmes# end >=  '#PeriodoMes1#'

        and #LvarEPeriodo# #opconcat# 
        	case  
        		when #LvarLEmes# > 1 then #LvarEmes#
                else '0' #opconcat# #LvarEmes# end <=  '#PeriodoMes2#'
        <cfif isdefined("lvarCformato1") and len(lvarCformato1) GT 0>
	        and cc.Cformato >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#lvarCformato1#">
        </cfif>
        <cfif isdefined("lvarCformato2") and len(lvarCformato2) GT 0>
	        and cc.Cformato <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#lvarCformato2#">
        </cfif>
        <cfif isdefined("form.Ocodigo") and form.Ocodigo NEQ -1>
        	and hd.Ocodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ocodigo#">
        </cfif>
        <cfif (isdefined("form.ID_Evento") and form.ID_Evento neq -1) OR (isdefined("form.ID_NEvento") and Len(Trim(form.ID_NEvento)))>
            and 
        <cfif isdefined("form.incluiroperaciones")>
            (
        </cfif>
                hd.NumeroEvento in (
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
            or hd.NumeroEvento in (
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

        order by 
			Mayor, 
			Formato, 
			<cfif isdefined("form.Ordenamiento")>
				<cfif form.Ordenamiento EQ 1>
					he.Efecha, hd.Cconcepto, he.Edocumento,
				</cfif>

				<cfif form.Ordenamiento EQ 2>
					he.Efecha, Debitos, Creditos, hd.Concepto, he.Edocumento,
				</cfif>

				<cfif form.Ordenamiento EQ 3>
					Debitos, Creditos, hd.Cconcepto, he.Edocumento,
				</cfif>
			</cfif>
			hd.Dlinea
        
</cfquery>
 
<cfquery name="rsReporteU" datasource="#session.dsn#">
	declare @Pagina int, @NumLin int 
	select @Pagina = 0, @NumLin = 0
	update #CG_LDIARIO_EV_NAME# 
    	set @NumLin = case when @NumLin = 25 then 1 else @NumLin + 1 end,
        @Pagina = case when @NumLin = 1 then @Pagina + 1 else @Pagina end,
        Pagina = 
        <cfif form.corte EQ 0>
        	1,
        <cfelseif form.corte EQ 1>
        	@Pagina, 
        <cfelse>
        	Mayor,
        </cfif>    
        LineaP = @NumLin
</cfquery>

<cfquery name="rsReporte" datasource="#session.dsn#">
	select * from #CG_LDIARIO_EV_NAME# 
</cfquery>

<cfquery dbtype="query" name="rsPaginaMax">
	select max(Pagina) as PaginaMax
    from rsReporte
</cfquery>
<cfset varPaginaMax = rsPaginaMax.PaginaMax>

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
		.Titulos3 {
			font-size:16px;
		}
	.encabReporteLine {
	background-color: ##006699;
	color: ##FFFFFF;
	padding-top: 2px;
	padding-bottom: 2px;
	font-size: 12px; 
	border-right-width: 1px;
	border-right-style: solid;
	border-right-color: ##CCCCCC;
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: ##CCCCCC;
	}
	.imprimeDatos {
	font-size: 11px;	
	padding-left: 5px; 
	}
	.imprimeDatosLinea {
	color: ##FF0000;
	font-size: 11px;
	font-weight: bold;
	padding-left: 5px; 
	}
	.imprimeMonto {
	font-size: 11px;
	text-align: right;
	}
	.imprimeMontoBold {
	font-size: 11px;
	text-align: right;
	font-weight: bold;
	}
	.imprimeMontoLinea {
	color: ##FF0000;
	font-size: 11px;
	text-align: right;
	font-weight: bold;
	}
</style>
</cfoutput>
<html>
<body>
<cfif isdefined("rsReporte") and rsReporte.recordCount gt 0>
	<cfflush interval="16000">
<!---<table width="100%">
<tr>
<td> --->   
	<cfoutput>					
		<table border="0" align="center" cellpadding="2" cellspacing="0" width="100%">
        	<tr>
            	<td colspan="3" align="right">
                	<!--- Pinta los botones de regresar, impresion y exportar a excel. --->
                    <cf_htmlreportsheaders
                        title="#LB_Titulo#" 
                        filename="#FileName#" 
                        ira="CtrlEventosLibroDeDiario.cfm">
                </td>
            </tr>
            <cfif form.corte NEQ 1>
                <tr style="font-weight:bold">
                  <td colspan="2" align="center"><strong class="Titulos">#session.Enombre#</strong></td>
                  <td align="right"><font size="2"><strong>#LB_Fecha#:&nbsp;#dateformat(now(), 'dd/mm/yyyy')#</strong></font></td>
                </tr>
                
                <tr style="font-weight:bold">
                  <td colspan="2" align="center"><strong class="Titulos">#LB_Titulo#</strong></td>
                  <td align="right"><font size="2"><strong>#LB_Usuario#:&nbsp;#session.Usulogin#</strong></font></td>
                </tr>
                
                <tr style="font-weight:bold">
                    <td colspan="2" align="center"><strong class="Titulos2">#LB_Desde#:&nbsp;#LB_Periodo# &nbsp;#form.periodo1#&nbsp;-#LB_Mes# &nbsp;#form.mes1#&nbsp;#LB_Hasta#:&nbsp;#LB_Periodo# &nbsp;#form.periodo2#&nbsp;-#LB_Mes# &nbsp;#form.mes2#</strong></td>                      
                    <td align="left"><strong class="Titulos2"></strong></td>
                    <td>&nbsp;</td>
                </tr>
                
                <tr>
                    <cfif isdefined("form.ccuenta1")>
                        <td colspan="2" align="Center">
                        	<strong class="Titulos2">
								<cfif isdefined("form.ccuenta1")>
                                    #LB_Cuenta#&nbsp;#LB_Desde#:&nbsp;#lvarCformato1#
                                </cfif>
                                &nbsp;
                                <cfif isdefined("form.ccuenta2")>
                                	#LB_Cuenta#&nbsp;#LB_Hasta#:&nbsp;#lvarCformato2#
                                </cfif>
                            </strong>
                        </td>
                    </cfif>
                    <td>&nbsp;</td>
                </tr>
                <cfif isdefined("form.Ocodigo") and form.Ocodigo NEQ -1>
                    <tr>
                        <td colspan="2" align="center"><strong class="Titulos2">#LB_Oficina#&nbsp;#form.Ocodigo#</strong></td>
                        <td>&nbsp;</td>
                    </tr>
                </cfif>
                <cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2 and isdefined("form.Mcodigo") and Len(form.Mcodigo) GT 0>
                    <tr>
                        <td align="center" colspan="2"><strong class="Titulos2">#LB_Morigen#: #rsReporte.Moneda#</strong></td>
                        <td>&nbsp;</td>
                    </tr>
                <cfelse>
                    <tr>
                        <td align="center" colspan="2"><strong class="Titulos2">#LB_Mlocal#</strong></td>
                        <td>&nbsp;</td>
                    </tr>
                </cfif>
                <cfif isdefined("form.incluiroperaciones")>
                    <tr>
                        <td align="center" colspan="2"><strong class="Titulos2">#LB_Incluye#</strong></td>
                        <td>&nbsp;</td>
                    </tr>
                </cfif>
                <tr>
                    <td colspan="2" align="center"><strong class="Titulos2">#LB_cifras#</strong></td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="3">&nbsp;</td>
                </tr>
            </cfif>
		</table>                   
	</cfoutput>  
<!---</td>
</tr>
<tr>
<td>--->
	<cfset TotalDebGen = 0>		
    <cfset TotalCredGen = 0>
    <cfset TotalMovGen = 0>
    <!---<cfif form.corte EQ 1> width="2500" style="width:2500;table-layout:fixed;overflow:hidden;white-space:nowrap;"<cfelse>width="100%"</cfif>--->
    
	<cfif isdefined("form.corte") and form.corte EQ 0>
        <cfoutput>
            <table cellpadding="5" cellspacing="0" border="0" align="center" width="100%" style="white-space:nowrap">	
                <tr>
                    <td rowspan="3" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Fecha#</td>
                    <td rowspan="3" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_NumeroEvento#</td>
                    <td rowspan="3" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Lote#-#LB_Poliza#</td>
                    <td rowspan="3" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Documento#</td>
                    <td colspan="4" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Configura#</td>
                    <td rowspan="3" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Descripcion#</td>	
                    <td colspan="2" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Monto#</td>
                    <!---<td rowspan="3" <!------> align="center" class="encabReporteLine" style="width:1% ;font-weight:bold">#LB_Movimiento#</td>--->							
                </tr>
                <tr>
                    <td colspan="2" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Contable#</td>
                    <td colspan="2" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Presupuesto#</td>
                    <td rowspan="2" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Debitos#</td>
                    <td rowspan="2" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Creditos#</td>
                </tr>
                <tr>
                    <td <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Cuenta#</td>
                    <td <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Descripcion#</td>
                    <td <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Cuenta#</td>
                    <td <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Descripcion#</td>
                </tr>
        </cfoutput>
    </cfif>
	<cfoutput query="rsReporte" group="Pagina"> 
		<cfset TotalDebPag = 0>		
        <cfset TotalCredPag = 0>
        <cfset TotalMovPag = 0>
        <cfif isdefined("form.corte") and form.corte EQ 1>
            <table cellpadding="5" cellspacing="0" border="0" align="center" width="100%" <cfif rsReporte.Pagina NEQ 1>style="white-space:nowrap; page-break-before:always"<cfelse>style="white-space:nowrap"</cfif>>	
                <tr>
                    <td colspan="11">
                        <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" style="width:100%">
                            <tr style="font-weight:bold">
                              <td colspan="2" align="center"><strong class="Titulos">#session.Enombre#</strong></td>
                              <td align="right"><font size="2"><strong>#LB_Pagina#:&nbsp;#Pagina#/#varPaginaMax#</strong></font></td>
                            </tr>
                            
                            <tr style="font-weight:bold">
                              <td colspan="2" align="center"><strong class="Titulos">#LB_Titulo#</strong></td>
                              <td align="right"><font size="2"><strong>#LB_Fecha#:&nbsp;#dateformat(now(), 'dd/mm/yyyy')#</strong></font></td>
                            </tr>
                            
                            <tr style="font-weight:bold">
                                <td colspan="2" align="center"><strong class="Titulos2">#LB_Desde#:&nbsp;#LB_Periodo# &nbsp;#form.periodo1#&nbsp;-#LB_Mes# &nbsp;#form.mes1#&nbsp;#LB_Hasta#:&nbsp;#LB_Periodo# &nbsp;#form.periodo2#&nbsp;-#LB_Mes# &nbsp;#form.mes2#</strong></td>                      
                                <td align="left"><strong class="Titulos2"></strong></td>
                                <td>&nbsp;</td>
                            </tr>
                            
                            <tr>
                                <cfif isdefined("form.ccuenta1")>
                                    <td colspan="2" align="Center">
                                        <strong class="Titulos2">
                                            <cfif isdefined("form.ccuenta1")>
                                                #LB_Cuenta#&nbsp;#LB_Desde#:&nbsp;#lvarCformato1#
                                            </cfif>
                                            &nbsp;
                                            <cfif isdefined("form.ccuenta2")>
                                                #LB_Cuenta#&nbsp;#LB_Hasta#:&nbsp;#lvarCformato2#
                                            </cfif>
                                        </strong>
                                    </td>
                                </cfif>
                                <td>&nbsp;</td>
                            </tr>
                            
                            <cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2 and isdefined("form.Mcodigo") and Len(form.Mcodigo) GT 0>
                                <tr>
                                    <td align="center" colspan="2"><strong class="Titulos2">#LB_Morigen#: #rsReporte.Moneda#</strong></td>
                                    <td>&nbsp;</td>
                                </tr>
                            <cfelse>
                                <tr>
                                    <td align="center" colspan="2"><strong class="Titulos2">#LB_Mlocal#</strong></td>
                                    <td>&nbsp;</td>
                                </tr>
                            </cfif>
                            <tr>
                                <td colspan="2" align="center"><strong class="Titulos2">#LB_cifras#</strong></td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td colspan="3">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td rowspan="3" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Fecha#</td>
                    <td rowspan="3" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_NumeroEvento#</td>
                    <td rowspan="3" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Lote#-#LB_Poliza#</td>
                    <td rowspan="3" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Documento#</td>
                    <td colspan="4" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Configura#</td>
                    <td rowspan="3" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Descripcion#</td>	
                    <td colspan="2" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Monto#</td>
                    <!---<td rowspan="3" <!------> align="center" class="encabReporteLine" style="width:1% ;font-weight:bold">#LB_Movimiento#</td>--->												
                </tr>
                <tr>
                    <td colspan="2" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Contable#</td>
                    <td colspan="2" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Presupuesto#</td>
                    <td rowspan="2" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Debitos#</td>
                    <td rowspan="2" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Creditos#</td>
                </tr>
                <tr>
                    <td <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Cuenta#</td>
                    <td <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Descripcion#</td>
                    <td <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Cuenta#</td>
                    <td <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Descripcion#</td>
                </tr>
        <cfelse>
        	<table cellpadding="5" cellspacing="0" border="0" align="center" width="100%" style="white-space:nowrap">	
        </cfif>
        
		<cfoutput group="Mayor">                       
            <cfset TotalDebMay = 0>		
            <cfset TotalCredMay = 0>
            <cfset TotalMovMay = 0>
            <!---<tr>
                <td nowrap class="encabReporteLine" colspan="1" style="width:2% ;font-weight:bold">Cuenta de Mayor : #Mayor#</td>
            </tr>
            
            <tr>
                <td nowrap class="encabReporteLine" colspan="1" style="width:1% ;font-weight:bold">Cuenta: #Formato#</td>
            </tr>--->
            <cfif isdefined("form.corte") and form.corte EQ 2>		
                <tr>
                    <td rowspan="3" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Fecha#</td>
                    <td rowspan="3" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_NumeroEvento#</td>
                    <td rowspan="3" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Lote#-#LB_Poliza#</td>
                    <td rowspan="3" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Documento#</td>
                    <td colspan="4" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Configura#</td>
                    <td rowspan="3" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Descripcion#</td>	
                    <td colspan="2" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Monto#</td>
                    <!---<td rowspan="3" <!------> align="center" class="encabReporteLine" style="width:1% ;font-weight:bold">#LB_Movimiento#</td>--->							
                </tr>
                <tr>
                    <td colspan="2" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Contable#</td>
                    <td colspan="2" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Presupuesto#</td>
                    <td rowspan="2" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Debitos#</td>
                    <td rowspan="2" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Creditos#</td>
                </tr>
                <tr>
                    <td <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Cuenta#</td>
                    <td <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Descripcion#</td>
                    <td <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Cuenta#</td>
                    <td <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Descripcion#</td>
                </tr>
            </cfif>			
            <cfoutput group="Formato">
                <cfset TotalDebCta = 0>		
                <cfset TotalCredCta = 0>
                <cfset TotalMovCta = 0>
                
                <cfif isdefined("form.corte") and form.corte EQ 3>		
                    <tr>
                        <td rowspan="3" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Fecha#</td>
                        <td rowspan="3" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_NumeroEvento#</td>
                        <td rowspan="3" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Lote#-#LB_Poliza#</td>
                        <td rowspan="3" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Documento#</td>
                        <td colspan="4" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Configura#</td>
                        <td rowspan="3" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Descripcion#</td>	
                        <td colspan="2" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Monto#</td>
                        <!---<td rowspan="3" <!------> align="center" class="encabReporteLine" style="width:1% ;font-weight:bold">#LB_Movimiento#</td>--->							
                    </tr>
                    <tr>
                        <td colspan="2" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Contable#</td>
                        <td colspan="2" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Presupuesto#</td>
                        <td rowspan="2" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Debitos#</td>
                        <td rowspan="2" <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Creditos#</td>
                    </tr>
                    <tr>
                        <td <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Cuenta#</td>
                        <td <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Descripcion#</td>
                        <td <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Cuenta#</td>
                        <td <!------> align="center" class="encabReporteLine" style="font-weight:bold">#LB_Descripcion#</td>
                    </tr>
                </cfif>			
                <cfoutput>
                    <tr>
                        <td <!---<cfif form.corte EQ 1>style="overflow:hidden"</cfif>---> class="imprimeDatos" align="left" width="100" <!------>>#LSdateformat(Efecha,'dd-mm-yyyy')#</td>
                        <td <!---<cfif form.corte EQ 1>style="overflow:hidden"</cfif>---> class="imprimeDatos" align="right" width="150" <!------>>#NumeroEvento#</td>
                        <td <!---<cfif form.corte EQ 1>style="overflow:hidden"</cfif>--->  class="imprimeDatos" align="center" width="50" <!------>>#Concepto#-#Edocumento#</td>
                        <td <!---<cfif form.corte EQ 1>style="overflow:hidden"</cfif>---> class="imprimeDatos" align="left" width="150" <!------>>#Documento#</td>
                        <td <!---<cfif form.corte EQ 1>style="overflow:hidden"</cfif>---> class="imprimeDatos" align="right" width="200" <!------>>
                            <cfif #FormatoP# NEQ "-">-<cfelse>#Formato#</cfif>
                        </td>
                        <td <!---<cfif form.corte EQ 1>style="overflow:hidden"</cfif>---> class="imprimeDatos" align="right" width="250" <!------>>
                            <cfif #DescCuentaP# NEQ "-">-<cfelse>#DescCuenta#</cfif>
                        </td>
                        <td <!---<cfif form.corte EQ 1>style="overflow:hidden"</cfif>---> class="imprimeDatos" align="right" width="200" <!------>>#FormatoP#</td>
                        <td <!---<cfif form.corte EQ 1>style="overflow:hidden"</cfif>---> class="imprimeDatos" align="right" width="250" <!------>>#DescCuentaP#</td>
                        <td <!---<cfif form.corte EQ 1>style="overflow:hidden"</cfif>---> class="imprimeDatos" align="left" width="250"<!------>>#Edescripcion#</td>
                        <td <!---<cfif form.corte EQ 1>style="overflow:hidden"</cfif>---> class="imprimeMonto" align="right" width="100"<!------>>#LScurrencyFormat(Debitos,'none')#</td>
                        <td <!---<cfif form.corte EQ 1>style="overflow:hidden"</cfif>---> class="imprimeMonto" align="right" width="100"<!------>>#LScurrencyFormat(Creditos,'none')#</td>
                        <!---<td class="imprimeMonto" align="right">#LScurrencyFormat(Debitos-Creditos,'none')#</td>--->
                    </tr>
                    <cfset TotalDebCta = TotalDebCta + Debitos>		
                    <cfset TotalCredCta = TotalCredCta + Creditos>
                    <cfset Movimiento = Debitos - Creditos>
                    <cfset TotalMovCta = TotalMovCta + Movimiento>
                </cfoutput>								
                
                <cfif isdefined("form.corte") and form.corte EQ 3>		
                    <tr>
                        <td class="imprimeDatos" align="left" colspan="7">&nbsp;</td>
                        <td align="right" colspan="2"><strong class="imprimeDatos">#LB_TotalCuenta#: #Formato#</strong></td>
                        <td align="right" class="imprimeMontoBold">#LSCUrrencyFormat(TotalDebCta,'none')#</td>
                        <td align="right" class="imprimeMontoBold">#LSCUrrencyFormat(TotalCredCta,'none')#</td>					
                        <!---<td align="right" class="imprimeMontoBold">#LSCUrrencyFormat(TotalMovCta,'none')#</td>--->
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                    </tr>
                </cfif>														
                <cfset TotalDebMay = TotalDebMay + TotalDebCta>		
                <cfset TotalCredMay = TotalCredMay + TotalCredCta>
                <cfset TotalMovMay = TotalMovMay + TotalMovCta>
            </cfoutput>
            
            <cfif isdefined("form.corte") and form.corte EQ 2>		
                <tr>
                    <td class="imprimeDatos" align="left" colspan="5">&nbsp;</td>
                    <td align="left" colspan="4"><strong class="imprimeDatos">#LB_TotalMayor#: #Mayor#</strong></td>
                    <td align="right" class="imprimeMontoBold">#LSCUrrencyFormat(TotalDebMay,'none')#</td>
                    <td align="right" class="imprimeMontoBold">#LSCUrrencyFormat(TotalCredMay,'none')#</td>					
                    <!---<td align="right" class="imprimeMontoBold">#LSCUrrencyFormat(TotalMovMay,'none')#</td>--->
                </tr>
                <tr><td>&nbsp;</td></tr>
            </cfif>
            
            <cfset TotalDebPag = TotalDebPag + TotalDebMay>		
            <cfset TotalCredPag = TotalCredPag + TotalCredMay>
            <cfset TotalMovPag = TotalMovPag + TotalMovMay>
        </cfoutput>
            
            <cfif isdefined("form.corte") and form.corte EQ 1>
                <tr>
                    <td class="imprimeDatos" align="left" colspan="3">&nbsp;</td>
                    <td align="left" colspan="6"><strong class="Titulos">#LB_TotalPagina#:</strong></td>
                    <td align="right" class="imprimeMontoBold">#LSCUrrencyFormat(TotalDebPag,'none')#</td>
                    <td align="right" class="imprimeMontoBold">#LSCUrrencyFormat(TotalCredPag,'none')#</td>					
                    <!---<td align="right" class="imprimeMontoBold">#LSCUrrencyFormat(TotalMovPag,'none')#</td>--->
                </tr>	
            </cfif>
            <tr><td>&nbsp;</td></tr>
            <cfset TotalDebGen = TotalDebGen + TotalDebPag>		
            <cfset TotalCredGen = TotalCredGen + TotalCredPag>
            <cfset TotalMovGen = TotalMovGen + TotalMovPag>
        </cfoutput>
        
        <cfoutput>
            <tr>
                <td class="imprimeDatos" align="left" colspan="1">&nbsp;</td>
                <td align="left" colspan="8"><strong class="Titulos">#LB_Total#:</strong></td>
                <td align="right" class="imprimeMontoBold">#LSCUrrencyFormat(TotalDebGen,'none')#</td>
                <td align="right" class="imprimeMontoBold">#LSCUrrencyFormat(TotalCredGen,'none')#</td>					
                <!---<td align="right" class="imprimeMontoBold">#LSCUrrencyFormat(TotalMovPag,'none')#</td>--->
            </tr>	
        </cfoutput>
        <tr>
        <td colspan="11" align="center" class="niv3">
            ------------------------------------------- Fin de la Consulta -------------------------------------------
        </td>
        </tr>
    </table>
<!---</td>
</tr>
</table>--->
<cfelse>
	<div align="center"> ------------------------------------------- No se encontraron registros -------------------------------------------</div>
</cfif>
</body>
</html>


