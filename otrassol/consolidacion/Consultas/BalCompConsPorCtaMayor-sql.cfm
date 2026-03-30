<!--- 
	Mdulo    : Otros
	Nombre    : Reporte de Balance de Comprobacin por Cuenta Mayor Consolidado
	Hecho por : E. Raúl Bravo Gómez
	Creado    : 11/05/2010
 --->

<cfsetting requesttimeout="3600">

<cfif isdefined("url.GEid") and not isdefined("form.GEid")>
	<cfparam name="form.GEid" default="#url.GEid#">
</cfif>
<cfif isdefined("url.periodo") and not isdefined("form.periodo")>
	<cfparam name="form.periodo" default="#url.periodo#">
</cfif>
<cfif isdefined("url.mes") and not isdefined("form.mes")>
	<cfparam name="form.mes" default="#url.mes#">
</cfif>
<cfif isdefined("url.mcodigoopt")>
	<cfparam name="Form.mcodigoopt" default="#url.mcodigoopt#">
</cfif>
<cfif isdefined("url.Mcodigo")>
	<cfparam name="Form.Mcodigo" default="#url.Mcodigo#">
</cfif>
 
<!--- Tabla de las empresas del reporte --->
<cf_dbtemp name="empresas">
	<cf_dbtempcol name="codigo"  	type="int" >	
	<cf_dbtempcol name="nombre"		type="varchar(100)"	>
</cf_dbtemp>

<cfset empresas = temp_table >

<cfquery datasource="#session.DSN#">
	insert into #empresas# (codigo,nombre)
	select e.Ecodigo,e.Edescripcion
	from AnexoGEmpresaDet dg
		inner join Empresas e
			on e.Ecodigo = dg.Ecodigo
	where dg.GEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEid#" >
	order by e.Ecodigo
</cfquery>

<cfquery name="rsParam" datasource="#Session.DSN#">
    select Pvalor
    from Parametros
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    and Pcodigo = 1310
</cfquery>
<cfif rsParam.recordCount>
 	<cfset emprCons = #rsParam.Pvalor# >
</cfif>

<cfset moneda ="">
<cfif isdefined("Form.mcodigoopt") and Form.mcodigoopt EQ "-2">
    
<cfelseif isdefined("Form.mcodigoopt") and (Form.mcodigoopt EQ "-3" or Form.mcodigoopt EQ "-4")>

	<cfif Form.mcodigoopt EQ "-3">
        <cfset TipoB15 = 0>
    <cfelse>
        <cfset TipoB15 = 2>    
    </cfif>

	<cfif TipoB15 EQ 0>
        <cfquery name="rsParam" datasource="#Session.DSN#">
            select Pvalor
            from Parametros
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and Pcodigo = 660
        </cfquery>
    <cfelse>
    	<cfquery name="rsParam" datasource="#Session.DSN#">
            select Pvalor
            from Parametros
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and Pcodigo = 3900
        </cfquery>
    </cfif>
	<cfif rsParam.recordCount> 
		<cfquery name="rsMonedaConvertida" datasource="#Session.DSN#">
			select Mcodigo, Mnombre, Miso4217
			from Monedas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParam.Pvalor#">
		</cfquery>
	</cfif>
	<cfset moneda=rsMonedaConvertida.Miso4217>
<cfelseif  isdefined("Form.mcodigoopt") and Form.mcodigoopt EQ "0">
</cfif>
<cfquery name = "rsValoresXEmpresa" datasource="#session.DSN#">
		select e.Ecodigo, m.Cmayor,
        case when (select count(1) from CtasMayor cm
  			where m.Cmayor = cm.Cmayor and cm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">) > 0 
            then
            (select cm.Cdescripcion from CtasMayor cm
  			where m.Cmayor = cm.Cmayor and cm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">)
            else
            (select cm.Cdescripcion from CtasMayor cm
  			where m.Cmayor = cm.Cmayor and cm.Ecodigo = e.Ecodigo) end as Cdescripcion,
        (coalesce(( 
        select sum(sc.SLinicial)
        from Monedas n, CContables c, SaldosContablesConvertidos sc
        where c.Ecodigo = e.Ecodigo and n.Miso4217='#moneda#'
            and c.Cformato = m.Cmayor
            and sc.Ccuenta = c.Ccuenta
            and sc.Speriodo = #form.periodo#
            and sc.Smes = #form.mes#
            and sc.Ecodigo = c.Ecodigo
            and sc.Mcodigo = n.Mcodigo
           	and n.Ecodigo = e.Ecodigo 
            and sc.B15 = #TipoB15#  
        ),0.00)) as SInicial,
        
        (coalesce(( 
        select sum(sc.DLdebitos)        
        from Monedas n, CContables c, SaldosContablesConvertidos sc
        where c.Ecodigo = e.Ecodigo and n.Miso4217='#moneda#'
            and c.Cformato = m.Cmayor
            and sc.Ccuenta = c.Ccuenta
            and sc.Speriodo = #form.periodo#
            and sc.Smes = #form.mes#
            and sc.Ecodigo = c.Ecodigo
            and sc.Mcodigo = n.Mcodigo
           	and n.Ecodigo = e.Ecodigo
            and sc.B15 = #TipoB15#            
        ),0.00)) as Debitos,
        (coalesce(( 
        select sum(sc.CLcreditos)        
        from Monedas n, CContables c, SaldosContablesConvertidos sc
        where c.Ecodigo = e.Ecodigo and n.Miso4217='#moneda#'
            and c.Cformato = m.Cmayor
            and sc.Ccuenta = c.Ccuenta
            and sc.Speriodo = #form.periodo#
            and sc.Smes = #form.mes#
            and sc.Ecodigo = c.Ecodigo
            and sc.Mcodigo = n.Mcodigo
            and n.Ecodigo = e.Ecodigo
            and sc.B15 = #TipoB15#            	
        ),0.00)) as Creditos,

		(coalesce(( 
        select sum(sc.SLinicial)
        from Monedas n, CContables c, SaldosContablesConvertidos sc
        where c.Ecodigo = #emprCons# and n.Miso4217='#moneda#'
            and c.Cformato = m.Cmayor
            and sc.Ccuenta = c.Ccuenta
            and sc.Speriodo = #form.periodo#
            and sc.Smes = #form.mes#
            and sc.Ecodigo = c.Ecodigo
            and sc.Mcodigo = n.Mcodigo
            and n.Ecodigo = c.Ecodigo
            and sc.B15 = #TipoB15#            	
        ),0.00)) as SInicialCons
        from (select distinct Cmayor from CtasMayor where Ecodigo in (select codigo from #empresas#)) m , Empresas e
        where e.Ecodigo in (select codigo from #empresas#)
        order by m.Cmayor, e.Ecodigo
        
<!---    <cfelse>
        select e.Ecodigo, m.Cmayor, 
        (select min(cm.Cdescripcion) from CtasMayor cm
  			where m.Cmayor = cm.Cmayor) as Cdescripcion,        
        (coalesce(( 
		<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) EQ -2>
            select sum(sc.SLinicial)
        <cfelse>
            select sum(sc.SOinicial)
        </cfif>        
        from Monedas n, CContables c, SaldosContables sc
        where c.Ecodigo = e.Ecodigo  
		<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) EQ 0>
			and n.Miso4217='#moneda#'
        </cfif>        
            and c.Cformato = m.Cmayor
            and sc.Ccuenta = c.Ccuenta
            and sc.Speriodo = #form.periodo#
            and sc.Smes = #form.mes#
            and sc.Ecodigo = c.Ecodigo
            and sc.Mcodigo = n.Mcodigo
            and n.Ecodigo = e.Ecodigo
        ),0.00)) as SInicial,
        (coalesce(( 
		<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) EQ -2>
            select sum(sc.DLdebitos)
        <cfelse>
            select sum(sc.DOdebitos)
        </cfif>        
        from Monedas n, CContables c, SaldosContables sc
        where c.Ecodigo = e.Ecodigo 
		
		<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) EQ 0>
			and n.Miso4217='#moneda#'
        </cfif>        

            and c.Cformato = m.Cmayor
            and sc.Ccuenta = c.Ccuenta
            and sc.Speriodo = #form.periodo#
            and sc.Smes = #form.mes#
            and sc.Ecodigo = c.Ecodigo
            and sc.Mcodigo = n.Mcodigo
            and n.Ecodigo = e.Ecodigo
        ),0.00)) as Debitos,
        (coalesce(( 
		<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) EQ -2>
            select sum(sc.CLcreditos)
        <cfelse>
            select sum(sc.COcreditos)
        </cfif>        
        from Monedas n, CContables c, SaldosContables sc
        where c.Ecodigo = e.Ecodigo 
		
		<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) EQ 0>
			and n.Miso4217='#moneda#'
        </cfif>        

            and c.Cformato = m.Cmayor
            and sc.Ccuenta = c.Ccuenta
            and sc.Speriodo = #form.periodo#
            and sc.Smes = #form.mes#
            and sc.Ecodigo = c.Ecodigo
            and sc.Mcodigo = n.Mcodigo
            and n.Ecodigo = e.Ecodigo
        ),0.00)) as Creditos,
		
        (coalesce(( 
		<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) EQ -2>
            select sum(sc.SLinicial)
        <cfelse>
            select sum(sc.SOinicial)
        </cfif>        
        from Monedas n, CContables c, SaldosContables sc
        where c.Ecodigo = #emprCons#  
		<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) EQ 0>
			and n.Miso4217='#moneda#'
        </cfif>        
            and c.Cformato = m.Cmayor
            and sc.Ccuenta = c.Ccuenta
            and sc.Speriodo = #form.periodo#
            and sc.Smes = #form.mes#
            and sc.Ecodigo = c.Ecodigo
            and sc.Mcodigo = n.Mcodigo
            and n.Ecodigo = c.Ecodigo
        ),0.00)) as SInicialCons,
		
        (coalesce((
		<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) EQ -2>
            select sum(dc.Dlocal)
        <cfelse>
            select sum(dc.Doriginal)
        </cfif>        
        from HDContables dc,Monedas n, CContables c
        where dc.Ecodigo = #emprCons#  
		
		<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) EQ 0>
			and n.Miso4217='#moneda#'
        </cfif>        

        	and dc.Cconcepto = #PolizaElim#
            and dc.Eperiodo = #form.periodo#
            and dc.Emes = #form.mes#
            and n.Ecodigo = dc.Ecodigo
			and dc.Mcodigo = n.Mcodigo
            and dc.Dmovimiento = 'D'
            and c.Ecodigo = dc.Ecodigo
            and c.Cmayor = m.Cmayor
            and dc.Ccuenta = c.Ccuenta
            ),0.00)) as Edebe,
		(coalesce((            
		<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) EQ -2>
            select sum(dc.Dlocal)
        <cfelse>
            select sum(dc.Doriginal)
        </cfif>        
        from HDContables dc,Monedas n, CContables c
        where dc.Ecodigo = #emprCons#  
		
		<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) EQ 0>
			and n.Miso4217='#moneda#'
        </cfif>        

        	and dc.Cconcepto = #PolizaElim#
            and dc.Eperiodo = #form.periodo#
            and dc.Emes = #form.mes#
            and n.Ecodigo = dc.Ecodigo
			and dc.Mcodigo = n.Mcodigo
            and dc.Dmovimiento = 'C'
            and c.Ecodigo = dc.Ecodigo
            and c.Cmayor = m.Cmayor
            and dc.Ccuenta = c.Ccuenta
            ),0.00)) as Ehaber,
		(coalesce((                        
		<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) EQ -2>
            select sum(dc.Dlocal)
        <cfelse>
            select sum(dc.Doriginal)
        </cfif>        
        from HDContables dc,Monedas n, CContables c
        where dc.Ecodigo = #emprCons#  
		
		<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) EQ 0>
			and n.Miso4217='#moneda#'
        </cfif>        

        	and dc.Cconcepto <> #PolizaElim#
            and dc.Eperiodo = #form.periodo#
            and dc.Emes = #form.mes#
            and n.Ecodigo = dc.Ecodigo
			and dc.Mcodigo = n.Mcodigo
            and dc.Dmovimiento = 'D'
            and c.Ecodigo = dc.Ecodigo
            and c.Cmayor = m.Cmayor
            and dc.Ccuenta = c.Ccuenta
            ),0.00)) as Rdebe,
		(coalesce((            
		<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) EQ -2>
            select sum(dc.Dlocal)
        <cfelse>
            select sum(dc.Doriginal)
        </cfif>        
        from HDContables dc,Monedas n, CContables c
        where dc.Ecodigo = #emprCons#  
		
		<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) EQ 0>
			and n.Miso4217='#moneda#'
        </cfif>        

        	and dc.Cconcepto <> #PolizaElim#
            and dc.Eperiodo = #form.periodo#
            and dc.Emes = #form.mes#
            and n.Ecodigo = dc.Ecodigo
			and dc.Mcodigo = n.Mcodigo
            and dc.Dmovimiento = 'C'
            and c.Ecodigo = dc.Ecodigo
            and c.Cmayor = m.Cmayor
            and dc.Ccuenta = c.Ccuenta
            ),0.00)) as Rhaber
        from (select distinct Cmayor from CtasMayor) m , Empresas e
        where e.Ecodigo in (select codigo from #empresas#)
        order by m.Cmayor, e.Ecodigo
	</cfif>
--->	        
</cfquery>

<!--- Pinta los botones de regresar, impresin y exportar a excel. --->

<cfset Title = "Balance de Comprobaci&oacute;n Por Cuenta Mayor Convertido">
<cfset FileName = "BalanceComprobacionPorCuentaMayorConvertido.xls">
<cfif Form.mcodigoopt EQ "-4">
	<cfset Title = "Balance de Comprobaci&oacute;n Por Cuenta Mayor Convertido B15">
    <cfset FileName = "BalanceComprobacionPorCuentaMayorConvertidoB15.xls">
</cfif>

<cf_htmlreportsheaders
	title="#Title#" 
	filename="#FileName#" 
	ira="BalCompConsPorCtaMayor.cfm">

<!--- Empieza a pintar el reporte en el usuario cada 512 bytes. --->
<cfif not isdefined("form.toExcel")>
	<cfflush interval="512">
</cfif>

<cfquery name="empresa" datasource="#session.DSN#">
	select codigo as Codigo, nombre as Nombre
	from #empresas# 
<!---	where codigo <> #emprCons#
--->	order by codigo
</cfquery>

<cf_templatecss>
	
<cfoutput>
<table width="100%" align="center" cellpadding="0" cellspacing="0">
	<tr align="center"><td align="center"><font size="4" face="Verdana, Arial, Helvetica, sans-serif"><strong>#session.Enombre#</strong></font></td></tr>
	<tr align="center"><td align="center"><font size="4" face="Verdana, Arial, Helvetica, sans-serif"><strong>Consolidado de Empresas</strong></font></td></tr>
	<tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong>#Title#</strong></font></td></tr>
	<tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Confidencial</strong></font></td></tr>
    
<cfif isdefined("Form.mcodigoopt") and Form.mcodigoopt EQ "-2">
	<tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong>#rsMonedaLocal.Mnombre#</strong></font></td></tr>
<cfelseif isdefined("Form.mcodigoopt") and Form.mcodigoopt EQ "-3">
	<tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong>#rsMonedaConvertida.Mnombre#</strong></font></td></tr>
<cfelseif  isdefined("Form.mcodigoopt") and Form.mcodigoopt EQ "0">
	<tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong>#rsMonedaSel.Mnombre#</strong></font></td></tr>
</cfif>
    <tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Periodo: #form.mes#/#form.Periodo#</strong></font></td></tr>
</table>
</cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
    	<td class="tituloListas" colspan="3">&nbsp;</td>
    	<td class="tituloListas" colspan="<cfoutput>3+#empresa.recordcount#</cfoutput>">&nbsp;</td>
<!--- 		<td class="tituloListas" colspan="2" align="center" ><font size="3" face="Times New Roman, Times, serif"><strong>Eliminaciones Consolidaci&oacute;n</strong></font></td>        
        <td class="tituloListas" align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Total Empresas</strong></font></td>
       <td class="tituloListas" colspan="2" align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Reclasificaciones de Partidas</strong></font></td>
        <td class="tituloListas"><font size="3" face="Times New Roman, Times, serif"><strong>Saldo Final</strong></font></td>
--->    
	</tr>
	<tr>
		<td class="tituloListas"><font size="3" face="Times New Roman, Times, serif"><strong>Cuenta</strong></font></td>
		<td class="tituloListas"><font size="3" face="Times New Roman, Times, serif"><strong>Descripci&oacute;n</strong></font></td>
		<cfoutput query="empresa">
        	<td class="tituloListas" align="center"><font size="2" face="Times New Roman, Times, serif"><strong>#empresa.nombre#</strong></font></td>
			<cfset totEmp['#empresa.codigo#'] = 0>
			<cfset totElimSIC['#empresa.codigo#'] = 0>			
            <cfset totElimD['#empresa.codigo#'] = 0>
            <cfset totElimH['#empresa.codigo#'] = 0>
            <cfset totRecD['#empresa.codigo#'] = 0>
            <cfset totRecH['#empresa.codigo#'] = 0>            
        </cfoutput>
		<td class="tituloListas" align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Total Empresas</strong></font></td>
<!---		<td class="tituloListas" align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Saldo Inicial</strong></font></td>
		<td class="tituloListas" align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Debe</strong></font></td>
        <td class="tituloListas" align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Haber</strong></font></td>
        <td class="tituloListas" ><font size="3" face="Times New Roman, Times, serif"><strong>Eliminaciones</strong></font></td>
        <td class="tituloListas" align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Debe</strong></font></td>
        <td class="tituloListas" align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Haber</strong></font></td>
        <td class="tituloListas" ><font size="3" face="Times New Roman, Times, serif"><strong>Consolidado</strong></font></td>
--->	
		</tr>
	<cfoutput query="rsValoresXEmpresa" group="Cmayor">
    <tr>
    	<cfset tot_emp = 0>
    	<td> #rsValoresXEmpresa.Cmayor#</td>
        <td> #rsValoresXEmpresa.Cdescripcion#</td>
        <cfoutput>
			<cfset saldo = #rsValoresXEmpresa.SInicial#+#rsValoresXEmpresa.Debitos#-#rsValoresXEmpresa.Creditos#>
            <td align="right">
                <cfif saldo GTE 0> #LSNumberFormat(saldo,',9.00')#
                <cfelse> <font color="##FF0000">#LSNumberFormat(saldo,',9.00')#</font>
                </cfif>
            </td>
            <cfset tot_emp += #saldo#>
            <cfset totEmp['#rsValoresXEmpresa.Ecodigo#'] = totEmp['#rsValoresXEmpresa.Ecodigo#'] + saldo >
        </cfoutput>
        <td align="right">
			<cfif tot_emp GTE 0> #LSNumberFormat(tot_emp,',9.00')#
            <cfelse> <font color="##FF0000">#LSNumberFormat(tot_emp,',9.00')#</font>
            </cfif>
        </td>
<!---        <td align="right">
			<cfif rsValoresXEmpresa.SInicialCons GTE 0> #LSNumberFormat(rsValoresXEmpresa.SInicialCons,',9.00')#
            <cfelse> <font color="##FF0000">#LSNumberFormat(rsValoresXEmpresa.SInicialCons,',9.00')#</font>
            </cfif>
        </td>
        <td align="right">
			<cfif rsValoresXEmpresa.Edebe GTE 0> #LSNumberFormat(rsValoresXEmpresa.Edebe,',9.00')#
            <cfelse> <font color="##FF0000">#LSNumberFormat(rsValoresXEmpresa.Edebe,',9.00')#</font>
            </cfif>
        </td>
        <td align="right">
			<cfif rsValoresXEmpresa.Ehaber GTE 0> #LSNumberFormat(rsValoresXEmpresa.Ehaber,',9.00')#
            <cfelse> <font color="##FF0000">#LSNumberFormat(rsValoresXEmpresa.Ehaber,',9.00')#</font>
            </cfif>
        </td>
		<cfset saldo = rsValoresXEmpresa.SInicialCons+#rsValoresXEmpresa.Edebe#-#rsValoresXEmpresa.Ehaber#>
        <cfset tot_emp += #saldo#>
		<cfset totElimSIC['#rsValoresXEmpresa.Ecodigo#'] = totElimSIC['#rsValoresXEmpresa.Ecodigo#'] + #rsValoresXEmpresa.SInicialCons# >
        <cfset totElimD['#rsValoresXEmpresa.Ecodigo#'] = totElimD['#rsValoresXEmpresa.Ecodigo#'] + #rsValoresXEmpresa.Edebe# >
        <cfset totElimH['#rsValoresXEmpresa.Ecodigo#'] = totElimH['#rsValoresXEmpresa.Ecodigo#'] + #rsValoresXEmpresa.Ehaber# >
        <td align="right">
			<cfif tot_emp GTE 0> #LSNumberFormat(tot_emp,',9.00')#
            <cfelse> <font color="##FF0000">#LSNumberFormat(tot_emp,',9.00')#</font>
            </cfif>
        </td>
        <td align="right">
			<cfif rsValoresXEmpresa.Rdebe GTE 0> #LSNumberFormat(rsValoresXEmpresa.Rdebe,',9.00')#
            <cfelse> <font color="##FF0000">#LSNumberFormat(rsValoresXEmpresa.Rdebe,',9.00')#</font>
            </cfif>
        </td>
        <td align="right">
			<cfif rsValoresXEmpresa.Rhaber GTE 0> #LSNumberFormat(rsValoresXEmpresa.Rhaber,',9.00')#
            <cfelse> <font color="##FF0000">#LSNumberFormat(rsValoresXEmpresa.Rhaber,',9.00')#</font>
            </cfif>
        </td>
		<cfset saldo = #rsValoresXEmpresa.Rdebe#-#rsValoresXEmpresa.Rhaber#>
        <cfset tot_emp += #saldo#>
        <cfset totRecD['#rsValoresXEmpresa.Ecodigo#'] = totRecD['#rsValoresXEmpresa.Ecodigo#'] + #rsValoresXEmpresa.Rdebe# >
        <cfset totRecH['#rsValoresXEmpresa.Ecodigo#'] = totRecH['#rsValoresXEmpresa.Ecodigo#'] + #rsValoresXEmpresa.Rhaber# >
        <td align="right">
			<cfif tot_emp GTE 0> #LSNumberFormat(tot_emp,',9.00')#
            <cfelse> <font color="##FF0000">#LSNumberFormat(tot_emp,',9.00')#</font>
            </cfif>
        </td>
--->    
	</tr>
    </cfoutput>
	<tr><td>&nbsp;</td></tr>
    <tr>
    <td colspan="2" align="left"><strong>Totales Finales:</strong></td>
	<cfset TotGpo = 0>
<!---	<cfset Tot_ElimSIC = 0>
	<cfset Tot_ElimD = 0>
    <cfset Tot_ElimH = 0>
    <cfset Tot_ReclD = 0>
    <cfset Tot_ReclH = 0>
--->    
	<cfoutput query="empresa">
		<td align="right"><strong>#LSNumberFormat(totEmp['#empresa.codigo#'],',9.00')#</strong></td>
        <cfset TotGpo += totEmp['#empresa.codigo#']>
<!---		<cfset Tot_ElimSIC += totElimSIC['#empresa.codigo#']>
        <cfset Tot_ElimD += totElimD['#empresa.codigo#']>
		<cfset Tot_ElimH += totElimH['#empresa.codigo#']>
        <cfset Tot_ReclD += totRecD['#empresa.codigo#']>
        <cfset Tot_ReclH += totRecH['#empresa.codigo#']>
--->	
	</cfoutput>
    <td align="right"><cfoutput><strong>#LSNumberFormat(TotGpo,',9.00')#</strong></cfoutput></td>
<!---	<td align="right"><cfoutput><strong>#LSNumberFormat(Tot_ElimSIC,',9.00')#</strong></cfoutput></td>
    <td align="right"><cfoutput><strong>#LSNumberFormat(Tot_ElimD,',9.00')#</strong></cfoutput></td>
	<td align="right"><cfoutput><strong>#LSNumberFormat(Tot_ElimH,',9.00')#</strong></cfoutput></td>
    <td align="right"><cfoutput><strong>#LSNumberFormat(TotGpo+Tot_ElimSIC+Tot_ElimD - Tot_ElimH,',9.00')#</strong></cfoutput></td>
    <td align="right"><cfoutput><strong>#LSNumberFormat(Tot_ReclD,',9.00')#</strong></cfoutput></td>
	<td align="right"><cfoutput><strong>#LSNumberFormat(Tot_ReclH,',9.00')#</strong></cfoutput></td>
    <td align="right"><cfoutput><strong>#LSNumberFormat(TotGpo+Tot_ElimSIC+Tot_ElimD - Tot_ElimH + Tot_ReclD - Tot_ReclH,',9.00')#</strong></cfoutput></td>
--->    
</table>
