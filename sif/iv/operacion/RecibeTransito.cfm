<cf_templateheader title="Inventarios">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Recepción de Productos en Tránsito">
	<table width="100%" border="0" cellspacing="1" cellpadding="1">
	  <tr>
		<td valign="top" width="35%">
			<!--- Lista de Encabezado --->
			<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="ERecibeTransito"/>				
				<cfinvokeargument name="columnas" value="ERTid, ERTdocref, ERTobservacion, ERTfecha,Usucodigo"/>
				<cfinvokeargument name="desplegar" value="ERTdocref, ERTfecha"/>
				<cfinvokeargument name="etiquetas" value="Documento, Fecha"/>
				<cfinvokeargument name="formatos" value="S,D"/>
				<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# and ERTaplicado = 0"/>
				<cfinvokeargument name="align" value="left, left"/>
				<cfinvokeargument name="ajustar" value="S"/>
				<cfinvokeargument name="checkboxes" value="N"/>				
				<cfinvokeargument name="irA" value="RecibeTransito.cfm"/>
				<cfinvokeargument name="keys" value="ERTid"/>
				<cfinvokeargument name="showEmptyListMsg" value="true">
				<cfinvokeargument name="maxrows" value="0"/>				
			</cfinvoke>
		</td>
		<td>
			<cfinclude template="formRecibeTransito.cfm">
		</td>
	  </tr>
	<tr>
		<td>&nbsp;</td>
		<td>
			<!--- Lista del Detalle --->
			<cfif isdefined("form.ERTid") and len(trim(form.ERTid)) gt 0 and isDefined("Form.modo") and Form.modo NEQ "ALTA">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Líneas">
				<form name="listaDet" method="post">				
				<table border="0" width="100%">
				  <tr> 
					<td><strong><input name="chkTodos" type="checkbox" value="" border="1" onClick="javascript:Marcar(this);">
					  &nbsp;Seleccionar Todos&nbsp;
					<input type="submit" name="btnBorrarSel" class="btnEliminar" value="Eliminar Seleccionados" onClick="javascript: borrarSel();" >
					<input type="hidden" name="ERTid_" 		 value="<cfoutput>#Form.ERTid#</cfoutput>"></strong></td>
				  </tr>		
					<tr><td>
					 <cf_dbfunction name="length"	args="rtrim(a.Adescripcion)" returnvariable="lenAdescripcion">
					<cf_dbfunction name="string_part" args="a.Adescripcion,1,32" returnvariable ="Adescripcion"> 
					<cf_dbfunction name="concat" args="#preservesinglequotes(Adescripcion)#+'...'"  returnvariable="Adescripcion2" delimiters = "+">
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">							
						<cfinvokeargument name="tabla" value="DRecibeTransito d, ERecibeTransito e, Articulos a"/>
						<cfinvokeargument name="columnas" value="e.ERTid, 
												d.DRTlinea, d.Tid, 
												d.Alm_Aid, d.DRTcantidad, 
												d.Aid, d.DRTfecha, d.Ddocumento, d.DRTcostoU, 
												d.Ucodigo, d.Kunidades, d.Kcosto, d.DRTembarque, coalesce(d.DRTgananciaperdida,0.00) as DRTgananciaperdida,
												
												case when #lenAdescripcion# >= 35 then #preservesinglequotes(Adescripcion2)#
													 when #lenAdescripcion# < 35 then a.Adescripcion end as Adescripcion,
								 
													  DRTlinea as checked"/>
						<cfinvokeargument name="desplegar" value="Adescripcion,Ddocumento,DRTembarque,DRTcantidad,DRTcostoU"/>
						<cfinvokeargument name="etiquetas" value="Artículo,Documento,Embarque,Cantidad,Costo Unit."/>
						<cfinvokeargument name="formatos" value="V,V,V,I,M"/>
						<cfinvokeargument name="filtro" value="d.ERTid = e.ERTid and e.Ecodigo=#session.Ecodigo# and e.ERTid=#Form.ERTid#
												and e.Ecodigo = a.Ecodigo and d.Aid = a.Aid"/>
						<cfinvokeargument name="align" value="left,left,left,right,right"/>
						<cfinvokeargument name="ajustar" value="S"/>
						<cfinvokeargument name="irA" value="RecibeTransito.cfm"/>
						<cfinvokeargument name="formName" value="listaDet"/>
						<cfinvokeargument name="keys" value="ERTid,DRTlinea,Tid,DRTcantidad,DRTgananciaperdida"/>
						<cfinvokeargument name="showEmptyListMsg" value="true">
						<cfinvokeargument name="checkboxes" value="S">
						<cfinvokeargument name="checkedcol" value="checked">
						<cfinvokeargument name="incluyeForm" value="false">
						<cfinvokeargument name="maxrows" value="0"/>
					</cfinvoke>
				
				 <script language="JavaScript">
					function borrarSel() {
						document.listaDet.action = "SQLRecibeTransito.cfm";
					}
					
					function Marcar(c) {
						var f = document.listaDet;
						if (f.chk != null) { //existe?
							if (f.chk.value != null) {// solo un check
								if (c.checked) f.chk.checked = true; else f.chk.checked = false;
							}
							else {
								if (c.checked) {
									for (var counter = 0; counter < f.chk.length; counter++)
									{
										if ((!f.chk[counter].checked) && (!f.chk[counter].disabled))
											{  f.chk[counter].checked = true;}
									}
									if ((counter==0)  && (!f.chk.disabled)) {
										f.chk.checked = true;
									}
								}
								else {
									for (var counter = 0; counter < f.chk.length; counter++)
									{
										if ((f.chk[counter].checked) && (!f.chk[counter].disabled))
											{  f.chk[counter].checked = false;}
									};
									if ((counter==0) && (!f.chk.disabled)) {
										f.chk.checked = false;
									}
								};
							}
						}
					}
										
				</script>				
					</td></tr>			
				</table>
				</form>
				<cf_web_portlet_end>
			</cfif>
		</td>
	</tr>
	</table>	
		  <cf_web_portlet_end>	
<cf_templatefooter>