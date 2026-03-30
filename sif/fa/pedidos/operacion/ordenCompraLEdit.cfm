<title>Registro Manual de Ordenes de Compra</title>
<cf_web_portlet_start titulo="Modificar Línea de la Orden de Compra">	
<script  language="JavaScript" src="/cfmx/sif/js/utilesMonto.js"></script>
<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()><title>Haga click para ocultar 	Registro Manual de Ordenes de Compra</title>


<cfif isdefined("url.linea") and len(trim(#url.linea#))> 
    <cfset modo ="CAMBIO">
	<!---<cfset exclude ="">
	<cfset exclude = exclude & Iif(len(exclude),DE(','),DE('')) & "AltaDet">
	<cfset exclude = exclude & Iif(len(exclude),DE(','),DE('')) & "Baja">
	<cfset exclude = exclude & Iif(len(exclude),DE(','),DE('')) & "BajaDet">
	<cfset exclude = exclude & Iif(len(exclude),DE(','),DE('')) & "CambioDet">
	<cfset exclude = exclude & Iif(len(exclude),DE(','),DE('')) & "NuevoDet">
	<cfset exclude = exclude  &iif(len(exclude),DE(','),DE('')) & "Nuevo">
	<cfset exclude = exclude  &Iif(len(exclude),DE(','),DE('')) & "Cambio">	
	<cfset include ="Guardar">
	<cfset includevalues ="Guardar">--->

   <cfquery name="InfoDO" datasource="#session.dsn#">
		select 	a.DOlinea as Linea, 
					a.EOidorden, 
					e.Ucodigo,				
					Udescripcion,	
					a.DOconsecutivo, 
					case a.CMtipo when 'A' then 'Artículo' when 'S' then 'Servicio' when 'F' then 'Activo' when 'P' then 'Obras' end as CMTipodesc,
					a.DOdescripcion, 
					a.DOcantidad, 
					#LvarOBJ_PrecioU.enSQL_AS("a.DOpreciou")#,
					a.DOtotal,
					case CMtipo when 'A' then e.Acodigo when 'F' then '-' when 'S' then f.Ccodigo when 'P' then 'P' end as Codigo
			from DPedido a
				left outer join Articulos e
					on a.Aid = e.Aid
					and a.Ecodigo=e.Ecodigo
		
				left outer join Conceptos f
					on a.Cid = f.Cid
					and a.Ecodigo=f.Ecodigo
				
				left outer join Unidades u
					on a.Ucodigo = u.Ucodigo
					and a.Ecodigo=u.Ecodigo
		
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.linea#">
			Order by DOconsecutivo
   </cfquery>
		<cfoutput>
		   <form name="formLinea" method="post" action="ordenCompraLEdit-SQL.cfm">
			<table align="center" width="99%">
				<tr bgcolor="##999999">
					<td align="center">
					<strong>Linea</strong>
					</td>
					<td align="center">
					<strong>Descripción</strong>
					</td>
					<td align="center">
					<strong>Cantidad</strong>
					</td>
					<td align="center">
					<strong>Precio</strong>
					</td>
					<td align="center">
					<strong>Total</strong>
					</td>
				</tr>
				<tr>
					<td align="center">
					#InfoDO.Linea#
					<input type="hidden" id="DOlinea" name="linea" value="#InfoDO.Linea#"/>
					<input type="hidden" id="modo" name="modo" value="CAMBIO"/>
					<input type="hidden" id="orden" name="orden" value="#InfoDO.EOidorden#"/>
					</td>
					<td>
					#InfoDO.DOdescripcion#
					</td>
					<td align="center">
					<input type="text"  id="cantidad" name="cantidad" size="10" value="#InfoDO.DOcantidad#" onchange="javascript:return CalculoTotal();">
					</td>
					<td align="right">
					#LsNumberFormat(InfoDO.DOpreciou,'9,9.99')#
					<input type="hidden"  id="precioU" name="precioU" value="#InfoDO.DOpreciou#"/>
					</td>
					<td align="right">
					<input type="text" id="total" name="total" size="15" value="#LsNumberFormat(InfoDO.DOtotal,'9,9.99')#" disabled="disabled">
					</td>
				</tr>				
			    <tr align="center">
				<td colspan="5">
				  <input type="submit" name="guardar" value="Guardar" onclick="javascript:return validar();"/>
				</td>
				</tr>				
			</table>							
			</form>
		</cfoutput>	
</cfif>

<cfoutput>
<script language="javascript">
 function validar()
 {
	  var cant = document.getElementById('cantidad').value;	 
	  if(cant < 1)
	  {	 
	    alert("La cantidad no puede ser 0 o menor que 0");
	    document.formLinea.cantidad.value= "#NumberFormat(InfoDO.DOcantidad,",9.99")#";
	    document.formLinea.total.value= "#NumberFormat(InfoDO.DOtotal,",9.99")#";
		return false;
	  }
	  else
	  {
	   	return true;
	  }
	  
} 
function CalculoTotal()
{ 
   var tot = 0;
   var cant = document.formLinea.cantidad.value
   var preU = document.formLinea.precioU.value
   tot =  parseFloat(qf(cant))* parseFloat(qf(preU)) ;
   document.formLinea.total.value= fm(tot,2);
   return true;
}
</script>
</cfoutput>
<cf_web_portlet_end>