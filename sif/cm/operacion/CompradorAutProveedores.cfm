<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>

<cf_templatecss>

<cfif isdefined("url.ESidsolicitud") and len(trim(url.ESidsolicitud))>
	<cfset form.ESidsolicitud = url.ESidsolicitud>
</cfif>

<cfif isdefined("url.DSlinea") and len(trim(url.DSlinea))>
	<cfset form.DSlinea = url.DSlinea>
</cfif>

<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>

<cfquery name="rsItem" datasource="#session.DSN#"><!----Obtener el ID del bien(articulo, servicio, activo)----->
	select Aid, Cid, ACid 
	from DSolicitudCompraCM 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
		and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DSlinea#">
</cfquery>

<cfif rsItem.RecordCount NEQ 0>
	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery name="rsContratos" datasource="#session.DSN#">
		select 	case b.DStipo 	when 'A' then a.Aid
								when 'S' then a.Cid
								when 'F' then a.ACid end as Bien,
				case b.DStipo 	when 'A' then ltrim(rtrim(Acodigo))
								when 'S' then ltrim(rtrim(n.Ccodigo))
								when 'F' then '' end as codigo,
				b.DSdescripcion,
				coalesce(b.DScant,0) as DScant,
				d.ECdesc,
				#LvarOBJ_PrecioU.enSQL_AS("coalesce(a.DCpreciou,0.00) / coalesce(a.DCcantcontrato,1.00)", "DCpreciou")#,
				a.Ucodigo,
				coalesce(a.DCcantcontrato,0) - coalesce(a.DCcantsurtida,0) as CantidadDisponible,
				ltrim(rtrim(h.SNidentificacion))#_Cat#' - '#_Cat#ltrim(rtrim(h.SNnombre)) as SocioNEgocio,
				a.ECid,
				d.SNcodigo,
				mon.Mnombre
				
		from DContratosCM a
			
			inner join Monedas mon
				on a.Mcodigo = mon.Mcodigo
				and a.Ecodigo = mon.Ecodigo
		
			inner join EContratosCM d
				on a.ECid = d.ECid
				and a.Ecodigo = d.Ecodigo		
				
				inner join SNegocios h
					on d.SNcodigo = h.SNcodigo 
					and d.Ecodigo = h.Ecodigo
		
			inner join DSolicitudCompraCM b
				on a.Ecodigo = b.Ecodigo				
				and a.Ucodigo = b.Ucodigo				<!----Valida que el contrato este en la misma unidad de medida que la solicitud---->
				and a.DCtipoitem = b.DStipo
				and b.DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DSlinea#">
				<cfif isdefined("rsItem.Aid") and len(trim(rsItem.Aid))><!---Si es un articulo---->
					and a.Aid = b.Aid
				<cfelseif isdefined("rsItem.Cid") and len(trim(rsItem.Cid))><!---Si es un servicio---->
					and a.Cid = b.Cid
				<cfelse><!---Si es un activo--->					
					and a.ACid = b.ACid
				</cfif>
		
				inner join ESolicitudCompraCM g
					on b.ESidsolicitud = g.ESidsolicitud
					and b.Ecodigo = g.Ecodigo
					<!---Valida que la fecha de la aplicacion de la solicitud este dentro del rango de vigencia del contrato----->
					and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between d.ECfechaini and ECfechafin 	
		
				-- Articulos
				left outer join Articulos m
					on b.Aid=m.Aid
					and b.Ecodigo=m.Ecodigo
			  
				-- Conceptos
				left outer join Conceptos n
					on b.Cid=n.Cid
					and b.Ecodigo=n.Ecodigo
		 
				<!---
				-- Activos
				left outer join ACategoria o
					on a.ACcodigo=o.ACcodigo
					and a.Ecodigo=o.Ecodigo
		 
				left outer join AClasificacion k
					on a.ACcodigo=k.ACcodigo
					and a.ACid=k.ACid
					and a.Ecodigo=k.Ecodigo
				----->
			
				inner join DSProvLineasContrato c
					on b.DSlinea = c.DSlinea
					and b.Ecodigo = c.Ecodigo	
		
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">			
			<cfif isdefined("rsItem.Aid") and len(trim(rsItem.Aid))><!---Si es un articulo---->
				and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsItem.Aid#">
			<cfelseif isdefined("rsItem.Cid") and len(trim(rsItem.Cid))><!---Si es un servicio---->
				and a.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsItem.Cid#">
			<cfelse><!---Si es un activo--->
				and a.ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsItem.ACid#">
			</cfif>
		Order by #LvarOBJ_PrecioU.enSQL("a.DCpreciou")# asc
	</cfquery>

	<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr><td colspan="8">&nbsp;</td></tr>
		<tr><td colspan="8" style="font-family:Verdana; font-size:11px" align="center"><strong>DETALLE DE PROVEEDORES</strong></td></tr>
		<tr><td colspan="8">&nbsp;</td></tr>
		<tr><td colspan="8">&nbsp;</td></tr>
		<cfif rsContratos.RecordCount NEQ 0>
			<form name="form1" action="CompradorAutProveedores-sql.cfm" method="post" onSubmit="javascript: return funcValidaciones();">
				<input type="hidden" name="DSlinea" value="#form.DSlinea#">
				<input type="hidden" name="ESidsolicitud" value="#form.ESidsolicitud#">
					<tr>
						<td colspan="8">
							<table width="100%" cellpadding="0" cellspacing="0" bgcolor="gainsboro">
								<tr>
									<td width="4%"><strong>Item:</strong></td>
									<td width="13%">#rsContratos.codigo#</td>
									<td width="9%"><strong>Descripci&oacute;n:</strong></td>
									<td width="43%">#rsContratos.DSdescripcion#</td>
									<td width="14%" nowrap><strong>Cantidad solicitada:</strong></td>
									<td width="17%">
										#rsContratos.DScant#
										<input type="hidden" name="DScant" value="#rsContratos.DScant#">
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td class="listaCorte" align="center" style="border-bottom: 1px solid black; border-right:1px solid black; border-left: 1px solid black; border-top:  1px solid black;"><strong>Nombre proveedor&nbsp;</strong></td>
						<td class="listaCorte" align="center" style="border-bottom: 1px solid black; border-right:1px solid black; border-top:  1px solid black;"><strong>Descripci&oacute;n del contrato&nbsp;</strong></td>
						<td class="listaCorte" align="center" style="border-bottom: 1px solid black; border-right:1px solid black; border-top:  1px solid black;"><strong>Cantidad disponible&nbsp;</strong></td>
						<td class="listaCorte" align="center" style="border-bottom: 1px solid black; border-right:1px solid black; border-top:  1px solid black;"><strong>Unidad de medida&nbsp;</strong></td>
						<td class="listaCorte" align="center" style="border-bottom: 1px solid black; border-right:1px solid black; border-top:  1px solid black;"><strong>Moneda&nbsp;</strong></td>
						<td class="listaCorte" align="right" style="border-bottom: 1px solid black; border-right:1px solid black; border-top:  1px solid black;"><strong>Precio unitario&nbsp;</strong></td>
						<td class="listaCorte" align="center" style="border-bottom: 1px solid black; border-right:1px solid black; border-top:  1px solid black;"><strong>Cantidad seleccionada&nbsp;</strong></td>
						<td class="listaCorte" align="center" style="border-bottom: 1px solid black; border-right:1px solid black; border-top:  1px solid black;"><strong>Cantidad adjudicada&nbsp;</strong></td>
					</tr>
					<cfloop query="rsContratos">			
						<cfquery name="rsProveedor" datasource="#session.DSN#">
							select coalesce(DSDcantidad,0) as DSDcantidad
							from DSDetalleProveedores 
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
								and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsContratos.SNcodigo#">	
								and DSlinea  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DSlinea#">
						</cfquery>
						<tr>
							<td style="border-bottom: 1px solid black; border-right:1px solid black; border-left: 1px solid black;">#SocioNEgocio#</td>
							<td style="border-bottom: 1px solid black; border-right:1px solid black;">#ECdesc#</td>
							<td align="center" style="border-bottom: 1px solid black; border-right:1px solid black;">
								<input type="hidden" name="CantidadDisponible_#rsContratos.SNcodigo#" value="#CantidadDisponible#">
								#CantidadDisponible#
							</td>
							<td style="border-bottom: 1px solid black; border-right:1px solid black;" align="center">#Ucodigo#</td>
							<td style="border-bottom: 1px solid black; border-right:1px solid black;" align="center">#Mnombre#</td>
							<td align="right" style="border-bottom: 1px solid black; border-right:1px solid black;">#LvarOBJ_PrecioU.enCF(DCpreciou)#</td>
							<td align="center" style="border-bottom: 1px solid black; border-right:1px solid black;"><cfif len(trim(rsProveedor.DSDcantidad))>#rsProveedor.DSDcantidad#<cfelse>-</cfif></td>
							<td align="center" style="border-bottom: 1px solid black; border-right:1px solid black;">
								<input type="hidden" name="SNcodigo" value="#rsContratos.SNcodigo#">								
								<input type="text" value="<cfif rsProveedor.RecordCount NEQ 0>#rsProveedor.DSDcantidad#</cfif>" name="DSDcantidad_#rsContratos.SNcodigo#" size="11" onBlur="javascript:fm(this,2);" onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}};"><!-----funcValida(#rsContratos.SNcodigo#,#CantidadDisponible#)----->
							</td>
						</tr>
					</cfloop>
					<tr><td colspan="8">&nbsp;</td></tr>
					<tr><td colspan="8">&nbsp;</td></tr>
					<tr>
						<td colspan="8" align="center">
							<input type="submit" name="btnAgregar" value="Agregar">&nbsp;&nbsp;
							<input type="button" name="btnCerrar" value="Cerrar" onClick="javascript: window.close()">
						</td>
					</tr>
				
			</form>
		<cfelse>
			<tr><td colspan="8" align="center">------- No se encontraron registros -------</td></tr>
		</cfif><!---Si el query devuelve datos----->
	</table>
	</cfoutput>
	<!----&& parseFloat(paramNDigitado) > parseFloat(document.form1['DSDcantidad_'+paramNSeleccionado].value)){----->
	<script type="text/javascript" language="javascript1.2">
		//Valida que la cantidad adjudicada no sea mayor que la disponible en el contrato
		/*function funcValida(paramNDigitado,paramNSeleccionado){
			if (parseFloat(document.form1['DSDcantidad_'+paramNDigitado].value) > 0 && parseFloat(document.form1['DSDcantidad_'+paramNDigitado].value) > paramNSeleccionado && parseFloat(document.form1['CantidadDisponible_'+paramNDigitado].value) != 0){
				alert("La cantidad adjudicada no puede ser mayor a la cantidad disponible en el contrato");
				document.form1['DSDcantidad_'+paramNDigitado].value = 0.00;
			}
		}*/
		
		function funcValidaciones(){
			var vsObjeto = document.form1;									//Variable con el objeto 
			var vnhasta = <cfoutput>#rsContratos.recordcount#</cfoutput>; 	//Variable con el numero de registros que procesar en el ciclo
			var vnSuma = 0; 
			
			if ( vnhasta > 1 ){ 				//Si es mas de una linea, el objeto se accesa como un arreglo
				for( var i=0; i<vnhasta; i++){
					var indice = vsObjeto.SNcodigo[i].value; 
					if (vsObjeto['DSDcantidad_'+indice].value != ''){
						parseFloat(qf(vsObjeto['DSDcantidad_'+indice].value))
						vnSuma = vnSuma + parseFloat(qf(vsObjeto['DSDcantidad_'+indice].value))
					}
				}
			}
			
			else{							//Si es una sola linea, el objeto se accesa comunmete
				var indice = vsObjeto.SNcodigo.value; 
				if (vsObjeto['DSDcantidad_'+indice].value != ''){
					parseFloat(qf(vsObjeto['DSDcantidad_'+indice].value))
					vnSuma = vnSuma + parseFloat(qf(vsObjeto['DSDcantidad_'+indice].value))
				}
			}
			if (parseFloat(vnSuma) == parseFloat(vsObjeto.DScant.value)){ 
				return true
			}
			else{
				alert("La sumatoria de las cantidades adjudicadas debe corresponder a la cantidad solicitada")
				return false;
			}
			return false;
		}
	</script>
</cfif>
