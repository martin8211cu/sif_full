<cfif len(trim(form.LvarOficinas)) eq 0>
	<cfset LvarirA = "QPassRVentasCorp.cfm">
<cfelse>
	<cfset LvarirA = "QPassRVentas.cfm">
</cfif>

<cfif form.formato eq 'xls'>
    <cfcontent type="application/vnd.ms-excel">
        <cfheader name="Content-Disposition" value="attachment; filename=RecuperacionCobra_#dateformat(now(),'dd-mm-yyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls">
        <cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
    
        <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
            "http://www.w3.org/TR/html4/loose.dtd">
        <html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40">
            <head>
                <title>Consulta Recuperacion Cobranza</title>
                <style type="text/css">
                    table
                    {mso-displayed-decimal-separator:"\.";
                    mso-displayed-thousand-separator:"\,";}
                    .numWithoutDec {mso-number-format:\#\,\#\#0?;text-align:right;}
                    .numWith2Dec {mso-number-format:Standard;text-align:right}
                    .date {mso-number-format:dd\/mm\/yyyy\;\@}
    
                </style>
                <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
                <meta http-equiv="content-language" content="es" />
            </head>
<cfelse>

    
    <cf_htmlReportsHeaders 
        irA="#LvarirA#"
        FileName="Ventas.xls"
        title="Reporte Tags">
    <cfif not isdefined("form.btnDownload")>  
        <cf_templatecss>
    </cfif>
</cfif>
    
<cfset fnRecuperaDatos()>    
<cfflush interval="20">
<cfset LvarColSpan = 11>
<table width="100%" cellpadding="0" cellspacing="1" border="0">	
    <cfoutput>
        <tr align="center">
            <td style="font-size:18px" colspan="#LvarColSpan#" class="tituloListas">
            #rsEmpresa.Enombre#
            </td>
        </tr>
        <tr align="center">
            <td style="font-size:18px" colspan="#LvarColSpan#" class="tituloListas">
            <strong>Reporte de Ventas</strong>
            </td>
        </tr>
        <tr align="center">
            <td align="center" style="width:1%" colspan="#LvarColSpan#" class="tituloListas">
                <strong>Desde:#form.QPLfechaVentaD# hasta:#form.QPLfechaVentaH#</strong>
            </td>
        </tr>
        <tr align="center">
            <td align="center" colspan="#LvarColSpan#" class="tituloListas">
                <strong>Sucursal:<cfif isdefined('form.Oficina')and len(trim(form.Oficina))>
                #rsSUC.Odescripcion#<cfelse>Todas</cfif></strong>
            </td>
        </tr>
    </cfoutput>
	<cfset cantidad = 0>
	<cfset suma = 0>
	<cfset total = 0>
	<cfset sumaCorte = 0>
    <cfloop query="rsVenta">
		<cfquery name="rsCausa" datasource="#session.dsn#">
			select aa.QPCmonto,aa.Mcodigo
				from QPventaConvenio con
					inner join  QPCausaxConvenio cc
						on cc.QPvtaConvid = con.QPvtaConvid
					inner join QPCausa aa
						on aa.QPCid = cc.QPCid
				where con.QPvtaConvid = #rsVenta.QPvtaConvid#
				  and aa.QPCtipo = 4 <!--- Ventas --->
		</cfquery>

		<cfquery name="rsMonto" datasource="#session.dsn#">
			select sum(a.QPMCMontoLoc) as QPMCMontoLoc 
			from QPMovCuenta a 
			inner join QPCausa b 
				on b.QPCid = a.QPCid 
			where  a.QPTidTag = #rsVenta.QPTidTag#  
			and a.QPMCFInclusion = (
										select  min(cu.QPMCFInclusion) 
										from QPMovCuenta  cu  
											inner join QPCausaxConvenio cc 
												inner join QPCausa b 
												on b.QPCid = cc.QPCid 
											on cc.QPCid = cu.QPCid 
										where cu.QPTidTag =  a.QPTidTag
										and cc.QPvtaConvid = #rsVenta.QPvtaConvid#
										and b.QPCtipo = 5 <!--- Recarga --->
									) 
			and b.QPCtipo = 5
		</cfquery>
		
		<cfset fnVerificaCorte()>
       <cfoutput>
            <tr class="<cfif rsVenta.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
		<td align="left"><cfif len(rsVenta.QPvtaEstado) and rsVenta.QPvtaEstado eq 2 or rsVenta.QPvtaEstado eq 3>*</cfif>&nbsp;#rsVenta.QPTPAN#</td>
		<td  nowrap="nowrap" align="left">&nbsp;#rsVenta.QPvtaConvDesc#</td>
		<td  nowrap="nowrap" align="left">&nbsp;#rsVenta.Odescripcion#</td>
		<td  nowrap="nowrap" align="left">&nbsp;#rsVenta.QPcteNombre#</td>
                <td align="left">&nbsp;#rsVenta.QPcteDocumento#</td>	
                <td align="left">&nbsp;#rsVenta.QPctaBancoNum#</td>
                <td align="left">#DateFormat(rsVenta.BMFecha,'dd/mm/yyyy')#</td>	
                <td align="left">&nbsp;#rsVenta.QPvtaAutoriza#</td>	
                <td nowrap="nowrap" align="left">&nbsp;#rsVenta.QPPnombre#</td>		
	        <td align="right"><cfif #rsVenta.QPctaSaldosTipo# eq 2>#LSNumberFormat(LvarM, ',9.00')# <cfelse> N/A </cfif></td>
		<td align="right">&nbsp;#LSNumberFormat(suma, ',9.00')#</td>	
            </tr>
        </cfoutput>
    </cfloop>
	<cfset fnPintaCorte(false)>
    <tr>
        <td align="center" colspan="<cfoutput>#LvarColSpan#</cfoutput>">&nbsp;</td>
    </tr>
    <tr>
        <td align="right" colspan="<cfoutput>#LvarColSpan#</cfoutput>"><strong>Total General:</strong>
      <cfoutput><strong>#LSNumberFormat(total, ',9.00')#</strong></cfoutput></td>
    </tr>
    <tr>
        <td align="center" colspan="<cfoutput>#LvarColSpan#</cfoutput>">***  Fin del Reporte  ***</td>
    </tr>
    <tr>
        <td colspan="<cfoutput>#LvarColSpan#</cfoutput>">&nbsp;</td>
    </tr>
    <tr>
        <td align="center" colspan="<cfoutput>#LvarColSpan#</cfoutput>">*** Este reporte por pantalla muestra un máximo de 500 registros. Si desea ver completa la salida escoja el formato Archivo Plano ***</td>
    </tr>
</table>

<!--- </cfif> --->

<cffunction name="fnVerificaCorte" access="private" output="yes">
	<cfif <!---LvarOcodigoAnt NEQ rsVenta.Ocodigo or---> LvarUsuarioAnt NEQ rsVenta.NombreUsuario or LvarTipoConv NEQ rsVenta.QPctaSaldosTipo2>
        <cfset fnPintaCorte(true)>
    </cfif>
	<cfset suma = 0>

    <cfset LvarTC =1>
	<cfloop query="rsCausa">
    <cfif len(trim(rsCausa.Mcodigo)) and rsCausa.Mcodigo NEQ rsMonedalocal.Mcodigo>
        <cfquery name="rsmoneda" datasource="#session.dsn#">
            select 
                tc.TCventa
            from Htipocambio tc
            where tc.Ecodigo = #Session.Ecodigo#
            and tc.Mcodigo = #rsCausa.Mcodigo#
            and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(rsVenta.BMFecha)#">
            and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(rsVenta.BMFecha)#">
        </cfquery>
        <cfset LvarTC = rsmoneda.TCventa>
    </cfif>
	
		<cfset LvarMonto = #numberformat(rsCausa.QPCmonto  * LvarTC, "9.00")#>
		<cfset sumaCorte = sumaCorte + #numberformat(LvarMonto, "9.00")#>
		<cfset suma = suma + #numberformat(LvarMonto, "9.00")#>
		<cfset total = total + #numberformat(LvarMonto, "9.00")#>
	</cfloop>
			<cfset cantidad = cantidad + 1>
			<cfset LvarM = #numberformat(rsMonto.QPMCMontoLoc, "9.00")#>
</cffunction>

<cffunction name="fnPintaCorte" access="private" output="yes">
	<cfargument name="PintaEncabezado" type="boolean" required="yes">
	<cfif sumaCorte NEQ 0>
        <cfoutput>
        <tr align="left">
        	<td align="right" colspan="#LvarColSpan#"><strong>Cantidad de Dispositivos:</strong>
           <cfoutput><strong>#cantidad#</strong></cfoutput></td>
        </tr>
        <tr align="left">
        	<td align="right" colspan="#LvarColSpan#"><strong>SubTotal:</strong>
            <strong>#LSNumberFormat(sumaCorte, ',9.00')#</strong></td>
        </tr>
        </cfoutput>
    </cfif>
	<cfif PintaEncabezado>
 		<cfoutput>
            <tr>
                <td colspan="#LvarColSpan#" class="tituloAlterno"></td>
            </tr>			
<!---             <tr nowrap="nowrap" align="left" class="tituloListas">
                <td colspan="#LvarColSpan#">Sucursal: <strong>#rsVenta.Odescripcion#</strong></td>
            </tr>
--->            <tr  nowrap="nowrap"  align="left" class="tituloListas">
                <td colspan="#LvarColSpan#">Usuario: <strong>#rsVenta.NombreUsuario#</strong></td>
            </tr>	
            <tr nowrap="nowrap" align="left" class="tituloListas">
                <td colspan="#LvarColSpan#">Tipo de Convenio: <strong>#rsVenta.QPctaSaldosTipo2#</strong></td>
            </tr>
 	    </cfoutput>
        <tr nowrap="nowrap" align="center" class="tituloListas">
            <td colspan="0" align="left">QuickPass</td>
            <td colspan="0" align="left">Convenio</td>
			<td colspan="0" align="left">Sucursal</td>

			
            <td colspan="0" align="left">Cliente</td>
            <td colspan="0" align="left">Identificaci&oacute;n</td>
            <td colspan="0" align="left">Cuenta</td>
            <td colspan="0" align="left">Fecha</td>
            <td colspan="0" align="left">Autorizaci&oacute;n</td>
            <td colspan="0" align="left">Promotor</td>
            <td colspan="0" align="left">Carga Inicial</td>
			<td colspan="0" align="left">Monto</td>
        </tr>
    </cfif>
    <cfset LvarOcodigoAnt = rsVenta.Ocodigo>
    <cfset LvarUsuarioAnt = rsVenta.NombreUsuario>
    <cfset LvarTipoConv = rsVenta.QPctaSaldosTipo2>
    <cfset sumacorte = 0>
    <cfset cantidad = 0>
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
    
<!---     <cfif ></cfif> --->
    
    <cfquery datasource="#session.DSN#" name="rsVenta" maxrows="500"> <!--- Se acordó 500 registros con Kenneth López y Esteban Pereira --->
        select
	    co.QPvtaConvDesc, 
	    a.QPvtaConvid,
            s.QPctaSaldosTipo,
            s.QPctaSaldosSaldo,
            pr.QPPnombre,
            case s.QPctaSaldosTipo when 2 then 'Prepago' when 1 then 'PostPago' else '' end as QPctaSaldosTipo2,	

            <!---d.QPTEstadoActivacion,--->
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
            <!---a.Ecodigo,--->
            a.QPTidTag,        
            <!---a.QPcteid,        --->
            <!---a.QPctaSaldosid,  --->
            a.Ocodigo,
            <!---a.BMusucodigo,--->
            a.QPvtaEstado
        from QPventaTags a 

			left outer join QPventaConvenio co
			on a.QPvtaConvid = co.QPvtaConvid 

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