<!--- 
	Mdulo    : Otros
	Nombre    : Reporte de Balance de Comprobación Convertido por Moneda
	Hecho por : E. Raúl Bravo Gómez
	Creado    : 20S/05/2010
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
</cf_dbtemp>
<cfset SaldosXCuentaMoneda = temp_table >
<cfquery datasource="#session.DSN#">
	insert into #SaldosXCuentaMoneda#
		(Cformato,Mcodigo,Ccuenta,Cdescripcion,LSaldoFinal,OSaldoFinal)	
		
		select m.Cformato,m.Mcodigo,m.Ccuenta,
		
(select min(cm.Cdescripcion) from CtasMayor cm
  			where m.Cformato=cm.Cmayor) as Cdescripcion,
			
(select (sc.SLinicial+DLdebitos-CLcreditos) from SaldosContables sc 
where m.Mcodigo=sc.Mcodigo and sc.Speriodo=#form.periodo# and sc.Smes=#form.mes# and sc.Ecodigo=#form.Empresa# and sc.Ccuenta=m.Ccuenta) as LSaldoFinal,

(select (sc.SOinicial+DOdebitos-COcreditos) from SaldosContables sc 
where m.Mcodigo=sc.Mcodigo and sc.Speriodo=#form.periodo# and sc.Smes=#form.mes# and sc.Ecodigo=#form.Empresa# and sc.Ccuenta=m.Ccuenta) as OSaldoFinal

from (select distinct m.Mcodigo as Mcodigo, sc.Ccuenta as Ccuenta, c.Cformato as Cformato
		from Monedas m 
		inner join SaldosContables sc  on sc.Ecodigo=m.Ecodigo 
		inner join CContables c on sc.Ccuenta = c.Ccuenta 
		inner join CtasMayor cm on c.Cformato=cm.Cmayor
		where m.Ecodigo=#form.Empresa# and sc.Speriodo=#form.periodo# and sc.Smes=#form.mes#) m
		
order by m.Cformato,m.Mcodigo desc
</cfquery> 

<cfset rsquery = 'select coalesce((sc.SLinicial+sc.DLdebitos-sc.CLcreditos), 0.00) from SaldosContablesConvertidos sc 
        where sc.Mcodigo= #SaldosXCuentaMoneda#.Mcodigo and sc.Speriodo=#form.periodo# and B15=0 and
              sc.Smes=#form.mes# and sc.Ecodigo=#form.Empresa# and sc.Ccuenta=#SaldosXCuentaMoneda#.Ccuenta and
			  sc.McodigoOri=#SaldosXCuentaMoneda#.Mcodigo'>
              
<cfquery datasource="#session.DSN#">
	update #SaldosXCuentaMoneda# 
    set LSaldoFinal = 
        case (#rsquery#)
        when 0 then LSaldoFinal
        else (#rsquery#)
        end
</cfquery>

<cfquery name = "rsValoresXEmpresa" datasource="#session.DSN#">
	select Cformato,Mcodigo,Ccuenta,Cdescripcion,LSaldoFinal,OSaldoFinal from #SaldosXCuentaMoneda#
    order by Cformato,Mcodigo desc
</cfquery>

<!--- Pinta los botones de regresar, impresin y exportar a excel. --->
<cfset Title = "Balance de Comprobaci&oacute;n Convertido por Moneda">
<cfset FileName = "BalCompConvXMon.xls">
<cf_htmlreportsheaders
	title="#Title#" 
	filename="#FileName#" 
	ira="BalCompConvXMon.cfm">

<!--- Empieza a pintar el reporte en el usuario cada 512 bytes. --->
<cfif not isdefined("form.toExcel")>
	<cfflush interval="512">
</cfif>

<cf_templatecss>
	
<cfoutput>
<table width="99%" align="center" cellpadding="0" cellspacing="0">
	<tr align="center"><td align="center"><font size="4" face="Verdana, Arial, Helvetica, sans-serif"><strong>#Empresa.Edescripcion#</strong></font></td></tr>
	<tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Balance de Comprobación por Moneda Origen </strong></font></td></tr>
	<tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Confidencial</strong></font></td></tr>
	<tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Periodo: #form.mes#/#form.Periodo#</strong></font></td></tr>
</table>
</cfoutput>
<table width="99%" cellpadding="2" cellspacing="0">
	<tr>
    	<td class="tituloListas" colspan="2">&nbsp;</td>
    	<td class="tituloListas" colspan="<cfoutput>2+#Moneda.recordcount#</cfoutput>">&nbsp;</td>
		<td class="tituloListas" colspan="2" align="center" ><font size="3" face="Times New Roman, Times, serif"><strong>MONEDA ORIGEN</strong></font></td>  
        <td class="tituloListas" colspan="<cfoutput>#Moneda.recordcount#-3</cfoutput>">&nbsp;</td>
    </tr>
	<tr>
		<td class="tituloListas"><font size="3" face="Times New Roman, Times, serif"><strong>Cuenta</strong></font></td>
		<td class="tituloListas"><font size="3" face="Times New Roman, Times, serif"><strong>Descripci&oacute;n</strong></font></td>
		<cfoutput query="Moneda">
        	<td class="tituloListas" align="center"><font size="2" face="Times New Roman, Times, serif"><strong>#Moneda.Mnombre#</strong></font></td>
			<cfset totMoneda['#Moneda.Mcodigo#'] = 0>
        </cfoutput>
	</tr>
	<cfoutput query="rsValoresXEmpresa" group="Cformato">
    <tr>
    	<td> #rsValoresXEmpresa.Cformato#</td>
        <td> #rsValoresXEmpresa.Cdescripcion#</td>
        <cfoutput>
                <td align="right">
					<cfif #rsValoresXEmpresa.OSaldoFinal# GTE 0 or #rsValoresXEmpresa.OSaldoFinal# EQ ''> #LSNumberFormat(rsValoresXEmpresa.OSaldoFinal,',9.00')#
                    <cfelse> <font color="##FF0000">#LSNumberFormat(rsValoresXEmpresa.OSaldoFinal,',9.00')#</font>
                    </cfif>
                </td>
                <cfif #rsValoresXEmpresa.OSaldoFinal# NEQ ''>
                	<cfset totMoneda['#rsValoresXEmpresa.Mcodigo#'] = totMoneda['#rsValoresXEmpresa.Mcodigo#'] + #rsValoresXEmpresa.OSaldoFinal# >
                </cfif>
        </cfoutput>
    </tr>
    </cfoutput>
	<tr><td>&nbsp;</td></tr>
    <tr>
    <td colspan="2" align="left"><strong>Totales Finales:</strong></td>
		<cfoutput query="Moneda">
            <td align="right"><strong>#LSNumberFormat(totMoneda['#Moneda.Mcodigo#'],',9.00')#</strong></td>
        </cfoutput>
    </tr>
</table>
