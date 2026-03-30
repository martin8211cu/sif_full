<!--- significado de cada uno de los usuarios 

ASESOR 		es cuando el usario crea un perfil nuevo en estado 10
ASESORM 	es cuando el perfil esta siendo modificado por un asesor 
ASESORSP	es cuando el usuario que crea el perfil es el jefe de asesores
JEFEASESOR	cuando el usuario es el jefe asesor y se encuentra en proceso de aprobacion de un perfil enviado por otro usuario
JEFECF		cuando el usuario es el encargado del centro funcional de un puesto que se encuentra en un perfil.
JEFECFNM	cuando el usuario es el encargado del centro funcional de un puesto que se encuentra en un perfil pero no puede modificar.
 --->
 

<script language="javascript" type="text/javascript">
	function buttonOver(obj) {
		obj.className="botonDown";
	}

	function buttonOut(obj) {
		obj.className="botonUp";
	}
	
	function eliminar(){
		<cfif form.o eq 2>
			document.formTB2.Boton.value = "ELIMINARDATOVARIABLE";
			document.formTB2.Observaciones.value = document.formObservacion.Observaciones.value;
			document.formTB2.submit();
		<cfelseif form.o eq 3>
			document.formTB3.Boton.value = "ELIMINARHABILIDAD";
			document.formTB3.Observaciones.value = document.formObservacion.Observaciones.value;
			document.formTB3.submit();
		<cfelseif form.o eq 4>
			document.formTB4.Boton.value = "ELIMINARCONOCIMIENTO";
			document.formTB4.Observaciones.value = document.formObservacion.Observaciones.value;
			document.formTB4.submit();	
		</cfif>
	}
		
	function Modificar(){
		<cfif form.o eq 2>
		if (validaDatoVariable()){
			document.formTB2.Boton.value = "MODIFICARDATOVARIABLE";
			document.formTB2.Observaciones.value = document.formObservacion.Observaciones.value;
			document.formTB2.submit();
		}
		<cfelseif form.o eq 3>
		if (validaHabilidades()){
			document.formTB3.Boton.value = "MODIFICARHABILIDAD";
			document.formTB3.Observaciones.value = document.formObservacion.Observaciones.value;
			document.formTB3.submit();	
		}
		<cfelseif form.o eq 4>
		if (validaconocimientos()){
			document.formTB4.Boton.value = "MODIFICARCONOCIMIENTO";
			document.formTB4.Observaciones.value = document.formObservacion.Observaciones.value;
			document.formTB4.submit();	
		}	
		</cfif>
	}	

	function Agregar (){
		<cfif form.o eq 2>
		if (validaDatoVariable()){
			document.formTB2.Boton.value = "AGREGARDATOVARIABLE";
			document.formTB2.Observaciones.value = document.formObservacion.Observaciones.value;
			document.formTB2.submit();
		}
		<cfelseif form.o eq 3>
		if (validaHabilidades()){
			document.formTB3.Boton.value = "AGREGARHABILIDAD";
			document.formTB3.Observaciones.value = document.formObservacion.Observaciones.value;
			document.formTB3.submit();
		}	
		<cfelseif form.o eq 4>
		if (validaconocimientos()){
			document.formTB4.Boton.value = "AGREGARCONOCIMIENTO";
			document.formTB4.Observaciones.value = document.formObservacion.Observaciones.value;
			document.formTB4.submit();	
		}
		</cfif>
	}	
	
	function Agregar2 (){
		document.formTB5.Boton.value = "AGREGARVALORES";
		document.formTB5.Observaciones.value = document.formObservacion.Observaciones.value;
		document.formTB5.submit();	
	}
	
	function  funcNuevo(){
		<cfif form.o eq 2>
			document.formTB2.Boton.value = "NUEVO";
			document.formTB2.submit();
		<cfelseif form.o eq 3>
			document.formTB3.Boton.value = "NUEVO";
			document.formTB3.submit();	
		<cfelseif form.o eq 4>
			document.formTB4.Boton.value = "NUEVO";
			document.formTB4.submit();	
		<cfelseif form.o eq 5>
			document.formTB5.Boton.value = "NUEVO";
			document.formTB5.submit();			
		</cfif>
	}	
	function  funcLimpiar(){
		<cfif form.o eq 2>
			document.formTB2.reset();
		<cfelseif form.o eq 3>
			document.formTB3.reset();
		<cfelseif form.o eq 4>
			document.formTB4.reset();	
		<cfelseif form.o eq 5>
			document.formTB5.reset();	
		</cfif> 
	}	
</script>

<table border="0" cellpadding="2" cellspacing="0" style="height: 24px; ">
	<tr>
	<cfif form.o eq 2>
		<cfif form.USUARIO neq 'JEFECFNM'>
			<cfif modoTab2 EQ 'ALTA'>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return Agregar();">
					<img src="/cfmx/rh/imagenes/Cfinclude.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Agregar">Agregar</cf_translate></font>
				</td>
				<td>|</td>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcLimpiar();">
					<img src="/cfmx/rh/imagenes/notepad.png" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Limpiar">Limpiar</cf_translate></font>
				</td>
			<cfelse>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return Modificar();">
					<img src="/cfmx/rh/imagenes/Cfinclude.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Modificar">Modificar</cf_translate></font>
				</td>
				<td>|</td>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcNuevo();">
					<img src="/cfmx/rh/imagenes/Insert Record.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Nuevo">Nuevo</cf_translate></font>
				</td>
				<td>|</td>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return eliminar();">
					<img src="/cfmx/rh/imagenes/Borrar01_S.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Borrar">Borrar</cf_translate></font>
				</td>
			</cfif>	
		</cfif>	
	<cfelseif form.o eq 3>
		<cfif form.USUARIO neq 'JEFECFNM'>
			<cfif modoTab3 EQ 'ALTA'>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return Agregar();">
					<img src="/cfmx/rh/imagenes/Cfinclude.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Agregar">Agregar</cf_translate></font>
				</td>
				<td>|</td>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcLimpiar();">
					<img src="/cfmx/rh/imagenes/notepad.png" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Limpiar">Limpiar</cf_translate></font>
				</td>
			<cfelse>
				
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return Modificar();">
					<img src="/cfmx/rh/imagenes/Cfinclude.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Modificar">Modificar</cf_translate></font>
				</td>
				<td>|</td>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcNuevo();">
					<img src="/cfmx/rh/imagenes/Insert Record.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Nuevo">Nuevo</cf_translate></font>
				</td>
				<cftransaction>
					<cfset borrar = true>
					<cftry>
						<cfquery name="RHHabPuestoDelete" datasource="#session.DSN#">
							delete from RHHabilidadesPuesto 
							where RHHid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHid#">
							and RHPcodigo  = '#data.RHPcodigo#'
							and Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">						
						</cfquery>	
					<cfcatch>
						<cfset borrar = false>
						 <!--- <cfdump var="#cfcatch#">--->
					</cfcatch>
					</cftry>
						
					<cfif borrar>
						<td>|</td>
						<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return eliminar();">
							<img src="/cfmx/rh/imagenes/Borrar01_S.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Borrar">Borrar</cf_translate></font>
						</td>
					</cfif>			
					<cftransaction action="rollback">
				</cftransaction>			
			</cfif>	
		</cfif>		
	<cfelseif form.o eq 4>
	  <cfif form.USUARIO neq 'JEFECFNM'>
			<cfif modoTab4 EQ 'ALTA'>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return Agregar();">
					<img src="/cfmx/rh/imagenes/Cfinclude.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Agregar">Agregar</cf_translate></font>
				</td>
				<td>|</td>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcLimpiar();">
					<img src="/cfmx/rh/imagenes/notepad.png" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Limpiar">Limpiar</cf_translate></font>
				</td>
			<cfelse>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return Modificar();">
					<img src="/cfmx/rh/imagenes/Cfinclude.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Modificar">Modificar</cf_translate></font>
				</td>
				<td>|</td>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcNuevo();">
					<img src="/cfmx/rh/imagenes/Insert Record.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Nuevo">Nuevo</cf_translate></font>
				</td>
				<cftransaction>
					<cfset borrar = true>
					<cftry>
						<cfquery name="RHHabPuestoDelete" datasource="#session.DSN#">
							delete from RHConocimientosPuesto 
							where RHCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
							and RHPcodigo  = '#data.RHPcodigo#'
							and Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">						
						</cfquery>		
					<cfcatch>
						<cfset borrar = false>
						 <!---<cfdump var="#cfcatch#"> --->
					</cfcatch>
					</cftry>
						
					<cfif borrar>
						<td>|</td>
						<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return eliminar();">
							<img src="/cfmx/rh/imagenes/Borrar01_S.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Borrar">Borrar</cf_translate></font>
						</td>
					</cfif>			
					<cftransaction action="rollback">
				</cftransaction>			
			</cfif>		
		</cfif>		
	<cfelseif form.o eq 5>
	  <cfif form.USUARIO neq 'JEFECFNM'>
		<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return Agregar2();">
			<img src="/cfmx/rh/imagenes/Cfinclude.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Actualizar">Actualizar</cf_translate></font>
		</td>
	  </cfif>		
	</cfif>

	</tr> 
</table>
