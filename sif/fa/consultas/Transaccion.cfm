<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cfoutput>#Request.Translate('ModuloFA','Facturación','/sif/Utiles/Generales.xml')#</cfoutput>
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
		            <cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#Request.Translate('TituloPortlet','Consulta de una Transacción')#">
	
			<script language="JavaScript">
			
				// ===========================================================================================
				//								Conlis de Transacciones de Facturación
				// ===========================================================================================
				
				var popUpWin=0;
				
				function popUpWindow(URLStr, left, top, width, height){
				  if(popUpWin) {
					if(!popUpWin.closed) popUpWin.close();
				  }
				  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				}
			
				function doConlis(id, desc, caja) {
					popUpWindow("ConlisTransacciones.cfm?form=consulta&id=" + id + "&desc=" + desc + "&caja=" + caja,250,200,750,350);
				}
				// ===========================================================================================
			
			</script>
			
			<!--- Cajas --->
			<cfquery name="rsCajas" datasource="#Session.DSN#">
				select convert(varchar,FCid) as FCid, FCcodigo from FCajas 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">				
			</cfquery>
			
			<cfset sql = "SQLTransaccion.cfm">			
			<form action="<cfoutput>#sql#</cfoutput>" method="post" name="consulta">
				<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
					<tr><td><cfinclude template="../../portlets/pNavegacionFA.cfm"></td></tr>
				
					<tr><td> 
						<table width="80%" border="0" cellpadding="0" cellspacing="0" align="center">
                      <!--- Transacción --->
                      <tr>
                        <td align="right" valign="baseline">Caja:</td>
                        <td valign="baseline" nowrap>
						<select name="FCid">
							<cfoutput query="rsCajas">
							<option value="#FCid#">#FCcodigo#</option>
							</cfoutput>
						</select></td>
                      </tr>
                      <tr> 
                        <td width="40%" align="right" valign="baseline">Transacci&oacute;n:&nbsp;</td>
                        <td valign="baseline" nowrap> <input name="ETobs" disabled type="text" value="" size="50" maxlength="80" alt="Transacción"> 
                          <a href="#"><img src="../../imagenes/Description.gif" alt="Lista de Transacciones" name="imagen" width="18" height="14" border="0" align="absmiddle" 
							onClick="javascript:doConlis('ETnumero', 'ETobs', document.consulta.FCid.value);"> 
                          </a> <input type="hidden" name="ETnumero" value="" > 
                          &nbsp;&nbsp;&nbsp; </td>
                      </tr>
                      <!--- Transacción --->
                      <tr> 
                        <td colspan="2">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="2" align="center"> <input name="btnConsultar_" type="submit" value="Consultar" onClick="javascript: return valida();"> 
                        </td>
                    </table>
					</td></tr>
				</table>
			</form>
			<script language="JavaScript1.2">
				function valida() {

					if (document.consulta.FCid.value == '') {
						alert('Debe seleccionar una caja');
						return false;					
					}

					if (document.consulta.ETnumero.value == '') {
						alert('Debe seleccionar una transacción');
						return false;					
					}
					return true;
				}
			</script>
		   
            	
		            </cf_web_portlet>
				</td>	
			</tr>
		</table>	
</cf_templatearea>
</cf_template>