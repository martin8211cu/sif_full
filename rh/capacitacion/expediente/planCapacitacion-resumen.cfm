<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Plan_de_capacitacion"
	default="Plan de capacitación"
	xmlFile="/rh/generales.xml"
	returnvariable="LB_Plan_de_capacitacion"/>
	
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Plan_de_capacitacion#'>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_DeseaDesinscribirEsteCurso"
	default="Desea desinscribir este curso"
	returnvariable="MSG_DeseaDesinscribirEsteCurso"/>
	
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<!---Cursos programados--->
	<tr><td colspan="6" >
		<form name="form_cursosProgramados" method="post" enctype="multipart/form-data" action="opciones_sql.cfm">
			<input name="PAGENUM"  type="hidden"  value="<cfoutput>1</cfoutput>"/>
			<input name="DEid"  type="hidden"  value="<cfoutput>#form.DEid#</cfoutput>"/>
			<input name="tab"  type="hidden"  value="<cfoutput>#form.tab#</cfoutput>"/>
			<input name="RHCid"  type="hidden"  value=""/>
			<input name="op"  type="hidden"  value=""/>
			<table cellpadding="0" cellspacing="0" border="0" width="100%">
				<tr><td class="listaCorte" style="border-bottom: 1px solid black;"colspan="7"><strong><cf_translate key="LB_Cursos_Programados">Cursos Programados</cf_translate></strong></td></tr> 
				<tr>
					<td class="listaCorte"><cf_translate key="LB_Curso">Curso</cf_translate></td>
					<td class="listaCorte"><cf_translate key="LB_Fecha_Inicio">Fecha Inicio</cf_translate></td>
					<td class="listaCorte"><cf_translate key="LB_Fecha_Final">Fecha Final</cf_translate></td>
					<td class="listaCorte"><cf_translate key="LB_Institucion">Institución</cf_translate></td>
					<td class="listaCorte"><cf_translate key="LB_Eliminar">Eliminar</cf_translate></td>
					<td class="tituloListas">&nbsp;</td>
					<td class="tituloListas">&nbsp;</td>
				</tr>
				<cfif rsCProgramados.recordcount gt 0>
					<cfoutput query="rsCProgramados">
						<tr class="<cfif rsCProgramados.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
							<td>#rsCProgramados.RHCcodigo# - #rsCProgramados.Mnombre#</td>
							<td><cf_locale name="date" value="#rsCProgramados.fdesde#"/></td>
							<td><cf_locale name="date" value="#rsCProgramados.fhasta#"/></td>
							<td>#rsCProgramados.RHIAnombre#</td>
							<td>#rsCProgramados.removible#</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>	
						</cfoutput>
				<cfelse>
					<tr><td colspan="5" align="center">-<cf_translate key="LB_El_colaborador_no_tiene_cursos_programados_registrados">El colaborador no tiene cursos programados registrados</cf_translate>-</td></tr>
				</cfif>  
			</table>
		</form> 
	</td></tr>
	
	<tr><td colspan="6" >&nbsp;</td></tr>
	<!---Cursos llevando--->
	<tr><td colspan="6" >
		<form name="form_cursosXllevar" method="post" enctype="multipart/form-data" action="opciones_sql.cfm">
			<input name="PAGENUM"  type="hidden"  value="<cfoutput>1</cfoutput>"/>
			<input name="DEid"  type="hidden"  value="<cfoutput>#form.DEid#</cfoutput>"/>
			<input name="tab"  type="hidden"  value="<cfoutput>#form.tab#</cfoutput>"/>
			<input name="RHCid"  type="hidden"  value=""/>
			<input name="op"  type="hidden"  value=""/>
			<table cellpadding="0" cellspacing="0" border="0" width="100%">
				<tr><td class="listaCorte"style="border-bottom: 1px solid black;" colspan="7" ><strong><cf_translate key="LB_Cursando_actualmente">Cursando actualmente</cf_translate></strong></td></tr> 
					<tr>
						<td class="tituloListas"><cf_translate key="LB_Curso">Curso</cf_translate></td>
						<td class="tituloListas"><cf_translate key="LB_Fecha_Inicio">Fecha Inicio</cf_translate></td>
						<td class="listaCorte"><cf_translate key="LB_Fecha_Final">Fecha Final</cf_translate></td>
						<td class="tituloListas"><cf_translate key="LB_Institucion">Institución</cf_translate></td>
						<td class="tituloListas">&nbsp;</td>
						<td class="tituloListas">&nbsp;</td>

					</tr>
			
					<cfif cursosporllevar.recordcount gt 0>
						<cfoutput query="cursosporllevar">
							<tr class="<cfif cursosporllevar.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
								<td>#trim(cursosporllevar.descripcion)#</td>
								<td align="left"><cf_locale name="date" value="#cursosporllevar.inicio#"/></td>
								<td align="left"><cf_locale name="date" value="#cursosporllevar.fin#"/></td>
								<!---<td align="left">#cursosporllevar.institucion#</td>--->
								<cfif cursosporllevar.RHECestado eq 10>
								<td align="left">#cursosporllevar.removible#</td>
								<cfelse>
								<td align="left">&nbsp;</td>
								</cfif>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
						</cfoutput>
					<cfelse>
						<tr><td colspan="5" align="center">-<cf_translate key="LB_El_colaborador_no_esta_llevando_cursos_en_este_momento">El colaborador no esta llevando cursos en este momento</cf_translate></td></tr>
					</cfif>	 
			</table>
		</form> 
	</td></tr>
	<!---<tr><td colspan="4" >&nbsp;</td></tr>--->
	<!---Cursos ganados(llevados)--->
	<tr><td class="listaCorte" style="border-bottom: 1px solid black;" colspan="6" ><strong><cf_translate key="LB_Curso_llevados">Cursos llevados</cf_translate></strong></td></tr> 
				<tr>
					<td class="tituloListas"><cf_translate key="LB_Curso">Curso</cf_translate></td>
					<td class="tituloListas"><cf_translate key="LB_Fecha_Inicio">Fecha Inicio</cf_translate></td>
					<td class="tituloListas"><cf_translate key="LB_Fecha_Final">Fecha Final</cf_translate></td>
					<!---<td class="tituloListas">Instituci&oacute;n</td>--->
					<td class="tituloListas"><cf_translate key="LB_Nota">Nota</cf_translate></td>
					<td class="tituloListas"><cf_translate key="LB_Horas">Horas</cf_translate></td>
				</tr>
				<!---<cfset rsCAprobados = expediente.cursosLlevados(form.DEid, session.Ecodigo) >--->
				<cfif rsCAprobados.recordcount gt 0>
					<cfoutput query="rsCAprobados">
						<tr class="<cfif rsCAprobados.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
							<td>#trim(rsCAprobados.RHCcodigo)# - #rsCAprobados.Mnombre#</td>
							<td align="left"><cf_locale name="date" value="#rsCAprobados.inicio#"/></td>
							<td align="left"><cf_locale name="date" value="#rsCAprobados.fin#"/></td>
							<td> <cfif rsCAprobados.RHCtipo EQ 'P'>N/A<cfelse>#LSNumberFormat(rsCAprobados.nota,',0.00')#</cfif> </td>
							<td align="right">#rsCAprobados.tiempo#</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr><td colspan="4" align="center">-<cf_translate key="LB_El_colaborador_no_ha_llevado_ningun_curso">El colaborador no ha llevado ningun curso</cf_translate>-</td></tr>
				</cfif>						 
	<tr><td colspan="4" >&nbsp;</td></tr>
	<!---Evaluaciones programadas--->
	<tr><td class="listaCorte"  style="border-bottom: 1px solid black;" colspan="6" ><strong><cf_translate key="LB_Evaluaciones_programadas">Evaluaciones programadas</cf_translate></strong></td></tr> 
				<tr>
					<td class="listaCorte"><cf_translate key="LB_Descripcion">Descripción</cf_translate></td>
					<td class="listaCorte"><cf_translate key="LB_Fecha_Inicio">Fecha Inicio</cf_translate></td>
					<td class="listaCorte"><cf_translate key="LB_Fecha_Final">Fecha Final</cf_translate></td>
					<td class="listaCorte">&nbsp; </td>
					<td class="listaCorte">&nbsp; </td>
					<td class="listaCorte">&nbsp; </td>

				</tr>
				<cfset rsEvalProgramadas = expediente.evalprogramadas(form.DEid, session.Ecodigo) >
				<cfif rsEvalProgramadas.recordcount gt 0>
					<cfoutput query="rsEvalProgramadas">
						<tr class="<cfif rsEvalProgramadas.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
							<td>#rsEvalProgramadas.relacion#</td>
							<td><cf_locale name="date" value="#rsEvalProgramadas.inicio#"/></td>
							<td><cf_locale name="date" value="#rsEvalProgramadas.fin#"/></td>
							<td >&nbsp; </td>
							<td >&nbsp; </td>
							<td >&nbsp; </td>
						</tr>	
					</cfoutput>
				<cfelse>
					<tr><td colspan="4" align="center">-<cf_translate key="LB_El_colaborador_no_tiene_cursos_evaluaciones_registrada">El colaborador no tiene cursos evaluaciones registrada</cf_translate>-</td></tr>
				</cfif> 
	<tr><td colspan="4" >&nbsp;</td></tr>
</table>
<cf_web_portlet_end>


<script type="text/javascript">
	<!--
	function Eliminar(RHCid){
		if (confirm('¿<cfoutput>#MSG_DeseaDesinscribirEsteCurso#</cfoutput>?')){
			//httpRequest('POST','opciones_sql.cfm','true');
			
			document.form_cursosXllevar.RHCid.value = RHCid;
			document.form_cursosXllevar.op.value = 'del';
			document.form_cursosXllevar.submit();
		}
	}
	
	//-->
</script>
