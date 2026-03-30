<!--- 
Creado por Jose Gutierrez 
	13/03/2018
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 				= t.Translate('LB_TituloH','Verificar Productos')>
<cfset TIT_VerificarProductos 	= t.Translate('TIT_VerificarProductos','Verificar Productos')>
<cfset LB_TipoTransaccion		= t.Translate('LB_TipoTransaccion','Tipo de Transacci&oacute;n')>
<cfset LB_NumTarjeta 			= t.Translate('LB_NumTarjeta','N&uacute;mero de Tarjeta')>
<cfset LB_NumFolio				= t.Translate('LB_NumFolio','N&uacute;mero de Folio')>
<cfset LB_CodTiendaExt			= t.Translate('LB_CodTiendaExt','C&oacute;digo de Tienda Externa')>
<cfset LB_CodExtDistribuidor	= t.Translate('LB_CodExtDistribuidor','C&oacute;digo Ext. Distribuidor')>
<cfset LB_Monto 				= t.Translate('LB_Monto', 'Monto')>
<cfset LB_Seleccione 			= t.Translate('LB_Seleccione', 'Seleccione')>
<cfset LB_ValeExterno 			= t.Translate('LB_ValeExterno', 'Vale externo')>
<cfset LB_MsjErrorTar 			= t.Translate('LB_MsjError1', 'Para este tipo de transacci&oacute;n el n&uacute;mero de tarjeta es requerido')>
<cfset LB_MsjErrorVal 			= t.Translate('LB_MsjErrorVal', 'Para este tipo de transacci&oacute;n el n&uacute;mero de folio y C&oacute;digo de tienda son requeridos')>


<!--- Query para obtener los tipos de transaccion que afectan a compras (Combo tipo de transaccion) --->
<cfquery name="rsTipoTransaccion" datasource="#session.DSN#">
	select 
		Codigo, afectaCompras, Codigo + ' ' + Descripcion as tipoTransaccion 
	from CRCTipoTransaccion
	where Ecodigo = #session.Ecodigo#
	and afectaCompras = 1
</cfquery>
 

<cfinclude template="../../../sif/Utiles/sifConcat.cfm">
<form name="form1" action="VerificarProducto_sql.cfm" method="post">
<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr><td colspan="4">&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td width="15%" nowrap><strong>#LB_TipoTransaccion#:&nbsp;</strong></td>
					<td width="10%" nowrap>
					 <select name="tipoTransaccion" id="tipoTransaccion" tabindex="1" onchange=" mostrarFiltro()" >
					 		<option value="">#LB_Seleccione#</option>
						<cfloop query="rsTipoTransaccion"> 
						  	<option value="#Codigo#" 
							  <cfif isdefined("form.tipoTransaccion") and form.tipoTransaccion eq Codigo> selected </cfif>>#rsTipoTransaccion.tipoTransaccion#</option>
						</cfloop>
					  </select>
					</td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr id="filNumTar" style="display: none;">
					<td>&nbsp;</td>
					<td width="15%" nowrap><strong>#LB_NumTarjeta#:&nbsp;</strong></td>
					<td width="10%" nowrap>
						<input type="text" name="numTarjeta" id="numTarjeta" <cfif isDefined('form.numTarjeta')> value="#form.numTarjeta#" </cfif>>
							
					</td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr id="filValExt" style="display: none;">
					<td>&nbsp;</td>
					<td width="15%" nowrap><strong>#LB_ValeExterno#:&nbsp;</strong></td>
					<td width="10%" nowrap>
						<input type="checkbox" name="valeExt" id="valeExt" onchange="validarValeExt()" <cfif isDefined('form.valeExt')> value="#form.valeExt#" </cfif>>
							
					</td>
					<td colspan="3">&nbsp;</td>
				</tr>

				<tr id="filNumFolio" style="display: none;">
					<td>&nbsp;</td>	
					<td width="15%" nowrap><strong>#LB_NumFolio#:</strong></td>
					 <td width="10%" nowrap>
						<input type="text" name="numFolio" id="numFolio" class="numFolio" <cfif isDefined('form.numFolio')> value="#form.numFolio#" </cfif>>
					 </td> 
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr id="filCodTienda" style="display: none;">
					<td>&nbsp;</td>
					<td width="15%" nowrap><strong>#LB_CodTiendaExt#:&nbsp;</strong></td>
					<td width="10%" nowrap>
					<cfset valoresTiendaExt = "">
					<cfif isDefined('form.codTienda')><cfset valoresTiendaExt = "#form.codTienda#,#form.Descripcion#"> </cfif>
						<cf_conlis
							title="#LB_CodTiendaExt#"
							Campos="codTienda, Descripcion"
							values="#valoresTiendaExt#"
							Desplegables="S,S"
							Modificables="S,N"
							Size="10,30"
							tabindex="2"
							Tabla="CRCTiendaExterna"
							Columnas="codigo as codTienda, descripcion as Descripcion"
							form="form1"
							Filtro="Ecodigo = #Session.Ecodigo# and activo = 1 order by Descripcion"
							Desplegar="codTienda, Descripcion"
							Etiquetas="Codigo Tienda, Descripcion"
							filtrar_por="Codigo, Descripcion"
							Formatos="S,S"
							Align="left, left"
							Asignar="codTienda, Descripcion"
							Asignarformatos="S,S"/>
						<!--- <input type="text" name="codTienda" id="codTienda" > --->
					</td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr id="filCodExtDis" style="display: none;">
					<td>&nbsp;</td>
					<td width="15%" nowrap><strong>#LB_CodExtDistribuidor#:&nbsp;</strong></td>
					<td width="10%" nowrap>
						<input type="text" name="codExtDis" id="codExtDis" <cfif isDefined('form.codExtDis')> value="#form.codExtDis#" </cfif>>
					</td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr id="filMonto"  style="display: none;">
					<td>&nbsp;</td>
					<td width="15%" nowrap><strong>#LB_Monto#:&nbsp;</strong></td>
					<td width="10%" nowrap>
						<input type="text" name="monto" id="monto" onkeypress="return soloNumeros(event)" <cfif isDefined('form.monto')> value="#form.monto#" </cfif>>
					</td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td width="15%"></td>
					<td align="right">
						<table>
							<tr>
								<td>
									<input type="submit" class="btnGuardar" name="verificarProducto" id="verificarProducto" value="Verificar" onclick="validar()">
								</td>
								<td>
									<!---<cf_botones values="Limpiar" names="Limpiar"  tabindex="1">--->
									<input type="button" name="limpiar" class="btnLimpiar" value="Limpiar" onclick="javascript:location.href='verificarProducto.cfm';" tabindex="2">
									
								</td>
							</tr>
						</table>
					</td>
					<td colspan="3">&nbsp;</td>
				</tr>
				</div>
				<tr>
					<td>&nbsp;</td>
					<td width="15%"></td>
					<td align="right" ><label id = "mensaje"></label></td>
					<td colspan="3">&nbsp;</td>
				</tr>
			</table>
			</fieldset>
		</td>	
	</tr>
</table>

</form>		

<script type="text/javascript">
	window.onload=mostrarFiltro;
	function soloNumeros(e) {
	    var keynum = window.event ? window.event.keyCode : e.which;
		if ((keynum == 8) || (keynum == 46))
	        return true; 
	        return /\d/.test(String.fromCharCode(keynum));
	}

	//Funcion para validar el tipo de transaccion que es y en base a este pedir valores 
	function validar(){
		
		mostrarFiltro();
		var tipoTransaccion = document.getElementById('tipoTransaccion').value;
		var numTarjeta = document.getElementById('numTarjeta').value;
		var numFolio = document.getElementById('numFolio').value;

		document.form1.numTarjeta.required=false;
		document.form1.numFolio.required=false;

		if ((tipoTransaccion == 'TC' || tipoTransaccion == 'TM') && numTarjeta == '' ) {
			document.getElementById('mensaje').innerHTML = '#LB_MsjErrorTar#' ;
			document.getElementById('mensaje').style.color="##FF0000";
			document.form1.numTarjeta.required=true;
			document.form1.numFolio.required=false;

		}
		else if(tipoTransaccion == 'VC' && (numFolio == '' || codTienda == '')){
			document.getElementById('mensaje').innerHTML = '#LB_MsjErrorVal#' ;
			document.getElementById('mensaje').style.color="##FF0000";
			document.form1.numFolio.required=true;
			document.form1.numTarjeta.required=false;
		}

	}

	//Funcion para mostrar filtros de acuerdo a tipo de transaccion
	function mostrarFiltro(){
		var tipoTransaccion = document.getElementById('tipoTransaccion').value;

		if (tipoTransaccion == 'Seleccione'){

			document.getElementById('filNumFolio').style.display = 'none';
			document.getElementById('filCodTienda').style.display = 'none';
			document.getElementById('filNumTar').style.display = 'none';
			document.getElementById('filCodExtDis').style.display = 'none';
			document.getElementById('filMonto').style.display = 'none';
			document.getElementById('filValExt').style.display = 'none';

		}else if(tipoTransaccion == 'VC'){

			document.getElementById('filNumFolio').style.display = '';
			document.getElementById('filNumTar').style.display = 'none';
			document.getElementById('filMonto').style.display = '';
			document.getElementById('filValExt').style.display = '';


		}else if (tipoTransaccion == 'TC' || tipoTransaccion == 'TM'){

			document.getElementById('filNumFolio').style.display = 'none';
			document.getElementById('filCodTienda').style.display = 'none';
			document.getElementById('filNumTar').style.display = '';
			document.getElementById('filCodExtDis').style.display = 'none';
			document.getElementById('filMonto').style.display = '';
			document.getElementById('filValExt').style.display = 'none';
		}

	}
	//Funcion para mostrar inputs de codigo de tienda externa y codigo de distribuidor externo si el vale a verificar es externo
	function validarValeExt(){
		var valeExt = document.form1.valeExt.checked;

		if (valeExt) {
			document.getElementById('filCodTienda').style.display = '';
			document.getElementById('filCodExtDis').style.display = '';
		}else {
			document.getElementById('filCodTienda').style.display = 'none';
			document.getElementById('filCodExtDis').style.display = 'none';
		}
	}
	function limpiar(){
		document.getElementById('tipoTransaccion').value = 'Seleccione';
		mostrarFiltro();
	}
</script>
</cfoutput>


