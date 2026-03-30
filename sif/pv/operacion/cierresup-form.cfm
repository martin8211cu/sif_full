<cfset fnProcesaInformacion()>
<style type="text/css">
<!--
.cierresup-form-style1 {font-size: 24px}
.cierresup-form-style2 {font-size: 18px}
.cierresup-form-style3 {font-size: 16px}
.cierresup-form-style4 {font-size: 14px}
-->
</style>
<cfoutput>

<form name="form1" action="cierresup-sql.cfm" method="post" style="margin:0">
	<table width="98%"  border="0" align="center" cellspacing="0" cellpadding="0" class="AreaFiltro">
	  <tr>
		  <td class="TituloListas">
	<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
	  <tr>
	  </tr>
		<td colspan = "4" align="right"  nowrap class= "TituloListas"><div align="right" >Fecha: #LSDateFormat(Now(),'dd/mm/yyyy')# #LSTimeFormat(Now(),'hh:mm')#</div></td>
	  <tr>
		<td align="center"  colspan="4" nowrap class= "TituloListas"><div align="center" class="cierresup-form-style3" >#rsEmpresa.Edescripcion#</div></td>
	  </tr>
	  <tr>
		<td  colspan="4" nowrap class= "TituloListas"><div align="center" class="cierresup-form-style4" >Verificaci&oacute;n de Arqueo</div></td>
	  </tr>
	  <tr>
		<td  width="10%" align="center" nowrap class= "TituloListas"><div align="center" ></div></td>
		<td  colspan="2" width="80%" align="center"   nowrap class= "TituloListas"><div align="center" >Caja : #rsCaja.FAM01CODD# - #rsCaja.FAM01DES#  &nbsp;&nbsp;&nbsp;&nbsp  Sucursal : #rsSucursal.Odescripcion#</div></td>
		<td  width="10%" align="center" nowrap class= "TituloListas"><div align="center" ></div></td>
	  </tr>
	
	  <tr>
		<td colspan="2" nowrap class= "TituloListas"><div align="right" >Fecha Contable:&nbsp;&nbsp;</div> </td>
		<td colspan="2" nowrap class= "TituloListas"><div align="left" > 
			<cfif isdefined("Url.imprimir")>
				#Form.FechaCierre#
			<cfelse>
				<cf_sifcalendario name="FechaCierre" form="form1" value="#Form.FechaCierre#">
			</cfif>
			</div> 
		</td>
	  </tr>
	  <tr>
		<td nowrap class= "TituloListas"><div align="center" >&nbsp;</div></td>
	  </tr>
	</table>
		<table width="100%"  border="0" align="center" cellpadding="1" cellspacing="0" style="margin:0">
			<tr align="right">
				<td width="50%" valign="top">
						<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20" style="background-color:##CCCCCC; border: 1px solid ##AAAAAA; height: 15;">
						  <tr>
							<td align="center" height="25">&nbsp;<strong>Transacciones</strong></td>
						  </tr>
						</table>
							<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="margin:0; background-color:##F3F4F8; border-top: none; border-left: 1px solid ##CCCCCC; border-right: 1px solid ##CCCCCC; border-bottom: 1px solid ##CCCCCC;">
								<tr>
								  <td width="1%" nowrap class = "TituloListas"><div align="center"></div></td>
								  <td nowrap class = "TituloListas"><div align="right">Cierre Manual </div></td>
								  <td nowrap class = "TituloListas"><div align="right">Cierre Autom&aacute;tico </div></td>
								  <td nowrap class = "TituloListas"><div align="right">Diferencia</div></td>
								</tr>							
								<tr>
								<tr>
								  <td width="1%" nowrap class = "TituloListas"><div align="right">Facturas Contado: </div></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.FContado#" modificable = "false" class="cajasinbordeb" size="15"></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.BDFContado#" modificable = "false" class="cajasinbordeb" size="16"></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.FContadodiv#" modificable = "false" class="cajasinbordeb" size="14"></td>
								</tr>
								<tr>
								  <td width="1%" nowrap class = "TituloListas"><div align="right">N.C. Generadas: </div></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.DocNCGeneradas#" modificable = "false" class="cajasinbordeb" size="15" ></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.BDNCGeneradas#" modificable = "false" class="cajasinbordeb"  size="16"></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.DocNCGeneradasdiv#" modificable = "false" class="cajasinbordeb" size="14" ></td>
								</tr>
								<tr>
								  <td width="1%" nowrap class = "TituloListas"><div align="right">Recibo Adelantos y Otros:</div></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.Adelantos#" modificable = "false" class="cajasinbordeb" size="15" ></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.BDAdelantos#" modificable = "false" class="cajasinbordeb" size="16" ></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.Adelantosdiv#" modificable = "false" class="cajasinbordeb" size="14" ></td>
								</tr>
								<tr>
								  <td width="1%" nowrap class = "TituloListas"><div align="right">Recibos CxC: </div></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.RecibosCxC#" modificable = "false" class="cajasinbordeb" size="15" ></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.BDRecibosCxC#" modificable = "false" class="cajasinbordeb" size="16" ></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.RecibosCxCdiv#" modificable = "false" class="cajasinbordeb" size="14" ></td>
								  <td width="100%" nowrap class = "TituloListas">&nbsp;</td>
								</tr>
								<tr>
								  <td width="1%" nowrap class = "TituloListas"><div align="right">Devoluciones(-):</div></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.NCredito#" modificable = "false" class="cajasinbordeb" size="15" ></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.BDNCredito#" modificable = "false" class="cajasinbordeb" size="16" ></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.NCreditodiv#" modificable = "false" class="cajasinbordeb" size="14" ></td>
								</tr>
								<tr>
								  <td width="1%" nowrap class = "TituloListas"><div align="right">Adelantos Aplicados(-):</div></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.AdelantosApli#" modificable = "false" class="cajasinbordeb" size="15" ></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.BDAdelantosApli#" modificable = "false" class="cajasinbordeb" size="16" ></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.AdelantosAplidiv#" modificable = "false" class="cajasinbordeb" size="14" ></td>
								</tr>
								<tr>
									<td colspan="5" nowrap class = "TituloListas"><div align="right"><hr></div></td>
								</tr>								
								<tr>
								  <td width="100%" nowrap class = "TituloListas"><div align="right"><strong>Documentos Efectivo:</strong></div></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.TotalDocumentos#" modificable = "false" class="cajasinbordeb" size="15" ></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.BDTotalDocumentos#" modificable = "false" class="cajasinbordeb"  size="16"></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.TotalDocumentosdiv#" modificable = "false" class="cajasinbordeb" size="14" ></td>
								</tr>
	
								<tr>
									<td colspan="5" nowrap class = "TituloListas"><div align="right">&nbsp;</div></td>
								</tr>
								<tr>
								  <td width="1%" nowrap class = "TituloListas"><div align="left"><strong>Documentos Cr&eacute;dito:</strong></div></td>
								  <td>&nbsp;  </td>
								  <td>&nbsp;  </td>
								  <td>&nbsp;  </td>
								</tr>
	
								<tr>
								  <td width="1%" nowrap class = "TituloListas"><div align="right">Facturas Cr&eacute;dito:</div></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.FCredito#" modificable = "false" class="cajasinbordeb"  size="15"></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.BDFCredito#" modificable = "false" class="cajasinbordeb" size="16" ></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.BDFCreditodiv#" modificable = "false" class="cajasinbordeb" size="14" ></td>
								</tr>
								<tr>
								  <td width="1%" nowrap class = "TituloListas"><div align="right">Notas Cr&eacute;dito:</div></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.NCCredito#" modificable = "false" class="cajasinbordeb"  size="15"></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.BDNCCredito#" modificable = "false" class="cajasinbordeb" size="16" ></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.NCCreditodiv#" modificable = "false" class="cajasinbordeb" size="14" ></td>
								</tr>
	
							</table>
				</td>
				<td width="50%"  align="right" valign="top" >
						<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20" style="background-color:##CCCCCC; border: 1px solid ##AAAAAA; height: 15;">
						  <tr>
							<td align="center" height="25">&nbsp;<strong>Valores</strong></td>
						  </tr>
						</table>
							<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="margin:0; background-color:##F3F4F8; border-top: none; border-left: 1px solid ##CCCCCC; border-right: 1px solid ##CCCCCC; border-bottom: 1px solid ##CCCCCC; height: 200;">
								<tr >
								  <td width="1%" nowrap class = "TituloListas"><div align="center"></div></td>
								  <td nowrap class = "TituloListas"><div align="right">Cierre Manual </div></td>
								  <td nowrap class = "TituloListas"><div align="right">Cierre Autom&aacute;tico </div></td>
								  <td nowrap class = "TituloListas"><div align="right">Diferencia</div></td>
								</tr>			
								<tr >
								  <td width="1%" nowrap class = "TituloListas"><div align="right">Efectivo:</div></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.Efectivo1#" modificable = "false" class="cajasinbordeb" size="16" ></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.BDEfectivo1#" modificable = "false" class="cajasinbordeb" size="16" ></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.Efectivo1div#" modificable = "false" class="cajasinbordeb" size="16" ></td>
								</tr>
								<tr>
								  <td width="1%" nowrap class = "TituloListas"><div align="right">Cheques:</div></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.Cheques#" modificable = "false" class="cajasinbordeb"   size="16" > </td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.BDCheques#" modificable = "false" class="cajasinbordeb"   size="16"> </td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.Chequesdiv#" modificable = "false" class="cajasinbordeb"   size="16"> </td>
								</tr>
								<tr>
								  <td width="1%" nowrap class = "TituloListas"><div align="right">Vouchers:</div></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.Vouchers#" modificable = "false" class="cajasinbordeb"   size="16"> </td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.BDVouchers#" modificable = "false" class="cajasinbordeb"  size="16"> </td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.Vouchersdiv#" modificable = "false" class="cajasinbordeb" size="16"> </td>
								</tr>
								<tr>
								  <td width="1%" nowrap class = "TituloListas"><div align="right">Cartas Promesa: </div></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.CartaPromesa#" modificable = "false" class="cajasinbordeb"  size="16"> </td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.BDCartaPromesa#" modificable = "false" class="cajasinbordeb"  size="16"> </td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.CartaPromesadiv#" modificable = "false" class="cajasinbordeb"  size="16" ></td>
								</tr>
								<tr>
								  <td width="1%" nowrap class = "TituloListas"><div align="right">Dep&oacute;sitos:</div></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.Depositos#" modificable = "false" class="cajasinbordeb"  size="16" > </td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.BDDepositos#" modificable = "false" class="cajasinbordeb"  size="16" > </td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.Depositosdiv#" modificable = "false" class="cajasinbordeb"   size="16"> </td>
								</tr>
								<tr>
								  <td width="1%" nowrap class = "TituloListas"><div align="right">Bonos:</div></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.DocOferta#" modificable = "false" class="cajasinbordeb"   size="16"> </td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.BDDocOferta#" modificable = "false" class="cajasinbordeb"   size="16"> </td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.DocOfertadiv#" modificable = "false" class="cajasinbordeb"   size="16"> </td>
								</tr>
								<tr>
									<td colspan="5" nowrap class = "TituloListas"><div align="right"><hr></div></td>
								</tr>								
								<tr>
								  <td width="1%" nowrap class = "TituloListas"><div align="right"><strong>Total Valores:</strong></div></td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.TotalValores#" modificable = "false" class="cajasinbordeb"   size="16"> </td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.BDTotalValores#" modificable = "false" class="cajasinbordeb"  size="16"> </td>
								  <td nowrap width="1%"><cf_monto  value = "#rs.TotalValoresdiv#" modificable = "false" class="cajasinbordeb"  size="16"> </td>
								</tr>
								<tr>
								  <td>&nbsp;  </td>
								  <td>&nbsp;  </td>
								  <td>&nbsp;  </td>
								  <td>&nbsp;  </td>
								</tr>
								<tr>
								  <td width="1%" nowrap class = "TituloListas"><div align="right"><strong> Sobrante (Faltante):</strong></div></td>
								  <td>&nbsp;  </td>
								  <td nowrap width="1%"><strong><cf_monto  value = "#rs.Faltante#" modificable = "false" class="cajasinbordeb"  size="16"></strong></td>
								  <td>&nbsp;  </td>
								</tr>
								<tr>
								  <td>&nbsp;  </td>
								  <td>&nbsp;  </td>
								  <td>&nbsp;  </td>
								  <td>&nbsp;  </td>
								</tr>
								<tr>
								  <td>&nbsp;  </td>
								  <td>&nbsp;  </td>
								  <td>&nbsp;  </td>
								  <td>&nbsp;  </td>
								</tr>
								<tr>
								  <td>&nbsp;  </td>
								  <td>&nbsp;  </td>
								  <td>&nbsp;  </td>
								  <td>&nbsp;  </td>
								</tr>
								<tr>
								  <td>&nbsp;  </td>
								  <td>&nbsp;  </td>
								  <td>&nbsp;  </td>
								  <td>&nbsp;  </td>
								</tr>
	
																		
							</table>
	
				</td>
			</tr>
		</table>  
	</td>
	</tr>
	</table>
	<cfif isdefined("Url.imprimir")>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td colspan="5">&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="5">&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="5">&nbsp;</td>
		  </tr>
		  <tr>
			<td width="8%">&nbsp;</td>
			<td width="40%" style="border-bottom: 1px solid black;">&nbsp;</td>
			<td width="4%">&nbsp;</td>
			<td width="40%" style="border-bottom: 1px solid black;">&nbsp;</td>
			<td width="8%">&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td>Cajero</td>
			<td>&nbsp;</td>
			<td>Supervisor</td>
			<td>&nbsp;</td>
		  </tr>
		</table>
	</cfif>
</form>
</cfoutput>

<!---
	<cfif isdefined("Url.FAM01COD")>
		 pdf
		<cfdocument format="flashPaper">
			<cfoutput>#micontenido#</cfoutput>
		</cfdocument>
	<cfelse>
			<cfoutput>#micontenido#</cfoutput>
	</cfif> 
--->

<cffunction name="fnProcesaInformacion" access="private" output="no">
	<cfif isdefined("Url.FAM01COD")>
		<cfset Form.FAM01COD = Url.FAM01COD>
	</cfif>
	<cfif isdefined("Url.FechaCierre")>
		<cfset Form.FechaCierre = Url.FechaCierre>
	<cfelse>
		<cfparam name="Form.FechaCierre" default="#LSdateFormat(Now(), 'DD/MM/YYYY')#">
	</cfif>
	<!--- Consultas --->
	<!--- Busca descripciones de Sucursales y Cajas Selecciondas --->
	<cfquery name="rsCaja" datasource="#session.dsn#">
		select FAM01COD, FAM01CODD, FAM01DES, Ocodigo, Ecodigo
		from FAM001
		where FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FAM01COD#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<cfquery name="rsSucursal" datasource="#session.dsn#">
		select Ocodigo, Odescripcion
		from Oficinas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCaja.Ecodigo#">
		  and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCaja.Ocodigo#">
	</cfquery>
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<!--- Invoca Componente que trae los datos del Form --->
	<cfinvoke 
		component="sif.pv.Componentes.pv_FA_Trae_Valores_Cierre"
		method="Cierre" returnvariable="rs">
			<cfinvokeargument name="FAM01COD" 		value="#form.FAM01COD#"/>
			<cfinvokeargument name="FechaCierre"	value="#LsDateFormat(FechaCierre, "DD/MM/YYYY")#">
	</cfinvoke>
</cffunction>