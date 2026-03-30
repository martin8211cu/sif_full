<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<style type="text/css">
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
</style>

<cfinclude template="docum-funciones.cfm">

<cfquery name="rsUnidades" datasource="#session.DSN#">
	select Ucodigo, Udescripcion 
	from Unidades 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Ucodigo
</cfquery>

<cfquery name="rsEmpresa" datasource="#session.dsn#">
	Select Mcodigo
	from Empresas
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>	

<cfoutput>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<cfif not (rsParametroTolerancia.RecordCount gt 0 and rsParametroTolerancia.Pvalor eq 1 and rsForm.EDRestado eq 5 and form.tipo eq "R")>
			<cfif modo neq 'ALTA' and len(trim(rsForm.EPDid)) EQ 0>
				<td class="bottomline" ><strong><font size="2">Agregar Lineas de Ordenes de Compra</font></strong> -- 
				<cfif modo neq 'ALTA'><a href="##"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Ordenes de Compra" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisLinea();'></a></cfif></td>
			</cfif>
		</cfif>
	</tr>		
	<tr>
		<td>
			<cfinclude template="filtroDetRecepcion.cfm">
		</td>
	</tr>
	<tr>
		<td>
 			<cfinvoke component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet"> 
				<cfinvokeargument name="query" value="#dataLineas#"/> 
				<cfinvokeargument name="desplegar" value="DOconsecutivo,DOdescripcion, DOcantidad, saldo, numparte, descImpuesto, cantidadFactura,cantidadRecibida,DDRprecioorig,precioFactura,DDRtotallin"/>
				<cfinvokeargument name="etiquetas" value="Linea,Item, Cantidad OC, Saldo,Num. Parte,Impuesto,Cantidad Factura, Cantidad Recibida,Precio OC,Precio Factura,Total"/>
				<cfinvokeargument name="formatos" value="I,S,M,M,S,S,M,M,M,M,M"/> 
				<cfinvokeargument name="align" value="center,left,right,right,right,center,right,right,right,right,right"/> 
				<cfinvokeargument name="ajustar" value="S"/> 
				<cfinvokeargument name="MaxRows" value="5"/>
				<cfinvokeargument name="keys" value="DDRlinea"/>
				<cfinvokeargument name="cortes" value="descOrden"/>
				<cfinvokeargument name="irA" value="documentos.cfm"/> 
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="showEmptyListMsg" value="yes"/>
			</cfinvoke>
		</td>
	</tr>
	<tr><td align="center">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td>
				<form action="documentos-sql.cfm" method = "post" name = "form2" onSubmit="javascript: return validaDet();">
					<!--- Ocultos --->
					<input type="hidden" name="EDRdescpro" value="#rsForm.EDRdescpro#">
					<input type="hidden" name="tipo" value="#form.tipo#">
					<input type="hidden" name="EDRid" value="#form.EDRid#">
					<input type="hidden" value="#totalGen - rsForm.EDRdescpro#" name="Total">		
					<input type="hidden" name="totImpuestos" value="<cfif isdefined('rsTotales')>#rsTotales.sumImpuesto#<cfelse>0</cfif>">
					<input type="hidden" name="totDescuentos" value="<cfif isdefined('rsTotales')>#rsTotales.sumDescuento#<cfelse>0</cfif>">					
					
					<cfif isdefined('form.DDRlinea') and form.DDRlinea NEQ '' and isdefined('form.DOlinea') and form.DOlinea NEQ ''>
						<input type="hidden" name="DDRlinea" value="#form.DDRlinea#">
						<input type="hidden" name="DOlinea" value="#form.DOlinea#">
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td align="center">

	<!---							<cf_tabs>
									<cf_tab text="Detalle 1" selected="yes">
 										<cfinclude template="tab1-Drecepcion.cfm"> 
										
									</cf_tab>
									<cf_tab text="Detalle 2">
									 	<cfinclude template="tab2-Drecepcion.cfm">
									</cf_tab>
								</cf_tabs>	 		--->
								<table width="100%"  border="1" cellspacing="0" cellpadding="0">
								  <tr>
									<td>
										<cfinclude template="DRecepcion.cfm">
									</td>
								  </tr>
								</table>
							</td>
						  </tr>
						  <tr>
							<td>&nbsp;</td>
						  </tr>
						  <tr>
							<td align="center" valign="baseline">
								<cfif not (rsParametroTolerancia.RecordCount gt 0 and rsParametroTolerancia.Pvalor eq 1 and rsForm.EDRestado eq 5 and form.tipo eq "R")>
									<!-- Modificacion de detalle -->
										<input tabindex="7" type="submit" class="btnGuardar" name="btnModificar" value="Modificar">
									<cfif len(trim(rsForm.EPDid)) EQ 0>
										<input tabindex="8" type="submit" class="btnEliminar" name="btnBorrarD" value="Borrar" onClick="javascript:if ( confirm('Desea eliminar el detalle del Documento ?') ){validar=false; return true;} return false;">
									</cfif>
								</cfif>
										<input tabindex="9" type="button" class="btnAnterior" name="btnRegresar" value="Regresar" onClick="javascript: funcRegresar()">
							</td>
						  </tr>
						</table>
					</cfif>
				</form>				
			</td>
			<td align="right" valign="top">
				<cfif isdefined('rsTotales') and rsTotales.recordCount GT 0>
					<!--- Este query obtiene los detalles de un documento de recepcion con los campos necesarios para calcular el reclamo --->
					<cfset detallesDDRReclamos = GetQueryReclamos(session.dsn,session.Ecodigo,rsForm.EDRid)>
					<cfset totalReclamo = 0>
					<cfset totalFactura = 0>
					<cfset LvarTotal = 0>
					<cfset idPoliza = 0>
					<cfloop query="detallesDDRReclamos">
						<cfif modo neq 'ALTA' and len(trim(rsForm.EPDid))>
							<cfset totalFactura = totalFactura + calcularMonto(detallesDDRReclamos.DDRcantorigen, detallesDDRReclamos.DDRpreciou, detallesDDRReclamos.DDRdescporclin, 0.00)>
						<cfelse>
							<cfset totalFactura = totalFactura + calcularMonto(detallesDDRReclamos.DDRcantorigen, detallesDDRReclamos.DDRpreciou, detallesDDRReclamos.DDRdescporclin, detallesDDRReclamos.Iporcentaje)>
						</cfif>
						<cfif detallesDDRReclamos.DDRgenreclamo eq 1>
							<cfif modo neq 'ALTA' and len(trim(rsForm.EPDid))>
							
								<cfset idPoliza = rsForm.EPDid>
								<cfset totalReclamo = calcularReclamo(detallesDDRReclamos.DDRcantorigen, detallesDDRReclamos.DDRpreciou, detallesDDRReclamos.DDRdescporclin,
																					  detallesDDRReclamos.Iporcentaje, detallesDDRReclamos.DOcantsaldo, detallesDDRReclamos.DDRpreciou,
																					  detallesDDRReclamos.DDRdescporclin, detallesDDRReclamos.Iporcentaje, detallesDDRReclamos.DDRcantrec,
																					  detallesDDRReclamos.Ctolerancia, detallesDDRReclamos.Mcodigo, detallesDDRReclamos.McodigoOC,
																					  detallesDDRReclamos.EDRtc, detallesDDRReclamos.EOtc, detallesDDRReclamos.factorConversionU, 
																					  detallesDDRReclamos.DDRtipoitem, detallesDDRReclamos.ArticuloTieneTolerancia,idPoliza,detallesDDRReclamos.DDRaprobtolerancia)>
							<!--- <script language="javascript" type="text/javascript">
								alert('Tasa 1');
							</script> --->
							<cfelse>
								<cfif len(trim(rsForm.EPDid)) GT 0>
									<cfset idPoliza = rsForm.EPDid>								
								</cfif>
								<cfset totalReclamo = calcularReclamo(detallesDDRReclamos.DDRcantorigen, detallesDDRReclamos.DDRpreciou, detallesDDRReclamos.DDRdescporclin,
																					  detallesDDRReclamos.Iporcentaje, detallesDDRReclamos.DOcantsaldo, detallesDDRReclamos.DDRprecioorig,
																					  detallesDDRReclamos.DOporcdesc, detallesDDRReclamos.IporcentajeOC, detallesDDRReclamos.DDRcantrec,
																					  detallesDDRReclamos.Ctolerancia, detallesDDRReclamos.Mcodigo, detallesDDRReclamos.McodigoOC,
																					  detallesDDRReclamos.EDRtc, detallesDDRReclamos.EOtc, detallesDDRReclamos.factorConversionU, 
																					  detallesDDRReclamos.DDRtipoitem, detallesDDRReclamos.ArticuloTieneTolerancia,idPoliza,detallesDDRReclamos.DDRaprobtolerancia)>
								<!--- <script language="javascript" type="text/javascript">
									alert('Tasa 2');
								</script> --->
							</cfif>

							<cfset LvartotalReclamo =  totalReclamo[1]>
							<cfset LvarTotal = LvarTotal + LvartotalReclamo >
							
						</cfif>
						
						
						<cfset idPoliza = 0>
					</cfloop>

					<!--- Inicio de lineas de Totales --->
					<table align="right" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td align="right" class="textoMensajes"><strong>SubTotal:&nbsp;</strong></td>
							<td align="right">
								<strong>#LSCurrencyFormat(rsTotales.total,'none')#</strong>
							</td>
						</tr>
						
						<tr>
							<td align="right" class="textoMensajes"><strong>Descuento:&nbsp;</strong></td>
							<td align="right">
								<strong>
									#LSCurrencyFormat(rsTotales.sumDescuento,'none')#
								</strong>
							</td>
						</tr>
					
						<tr>
							<td align="right" class="textoMensajes"><strong>Impuesto:&nbsp;</strong></td>
							<td align="right">
								<cfif modo neq 'ALTA' and len(trim(rsForm.EPDid))>
									<strong>0.00</strong>
								<cfelse>
									<strong>#LSCurrencyFormat(rsTotales.sumImpuesto,'none')#</strong>
								</cfif>
							</td>
						</tr>
									
						<tr>
							<td class="textoMensajes"><strong>Total Estimado:&nbsp;</strong></td>
							<td align="right">												
								<strong>#LSCurrencyFormat(totalGen,'none')# </strong>
							</td>							
						</tr>

						<!--- Monto real recibido --->
						<tr>
							<td class="textoMensajes"><strong>Monto Real Recibido:&nbsp;</strong></td>
							<td align="right">
								
								<cfoutput><strong>#LSCurrencyFormat(totalFactura - LvarTotal, 'none')#</strong></cfoutput>
							</td>
						</tr>
						
						<!--- Monto reclamado --->
						<tr>
							<td class="textoMensajes"><strong>Monto Reclamado:&nbsp;</strong></td>
							<td align="right">
								<cfoutput><strong>#LSCurrencyFormat(LvarTotal, 'none')#</strong></cfoutput>
							</td>
						</tr>						
					  </table>
					<!--- Fin de lineas de Totales --->
				</cfif>
			</td>
		  </tr>
		</table>
	</td></tr>
</table>
</cfoutput>

<script language="javascript1.2" type="text/javascript">
	function eliminar(id){
		if ( confirm('Desea eliminar el registro?') ){
			document.form1._delete.value = id;
			document.form1.IDdelete.value = id;
			document.form1.submit();
		}
	}
	
	function doConlisLinea() {
		/*alert("/cfmx/sif/cm/operacion/ConlisLineaCompra.cfm?EDRid=<cfoutput>#form.EDRid#</cfoutput>&SNcodigo="+
				document.form1.SNcodigo.value + "&McodigoE=" + 
				document.form1.Mcodigo.value + "&TC_E=" + 
				qf(document.form1.EDRtc.value)
			);*/
			
		popUpWindow("/cfmx/sif/cm/operacion/ConlisLineaCompra.cfm?EDRid=<cfoutput>#form.EDRid#</cfoutput>&SNcodigo="+
			document.form1.SNcodigo.value + "&McodigoE=" + 
			document.form1.Mcodigo.value + "&TC_E=" + 
			qf(document.form1.EDRtc.value),50,50,1060,600);
	}
	
	function cargaImpEncab(){
		<cfif isdefined('rsTotales') and rsTotales.recordCount GT 0>
			document.form1.EDRimppro.value='<cfoutput>#LSCurrencyFormat(rsTotales.sumImpuesto,'none')#</cfoutput>';		
			document.form1.EDRdescpro.value='<cfoutput>#LSCurrencyFormat(rsTotales.sumDescuento,'none')#</cfoutput>';		
		</cfif>	
	}	

	cargaImpEncab();
</script>
