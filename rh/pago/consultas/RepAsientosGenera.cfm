<cfoutput>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Generar_Asientos_de_Diario"
	Default="Generar Asientos de Diario"	
	returnvariable="LB_Generar_Asientos_de_Diario"/>	

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/sif/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RelacionCalculo"
		Default="Relación de Cálculo"
		XmlFile="/sif/rh/generales.xml"
		returnvariable="LB_RelacionCalculo"/>
		
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_web_portlet_start titulo="<cfoutput>#LB_Generar_Asientos_de_Diario#</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>
			
			<!---=================== TRADUCCION ======================---->
			
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Lista_de_Relaciones_de_Calculo"
				Default="Lista de Relaciones de C&aacute;lculo"	
				returnvariable="LB_Lista_de_Relaciones_de_Calculo"/>

				
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Relacion_de_Calculo"
				Default="Relaci&oacute;n de C&aacute;lculo"	
				returnvariable="LB_Relacion_de_Calculo"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Tipo_de_Nomina"
				Default="Tipo de N&oacute;mina"	
				returnvariable="LB_Tipo_de_Nomina"/>
			
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_FechaDesde"
				Default="Fecha Desde"	
				returnvariable="LB_FechaDesde"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_FechaHasta"
				Default="Fecha Hasta"	
				returnvariable="LB_FechaHasta"/>
			
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_No_se_encotraron_relaciones_de_calculo"
				Default="No se encotraron relaciones de cálculo"	
				returnvariable="LB_No_se_encotraron_relaciones_de_calculo"/>			
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Generar_Asiento"
				Default="Generar Asiento a Exactus"
				returnvariable="BTN_Generar_Asiento"/>	
			
			<form name="form1" action="RepAsientosGenera-rpt.cfm" method="get">
				<input type="hidden" name="vRCNid" value="url.RCNid">		
				
				<table width="98%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="45%" valign="top">															
							<cf_web_portlet_start border="true" titulo="#LB_Generar_Asientos_de_Diario#" skin="info1">
								<div align="justify">
								  <p><cf_translate key="LB_ConsultaDeAsientosAGenerarApartirDeUnaRelacionDeCalculoPagada">Consulta de asientos a generar a partir de una relaci&oacute;n de c&aacute;lculo pagada.</cf_translate></p>
								</div>
							<cf_web_portlet_end>
						</td>
						<td width="55%" valign="top">
							<table width="98%" cellpadding="2" cellspacing="0" align="center">
								<tr>
								  <td colspan="2" align="center">&nbsp;</td>
							    </tr>
								<tr>
									<td align="right" nowrap><strong>#LB_RelacionCalculo#:&nbsp;</strong></td>
									<td>  
									<cf_conlis 
										campos="RCNid, RCDescripcion, Tdescripcion,a.RCdesde, a.RChasta"
										size="0,40,0,0,0"
										desplegables="N,S,N,N,N"
										modificables="N,N,N,N,N"
										title="#LB_Lista_de_Relaciones_de_Calculo#"
										tabla="HRCalculoNomina a
												inner join TiposNomina T
												  on a.Ecodigo = T.Ecodigo 
												  and a.Tcodigo = T.Tcodigo"
										columnas="a.RCNid, RCDescripcion , T.Tdescripcion,a.RCdesde, a.RChasta"
										filtro="a.Ecodigo = #Session.Ecodigo#
													and exists (
														select 1
														from RCuentasTipo x
														where x.Ecodigo = a.Ecodigo
														and x.RCNid = a.RCNid
													)
													order by a.RChasta desc, T.Tdescripcion, a.RCDescripcion"
										filtrar_por="RCDescripcion, T.Tdescripcion,a.RCdesde,a.RChasta"
										desplegar="RCDescripcion, Tdescripcion,RCdesde,RChasta"
										etiquetas="#LB_Relacion_de_Calculo#,#LB_Tipo_de_Nomina#,#LB_FechaDesde#,#LB_FechaHasta#"
										formatos="S,S,D,D"
										align="left,left"
										asignar="RCNid, RCDescripcion "
										asignarFormatos="S,S,S,S"
										width="800"
										form="form1"
										showEmptyListMsg="true"
										EmptyListMsg=" --- #LB_No_se_encotraron_relaciones_de_calculo# --- "/>
								   </td>
								</tr>
								<tr>
								  <td colspan="2" align="center">&nbsp;</td>
							    </tr>
								<tr>
									<td colspan="2" align="center">
										<cfoutput><input type="submit" name="btn_consultar" value="#BTN_Generar_Asiento#"/></cfoutput>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</form>
		<cf_web_portlet_end>
	<cf_templatefooter>	

<cf_qforms form="form1">
<script type="text/javascript" language="javascript1.2">
	objForm.RCNid.required = true;
	objForm.RCNid.description = '#LB_RelacionCalculo#';
</script>

</cfoutput>