
<cfset arr=ArrayNew(1)>
<cfif ((not isdefined('form.IDpreFactura') or form.IDpreFactura EQ '')  and isdefined('form.chk'))>
	<cfset arr = ListToArray(form.chk,',') >
<cfelse>
	<cfset arr[1]=form.IDpreFactura>
</cfif>
<!--- <cf_dump var="#arr#"> --->
<cfif arraylen(arr) eq 1>
	<cfquery name="rsPFactura" datasource="#session.DSN#">
		<!--- Query Modificado para tabla de Facturas --->
	    Select
	        IDpreFactura,
	        PFdocumento,
	        sn.SNnumero,
	        sn.SNnombre,
	        ds.direccion1,
	        ds.direccion2,
	        ds.ciudad,
	        ds.estado,
	        ofi.Ocodigo,
	        ofi.Odescripcion,
	        m.Miso4217,
	        fac.PFTcodigo,
	        pft.PFTdescripcion,
	        <!--- TipoPago, MIRAC--->
	        Estatus,
	        case Estatus
	            when 'P' then 'Pendiente'
	            when 'E' then 'Estimada'
	            when 'A' then 'Anulada'
	            when 'T' then 'Terminada'
	            when 'V' then 'Vencida'
	        end EstatusDesc,
	        coalesce(Descuento,0) as Descuento,
	        Impuesto,
	        Total,
	        Total-Impuesto+Descuento as SubTotal,
	        Observaciones,
	        TipoCambio,
	        FechaCot,
	        vencimiento,
	        NumOrdenCompra,
	        DdocumentoREF
	    from FAPreFacturaE fac
	        inner join SNegocios sn
	        on fac.Ecodigo = sn.Ecodigo and fac.SNcodigo=sn.SNcodigo
	        left join DireccionesSIF ds
	        on fac.id_direccion = ds.id_direccion
	        inner join Oficinas ofi
	        on fac.Ecodigo = ofi.Ecodigo and fac.Ocodigo = ofi.Ocodigo
	        inner join Monedas m
	        on fac.Ecodigo = m.Ecodigo and fac.Mcodigo = m.Mcodigo
	        inner join FAPFTransacciones pft
	        on fac.Ecodigo = pft.Ecodigo and fac.PFTcodigo = pft.PFTcodigo
	    where fac.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	        and IDpreFactura=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arr[1]#">
	</cfquery>
	<cfset nDocumento = rsPFactura.PFdocumento>
	<cfset nDescripcion = rsPFactura.EstatusDesc>
<cfelse>
	<cfset nDocumento = 'Varios'>
	<cfset nDescripcion = ''>
</cfif>
<cfset LvarIrA     = 'FApreFactura.cfm'>
<cfset LvarFileName = "PreFactura_#nDocumento#-#nDescripcion#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
<cf_htmlReportsHeaders
				title="Formato de Impresi&oacute;n de PreFactura"
				filename="#LvarFileName#"
				irA="#LvarIrA#"	>
				<cfif not isdefined("form.btnDownload")>
					<cf_templatecss>
				</cfif>
<style type="text/css">
	.titulo {
		border-top:  #000000 2px solid;
		BORDER-BOTTOM: #000000 2px solid;
		COLOR: #000;
		font-size:18px;
		font-weight:bold;
	}
	.titulo2 {
		border-top:  #000000 2px solid;
		BORDER-BOTTOM: #000000 2px solid;
		COLOR: #000;
		font-size:14px;
		font-weight:bold;
	}
	.borde {
		BORDER-BOTTOM: #000000 2px solid;
		COLOR: #000000;
	}
	.areaNumero {
		BORDER-RIGHT: #000000 2px solid;
		PADDING-RIGHT: 3px;
		BORDER-TOP: #000000 2px solid;
		PADDING-LEFT: 3px;
		PADDING-BOTTOM: 3px;
		BORDER-LEFT: #000000 2px solid;
		COLOR: #000000;
		@media all {
	.page-break	{ display: none; }
    }

    @media print {
	.page-break	{ display: block; page-break-before: always; }
    }
		PADDING-TOP: 3px;
		BORDER-BOTTOM: #000000 2px solid;

	}
	.LetraDetalle{
		font-size:11px;
	}
	.LetraEncab{
		font-size:12px;
		font-weight:bold;
	}
	.LetraEncablight{
		font-size:12px;
	}
	.LetraEncabBig{
		font-size:14px;
		font-weight:bold;
		color:#333
	}


</style>

<cfoutput>
<form name="formimprime" method="post" action="FApreFactura.cfm">
    <input type="hidden" name="IDpreFactura" id="IDpreFactura" value="#ArrayToList(arr,',')#">

<cfloop array=#arr# index="preFact">

	<cfquery name="rsPFactura" datasource="#session.DSN#">
		<!--- Query Modificado para tabla de Facturas --->
	    Select
	        IDpreFactura,
	        PFdocumento,
	        sn.SNnumero,
	        sn.SNnombre,
	        ds.direccion1,
	        ds.direccion2,
	        ds.ciudad,
	        ds.estado,
	        ofi.Ocodigo,
	        ofi.Odescripcion,
	        m.Miso4217,
	        fac.PFTcodigo,
	        pft.PFTdescripcion,
	        <!--- TipoPago, MIRAC--->
	        Estatus,
	        case Estatus
	            when 'P' then 'Pendiente'
	            when 'E' then 'Estimada'
	            when 'A' then 'Anulada'
	            when 'T' then 'Terminada'
	            when 'V' then 'Vencida'
	        end EstatusDesc,
	        coalesce(Descuento,0) as Descuento,
	        Impuesto,
	        Total,
	        Total-Impuesto+Descuento as SubTotal,
	        Observaciones,
	        TipoCambio,
	        FechaCot,
	        vencimiento,
	        NumOrdenCompra,
	        DdocumentoREF
	    from FAPreFacturaE fac
	        inner join SNegocios sn
	        on fac.Ecodigo = sn.Ecodigo and fac.SNcodigo=sn.SNcodigo
	        left join DireccionesSIF ds
	        on fac.id_direccion = ds.id_direccion
	        inner join Oficinas ofi
	        on fac.Ecodigo = ofi.Ecodigo and fac.Ocodigo = ofi.Ocodigo
	        inner join Monedas m
	        on fac.Ecodigo = m.Ecodigo and fac.Mcodigo = m.Mcodigo
	        inner join FAPFTransacciones pft
	        on fac.Ecodigo = pft.Ecodigo and fac.PFTcodigo = pft.PFTcodigo
	    where fac.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	        and IDpreFactura=<cfqueryparam cfsqltype="cf_sql_numeric" value="#preFact#">
	</cfquery>
	<cfquery name="rsPFacturaD" datasource="#session.DSN#">
	    Select
	        Linea,
	        Cantidad,
	        case TipoLinea
	        when 'A' then 'Articulo'
	        when 'S' then 'Concepto'
	        when 'F' then 'Activo'
	        else 'Desconocido' end as TipoLinea,
	        a.Acodigo,
	        a.Adescripcion,
	        c.Ccodigo,
	        c.Cdescripcion,
	        alm.Almcodigo,
	        alm.Bdescripcion,
	        cc.Cformato,
	        cf.CFcodigo as CFcodigoresp, cf.CFdescripcion as CFdescripcionresp,
	        i.Icodigo, i.Idescripcion,
	        fd.Descripcion,
	        fd.Descripcion_Alt,
	        fd.PrecioUnitario,
	        fd.DescuentoLinea,
	        fd.TotalLinea,
	        fechaalta
	    from FAPreFacturaD fd
	        inner join CFuncional cf
	        on fd.Ecodigo = cf.Ecodigo and fd.CFid = cf.CFid
	        left join Conceptos c
	        on fd.Ecodigo = c.Ecodigo and fd.Cid = c.Cid
	        left join Articulos a
	        on fd.Ecodigo = a.Ecodigo and fd.Aid = a.Aid
	        left join Almacen alm
	        on fd.Ecodigo = alm.Ecodigo and fd.Alm_Aid = alm.Aid
	        inner join CContables cc
	        on fd.Ecodigo = cc.Ecodigo and fd.Ccuenta = cc.Ccuenta
	        inner join Impuestos i
	        on fd.Ecodigo = i.Ecodigo and fd.Icodigo = i.Icodigo
	    where
	    fd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	    and IDpreFactura = <cfqueryparam cfsqltype="cf_sql_numeric" value="#preFact#">
	</cfquery>
    <table width="80%" align="center">
    	<tr>
        	<td colspan="6" align="center" class="titulo"> Formato de Impresion de Pre-Factura </td>
        </tr>
        <tr>
        	<td width="15%"></td>
            <td width="10%"></td>
            <td width="40%"></td>
            <td width="15%"></td>
            <td width="5%"></td>
            <td width="15%"></td>
        </tr>
        <tr>
        	<td align="right" class="LetraEncab">Estatus:</td>
            <td class="LetraEncablight">#rsPFactura.EstatusDesc#</td>
            <td class="LetraEncab"><cfif rsPFactura.EstatusDesc EQ 'Estimada'>Documento Estimado: #rsPFactura.DdocumentoREF#<cfelse>&nbsp;</cfif></td>
        	<td align="right" class="LetraEncab">Fecha:</td>
            <td colspan="2" align="right" class="LetraEncablight">#LsDateFormat(rsPFactura.FechaCot,"dd-mmm-yyyy")#</td>
        </tr>
        <tr>
        	<td align="right" class="LetraEncab">Pre-Factura:</td>
            <td colspan="2" class="LetraEncablight">#rsPFactura.PFdocumento#</td>
            <td align="right" class="LetraEncab">Tipo Pre-Factura:</td>
            <td class="LetraEncablight"></td>
            <td class="LetraEncablight"></td>
        </tr>
        <tr>
        	<td align="right" class="LetraEncab">Cliente:</td>
            <td class="LetraEncablight">#rsPFactura.SNnumero#</td>
            <td class="LetraEncablight">#rsPFactura.SNnombre#</td>
            <td align="right" class="LetraEncab">Moneda:</td>
            <td colspan="2" class="LetraEncablight">#rsPFactura.Miso4217#</td>
        </tr>
        <tr>
        	<td align="right" class="LetraEncab">Oficina:</td>
            <td class="LetraEncablight">#rsPFactura.Ocodigo#</td>
            <td class="LetraEncablight">#rsPFactura.Odescripcion#</td>
            <td align="right" class="LetraEncab">Tipo Cambio:</td>
            <td colspan="2" class="LetraEncablight">#rsPFactura.TipoCambio#</td>
        </tr>
        <tr>
        	<td align="right" class="LetraEncab">Vendedor:</td>
            <td colspan="2" class="LetraEncablight">#rsPFactura.Ocodigo#</td>
            <td align="right" class="LetraEncab">Orden Compra:</td>
            <td colspan="2" class="LetraEncablight">#rsPFactura.NumOrdenCompra#</td>
        </tr>
        <tr>
        	<td colspan="3"></td>
            <td align="right" class="LetraEncab">Dias Vencimiento:</td>
            <td colspan="2" class="LetraEncablight">#rsPFactura.Vencimiento#</td>
        </tr>
        <tr>
        	<td align="right" class="LetraEncab">Observaciones:</td>
            <td colspan="2" class="LetraEncablight" style="border-bottom:thin; border-right:thin; border-left:thin; border-top:thin">#rsPFactura.Observaciones#</td>
            <td>&nbsp;</td>
            <td colspan="2" align="right" class="areaNumero">
            	<table width="100%">
                	<tr>
                    	<td align="right" class="LetraEncab">Sub-Total:</td>
                        <td align="right" class="LetraEncablight">#LSNumberFormat(rsPFactura.SubTotal,',9.00')#</td>
                    </tr>
                    <tr>
                    	<td align="right" class="LetraEncab">Descuento:</td>
                        <td align="right" class="LetraEncablight">#LSNumberFormat(rsPFactura.Descuento,',9.00')#</td>
                    </tr>
                    <tr>
                        <td align="right" class="LetraEncab">Impuesto:</td>
                        <td align="right" class="LetraEncablight">#LSNumberFormat(rsPFactura.Impuesto,',9.00')#</td>
                    </tr>
                    <tr>
                        <td align="right" class="LetraEncab">Total:</td>
                        <td align="right" class="LetraEncablight">#LSNumberFormat(rsPFactura.Total,',9.00')#</td>
                    </tr>
                </table>
            </td>
        </tr>
        <div></div>
        <tr>
        	<td align="center" colspan="6" class="titulo2">Detalles de Pre-Factura</td>
        </tr>
        <cfloop query="rsPFacturaD">
            <tr>
                <td align="center" colspan="6">
                    <table width="100%" align="center">
                        <tr>
                            <td width="10%"></td>
                            <td width="20%"></td>
                            <td width="5%"></td>
                            <td width="10%"></td>
                            <td width="20%"></td>
                            <td width="5%"></td>
                            <td width="10%"></td>
                            <td width="20%"></td>
                        </tr>
                        <tr>
                            <td align="right" class="LetraEncab">Tipo:</td>
                            <td class="LetraEncablight">#rsPFacturaD.TipoLinea#</td>
                            <cfif rsPFacturaD.Tipolinea EQ 'Articulo'>
                                <td align="right" class="LetraEncab">Almac&eacute;n:</td>
                                <td class="LetraEncablight">#rsPFacturaD.Almcodigo#</td>
                                <td class="LetraEncablight">#rsPFacturaD.Bdescripcion#</td>
                                <td align="right" class="LetraEncab">Articulo:</td>
                                <td class="LetraEncablight">#rsPFacturaD.Acodigo#</td>
                            	<td class="LetraEncablight">#rsPFacturaD.Adescripcion#</td>
                            <cfelseif rsPFacturaD.Tipolinea EQ 'Concepto'>
                            	<td align="right" class="LetraEncab">Concepto:</td>
                                <td class="LetraEncablight">#rsPFacturaD.Ccodigo#</td>
                                <td colspan="4" class="LetraEncablight">#rsPFacturaD.Cdescripcion#</td>
							<cfelseif rsPFacturaD.Tipolinea EQ 'Activo'>
                            	<td align="center" colspan="6">Tipo Activo Fijo No soportado en Facturaci&oacute;n</td>
                            <cfelse>
                            	<td align="center" colspan="6">Error Tipo de Linea No soportado en Facturaci&oacute;n</td>
                            </cfif>
                        </tr>
                        <tr>
                            <td align="right" class="LetraEncab">Descripcion:</td>
                            <td colspan="2" class="LetraEncablight">#rsPFacturaD.Descripcion#</td>
                            <td align="right" class="LetraEncab">Descripcion Alterna:</td>
                            <td colspan="4" class="LetraEncablight">#rsPFacturaD.Descripcion_Alt#</td>
                        </tr>
                        <tr>
                            <td align="right" class="LetraEncab">Cuenta:</td>
                            <td class="LetraEncablight">#rsPFacturaD.Cformato#</td>
                            <td align="right" class="LetraEncab">Impuesto:</td>
                            <td class="LetraEncablight">#rsPFacturaD.Icodigo#</td>
                            <td class="LetraEncablight">#rsPFacturaD.Idescripcion#</td>
                            <td align="right" class="LetraEncab">Centro Funcional:</td>
                            <td class="LetraEncablight">#rsPFacturaD.CFcodigoresp#</td>
                            <td class="LetraEncablight">#rsPFacturaD.CFdescripcionresp#</td>
                        </tr>
                        <tr>
                            <td align="right" class="LetraEncab">Cantidad:</td>
                            <td class="LetraEncablight">#LSNumberFormat(rsPFacturaD.Cantidad,',9.0000')#</td>
                            <td align="right" class="LetraEncab">Precio Unitario:</td>
                            <td class="LetraEncablight">#LSNumberFormat(rsPFacturaD.PrecioUnitario,',9.00')#</td>
                            <td align="right" class="LetraEncab">Descuento:</td>
                            <td class="LetraEncablight">#LSNumberFormat(rsPFacturaD.DescuentoLinea,',9.00')#</td>
                            <td align="right" class="LetraEncab">Total:</td>
                            <td class="LetraEncablight">#LSNumberFormat(rsPFacturaD.TotalLinea,',9.00')#</td>
                        </tr>
                        <tr>
                        	<td colspan="8" class="borde">&nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
        </cfloop>
    </table>
	<p style="page-break-after:always;"></p>
	</cfloop>
</form>
</cfoutput>