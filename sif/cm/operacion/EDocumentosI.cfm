<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<cfset modo  = 'ALTA'>
<cfset dmodo = 'ALTA'>
<cfif isdefined("form.EDIid") and len(trim(form.EDIid))>
	<cfset modo = 'CAMBIO'>
	<cfif isdefined("form.DDlinea") and len(trim(form.DDlinea))>
		<cfset dmodo = 'CAMBIO'>
	</cfif>
</cfif>
<cfif isdefined("form.EPDid_DP") and Len(Trim(form.EPDid_DP)) NEQ 0>
	<cfset Regresar="/cfmx/sif/cm/operacion/EDocumentos-lista.cfm?EPDid=#form.EPDid_DP#">
</cfif>

<cf_templateheader title="	Compras">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Registro de Transacciones'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<form action="EDocumentosI-sql.cfm" method = "post" name = "form1" onSubmit="javascript: return valida();" >
				<tr><td>
					<table width="99%" cellpadding="0" cellspacing="0" align="center">
						<tr><td class="subTitulo" align="center"><font size="2">Encabezado de Transacciones</font></td></tr>
						<tr><td align="center"><cfinclude template="EDocumentosI-form.cfm"></td></tr>
						<tr><td>&nbsp;</td></tr>						
						<!-- Caso 1: Alta de Encabezados -->
						<cfif modo EQ 'ALTA'>
                            <tr>
                                <td align="center">
                                    <input type="submit" name="btnAgregarE" value="Agregar" tabindex="10">
                                    <input type="reset"  name="btnLimpiar"  value="Limpiar" tabindex="11">
                                    <input type="button" name="btnAtras"    value="Lista" 	tabindex="13" onClick="javascript: atras();" alt="Lista de Transacciones">
                                </td>	
                            </tr>
                        </cfif>
						<!-- Caso 2: Cambio de Encabezados / Alta de detalles -->
						<cfif modo neq 'ALTA'>
                            <tr>
                                <td align="center" valign="baseline" colspan="8">	
                                	<cfif rsForm.EDIestado EQ 0><!---►Digitación--->						
                                        <input type="submit" class="btnGuardar"  name="btnModificar" tabindex="10" value="Modificar">
                                        <input type="submit" class="btnAplicar"  name="btnAplicar" 	 tabindex="11" value="Aplicar" 		  onClick="javascript: validar=false; return true;">
                                        <input type="submit" class="btnEliminar" name="btnBorrarE" 	 tabindex="12" value="Borrar Factura" onClick="javascript:if ( confirm('Desea eliminar el Documento?') ){validar=false; return true;} return false;" >
                                    </cfif>
                                    <cfif rsForm.EDIestado EQ 10><!---►Aplicadas--->
                                    	<input type="submit" class="btnEliminar" name="btnReversar"  tabindex="13" value="Reversar Factura" onclick="return confirm('Desea reversar el Documento?');">
                                    </cfif>
                                        <input type="submit" class="btnNuevo"    name="btnNuevoE" 	 tabindex="13" value="Nueva Factura">
                                        <input type="button" class="btnAnterior" name="btnAtras" 	 tabindex="13" value="Lista" onClick="javascript: atras();" alt="Lista de Transacciones">
                                </td>	
                            </tr>
						</cfif>
						</table>	
					</td></tr>
					<tr><td colspan="2">&nbsp;</td></tr>						
				</form>
				<cfif modo neq "ALTA">
					<tr><td>&nbsp;</td></tr>
					<tr><td class="subTitulo" align="center"><font size="2">Detalle de Transacciones</font></td></tr>
					<tr><td><cfinclude template="EDocumentosI-Det-form.cfm"></td></tr>
					<tr><td><cfinclude template="EDocumentosI_listaDet.cfm"></td></tr>								
				</cfif>	
				<tr><td>&nbsp;</td></tr>
			</table>
		  
		<script language="javascript1.2" type="text/javascript">
			var validar = true;
			function atras(){
				<cfif isdefined("form.EPDid_DP") and Len(Trim(form.EPDid_DP)) NEQ 0>
				location.href="EDocumentos-lista.cfm?EPDid=" + <cfoutput>#form.EPDid_DP#</cfoutput>;
				<cfelse>
				location.href="EDocumentos-lista.cfm";
				</cfif>
			}
			function valida(){			
				document.form1.EDItc.disabled = false;
				if (validar){				
					var error = false;
					var mensaje = "Se presentaron los siguientes errores:\n";
					// Validacion de Encabezado	
					if ( trim(document.form1.Ddocumento.value) == '' ){
						error = true;
						mensaje += " - El campo Código es requerido.\n";
					}
					
					if ( trim(document.form1.Mcodigo.value) == '' ){
						error = true;
						mensaje += " - El campo Moneda es requerido.\n";
					}

					if ( trim(document.form1.EDItc.value) == '' ){
						error = true;
						mensaje += " - El campo Tipo de Cambio es requerido.\n";
					}

					if ( new Number(qf(document.form1.EDItc.value)) == 0 ){
						error = true;
						mensaje += " - El campo Tipo de Cambio debe ser mayor que cero.\n";
					}
					
					if ( trim(document.form1.SNcodigo.value) == '' ){						
						error = true;
						mensaje += " - El campo Socio de Negocio es requerido.\n";
					}					

					if ( trim(document.form1.CPcodigo.value) == '' ){
						error = true;
						mensaje += " - El campo Tipo de Transacción es requerido.\n";
					}

					if ( trim(document.form1.EDIfecha.value) == '' ){
						error = true;
						mensaje += " - El campo Fecha del Documento es requerido.\n";
					}
					if ( '<cfoutput>#modo#</cfoutput>' == 'ALTA' && document.form1.EDItipo.value == 'N' && trim(document.form1.EDIidref.value) == '' ){
						error = true;
						mensaje += " - El campo factura de referencia del Documento es requerido.\n";
					}

					if (error){
						alert(mensaje);
						return false;
					}else{
						fm(document.form1.EDItc, 2);
						document.form1.EDItc.value = qf(document.form1.EDItc.value);
						document.form1.EDItc.disabled = false;						
						return true;
					}
				}else{
					return true;
				}	
			}
		</script>	
	<cf_web_portlet_end>
<cf_templatefooter>