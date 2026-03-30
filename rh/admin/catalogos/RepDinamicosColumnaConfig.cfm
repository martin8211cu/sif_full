<!---►►►Variables de Navegacion◄◄◄--->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfif isdefined('url.Cid') and not isdefined('form.Cid')>
	<cfset form.Cid = url.Cid>
</cfif>
<cfif isdefined('url.RHRDEid') and not isdefined('form.RHRDEid')>
	<cfset form.RHRDEid = url.RHRDEid>
</cfif>

<!---►►►Variables de Traduccion◄◄◄ --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Anno" 				Default="Año" 						returnvariable="LB_Anno"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" 	Default="Recursos Humanos" 			returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_navConfigura" 		Default="Configuraci&oacute;n de Reporte" 	returnvariable="LB_navConfigura"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_compSalarial" 		Default="Componentes Salariales" 	returnvariable="LB_compSalarial"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_compSalarialInc" 		Default="Componentes Salariales a Incluir" 	returnvariable="LB_compSalarialInc"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_columna" 		returnvariable="LB_columna" 		Default="Columna" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_atras" 			returnvariable="LB_atras" 			Default="Atras" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_desc1Sal" 			returnvariable="LB_desc1Sal" 		Default="El reporte devolverá el monto o suma de los Componentes del Empleado según la Linea del Tiempo a la fecha de la Nómina.">
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_desc2Sal" 			returnvariable="LB_desc2Sal" 		Default="Utilice los botones para incluir o excluir Componentes:" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_descincT" 		returnvariable="LB_descincT" 		Default="Incluir Todos" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_descexcT" 		returnvariable="LB_descexcT" 		Default="Excluir Todos" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_descincS" 		returnvariable="LB_descincS" 		Default="Incluir Selección" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_descexcS" 		returnvariable="LB_descexcS" 		Default="Excluir Selección" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_buscar" 			returnvariable="LB_buscar" 			Default="Buscar" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_title" 			returnvariable="LB_title" 			Default="Configuracion Columna " >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_accion" 			returnvariable="LB_accion" 			Default="Tipos de Acción" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_accionInc" 		returnvariable="LB_accionInc" 		Default="Acciones a Incluir" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_concpagos" 		returnvariable="LB_concpagos" 		Default="Conceptos de Pago" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_concpagosInc" 	returnvariable="LB_concpagosInc" 	Default="Conceptos de Pago a Incluir" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_tDeduccion" 		returnvariable="LB_tDeduccion" 		Default="Tipos de Deducción" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_tdeduccionInc" 	returnvariable="LB_tdeduccionInc" 	Default="Tipos de Deducción a Incluir" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_cargas" 			returnvariable="LB_cargas" 			Default="Tipos de Cargas" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_cargasInc" 		returnvariable="LB_cargasInc" 		Default="Tipos de Cargas a incluir" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_seleccione" 		returnvariable="LB_seleccione" 		Default="Seleccione" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_empleado" 		returnvariable="LB_empleado" 		Default="Empleado" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_patronal" 		returnvariable="LB_patronal" 		Default="Patronal" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ambas" 			returnvariable="LB_ambas" 			Default="Ambas" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_especiales" 		returnvariable="LB_especiales" 		Default="Tipos de Especiales" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_especialesInc" 	returnvariable="LB_especialesInc" 	Default="Tipos de Especiales a Incluir" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_datEmpleado" 	returnvariable="LB_datEmpleado" 	Default="Datos del Empleado" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_empleadoInc" 	returnvariable="LB_empleadoInc" 	Default="Datos del Empleado a incluir">
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nomina" 			returnvariable="LB_nomina" 			Default="Datos de la Nómina" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nominaInc" 		returnvariable="LB_nominaInc" 		Default="Datos de la Nómina a incluir">
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_monto" 			returnvariable="LB_monto" 			Default="Monto" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_unit" 			returnvariable="LB_unit" 			Default="Unidades" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_configN" 		returnvariable="LB_configN" 		Default="Configuración No Agregada" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_config" 			returnvariable="LB_config" 			Default="Configuración Agregada" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_totalizar" 		returnvariable="LB_totalizar" 		Default="Columnas Totalizar" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_totalizarInc" 	returnvariable="LB_totalizarInc" 	Default="Columnas Totalizar a Incluir">
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_taccion" 		returnvariable="LB_taccion" 		Default="Pagos por Tipo de Accion" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_tconceptos" 		returnvariable="LB_tconceptos" 		Default="Conceptos de Pago" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_tdeducciones" 	returnvariable="LB_tdeducciones" 	Default="Deducciones" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_tcargas" 		returnvariable="LB_tcargas" 		Default="Cargas" >
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_tespeciales" 	returnvariable="LB_tespeciales" 	Default="Especiales" >

<cfquery name="rsInfoColumna" datasource="#session.DSN#">
	select RHRDEdescripcion,Cdescripcion,Ctipo,RHRDEcodigo,RHRDEdescripcion
	from RHReportesDinamicoC a
		inner join RHReportesDinamicoE b
			on a.RHRDEid = b.RHRDEid
	where Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">
</cfquery>


<cf_templateheader>
  	<cf_web_portlet_start border="true" titulo="#LB_title#" skin="#session.preferences.skin#" >
	<cf_importJquery>
       <style type="text/css">
          .fila{  }       
          .seleccionado{
             background: rgb(183,215,241)
          }

        .maxTamDiv{overflow-y: auto;max-height: 20em;}
		.classButton {
			-moz-box-shadow:inset 0px 1px 0px 0px #ffffff;
			-webkit-box-shadow:inset 0px 1px 0px 0px #ffffff;
			box-shadow:inset 0px 1px 0px 0px #ffffff;
			background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #ededed), color-stop(1, #c9c9c9) );
			background:-moz-linear-gradient( center top, #ededed 5%, #c9c9c9 100% );
			filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#ededed', endColorstr='#c9c9c9');
			background-color:#ededed;
			-moz-border-radius:6px;
			-webkit-border-radius:6px;
			border-radius:6px;
			border:1px solid #bdbdbd;
			display:inline-block;
			color:#777777;
			font-family:arial;
			font-size:15px;
			font-weight:bold;
			width:62px;
			height:35px;
			text-decoration:none;
			text-shadow:1px 1px 0px #ffffff;
		}.classButton:hover {
			background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #c9c9c9), color-stop(1, #ededed) );
			background:-moz-linear-gradient( center top, #c9c9c9 5%, #ededed 100% );
			filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#c9c9c9', endColorstr='#ededed');
			background-color:#c9c9c9; 
		}.classButton:active {
			position:relative;
			top:1px;
		}
		.panel-success {
			border-color: #3c763d;
		} 
		.panel-success>.panel-heading {
			background-color: #3c763d;
			color: white;
		}
		.panel>.panel-body {
			cursor: pointer;
		}


		<cfset cssTablas ="">
		.ListaAcciones{<cfoutput>#cssTablas#</cfoutput>}
		.ListaAccionesIncluir{<cfoutput>#cssTablas#</cfoutput>}
		.ListaComponentes{<cfoutput>#cssTablas#</cfoutput>}
		.ListaComponentesIncluir{<cfoutput>#cssTablas#</cfoutput>}
		.ListaConceptos{<cfoutput>#cssTablas#</cfoutput>}
		.ListaConceptosIncluir{<cfoutput>#cssTablas#</cfoutput>}
		.ListaDeducciones{<cfoutput>#cssTablas#</cfoutput>}
		.ListaDeduccionesIncluir{<cfoutput>#cssTablas#</cfoutput>}
		.ListaCargas{<cfoutput>#cssTablas#</cfoutput>}
		.ListaCargasIncluir{<cfoutput>#cssTablas#</cfoutput>}
		.ListaEspeciales{<cfoutput>#cssTablas#</cfoutput>}
		.ListaEspecialesIncluir{<cfoutput>#cssTablas#</cfoutput>}
		.ListEmpleado{<cfoutput>#cssTablas#</cfoutput>}
		.ListEmpleadoIncluir{<cfoutput>#cssTablas#</cfoutput>}
		.ListNomina{<cfoutput>#cssTablas#</cfoutput>}
		.ListNominaIncluir{<cfoutput>#cssTablas#</cfoutput>}
		.ListFormular{<cfoutput>#cssTablas#</cfoutput>}
		.ListFormularincluir{<cfoutput>#cssTablas#</cfoutput>}

		.modale {
		    display: none;
		    position:   fixed;
		    z-index:    1000;
		    top:        50%;
		    left:       50%;
		    height:     100%;
		    width:      100%;
		    background: transparent; 
            border: 16px solid #cadae8; 
		    border-top: 16px solid #3498db;
		    border-radius: 50%;
		    width: 120px;
		    height: 120px;
		    animation: spin 2s linear infinite;
		}

		@keyframes spin {
		    0% { transform: rotate(0deg); }
		    100% { transform: rotate(360deg); }
		}

		/* When the body has the loading class, we turn
		   the scrollbar off with overflow:hidden */
		body.loading {
		    overflow: hidden;   
		    pointer-events: none;
		}

		/* Anytime the body has the loading class, our
		   modal element will be visible */
		body.loading .modale {
		    display: inline;
		}

		</style>
		
  		<cfoutput>      
		<cfsavecontent variable="helpimg">
			<img src="../../imagenes/Help02_T.gif" width="25" height="25" border="0"/>
		</cfsavecontent>		
		<table width="100%" bgcolor="CCCCCC" cellpadding="2px">
		<tr>
		<td align="left" style="font-size:14px"><input type="button" class="btnAnterior" value="#LB_atras#" onclick="regresar()" /><strong><cfoutput>#LB_columna#</cfoutput>:</strong>&nbsp;#rsInfoColumna.Cdescripcion#</td>
				<cfif rsInfoColumna.Ctipo eq 2><!--- empleado---->
										<td  align="right"><cf_notas titulo="#LB_empleado#" position="left" link="#helpimg#" pageIndex="1" msg = "Permite visualizar en el Reporte las caracter&iacute;sticas del Empleado.<br><br> Utilice los botones para incluir o excluir caracter&iacute;sticas<br><b>>></b> = Incluir Todos<br><b><<</b> = Excluir Todos<br><b>></b> = Incluir Selecci&oacute;n<br><b><</b> = Excluir Selecci&oacute;n<br><br><b>Asc/Desc:</b>Ascendente o Descendente, es el orden de la Columna<br><b>Min/Max: </b>Especifica si utiliza el Puesto del M&iacute;nimo o M&aacute;ximo corte del Empleado seg&uacute;n las fechas de la N&oacute;mina" animar="true"></td>	
				<cfelseif rsInfoColumna.Ctipo eq 3><!---- nomina---->
										<td align="right"><cf_notas titulo="Configurar #LB_nomina#" position="left" link="#helpimg#" pageIndex="1" msg = "Permite visualizar en el Reporte las caracter&iacute;sticas de la N&oacute;mina.<br><br> Utilice los botones para incluir o excluir caracter&iacute;sticas<br><b>>></b> = Incluir Todos<br><b><<</b> = Excluir Todos<br><b>></b> = Incluir Selecci&oacute;n<br><b><</b> = Excluir Selecci&oacute;n" animar="true"></td>	
				<cfelseif rsInfoColumna.Ctipo eq 10><!--- formular----->
										<td align="right"><cf_notas titulo="Configurar Formulaci&oacute;n" position="left" link="#helpimg#" pageIndex="1" msg = "Permite visualizar en el Reporte columnas formuladas como resultado de operaciones entre columnas.<br><br> Utilice los botones para incluir o excluir formulaciones<br><b>>></b> = Incluir Todos<br><b><<</b> = Excluir Todos<br><b>></b> = Incluir Selecci&oacute;n<br><b><</b> = Excluir Selecci&oacute;n<br><br><b>Asc/Des: </b> Ascendente o Descendente, especifica el orden de la Columna en el reporte" animar="true"></td>	
				<cfelseif rsInfoColumna.Ctipo eq 20><!--- Totalizar ----->
										<td align="right"><cf_notas titulo="Configurar #LB_totalizar#" position="left" link="#helpimg#" pageIndex="1" msg = "Permite visualizar en el Reporte una Columna con la Suma de varias columnas. <br><br> Utilice los botones para incluir o excluir Columnas a Totalizar mediante Suma <br><b>>></b> = Incluir Todos<br><b><<</b> = Excluir Todos<br><b>></b> = Incluir Selecci&oacute;n<br><b><</b> = Excluir Selecci&oacute;n<br><br>" animar="true"></td>	
				</cfif>
		</tr>
		</table>
		<table><tr><td>&nbsp;</td></tr></table>
			<div class="modale"></div>			
					
		<cfinclude template="RepDinamicosJS.cfm">
		<cfif rsInfoColumna.Ctipo eq 1>			<!--- sumarizar --->
			<cf_tabs>
				<cf_tab text="#LB_taccion#" selected="true">
					<cfquery datasource="#session.dsn#" name="rsTipoAccion">
						select RHTid,RHTcodigo, RHTdesc,
						case when (	select count(1) 
									from RHReportesDinamicoCSUM 
									where Cid = #form.Cid#
									and CSUMreferencia = rh.RHTid
									and CSUMtipo = 1
									and Ecodigo = #session.Ecodigo#) > 0<!---- tipo 1 acciones---->
						then 1
						else 0
						end as incluido			
						from RHTipoAccion rh
						where Ecodigo = #session.Ecodigo#
						order by RHTdesc,RHTcodigo
					</cfquery>

						<div class="row">
							<div class="col col-sm-12">
								<cf_notas titulo="#LB_accion#" position="left" link="#helpimg#" pageIndex="1" msg = "El reporte devolver&aacute; el monto del Salario seg&uacute;n el Tipo de Acci&oacute;n aplicada al Empleado en la N&oacute;mina.<br><br> Utilice los botones para incluir o excluir Tipos de Acciones:<br><b>>></b> = #LB_descincT#<br><b><<</b> = #LB_descexcT#<br><b>></b> = #LB_descincS#<br><b><</b> = #LB_descexcS#" animar="true">
							</div>	
						</div>	

						<div class="row"> 
							<div class="col-md-5 col-sm-5">
								<div class="panel panel-primary">
									<div class="panel-heading">
										<b><cfoutput>#LB_accion#</cfoutput></b>
									</div>
									<div class="panel-body">
										<div class="row">
											<div class="col col-sm-12"><b><cfoutput>#LB_buscar#</cfoutput></b><input type="text"  id="filtroAccionesA" value="" size="20"></div>
										</div>
										<div class="row maxTamDiv">
											<table class="ListaAcciones" id="ListaAcciones">
												<cfloop query="rsTipoAccion">
													<cfif rsTipoAccion.incluido eq 0>
														 <tr class="fila" id="#RHTid#">
															<td>#rsTipoAccion.RHTcodigo#</td>
															<td>- #rsTipoAccion.RHTdesc#</td>
														 </tr>
													 </cfif>
												 </cfloop>
											</table>
										</div>
									</div>
								</div>
							</div>
							<div class="col-md-2 col-sm-2"> 
								<div class="row"></div>
								<div class="row text-center">
									<table align="center">
										<tr><td align="center"><input type="button" class="classButton" id="incluirAccionTodos" value=">>"></td></tr>
										<tr><td align="center"><input type="button" class="classButton" id="incluirAccion" value=">"></td></tr>
										<tr><td align="center"><input type="button" class="classButton" id="excluirAccion" value="<"></td></tr>
										<tr><td align="center"><input type="button" class="classButton" id="excluirAccionTodos" value="<<"></td></tr>
									</table>
								 </div>
							</div>
							<div class="col-md-5 col-sm-5">
								<div class="panel panel-success">
									<div class="panel-heading">
										<b><cfoutput>#LB_accionInc#</cfoutput></b>
									</div>
									<div class="panel-body">
										<div class="row">
											<div class="col col-sm-12"><b><cfoutput>#LB_buscar#</cfoutput></b><input type="text"  id="filtroAccionesB" value="" size="20"></div>
										</div>
										<div class="row maxTamDiv">
											<table class="ListaAccionesIncluir" id="ListaAccionesIncluir">
												<cfloop query="rsTipoAccion">
													<cfif rsTipoAccion.incluido eq 1>
														 <tr class="fila" id="#RHTid#">
															<td>#rsTipoAccion.RHTcodigo#</td>
															<td>- #rsTipoAccion.RHTdesc#</td>
														 </tr>
													 </cfif>
												 </cfloop>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>

				</cf_tab>
				<cf_tab text="#LB_tconceptos#">
	
					<cfquery datasource="#session.dsn#" name="rsIncidencias">
						select CIid,CIcodigo, CIdescripcion,
						case when (	select count(1) 
									from RHReportesDinamicoCSUM 
									where Cid = #form.Cid#
									and CSUMreferencia = rh.CIid
									and CSUMtipo = 2
									and Ecodigo = #session.Ecodigo#) > 0<!---- tipo 2 =  conceptos de pago----->
						then 1
						else 0
						end as incluido			
						from CIncidentes rh
						where Ecodigo = #session.Ecodigo#
						order by CIdescripcion,CIcodigo
					</cfquery>
					
 
						<div class="row">
							<div class="col col-sm-12">
								<cf_notas titulo="Conceptos de Pago" position="left" link="#helpimg#" pageIndex="3" msg = "El reporte devolver&aacute; el monto o suma de los Conceptos de Pago del Empleado en la N&oacute;mina.<br><br> Utilice los botones para incluir o excluir Conceptos de Pago:<br><b>>></b> = #LB_descincT#<br><b><<</b> = #LB_descexcT#<br><b>></b> = #LB_descincS#<br><b><</b> = #LB_descexcS#" animar="true">
							</div>	
						</div>	
						<div class="row"> 
							<div class="col-md-5 col-sm-5">
								<div class="panel panel-primary">
									<div class="panel-heading">
										<b><cfoutput>#LB_concpagos#</cfoutput></b>
									</div>
									<div class="panel-body">
										<div class="row">
											<div class="col col-sm-12"><b><cfoutput>#LB_buscar#</cfoutput></b><input type="text"  id="filtroConceptosPagoA" value="" size="20"></div>
										</div>
										<div class="row maxTamDiv">
											<table class="ListaConceptos" id="ListaConceptos">
												<cfloop query="rsIncidencias">
													<cfif rsIncidencias.incluido eq 0>
														 <tr class="fila" id="#rsIncidencias.CIid#">
															<td>#trim(rsIncidencias.CIcodigo)#</td>
															<td>- #trim(rsIncidencias.CIdescripcion)#</td>
														 </tr>
													 </cfif>
												 </cfloop>
											</table>
										</div>
									</div>
								</div>
							</div>
							<div class="col-md-2 col-sm-2"> 
								<div class="row"></div>
								<div class="row text-center">
									<table align="center">
										<tr><td align="center"><input type="button" class="classButton" id="incluirConceptoTodos" value=">>"></td></tr>
										<tr><td align="center"><input type="button" class="classButton" id="incluirConcepto" value=">">	</td></tr>
										<tr><td align="center"><input type="button" class="classButton" id="excluirConcepto" value="<"></td></tr>
										<tr><td align="center"><input type="button" class="classButton" id="excluirConceptoTodos" value="<<"></td></tr>	
									</table>
								 </div>
							</div>
							<div class="col-md-5 col-sm-5">
								<div class="panel panel-success">
									<div class="panel-heading">
										<b><cfoutput>#LB_concpagosInc#</cfoutput></b>
									</div>
									<div class="panel-body">
										<div class="row">
											<div class="col col-sm-12"><b><cfoutput>#LB_buscar#</cfoutput></b><input type="text"  id="filtroConceptosPagoB" value="" size="20"></div>
										</div>
										<div class="row maxTamDiv">
											<table class="ListaConceptosIncluir" id="ListaConceptosIncluir" >
												<cfloop query="rsIncidencias">
													<cfif rsIncidencias.incluido eq 1>
														<tr class="fila" id="#rsIncidencias.CIid#">
															<td>#rsIncidencias.CIcodigo#</td>
															<td>- #rsIncidencias.CIdescripcion#</td>
														</tr>
													</cfif>
												</cfloop>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>
				</cf_tab>
				<cf_tab text="#LB_tdeducciones#">
					<cfquery datasource="#session.dsn#" name="rsDeducciones">
						select TDid,TDcodigo, TDdescripcion,
						case when (	select count(1) 
									from RHReportesDinamicoCSUM 
									where Cid = #form.Cid#
									and CSUMreferencia = rh.TDid
									and CSUMtipo = 3
									and Ecodigo = #session.Ecodigo#) > 0<!---- tipo 3 =  Deducciones----->
						then 1
						else 0
						end as incluido			
						from TDeduccion rh
						where Ecodigo = #session.Ecodigo#
						order by TDdescripcion,TDcodigo
					</cfquery>
					  
					 
					<div class="row">
						<div class="col col-sm-12">
							<cf_notas titulo="Tipos de Deducci&oacute;n" position="left" link="#helpimg#" pageIndex="4" msg = "El reporte devolver&aacute; el monto o suma de las Deducciones del Empleado en la N&oacute;mina.<br><br> Utilice los botones para incluir o excluir Tipos de Deducci&oacute;n:<br><b>>></b> = #LB_descincT#<br><b><<</b> = #LB_descexcT#<br><b>></b> = #LB_descincS#<br><b><</b> = #LB_descexcS#" animar="true">
						</div>	
					</div>	

					<div class="row"> 
						<div class="col-md-5 col-sm-5">
							<div class="panel panel-primary">
								<div class="panel-heading">
									<b><cfoutput>#LB_tdeduccion#</cfoutput></b>
								</div>
								<div class="panel-body">
									<div class="row">
										<div class="col col-sm-12"><b><cfoutput>#LB_buscar#</cfoutput></b><input type="text"  id="filtroDeduccionesA" value="" size="20"></div>
									</div>
									<div class="row maxTamDiv">
										<table class="ListaDeducciones" id="ListaDeducciones">
											<cfloop query="rsDeducciones">
												<cfif rsDeducciones.incluido eq 0>
													 <tr class="fila" id="#rsDeducciones.TDid#">
														<td>#trim(rsDeducciones.TDcodigo)#</td>
														<td>- #trim(rsDeducciones.TDdescripcion)#</td>
													 </tr>
												 </cfif>
											 </cfloop>
										</table>
									</div>
								</div>
							</div>
						</div>
						<div class="col-md-2 col-sm-2"> 
							<div class="row"></div>
							<div class="row text-center">
								<table align="center">
									<tr><td align="center"><input type="button" class="classButton" id="incluirDeduccionTodos" value=">>"></td></tr>
									<tr><td align="center"><input type="button" class="classButton" id="incluirDeduccion" value=">"></td></tr>
									<tr><td align="center"><input type="button" class="classButton" id="excluirDeduccion" value="<"></td></tr>
									<tr><td align="center"><input type="button" class="classButton" id="excluirDeduccionTodos" value="<<"></td></tr> 
								</table>
							 </div>
						</div>
						<div class="col-md-5 col-sm-5">
							<div class="panel panel-success">
								<div class="panel-heading">
									<b><cfoutput>#LB_tdeduccionInc#</cfoutput></b>
								</div>
								<div class="panel-body">
									<div class="row">
										<div class="col col-sm-12"><b><cfoutput>#LB_buscar#</cfoutput></b><input type="text"  id="filtroDeduccionesB" value="" size="20"></div>
									</div>
									<div class="row maxTamDiv">
										<table class="ListaDeduccionesIncluir" id="ListaDeduccionesIncluir" >
											<cfloop query="rsDeducciones">
												<cfif rsDeducciones.incluido eq 1>
													 <tr class="fila" id="#rsDeducciones.TDid#">
														<td>#rsDeducciones.TDcodigo#</td>
														<td>- #rsDeducciones.TDdescripcion#</td>
													 </tr>
												 </cfif>
											 </cfloop>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>

				</cf_tab>
				<cf_tab text="#LB_tcargas#">
					<cfquery datasource="#session.dsn#" name="rsCargas">
						select DClinea,DCcodigo, DCdescripcion,
						case when (	select count(1) 
									from RHReportesDinamicoCSUM 
									where Cid = #form.Cid#
									and CSUMreferencia = rh.DClinea
									and CSUMtipo = 4
									and Ecodigo = #session.Ecodigo#) > 0<!---- tipo 4 =  Cargas----->
						then 1
						else 0
						end as incluido,
						(	select coalesce(CSUMsubtipo,1)
							from RHReportesDinamicoCSUM 
							where Cid = #form.Cid#
							and CSUMreferencia = rh.DClinea
							and CSUMtipo = 4
							and Ecodigo = #session.Ecodigo#
						) as incluidoTipo,
						case when DCvaloremp != 0
								then 0
							when DCvaloremp = 0
								then 1
							else 2
						end as defaultTipo		
						from DCargas rh
						where Ecodigo = #session.Ecodigo#
						order by DCdescripcion,DCcodigo
					</cfquery>
			 
						<div class="row">
							<div class="col col-sm-12">
								<cf_notas titulo="Configurar Cargas" position="left" link="#helpimg#" pageIndex="5" msg = "El reporte devolver&aacute; el monto o suma de las Cargas del Empleado y/o Patrono en la N&oacute;mina.<br><br> Utilice los botones para incluir o excluir Tipos de Cargas:<br><b>>></b> = #LB_descincT#<br><b><<</b> = #LB_descexcT#<br><b>></b> = #LB_descincS#<br><b><</b> = #LB_descexcS#" animar="true">
							</div>	
						</div>	

						<div class="row"> 
							<div class="col-md-5 col-sm-5">
								<div class="panel panel-primary">
									<div class="panel-heading">
										<b><cfoutput>#LB_cargas#</cfoutput></b>
									</div>
									<div class="panel-body">
										<div class="row">
											<div class="col col-md-9"><b><cfoutput>#LB_buscar#</cfoutput></b><input type="text"  id="filtroCargasA" value="" size="20"></div>
											<div class="col col-md-3">
												<select id="cambiarAllTiposCargas" >
													<option value="" selected disabled><cfoutput>#LB_seleccione#</cfoutput></option>
													<option value="1"><cfoutput>#LB_empleado#</cfoutput></option>
													<option value="2"><cfoutput>#LB_patronal#</cfoutput></option>
													<option value="3"><cfoutput>#LB_ambas#</cfoutput></option>
												</select>
											</div>
										</div>
										<div class="row maxTamDiv">
											<table class="ListaCargas" id="ListaCargas">
												<cfloop query="rsCargas">
													<cfif rsCargas.incluido eq 0>
														 <tr class="fila" id="#rsCargas.DClinea#">
															<td>#trim(rsCargas.DCcodigo)#</td>
															<td>- #trim(rsCargas.DCdescripcion)#</td>
															<td>
																<select id="TipoCarga#rsCargas.DClinea#" class="selectorCargas">
																	<option value="1" <cfif rsCargas.defaultTipo eq 0>selected="selected"</cfif> ><cfoutput>#LB_empleado#</cfoutput></option>
																	<option value="2" <cfif rsCargas.defaultTipo eq 1>selected="selected"</cfif> ><cfoutput>#LB_patronal#</cfoutput></option>
																	<option value="3" <cfif rsCargas.defaultTipo eq 2>selected="selected"</cfif> ><cfoutput>#LB_ambas#</cfoutput></option>
																</select>
															</td>
														 </tr>
													 </cfif>
												 </cfloop>
											</table>
										</div>
									</div>
								</div>
							</div>
							<div class="col-md-2 col-sm-2"> 
								<div class="row"></div>
								<div class="row text-center">
									<table align="center">
										<tr><td align="center"><input type="button" class="classButton" id="incluirCargaTodos" value=">>"></td></tr>
										<tr><td align="center"><input type="button" class="classButton" id="incluirCarga" value=">"></td></tr>
										<tr><td align="center"><input type="button" class="classButton" id="excluirCarga" value="<"></td></tr>
										<tr><td align="center"><input type="button" class="classButton" id="excluirCargaTodos" value="<<"></td></tr>
									</table>
								 </div>
							</div>
							<div class="col-md-5 col-sm-5">
								<div class="panel panel-success">
									<div class="panel-heading">
										<b><cfoutput>#LB_cargasInc#</cfoutput></b>
									</div>
									<div class="panel-body">
										<div class="row">
											<div class="col col-sm-12"><b><cfoutput>#LB_buscar#</cfoutput></b><input type="text"  id="filtroCargasB" value="" size="20"></div>
										</div>
										<div class="row maxTamDiv">
											<table class="ListaCargasIncluir" id="ListaCargasIncluir" >
												<cfloop query="rsCargas">
													<cfif rsCargas.incluido eq 1>
														 <tr class="fila" id="#rsCargas.DClinea#">
															<td>#rsCargas.DCcodigo#</td>
															<td>- #rsCargas.DCdescripcion#</td>
															<td>
																<select disabled="disabled" id="TipoCarga#rsCargas.DClinea#" class="selectorCargas">
																	<option value="1" <cfif rsCargas.incluidoTipo eq 1>selected="selected"</cfif> ><cfoutput>#LB_empleado#</cfoutput></option>
																	<option value="2" <cfif rsCargas.incluidoTipo eq 2>selected="selected"</cfif> ><cfoutput>#LB_patronal#</cfoutput></option>
																	<option value="3" <cfif rsCargas.incluidoTipo eq 3>selected="selected"</cfif> ><cfoutput>#LB_ambas#</cfoutput></option>
																</select>
															</td>
														 </tr>
													 </cfif>
												 </cfloop>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>
				</cf_tab>
				<cf_tab text="#LB_tespeciales#">
					<cfquery datasource="#session.dsn#" name="rsEspeciales">
						select CSUMreferencia as tipo<!---- 1 = renta tabla, 2 = renta deduccion,  3 = liquido,  4 = ISPT----->
						from RHReportesDinamicoCSUM 
						where Cid = #form.Cid#
							and CSUMtipo = 5<!---- tipo 5 =  Especial----->
							and CSUMreferencia in (1,2,3,4)
							and Ecodigo = #session.Ecodigo#
						order by CSUMreferencia
					</cfquery> 
						<div class="row">
							<div class="col col-sm-12">
								<cf_notas titulo="Tipos Especiales" position="left" link="#helpimg#" pageIndex="6" msg = "El reporte devolver&aacute; el monto o suma del Elemento Especial seleccionado seg&uacute;n la N&oacute;mina.<br><br> Utilice los botones para incluir o excluir Tipos Especiales:<br><b>>></b> = #LB_descincT#<br><b><<</b> = #LB_descexcT#<br><b>></b> = #LB_descincS#<br><b><</b> = #LB_descexcS#" animar="true">
							</div>	
						</div>	
						<div class="row"> 
							<div class="col-md-5 col-sm-5">
								<div class="panel panel-primary">
									<div class="panel-heading">
										<b><cfoutput>#LB_especiales#</cfoutput></b>
									</div>
									<div class="panel-body">
										<div class="row maxTamDiv">
											<table class="ListaEspeciales" id="ListaEspeciales">
												<cfif  rsEspeciales.recordcount eq 0>
													 <tr class="fila" id="1">
														<td>Renta Tabla</td>
													 </tr>
													 <tr class="fila" id="2">
														<td>Renta Deducci&oacute;n</td>
													 </tr>
													 <tr class="fila" id="3">
														<td>L&iacute;quidos</td>
													 </tr>
													 <tr class="fila" id="4">
														<td>ISPT</td>
													 </tr>
												<cfelse>
													<cfquery dbtype="query" name="chkRentaT">
														select * from rsEspeciales where tipo=1
													</cfquery>									
													<cfquery dbtype="query" name="chkRentaD">
														select * from rsEspeciales where tipo=2
													</cfquery>
													<cfquery dbtype="query" name="chkLiquido">
														select * from rsEspeciales where tipo=3
													</cfquery>
													<cfquery dbtype="query" name="chkISPT">
														select * from rsEspeciales where tipo=4
													</cfquery>
													<cfif chkRentaT.recordcount eq 0>
														<tr class="fila" id="1">
															<td>Renta Tabla</td>
														</tr>
													</cfif>
													<cfif chkRentaD.recordcount eq 0>
														<tr class="fila" id="2">
															<td>Renta Deducci&oacute;n</td>
														</tr>
													</cfif>
													<cfif chkLiquido.recordcount eq 0>
														<tr class="fila" id="3">
															<td>L&iacute;quidos</td>
													 	</tr>
													</cfif>
													<cfif chkISPT.recordcount eq 0>
														<tr class="fila" id="4">
															<td>ISPT</td>
													 	</tr>
													</cfif>
												</cfif>
											</table>
										</div>
									</div>
								</div>
							</div>
							<div class="col-md-2 col-sm-2"> 
								<div class="row"></div>
								<div class="row text-center">
									<table align="center">
										<tr><td align="center"><input type="button" class="classButton" id="incluirEspecialesTodos" value=">>"></td></tr>
										<tr><td align="center"><input type="button" class="classButton" id="incluirEspeciales" value=">"></td></tr>
										<tr><td align="center"><input type="button" class="classButton" id="excluirEspeciales" value="<"></td></tr>
										<tr><td align="center"><input type="button" class="classButton" id="excluirEspecialesTodos" value="<<"></td></tr>
									</table>
								 </div>
							</div>
							<div class="col-md-5 col-sm-5">
								<div class="panel panel-success">
									<div class="panel-heading">
										<b><cfoutput>#LB_especialesInc#</cfoutput></b>
									</div>
									<div class="panel-body">
										<div class="row maxTamDiv">
											<table class="ListaEspecialesIncluir" id="ListaEspecialesIncluir" >
												<cfloop query="rsEspeciales">
													<cfif rsEspeciales.tipo eq 1><!----- Renta tabla------>
														 <tr class="fila" id="1">
															<td>Renta Tabla</td>
														 </tr>
													 <cfelseif rsEspeciales.tipo eq 2><!----- Renta deduccion------>
														 <tr class="fila" id="2">
															<td>Renta Deducci&oacute;n</td>
														 </tr>
													 <cfelseif  rsEspeciales.tipo eq 3><!---- liquido----->
														 <tr class="fila" id="3">
															<td>L&iacute;quidos</td>
														 </tr>
													 <cfelseif  rsEspeciales.tipo eq 4><!---- ISPT----->
														 <tr class="fila" id="4">
															<td>ISPT</td>
														 </tr>
													 </cfif>
												 </cfloop>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>
				</cf_tab>
			</cf_tabs>
		<cfelseif rsInfoColumna.Ctipo eq 2>	<!---- columna tipo empleado----->
			<cfquery datasource="#session.dsn#" name="rsConfigEmpleado">
				select CCTEcampo, CCTEorderDatos
				from RHReportesDinamicoCCTE 
				where Cid = #form.Cid#
					and CCTEtipo = 1<!---- tipo Empleado----->
				order by CCTEorder asc	
			</cfquery> 

			<div class="row"> 
				<div class="col-md-5 col-sm-5">
					<div class="panel panel-primary">
						<div class="panel-heading">
							<b>Datos del Empleado</b>
						</div>
						<div class="panel-body">
							<div class="row">
								<div class="col-md-2 col-md-offset-8">
									<select id="cambiarAllordenEmpleado" >
										<option value="1" selected="selected">Asc</option>
										<option value="2">Desc</option>
									</select>
								</div>
							</div>
							<div class="row maxTamDiv">
								<table class="ListEmpleado" id="ListEmpleado">
									<cfquery dbtype="query" name="rsIdentificacion">
										select CCTEorderDatos from rsConfigEmpleado where CCTEcampo like '%DEidentificacion%'
									</cfquery>

									<cfif rsIdentificacion.recordcount eq 0>
										<tr class="fila" id="DEidentificacion">
											<td>Identificaci&oacute;n</td>
											<td>
												<select id="orderDEidentificacion" class="selectorEmpleado">
													<option value="1" selected="selected">Asc</option>
													<option value="2">Desc</option>												
												</select>
											</td>
										</tr>
									</cfif>

									<!----- se agrega id de tarjeta como parte de la info a mostrar en el empleado---->
									<cfquery dbtype="query" name="rsDEtarjeta">
										select CCTEorderDatos from rsConfigEmpleado where CCTEcampo like '%DEtarjeta%'
									</cfquery>

									<cfif rsDEtarjeta.recordcount eq 0>
										<tr class="fila" id="DEtarjeta">
											<td>Id Tarjeta</td>
											<td>
												<select id="orderDEtarjeta" class="selectorEmpleado">
													<option value="1" selected="selected">Asc</option>
													<option value="2">Desc</option>												
												</select>
											</td>
										</tr>
									</cfif>

									<!----- se agrega RFC como parte de la info a mostrar en el empleado---->
									<cfquery dbtype="query" name="rsRFC">
										select CCTEorderDatos from rsConfigEmpleado where CCTEcampo like 'RFC%'
									</cfquery>
									<cfif rsRFC.recordcount eq 0>
										<tr class="fila" id="RFC">
											<td>RFC</td>
											<td>
												<select id="orderRFC" class="selectorEmpleado">
													<option value="1" selected="selected">Asc</option>
													<option value="2">Desc</option>												
												</select>
											</td>
										</tr>
									</cfif>

									<!----- se agrega CURP como parte de la info a mostrar en el empleado---->
									<cfquery dbtype="query" name="rsCURP">
										select CCTEorderDatos from rsConfigEmpleado where CCTEcampo like 'CURP%'
									</cfquery>
									<cfif rsCURP.recordcount eq 0>
										<tr class="fila" id="CURP">
											<td>CURP</td>
											<td>
												<select id="orderCURP" class="selectorEmpleado">
													<option value="1" selected="selected">Asc</option>
													<option value="2">Desc</option>												
												</select>
											</td>
										</tr>
									</cfif>

									<!----- se agrega DESeguroSocial como parte de la info a mostrar en el empleado---->
									<cfquery dbtype="query" name="rsDESeguroSocial">
										select CCTEorderDatos from rsConfigEmpleado where CCTEcampo like 'DESeguroSocial%'
									</cfquery>
									<cfif rsDESeguroSocial.recordcount eq 0>
										<tr class="fila" id="DESeguroSocial">
											<td>Seguro Social</td>
											<td>
												<select id="orderDESeguroSocial" class="selectorEmpleado">
													<option value="1" selected="selected">Asc</option>
													<option value="2">Desc</option>												
												</select>
											</td>
										</tr>
									</cfif>

									<cfquery dbtype="query" name="rsDEnombre">
										select CCTEorderDatos from rsConfigEmpleado where CCTEcampo like '%DEnombre%'
									</cfquery>

									<cfif rsDEnombre.recordcount  eq 0>
										<tr class="fila" id="DEnombre">
											<td>Nombre</td>
											<td>
												<select id="orderDEnombre" class="selectorEmpleado">
													<option value="1" selected="selected">Asc</option>
													<option value="2">Desc</option>	
												</select>
											</td>
										</tr>
									</cfif>

									<cfquery dbtype="query" name="rsDEapellido1">
										select CCTEorderDatos from rsConfigEmpleado where CCTEcampo like '%DEapellido1%'
									</cfquery>

									<cfif rsDEapellido1.recordcount  eq 0>
										<tr class="fila" id="DEapellido1">
											<td>Primer Apellido</td>
											<td>
												<select id="orderDEapellido1" class="selectorEmpleado">
													<option value="1" selected="selected">Asc</option>
													<option value="2">Desc</option>	
												</select>
											</td>
										</tr>
									</cfif>
											 
											 
									<cfquery dbtype="query" name="rsDEapellido2">
										select CCTEorderDatos from rsConfigEmpleado where CCTEcampo like '%DEapellido2%'
									</cfquery>
									<cfif rsDEapellido2.recordcount  eq 0>
										<tr class="fila" id="DEapellido2">
											<td>Segundo Apellido</td>
											<td>
												<select id="orderDEapellido2" class="selectorEmpleado">
													<option value="1" selected="selected">Asc</option>
													<option value="2">Desc</option>	
												</select>
											</td>
										</tr>
									</cfif>
											 
											 
									<cfquery dbtype="query" name="rsRHPcodigo">
										select CCTEorderDatos from rsConfigEmpleado where CCTEcampo like '%RHPcodigo%'
									</cfquery>
									<cfquery dbtype="query" name="rsRHPdescpuesto">
										select CCTEorderDatos from rsConfigEmpleado where CCTEcampo like '%RHPdescpuesto%'
									</cfquery>
									<cfset tieneCodigo = rsRHPcodigo.recordcount gt 0>
									<cfset tieneDescripcion = rsRHPdescpuesto.recordcount gt 0>

									<cfif rsRHPcodigo.recordcount  eq 0>
										<tr class="fila" id="RHPcodigo">
											<td>C&oacute;digo del Puesto</td>
											<td>
												<select id="orderRHPcodigo" class="selectorEmpleado" <cfif tieneDescripcion>disabled="disabled"</cfif> >
													<option value="1" selected="selected">Asc</option>
													<option value="2">Desc</option>	
												</select>
											</td>
											<td>
												<select id="agregadoRHPcodigo" class="selectorEmpleado" <cfif tieneDescripcion>disabled="disabled"</cfif>>
													<option value="1" selected="selected">Min</option>
													<option value="2">Max</option>	
												</select>
											</td>
										</tr>
									</cfif>

									<cfif rsRHPdescpuesto.recordcount  eq 0>
										<tr class="fila" id="RHPdescpuesto">
											<td>Descripci&oacute;n del Puesto</td>
											<td>
												<select id="orderRHPdescpuesto" class="selectorEmpleado" <cfif tieneCodigo>disabled="disabled"</cfif>>
													<option value="1" selected="selected">Asc</option>
													<option value="2">Desc</option>	
												</select>
											</td>
											<td>
												<select id="agregadoRHPdescpuesto" class="selectorEmpleado" <cfif tieneCodigo>disabled="disabled"</cfif>>
													<option value="1" selected="selected">Min</option>
													<option value="2">Max</option>	
												</select>
											</td>
										</tr>
									</cfif>

									<!--- Categorias del puesto --->

									<cfquery dbtype="query" name="rsRHCcodigo">
										select CCTEorderDatos from rsConfigEmpleado where CCTEcampo like '%RHCcodigo%'
									</cfquery>
									<cfquery dbtype="query" name="rsRHCdescripcion">
										select CCTEorderDatos from rsConfigEmpleado where CCTEcampo like '%RHCdescripcion%'
									</cfquery>
									<cfset tieneCodigo = rsRHCcodigo.recordcount gt 0>
									<cfset tieneDescripcion = rsRHCdescripcion.recordcount gt 0>

									<cfif !tieneCodigo>
										<tr class="fila" id="RHCcodigo">
											<td>C&oacute;digo de la Categor&iacute;a</td>
											<td>
												<select id="orderRHCcodigo" class="selectorEmpleado" <cfif tieneDescripcion>disabled="disabled"</cfif> >
													<option value="1" selected="selected">Asc</option>
													<option value="2">Desc</option>	
												</select>
											</td>
											<td>
												<select id="agregadoRHCcodigo" class="selectorEmpleado" <cfif tieneDescripcion>disabled="disabled"</cfif>>
													<option value="1" selected="selected">Min</option>
													<option value="2">Max</option>	
												</select>
											</td>
										</tr>
									</cfif>

									<cfif !tieneDescripcion>
										<tr class="fila" id="RHCdescripcion">
											<td>Descripci&oacute;n de la Categor&iacute;a</td>
											<td>
												<select id="orderRHCdescripcion" class="selectorEmpleado" <cfif tieneCodigo>disabled="disabled"</cfif>>
													<option value="1" selected="selected">Asc</option>
													<option value="2">Desc</option>	
												</select>
											</td>
											<td>
												<select id="agregadoRHCdescripcion" class="selectorEmpleado" <cfif tieneCodigo>disabled="disabled"</cfif>>
													<option value="1" selected="selected">Min</option>
													<option value="2">Max</option>	
												</select>
											</td>
										</tr>
									</cfif>



											 
									 <!----- Centro Funcional--------------------->
									<cfquery dbtype="query" name="rsCFcodigo">
										select CCTEorderDatos from rsConfigEmpleado where CCTEcampo like '%CFcodigo%'
									</cfquery>
									<cfquery dbtype="query" name="rsCFdescripcion">
										select CCTEorderDatos from rsConfigEmpleado where CCTEcampo like '%CFdescripcion%'
									</cfquery>
									<cfset tieneCodigo = rsCFcodigo.recordcount gt 0>
									<cfset tieneDescripcion = rsCFdescripcion.recordcount gt 0>

									<cfif rsCFcodigo.recordcount  eq 0>
										<tr class="fila" id="CFcodigo">
											<td>C&oacute;digo del Centro Funcional</td>
											<td>
												<select id="orderCFcodigo" class="selectorEmpleado" <cfif tieneDescripcion>disabled="disabled"</cfif> >
													<option value="1" selected="selected">Asc</option>
													<option value="2">Desc</option>	
												</select>
											</td>
											<td>
												<select id="agregadoCFcodigo" class="selectorEmpleado" <cfif tieneDescripcion>disabled="disabled"</cfif>>
													<option value="1" selected="selected">Min</option>
													<option value="2">Max</option>	
												</select>
											</td>
										</tr>
									</cfif>

									<cfif rsCFdescripcion.recordcount  eq 0>
										<tr class="fila" id="CFdescripcion">
											<td>Descripci&oacute;n del Centro Funcional</td>
											<td>
												<select id="orderCFdescripcion" class="selectorEmpleado" <cfif tieneCodigo>disabled="disabled"</cfif>>
													<option value="1" selected="selected">Asc</option>
													<option value="2">Desc</option>	
												</select>
											</td>
											<td>
												<select id="agregadoCFdescripcion" class="selectorEmpleado" <cfif tieneCodigo>disabled="disabled"</cfif>>
													<option value="1" selected="selected">Min</option>
													<option value="2">Max</option>	
												</select>
											</td>
										</tr>
									</cfif>
								</table>
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-2 col-sm-2"> 
					<div class="row"></div>
					<div class="row text-center">
						<table align="center">
							<tr><td align="center"><input type="button" class="classButton" id="incluirEmpleadoTodos" value=">>"></td></tr>
							<tr><td align="center"><input type="button" class="classButton" id="incluirEmpleado" value=">"></td></tr>
							<tr><td align="center"><input type="button" class="classButton" id="excluirEmpleado" value="<"></td></tr>
							<tr><td align="center"><input type="button" class="classButton" id="excluirEmpleadoTodos" value="<<"></td></tr>
						</table>
					 </div>
				</div>
				<div class="col-md-5 col-sm-5">
					<div class="panel panel-success">
						<div class="panel-heading">
							<b>Datos del Empleado a Incluir</b>
						</div>
						<div class="panel-body">
							<div class="row maxTamDiv">
								<table class="ListEmpleadoIncluir" id="ListEmpleadoIncluir" >
									<cfloop query="rsConfigEmpleado">
										<cfif trim(rsConfigEmpleado.CCTEcampo) eq 'DEidentificacion'>
										 <tr class="fila" id="DEidentificacion">
											<td>Identificaci&oacute;n</td>
											<td>
												<select id="orderDEidentificacion" class="selectorEmpleado" disabled="disabled">
													<option value="1" <cfif rsConfigEmpleado.CCTEorderDatos eq 1>selected="selected" </cfif>>Asc</option>
													<option value="2" <cfif rsConfigEmpleado.CCTEorderDatos eq 2>selected="selected" </cfif>>Desc</option>
												</select>
											</td>
										 </tr>
										 </cfif>

										<cfif trim(rsConfigEmpleado.CCTEcampo) eq 'DEtarjeta'>
										 <tr class="fila" id="DEtarjeta">
											<td>Id Tarjeta</td>
											<td>
												<select id="orderDEtarjeta" class="selectorEmpleado" disabled="disabled">
													<option value="1" <cfif rsConfigEmpleado.CCTEorderDatos eq 1>selected="selected" </cfif>>Asc</option>
													<option value="2" <cfif rsConfigEmpleado.CCTEorderDatos eq 2>selected="selected" </cfif>>Desc</option>
												</select>
											</td>
										 </tr>
										</cfif>
					
										<cfif trim(rsConfigEmpleado.CCTEcampo) eq 'RFC'>
										 <tr class="fila" id="RFC">
											<td>RFC</td>
											<td>
												<select id="orderRFC" class="selectorEmpleado" disabled="disabled">
													<option value="1" <cfif rsConfigEmpleado.CCTEorderDatos eq 1>selected="selected" </cfif>>Asc</option>
													<option value="2" <cfif rsConfigEmpleado.CCTEorderDatos eq 2>selected="selected" </cfif>>Desc</option>
												</select>
											</td>
										 </tr>
										</cfif>

										<cfif trim(rsConfigEmpleado.CCTEcampo) eq 'CURP'>
										 <tr class="fila" id="CURP">
											<td>CURP</td>
											<td>
												<select id="orderCURP" class="selectorEmpleado" disabled="disabled">
													<option value="1" <cfif rsConfigEmpleado.CCTEorderDatos eq 1>selected="selected" </cfif>>Asc</option>
													<option value="2" <cfif rsConfigEmpleado.CCTEorderDatos eq 2>selected="selected" </cfif>>Desc</option>
												</select>
											</td>
										 </tr>
										</cfif>

										<cfif trim(rsConfigEmpleado.CCTEcampo) eq 'DESeguroSocial'>
										 <tr class="fila" id="DESeguroSocial">
											<td>Seguro Social</td>
											<td>
												<select id="orderDESeguroSocial" class="selectorEmpleado" disabled="disabled">
													<option value="1" <cfif rsConfigEmpleado.CCTEorderDatos eq 1>selected="selected" </cfif>>Asc</option>
													<option value="2" <cfif rsConfigEmpleado.CCTEorderDatos eq 2>selected="selected" </cfif>>Desc</option>
												</select>
											</td>
										 </tr>
										</cfif>


										<cfif trim(rsConfigEmpleado.CCTEcampo) eq 'DEnombre'>
										 <tr class="fila" id="DEnombre">
											<td>Nombre</td>
											<td>
												<select id="orderDEnombre" class="selectorEmpleado" disabled="disabled">
													<option value="1" <cfif rsConfigEmpleado.CCTEorderDatos eq 1>selected="selected" </cfif>>Asc</option>
													<option value="2" <cfif rsConfigEmpleado.CCTEorderDatos eq 2>selected="selected" </cfif>>Desc</option>
												</select>
											</td>
										 </tr>
										 </cfif>

										<cfif trim(rsConfigEmpleado.CCTEcampo) eq 'DEapellido1'>
										 <tr class="fila" id="DEapellido1">
											<td>Primer Apellido</td>
											<td>
												<select id="orderDEapellido1" class="selectorEmpleado" disabled="disabled">
													<option value="1" <cfif rsConfigEmpleado.CCTEorderDatos eq 1>selected="selected" </cfif>>Asc</option>
													<option value="2" <cfif rsConfigEmpleado.CCTEorderDatos eq 2>selected="selected" </cfif>>Desc</option>
												</select>
											</td>
										 </tr>
										 </cfif>

										<cfif trim(rsConfigEmpleado.CCTEcampo) eq 'DEapellido2'>
										 <tr class="fila" id="DEapellido2">
											<td>Segundo Apellido</td>
											<td>
												<select id="orderDEapellido2" class="selectorEmpleado" disabled="disabled">
													<option value="1" <cfif rsConfigEmpleado.CCTEorderDatos eq 1>selected="selected" </cfif>>Asc</option>
													<option value="2" <cfif rsConfigEmpleado.CCTEorderDatos eq 2>selected="selected" </cfif>>Desc</option>
												</select>
											</td>
										 </tr>
										 </cfif>
										 
										<cfif trim(rsConfigEmpleado.CCTEcampo) eq 'RHPcodigo'>
										 <tr class="fila" id="RHPcodigo">
											<td>C&oacute;digo del Puesto</td>
											<td>
												<select id="orderRHPcodigo" class="selectorEmpleado" disabled="disabled">
													<option value="1" <cfif rsConfigEmpleado.CCTEorderDatos eq 1>selected="selected" </cfif>>Asc</option>
													<option value="2" <cfif rsConfigEmpleado.CCTEorderDatos eq 2>selected="selected" </cfif>>Desc</option>
												</select>
											</td>
											<td>
												<select id="agregadoRHPcodigo" class="selectorEmpleado" disabled="disabled">
													<option value="1" <cfif rsConfigEmpleado.CCTEorderDatos eq 1>selected="selected" </cfif>>Min</option>
													<option value="2" <cfif rsConfigEmpleado.CCTEorderDatos eq 2>selected="selected" </cfif>>Max</option>
												</select>
											</td>
										 </tr>
										 </cfif>
										 
										<cfif trim(rsConfigEmpleado.CCTEcampo) eq 'RHPdescpuesto'>
										 <tr class="fila" id="RHPdescpuesto">
											<td>Descripci&oacute;n de Puesto</td>
											<td>
												<select id="orderRHPdescpuesto" class="selectorEmpleado" disabled="disabled">
													<option value="1" <cfif rsConfigEmpleado.CCTEorderDatos eq 1>selected="selected" </cfif>>Asc</option>
													<option value="2" <cfif rsConfigEmpleado.CCTEorderDatos eq 2>selected="selected" </cfif>>Desc</option>
												</select>
											</td>
											<td>
												<select id="agregadoRHPdescpuesto" class="selectorEmpleado" disabled="disabled">
													<option value="1" <cfif rsConfigEmpleado.CCTEorderDatos eq 1>selected="selected" </cfif>>Min</option>
													<option value="2" <cfif rsConfigEmpleado.CCTEorderDatos eq 2>selected="selected" </cfif>>Max</option>
												</select>
											</td>
										 </tr>
										</cfif>

										<cfif trim(rsConfigEmpleado.CCTEcampo) eq 'RHCcodigo'>
										 <tr class="fila" id="RHCcodigo">
											<td>C&oacute;digo de la Categor&iacute;a</td>
											<td>
												<select id="orderRHCcodigo" class="selectorEmpleado" disabled="disabled">
													<option value="1" <cfif rsConfigEmpleado.CCTEorderDatos eq 1>selected="selected" </cfif>>Asc</option>
													<option value="2" <cfif rsConfigEmpleado.CCTEorderDatos eq 2>selected="selected" </cfif>>Desc</option>
												</select>
											</td>
											<td>
												<select id="agregadoRHCcodigo" class="selectorEmpleado" disabled="disabled">
													<option value="1" <cfif rsConfigEmpleado.CCTEorderDatos eq 1>selected="selected" </cfif>>Min</option>
													<option value="2" <cfif rsConfigEmpleado.CCTEorderDatos eq 2>selected="selected" </cfif>>Max</option>
												</select>
											</td>
										 </tr>
										 </cfif>
										 
										<cfif trim(rsConfigEmpleado.CCTEcampo) eq 'RHCdescripcion'>
										 <tr class="fila" id="RHCdescripcion">
											<td>Descripci&oacute;n de la Categor&iacute;a</td>
											<td>
												<select id="orderRHCdescripcion" class="selectorEmpleado" disabled="disabled">
													<option value="1" <cfif rsConfigEmpleado.CCTEorderDatos eq 1>selected="selected" </cfif>>Asc</option>
													<option value="2" <cfif rsConfigEmpleado.CCTEorderDatos eq 2>selected="selected" </cfif>>Desc</option>
												</select>
											</td>
											<td>
												<select id="agregadoRHCdescripcion" class="selectorEmpleado" disabled="disabled">
													<option value="1" <cfif rsConfigEmpleado.CCTEorderDatos eq 1>selected="selected" </cfif>>Min</option>
													<option value="2" <cfif rsConfigEmpleado.CCTEorderDatos eq 2>selected="selected" </cfif>>Max</option>
												</select>
											</td>
										 </tr>
										</cfif>
										 
										<cfif trim(rsConfigEmpleado.CCTEcampo) eq 'CFcodigo'>
										 <tr class="fila" id="CFcodigo">
											<td>C&oacute;digo del Centro Funcional</td>
											<td>
												<select id="orderCFcodigo" class="selectorEmpleado" disabled="disabled">
													<option value="1" <cfif rsConfigEmpleado.CCTEorderDatos eq 1>selected="selected" </cfif>>Asc</option>
													<option value="2" <cfif rsConfigEmpleado.CCTEorderDatos eq 2>selected="selected" </cfif>>Desc</option>
												</select>
											</td>
											<td>
												<select id="agregadoCFcodigo" class="selectorEmpleado" disabled="disabled">
													<option value="1" <cfif rsConfigEmpleado.CCTEorderDatos eq 1>selected="selected" </cfif>>Min</option>
													<option value="2" <cfif rsConfigEmpleado.CCTEorderDatos eq 2>selected="selected" </cfif>>Max</option>
												</select>
											</td>
										 </tr>
										 </cfif>
										 
										<cfif trim(rsConfigEmpleado.CCTEcampo) eq 'CFdescripcion'>
										 <tr class="fila" id="CFdescripcion">
											<td>Descripci&oacute;n del Centro Funcional</td>
											<td>
												<select id="orderCFdescripcion" class="selectorEmpleado" disabled="disabled">
													<option value="1" <cfif rsConfigEmpleado.CCTEorderDatos eq 1>selected="selected" </cfif>>Asc</option>
													<option value="2" <cfif rsConfigEmpleado.CCTEorderDatos eq 2>selected="selected" </cfif>>Desc</option>
												</select>
											</td>
											<td>
												<select id="agregadoCFdescripcion" class="selectorEmpleado" disabled="disabled">
													<option value="1" <cfif rsConfigEmpleado.CCTEorderDatos eq 1>selected="selected" </cfif>>Min</option>
													<option value="2" <cfif rsConfigEmpleado.CCTEorderDatos eq 2>selected="selected" </cfif>>Max</option>
												</select>
											</td>
										 </tr>
										 </cfif>
										
									</cfloop>	 
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
		<cfelseif rsInfoColumna.Ctipo eq 3>		<!--- nomina --->
			<cfquery datasource="#session.dsn#" name="rsConfigNomina">
				select CCTEcampo, CCTEagregado
				from RHReportesDinamicoCCTE 
				where Cid = #form.Cid#
					and CCTEtipo = 3<!----Tipo Nomina ----->
				order by CCTEorder asc	
			</cfquery>
			<div class="row"> 
				<div class="col-md-5 col-sm-5">
					<div class="panel panel-primary">
						<div class="panel-heading">
							<b>Datos de la N&oacute;mina</b>
						</div>
						<div class="panel-body">
							<div class="row">
								<div class="col-md-2 col-md-offset-8">
									<select id="cambiarAllordenNomina" >
										<option value="1" selected="selected">Asc</option>
										<option value="2">Desc</option>
									</select>
								</div>
							</div>
							<div class="row maxTamDiv">
								<div class="col-md-10 col-md-offset-1">
									<table class="ListNomina" id="ListNomina">
										<cfquery dbtype="query" name="rsTcodigo">
											select CCTEagregado from rsConfigNomina where CCTEcampo like '%Tcodigo%'
										</cfquery>
										<cfif rsTcodigo.recordcount eq 0>
										 <tr class="fila" id="Tcodigo">
											<td>C&oacute;digo</td>
											<td>
												<select id="orderTcodigo" class="selectorNomina">
													<option value="1" selected="selected">Asc</option>
													<option value="2">Desc</option>											
												</select>
											</td>
										</tr>
										</cfif>
										<cfquery dbtype="query" name="rsTdescripcion">
											select CCTEagregado from rsConfigNomina where CCTEcampo like '%Tdescripcion%'
										</cfquery>
										<cfif rsTdescripcion.recordcount  eq 0>
										 <tr class="fila" id="Tdescripcion">
											<td>Descripci&oacute;n</td>
											<td>
												<select id="orderTdescripcion" class="selectorNomina">
													<option value="1" selected="selected">Asc</option>
													<option value="2">Desc</option>	
												</select>
											</td>
										</tr>
										</cfif>
										<cfquery dbtype="query" name="rsRCdesde">
											select CCTEagregado from rsConfigNomina where CCTEcampo like '%RCdesde%'
										</cfquery>
										<cfif rsRCdesde.recordcount  eq 0>
										 <tr class="fila" id="RCdesde">
											<td>Fecha Desde</td>
											<td>
												<select id="orderRCdesde" class="selectorNomina">
													<option value="1" selected="selected">Asc</option>
													<option value="2">Desc</option>	
												</select>
											</td>
										</tr>
										</cfif>
										<cfquery dbtype="query" name="rsRChasta">
											select CCTEagregado from rsConfigNomina where CCTEcampo like '%RChasta%'
										</cfquery>
										<cfif rsRChasta.recordcount  eq 0>
										 <tr class="fila" id="RChasta">
											<td>Fecha Hasta</td>
											<td>
												<select id="orderRChasta" class="selectorNomina">
													<option value="1" selected="selected">Asc</option>
													<option value="2">Desc</option>	
												</select>
											</td>
										</tr>
										</cfif>
										<cfquery dbtype="query" name="rsCPfpago">
											select CCTEagregado from rsConfigNomina where CCTEcampo like '%CPfpago%'
										</cfquery>
										<cfif rsCPfpago.recordcount  eq 0>
											<tr class="fila" id="CPfpago">
												<td>Fecha Pago</td>
												<td>
													<select id="orderCPfpago" class="selectorNomina">
														<option value="1" selected="selected">Asc</option>
														<option value="2">Desc</option>	
													</select>
												</td>
											</tr>
										</cfif>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-2 col-sm-2"> 
					<div class="row"></div>
					<div class="row text-center">
						<table align="center">
							<tr><td align="center"><input type="button" class="classButton" id="incluirNomina" value=">"></td></tr>
							<tr><td align="center"><input type="button" class="classButton" id="excluirNomina" value="<"></td></tr>
							<tr><td align="center"><input type="button" class="classButton" id="excluirNominaTodos" value="<<"></td></tr>
							<tr><td align="center"><input type="button" class="classButton" id="incluirNominaTodos" value=">>"></td></tr>
						</table>
					 </div>
				</div>
				<div class="col-md-5 col-sm-5">
					<div class="panel panel-success">
						<div class="panel-heading">
							<b>Datos de la N&oacute;mina a Incluir</b>
						</div>
						<div class="panel-body">
							<div class="row maxTamDiv">
								<div class="col-md-10 col-md-offset-1">
									<table class="ListNominaIncluir" id="ListNominaIncluir" >
										<cfloop query="rsConfigNomina">
											<cfif trim(rsConfigNomina.CCTEcampo) eq 'Tcodigo'>
											 <tr class="fila" id="Tcodigo">
												<td>C&oacute;digo</td>
												<td>
													<select id="orderTcodigo" class="selectorNomina" disabled="disabled">
														<option value="1" <cfif rsConfigNomina.CCTEagregado eq 1>selected="selected" </cfif>>Asc</option>
														<option value="2" <cfif rsConfigNomina.CCTEagregado eq 2>selected="selected" </cfif>>Desc</option>
													</select>
												</td>
											 </tr>
											 </cfif>

											<cfif trim(rsConfigNomina.CCTEcampo) eq 'Tdescripcion'>
											 <tr class="fila" id="Tdescripcion">
												<td>Descripci&oacute;n</td>
												<td>
													<select id="orderTdescripcion" class="selectorNomina" disabled="disabled">
														<option value="1" <cfif rsConfigNomina.CCTEagregado eq 1>selected="selected" </cfif>>Asc</option>
														<option value="2" <cfif rsConfigNomina.CCTEagregado eq 2>selected="selected" </cfif>>Desc</option>
													</select>
												</td>
											 </tr>
											 </cfif>

											<cfif trim(rsConfigNomina.CCTEcampo) eq 'RCdesde'>
											 <tr class="fila" id="RCdesde">
												<td>Fecha Desde</td>
												<td>
													<select id="orderRCdesde" class="selectorNomina" disabled="disabled">
														<option value="1" <cfif rsConfigNomina.CCTEagregado eq 1>selected="selected" </cfif>>Asc</option>
														<option value="2" <cfif rsConfigNomina.CCTEagregado eq 2>selected="selected" </cfif>>Desc</option>
													</select>
												</td>
											 </tr>
											 </cfif>

											<cfif trim(rsConfigNomina.CCTEcampo) eq 'RChasta'>
											 <tr class="fila" id="RChasta">
												<td>Fecha Hasta</td>
												<td>
													<select id="orderRChasta" class="selectorNomina" disabled="disabled">
														<option value="1" <cfif rsConfigNomina.CCTEagregado eq 1>selected="selected" </cfif>>Asc</option>
														<option value="2" <cfif rsConfigNomina.CCTEagregado eq 2>selected="selected" </cfif>>Desc</option>
													</select>
												</td>
											 </tr>
											 </cfif>
											 
											<cfif trim(rsConfigNomina.CCTEcampo) eq 'CPfpago'>
											 <tr class="fila" id="CPfpago">
												<td>Fecha Pago</td>
												<td>
													<select id="orderCPfpago" class="selectorNomina" disabled="disabled">
														<option value="1" <cfif rsConfigNomina.CCTEagregado eq 1>selected="selected" </cfif>>Asc</option>
														<option value="2" <cfif rsConfigNomina.CCTEagregado eq 2>selected="selected" </cfif>>Desc</option>
													</select>
												</td>
											 </tr>
											 </cfif>
										</cfloop>	 
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		<cfelseif rsInfoColumna.Ctipo eq 4><!---- tipo informacion salarial------->	
			<cfquery datasource="#session.dsn#" name="rsComponentes">
				select CSid,CScodigo, CSdescripcion,
				case when (	select count(1) 
							from RHReportesDinamicoCSUM 
							where Cid = #form.Cid#
							and CSUMreferencia = cs.CSid
							and CSUMtipo = 6 
							and Ecodigo = #session.Ecodigo#) > 0<!---- tipo 6 =  Componentes Salariales----->
				then 1
				else 0
				end as incluido			
				from ComponentesSalariales cs
				where cs.Ecodigo = #session.Ecodigo#
				order by cs.CScodigo, cs.CSdescripcion
			</cfquery>
			<div class="row">
				<cf_notas titulo="#LB_compSalarial#" position="left" link="#helpimg#" pageIndex="2" msg = "#LB_desc1Sal#.<br><br> #LB_desc2Sal#<br><b>>></b> = #LB_descincT#<br><b><<</b> = #LB_descexcT#<br><b>></b> = #LB_descincS#<br><b><</b> = #LB_descexcS#" animar="true">
			</div>

			<div class="row"> 
				<div class="col-md-5 col-sm-5">
					<div class="panel panel-primary">
						<div class="panel-heading">
							<b><cfoutput>#LB_compSalarial#</cfoutput></b>
						</div>
						<div class="panel-body">
							<div class="row">
								<b><cfoutput>#LB_buscar#</cfoutput></b><input type="text"  id="filtroComponentesA" value="" size="20">
								<select id="agregado" class="selectorCS" onchange="changeAll(this)">
									<option value="0">Min</option>
									<option value="1">Max</option>
								</select>
								<select id="tsuma" class="sumaCS" onchange="changeAllSuma(this)">
									<option value="1">Unidades</option>
									<option value="2">Monto</option>
								</select>
							</div>
							<div class="row maxTamDiv">
								<table class="ListaComponentes" id="ListaComponentes">
									<cfloop query="rsComponentes">
										<cfif rsComponentes.incluido eq 0>
											 <tr class="fila" id="#rsComponentes.CSid#">
												<td>#trim(rsComponentes.CScodigo)#</td>
												<td>- #trim(rsComponentes.CSdescripcion)#</td>
												<td style="display:none">
													<select id="agregado#rsComponentes.CSid#" class="selectorCS" onchange="changeAll(this)">
														<option value="0">Min</option>
														<option value="1">Max</option>
													</select>
													<select id="tsuma#rsComponentes.CSid#" class="sumaCS" onchange="changeAllSuma(this)">
														<option value="1">Unidades</option>
														<option value="2">Monto</option>
													</select>
												</td>
											 </tr>
										 </cfif>
									 </cfloop>
								</table>
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-2 col-sm-2"> 
					<div class="row"></div>
					<div class="row text-center">
						<table align="center">
							<tr><td align="center"><input type="button" class="classButton" id="incluirComponentesTodos" value=">>"></td></tr>
							<tr><td align="center"><input type="button" class="classButton" id="incluirComponentes" value=">">	</td></tr>
							<tr><td align="center"><input type="button" class="classButton" id="excluirComponentes" value="<"></td></tr>
							<tr><td align="center"><input type="button" class="classButton" id="excluirComponentesTodos" value="<<"></td></tr>
						</table>
					 </div>
				</div>
				<div class="col-md-5 col-sm-5">
					<div class="panel panel-success">
						<div class="panel-heading">
							<b><cfoutput>#LB_compSalarialInc#</cfoutput></b>
						</div>
						<div class="panel-body">
							<div class="row">
								<b><cfoutput>#LB_buscar#</cfoutput></b><input type="text"  id="filtroComponentesB" value="" size="20">
							</div>
							<div class="row maxTamDiv">
								<table class="ListaComponentesIncluir" id="ListaComponentesIncluir" >
									<cfloop query="rsComponentes">
										<cfif rsComponentes.incluido eq 1>
											 <tr class="fila" id="#rsComponentes.CSid#">
												<td>#rsComponentes.CScodigo#</td>
												<td>- #rsComponentes.CSdescripcion#</td>
												<td>
													<select id="agregado#rsComponentes.CSid#" class="selectorCS">
														<option value="0">Min</option>
														<option value="1">Max</option>
													</select>
													<select id="tsuma#rsComponentes.CSid#" class="sumaCS">
														<option value="1">Unidades</option>
														<option value="2">Monto</option>
													</select>
												</td>
											</tr>
										 </cfif>
									 </cfloop>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
			<script language="javascript"> habilitarDeshabilitar();</script>
		<cfelseif rsInfoColumna.Ctipo eq 10><!---- columnas formuladas------>			
			<cfquery datasource="#session.dsn#" name="rsPopulateColumnas">
				select rh.Cdescripcion, rh.Cid,
						 (select count(1) 
						 from RHReportesDinamicoCFOR
						 where CFORcolA =  rh.Cid
						 and Cid = #form.Cid#) as ColumnaA,
						 (select count(1) 
						 from RHReportesDinamicoCFOR
						 where CFORcolB =  rh.Cid
						 and Cid = #form.Cid#) as ColumnaB
				from RHReportesDinamicoC rh
				where rh.Ctipo in (1,4,10,20)
				and rh.RHRDEid = (select x.RHRDEid from RHReportesDinamicoC x where Cid =#form.Cid#)
				and rh.Corden < (select Corden 
							  from RHReportesDinamicoC 
							  where Cid = #form.Cid#) <!---- solo se deben mostrar las columnas que tienen un orden previo--->
			</cfquery>
			
			<cfquery datasource="#session.dsn#" name="rsConfigFormuladaValores">
				select rh.CFORtipo, rh.CFORcteA, rh.CFORcteB, rh.CFORorder
				from RHReportesDinamicoCFOR rh
				where rh.Cid = #form.Cid# <!---- solo se deben mostrar las columnas que tienen un orden previo--->
			</cfquery>
			<cfset  usarValorA = len(trim(rsConfigFormuladaValores.CFORcteA)) gt 0>
			<cfset  usarValorB = len(trim(rsConfigFormuladaValores.CFORcteB)) gt 0>
			<div class="row"> 
				<div class="col-md-5 col-sm-5">
					<div class="panel panel-primary">
						<div class="panel-heading">
							<b>Configuraci&oacute;n No Agregada</b>
						</div>
						<div class="panel-body">
							<div class="row maxTamDiv">
								<table class="ListFormular" id="ListFormular">
									<cfif rsConfigFormuladaValores.recordcount eq 0>
										<tbody>
											<tr>
												<td><b>Tipo:</b></td>
												<td align="left">
													<select id="cmbTipoA" name="cmbTipoA" class="selectorFormulada">
														<option value="1"selected="selected">Columna</option>
														<option value="2">Valor</option>
													</select>
												</td>
												<td id="VerColumnasA">
													<select id="cmbColumnaA" class="selectorFormulada">
														<cfloop query="rsPopulateColumnas">
															<option value="#Cid#" selected="selected">#Cdescripcion#</option>
														</cfloop>
													</select>
												</td>
												<td id="VerValorA">
													<cf_inputNumber name="inpValorA" decimales="2" enteros="7">
												</td>
											</tr>
											<!---- operador----->
											<tr>
												<td><b>Operador:</b></td>
												<td colspan="2" align="center">
													<select id="cmbTipoOperador" name="cmbTipoOperador" class="selectorFormulada">
															<option value="1" selected="selected" >Multiplicacion</option>
															<option value="2">Division</option>
															<option value="3">Suma</option>
															<option value="4">Resta</option>																
													</select>
												</td>
											</tr>
											<!---- columna B----->
											<tr>
												<td><b>Tipo:</b></td>
												<td align="left">
													<select id="cmbTipoB" name="cmbTipoB" class="selectorFormulada">
														<option value="1" selected="selected">Columna</option>
														<option value="2">Valor</option>
													</select>
												</td>
												<td id="VerColumnasB">
													<select id="cmbColumnaB" class="selectorFormulada">
														<cfloop query="rsPopulateColumnas">
															<option value="#Cid#">#Cdescripcion#</option>
														</cfloop>
													</select>
												</td>
												<td id="VerValorB">
													<cf_inputNumber name="inpValorB" decimales="2" enteros="7">
												</td>
											</tr>
											<!---- Ordenamiento de los datos------> 
											<tr>
												<td><b>Orden:</b></td>
												<td colspan="2" align="center">
													<select id="orderColumnaFormulada" name="orderColumnaFormulada" class="selectorFormulada">
															<option value="1" selected="selected" >Asc</option>
															<option value="2">Desc</option>																
													</select>
												</td>
											</tr>
										</tbody>
									</cfif>
								</table>
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-2 col-sm-2"> 
					<div class="row"></div>
					<div class="row text-center">
						<table align="center">
							<tr>
								<td align="center"><input type="button" class="classButton" id="incluirFormulada" value=">"></td>	
							</tr>
							<tr>	
								<td align="center"><input type="button" class="classButton" id="excluirFormulada" value="<"></td>
							</tr>
						</table>
					 </div>
				</div>
				<div class="col-md-5 col-sm-5">
					<div class="panel panel-success">
						<div class="panel-heading">
							<b>Configuraci&oacute;n Agregada</b>
						</div>
						<div class="panel-body">
							<div class="row maxTamDiv">
								<table class="ListFormularincluir" id="ListFormularincluir">
									<cfif rsConfigFormuladaValores.recordcount gt 0>
										<tbody>
											<tr>
												<td><b>Tipo:</b></td>
												<td align="left">
												
													<select id="cmbTipoA" name="cmbTipoA" class="selectorFormulada" disabled="disabled">
														<option value="1" <cfif not usarValorA>selected="selected" </cfif>>Columna</option>
														<option value="2" <cfif usarValorA>selected="selected" </cfif>>Valor</option>
													</select>
												</td>
												<td id="VerColumnasA">
													<select id="cmbColumnaA" class="selectorFormulada" disabled="disabled">
														<cfloop query="rsPopulateColumnas">
															<option value="#Cid#" <cfif ColumnaA eq 1>selected="selected" </cfif> >#Cdescripcion#</option>
														</cfloop>
													</select>
												</td>
												<td id="VerValorA">
													<cfif len(trim(rsConfigFormuladaValores.CFORcteA)) gt 0>
														<cf_inputNumber decimales="2" name="inpValorA" enteros="7" value="#rsConfigFormuladaValores.CFORcteA#">
													<cfelse>	
														<cf_inputNumber decimales="2" name="inpValorA" enteros="7" value="">
													</cfif>	
												</td>
											</tr>

											<!---- operador----->
											<tr>
												<td><b>Operador:</b></td>
												<td colspan="2" align="center">
													<select id="cmbTipoOperador" name="cmbTipoOperador" class="selectorFormulada" disabled="disabled">
														<cfif  len(trim(rsConfigFormuladaValores.CFORtipo)) gt 0 >
															<option value="1" <cfif rsConfigFormuladaValores.CFORtipo eq 1>selected="selected" </cfif> >Multiplicacion</option>
															<option value="2" <cfif rsConfigFormuladaValores.CFORtipo eq 2>selected="selected" </cfif>>Division</option>
															<option value="3" <cfif rsConfigFormuladaValores.CFORtipo eq 3>selected="selected" </cfif>>Suma</option>
															<option value="4" <cfif rsConfigFormuladaValores.CFORtipo eq 4>selected="selected" </cfif>>Resta</option>																
														</cfif>
													</select>
												</td>
											</tr>

											<!---- columna B----->
											<tr>
												<td><b>Tipo:</b></td>
												<td align="left">
													<select id="cmbTipoB" name="cmbTipoB" class="selectorFormulada" disabled="disabled">
														<option value="1" <cfif not usarValorB>selected="selected" </cfif>>Columna</option>
														<option value="2" <cfif usarValorB>selected="selected" </cfif>>Valor</option>
													</select>
												</td>
												<td id="VerColumnasB">
													<select id="cmbColumnaB" class="selectorFormulada" disabled="disabled">
														<cfloop query="rsPopulateColumnas">
															<option value="#Cid#" <cfif ColumnaB eq 1>selected="selected" </cfif> >#Cdescripcion#</option>
														</cfloop>
													</select>
												</td>
												<td id="VerValorB">
													<cfif len(trim(rsConfigFormuladaValores.CFORcteB)) gt 0>
														<cf_inputNumber decimales="2" name="inpValorB" enteros="7" value="#rsConfigFormuladaValores.CFORcteB#">
													<cfelse>
														<cf_inputNumber decimales="2" name="inpValorB" enteros="7" value="">
													</cfif>	
												</td>
											</tr>
											<!---- Ordenamiento de los datos------> 
											<tr>
												<td><b>Orden:</b></td>
												<td colspan="2" align="center">
													<select id="orderColumnaFormulada" name="orderColumnaFormulada" class="selectorFormulada">
															<option value="1" <cfif rsConfigFormuladaValores.CFORorder eq 1>selected="selected"</cfif> >Asc</option>
															<option value="2" <cfif rsConfigFormuladaValores.CFORorder eq 2>selected="selected"</cfif> >Desc</option>																
													</select>
												</td>
											</tr>
										</tbody>
										<script language="javascript">EnableDisableFormulada();EnableDisableFormulada();</script>
									</cfif>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
		<cfelseif rsInfoColumna.Ctipo eq 20><!---- columnas Totalizadas------>		
			<cfquery datasource="#session.dsn#" name="rsPopulateColumnas">
				select rh.Cdescripcion, rh.Cid,
						 (select count(1) 
						 from RHReportesDinamicoCSUM
						 where Cid = #form.Cid#
						 and CSUMreferencia =  rh.Cid
						 and CSUMtipo = 20) as incluido
				from RHReportesDinamicoC rh
				where rh.Ctipo in (1,4,10,20)
				and rh.RHRDEid = (select x.RHRDEid from RHReportesDinamicoC x where Cid =#form.Cid#)
				and rh.Corden < (select Corden 
							  from RHReportesDinamicoC 
							  where Cid = #form.Cid#) <!---- solo se deben mostrar las columnas que tienen un orden previo--->
				order by rh.Cdescripcion
			</cfquery>
			
			<div class="row"> 
				<div class="col-md-5 col-sm-5">
					<div class="panel panel-primary">
						<div class="panel-heading">
							<b>Columnas Totalizar</b>
						</div>
						<div class="panel-body">
							<div class="row">
								<b><cfoutput>#LB_buscar#</cfoutput></b><input type="text"  id="filtroTotalA" value="" size="20">
							</div>
							<div class="row maxTamDiv">
								<div class="col-md-8 col-md-offset-2">
									<table class="ListaTotal" id="ListaTotal">
										<cfloop query="rsPopulateColumnas">
											<cfif rsPopulateColumnas.incluido eq 0>
												 <tr class="fila" id="#rsPopulateColumnas.Cid#">
													<td>#trim(rsPopulateColumnas.Cdescripcion)#</td>
												 </tr>
											 </cfif>
										 </cfloop>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-2 col-sm-2"> 
					<div class="row"></div>
					<div class="row text-center">
						<table align="center">
							<tr><td align="center"><input type="button" class="classButton" id="incluirTotalTodos" value=">>"></td></tr>
							<tr><td align="center"><input type="button" class="classButton" id="incluirTotal" value=">"></td></tr>
							<tr><td align="center"><input type="button" class="classButton" id="excluirTotal" value="<"></td></tr>
							<tr><td align="center"><input type="button" class="classButton" id="excluirTotalTodos" value="<<"></td></tr>
						</table>
					 </div>
				</div>
				<div class="col-md-5 col-sm-5">
					<div class="panel panel-success">
						<div class="panel-heading">
							<b>Columnas Totalizar a Incluir</b>
						</div>
						<div class="panel-body">
							<div class="row">
								<b><cfoutput>#LB_buscar#</cfoutput></b><input type="text"  id="filtroTotalB" value="" size="20">
							</div>
							<div class="row maxTamDiv">
								<div class="col-md-8 col-md-offset-2">
									<table class="ListaTotalIncluir" id="ListaTotalIncluir" >
										<cfloop query="rsPopulateColumnas">
											<cfif rsPopulateColumnas.incluido eq 1>
												 <tr class="fila" id="#rsPopulateColumnas.Cid#">
													<td>#trim(rsPopulateColumnas.Cdescripcion)#</td>
												 </tr>
											 </cfif>
										 </cfloop>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</cfif>
		</cfoutput>	
		<table width="100%"><tr><td align="center"><input type="button" class="btnAnterior" value="<cfoutput>#LB_atras#</cfoutput>" onclick="regresar()" /></td></tr></table>
	<cf_web_portlet_end>
<cf_templatefooter>

<script type="text/javascript">
	function regresar () {
	<cfif isDefined("form.RHRDEid") AND LEN(form.RHRDEid) >
		location.href = <cfoutput>"RepDinamicosColumna.cfm?RHRDEid=#form.RHRDEid#";</cfoutput>	
	<cfelse>
		history.back();
	</cfif>
	}
</script>