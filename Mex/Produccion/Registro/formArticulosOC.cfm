<cfset lsOrdenes = ''>
<cfloop from="1" to="#rsProdCliente.recordcount#" index="id">
	<cfset OT = 'OTselcodigo#id#' >
    <cfif isdefined("form.chk#id#")>
    	<cfset lsOrdenes = ListAppend(lsOrdenes,#form['#OT#']#)>
	</cfif>
</cfloop>
<cfset NumArticulos=0>
<cfif #lsOrdenes# neq "">
    <cfquery name="rsArticuloSol" datasource="#Session.DSN#">
        select a.Aid,a.Acodigo,a.Adescripcion, coalesce(sum(p.Pexistencia), 0) as Pexistencia, coalesce(sum(i.MPcantidad), 0) as Cantidad,
                coalesce(ABS(sum(p.Pexistencia)-sum(i.MPcantidad)), 0) as Psugerida,min(i.MPprecioUnit) as precioU
                from Prod_inventario p
                inner join Articulos a on p.Ecodigo=a.Ecodigo and a.Aid=p.Artid
                inner join Prod_insumo i on p.Ecodigo=i.Ecodigo and i.Artid=p.Artid and i.OTseq=p.OTseq and i.OTcodigo=p.OTcodigo
        inner join Prod_ClasificacionAlmacen pc on
                            a.ecodigo = pc.ecodigo
                        and a.Ccodigo = pc.Ccodigo
        left join Existencias e on	
                    p.ecodigo = e.ecodigo
                and e.aid = p.Artid
                and pc.almid = e.alm_aid        
        where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
        		and p.OTcodigo in(<cfqueryparam cfsqltype="cf_sql_varchar" value="#lsOrdenes#" list="yes">)
        group by a.Aid, a.Acodigo, a.Adescripcion
        order by a.Aid, a.Acodigo, a.Adescripcion
    </cfquery>
    <cfset NumArticulos=#rsArticuloSol.recordCount#>
    <cfquery name="rsAlmacen" datasource="#Session.DSN#">
    	select al.aid, al.Bdescripcion
        from Prod_inventario p
        inner join Articulos a on p.Ecodigo=a.Ecodigo and a.Aid=p.Artid
        inner join Prod_ClasificacionAlmacen pc on a.ecodigo = pc.ecodigo and a.Ccodigo = pc.Ccodigo
        inner join Almacen al on al.ecodigo = pc.ecodigo and pc.Almid=al.Aid
        where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
        		and p.OTcodigo in(<cfqueryparam cfsqltype="cf_sql_varchar" value="#lsOrdenes#" list="yes">)
        order by al.Bdescripcion
    </cfquery>    
</cfif>
<cfoutput>
<form action="solicitudOrdenCompra-SQL.cfm" method="post" name="form3">

	<input name="NumArt" type="hidden" value="#NumArticulos#"/>
    
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
        
        	<td><strong>C&oacute;digo Art&iacute;culo</strong></td>
        	<td><strong>Descripci&oacute;n Art&iacute;culo</strong></td>
        	<td align="center"><strong>Cantidad Total (Orden de Trabajo)</strong></td>
        	<td align="center"><strong>Existencia</strong></td>
        	<td align="center"><strong>Cantidad Sugerida</strong></td>
        	<td><strong>Cantidad X Pedir</strong></td>
        	<td><strong>Almacen Destino</strong></td>
        </tr>
		<cfif #lsOrdenes# neq "">
            <cfloop query="rsArticuloSol">
            <tr>
                <td>#rsArticuloSol.Acodigo#
                <input name="idArticulo#CurrentRow#" type="hidden" value="#rsArticuloSol.Aid#"/>
                </td>
                <td>#rsArticuloSol.Adescripcion#
                <input name="artDescripcion#CurrentRow#" type="hidden" value="#rsArticuloSol.Adescripcion#"/>
                <input name="precioU#CurrentRow#" type="hidden" value="#rsArticuloSol.precioU#"/>
                </td>
                <td align="center">#rsArticuloSol.Cantidad#</td>
                <td align="center">#rsArticuloSol.Pexistencia#</td>
                <td align="center">#rsArticuloSol.Psugerida#</td>
                <td align="left" nowrap>
                    <input type="text" name= "CPedir#CurrentRow#" maxlength="4" size="4"/>
                </td>
                <td>
                <select name="Almacen#CurrentRow#">
                    <cfloop query="rsAlmacen">
                        <option value="#rsAlmacen.aid#">#rsAlmacen.Bdescripcion#</option>
					</cfloop>
                </select>
                </td>
            </tr>
            </cfloop>
            <tr>
                <td align="center" colspan="7">  
                    <input type="submit" name="Generar" value="Generar">
                </td>
            </tr>
		</cfif>               
     </table>
</form>
</cfoutput>