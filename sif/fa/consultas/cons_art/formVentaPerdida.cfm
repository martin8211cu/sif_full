<cf_template>
<cf_templatearea name="title">
	Ventas Perdidas</cf_templatearea>
<cf_templatearea name="body">
	<cfinclude template="estilo.cfm">

<!---- Ventas perdidas --->
<cfquery name="rsVPid" datasource="#session.dsn#">
   select VPid,VPnombre
   from TipoVentaPerdida
   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

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
			b.obs_venta_perdida,
			b.VPid,	
            a.numero_linea,
 	   		a.precio_unitario,
		    a.precio_linea,
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
	
<cfoutput>

<cfif rsVentaD.RecordCount IS 0>
   [ No existen articulos el carrito ]
<cfelse>

<form name="form1" id="form1" action="carrito_go.cfm" method="post" onSubmit="return valida(this)">


   <table width="100%"  border="0" cellpadding="0" cellspacing="0">
	  <tr><td>&nbsp;</td></tr>
	  <tr><td>&nbsp;</td></tr>
	  <tr><td>&nbsp;</td></tr>			  
	  <tr>		  	   
	  	<td class="tituloListas" colspan="2" align="center"><strong>&nbsp;Ventas Perdidas</strong></td>
	  </tr>				
	  <tr><td>&nbsp;</td></tr>
	  <tr><td>&nbsp;</td></tr>
     <tr>
	  	<td nowrap><strong>Motivo Pérdida de Venta:&nbsp;</strong>
			<select name="VPid" id="VPid">
				<option value="">- No especificado -</option> 
				<cfloop query="rsVPid">
              		<option value="#rsVPid.VPid#" <cfif isdefined("rsVentaD.VPid")>selected</cfif>>#HTMLEditFormat(rsVPid.VPnombre)#</option>
				</cfloop>
			</select>				
		</td> 
     </tr>
	 <tr>
	 	<td><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Observaciones:&nbsp;</strong>
          <input name="obs_venta_perdida" type="text" size="60" value="<cfif isdefined("rsVentaD.obs_venta_perdida")>#rsVentaD.obs_venta_perdida#</cfif>">
        </td>	 	 
	 </tr>
	 <tr><td>&nbsp;</td></tr>
	 <tr>
       <td>
         <table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
          
		   <tr>
             <td align="right"><strong>Cliente:&nbsp;</strong></td>
             <td width="58%">#rsVentaD.cedula_cliente# - #rsVentaD.nombre_cliente#</td>
           </tr>
           <tr>
             <td width="7%" align="right"><strong>Fecha:&nbsp;</strong></td>
             <td width="58%"><cfset fecha=LSDateFormat(rsVentaD.fecha,'dd/mm/yyyy')>#fecha#</td>
             <td width="19%"><strong>Almacén:</strong></td>
             <td width="16%">#rsVentaD.Bdescripcion#</td>
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
       <td align="right" class="tituloListas"><strong>Descuento:&nbsp;#LSCurrencyFormat(rsVentaD.monto * rsVentaD.descuento_porcentaje/100,'none')#</strong></td>
     </tr>
     <tr>
       <td align="right" class="tituloListas"><strong>Total:&nbsp;#LSCurrencyFormat(rsVentaD.total_productos,'none')#</strong></td>
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
			   <td width="50"><cf_boton index="6" texto="Aceptar" funcion="update()"></td>
			    <td width="200"><cf_boton index="5" texto="Regresar a Catálogo" link="/cfmx/sif/fa/consultas/cons_art/index.cfm"></td>
			 </tr>
	      </table>
	   </td>
     </tr>
   </table>
</form>
</cfif>
<script type="text/javascript" language="javascript1.2">
	function update(){
		document.form1.action = 'SQLVentaPerdida.cfm';
		document.form1.submit();
	}
</script>

</cfoutput>		  
</cf_templatearea>
</cf_template>
