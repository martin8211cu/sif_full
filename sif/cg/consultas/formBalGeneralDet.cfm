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
<cfinvoke key="MSG_GrupoOficinas" 	default="Grupo de Oficinas"	returnvariable="MSG_GrupoOficinas"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Periodo" 		default="Per&iacute;odo"	returnvariable="MSG_Periodo"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Balance_General"	default="Balance General Detallado"	returnvariable="MSG_Balance_General"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Activo" 			default="ACTIVO"			returnvariable="MSG_Activo"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Pasivo" 			default="PASIVO"			returnvariable="MSG_Pasivo"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Capital" 		default="CAPITAL"			returnvariable="MSG_Capital"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Utilidad" 		default="UTILIDAD DEL PERIODO"returnvariable="MSG_Utilidad"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_PasivoCapital"	default="PASIVO Y CAPITAL"	returnvariable="MSG_PasivoCapital"		component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke key="MSG_Mes_Actual"		default="Mes Actual"		returnvariable="MSG_Mes_Actual"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Mes_Anterior"	default="Mes Anterior"		returnvariable="MSG_Mes_Anterior"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Variacion"		default="Variacion"			returnvariable="MSG_Variacion"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Favor_En_Contra"	default="A Favor (En Contra)"returnvariable="MSG_Favor_En_Contra"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Ano_Anterior"	default="Año Anterior"		returnvariable="MSG_Ano_Anterior"		component="sif.Componentes.Translate" method="Translate"/>

<cfparam name="form.chkConCodigo" default="0">
<cfset session.Conta.balances.ConCodigo = (form.chkConCodigo EQ "1")>
<cfif session.Conta.balances.ConCodigo>
	<cfset LvarCta = "formato + ' ' + descrip as descrip">
<cfelse>
	<cfset LvarCta = "descrip">
</cfif>

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
<cfquery name="rsMesFiscal" datasource="#Session.DSN#">
    select Pvalor 
    from Parametros
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
      and Pcodigo = 45
</cfquery>
 <cfset LvarMesFiscal= rsMesFiscal.Pvalor>
        
<cfset oficina = "Todas">
<cfif rsOficina.recordCount eq 1>
	<cfset oficina = rsOficina.Odescripcion>
</cfif>

<cfif isdefined("url.periodo")>
	<cfparam name="Form.periodo" default="#url.periodo#">
</cfif>
<cfif isdefined("url.mes")>
	<cfparam name="Form.mes" default="#url.mes#">
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

   

<cfif Form.mes eq 1>
	<cfset MesAnterior = 12>
	<cfset periodoMesAnterior = (Form.periodo - 1)>
<cfelse> 
	<cfset MesAnterior = (Form.mes - 1)>
	<cfset periodoMesAnterior = (Form.periodo)>
</cfif>

<cfif Form.mes gt LvarMesFiscal>
	<cfset periodoFinAnterior = (Form.periodo)>
<cfelse>
	<cfset periodoFinAnterior = (Form.periodo - 1)>
</cfif>    



<cfset moneda ="">
<cfif isdefined("Form.mcodigoopt") and Form.mcodigoopt EQ "-2">
	<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
		select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
		from Empresas a, Monedas b 
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.Mcodigo = b.Mcodigo
	</cfquery>
	<cfset moneda =rsMonedaLocal.Mnombre>
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
	<cfset moneda ='Convertida a ' & rsMonedaConvertida.Mnombre>
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
	<cfset moneda ='Informe B15 en ' & rsMonedaB15.Mnombre>
<cfelseif  isdefined("Form.mcodigoopt") and Form.mcodigoopt EQ "0">
	<cfquery name="rsMonedaSel" datasource="#Session.DSN#">
		select Mcodigo, Mnombre
		from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
	</cfquery>
	<cfset moneda ='Montos en ' & rsMonedaSel.Mnombre>
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

<cftransaction>		
	<cfinvoke returnvariable="rsProc" component="sif.Componentes.sp_SIF_CG0005_Detallado" method="balanceGeneral" 
		Ecodigo="#Session.Ecodigo#"
		periodo="#Form.periodo#"
		mes="#Form.mes#"
		ceros="N"
		nivel = "#varNivel#"
		Mcodigo="#varMonedas#"
		Ocodigo="#varOcodigo#"
		GOid="#varGOid#"
	>
	</cfinvoke>			
</cftransaction>

<cfif isdefined("rsProc") and rsProc.recordcount gt 2499><!--- En el mensaje se pone que excede los 2500 registros  --->
	<cf_errorCode	code = "50235" msg = "La consulta excede los 2500 registros">
	<cfabort>
</cfif>

<cfif isdefined("form.botonsel") and len(trim(form.botonsel)) and form.botonsel eq "Exportar">
	<cf_exportQueryToFile query="#rsProc#"  filename="Balance_General_Detallado_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls" jdbc="false">
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
    	<tr><td colspan="8" class="tituloAlterno" align="center"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></td></tr>
    	<tr><td colspan="8">&nbsp;</td></tr>
    	<tr><td colspan="8" align="center"><b><font size="2"><cfoutput>#MSG_Balance_General#</cfoutput></font></b></td></tr>
    	<tr>
			<td colspan="8" align="center" style="padding-right: 20px">
				<b><cfoutput>#CMB_Mes#:</cfoutput></b> 
          		&nbsp;<cfoutput>#ListGetAt(meses, Form.mes, ',')#</cfoutput> 
				<b><cfoutput>#MSG_Periodo#:</cfoutput></b> &nbsp;<cfoutput>#Form.periodo#</cfoutput>
			</td>
    	</tr>
		<cfif Oficina neq 'Todas'>
			<tr>
				<td colspan="8" align="center" style="padding-right: 20px">
					<b><cfoutput>#MSG_Oficina#:</cfoutput></b> &nbsp;<cfoutput>#Oficina#</cfoutput>
				</td>
			</tr>
        </cfif>
		<cfif rsGruposOficina.recordCount eq 1>
			<tr>
				<td colspan="8" align="center" style="padding-right: 20px">
					<b><cfoutput>#MSG_GrupoOficinas#:</cfoutput></b> &nbsp;<cfoutput>#rsGruposOficina.GOnombre#</cfoutput>
				</td>
			</tr>
        </cfif>
		<tr>
			<td colspan="8" align="center" style="padding-right: 20px">
				<b><cfoutput>#moneda#</cfoutput></b>
			</td>
		</tr>		
		<!--- **************************** ACTIVOS ****************************** --->
		<tr><td colspan="8" class="bottomline">&nbsp;</td></tr>
		<tr><td colspan="8" class="tituloListas">&nbsp;</td></tr>
		<cfoutput>	
		<tr> 
    		<td width="10%" align="left" nowrap class="encabReporte">#MSG_Activo#</td>
			<td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#MSG_Mes_Actual#</div></td>
			<td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#MSG_Mes_Anterior#</div></td>
            <td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#MSG_Variacion#</div></td>
			<td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#MSG_Ano_Anterior#</div></td>
            <td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#MSG_Ano_Anterior#</div></td>
    	</tr>
        <tr> 
    		<td width="10%" align="left" nowrap class="encabReporte"></td>
			<td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#ListGetAt(meses, Form.mes, ',')#-#Form.periodo#</div></td>
			<td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#ListGetAt(meses, MesAnterior, ',')#-#periodoMesAnterior#</div></td>
            <td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#MSG_Favor_En_Contra#</div></td>
			<td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#ListGetAt(meses, LvarMesFiscal, ',')#-#periodoFinAnterior#</div></td>
            <td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#ListGetAt(meses, Form.mes, ',')#-#Form.periodo-1#</div></td>
    	</tr>
		</cfoutput>

		<cfquery name="rsCuentasA" dbtype="query">
			select nivel, #preservesinglequotes(LvarCta)#, saldoFin,saldoFinMA, saldoFin-saldoFinMA as variacion, saldoFinFA ,saldoFinPA from rsProc where tipo = 'A' 
		</cfquery>
           
		<cfoutput query="rsCuentasA"> 
			<cfif nivel EQ 0 and varNivel GT 1><tr><td colspan="8">&nbsp;</td></tr></cfif>
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
							<cfif rsCuentasA.saldoFin GTE 0>#LSNumberFormat(rsCuentasA.saldoFin,'999,999,999,999,999.00')# 
							<cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasA.saldoFin,'999,999,999,999,999.00()')#</font> 
						<cfif rsCuentasA.nivel EQ 0>
							</font></strong>
						</cfif>
						</cfif>
				</td>				
				<td align="right">
						<cfif rsCuentasA.nivel EQ 0>
							<strong><font size="2">
						</cfif>
							<cfif rsCuentasA.saldoFinMA GTE 0>#LSNumberFormat(rsCuentasA.saldoFinMA,'999,999,999,999,999.00')# 
							<cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasA.saldoFinMA,'999,999,999,999,999.00()')#</font> 
							</cfif>
						<cfif rsCuentasA.nivel EQ 0>
							</font></strong>
						</cfif>
				</td>
               <td align="right">
						<cfif rsCuentasA.nivel EQ 0>
							<strong><font size="2">
						</cfif>
							<cfif rsCuentasA.variacion GTE 0>#LSNumberFormat(rsCuentasA.variacion,'999,999,999,999,999.00')# 
							<cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasA.variacion,'999,999,999,999,999.00()')#</font> 
							</cfif>
						<cfif rsCuentasA.nivel EQ 0>
							</font></strong>
						</cfif>
				</td>
               <td align="right">
						<cfif rsCuentasA.nivel EQ 0>
							<strong><font size="2">
						</cfif>
							<cfif rsCuentasA.saldoFinFA GTE 0>#LSNumberFormat(rsCuentasA.saldoFinFA,'999,999,999,999,999.00')# 
							<cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasA.saldoFinFA,'999,999,999,999,999.00()')#</font> 
						<cfif rsCuentasA.nivel EQ 0>
							</font></strong>
						</cfif>
						</cfif>
				</td>				
				<td align="right">
						<cfif rsCuentasA.nivel EQ 0>
							<strong><font size="2">
						</cfif>
							<cfif rsCuentasA.saldoFinPA GTE 0>#LSNumberFormat(rsCuentasA.saldoFinPA,'999,999,999,999,999.00')# 
							<cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasA.saldoFinPA,'999,999,999,999,999.00()')#</font> 
							</cfif>
						<cfif rsCuentasA.nivel EQ 0>
							</font></strong>
						</cfif>
				</td>
			</tr>
		</cfoutput>

		<cfquery name="sumA" dbtype="query">
			select sum(saldoFin) as total,sum(saldoFinMA) as totalMA ,sum(saldoFin-saldoFinMA) as totalVariacion, sum(saldoFinFA) as totalFA,sum(saldoFinPA) as totalPA from rsCuentasA where nivel = 0 
		</cfquery>
		<tr><td colspan="8">&nbsp;</td></tr>
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
				<cfif sumA.totalMA GTE 0>
					#LSNumberFormat(sumA.totalMA,'999,999,999,999.00')# 
				<cfelse>
					<font color="##FF0000">#LSNumberFormat(sumA.totalMA,'(999,999,999,999.00)')#</font> 
				</cfif>
				</cfoutput>
				</strong></font>
			</td>
            <td class="topline" align="right"><font size="2"> <strong>
				<cfoutput> 
				<cfif sumA.totalVariacion GTE 0>
					#LSNumberFormat(sumA.totalVariacion,'999,999,999,999.00')# 
				<cfelse>
					<font color="##FF0000">#LSNumberFormat(sumA.totalVariacion,'(999,999,999,999.00)')#</font> 
				</cfif>
				</cfoutput>
				</strong></font>
			</td>
            <td class="topline" align="right"><font size="2"> <strong>
				<cfoutput> 
				<cfif sumA.totalFA GTE 0>
					#LSNumberFormat(sumA.totalFA,'999,999,999,999.00')# 
				<cfelse>
					<font color="##FF0000">#LSNumberFormat(sumA.totalFA,'(999,999,999,999.00)')#</font> 
				</cfif>
				</cfoutput>
				</strong></font>
			</td>
            <td class="topline" align="right"><font size="2"> <strong>
				<cfoutput> 
				<cfif sumA.totalPA GTE 0>
					#LSNumberFormat(sumA.totalPA,'999,999,999,999.00')# 
				<cfelse>
					<font color="##FF0000">#LSNumberFormat(sumA.totalPA,'(999,999,999,999.00)')#</font> 
				</cfif>
				</cfoutput>
				</strong></font>
			</td>			
		</tr>

		<!--- **************************** PASIVOS ****************************** --->
    	<tr><td colspan="8" class="bottomline">&nbsp;</td></tr>
		<tr><td colspan="8" nowrap class="tituloListas">&nbsp;</td>	</tr>
		<cfoutput>
		<tr> 
    		<td  align="left" nowrap class="encabReporte">#MSG_Pasivo#</td>
			<td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#MSG_Mes_Actual#</div></td>
			<td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#MSG_Mes_Anterior#</div></td>
            <td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#MSG_Variacion#</div></td>
			<td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#MSG_Ano_Anterior#</div></td>
            <td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#MSG_Ano_Anterior#</div></td>
    	</tr>
         <tr> 
    		<td width="10%" align="left" nowrap class="encabReporte"></td>
			<td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#ListGetAt(meses, Form.mes, ',')#-#Form.periodo#</div></td>
			<td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#ListGetAt(meses, MesAnterior, ',')#-#periodoMesAnterior#</div></td>
            <td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#MSG_Favor_En_Contra#</div></td>
			<td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#ListGetAt(meses, LvarMesFiscal, ',')#-#periodoFinAnterior#</div></td>
            <td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#ListGetAt(meses, Form.mes, ',')#-#Form.periodo-1#</div></td>
    	</tr>
		</cfoutput>

		<cfquery name="rsCuentasP" dbtype="query">
			select nivel, #preservesinglequotes(LvarCta)#, saldoFin,saldoFinMA,saldoFin-saldoFinMA as variacion, saldoFinFA ,saldoFinPA  from rsProc where tipo = 'P' 
		</cfquery>

		<cfoutput query="rsCuentasP"> 
		  <cfif nivel EQ 0 and varNivel GT 1><tr><td colspan="8">&nbsp;</td></tr></cfif>
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
						<cfif rsCuentasP.saldoFin GTE 0>#LSNumberFormat(rsCuentasP.saldoFin,'999,999,999,999,999.00')# 
						<cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasP.saldoFin,'999,999,999,999,999.00()')#</font> 
						</cfif>
				<cfif rsCuentasP.nivel EQ 0>
					</font></strong>
				</cfif>
			</td>				
			<td align="right">
				<cfif rsCuentasP.nivel EQ 0>
					<strong><font size="2">
				</cfif>
						<cfif rsCuentasP.saldoFinMA GTE 0>#LSNumberFormat(rsCuentasP.saldoFinMA,'999,999,999,999,999.00')# 
						<cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasP.saldoFinMA,'999,999,999,999,999.00()')#</font> 
						</cfif>
				<cfif rsCuentasP.nivel EQ 0>
					</font></strong>
				</cfif>
			</td>
            <td align="right">
				<cfif rsCuentasP.nivel EQ 0>
					<strong><font size="2">
				</cfif>
						<cfif rsCuentasP.variacion GTE 0>#LSNumberFormat(rsCuentasP.variacion,'999,999,999,999,999.00')# 
						<cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasP.variacion,'999,999,999,999,999.00()')#</font> 
						</cfif>
				<cfif rsCuentasP.nivel EQ 0>
					</font></strong>
				</cfif>
			</td>
            <td align="right">
				<cfif rsCuentasP.nivel EQ 0>
					<strong><font size="2">
				</cfif>
						<cfif rsCuentasP.saldoFinFA GTE 0>#LSNumberFormat(rsCuentasP.saldoFinFA,'999,999,999,999,999.00')# 
						<cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasP.saldoFinFA,'999,999,999,999,999.00()')#</font> 
						</cfif>
				<cfif rsCuentasP.nivel EQ 0>
					</font></strong>
				</cfif>
			</td>
            <td align="right">
				<cfif rsCuentasP.nivel EQ 0>
					<strong><font size="2">
				</cfif>
						<cfif rsCuentasP.saldoFinPA GTE 0>#LSNumberFormat(rsCuentasP.saldoFinPA,'999,999,999,999,999.00')# 
						<cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasP.saldoFinPA,'999,999,999,999,999.00()')#</font> 
						</cfif>
				<cfif rsCuentasP.nivel EQ 0>
					</font></strong>
				</cfif>
			</td>
		  </tr>
		</cfoutput> 
		<cfquery name="sumP" dbtype="query">
			select sum(saldoFin) as total,sum(saldoFinMA) as totalMA ,sum(saldoFin-saldoFinMA) as totalVariacion, sum(saldoFinFA) as totalFA,sum(saldoFinPA) as totalPA	from rsCuentasP where nivel = 0 
		</cfquery>
		<tr><td colspan="8">&nbsp;</td></tr>
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
				<cfif sumP.totalMA GTE 0>
					#LSNumberFormat(sumP.totalMA,'999,999,999,999.00')# 
				<cfelse>
					<font color="##FF0000">#LSNumberFormat(sumP.totalMA,'(999,999,999,999.00)')#</font> 
				</cfif>
				</cfoutput>
				</strong></font>
			</td>
            <td class="topline" align="right"><font size="2"> <strong>
				<cfoutput> 
				<cfif sumP.totalVariacion GTE 0>
					#LSNumberFormat(sumP.totalVariacion,'999,999,999,999.00')# 
				<cfelse>
					<font color="##FF0000">#LSNumberFormat(sumP.totalVariacion,'(999,999,999,999.00)')#</font> 
				</cfif>
				</cfoutput>
				</strong></font>
			</td>
            <td class="topline" align="right"><font size="2"> <strong>
				<cfoutput> 
				<cfif sumP.totalFA GTE 0>
					#LSNumberFormat(sumP.totalFA,'999,999,999,999.00')# 
				<cfelse>
					<font color="##FF0000">#LSNumberFormat(sumP.totalFA,'(999,999,999,999.00)')#</font> 
				</cfif>
				</cfoutput>
				</strong></font>
			</td>
            <td class="topline" align="right"><font size="2"> <strong>
				<cfoutput> 
				<cfif sumP.totalPA GTE 0>
					#LSNumberFormat(sumP.totalPA,'999,999,999,999.00')# 
				<cfelse>
					<font color="##FF0000">#LSNumberFormat(sumP.totalPA,'(999,999,999,999.00)')#</font> 
				</cfif>
				</cfoutput>
				</strong></font>
			</td>			
		</tr>

	<!--- **************************** Capital ****************************** --->
    <tr><td colspan="8" class="bottomline">&nbsp;</td></tr>
	<tr><td colspan="8" nowrap class="tituloListas">&nbsp;</td></tr>
    <cfoutput>
		<tr> 
    		<td  align="left" nowrap class="encabReporte">#MSG_Capital#  </td>
			<td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#MSG_Mes_Actual#</div></td>
			<td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#MSG_Mes_Anterior#</div></td>
            <td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#MSG_Variacion#</div></td>
			<td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#MSG_Ano_Anterior#</div></td>
            <td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#MSG_Ano_Anterior#</div></td>
    	</tr>
         <tr> 
    		<td width="10%" align="left" nowrap class="encabReporte"></td>
			<td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#ListGetAt(meses, Form.mes, ',')#-#Form.periodo#</div></td>
			<td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#ListGetAt(meses, MesAnterior, ',')#-#periodoMesAnterior#</div></td>
            <td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#MSG_Favor_En_Contra#</div></td>
			<td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#ListGetAt(meses, LvarMesFiscal, ',')#-#periodoFinAnterior#</div></td>
            <td  nowrap="nowrap" width="15%" class="encabReporte"><div align="center">#ListGetAt(meses, Form.mes, ',')#-#Form.periodo-1#</div></td>
    	</tr>
	</cfoutput>
	<cfquery name="rsCuentasC" dbtype="query">
	    select nivel, #preservesinglequotes(LvarCta)#, saldoFin,saldoFinMA,saldoFin-saldoFinMA as variacion, saldoFinFA ,saldoFinPA from rsProc where tipo = 'C' 
    </cfquery>
    <cfoutput query="rsCuentasC">
	  <cfif nivel EQ 0 and varNivel GT 1><tr><td colspan="8">&nbsp;</td></tr></cfif> 
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
			<cfif rsCuentasC.saldoFin GTE 0>#LSNumberFormat(rsCuentasC.saldoFin,'999,999,999,999,999.00')# 
			<cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasC.saldoFin,'999,999,999,999,999.00()')#</font> 
			</cfif>
			<cfif rsCuentasC.nivel EQ 0>
				</font></strong>
			</cfif>
		</td>
		<td align="right">
			<cfif rsCuentasC.nivel EQ 0>
				<strong><font size="2">
			</cfif>
			<cfif rsCuentasC.saldoFinMA GTE 0>#LSNumberFormat(rsCuentasC.saldoFinMA,'999,999,999,999,999.00')# 
			<cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasC.saldoFinMA,'999,999,999,999,999.00()')#</font> 
			</cfif>
			<cfif rsCuentasC.nivel EQ 0>
				</font></strong>
			</cfif>
		</td>
        <td align="right">
			<cfif rsCuentasC.nivel EQ 0>
				<strong><font size="2">
			</cfif>
			<cfif rsCuentasC.variacion GTE 0>#LSNumberFormat(rsCuentasC.variacion,'999,999,999,999,999.00')# 
			<cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasC.variacion,'999,999,999,999,999.00()')#</font> 
			</cfif>
			<cfif rsCuentasC.nivel EQ 0>
				</font></strong>
			</cfif>
		</td>
        <td align="right">
			<cfif rsCuentasC.nivel EQ 0>
				<strong><font size="2">
			</cfif>
			<cfif rsCuentasC.saldoFinFA GTE 0>#LSNumberFormat(rsCuentasC.saldoFinFA,'999,999,999,999,999.00')# 
			<cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasC.saldoFinFA,'999,999,999,999,999.00()')#</font> 
			</cfif>
			<cfif rsCuentasC.nivel EQ 0>
				</font></strong>
			</cfif>
		</td>
		<td align="right">
			<cfif rsCuentasC.nivel EQ 0>
				<strong><font size="2">
			</cfif>
			<cfif rsCuentasC.saldoFinPA GTE 0>#LSNumberFormat(rsCuentasC.saldoFinPA,'999,999,999,999,999.00')# 
			<cfelse><font color="##FF0000">#LSNumberFormat(rsCuentasC.saldoFinPA,'999,999,999,999,999.00()')#</font> 
			</cfif>
			<cfif rsCuentasC.nivel EQ 0>
				</font></strong>
			</cfif>
		</td>
      </tr>
    </cfoutput> 
	<!--- Utilidad --->
    <tr><td colspan="8">&nbsp;</td></tr>
    <tr class="tituloListas"> 
		<td><strong><font size="2"><cfoutput>#MSG_Utilidad#</cfoutput></font></strong></td> 
      	<td><div align="right"><font size="2"><strong>
          	<cfoutput> 
            	<cfif rsProc.utilidadsaldo GTE 0>
              		#LSNumberFormat(rsProc.utilidadsaldo,'999,999,999,999,999.00')# 
              	<cfelse>
              		<font color="##FF0000">#LSNumberFormat(rsProc.utilidadsaldo,'999,999,999,999,999.00()')#</font> 
            	</cfif>
          	</cfoutput> </strong></font></div>
		</td>
      	<td><div align="right"><font size="2"><strong>
          	<cfoutput> 
            	<cfif rsProc.utilidadSaldoMA GTE 0>
              		#LSNumberFormat(rsProc.utilidadSaldoMA,'999,999,999,999,999.00')# 
              	<cfelse>
              		<font color="##FF0000">#LSNumberFormat(rsProc.utilidadSaldoMA,'999,999,999,999,999.00()')#</font> 
            	</cfif>
          	</cfoutput> </strong></font></div>
		</td>
        <td><div align="right"><font size="2"><strong>
          	<cfoutput> 
            	<cfif rsProc.utilidadsaldo-rsProc.utilidadSaldoMA GTE 0>
              		#LSNumberFormat(rsProc.utilidadsaldo-rsProc.utilidadSaldoMA,'999,999,999,999,999.00')# 
              	<cfelse>
              		<font color="##FF0000">#LSNumberFormat(rsProc.utilidadsaldo-rsProc.utilidadSaldoMA,'999,999,999,999,999.00()')#</font> 
            	</cfif>
          	</cfoutput> </strong></font></div>
		</td>
        <td><div align="right"><font size="2"><strong>
          	<cfoutput> 
            	<cfif rsProc.utilidadSaldoFA GTE 0>
              		#LSNumberFormat(rsProc.utilidadSaldoFA,'999,999,999,999,999.00')# 
              	<cfelse>
              		<font color="##FF0000">#LSNumberFormat(rsProc.utilidadSaldoFA,'999,999,999,999,999.00()')#</font> 
            	</cfif>
          	</cfoutput> </strong></font></div>
		</td>
        <td><div align="right"><font size="2"><strong>
          	<cfoutput> 
            	<cfif rsProc.utilidadSaldoPA GTE 0>
              		#LSNumberFormat(rsProc.utilidadSaldoPA,'999,999,999,999,999.00')# 
              	<cfelse>
              		<font color="##FF0000">#LSNumberFormat(rsProc.utilidadSaldoPA,'999,999,999,999,999.00()')#</font> 
            	</cfif>
          	</cfoutput> </strong></font></div>
		</td>
    <!--- Total Capital --->  
    </tr>
		<cfquery name="sumC" dbtype="query">
			select sum(saldoFin) as total ,sum(saldoFinMA) as totalMA,sum(variacion)as totalVariacion, sum(saldoFinFA) as totalFA,sum(saldoFinPA) as totalPA	from rsCuentasC where nivel = 0 
		</cfquery>
		<cfset totalC = iif(len(trim(rsProc.utilidadsaldo)) GT 0,de(rsProc.utilidadsaldo),0.00)>
		<cfset totalCMA = iif(len(trim(rsProc.utilidadSaldoMA)) GT 0,de(rsProc.utilidadSaldoMA),0.00)>
		<cfset totalCFA = iif(len(trim(rsProc.utilidadSaldoFA)) GT 0,de(rsProc.utilidadSaldoFA),0.00)>
		<cfset totalCPA = iif(len(trim(rsProc.utilidadSaldoPA)) GT 0,de(rsProc.utilidadSaldoPA),0.00)>
		<cfif sumC.recordCount>
			<cfset totalC = totalC + sumC.total>
			<cfset totalCMA = totalCMA + sumC.totalMA>
			<cfset totalCFA = totalCFA + sumC.totalFA>
			<cfset totalCPA = totalCPA + sumC.totalPA>
		</cfif>
        <cfset totalCvariacion = totalC-totalCMA>
	<tr><td colspan="8">&nbsp;</td></tr>
    <tr> 
      	<td class="topline"><b>TOTAL <cfoutput>#MSG_Capital# </cfoutput></b></td>
       	<td class="topline"><div align="right"><font size="2"><strong>
		<cfoutput> 
        	<cfif sumC.total GTE 0>
            	#LSNumberFormat(totalC,',9.00')# 
            <cfelse>
              	<font color="##FF0000">#LSNumberFormat(totalC,',9.00()')#</font> 
            </cfif>
        </cfoutput> </strong> </font></div>
        </td>
      	<td class="topline"><div align="right"><font size="2"><strong>
		<cfoutput> 
        	<cfif sumC.totalMA GTE 0>
              	#LSNumberFormat(totalCMA,',9.00')# 
            <cfelse>
            	<font color="##FF0000">#LSNumberFormat(totalCMA,',9.00()')#</font> 
            </cfif>
        </cfoutput> </strong> </font></div>
        </td>        
        <td class="topline"><div align="right"><font size="2"><strong>
		<cfoutput> 
        	<cfif sumC.totalVariacion GTE 0>
            	#LSNumberFormat(totalCvariacion,',9.00')# 
            <cfelse>
              	<font color="##FF0000">#LSNumberFormat(totalCvariacion,',9.00()')#</font> 
            </cfif>
        </cfoutput> </strong> </font></div>
        </td>
        
        
        <td class="topline"><div align="right"><font size="2"><strong>
		<cfoutput> 
        	<cfif sumC.totalFA GTE 0>
              	#LSNumberFormat(totalCFA,',9.00')# 
            <cfelse>
            	<font color="##FF0000">#LSNumberFormat(totalCFA,',9.00()')#</font> 
            </cfif>
        </cfoutput> </strong> </font></div>
        </td>
        <td class="topline"><div align="right"><font size="2"><strong>
		<cfoutput> 
        	<cfif sumC.totalPA GTE 0>
              	#LSNumberFormat(totalCPA,',9.00')# 
            <cfelse>
            	<font color="##FF0000">#LSNumberFormat(totalCPA,',9.00()')#</font> 
            </cfif>
        </cfoutput> </strong> </font></div>
        </td>
    </tr>
    <tr> 
      	<td colspan="8">&nbsp;</td>
    </tr>
    
    <!--- **************************** Total Pasivo y Capital ****************************** --->
    <cfquery name="sumPCU" dbtype="query">
    	select sum(saldoFin) as total ,sum(saldoFinMA) as totalMA , sum(saldoFinFA) as totalFA ,sum(saldoFinPA) as totalPA
		from rsProc 
		where nivel = 0 and 
		tipo in ('P','C') 
    </cfquery>
	<cfset totalPCU = iif(len(trim(rsProc.utilidadsaldo)) GT 0, de(rsProc.utilidadsaldo),0.00)>
	<cfset totalPCUma = iif(len(trim(rsProc.utilidadSaldoMA)) GT 0, de(rsProc.utilidadSaldoMA),0.00)>
	<cfset totalPCUfa = iif(len(trim(rsProc.utilidadSaldoFA)) GT 0, de(rsProc.utilidadSaldoFA),0.00)>
	<cfset totalPCUpa = iif(len(trim(rsProc.utilidadSaldoPA)) GT 0, de(rsProc.utilidadSaldoPA),0.00)>
	
	<cfif sumPCU.recordCount>
		<cfset totalPCU = totalPCU + sumPCU.total>
		<cfset totalPCUma = totalPCUma + sumPCU.totalMA>
		<cfset totalPCUfa = totalPCUfa + sumPCU.totalFA>
		<cfset totalPCUpa = totalPCUpa + sumPCU.totalPA>
	</cfif>
    <cfset totalPCUvariacion = totalPCU-totalPCUma>

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
            <cfif totalPCUma GTE 0>
              #LSNumberFormat(totalPCUma,',9.00')# 
              <cfelse>
              <font color="##FF0000">#LSNumberFormat(totalPCUma,',9.00()')#</font> 
            </cfif>
            </strong></font></div>
		  </cfoutput> 
		</td>
        <td>
		  <cfoutput> 
			<div align="right"><font size="2"><strong> 
            <cfif totalPCUvariacion GTE 0>
              #LSNumberFormat(totalPCUvariacion,',9.00')# 
              <cfelse>
              <font color="##FF0000">#LSNumberFormat(totalPCUvariacion,',9.00()')#</font> 
            </cfif>
            </strong></font></div>
		  </cfoutput> 
		</td>
        <td>
		  <cfoutput> 
			<div align="right"><font size="2"><strong> 
            <cfif totalPCUfa GTE 0>
              #LSNumberFormat(totalPCUfa,',9.00')# 
              <cfelse>
              <font color="##FF0000">#LSNumberFormat(totalPCUfa,',9.00()')#</font> 
            </cfif>
            </strong></font></div>
		  </cfoutput> 
		</td>
        <td>
		  <cfoutput> 
			<div align="right"><font size="2"><strong> 
            <cfif totalPCUpa GTE 0>
              #LSNumberFormat(totalPCUpa,',9.00')# 
              <cfelse>
              <font color="##FF0000">#LSNumberFormat(totalPCUpa,',9.00()')#</font> 
            </cfif>
            </strong></font></div>
		  </cfoutput> 
		</td>
	</tr>
    <tr>
		<td colspan="8">&nbsp;</td>
	</tr>
    <tr>
		<td colspan="8">&nbsp;</td>
	</tr>
    <tr> 
      <td colspan="8"><div align="center" class="tituloLeyenda" ><cfoutput>#rsLeyenda.Pvalor#</cfoutput></div></td>
    </tr>
    <tr>
		<td colspan="8">&nbsp;</td>
	</tr>
    <tr> 
      <td colspan="8"><div align="center">------------------ <cfoutput>#MGS_FinDelReporte#</cfoutput> ------------------</div></td>
    </tr>
  </table>
</form>

