<!--- 
	Mdulo    : Otros
	Nombre    : Reporte de Balance de Comprobación Convertido por Moneda Detallado por cuenta
	Hecho por : E. Raúl Bravo Gómez
	Creado    : 26/09/2914
 --->

<cfsetting requesttimeout="3600">

<cfif isdefined("url.Empresa") and not isdefined("form.Empresa")>
	<cfparam name="form.Empresa" default="#url.Empresa#">
</cfif>

<cfif isdefined("url.periodo") and not isdefined("form.periodo")>
	<cfparam name="form.periodo" default="#url.periodo#">
</cfif>
<cfif isdefined("url.mes") and not isdefined("form.mes")>
	<cfparam name="form.mes" default="#url.mes#">
</cfif>
<cfif isdefined("form.NIVEL")>
    <cfset varNivel = form.NIVEL>
</cfif>
 
<cfquery name="Moneda" datasource="#Session.DSN#">
    select b.Mcodigo, b.Mnombre, b.Miso4217
    from Monedas b 
    where Ecodigo=#form.Empresa#
    order by b.Mcodigo desc
</cfquery>
 
<cfquery name="Empresa" datasource="#Session.DSN#">
    select Edescripcion
    from Empresas 
    where Ecodigo=#form.Empresa#
</cfquery>

<cf_dbtemp name="SaldosXCuentaMoneda">
	<cf_dbtempcol name="Cformato"     type="varchar(100)"	>
	<cf_dbtempcol name="Mcodigo"      type="int" 			>
	<cf_dbtempcol name="Ccuenta"      type="numeric" 		>			
	<cf_dbtempcol name="Cdescripcion" type="varchar(100)" 	>
	<cf_dbtempcol name="LSaldoFinal"  type="money" 			>
	<cf_dbtempcol name="OSaldoFinal"  type="money" 			>
    <cf_dbtempcol name="corte"  		type="int">
    <cf_dbtempcol name="nivel"  		type="int">
</cf_dbtemp>
<cfset SaldosXCuentaMoneda = temp_table >

<cfquery datasource="#session.DSN#">
	insert into #SaldosXCuentaMoneda#
		(Cformato,Mcodigo,Ccuenta,Cdescripcion,LSaldoFinal,OSaldoFinal,nivel)	
		select m.Cformato,m.Mcodigo,m.Ccuenta,
		(select Cdescripcion from CContables where Ecodigo = #form.Empresa# and Cformato = m.Cformato) as Cdescripcion,
        coalesce(
        (select (sc.SLinicial+sc.DLdebitos-sc.CLcreditos) from SaldosContablesConvertidos sc 
		where sc.Speriodo=#form.periodo# and sc.Smes=#form.mes# and sc.Ecodigo=#form.Empresa# and sc.Ccuenta=m.Ccuenta and sc.McodigoOri=m.Mcodigo and B15= 0),0) as LSaldoFinal,
        coalesce(
		(select (sc.SOinicial+DOdebitos-COcreditos) from SaldosContables sc 
		where m.Mcodigo=sc.Mcodigo and sc.Speriodo=#form.periodo# and sc.Smes=#form.mes# and sc.Ecodigo=#form.Empresa# and sc.Ccuenta=m.Ccuenta),0) as OSaldoFinal,
        case when m.Cformato = m.Cmayor then 0 else 1 end as nivel
	from (select distinct mon.Mcodigo as Mcodigo, sc.Ccuenta as Ccuenta, c.Cmayor, c.Cformato as Cformato
		from Monedas mon 
		inner join SaldosContables sc  on sc.Ecodigo=mon.Ecodigo 
		inner join CContables c on sc.Ccuenta = c.Ccuenta        
		where mon.Ecodigo=#form.Empresa# and c.Cmayor = c.Cformato and
        sc.Speriodo=#form.periodo# and sc.Smes=#form.mes#) m
</cfquery> 

<cfif varNivel GTE 0>
	<cfset nivelactual = 1>
	<cfset nivelanteri = 0>
    <cfloop condition = "nivelactual LESS THAN varNivel">
        <cfquery name="A2_Cuentas" datasource="#Session.DSN#">
            insert INTO #SaldosXCuentaMoneda# (Cformato, nivel, Ccuenta, Mcodigo,Cdescripcion,LSaldoFinal,OSaldoFinal)
            select 
                b.Cformato, #nivelactual#, b.Ccuenta, a.Mcodigo, 
                (select Cdescripcion from CContables where Ecodigo = #form.Empresa# and Cformato = b.Cformato) as Cdescripcion,
                coalesce(
                (select (sc.SLinicial+sc.DLdebitos-sc.CLcreditos) from SaldosContablesConvertidos sc 
                 where sc.Speriodo=#form.periodo# and sc.Smes=#form.mes# and sc.Ecodigo=#form.Empresa# and sc.Ccuenta=b.Ccuenta and sc.McodigoOri=a.Mcodigo and B15= 0),0) as LSaldoFinal,
                 coalesce(
                (select (sc.SOinicial+DOdebitos-COcreditos) from SaldosContables sc 
                 where a.Mcodigo=sc.Mcodigo and sc.Speriodo=#form.periodo# and sc.Smes=#form.mes# and sc.Ecodigo=#form.Empresa# and sc.Ccuenta=b.Ccuenta),0) as OSaldoFinal
            from #SaldosXCuentaMoneda# a
                inner join CContables b
                on b.Cpadre = a.Ccuenta
            where a.nivel = #nivelanteri#
        </cfquery>
		<cfset nivelanteri = nivelactual>
        <cfset nivelactual = nivelactual + 1>
    </cfloop>
</cfif>

<!---<cfquery name="salida" datasource="#session.DSN#">
	select * from #SaldosXCuentaMoneda#
    order by Ccuenta, Mcodigo
</cfquery>

<cf_dump var="#salida#">
--->
<cfquery name = "rsValoresXEmpresa" datasource="#session.DSN#">
	select Cformato,Mcodigo,Ccuenta,Cdescripcion,LSaldoFinal,OSaldoFinal,nivel from #SaldosXCuentaMoneda#
    order by Cformato,Mcodigo desc
</cfquery>

<!--- Pinta los botones de regresar, impresin y exportar a excel. --->
<cfset Title = "Balance de Comprobaci&oacute;n Convertido por Moneda">
<cfset FileName = "BalCompConvXMonLO.xls">
<cf_htmlreportsheaders
	title="#Title#" 
	filename="#FileName#" 
	ira="BalCompConvXMonLO.cfm">

<!--- Empieza a pintar el reporte en el usuario cada 512 bytes. --->
<cfif not isdefined("form.toExcel")>
	<cfflush interval="512">
</cfif>

<cf_templatecss>
	
<cfoutput>
<table width="99%" align="center" cellpadding="0" cellspacing="0">
	<tr align="center"><td align="center"><font size="4" face="Verdana, Arial, Helvetica, sans-serif"><strong>#Empresa.Edescripcion#</strong></font></td></tr>
	<tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Balance de Comprobación Convertido por Moneda Origen</strong></font></td></tr>
	<tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Confidencial</strong></font></td></tr>
	<tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Periodo: #form.mes#/#form.Periodo#</strong></font></td></tr>
</table>
</cfoutput>
<table width="99%" cellpadding="2" cellspacing="0">
	<tr>
		<td class="tituloListas"><font size="3" face="Times New Roman, Times, serif"><strong>Cuenta</strong></font></td>
		<td class="tituloListas"><font size="3" face="Times New Roman, Times, serif"><strong>Descripci&oacute;n</strong></font></td>
		<cfoutput query="Moneda">
        	<td class="tituloListas" colspan="2" align="center" ><font size="2" face="Times New Roman, Times, serif"><strong>#Moneda.Mnombre#</strong></font></td>			
			<cfset totMoneda['#Moneda.Mcodigo#'] = 0>
			<cfset totMonedaL['#Moneda.Mcodigo#'] = 0>
        </cfoutput>
	</tr>
	<tr>
    	<td class="tituloListas" colspan="2">&nbsp;</td>
		<cfoutput query="Moneda">
        	<td class="tituloListas" align="center"><font size="2" face="Times New Roman, Times, serif"><strong>MONEDA ORIGEN</strong></font></td>	
        	<td class="tituloListas" align="center"><font size="2" face="Times New Roman, Times, serif"><strong>MONEDA CONVERTIDA</strong></font></td>								
        </cfoutput>
		<td class="tituloListas" align="center"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL CONVERTIDO</strong></font></td>
	</tr>
	<cfoutput query="rsValoresXEmpresa" group="Cformato">
		<cfset varCeros = True>
    	<cfif rsValoresXEmpresa.nivel GT 0>
			<cfset varCeros = False>
    		<cfquery name = "rsCeros" datasource="#session.DSN#">
    			select count(*) as reg from #SaldosXCuentaMoneda# 
                where Ccuenta= #rsValoresXEmpresa.Ccuenta#
                and (LSaldoFinal <> 0 or OSaldoFinal <> 0)
    		</cfquery>
            <cfif rsCeros.reg gt 0 >
				<cfset varCeros = True>
            </cfif>
    	</cfif>
		<cfif varCeros>
            <tr>
                <td> #rsValoresXEmpresa.Cformato#</td>
                <td> #rsValoresXEmpresa.Cdescripcion#</td>
                <cfset Tot_cons = 0>
                <cfoutput>
        <!---Saldos Moneda Origen--->			
                        <td align="right">
                            <cfif #rsValoresXEmpresa.OSaldoFinal# GTE 0 or #rsValoresXEmpresa.OSaldoFinal# EQ ''> #LSNumberFormat(rsValoresXEmpresa.OSaldoFinal,',9.00')#
                            <cfelse> <font color="##FF0000">#LSNumberFormat(rsValoresXEmpresa.OSaldoFinal,',9.00')#</font>
                            </cfif>
                        </td>				
                        <cfif #rsValoresXEmpresa.OSaldoFinal# NEQ '' and rsValoresXEmpresa.nivel eq 0>
                            <cfset totMoneda['#rsValoresXEmpresa.Mcodigo#'] = totMoneda['#rsValoresXEmpresa.Mcodigo#'] + #rsValoresXEmpresa.OSaldoFinal# >
                        </cfif>
        <!---Saldos Moneda Convertida--->			
                        <td align="right">
                            <cfif #rsValoresXEmpresa.LSaldoFinal# GTE 0 or #rsValoresXEmpresa.LSaldoFinal# EQ ''> #LSNumberFormat(rsValoresXEmpresa.LSaldoFinal,',9.00')#
                            <cfelse> <font color="##FF0000">#LSNumberFormat(rsValoresXEmpresa.LSaldoFinal,',9.00')#</font>
                            </cfif>
                        </td>				
                        <cfif #rsValoresXEmpresa.LSaldoFinal# NEQ '' and rsValoresXEmpresa.nivel eq 0>
                            <cfset totMonedaL['#rsValoresXEmpresa.Mcodigo#'] = totMonedaL['#rsValoresXEmpresa.Mcodigo#'] + #rsValoresXEmpresa.LSaldoFinal# >
                        </cfif>
                        <cfset Tot_cons = Tot_cons + #rsValoresXEmpresa.LSaldoFinal#>
                </cfoutput>
                <td align="right">
					<cfif #Tot_cons# GTE 0 or #Tot_cons# EQ ''> #LSNumberFormat(Tot_cons,',9.00')#
                    <cfelse> <font color="##FF0000">#LSNumberFormat(Tot_cons,',9.00')#</font>
                    </cfif>
                </td>
            </tr>
        </cfif>
    </cfoutput>
	<tr><td>&nbsp;</td></tr>
    <tr>
    <td colspan="2" align="left"><strong>Totales Finales:</strong></td>
		<cfoutput query="Moneda">
            <td align="right"><strong>#LSNumberFormat(totMoneda['#Moneda.Mcodigo#'],',9.00')#</strong></td>
            <td align="right"><strong>#LSNumberFormat(totMonedaL['#Moneda.Mcodigo#'],',9.00')#</strong></td>			
        </cfoutput>
    </tr>
</table>
