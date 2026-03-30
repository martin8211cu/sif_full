<cf_templatecss>
<cf_htmlReportsHeaders 
	irA="ConsolidaExtArticulo.cfm"
	FileName="Sugerido.xls"
	title="Reporte Sugerido de Pedidos">


<cfquery name="rsEmpresa" datasource="#session.dsn#">
   select Enombre
   from Empresa
	where CEcodigo = #session.CEcodigo#
</cfquery>

<cfquery name="rsAlmIni" datasource="#session.DSN#">
	select Bdescripcion
	from Almacen
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.almini#">
</cfquery>


<cfquery name="rsAlmFin" datasource="#session.DSN#">
	select Bdescripcion
	from Almacen
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.almfin#">
</cfquery>

<cfif isdefined("form.articuloi") and len(trim(form.articuloi))>
	<cfquery name="rsArtIni" datasource="#session.DSN#">
		select Adescripcion
		from Articulos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.iAid#">
	</cfquery>
</cfif>

<cfif isdefined("form.articulof") and len(trim(form.articulof))>
	<cfquery name="rsArtFin" datasource="#session.DSN#">
		select Adescripcion
		from Articulos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fAid#">
	</cfquery>
</cfif>


<cfquery datasource="#session.DSN#" name="rsSugerido">
	select 
		(d.Eexistmax - d.Eexistencia) + (( select  coalesce(sum (DRcantidad),0.00) from ERequisicion  reqE  inner join DRequisicion  reqD on   reqE.ERid = reqD.ERid  where  reqE.Aid = e.Aid  and   reqD.Aid = a.Aid )) as  sugerido,
	
		(( select coalesce(sum (reqD.DRcantidad),0.00) from ERequisicion  reqE  inner join DRequisicion  reqD on   reqE.ERid = reqD.ERid  where  reqE.Aid = e.Aid  and   reqD.Aid = a.Aid )) as solicitudes,
		
		(( select coalesce(sum (OD.DOcantidad),0.00) from DOrdenCM OD inner join EOrdenCM  OE on  OE.EOidorden = OD.EOidorden   where   OD.Aid  = a.Aid and  OD.Alm_Aid  = e.Aid )) as orden_compra,
		a.Aid,
		e.Aid,
		e.Almcodigo as almacen,
		d.Eexistmin as minimo, 
		d.Eexistmax as maximo, 
		coalesce(d.Eexistencia,0.00) as Existencia,
		a.Acodigo as articulo, 
		a.Adescripcion as descripcion, 
		e.Bdescripcion as Bodega
	from Almacen e
		inner join  Existencias d
			on d.Alm_Aid = e.Aid 
		inner join  Articulos a
			on a.Ecodigo = d.Ecodigo 
			and a.Aid = d.Aid 
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and e.Bdescripcion between '#rsAlmIni.Bdescripcion#' and '#rsAlmFin.Bdescripcion#'
		 <cfif isdefined("form.articulof") and len(trim(form.articulof)) and not isdefined ("form.articuloi")>
			and  a.Adescripcion <= '#rsArtFin.Adescripcion#'
		 <cfelseif isdefined("form.articuloi") and len(trim(form.articuloi)) and not isdefined ("form.articulof")>
			and a.Adescripcion >= '#rsArtIni.Adescripcion#'
		 <cfelseif isdefined("form.articuloi") and len(trim(form.articuloi)) and isdefined("form.articulof") and len(trim(form.articulof))>
			and a.Adescripcion between '#rsArtIni.Adescripcion#' and '#rsArtFin.Adescripcion#'
		 </cfif> 
		 order by Bodega,sugerido desc
</cfquery>


	<style type="text/css">
		.encabReporte {
			background-color: #006699;
			font-weight: bold;
			color: #FFFFFF;
			padding-top: 2px;
			font-size: 11px; 
			padding-bottom: 2px;
		}
</style>
<cfif isdefined("rsSugerido") and rsSugerido.recordcount gt 0>
		<table width="100%" cellpadding="0" cellspacing="1" border="0">	
			<cfoutput>
		
			<tr align="center" class="tituloListas">
				<td colspan="10" align="center"><strong>#rsEmpresa.Enombre#</strong></td>
			</tr>
			<tr align="center" class="tituloListas">
				<td colspan="10" align="center"><strong>Inventarios</strong></td>
			</tr>
		
			<tr align="center" class="tituloListas">
				<td colspan="10" align="center"><strong>Consulta de Sugerido de Pedido</strong></td>
			</tr>
			<tr>
				<td colspan="10">&nbsp;</td>
			</tr>
			</cfoutput>
            <tr nowrap="nowrap" align="center" class="encabReporte">
				<td align="left" nowrap="nowrap"><strong>Almacén</strong></td>
				<td align="left" nowrap="nowrap"><strong>Artículo</strong></td>
				<td align="left"><strong>Descripción</strong></td>
				<td align="left"><strong>Existencia Mínima</strong></td>
				<td align="left"><strong>Existencia Máxima</strong></td>
				<td align="left"><strong>Existencia</strong></td>
				<td align="left"><strong>Solicitudes a Inventario</strong></td> 
				<td align="left"><strong>Cantidad en Tránsito</strong></td>
				<td align="left"><strong>Sugerido</strong></td>
			</tr>
			
			<cfoutput query="rsSugerido">
				<tr>
					<td x:date nowrap="nowrap" style="font-size:12px" align="left">#rsSugerido.Bodega#</td>
					<td x:date nowrap="nowrap" style="font-size:12px" align="left">#rsSugerido.articulo#</td>
					<td x:numWith2Dec style="font-size:12px" align="left">#rsSugerido.descripcion#</td>
					<td x:numWith2Dec style="font-size:12px" align="right">#rsSugerido.minimo#</td>
					<td x:numWith2Dec style="font-size:12px" align="right">#rsSugerido.maximo#</td>
					<td x:str style="font-size:12px" align="right">#rsSugerido.existencia#</td>	
					<td x:str nowrap="nowrap" style="font-size:12px" align="right">#rsSugerido.solicitudes#</td>	
					<td x:str style="font-size:12px" align="right">#rsSugerido.orden_compra#</td>
					<td x:str style="font-size:12px" align="right"><cfif rsSugerido.orden_compra gt rsSugerido.sugerido>#rsSugerido.sugerido#<cfelse>#rsSugerido.orden_compra#</cfif></td>
				</tr>
			</cfoutput>
			<tr>
				<td>&nbsp;</td>
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
	
