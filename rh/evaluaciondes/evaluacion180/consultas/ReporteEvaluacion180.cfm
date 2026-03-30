<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ReporteDeEvaluacionDelDesempenoDeJefaturas"
	Default="Reporte de Evaluaci&oacute;n del Desempe&ntilde;o de Jefaturas"
	returnvariable="LB_ReporteDeEvaluacionDelDesempenoDeJefaturas"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeEvaluacionesDelDesempenoDeJefaturas"
	Default="Lista de Evaluaciones del Desempe&ntilde;o de Jefaturas"	
	returnvariable="LB_ListaDeEvaluacionesDelDesempenoDeJefaturas"/> 
	
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
	Default="Descripci&oacute;n"	
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
	Default="Identificaci&oacute;n"	
	returnvariable="LB_Identificacion"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"	
	returnvariable="LB_Nombre"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"	
	returnvariable="LB_Codigo"/>	 
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Grupo"
	Default="Grupo"	
	returnvariable="LB_Grupo"/>	  
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
				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_ReporteDeEvaluacionDelDesempenoDeJefaturas#">
					<form name="form1" method="get" action="ReporteEvaluacion180_Rep.cfm" style="margin:0; " onSubmit="javascript: return validar(this);">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr><td colspan="4"><cfinclude template="../../../portlets/pNavegacion.cfm"></td></tr>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							
							<td width="45%"  valign="top">
								<cf_web_portlet_start border="true" titulo="#LB_ReporteDeEvaluacionDelDesempenoDeJefaturas#" skin="info1">
									<table width="100%" >
										<tr><td><p>
										<cf_translate  key="Ayuda_EsteReporteMuestraLosResultadosDeUnaEvaluacionEspecificaTantoDetalladaComoResumida">
											Este reporte muestra los resultados de una evaluaci&oacute;n espec&iacute;fica, tanto detallada como resumida, dando la posibilidad de verlos resultados de cada uno de los items por empleado o el listado de los resultados totales por empleado.
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
												tabindex="1"
												Desplegables="N,S"
												Modificables="N,N"
												Size="0,35"
												Title="#LB_ListaDeEvaluacionesDelDesempenoDeJefaturas#"
												Tabla="RHRegistroEvaluacion"
												Filtro="REestado  = 2  and Ecodigo = #Session.Ecodigo# order by REdescripcion"
												Desplegar="REdescripcion,REdesde,REhasta"
												Etiquetas="#LB_Descripcion#,#LB_Desde#,#LB_Hasta#"
												Columnas="REid,REdescripcion,REdesde,REhasta,REaplicajefe,REaplicaempleado"
												filtrar_por="REdescripcion,REdesde,REhasta"
												Formatos="S,D,D"
												Align="left,left,left"
												Asignar="REid,REdescripcion,REaplicajefe,REaplicaempleado"
												Asignarformatos="I,S"
												Alt="ID,#LB_Descripcion#"/>	<!---  --->
										</td>
									</tr>
									<tr>
										<td align="right"><cfoutput>#LB_Grupo#</cfoutput>&nbsp;:&nbsp;</td>
										<td>
											<cf_conlis
											   campos="GREid,GREnombre"
											   desplegables="N,S"
											   modificables="N,S"
											   size="0,40"
											   title="#LB_Grupo#"
											   tabla="RHGruposRegistroE"
											   columnas="GREid,GREnombre"
											   filtro="REid = $REid,numeric$ and Ecodigo = #Session.Ecodigo#"
											   desplegar="GREnombre"
											   filtrar_por="GREnombre"
											   filtrar_por_delimiters="|"
											   etiquetas="#LB_Nombre#"
											   formatos="S"
											   align="left"
											   asignar="GREid,GREnombre"
											   asignarformatos="S,S"
											   showemptylistmsg="true"
											   tabindex="1"
											   onchange="validaGR()"
											   funcion="validaGR()"
											   alt="ID,#LB_Nombre#">
										</td>									
									</tr>
									<tr id="EmpG"  style="display: none">
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Empleado">Empleado</cf_translate>:&nbsp;</td>
										<td >
											<cf_conlis
											   campos="DEidG,DEidentificacionG,NombreG"
											   desplegables="N,S,S"
											   modificables="N,S,N"
											   size="0,20,40"
											   title="#LB_ListaDeEmpleados#"
											   tabla=" RHGruposRegistroE gr
														inner join RHCFGruposRegistroE gcf
															on gcf.Ecodigo = gr.Ecodigo
															and gcf.GREid = gr.GREid
															
														inner join RHRegistroEvaluacion rel
															on rel.REid = gr.REid
															
														inner join RHPlazas rhp
															on rhp.Ecodigo = gcf.Ecodigo
															and rhp.CFid = gcf.CFid	
													
														inner join CFuncional cf
															on cf.Ecodigo=rhp.Ecodigo
															and cf.CFid=rhp.CFid
														
														inner join LineaTiempo lt
															on lt.Ecodigo = rhp.Ecodigo
															and lt.RHPid = rhp.RHPid
															and getDate() between lt.LTdesde and lt.LThasta
													
														inner join RHPuestos rhpu
															on rhpu.Ecodigo = lt.Ecodigo
															and rhpu.RHPcodigo = lt.RHPcodigo
													
														inner join DatosEmpleado de
															on de.Ecodigo = rhpu.Ecodigo
																and de.DEid = lt.DEid"
											   columnas="de.DEid as DEidG, de.DEidentificacion as DEidentificacionG, {fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )},  ' ' )}, de.DEnombre)} as NombreG"
											   filtro="gr.REid = $REid,numeric$ and gr.GREid = $GREid,numeric$ and de.Ecodigo = #Session.Ecodigo#  order by DEidentificacion"
											   desplegar="DEidentificacionG,NombreG"
											   filtrar_por="de.DEidentificacion|{fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )},  ' ' )}, de.DEnombre)}"
											   filtrar_por_delimiters="|"
											   etiquetas="#LB_Identificacion#,#LB_Nombre#"
											   formatos="S,S"
											   align="left,left"
											   asignar="DEidG,DEidentificacionG,NombreG"
											   asignarformatos="S,S,S"
											   showemptylistmsg="true"
											   tabindex="1"
											   alt="ID,#LB_Identificacion#,#LB_Nombre#">
										</td>
									</tr>
									<tr id="Emp">
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Empleado">Empleado</cf_translate>:&nbsp;</td>
										<td >
											<cf_conlis
											   campos="DEid,DEidentificacion,Nombre"
											   desplegables="N,S,S"
											   modificables="N,S,N"
											   size="0,20,40"
											   title="#LB_ListaDeEmpleados#"
											   tabla=" RHGruposRegistroE gr
														inner join RHCFGruposRegistroE gcf
															on gcf.Ecodigo = gr.Ecodigo
															and gcf.GREid = gr.GREid

														inner join RHRegistroEvaluacion rel
															on rel.REid = gr.REid
															
														inner join RHPlazas rhp
															on rhp.Ecodigo = gcf.Ecodigo
															and rhp.CFid = gcf.CFid	
													
														inner join CFuncional cf
															on cf.Ecodigo=rhp.Ecodigo
															and cf.CFid=rhp.CFid
														
														inner join LineaTiempo lt
															on lt.Ecodigo = rhp.Ecodigo
															and lt.RHPid = rhp.RHPid
															and getDate() between lt.LTdesde and lt.LThasta
													
														inner join RHPuestos rhpu
															on rhpu.Ecodigo = lt.Ecodigo
															and rhpu.RHPcodigo = lt.RHPcodigo
													
														inner join DatosEmpleado de
															on de.Ecodigo = rhpu.Ecodigo
																and de.DEid = lt.DEid"
											   columnas="de.DEid, de.DEidentificacion , {fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )},  ' ' )}, de.DEnombre)} as Nombre"
											   filtro="gr.REid = $REid,numeric$ and de.Ecodigo = #Session.Ecodigo#  order by DEidentificacion"
											   desplegar="DEidentificacion,Nombre"
											   filtrar_por="de.DEidentificacion|{fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )},  ' ' )}, de.DEnombre)}"
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
									<tr id="CFGR"  style="display: none">
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_CentroFuncional"> Centro Funcional</cf_translate>:&nbsp;</td>
										<td >
										<cf_conlis
											Campos="CFidG,CFcodigoG,CFdescripcionG"
											tabindex="1"
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
											Columnas="distinct c.CFid as CFidG,c.CFcodigo as CFcodigoG,c.CFdescripcion as CFdescripcionG"
											Filtro="REid = $REid,numeric$ 
													and a.Ecodigo = #Session.Ecodigo# 
													and a.GREid = $GREid,numeric$
													order by CFcodigo,CFdescripcion"
											Desplegar="CFcodigoG,CFdescripcionG"
											Etiquetas="#LB_Codigo#,#LB_Descripcion#"
											filtrar_por="c.CFcodigo,c.CFdescripcion"
											Formatos="S,S"
											Align="left,left"
											Asignar="CFidG,CFcodigoG,CFdescripcionG"
											Asignarformatos="I,S,S"
											alt="ID,#LB_Codigo#,#LB_Descripcion#"/>
										</td>
									</tr>
									<tr id="CF">
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
											Filtro="REid = $REid,numeric$ and a.Ecodigo = #Session.Ecodigo# 
														order by CFcodigo,CFdescripcion"
											Desplegar="CFcodigo,CFdescripcion"
											Etiquetas="#LB_Codigo#,#LB_Descripcion#"
											filtrar_por="c.CFcodigo,c.CFdescripcion"
											Formatos="S,S"
											Align="left,left"
											Asignar="CFid,CFcodigo,CFdescripcion"
											Asignarformatos="I,S,S"
											alt="ID,#LB_Codigo#,#LB_Descripcion#"/>
										</td>
									</tr>
									<tr>
										<td >&nbsp;</td>
										<td ><input type="radio" name="Tipo"  id="R" value="1" checked ><label for=R><cf_translate  key="LB_Resumido">Resumido</cf_translate></label>&nbsp;&nbsp;
										     <input type="radio" name="Tipo"  id="D" value="2" /><label for=D><cf_translate  key="LB_Detallado">Detallado</cf_translate></label>
										</td>									
									</tr>
									

									<tr>
											<td align="right"><cf_translate  key="LB_Formato">Formato</cf_translate>:&nbsp;</td>
											<td>
												<select name="formato" tabindex="1" onchange="javascript: deshabilita(this);">
													<option value="T"><cf_translate key="LB_Tabular">Tabular</cf_translate></option>
													<option value="G"><cf_translate key="LB_Grafico">Gr&aacute;fico</cf_translate></option>
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
							if ( mensaje != '' ){
								mensaje = '#MSG_SePresentaronLosSiguientesErrores#:\n' + mensaje;
								alert(mensaje);
								return false;
							}
							</cfoutput>
							return true;
							
						}
						function validaGR() {
							//VISUALIZA EL CENTRO FUNCIONAL Y LOS EMPLEADOS POR GRUPO SELECCIONADO
							var centro = document.getElementById("CF");
							var centroG = document.getElementById("CFGR");
							var emp = document.getElementById("Emp");
							var empG = document.getElementById("EmpG");
							var grupo = document.form1.GREid.value;
							if (emp.style.display == "" && grupo != "") {
								emp.style.display = "none";
								empG.style.display = "";
								document.form1.DEid.value = "";
								document.form1.DEidentificacion.value = "";
								document.form1.Nombre.value = "";
								document.form1.DEidG.value = "";
								document.form1.DEidentificacionG.value = "";
								document.form1.NombreG.value = "";
							} else {
								emp.style.display = "";
								empG.style.display = "none";
								document.form1.DEidG.value = "";
								document.form1.DEidentificacionG.value = "";
								document.form1.NombreG.value = "";
								document.form1.DEid.value = "";
								document.form1.DEidentificacion.value = "";
								document.form1.Nombre.value = "";
							}
							if (centro.style.display == "" && grupo != "") {
								centro.style.display = "none";
								centroG.style.display = "";
								document.form1.CFid.value="";
								document.form1.CFcodigo.value="";
								document.form1.CFdescripcion.value="";
								document.form1.CFidG.value="";
								document.form1.CFcodigoG.value="";
								document.form1.CFdescripcionG.value="";
							} else {
								centro.style.display = "";
								centroG.style.display = "none";
								document.form1.CFidG.value="";
								document.form1.CFcodigoG.value="";
								document.form1.CFdescripcionG.value="";
								document.form1.CFid.value="";
								document.form1.CFcodigo.value="";
								document.form1.CFdescripcion.value="";
							}
						}
						
						function deshabilita(obj){
							var dato = obj.value;
							var f = document.form1;
							f.Tipo[0].checked= true;
							if (dato == 'G'){
								f.Tipo[0].disabled = true;
								f.Tipo[1].disabled = true;
							}else{
								f.Tipo[0].disabled = false;
								f.Tipo[1].disabled = false;
							}
						}
					</script>
				<cf_web_portlet_end>
			</td></tr>
		</table>
<cf_templatefooter>