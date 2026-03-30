<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TiposDeDeduccion" 		default="Tipos de Deducci&oacute;n" returnvariable="LB_TiposDeDeduccion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_AdministracionDeNomina" 	default="Administración de Nómina" returnvariable="LB_AdministracionDeNomina"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CODIGO" 					default="C&oacute;digo" xmlfile="/rh/generales.xml" returnvariable="LB_CODIGO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_DESCRIPCION"				default="Descripci&oacute;n" xmlfile="/rh/generales.xml" returnvariable="LB_DESCRIPCION"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Renta" 					default="Renta" returnvariable="LB_Renta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Obligatoria" 			default="Obligatoria" returnvariable="LB_Obligatoria"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PrestFOA" 				default="Pr&eacute;stamos de FOA" returnvariable="LB_PrestFOA"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Ley" 					default="Ley" returnvariable="LB_Ley"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_DespuesRenta" 			default="Calcular Despues de Renta" returnvariable="LB_DespuesRenta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Prioridad" 				default="Prioridad" returnvariable="LB_Prioridad"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_RecursosHumanos" 		default="Recursos Humanos" returnvariable="LB_RecursosHumanos" xmlfile="/rh/generales.xml"/>
<cfinvoke key="MSG_ConceptoSAT" default="Concepto SAT" returnvariable="MSG_ConceptoSAT" component="sif.Componentes.Translate" method="Translate"/>

<cfset Session.Params.ModoDespliegue = 1>
<cfset Session.cache_empresarial     = 0>
<cfset regresar            = "/cfmx/rh/indexAdm.cfm">
<cfset navBarItems         = ArrayNew(1)>
<cfset navBarLinks         = ArrayNew(1)>
<cfset navBarStatusText    = ArrayNew(1)>
<cfset navBarItems[1] 	   = "<cfoutput>#LB_AdministracionDeNomina#</cfoutput>">
<cfset navBarLinks[1] 	   = "/cfmx/rh/indexAdm.cfm">
<cfset navBarStatusText[1] = "/cfmx/rh/indexAdm.cfm">

<cf_templateheader title="#LB_RecursosHumanos#">
<cfinclude template="/rh/portlets/pNavegacion.cfm">
	<cfinclude template="/rh/Utiles/params.cfm">
	<cf_web_portlet_start border="true" titulo="#LB_TiposDeDeduccion#" skin="#Session.Preferences.Skin#">
		<table width="100%" border="0" cellspacing="1" cellpadding="1">
			<tr>
				<td valign="top" width="45%">
					<cfinvoke component="rh.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
							<cfinvokeargument name="conexion" value="#Session.DSN#"/>
							<cfinvokeargument name="columnas" value="TDid, TDcodigo, TDdescripcion, TDfecha, TDprioridad,
																	case TDobligatoria  when 0 then 
																		'<img border=''0'' src=''/cfmx/rh/imagenes/unchecked.gif''>'
																	else 
																		'<img border=''0'' src=''/cfmx/rh/imagenes/checked.gif''>'
																	end as Obligatorio,
																	case coalesce(TDley,0)  when 0 then 
																		'<img border=''0'' src=''/cfmx/rh/imagenes/unchecked.gif''>'
																	else 
																		'<img border=''0'' src=''/cfmx/rh/imagenes/checked.gif''>'
																	end as Ley,
																	case TDrenta when 0 then 
																		'<img border=''0'' src=''/cfmx/rh/imagenes/unchecked.gif''>'
																	else 
																		'<img border=''0'' src=''/cfmx/rh/imagenes/checked.gif''>'
																	end as Renta
																	"/>
							<cfinvokeargument name="tabla" 				value="TDeduccion"/>
							<cfinvokeargument name="desplegar" 			value="TDcodigo, TDdescripcion, Obligatorio,Ley, Renta, TDprioridad"/>
							<cfinvokeargument name="etiquetas" 			value="#LB_CODIGO#, #LB_DESCRIPCION#, #LB_Obligatoria#,#LB_Ley# ,#LB_Renta#, #LB_Prioridad#"/>
							<cfinvokeargument name="formatos" 			value="S,S,U,U,U,U"/>
							<cfinvokeargument name="align" 				value="left, left, center, center,center, center"/>
							<cfinvokeargument name="irA" 				value="TipoDeduccion.cfm"/>
							<cfinvokeargument name="filtro" 			value="Ecodigo = #Session.Ecodigo# order by TDcodigo"/>
							<cfinvokeargument name="ajustar" 			value="N"/>
							<cfinvokeargument name="keys" 				value="TDid"/>
							<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
							<cfinvokeargument name="mostrar_filtro" 	value="true"/>
							<cfinvokeargument name="filtrar_automatico" value="true"/>
					</cfinvoke>
				</td>
				<td valign="top" width="55%" align="center">
					<cfinclude template="formTipoDeduccion.cfm">
				</td>
			</tr>
			<tr>
				<td colspan="2" nowrap>
					<cf_web_portlet_start titulo="" border="true"  skin="info1">
						<strong><cf_translate  key="AYUDA_General_General">General</cf_translate></strong><br>
						<cf_translate  key="AYUDA_General_TextoProsa">Cuando no se puedan aplicar todas las deducciones asociadas a un empleado, pues no le alcanza el salario, se aplicarán el siguiente criterio para la eliminación</cf_translate>:
						<ul>
							<li class="style1"><cf_translate  key="AYUDA_General_ElemListaA">Sólamente se eliminarán las deducciones que no se encuentren marcadas como obligatorias</cf_translate>.</li>
							<li class="style1"><cf_translate  key="AYUDA_General_ElemListaB">Para aquellas que no sean obligatorias, se define el siguiente ordenamiento de exclusión</cf_translate>:
								<br>
								<ol>
									<li class="style1"><cf_translate  key="AYUDA_General_ElemListaB1">Serán consideradas los tipos de deducción de acuerdo con la prioridad definida, de mayor a menor</cf_translate>. </li>
									<li class="style1"><cf_translate  key="AYUDA_General_ElemListaB2">Dentro de la misma prioridad, serán consideradas las deducciones por el código de tipo de deducción, de menor a mayor</cf_translate>. </li>
									<li class="style1"><cf_translate  key="AYUDA_General_ElemListaB3">Para cada uno de los tipos de deducción, se consideran las deducciones del empleado de acuerdo con los criterios de ordenamiento definidos para dicho Tipo de Deducción, a saber, alguno de los siguientes (solamente aplica uno dentro de cada tipo de deducción)</cf_translate>:
										<ul>
											<li class="style1"><cf_translate  key="AYUDA_General_ElemListaB1A">Monto de la Deducción en orden ascendente</cf_translate>. </li>
											<li class="style1"><cf_translate  key="AYUDA_General_ElemListaB1B">Monto de la Deducción en orden descendente</cf_translate>. </li>
											<li class="style1"><cf_translate  key="AYUDA_General_ElemListaB1C">Fecha de inicio de la deducción en orden ascendente (primero se eliminan las deducciones más antiguas)</cf_translate> </li>
											<li class="style1"><cf_translate  key="AYUDA_General_ElemListaB1D">Fecha de inicio de la deducción en orden descendente (primero se eliminan las deducciones más recientes)</cf_translate></li>
										</ul>
									</li>
								</ol>
							</li>
							<li class="style1"><cf_translate  key="AYUDA_General_ElemListaC">Se puede identificar si una deducción puede aplicar parcial o si únicamente puede aplicarse en forma total</cf_translate>.</li>
						</ul>
						<cf_translate  key="AYUDA_Prioridad">
							<strong>Prioridad</strong>
							<br>
							Indica la prioridad en que serán procesadas los tipos de deducción.
							<br>
						</cf_translate>
						<cf_translate  key="AYUDA_PagoParcial">
						  <strong>Pago Parcial</strong>
						  <br>
						  Define si podrá pagarse la deducción en forma parcial o Total.
						  <br>
						</cf_translate>
						<cf_translate  key="AYUDA_Criterio">
						  <strong>Criterio</strong>
						  <br>
						  El criterio define el criterio por el cual será procesado el Tipo de Deducción.
						  <br>
						</cf_translate>
						<ul>
							<li class="style1"><cf_translate  key="AYUDA_MontoAscendente"> <u>Monto Ascendente:</u> Los montos menores serán procesados primero</cf_translate>.</li>
							  <br>
							<li class="style1"><cf_translate  key="AYUDA_MontoDescendente"><u>Monto Descendente:</u> Los montos mayores serán procesados primero.</cf_translate></li>
							  <br>
							<li class="style1"><cf_translate  key="AYUDA_FechaAscendente"><u>Fecha Ascendente:</u> Se procesan primero las deducciones con menor fecha de inicio.</cf_translate></li>
							  <br>
							<li class="style1"><cf_translate  key="AYUDA_FechaDescendente"><u>Fecha Descendente:</u> Se procesan primero las deducciones con mayor fecha de inicio</cf_translate><a href="DTipoDeduccion.cfm">.&nbsp;</a></li>
							  <br>
						</ul>
						<br>
						<cf_translate  key="AYUDA_Renta">
						<strong>Renta</strong><br>Indica que el tipo de deducci&oacute;n se
						comporta como una retenci&oacute;n del impuesto de la renta, solo
						debe haber un tipo de deducci&oacute;n con este comportamiento.
						</cf_translate>
						<br>
					<cf_web_portlet_end>
				</td>
			</tr>	
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>