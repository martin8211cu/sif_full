 <cf_templateheader title="Bitacora de Procesos"> 
	<cfif  isdefined("form.Tabla") and form.Tabla EQ "ESIFLD_Facturas_Venta">
		<cfquery name = "RsRegErrorCab" datasource="sifinterfaces">
			select	*
			from ESIFLD_Facturas_Venta
			where ID_DocumentoV = #form.ID_Documento#
		</cfquery>
		<cfquery name = "RsRegErrorDet" datasource="sifinterfaces">
			select *
			from DSIFLD_Facturas_Venta
			where ID_DocumentoV = #form.ID_Documento#
		</cfquery>
		<cfquery name = "RsRegErrorPag" datasource="sifinterfaces">
			select *
			from SIFLD_Facturas_Tipo_Pago
			where ID_DocumentoV = #form.ID_Documento#
		</cfquery>
	</cfif>
	 
	<cfif  isdefined("form.Tabla") and form.Tabla EQ "ESIFLD_Facturas_Compra">
		<cfquery name = "RsRegErrorCab" datasource="sifinterfaces">
			select *
			from ESIFLD_Facturas_Compra
			where ID_DocumentoC = #form.ID_Documento#   
		</cfquery>
		<cfquery name = "RsRegErrorDet" datasource="sifinterfaces">
			select *
			from DSIFLD_Facturas_Compra
			where ID_DocumentoC = #form.ID_Documento#
		</cfquery>
	</cfif>
	
	<cfif  isdefined("form.Tabla") and form.Tabla EQ "ESIFLD_Movimientos_Inventario">
		<cfquery name = "RsRegErrorCab" datasource="sifinterfaces">
			SELECT *
			FROM ESIFLD_Movimientos_Inventario
			where ID_Movimiento = #form.ID_Documento#
		</cfquery>
		<cfquery name = "RsRegErrorDet" datasource="sifinterfaces">
			SELECT *
			FROM DSIFLD_Movimientos_Inventario
			where ID_Movimiento = #form.ID_Documento#
		</cfquery>
	</cfif>
	
	<cfif  isdefined("form.Tabla") and form.Tabla EQ "ESIFLD_Retiros_Caja">
		<cfquery name = "RsRegErrorCab" datasource="sifinterfaces">
			SELECT *
			FROM ESIFLD_RETIROS_CAJA
			where ID_Retiro = #form.ID_Documento#
		</cfquery>
		<cfquery name = "RsRegErrorDet" datasource="sifinterfaces">
			SELECT *
			FROM DSIFLD_RETIROS_CAJA
			where ID_Retiro = #form.ID_Documento#
		</cfquery>
	</cfif>
	
	<cfif  isdefined("form.Tabla") and form.Tabla EQ "ESIFLD_MovBancariosCxC">
		<cfquery name = "RsRegErrorCab" datasource="sifinterfaces">
			SELECT *
			FROM ESIFLD_MovBancariosCxC
			where ID_DocumentoM = #form.ID_Documento#
		</cfquery>
	</cfif>

	<cfif  isdefined("form.Tabla") and form.Tabla EQ "SIFLD_Movimientos_Bancarios">
		<cfquery name = "RsRegErrorCab" datasource="sifinterfaces">
			SELECT *
			FROM SIFLD_Movimientos_Bancarios
			where ID_MovimientoB = #form.ID_Documento#
		</cfquery>
	</cfif>
	
	<cfif  isdefined("form.Tabla") and form.Tabla EQ "SIFLD_Costo_Venta">
		<cfquery name = "RsRegErrorCab" datasource="sifinterfaces">
			select *
			from SIFLD_Costo_Venta
			where ID_Mov_Costo = #form.ID_Documento#
		</cfquery>
	</cfif>
    
    <cfif  isdefined("form.Tabla") and form.Tabla EQ "ESIFLD_Cobros_Pagos">
		<cfquery name = "RsRegErrorCab" datasource="sifinterfaces">
			select	*
			from ESIFLD_Cobros_Pagos
			where ID_Pago = #form.ID_Documento#
		</cfquery>
		<cfquery name = "RsRegErrorDet" datasource="sifinterfaces">
			select *
			from DSIFLD_Cobros_Pagos
			where ID_Pago = #form.ID_Documento#
		</cfquery>
	</cfif>
	
	<cfif  isdefined("form.Tabla") and form.Tabla EQ "Enc_Ordenes_Pago_SOIN">
		<cfquery name = "RsRegErrorCab" datasource="sifinterfaces">
			select	*
			from Enc_Ordenes_Pago_SOIN
			where ID = #form.ID_Documento#
		</cfquery>		
		<cfquery name = "RsRegErrorDet" datasource="sifinterfaces">
			select *
			from Det_Ordenes_Pago_SOIN
			where ID = #form.ID_Documento#
		</cfquery>	
	</cfif>
	
	<cfif  isdefined("form.Tabla") and form.Tabla EQ "Cheques_SOIN">
		<cfquery name = "RsRegErrorCab" datasource="sifinterfaces">
			select	*
			from Cheques_SOIN
			where ID = #form.ID_Documento#
		</cfquery>		
	</cfif>
    
    <cfif  isdefined("form.Tabla") and form.Tabla EQ "">
		<cfquery name = "RsRegErrorCab" datasource="sifinterfaces">
			SELECT 'NO HAY DETALLES PARA ESTE ERROR'
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
			<cfif  isdefined("RsRegErrorDet")>
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
            </cfif>
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