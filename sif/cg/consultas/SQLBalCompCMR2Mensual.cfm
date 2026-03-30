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
<cfinvoke key="LB_Cuenta" 			default="Cuenta"			returnvariable="LB_Cuenta" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_BalanceComprobacion"	default="Balance de Comprobaci&oacute;n"	returnvariable="MSG_BalanceComprobacion"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_SaldoInicial" 		default="Saldo Inicial"						returnvariable="MSG_SaldoInicial"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Debitos"				default="D&eacute;bitos"					returnvariable="MSG_Debitos"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Creditos" 			default="Cr&eacute;ditos"					returnvariable="MSG_Creditos"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_SaldoFinal"			default="Saldo Final"						returnvariable="MSG_SaldoFinal"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_TotalesFinales" 		default="Totales Finales"					returnvariable="MSG_TotalesFinales"			component="sif.Componentes.Translate" method="Translate"/>

<cf_PleaseWait SERVER_NAME="/cfmx/sif/cg/consultas/SQLBalCompR2Mensual.cfm" >
<cfsetting enablecfoutputonly="yes">
<cfsetting requesttimeout="3600"> 
<cfparam name="url.IncluirOficina" default="N">
<cfparam name="url.chkCeros" default = "N">
<cfparam name="url.formato" default="HTML">
<cfparam name="url.CHKMesCierre" default="0">
<cfparam name="url.CHKMesCierre" default="0">
<cfparam name="url.CHKMensual" default="0">
<cfparam name="url.CHKNivelSeleccionado" default="0">

<cfset session.Conta.balances.nivelSeleccionado = (form.NivelSeleccionado EQ "1")>
<cfif isdefined("form.IncluirOficina")>
	<cfset url.IncluirOficina = form.IncluirOficina>
</cfif>
<cfif isdefined("form.CHKMesCierre")>
	<cfset url.CHKMesCierre = form.CHKMesCierre>
</cfif>
<cfif isdefined("form.CMAYOR_CCUENTA1")>
	 <cfset url.CMAYOR_CCUENTA1 = form.CMAYOR_CCUENTA1>
</cfif>
<cfif isdefined("form.CMAYOR_CCUENTA2")>
	 <cfset url.CMAYOR_CCUENTA2 = form.CMAYOR_CCUENTA2>
</cfif>
<cfif isdefined("form.FORMATO")>
	 <cfset form.FORMATO = form.FORMATO>
</cfif>
<cfif isdefined("form.MCODIGO")>
	 <cfset url.MCODIGO = form.MCODIGO>
</cfif>
<cfif isdefined("form.MCODIGOOPT")>
	 <cfset url.MCODIGOOPT = form.MCODIGOOPT>
</cfif>
<cfif isdefined("form.MES")>
	<cfset url.MES = form.MES>
</cfif>
<cfif isdefined("form.NIVEL")>
	<cfset url.NIVEL = form.NIVEL>
    <cfset varNivel = url.NIVEL>
</cfif>

<cfif isdefined("form.PERIODO")>
	<cfset url.PERIODO = form.PERIODO>
</cfif>
<cfif isdefined("form.UBICACION")>
	<cfset url.UBICACION = form.UBICACION>
</cfif>
<cfif isdefined("form.MostrarCeros")>
	<cfset url.chkCeros = form.MostrarCeros>
</cfif>
<cfif isdefined("form.CHKMensual")>
	<cfset url.CHKMensual = form.CHKMensual>
</cfif>

<cfif isdefined("form.NivelSeleccionado")>
	<cfset url.CHKNivelSeleccionado = form.NivelSeleccionado>
</cfif>

<cfset varMcodigo = "">
<cfset LvarIncluirOficina = false>
<cfif isdefined("url.IncluirOficina") and url.IncluirOficina EQ "S">
	<cfset LvarIncluirOficina = true>
</cfif>

<cfset LvarMostarCeros = "N">
<cfif isdefined("url.MostrarCeros") and url.MostrarCeros EQ "S">
	<cfset LvarMostarCeros = "S">
</cfif>
<cfif isdefined("url.ChkCeros") and url.ChkCeros EQ "S">
	<cfset LvarMostarCeros = "S">
</cfif>
<cfif isdefined("form.MostrarCeros") and form.MostrarCeros EQ "S">
	<cfset LvarMostarCeros = "S">
</cfif>

<cfif isdefined("url.mcodigoopt") and url.mcodigoopt EQ "0">
	<cfset varMcodigo = url.Mcodigo>
<cfelse>
	<cfset varMcodigo = url.mcodigoopt>
</cfif>

<cfset moneda ="">

<cfif isdefined("url.mcodigoopt") and url.mcodigoopt EQ "-2">
	<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
		select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
		from Empresas a, Monedas b 
		where a.Ecodigo =  #Session.Ecodigo# 
		  and a.Mcodigo = b.Mcodigo
	</cfquery>
	<cfset moneda =rsMonedaLocal.Mnombre>
<cfelseif isdefined("url.mcodigoopt") and url.mcodigoopt EQ "-3">
	<cfquery name="rsParam" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo =  #Session.Ecodigo# 
		and Pcodigo = 660
	</cfquery>
	<cfif rsParam.recordCount> 
		<cfquery name="rsMonedaConvertida" datasource="#Session.DSN#">
			select Mcodigo, Mnombre
			from Monedas
			where Ecodigo =  #Session.Ecodigo# 
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParam.Pvalor#">
		</cfquery>
	</cfif>
	<cfset moneda ='Convertida a ' & rsMonedaConvertida.Mnombre>
<cfelseif  isdefined("url.mcodigoopt") and url.mcodigoopt EQ "0">
	<cfquery name="rsMonedaSel" datasource="#Session.DSN#">
		select Mcodigo, Mnombre
		from Monedas
		where Ecodigo =  #Session.Ecodigo# 
		and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Mcodigo#">
	</cfquery>
	<cfset moneda ='Montos en ' & rsMonedaSel.Mnombre>
</cfif>

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

<cffunction name="obtenerNivel" returntype="numeric" description="">
	<cfargument name="nivel" type="numeric" required="yes">
    <cfquery name="rsObtenerNivel" datasource="#Session.DSN#">
    	Select PCDCniv
        From PCDCatalogoCuenta 
        Where Ccuentaniv = #arguments.nivel#
  	</cfquery>
    <cfreturn rsObtenerNivel.PCDCniv>
</cffunction>

<cfif isdefined("url.cmayor_ccuenta1") and url.cmayor_ccuenta1 NEQ "">
	<cfset varCuentaini = url.cmayor_ccuenta1>
	<cfif isdefined("url.cformato1") and url.cformato1 NEQ "">
		<cfset varCuentaini = varCuentaini & "-" & url.cformato1>
	</cfif>
<cfelse>
	<cfset varCuentaini = "">
</cfif>	

<cfif isdefined("url.cmayor_ccuenta2") and url.cmayor_ccuenta2 NEQ "">
	<cfset varCuentafin = url.cmayor_ccuenta2>
	<cfif isdefined("url.cformato2") and url.cformato2 NEQ "">
		<cfset varCuentafin = varCuentafin & "-" & url.cformato2>
	</cfif>
<cfelse>
	<cfset varCuentafin = "">
</cfif>

<!--- Empresas u Oficinas --->
<cfif isDefined("url.ubicacion")>
	<cfset myEcodigo = IIf(len(trim(url.ubicacion)) EQ 0, session.Ecodigo,-1)>
	<cfset myGEid    = IIf(ListFirst(url.ubicacion) EQ 'ge', ListRest(url.ubicacion), -1)>
	<cfset myGOid    = IIf(ListFirst(url.ubicacion) EQ 'go', ListRest(url.ubicacion), -1)>
	<cfset myOcodigo = IIf(ListFirst(url.ubicacion) EQ 'of', ListRest(url.ubicacion), -1)>
	<cfset mySLinicial = "SLinicialGE">
	<cfset mySOinicial = "SOinicialGE">
<cfelse>
	<cfset myEcodigo = session.Ecodigo>
	<cfset myGEid = "-1">
	<cfset myGOid = "-1">
	<cfset myOcodigo = "-1">
	<cfset mySLinicial = "SLinicial">
	<cfset mySOinicial = "SOinicial">
</cfif>

<!--- Obtiene la Ubicación --->
<cfset ubiDescripcion = "- Todas -">
<cfif myOcodigo NEQ -1>
	<cfquery name="rsOficinas" datasource="#Session.DSN#">
		select Odescripcion
		from Oficinas 
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer"> 
		  and Ocodigo = <cfqueryparam value="#myOcodigo#" cfsqltype="cf_sql_integer"> 
	</cfquery>
	<cfif rsOficinas.recordCount EQ 1>
		<cfset ubiDescripcion = "- Oficina: " & #rsOficinas.Odescripcion# & " -">
	<cfelse><cfset ubiDescripcion = "- Todas las Oficinas -">
	</cfif>

<cfelseif myEcodigo NEQ -1>
	<cfset ubiDescripcion = "- Empresa: " & #HTMLEditFormat(session.Enombre)# & " -">

<cfelseif myGEid NEQ -1>
	<cfquery name="rsGE" datasource="#session.DSN#">
		select ge.GEnombre
		from AnexoGEmpresa ge
			join AnexoGEmpresaDet gd
				on ge.GEid = gd.GEid
		where ge.CEcodigo =  #session.CEcodigo# 
		  and gd.Ecodigo =  #session.Ecodigo# 
		  and ge.GEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#myGEid#">
		order by ge.GEnombre
	</cfquery>
	<cfif rsGE.recordCount EQ 1>
		<cfset ubiDescripcion = "- Grupo de Empresa: " & #rsGE.GEnombre# & " -">
	<cfelse><cfset ubiDescripcion = "- Todos las Grupos de Empresa -">
	</cfif>
	
<cfelseif myGOid NEQ -1>
	<cfquery name="rsGO" datasource="#session.DSN#">
		select GOid, GOnombre
		from AnexoGOficina
		where Ecodigo =  #session.Ecodigo# 
		  and GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#myGOid#">
		order by GOnombre
	</cfquery>
	<cfif rsGO.recordCount EQ 1>
		<cfset ubiDescripcion = "- Grupo de Oficina: " & #rsGO.GOnombre# & " -">
	<cfelse><cfset ubiDescripcion = "- Todos las Grupos de Oficina -">
	</cfif>	
</cfif>

<cfset strMes = arraynew(1)>
<cfset strMes[1] = "#CMB_Enero#"> 
<cfset strMes[2] = "#CMB_Febrero#"> 
<cfset strMes[3] = "#CMB_Marzo#"> 
<cfset strMes[4] = "#CMB_Abril#"> 
<cfset strMes[5] = "#CMB_Mayo#"> 
<cfset strMes[6] = "#CMB_Junio#"> 
<cfset strMes[7] = "#CMB_Julio#"> 
<cfset strMes[8] = "#CMB_Agosto#"> 
<cfset strMes[9] = "#CMB_Setiembre#"> 
<cfset strMes[10] = "#CMB_Octubre#"> 
<cfset strMes[11] = "#CMB_Noviembre#"> 										
<cfset strMes[12] = "#CMB_Diciembre#"> 

<cfquery name="rsNombreEmpresa" datasource="#session.dsn#">
	select e.Edescripcion
	from Empresas e
	where e.Ecodigo = #session.Ecodigo#
</cfquery>

<cfoutput>
<cf_htmlreportsheaders
	title="Balance de Comprobaci&oacute;n" 
	filename="BalanceComprobacion-#Session.Usucodigo#.xls" 
	ira="BalCompR.cfm">
	<cfif not isdefined('form.btnDownload')>
	<cf_templatecss>
</cfif>
</cfoutput>

<cfquery name="rsCuentas" datasource="#session.dsn#">
	select c.Ccuenta, c.Cformato, <cf_dbfunction name="sPart"	args="c.Cdescripcion,1, 40"> as Cdescripcion
	from CContables c
	where c.Ecodigo = #session.Ecodigo#
	<cfif len(trim(url.CMAYOR_CCUENTA1)) GT 0>
	  and c.Cmayor >= '#url.CMAYOR_CCUENTA1#'
	</cfif>
	<cfif len(trim(url.CMAYOR_CCUENTA2)) GT 0>
	  and c.Cmayor <= '#url.CMAYOR_CCUENTA2#'
	</cfif>
	<cfif url.chkCeros NEQ "S">
		and exists (
			select 1
			from SaldosContables s
			where s.Ccuenta  = c.Ccuenta
			  and s.Speriodo = #url.periodo#
			  and s.Smes     <= #url.mes# 
			  and (s.#mySLinicial# <> 0 or s.DLdebitos <> 0 or s.CLcreditos <> 0)
		)
	</cfif>
	  and exists(
	  	select 1
		from PCDCatalogoCuenta cu
		where cu.Ccuentaniv = c.Ccuenta
		  and cu.PCDCniv <= #url.NIVEL# - 1
		)
	order by c.Cformato
</cfquery>

<!--- columnas:  Cuenta, Descripcion, Saldo Inicial, Debitos - Creditos por cada mes, Saldo Final --->
<cfset LvarCantidadColumnas = 4 + (url.mes * 2)>
<cfset LvarDebitos = arraynew(1)>
<cfset LvarCreditos = arraynew(1)>
<cfset arrayset(LvarDebitos, 1, LvarCantidadColumnas, 0)>
<cfset arrayset(LvarCreditos, 1, LvarCantidadColumnas, 0)>

<cfset TotalSaldoInicial = 0>
<cfset TotalSaldoFinal = 0>

<cfset LvarContador = 1>

<cfflush interval="128">
<cfoutput>
	<style type="text/css">
		.corte {
			font-weight: bold; 
		}
	</style>
		<table cellpadding="5" cellspacing="5" border="0">
			<tr>
				<td colspan="#LvarCantidadColumnas - 1#">&nbsp;</td>
				<td align="right">#DateFormat(now(),"DD/MM/YYYY")#</td>
			</tr>					
			<tr >
				<td style="font-size:16px" align="center" colspan="#LvarCantidadColumnas#">
				<strong>#rsNombreEmpresa.Edescripcion#</strong>	
				</td>
			</tr>
			<tr>
				<td style="font-size:16px" align="center" colspan="#LvarCantidadColumnas#">
				<strong>#MSG_BalanceComprobacion#</strong>
				</td>
			</tr>
			<tr>
				<td style="font-size:16px" align="center" colspan="#LvarCantidadColumnas#">
				<strong>#strMes[url.mes]# - #url.periodo#</strong>
				</td>
			</tr>
			<tr>
				<td colspan="#LvarCantidadColumnas#">&nbsp;</td>
			</tr>
			<tr bgcolor="##CCCCCC">
				<td nowrap rowspan="2" colspan="2" align="center"><strong>#LB_Cuenta#</strong></td>
				<!--- <td nowrap><strong>Nombre</strong></td> --->
				<td nowrap align="right" rowspan="2"><strong>#MSG_SaldoInicial#</strong></td>
				<cfset LvarContador = 1>
				<cfset CONTROL = 1>
				<cfloop condition="CONTROL LTE url.Mes">
					<td align="right" rowspan="2"><strong>#MSG_Debitos#<br/>#strMes[CONTROL]#</strong></td>
					<td align="right" rowspan="2"><strong>#MSG_Creditos#<br/>#strMes[CONTROL]#</strong></td>
					<cfset LvarContador = LvarContador + 2>
					<cfset CONTROL = CONTROL + 1>
				</cfloop>
				<td nowrap align="right" rowspan="2"><strong>#MSG_SaldoFinal#</strong></td>
			</tr>
			<tr><td colspan="#LvarCantidadColumnas#">&nbsp;</td></tr>
			<cfloop query="rsCuentas">            
				<cfset LvarSaldoFinal = 0>
                <cfquery name="rsReporte" datasource="#session.dsn#">
                    select sum(#mySLinicial#) as saldoini
                    from SaldosContables s
                    where s.Ccuenta  = #rsCuentas.Ccuenta#
                      and s.Speriodo = #url.periodo#
                      and s.Smes     = 1
                </cfquery>
                <cfquery name="rsReporteM" datasource="#session.dsn#">
                    select 
                        Smes, 
                        coalesce(sum(DLdebitos), 0.00) as Debitos, 
                        coalesce(sum(CLcreditos), 0.00) as Creditos
                    from SaldosContables s
                    where s.Ccuenta  = #rsCuentas.Ccuenta#
                      and s.Speriodo = #url.periodo#
                      and s.Smes     <= #url.mes#
                    group by Smes
                </cfquery>	
                	<cfif session.Conta.balances.nivelSeleccionado>
						<cfif obtenerNivel(rsCuentas.Ccuenta) EQ (varNivel - 1) or (esHoja(rsCuentas.Ccuenta) EQ "S")>			                                
                            <tr <cfif len(rsCuentas.Cformato) LT 5>class="corte"</cfif>>
                            <td nowrap >&nbsp;<cfif len(trim(rsCuentas.Cformato)) GT 5>&nbsp;&nbsp;&nbsp;</cfif>#rsCuentas.Cformato#</td>
                            <td nowrap >&nbsp;#rsCuentas.Cdescripcion#</td>
                        </cfif>
                   	<cfelse>
                            <tr <cfif len(rsCuentas.Cformato) LT 5>class="corte"</cfif>>
                            <td nowrap >&nbsp;<cfif len(trim(rsCuentas.Cformato)) GT 5>&nbsp;&nbsp;&nbsp;</cfif>#rsCuentas.Cformato#</td>
                            <td nowrap >&nbsp;#rsCuentas.Cdescripcion#</td>
                  	</cfif>
                    <cfif isdefined("rsReporte") and rsReporte.recordcount GT 0 and len(trim(rsReporte.saldoini))>
						<cfif session.Conta.balances.nivelSeleccionado>
                			<cfif obtenerNivel(rsCuentas.Ccuenta) EQ (varNivel - 1) or (esHoja(rsCuentas.Ccuenta) EQ "S")>	
	                        	<tr  ><td nowrap align="right">#numberformat(rsReporte.saldoini, ",9.00")#</td>
                           	</cfif>
                       	<cfelse>
                        	<tr  ><td nowrap align="right">#numberformat(rsReporte.saldoini, ",9.00")#</td>
                     	</cfif>
                        <cfset LvarSaldoFinal = rsReporte.saldoini>
                    <cfelse>
                    	<cfif session.Conta.balances.nivelSeleccionado>
                			<cfif obtenerNivel(rsCuentas.Ccuenta) EQ (varNivel - 1) or (esHoja(rsCuentas.Ccuenta) EQ "S")>	
                        		<tr  ><td nowrap align="right">0.00</td>
                           	</cfif>
                       	<cfelse>
                        	<tr  ><td nowrap align="right">0.00</td>
                       	</cfif>
                        <cfset LvarSaldoFinal = 0.00>
                    </cfif>
                    <cfif len(rsCuentas.Cformato) LT 5>
                        <cfset TotalSaldoInicial = TotalSaldoInicial + LvarSaldoFinal>				
                    </cfif>
                    <cfset LvarContador = 1>
                    <cfloop condition="LvarContador LTE url.Mes">
                        <cfquery name="rsMovimientos" dbtype="query">
                            select Debitos, Creditos
                            from rsReporteM
                            where Smes = #LvarContador#
                        </cfquery>
                        <cfif isdefined("rsMovimientos") and rsMovimientos.recordcount GT 0 and len(trim(rsMovimientos.Debitos))>
                        	<cfif session.Conta.balances.nivelSeleccionado>
                				<cfif obtenerNivel(rsCuentas.Ccuenta) EQ (varNivel - 1) or (esHoja(rsCuentas.Ccuenta) EQ "S")>
                                    <tr  ><td nowrap align="right">#numberformat(rsMovimientos.debitos, ",9.00")#</td>
                                    <td nowrap align="right">#numberformat(rsMovimientos.creditos, ",9.00")#</td>
                              	</cfif>
                          	<cfelse>
                            	<tr  ><td nowrap align="right">#numberformat(rsMovimientos.debitos, ",9.00")#</td>
                           		<td nowrap align="right">#numberformat(rsMovimientos.creditos, ",9.00")#</td>
                           	</cfif>
                            <cfset LvarSaldoFinal = LvarSaldoFinal + rsMovimientos.debitos>
                            <cfset LvarSaldoFinal = LvarSaldoFinal - rsMovimientos.creditos>
                            <cfif len(trim(rsCuentas.Cformato)) LT 5>
                                <cfset LvarDebitos[LvarContador] = LvarDebitos[LvarContador] + rsMovimientos.debitos>
                                <cfset LvarCeditos[LvarContador] = LvarCreditos[LvarContador] + rsMovimientos.creditos>
                                <cfset TotalSaldoInicial = 0>
                                <cfset TotalSaldoFinal = TotalSaldoFinal + LvarSaldoFinal>
                            </cfif>
                        <cfelse>
                        	<cfif session.Conta.balances.nivelSeleccionado>
                				<cfif obtenerNivel(rsCuentas.Ccuenta) EQ (varNivel - 1) or (esHoja(rsCuentas.Ccuenta) EQ "S")>
                                    <tr  ><td nowrap align="right">0.00</td>
                                    <td nowrap align="right">0.00</td>
                              	</cfif>
                          	<cfelse>
                            	 <tr  ><td nowrap align="right">0.00</td>
                                 <td nowrap align="right">0.00</td>
                         	</cfif>
                        </cfif>
                        <cfset LvarContador = LvarContador + 1>
                    </cfloop>
                    	<cfif session.Conta.balances.nivelSeleccionado>
                			<cfif obtenerNivel(rsCuentas.Ccuenta) EQ (varNivel - 1) or (esHoja(rsCuentas.Ccuenta) EQ "S")>
                    			<tr  ><td nowrap align="right">#numberformat(LvarSaldoFinal, ",9.00")#</td>
                           	</cfif>
                       	<cfelse>
                        	<tr  ><td nowrap align="right">#numberformat(LvarSaldoFinal, ",9.00")#</td>
                      	</cfif>
                </tr>  	
			</cfloop>
			<tr  bgcolor="##CCCCCC">
				<td nowrap colspan="2"><strong>#MSG_TotalesFinales#:</strong></td>
				<td style="border-top:double" nowrap align="right"><strong>#numberformat(TotalSaldoInicial, ",9.00")#</strong></td>
				<cfset LvarContador = 1>
				<cfloop condition="LvarContador LTE url.Mes">
					<td style="border-top:double" nowrap align="right"><strong>#numberformat(LvarDebitos[LvarContador], ",9.00")#</strong></td>
					<td style="border-top:double" nowrap align="right"><strong>#numberformat(LvarCreditos[LvarContador], ",9.00")#</strong></td>
					<cfset LvarContador = LvarContador + 1>
				</cfloop>
				<td style="border-top:double" nowrap align="right"><strong>#numberformat(TotalSaldoFinal, ",9.00")#</strong></td>
			</tr>
		</table>
</cfoutput>
