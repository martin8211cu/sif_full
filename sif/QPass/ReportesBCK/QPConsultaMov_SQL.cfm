<cf_htmlReportsHeaders 
	irA="QPConsultaMov.cfm"
	FileName="Movimientos.xls"
	title="Consulta Movimientos de Tags">

<cfif not isdefined("form.btnDownload")>  
	<cf_templatecss>
</cfif>

<style type="text/css">
<!--
.style1 {
	font-size: 16px;
	font-weight: bold;
}
-->
</style>

<cfset fnObtieneDatos()>

<cfflush interval="20">
<cfset LvarColSpan = 5>
<table width="100%" cellpadding="0" cellspacing="1" border="0">	
	<cfoutput>
    <tr>
        <td colspan="#LvarColSpan#" valign="bottom">
            <img src='/cfmx/sif/js/FCKeditor/editor/logo.html' border="0" align="right"><img src='/cfmx/sif/js/FCKeditor/editor/hsbc_logo_localbank1.gif' border="0">
        </td>		
    </tr>
    <tr>
      <td align="right" nowrap="nowrap" colspan="#LvarColSpan#"><strong>#Fecha#</strong></td>
    </tr>
    <tr>
        <td align="center" colspan="#LvarColSpan#">
            <hr />            
        </td>
    </tr>
     <tr align="left" nowrap="nowrap" >
        <td align="left" colspan="#LvarColSpan#">
            <span class="style1">TAG:&nbsp;#form.QPTPAN#</span>	
        </td>
    </tr>		
    <tr align="left" nowrap="nowrap">
        <td style="font-size:18px" colspan="#LvarColSpan#">
            <span class="style1">Cliente:&nbsp;#rsVenta.QPcteNombre#</span>	
        </td>
    </tr>

    <tr align="left" nowrap="nowrap">
        <td style="font-size:18px" colspan="#LvarColSpan#">
            <span class="style1">Tipo Convenio:&nbsp;#rsVenta.tipo#</span>	
        </td>
    </tr>

    <tr align="left">
        <td align="left" colspan="#LvarColSpan#">
            <span class="style1">Saldo Actual:&nbsp;#LSNumberFormat(rsVenta.QPctaSaldosSaldo, ',9.00')#</span>&nbsp;(*)
        </td>
    </tr>
    <tr>
        <td align="center" colspan="#LvarColSpan#">
            <hr />            
        </td>
    </tr>
    <tr nowrap="nowrap" align="left">
        <td colspan="#LvarColSpan#" style="font-size:16px"><strong>Movimientos realizados entre &nbsp;#form.QPLfechaD#&nbsp;y&nbsp;#form.QPLfechaH#</strong></td>
    </tr>
    <tr>
    <td colspan="#LvarColSpan#">&nbsp;</td>
    </tr>
    </cfoutput>
    <tr nowrap="nowrap" align="center" class="tituloListas">
        <td colspan="0" align="left" nowrap="nowrap">Fecha</td>
        <td colspan="0" align="left" nowrap="nowrap">Concepto</td>
        <td colspan="0" align="right" nowrap="nowrap">Monto</td>
        <td colspan="0" align="right" nowrap="nowrap"><cfoutput>#rsMonedalocal.Mnombre#</cfoutput></td>
        <td colspan="0" align="right" nowrap="nowrap">Saldo</td>
    </tr>
	<tr>
		<td colspan="5" class="tituloAlterno"></td>
	</tr>			
    <tr>
        <td colspan="0" align="left" nowrap="nowrap">&nbsp;</td>
        <td colspan="0" align="left" nowrap="nowrap"><strong>Saldo Inicial:</strong></td>
        <td colspan="0" align="right" nowrap="nowrap">&nbsp;</td>
        <td colspan="0" align="right" nowrap="nowrap">&nbsp;</td>
        <td colspan="0" align="right" nowrap="nowrap"><cfoutput>#LSNumberFormat(saldoInicial_, ',9.00')#</cfoutput></td>
    </tr>
    <cfflush>
    <cfloop query="rsVenta">	
        <cfoutput>
            <tr class="<cfif rsVenta.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
                <td align="left">#DateFormat(rsVenta.QPMCFInclusion,'dd/mm/yyyy')#</td>
                <td align="left" nowrap="nowrap">#rsVenta.QPCdescripcion#</td>
                <td align="right" nowrap="nowrap">#LSNumberFormat(rsVenta.QPMCMonto, ',9.00')# #rsVenta.Miso4217#</td>	
                <td align="right" nowrap="nowrap">#LSNumberFormat(rsVenta.QPMCMontoLoc, ',9.00')#</td>	
                <td align="right" nowrap="nowrap">#LSNumberFormat(rsVenta.QPMCSaldoMonedaLocal, ',9.00')#</td>	
            </tr>
        </cfoutput>
        <cfset LvarSaldoFinal = rsVenta.QPMCSaldoMonedaLocal>
        <cfflush>
    </cfloop>
    <tr>
    	<td>&nbsp;</td>
    </tr>
    <cfoutput>
        <tr>
        	<td>&nbsp;</td>
			<td><strong>Saldo Final:</strong></td>
			<td align="right" colspan="#LvarColSpan-2#">&nbsp;#LSNumberFormat(LvarSaldoFinal, ',9.00')#</td>	
        </tr>
    </cfoutput>
    <cfoutput>
        <tr>
            <td align="center" colspan="#LvarColSpan#">
                <hr />            
            </td>
        </tr>
        <tr>
            <td  align="left" nowrap="nowrap" colspan="#LvarColSpan#">* En este saldo puede que no se reflejen los movimientos realizados en las últimas 48 horas</td>
        </tr>
        <tr>
            <td colspan="#LvarColSpan#">&nbsp;</td>
        </tr>
        <tr>
            <td align="center" nowrap="nowrap" colspan="#LvarColSpan#" class="tituloListas">Servicio al Cliente Tel. 2287-1000</td>
        </tr>
	</cfoutput>
</table>
    
    
<cffunction name="fnObtieneDatos" access="private" output="no">

	<cfif isdefined ('form.QPLfechaH') and len(trim(form.QPLfechaH))>
        <cfset LvarFechaFin = DateAdd("d", 1, #dateformat(form.QPLfechaH,'dd/mm/yyyy')#)>
        <cfset LvarFechaFin = DateAdd("s", -1, #LvarFechaFin#)>
	<cfelse>
        <cfset LvarFechaFin = now()>
    </cfif>

    <cfquery name="rsEmpresa" datasource="#session.dsn#">
        select Edescripcion 
        from Empresas
        where Ecodigo = #session.Ecodigo#
    </cfquery>
    
    <cfquery name="rsMonedalocal" datasource="#session.dsn#">
        select Mnombre
        from Empresas e
            inner join Monedas m 
            on m.Mcodigo = e.Mcodigo
        where e.Ecodigo = #session.Ecodigo#
    </cfquery>
    
	<cfquery name="rsObtieneVentaActiva" datasource="#session.dsn#">
		select max(QPvtaTagid) as QPvtaTagid
		from QPventaTags
		where QPTidTag = #form.QPTidTag#
		  and QPvtaEstado = 1
	</cfquery>
	<cfif len(trim(rsObtieneVentaActiva.QPvtaTagid)) GT 0>
		<cfset LvarQPvtaTagid = rsObtieneVentaActiva.QPvtaTagid>
		<cfquery name="rsObtieneVentaActiva" datasource="#session.dsn#">
			select QPcteid, QPctaSaldosid
			from QPventaTags
			where QPTidTag = #form.QPTidTag#
			  and QPvtaTagid = #LvarQPvtaTagid#
			  and QPvtaEstado = 1
		</cfquery>
	
		<cfset LvarQPcteid = rsObtieneVentaActiva.QPcteid>
		<cfset LvarQPctaSaldosid = rsObtieneVentaActiva.QPctaSaldosid>
	<cfelse>
		<cfset LvarQPvtaTagid = 0>
		<cfset LvarQPcteid = 0>
		<cfset LvarQPctaSaldosid = 0>
	</cfif>	
	
    <cfquery datasource="#session.DSN#" name="rsVenta">
        select
            coalesce(a.QPMCMonto,0) as QPMCMonto,
            m.Miso4217,
            c.QPcteNombre, 
            s.QPctaSaldosSaldo,
	    case 
	     when s.QPctaSaldosTipo =1 then 'PostPago'
	     when s.QPctaSaldosTipo =2 then 'Prepago'
	    end as tipo,
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
            coalesce(a.QPMCSaldoMonedaLocal,0) as QPMCSaldoMonedaLocal,
            coalesce(a.QPMCMontoLoc,0) as QPMCMontoLoc,
            a.BMFecha                   
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
		   and a.QPcteid = #LvarQPcteid#
		   and a.QPctaSaldosid = #LvarQPctaSaldosid#
        <cfif isdefined("form.QPLfechaD") and len(trim(form.QPLfechaD))>
			and a.QPMCFInclusion >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.QPLfechaD)#">
        </cfif>
         and a.QPMCFInclusion <= #LvarFechaFin#
         and a.QPMCFProcesa is not null
       order by a.QPMCid asc
    </cfquery>

    <cfset Fecha  = DateFormat(#now()#,'DD/MM/YYYY') >
    
    <cfset colones_ = 0>
    <cfset saldo_ = 0>
    <cfset saldoInicial_ = 0>
    
    <cfif rsVenta.recordcount gt 0>	
        <cfset colones_ = rsVenta.QPMCSaldoMonedaLocal>
        <cfset saldo_ = rsVenta.QPMCMontoLoc>
        <cfset saldoInicial_ = saldo_ - colones_ >
    </cfif>

	<cfset LvarSaldoFinal = 0>

</cffunction>
