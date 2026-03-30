<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ConsultaCarreraProfesionalMasivo" Default="Consulta de Carrera Profesional Masivo" returnvariable="LB_Titulo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Consultar" Default="Consultar" XmlFile="/rh/generales.xml" returnvariable="LB_Consultar"/>
<cfinvoke key="LB_ListaDeConceptosDeCarreraProfesional" default="Lista de Conceptos de Carrera Profesional"  returnvariable="LB_ListaDeConceptosDeCarreraProfesional" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke key="MSG_NoSeEncontraronRegistros" default="No se encontraron Registros"	 returnvariable="MSG_NoSeEncontraronRegistros" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Codigo" default="C&oacute;digo"  returnvariable="LB_Codigo" component="sif.Componentes.Translate"  method="Translate" />	
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n"  returnvariable="LB_Descripcion" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke key="LB_Valor" default="Valor"  returnvariable="LB_Valor" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke key="LB_Unidad" default="Unidad"  returnvariable="LB_Unidad" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke key="LB_ListaDeConceptosDeCarreraProfesional" default="Lista de Puestos"  returnvariable="LB_ListaDePuestos" component="sif.Componentes.Translate"  method="Translate" />
<cfoutput>
<cfquery name="rsTipoConcepto" datasource="#session.DSN#">
	select TCCPid, TCCPdesc
	from TipoConceptoCP 
</cfquery>
<cfquery name="rsUnidadEq" datasource="#session.DSN#">
	select UECPid,UECPdescripcion
	from UnidadEquivalenciaCP 
</cfquery>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<table width="100%" cellpadding="1" cellspacing="0">
		<tr>
			<td valign="top">	
				<cf_web_portlet_start border="true" titulo="#LB_Titulo#" skin="#Session.Preferences.Skin#"> 
					<form name="form1" method="get" action="CarreraProfesionalMasivo-form.cfm" style="margin:0;" onSubmit="return funcValidar();">
						<table width="75%" align="center" cellpadding="2" border="0">														
							<tr>
								<td align="right" width="30%"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_FechaDesde">Fecha desde</cf_translate>:</strong></td>
								<td width="12%"><cf_sifcalendario name="desde"></td>
								<td>&nbsp;</td>
								<td width="11%" align="right" nowrap><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_FechaHasta">Fecha hasta</cf_translate>:</strong></td>
								<td width="33%"><cf_sifcalendario name="hasta"></td>
							</tr>
							<tr>
								<td align="right" width="30%" nowrap><strong><cf_translate key="LB_TipoConcepto">Tipo Concepto</cf_translate>:</strong></td>
								<td>
									<select name="TCCPid" tabindex="3">
										<option value=""><cf_translate key="LB_Todos">--- Todos ---</cf_translate></option>										
										<cfloop query="rsTipoConcepto">											
											<option value="#TCCPid#">#TCCPdesc#</option>
										</cfloop>
									</select>
								</td>
								<td>&nbsp;</td>
								<td align="right" width="30%" nowrap><strong><cf_translate key="LB_ConceptoCarreraProfesional">Concepto Carrera Profesional</cf_translate>:</strong></td>
								<td nowrap>
									<cf_conlis
										campos="CCPid,CIid,CCPcodigo,CCPdescripcion,CCPvalor,UECPdescripcion,TCCPdesc"
										desplegables="N,N,S,S,N,N,N"
										modificables="N,N,S,N,N,N,N"
										size="0,0,10,25,0,0,0"
										title="#LB_ListaDeConceptosDeCarreraProfesional#"
										tabla="ConceptosCarreraP a
												inner join UnidadEquivalenciaCP b
													on b.UECPid = a.UECPid
												inner join TipoConceptoCP d
													on d.TCCPid = a.TCCPid"
										columnas="CCPid,CIid,CCPcodigo,CCPdescripcion,CCPvalor,UECPdescripcion,TCCPdesc"
										filtro="Ecodigo = #SESSION.ECODIGO# 												
												order by TCCPdesc,CCPcodigo"
										desplegar="CCPcodigo,CCPdescripcion,CCPvalor,UECPdescripcion"
										filtrar_por="CCPcodigo, CCPdescripcion,CCPvalor,UECPdescripcion"
										Cortes = "TCCPdesc"
										etiquetas="#LB_Codigo#, #LB_Descripcion#, #LB_Valor#, #LB_Unidad#"
										formatos="S,S,M,S"								
										align="left,left,right"
										asignar="CCPid,CIid, CCPcodigo, CCPdescripcion,CCPvalor,UECPdescripcion"
										asignarformatos="S, S, S,S,M,S"
										showEmptyListMsg="true"
										EmptyListMsg="-- #MSG_NoSeEncontraronRegistros# --"
										tabindex="1"
										rsUECPdescripcion="#rsUnidadEq#"
										scrollbar="yes">
								</td>
							</tr>
							<tr>
								<td align="right" width="30%" nowrap><strong><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:</strong></td>
								<td colspan="4">
									<cf_rhcfuncional form="form1" codigosize='30' size='60' >
								</td>
								<td>&nbsp;</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td colspan="5" align="center"><input type="submit" class="btnFiltrar" name="Consultar" value="#LB_Consultar#"></td>
							</tr>
						</table>
					</form>
				<cf_web_portlet_end> 
			</td>	
		</tr>
	</table>	
<cf_templatefooter>
<script type="text/javascript" language="javascript1.2">
	function funcValidar(){
	}
</script>
</cfoutput>