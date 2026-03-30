<cfinvoke key="LB_FolioExt" default="Folio" returnvariable="LB_FolioExt" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoCFID.xml"/>
<cfinvoke key="LB_RFCExt" default="RFC" returnvariable="LB_RFCExt" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoCFID.xml"/>
<cfinvoke key="LB_MontoTotalExt" default="Monto total" returnvariable="LB_MontoTotalExt" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoCFID.xml"/>
<cfinvoke key="LB_MetodoPagoExt" default="Metodo de pago" returnvariable="LB_MetodoPagoExt" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoCFID.xml"/>
<cfinvoke key="LB_MonedaExt" default="Moneda" returnvariable="LB_MonedaExt" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoCFID.xml"/>
<cfinvoke key="LB_TipoCambioExt" default="Tipo de cambio" returnvariable="LB_TipoCambioExt" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoCFID.xml"/>
<cfinvoke key="LB_SerieOtr" default="Serie" returnvariable="LB_SerieOtr" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoCFID.xml"/>
<cfinvoke key="LB_Tipo" default="Tipo" returnvariable="LB_Tipo" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoCFID.xml"/>
<cfinvoke key="LB_UUID" default="UUID" returnvariable="LB_UUID" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoCFID.xml"/>
<cfinvoke key="LB_RazonSocialE" default="Nombre o Raz&oacute;n Social Emisor" returnvariable="LB_RazonSocialE" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoCFID.xml"/>
<cfinvoke key="LB_RazonSocialR" default="Nombre o Raz&oacute;n Social Receptor" returnvariable="LB_RazonSocialR" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoCFID.xml"/>
<cfinvoke key="LB_RFCE" default="RFC Emisor" returnvariable="LB_RFCE" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoCFID.xml"/>
<cfinvoke key="LB_RFCR" default="RFC Receptor" returnvariable="LB_RFCR" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoCFID.xml"/>
<cfinvoke key="LB_Direccion" default="Direcci&oacute;n" returnvariable="LB_Direccion" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoCFID.xml"/>
<cfinvoke key="LB_Cantidad" default="Cantidad" returnvariable="LB_Cantidad" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoCFID.xml"/>
<cfinvoke key="LB_Concepto" default="Concepto" returnvariable="LB_Concepto" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoCFID.xml"/>
<cfinvoke key="LB_Monto" default="Monto" returnvariable="LB_Monto" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoCFID.xml"/>
<cfinvoke key="LB_Total" default="Total" returnvariable="LB_Total" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoCFID.xml"/>
<cfinvoke key="LB_Impuesto" default="Impuesto" returnvariable="LB_Impuesto" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoCFID.xml"/>
<cfinvoke key="LB_ArchivoSoporte" default="Archivo Soporte: " returnvariable="LB_ArchivoSoporte" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoCFID.xml"/>


<cfif isdefined('url.IDContable') and len(trim(url.IDContable)) GT 0>
	<cfset IDContable = #url.IDContable#>
</cfif>

<cfif isdefined('url.Dlinea') and len(trim(url.Dlinea)) GT 0>
	<cfset Dlinea = #url.Dlinea#>
</cfif>

<cfset rfc = "">
<cfif isdefined('form.rfc') and len(trim(form.rfc)) GT 0>
	<cfset rfc = #form.rfc#>
</cfif>
<cfset nombrer = "">
<cfif isdefined('form.nombrer') and len(trim(form.nombrer)) GT 0>
	<cfset nombrer = #form.nombrer#>
</cfif>

<cfif isdefined('url.IdRep') and len(trim(url.IdRep)) GT 0>
	<cfset IdRep = #url.IdRep#>
</cfif>

<cfset hideAgrega = "true">
<cfif isdefined('url.info') and len(trim(url.info)) GT 0>
	<cfset hideAgrega = "false">
</cfif>

<cfset aux = "false">
<cfif isdefined('url.aux') and len(trim(url.aux)) GT 0>
	<cfset aux = #url.aux#>
	<cfset hideAgrega = "false">
</cfif>
<cfif IdRep GT 0>
	<cfset LobjRepo = createObject( "component","sif.ce.Componentes.RepositorioCFDIs")>
	<cfset axml = LobjRepo.getInfoXML(idRepo=#IdRep#,temp=#aux#)>

	<cfif isdefined('url.action') and len(trim(url.action)) GT 0>
		<cfset axml = LobjRepo.getArchivoAdicional(#IdRep#)>
	</cfif>

	<!---<cf_dump var="#axml.Conceptos[1].Cantidad#">--->
	<div style="font-family: Arial, Helvetica, sans-serif;">
	<br>
	<table width="100%">
		<tr>
			<td align="center" width="100%">
	        <cfoutput>
	        		<cfif (isDefined("axml.TipoComprobante") AND axml.TipoComprobante EQ "1") or axml.TipoComprobante EQ "">

	        			<cfif (isdefined("axml.UUID") and axml.UUID NEQ "") or aux eq 1>
						<!--- INICIA TIPO 1-NACIONAL --->
	        			<table width="80%">
						<cfif hideAgrega>

						<tr>
				            <td align="right" colspan="3"><cfoutput><a href="../../ce/operacion/formComprobanteFiscalPoliza.cfm?IDContable=#IDContable#&Dlinea=#Dlinea#&IdRep=#IdRep#">Agregar/Modificar CFDI</a></cfoutput></td>
				        </tr>
				        </cfif>
		            	<!--- <tr>
		                	<td width="30%" align="left">
		                    	<strong>#LB_Tipo#:</strong>
		                    </td>
		                    <td width="70%">
		                    	<input type="text" name="txtTipo" id="txtTipo" value="#Ucase(axml.Tipo)#" style="background-color:##E8E8E8; width:100%; border:hidden;"/>
		                    </td>
		                </tr> --->
		                <tr>
		                	<td width="30%" align="left">
		                    	<strong>#LB_UUID#:</strong>
		                    </td>
		                    <td width="70%">
		                    	<cfif isdefined('axml.UUID') and len(trim(axml.UUID))>
		                    		<span>#axml.UUID#</span>
		                        </cfif>
		                    </td>
		                </tr>
		                <tr>
		                	<td width="30%" align="left">
		                    	<strong>#LB_RazonSocialE#:</strong>
		                    </td>
		                    <td width="70%" style="background-color:##E8E8E8; width:100%;" >
		                    	<cfif isdefined('axml.NombreEmisor') and len(trim(axml.NombreEmisor))>
		                        	<font color="##000"><span>#axml.NombreEmisor#</span></font>
		                        </cfif>
		                    </td>
		                </tr>
		                <tr>
		                	<td width="30%" align="left">
		                    	<strong>#LB_RFCE#:</strong>
		                    </td>
		                    <td width="70%">
		                    	<cfif isdefined('axml.RFCemisor') and len(trim(axml.RFCemisor))>
		                        	<span>#axml.RFCemisor#</span>
		                        </cfif>
		                    </td>
		                </tr>
		                <tr>
		                	<td width="30%" align="left">
		                    	<strong>#LB_RazonSocialR#:</strong>
		                    </td>
		                    <td width="70%" style="background-color:##E8E8E8; width:100%;" >
		                    	<cfif isdefined('axml.NombreReceptor') and len(trim(axml.NombreReceptor))>
		                        	<font color="##000"><span>#axml.NombreReceptor#</span></font>
		                        </cfif>
		                    </td>
		                </tr>
		                <tr>
		                	<td width="30%" align="left">
		                    	<strong>#LB_RFCR#:</strong>
		                    </td>
		                    <td width="70%">
		                    	<cfif isdefined('axml.RFCreceptor') and len(trim(axml.RFCreceptor))>
		                        	<span>#axml.RFCreceptor#</span>
		                        </cfif>
		                    </td>
		                </tr>
		                <tr>
		                	<td width="30%" align="left">
		                    	<strong>#LB_Direccion#:</strong>
		                    </td>
		                    <td width="70%" style="background-color:##E8E8E8;">
		                    	<cfif isdefined('axml.DireccionEmisor') and len(trim(axml.DireccionEmisor))>
		                        	<font color="##000"><span>#axml.DireccionEmisor#</span></font>
		                        </cfif>
		                    </td>
		                </tr>
		                <tr>
		                	<td colspan="2">
		                    	<hr  />
		                    </td>
		                </tr>
		                <tr>
		                	<td colspan="2">
								<table width="100%" cellspacing="0" cellpadding="0">
		                        	<tr bgcolor="##E8E8E8">
		                            	<td width="10%">
		                                	<font color="##000"><strong>#LB_Cantidad#</strong></font>
		                                </td>
		                                <td width="80%">
		                                	<font color="##000"><strong>#LB_Concepto#</strong></font>
		                                </td>
		                                <td width="10%">
		                                	<font color="##000"><strong>#LB_Monto#</strong></font>
		                                </td>
		                            </tr>
		                        </table>
		                    </td>
		                </tr>
		                <!---Aqui va el detalle de conceptos--->
						<cfif isdefined("axml.Conceptos")>
			                <cfloop from="1" to="#arraylen(axml.Conceptos)#" index="i">
			                 <tr>
			                	<td colspan="2">
									<table width="100%">
			                        	<tr>
			                            	<td width="10%" align="center">
			                                	<cfif isdefined('axml.Conceptos') and arraylen(axml.Conceptos)>
			                                    	<span>#LSNumberFormat(axml.Conceptos[i].Cantidad)#</span>
			                                    </cfif>
			                                </td>
			                                <td width="80%">
			                                	<cfif isdefined('axml.Conceptos') and arraylen(axml.Conceptos)>
			                                    	<span>#axml.Conceptos[i].Descripcion#</span>
			                                    </cfif>
			                                </td>
			                                <td width="10%" align="center">
			                                	<cfif isdefined('axml.Conceptos') and arraylen(axml.Conceptos)>
			                                    	<span>#LSCurrencyFormat(axml.Conceptos[i].Importe)#</span>
			                                    </cfif>
			                                </td>
			                            </tr>
			                        </table>
			                    </td>
			                </tr>
							</cfloop>
		                </cfif>
		                <!---Aqui va el detalle de conceptos--->
		                <tr bgcolor="##87CEEB">
		                	<td colspan ="2">
		                    	<table width="100%">
		                        	<tr>
		                            	<td width="20%">
		                                	<strong>#LB_Impuesto#</strong>
		                                </td>
		                                <td colspan ="2">
		                                	<cfif isdefined('axml.Impuesto') and len(trim(axml.Impuesto))>
		                                    	<span>#LSCurrencyFormat(axml.Impuesto)#</span>
		                                    </cfif>
		                                </td>
		                            </tr>
		                        </table>
		                    </td>
		                </tr>
		                <tr bgcolor="##E8E8E8">
		                	<td colspan="2">
		                    	<table width="100%">
		                        	<tr>
		                            	<td width="20%">
		                                	<font color="##000"><strong>#LB_Total#</strong><font color="##000">
		                                </td>
										<cfset varSubtotal = 0>
										<cfset varImpuesto = 0>
										<cfif isdefined("axml.Subtotal") and axml.Subtotal NEQ "">
											<cfset varSubtotal = axml.SubTotal>
										</cfif>
										<cfif isdefined("axml.Impuesto") and axml.Impuesto NEQ "">
											<cfset varImpuesto = axml.Impuesto>
										</cfif>
		                                <td colspan ="2">
		                                	<cfset Total = #varSubtotal# + #varImpuesto#>
		                                    <cfif isdefined('axml.RFCemisor') and len(trim(axml.RFCemisor))>
		                                    	<font color="##000"><span>#LSCurrencyFormat(Total)#</span></font>
		                                    </cfif>
		                                </td>
		                            </tr>
		                        </table>
		                    </td>
		                </tr>
					<cfelse>
					<tr>
	                	<td colspan="2" align="left">
	                    	<cfinclude template="../../ce/operacion/formComprobanteFiscalPoliza.cfm">
	                    </td>
	                </tr>
					</cfif>

					<cfif isdefined("axml.ExisteSoporte") and axml.ExisteSoporte EQ 1>
						<tr bgcolor="##E8E8E8">
		                	<td colspan="2" align="left">
		                    	<b>#LB_ArchivoSoporte#: </b><a href="popUp-CEInfoCFDI.cfm?IDContable=#IDContable#&Dlinea=#Dlinea#&IdRep=#IdRep#&action=#axml.archivoSoporte#">#axml.archivoSoporte#</a>
		                    </td>
		                </tr>
					</cfif>
	            </table>
	        		</cfif>

	            <!--- FINALIZA TIPO 1-NACIONAL --->
	            <!--- INICIA TIPO 2-EXT.. --->
	            <cfif isDefined("axml.TipoComprobante") AND axml.TipoComprobante EQ "2">
	            	<table width="80%">
	            		<cfset cont = 0>
	            		<cfif hideAgrega>
							<tr>
					            <td align="right" colspan="3"><cfoutput><a href="../../ce/operacion/formComprobanteFiscalPoliza.cfm?IDContable=#IDContable#&Dlinea=#Dlinea#&IdRep=#IdRep#">Agregar/Modificar CFDI</a></cfoutput></td>
					        </tr>
				        </cfif>
				        <!--- Folio --->
				        <cfif isDefined("axml.UUID")>
				        	<cfset cont = cont + 1>
				        	<tr>
					        	<td width="30%" align="left">
			                    	<strong>#LB_FolioExt#:</strong>
			                    </td>
			                    <td width="70%" <cfif cont mod 2 EQ 0> style = "background-color:##E8E8E8;"</cfif>>
			                    	<span>#axml.UUID#</span>
			                    </td>
					        </tr>
				        </cfif>
				        <!--- RFC contribuyente --->
				        <cfif isDefined("axml.RFCExt")>
				        	<cfset cont = cont + 1>
				        	<tr>
					        	<td width="30%" align="left">
			                    	<strong>#LB_RFCExt#:</strong>
			                    </td>
			                    <td width="70%" <cfif cont mod 2 EQ 0> style = "background-color:##E8E8E8;"</cfif>>
			                    	<span>#axml.RFCExt#</span>
			                    </td>
					        </tr>
				        </cfif>
				        <!--- Monto total --->
				        <cfif isDefined("axml.MontoTotal")>
				        	<cfset cont = cont + 1>
				        	<tr>
					        	<td width="30%" align="left">
			                    	<strong>#LB_MontoTotalExt#:</strong>
			                    </td>
			                    <td width="70%" <cfif cont mod 2 EQ 0> style = "background-color:##E8E8E8;"</cfif>>
			                    	<span>#LSCurrencyFormat(axml.MontoTotal)#</span>
			                    </td>
					        </tr>
				        </cfif>
				        <!--- Metodo de pago --->
				        <cfif isDefined("axml.MetPago")>
				        	<cfset cont = cont + 1>
				        	<tr>
					        	<td width="30%" align="left">
			                    	<strong>#LB_MetodoPagoExt#:</strong>
			                    </td>
			                    <td width="70%" <cfif cont mod 2 EQ 0> style = "background-color:##E8E8E8;"</cfif>>
			                    	<span>#axml.MetPago#</span>
			                    </td>
					        </tr>
				        </cfif>
				        <!--- Moneda --->
				        <cfif isDefined("axml.Miso4217")>
				        	<cfset cont = cont + 1>
				        	<tr>
					        	<td width="30%" align="left">
			                    	<strong>#LB_MonedaExt#:</strong>
			                    </td>
			                    <td width="70%" <cfif cont mod 2 EQ 0> style = "background-color:##E8E8E8;"</cfif>>
			                    	<span>#axml.Miso4217#</span>
			                    </td>
					        </tr>
				        </cfif>
				        <!--- Tipo de cambio --->
				        <cfif isDefined("axml.TipoCambio")>
				        	<cfset cont = cont + 1>
				        	<tr>
					        	<td width="30%" align="left">
			                    	<strong>#LB_TipoCambioExt#:</strong>
			                    </td>
			                    <td width="70%" <cfif cont mod 2 EQ 0> style = "background-color:##E8E8E8;"</cfif>>
			                    	<span>#Trim(numberFormat(axml.TipoCambio,"0.00"))#</span>
			                    </td>
					        </tr>
				        </cfif>
	            	</table>
	            </cfif>
	            <!--- FINALIZA TIPO 2-EXT.. --->
	            <!--- INICIA TIPO 3-OTRONAL.. --->
	            <cfif isDefined("axml.TipoComprobante") AND axml.TipoComprobante EQ "3">
	            	<table width="80%">
	            		<cfset cont = 0>
	        			<cfif hideAgrega>
							<tr>
					            <td align="right" colspan="3"><cfoutput><a href="../../ce/operacion/formComprobanteFiscalPoliza.cfm?IDContable=#IDContable#&Dlinea=#Dlinea#&IdRep=#IdRep#">Agregar/Modificar CFDI</a></cfoutput></td>
					        </tr>
				        </cfif>
				        <!--- CFD_CBB_Serie --->
				        <cfif isDefined("axml.Serie")>
				        	<cfset cont = cont + 1>
				        	<tr>
					        	<td width="30%" align="left">
			                    	<strong>#LB_SerieOtr#:</strong>
			                    </td>
			                    <td width="70%" <cfif cont mod 2 EQ 0> style = "background-color:##E8E8E8;"</cfif>>
			                    	<span>#Trim(axml.Serie)#</span>
			                    </td>
					        </tr>
				        </cfif>
				        <!--- CFD_CBB_NumFol --->
				        <cfif isDefined("axml.UUID")>
				        	<cfset cont = cont + 1>
				        	<tr>
					        	<td width="30%" align="left">
			                    	<strong>#LB_FolioExt#:</strong>
			                    </td>
			                    <td width="70%" <cfif cont mod 2 EQ 0> style = "background-color:##E8E8E8;"</cfif>>
			                    	<span>#axml.UUID#</span>
			                    </td>
					        </tr>
				        </cfif>

				        <!--- Monto total --->
				        <cfif isDefined("axml.MontoTotal")>
				        	<cfset cont = cont + 1>
				        	<tr>
					        	<td width="30%" align="left">
			                    	<strong>#LB_MontoTotalExt#:</strong>
			                    </td>
			                    <td width="70%" <cfif cont mod 2 EQ 0> style = "background-color:##E8E8E8;"</cfif>>
			                    	<span>#LSCurrencyFormat(axml.MontoTotal)#</span>
			                    </td>
					        </tr>
				        </cfif>
				        <!--- RFC --->
				        <cfif isDefined("axml.RFCemisor")>
				        	<cfset cont = cont + 1>
				        	<tr>
					        	<td width="30%" align="left">
			                    	<strong>#LB_RFCExt#:</strong>
			                    </td>
			                    <td width="70%" <cfif cont mod 2 EQ 0> style = "background-color:##E8E8E8;"</cfif>>
			                    	<span>#axml.RFCemisor#</span>
			                    </td>
					        </tr>
				        </cfif>
				        <!--- Metodo de pago --->
				        <cfif isDefined("axml.MetPago")>
				        	<cfset cont = cont + 1>
				        	<tr>
					        	<td width="30%" align="left">
			                    	<strong>#LB_MetodoPagoExt#:</strong>
			                    </td>
			                    <td width="70%" <cfif cont mod 2 EQ 0> style = "background-color:##E8E8E8;"</cfif>>
			                    	<span>#axml.MetPago#</span>
			                    </td>
					        </tr>
				        </cfif>
				        <!--- Moneda --->
				        <cfif isDefined("axml.Miso4217")>
				        	<cfset cont = cont + 1>
				        	<tr>
					        	<td width="30%" align="left">
			                    	<strong>#LB_MonedaExt#:</strong>
			                    </td>
			                    <td width="70%" <cfif cont mod 2 EQ 0> style = "background-color:##E8E8E8;"</cfif>>
			                    	<span>#axml.Miso4217#</span>
			                    </td>
					        </tr>
				        </cfif>
				        <!--- Tipo de cambio --->
				        <cfif isDefined("axml.TipoCambio")>
				        	<cfset cont = cont + 1>
				        	<tr>
					        	<td width="30%" align="left">
			                    	<strong>#LB_TipoCambioExt#:</strong>
			                    </td>
			                    <td width="70%" <cfif cont mod 2 EQ 0> style = "background-color:##E8E8E8;"</cfif>>
			                    	<span>#Trim(numberFormat(axml.TipoCambio,"0.00"))#</span>
			                    </td>
					        </tr>
				        </cfif>
	            	</table>
	            </cfif>
	            <!--- FINALIZA TIPO 3-OTRONAL.. --->
	        </cfoutput>
			</td>
		</tr>
	</table>
<cfelse>

	<cfquery name="rsListaLineas" datasource="#session.DSN#">
		select IdRep,IdContable,linea,timbre from CERepositorio
		where IdContable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#IDContable#">
			and linea = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Dlinea#">
	</cfquery>

	<cfset newValsRazon = []>
	<cfset newValsRFCr = []>
	<cfset newValsTotal = []>

	<cfloop query="rsListaLineas">
		<cfset LobjRepo = createObject( "component","sif.ce.Componentes.RepositorioCFDIs")>
		<cfset axml = LobjRepo.getInfoXML(idRepo=#IdRep#,temp=aux)>

		<cfif isdefined("axml.NombreReceptor")>
			<cfset rRazon = axml.NombreReceptor>
		<cfelse>
			<cfset rRazon = "">
		</cfif>
		<cfif isdefined("axml.RFCreceptor")>
			<cfset rRFCr = axml.RFCreceptor>
		<cfelse>
			<cfset rRFCr = "">
		</cfif>


	    <cfset varSubtotal = 0>
		<cfset varImpuesto = 0>
		<cfif isdefined("axml.Subtotal")>
			<cfset varSubtotal = axml.SubTotal>
		</cfif>
		<cfif isdefined("axml.Impuesto")>
			<cfset varImpuesto = axml.Impuesto>
		</cfif>
       	<cfset rTotal = #varSubtotal# + #varImpuesto#>

		<cfset ArrayAppend(newValsRazon, rRazon)>
	    <cfset ArrayAppend(newValsRFCr, rRFCr)>
	    <cfset ArrayAppend(newValsTotal, rTotal)>
	</cfloop>

	<cfset QueryAddColumn(rsListaLineas, "Razon", "Varchar", newValsRazon)>
	<cfset QueryAddColumn(rsListaLineas, "RFCr", "Varchar", newValsRFCr)>
	<cfset QueryAddColumn(rsListaLineas, "montoTotal", "Decimal", newValsTotal)>

	<!--- <form name="frmRegresar"> --->
	<table width="100%" border="0" cellspacing="0">
		<tr>
            <td align="right" colspan="4"><cfoutput><a href="../../ce/operacion/formComprobanteFiscalPoliza.cfm?masiva=1&IDContable=#IDContable#&Dlinea=#Dlinea#&IdRep=#IdRep#">Agregar/Modificar CFDI</a></cfoutput></td>
        </tr>
		<tr bgcolor="E2E2E2" class="subTitulo">
			<td colspan="5">
			<cfoutput>
				<form action="popUp-CEInfoCFDI.cfm?IDContable=#IDContable#&Dlinea=#Dlinea#&IdRep=#IdRep#" method="post" name="frmFiltro">
					<table width="100%" border="0" cellspacing="0">
						<tr>
				            <td width="25%" align="right" valign="bottom"><strong>RFC Receptor:&nbsp;</strong></td>
				            <td align="left" valign="bottom"><input type="text" name="rfc" value="#rfc#"></td>
				            <td width="25%" align="right" valign="bottom"><strong>Nombre:&nbsp;</strong></td>
				            <td align="left" valign="bottom"><input type="text" name="nombrer" value="#nombrer#"></td>
				            <td width="15%" align="center" valign="bottom"><input type="submit" name="btnFiltrar" value="Filtrar" ><input type="reset" name="btnReset" value="Limpiar" ></td>
						</tr>
					</table>
				</form>
			</cfoutput>
			</td>
        </tr>
		<tr bgcolor="E2E2E2" class="subTitulo">
            <td width="25%" valign="bottom"><strong>&nbsp;RFC Receptor</strong></td>
            <td valign="bottom"><strong>&nbsp;Nombre</strong></td>
            <td width="15%" align="center" valign="bottom"><strong>&nbsp;Monto</strong></td>
			<td align="center" valign="bottom"><strong>&nbsp;Timbre Fiscal</strong></td>
			<td width="3%" align="center" valign="bottom"><strong>&nbsp;</strong></td>
        </tr>
		<cfset actRow = 1>
		<cfoutput query="rsListaLineas">
			<cfif	(len(rfc) EQ 0 and len(nombrer) EQ 0) or
					(len(rfc) GT 0 and len(nombrer) EQ 0 and FindNoCase(rfc,rsListaLineas.RFCr)) or
					(len(rfc) EQ 0 and len(nombrer) GT 0 and FindNoCase(nombrer,rsListaLineas.Razon)) or
					(len(rfc) GT 0 and len(nombrer) GT 0 and FindNoCase(nombrer,rsListaLineas.Razon) and FindNoCase(rfc,rsListaLineas.RFCr))
			>
				<tr style="cursor: pointer;" onMouseOver="javascript: style.color = 'red';" onMouseOut="javascript: style.color = 'black';"
				<cfif actRow MOD 2>
					bgcolor="white"
				<cfelse>
					bgcolor="##fafafa"
				</cfif>
				>
					<td onClick="javascript:ShowNewPage(#rsListaLineas.IDContable#,#rsListaLineas.linea#,#rsListaLineas.IdRep#);">
						#rsListaLineas.RFCr#
					</td>
					<td onClick="javascript:ShowNewPage(#rsListaLineas.IDContable#,#rsListaLineas.linea#,#rsListaLineas.IdRep#);">
						#rsListaLineas.Razon#
					</td>
					<td align="center" onClick="javascript:ShowNewPage(#rsListaLineas.IDContable#,#rsListaLineas.linea#,#rsListaLineas.IdRep#);">
						#LSCurrencyFormat(rsListaLineas.montoTotal,'none')#
					</td>
					<td align="center" onClick="javascript:ShowNewPage(#rsListaLineas.IDContable#,#rsListaLineas.linea#,#rsListaLineas.IdRep#);">
						#rsListaLineas.timbre#
					</td>
					<td align="right">
	                     <img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif"
	                     alt="Eliminar Detalle" onclick="funcBorrar('#rsListaLineas.IdRep#');">
	                </td>
				</tr>
				<cfset actRow = actRow + 1>
			</cfif>
		</cfoutput>
	</table>
</div>
	<!--- </form> --->

<script>
 !window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.1.js"><\/script>');
</script>
<script language="JavaScript1.2" src="/cfmx/sif/js/ModalPopupWindow.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	var modalWin = new CreateModalPopUpObject();
	modalWin.SetLoadingImagePath("../../imagenes/modal/loading.gif");
	 modalWin.SetCloseButtonImagePath("../../imagenes/modal/remove.gif");
	 //Uncomment below line to make look buttons as link
	 //modalWin.SetButtonStyle("background:none;border:none;textDecoration:underline;cursor:pointer");

	function ShowNewPage(IDContable,Dlinea,IdRep){
		var callbackFunctionArray = new Array(EnrollNow, EnrollLater);
		modalWin.ShowURL("/cfmx/sif/ce/consultas/popUp-CEInfoCFDI.cfm?info=1&IDContable=" + IDContable + "&Dlinea=" + Dlinea + "&IdRep=" + IdRep,480,640,'CFDI',null,callbackFunctionArray);
	}

	function EnrollNow(msg){
	modalWin.HideModalPopUp();
	modalWin.ShowMessage(msg,200,400,'User Information',null,null);
	}

	function EnrollLater(){
	modalWin.HideModalPopUp();
	modalWin.ShowMessage(msg,200,400,'User Information',null,null);
	}

	function HideModalWindow() {
	    modalWin.HideModalPopUp();
	}

	function funcBorrar(idRep)
	{

		if(confirm("Se va a eliminar el CFDI de todos los documentos relacionados, Desea continuar?")){
			$.ajax({
				   type: 'POST',
				url:'/cfmx/sif/ce/operacion/SQLCFDIAjax.cfm',
				data: "action=delete&idrep="+idRep,
				success: function(msg){
					location.reload();

				}
				});

			return false;
		}
		return false;


	}

	<cfoutput>
		<cfif isdefined("rsListaLineas") and rsListaLineas.recordCount EQ 0>
			window.opener.location.reload();
			window.close();
		</cfif>
	</cfoutput>
 </script>

</cfif>