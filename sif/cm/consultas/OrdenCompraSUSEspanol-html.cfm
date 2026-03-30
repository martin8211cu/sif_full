<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<!--- Query para obtener el nombre del comprador --->
<!--- <cf_dump var="#form#"> --->
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfif isdefined("url.EOidorden") and len(trim(url.EOidorden)) and not isdefined("form.EOidorden")>
	<cfset form.EOidorden = url.EOidorden >
</cfif>

<cfif not isdefined("form.EOidorden") >
	<cfif isdefined("url.EOnumero") and len(trim(url.EOnumero))>
		<cfquery name="rsOrden" datasource="#session.DSN#">
			select EOidorden
			from EOrdenCM
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOnumero#">
		</cfquery>
		<cfset form.EOidorden = rsOrden.EOidorden >
	</cfif>
</cfif>

<cfif not (isdefined("form.EOidorden") and len(trim(form.EOidorden)))>
	<cf_errorCode	code = "50272" msg = "No ha sido definida la Orden que desa imprimir.">
</cfif>

<cf_templatecss>
<style type="text/css">
	.titulo {
		border-top:  #000000 2px solid;
		BORDER-BOTTOM: #000000 2px solid;
		COLOR: #009;
		font-size:18px;
		font-weight:bold;
	}
	.titulo2 {
		border-top:  #000000 2px solid;
		BORDER-BOTTOM: #000000 2px solid;
		COLOR: #999;
		font-size:18px;
		font-weight:bold;
	}
	.borde {
		BORDER-BOTTOM: #000000 2px solid;
		COLOR: #000;
	}
	.areaNumero {
		BORDER-RIGHT: #000000 2px solid;
		PADDING-RIGHT: 3px;
		BORDER-TOP: #000000 2px solid;
		PADDING-LEFT: 3px;
		PADDING-BOTTOM: 3px;
		BORDER-LEFT: #000000 2px solid;
		COLOR: #000000;
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

<cfquery name="data" datasource="#session.DSN#">
	select a.EOidorden,
			a.CMCid,
			b.DOconsecutivo,
			b.Icodigo,
			a.EOnumero,
			a.EOImpresion, 
		   rtrim(c.Edescripcion) as TituloEmpresa, 
           e.CMCnombre as NombreComprador, 
           coalesce(f.SNtelefono,'') as TelefonoProveedor, 
           coalesce(f.SNFax,'') as FaxProveedor, 
           coalesce(f.SNemail,'') as EmailProveedor, 
           f.SNdireccion as Direccion,
           a.EOfecha as FechaOC, 
		   f.SNnumero,
           f.SNnombre as NombreProveedor,
           f.SNidentificacion as CedulaJuridica,
			a.EOplazo,
			g.ESnumero as NumeroSolicitud,
			h.Ucodigo,
			b.DOcantidad,
			#LvarOBJ_PrecioU.enSQL_AS("b.DOpreciou")#,
			b.DOtotal,
			a.Mcodigo,
			i.Mnombre,
			i.Msimbolo,
            i.Miso4217,
			CMtipo,

			<!--- case CMtipo when 'A' then coalesce(b.DOalterna, j.Adescripcion) 
					when 'S' then coalesce(b.DOalterna, k.Cdescripcion)
					when 'F' then coalesce(b.DOalterna, ac.ACdescripcion) 
			end as Descripcion, --->
			<!--- Cambio hecho por: Rodolfo Jimenez Jara, 05-07-2005
			solicitado por:   Nelson Baltodano , Dos Pinos --->
			case CMtipo when 'A' then coalesce(b.DOalterna, '') 
					when 'S' then coalesce(b.DOalterna, '')
					when 'F' then coalesce(b.DOalterna, '') 
			end as Descripcion,

			case CMtipo when 'A' then coalesce(b.DOobservaciones, '') 
					when 'S' then coalesce(b.DOobservaciones, '')
					when 'F' then coalesce(b.DOobservaciones, '') 
			end as ObservacionesOrden,

			case CMtipo when 'A' then coalesce(j.Acodigo,'') when 'S' then coalesce(k.Ccodigo,'') else '' end as CodArticulo,
			case CMtipo when 'A' then coalesce(b.numparte,j.Acodalterno) else '' end as NumeroParte,

			coalesce(ltrim(rtrim(b.DOdescripcion)),'') as DescripcionDetalle,			
			coalesce(b.DOobservaciones,'') as Observacion,

			a.EOtotal as TotalOC,
			a.Impuesto as ImpuestoOC,
			a.EOdesc as DescuentoOC,
			a.EOtotal + a.EOdesc - a.Impuesto as SubtotalOC,

			a.EOnumero as NumeroOC,
		    b.DOfechareq,
		    b.DOfechaes,
		    coalesce(a.Observaciones,'') as Observaciones,
			s.CMPnumero,
			coalesce(b.DOporcdesc, 0.00) as DOporcdesc,
			cmf.CMFPdescripcion,
            cmf.CMFPplazo as PlazoCredito,
			a.EOlugarentrega,
			coalesce(b.DOmontodesc,0.00) as DOmontodesc,
			a.EOdiasEntrega,
			al.Almcodigo,
			al.Bdescripcion,
            c.EDireccion1,
            c.EDireccion2,
            c.EDireccion3,
            c.ETelefono1,
            c.ETelefono2,
            c.EIdentificacion,
            dp.atencion as AtencionProv,
            dp.direccion1 as Dir1Prov, 
            dp.direccion2 as Dir2Prov,
            dp.ciudad as CiudadProv,
            dp.estado as EstadoProv,
            dp.codPostal as CPProv,
			inc.CMIcodigo #_Cat#' - '#_Cat#inc.CMIdescripcion as Incoterm,
			year(EOfecha) as OPeriodo
                        
		from EOrdenCM a 

		inner join DOrdenCM b
		  			 left join Almacen al <!--- Se pone un left por que el campo Alm_Aid acepta nulos --->
						on al.Aid  = b.Alm_Aid
					on a.Ecodigo = b.Ecodigo
					and a.EOidorden = b.EOidorden

		left outer join DCotizacionesCM r
					on b.DClinea = r.DClinea

		left outer join CMProcesoCompra s
					on r.CMPid = s.CMPid

		inner join Empresas c 
					on a.Ecodigo = c.Ecodigo

		inner join CMCompradores e
					on a.Ecodigo = e.Ecodigo 
					and a.CMCid = e.CMCid

		inner join SNegocios f
        	inner join DireccionesSIF dp
            			on f.id_direccion = dp.id_direccion
					on a.Ecodigo = f.Ecodigo
					and a.SNcodigo = f.SNcodigo

		inner join Unidades h
					on  b.Ecodigo = h.Ecodigo
					and b.Ucodigo = h.Ucodigo

		inner join Monedas i
					on  a.Ecodigo = i.Ecodigo
					and a.Mcodigo = i.Mcodigo                     

		left outer join DSolicitudCompraCM g
					on  g.Ecodigo = b.Ecodigo
					and g.ESidsolicitud = b.ESidsolicitud 
					and g.DSlinea = b.DSlinea 

		left outer join Articulos j
				   on b.Aid=j.Aid
				   and b.Ecodigo=j.Ecodigo 

		left outer join Conceptos k
				   on b.Cid=k.Cid
				   and b.Ecodigo=k.Ecodigo 

		left outer join AClasificacion ac
				   on b.Ecodigo = ac.Ecodigo
				   and b.ACcodigo = ac.ACcodigo
				   and b.ACid = ac.ACid  

		left outer join ACategoria atl
				   on b.Ecodigo = atl.Ecodigo
				   and b.ACcodigo = atl.ACcodigo

		left outer join CMFormasPago cmf
				   on a.CMFPid = cmf.CMFPid

		left outer join CMIncoterm inc
				on a.CMIid = inc.CMIid
				and a.Ecodigo = inc.Ecodigo
                
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
   		  and a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
		order by b.DOconsecutivo, NumeroParte, CodArticulo
</cfquery>

<cfset NombreComprador = "">
<cfif isdefined("data") and Len(Trim(data.CMCid))>
	<cfquery name="rsComprador" datasource="#Session.DSN#">
		select CMCnombre
		from CMCompradores
		where CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CMCid#">
	</cfquery>
	<cfset NombreComprador = rsComprador.CMCnombre>
</cfif>

<cfif data.recordCount EQ 0>
	<cf_errorCode	code = "50273" msg = "No se encontraron datos para el detalle de la Orden de Compra">
</cfif>

<!--- datos de la empresa --->
<cfquery name="dataOrden" dbtype="query" maxrows="1">
	select EOidorden
	from data
</cfquery>

<cfquery name="rsAutoriza" datasource="#session.DSN#">
	select * 
	from CMAutorizaOrdenes
	where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataOrden.EOidorden#">
</cfquery>

<cfif rsAutoriza.recordCount gt 0 >
	<!---
		CMAestado (Estado por cada comprador): 
			0 = En Proceso, 1 = Rechazado, 2 = Aprobado
		CMAestadoproceso (Estado general de la orden de Compra): 
			0 = En Proceso, 5 = Rechazado con posibilidad de revivir, 10 = Rechazado sin opcion de revivir, 15 = Aprobado
		Nivel (Jerarquía de Compradores, el último en autorizar debe ser el que tiene el MAYOR nivel)
	--->

	<!--- ME DICE EL ULTIMO COMPRADOR QUE AUTORIZO O RECHAZO LA ORDEN --->
	<cfquery name="dataComprador" datasource="#session.DSN#" maxrows="1">
		select CMAid, CMCid, Nivel, coalesce(CMAestadoproceso,0) as CMAestadoproceso
		from CMAutorizaOrdenes 
		where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataOrden.EOidorden#">
		and CMAestado in (1,2)
		and CMAestadoproceso <> 10
		and Nivel = ( select max(Nivel)
					  from CMAutorizaOrdenes 
					  where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataOrden.EOidorden#">
						and CMAestadoproceso <> 10
						and CMAestado in (1,2) )
	</cfquery>

	<cfif dataComprador.recordCount gt 0 and dataComprador.CMAestadoproceso eq 15>
		<cfset vCMCid = dataComprador.CMCid >
	</cfif>
<cfelse>
	<cfquery name="dataComprador" dbtype="query" maxrows="1">
		select CMCid
		from data
	</cfquery>
	<cfset vCMCid = dataComprador.CMCid >
</cfif>

<cfquery name="dataEncabezado" dbtype="query" maxrows="1">
	select EOnumero, EOImpresion, Observaciones, TituloEmpresa, CMPnumero, Miso4217 as Mnombre,
		   SNnumero, NombreProveedor, CedulaJuridica, TelefonoProveedor, FaxProveedor,
           AtencionProv, Dir1Prov, Dir2Prov, CiudadProv, EstadoProv, CPProv,
           FechaOC, EDireccion1, EDireccion2, EDireccion3, ETelefono1, ETelefono2, EIdentificacion,
           Incoterm, EOlugarentrega, OPeriodo
	from data
</cfquery>

<cfoutput>

<cfsavecontent variable="encabezado">
	<table width="100%" border="0" cellpadding="0"  cellspacing="0" align="center">
        <tr>
            <td align="left" class="titulo">#dataEncabezado.TituloEmpresa#</td>
            <td align="right" class="titulo2">Orden de Compra</td>
        </tr>
        <tr>
            <td align="left" class="LetraEncablight" bgcolor="##CCCCCC">#dataEncabezado.EDireccion1#</td>
            <td align="center" class="LetraEncabBig" bgcolor="##CCCCCC">#dataEncabezado.EOnumero#/#dataEncabezado.OPeriodo#</td>
        </tr>
		<tr>
            <td align="left" class="LetraEncablight" bgcolor="##CCCCCC">#dataEncabezado.EDireccion2#</td>
            <td align="right" class="LetraEncablight" bgcolor="##CCCCCC">Telefono1: #dataEncabezado.ETelefono1#</td>
		</tr>
        <tr>
            <td align="left" class="LetraEncablight" bgcolor="##CCCCCC">#dataEncabezado.EDireccion3#</td>
            <td align="right" class="LetraEncablight" bgcolor="##CCCCCC">Telefono2: #dataEncabezado.ETelefono2#</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
    </table>
</cfsavecontent>
<cfsavecontent variable="encabezado2">
	<table width="100%" border="0" cellpadding="0"  cellspacing="0" align="center">
		<tr>
			<td colspan="2" align="center">
				<table width="100%" border="0" cellpadding="2" cellspacing="0">
					<tr>
						<td colspan="2" align="left" nowrap class="LetraEncabBig">#dataEncabezado.NombreProveedor#</td>
						<td align="right" nowrap class="LetraEncab">Fecha Orden:</td>
						<td align="left" nowrap class="LetraEncablight">#LSDateFormat(dataEncabezado.FechaOC,'dd/mm/yyyy')#</td>
					</tr>
					<tr>
						<td colspan="2" align="left" nowrap class="LetraEncab">#dataEncabezado.CedulaJuridica#</td>
						<td align="right" nowrap class="LetraEncab">Moneda:</td>
						<td align="left" nowrap class="LetraEncablight">#dataEncabezado.Mnombre#</td>
					</tr>
                    <tr>
                    	<td colspan="2" align="left" nowrap class="LetraEncablight">#dataEncabezado.Dir1Prov#</td>
                        <td align="right" nowrap class="LetraEncab">Incoterm:</td>
						<td align="left" nowrap class="LetraEncablight">#dataEncabezado.Incoterm#</td>
                    </tr>
                    <tr>
                    	<td colspan="2" align="left" nowrap class="LetraEncablight">#dataEncabezado.Dir2Prov#</td>
                        <td colspan="2">&nbsp;</td>
                    </tr>
                    <tr>
                    	<td colspan="2" align="left" nowrap class="LetraEncablight">#dataEncabezado.CPProv# #dataEncabezado.CiudadProv#, #dataEncabezado.EstadoProv#</td>
                        <td colspan="2">&nbsp;</td>
                    </tr>
					<tr>
						<td align="left" nowrap class="LetraEncab">Telefono:</td>
						<td align="left" nowrap class="LetraEncablight">#dataEncabezado.TelefonoProveedor#</td>
						<td colspan="2">&nbsp;</td>
					</tr>
                    <tr>
						<td nowrap class="LetraEncab">Fax:</td>
						<td nowrap class="LetraEncablight">#dataEncabezado.FaxProveedor#</td>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
					</tr>
                    <tr>
                    	<td align="left" nowrap class="LetraEncab">Attn:</td>
                        <td align="left" nowrap class="LetraEncablight">#dataEncabezado.AtencionProv#</td>
                        <td colspan="2">&nbsp;</td>
                    </tr>
				</table>
			</td>
		</tr>
        <tr>
			<td colspan="2" align="center">
				<table width="100%" border="0" cellpadding="2" cellspacing="0">
                	<tr>
                    	<td style="border-top: 2px solid black;" width="25%" class="LetraEncab">Lugar de Entrega:</td>
                        <td style="border-top: 2px solid black;" width="25%">&nbsp;</td>
                        <td style="border-top: 2px solid black;" width="25%">&nbsp;</td>
                        <td style="border-top: 2px solid black;" width="25%" class="LetraEncab">Datos Fiscales:</td>
                    </tr>
                    <tr>
                    	<td width="25%" align="left" class="LetraEncablight">#dataEncabezado.EOlugarentrega#</td>
                        <td width="25%">&nbsp;</td>
                        <td width="25%">&nbsp;</td>
						<td width="25%">
                        	<table width="95%" border="0" cellpadding="0" cellspacing="0">
                            	<tr>
                                	<td align="left" class="LetraEncablight">#dataEncabezado.EDireccion1#</td>
                                </tr>
                                <tr>
                                	<td align="left" class="LetraEncablight">#dataEncabezado.EDireccion2#</td>
                                </tr>
                                <tr>
                                	<td align="left" class="LetraEncablight">#dataEncabezado.EDireccion3#</td>
                                </tr>
                                <tr>
                                	<td align="left" class="LetraEncablight">#dataEncabezado.EIdentificacion#</td>
                                </tr>
                            </table>
                        </td>	
                    </tr>
                </table>
            </td>
        </tr>
	</table>
</cfsavecontent>

<cfset contador = 1 >

<!---
<cfset total_general = 0 >
<cfset totalImpuestos = 0 >
<cfset subtotal_general = 0 >
<cfset total_descuento = 0 >
--->
	<cfset PagImp = 0>
    <cfset NPAG = 1>
	<cfset max_lineas = 9 * 1.0>
	<cfset max_lineasR = max_lineas>
    
	<table width="98%" cellpadding="2" cellspacing="0" align="center">
		<cfloop query="data">
			<cfif (isdefined("Url.imprimir") and NPAG EQ 1) or data.Currentrow eq 1>
				<cfset PagImp = PagImp + 1>
    			<tr><td colspan="7">
					#encabezado#
				</td></tr>
				<cfif data.Currentrow eq 1>
                    <tr><td colspan="7">
                        #encabezado2#
                    </td></tr>
                </cfif>
				<tr class="titulolistas">
					<td style="border-top: 2px solid black;" class="LetraEncab">L&iacute;n.</td>
					<td style="border-top: 2px solid black;" class="LetraEncab">Item</td>
					<td style="border-top: 2px solid black;" class="LetraEncab">Descripci&oacute;n</td>
					<td style="border-top: 2px solid black;" align="right" class="LetraEncab">Cant.</td>
					<!---<td class="LetraEncab">UM</td>--->
					<td style="border-top: 2px solid black;" align="right" class="LetraEncab">Precio Unit.</td>
					<!---<td align="right" nowrap class="LetraEncab">% Desc.</td>--->
					<td style="border-top: 2px solid black;" align="right" class="LetraEncab">Impuesto</td>
					<!----<td align="right"><strong>Imp.Calc.</strong></td>---->
					<td style="border-top: 2px solid black;" align="right" class="LetraEncab">Total</td>
				</tr>
				<cfset contador = 1 >
                <cfif PagImp EQ 1 and data.recordcount LT 6>
					<cfset max_lineas = 12 * 1.0>
                <cfelseif PagImp EQ 1 and data.recordcount GTE 5>
                	<cfset max_lineas = 10 * 1.0>
                <cfelseif PagImp GT 1 and data.recordcount - (data.currentrow - 1) GTE 7>
                	<cfset max_lineas = 14 * 1.0>
                <cfelse>
                	<cfset max_lineas = 16 * 1.0>
                </cfif>
                <cfset max_lineasR = max_lineas>
                <cfset NPAG = 0>
			</cfif>
	
			<tr>
				<td class="LetraDetalle">#data.DOconsecutivo#</td>
				<td class="LetraDetalle"><cfif len(trim(data.CodArticulo))>#data.CodArticulo#<cfelse>N/A</cfif></td>
				<td class="LetraDetalle">#data.DescripcionDetalle#</td>
				<td align="right" class="LetraDetalle">#LSNumberFormat(data.DOcantidad,',9.00')#</td>
				<!---<td class="LetraDetalle">#data.Ucodigo#</td>--->
				<td align="right" class="LetraDetalle">#LvarOBJ_PrecioU.enCF_RPT(data.DOpreciou)#</td>
				<!---<td align="right" class="LetraDetalle">#LSNumberFormat(data.DOporcdesc,',9.00')#</td>--->
				<cfset vImpuesto = 0 >
				<cfif len(trim(data.Icodigo))>
					<cfquery name="rsImpuesto" datasource="#session.DSN#">
						select Iporcentaje, Idescripcion
						from Impuestos
						where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and Icodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#data.Icodigo#">
					</cfquery>
					<cfif len(trim(rsImpuesto.Iporcentaje))>
						<cfset vImpuesto = rsImpuesto.Iporcentaje >
					</cfif>
				</cfif>
				<td align="right" nowrap class="LetraDetalle">
					<cfif len(trim(data.Icodigo))>
						#rsImpuesto.Idescripcion# (#rsImpuesto.Iporcentaje#%)
					</cfif>
				</td>								
				<td align="right" class="LetraDetalle">#LSNumberFormat(data.DOtotal,',9.00')#</td>
			</tr>
			
            <!--- Descripcion de Detalles --->
			<cfif len(trim(data.Descripcion)) GT 0>
                <tr>
                  <td class="LetraDetalle">Desc. Alterna: </td>
                  <td colspan="6" class="LetraDetalle">
                    <cfif isdefined("data") and len(trim(data.Descripcion))>#data.Descripcion# </cfif>
                  </td>
                </tr>
                <cfset max_lineasR = max_lineasR - 1>
            </cfif>
            <cfif len(trim(data.ObservacionesOrden)) GT 0>
                <tr>
                    <td class="LetraDetalle">Observaciones: </td>
                    <td colspan="6" class="LetraDetalle">
                        <cfif isdefined("data") and len(trim(data.ObservacionesOrden))>#data.ObservacionesOrden#</cfif>
                    </td>
                </tr>
                <cfset max_lineasR = max_lineasR - 1>
            </cfif>
			<tr>
                <td style="border-bottom: 1px solid gray;" class="LetraDetalle">Fecha Req.:</td>
                <td align="left" style="border-bottom: 1px solid gray;" class="LetraDetalle">#LSDateFormat(data.DOfechareq, 'dd/mm/yyyy')#</td>
                <td style="border-bottom: 1px solid gray;" class="LetraDetalle" align="right">&nbsp;</td>
                <td style="border-bottom: 1px solid gray;" class="LetraDetalle">Fecha Est.:</td>
                <td align="left" style="border-bottom: 1px solid gray;" class="LetraDetalle">#LSDateFormat(data.DOfechaes, 'dd/mm/yyyy')#</td>
                <td colspan="2" style="border-bottom: 1px solid gray;" class="LetraDetalle" align="right">&nbsp;</td>
			</tr>
			
			<cfif isdefined("Url.imprimir") and data.Currentrow NEQ data.recordCount and contador mod max_lineasR EQ 0>
            	<cfset NPAG = 1>
                <tr>
                    <td colspan="7" align="right" class="LetraDetalle">
                        <strong>Pág. #PagImp#</strong>
                    </td>
                </tr>
                <tr class="pageEnd">
                    <td colspan="7">&nbsp;</td>
                </tr>
			</cfif>
			
			<cfset contador = contador + 1 >
			<!---
			<cfset totalImpuestos = totalImpuestos + vMontoImpuesto >
			<cfset subtotal_general = subtotal_general + data.subtotalLinea >
			<cfset total_general = total_general + vTotal >
			<cfset total_descuento = total_descuento + data.DOmontodesc >
			--->
		</cfloop>
	</table> 

	<table width="99%" align="center" cellpadding="0" cellspacing="0">
		<cfquery name="rsResumen" dbtype="query" maxrows="1">
			select 	EOlugarentrega, 
					CMFPdescripcion, 
                    PlazoCredito,
					SubtotalOC, 
					TotalOC, 
					DescuentoOC, 
					ImpuestoOC, 
					Observaciones, 
					FechaOC, 
					EOdiasEntrega
			from data
		</cfquery>
		
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		
		<tr>
			<td>
				<table width="70%" align="center" border="0" cellpadding="2" cellspacing="0">
					<tr>
						<td nowrap class="LetraEncab">Plazo de Credito:</td>
						<td align="left" class="LetraDetalle"> #rsResumen.PlazoCredito# </td>
						<td width="1%" nowrap class="LetraEncab">Subtotal:</td>
						<td align="right" class="LetraDetalle">#LSNumberFormat(rsResumen.SubtotalOC,',9.00')#</td>
					</tr>
					
					<!---<tr>
						<td colspan="2" class="LetraDetalle">&nbsp;</td>
						<td class="LetraEncab">Descuento:</td>
						<td align="right" class="LetraDetalle">#LSNumberFormat(rsResumen.DescuentoOC,',9.00')#</td>
					</tr>--->
					
					<tr>
				  		<td colspan="2" class="LetraEncab">Observaciones:</td>
						<td class="LetraEncab">Impuesto:</td>
						<td  style="border-bottom: 1px solid gray;" align="right" class="LetraDetalle">#LSNumberFormat(rsResumen.ImpuestoOC,',9.00')#</td>
			  		</tr>
					
					<tr>
                    	<td colspan="2" class="LetraDetalle">#rsResumen.Observaciones#</td>
						<td class="LetraEncab">Total:</td>
						<td align="right" class="LetraDetalle">#LSNumberFormat(rsResumen.TotalOC,',9.00')#</td>
					</tr>
					<!---
					<tr>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
						<td nowrap>
							<cfif isdefined("vCMCid") and len(trim(vCMCid))>
								<cfquery datasource="#session.dsn#" name="compradorts">
									select CMFfirma, ts_rversion 
									from CMFirmaComprador
									where CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCMCid#">
								</cfquery>
								<cfif Len(compradorts.CMFfirma) GT 1>
									<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="tsurl">
										<cfinvokeargument name="arTimeStamp" value="#compradorts.ts_rversion#"/>
									</cfinvoke>
									<!--- Es para presentar la imagen tanto en el correo como en la consulta --->
									<cfif isdefined("form.btnEnviar")>
										<img src="CID:firma" ALT="IETF logo"> 
									<cfelse>
										<cfset ts2 = LSTimeFormat(Now(), 'hhmmss')> 
										<img src="/cfmx/sif/cm/catalogos/firma_comprador.cfm?CMCid=#vCMCid#&ts=#tsurl#&ts2=#ts2#" border="0" >
									</cfif>
									
								</cfif>
							</cfif>
						</td>
						<td nowrap>&nbsp;</td>
					</tr>
					--->
                    
                    <tr><td colspan="4">&nbsp;</td></tr>
                    <tr><td colspan="4">&nbsp;</td></tr>
                    <tr><td colspan="4">&nbsp;</td></tr>
                    
                    <tr>
						<td nowrap>&nbsp;</td>
						<td colspan="2" nowrap><hr></td>
                        <td nowrap>&nbsp;</td>
					</tr>
                    <tr>
						<!---<td class="LetraEncab">Usuario Emisor:</td>--->
						<td nowrap>&nbsp;</td>
						<td align="center" colspan="2" class="LetraEncab">Firma</td>
                        <td nowrap>&nbsp;</td>
					</tr>
					<tr>
						<!---<td align="left" class="LetraDetalle">#NombreComprador#</td>--->
						<td nowrap>&nbsp;</td>
						<td colspan="2" align="center" nowrap class="LetraEncab">
							<cfif isdefined("vCMCid") and len(trim(vCMCid))>
                                <cfquery name="rsComprador" datasource="#session.dsn#" >
									select CMCnombre 
									from CMCompradores 
									where CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCMCid#">
								</cfquery>
								<cfif len(trim(rsComprador.CMCnombre)) GT 0>
									#rsComprador.CMCnombre#
								</cfif>
							<cfelse>
                            	#NombreComprador#
                            </cfif>
						</td>
                        <td nowrap>&nbsp;</td>
					</tr>
					
				</table>
			</td>
		</tr>
		
		<!--- 17/02/2005 hecha en Dos Pinos, correccion para imprimir correctamente etiqueta de Original y Copia --->
		<cfif (len(trim(dataEncabezado.EOImpresion)) EQ 0) or (isdefined("url.primeravez"))><!----or (trim(dataEncabezado.EOImpresion) eq 'I'----->
			<tr><td align="right" class="LetraEncab">ORIGINAL - PROVEEDOR</td></tr>	
		<cfelseif len(trim(dataEncabezado.EOImpresion))><!--- neq 'I'---->
			<tr><td align="right" class="LetraEncab">(COPIA NO NEGOCIABLE)</td></tr>
		</cfif>
		<cfif isdefined("Url.imprimir") and data.recordCount>
			<tr><td align="right" class="LetraDetalle"><strong>Pag. #PagImp#</strong></td></tr>
		</cfif>
	</table>
</cfoutput>
<!---Verificar el estado de la impresion de la orden actualmente
	'I' = Impresa la primera vez 
	' ' = Nunca se ha impreso
	'R' = Reimpresion ----->
<cfquery name="rsEstadoImpresion" datasource="#session.DSN#">
	select ltrim(rtrim(EOImpresion)) as EOImpresion from EOrdenCM 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
</cfquery>
<!----ACTUALIZAR EL ESTADO DE LA IMPRESION DE LA OC----->
<cfif isdefined("url.Imprimir") and len(trim(rsEstadoImpresion.EOImpresion)) EQ 0><!----Si la OC todavia no ha sido impresa por primera vez---->
	<cfquery datasource="#session.DSN#">
		update EOrdenCM
		set EOImpresion='I'
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	</cfquery>	
<cfelseif isdefined("url.Imprimir")>
	<cfquery datasource="#session.DSN#">
		update EOrdenCM
		set EOImpresion='R'
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	</cfquery>
</cfif>


