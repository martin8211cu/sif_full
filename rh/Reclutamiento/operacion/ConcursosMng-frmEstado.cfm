<cfoutput>
	<form action="ConcursosMng-sql.cfm" method="post" name="form1">
		<cfinclude template="ConcursosMng-hiddens.cfm">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td valign="top">&nbsp;</td>
			<td valign="top">&nbsp;</td>
			<td valign="top">&nbsp;</td>
		  </tr>
		  <tr>
		    <td width="2%" valign="top" align="center">&nbsp;</td>
			<td width="38%" valign="top" align="center">
				<!--- AYUDA --->
				<!--- VARIABLES DE TRADUCCION --->
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_DescripcionDeNuevosEstados"
					Default="Descripci&oacute;n de Nuevos Estados"
					returnvariable="LB_DescripcionDeNuevosEstados"/>
				<cf_web_portlet_start titulo="#LB_DescripcionDeNuevosEstados#">
				<table width="90%"  border="0" cellspacing="0" cellpadding="2" align="center">
				  <tr>
				    <td align="right" valign="top" class="fileLabel">&nbsp;</td>
				    <td>&nbsp;</td>
			      </tr>
				  <tr>
				    <td width="10%" align="right" valign="top" class="fileLabel" nowrap="nowrap"><cf_translate key="LB_Cerrado">Cerrado</cf_translate>:</td>
			        <td><cf_translate key="LB_LaSolicitudDeConcursoNoSeraAntendida">La solicitud de concurso no ser&aacute; atendida</cf_translate></td>
				  </tr>
				  <tr>
				    <td align="right" valign="top" class="fileLabel" nowrap="nowrap"><cf_translate key="LB_Desierto">Desierto</cf_translate>:</td>
				    <td><cf_translate key="LB_NoHaySuficientesConcursantes">No hay suficientes concursantes</cf_translate></td>
			      </tr>
				  <tr>
				    <td align="right" valign="top" class="fileLabel">&nbsp;</td>
				    <td>&nbsp;</td>
			      </tr>
				</table>
				<cf_web_portlet_end>
			</td>
			<td width="60%" valign="top">
				<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
					<tr>
						<td width="25%" align="right" nowrap class="fileLabel"><cf_translate key="LB_EstadoActual">Estado actual</cf_translate>:&nbsp;</td>
						<td>
							<cfif rsRHConcursos.RHCestado eq 0>
								<cf_translate key="LB_EnProceso">En proceso</cf_translate>
							<cfelseif rsRHConcursos.RHCestado eq 10 >
								<cf_translate key="LB_Solicitado">Solicitado</cf_translate>
							<cfelseif rsRHConcursos.RHCestado eq 15 >
								<cf_translate key="LB_Verificado">Verificado</cf_translate>
							<cfelseif rsRHConcursos.RHCestado eq 20 >
								<cf_translate key="LB_Desierto">Desierto</cf_translate>
							<cfelseif rsRHConcursos.RHCestado eq 30 >
								<cf_translate key="LB_Cerrado">Cerrado</cf_translate>
							<cfelseif rsRHConcursos.RHCestado eq 40 >
								<cf_translate key="LB_Revision">Revisi&oacute;n</cf_translate>
							<cfelseif rsRHConcursos.RHCestado eq 50 >
								<cf_translate key="LB_AplicadoPublicado">Aplicado/Publicado</cf_translate>
							<cfelseif rsRHConcursos.RHCestado eq 60 >
								<cf_translate key="LB_Evaluado">Evaluado</cf_translate>
							<cfelseif rsRHConcursos.RHCestado eq 70 >
								<cf_translate key="LB_Terminado">Terminado</cf_translate>
							</cfif>
						</td>
					</tr>	
					<tr>
						<td align="right" nowrap class="fileLabel"><cf_translate key="LB_NuevoEstado">Nuevo estado</cf_translate>:&nbsp;</td>
						<td> 
							<select name="RHCestado" id="RHCestado">
								<cfif isDefined("session.Ecodigo") and isDefined("Form.RHCconcurso") and len(trim(Form.RHCconcurso)) NEQ 0>
								  <option value="30"><cf_translate key="CMB_Cerrado">Cerrado</cf_translate></option>
								  <option value="20"><cf_translate key="LB_Desierto">Desierto</cf_translate></option>
								</cfif>
							</select>
						</td>
					</tr>
					<tr>
						<td align="right" valign="top" nowrap class="fileLabel"><cf_translate key="LB_Justificacion">Justificaci&oacute;n</cf_translate>:&nbsp;</td>
						<td>
							<textarea name="RHCjustificacion" id="RHCjustificacion" rows="3" style="width:90%"></textarea>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<cf_botones values="Aceptar" names="Aceptar">
						</td>
					</tr>
				</table>
			</td>
		  </tr>
		</table>
	</form>
</cfoutput>

<cf_qforms form="form1">
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EstaSeguroDeQueDeseaCambiarElEstadoDelConcursoA"
	Default="¿Está seguro de que desea cambiar el estado del concurso a"
	returnvariable="MSG_EstaSeguroDeQueDeseaCambiarElEstadoDelConcursoA"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Justificacion"
	Default="Justificación"
	returnvariable="LB_Justificacion"/>
	
	
<script language="javascript" type="text/javascript">
	<!--//
	
	function funcAceptar() {
		if (confirm('<cfoutput>#MSG_EstaSeguroDeQueDeseaCambiarElEstadoDelConcursoA#</cfoutput> '+document.form1.RHCestado.options[document.form1.RHCestado.selectedIndex].text+' ?')) {
			return true;
		} else {
			return false;
		}
	}
	
	objForm.RHCjustificacion.required = true;
	objForm.RHCjustificacion.description = '<cfoutput>#LB_Justificacion#</cfoutput>';
	
	//-->
</script>
