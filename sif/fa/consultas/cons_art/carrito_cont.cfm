
<cfinclude template="carrito_recalc.cfm">

<style type="text/css">
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

	.sinBorde {
		background-color:#FFFFFF;
		border-top-style: none;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
	}
</style>

<cfif IsDefined("session.listaFactura")>
	<cfquery datasource="#session.dsn#" name="VentaE">
		select  e.fecha, v.FVnombre, e.tipo_compra, e.LPid, e.CDid, e.periodo_pago, 
				e.plazo_meses, e.tasa_interes, e.total_financiado , e.total_productos, 
				e.total_financiado, e.periodo_pago, e.plazo_meses
		from VentaE e
			left join FVendedores v
				on v.FVid = e.FVid
		where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and e.VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">
	</cfquery>

	<cfquery datasource="#session.dsn#" name="VentaD">
		select a.numero_linea, a.Aid, a.precio_contado, a.precio_contado as DLprecio, a.precio_vendedor, 
			   a.precio_supervisor, a.cantidad, c.Adescripcion, a.precio_unitario, prima_minima as prima,
			   a.descuento_porcentaje, a.prima_minima, coalesce(a.porc_impuesto,0) as porc_impuesto
		
		from VentaD a
		
		inner join VentaE b
		on a.VentaID=b.VentaID

		inner join Articulos c
		on a.Aid = c.Aid

		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">
	</cfquery>
	
	<cfquery datasource="#session.dsn#" name="VentaDPrima">
		select sum(coalesce(prima_minima_total,0)) as prima_minima_total
		from VentaD
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">
	</cfquery>
	
	<!--- Cajas asignadas al usuario --->
	<cfquery name="rsCajasUsuario" datasource="#Session.DSN#">
		select a.FCid, b.FCcodigo, b.FCdesc, b.Ocodigo
		from UsuariosCaja a, FCajas b
		where a.EUcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.FCid = b.FCid
	</cfquery>
	
	<!--- Almacenes --->
	<cfquery name="rsAlmacenes" datasource="#session.dsn#">
		select Aid, Bdescripcion
		from Almacen
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	</cfquery>

	<cfoutput>
	  <cfif VentaD.RecordCount IS 0>
		  [ No existen articulos el carrito ]
	  <cfelse>
		  <form name="form1" id="form1" action="carrito_go.cfm" method="post" onSubmit="return valida(this)">
		  <!--- funciones para omitir los valores de los items que no cambien --->

<!--- 
				var aid = '';
				var f = obj.form;
				<cfoutput>
				<cfloop query="VentaD">
					aid = #VentaD.Aid#;
					f['precio_'+aid].value = #VentaD.DLprecio#;
					fm(f['precio_'+aid],2);
				</cfloop>
				</cfoutput>
--->

		  <script type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
		  <script type="text/javascript">
			<!--
			precio_contado =
				<cfloop query="VentaD">
					<cfif CurrentRow is 1>{<cfelse>,</cfif>
					"#JSStringFormat(Aid)#": "#JSStringFormat(DLprecio)#"
				</cfloop>
			};

			precio_vendedor =
				<cfloop query="VentaD">
					<cfif CurrentRow is 1>{<cfelse>,</cfif>
					"#JSStringFormat(Aid)#": "#JSStringFormat(precio_vendedor)#"
				</cfloop>
			};

			precio_supervisor =
				<cfloop query="VentaD">
					<cfif CurrentRow is 1>{<cfelse>,</cfif>
					"#JSStringFormat(Aid)#": "#JSStringFormat(precio_supervisor)#"
				</cfloop>
			};

			function calcula_descuento(f, aid, precio, desc){
				var precio_lista = parseFloat(qf(f['precio_'+aid].value));
				var precio_autorizado = parseFloat(qf(f['prec_'+aid].value));
				var cantidad = parseFloat(qf(f['cant_'+aid].value));
				//alert("PL:  " + precio_lista + " PA: " + precio_autorizado + "  QTY: " + cantidad)
				if ( precio_lista > 0  ){
					return ( precio_lista - precio_autorizado )*cantidad;
				}
				return 0;
			}

			function recalcula_montos(f){
				var subtotal   = 0;
				var descuento  = 0;
				var descuento2 = 0;
				var total      = 0;
				var impuesto   = 0;
				
				// calcula total
				<cfloop query="VentaD">
					cantidad = qf( f['cant_'+#VentaD.Aid#].value );

					// subtotal
					precio = qf( f['prec_'+#VentaD.Aid#].value );
					subtotal += ( parseFloat(precio) * parseFloat(cantidad) );
					
					// total *** no se esta usando
					prec = qf( f['prec_'+#VentaD.Aid#].value );
					total += ( parseFloat(prec) * parseFloat(cantidad) );

					// descuento 
					descuento += calcula_descuento(f, #VentaD.Aid#, parseFloat(precio), #VentaD.descuento_porcentaje#)
					
					// impuesto
					montototal = qf( f['subt_'+#VentaD.Aid#].value );
					porcentaje = #VentaD.porc_impuesto#;
					porcentaje = porcentaje/100;
					impuesto  += (montototal*porcentaje)/(1+porcentaje);
				</cfloop>
				
				//subtotal = subtotal - descuento;
				
				f['subTotal'].value  = subtotal;
				f['descuento'].value = descuento;
				f['impuesto'].value = impuesto;
				f['total'].value     = total;
				
				fm(f['subTotal'],2);
				fm(f['descuento'],2);
				fm(f['impuesto'],2);
				fm(f['total'],2);
				
				if (f.fprecio){
					f['fprecio'].value  = subtotal;
					fm(f['fprecio'],2);
					calcular_cuotas(f);
				}
			}

			function recalcula_prima(f){
				var primaDoc   = 0;
				var cantidad   = 0;
				var primaLinea = 0;
				
				<cfloop query="VentaD">
					cantidad = qf( f['cant_'+#VentaD.Aid#].value );
					primaLinea = qf( f['prima_minima_'+#VentaD.Aid#].value );
					primaDoc += ( parseFloat(cantidad) * parseFloat(primaLinea) );
				</cfloop>
				
				f.prima_documento.value = primaDoc;
				fm(f.prima_documento.value,2);
				
				if (f.Prima){
					var prima_act = parseFloat(f.Prima.value.replace(/,/g,''));
					if (prima_act != primaDoc){
						f['Prima'].value  = primaDoc;
						fm(f['Prima'],2);
						calcular_cuotas(f);
					}
				}
			}

			function valida_precio(aid, precio){
				var f=document.form1;
				
				document.getElementById("fontPrecio_"+aid).innerHTML = '';
				//document.getElementById("warningPrecio").innerHTML = '';

				var vprecio_vendedor = parseFloat(precio_vendedor[aid]);
				var vprecio_supervisor = parseFloat(precio_supervisor[aid]);
				
				// Valida que el precio del supervisor no sea mayor al del vendedor
				if ( vprecio_supervisor > vprecio_vendedor ){
					vprecio_vendedor = vprecio_supervisor;
				}
				
				// 1. Precio entre el precio del supervisor y el precio del Vendedor
				if ( precio < vprecio_vendedor && precio >= vprecio_supervisor  ){
					document.getElementById("fontPrecio_"+aid).innerHTML = '*';
					//document.getElementById("warningPrecio").innerHTML = '* Requiere autorización del supervisor.';
					return 0;
				}
				else if ( precio < vprecio_supervisor ){
					return 1;
				}
				
				return 2;
			}

			function onchange_pago(obj){
				document.form1.submit();
			}

			function onchange_cant(target,aid) {
				var f=document.form1;
				fm(target,0);

				var cant = parseFloat(f['cant_'+aid].value.replace(/,/g,''));
				var prec = parseFloat(f['prec_'+aid].value.replace(/,/g,''));
				var prima = parseFloat(f['prima_minima_'+aid].value.replace(/,/g,''));
				
				f['subt_'+aid].value = cant * prec;
				f['prima_'+aid].value = cant * prima;
				fm(f['subt_'+aid],2);
				fm(f['prima_'+aid],2);
				
				// recalcula de prima minima por linea y montos
				recalcula_prima(f);
				recalcula_montos(f)
			}

			function onchange_desc(target,aid) {
				var f=document.form1;

				var cant = parseFloat(f['cant_'+aid].value.replace(/,/g,''));
				var desc = parseFloat(f['desc_'+aid].value.replace(/,/g,''));

				var cont = precio_contado[aid];

				if (cont != 0) {
					desc = (desc < 0 || desc > 100) ? 0 : desc;
					f['prec_'+aid].value = cont * (100-desc)/100;
					f['subt_'+aid].value = cont * (100-desc)/100 * cant;
					fm(f['prec_'+aid],2);
					fm(f['subt_'+aid],2);
				} 
				else {
					desc = 0;
				}
				target.value=desc;
				fm(target,2);
				
				// recalcula de prima minima por linea y montos
				recalcula_montos(f)
			}

			function onchange_prec(target,aid){
				var f=document.form1;
				fm(target,2);
				var cant = parseFloat(f['cant_'+aid].value.replace(/,/g,''));
				var prec = parseFloat(f['prec_'+aid].value.replace(/,/g,''));
				
				var cont = precio_contado[aid];
				
				if (cont != 0) {
					prec = (prec < 0 || prec > cont) ? cont : prec;
				}
				
				if ( valida_precio(aid, prec) != 1 ) {
					desc = (cont == 0) ? 0 : (100 - 100 * prec / cont);
					f['desc_'+aid].value = desc;
					f['subt_'+aid].value = prec * cant;
					f['prec_'+aid].value = prec;
					fm(f['desc_'+aid],2);
					fm(f['subt_'+aid],2);
					fm(f['prec_'+aid],2);
					
					// recalcula de prima minima por linea y montos
					recalcula_montos(f)
				}
				else{
					alert('No esta autorizado para dar este precio.');
					target.value = '';
					f['desc_'+aid].value = 0;
					f['subt_'+aid].value = 0;
					fm(f['desc_'+aid],2);
					fm(f['subt_'+aid],2);
				}
			}
			
			function valida_ctl(ctl,cant) {
				return;
				if (ctl.value == cant) {
					ctl.id = '';
					ctl.name = '';
				}
			}

			function valida(f){
				<cfloop query="VentaD">
				valida_ctl (f.cant_#VentaD.Aid#, '#VentaD.cantidad#');
				</cfloop>
				return true;
			}
			//-->
		  </script>

	<table width="100%"  border="0" cellpadding="0" cellspacing="0">
    	<tr>
        	<td>
				<table width="100%"  border="0" cellspacing="2" cellpadding="0">
					<tr>
						<td width="1%">&nbsp;</td>
						<td colspan="3" align="right"><strong>Vendedor</strong></td>
					</tr>
          
		  			<tr>
            			<td>&nbsp;</td>
            			<td colspan="3" align="right">#VentaE.FVnombre#</td>
            		</tr>

					<tr>
						<td><strong>Cliente&nbsp;</strong></td>
						<td><cf_sif_cliente_detallista idquery="#VentaE.CDid#"></td>
						<td align="left"><cf_boton size="150" index="5" texto="Nuevo&nbsp;Cliente&gt;&gt;" link="/cfmx/sif/cc/catalogos/clientes/DatosClientes.cfm?opcion=1"></td>
						<td align="right"><cfset fecha=LSDateFormat(VentaE.fecha,'dd/mm/yyyy')>#fecha#</td>
					</tr>
					
					<cfquery name="dataLP" datasource="#session.DSN#">
						select LPdescripcion
						from EListaPrecios
						where LPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VentaE.LPid#">
						  and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>
					<tr>
						<td nowrap><strong>Lista de Precios&nbsp;</strong></td>
            			<td colspan="3">#dataLP.LPdescripcion#</td>
					</tr>
					
					<cfquery name="dataCliente" datasource="#session.DSN#">
						select coalesce(CDlimitecredito,0) as CDlimitecredito, coalesce(CDcreditoutilizado,0) as CDcreditoutilizado
						from ClienteDetallista 
						where CDid=<cfif len(trim(VentaE.CDid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#VentaE.CDid#"><cfelse>-1</cfif>
					</cfquery>
					<tr>
						<td nowrap><strong>L&iacute;mite de Cr&eacute;dito&nbsp;</strong></td>
            			<td colspan="3">
							<input readonly tabindex="1" name="credito_limite" id="credito_limite" type="text" class="sinBorde" style="text-align:right" value="<cfif isdefined("dataCliente.CDlimitecredito") and len(trim(dataCliente.CDlimitecredito))>#LSNumberFormat(dataCliente.CDlimitecredito,',0.00')#<cfelse>0.00</cfif>" size="15" maxlength="30" >
							<!---<cfif dataCliente.recordCount gt 0>#LSNumberFormat(dataCliente.CDlimitecredito, ',9.00')#<cfelse>-</cfif>---></td>
					</tr>
					<tr>
						<td nowrap><strong>Cr&eacute;dito Utilizado&nbsp;</strong></td>
            			<td colspan="3">
							<input readonly tabindex="1" name="credito_utilizado" id="credito_utilizado" type="text" class="sinBorde" style="text-align:right" value="<cfif isdefined("dataCliente.CDcreditoutilizado") and len(trim(dataCliente.CDcreditoutilizado))>#LSNumberFormat(dataCliente.CDcreditoutilizado,',0.00')#<cfelse>0.00</cfif>" size="15" maxlength="30" >
							<!---<cfif dataCliente.recordCount gt 0>#LSNumberFormat(dataCliente.CDcreditoutilizado, ',9.00')#<cfelse>-</cfif>---></td>
					</tr>

					<tr>
						<td nowrap><strong>Forma de pago&nbsp;</strong></td>
						<td colspan="3">
							<table width="25%" cellpadding="0" cellspacing="0">
								<tr>
									<td width="1%"><input name="forma_pago" id="contado"    type="radio" value="CO" <cfif VentaE.tipo_compra eq 'CO'>checked</cfif> onClick="javascript:onchange_pago(this);"></td><td><label style="vertical-align:middle" for="contado">Contado</label></td>
									<td width="1%"><input name="forma_pago" id="financiado" type="radio" value="FI" <cfif VentaE.tipo_compra eq 'FI'>checked</cfif> onClick="javascript:onchange_pago(this);"></td><td><label for="financiado">Cr&eacute;dito</label></td>
							  </tr>
							</table>
						</td>
					</tr>	
          			
					<tr>
            			<td>&nbsp;</td>
            			<td colspan="3">&nbsp;</td>
          			</tr>
				</table>
			</td>
      </tr>

	<tr><td class="bottomline" bgcolor="##F5F5F5"><strong><font size="2">Detalle de la Venta</font></strong></td></tr>
      <tr>
        <td><table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
          <tr align="center" valign="top">
            <td nowrap class="tituloListas"><strong>Cantidad</strong></td>
            <td nowrap class="tituloListas"><strong>Art&iacute;culo</strong></td>
            <td align="right" nowrap class="tituloListas"><strong>Precio lista</strong></td>
            <td align="right" nowrap class="tituloListas"><strong>Descuento</strong></td>
            <td align="right" nowrap class="tituloListas"><strong>Precio autorizado</strong></td>
            <td align="right" nowrap class="tituloListas"><strong>Total</strong></td>
            <td align="right" nowrap class="tituloListas"><strong>Prima m&iacute;nima </strong></td>
			<td align="right" nowrap class="tituloListas"><strong></strong></td>
          </tr>

		<cfset primaDoc = 0 >
		<cfset subTotal = 0 >
		<cfset descuento = 0 >
		<cfset impuesto = 0 >
		<cfloop query="VentaD">
			<tr valign="top" class="<cfif VentaD.CurrentRow mod 2>listaNon<cfelse>listaPar</cfif>" >
				<td align="right"><input tabindex="1" name="linea_#VentaD.Aid#" id="linea_#VentaD.Aid#" type="hidden" value="#VentaD.numero_linea#">
					<input tabindex="1" name="cant_#VentaD.Aid#" id="cant_#VentaD.Aid#" type="text" class="flat" style="text-align:right" onFocus="select()" value="#LSNumberFormat(VentaD.cantidad,'0')#" size="4" maxlength="4" onchange="onchange_cant(this,'#JSStringFormat(VentaD.Aid)#')">
				</td>
			
				<td><a tabindex="0" href="prodview.cfm?prod=#VentaD.Aid#"><span class="prod_item">#VentaD.Adescripcion#</span></a> </td>
			
			
				<td align="right" class="prec_item">
					<cfset precio=LSNumberFormat(VentaD.DLprecio,",0.00")>
					<input onBlur="fm(this,2)" readonly tabindex="1" name="precio_#VentaD.Aid#" id="precio_#VentaD.Aid#" type="text" class="flat" style="text-align:right" value="#LSNumberFormat(VentaD.DLprecio,',0.00')#" size="10" maxlength="30" >
				</td>
			
				<td align="right" class="prec_item"><input tabindex="1" name="desc_#VentaD.Aid#" id="desc_#VentaD.Aid#" type="text" class="flat" style="text-align:right" onFocus="this.select()" value="#LSNumberFormat(VentaD.descuento_porcentaje,'0.00')#" size="4" maxlength="5"  onchange="onchange_desc(this,'#JSStringFormat(VentaD.Aid)#')"></td>
				<td align="right" class="prec_item"><input onFocus="this.select()" onBlur="fm(this,2)" tabindex="1" name="prec_#VentaD.Aid#" id="prec_#VentaD.Aid#" type="text" class="flat" style="text-align:right" value="#LSNumberFormat(VentaD.precio_unitario,',0.00')#" size="10" maxlength="30" onchange="onchange_prec(this,'#JSStringFormat(VentaD.Aid)#')"></td>
				<td align="right" class="prec_item"><input onFocus="this.select()" readonly="" onBlur="fm(this,2)" tabindex="1" name="subt_#VentaD.Aid#" id="subt_#VentaD.Aid#" type="text" class="flat" style="text-align:right" value="#LSNumberFormat(VentaD.precio_unitario*VentaD.cantidad,',0.00')#" size="10" maxlength="30" onchange="onchange_cant(this,'#JSStringFormat(VentaD.Aid)#')"></td>
				<td align="right" class="prec_item">
					<cfset primaLinea = VentaD.prima * VentaD.cantidad>
					<input name="prima_minima_#VentaD.Aid#" id="prima_minima_#VentaD.Aid#" type="hidden" class="flat" style="text-align:right" value="#VentaD.prima#" >
					<input onBlur="fm(this,2)" readonly tabindex="1" name="prima_#VentaD.Aid#" id="prima_#VentaD.Aid#" type="text" class="flat" style="text-align:right" value="#LSNumberFormat(primaLinea,',0.00')#" size="10" maxlength="30" >
				</td>
				<td align="center" width="2%"><font color="##FF0000" id="fontPrecio_#VentaD.Aid#">&nbsp;</font></td>
			</tr>
			
			<!--- calcula la prima del documento OJO con prima, debe ser el de la bd--->
			<cfset primaDoc = primaDoc + (VentaD.prima*VentaD.cantidad) >
			
			<!--- el subtotal del documento--->
			<cfset subTotal = subTotal + (VentaD.precio_unitario*VentaD.cantidad) >

			<!--- el impuesto del documento--->
			<cfset monto = VentaD.precio_unitario*VentaD.cantidad >
			<cfset porcentaje = VentaD.porc_impuesto/100 >
			<cfset impuesto = impuesto + ((monto*porcentaje)/(1+porcentaje)) >

			<!--- el subtotal del documento--->
			<!---PL: #VentaD.precio_contado#<br>
			PA: #VentaD.precio_unitario#<br>
			QTY: #VentaD.cantidad#<br>
			----------------------<br>--->
			<cfset descuento = descuento + ((VentaD.precio_contado - VentaD.precio_unitario)*VentaD.cantidad) >
		</cfloop>

			<tr><td>&nbsp;</td></tr>
			<tr valign="top">
              <td align="right" class="topLine" bgcolor="##F5F5F5">&nbsp;</td>
              <td align="right" class="topLine" colspan="4" bgcolor="##F5F5F5"><strong>Total</strong></td>
              <td align="right" class="topLine" bgcolor="##F5F5F5"><input readonly tabindex="1" name="subTotal" id="" type="text" class="sinBorde" style="text-align:right; border-bottom-style:none; background-color:##F5F5F5;" value="#LSNumberFormat(subTotal, ',9.00')#" size="10" maxlength="30" ></td>
			  <td align="right" class="topLine" bgcolor="##F5F5F5" colspan="2">&nbsp;</td>
            </tr>

            <tr valign="top">
              <td align="right" >&nbsp;</td>
              <td align="right" colspan="4" ><strong>Descuento aplicado</strong></td>
              <td align="right" >
				<input readonly tabindex="1" name="descuento" id="" type="text" class="sinBorde" style="text-align:right" value="#LSNumberFormat(descuento, ',9.00')#" size="10" maxlength="30" >
			  </td>
            </tr>

            <tr valign="top">
              <td align="right">&nbsp;</td>
              <td align="right" colspan="4"><strong>Impuesto aplicado<strong></td>
              <td align="right"><input readonly tabindex="1" name="impuesto" id="" type="text" class="sinBorde" style="text-align:right; border-bottom-style:none;" value="#LSNumberFormat(impuesto, ',9.00')#" size="10" maxlength="30" ></td>
            </tr>
			
            <tr valign="top">
              <td align="right">&nbsp;</td>
              <!---<td align="right" colspan="4"><strong>Total</strong> </td>--->
              <td align="right">
					<cfset total_prima = LSNumberFormat(0, ',9.00')>
					<cfset total = LSNumberFormat(Session.listaFactura.Total, ',9.00')>
					<input readonly tabindex="1" name="total" id="" type="hidden" class="sinBorde" style="text-align:right" value="#LSNumberFormat(Session.listaFactura.Total, ',9.00')#" size="10" maxlength="30" >
			  </td>
            </tr>
			
            <!---<tr valign="top">
              <td align="left" colspan="8"><font color="##FF0000" id="warningPrecio" >&nbsp;</font></td>
            </tr>
			--->
			<tr><td>&nbsp;</td></tr>
			
        </table></td>
      </tr>
      
	  <cfif VentaE.tipo_compra eq 'FI'>
	  <tr>
        <td>
	
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr><td class="bottomline" bgcolor="##F5F5F5" colspan="4"><strong><font size="2">Financiamiento</font></strong></td></tr>
          <tr>
            <td valign="top">
			</td>
            
			<td></td>
			
			<!---- XXXXXXXXXXXXXXXXXXXXXXXXX --->
			<td>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1%" nowrap>Monto</td>
						<td>
							<input type="text" class="flat" readonly name="fprecio" value="<cfif isdefined("VentaE.total_productos") and len(trim(VentaE.total_productos))>#LSNumberFormat(VentaE.total_productos, ',9.00')#<cfelse>0.00</cfif>" tabindex="1" size="10" maxlength="10" style="text-align: right; "  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
						</td>
					</tr>
					<tr>
						<td width="1%" nowrap>Plazo Meses</td>
						<td>
							<input type="text" class="flat" name="PlazoMeses" value="<cfif isdefined("VentaE.plazo_meses") and len(trim(VentaE.plazo_meses))>#VentaE.plazo_meses#<cfelse>0</cfif>" tabindex="1" size="10" maxlength="3" style="text-align: right;" onBlur="javascript:fm(this,0);  calcular_cuotas(this.form);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" >
						</td>
					</tr>
					<tr>
						<td width="1%" nowrap>Tipo de Cuota</td>
						<td>
							<select name="tipo" onChange="calcular_cuotas(document.form1);">
								<option value="s" <cfif VentaE.periodo_pago eq 's'>selected</cfif>>Semanal</option>
								<option value="q" <cfif VentaE.periodo_pago eq 'q'>selected</cfif>>Quincenal</option>
								<option value="m" <cfif VentaE.periodo_pago eq 'm'>selected</cfif>>Mensual</option>
							</select>
						</td>
					</tr>
					<tr>
						<td width="1%" nowrap>N&uacute;mero de Cuotas&nbsp;</td>
						<td><input type="text" class="flat" name="NumCuotas" readonly value="0" tabindex="1" size="10" maxlength="10" style="text-align: right;" onBlur="javascript:fm(this,0);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" ></td>																</tr>
					<tr>
						<td>Prima</td>
						<td>
							<input type="text" class="flat" name="Prima" value="<cfif isdefined("VentaDPrima.prima_minima_total")>#LSNumberFormat(VentaDPrima.prima_minima_total,',0.00')#</cfif>" tabindex="1" size="10" maxlength="10" style="text-align: right;" onBlur="javascript:fm(this,2); validar_prima(this.form); calcular_cuotas(this.form);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
						</td>
					</tr>
					<tr>
						<td width="1%" nowrap>Inter&eacute;s Anual</td>
						<td><input type="text" class="flat" readonly name="Intereses" value="#NumberFormat(VentaE.tasa_interes,'0.00')#" tabindex="1" size="10" maxlength="10" style="text-align: right;" onBlur="javascript:fm(this,2); calcular_cuotas(this.form);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >%</td>
					</tr>
					<tr>
						<td>Monto de Cuota</td>
						<td><input type="text" class="flat" name="CuotaMensual" value="0.00" tabindex="1" size="10" maxlength="20" style="text-align: right;" onBlur="javascript:fm(this,2); calcular_plazo(this.form);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" ></td>
					</tr>
					<tr>
						<td width="1%" nowrap>PagoTotal</td>
						<td><input type="text" class="flat" readonly name="PagoTotal" value="0.00" tabindex="1" size="10" maxlength="20" style="text-align: right;" onBlur="javascript:fm(this,2); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" ></td>
					</tr>
					
					<tr><td colspan="2" id="warning"></td></tr>
				</table>
			</td>
			<!--- XXXXXXXXXXXXXXXXXXXXXXXXXX--->
          </tr>


          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
        </table></td>
      </tr>
	  </cfif>
	  
	  
      <tr>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td><table width="92%" border="0" align="center" cellpadding="0" cellspacing="2">
          <tr>
            <td width="148" align="center">
			<cf_boton index="1" texto="Actualizar" funcion="document.form1.submit()">
            </td>
            <td width="148" align="center">
				<cf_boton index="2" texto="Seguir&nbsp;vendiendo" link="index.cfm">
            </td>
            <td width="148" align="center">
				<cf_boton index="3" texto="Venta&nbsp;perdida" link="formVentaPerdida.cfm">
            </td>
            <td width="148" align="center">
				<cf_boton index="4" texto="Ir&nbsp;a&nbsp;cajas&nbsp;&gt;&gt;" link="formPagar.cfm">
            </td>
          </tr>
        </table></td>
      </tr>

	  <!--- hiddens --->
	  <tr><td>
	  	  <!--- prima documento --->
		  <input type="hidden" name="prima_documento" value="#primaDoc#">
	  </td></tr>
    </table>


		  </form>
		  
	  </cfif>
	</cfoutput>

	<script language="javascript1.2" type="text/javascript">
		<cfoutput query="VentaD">
		document.getElementById("fontPrecio_#VentaD.Aid#").innerHTML = '';
		//document.getElementById("warningPrecio").innerHTML = '';
		</cfoutput>


		// *************************************************************
		// *************************************************************
	function validar_prima(f){
		var prima = parseFloat(qf(f.Prima.value));
		var prima_minima = parseFloat(qf(f.prima_documento.value));
		
		if ( prima < prima_minima ){
			alert('La prima es menor a la prima mínima permitida.');
			f.Prima.value = prima_minima;
			formatCurrency(f.Prima, 2);
		}
	}	

	function calcular_cuotas(f){
		var plazo = Math.abs(Math.round(parseFloat(f.PlazoMeses.value)));
		var tipo = f.tipo.value;
		/* preguntar a danim. Asumo que un mes tiene 4 semanas y 1 mes tiene 2 quincenas */
		if (tipo == 'q') {
			plazo *= 2;
		} else if (tipo == 's') {
			plazo *= 4;
		}

		var interes = Math.abs(Math.round(parseFloat(f.Intereses.value)*100) / 10000);
		var saldo = qf(f.fprecio.value);  // toma como saldo el precio del articulo
		var pago_inicial = Math.abs(Math.round(parseFloat(f.Prima.value.replace(/,/g, ''))*100) / 100); // toma como pago inicial la prima

		if (isNaN(pago_inicial)){
			pago_inicial = 0;
			f.Prima.value = 0;
		} else if (pago_inicial != parseFloat(f.Prima.value.replace(/,/g, ''))) {
			f.Prima.value = pago_inicial;
			formatCurrency(f.Prima,2);
		}

		if (pago_inicial > saldo) {
			pago_inicial = saldo;
			saldo = 0;
			f.Prima.value = pago_inicial;
			formatCurrency(f.Prima,2);
		} else {
			saldo -= pago_inicial;
		}

		if (isNaN(plazo)) {
			f.PlazoMeses.value = '';
		}

		if (isNaN(interes)) {
			f.Intereses.value = '';
		} else if (interes*100 != parseFloat(f.Intereses.value)) {
			f.Intereses.value = interes*100;
			formatCurrency(f.Intereses,2);
		}
		
		if (tipo == 'm') {
			// plazo ok, el plazo está en meses
			interes /= 12;
		} else if (tipo == 'q') {
			interes /= 24;
		} else if (tipo == 's') {
			interes /= 52;
		}
		
		if (isNaN(plazo) || isNaN(interes) || plazo <= 0) {
			cuota = saldo;
			plazo = 1;
			interes = 0;
		} 
		if (interes != 0) {
			cuota = saldo / ( (1 - Math.pow (1+interes, -plazo)) / interes );
		} else {
			cuota = saldo / plazo;
		}

		f.NumCuotas.value = plazo;
		f.CuotaMensual.value = cuota;
		//f.plazo2.value = plazo;
		f.PagoTotal.value = pago_inicial + cuota*plazo;
		formatCurrency(f.CuotaMensual, 2);
		formatCurrency(f.PagoTotal, 2);
	}

	function calcular_plazo(f){
		var cuota = parseFloat(qf(f.CuotaMensual.value));
		
		if ( cuota > 0 ) {
			var plazo = 0;
			var tipo = f.tipo.value;
	
			var interes = Math.abs(Math.round(parseFloat(f.Intereses.value)*100) / 10000);
			var saldo = qf(f.fprecio.value);  // toma como saldo el precio del articulo
			var pago_inicial = Math.abs(Math.round(parseFloat(f.Prima.value.replace(/,/g, ''))*100) / 100); // toma como pago inicial la prima
	
			if (isNaN(pago_inicial)){
				pago_inicial = 0;
				f.Prima.value = 0;
			} else if (pago_inicial != parseFloat(f.Prima.value.replace(/,/g, ''))) {
				f.Prima.value = pago_inicial;
				formatCurrency(f.Prima,2);
			}
	
			if (pago_inicial > saldo) {
				pago_inicial = saldo;
				saldo = 0;
				f.Prima.value = pago_inicial;
				formatCurrency(f.Prima,2);
			} else {
				saldo -= pago_inicial;
			}
	
			if (isNaN(interes)) {
				f.Intereses.value = '';
			} else if (interes*100 != parseFloat(f.Intereses.value)) {
				f.Intereses.value = interes*100;
				formatCurrency(f.Intereses,2);
			}
			
			if (tipo == 'm') {
				// plazo ok, el plazo está en meses
				interes /= 12;
			} else if (tipo == 'q') {
				interes /= 24;
			} else if (tipo == 's') {
				interes /= 52;
			}
			
			// plazo corresponde a la cantidad de cuotas
			if (interes != 0) {
				plazo = - Math.log (1 - saldo * interes / cuota) / Math.log(1+interes)
			} else {
				plazo = saldo / cuota;
			}
	
			f.PlazoMeses.value = plazo;
			
			// plazo2 corresponde a meses plazo 
			var plazo2 = 0;
			if (tipo == 'q') {
				plazo2 = plazo / 2;
			} else if (tipo == 's') {
				plazo2 = plazo / 4;
			} else if ( tipo == 'm' ){
				plazo2 = plazo;
			}
			
			f.NumCuotas.value = plazo;
			f.PlazoMeses.value = plazo2;
			formatCurrency(f.PlazoMeses, 2);
			
			
			f.PagoTotal.value = pago_inicial + cuota*plazo;
			formatCurrency(f.CuotaMensual, 2);
			formatCurrency(f.PagoTotal, 2);
			formatCurrency(f.NumCuotas, 2);
		}
	}
	
	<cfif VentaE.tipo_compra neq 'CO'>
	recalcula_prima(document.form1);
	calcular_cuotas(document.form1);
	</cfif>

	//*****************************************************
	//*****************************************************
	</script>
</cfif>