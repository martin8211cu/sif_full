<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 2-3-2006.
		Motivo: Se utiliza la tabla CGPeriodosProcesados para sacar el combo de los periodos y así mejorar el 
		rendimiento de la pantalla.
 --->
 <!---
 Modificado Por Israel Rodríguez Fecha 25-04-2012
 Se realiza Adecuación  para que tenga la funcionalidad de  cambiar la traduccion de las etiquetas
 --->
 
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Libro Diario Eventos" 
returnvariable="LB_Titulo" xmlfile="CtrlEventosCtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PeriodoInicial" default="Desde Per&iacute;odo" 
returnvariable="LB_PeriodoInicial" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PeriodoFinal" default="Hasta Per&iacute;odo" 
returnvariable="LB_PeriodoFinal" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MesInicial" default="Mes" 
returnvariable="LB_MesInicial" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MesFinal" default="Mes" 
returnvariable="LB_MesFinal" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechaInicial" default="Fecha Inicio" 
returnvariable="LB_FechaInicial" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechaFinal" default="Fecha Fin" 
returnvariable="LB_FechaFinal" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CuentaInicial" default="Cuenta Inicial" 
returnvariable="LB_CuentaInicial" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CuentaFinal" default="Cuenta Final" 
returnvariable="LB_CuentaFinal" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Moneda" default="Moneda" 
returnvariable="LB_Moneda" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Formato" default="Formato" 
returnvariable="LB_Formato" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Orden" default="Ordenamiento" 
returnvariable="LB_Orden" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Ninguno" default="- Ninguno -" 
returnvariable="LB_Ninguno" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Pagina" default="P&aacute;gina" 
returnvariable="LB_Pagina" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mayor" default="Mayor" 
returnvariable="LB_Mayor" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cuenta" default="Cuenta" 
returnvariable="LB_Cuenta" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Oficina" default="Oficina" 
returnvariable="LB_Oficina" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Todos" default="Todos" returnvariable="LB_Todos" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="RBTN_MonedaLocal" default="Local" 
returnvariable="RBTN_MonedaLocal" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="RBTN_MonedaOrigen" default="Origen" 
returnvariable="RBTN_MonedaOrigen" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="CHK_ImpMontoMO" default="Imprimir Monto en Moneda Origen" 
returnvariable="CHK_ImpMontoMO" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="CHK_TotalFecha" default="Totalizar por Fecha" 
returnvariable="CHK_TotalFecha" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="CHK_CierreAnual" default="Cierre Anual" 
returnvariable="CHK_CierreAnual" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Limpiar" default="Limpiar" 
returnvariable="BTN_Limpiar" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Consultar" default="Consultar" 
returnvariable="BTN_Consultar" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="CHK_TipoEvento" default="Tipo Evento:" 
returnvariable="CHK_TipoEvento" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="CHK_NumeroEvento" default="N&uacute;mero Evento:" 
returnvariable="CHK_NumeroEvento" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="R_FECHA" default="Rangos de Fecha" 
returnvariable="R_FECHA" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="R_CUENTA" default="Rangos de Cuenta" 
returnvariable="R_CUENTA" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="R_OPC" default="Opciones de Reporte" 
returnvariable="R_OPC" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Corte" default="Cortes por:" 
returnvariable="LB_Corte" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Evento" default="Evento" 
returnvariable="LB_Evento" xmlfile="CtrlEventosLibroDeDiario.xml"/>

 
<cfquery datasource="#Session.DSN#" name="rsOficinas">
    select Ocodigo, Odescripcion
    from Oficinas 
    where Ecodigo = #Session.Ecodigo#
    order by Ocodigo 
</cfquery>
<cfquery datasource="#Session.DSN#" name="rsNivelDef">
    select Pvalor as valor
    from Parametros 
    where Ecodigo = #Session.Ecodigo#
    and Pcodigo = 10 
</cfquery>			  

<cfquery name="periodo_desde" datasource="#Session.DSN#">
    select distinct coalesce ( min (Speriodo ), # Year(Now()) - 3 #) as Speriodo
    from CGPeriodosProcesados
    where Ecodigo = #session.Ecodigo#
    order by Speriodo desc
</cfquery>
<cfquery name="periodo_hasta" datasource="#Session.DSN#">
    select distinct coalesce ( max (Speriodo ), # Year(Now()) + 3 #) as Speriodo
    from CGPeriodosProcesados
    where Ecodigo = #session.Ecodigo#
    order by Speriodo desc
</cfquery>

<cfquery name="rsPer" datasource="#Session.DSN#">
    select distinct Speriodo as Eperiodo
    from CGPeriodosProcesados
    where Ecodigo = #session.Ecodigo#
    order by Eperiodo desc
</cfquery>		

<cfset nivelDef="#ArrayLen(ListtoArray(rsNivelDef.valor, '-'))#">

<cfquery name="rsParam" datasource="#Session.DSN#">
	select ltrim(rtrim(Pvalor)) as Pvalor
	from Parametros
	where Ecodigo = #Session.Ecodigo#
	and Pcodigo = 30
</cfquery>
<cfset periodo = rsParam.Pvalor>

<cfquery name="rsParam" datasource="#Session.DSN#">
	select ltrim(rtrim(Pvalor)) as Pvalor
	from Parametros
	where Ecodigo = #Session.Ecodigo#
	and Pcodigo = 40
</cfquery>
<cfset mes = rsParam.Pvalor>

<cfquery name="rsMonedas" datasource="#Session.DSN#">
    select Mcodigo as Mcodigo, Mnombre, Msimbolo, Miso4217, ts_rversion 
    from Monedas
    where Ecodigo = #Session.Ecodigo#
</cfquery>
<cfset longitud = len(Trim(rsMonedas.Miso4217))>

<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
	from Empresas a, Monedas b
	where a.Ecodigo = #Session.Ecodigo#
	and a.Ecodigo = b.Ecodigo
	and a.Mcodigo = b.Mcodigo
</cfquery>

<cfquery name="rsParam" datasource="#Session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #Session.Ecodigo#
	and Pcodigo = 660
</cfquery>
<cfif rsParam.recordCount> 
	<cfquery name="rsMonedaConvertida" datasource="#Session.DSN#">
		select Mcodigo, Mnombre
		from Monedas
		where Ecodigo = #Session.Ecodigo#
		and Mcodigo = #rsParam.Pvalor#
	</cfquery>
</cfif>

<!---Control Eventos Inicia--->
<cfquery name="rsParam" datasource="#Session.DSN#">
	select ltrim(rtrim(Pvalor)) as Pvalor
	from Parametros
	where Ecodigo = #Session.Ecodigo#
	and Pcodigo = 1350
</cfquery>
<cfset evento = rsParam.Pvalor>
<!---Control Eventos Fin--->

<cfif isdefined("url.ID_Evento") and not isdefined("form.ID_Evento")>
	<cfset form.ID_Evento = url.ID_Evento>
</cfif>

<cf_templateheader title="#LB_Titulo#">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
<cfoutput>
    <table width="100%" cellpadding="2" cellspacing="0">
        <tr>
            <td valign="top">
				<script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
                <!---<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>--->
                <script language="JavaScript1.2" type="text/javascript" src="../../js/qForms/qforms.js"></script>
                <script language="JavaScript1.2" type="text/javascript">
                    // specify the path where the "/qforms/" subfolder is located
                    qFormAPI.setLibraryPath("../../js/qForms/");
                    // loads all default libraries
                    qFormAPI.include("*");
                    
                </script>
                            
<!---                <form name="form1" method="get" action="CtrlEventosLibroDeDiario-SQL.cfm" onsubmit="return sinbotones()">--->
                <form name="form1" method="post" action="CtrlEventosLibroDeDiario-SQL.cfm">
                    <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
                        <tr> 
                          <td width="15%" >&nbsp;</td>
                          <td width="10%" >&nbsp;</td>
                          <td width="10%" >&nbsp;</td>
                          <td width="15%" >&nbsp;</td>
                          <td width="10%" >&nbsp;</td>
                          <td width="10%" >&nbsp;</td>
                          <td width="15%" >&nbsp;</td>
                          <td width="10%" >&nbsp;</td>
                          <td width="5%" >&nbsp;</td>
                        </tr>
                        <tr>
                        	<td colspan="9">
                            	<strong>#R_FECHA#</strong>
                            </td>
                        </tr>
                        <tr>
                            <td nowrap><div align="right">#LB_PeriodoInicial#:&nbsp;</div></td>
                            <td colspan="2">
                                <select name="periodo1" tabindex="1">
                                    <cfloop from="#periodo_desde.Speriodo#" to="#periodo_hasta.Speriodo#" index="Speriodo">
                                            <cfif isdefined("url.periodo1")>
                                                <cfset SperiodoIni = #url.periodo1#>
                                            <cfelse>
                                                <cfset SperiodoIni = #Speriodo#>
                                            </cfif>                                
                                            <option value="#Speriodo#" <cfif #SperiodoIni# EQ "#rsPer.Eperiodo#">selected</cfif>>#Speriodo#</option>
                                    </cfloop>
                                </select>
                            </td>  
                            <td align="right">#LB_MesInicial#:</td>
                            <td colspan="2">
                                <cfif isdefined("url.mes1")>
                                    <cfset mes=#url.mes1#>
                                </cfif>
                                <select name="mes1" size="1" tabindex="2">
                                    <option value="1" <cfif mes EQ 1>selected</cfif>>Enero</option>
                                    <option value="2" <cfif mes EQ 2>selected</cfif>>Febrero</option>
                                    <option value="3" <cfif mes EQ 3>selected</cfif>>Marzo</option>
                                    <option value="4" <cfif mes EQ 4>selected</cfif>>Abril</option>
                                    <option value="5" <cfif mes EQ 5>selected</cfif>>Mayo</option>
                                    <option value="6" <cfif mes EQ 6>selected</cfif>>Junio</option>
                                    <option value="7" <cfif mes EQ 7>selected</cfif>>Julio</option>
                                    <option value="8" <cfif mes EQ 8>selected</cfif>>Agosto</option>
                                    <option value="9" <cfif mes EQ 9>selected</cfif>>Setiembre</option>
                                    <option value="10" <cfif mes EQ 10>selected</cfif>>Octubre</option>
                                    <option value="11" <cfif mes EQ 11>selected</cfif>>Noviembre</option>
                                    <option value="12" <cfif mes EQ 12>selected</cfif>>Diciembre</option>
                                </select>							  </td> 
                            <td align="right" nowrap>#LB_FechaInicial#:&nbsp;</td>
                            <td colspan="4" nowrap>
                                <cfif isdefined ("url.fechaini")>
                                    <cfset varFecha = #url.fechaini#>
                                <cfelse>
                                    <cfset varFecha = "">
                                </cfif>
                                <cf_sifcalendario name="fechaini" tabindex="5" value =#varFecha#>
                            </td> 
                        </tr>
                        <tr>
                            <td nowrap><div align="right">#LB_PeriodoFinal#:&nbsp;</div></td>
                            <td colspan="2">
                                <select name="periodo2" tabindex="3">
                                    <cfloop from="#periodo_desde.Speriodo#" to="#periodo_hasta.Speriodo#" index="Speriodo">
											<cfif isdefined("url.periodo2")>
                                                <cfset SperiodoFin = #url.periodo2#>
                                                <!---<cfabort showerror="PERIODO2">--->
                                            <cfelse>
                                                <cfset SperiodoFin = #Speriodo#>
                                            </cfif>                                
                                            <option value="#Speriodo#" <cfif #SperiodoFin# EQ "#rsPer.Eperiodo#">selected</cfif>>#Speriodo#</option>
                                    </cfloop>
                                </select>
                            </td>
                            <td align="right">#LB_MesFinal#:</td>
                            <td colspan="2">
								<cfif isdefined("url.mes2")>
                                    <cfset mes=#url.mes2#>
                                </cfif>
                                <select name="mes2" size="1" tabindex="4">
                                  <option value="1" <cfif mes EQ 1>selected</cfif>>Enero</option>
                                  <option value="2" <cfif mes EQ 2>selected</cfif>>Febrero</option>
                                  <option value="3" <cfif mes EQ 3>selected</cfif>>Marzo</option>
                                  <option value="4" <cfif mes EQ 4>selected</cfif>>Abril</option>
                                  <option value="5" <cfif mes EQ 5>selected</cfif>>Mayo</option>
                                  <option value="6" <cfif mes EQ 6>selected</cfif>>Junio</option>
                                  <option value="7" <cfif mes EQ 7>selected</cfif>>Julio</option>
                                  <option value="8" <cfif mes EQ 8>selected</cfif>>Agosto</option>
                                  <option value="9" <cfif mes EQ 9>selected</cfif>>Setiembre</option>
                                  <option value="10" <cfif mes EQ 10>selected</cfif>>Octubre</option>
                                  <option value="11" <cfif mes EQ 11>selected</cfif>>Noviembre</option>
                                  <option value="12" <cfif mes EQ 12>selected</cfif>>Diciembre</option>
                                </select>                              
                            </td>
                            <td align="right" nowrap>#LB_FechaFinal#:&nbsp;</td>
                            <td colspan="2" align="left" nowrap>
								<cfif isdefined ("url.fechafin")>
                                    <cfset varFecha = #url.fechafin#>
                                <cfelse>
                                    <cfset varFecha = "">
                                </cfif>
                                <cf_sifcalendario name="fechafin" tabindex="6" value =#varFecha#>
                            </td>
                        </tr>
                        <tr>
                        	<td colspan="9">
                            	<strong>#R_CUENTA#</strong>
                            </td>
                        </tr>
                        <tr>
							<!---AQUI VA CUENTA--->
                            <td align="right" nowrap>#LB_CuentaInicial#:&nbsp; </td>
                            <td colspan="8" align="left" nowrap>
								<cfif isdefined("url.cfcuenta_ccuenta1") and LEN(TRIM(url.cfcuenta_ccuenta1))>
                                    <cfquery name="rsCuenta" datasource="#session.DSN#">
                                        select Ccuenta, rtrim(CFformato) as CFformato, CFdescripcion
                                        from CFinanciera cf
                                    where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cfcuenta_ccuenta1#">
                                    </cfquery>
                                    <cf_cuentas NoVerificarPres="yes" cformato="Cformato1" cdescripcion="Cdescripcion1" ccuenta="Ccuenta1" query="#rsCuenta#" CFcuenta="cfcuenta_ccuenta1" Cmayor="cmayor_ccuenta1" MOVIMIENTO="S" AUXILIARES="N" frame="frcuenta1" descwidth="20" tabindex="7"> 
                                <cfelse>  
                                    <cf_cuentas NoVerificarPres="yes" cformato="Cformato1" cdescripcion="Cdescripcion1" ccuenta="Ccuenta1" MOVIMIENTO="S" AUXILIARES="N" frame="frcuenta1" descwidth="20" tabindex="7"> 
                                </cfif>
                            </td>
                        </tr>
                        <tr>
                            <td align="right" nowrap> #LB_CuentaFinal#:&nbsp; </td>
                            <td colspan="8" align="left" nowrap>                       
								<cfif isdefined("url.cfcuenta_ccuenta2") and LEN(TRIM(url.cfcuenta_ccuenta2))>
                                    <cfquery name="rsCuenta" datasource="#session.DSN#">
                                        select Ccuenta, rtrim(CFformato) as CFformato, CFdescripcion
                                        from CFinanciera cf
                                        where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cfcuenta_ccuenta2#">
                                    </cfquery>
                                	<cf_cuentas NoVerificarPres="yes" cformato="Cformato2" cdescripcion="Cdescripcion2" ccuenta="Ccuenta2" query="#rsCuenta#" CFcuenta="cfcuenta_ccuenta2" Cmayor="cmayor_ccuenta2" MOVIMIENTO="S" AUXILIARES="N" frame="frcuenta2" descwidth="20" tabindex="8"> 
                                <cfelse>  
                                	<cf_cuentas NoVerificarPres="yes" cformato="Cformato2" cdescripcion="Cdescripcion2" ccuenta="Ccuenta2" MOVIMIENTO="S" AUXILIARES="N" frame="frcuenta2" descwidth="20" tabindex="8"> 
                                </cfif> 
                            </td>
                        </tr>
                        <tr>
                        	<td colspan="9">
                            	<strong>#R_OPC#</strong>
                            </td>
                        </tr>
                        <tr>
                            <td nowrap><div align="right">#LB_Moneda#:</div></td>
                            <td colspan="5" rowspan="2" valign="top">
                                <table border="0" cellspacing="0" cellpadding="2">
                                    <tr>
                                        <td nowrap>
                                            <input name="mcodigoopt" type="radio" value="-2" 
                                            <cfif -(isdefined("url.mcodigoopt") and url.mcodigoopt eq "-2") or not isdefined("url.mcodigoopt")> checked </cfif>
                                             tabindex="9">
                                        </td>
                                        <td nowrap> #RBTN_MonedaLocal#: </td>
                                        <td><strong>#rsMonedaLocal.Mnombre#</strong></td>
                                    </tr>
                                    <tr>
                                    	<td nowrap><input name="mcodigoopt" type="radio" value="0" <cfif isdefined("url.mcodigoopt") and url.mcodigoopt eq "0"> checked </cfif> tabindex="10" /></td>
                                    	<td nowrap>#RBTN_MonedaOrigen#:</td>
                                        <td>
                                            <cfif isdefined('url.Mcodigo') and len(trim(url.Mcodigo))>
                                                <select name="Mcodigo" tabindex="11">
                                                  <cfloop query="rsMonedas">
                                                    <option value="#rsMonedas.Mcodigo#"
                                                    <cfif rsMonedas.Mcodigo EQ url.Mcodigo >selected</cfif>>
                                                    #rsMonedas.Mnombre#</option>
                                                  </cfloop>
                                                </select>
                                            <cfelse>
                                                <select name="Mcodigo" tabindex="12">
                                                  <cfloop query="rsMonedas">
                                                    <option value="#rsMonedas.Mcodigo#"
                                                    <cfif isdefined('rsMonedas') and isdefined('rsMonedaLocal')>
                                                        <cfif rsMonedas.Mcodigo EQ rsMonedaLocal.Mcodigo >selected</cfif>>
                                                        #rsMonedas.Mnombre#</option>
                                                    </cfif>
                                                  </cfloop>
                                                </select>
                                            </cfif>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td nowrap align ="right">#CHK_TipoEvento#&nbsp;</td>
                            <td colspan="2" nowrap>
                                <cfquery name="idEvento" datasource="#session.dsn#">
                                    select  ID_Evento,EVcodigo, EVdescripcion from EEvento
                                    where Ecodigo = #session.Ecodigo#
                                </cfquery>
                                
                                <select name="ID_Evento" id="ID_Evento" onchange="javascript:asignar(this.value);" >
                                <option value="-1">(Evento)</option>
                                <cfloop query="idEvento">
                                    <option value="#ID_Evento# " <cfif isdefined("form.ID_Evento") and  form.ID_Evento EQ idEvento.ID_Evento >selected  </cfif>> #EVcodigo# - #EVdescripcion#</option>
                                </cfloop>
                                </select>
                            </td>
                        </tr>
                    <tr>
                        <td >&nbsp;</td>
                        <td nowrap align ="right">#CHK_NumeroEvento#&nbsp;</td>
                        <td colspan="2" nowrap>
                            <cfset varFiltroEvento = "Ecodigo = #Session.Ecodigo#">
							<cfif isdefined("form.ID_Evento") and form.ID_Evento GT 0>
                                <cfset varFiltroEvento = varFiltroEvento&" and ID_Evento=#form.ID_Evento#">
                            </cfif>
                            
                                <cf_conlis
                                  Campos="Evento,ID_NEvento, Oorigen, Documento, Transaccion"
                                  Desplegables="S,N,N,N,N"
                                  Modificables="S,N,N,N,N"
                                  Size="25,10,10,10,10"
                                  tabindex="13" 
                                  Values="" 
                                  Title="Lista de Eventos"
                                  Tabla="EventosControl"
                                  Columnas="ID_NEvento, Evento, Oorigen, Documento, Transaccion"
                                  Filtro="#varFiltroEvento#"
                                  Desplegar="Evento, Oorigen, Documento, Transaccion"
                                  Etiquetas="Evento, Auxiliar, Documento, Transaccion"
                                  filtrar_por="Evento, Oorigen, Documento, Transaccion"
                                  Formatos="S,S,S,S,S"
                                  Align="left,left,left,left,left"
                                  form="form1" 
                                  Asignar="Evento,ID_NEvento"
                                  Asignarformatos="S,N"
                                  EmptyListMsg="No existen Eventos por mostrar"
                                  showEmptyListMsg="true"
                                  permiteNuevo="false"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6">&nbsp;</td>
                        <td nowrap align="right">
                            <input type="checkbox" id="IncluirOperaciones" name="IncluirOperaciones" tabindex="14" onClick="javascript: OP_REL();">
                        </td>
                        <td colspan="2">Incluir Operaciones relacionadas al Evento</td>
                    </tr>
                    <tr>
                    	<td align="right" nowrap>#LB_Oficina#:&nbsp;</td>
                        <td colspan="5" align="left" nowrap>
                        	<select name="Ocodigo" id="select" tabindex="15">
                                <option value="-1">#LB_Todos#</option>
                                <cfloop query="rsOficinas">
                                <option value="#rsOficinas.Ocodigo#" <cfif isdefined("url.Ocodigo") and url.Ocodigo eq "#rsOficinas.Ocodigo#">selected</cfif> >#rsOficinas.Odescripcion#</option>
                                </cfloop>
                            </select>
                        </td>
                        <td align="right">#LB_Corte#</td>
                        <td colspan="2" align="left">
	                        <select id="corte" name="corte" tabindex="16">
                                <option value="0" selected>#LB_Ninguno#</option>
                                <option value="1">#LB_Pagina#</option>
                                <option value="2">#LB_Mayor#</option>
                                <option value="3">#LB_Cuenta#</option>
                                <option disabled="disabled" value="4">#LB_Evento#</option>
    	                    </select>
                        </td>
                    </tr>
                    <tr>
                    	<td align="right">#LB_Orden#:</td>
                        <td colspan="2" align="left">
	                        <select id="ordenamiento" name="ordenamiento" tabindex="17" onchange="javascript:funcOrdena();">
                                <option value="0" selected>Linea</option>
                                <option value="1">Fecha/Concepto/Asiento</option>
                                <option value="2">Fecha/Monto/Asiento</option>
                                <option value="3">Monto/Concepto/Asiento</option>
                                <option value="4">#LB_Evento#</option>
    	                    </select>
                        </td>
                        <td colspan="6">&nbsp;</td>
                    </tr>
                    <tr>
                      <td colspan="9" align="right">&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="2">&nbsp;</td>
<!---                        <td colspan="3" align="right"><input type="submit" name="Submit" value="#BTN_Consultar#" onClick="this.form.btnGenerar2.value=0" tabindex="17"></td>--->
                        <td colspan="3" align="right"><input type="submit" name="Submit" value="#BTN_Consultar#" tabindex="18"></td>
                        <td colspan="3" align="left"><input type="Reset" name="Limpiar" value="#BTN_Limpiar#" tabindex="19"></td>
                        <td>&nbsp;</td>
                    </tr>
                    </table>
                </form>
            </td>	
        </tr>
    </table>	
    </cfoutput>
    <cf_web_portlet_end>
<cf_templatefooter>
<cfoutput>
	<script language="javascript">
		function asignar(value){
			if (value != ''){
				document.form1.action='';
				document.form1.submit();	
			}
		}

		function OP_REL() {
			if (document.getElementById("ID_NEvento").value <=  0 ){
				document.getElementById("IncluirOperaciones").checked=0;
				alert("Debe seleccionar un Evento");
			return 0;
		}
		else
			if (document.getElementById("IncluirOperaciones").checked ==  1 ) {
				alert("Se incluiran los Eventos relacionados al Evento que ha seleccionado");
			}
			return 1;
		}
		function funcOrdena() {
			var x=document.getElementById("ordenamiento").selectedIndex;
			if (x==4){
				document.getElementById("corte").options[2].disabled=true;
				document.getElementById("corte").options[3].disabled=true;
				document.getElementById("corte").options[4].disabled=false;
			}
			else{
				document.getElementById("corte").options[2].disabled=false;
				document.getElementById("corte").options[3].disabled=false;
				document.getElementById("corte").options[4].disabled=true;
			}
			document.getElementById("corte").selectedIndex='0';
		}
	</script>
</cfoutput>
