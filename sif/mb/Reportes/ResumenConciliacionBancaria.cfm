<!---------
	Creado por: Gustavo Fonseca H.
	Fecha de modificación: 10-11-2005
	Motivo:	Nuevo reporte "resumen de conciliación Bancaria."
----------->
<cf_templateheader title="Bancos">
			
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte de Conciliaci&oacute;n Bancaria'>
					<cfquery name="rsEstados" datasource="#session.DSN#">
						select *
						from ECuentaBancaria ec
							inner join CuentasBancos cb
								on ec.CBid=cb.CBid
						where cb.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                        and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
						and EChistorico='S'
					</cfquery>	

					<script language="JavaScript1.2">
					
						function validar(form){
							<cfif rsEstados.RecordCount gt 0 >
								return true;
							<cfelse>	
								alert('No existen Estados de Cuenta para consultar')
								return false;
							</cfif>	
						}	
						
						function limpiar(obj){
							var form = obj.form
							form.ECdescripcion.value = "";
							form.ECid.value          = "";
						}
						
						// ===========================================================================================
						//								Conlis de Estados de Cuenta
						// ===========================================================================================
						var popUpWin=0;
						function popUpWindow(URLStr, left, top, width, height){
						  if(popUpWin) {
							if(!popUpWin.closed) popUpWin.close();
						  }
						  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
						}
					
						function doConlis() {
							popUpWindow("ConlisEstadoCuenta.cfm?form=form1&id=ECid&desc=ECdescripcion",250,200,650,350);
						}
						// ===========================================================================================
					
					</script>

					<form action="SQLConciliacion.cfm" name="form1" method="post" onSubmit="javascript: return validar(this);">
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td colspan="2">
									<cfinclude  template="../../portlets/pNavegacionMB.cfm">
								</td>
							</tr>	
							
							<tr><td>&nbsp;</td></tr>
		
							<tr>
								<td align="right" nowrap width="40%">Estado de Cuenta:&nbsp;</td>
								<td>
									<input name="ECdescripcion" type="text" value="" size="50" maxlength="50" disabled="true">
									<a href="##">
										<img src="../../imagenes/Description.gif" alt="Lista de Estados de Cuenta" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlis();">
									</a> 
								</td>
		
							<tr><td><input type="hidden" name="ECid" value=""></td></tr>
							<tr><td>&nbsp;</td></tr>
			
							<tr>
								<td colspan="2" align="center">
									<input type="submit" name="btnConsultar" value="Consultar">
									<input type="button" name="btnLimpiar"   value="Limpiar" onClick="javascript:limpiar(this);">
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
						</table>
					</form>            	
		            <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>
