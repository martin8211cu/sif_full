<cfif len(trim(form.LvarOficinas)) eq 0>
	<cfset LvarirA = "QPassRVentasCorp.cfm">
<cfelse>
	<cfset LvarirA = "QPassRVentas.cfm">
</cfif>
<cfset fnRecuperaDatos()>

<cf_htmlReportsHeaders 
	irA="#LvarirA#"
	FileName="Ventas.xls"
	title="Reporte Tags">
<cfif not isdefined("form.btnDownload")>  
	<cf_templatecss>
</cfif>
    
<style type="text/css">
.RLTtopline {
      border-bottom-width: 1px;
      border-bottom-style: solid;
      border-bottom-color:#000000;
      border-top-color: #000000;
      border-top-width: 1px;
      border-top-style: solid;
     } 
.style5 {font-size: 18px; font-weight: bold; }

</style>
<cfflush interval="20">
<cfset LvarColSpan = 8>
<table width="100%" cellpadding="0" cellspacing="1" border="0">	
    <cfoutput>
        <tr align="center" bgcolor="E3EDEF">
            <td style="font-size:18px" colspan="#LvarColSpan#">
            #rsEmpresa.Enombre#
            </td>
        </tr>
        <tr align="center" bgcolor="E3EDEF">
            <td style="font-size:18px" colspan="#LvarColSpan#">
            <strong>Reporte de Ventas</strong>
            </td>
        </tr>
        <tr align="center" bgcolor="E3EDEF">
            <td align="center" style="width:1%" colspan="#LvarColSpan#">
                <strong>Desde:#form.QPLfechaVentaD# hasta:#form.QPLfechaVentaH#</strong>
            </td>
        </tr>
        <tr align="center" bgcolor="E3EDEF">
            <td align="center" colspan="#LvarColSpan#">
                <strong>Sucursal:<cfif isdefined('form.Oficina')and len(trim(form.Oficina))>
                #rsSUC.Odescripcion#<cfelse>Todas</cfif></strong>
            </td>
        </tr>
    </cfoutput>
	<cfset suma = 0>
	<cfset sumaCorte = 0>
    <cfloop query="rsVenta">
		<cfset fnVerificaCorte()>
        <cfoutput>
            <tr class="<cfif rsVenta.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
                <td align="left"<cfif len(rsVenta.QPvtaEstado) and rsVenta.QPvtaEstado eq 2 or rsVenta.QPvtaEstado eq 3>style="color:##F00"</cfif>><cfif len(rsVenta.QPvtaEstado) and rsVenta.QPvtaEstado eq 2 or rsVenta.QPvtaEstado eq 3>*</cfif>&nbsp;#rsVenta.QPTPAN#</td>
                <td align="left"<cfif len(rsVenta.QPvtaEstado) and rsVenta.QPvtaEstado eq 2 or rsVenta.QPvtaEstado eq 3 >style="color:##F00"</cfif>>&nbsp;#rsVenta.QPcteNombre#</td>
                <td align="left"<cfif len(rsVenta.QPvtaEstado) and rsVenta.QPvtaEstado eq 2 or rsVenta.QPvtaEstado eq 3 >style="color:##F00"</cfif>>&nbsp;#rsVenta.QPcteDocumento#</td>	
                <td align="left"<cfif len(rsVenta.QPvtaEstado) and rsVenta.QPvtaEstado eq 2 or rsVenta.QPvtaEstado eq 3 >style="color:##F00"</cfif>>&nbsp;#rsVenta.QPctaBancoNum#</td>
                <td align="left"<cfif len(rsVenta.QPvtaEstado) and rsVenta.QPvtaEstado eq 2 or rsVenta.QPvtaEstado eq 3 >style="color:##F00"</cfif>>#DateFormat(rsVenta.BMFecha,'dd/mm/yyyy')#</td>	
                <td align="left"<cfif len(rsVenta.QPvtaEstado) and rsVenta.QPvtaEstado eq 2 or rsVenta.QPvtaEstado eq 3 >style="color:##F00"</cfif>>&nbsp;#rsVenta.QPvtaAutoriza#</td>	
                <td align="left"<cfif len(rsVenta.QPvtaEstado) and rsVenta.QPvtaEstado eq 2 or rsVenta.QPvtaEstado eq 3 >style="color:##F00"</cfif>>&nbsp;#rsVenta.QPPnombre#</td>		
                <td align="right"<cfif len(rsVenta.QPvtaEstado) and rsVenta.QPvtaEstado eq 2 or rsVenta.QPvtaEstado eq 3 >style="color:##F00"</cfif>>&nbsp;#LSNumberFormat(LvarMonto, ',9.00')#</td>	
            </tr>
        </cfoutput>
    </cfloop>
	<cfset fnPintaCorte(false)>
    <tr>
        <td align="center" colspan="<cfoutput>#LvarColSpan#</cfoutput>">&nbsp;</td>
    </tr>
    <tr>
        <td align="right" colspan="1"><strong>Total:</strong></td>
        <td align="right" colspan="<cfoutput>#LvarColSpan-1#</cfoutput>"><cfoutput><strong>#LSNumberFormat(suma, ',9.00')#</strong></cfoutput></td>
    </tr>
    <tr>
        <td align="center" colspan="<cfoutput>#LvarColSpan#</cfoutput>">***  Fin del Reporte  ***</td>
    </tr>
    <tr>
        <td colspan="<cfoutput>#LvarColSpan#</cfoutput>">&nbsp;</td>
    </tr>
</table>

<cffunction name="fnVerificaCorte" access="private" output="yes">
	<cfif LvarOcodigoAnt NEQ rsVenta.Ocodigo or LvarUsuarioAnt NEQ rsVenta.NombreUsuario or LvarTipoConv NEQ rsVenta.QPctaSaldosTipo2>
        <cfset fnPintaCorte(true)>
    </cfif>
    <cfset LvarTC =1>
    <cfif len(trim(rsVenta.Mcodigo)) and rsVenta.Mcodigo NEQ rsMonedalocal.Mcodigo>
        <cfquery name="rsmoneda" datasource="#session.dsn#">
            select 
                tc.TCventa
            from Htipocambio tc
            where tc.Ecodigo = #Session.Ecodigo#
            and tc.Mcodigo = #rsVenta.Mcodigo#
            and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(rsVenta.QPvtaTagFecha)#">
            and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(rsVenta.QPvtaTagFecha)#">
        </cfquery>
        <cfset LvarTC = rsmoneda.TCventa><!--- <cfdump var="#rsmoneda#"> --->
    </cfif>
    <cfset LvarMonto = #numberformat(rsVenta.montoCausaVenta  * LvarTC, "9.00")#>
    <cfset sumaCorte = sumaCorte + #numberformat(LvarMonto, "9.00")#>
    <cfset suma = suma + #numberformat(LvarMonto, "9.00")#>
</cffunction>

<cffunction name="fnPintaCorte" access="private" output="yes">
	<cfargument name="PintaEncabezado" type="boolean" required="yes">
	<cfif sumaCorte NEQ 0>
        <cfoutput>
        <tr align="left">
            <td align="right" colspan="8" nowrap="nowrap"><cfoutput><strong>#LSNumberFormat(sumaCorte, ',9.00')#</strong></cfoutput></td>
        </tr>
        </cfoutput>
    </cfif>
	<cfif PintaEncabezado>
 		<cfoutput>
            <tr>
                <td colspan="#LvarColSpan#">&nbsp;</td>
            </tr>			
             <tr bgcolor="E3EDEF" nowrap="nowrap" style="background-color:E3EDEF" align="left" class="tituloListas">
                <td colspan="#LvarColSpan#">Sucursal: <strong>#rsVenta.Odescripcion#</strong></td>
            </tr>
            <tr bgcolor="E3EDEF" nowrap="nowrap" style="background-color:E3EDEF" align="left" class="tituloListas">
                <td colspan="#LvarColSpan#">Usuario: <strong>#rsVenta.NombreUsuario#</strong></td>
            </tr>	
            <tr bgcolor="E3EDEF" nowrap="nowrap" style="background-color:E3EDEF" align="left" class="tituloListas">
                <td colspan="#LvarColSpan#">Tipo de Convenio: <strong>#rsVenta.QPctaSaldosTipo2#</strong></td>
            </tr>
 	    </cfoutput>
        <tr bgcolor="E3EDEF" nowrap="nowrap" style="background-color:E3EDEF" align="center" class="tituloListas">
            <td colspan="0" align="left">&nbsp;QuickPass</td>
            <td colspan="0" align="left">Cliente</td>
            <td colspan="0" align="left">Identificaci&oacute;n</td>
            <td colspan="0" align="left">Cuenta</td>
            <td colspan="0" align="left">&nbsp;Fecha</td>
            <td colspan="0" align="left">Autorizaci&oacute;n</td>
            <td colspan="0" align="left">&nbsp;Promotor</td>
            <td colspan="0" align="rigth">Monto</td>
        </tr>
    </cfif>
    <cfset LvarOcodigoAnt = rsVenta.Ocodigo>
    <cfset LvarUsuarioAnt = rsVenta.NombreUsuario>
    <cfset LvarTipoConv = rsVenta.QPctaSaldosTipo2>
    <cfset sumacorte = 0>
</cffunction>

<cffunction name="fnRecuperaDatos" access="private" output="no">
	<cfset LvarOcodigoAnt = "">
    <cfset LvarUsuarioAnt = "">
    <cfset LvarTipoConv = "">

    <cfquery name="rsEmpresa" datasource="#session.dsn#">
        select Enombre
        from Empresa
        where CEcodigo = #session.CEcodigo#
    </cfquery>
    
    <cfquery name="rsSUC" datasource="#session.dsn#">
        select 
            a.Odescripcion 
        from Oficinas a
        where a.Ecodigo = #session.Ecodigo#
        <cfif isdefined('form.Oficina')and len(trim(form.Oficina))>
            and a.Ocodigo = #form.Oficina#
        </cfif>	
        #form.LvarOficinas#
        order by a.Oficodigo
    </cfquery>
    
    <cfif isdefined ('form.QPLfechaVentaH') and len(trim(form.QPLfechaVentaH))>
        <cfset LvarFechaFin = DateAdd("d", 1, #dateformat(form.QPLfechaVentaH,'dd/mm/yyyy')#)>
        <cfset LvarFechaFin = DateAdd("s", -1, #LvarFechaFin#)>
    </cfif>
    
    <!---
        "1" PostPago
        "2" PrePago
        1 Cargo Administrativo
        2 Movimiento por uso
        3 Membresia
        4 Venta PostPago
        5 Recarga
    --->
    
    <cfquery datasource="#session.DSN#" name="rsVenta">
        select
            s.QPctaSaldosTipo,
            s.QPctaSaldosSaldo,
            pr.QPPnombre,
            case s.QPctaSaldosTipo when 2 then 'Prepago' when 1 then 'PostPago' else '' end as QPctaSaldosTipo2,	
            
            ((
                select min(aa.Mcodigo)
                from QPventaConvenio con
                    inner join  QPCausaxConvenio cc
                        on cc.QPvtaConvid = con.QPvtaConvid
                    inner join QPCausa aa
                        on aa.QPCid = cc.QPCid
                where con.QPvtaConvid = a.QPvtaConvid
                  and aa.QPCtipo = 4
            )) as Mcodigo,
        
            coalesce((
                select sum(aa.QPCmonto)
                from QPventaConvenio con
                    inner join  QPCausaxConvenio cc
                        on cc.QPvtaConvid = con.QPvtaConvid
                    inner join QPCausa aa
                        on aa.QPCid = cc.QPCid
                where con.QPvtaConvid = a.QPvtaConvid
                  and aa.QPCtipo = 4
            ), 0) as montoCausaVenta,
            
            d.QPTEstadoActivacion,
            a.QPvtaTagFecha,
            s.QPctaSaldosSaldo,
            a.QPvtaTagid,
            p.Pnombre + ' ' + p.Papellido1 + ' ' + p.Papellido2 as NombreUsuario,
            ((
                select min(b.QPctaBancoNum)
                from QPcuentaBanco b 
                where b.QPctaBancoid = s.QPctaBancoid
            )) as QPctaBancoNum
            ,
            d.QPTPAN,
            c.QPcteDocumento,
            c.QPcteNombre,
            o.Odescripcion,
            a.BMFecha,   
            a.QPvtaAutoriza,
            a.Ecodigo,             
            a.QPTidTag,        
            a.QPcteid,        
            a.QPctaSaldosid,  
            a.Ocodigo,        
            a.BMusucodigo,
            a.QPvtaEstado 
        from QPventaTags a 
            inner join QPassTag d
                on d.QPTidTag = a.QPTidTag
                
            left outer join QPPromotor pr
                 on pr.QPPid = d.QPPid
    
            inner join QPcliente c 
                on c.QPcteid = a.QPcteid 
    
            inner join QPcuentaSaldos s
                on s.QPctaSaldosid = a.QPctaSaldosid 
    
            inner join Oficinas o
                on o.Ecodigo = a.Ecodigo
                and o.Ocodigo = a.Ocodigo
    
            inner join Usuario u
                on a.BMusucodigo = u.Usucodigo
            inner join DatosPersonales p
                on p.datos_personales = u.datos_personales
    
        where a.Ecodigo = #session.Ecodigo#
            and a.QPvtaEstado = 1
            
        <cfif isdefined('form.Oficina')and len(trim(form.Oficina))>
            and a.Ocodigo = #form.Oficina#
        </cfif>	
        
        <cfif isdefined("form.QPLfechaVentaH") and len(trim(form.QPLfechaVentaH)) and not isdefined ("form.QPLfechaVentaD")>
                and a.BMFecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.QPLfechaVentaH)#">
        <cfelseif isdefined("form.QPLfechaVentaD") and len(trim(form.QPLfechaVentaD)) and not isdefined ("form.QPLfechaVentaH")>
                and a.BMFecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.QPLfechaVentaD)#">
        <cfelseif isdefined("form.QPLfechaVentaD") and len(trim(form.QPLfechaVentaD)) and isdefined("form.QPLfechaVentaH") and len(trim(form.QPLfechaVentaH))>
            and a.BMFecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.QPLfechaVentaD)#"> and #(LvarFechaFin)#
        </cfif> 
        #form.LvarOficinas#
       order by o.Ocodigo, p.Papellido1+p.Papellido2+p.Pnombre, QPctaSaldosTipo2, a.BMFecha desc
    </cfquery>
    
    <cfquery name="rsMonedalocal" datasource="#session.dsn#">
        select Mcodigo 
        from Empresas 
        where Ecodigo = #session.Ecodigo#
    </cfquery>
    
</cffunction>
