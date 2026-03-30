<!--- significado de cada uno de los usuarios 

ASESOR 		es cuando el usario crea un perfil nuevo en estado 10
ASESORM 	es cuando el perfil esta siendo modificado por un asesor 
ASESORSP	es cuando el usuario que crea el perfil es el jefe de asesores
JEFEASESOR	cuando el usuario es el jefe asesor y se encuentra en proceso de aprobacion de un perfil enviado por otro usuario
JEFECF		cuando el usuario es el encargado del centro funcional de un puesto que se encuentra en un perfil.
JEFECFNM	cuando el usuario es el encargado del centro funcional de un puesto que se encuentra en un perfil pero no puede modificar.
 --->
 

<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_DeseaAplicarEstePerfilDelDescriptivo"
			Default="Desea aplicar este perfil del descriptivo"
			returnvariable="MSG_DeseaAplicarEstePerfilDelDescriptivo"/>

<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_DeseaAprobarEstePerfilDelDescriptivo"
			Default="Desea aprobar este perfil del descriptivo"
			returnvariable="MSG_DeseaAprobarEstePerfilDelDescriptivo"/>
			
<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_DeseaanularEstePerfilDelDescriptivo"
			Default="Desea anular este perfil del descriptivo"
			returnvariable="MSG_DeseaanularEstePerfilDelDescriptivo"/>	
<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_DesearechazarEstePerfilDelDescriptivo"
			Default="Desea rechazar este perfil del descriptivo"
			returnvariable="MSG_DesearechazarEstePerfilDelDescriptivo"/>						
			

<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_EstaOperacionEsIrreversible"
			Default="Esta operación es irreversible"
			returnvariable="MSG_EstaOperacionEsIrreversible"/>
			
<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Asegurese_de_guardar_toda_la_informacion_antes_de_lo_contrario_no_se_reflejaran_estos_cambios"
			Default="Asegurese de guardar toda la información antes, de lo contrario no se reflejarán estos cambios"
			returnvariable="MSG_Asegurese_de_guardar_toda_la_informacion_antes_de_lo_contrario_no_se_reflejaran_estos_cambios"/>			



<script language="javascript" type="text/javascript">
	function buttonOver(obj) {
		obj.className="botonDown";
	}

	function buttonOut(obj) {
		obj.className="botonUp";
	}
	function funcGuardar(){
		<cfif form.o eq 1>
			document.form1.Boton.value = "GUARDARTAB1";
			document.form1.Observaciones.value = document.formObservacion.Observaciones.value;
			document.form1.submit();
		</cfif>
	}
	
	function funcAprobarToCF(){
		if(confirm('<cfoutput>¿#MSG_DeseaAprobarEstePerfilDelDescriptivo#?\n#MSG_EstaOperacionEsIrreversible#\n#MSG_Asegurese_de_guardar_toda_la_informacion_antes_de_lo_contrario_no_se_reflejaran_estos_cambios#</cfoutput>.')){
			document.formObservacion.Boton.value = "ASESORTOCF";
			document.formObservacion.Observaciones.value = document.formObservacion.Observaciones.value;
			document.formObservacion.submit();
			return true;
		}
		return false;
	}	
	
	function funcRechazadoporJEFEASESOR(){
		if(confirm('<cfoutput>¿#MSG_DesearechazarEstePerfilDelDescriptivo#?\n#MSG_EstaOperacionEsIrreversible#</cfoutput>.')){
			document.formObservacion.Boton.value = "RECHAZADOJEFEASESOR";
			document.formObservacion.Observaciones.value = document.formObservacion.Observaciones.value;
			document.formObservacion.submit();
			return true;
		}
		return false;
		
	}	
	
	function funcRechazadoporCF(){
		if(confirm('<cfoutput>¿#MSG_DesearechazarEstePerfilDelDescriptivo#?\n#MSG_EstaOperacionEsIrreversible#</cfoutput>.')){
			document.formObservacion.Boton.value = "RECHAZADOJEFECF";
			document.formObservacion.Observaciones.value = document.formObservacion.Observaciones.value;
			document.formObservacion.submit();
			return true;
		}
		return false;
		
	}	
	
	function funcGuardarSoloObservacion(){
		document.formObservacion.Boton.value = "OBSERVACION";
		document.formObservacion.Observaciones.value = document.formObservacion.Observaciones.value;
		document.formObservacion.submit();
	}	
	
	
	function funcAprobarToJEFEASESOR(){
		if(confirm('<cfoutput>¿#MSG_DeseaAprobarEstePerfilDelDescriptivo#?\n#MSG_EstaOperacionEsIrreversible#\n#MSG_Asegurese_de_guardar_toda_la_informacion_antes_de_lo_contrario_no_se_reflejaran_estos_cambios#</cfoutput>.')){
			document.formObservacion.Boton.value = "ASESORTOJEFEASESOR";
			document.formObservacion.Observaciones.value = document.formObservacion.Observaciones.value;
			document.formObservacion.submit();
			return true;
		}
		return false;
	}
		
	function funcAprobarCFToJEFEASESOR(){
		if(confirm('<cfoutput>¿#MSG_DeseaAprobarEstePerfilDelDescriptivo#?\n#MSG_EstaOperacionEsIrreversible#\n#MSG_Asegurese_de_guardar_toda_la_informacion_antes_de_lo_contrario_no_se_reflejaran_estos_cambios#</cfoutput>.')){
			document.formObservacion.Boton.value = "JEFECFTOJEFEASESOR";
			document.formObservacion.Observaciones.value = document.formObservacion.Observaciones.value;
			document.formObservacion.submit();
			return true;
		}
		return false;
	}
	
	function funcElimiar(){
		document.formObservacion.Boton.value = "ELIMINARPERFIL";
		document.formObservacion.submit();
	}
	
	function reportePuesto(){
		var RHDPPid = document.formObservacion.RHDPPid.value;
		var sel     = "<cfoutput>#form.o#</cfoutput>";
		var o       = "<cfoutput>#form.o#</cfoutput>";
		var USUARIO = "<cfoutput>#form.USUARIO#</cfoutput>";
		location.href="PuestosReport.cfm?RHDPPid="+ RHDPPid + "&sel="+ sel + "&o="+ o+ "&USUARIO="+ USUARIO;
	}
	
	function funcAprobarJEFEASESOR (){
		if(confirm('<cfoutput>¿#MSG_DeseaAplicarEstePerfilDelDescriptivo#?\n#MSG_EstaOperacionEsIrreversible#\n#MSG_Asegurese_de_guardar_toda_la_informacion_antes_de_lo_contrario_no_se_reflejaran_estos_cambios#</cfoutput>.')){
			document.formObservacion.Boton.value = "APROBACIONFINAL";
			document.formObservacion.submit();
			return true;
		}
		return false;
	}
	
	function funcAnularJEFEASESOR(){
		if(confirm('<cfoutput>¿#MSG_DeseaanularEstePerfilDelDescriptivo#?\n#MSG_EstaOperacionEsIrreversible#</cfoutput>.')){
			document.formObservacion.Boton.value = "ANULAR";
			document.formObservacion.submit();
			return true;
		}
		return false;
	}
	
	
</script>

<cfquery name="rsEstado" datasource="#session.DSN#">
	select 
		Estado,RHPcodigo
	from RHDescripPuestoP
	where RHDPPid = <cfqueryparam value="#form.RHDPPid#" cfsqltype="cf_sql_numeric">
	and Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfset Puesto = rsEstado.RHPcodigo>

<!--- funcGuardarSoloObservacion --->

<table border="0" cellpadding="2" cellspacing="0" style="height: 24px; ">
	<tr>
		<cfif form.USUARIO eq 'ASESOR' OR  form.USUARIO eq 'ASESORM'>
			<cfset EL_PUESTO_ES_DEL_JEFEASESOR = true>
			<cfquery name="RSJEFEASESOR" datasource="#session.DSN#">
				select ltrim(rtrim(Pvalor)) as CFID  
				from RHParametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Pcodigo = 700				
			</cfquery>
			
			<cfif RSJEFEASESOR.recordCount GT 0>
				<cfquery name="RSCFPUESTO" datasource="#session.DSN#">
					select coalesce (CFid ,-1) as CFid   from RHPuestos
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
					and RHPcodigo = '#Puesto#'
				</cfquery>
				<cfif RSJEFEASESOR.CFID eq RSCFPUESTO.CFID>
					<cfset EL_PUESTO_ES_DEL_JEFEASESOR = true>
				<cfelse>
					<cfset EL_PUESTO_ES_DEL_JEFEASESOR = false>
				</cfif>	
			<cfelse>
				<cfset EL_PUESTO_ES_DEL_JEFEASESOR = false>
			</cfif>	
			
			 
			 <cfinvoke component="rh.Componentes.RH_Funciones" 
				method="DeterminaResponsableCF"
				CFid = "#data.CFid#"
				fecha = "#Now()#"
				returnvariable="ResponsableCF">
				
			<!---<cfdump var="#EL_PUESTO_ES_DEL_JEFEASESOR#"> --->


			<cfif form.o eq 1>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcGuardar();">
					<img src="/cfmx/rh/imagenes/Cfinclude.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Guardar">Guardar</cf_translate></font>
				</td>
				<td>|</td>
			<cfelse>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcGuardarSoloObservacion();">
					<img src="/cfmx/rh/imagenes/Cfinclude.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_GuardarObservacion">Guardar Observaci&oacute;n</cf_translate></font>
				</td>
				<td>|</td>			
			</cfif>
			 <cfif isdefined("data.CFid") and len(trim(data.CFid)) and data.CFid neq -1  and EL_PUESTO_ES_DEL_JEFEASESOR eq false and ResponsableCF neq -1 >
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcAprobarToCF();">
					<img src="/cfmx/rh/imagenes/iedit.gif" border="0" align="top" hspace="2"><font size="+2">&nbsp;<cf_translate key="LB_Aprobar">Aprobar</cf_translate></font>
				</td>
			 </cfif>
			<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcAprobarToJEFEASESOR();">
				<img src="/cfmx/rh/imagenes/Cfinclude.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_AprobacioNoRelevante">Aprobaci&oacute;n no relevante</cf_translate></font>
			</td>
			<cfif isdefined("rsEstado.Estado") and len(trim(rsEstado.Estado)) and rsEstado.Estado eq 10 >
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcElimiar();">
				<img src="/cfmx/rh/imagenes/Borrar01_S.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_EliminarPerfil">Eliminar perfil</cf_translate></font>
				</td>
			</cfif>	
		<cfelseif form.USUARIO eq 'ASESORSP'>	
			<cfif form.o eq 1>
			<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcGuardar();">
				<img src="/cfmx/rh/imagenes/Cfinclude.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Guardar">Guardar</cf_translate></font>
			</td>
			<td>|</td>
			<cfelse>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcGuardarSoloObservacion();">
					<img src="/cfmx/rh/imagenes/Cfinclude.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_GuardarObservacion">Guardar Observaci&oacute;n</cf_translate></font>
				</td>
				<td>|</td>			
			</cfif>
			<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcAprobarJEFEASESOR();">
				<img src="/cfmx/rh/imagenes/Cfinclude.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Aplicar">Aplicar</cf_translate></font>
			</td>
			<cfif isdefined("rsEstado.Estado") and len(trim(rsEstado.Estado)) and rsEstado.Estado eq 10 >
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcElimiar();">
				<img src="/cfmx/rh/imagenes/Borrar01_S.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_EliminarPerfil">Eliminar perfil</cf_translate></font>
				</td>
			</cfif>				
		<cfelseif form.USUARIO eq 'JEFEASESOR'>
			<cfif form.o eq 1>
			<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcGuardar();">
				<img src="/cfmx/rh/imagenes/Cfinclude.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Guardar">Guardar</cf_translate></font>
			</td>
			<td>|</td>
			<cfelse>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcGuardarSoloObservacion();">
					<img src="/cfmx/rh/imagenes/Cfinclude.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_GuardarObservacion">Guardar Observaci&oacute;n</cf_translate></font>
				</td>
				<td>|</td>			
			</cfif>
			<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcAprobarJEFEASESOR();">
				<img src="/cfmx/rh/imagenes/Cfinclude.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Aplicar">Aplicar</cf_translate></font>
			</td>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcRechazadoporJEFEASESOR();">
				<img src="/cfmx/rh/imagenes/Borrar01_S.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Rechazar">Rechazar</cf_translate></font>
			</td>	
			</td>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcAnularJEFEASESOR();">
				<img src="/cfmx/rh/imagenes/question.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Anular">Anular</cf_translate></font>
			</td>				
		<cfelseif form.USUARIO eq 'JEFECF' or form.USUARIO eq 'JEFECFNM'>
			<cfif form.o eq 1>
				
				<cfif form.USUARIO eq 'JEFECF'>
					<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcGuardar();">
						<img src="/cfmx/rh/imagenes/Cfinclude.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Guardar">Guardar</cf_translate></font>
					</td>
					<td>|</td> 
				<cfelse>
					<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcGuardarSoloObservacion();">
						<img src="/cfmx/rh/imagenes/Cfinclude.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_GuardarObservacion">Guardar Observaci&oacute;n</cf_translate></font>
					</td>
					<td>|</td>	
				</cfif>			
			<cfelse>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcGuardarSoloObservacion();">
					<img src="/cfmx/rh/imagenes/Cfinclude.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_GuardarObservacion">Guardar Observaci&oacute;n</cf_translate></font>
				</td>
				<td>|</td>			
			</cfif>
			<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcAprobarCFToJEFEASESOR();">
				<img src="/cfmx/rh/imagenes/Cfinclude.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Aprobar">Aprobar</cf_translate></font>
			</td>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcRechazadoporCF();">
				<img src="/cfmx/rh/imagenes/Borrar01_S.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Rechazar">Rechazar</cf_translate></font>
			</td>
		</cfif>

		<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return buscar();">
			<img src="/cfmx/rh/imagenes/iindex.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_SeleccioneUnPuesto">Seleccione un puesto</cf_translate></font>
		</td>
		<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return reportePuesto();">
			<img src="/cfmx/rh/imagenes/Template.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_VerPerfil">Ver perfil </cf_translate></font>
		</td> <!--- --->	
	</tr>
</table>
