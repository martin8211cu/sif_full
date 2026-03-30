<cf_templateheader title="Ordenes de compra proveedores del exterior">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Ordenes de compra proveedores del exterior'>
		<script language="JavaScript" src="/cfmx/sif/js/utilesMonto.js" type="text/javascript"></script>		
		<cfoutput>
		<form method="get" name="form1" action="OrdenesCompraExterior-rep.cfm" onSubmit="javascript: return FC_Verifica()"> 
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td colspan="2"><cfinclude template="/sif/portlets/pNavegacion.cfm"></td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				
				<tr>
					<td width="30%" valign="top">
						<table width="100%">
							<tr valign="top">
								<td valign="top">	
									<cf_web_portlet_start border="true" titulo="Consulta de Seguimiento de Tracking" skin="info1">
										<div align="justify">
										  <p>Este reporte contiene la información de las Órdenes de Compra del Proveedor Extranjero.</p>
								    </div>
									<cf_web_portlet_end>
								</td>
							</tr>
						</table>  
					</td>
					<td width="57%" valign="top">
						<table width="98%" cellpadding="0" cellspacing="0" align="center">
							<tr>
								<td width="48%" align="center" nowrap><div align="right"><strong>N° Orden:</strong>&nbsp; </div></td>
								<td width="52%"><input name="EOnumero" value="" size="15"
													onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
													onFocus="javascript:this.select();" 
													onChange="javascript:fm(this,0);" 								
												>
								</td>
								<!----<td width="11%" align="center" nowrap><div align="right"><strong>Hasta:</strong>&nbsp; </div></td>--->
								<!---<td width="47%"><input name="EOnumeroH" value="" size="15"></td>---->
							</tr>
							<td align="right" nowrap><strong>&nbsp;Formato:</strong>&nbsp;</td>
							  	<td colspan="3" nowrap>
                                    <select name="formato">
                                      <option value="html">En línea (HTML)</option>
                                      <option value="pdf">Adobe PDF</option>
                                      <option value="fla">Flashpaper</option>
                                    </select>
                              </td>
							<tr>
								<td align="center" colspan="2">&nbsp;</td>
							</tr>
							<tr>
							  <td colspan="2" align="center"><input type="submit" value="Generar" name="Generar" id="Generar">
							    <input type="reset" name="Limpiar" value="Limpiar"></td>
								</tr>
						</table>
					</td>
				</tr>
			</table>
		 </form>
		 </cfoutput>
		 <script language="javascript1.2" type="text/javascript">
		 	function FC_Verifica (){
				if (document.form1.EOnumero.value == ''){
					alert('Debe digitar el número de orden');
					return false;
				}
				else
					return true;					
			}
		 
		 </script>
		<cf_web_portlet_end>
	<cf_templatefooter>

