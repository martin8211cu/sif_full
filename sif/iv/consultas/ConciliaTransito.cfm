<!-- InstanceBegin template="/Templates/LMenu03.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		<!-- InstanceBeginEditable name="titulo" --> 
			Inventarios
		<!-- InstanceEndEditable -->">
	
		
		<br>
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td width="1%" valign="top">
					<!-- InstanceBeginEditable name="menu" -->
						<cfinclude template="/sif/menu.cfm">
					<!-- InstanceEndEditable -->
				</td>
			
				<td valign="top">
					<!-- InstanceBeginEditable name="mantenimiento" -->	
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Conciliación de Artículos contra terceros'>
			<cfif isdefined('Url.ETid') and ltrim(rtrim(Url.ETid)) NEQ 0 and not isdefined("form.ETid")>
				<cfset form.ERtid = Url.ETid>
			</cfif>
			<form action="ConciliaTransito-SQL.cfm" method="post" name="consulta">
				<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
					<tr><td><cfinclude template="../../portlets/pNavegacionIV.cfm"></td></tr>
					<tr>
						<td> 
						<table width="80%" border="0" cellpadding="0" cellspacing="0" align="center">
						<tr>
							<td colspan="4">
							   <cfif isdefined ("Url.noHayTransforma") and Url.noHayTransforma EQ 1>
									No puede realizar el proceso de Conciliación , hasta que realice la carga de productos para su transformación.
									<a href="/cfmx/sif/iv/operacion/Transformacion.cfm?regresar=/cfmx/sif/iv/consultas/ConciliaTransito.cfm?noHayTransforma=0"><font color="#0000CC"><strong>pulse aquí</strong></font></a> para realizar la carga de productos de Transformación.
							   </cfif>
							</td>
						</tr>
						
						<tr>
							<td align="right" valign="baseline" nowrap>Mostrar solo productos con Diferencias: &nbsp;</td>
							<td valign="baseline" nowrap><input type="checkbox" name="ckPend" value="checkbox"  <cfif isdefined('form.ckPend')>checked</cfif>></td>
							<td align="right" valign="baseline" nowrap>&nbsp; </td>
							<td valign="baseline" nowrap>&nbsp;</td>
						</tr>
						<tr> 
							<td colspan="4">&nbsp;</td>
						</tr>
                      <tr> 
                        <!---<td colspan="4" align="center"> <input name="btnConsultar" type="submit" value="Consultar" onClick="javascript: return valida();"> --->
						<td colspan="4" align="center"> <input name="btnConsultar" type="submit" value="Consultar">
                         <!---  <input type="reset" name="Reset" value="Limpiar"> ---> 
						 	<cfoutput>
						 	<input name="ETid" type="hidden" value="<cfif isdefined("Form.ETid")>#Form.ETid#</cfif>">
							</cfoutput>
						 </td>
                    </table>
					</td></tr>
				</table>
			</form>
		
            	
		<cf_web_portlet_end>
	<!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	<cf_templatefooter><!-- InstanceEnd -->