<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<!--- Query para obtener el nombre del comprador --->
<!--- <cf_dump var="#form#"> --->
<cfset max_lineas = 10 * 1.0>

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
		font-size:10px;
		font-weight:bold;
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
			c.ETelefono1,                   
			c.ETelefono2,             
			c.EDireccion1,         
			c.EDireccion2,             
			c.EDireccion3,     
			c.EIdentificacion as iden ,
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
			a.EOlugarentrega,
			coalesce(b.DOmontodesc,0.00) as DOmontodesc,
			a.EOdiasEntrega,
			al.Almcodigo,
			al.Bdescripcion

		from EOrdenCM a 

		inner join DOrdenCM b
		  			 left join Almacen al <!--- Se pone un left por que el campo Alm_Aid acepta nulos --->
						on al.Aid  = b.Alm_Aid
					on a.EOidorden = b.EOidorden

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
	select EOnumero, EOImpresion, Observaciones, TituloEmpresa, CMPnumero, Mnombre,
		   SNnumero, NombreProveedor, CedulaJuridica, TelefonoProveedor, FaxProveedor, FechaOC
	from data
</cfquery>

<cfoutput>

<cfsavecontent variable="encabezado">
	<table width="98%" border="0" cellpadding="0"  cellspacing="0" align="center">
		<tr>
			<td align="center"><strong><font size="2">#dataEncabezado.TituloEmpresa#</font></strong></td>
		</tr>
		<tr>
			<td align="center" bgcolor="##CCCCCC"><font size="1">Gerencia de Compras</font></td>
		</tr>
		
	
			<tr>
				<td align="center" bgcolor="##CCCCCC"><font size="1">#data.EDireccion1#</font></td>
			</tr>
			<tr>
				<td align="center" bgcolor="##CCCCCC"><font size="1">#data.EDireccion2#</font></td>
			</tr>
		
		
		<tr>
			<td>
				<table width="90%" border="0" align="center">
					<tr>
					
						<td nowrap class="LetraEncab">PBX:</td>
						<td nowrap class="LetraEncab">#session.datos_personales.oficina#</td>
						<td nowrap class="LetraEncab">Fax:</td>
						<td nowrap class="LetraEncab">#session.datos_personales.fax#</td>
						<td nowrap class="LetraEncab">Apdo:</td>
						<td nowrap>&nbsp;</td>
						<td nowrap class="LetraEncab">E-mail:</td>
						<td nowrap class="LetraEncab">#session.datos_personales.email1#</td>
						<td nowrap class="LetraEncab">NIT:</td>
						<td nowrap class="LetraEncab">#data.iden#</td>

					</tr>
				</table>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center"><strong><font size="2">ORDEN DE COMPRA LOCAL No: #dataEncabezado.EOnumero#</font></strong></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>
				<table width="90%" border="0" align="center" cellpadding="2" cellspacing="0">
					<tr>
						<td nowrap class="LetraEncab">Proveedor:</td>
						<td nowrap class="LetraDetalle">#dataEncabezado.NombreProveedor#</td>
						<td nowrap class="LetraEncab">Fecha:</td>
						<td nowrap class="LetraDetalle">#LSDateFormat(dataEncabezado.FechaOC,'dd/mm/yyyy')#</td>
					</tr>
					<tr>
						<td nowrap class="LetraEncab">C&eacute;dula Jur&iacute;dica:</td>
						<td nowrap class="LetraDetalle">#dataEncabezado.CedulaJuridica#</td>
						<td nowrap class="LetraEncab">Publicaci&oacute;n: No.</td>
						<td nowrap class="LetraDetalle">#dataEncabezado.CMPnumero#</td>
					</tr>
					<tr>
						<td nowrap class="LetraEncab">Telefono:</td>
						<td nowrap class="LetraDetalle">#dataEncabezado.TelefonoProveedor#</td>
						<td nowrap class="LetraEncab">Moneda:</td>
						<td nowrap class="LetraDetalle">#dataEncabezado.Mnombre#</td>
					</tr>
					<tr>
						<td nowrap class="LetraEncab">Fax:</td>
						<td nowrap class="LetraDetalle">#dataEncabezado.FaxProveedor#</td>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
					</tr>
					<tr>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>

	</table>
</cfsavecontent>

<cfset contador = 0 >

<!---
<cfset total_general = 0 >
<cfset totalImpuestos = 0 >
<cfset subtotal_general = 0 >
<cfset total_descuento = 0 >
--->

	<table width="98%" cellpadding="2" cellspacing="0" align="center">
		<cfloop query="data">
			<cfif (isdefined("Url.imprimir") and contador eq max_lineas) or data.Currentrow eq 1>
				<tr><td colspan="11">
					#encabezado#
				</td></tr>
				<tr class="titulolistas">
					<td class="LetraEncab">L&iacute;n.</td>
					<td class="LetraEncab">Sol.</td>
					<td class="LetraEncab">Item</td>
					<td nowrap class="LetraEncab">## Parte</td>
					<td class="LetraEncab">Descripción</td>
					<td align="right" class="LetraEncab">Cantidad</td>
					<td class="LetraEncab">UM</td>
					<td align="right" class="LetraEncab">Precio Unit</td>
					<td align="right" nowrap class="LetraEncab">% Desc.</td>
					<td align="right" class="LetraEncab">Impuesto</td>
					<!----<td align="right"><strong>Imp.Calc.</strong></td>---->
					<td align="right" class="LetraEncab">Total</td>
				</tr>
				<cfset contador = 0 >
			</cfif>
	
			<tr>
				<td class="LetraDetalle">#data.DOconsecutivo#</td>
				<td class="LetraDetalle"><cfif len(trim(data.NumeroSolicitud))>#data.NumeroSolicitud#</cfif></td>
				<td class="LetraDetalle"><cfif len(trim(data.CodArticulo))>#data.CodArticulo#<cfelse>N/A</cfif></td>
				<td class="LetraDetalle">
					<cfif data.CMtipo EQ 'A'>
						#data.NumeroParte#
					<cfelse>
						&nbsp;
					</cfif>
				</td>				
				<td class="LetraDetalle">#data.DescripcionDetalle#</td>
				<td align="right" class="LetraDetalle">#LSNumberFormat(data.DOcantidad,',9.00')#</td>
				<td class="LetraDetalle">#data.Ucodigo#</td>
				<td align="right" class="LetraDetalle">#LvarOBJ_PrecioU.enCF_RPT(data.DOpreciou)#</td>
				<td align="right" class="LetraDetalle">#LSNumberFormat(data.DOporcdesc,',9.00')#</td>
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
		
			<tr>
			<!--- Cambios solicitados por Nelson Baltodano
				  Rodolfo Jimenez Jara, 05/05/2005 --->
			  <td colspan="11" class="LetraDetalle"><cfif isdefined("data") and len(trim(data.Descripcion))>#data.Descripcion# </cfif>  <cfif isdefined("data") and len(trim(data.Descripcion)) and len(trim(data.ObservacionesOrden))>-</cfif> #data.ObservacionesOrden# &nbsp;</td>
			</tr>
			<tr>
				<td colspan="2" style="border-bottom: 1px solid gray;" class="LetraDetalle" align="right">Bodega&nbsp;</td>
				<td colspan="9" style="border-bottom: 1px solid gray;" class="LetraDetalle">#data.Almcodigo# -	#data.Bdescripcion#</td>
			</tr>
			
			<cfif isdefined("Url.imprimir") and data.Currentrow NEQ data.recordCount and data.Currentrow mod max_lineas EQ 0>
			<tr>
				<td colspan="11" align="right" class="LetraDetalle">
					<strong>Pág. #Int(data.Currentrow / max_lineas)#/#Ceiling(data.recordCount / max_lineas)#</strong>
				</td>
			</tr>
			<tr class="pageEnd">
				<td colspan="11">&nbsp;</td>
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
				<table width="90%" align="center" border="0" cellpadding="2" cellspacing="0">
					<tr>
						<td width="1%" nowrap class="LetraEncab">Forma de Pago:</td>
						<td class="LetraDetalle">#rsResumen.CMFPdescripcion# </td>
						<td width="1%" nowrap class="LetraEncab">Subtotal:</td>
						<td align="right" class="LetraDetalle">#LSNumberFormat(rsResumen.SubtotalOC,',9.00')#</td>
					</tr>
					
					<tr>
						<td nowrap class="LetraEncab">Fecha de Entrega:</td>
						<td class="LetraDetalle">
							<cfset FechaEntrega = rsResumen.FechaOC>
							<cfif Len(Trim(rsResumen.EOdiasEntrega))>
								<cfset FechaEntrega = DateAdd('d', rsResumen.EOdiasEntrega, FechaEntrega)>
							</cfif>
							#LSDateFormat(FechaEntrega, 'dd/mm/yyyy')#
						</td>
						<td class="LetraEncab">Descuento:</td>
						<td align="right" class="LetraDetalle">#LSNumberFormat(rsResumen.DescuentoOC,',9.00')#</td>
					</tr>
					
					<tr>
				  		<td nowrap class="LetraEncab">Lugar de Entrega:</td>
				  		<td class="LetraDetalle">#rsResumen.EOlugarentrega#</td>
						<td class="LetraEncab">Impuestos:</td>
						<td align="right" class="LetraDetalle">#LSNumberFormat(rsResumen.ImpuestoOC,',9.00')#</td>
			  		</tr>
					
					<tr>
						<td class="LetraEncab">Observaciones:</td>
						<td class="LetraDetalle">#rsResumen.Observaciones#</td>
						<td class="LetraEncab">Total:</td>
						<td align="right" class="LetraDetalle">#LSNumberFormat(rsResumen.TotalOC,',9.00')#</td>
					</tr>
					
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
					
					<tr>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
						<td nowrap><hr></td>
						<td nowrap>&nbsp;</td>
					</tr>
					
					<tr>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
						<td nowrap class="LetraEncab">
							<cfif isdefined("vCMCid") and len(trim(vCMCid))>
								<cfquery name="rsComprador" datasource="#session.dsn#" >
									select CMCnombre 
									from CMCompradores 
									where CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCMCid#">
								</cfquery>
								<cfif len(trim(rsComprador.CMCnombre)) GT 0>
									#rsComprador.CMCnombre#
								</cfif>
							</cfif>
						</td>
						<td nowrap>&nbsp;</td>
					</tr>

					<tr><td colspan="4">&nbsp;</td></tr>
					
					<tr>
						<td class="LetraEncab">Usuario Emisor:</td>
						<td class="LetraDetalle">#NombreComprador#</td>
						<td colspan="2" class="LetraEncab">Autorizado por</td>
					</tr>
				</table>
			</td>
		</tr>
		
		<!--- 17/02/2005 hecha en Dos Pinos, correccion para imprimir correctamente etiqueta de Original y Copia --->
		<cfif (len(trim(dataEncabezado.EOImpresion)) EQ 0) or (isdefined("url.primeravez"))><!----or (trim(dataEncabezado.EOImpresion) eq 'I'----->
			<tr><td align="right" class="LetraEncab">ORIGINAL - PROVEEEDOR</td></tr>	
		<cfelseif len(trim(dataEncabezado.EOImpresion))><!--- neq 'I'---->
			<tr><td align="right" class="LetraEncab">(COPIA NO NEGOCIABLE)</td></tr>
		</cfif>
		<cfif isdefined("Url.imprimir") and data.recordCount>
			<tr><td align="right" class="LetraDetalle"><strong>Pág. #Ceiling(data.recordCount / max_lineas)#/#Ceiling(data.recordCount / max_lineas)#</strong></td></tr>
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


