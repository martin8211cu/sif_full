			<table width="100%" align="center">
			</table>					
			<table width="100%" border="0" cellspacing="1" cellpadding="1">
			  <tr>
					<td valign="top">
					<cfinvoke 
					 component="sif.Componentes.pListas"
					 method="pListaRH"
					 returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="RH_OtrosPatronos"/>
						<cfinvokeargument name="columnas" value="OPid, OPcodigo, OPdescripcion"/>
						<cfinvokeargument name="desplegar" value="OPcodigo, OPdescripcion"/>
						<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
						<cfinvokeargument name="formatos" value="S,S"/>
						<cfinvokeargument name="filtro" value="Ecodigo= #session.Ecodigo# order by OPcodigo, OPdescripcion"/>
						<cfinvokeargument name="mostrar_filtro" value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="filtrar_por" value="OPcodigo, OPdescripcion, ''"/>
						<cfinvokeargument name="align" value="N,N"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="keys" value="OPid"/>
						<cfinvokeargument name="irA" value=""/>
						<cfinvokeargument name="maxrows" value="15"/>
					</cfinvoke>		
					</td>
				
				<td valign="top">

				<cfif isdefined("Form.Cambio")>
					<cfset modo="CAMBIO">
				<cfelse>
					<cfif not isdefined("Form.modo")>
						<cfset modo="ALTA">
					<cfelseif Form.modo EQ "CAMBIO">
						<cfset modo="CAMBIO">
					<cfelse>
						<cfset modo="ALTA">
					</cfif>
				</cfif>
				
				<cfif modo NEQ "ALTA">
					<cfquery name="rsForm" datasource="#Session.DSN#">
						select OPid, OPcodigo, OPdescripcion
						from RH_OtrosPatronos
						where OPid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OPid#">
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
					</cfquery>
				</cfif>
				
				<script language="JavaScript" src="/cfmx/sif/js/utilesMonto.js">//</script>
				<script language="JavaScript1.2">
					function valida() {
						var f = document.form1;		
						if (trim(f.PCEMcodigo.value) == '') {
							alert('¡Debe digitar el codigo!');
							f.PCEMcodigo.focus();
							return false;
						}
						if (trim(f.PCEMdesc.value) == '') {
							alert('¡Debe digitar la descripción!');
							f.PCEMdesc.focus();
							return false;
						}
						if ((f.PCEMformato) && (trim(f.PCEMformato.value) == '')) {
							alert('¡Debe digitar el formato!');
							f.PCEMformato.focus();
							return false;
						}		
						return true;
					}	
				</script>
				
				<form name="form1"  method="post" action="MantOtrosPatronosSQL.cfm" onSubmit="javascript: if (this.botonSel.value != 'Baja' && this.botonSel.value != 'Nuevo') return valida(); else return true;" style="margin:0;">
				<cfoutput>
				<table width="100%" border="0" cellspacing="1" cellpadding="1">

				  <tr>
					<td><div align="right">C&oacute;digo:</div></td>
					<td><input name="OPcodigo" tabindex="1" type="text" value="<cfif modo NEQ 'ALTA'>#rsForm.OPcodigo#</cfif>" size="10" maxlength="10" <cfif modo NEQ 'ALTA'>readonly="true"</cfif>></td>
					<cfif modo NEQ 'ALTA'><input name="OPid" type="hidden" value="#rsForm.OPid#" ></cfif>
				  </tr>
				  <tr>
					<td><div align="right">Descripci&oacute;n:</div></td>
					<td><input name="OPdescripcion" type="text" tabindex="1" value="<cfif modo NEQ 'ALTA'>#rsForm.OPdescripcion#</cfif>" size="60" maxlength="80"></td>
				  </tr>
				  </tr>
				  <tr>
					<td colspan="2"><div align="center">
								
				
				<script language="JavaScript" type="text/javascript">
					// Funciones para Manejo de Botones
					botonActual = "";
				
					function setBtn(obj) {
						botonActual = obj.name;
					}
					function btnSelected(name, f) {
						if (f != null) {
							return (f["botonSel"].value == name)
						} else {
							return (botonActual == name)
						}
					}
				</script>
				<cfif not isdefined('modo')>
					<cfset modo = "ALTA">
				</cfif>
				
					<input type="hidden" name="botonSel" value="" tabindex="-1">
					<input type="text"	 name="txtEnterSI"  size="1" maxlength="1" tabindex="-1" readonly="true" class="cajasinbordeb">
				<cfif modo EQ "ALTA">
					<input type="submit" name="Alta"    class="btnGuardar" 	value="Agregar" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name">
					<input type="reset"  name="Limpiar" class="btnLimpiar"	value="Limpiar" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name">
				<cfelse>
					<input type="submit" name="Cambio"  class="btnGuardar" 	value="Modificar" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion(); ">
					<input type="submit" name="Baja"    class="btnEliminar" value="Eliminar" tabindex="1" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Desea eliminar este Patrono?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
					<input type="submit" name="Nuevo" 	class="btnNuevo" 	value="Nuevo" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
				</cfif>
					
					</td>
					</tr>
				</table>
				</cfoutput>
				</form>
			  </tr>
			  
		</table>
