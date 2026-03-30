<cf_template>
<cf_templatearea name="title">
	Confirmar Crédito</cf_templatearea>
<cf_templatearea name="body">
	<cfinclude template="estilo.cfm">
<!---
<cfdump var="#url#">
<cfdump var="#session.listaFactura.VentaID#">

<cfabort>
--->

 <cfquery name="rsVentaD" datasource="#session.dsn#" >
	select  (select coalesce(sum(precio_linea),0 ) 
				from VentaD 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">) as monto,	   
	   		b.VentaID,			
            b.fecha,
	    	b.CDid,
			b.total_productos,	
            a.numero_linea,
 	   		a.precio_unitario,
		    a.precio_linea,
		    a.cantidad,
			a.descuento_porcentaje,	
		    b.nombre_cliente,
			b.cedula_cliente,	
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

<cfoutput>

<cfif rsVentaD.RecordCount IS 0>
   [ No existen articulos el carrito ]
<cfelse>
<form name="form1" id="form1" action="carrito_go.cfm" method="post" onSubmit="return valida(this)">
   <table width="100%"  border="0" cellpadding="0" cellspacing="0">     
    <!--- La variable CreditoDetallista indica si la prefactura va a CAJA o a CREDITO --->
	
	 <tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<cfif isdefined("url.ClienteDetallista") and len(trim(url.ClienteDetallista))>	   
	  <cfif ClienteDetallista EQ 0>	
	       
		 <tr>
		     <td align="center" class="errormsg" colspan="2">No se ha asignado un Cliente Detallista a la Factura</td>
	     </tr>
		 <tr><td>&nbsp;</td></tr>
	  </cfif>
	  <cfif ClienteDetallista EQ 1> <!--- Si variable ClienteDetallista es 1 entonce se actualiza el estado por 40 (CAJA) ---> 
		 <tr>
		     <td align="center"  colspan="2">La Factura ha sido Pasada a Caja</td>
	     </tr>
		 <tr><td>&nbsp;</td></tr>
		 <cfquery name="updateEstado" datasource="#session.dsn#">
			 update VentaE 
			 set estado = 40 
			 where VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">
		   </cfquery>
		<cfelseif ClienteDetallista EQ 2> <!--- Si variable ClienteDetallista es 0 entonces se actualiza el estado por 30 (CREDITO) ---> 
		   <tr>
		     <td align="center" colspan="2">La Factura ha sido Pasada a Crédito</td>
	       </tr>
		   <tr><td>&nbsp;</td></tr>
		     <cfquery name="rsUpdate" datasource="#session.dsn#" >
			  update VentaE 
			  set estado = 30 
			  where VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">
		   </cfquery>
		</cfif> <!-- Fin del si ClienteDetallista es 1---> 
	</cfif> <!--- Fin del If si viene definida la variable ClienteDetallista ---> 
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
       </table></td>
     </tr>
     <tr>
       <td>
         <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
           <tr valign="top">
             <td width="40%" nowrap class="tituloListas"><strong>Art&iacute;culo</strong></td>
             <td width="15%" align="right" nowrap class="tituloListas"><strong>Precio Unitario</strong></td>
             <td width="15%" align="right" nowrap class="tituloListas"><strong>Cantidad</strong></td>
             <td width="30%" align="right" nowrap class="tituloListas"><strong>Total L&iacute;nea</strong></td>
           </tr>
            <cfloop query="rsVentaD">
             <tr>
               <td width="40%">#rsVentaD.Adescripcion#</td>
               <td align="right" width="15%">#LSCurrencyFormat(rsVentaD.precio_unitario,'none')#</td>
               <td align="right" width="15%">#rsVentaD.cantidad#</td>
               <td align="right" width="30%">#LSCurrencyFormat(rsVentaD.precio_linea,'none')#</td>
             </tr>
           </cfloop>
       </table></td>
     </tr>
     <tr>
       <td>&nbsp;</td>
     <tr>
       <td align="right" class="listaCorte"><strong>Descuento:&nbsp;#LSCurrencyFormat(rsVentaD.monto * rsVentaD.descuento_porcentaje/100,'none')#</strong></td>
     </tr>
     <tr>
       <td align="right" class="listaCorte"><strong>Total:&nbsp;#LSCurrencyFormat(rsVentaD.total_productos,'none')#</strong></td>
     </tr>
     <tr>
       <td>&nbsp;</td>
     <tr>
       <td>&nbsp;</td>
     <tr>
       <td>&nbsp;</td>
     <tr>
       <td>&nbsp;</td>
     </tr>
	 <tr>
	    <td>
		   <table align="center">
		       <tr>
                  <td width="200"><cf_boton index="5" texto="Regresar a Catálogo" link="/cfmx/sif/fa/consultas/cons_art/index.cfm"></td>
	              <td width="10"><cf_boton index="6" texto="Salir" link="/cfmx/sif/fa/MenuFA.cfm"></td>
			   </tr>
		   </table>      
	   </td>
     </tr>
  </table>
</form>
 </cfif>	  	
</cfoutput>	
</cf_templatearea>
</cf_template>

<cfset StructDelete(session,'listaFactura')>


