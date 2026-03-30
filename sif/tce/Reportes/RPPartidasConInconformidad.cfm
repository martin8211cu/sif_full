<!---		Alejandro Bolaños APH
		Fecha 14 de septiembre 2011
		Motivo: Se agrega el valor Todas al combo de seleccion de cuenta, y adapatacion del reporte
		para mostrar la salida de varias cuentas. 
		
		Modificado por: Alejandro Bolaños APH
		Fecha de modificación: 19 de septiembre 2011
		Motivo:	Se agregan los filtros por periodo-mes
--->
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
<cfif isdefined('url.Periodo')>
	<cfset form.Periodo = url.Periodo>
</cfif>
<cfif isdefined('url.mes')>
	<cfset form.mes = url.mes>
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

<cfif isdefined('form.EChasta') and LEN(TRIM(form.EChasta))><!--- Si se define el tipo de filtro por fecha --->
    <cfquery name="rsEstadoCta" datasource="#session.DSN#">
        select ec.ECid, ec.CBid 
        from ECuentaBancaria ec
        where ec.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
          <cfif form.CBid NEQ -1>
            and ec.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
          </cfif>
          and ec.EChasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.EChasta)#">
          and ec.ECStatus = 1
    </cfquery>
<cfelseif isdefined("form.Rango") and form.Rango EQ 'PeriodoMes'><!--- Se utiliza el filtro por periodo Mes --->
         <cfquery name="rsEstadoCta" datasource="#session.DSN#">
            select ec.ECid, ec.CBid 
            from ECuentaBancaria ec
            where ec.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
              <cfif form.CBid NEQ -1>
                and ec.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
              </cfif>
              and ec.EChasta 
	            between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaInicio#">
    	        and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaFin#">      
              and ec.ECStatus = 1
        </cfquery>
<cfelse>
	<cfquery name="rsEstadoCta" datasource="#session.dsn#">
        select ec.ECid, ec.CBid 
        from ECuentaBancaria ec
        where ec.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
        <cfif form.CBid NEQ -1>
        	and ec.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
        </cfif>
        	and ec.ECStatus = 1 
     </cfquery>     
</cfif>
<cfif isdefined('rsEstadoCta') and rsEstadoCta.RecordCount EQ 0>
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
	<cf_htmlReportsHeaders 
		title="" 
		filename="PartidasConInconformidad#session.usucodigo#.xls"
		irA="../consultas/TCEReportePartidasConInconformidad.cfm"
		back = "yes"
		download="yes"
		preview="no"
	>
</cfif>

<table width="85%" cellpadding="2" cellspacing="0" align="center" border="0">
	<tr>
		<td colspan="4"><font size="4"><strong><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong></font></td>
		<td align="right"><font size="1"><strong><cfoutput>#LSDateFormat(Now(),'dd/mm/yyyy')#</cfoutput></strong></font></td>
	</tr>
	<tr><td colspan="6"><font size="3">
    	<cfoutput> 
            <strong>
                Partidas con Inconformidad
                    <cfif isdefined('form.Rango') and form.Rango EQ 'PeriodoMes'>
                        del Periodo: #form.Periodo# Mes: #form.Mes#
                    <cfelseif isdefined('form.EChasta') and LEN(TRIM(form.EChasta))>
                            con Fecha: #LSDateFormat(form.EChasta,'dd/mm/yyyy')#
                    </cfif>
            </strong></font>
        </cfoutput>
        </td>
	</tr>

<!---****************** Consulta Bancos                     ******************--->
<cfquery name="rsDatosBanco" datasource="#session.DSN#">
	select Bdescripcion
    from Bancos 
    where Ecodigo = #Session.Ecodigo#
    and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
</cfquery>

<tr><td colspan="6">&nbsp;</td></tr>
<tr><td colspan="6"><font size="2"><strong>Banco:&nbsp;<cfoutput>#rsDatosBanco.Bdescripcion#</cfoutput></strong></font></td></tr>

<cfset cont=0>
<cfloop query="rsEstadoCta">
	<cfset cont=cont+1>
	<cfset form.ECid = rsEstadoCta.ECid>
    <cfset form.CBid = rsEstadoCta.CBid>
	<cfif isdefined('form.ECid') and LEN(form.Bid) GT 0 and LEN(form.CBid) and LEN(form.ECid)>
		<cfset vparams ="">
        <cfset vparams = vparams & "&Bid=" & form.Bid & "&CBid=" & form.CBid & "&ECid=" & form.ECid & "&cons=" & form.cons>
        <!---****************** Consultas Encabezado 				******************--->
		<cfquery name="rsDatosEncab" datasource="#session.DSN#">
			select CBdescripcion,ECdescripcion
			from ECuentaBancaria ec
			inner join CuentasBancos cb
			   on cb.Bid = ec.Bid
			  and cb.CBid = ec.CBid
			where cb.Ecodigo = #Session.Ecodigo#
              and cb.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
              and cb.CBesTCE = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			  and cb.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
			  and ec.ECid = #form.ECid#
		</cfquery>
        <!--- «« Estados de Cuenta con Inconformidad »» --->
        <cfquery name="rsBancosConciliados" datasource="#Session.DSN#">
            select dc.DCReferencia, b.CDBdocumento ,c.BTEdescripcion , b.CDBfechabanco as fechaBancos, b.CDBmonto, b.BTEcodigo, c.BTEtipo, b.CDBconciliado,b.CDBjustificacion
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
                and b.CDBinconformidad = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
            order by b.BTEcodigo, b.CDBfechabanco, b.CDBmonto desc
    </cfquery>  
    </cfif>
    
	<!--- 
		validar que los querys tengan datos para que no se muestre estados de cuenta sin datos 
	--->
    <cfif  rsDatosEncab.recordcount GT 0 and rsBancosConciliados.RecordCount GT 0>
        <tr><td colspan="6">&nbsp;</td></tr>
        <tr><td colspan="6"><font size="2"><strong>Tarjeta de Cr&eacute;dito:&nbsp;<cfoutput>#rsDAtosEncab.CBdescripcion#</cfoutput></strong></font></td></tr>
        <tr><td colspan="6"><font size="2"><strong>Estado de Cuenta &nbsp;<cfoutput>#rsDAtosEncab.ECdescripcion#</cfoutput></strong></font></td></tr>
        <tr><td align="center" valign="top" colspan="6"><span style="font-size:16px"><strong>REMANENTE DEL BANCO CON INCONFORMIDAD</strong></span></td></tr>
        <cfset totalTransD = 0>
        <cfset totalTransC = 0>
        <cfset totalBancosD = 0>
        <cfset totalBancosC = 0>
           
        <cfif rsBancosConciliados.RecordCount GT 0>
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
                    <tr><td colspan="6">&nbsp;</td></tr>
                    <tr bgcolor="EFEFEF"><td colspan="6" align="left"><span style="font-size:12px;"><strong>#BTEdescripcion#</strong></span></td></tr>
                    <tr class="subTitulo" bgcolor="E2E2E2"> 
                        <td ><strong>Fecha</strong></td>
                        <td ><strong>Documento</strong></td>
                        <td ><strong>Referencia</strong></td>
                        <td align="right"><strong>D&eacute;bito</strong></td>
                        <td align="right"><strong>Cr&eacute;dito</strong></td>
                        <td align="left" width="30%"><strong>Justificación</strong></td>
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
                    <!---JUSTIFICACION--->
                    <td align="left">#CDBjustificacion#</td>
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
            <tr><td colspan="6">&nbsp;</td></tr>
        <cfelse>
            <tr align="center"><td colspan="6"> --------------------------- No hay documentos para bancos --------------------------- </td></tr>
        </cfif>
        <tr><td colspan="6">&nbsp;</td></tr>
        <tr><td colspan="6">&nbsp;</td></tr>
        <cfif isdefined("url.imprimir")>
            <tr><td><h6>&nbsp;</h6></td></tr>
            <tr align="center"><td colspan="6"> --------------------------- Fin del Reporte --------------------------- </td></tr>
        </cfif>
    <cfelse>
    	<cfif cont eq rsEstadoCta.RecordCount>
             <tr align="center"><td colspan="6"> ----------No hay más datos que Mostrar---------- </td></tr>
            <tr align="center"><td colspan="6"> --------------------------- Fin del Reporte --------------------------- </td></tr>
        </cfif>    
   </cfif>     
</cfloop>
</table>

