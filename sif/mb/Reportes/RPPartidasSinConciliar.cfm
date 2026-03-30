<!---------
	Modificado por Gustavo Fonseca H.
		Fecha: 8-2-2006.
		Motivo: Se incluye un iframe para que el tag de impresión no tenga que abrir otra ventana con la misma información.
		
	Modificado por: Ana Villavicencio
	Fecha: 23 de noviembre del 2005
	Motivo: se cambio la consulta de los datos del reporte estaba incorrecto.
	
	Modificado por: Ana Villavicencio
	Fecha: 18 de noviembre del 2005
	Motivo: se cambio el filtro, se puso el banco, cuenta bancaria y estado de cuenta.
			Se cambio el despliegue de los datos, se eliminaron las dos columnas.
			Se agrego un parametro por url, para indicar si son documentos conciliados o no conciliados.
			
	Modificado por: Ana Villavicencio
	Fecha: 11 de noviembre del 2005
	Motivo: Agrupar por transaccion los documentos sin conciliar de una banco, cuenta y fecha determinada.

	Creado por: Ana Villavicencio
	Fecha de creación: 23 de mayo del 2005
	Motivo:	Reporte de impresión de documentos  no conciliados.

---------->
 <cfset LvarIrAPartiSinConci="/cfmx/sif/mb/Reportes/PartidasSinConciliar.cfm">
 <cfset LvarCBesTCE=0><!---Filtro para los querys TCE o CuentasBancarias--->
<cfif isdefined("LvarTCERPPartiSinConci")>
 	<cfset LvarIrAPartiSinConci="/cfmx/sif/tce/Reportes/TCEPartidasSinConciliar.cfm">
 	<cfset LvarCBesTCE=1><!---Filtro para los querys TCE o CuentasBancarias--->
</cfif>
 
<cfif isdefined('url.Bid')>
	<cfset form.Bid = url.Bid>
</cfif>
<cfif isdefined('url.CBid')>
	<cfset form.CBid = url.CBid>
</cfif>
<cfif isdefined('url.ECid')>
	<cfset form.ECid = url.ECid>
</cfif>
<cfif isdefined('url.cons')>
	<cfset form.cons = url.cons>
</cfif>

<cfif isdefined("form.Rango") and form.Rango EQ 'PeriodoMes'>
	<cfset FechaInicio = createdate(form.Periodo,form.mes,1)>
    <cfset FechaFin = createdate(form.Periodo,form.mes,1)>
    <cfset FechaFin = DateAdd("m",1,FechaFin)>
	<cfset FechaFin = DateAdd("d",-1,FechaFin)>
	<cfset FechaFin = DateAdd("h",23,FechaFin)>
	<cfset FechaFin = DateAdd("n",59,FechaFin)>
	<cfset FechaFin = DateAdd("s",59,FechaFin)>
</cfif>

<cfif isdefined('form.EChasta') and LEN(TRIM(form.EChasta))>
    <cfquery name="rsEstadoCta" datasource="#session.DSN#">
		select ECid, CBid 
		from ECuentaBancaria
		where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
		  <cfif form.CBid NEQ -1>
			and CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
		  </cfif>
		  and EChasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.EChasta)#">
	</cfquery>
<cfelseif isdefined("form.Rango") and form.Rango EQ 'PeriodoMes'>
	<cfquery name="rsEstadoCta" datasource="#session.DSN#">
		select ECid, CBid
		from ECuentaBancaria
		where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
		<cfif form.CBid NEQ -1>
			 and CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
		</cfif>
		and EChasta 
		between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaInicio#">
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaFin#">
	</cfquery>
<cfelse>
    <cfquery name="rsEstadoCta" datasource="#session.DSN#">
        select ECid, CBid
        from ECuentaBancaria
        where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
      	  and CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
    </cfquery>                  
</cfif>

<cfif isdefined('rsEstadoCta') and rsEstadoCta.RecordCount eq 0>
	<table width="90%" align="center">
		<tr><td><h6>&nbsp;</h6></td></tr>
		<tr align="center"><td> --------------------------- No se encontró el Estado de Cuenta o No hay datos que mostrar --------------------------- </td></tr>
	</table>
	<cfabort>
</cfif>

<!--- Consulta empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
    select Edescripcion from Empresas
    where Ecodigo = #Session.Ecodigo#
</cfquery>	

<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
<cfif not isdefined("url.imprimir")>
<cfif isdefined('url.cons')>
	<cfset form.tipo = #TRIM(url.cons)#>
</cfif>
<cfif isdefined("form.tipo") and form.tipo EQ 'S'>
	<cfset lVarFileName = "PartidasConciliadas#DateTimeFormat(now(), "dd-mm-yyyy_hh:nn:ss")#.xls">
<cfelse>
	<cfset lVarFileName = "PartidasSinConciliar#DateTimeFormat(now(), "dd-mm-yyyy_hh:nn:ss")#.xls">
</cfif>
<!---Redireccion PartidasSinConciliar.cfm o TCEPartidasSinConciliar.cfm--->
	<cf_htmlReportsHeaders 
		title="" 
		filename="#lVarFileName#"
		irA="#LvarIrAPartiSinConci#"
		download="yes"
		preview="no"
	>
</cfif>
<table width="80%" cellpadding="2" cellspacing="0" align="center" border="0">
	<tr>
		<td colspan="4"><font size="4"><strong><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong></font></td>
		<td align="right"><font size="1"><strong><cfoutput>#LSDateFormat(Now(),'dd/mm/yyyy')#</cfoutput></strong></font></td>
	</tr>
    <tr>
    <tr><td colspan="5"><font size="3"><strong><cfif isdefined('url.cons') and url.cons EQ 'S'>Partidas Conciliadas<cfelse>Partidas Pendientes de Conciliar </cfif></strong></font></td></tr>
    </tr>

	<!---****************** Consulta Bancos                     ******************--->
    <cfquery name="rsDatosBanco" datasource="#session.DSN#">
        select Bdescripcion
        from Bancos 
        where Ecodigo = #Session.Ecodigo#
        and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
    </cfquery>
	<tr><td colspan="5"><font size="3"><strong>Banco:&nbsp;<cfoutput>#rsDatosBanco.Bdescripcion#</cfoutput></strong></font></td></tr>
	<cfset cont=0>
    <cfloop query="rsEstadoCta">
        <cfset cont=cont+1>
        <cfset form.ECid = rsEstadoCta.ECid>
        <cfset form.CBid = rsEstadoCta.CBid>
        <cfif isdefined('form.ECid') and LEN(form.Bid) GT 0 and LEN(form.CBid) and LEN(form.ECid)>
            <cfset vparams ="">
            <cfset vparams = vparams & "&Bid=" & form.Bid & "&CBid=" & form.CBid & "&ECid=" & form.ECid & "&cons=" & form.cons>
            <!---****************** Consultas Encabezado 	******************--->
            <cfquery name="rsDatosEncab" datasource="#session.DSN#">
                select CBdescripcion,ECdescripcion
                from ECuentaBancaria ec
                    inner join CuentasBancos cb
                        on cb.Bid = ec.Bid
                        and cb.CBid = ec.CBid
                where cb.Ecodigo = #Session.Ecodigo#
                    and cb.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
                    and cb.CBesTCE = #LvarCBesTCE#
                    and cb.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
                    and ec.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
            </cfquery>
            
            <!---****************** Consultas Detalle  Libros******************--->
        <cfquery name="rsLibrosConciliados" datasource="#Session.DSN#">
            select 
                    MLdescripcion,
                    CDLdocumento, 
                    BTdescripcion ,
                    CDLfecha as fechalibros, 
                    CDLmonto, 
                    BTcodigo as CDLidtrans, 
                    CDLtipomov
            from ECuentaBancaria a 
                inner join CDLibros b
                    on a.ECid = b.ECid 
                    and b.CDLconciliado = <cfqueryparam cfsqltype="cf_sql_char" value="#form.cons#">
                inner join MLibros ml
                    on ml.MLid = b.MLid
                inner join BTransacciones c
                    on b.CDLidtrans = c.BTid
            where a.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
                and a.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
                and c.Ecodigo = #Session.Ecodigo#
                and a.ECid = #form.ECid#
            order by CDLidtrans, fechalibros, CDLmonto desc
        </cfquery>
        
        <!---******************  Consultas Detalle  Bancos******************--->
          <cfquery name="rsBancosConciliados" datasource="#Session.DSN#">
                select 
                        dc.DCReferencia, 
                        b.CDBdocumento,
                        c.BTEdescripcion, 
                        b.CDBfechabanco as fechaBancos,
                        b.CDBmonto, 
                        b.BTEcodigo, 
                        c.BTEtipo, 
                        b.CDBconciliado
                from ECuentaBancaria a
                    inner join CDBancos b
                        on b.ECid = a.ECid
                        and b.CDBconciliado = <cfqueryparam cfsqltype="cf_sql_char" value="#form.cons#">
                    inner join DCuentaBancaria dc
                        on dc.ECid = b.CDBecref
                        and dc.Linea = b.CDBlinref
                    inner join TransaccionesBanco c
                        on c.Bid  = b.Bid
                        and c.BTEcodigo = b.BTEcodigo
                where a.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
                    and a.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
                    and b.ECid = #form.ECid#
                    and dc.Ecodigo =  #Session.Ecodigo#
                order by b.BTEcodigo, b.CDBfechabanco, b.CDBmonto desc
            </cfquery>
        </cfif>
        
        <!--- 
            validar que los querys tengan datos para que no se muestre estados de cuenta sin datos 
        --->
        <cfif  rsDatosEncab.recordcount GT 0 and rsLibrosConciliados.RecordCount GT 0 and rsBancosConciliados.RecordCount GT 0>
            <tr><td colspan="5">&nbsp;</td></tr>
            <tr><td colspan="5"><font size="2"><strong><cfif isdefined("LvarTCERPPartiSinConci")>Tarjeta de Cr&eacute;dito:<cfelse>Cuenta:</cfif>&nbsp;<cfoutput>#rsDAtosEncab.CBdescripcion#</cfoutput></strong></font></td></tr>
            <tr><td colspan="5"><font size="2"><strong>Estado de Cuenta:&nbsp;<cfoutput>#rsDAtosEncab.ECdescripcion#</cfoutput></strong></font></td></tr>
            <tr><td align="center" valign="top" colspan="5" ><span style="font-size:16px"><strong>DOCUMENTOS EN LIBROS</strong></span></td></tr>
            
            <cfflush interval="32">
            <cfset totalTransD = 0>
            <cfset totalTransC = 0>
            <cfset totalLibrosD = 0>
            <cfset totalLibrosC = 0>
            <!--- Libros sin Conciliar --->
                <cfif rsLibrosConciliados.RecordCount GT 0>
                    <cfset transaccion = ''>
                    <cfset transAnterior = ''>
                    <cfoutput query="rsLibrosConciliados">
                        <cfif transaccion NEQ CDLidtrans>
                            <cfif transaccion NEQ ''>
                                <tr><td colspan="1">&nbsp;</td></tr>
                                <tr>
                                    <td colspan="3" align="right"><strong>Total movimientos tipo #Ucase(transAnterior)#:</strong></td>
                                    <td align="right">#LSCurrencyFormat(totalTransD,'none')#</td>
                                    <td align="right">#LSCurrencyFormat(totalTransC,'none')#</td>
                                </tr>
                            </cfif>
                            <tr><td colspan="5">&nbsp;</td></tr>
                            <tr bgcolor="##EFEFEF">
                                <td colspan="5" align="left"><span style="font-size:12px;"><strong>#BTdescripcion#</strong></span></td>
                            </tr>
                            <tr class="subTitulo" bgcolor="E2E2E2"> 
                                <td ><strong>Fecha</strong></td>
                                <td ><strong>Documento</strong></td>
                                <td ><strong>Referencia</strong></td>
                                <td align="right"><strong>D&eacute;bito</strong></td>
                                <td align="right"><strong>Cr&eacute;dito</strong></td>
                            </tr>
                            <cfset transaccion = CDLidtrans>
                            <cfset transAnterior = BTdescripcion>
                            <cfset totalLibrosD = totalLibrosD + totalTransD>
                            <cfset totalLibrosC = totalLibrosC + totalTransC>
                            <cfset totalTransD = 0>
                            <cfset totalTransC = 0>
                        </cfif>
                        <cfif CDLtipomov EQ 'D'>
                            <cfset totalTransD = totalTransD + CDLmonto>
                        <cfelse>
                            <cfset totalTransC = totalTransC + CDLmonto>
                        </cfif>
                        <tr <cfif rsLibrosConciliados.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>> 
                            <td>&nbsp;&nbsp;#LSDateFormat(fechalibros,'dd/mm/yyyy')#</td>
                            <td nowrap>#CDLdocumento#&nbsp;&nbsp;</td>
                            <td nowrap>#MLdescripcion#&nbsp;&nbsp;</td>
                            <td align="right"><cfif #CDLtipomov# EQ 'D'>#LSCurrencyFormat(CDLmonto,'none')#<cfelse>0.00</cfif></td>
                            <td align="right"><cfif #CDLtipomov# EQ 'C'>#LSCurrencyFormat(CDLmonto,'none')#<cfelse>0.00</cfif></td>
                        </tr>
                        <cfif isdefined("url.imprimir")>
                            <cfif rsLibrosConciliados.RecordCount mod 35 EQ 1>
                                <cfif rsLibrosConciliados.RecordCount NEQ 1>
                                    <tr class="pageEnd"><td colspan="7">&nbsp;</td></tr>
                                    <tr class="subTitulo"> 
                                        <td><strong>Fecha</strong></td>
                                        <td><strong>Documento</strong></td>
                                        <td><strong>Referencia</strong></td>
                                        <td align="right"><strong>D&eacute;bito</strong></td>
                                        <td align="right"><strong>Cr&eacute;dito</strong></td>
                                    </tr>
                                </cfif>
                            </cfif>	
                        </cfif>
                        <cfif CurrentRow EQ RecordCount>
                            <tr><td colspan="4">&nbsp;</td></tr>
                            <tr>
                                <td colspan="3" align="right"><strong>Total movimientos tipo #BTdescripcion#:</strong></td>
                                <td align="right">#LSCurrencyFormat(totalTransD,'none')#</td>
                                <td align="right">#LSCurrencyFormat(totalTransC,'none')#</td>
                                <cfset totalLibrosD = totalLibrosD + totalTransD>
                                <cfset totalLibrosC = totalLibrosC + totalTransC>
                            </tr>
                        </cfif>
                        <cfflush>
                    </cfoutput>
                    <tr><td colspan="3">&nbsp;</td></tr>
                    <cfoutput>
                    <tr>
                        <td colspan="3" align="right"><span style=" font-size: 14px"><strong>TOTAL DOCUMENTOS EN LIBROS:</strong></span></td>
                        <td align="right"><span style=" font-size: 12px">&nbsp;&nbsp;#LSCurrencyFormat(totalLibrosD,'none')#</span></td>
                        <td align="right"><span style=" font-size: 12px">&nbsp;&nbsp;#LSCurrencyFormat(totalLibrosC,'none')#</span></td>
                    </tr>
                    </cfoutput>
                <cfelse>
                    <tr align="center"><td colspan="5"> --------------------------- No hay documentos para libros --------------------------- </td></tr>
                </cfif>
                <tr><td>&nbsp;</td></tr>
                <tr><td>&nbsp;</td></tr>
                <cfif isdefined("url.imprimir")>
                    <tr class="pageEnd"><td colspan="1">&nbsp;</td></tr>
                </cfif>
                <!--- Bancos sin Conciliar --->
                <cfif rsBancosConciliados.RecordCount GT 0>
                    <tr><td align="center" valign="top" colspan="5"><span style="font-size:16px"><strong>REMANENTE DEL BANCO</strong></span></td></tr>
                    <cfset totalTransD = 0>
                    <cfset totalTransC = 0>
                    <cfset totalBancosD = 0>
                    <cfset totalBancosC = 0>
                    <cfset transaccion = ''>
                    <cfset transAnterior = ''>
                        <cfoutput query="rsBancosConciliados">
                            <cfif transaccion NEQ BTEcodigo>
                                <cfif transaccion NEQ ''>
                                    <tr><td colspan="4">&nbsp;</td></tr>
                                    <tr>
                                        <td colspan="3" align="right"><strong>Total movimientos tipo #Ucase(transAnterior)#:</strong></td>
                                        <td align="right">#LSCurrencyFormat(totalTransD,'none')#</td>
                                        <td align="right">#LSCurrencyFormat(totalTransC,'none')#</td>
                                    </tr>
                                </cfif>
                                <tr><td colspan="5">&nbsp;</td></tr>
                                <tr bgcolor="EFEFEF"><td colspan="5" align="left"><span style="font-size:12px;"><strong>#BTEdescripcion#</strong></span></td></tr>
                                <tr class="subTitulo" bgcolor="E2E2E2"> 
                                    <td ><strong>Fecha</strong></td>
                                    <td ><strong>Documento</strong></td>
                                    <td ><strong>Referencia</strong></td>
                                    <td align="right"><strong>D&eacute;bito</strong></td>
                                    <td align="right"><strong>Cr&eacute;dito</strong></td>
                                </tr>
                                <cfset transaccion = BTEcodigo>
                                <cfset transAnterior = BTEdescripcion>
                                <cfset totalBancosD = totalBancosD + totalTransD>
                                <cfset totalBancosC = totalBancosC + totalTransC>
                                <cfset totalTransD = 0>
                                <cfset totalTransC = 0>
                            </cfif>
                            <cfif BTEtipo EQ 'D'>
                                <cfset totalTransD = totalTransD + CDBmonto>
                            <cfelse>
                                <cfset totalTransC = totalTransC + CDBmonto>
                            </cfif>
                            <tr <cfif rsBancosConciliados.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>> 
                                <td>&nbsp;&nbsp;#LSDateFormat(fechaBancos,'dd/mm/yyyy')#</td>
                                <td nowrap>#CDBdocumento#&nbsp;&nbsp;</td>
                                <td nowrap>#DCReferencia#&nbsp;&nbsp;</td>
                                <td align="right"><cfif BTEtipo EQ 'D'>#LSCurrencyFormat(CDBmonto,'none')#<cfelse>0.00</cfif></td>
                                <td align="right"><cfif BTEtipo EQ 'C'>#LSCurrencyFormat(CDBmonto,'none')#<cfelse>0.00</cfif></td>
                            </tr>
                            <cfif isdefined("url.imprimir")>
                                <cfif rsBancosConciliados.RecordCount mod 35 EQ 1>☺♀
                                    <cfif rsBancosConciliados.RecordCount NEQ 1>
                                        <tr class="pageEnd"><td colspan="7">&nbsp;</td></tr>
                                        <tr class="subTitulo"> 
                                            <td ><strong>Fecha</strong></td>
                                            <td ><strong>Documento</strong></td>
                                            <td ><strong>Referencia</strong></td>
                                            <td align="right"><strong>D&eacute;bito</strong></td>
                                            <td align="right"><strong>Cr&eacute;dito</strong></td>
                                        </tr>
                                    </cfif>
                                </cfif>	
                            </cfif>
                            <cfif CurrentRow EQ RecordCount>
                                <tr><td colspan="4">&nbsp;</td></tr>
                                <tr>
                                    <td colspan="3" align="right"><strong>Total movimientos tipo #BTEdescripcion#:</strong></td>
                                    <td align="right">#LSCurrencyFormat(totalTransD,'none')#</td>
                                    <td align="right">#LSCurrencyFormat(totalTransC,'none')#</td>
                                    <cfset totalBancosD = totalBancosD + totalTransD>
                                    <cfset totalBancosC = totalBancosC + totalTransC>
                                </tr>
                            </cfif>
                            <cfflush>
                        </cfoutput>
                        <tr><td colspan="3">&nbsp;</td></tr>
                        <cfoutput>
                        <tr>
                            <td colspan="3" align="right"><span style=" font-size: 14px"><strong>TOTAL REMANENTE DEL BANCO:</strong></span></td>
                            <td align="right"><span style=" font-size: 12px">&nbsp;&nbsp;#LSCurrencyFormat(totalBancosD,'none')#</span></td>
                            <td align="right"><span style=" font-size: 12px">&nbsp;&nbsp;#LSCurrencyFormat(totalBancosC,'none')#</span></td>
                        </tr>
                        </cfoutput>
                        <tr><td colspan="5">&nbsp;</td></tr>
                <cfelse>
                    <tr align="center"><td colspan="5"> --------------------------- No hay documentos para bancos --------------------------- </td></tr>
                </cfif> 
            <tr><td colspan="5">&nbsp;</td></tr>
            <cfoutput>
            <tr>
                <td colspan="3" align="right"><span style=" font-size: 14px"><strong>TOTALES <cfif isdefined("LvarTCERPPartiSinConci")>TARJETA DE CR&Eacute;DITO:<cfelse>CUENTA:</cfif></strong></span></td>
                <td align="right"><span style=" font-size: 12px">&nbsp;&nbsp;#LSCurrencyFormat(totalBancosD+totalLibrosD,'none')#</span></td>
                <td align="right"><span style=" font-size: 12px">&nbsp;&nbsp;#LSCurrencyFormat(totalBancosC+totalLibrosC,'none')#</span></td>
            </tr>
            </cfoutput>
            <tr><td colspan="5">&nbsp;</td></tr>
            <cfif isdefined("url.imprimir")>
                <tr><td><h6>&nbsp;</h6></td></tr>
                <tr align="center"><td colspan="5"> --------------------------- Fin del Reporte --------------------------- </td></tr>
            </cfif>
         <cfelse><!--- Caso de que los estados de cuenta no tengan Datos --->
            <cfif cont eq rsEstadoCta.RecordCount>
                 <tr><td><h6>&nbsp;</h6></td></tr>
                 <tr align="center"><td colspan="5"> ----------No hay Datos que Mostrar---------- </td></tr>
                <tr align="center"><td colspan="5"> --------------------------- Fin del Reporte --------------------------- </td></tr>
            </cfif>
        </cfif>
    </cfloop>
</table>
