<cf_template>
<cf_templatearea name="title">
	Confirmar Crédito</cf_templatearea>
<cf_templatearea name="body">
<cfinclude template="estilo.cfm">

<cfquery name="rsVentaD" datasource="#session.dsn#" >
	select  (select coalesce(sum(precio_linea),0 ) 
				from VentaD 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
				and VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">) as monto,	   
	   		b.VentaID,			
            b.fecha,
	    	b.CDid,
			b.total_productos,
			b.nombre_cliente,
			b.cedula_cliente,
			b.tipo_compra,	
            a.numero_linea,
 	   		a.precio_unitario,
		    a.precio_linea,
			a.precio_vendedor,
		    a.cantidad,
			a.descuento_porcentaje,			   
			d.Adescripcion,
			f.Bdescripcion
              
     from VentaE b	 
          left outer join VentaD a         
  		     
			 left outer join Articulos d
			    on a.Aid = d.Aid
                and a.Ecodigo = d.Ecodigo
             
			 left outer join Almacen f
			 	on a.Alm_Aid = f.Aid
                and a.Ecodigo = f.Ecodigo
				     
             on a.VentaID =  b.VentaID
             and a.Ecodigo = b.Ecodigo          	      	  
   
	where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	       and b.VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">	
</cfquery>

<cfif rsVentaD.CDid NEQ ''>
	<cfquery name="rsCreditoCaja" datasource="#session.dsn#">
		select coalesce(CDlimitecredito,0) as CDlimitecredito, 
		       coalesce(CDcreditoutilizado,0) as CDcreditoutilizado,
			   (coalesce(CDlimitecredito,0) - coalesce(CDcreditoutilizado,0)) as diferencia
		from ClienteDetallista
		where CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVentaD.CDid#">
	</cfquery>
	<cfset HayClienteDetallista = 1>
<cfelse>
    <cfset HayClienteDetallista = 0>
</cfif>
	
<cfoutput>

<cfif rsVentaD.RecordCount IS 0>
   [ No existen articulos el carrito ]
<cfelse>

<form name="form1" id="form1" action="SQLPagar.cfm" method="get" onSubmit="return valida(this)" autocomplete="off">
	<table width="100%"  border="0" cellpadding="0" cellspacing="0">
    	<tr><td>&nbsp;</td></tr>
	   	<tr><td>&nbsp;</td></tr>
	   	<tr><td>&nbsp;</td></tr>
	 	<cfset ClienteDetallista = 0> 	
	<cfif rsVentaD.tipo_compra EQ 'CO'> <!---- Si la compra es de contado ----->
		<tr>
        	<td align="center" class="tituloListas" colspan="2"><strong><font color="##FF0000">Factura de Contado. </font> <br> Por Favor Pagar en la Caja.<br> Muchas Gracias!</strong></td>
       	</tr>
	<cfelse> <!--- Si la compra NO es de contado --->	 
		<cfif isdefined("HayClienteDetallista") and HayClienteDetallista EQ 1>  <!---- Si se definio un cliente detallista para la factura ----->    
			<cfif rsVentaD.total_productos LE rsCreditoCaja.diferencia> <!--- Si el monto de la factura es menor o igual que lo que queda del credito ---->
				<cfset ClienteDetallista = 1> <!--- La variable ClienteDetallista es 1 cuando se va para caja --->
				<tr>
					<td align="center" class="tituloListas" colspan="2"><strong>Por Favor Pagar en la <font color="##FF0000">Caja.</font> <br> Muchas Gracias!</strong></td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
			<cfelseif rsVentaD.total_productos GT rsCreditoCaja.diferencia> <!--- Si el monto de la factura es mayor a lo que queda del credito ---->
			<br>
				<cfset ClienteDetallista = 2> <!--- La variable ClienteDetallista es 2 cuando se va para credito --->
				<tr>
					<td class="tituloListas" colspan="2"><strong>&nbsp;Límite de Crédito:&nbsp;#LSCurrencyFormat(rsCreditoCaja.CDlimitecredito,'none')#</strong></td>
				</tr>
				<tr>
					<td class="tituloListas" colspan="2"><strong>&nbsp;Crédito Utilizado:&nbsp;#LSCurrencyFormat(rsCreditoCaja.CDcreditoutilizado,'none')#</strong></td>
				</tr>
				<tr>
					<td class="tituloListas" colspan="2"><strong>&nbsp;Crédito Disponible:&nbsp;<font color="##FF0000">#LSCurrencyFormat(rsCreditoCaja.diferencia,'none')#</font></strong></td>
				</tr>
				<tr>
					<td class="tituloListas" colspan="2"><strong>&nbsp;<font color="##FF0000">La Factura será pasada a Crédito&nbsp;</font></strong></td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
			</cfif> <!---- Fin del if del monto de la factura ---->
		<cfelse> <!--- Si no se definio un cliente detallista para la factura --->
			<tr>		  	   
				<td class="errormsg" colspan="2"><strong>&nbsp;No se ha Asignado un Cliente Detallista a la Factura</strong></td>
			</tr>				
	   		<tr><td>&nbsp;</td></tr>
		</cfif><!--- Fin de si se definio cliente detallista ---->
   </cfif> <!---- Fin de si la compra es de contado ---->
	<tr>
		<td>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td align="right"><strong>Cliente:&nbsp;</strong></td>
					<td width="43%">#rsVentaD.cedula_cliente# - #rsVentaD.nombre_cliente#</td>
				</tr>
				<tr>
					<td width="10%" align="right"><strong>Fecha:&nbsp;</strong></td>
            		<td width="60%"><cfset fecha=LSDateFormat(rsVentaD.fecha,'dd/mm/yyyy')>#fecha#</td>
         			<td width="20%"><strong>Almacén:</strong></td>
             		<td width="10%">#rsVentaD.Bdescripcion#</td>
           		</tr>
           		<tr>
             		<td colspan="5" style="border-top:1px solid black;">&nbsp;</td>
           		</tr>
       		</table>
		</td>
     </tr>
     <tr>
       	<td>
         	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
           		<tr valign="top">
             		<td width="40%" nowrap class="tituloListas"><strong>Art&iacute;culo</strong></td>
             		<td width="15%" align="right" nowrap class="tituloListas"><strong>Precio Unitario</strong></td>
					 <td width="15%" align="right" nowrap class="tituloListas"><strong>Cantidad</strong></td>
					 <td width="30%" align="right" nowrap class="tituloListas"><strong>Total L&iacute;nea</strong></td>
					 <td align="right" nowrap class="tituloListas">&nbsp;</td>
           		</tr>
		   		<cfset req_auth = false>
           		<cfloop query="rsVentaD">
             	<tr>
               	   	<td width="40%">#rsVentaD.Adescripcion#</td>
				   	<td align="right" width="15%">#LSCurrencyFormat(rsVentaD.precio_unitario,'none')#</td>
				   	<td align="right" width="15%">#rsVentaD.cantidad#</td>
				   	<td align="right" width="30%">#LSCurrencyFormat(rsVentaD.precio_linea,'none')#</td>
				   	<td align="right"><cfif rsVentaD.precio_unitario lt rsVentaD.precio_vendedor>
					<cfset req_auth = true>
			   		<span style="color:red;font-weight:bold">*</span></cfif></td>
             	</tr>
           		</cfloop>
       		</table>
		</td>
     </tr>
     <tr>
       <td>&nbsp;</td>
     <tr>
       <td align="right" class="tituloListas"><strong>Descuento:&nbsp;#LSCurrencyFormat(rsVentaD.monto * rsVentaD.descuento_porcentaje/100,'none')#</strong></td>
     </tr>
     <tr>
       <td align="right" class="tituloListas"><strong>Total:&nbsp;#LSCurrencyFormat(rsVentaD.total_productos,'none')#</strong></td>
     </tr>
     <tr>
       <td>&nbsp;</td>
     <tr>
       <td><cfif req_auth>
	   Los productos marcados con un (<span style="color:red;font-weight:bold">*</span>) requieren <br>de la autorizaci&oacute;n
	   de un supervisor para proceder con esta factura.<br>
	   Autorizaci&oacute;n del supervisor: <input type="password" size="10" name="supervisor"> </cfif></td>
     <tr>
       <td>&nbsp;</td>
     <tr>
       <td>&nbsp;</td>
     </tr>
     <tr>
	   <td> 
	      <table align="center">
		     <tr>
			   <td width="50"><cf_boton index="5" texto="Regresar" link="/cfmx/sif/fa/consultas/cons_art/carrito.cfm"></td>
			   <td width="50"><cf_boton index="6" texto="Confirmar" funcion="document.form1.submit()">
			   <input type="hidden" name="ClienteDetallista" value="#ClienteDetallista#">
			   </td>
			 </tr>
	      </table>
	   </td>
     </tr>
   </table>
</form>

<script type="text/javascript">
<!--
function valida(f){
	if (f.supervisor.value != '1234') {
		alert("La clave de supervisor no es válida");
		return false;
	}
	return true;
}
//-->
</script>
</cfif>
</cfoutput>		  
</cf_templatearea>
</cf_template>
