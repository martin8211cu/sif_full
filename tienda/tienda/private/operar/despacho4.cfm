<cfinclude template="despacho_query.cfm">

<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">Registro de despacho </cf_templatearea>
<cf_templatearea name="header">
<cfinclude template="header.cfm">
</cf_templatearea>
<cf_templatearea name="body">

<link href="despacho.css" rel="stylesheet" type="text/css">

<cfinclude template="/home/menu/pNavegacion.cfm">
		<cf_web_portlet titulo="Registro de Despacho">
		
		

		<form name="form1" action="despacho4_go.cfm" method="post" style="margin:0 " onSubmit="return validar(this);">
		<cfinclude template="despacho_hdr.cfm">
			<br>
			<table width="958"  border="0" cellpadding="3" cellspacing="0" bordercolor="#CCCCCC" bgcolor="#FFFFFF">
			  <tr bgcolor="#CCCCCC">
			    <td width="77"  class="picklist_header">C&oacute;digo</td>
				<td width="215" class="picklist_header">Nombre</td>
				<td width="216"  class="picklist_header">Presentaci&oacute;n</td>
				<td width="61" align="right"  class="picklist_header">Pedido&nbsp;</td>
				<td width="61" align="right"  class="picklist_header">Saldo&nbsp;</td>
			    <td width="73" align="right"  class="picklist_header">Env&iacute;o</td>
			    <td width="131" align="right" class="picklist_header">Subtotal (<cfoutput>#data.moneda#</cfoutput>) </td>
			    <td width="76" align="right"  class="picklist_header">Pendiente</td>
		      </tr>
			<cfoutput query="data">
			
			<cfquery datasource="#session.dsn#" name="this_cant">
				select coalesce ( sum (cantidad), 0) as cantidad
				from CarritoEnvioItem
				where id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.num_pedido#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_producto#">
				  and id_presentacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_presentacion#">
				  and id_envio != <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.num_envio#">
			</cfquery>
			  <tr>
			    <td class="picklist_data">#sku#</td>
				<td class="picklist_data">#nombre_producto#&nbsp;</td>
				<td  class="picklist_data">#nombre_presentacion#&nbsp;</td>
				<td class="picklist_data" align="right">#NumberFormat(cantidad,',0')#</td>
				<td class="picklist_data" align="right">#NumberFormat(cantidad-this_cant.cantidad,',0')#</td>
			    <td class="picklist_data" align="right">#NumberFormat(cantidad_envio,',0')#</td>
			    <td align="right" nowrap class="picklist_data">#NumberFormat(subtotal_envio,',0.00')#</td>
			    <td class="picklist_data" align="right">#NumberFormat(cantidad-this_cant.cantidad-cantidad_envio,',0')#</td>
		      </tr>
		  </cfoutput>	
			  <tr>
			    <td>&nbsp;</td>
			    <td colspan="2" valign="top" class="picklist_data">&nbsp;</td>
			    <td valign="top" class="picklist_data">&nbsp;</td>
			    <td valign="top" class="picklist_data">&nbsp;</td>
			    <td valign="top" class="picklist_data">&nbsp;</td>
			    <td valign="top" class="picklist_data">&nbsp;</td>
			    <td valign="top" class="picklist_data">&nbsp;</td>
		      </tr>
			  <tr>
			    <td>&nbsp;</td>
			    <td colspan="2" valign="top" class="picklist_data"><cfset despacho_progreso_paso = 4>
			      <cfinclude template="despacho_progreso.cfm"></td>
			    <td valign="top" class="picklist_data">&nbsp;	</td>
		        <td colspan="4" valign="top" class="picklist_data"><table width="350"  border="0" cellspacing="0" cellpadding="0">
                  <tr bordercolor="#CCCCCC" bgcolor="#FFFFFF">
                    <td width="143" valign="top" class="picklist_data">&nbsp;</td>
                    <td width="137" align="right" valign="top" class="picklist_data">&nbsp;</td>
                    <td width="70" valign="top" class="picklist_data">&nbsp;</td>
                  </tr>
                  <tr bordercolor="#CCCCCC" bgcolor="#FFFFFF">
                    <td valign="top" class="picklist_data">Subtotal Productos </td>
                    <td align="right" valign="top" class="picklist_data"><cfoutput>#NumberFormat(envio.subtotal, ',0.00')#</cfoutput>&nbsp;</td>
                    <td valign="top" class="picklist_data">&nbsp;</td>
                  </tr>
                  <tr bordercolor="#CCCCCC" bgcolor="#FFFFFF">
                    <td valign="top" class="picklist_data">Gastos por env&iacute;o: </td>
                    <td align="right" valign="top" class="picklist_data"><cfoutput>#NumberFormat(envio.gastos_envio, ',0.00')#</cfoutput>&nbsp;</td>
                    <td valign="top" class="picklist_data">&nbsp;</td>
                  </tr>
                  <tr bordercolor="#CCCCCC" bgcolor="#FFFFFF">
                    <td valign="top" class="picklist_data">Total</td>
                    <td align="right" valign="top" class="picklist_data"><cfoutput>#NumberFormat(envio.total, ',0.00')#</cfoutput>&nbsp;</td>
                    <td valign="top" class="picklist_data">&nbsp;</td>
                  </tr>
                  <tr bordercolor="#CCCCCC" bgcolor="#FFFFFF">
                    <td valign="top" class="picklist_data">N&uacute;mero de autorizaci&oacute;n </td>
                    <td align="right" valign="top" class="picklist_data"><cfoutput>#HTMLEditFormat(envio.num_autorizacion)#</cfoutput>&nbsp;</td>
                    <td valign="top" class="picklist_data">&nbsp;</td>
                  </tr>
                  <tr bordercolor="#CCCCCC" bgcolor="#FFFFFF">
                    <td valign="top" class="picklist_data">Medio de env&iacute;o: </td>
                    <td colspan="2" valign="top" class="picklist_data"> <cfoutput>#envio.nombre_transportista#</cfoutput> </td>
                  </tr>
                  <tr bordercolor="#CCCCCC" bgcolor="#FFFFFF">
                    <td valign="top" class="picklist_data">N&uacute;mero de gu&iacute;a <br>
      (tracking number) </td>
                    <td colspan="2" valign="top" class="picklist_data"><input name="tracking_no" class="despacho_pend" type="text" id="tracking_no" size="30" maxlength="30"></td>
                  </tr>
                </table></td>
	          </tr>
</table>
		    
		    <br>
		    <table width="667" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td width="649" align="center"><input name="submit" type="submit" value="Registrar envío"></td>
              </tr>
            </table>
		    <br>
</form>

<script type="text/javascript">
<!--
	function validar(f) {
		f.tracking_no.value = f.tracking_no.value.replace(/^ +/,'').replace(/ +$/,'')
		if (f.tracking_no.value == "") {
			<cfoutput>
			alert("Indique el numero de guía que le suministró #JSStringFormat(envio.nombre_transportista)# al realizar el envío");
			f.tracking_no.focus();
			</cfoutput>
			return false;
		}
		return true;
	}
	document.form1.tracking_no.focus();
//-->
</script>

		</cf_web_portlet>


</cf_templatearea>
</cf_template>
