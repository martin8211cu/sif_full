<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfset Title           = "Reporte Detallado de Costos & Ingresos Autom&aacute;ticos">
<cfset FileName        = "Costos&Ingresos_Auto">
<cfset FileName 	   = FileName & ".xls">
<cf_htmlreportsheaders title="#Title#" filename="#FileName#" download="yes" ira="repCosIng.cfm">

<style type="text/css">
.ofice {
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-right-style: none;
	border-top-style: none;
	border-left-style: none;
	border-bottom-color: #CCCCCC;
	font-size:14px;
	background-color:#F5F5F5;
}
.cssmoneda {
	font-size:13px;
	background-color:#FAFAFA;
}
.cssg {
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-right-style: none;
	border-top-style: none;
	border-left-style: none;
	border-bottom-color: #CCCCCC;
	font-size:11px;
	background-color:#FAFAFA;
}
.cssg2 {
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-right-style: none;
	border-top-style: none;
	border-left-style: none;
	border-bottom-color: #CCCCCC;
	font-size:11px;
	background-color:#F5F5F5;
}
.cssg3 {
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-right-style: none;
	border-top-width: 1px;
	border-top-style: solid;
	border-left-style: none;
	border-bottom-color: #CCCCCC;
	border-top-color: #CCCCCC;
	font-size:11px;
	background-color:#F5F5F5;
}
.item {
	font-size:12px;
}
.letra {
	font-size:12px;
	padding-bottom:5px;
}
.letra2 {
	font-size:18px;
	font-weight:bold;
}
.letra3 {
	font-size:15px;
	font-weight:bold;
}
.total1 {
	font-size:12px;
	font-weight:bold;
}
.total2 {
	font-size:13px;
	font-weight:bold;
}
.total3 {
	font-size:14px;
	font-weight:bold;
}
.total4 {
	font-size:15px;
	font-weight:bold;
}
.total5 {
	font-size:16px;
	font-weight:bold;
}
.total6 {
	font-size:18px;
	font-weight:bold;
}
</style>

<cfset form.Ocodigo = "">
<cfset form.GOid = "">
<cfset form.GEid = "">
<cfset TituloUbicacion = "Oficina/Grupo">
<cfparam name="form.ubicacion" default="">
<cfif ListFirst(form.ubicacion) EQ 'of'>
	<cfset TituloUbicacion = "Oficina">
    <cfset form.Ocodigo = ListRest(form.ubicacion)>
<cfelseif ListFirst(form.ubicacion) EQ 'ge'>
	<cfset TituloUbicacion = "Grupo de Empresas">
    <cfset form.GEid = ListRest(form.ubicacion)>
<cfelseif form.ubicacion EQ '-1'>
	<cfset TituloUbicacion = "Variables de Empresa">
</cfif>

<cfif ListLen(form.ubicacion) EQ 2>
	<cfset form.AVid = ''>
</cfif>

<cfparam name="form.Ocodigo" default="">
<cfparam name="form.GOid"    default="">
<cfparam name="form.GEid"    default="">
<cfparam name="form.AVid"    default="">

<cfif isdefined("url.resumido") and not isdefined("form.resumido")>
	<cfset form.resumido = Url.resumido>
</cfif>

<cfif isdefined("url.Cid") and not isdefined("form.Cid")>
	<cfset form.Cid = Url.Cid>
</cfif>

<cfif isdefined("url.Cid2") and not isdefined("form.Cid2")>
	<cfset form.Cid2 = Url.Cid2>
</cfif>

<cfif isdefined("url.fechai") and len(trim(url.fechai)) and not isdefined("form.fechai")>
	<cfset form.fechai = Url.fechai>
	<cfset vFechai = lsparseDateTime(form.fechai) >
</cfif>

<cfif isdefined("url.fechaf") and len(trim(url.fechaf)) and not isdefined("form.fechaf")>
	<cfset form.fechaf = Url.fechaf>
    <cfset vFechaf = lsparseDateTime(form.fechaf) >
</cfif>

<cfif isdefined("form.fechai") and len(trim(form.fechai)) >
	<cfset vFechai = lsparseDateTime(form.fechai) >
<cfelse>
	<cfset vFechai = createdate(1900, 01, 01) >
</cfif>

<cfif isdefined("form.fechaf")  and len(trim(form.fechaf)) >
	<cfset vFechaf = lsparseDateTime(form.fechaf) >
<cfelse>
	<cfset vFechaf = createdate(6100, 01, 01) >
</cfif>

<cfif isdefined("url.fCFid") and not isdefined("form.fCFid")>
	<cfset form.fCFid = Url.fCFid>
</cfif>

<cfif isdefined("url.CFcodigo") and not isdefined("form.CFcodigo")>
	<cfset form.CFcodigo = Url.CFcodigo>
</cfif>

<cfif isdefined("url.CFdescripcion") and not isdefined("form.CFdescripcion")>
	<cfset form.CFdescripcion = Url.CFdescripcion>
</cfif>

<!--- Rango de fechas --->
<cfif isdefined("vFechai") and isdefined("vFechaf") >
<cfif DateCompare(vFechai, vFechaf) eq 1 >
	<cfset tmp = vFechai >
    <cfset vFechai = vFfechaf >
    <cfset vFechaf = tmp >
</cfif>
</cfif>

<cfquery name="data0" datasource="#session.DSN#">
    select count(1) as CantidadRegistros
    from ETransaccionesCalculo etc
    inner join ETransacciones et
    on et.ETnumero = etc.ETnumero
    and et.FCid = etc.FCid
    and et.Ecodigo = etc.Ecodigo

    inner join CFuncional cf
    on cf.CFid = etc.CFid
    and cf.Ecodigo = etc.Ecodigo
    
    inner join CfuncionalConc cfc
    on cfc.CFCid = etc.CFCid
    and cfc.Ecodigo = etc.Ecodigo
    
    inner join Conceptos c
    on c.Cid = etc.Cid
    and c.Ecodigo = etc.Ecodigo
    
    inner join Monedas m
    on m.Mcodigo = et.Mcodigo        
    and m.Ecodigo = et.Ecodigo
    
    where etc.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
    
    <cfif isdefined("form.Cid") and len(trim(form.Cid))>
    and etc.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">
    </cfif>
    and c.Ctipo = <cfqueryparam cfsqltype="cf_sql_char" value="G">
    
    and et.ETfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechai#"> 
    and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaf#">	
    
    <cfif isdefined("form.fCFid") and len(trim(form.fCFid))>  
    and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fCFid#">
    </cfif>
    
    <cfif form.MCodigoORI neq -1>
    and m.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MCodigoORI#"> 
    </cfif>
</cfquery>

<cfif data0.CantidadRegistros GT 3000>
    <cf_errorCode	code = "50275"
    msg  = "Se han procesado mas de 3000 registros. La consulta regresa @errorDat_1@. Por favor sea mas especifico en los filtros seleccionados"
    errorDat_1="#data.CantidadRegistros#"
    >
    <cfreturn>
</cfif>

<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="data" datasource="#session.DSN#">
    select 	emp.Edescripcion, emp.Ecodigo,
    cf.Ocodigo,
    ofi.Odescripcion,
    m.Miso4217,
    et.Mcodigo,
    m.Mnombre,
    et.ETfecha,
    etc.Porcentaje,
    etc.MontoA,
    etc.MontoT,
    cf.CFid,
    cf.CFcodigo,
    cf.CFdescripcion,
    et.ETnumero,
    et.ETdocumento,
    et.FCid,
    et.ETserie,
    etc.Cid,
    etc.Cdescripcion,
    cct.CCTdescripcion,
    sn.SNnombre,
    (select CFdescripcion from CFuncional where CFid = etc.CFidD) as CDestino
    
    from ETransaccionesCalculo etc	
    
    inner join ETransacciones et
    on et.ETnumero = etc.ETnumero
    and et.FCid = etc.FCid
    and et.Ecodigo = etc.Ecodigo
    
    inner join CCTransacciones cct
    on cct.CCTcodigo = et.CCTcodigo
    and cct.Ecodigo = et.Ecodigo
    
    inner join SNegocios sn
    on sn.SNcodigo = et.SNcodigo
    and sn.Ecodigo = et.Ecodigo
    
    inner join CFuncional cf
    on cf.CFid = etc.CFid
    and cf.Ecodigo = etc.Ecodigo
    
    inner join CfuncionalConc cfc
    on cfc.CFCid = etc.CFCid
    and cfc.Ecodigo = etc.Ecodigo
    
    inner join Conceptos c
    on c.Cid = etc.Cid
    and c.Ecodigo = etc.Ecodigo
    
    inner join Monedas m
    on m.Mcodigo = et.Mcodigo        
    and m.Ecodigo = et.Ecodigo
    
    inner join Empresas emp
    on emp.Ecodigo = et.Ecodigo 
    
    inner join Oficinas ofi
    on ofi.Ecodigo = et.Ecodigo
    and ofi.Ocodigo = cf.Ocodigo
    
    where 1=1
    <cfif form.ubicacion EQ 1>
    and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    <cfelseif ListFirst(form.ubicacion) EQ 'of'>
    and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
    <cfif len(trim(form.Ocodigo))>
    and ofi.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
    </cfif>
    <cfelseif ListFirst(form.ubicacion) EQ 'ge'>
    and exists(Select 1 from AnexoGEmpresaDet where Ecodigo = emp.Ecodigo <cfif len(trim(form.GEid))> and GEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEid#"> </cfif>)	
    </cfif>	
    
    and et.ETfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechai#"> 
    and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaf#">
    <cfif isdefined("form.Cid") and len(trim(form.Cid))>
    and etc.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">
    </cfif>
    and c.Ctipo = <cfqueryparam cfsqltype="cf_sql_char" value="G">
    
    <cfif isdefined("form.fCFid") and len(trim(form.fCFid))>  
    and b.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fCFid#">
    </cfif>
    
    <cfif form.MCodigoORI neq -1>
    and m.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MCodigoORI#"> 
    </cfif>
    order by emp.Ecodigo, m.Miso4217, et.ETnumero, etc.Cid, cf.CFid
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="1" style="padding-left: 5px; padding-right: 10px" align="center">
<tr> 
<td colspan="6" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cfoutput>#session.Enombre#</cfoutput></strong></td>
</tr>
<tr> 
<td colspan="6" class="letra" align="center"><b>Consulta Detallada de Costos & Ingresos Autom&aacute;ticos</b></td>
</tr>
<cfoutput> 
<tr>
<td colspan="6" align="center" class="letra"><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td>
</tr>
</cfoutput> 			
</table>
<br>
<table width="98%" cellpadding="1" border="0" cellspacing="0" align="center">
<cfset corte = ''>
<cfset total = 0>
<cfoutput query="data" group="Ecodigo">
    <cfset totalemp = 0 >
    <tr><td colspan="12" >&nbsp;</td></tr>
    <tr>
        <td class="letra2" width="1%" nowrap colspan="1"><strong>Empresa:&nbsp;</strong></td>
        <td class="letra2" colspan="11"><strong>#Edescripcion#</strong></td>
    </tr>
    <cfoutput group="Ocodigo">
        <cfset totalofi = 0 >
        <tr>
	        <td class="ofice" width="1%" nowrap colspan="1"><strong>Oficina:&nbsp;</strong></td><td colspan="11" class="ofice"><strong>#Odescripcion#</strong></td>
        </tr>
        
        <cfoutput group="Miso4217">
            <cfset totalmoneda = 0 >
            <tr>
                <td class="cssmoneda" width="1%" nowrap colspan="8">
    	            <strong>Moneda:&nbsp;</strong>#data.Miso4217#
                </td>
            </tr>
            <cfoutput group="ETnumero">
                <tr>
                    <td class="letra" width="1%" nowrap colspan="8">
	                    <strong>Transaccion:&nbsp;</strong>#data.ETdocumento##data.ETserie#
                    </td>
                </tr>
                <cfset totaltran = 0>
                <cfset totalgasto = 0>
                <cfoutput group="Cid">
                    <tr>
                        <td class="cssg" width="1%" nowrap colspan="9">
	                        <strong>Gasto:&nbsp;</strong>#data.Cdescripcion#
                        </td>
                    </tr>
                    <tr bgcolor="##f5f5f5" >
                        <td class="cssg2" ><strong>Fecha</strong></td>
                        <td class="cssg2"><strong>Transacci&oacute;n</strong></td>
                        <td class="cssg2"><strong>Factura</strong></td>
                        <td class="cssg2"><strong>Tipo</strong></td>
                        <td class="cssg2"><strong>Centro Funcional</strong></td>
                        <td class="cssg2"><strong>Cliente</strong></td>
                        <td class="cssg2"><strong>Monto de Venta</strong></td>
                        <td align="right" class="cssg2"><strong>% Costo</strong></td>
                        <td align="right" class="cssg2"><strong>Monto Calculado</strong></td>
                    </tr>
                    <cfset total = 0 >
                    <cfoutput> 
                        <tr class="<cfif data.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" >
                            <td class="letra" >#LSDateFormat(data.ETfecha,'dd/mm/yyyy')#</td>
                            <td class="letra" >#data.ETdocumento##data.ETserie#</td>
                            <td class="letra" >#data.ETnumero#</td>
                            <td class="letra" >#data.CCTdescripcion#</td>
                            <td class="letra" >#data.CFdescripcion#</td>
                            <td class="letra" >#data.SNnombre#</td>		
                            <td class="letra"  >#LSCurrencyFormat(data.MontoT,'none')#</td>                      
                            <td class="letra" align="right">#data.Porcentaje#</td>
                            <td class="letra" align="right">#LSCurrencyFormat(data.MontoA,'none')#</td>
                            <cfset total = total + data.MontoA>
                        </tr>
                    </cfoutput>
					<cfif not isdefined("form.resumido")>
                        <tr >
                            <td colspan="2"><strong>&nbsp;</strong></td>
                            <td class="cssg2" colspan="4" align="center" bgcolor="##f5f5f5" ><strong>Detalle de la Transacci&oacute;n</strong></td>
                        </tr>
                        <tr >
                            <td colspan="2"><strong>&nbsp;</strong></td>
                            <td class="cssg2" bgcolor="##f5f5f5" ><strong>L&iacute;nea</strong></td>
                            <td class="cssg2" bgcolor="##f5f5f5" ><strong>Descripci&oacute;n</strong></td>
                            <td class="cssg2" bgcolor="##f5f5f5" ><strong>Tipo</strong></td>
                            <td class="cssg2" bgcolor="##f5f5f5" ><strong>Monto</strong></td>
                        </tr>
                        <cfquery name="rsDetalleTransacciones" datasource="#session.DSN#">
                            select case DTtipo 
                                   when 'A' then 
                                        'Articulo'
                                   when 'S' then 
                                        'Servicio'
                                   else '--' end as tipo, DTtotal,DTdescripcion
                            from DTransacciones
                            where FCid = #data.FCid#
                            and ETnumero = #data.ETnumero#
                            and Ecodigo = #data.Ecodigo#
                        </cfquery>
                        <cfloop query="rsDetalleTransacciones">
                            <tr>
                                <td colspan="2"><strong>&nbsp;</strong></td>
                                <td class="letra">#rsDetalleTransacciones.CurrentRow#</td>
                                <td class="letra">#rsDetalleTransacciones.DTdescripcion#</td>
                                <td class="letra">#rsDetalleTransacciones.tipo#</td>
                                <td class="letra">#LSCurrencyFormat(rsDetalleTransacciones.DTtotal,'none')#</td>
                            </tr>
                        </cfloop>
                    </cfif>
                    <tr>
                        <td colspan="8" class="total1" align="right">Total:&nbsp;</td>
                        <td align="right" class="total1">#LSCurrencyFormat(total,'none')#</td>
                    </tr>
                    
                    <tr>
	                    <td colspan="9" >&nbsp;</td>
                    </tr>
                    <cfset totalgasto = totalgasto + total >
                </cfoutput>
                <cfset totaltran = totaltran + totalgasto >
                <tr>
                    <td colspan="8" class="total2" align="right">Total Gastos:&nbsp;</td>
                    <td align="right" class="total2">#LSCurrencyFormat(totalgasto,'none')#</td>
                </tr>
                
                <cfquery name="rsDetalleIng" datasource="#session.DSN#">
                    select etr.*, 
                    coalesce((select Cdescripcion 
                    from CfuncionalConc cfc
                    inner join Conceptos c 
                    on c.Cid = cfc.Cid
                    and c.Ecodigo = cfc.Ecodigo
                    where cfc.CFCid_Costo = cf.CFCid_Costo 
                    and cfc.CFid = cf.CFid
                    and cfc.Ecodigo = cf.Ecodigo
                    ),'No') as costo,
                    coalesce((select CFdescripcion 
                    from CFuncional
                    where CFid = cf.CFidD 
                    and Ecodigo = cf.Ecodigo
                    ),'No') as CFDestino 
                    ,cfun.CFdescripcion
                    from ETransaccionesCalculo etr
                    inner join CfuncionalConc cf
                    on cf.Cid = etr.Cid
                    and cf.Ecodigo = etr.Ecodigo
                    inner join CFuncional cfun
                    on cfun.CFid = cf.CFid
                    and cfun.Ecodigo = etr.Ecodigo
                    where ETnumero = #data.ETnumero#
                    and FCid = #data.FCid#
                    and etr.Ecodigo = #data.Ecodigo#
                    and Tipo = 'I'
                </cfquery>
                				
                <tr>
                    <td class="cssg" width="1%" nowrap colspan="9">
    	                <strong>Detalle de Ingresos</strong>
	                </td>
                </tr>
                
                <tr bgcolor="##f5f5f5" >
                    <td class="cssg2" colspan="2"><strong>Ingreso</strong></td>
                    <td class="cssg2" colspan="2"><strong>Centro Funcional</strong></td>
                    <td class="cssg2"><strong>Centro Funcional Destino</strong></td>
                    <td class="cssg2"><strong>Costo Asociado</strong></td>
                    <td class="cssg2"><strong>Monto de Costos</strong></td>
                    <td align="right" class="cssg2"><strong>% Ingreso</strong></td>
                    <td align="right" class="cssg2"><strong>Monto Calculado</strong></td>
                </tr>
                <cfset totalIng = 0>
                <cfloop query="rsDetalleIng">
                    <tr class="<cfif rsDetalleIng.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" >
                        <td class="letra" nowrap="nowrap" colspan="2">#rsDetalleIng.Cdescripcion#&nbsp;</td>
                        <td class="letra" colspan="2">#rsDetalleIng.CFdescripcion#&nbsp;</td>
                        <td class="letra" >#rsDetalleIng.CFDestino#&nbsp;</td>
                        <td class="letra" >#rsDetalleIng.costo#</td>		
                        <td class="letra"  >#LSCurrencyFormat(rsDetalleIng.MontoT,'none')#</td>                      
                        <td class="letra" align="right">#rsDetalleIng.Porcentaje#</td>
                        <td class="letra" align="right">#LSCurrencyFormat(rsDetalleIng.MontoA,'none')#</td>
                    </tr>
                    <cfset totalIng = totalIng + rsDetalleIng.MontoA>
                </cfloop>
                <cfset totaltran = totaltran + totalIng >
                <tr>
                    <td colspan="8" class="total2" align="right">Total Ingresos:&nbsp;</td>
                    <td align="right" class="total2">#LSCurrencyFormat(totalIng,'none')#</td>
                </tr>
                <tr>
	                <td colspan="9" >&nbsp;</td>
                </tr>

                <tr>
                    <td colspan="8" class="total3" align="right"><strong>Total Transaccion:&nbsp;</strong></td>
                    <td align="right" class="total3"><strong>#LSCurrencyFormat(totaltran,'none')#</strong></td>
                </tr>
                <tr>
                    <td colspan="9" >&nbsp;</td>
                </tr>
                <cfset totalmoneda = totalmoneda + totaltran>
            </cfoutput> <!--- TRANSACCION --->
            	 <tr>
                    <td colspan="8" class="total4" align="right">Total #Miso4217#:&nbsp;</td>
                    <td align="right" class="total4">#LSCurrencyFormat(totalmoneda,'none')#</td>
                </tr>
                <tr>
                    <td colspan="9" >&nbsp;</td>
                </tr>
                 <cfset totalofi = totalofi + totalmoneda>
        </cfoutput> <!--- MONEDA --->
        <tr>
            <td colspan="8" class="total5" align="right">Total #Odescripcion#:&nbsp;</td>
            <td align="right" class="total5">#LSCurrencyFormat(totalofi,'none')#</td>
        </tr>
        <tr>
            <td colspan="9" >&nbsp;</td>
        </tr>
        <cfset totalemp = totalemp + totalofi>
    </cfoutput> <!--- OFICINA --->
    <tr>
        <td colspan="8" class="total6" align="right">Total #Edescripcion#:&nbsp;</td>
        <td align="right" class="total6">#LSCurrencyFormat(totalemp,'none')#</td>
    </tr>
    <tr>
        <td colspan="9" >&nbsp;</td>
    </tr>
</cfoutput> <!--- EMPRESA --->

<cfif data.RecordCount gt 0 >
<tr><td colspan="9" align="center">&nbsp;</td></tr>
<tr><td colspan="9" align="center">------------------ Fin del Reporte ------------------</td></tr>
<cfelse>
<tr><td colspan="9" align="center">&nbsp;</td></tr>
<tr><td colspan="9" align="center">--- No se encontraron datos ----</td></tr>
</cfif>
</table>
<br>