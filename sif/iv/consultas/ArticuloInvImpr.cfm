<cfif isdefined("url.almini") and len(trim(url.almini)) and not isdefined("form.almini")>
	<cfset form.almini = url.almini>
</cfif>
<cfif isdefined("url.almfin") and len(trim(url.almfin)) and not isdefined("form.almfin")>
	<cfset form.almfin = url.almfin>
</cfif>

<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsAlmIni" datasource="#session.DSN#">
	select Bdescripcion
	from Almacen
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AlmIni#">
</cfquery>


<cfquery name="rsAlmFin" datasource="#session.DSN#">
	select Bdescripcion
	from Almacen
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AlmFin#">
</cfquery>

<cfquery name="rsArticulo" datasource="#Session.DSN#">
	select 	
	      a.Aestado,
			(case when Aestado = 1 then 'Activo' when Aestado = 0 then 'Inactivo' else ' ' end) as Estado,
			a.Acodigo as CodArticulo, 
			b.Udescripcion as Unidad, 
			c.Cdescripcion as Clasificacion, 
			a.Adescripcion as Articulo, 
			e.Bdescripcion as Bodega, 
			f.Odescripcion as Oficina, 
			d.Eestante as Estante, 
			d.Ecasilla as Casilla, 
			coalesce(d.Eexistencia,0.00) as Existencia, 
			coalesce(d.Ecostou,0.00) as Costou, 
			coalesce(d.Ecostototal,0.00) as CostoTotal 
	from Almacen e,
		 Articulos a, 
		 Unidades b, 
		 Clasificaciones c, 
		 Existencias d, 
		 Oficinas f 
	where 	a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.Ecodigo = b.Ecodigo 
			and a.Ucodigo = b.Ucodigo 
			
			and a.Ecodigo = c.Ecodigo 
			and a.Ccodigo = c.Ccodigo 
			
			and a.Ecodigo = d.Ecodigo 
			and a.Aid = d.Aid 
			
			and d.Alm_Aid = e.Aid 
			and e.Bdescripcion between '#rsAlmIni.Bdescripcion#' and '#rsAlmFin.Bdescripcion#'

			and e.Ecodigo = f.Ecodigo 
			and e.Ocodigo = f.Ocodigo 
			<cfif not isdefined("form.SinExistencia")>
				and d.Eexistencia > 0.00
			</cfif>
		 	<cfif isdefined("form.estado") and len(trim(form.estado))>
          and a.Aestado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.estado#">
			</cfif>
			
	order by Bdescripcion, Odescripcion, Cdescripcion, Adescripcion
</cfquery>

<cfif isdefined("form.toExcel")>
	<cf_exportQueryToFile query="#rsArticulo#" filename="ArticulosInventario_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls" jdbc="false">
</cfif>

<cfset params = "?AlmIni=#form.AlmIni#">
<cfif isdefined("url.LvarReciboB") and len(trim(url.LvarReciboB))>
	<cfset params = params & '&LvarReciboB=#url.LvarReciboB#'>
</cfif>

<cf_rhimprime datos="/sif/iv/consultas/ArticuloInvImpr.cfm" paramsuri="#params#" regresar="/cfmx/sif/iv/consultas/ArticuloInv.cfm">
<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe>

	<style type="text/css">
		.encabReporte {
			background-color: #006699;
			font-weight: bold;
			color: #FFFFFF;
			padding-top: 2px;
			font-size: 11px; 
			padding-bottom: 2px;
		}
		.topline {
			border-top-width: 1px;
			border-top-style: solid;
			border-right-style: none;
			border-bottom-style: none;
			border-left-style: none;
			border-top-color: #CCCCCC;
		}
		.bottomline {
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-right-style: none;
			border-top-style: none;
			border-left-style: none;
			border-bottom-color: #CCCCCC;
		}
		.subTituloRep {
			font-weight: bold; 
			font-size: x-small; 
			background-color: #F5F5F5;
		}
		.style4 { 
				 font-size: 11px; 
				 font-style: normal; 
				 text-shadow: Black;}
		.style4 { 
				 font-size: 12px; 
				 font-style: normal; 
				 text-shadow: Black;}
	</style>
	
<cfif isdefined("rsArticulo") and rsArticulo.recordcount gt 0>
  <table width="100%" border="0" cellspacing="0" cellpadding="1" style="padding-left: 5px; padding-right: 10px" align="center">
    <tr> 
      <td colspan="11" align="center"><cfoutput><b>#rsEmpresa.Edescripcion#</b></cfoutput></td>
    </tr>
    <tr> 
      <td colspan="11" align="center"><b>Consulta Artículos de Inventario</b></td>
    </tr>
    <tr> 
		<cfoutput> 
			<td colspan="11" align="center"><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td>
		</cfoutput> 
	</tr>
	<tr> 
	  <td colspan="16" class="bottomline">&nbsp;</td>
	</tr>
    <tr> 
		<td colspan="4" class="tituloListas" align="left"><div align="center"><font size="3">&nbsp;</font></div></td>
	</tr>
	
		<cfset TotalClaCostoTot = 0>
		<cfset TotalOfiCostoTot = 0>
		<cfset TotalBodCostoTot = 0>
			
			<cfoutput query="rsArticulo" group="Bodega">
				 <cfset TotalBodCostoTot = 0>
				<tr> 
					<td nowrap><strong>Bodega:</strong></td>
					<td class="style4" colspan="3" nowrap="nowrap">#rsArticulo.Bodega#</td>
				</tr>
				<cfoutput group="Oficina">
					<cfset TotalOfiCostoTot = 0>
					<tr> 
						<td nowrap><strong>Oficina:</strong></td>
						<td class="style4" colspan="3" nowrap="nowrap">#rsArticulo.Oficina#</td>
					</tr>
					
					<cfoutput group="Clasificacion">
						<cfset TotalClaCostoTot = 0>
							
						<tr> 
							<td nowrap><strong>Clasificaci&oacute;n:</strong></td>
							<td class="style4" colspan="3" nowrap="nowrap">#rsArticulo.Clasificacion#</td>
						</tr>
						<tr>
							<td colspan="4" nowrap>&nbsp;</td>
						</tr>
						
						<tr class="encabReporte"> 
							<td width="15%" nowrap>C&oacute;digo de Art&iacute;culo</td>
							<td width="15%" nowrap>Descripci&oacute;n del Art&iacute;culo</td>
							<td width="15%" nowrap="nowrap">Unidad de Medida</td>
							<td width="15%" nowrap="nowrap">Estado</td>
							
							<td width="7%"><strong>Estante</strong></td>
							<td width="6%"><strong>Casilla</strong></td>
							<td width="7%"><div align="right"><strong>Existencias</strong></div></td>
							<td width="15%" nowrap="nowrap"><div align="right"><strong>Costo Unitario</strong></div></td>
							<td width="15%" nowrap="nowrap"><div align="right"><strong>Costo Total</strong></div></td>
						</tr>
						<cfoutput>
							<tr <cfif rsArticulo.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>> 
								<td align="left" class="style4">#rsArticulo.CodArticulo#</td>
								<td align="left" class="style4">#rsArticulo.Articulo#</td>
								<td align="left" class="style4">#rsArticulo.Unidad#</td> 
								<td align="left" class="style4">#rsArticulo.Estado#</td> 
								
								
								<td class="style4">#rsArticulo.Estante#</td>
								<td class="style4">#rsArticulo.Casilla#</td>
								<td nowrap align="right" class="style4">#LSNumberFormat(rsArticulo.Existencia,',9.00')#</td>
								<td align="right" class="style4">#LSNumberFormat(rsArticulo.Costou,',9.00')#</td>
								<td align="right" class="style4">#LSNumberFormat(rsArticulo.CostoTotal,',9.00')#</td>
							</tr>
							<cfset TotalClaCostoTot = TotalClaCostoTot + rsArticulo.CostoTotal>
						</cfoutput>
						<tr>
							<td nowrap>&nbsp;</td>
							<td class="style4" colspan="6" align="right" nowrap="nowrap">Totales por Clasificaci&oacute;n #rsArticulo.Clasificacion#:</td>
							<td align="right" class="style4">#LSNumberFormat(TotalClaCostoTot,',9.00')#</td>
						</tr>
						<cfset TotalOfiCostoTot = TotalOfiCostoTot + TotalClaCostoTot>
					</cfoutput>			
				
					
				
				<tr>
					<td nowrap>&nbsp;</td>
					<td class="style4" colspan="6" align="right" nowrap="nowrap">Totales por Oficina #rsArticulo.Oficina#:</td>
					<td align="right" class="style4">#LSNumberFormat(TotalOfiCostoTot,',9.00')#</td>
				</tr>
				<cfset TotalBodCostoTot = TotalBodCostoTot + TotalOfiCostoTot>
				</cfoutput>
			
			<tr>
				<td nowrap>&nbsp;</td>
				<td class="style4" colspan="6" nowrap="nowrap" align="right">Totales por Bodega #rsArticulo.Bodega#:</td>
				<td align="right" class="style4">#LSNumberFormat(TotalBodCostoTot,',9.00')#</td>
			</tr>
			<tr> 
			    <td colspan="16"><hr></td>
			</tr>
			</cfoutput>
		  </table>
		</td>
	  </tr>
	  <tr> 
		<td colspan="8">&nbsp;</td>
	  </tr>
    <tr> 
      <td colspan="11">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="11" class="topline">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="11">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="11"><div align="center">--- Fin de la consulta ---</div></td>
    </tr>
  </table>
<cfelse>
 	<table border="0" cellpadding="0" cellspacing="0" style="width:100%">
		<tr>
			<td align="center">--- No se encontraron registros ---</td>
		</tr>
	</table>
</cfif>