<cfif ef_modo neq 'ALTA' and df_modo neq 'ALTA' >
	<cfquery name="rsdForm" datasource="#session.DSN#">
		select a.DFElinea, a.DFEetiqueta, a.DFEfuente, DFEnegrita, DFEitalica, DFEsubrayado, DFEtamfuente, DFEcolor, DFEcaptura, ECEid, a.ts_rversion
		from DFormatosExpediente a
			inner join EFormatosExpediente b 
				on a.EFEid = b.EFEid
		where b.TEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TEid#">
		  and a.EFEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EFEid#">
		  and a.DFElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DFElinea#">
	</cfquery>
</cfif>

<script language="JavaScript1.2" type="text/javascript">

	function traercolor( obj, tabla, color ){
		if ( trim(color) == '' ){
			color = '000000';
		}		

		if ( trim(color) != '' && color.length == 6 ){
			var tablita = document.getElementById("colorBox");
			tablita.bgColor = "#" + color;
			document.form2.DFEcolor.value = color;
		}
	}

	function mostrarpaleta(){
	// RESULTADO
	// Muestra una paleta de colores.
		window.open("/cfmx/sif/ad/catalogos/color.cfm?obj=DFEcolor&tabla=colorBox","Paleta",'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,height=60,width=308,left=375, top=250');
	}

	function d_validacion(valor){
		objForm2.DFEetiqueta.required    = valor;
	}
	
</script>

<style type="text/css">
	.cuadro{
		border: 1px solid #999999;
	}
</style>

<form name="form2" method="post"  action="SQLDFormatosExpediente.cfm" >
	<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td>&nbsp;</td>
				<td align="center">
					<cfoutput>
					<table width="100%" cellpadding="2" cellspacing="0" border="0" >

						<!--- descripcion --->
						<tr>
							<td align="right" width="8%" nowrap><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
							<td colspan="5" >
								<input type="text" name="DFEetiqueta" size="75" maxlength="255" tabindex="1"
									value="<cfif df_modo neq 'ALTA'>#rsdForm.DFEetiqueta#</cfif>" >
							</td>
						</tr>
						
						<!--- Fuente, Negrita --->
						<tr>
							<td align="right" nowrap><cf_translate key="LB_Fuente">Fuente</cf_translate>:&nbsp;</td>
							<td colspan="2">
								<select name="DFEfuente" tabindex="1">
									<option value="Arial" <cfif df_modo neq 'ALTA' and rsdForm.DFEfuente eq 'Arial'>selected</cfif>><cf_translate key="LB_Arial">Arial</cf_translate></option>
									<option value="Courier" <cfif df_modo neq 'ALTA' and rsdForm.DFEfuente eq 'Courier'>selected</cfif> ><cf_translate key="LB_Courier">Courier</cf_translate></option>
									<option value="sans-serif" <cfif df_modo neq 'ALTA' and rsdForm.DFEfuente eq 'sans-serif'>selected</cfif>><cf_translate key="LB_sans-serif">sans-serif</cf_translate></option>
								</select>	
							</td>
							<td>&nbsp;</td>
							<td align="right" nowrap width="2%">
								<input type="checkbox" name="DFEnegrita" tabindex="1"
									<cfif df_modo neq 'ALTA' and rsdForm.DFEnegrita eq 1 >checked</cfif> ></td>
							<td align="left" width="52%"><b><cf_translate key="CHK_Negrita">Negrita</cf_translate></b></td>
							<td width="13%" >&nbsp;</td>
						</tr>
	
						<!--- Alineacion, Subrayado --->
						<tr>
							<td align="right" nowrap><cf_translate key="LB_Tamano">Tama&ntilde;o</cf_translate>:&nbsp;</td>
							<td colspan="2">
								<select name="DFEtamfuente" tabindex="1">
									<option value="6" <cfif df_modo neq 'ALTA' and rsdForm.DFEtamfuente eq 6>selected</cfif> >6</option>
									<option value="8" <cfif df_modo neq 'ALTA' and rsdForm.DFEtamfuente eq 8>selected</cfif> >8</option>
									<option value="9" <cfif df_modo neq 'ALTA' and rsdForm.DFEtamfuente eq 9>selected</cfif> >9</option>
									<option value="10" <cfif df_modo neq 'ALTA' and rsdForm.DFEtamfuente eq 10>selected</cfif> >10</option>
									<option value="11" <cfif df_modo neq 'ALTA' and rsdForm.DFEtamfuente eq 11>selected</cfif> >11</option>
									<option value="12" <cfif df_modo neq 'ALTA' and rsdForm.DFEtamfuente eq 12>selected</cfif> >12</option>
									<option value="14" <cfif df_modo neq 'ALTA' and rsdForm.DFEtamfuente eq 14>selected</cfif> >14</option>
									<option value="16" <cfif df_modo neq 'ALTA' and rsdForm.DFEtamfuente eq 16>selected</cfif> >16</option>
								</select>	
							</td>
							<td></td>
							<td align="right" nowrap width="2%">
								<input type="checkbox" name="DFEsubrayado" tabindex="1"
									<cfif df_modo neq 'ALTA' and rsdForm.DFEsubrayado eq 1 >checked</cfif> >
							</td>
							<td align="left" width="52%"><u><cf_translate key="CHK_Subrayado">Subrayado</cf_translate></u></td>
							<td>&nbsp;</td>
						</tr>
	
						<!--- Color, Italica --->
						<tr>
							<td align="right" nowrap><cf_translate key="LB_Color">Color</cf_translate>:&nbsp;</td>
							<td width="6%" nowrap>
								<input type="text" size="10" maxlength="6" name="DFEcolor" tabindex="1"
									value="<cfif df_modo neq 'ALTA'>#Trim(rsdForm.DFEcolor)#<cfelse>000000</cfif>" onblur="javascript:traercolor('FMT02CLR', 'colorBox', document.form2.DFEcolor.value )" style="text-transform: uppercase;" onFocus="javascript:this.select();" alt="El Color">
							</td>
							<td width="8%">
								<table id="colorBox" width="18" border="0" cellpadding="0" cellspacing="0" bgcolor="##000000" class="cuadro">
									<tr>
										<td align="center" valign="middle" style="color: ##FFFFFF;cursor:hand;">
											<a href="javascript:mostrarpaleta()" style="text-decoration:none;">
												<font size="1">&nbsp;&nbsp;&nbsp;&nbsp;</font>
											</a>
										</td>
									</tr>
								</table>
							</td>											
							<!--- Tabla para color --->
							<td width="11%">&nbsp;</td>
							<script language="JavaScript1.2" type="text/javascript">traercolor( 'DFEcolor', 'colorBox', document.form2.DFEcolor.value );</script>
							<td align="right" nowrap width="2%">
								<input type="checkbox" name="DFEitalica" tabindex="1"
									<cfif df_modo neq 'ALTA' and rsdForm.DFEitalica eq 1 >checked</cfif> >
							</td>
							<td align="left" width="52%"><i><cf_translate key="CHK_Italica">It&aacute;lica</cf_translate></i></td>
							<td>&nbsp;</td>
						</tr>
						
						<tr>
							<td align="right"><cf_translate key="LB_Capturar">Capturar</cf_translate>:&nbsp;</td>
							<td>
								<select name="DFEcaptura" onchange="javascript: mostrar_concepto(this);">
									<option value="0" <cfif isdefined("rsdForm.DFEcaptura") and rsdForm.DFEcaptura eq 0>selected</cfif> >Observaci&oacute;n</option>
									<option value="1" <cfif isdefined("rsdForm.DFEcaptura") and rsdForm.DFEcaptura eq 1>selected</cfif> >Concepto</option>
									<option value="2" <cfif isdefined("rsdForm.DFEcaptura") and rsdForm.DFEcaptura eq 2>selected</cfif> >Ambos</option>
								</select>
							</td>
						</tr>

						<cfquery name="rs_conceptos" datasource="#session.DSN#">
							select ECEid, ECEcodigo, ECEdescripcion
							from EConceptosExpediente
							where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
							order by ECEcodigo
						</cfquery>
						<tr id="tr_concepto" <cfif isdefined("rsdForm.DFEcaptura") and len(trim(rsdForm.DFEcaptura)) and rsdForm.DFEcaptura neq 0 >style="display: ;"<cfelse>style="display: none;"</cfif> >
							<td align="right"><cf_translate key="LB_Concepto">Concepto</cf_translate>:&nbsp;</td>
							<td colspan="6">
								<select name="ECEid">
									<option value="" >-<cf_translate xmlfile="/rh/generales.xml" key="LB_Seleccionar">Seleccionar</cf_translate> -</option>
									<cfloop query="rs_conceptos">
										<option value="#rs_conceptos.ECEid#" <cfif isdefined("rsdForm.ECEid") and rsdForm.ECEid eq rs_conceptos.ECEid>selected</cfif> >#trim(rs_conceptos.ECEcodigo)# - #rs_conceptos.ECEdescripcion#</option>
									</cfloop>
								</select>
							</td>
						</tr>	

						<cfset dts = "">	
						<cfif df_modo neq "ALTA">
							<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="dts">
								<cfinvokeargument name="arTimeStamp" value="#rsdForm.ts_rversion#"/>
							</cfinvoke>
						</cfif>
						<tr>
							<input name="TEid"   type="hidden" value="<cfif isdefined("form.TEid")>#form.TEid#</cfif>" tabindex="-1">
							<input name="EFEid"  type="hidden" value="<cfif isdefined("form.EFEid")>#form.EFEid#</cfif>" tabindex="-1">
							<input type="hidden" name="DFElinea" value="<cfif df_modo neq 'ALTA'>#rsdForm.DFElinea#</cfif>"  tabindex="-1">
							<input type="hidden" name="dtimestamp" value="<cfif df_modo NEQ 'ALTA'>#dts#</cfif>" tabindex="-1">
						</tr>

					</table>
					</cfoutput>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		<!--- Detalle --->			

		<!-- ============================================================================================================ -->
		<!--  											Botones													          -->
		<!-- ============================================================================================================ -->		

		<!-- Caso 1: Alta de Encabezados -->
		<tr><td><input type="hidden" name="botonSel" value=""></td></tr>
		<cfif df_modo EQ 'ALTA'>
			<tr>
				<td align="center" valign="baseline" colspan="6">
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Agregar"
					Default="Agregar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Agregar"/>
				
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Limpiar"
					Default="Limpiar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Limpiar"/>
					<cfoutput>
					<input type="submit" name="AltaD" tabindex="1" value="#BTN_Agregar#" onClick="javascript: setBtn(this);" >
					<input type="reset"  name="LimpiarD" tabindex="1"  value="#BTN_Limpiar#" >
					</cfoutput>	
				</td>	
			</tr>
		<cfelse>
			<tr>
				<td align="center" valign="baseline" colspan="6">
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Modificar"
					Default="Modificar"
					XmlFile="/rh/generales.xml"
					returnvariable="LB_btnModificar"/>
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Eliminar"
					Default="Eliminar"
					XmlFile="/rh/generales.xml"
					returnvariable="LB_btnEliminar"/>
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MGS_DeseaElimarElDetalleDeFormato"
					Default="Desea eliminar el Detalle de Formato?"
					returnvariable="MGS_DeseaEliminarElDetalleFormato"/>
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Nuevo"
					Default="Nuevo"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Nuevo"/>
					<cfoutput>
					<input type="submit" name="CambioD" value="#BTN_Modificar#" tabindex="1" onClick="javascript: setBtn(this);" >
					<input type="submit" name="BajaD"   value="#BTN_Eliminar#" tabindex="1"  onClick="javascript: if (confirm('#MGS_DeseaEliminarElDetalleFormato#')){ setBtn(this); d_validacion(false); return true; } else{ return false; } " >
					<input type="submit" name="NuevoD"  value="#BTN_Nuevo#" tabindex="1"      onClick="javascript: setBtn(this); d_validacion(false);" >
					</cfoutput>
				</td>	
			</tr>
		</cfif>

	</table>
</form>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Etiqueta"
	Default="Etiqueta"
	returnvariable="MSG_Etiqueta"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Concepto"
	Default="Concepto"
	xmlfile='/rh/generales.xml'
	returnvariable="MSG_Concepto"/>


<script language="JavaScript1.2" type="text/javascript">
	//instancias de qforms
	objForm2 = new qForm("form2");
<cfoutput>	

	objForm2.DFEetiqueta.required   = true;
	objForm2.DFEetiqueta.description = '#MSG_Etiqueta#';
</cfoutput>

function mostrar_concepto(obj){
	if (obj.value == 0 ){
		document.getElementById('tr_concepto').style.display = 'none';
		objForm2.ECEid.required   = false;
	}
	else{
		document.getElementById('tr_concepto').style.display = '';
		objForm2.ECEid.required   = true;
		objForm2.ECEid.description = '<cfoutput>#MSG_Concepto#</cfoutput>';
	}
}




</script>