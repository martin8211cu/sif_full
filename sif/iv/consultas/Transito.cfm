<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_InventarioTransito"
	Default="Inventario en Tránsito"
	returnvariable="LB_InventarioTransito"/>
	
<cf_dbfunction name="to_char" args="Aid" returnvariable = "Aid">
<cfquery datasource="#session.DSN#" name="rsArticulos">
	select #PreserveSingleQuotes(Aid)#,Acodigo,Acodalterno, Adescripcion
		from Articulos 
	where Ecodigo = #session.Ecodigo#
</cfquery> 	


	
		
	
<script language="JavaScript">
	// ===========================================================================================
	//								Conlis de Articulos
	// ===========================================================================================
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis(id, desc) {
		popUpWindow("ConlisArticulosTransito.cfm?form=consulta&id=" + id + "&desc=" + desc ,250,200,650,350);
	}
	// ===========================================================================================
	function valida() {
			if (document.consulta.Aid.value != '') 
				return true;					
			else {
				alert('Debe seleccionar un artículo');
				return false;					
			}
		}
</script>

<cf_templateheader title="#LB_InventarioTransito#">
	<cfinclude template="../../portlets/pNavegacionIV.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_InventarioTransito#">
			<form action="SQLTransito.cfm" method="post" name="consulta">
				<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
					<tr><td colspan="4">&nbsp;</td></tr>
					<!--- Almacen --->
					<tr> 
						<td width="40%" align="right" valign="baseline">
							Art&iacute;culo Inicial:&nbsp;
						</td>
						<td valign="baseline" nowrap> 
							<input name="Adescripcion" disabled type="text" value="" size="50" maxlength="80" alt="Artículo"> 
							<a href="#"><img src="../../imagenes/Description.gif" alt="Lista de Art&iacute;culos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlis('Aid', 'Adescripcion');"> 
							</a> <input type="hidden" name="Aid" value="" >&nbsp;&nbsp;&nbsp; 
						</td>
						<td width="40%" align="right" valign="baseline">
							Art&iacute;culo Final:&nbsp;
						</td>
						<td valign="baseline" nowrap> 
							<input name="AdescripcionF" disabled type="text" value="" size="50" maxlength="80" alt="Artículo"> 
							<a href="#"><img src="../../imagenes/Description.gif" alt="Lista de Art&iacute;culos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlis('AidF', 'AdescripcionF');"> 
							</a> <input type="hidden" name="AidF" value="" >&nbsp;&nbsp;&nbsp; 
						</td>
					</tr>
					<tr>
						<td align="right" valign="baseline" nowrap>
							Fecha inicial del embarque:&nbsp;
						</td>
						<td valign="baseline" nowrap>
							<cf_sifcalendario name="fecha1" form="consulta"> 
						</td>
						<td align="right" valign="baseline" nowrap>
							Fecha final del embarque:&nbsp;
						</td>
						<td valign="baseline" nowrap> 
							<cf_sifcalendario name="fecha2" form="consulta"> 
						</td>
					</tr>
					<tr>
						<td align="right" valign="baseline" nowrap>
							Mostrar solo Pendientes: &nbsp;
						</td>
						<td valign="baseline" nowrap>
							<input type="checkbox" name="ckPend" value="checkbox"  <cfif isdefined('form.ckPend')>checked</cfif>>
						</td>
						<td align="right" valign="baseline" nowrap>
							<input type="checkbox" name="toExcel"/> 
						</td>
						<td valign="baseline" nowrap>
							<cf_translate  key="LB_ExpotarAExcel">Exportar a Excel</cf_translate>
						</td>
					</tr>
					<tr><!--- Articulo --->
						<td colspan="4">&nbsp;</td>
					</tr>
					<tr> 
					<td colspan="4" align="center"> 
						<input name="btnConsultar" type="submit" value="Consultar">
						<input type="reset" name="Reset" value="Limpiar"> </td>
					</tr>
				</table>
			</form>
	<cf_web_portlet_end>	
<cf_templatefooter>