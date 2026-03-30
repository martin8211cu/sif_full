<cfinvoke key="LB_Codigo" default="C&oacute;digo"  returnvariable="LB_Codigo" component="sif.Componentes.Translate"  method="Translate" />	
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n"  returnvariable="LB_Descripcion" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke key="LB_ListaDeGruposDeNivel" default="Lista de Grupos de Nivel"  returnvariable="LB_ListaDeGruposDeNivel" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke key="BTN_Nuevo" default="Nuevo"  returnvariable="BTN_Nuevo" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke key="MSG_EstaSeguroQueDeseaEliminarElComportamiento" default="Esta seguro que desea eliminar el comportamiento?"  returnvariable="MSG_EliminarComp" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke key="LB_NoSeEncontraronRegistros" default="No se encontraron registros"  returnvariable="LB_NoSeEncontraronRegistros" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke key="MSG_ElValorDelPesoNoPuedeSerCero" default="El valor del peso no puede ser cero"  returnvariable="MSG_PesoCero" component="sif.Componentes.Translate"  method="Translate" />

<cfquery name="rsComportamientos" datasource="#session.DSN#">
	select a.RHCOid, a.RHCOcodigo, a.RHCOdescripcion,RHCOpeso
	from RHComportamiento a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and a.RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHid#">
</cfquery>

<cfoutput>

<table width="95%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td>
			<fieldset><legend><cf_translate key="LB_ComportamientosDeLaHabilidad">Comportamientos de la Habilidad</cf_translate></legend>
			<table width="95%" border="0"> 
				<tr> 
					<td align="right" class="fileLabel">#LB_CODIGO#:</td>
					<td>
						<input name="RHCOcodigo" type="text" id="RHCOcodigo" size="10" maxlength="10" value="" onfocus="this.select();">
					</td>
				</tr>	
				<tr> 
					<td align="right" class="fileLabel" valign="top">#LB_DESCRIPCION#:</td>
					<td>
						<textarea name="RHCOdescripcion" id="RHCOdescripcion" cols="50" rows="7"></textarea>				
					</td>
				</tr>	
				<tr>
					<td align="right" class="fileLabel">#LB_Peso#:</td>
					<td>
						<input name="RHCOpeso" type="text" id="RHCOpeso" value=""  size="6" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2); funcValidaCero(this.value); "  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;"/>
					</td>
				</tr>
				<tr>
					<td align="right" class="fileLabel">#LB_GrupoDeNiveles#:</td>
					<td>
						<cf_conlis title="#LB_ListaDeGruposDeNivel#"
								campos = "RHGNid,RHGNcodigo,RHGNdescripcion" 
								desplegables = "N,S,S" 
								modificables = "N,S,N" 
								size = "0,10,20"
								asignar="RHGNid,RHGNcodigo,RHGNdescripcion"
								asignarformatos="I,S,S"
								tabla="	RHGrupoNivel a"																	
								columnas="a.RHGNid,a.RHGNcodigo,a.RHGNdescripcion"
								filtro="a.Ecodigo =#session.Ecodigo#"
								desplegar="RHGNcodigo,RHGNdescripcion"
								etiquetas="	#LB_CODIGO#, 
											#LB_DESCRIPCION#"
								formatos="S,S"
								align="left,left"
								showEmptyListMsg="true"
								debug="false"
								form="form1"
								width="800"
								height="500"
								left="70"
								top="20"
								filtrar_por="RHGNcodigo,RHGNdescripcion">
					</td>
				</tr>	
				<tr><td>&nbsp;</td></tr>					
				<tr>
					<td colspan="2" align="center">
						<table align="center">
							<tr>
								<td align="center" id="agregarc"><input type="submit" name="btn_AgregarComp" id="btn_AgregarComp" value="#BTN_Agregar#" onClick="javascript: return funcAgregarComp();"></td>
								<td align="center" id="modificarc" style="display:none;"><input type="submit" name="btn_ModificarComp" id="btn_ModificarComp" value="#BTN_Modificar#" onClick="javascript: return funcAgregarComp();"></td>
								<td align="center" id="nuevoc" style="display:none;"><input type="button" name="btn_NuevoComp" id="btn_NuevoComp" value="#BTN_Nuevo#" onClick="javascript: funcNuevoComp();"></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>					
					<td colspan="2" align="center">		
						<div style="overflow:auto; height:140; width:400; margin:0;">										 
							 <table width="80%" border="0" align="center" cellpadding="0" cellspacing="0">
								<tr class="listaPar">
									<td width="40%"><b>#LB_CODIGO#</b></td>
									<td width="10%"><b>#LB_Peso#</b></td>
									<td width="5%">&nbsp;</td>
									<td width="5%">&nbsp;</td>
								</tr>
								<cfif rsComportamientos.RecordCount NEQ 0>
									<cfloop query="rsComportamientos">
										<tr <cfif rsComportamientos.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
											<td width="40%">#rsComportamientos.RHCOcodigo#</td>
											<td width="10%">#LSNumberFormat(rsComportamientos.RHCOpeso,'999.99')#</td>
											<td width="5%" style="cursor:pointer;" align="right">
												<img src="/cfmx/rh/imagenes/Borrar01_S.gif" onClick="javascript: funcBorrarComp('#rsComportamientos.RHCOid#');" >
											</td>
											<td width="5%" style="cursor:pointer;" align="right">
												<img src="/cfmx/rh/imagenes/edit_o.gif" onClick="javascript: funcDetalleComp('#rsComportamientos.RHCOid#');">
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
	<input type="hidden" name="borrarComp" value="">
	<input type="hidden" name="RHCOid" value="">
	<iframe id="detallecomp" width="0" height="0" style="visibility:hidden;"></iframe>
</table>
<script type="text/javascript">
	function funcBorrarComp(prn_llave){
		if(confirm('#MSG_EliminarComp#')){
			document.form1.borrarComp.value = prn_llave;
			document.form1.submit();
		}
	}
	function funcDetalleComp(prn_llave){
		document.getElementById("agregarc").style.display = 'none';
		document.getElementById("modificarc").style.display = '';
		document.getElementById("nuevoc").style.display = '';		
		document.getElementById("detallecomp").src="frm_cargacomportamiento.cfm?RHCOid="+prn_llave;		
	}
	function funcNuevoComp(){
		document.form1.RHCOcodigo.value = '';
		document.form1.RHCOdescripcion.value = '';
		document.form1.RHCOpeso.value = 0;
		document.form1.RHGNid.value = '';
		document.form1.RHGNcodigo.value = '';
		document.form1.RHGNdescripcion.value = '';
		document.getElementById("agregarc").style.display = '';
		document.getElementById("modificarc").style.display = 'none';
		document.getElementById("nuevoc").style.display = 'none';	
	}
	
	function funcAgregarComp(){
		if (funcValidaCero(document.form1.RHCOpeso.value)){
			habilitarValidacionComp();
		}
		else{
			return false;
		}
		
	}	
	function funcValidaCero(prn_valor){
		if (parseFloat(prn_valor) <= 0){
			alert('#MSG_PesoCero#');
			return false;
		}
		else{
			return true;
		}
	}
</script>
</cfoutput>