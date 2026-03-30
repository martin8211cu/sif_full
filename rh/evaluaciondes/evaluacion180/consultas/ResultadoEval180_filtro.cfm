<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ReportesDeRetroalimentacionEvaluacionDelDesempenno"
	Default="Reportes de Retroalimentación - Evaluación del Desempe&ntilde;o"
	returnvariable="LB_ReportesDeRetroalimentacionEvaluacionDelDesempenno"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeEvaluaciones"
	Default="Lista de Evaluaciones"	
	returnvariable="LB_ListaDeEvaluaciones"/> 
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeCentrosFuncionales"
	Default="Lista de Centros Funcionales"	
	returnvariable="LB_ListaDeCentrosFuncionales"/> 

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeEmpleados"
	Default="Lista de Empleados"	
	returnvariable="LB_ListaDeEmpleados"/> 	

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripción"	
	returnvariable="LB_Descripcion"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Desde"
	Default="Desde"	
	returnvariable="LB_Desde"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Hasta"
	Default="Hasta"	
	returnvariable="LB_Hasta"/>		
	 
    <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificación"	
	returnvariable="LB_Identificacion"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"	
	returnvariable="LB_Nombre"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="Código"	
	returnvariable="LB_Codigo"/>	 
	 
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Consultar"
	Default="Consultar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Consultar"/>  
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Limpiar"
	Default="Limpiar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Limpiar"/>		 
	<cf_templateheader title="#LB_RecursosHumanos#">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>
				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_ReportesDeRetroalimentacionEvaluacionDelDesempenno#">
					<form name="form1" method="get" action="ResultadoEval180.cfm" style="margin:0; " onSubmit="javascript: return validar(this);">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr><td colspan="4"><cfinclude template="../../../portlets/pNavegacion.cfm"></td></tr>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							
							<td width="45%"  valign="top">
								<cf_web_portlet_start border="true" titulo="#LB_ReportesDeRetroalimentacionEvaluacionDelDesempenno#" skin="info1">
									<table width="100%" >
										<tr><td><p>
										<cf_translate  key="Ayuda_EsteReporteMuestraLasRespuestasALasPreguntasQueSeLeRealizaronEnUnaDeterminadaEvaluacionDelDesempenoDeJefaturas">
											Este reporte muestra las respuestas a las preguntas que se le realizaron en una determinada evaluación del Desempe&ntilde;o de Jefaturas			
										</cf_translate>
										</p></td></tr>
									</table>
								<cf_web_portlet_end>
							</td>
							<td width="3%">&nbsp;</td>
							<td colspan="2" valign="top">
								<table width="90%" align="center" cellpadding="2" cellspacing="0">
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Evaluacion">Evaluaci&oacute;n</cf_translate>:&nbsp;</td>
										<td >
											<cf_conlis
												Campos="REid,REdescripcion"
												tabindex="3"
												Desplegables="N,S"
												Modificables="N,N"
												Size="0,35"
												Title="#LB_ListaDeEvaluaciones#"
												Tabla="RHRegistroEvaluacion"
												Filtro="REestado  = 2  and Ecodigo = #Session.Ecodigo# order by REdescripcion"
												Desplegar="REdescripcion,REdesde,REhasta"
												Etiquetas="#LB_Descripcion#,#LB_Desde#,#LB_Hasta#"
												Columnas="REid,REdescripcion,REdesde,REhasta,REaplicajefe,REaplicaempleado"
												filtrar_por="REdescripcion,REdesde,REhasta"
												Formatos="S,D,D"
												Align="left,left,left"
												funcion="controlcheck()"
												Asignar="REid,REdescripcion,REaplicajefe,REaplicaempleado"
												Asignarformatos="I,S"
												Alt="ID,#LB_Descripcion#"/>	
										</td>
									</tr>
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Empleado">Empleado</cf_translate>:&nbsp;</td>
										<td >
											<cf_conlis
											   campos="DEid,DEidentificacion,Nombre"
											   desplegables="N,S,S"
											   modificables="N,S,N"
											   size="0,20,40"
											   title="#LB_ListaDeEmpleados#"
											   tabla=" RHRegistroEvaluadoresE a
															inner join DatosEmpleado b
																on a.DEid = b.DEid
																and a.Ecodigo = b.Ecodigo"
											   columnas="b.DEid, b.DEidentificacion , {fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )},  ' ' )}, b.DEnombre)} as Nombre"
											   filtro="REid = $REid,numeric$ and a.Ecodigo = #Session.Ecodigo#  order by DEidentificacion"
											   desplegar="DEidentificacion,Nombre"
											   filtrar_por="b.DEidentificacion|{fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )},  ' ' )}, b.DEnombre)}"
											   filtrar_por_delimiters="|"
											   etiquetas="#LB_Identificacion#,#LB_Nombre#"
											   formatos="S,S"
											   align="left,left"
											   asignar="DEid,DEidentificacion,Nombre"
											   asignarformatos="S,S,S"
											   showemptylistmsg="true"
											   tabindex="1"
											   alt="ID,#LB_Identificacion#,#LB_Nombre#"> 
										</td>
									</tr>
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate>:&nbsp;</td>
										<td >
										<cf_conlis
											Campos="CFid,CFcodigo,CFdescripcion"
											tabindex="4"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,15,35"
											Title="#LB_ListaDeCentrosFuncionales#"
											Tabla="RHGruposRegistroE a
													inner join RHCFGruposRegistroE b
														on  a.GREid =b.GREid
														and a.Ecodigo = b.Ecodigo
													inner join CFuncional c
														on b.CFid = c.CFid
														and  b.Ecodigo = c.Ecodigo"
											Columnas="distinct c.CFid,c.CFcodigo,c.CFdescripcion"
											Filtro="REid = $REid,numeric$ and a.Ecodigo = #Session.Ecodigo# order by CFcodigo,CFdescripcion"
											Desplegar="CFcodigo,CFdescripcion"
											Etiquetas="#LB_Codigo#,#LB_Descripcion#"
											filtrar_por="c.CFcodigo,c.CFdescripcion"
											Formatos="S,S"
											Align="left,left"
											Asignar="CFid,CFcodigo,CFdescripcion"
											Asignarformatos="I,S,S"
											Alt="ID,#LB_Codigo#,#LB_Descripcion#"/>
										</td>
									</tr>
									<tr>
										<td >&nbsp;</td>
										<td >
											<input 	type="checkbox" 
													name="chkDep" 
													value="" 
													id="chkDep"><label for=chkDep style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate  key="LB_IncluirDependencias">Incluir dependencias</cf_translate></label>
										</td>									
									</tr>
									
									<tr>
										<td >&nbsp;</td>
										<td ><input type="radio" name="Tipo"  id="Auto"     value="1" /><label for=Auto style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate  key="LB_AutoEvaluacion">AutoEvaluación</cf_translate></label>&nbsp;&nbsp;
										     <input type="radio" name="Tipo"  id="Jefatura" value="2" /><label for=Jefatura style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate  key="LB_Jefaturas">Jefaturas</cf_translate></label>
										</td>									
									</tr>
									

									<tr>
											<td align="right"><cf_translate  key="LB_Formato">Formato</cf_translate>:&nbsp;</td>
											<td>
												<select name="formato" tabindex="1">
													<option value="FlashPaper">FlashPaper</option>
													<option value="pdf">Adobe PDF</option>
													<option value="Excel">Microsoft Excel</option>
												</select>
											</td>
										</tr>									
								</table>

							    <table width="90%" align="center" cellpadding="2" cellspacing="0">
							      <tr>
                                      
							        
							        <td colspan="2" align="center">
									<input type="submit" name="Consultar" value="<cfoutput>#BTN_Consultar#</cfoutput>">
									<input type="reset"  name="Limpiar" value="<cfoutput>#BTN_Limpiar#</cfoutput>">
									</td>
						          </tr>
						      </table>
					      </td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
					<input type="hidden" name="REaplicajefe" value="">
					<input type="hidden" name="REaplicaempleado" value="">
					</form>
					
					<script language="javascript1.2" type="text/javascript">
						function validar(form){
							var mensaje = '';
							
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="MSG_ElCampoEvaluacionEsRequerido"
							Default="El campo Evaluación es requerido"
							returnvariable="MSG_ElCampoEvaluacionEsRequerido"/>
							
							
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="MSG_TieneQueIndicarElTipoDeEvaluacion"
							Default="Tiene que indicar el tipo de evaluación"
							returnvariable="MSG_TieneQueIndicarElTipoDeEvaluacion"/>
							
							
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="MSG_SePresentaronLosSiguientesErrores"
							Default="Se presentaron los siguientes errores"
							returnvariable="MSG_SePresentaronLosSiguientesErrores"/>
							
														
							<cfoutput>
							
							
							
							if (form.REid.value == '' ){
								mensaje += ' - #MSG_ElCampoEvaluacionEsRequerido#.\n';
							}
							if(form.Jefatura.checked == false && form.Auto.checked == false){
								mensaje += ' - #MSG_TieneQueIndicarElTipoDeEvaluacion#.\n';
							}

							if ( mensaje != '' ){
								mensaje = '#MSG_SePresentaronLosSiguientesErrores#:\n' + mensaje;
								alert(mensaje);
								return false;
							}
							</cfoutput>
							return true;
							
						}
						function controlcheck(){
							if(document.form1.REaplicajefe.value == '1'){				
								document.form1.Jefatura.disabled = false;
							}
							else{
								document.form1.Jefatura.disabled = true;
							}	
							
							if(document.form1.REaplicaempleado.value == '1'){				
								document.form1.Auto.disabled = false;
							}
							else{
								document.form1.Auto.disabled = true;
							}	
							
							if(document.form1.REaplicajefe.value == '1' && document.form1.REaplicaempleado.value == '0'){
								document.form1.Jefatura.checked = true;
							}
							
							if(document.form1.REaplicajefe.value == '0' && document.form1.REaplicaempleado.value == '1'){
								document.form1.Auto.checked = true;
							}	
							
						}
						
					</script>
				<cf_web_portlet_end>
			</td></tr>
		</table>
<cf_templatefooter>