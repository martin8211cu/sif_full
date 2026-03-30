<cf_htmlReportsHeaders 
	irA="QPConsultaMov.cfm"
	FileName="Movimientos.xls"
	title="Consulta Movimientos de Tags">
<cfif not isdefined("form.btnDownload")>  
	<cf_templatecss>
</cfif>

<style type="text/css">
<!--
.style5 {font-size: 18px; font-weight: bold; }
-->
</style>

<cfquery name="rsEmpresa" datasource="#session.dsn#">
    select Edescripcion 
    from Empresas
    where Ecodigo = #session.Ecodigo#
</cfquery>

<cfif isdefined ('form.QPLfechaH') and len(trim(form.QPLfechaH))>
	<cfset LvarFechaFin = DateAdd("d", 1, #dateformat(form.QPLfechaH,'dd/mm/yyyy')#)>
	<cfset LvarFechaFin = DateAdd("s", -1, #LvarFechaFin#)>
</cfif>

<cfquery datasource="#session.DSN#" name="rsVenta">
   	select
		m.Miso4217,
		c.QPcteNombre, 
		s.QPctaSaldosSaldo,
		b.QPCdescripcion,
		a.QPMCid,                      
		a.QPCid,                         
		a.QPctaSaldosid,          
		a.QPcteid,                      
		a.QPMovid,                    
		a.QPTidTag,                  
		a.QPTPAN,                    
		a.QPMCFInclusion,      
		a.QPMCFProcesa,       
		a.QPMCFAfectacion,   
		a.Mcodigo,                     
		a.QPMCMonto,             
		a.QPMCMontoLoc,       
		a.BMFecha,                   
		a.QPMCSaldoMonedaLocal
		from QPMovCuenta a
			inner join QPCausa b
				on a.QPCid = b.QPCid
			inner join QPcuentaSaldos s
				on s.QPctaSaldosid = a.QPctaSaldosid 	
			inner join QPcliente c
				on c.QPcteid = a.QPcteid	
			inner join Monedas m
				on m.Mcodigo = a.Mcodigo	
	where a.QPTidTag = #form.QPTidTag#
	
	<cfif isdefined("form.QPLfechaH") and len(trim(form.QPLfechaH)) and not isdefined ("form.QPLfechaD")>
			and a.BMFecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.QPLfechaH)#">
	<cfelseif isdefined("form.QPLfechaD") and len(trim(form.QPLfechaD)) and not isdefined ("form.QPLfechaH")>
			and a.BMFecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.QPLfechaD)#">
	<cfelseif isdefined("form.QPLfechaD") and len(trim(form.QPLfechaD)) and isdefined("form.QPLfechaH") and len(trim(form.QPLfechaH))>
        and a.BMFecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.QPLfechaD)#"> and #(LvarFechaFin)#	
	</cfif> 
   order by a.QPMovid
</cfquery>
    
<style type="text/css">
     .RLTtopline {
      border-bottom-width: 1px;
      border-bottom-style: solid;
      border-bottom-color:#000000;
      border-top-color: #000000;
      border-top-width: 1px;
      border-top-style: solid;
     } 
</style>
<cfflush interval="20">
<cfset LvarColSpan = 8>
<table width="100%" cellpadding="0" cellspacing="1" border="0">	
    <cfoutput>
        <tr align="center" bgcolor="E3EDEF">
            <td style="font-size:18px" colspan="#LvarColSpan#">
            #rsEmpresa.Edescripcion#
            </td>
        </tr>
        <tr align="center" bgcolor="E3EDEF">
            <td style="font-size:18px" colspan="#LvarColSpan#">
            <strong>MOVIMIENTOS</strong>
            </td>
        </tr>
        <tr align="center" bgcolor="E3EDEF">
            <td style="font-size:18px" colspan="#LvarColSpan#">
                <strong>Cliente:#rsVenta.QPcteNombre#</strong>
            </td>
        </tr>
		
        <tr align="center" bgcolor="E3EDEF">
            <td align="center" colspan="#LvarColSpan#">
                <strong>TAG:#form.QPTPAN#</strong>
            </td>
        </tr>
	    <tr align="center" bgcolor="E3EDEF">
            <td align="center" colspan="#LvarColSpan#">
                <strong>Desde:#form.QPLfechaD# hasta:#form.QPLfechaH#</strong>
            </td>
        </tr>
		<tr align="center" bgcolor="E3EDEF">
            <td align="center" colspan="#LvarColSpan#">
                <strong>Saldo Inicial:#LSNumberFormat(rsVenta.QPctaSaldosSaldo, ',9.00')#</strong>
            </td>
        </tr>
        <tr>
            <td>&nbsp;
                
            </td>
        </tr>
    </cfoutput>
            <tr bgcolor="E3EDEF" nowrap="nowrap" style="background-color:E3EDEF" align="center" class="tituloListas">
                <td colspan="0" align="left" nowrap="nowrap">Fecha</td>
                <td colspan="0" align="left" nowrap="nowrap">Concepto</td>
                <td colspan="0" align="right" nowrap="nowrap">Monto Local</td>
                <td colspan="0" align="right" nowrap="nowrap">Moneda</td>
                <td colspan="0" align="right" nowrap="nowrap">Monto</td>
                <td colspan="0" align="right" nowrap="nowrap">Moneda</td>
                <td colspan="0" align="right" nowrap="nowrap">Saldo</td>
                <td colspan="0" align="right" nowrap="nowrap">Moneda</td>
            </tr>
	  <cfloop query="rsVenta">	
        <cfoutput>
            <tr class="<cfif rsVenta.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
                <td align="left">#DateFormat(rsVenta.BMFecha,'dd/mm/yyyy')#</td>
                <td align="left" nowrap="nowrap">#rsVenta.QPCdescripcion#</td>
                <td align="right" nowrap="nowrap">#LSNumberFormat(rsVenta.QPMCMontoLoc, ',9.00')#</td>	
                <td align="right" nowrap="nowrap">CRC</td>
                <td align="right" nowrap="nowrap">#LSNumberFormat(rsVenta.QPMCMonto, ',9.00')#</td>	
                <td align="right" nowrap="nowrap">#rsVenta.Miso4217#</td>
                <td align="right" nowrap="nowrap">#LSNumberFormat(rsVenta.QPMCSaldoMonedaLocal, ',9.00')#</td>	
                <td align="right" nowrap="nowrap">CRC</td>
		    </tr>
        </cfoutput>
    </cfloop>
    <tr>
        <td align="center" nowrap="nowrap" colspan="10">***  Fin de la Consulta  ***</td>
    </tr>
    <tr>
        <td colspan="10">&nbsp;</td>
    </tr>
</table>