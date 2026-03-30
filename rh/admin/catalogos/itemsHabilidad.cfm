<cfinvoke key="LB_Orden" default="Orden"  returnvariable="LB_Orden" component="sif.Componentes.Translate"  method="Translate" />	
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n"  returnvariable="LB_Descripcion" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke key="LB_ListaDeGruposDeNivel" default="Lista de Grupos de Nivel"  returnvariable="LB_ListaDeGruposDeNivel" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke key="BTN_Nuevo" default="Nuevo"  returnvariable="BTN_Nuevo" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke key="MSG_EstaSeguroQueDeseaEliminarElComportamiento" default="Esta seguro que desea eliminar el ítem?"  returnvariable="MSG_EliminarComp" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke key="LB_NoSeEncontraronRegistros" default="No se encontraron registros"  returnvariable="LB_NoSeEncontraronRegistros" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke key="MSG_ElValorDelPesoNoPuedeSerCero" default="El valor del peso no puede ser cero"  returnvariable="MSG_PesoCero" component="sif.Componentes.Translate"  method="Translate" />

<cfquery name="rsItems" datasource="#session.DSN#">
	select a.RHIHid, a.RHIHorden, a.RHIHdescripcion,
	case 
		when #preservesinglequotes(RHIHdescripcion_length)# > 40 
			then #preservesinglequotes(RHIHdescripcion_sPart)# #_CAT# '...'
			else RHIHdescripcion end RHIHdescripcionshort
	from RHIHabilidad a
	where a.RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHid#">
</cfquery>

<cfoutput>

<table width="95%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td>
			<fieldset><legend><cf_translate key="LB_ItemsporHabilidad">Items por Habilidad</cf_translate></legend>
			<table width="95%" border="0"> 
				<tr> 
					<td align="right" class="fileLabel">#LB_CODIGO#:</td>
					<td>
						<input name="RHIHorden" type="text" id="RHIHorden" tabindex="1" size="10" maxlength="10" value="" onfocus="this.select();">
					</td>
				</tr>	
				<tr> 
					<td align="right" class="fileLabel" valign="top">#LB_DESCRIPCION#:</td>
					<td>
						<textarea name="RHIHdescripcion" tabindex="1" id="RHIHdescripcion" cols="50" rows="7"></textarea>				
					</td>
				</tr>	
				<tr><td>&nbsp;</td></tr>					
				<tr>
					<td colspan="2" align="center">
						<table align="center">
							<tr>
								<td align="center" id="agregari"><input type="submit" name="btn_AgregarItem" id="btn_AgregarItem" value="#BTN_Agregar#" onClick="javascript: return funcAgregarItem();"></td>
								<td align="center" id="modificari" style="display:none;"><input type="submit" name="btn_ModificarItem" id="btn_ModificarItem" value="#BTN_Modificar#" onClick="javascript: return funcAgregarItem();"></td>
								<td align="center" id="nuevoi" style="display:none;"><input type="button" name="btn_NuevoItem" id="btn_NuevoItem" value="#BTN_Nuevo#" onClick="javascript: funcNuevoItem();"></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>					
					<td colspan="2" align="center">		
						<div style="overflow:auto; height:140; width:400; margin:0;">										 
							 <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
								<tr class="listaPar">
									<td width="40%"><b>#LB_Orden#</b></td>
									<td width="10%"><b>#LB_Descripcion#</b></td>
									<td width="5%">&nbsp;</td>
									<td width="5%">&nbsp;</td>
								</tr>
								<cfif rsItems.RecordCount NEQ 0>
									<cfloop query="rsItems">
										<tr <cfif rsItems.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
											<td width="40%">#rsItems.RHIHorden#</td>
											<td width="10%">#rsItems.RHIHdescripcionshort#</td>
											<td width="5%" style="cursor:pointer;" align="right">
												<img src="/cfmx/rh/imagenes/Borrar01_S.gif" onClick="javascript: funcBorrarItem('#rsItems.RHIHid#');" >
											</td>
											<td width="5%" style="cursor:pointer;" align="right">
												<img src="/cfmx/rh/imagenes/edit_o.gif" onClick="javascript: funcdetalleitem('#rsItems.RHIHid#');">
											</td>
										</tr>
									</cfloop>
								<cfelse>
									<tr><td colspan="4" align="center">----- <b>#LB_NoSeEncontraronRegistros#</b> -----</td></tr>
								</cfif>
							</table>
						</div>
					</td>					
				</tr>
			</table>
			</fieldset>
		</td>
	</tr>
	<input type="hidden" name="borrarItem" value="">
	<input type="hidden" name="RHIHid" value="">
	<iframe id="detalleitem" width="0" height="0" style="visibility:hidden;" ></iframe>
</table>
<script type="text/javascript">
	function funcBorrarItem(prn_llave){
		if(confirm('#MSG_EliminarComp#')){
			document.form1.borrarItem.value = prn_llave;
			document.form1.submit();
		}
	}
	function funcdetalleitem(prn_llave){
		document.getElementById("agregari").style.display = 'none';
		document.getElementById("modificari").style.display = '';
		document.getElementById("nuevoi").style.display = '';
		document.getElementById("detalleitem").src="frm_cargaitem.cfm?RHIHid="+prn_llave;		
	}
	function funcNuevoItem(){
		document.form1.RHIHorden.value = '';
		document.form1.RHIHdescripcion.value = '';
		document.form1.RHCOpeso.value = 0;
		document.form1.RHGNid.value = '';
		document.form1.RHGNcodigo.value = '';
		document.form1.RHGNdescripcion.value = '';
		document.getElementById("agregari").style.display = '';
		document.getElementById("modificari").style.display = 'none';
		document.getElementById("nuevoi").style.display = 'none';	
	}
	
	function funcAgregarItem(){
			habilitarValidacionDet();
	}	
</script>
</cfoutput>