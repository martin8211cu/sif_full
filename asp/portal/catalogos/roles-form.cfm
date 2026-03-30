<cfset modo = "ALTA">
<cfif isdefined("Form.SScodigo") and isdefined("Form.SRcodigo")>
	<cfset modo = "CAMBIO">
</cfif>

<!--- Sistemas Existentes --->
<cfquery name="rsSistemas" datasource="asp">
	select SScodigo, 
	{fn concat({fn concat(rtrim(SScodigo), ' - ')}, SSdescripcion)}   as SSdescripcion
	from SSistemas
	order by SScodigo, SSdescripcion
</cfquery>

<!--- roles que ya existen --->
<cfquery name="rsCodigos" datasource="asp">
	select SScodigo, SRcodigo
	from SRoles
	<cfif modo neq 'ALTA'>
		where SRcodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="#form.SRcodigo#">
	</cfif>
	order by SScodigo, SRcodigo
</cfquery>

<cfif modo EQ "CAMBIO">
	<cfquery name="rsData" datasource="asp">
		select 	a.SScodigo, 
				<!---rtrim(a.SScodigo) || ' - ' || a.SSdescripcion as Sistema,--->
				{fn concat({fn concat(rtrim(a.SScodigo), ' - ')}, a.SSdescripcion)} as Sistema,
			   	b.SRcodigo, b.SRdescripcion, SRinterno
		from SSistemas a, SRoles b
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
		and b.SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SRcodigo#">
		and a.SScodigo = b.SScodigo
		order by a.SScodigo, a.SSdescripcion, b.SRcodigo, b.SRdescripcion
	</cfquery>

	<!--- Averiguar si un rol puede ser borrado --->
	<cfquery name="rsDependencias1" datasource="asp">
		select count(1) as cant from SProcesosRol
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
		and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SRcodigo#">
	</cfquery>

	<cfquery name="rsDependencias2" datasource="asp">
		select count(1) as cant from UsuarioRol
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
		and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SRcodigo#">
	</cfquery>

</cfif>

<script src="/cfmx/sif/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script type="text/javascript" language="javascript1.2">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>

<cfoutput>
<form name="form1" action="roles-sql.cfm" method="post">
	<cfif isdefined("form.PageNum")>
		<input type="hidden" name="Pagina" value="#Form.PageNum#">
	</cfif>
	<cfif isdefined("form.fSScodigo")>
		<input type="hidden" name="fSScodigo" value="#form.fSScodigo#">
	</cfif>
	<cfif isdefined("form.fSRcodigo")>
		<input type="hidden" name="fSRcodigo" value="#form.fSRcodigo#">
	</cfif>
	<cfif isdefined("form.fSRdescripcion")>
		<input type="hidden" name="fSRdescripcion" value="#form.fSRdescripcion#">
	</cfif>

	<table width="90%"  border="0" cellspacing="0" cellpadding="2">
	  <tr>
	    <td align="right" nowrap class="etiquetaCampo">Sistema:</td>
	    <td align="left" nowrap colspan="2">
			<cfif modo EQ "CAMBIO">
				#rsData.Sistema#
				<input name="SScodigo" type="hidden" id="SScodigo" value="#rsData.SScodigo#">
			<cfelse>
				<select name="SScodigo" id="SScodigo">
				<cfloop query="rsSistemas">
					<option value="#SScodigo#" <cfif isdefined("form.SScodigo") and trim(form.SScodigo) eq rsSistemas.SScodigo>selected</cfif>  >#SSdescripcion#</option>
				</cfloop>
				</select>
		</cfif>
		</td>
      </tr>
	  <tr>
		<td align="right" nowrap class="etiquetaCampo">Grupo:</td>
		<td align="left" nowrap colspan="2">
			<cfif modo EQ "CAMBIO">
				<input name="SRcodigo" type="hidden" id="SRcodigo" value="#rsData.SRcodigo#">
			</cfif>
			<input name="SRcodigo_text" type="text" id="SRcodigo_text"  value="<cfif modo neq 'ALTA'>#rsData.SRcodigo#</cfif>"size="20" maxlength="10" onBlur="codigos(this);" onFocus="this.select();">
		</td>
	  </tr>
	  <tr>
		<td align="right" nowrap class="etiquetaCampo">Descripci&oacute;n: </td>
		<td align="left" nowrap colspan="2">
			<input name="SRdescripcion" type="text" id="SRdescripcion" value="<cfif modo EQ 'CAMBIO'>#rsData.SRdescripcion#</cfif>" onFocus="this.select();" size="50" maxlength="80">
		</td>
	  </tr>

	  <tr>
	    <td>&nbsp;</td>
        <td><table border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td valign="top"><input style="border:0;" type="checkbox" id="SRinterno" name="SRinterno" value="" <cfif modo neq 'ALTA' and rsData.SRinterno eq 1 >checked</cfif>></td>
            <td valign="top"><div align="justify">
                <label for="SRinterno"><strong>Uso interno</strong>. Seleccione esta opci&oacute;n para  que el rol no aparezca en la lista de los roles asignables a los usuarios empresariales.</label>
            </div></td>
          </tr>
        </table></td>
	  </tr>
	  <tr>
	    <td colspan="2">
        	<cfif modo EQ "CAMBIO">
            	<!--- Para saber que borrar --->
				<input type="hidden" name="procesos_borrar" value="">
            	<table border="0" width="100%" cellpadding="0" cellspacing="0" >
                    <tr><td colspan="2">&nbsp;</td></tr>
                    <tr class="areaFiltro"><td class="label" colspan="2">Procesos Asignados</td></tr>
                    <!--- include de Procesos o Roles --->
                    <tr class="tituloLista" >
                        <td class="label"><b>M&oacute;dulo</b></td>
                        <td class="label"><b>Proceso</b></td>
                    </tr>
                
                    <cfquery name="rsModulo" datasource="asp">
                    	select a.SScodigo, a.SMcodigo, a.SMdescripcion
                        from SModulos a
                        where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
                        order by a.SMdescripcion
                    </cfquery>

                    <cfloop query="rsModulo">
                    	<cfset Modulo = rsModulo.SMcodigo>
	                    <cfset Sistema = rsModulo.SScodigo>
                    	<cfquery name="rsProcesos" datasource="asp">
                            select a.SScodigo, a.SMcodigo, a.SPcodigo, a.SPdescripcion,
                            	b.SRcodigo
                            from SProcesos a 
                                left outer join SProcesosRol b
                                on a.SScodigo 	= b.SScodigo
                                and a.SPcodigo 	= b.SPcodigo
                                and a.SMcodigo = b.SMcodigo
                                and b.SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SRcodigo#">
                            where 1=1
                            and a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsModulo.SScodigo#">
                            and a.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsModulo.SMcodigo#">
                            and a.SPanonimo=0
                            and a.SPpublico=0
                            --and a.SPinterno=0							
                        </cfquery>
                        <tr>
                            <td colspan="2" class="label" nowrap>
                                <table width="100%" border="0">
                                    <tr>
                                        <td width="1%">
                                            <cfif rsProcesos.RecordCount gt 0>
                                            <img name="mas" src="../imagenes/mas.gif" style="cursor:hand; " border="0" onClick="javascript:imagen(this,'#sistema#','#modulo#')" alt="Mostrar los procesos asociados a este Módulo.">
                                            <cfelse>
                                            <img name="nada" src="../imagenes/menos.gif" style="cursor:hand; " border="0"  alt="Módulo no tiene porcesos asignados.">
                                            </cfif>
                                        </td>
                                        <td width="1%">
                                            <cfif rsProcesos.RecordCount gt 0>
                                            	<input style="border:0;" name="modulo" id="#sistema#|#modulo#" type="checkbox" value="#(form.SRcodigo)#|#(form.SScodigo)#|#(rsProcesos.SMcodigo)#" onClick="javascript:check(this, '#sistema#', '#modulo#', '#rsProcesos.RecordCount#'); borrar(this);">
                                            <cfelse>
                                            	<input style="border:0;" disabled name="blanco" type="checkbox" >
                                            </cfif>
                                        </td>
                                        <td nowrap>
                                            #rsModulo.SMdescripcion#
                                        </td>
                                        <cfif rsProcesos.RecordCount gt 0>
                                            <tr>
                                                <td colspan="2">&nbsp;</td>
                                                <td width="75%">
                                                    <div style="display:none;" id="#sistema#|#modulo#|div">
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    
                                                        <cfloop query="rsProcesos">
                                                            <cfset id = "#(rsProcesos.SScodigo)#|#(rsProcesos.SMcodigo)#|#rsProcesos.CurrentRow#" >
                                                            <tr ><td class="label" nowrap><input style="border:0;" onClick="javascript:check_sistema(this, '#sistema#','#modulo#', '#rsProcesos.RecordCount#'); borrar(this);" name="permisos" id="#(rsProcesos.SScodigo)#|#(rsProcesos.SMcodigo)#|#rsProcesos.CurrentRow#" type="checkbox" <cfif len(trim(rsProcesos.SRcodigo)) gt 0>checked</cfif> value="#(form.SRcodigo)#|#(form.SScodigo)#|#(rsProcesos.SMcodigo)#|#(rsProcesos.SPcodigo)#">#rsProcesos.SPdescripcion#</td></tr>
                                                        </cfloop>
                    
                                                    </table>
                                                    </div>
                                                </td>
                                            </tr>						
                                            
                                            <cfif rsProcesos.RecordCount gt 0>
                                                <script language="javascript1.2" type="text/javascript">
													var id = '#id#';
                                                    var obj = document.getElementById(id);
													check_sistema_inicio(obj, '#sistema#','#modulo#', '#rsProcesos.RecordCount#');
													function check_sistema_inicio(obj, sistema, modulo, cantidad){
														// nada que ver con esta funcion pero se pone aqui
														//borrar(obj);
												
														var objeto = sistema + '|' + modulo;		// check de modulo
														
														if (obj.checked){
															// VERIFICA LOS DEMAS OBJETOS PARA ESA EMPRESA Y MODULO ACTUAL
															for ( var i=1; i<=cantidad; i++ ){
																var objeto2 = sistema + '|' + modulo + '|' + i;		// check de procesos
																if (!document.getElementById(objeto2).checked){
																	return;
																}
															}	
															document.getElementById(objeto).checked = true;
														}
														else{
															document.getElementById(objeto).checked = false;
														}
													}
                                                </script>
                                            </cfif>
                    
                                        <cfelse>
                                            <tr><td colspan="2">&nbsp;</td><td align="left"><i>No se han definido Procesos para este M&oacute;dulo</i></td></tr>
                                        </cfif>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </cfloop>
                </table>
            <cfelse>
            	&nbsp;
            </cfif>
        </td>
      </tr>
	  <tr>
	    <td colspan="3" align="center">
			<cfif modo EQ "CAMBIO">
				<input type="submit" name="btnCambiar" value="Guardar">
				<cfif rsDependencias1.cant EQ 0 and rsDependencias2.cant EQ 0>
				<input type="submit" name="btnEliminar" value="Eliminar" onClick="javascript: if (confirm('¿Está seguro de que desea eliminar este rol?')) { deshabilitarValidacion(); return true; } else return false;">
				</cfif>
				<input type="submit" name="btnNuevo" value="Nuevo">
				<input type="submit" name="btnProcesos" value="Procesos" onClick="javascript: deshabilitarValidacion(); ">
			<cfelse>
				<input type="submit" name="btnAgregar" value="Agregar">
			</cfif>
		</td>
      </tr>
	<cfif MODO NEQ "ALTA">
		<tr>
		<td colspan="3">
		<BR><BR>
		<cfinclude template="roles-SRolMenu.cfm">
		</td>
		</tr>
	</cfif>
	</table>
</form>
</cfoutput>

<script language="JavaScript1.2" type="text/javascript">

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	<cfif modo EQ "ALTA">
	objForm.SScodigo.required = true;
	objForm.SScodigo.description = "Sistema";
	</cfif>
	objForm.SRcodigo_text.required = true;
	objForm.SRcodigo_text.description = "Grupo";
	objForm.SRdescripcion.required = true;
	objForm.SRdescripcion.description = "Descripción";

	function deshabilitarValidacion() {
		objForm.SRdescripcion.required = false;
	}
	
	function codigos(obj){
		if (obj.value != "") {
			var dato    = obj.value + '|' + document.form1.SScodigo.value;
			var temp    = new String();
	
			<cfloop query="rsCodigos">
				temp = '<cfoutput>#rsCodigos.SRcodigo#|#rsCodigos.SScodigo#</cfoutput>';
				if (dato.toUpperCase() == temp.toUpperCase()){
					alert('El código de grupo ya existe.');
					obj.value = "";
					obj.focus();
					return false;
				}
			</cfloop>
		}	
		return true;
	}
	
	function imagen(obj, sistema, modulo){
		if (obj.name == 'mas'){
			obj.name = 'menos';
			obj.src = '../imagenes/menos.gif';
			prueba(sistema,modulo, '');
		}
		else{
			obj.name = 'mas';
			obj.src = '../imagenes/mas.gif';
			prueba(sistema,modulo,'none');
		}
	}
	
	function prueba(sistema, modulo, modo){
		document.getElementById(sistema+'|'+modulo+'|div').style.display = modo;
	}

function check(obj, sistema, modulo, cantidad){
		for ( var i=1; i<=cantidad; i++ ){
			var objeto = sistema + '|' + modulo + '|' + i;
			
			if (obj.checked){
				document.getElementById(objeto).checked = true;
			}
			else{
				document.getElementById(objeto).checked = false;
			}
		}
	}

function borrar(obj){
		// agrega el codigo del registro a borrar
		if (!obj.checked){
			document.form1.procesos_borrar.value = document.form1.procesos_borrar.value + obj.value + '*';
		}
	}
	
function check_sistema(obj, sistema, modulo, cantidad){
		// nada que ver con esta funcion pero se pone aqui
		//borrar(obj);

		var objeto = sistema + '|' + modulo;		// check de modulo
		
		if (obj.checked){
			// VERIFICA LOS DEMAS OBJETOS PARA ESA EMPRESA Y MODULO ACTUAL
			for ( var i=1; i<=cantidad; i++ ){
				var objeto2 = sistema + '|' + modulo + '|' + i;		// check de procesos
				if (!document.getElementById(objeto2).checked){
					return;
				}
			}	
			document.getElementById(objeto).checked = true;
		}
		else{
			document.getElementById(objeto).checked = false;
		}
	}
	
</script>
