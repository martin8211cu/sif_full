<style type="text/css">
<!--
.style4 {font-size: 12px}
-->
</style>

<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="subTitulo"><font size="2">Lista de Detalles</font></td>
	</tr>
</table>
<!---Lista de Items--->
<cfquery name="rsListaItems" datasource="#session.dsn#">
	select 	a.DOlinea, 
			a.EOidorden,
			SNcodigo,
			e.Ucodigo,
			Udescripcion,	
			a.DOconsecutivo, 
			case a.CMtipo when 'A' then 'Artículo' when 'S' then 'Servicio' when 'F' then 'Activo' end as CMTipodesc,
			a.DOdescripcion, 
			a.DOcantidad, 
			a.DOpreciou, 
			a.DOtotal,
			case CMtipo when 'A' then e.Acodigo when 'F' then '-' when 'S' then f.Ccodigo end as Codigo
	from DRemisionesFA a
		inner join ERemisionesFA eo
			on eo.EOidorden=a.EOidorden
				and a.Ecodigo=eo.Ecodigo
					
		left outer join Articulos e
			on a.Aid = e.Aid
			and a.Ecodigo=e.Ecodigo

		left outer join Conceptos f
			on a.Cid = f.Cid
			and a.Ecodigo=f.Ecodigo
		
		left outer join Unidades u
			on e.Ucodigo = u.Ucodigo
			and e.Ecodigo=u.Ecodigo	

	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	Order by DOconsecutivo
</cfquery>

<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<cfset navegacion = "">
			<cfif isdefined("form.EOidorden") and len(trim(form.EOidorden)) >
				<cfset navegacion = navegacion & "&EOidorden=#form.EOidorden#">
			</cfif>

			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
				<cfinvokeargument name="query" value="#rsListaItems#">
				<cfinvokeargument name="desplegar" value="DOconsecutivo,CMTipodesc,Codigo,DOdescripcion,DOcantidad,Udescripcion,DOpreciou,DOtotal">
				<cfinvokeargument name="etiquetas" value="L&iacute;nea,Tipo,C&oacute;digo,Descripci&oacute;n,Cantidad,Unidad Medida,Precio,Total">
				<cfinvokeargument name="formatos" value="V,V,V,V,M,V,F,M">
				<cfinvokeargument name="align" value="left,left,left,left,right,center,right,right">
				<cfinvokeargument name="ajustar" value="N">
				<cfinvokeargument name="irA" value="ordenCompra_cambioFP.cfm">

				<!---<cfinvokeargument name="funcion" value="ProcesarLinea">
				
				<cfinvokeargument name="incluyeForm" value="false">
				 <cfinvokeargument name="formName" value="form1"> 		
				 <cfinvokeargument name="fparams" value="Linea">--->
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke>
		</td>
	</tr>
</table>
<hr width="99%" align="center">

<!---Línea de Totales--->
<table width="99%"  border="0" cellspacing="0" cellpadding="0">
<cfoutput>
  <tr>
    <td>

	  <table align="right" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="right"><strong>SubTotal:&nbsp;</strong></td>
				<td align="right">
					<input class="cajasinbordeb" type="text" style="text-align:right" readonly id="_subtotal" name="subtotal" value="<cfif modo EQ "CAMBIO" >#LSCurrencyFormat(rsTotales.subtotal,'none')#<cfelse>0.00</cfif>">
				</td>
			</tr>
		
			<tr>
				<td align="right"><strong>Descuento:&nbsp;</strong></td>
				<td align="right">
					<input class="cajasinbordeb" type="text" style="text-align:right" readonly id="_descuento" name="_descuento" value="<cfif modo EQ "CAMBIO">#LSCurrencyFormat(rsTotales.descuento,'none')#<cfelse>0.00</cfif>">
				</td>
			</tr>
			
			<tr>
				<td align="right"><strong>Impuesto:&nbsp;</strong></td>
				<td align="right">
					<input class="cajasinbordeb" type="text" style="text-align:right" readonly id="_impuesto" name="_impuesto" value="<cfif modo EQ "CAMBIO">#LSCurrencyFormat(rsTotales.impuesto,'none')#<cfelse>0.00</cfif>">
				</td>
			</tr>

			<tr>
				<td><strong>Total Estimado:&nbsp;</strong></td>
				<td align="right">
					<input class="cajasinbordeb" type="text" style="text-align:right; " readonly id="_total" name="_total" value="<cfif modo EQ "CAMBIO">#LSCurrencyFormat(rsTotales.subtotal+rsTotales.impuesto-rsTotales.descuento,'none')#<cfelse>0.00</cfif>">
				</td>
			</tr>
	  </table>	
			
	  </td>
  </tr>

</cfoutput>
</table>