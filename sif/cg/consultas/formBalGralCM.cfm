<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_ConvA = t.Translate('LB_ConvA','Convertida a')>
<cfset LB_InfB15 = t.Translate('LB_InfB15','Informe B15 en')>
<cfset LB_MontosEm = t.Translate('LB_MontosEm','Montos en')>
<cfinvoke key="CMB_Mes" 			default="Mes" 		returnvariable="CMB_Mes" 		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>

<cfif isdefined("url.periodo")>
	<cfparam name="Form.periodo" default="#url.periodo#">
</cfif>
<cfif isdefined("url.mes")>
	<cfparam name="Form.mes" default="#url.mes#">
</cfif>

<!---<cf_dump var="#session.idioma#">--->
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
<cfinvoke key="MSG_Oficina" 		default="Oficina"			returnvariable="MSG_Oficina"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Mes" 			default="Mes" 				returnvariable="CMB_Mes" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MGS_FinDelReporte" 	default="Fin Del Reporte" 	returnvariable="MGS_FinDelReporte" 		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_GrupoOficinas" 	default="Grupo de Oficinas"	returnvariable="MSG_GrupoOficinas"		component="sif.Componentes.Translate" method="Translate" xmlfile="SQLBalGeneral.xml"/>
<cfinvoke key="MSG_Periodo" 		default="Per&iacute;odo"	returnvariable="MSG_Periodo"			component="sif.Componentes.Translate" method="Translate" xmlfile="SQLBalGeneral.xml"/>
<cfinvoke key="MSG_Balance_General"	default="Balance General"	returnvariable="MSG_Balance_General"	component="sif.Componentes.Translate" method="Translate" xmlfile="SQLBalGeneral.xml"/>
<cfinvoke key="MSG_Activo" 			default="ACTIVO"			returnvariable="MSG_Activo"				component="sif.Componentes.Translate" method="Translate" xmlfile="SQLBalGeneral.xml"/>
<cfinvoke key="MSG_Pasivo" 			default="PASIVO"			returnvariable="MSG_Pasivo"				component="sif.Componentes.Translate" method="Translate" xmlfile="SQLBalGeneral.xml"/>
<cfinvoke key="MSG_Capital" 		default="CAPITAL"			returnvariable="MSG_Capital"			component="sif.Componentes.Translate" method="Translate" xmlfile="SQLBalGeneral.xml"/>
<cfinvoke key="MSG_Utilidad" 		default="UTILIDAD DEL PERIODO"returnvariable="MSG_Utilidad"			component="sif.Componentes.Translate" method="Translate" xmlfile="SQLBalGeneral.xml"/>
<cfinvoke key="MSG_PasivoCapital"	default="PASIVO Y CAPITAL"	returnvariable="MSG_PasivoCapital"		component="sif.Componentes.Translate" method="Translate" xmlfile="SQLBalGeneral.xml"/>

<cfparam name="form.chkConCodigo" default="0">
<cfset session.Conta.balances.ConCodigo = (form.chkConCodigo EQ "1")>
<cfif session.Conta.balances.ConCodigo>
	<cfset LvarCta = "formato + ' ' + descrip as descrip">
<cfelse>
	<cfset LvarCta = "descrip">
</cfif>

<cfparam name="form.chkNivelSeleccionado" default="0">
<cfset session.Conta.balances.nivelSeleccionado = (form.chkNivelSeleccionado EQ "1")>
 
<cfif isDefined("url.oficina") and not isDefined("form.oficina")>
	<cfset form.oficina = url.oficina>
</cfif>

<cfinclude template="Funciones.cfm">
<cfquery datasource="#Session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsOficina">
	select Odescripcion
	from Oficinas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.oficina#">
</cfquery>
<cfquery name="rsLeyenda" datasource="#Session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
		and Pcodigo = 920
</cfquery>

<cfset oficina = "Todas">
<cfif rsOficina.recordCount eq 1>
	<cfset oficina = rsOficina.Odescripcion>
</cfif>

<cfif isdefined("url.nivel")>
	<cfparam name="Form.nivel" default="#url.nivel#">
</cfif>
<cfif isdefined("url.oficina")>
	<cfparam name="Form.oficina" default="#url.oficina#">
</cfif>
<cfif isdefined("url.GOid")>
	<cfparam name="Form.GOid" default="#url.GOid#">
</cfif>
<cfif isdefined("url.ceros")>
	<cfparam name="Form.ceros" default="#url.ceros#">
</cfif>
<cfif isdefined("url.mcodigoopt")>
	<cfparam name="Form.mcodigoopt" default="#url.mcodigoopt#">
</cfif>
  
<cfset moneda ="">

<cfset varTC = 1>

<cfif isdefined("Form.mcodigoopt") and Form.mcodigoopt EQ "-2">
	<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
		select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
		from Empresas a, Monedas b 
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.Mcodigo = b.Mcodigo
	</cfquery>
	<cfquery name="rsMonedaRep" datasource="#Session.DSN#">
		select b.Mnombre
		from Monedas b 
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and b.Mcodigo = #Form.Mcodigo#
	</cfquery>
	<cfset moneda =rsMonedaRep.Mnombre>
<cfif rsMonedaLocal.Mcodigo neq Form.Mcodigo>
    <cfquery datasource="#Session.DSN#" name="rsTC">	
        select Mcodigo,TCtipocambio from TipoCambioReporte
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        and TCperiodo = #Form.periodo# and TCmes = #Form.mes# and Mcodigo = #Form.Mcodigo#
    </cfquery>
    <cfif rsTC.recordCount eq 0>
        <cfset MSG_TipoCambio = t.Translate('MSG_TipoCambio','No está definido el Tipo de Cambio para el periodo')>
        <cf_errorCode code = "50194" msg = "#MSG_TipoCambio# #Form.periodo# #CMB_Mes# #Form.mes#">
        <cfabort>
    </cfif>  
	<cfset varTC = #rsTC.TCtipocambio#>
</cfif>
    
<cfelseif isdefined("Form.mcodigoopt") and Form.mcodigoopt EQ "-3">
	<cfquery name="rsParam" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Pcodigo = 660
	</cfquery>
	<cfif rsParam.recordCount> 
		<cfquery name="rsMonedaConvertida" datasource="#Session.DSN#">
			select Mcodigo, Mnombre
			from Monedas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParam.Pvalor#">
		</cfquery>
	</cfif>
	<cfset moneda =#LB_ConvA# & ' ' & rsMonedaConvertida.Mnombre>
<cfelseif isdefined("Form.mcodigoopt") and Form.mcodigoopt EQ "-4">
	<cfquery name="rsParam" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		and Pcodigo = 3900
	</cfquery>
	<cfif rsParam.recordCount> 
		<cfquery name="rsMonedaB15" datasource="#Session.DSN#">
			select Mcodigo, Mnombre
			from Monedas
			where Ecodigo = #Session.Ecodigo#
			and Mcodigo = #rsParam.Pvalor#
		</cfquery>
		<cfset LvarMcodigo = rsMonedaB15.Mcodigo>
	</cfif>
	<cfset moneda =#LB_InfB15# & ' ' & rsMonedaB15.Mnombre>
<cfelseif  isdefined("Form.mcodigoopt") and Form.mcodigoopt EQ "0">
	<cfquery name="rsMonedaSel" datasource="#Session.DSN#">
		select Mcodigo, Mnombre
		from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
	</cfquery>
	<cfset moneda =#LB_MontosEm# & ' ' & rsMonedaSel.Mnombre>
</cfif>

<cfif isdefined("Form.Nivel") and Form.Nivel neq "-1">
	<cfset varNivel = Form.Nivel>
<cfelse>
	<cfset varNivel = "0">
</cfif>

<cfif isdefined("Form.mcodigoopt") and Form.mcodigoopt EQ "0">
	<cfset varMonedas = Form.Mcodigo>
<cfelse>
	<cfset varMonedas = Form.mcodigoopt>
</cfif>

<cfif isdefined("Form.Oficina") and len(trim(Form.Oficina))>
	<cfset varOcodigo = Form.Oficina>
<cfelse>
	<cfset varOcodigo = "-1">
</cfif>

<cfif isdefined("Form.GOid") and len(trim(Form.GOid))>
	<cfset varGOid = Form.GOid>
<cfelse>
	<cfset varGOid = "-1">
</cfif>

<cfquery name="rsGruposOficina" datasource="#Session.DSN#">
    select GOid, GOcodigo, GOnombre
    from AnexoGOficina
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varGOid#">
    order by GOcodigo
</cfquery>

<!--- Funcion para saber si una cuenta es hoja o no --->
<cffunction name="esHoja" returntype="string" description="Retorna S, si es Hoja, de lo contrario retorna N">
	<cfargument name="idCuenta" type="numeric" required="yes">
    <cfquery name="rsObtenerCMovimiento" datasource="#Session.DSN#">
    	Select A.Cmovimiento
        From CContables A
        Where A.Ccuenta = #arguments.idCuenta#
  	</cfquery>
    <cfreturn rsObtenerCMovimiento.Cmovimiento>
</cffunction>

<cftransaction>		
	<cfinvoke returnvariable="rsProc" component="sif.Componentes.sp_SIF_CG0005CM" method="balanceGeneral" 
		Ecodigo="#Session.Ecodigo#"
		periodo="#Form.periodo#"
		mes="#Form.mes#"
		ceros="N"
		nivel = "#varNivel#"
		Mcodigo="#varMonedas#"
		Ocodigo="#varOcodigo#"
		GOid="#varGOid#"
        DescAlt="#Form.Idioma#"
        TipoCmb= "#varTC#"
	>
	</cfinvoke>			
</cftransaction>

<cfif isdefined("rsProc") and rsProc.recordcount gt 2499><!--- En el mensaje se pone que excede los 2500 registros  --->
	<cfset MSG_ConsExc = t.Translate('MSG_ConsExc','La consulta excede los 2500 registros')>
	<cf_errorCode	code = "50235" msg = "#MSG_ConsExc#">
	<cfabort>
</cfif>

<cfif isdefined("form.botonsel") and len(trim(form.botonsel)) and form.botonsel eq "Exportar">
	<cf_exportQueryToFile query="#rsProc#"  filename="Balance_General_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls" jdbc="false">
</cfif>

<cfset meses="#CMB_Enero#,#CMB_Febrero#,#CMB_Marzo#,#CMB_Abril#,#CMB_Mayo#,#CMB_Junio#,#CMB_Julio#,#CMB_Agosto#,#CMB_Setiembre#,#CMB_Octubre#,#CMB_Noviembre#,#CMB_Diciembre#">

<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 2px;
		padding-bottom: 2px;
		font-size:12px;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
	.tituloLeyenda {
		font-weight: bold;
		font-size:16px;
		color:#0000FF; 
	}
</style>

<form name="form1" method="post">
	<table width="87%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 10px" align="center">
    	<tr><td colspan="5" class="tituloAlterno" align="center"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></td></tr>
    	<tr><td colspan="5">&nbsp;</td></tr>
    	<tr><td colspan="5" align="center"><b><font size="2"><cfoutput>#MSG_Balance_General#</cfoutput></font></b></td></tr>
    	<tr>
			<td colspan="5" align="center" style="padding-right: 20px">
				<b><cfoutput>#CMB_Mes#:</cfoutput></b> 
          		&nbsp;<cfoutput>#ListGetAt(meses, Form.mes, ',')#</cfoutput> 
				<b><cfoutput>#MSG_Periodo#:</cfoutput></b> &nbsp;<cfoutput>#Form.periodo#</cfoutput>
			</td>
    	</tr>
		<cfif Oficina neq 'Todas'>
			<tr>
				<td colspan="5" align="center" style="padding-right: 20px">
					<b><cfoutput>#MSG_Oficina#:</cfoutput></b> &nbsp;<cfoutput>#Oficina#</cfoutput>
				</td>
			</tr>
        </cfif>
		<cfif rsGruposOficina.recordCount eq 1>
			<tr>
				<td colspan="5" align="center" style="padding-right: 20px">
					<b><cfoutput>#MSG_GrupoOficinas#:</cfoutput></b> &nbsp;<cfoutput>#rsGruposOficina.GOnombre#</cfoutput>
				</td>
			</tr>
        </cfif>
		<tr>
			<td colspan="5" align="center" style="padding-right: 20px">
				<b><cfoutput>#moneda#</cfoutput></b>
			</td>
		</tr>		
		<!--- **************************** ACTIVOS ****************************** --->
		<tr><td colspan="5" class="bottomline">&nbsp;</td></tr>
		<tr><td colspan="5" class="tituloListas">&nbsp;</td></tr>
		<cfoutput>	
		<tr> 
    		<td width="40%" align="left" nowrap class="encabReporte">#MSG_Activo#</td>
			<td  nowrap="nowrap" width="15%" class="encabReporte"><div align="right">#Form.periodo#</div></td>
			<td  nowrap="nowrap" width="15%" class="encabReporte"><div align="right">#Form.periodo-1#</div></td>
    	</tr>
		</cfoutput>     
        
		<cfquery name="rsCuentasA" dbtype="query">
			select Ccuenta, nivel, #preservesinglequotes(LvarCta)#, saldofin, saldofinA 
            from rsProc 
            where tipo = 'A' 
		</cfquery>
		<cfoutput query="rsCuentasA">
        	<cfif session.Conta.balances.nivelSeleccionado>
                <cfif rsCuentasA.nivel EQ (varNivel - 1) or (esHoja(rsCuentasA.CCUENTA) EQ "S")>
                    <tr style="padding:2px; "> 
                        <td width="50%" align="left" nowrap> 
                            #descrip#
                        </td>
                        <td align="right">
							<cfif rsCuentasA.saldofin GTE 0>#LSNumberFormat(rsCuentasA.saldofin,'999,999,999,999,999.00')# 
                            <cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasA.saldofin,'999,999,999,999,999.00()')#</font> 
                            </cfif>
                        </td>				
                        <td align="right">
							<cfif rsCuentasA.saldofinA GTE 0>#LSNumberFormat(rsCuentasA.saldofinA,'999,999,999,999,999.00')# 
                            <cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasA.saldofinA,'999,999,999,999,999.00()')#</font> 
                            </cfif>
                        </td>
                    </tr>
               	
           		</cfif>
            <cfelse>
				<cfif nivel EQ 0 and varNivel GT 1><tr><td colspan="5">&nbsp;</td></tr></cfif>
                <tr style="padding:2px; " <cfif rsCuentasA.nivel EQ 0>class="tituloListas"</cfif>> 
                    <td width="50%" align="left" nowrap> 
                        <cfif rsCuentasA.nivel EQ 0>
                            <font size="2"><strong>#descrip#</strong></font>
                        <cfelse>
                            <cfset LvarCont = rsCuentasA.nivel>
                            <cfloop condition="LvarCont NEQ 0">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <cfset LvarCont = LvarCont - 1>
                            </cfloop>
                            #descrip#
                        </cfif>
                    </td>
                    <td align="right">
                            <cfif rsCuentasA.nivel EQ 0>
                                <strong><font size="2">
                            </cfif>
                                <cfif rsCuentasA.saldofin GTE 0>#LSNumberFormat(rsCuentasA.saldofin,'999,999,999,999,999.00')# 
                                <cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasA.saldofin,'999,999,999,999,999.00()')#</font> 
                            <cfif rsCuentasA.nivel EQ 0>
                                </font></strong>
                            </cfif>
                            </cfif>
                    </td>				
                    <td align="right">
                            <cfif rsCuentasA.nivel EQ 0>
                                <strong><font size="2">
                            </cfif>
                                <cfif rsCuentasA.saldofinA GTE 0>#LSNumberFormat(rsCuentasA.saldofinA,'999,999,999,999,999.00')# 
                                <cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasA.saldofinA,'999,999,999,999,999.00()')#</font> 
                                </cfif>
                            <cfif rsCuentasA.nivel EQ 0>
                                </font></strong>
                            </cfif>
                    </td>
                </tr>         	
            </cfif>
		</cfoutput>

		<cfquery name="sumA" dbtype="query">
			select sum(saldofin) as total,sum(saldofinA) as totalA from rsCuentasA where nivel = 0 
		</cfquery>
		<tr><td colspan="5">&nbsp;</td></tr>
		<tr> 
			<td class="topline"  nowrap><b>TOTAL <cfoutput>#MSG_Activo#</cfoutput></b></div></td>
			<td class="topline" align="right"><font size="2"> <strong>
				<cfoutput> 
				<cfif sumA.total GTE 0>
					#LSNumberFormat(sumA.total,'999,999,999,999.00')# 
				<cfelse>
					<font color="##FF0000">#LSNumberFormat(sumA.total,'(999,999,999,999.00)')#</font> 
				</cfif>
				</cfoutput>
				</strong></font>
			</td>
			<td class="topline" align="right"><font size="2"> <strong>
				<cfoutput> 
				<cfif sumA.totalA GTE 0>
					#LSNumberFormat(sumA.totalA,'999,999,999,999.00')# 
				<cfelse>
					<font color="##FF0000">#LSNumberFormat(sumA.totalA,'(999,999,999,999.00)')#</font> 
				</cfif>
				</cfoutput>
				</strong></font>
			</td>			
		</tr>

		<!--- **************************** PASIVOS ****************************** --->
    	<tr><td colspan="5" class="bottomline">&nbsp;</td></tr>
		<tr><td colspan="5" nowrap class="tituloListas">&nbsp;</td>	</tr>
		<cfoutput>
		<tr> 
    		<td  align="left" nowrap class="encabReporte">#MSG_Pasivo#</td>
			<td  nowrap="nowrap"  class="encabReporte"><div align="right">#Form.periodo#</div></td>
			<td  nowrap="nowrap"  class="encabReporte"><div align="right">#Form.periodo-1#</div></td>
    	</tr>
		</cfoutput>

		<cfquery name="rsCuentasP" dbtype="query">
			select Ccuenta, nivel, #preservesinglequotes(LvarCta)#, saldofin, saldofinA  from rsProc where tipo = 'P' 
		</cfquery>

		<cfoutput query="rsCuentasP"> <!---Inicio rsCuentasP--->
			<cfif session.Conta.balances.nivelSeleccionado>
                    <cfif rsCuentasP.nivel EQ (varNivel - 1) or (esHoja(rsCuentasP.CCUENTA) EQ "S")>
                    <tr style="padding:2px; "> 
                        <td width="50%" align="left" nowrap> 
                            #descrip#
                        </td>
                        <td align="right">
                            <cfif rsCuentasP.saldofin GTE 0>#LSNumberFormat(rsCuentasP.saldofin,'999,999,999,999,999.00')# 
                            <cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasP.saldofin,'999,999,999,999,999.00()')#</font> 
                            </cfif>
                        </td>				
                        <td align="right">
                            <cfif rsCuentasP.saldofinA GTE 0>#LSNumberFormat(rsCuentasP.saldofinA,'999,999,999,999,999.00')# 
                            <cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasP.saldofinA,'999,999,999,999,999.00()')#</font> 
                            </cfif>
                        </td>
                    </tr>
                </cfif>
            <cfelse>
            <cfif nivel EQ 0 and varNivel GT 1><tr><td colspan="5">&nbsp;</td></tr></cfif>
              <tr <cfif rsCuentasP.nivel EQ 0>class="tituloListas"</cfif>> 
                <td width="50%" align="left" nowrap> 
                  <cfif rsCuentasP.nivel EQ 0>
                    <font size="2"><strong>#descrip#</strong></font> 
                    <cfelse>
                        <cfset LvarContP = rsCuentasP.nivel>
                        <cfloop condition="LvarContP NEQ 0">
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <cfset LvarContP = LvarContP - 1>
                        </cfloop>
                        #descrip#</cfif> </td>
                <td align="right">
                    <cfif rsCuentasP.nivel EQ 0>
                        <strong><font size="2">
                    </cfif>
                            <cfif rsCuentasP.saldofin GTE 0>#LSNumberFormat(rsCuentasP.saldofin,'999,999,999,999,999.00')# 
                            <cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasP.saldofin,'999,999,999,999,999.00()')#</font> 
                            </cfif>
                    <cfif rsCuentasP.nivel EQ 0>
                        </font></strong>
                    </cfif>
                </td>				
                <td align="right">
                    <cfif rsCuentasP.nivel EQ 0>
                        <strong><font size="2">
                    </cfif>
                            <cfif rsCuentasP.saldofinA GTE 0>#LSNumberFormat(rsCuentasP.saldofinA,'999,999,999,999,999.00')# 
                            <cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasP.saldofinA,'999,999,999,999,999.00()')#</font> 
                            </cfif>
                    <cfif rsCuentasP.nivel EQ 0>
                        </font></strong>
                    </cfif>
                </td>
              </tr>
            </cfif>
		</cfoutput> <!---Fin rsCuentasP--->
		<cfquery name="sumP" dbtype="query">
			select sum(saldofin) as total ,
			sum(saldofinA) as totalA
			from rsCuentasP where nivel = 0 
		</cfquery>
		<tr><td colspan="5">&nbsp;</td></tr>
		<tr> 
			<td class="topline"  nowrap><b>TOTAL <cfoutput>#MSG_Pasivo#</cfoutput></b></div></td>
			<td class="topline" align="right"><font size="2"> <strong>
				<cfoutput> 
				<cfif sumP.total GTE 0>
					#LSNumberFormat(sumP.total,'999,999,999,999.00')# 
				<cfelse>
					<font color="##FF0000">#LSNumberFormat(sumP.total,'(999,999,999,999.00)')#</font> 
				</cfif>
				</cfoutput>
				</strong></font>
			</td>
			<td class="topline" align="right"><font size="2"> <strong>
				<cfoutput> 
				<cfif sumP.totalA GTE 0>
					#LSNumberFormat(sumP.totalA,'999,999,999,999.00')# 
				<cfelse>
					<font color="##FF0000">#LSNumberFormat(sumP.totalA,'(999,999,999,999.00)')#</font> 
				</cfif>
				</cfoutput>
				</strong></font>
			</td>			
		</tr>

	<!--- **************************** Capital ****************************** --->
    <tr><td colspan="5" class="bottomline">&nbsp;</td></tr>
	<tr><td colspan="5" nowrap class="tituloListas">&nbsp;</td></tr>
    <cfoutput>
		<tr> 
    		<td  align="left" nowrap class="encabReporte">#MSG_Capital#  </td>
			<td  nowrap="nowrap"  class="encabReporte"><div align="right">#Form.periodo#</div></td>
			<td  nowrap="nowrap"  class="encabReporte"><div align="right">#Form.periodo-1#</div></td>
    	</tr>
	</cfoutput>
	<cfquery name="rsCuentasC" dbtype="query">
	    select nivel, Ccuenta, #preservesinglequotes(LvarCta)#, saldofin, saldofinA from rsProc where tipo = 'C' 
    </cfquery>
    
    <cfoutput query="rsCuentasC">
    	<cfif session.Conta.balances.nivelSeleccionado>
			<cfif rsCuentasC.nivel EQ (varNivel - 1) or (esHoja(rsCuentasC.Ccuenta) EQ "S")>
                <tr style="padding:2px; "> 
                    <td width="50%" align="left" nowrap> 
                        #descrip#
                    </td>
                    <td align="right">
                        <cfif rsCuentasC.saldofin GTE 0>#LSNumberFormat(rsCuentasC.saldofin,'999,999,999,999,999.00')# 
                        <cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasC.saldofin,'999,999,999,999,999.00()')#</font> 
                        </cfif>
                    </td>				
                    <td align="right">
                        <cfif rsCuentasC.saldofinA GTE 0>#LSNumberFormat(rsCuentasC.saldofinA,'999,999,999,999,999.00')# 
                        <cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasC.saldofinA,'999,999,999,999,999.00()')#</font> 
                        </cfif>
                    </td>
                </tr>
            </cfif>
		<cfelse>
	  <cfif nivel EQ 0 and varNivel GT 1><tr><td colspan="5">&nbsp;</td></tr></cfif> 
      <tr <cfif rsCuentasC.nivel EQ 0>class="tituloListas"</cfif>> 
        <td width="50%" align="left" nowrap> 
          <cfif rsCuentasC.nivel EQ 0>
            <font size="2"><strong>#descrip#</strong></font> 
            <cfelse>
                <cfset LvarContC = rsCuentasC.nivel>
                <cfloop condition="LvarContC NEQ 0">
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfset LvarContC = LvarContC - 1>
                </cfloop>
            #descrip#</cfif> </td>
        <td align="right">
            <cfif rsCuentasC.nivel EQ 0>
                <strong><font size="2">
            </cfif>
            <cfif rsCuentasC.saldofin GTE 0>#LSNumberFormat(rsCuentasC.saldofin,'999,999,999,999,999.00')# 
            <cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasC.saldofin,'999,999,999,999,999.00()')#</font> 
            </cfif>
            <cfif rsCuentasC.nivel EQ 0>
                </font></strong>
            </cfif>
        </td>
        <td align="right">
            <cfif rsCuentasC.nivel EQ 0>
                <strong><font size="2">
            </cfif>
            <cfif rsCuentasC.saldofinA GTE 0>#LSNumberFormat(rsCuentasC.saldofinA,'999,999,999,999,999.00')# 
            <cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasC.saldofinA,'999,999,999,999,999.00()')#</font> 
            </cfif>
            <cfif rsCuentasC.nivel EQ 0>
                </font></strong>
            </cfif>
        </td>
      </tr>
      </cfif>
    </cfoutput> 
	<!--- Utilidad --->
    <tr><td colspan="5">&nbsp;</td></tr>
    <tr class="tituloListas"> 
       <td><strong><font size="2"><cfoutput>#MSG_Utilidad#</cfoutput></font></strong></td> 
      <td><div align="right"><font size="2"><strong>
          <cfoutput> 
            <cfif rsProc.utilidadsaldo GTE 0>
              #LSNumberFormat(rsProc.utilidadsaldo,'999,999,999,999,999.00')# 
              <cfelse>
              <font color="##FF0000">#LSNumberFormat(rsProc.utilidadsaldo,'999,999,999,999,999.00()')#</font> 
            </cfif>
          </cfoutput> </strong></font></div></td>
      <td><div align="right"><font size="2"><strong>
          <cfoutput> 
            <cfif rsProc.utilidadsaldoA GTE 0>
              #LSNumberFormat(rsProc.utilidadsaldoA,'999,999,999,999,999.00')# 
              <cfelse>
              <font color="##FF0000">#LSNumberFormat(rsProc.utilidadsaldoA,'999,999,999,999,999.00()')#</font> 
            </cfif>
          </cfoutput> </strong></font></div></td>
		  
    </tr>
		<cfquery name="sumC" dbtype="query">
			select sum(saldofin) as total ,sum(saldofinA) as totalA 
			from rsCuentasC 
			where nivel = 0 
		</cfquery>
		<cfset totalC = iif(len(trim(rsProc.utilidadsaldo)) GT 0,de(rsProc.utilidadsaldo),0.00)>
		<cfset totalCA = iif(len(trim(rsProc.utilidadsaldoA)) GT 0,de(rsProc.utilidadsaldoA),0.00)>
		<cfif sumC.recordCount>
			<cfset totalC = totalC + sumC.total>
			<cfset totalCA = totalCA + sumC.totalA>
		</cfif>
	<tr><td colspan="5">&nbsp;</td></tr>
    <tr> 
      <td class="topline"><b>TOTAL <cfoutput>#MSG_Capital# </cfoutput></b></td>
       <td class="topline"><div align="right"><font size="2"><strong><cfoutput> 
            <cfif sumC.total GTE 0>
              #LSNumberFormat(totalC,',9.00')# 
              <cfelse>
              <font color="##FF0000">#LSNumberFormat(totalC,',9.00()')#</font> 
            </cfif>
          </cfoutput> </strong> </font></div></td>
      <td class="topline"><div align="right"><font size="2"><strong><cfoutput> 
            <cfif sumC.totalA GTE 0>
              #LSNumberFormat(totalCA,',9.00')# 
              <cfelse>
              <font color="##FF0000">#LSNumberFormat(totalCA,',9.00()')#</font> 
            </cfif>
          </cfoutput> </strong> </font></div></td>
    </tr>
    <tr> 
      <td colspan="5">&nbsp;</td>
    </tr>
    <cfquery name="sumPCU" dbtype="query">
    	select sum(saldofin) as total ,sum(saldofinA) as totalA 
		from rsProc 
		where nivel = 0 and 
		tipo in ('P','C') 
    </cfquery>
	<cfset totalPCU = iif(len(trim(rsProc.utilidadsaldo)) GT 0, de(rsProc.utilidadsaldo),0.00)>
	<cfset totalPCUA = iif(len(trim(rsProc.utilidadsaldoA)) GT 0, de(rsProc.utilidadsaldoA),0.00)>
	
	<cfif sumPCU.recordCount>
		<cfset totalPCU = totalPCU + sumPCU.total>
		<cfset totalPCUA = totalPCUA + sumPCU.totalA>
	</cfif>

	<!--- **************************** Total Pasivo y Capital ****************************** --->

    <tr bgcolor="#CCCCCC" class="tituloAlterno"> 
     	<td ><div align="left"><strong><font size="3">TOTAL <cfoutput>#MSG_PasivoCapital#</cfoutput></font></strong></div></td>
        <td>
		  <cfoutput> 
			<div align="right"><font size="2"><strong> 
            <cfif totalPCU GTE 0>
              #LSNumberFormat(totalPCU,',9.00')# 
              <cfelse>
              <font color="##FF0000">#LSNumberFormat(totalPCU,',9.00()')#</font> 
            </cfif>
            </strong></font></div>
		  </cfoutput> 
		</td>
        <td>
		  <cfoutput> 
			<div align="right"><font size="2"><strong> 
            <cfif totalPCUA GTE 0>
              #LSNumberFormat(totalPCUA,',9.00')# 
              <cfelse>
              <font color="##FF0000">#LSNumberFormat(totalPCUA,',9.00()')#</font> 
            </cfif>
            </strong></font></div>
		  </cfoutput> 
		</td>
	</tr>
    <tr>
		<td colspan="5">&nbsp;</td>
	</tr>
    <tr>
		<td colspan="5">&nbsp;</td>
	</tr>
    <tr> 
      <td colspan="5"><div align="center" class="tituloLeyenda" ><cfoutput>#rsLeyenda.Pvalor#</cfoutput></div></td>
    </tr>
    <tr>
		<td colspan="5">&nbsp;</td>
	</tr>
    <tr> 
      <td colspan="5"><div align="center">------------------ <cfoutput>#MGS_FinDelReporte#</cfoutput> ------------------</div></td>
    </tr>
  </table>
</form>

