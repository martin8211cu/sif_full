 <cf_templateheader title="Bitacora de Procesos"> 
	
	<cfif  isdefined("form.Tabla") and form.Tabla EQ "ESIFLD_Facturas_Venta">
		<cfquery name = "RsRegErrorCab" datasource="sifinterfaces">
			select
				Ecodigo,Origen,ID_DocumentoV,Tipo_Documento,Tipo_Venta,Fecha_Venta,
				Numero_Documento,Cliente,IETU_Clas,Subtotal,Descuento,
				Impuesto,Total,Vendedor,Sucursal,Dias_Credito,Moneda,Tipo_Cambio,
				Direccion_Facturacion,Retencion,Observaciones,Tipo_CEDI,Estatus
			from ESIFLD_Facturas_Venta
			where ID_DocumentoV = #form.ID_Documento#
		</cfquery>
		<cfquery name = "RsRegErrorDet" datasource="sifinterfaces">
			select
				Ecodigo,ID_DocumentoV,ID_linea,Tipo_Lin,Tipo_Item,Clas_Item,Cod_Item,Cod_Fabricante,
				Cod_Impuesto,Cantidad,Precio_Unitario,Descuento_Lin,
				Descuento_Fact,Subtotal_Lin,Impuesto_Lin,Total_Lin,Costo_Venta
			from DSIFLD_Facturas_Venta
			where ID_DocumentoV = #form.ID_Documento#
		</cfquery>
		<cfquery name = "RsRegErrorPag" datasource="sifinterfaces">
			select
				Ecodigo,ID_DocumentoV,ID_linea_Pago,Tipo_Pago,ID_Forma_Pago, Importe,Moneda,
				Tipo_Cambio, Comision_Porcentaje, Especial, SocioDocumento
			from SIFLD_Facturas_Tipo_Pago
			where ID_DocumentoV = #form.ID_Documento#
		</cfquery>
	</cfif>
	 
	<cfif  isdefined("form.Tabla") and form.Tabla EQ "ESIFLD_Facturas_Compra">
		<cfquery name = "RsRegErrorCab" datasource="sifinterfaces">
			select
				Ecodigo,Origen,ID_DocumentoC,Tipo_Documento,Tipo_Compra,Fecha_Compra,
				Fecha_Arribo,Numero_Documento,Proveedor,IETU_Clas,Subtotal,
				Descuento,Impuesto,Total,Vendedor,Sucursal,Moneda,Tipo_Cambio,Retencion,
				Observaciones,Almacen,Estatus
			from ESIFLD_Facturas_Compra
			where ID_DocumentoC = #form.ID_Documento#   
		</cfquery>
		<cfquery name = "RsRegErrorDet" datasource="sifinterfaces">
			select
				Ecodigo,ID_documentoC,ID_linea,Tipo_Lin,Tipo_Item,Clas_Item,Cod_Item,Cod_Fabricante,
			  	Cod_Impuesto,Cantidad,Precio_Unitario,Descuento_Lin,
			  	Descuento_Fact,Subtotal_Lin,Impuesto_Lin,Total_Lin
			from DSIFLD_Facturas_Compra
			where ID_DocumentoC = #form.ID_Documento#
		</cfquery>
	</cfif>
	
	<cfif  isdefined("form.Tabla") and form.Tabla EQ "ESIFLD_Movimientos_Inventario">
		<cfquery name = "RsRegErrorCab" datasource="sifinterfaces">
			SELECT
				Ecodigo,Origen,ID_Movimiento,Tipo_Movimiento,Fecha_Movimiento,Documento,
				Descripcion,Almacen_Origen,Almacen_Destino,Sucursal,tipo_ajuste,StatusError
			FROM ESIFLD_Movimientos_Inventario
			where ID_Movimiento = #form.ID_Documento#
		</cfquery>
		<cfquery name = "RsRegErrorDet" datasource="sifinterfaces">
			SELECT 
				Ecodigo,ID_Movimiento,ID_linea,Clas_Item,Cod_Item,Cantidad,Costo,Tipo_Item,Cod_Fabricante
			FROM DSIFLD_Movimientos_Inventario
			where ID_Movimiento = #form.ID_Documento#
		</cfquery>
	</cfif>
	
	<cfif  isdefined("form.Tabla") and form.Tabla EQ "ESIFLD_Retiros_Caja">
		<cfquery name = "RsRegErrorCab" datasource="sifinterfaces">
			SELECT 
				Ecodigo,Origen,ID_Retiro,Tipo_Retiro,Concepto_Retiro,Fecha_Retiro,Sucursal,StatusError
			FROM ESIFLD_RETIROS_CAJA
			where ID_Retiro = #form.ID_Documento#
		</cfquery>
		<cfquery name = "RsRegErrorDet" datasource="sifinterfaces">
			SELECT 
				Ecodigo,Origen,ID_Retiro,Id_Linea_Retiro,Forma_Retiro,Codigo_Forma_Retiro,Monto_Retiro
			FROM DSIFLD_RETIROS_CAJA
			where ID_Retiro = #form.ID_Documento#
		</cfquery>
	</cfif>
	
	<cfif  isdefined("form.Tabla") and form.Tabla EQ "SIFLD_Movimientos_Bancarios">
		<cfquery name = "RsRegErrorCab" datasource="sifinterfaces">
			SELECT
				Ecodigo,Origen,ID_MovimientoB,Tipo_Movimiento,Fecha_Movimiento,
				Documento,Referencia,Banco_Origen,Cuenta_Origen,Banco_Destino,
				Cuenta_Destino,Importe_Movimiento,Sucursal,StatusError
			FROM SIFLD_Movimientos_Bancarios
			where ID_MovimientoB = #form.ID_Documento#
		</cfquery>
	</cfif>
  	<form method="post" name="frmDetalle" style="margin:0 0 0 0">
		
		<hr>
			<table width=500 align=center><tr><td>
			<cf_web_portlet_start titulo="Informacion del Documento">
				<cfif isdefined("RsRegErrorCab") and RsRegErrorCab.recordCount EQ 1>
					<cfset LvarCampos = RsRegErrorCab.getColumnnames()>
					<table width="200" >
						<cfloop query="RsRegErrorCab">
							<cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
								<tr>
									<td width="100" align="right">
										<strong><cfoutput>#LvarCampos[i]#:</cfoutput></strong>
									</td>
									<td>
										<cfoutput>#evaluate("RsRegErrorCab.#LvarCampos[i]#")#</cfoutput>
									</td>
								</tr>
							</cfloop>
						</cfloop>
					</table>
				</cfif> 
			<cf_web_portlet_end>
		 	</td></tr></table>
		<hr>
			<cf_web_portlet_start titulo="Informacion Detallada del Documento">
				<cfset LvarCampos = RsRegErrorDet.getColumnNames()>
				<div style="width:970px;overflow:scroll">
					<TABLE border="1" >
						<TR>
							<cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
								<td style="font-size:8;font-weight:bold">
							   		<cfoutput>#lcase(LvarCampos[i])#</cfoutput>
								</td>
							</cfloop>
						</TR>
						<cfloop query="RsRegErrorDet">   
							<TR>
								<cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
									<td style="font-size:10">
									<cfoutput>#evaluate("RsRegErrorDet.#LvarCampos[i]#")#&nbsp;</cfoutput>
									</td>
								</cfloop>
							</TR>
						</cfloop> 
					</TABLE>
				</div>
			<cf_web_portlet_end>
		<hr>
		<cfif  isdefined("RsRegErrorCab.Tipo_Venta") and RsRegErrorCab.Tipo_Venta EQ 'P' and isdefined("RsRegErrorPag")>
			<cf_web_portlet_start titulo="Formas de Pago del Documento">
				<cfset LvarCampos = RsRegErrorPag.getColumnNames()>
				<div style="width:970px;overflow:scroll">
					<TABLE border="1" >
						<TR>
							<cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
								<td style="font-size:8;font-weight:bold">
							   		<cfoutput>#lcase(LvarCampos[i])#</cfoutput>
								</td>
							</cfloop>
						</TR>
						<cfloop query="RsRegErrorPag">   
							<TR>
								<cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
									<td style="font-size:10">
									<cfoutput>#evaluate("RsRegErrorPag.#LvarCampos[i]#")#&nbsp;</cfoutput>
									</td>
								</cfloop>
							</TR>
						</cfloop> 
					</TABLE>
				</div>
			<cf_web_portlet_end>
		</cfif>
		<hr />
	</form>
   	<!----------------------------------------------------  --->
	<table align="center">
		<tr>
			<td>
				<form action="consola-procesos-form.cfm" method="post" style="margin:0 0 0 0" name="sql">
					<input type="submit" name="btnRegresar" value="Regresar">
				</form>
			</td>
			<td>
				<form action="consola-procesos-Errores.cfm" method="post" style="margin:0 0 0 0" name="sql">
					<input type="submit" name="btnError" value="Error">
					<input type="hidden" name="IDERROR" value="<cfoutput>#form.ID_Error#</cfoutput>">
				</form>
			</td>
		</tr>
	</table>
   <!----------------------------------------------------  --->

	<cfset LvarFiltro = ""> 
	<cfset LvarNavegacion = "">

 <cf_templatefooter>