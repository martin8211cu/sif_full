<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
<cf_templatecss>
<!--- <cfset vd_fechaFinal = DateAdd("d", 6, "#LSParseDateTime(form.fdesde)#")>	 --->
  <cfinclude template="/rh/Utiles/params.cfm">
  <cfset Session.Params.ModoDespliegue = 1>
  <cfset Session.cache_empresarial = 0>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">      			    
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_DiasNoAgrupados"
				Default="Reporte Días no agrupados"
				returnvariable="titulo"/>
			
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Grupo"
				Default="Grupo"
				returnvariable="LB_Grupo"/>	

			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_ListaDeEmpleados"
				Default="Lista de empleados"	
				returnvariable="LB_ListaDeEmpleados"/>	
			
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
				Key="LB_Empleado"
				Default="Empleado"	
				returnvariable="LB_Empleado"/>							
				
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

			<cfquery name="rsGrupos" datasource="#session.DSN#">
				select  b.Gid, b.Gdescripcion
				from RHCMGrupos b					
				where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
												  
			<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">				  
			<cfinclude template="/rh/portlets/pNavegacion.cfm">			
			<cfoutput>
				<form method="post" name="form1" action="DiasNoAgrupados-vista.cfm">
					<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td width="42%">
								<table width="100%">
									<tr>
										<td height="173" valign="top">																											
											<cf_web_portlet_start border="true" titulo="#titulo#" skin="info1">
												<div align="justify">
												  <p>
												  	<cf_translate  key="AYUDA_EsteReporteseMuestranLosDiasNoAgrupados">														  
													  En &eacute;ste reporte 
													  se muestran los d&iacute;as no agrupados por empleado en un 
													  rango de fechas.
													  </cf_translate>
												  </p>
											</div>
										  <cf_web_portlet_end>							  
										</td>
									</tr>
							  </table>  
							</td>
							<td width="58%" valign="top">
								<table width="100%" cellpadding="0" cellspacing="0" align="center">	
								 <tr>		
								    <td align="right"><strong>#LB_Grupo#:&nbsp;</strong></td>
									<td nowrap="nowrap">
										<select name="Gid" tabindex="5">
											<cfloop query="rsGrupos">
												<option value="#rsGrupos.Gid#" <cfif isdefined("form.Grupo") and len(trim(form.Grupo)) and form.Grupo EQ rsGrupos.Gid>selected</cfif>>#rsGrupos.Gdescripcion#</option>
											</cfloop>
										</select>									
									 </td>								  
								  </tr>
								  <tr>		
								    <td align="right"><strong>#LB_Empleado#:&nbsp;</strong></td>
									<td nowrap="nowrap">
											<cf_conlis
											   campos="DEid,DEidentificacion,Nombre"
											   desplegables="N,S,S"
											   modificables="N,S,N"
											   size="0,20,40"
											   title="#LB_ListaDeEmpleados#"
											   tabla=" RHCMEmpleadosGrupo gr
														inner join DatosEmpleado de
															on de.Ecodigo = gr.Ecodigo
																and de.DEid = gr.DEid"
											   columnas="de.DEid,de.DEidentificacion,{fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )},  ' ' )}, de.DEnombre)} as Nombre"
											   filtro="gr.Gid = $Gid,numeric$ and gr.Ecodigo = #Session.Ecodigo#  order by DEidentificacion"
											   desplegar="DEidentificacion,Nombre"
											   filtrar_por="de.DEidentificacion|{fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )},  ' ' )}, de.DEnombre)}"
											   filtrar_por_delimiters="|"
											   etiquetas="#LB_Identificacion#,#LB_Nombre#"
											   formatos="S,S"
											   align="left,left"
											   asignar="DEid,DEidentificacion,Nombre"
											   asignarformatos="S,S,S"
											   showemptylistmsg="true"
											   tabindex="1">
									   </td>								  
								  </tr>
								  <tr> 
										<td align="right"><strong>#LB_Desde#:&nbsp;</strong></td>
										<td nowrap>
											<cfif isdefined("Form.fdesde")>
												<cfset fecha = Form.fdesde>
											<cfelse>
												<cfset fecha = "">
											</cfif>
											<cf_sifcalendario form="form1" value="#fecha#" name="fdesde" tabindex="1">
										</td>											
									</tr>
									 <tr> 
										<td align="right"><strong>#LB_Hasta#:&nbsp;</strong></td>
										<td nowrap>
											<cfif isdefined("Form.fHasta")>
												<cfset fecha = Form.fHasta>
											<cfelse>
												<cfset fecha = "">
											</cfif>
											<cf_sifcalendario form="form1" value="#fecha#" name="fHasta" tabindex="1">
										</td>											
									</tr>
									<tr><td align="center" colspan="3">&nbsp;</td></tr>										
									<tr>
										<td align="center" colspan="3">
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Generar"
										Default="Generar"
										XmlFile="/rh/generales.xml"
										returnvariable="BTN_Generar"/>
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Limpiar"
										Default="Limpiar"
										XmlFile="/rh/generales.xml"
										returnvariable="BTN_Limpiar"/>										
										<input type="submit" value="#BTN_Generar#" name="Reporte" tabindex="1">
										<input type="reset"  name="Limpiar" value="#BTN_Limpiar#" tabindex="1"></td>
										</tr>
								</table>
							</td>
						</tr>
					</table>
				</form>
			</cfoutput>			    
			</td>	
		</tr>
	</table>	
	<cf_qforms form="form1">
	<script type="text/javascript" language="javascript1.2">
		objForm.fdesde.required = true;
		objForm.fHasta.required = true;
		objForm.fdesde.description="<cfoutput>#LB_Desde#</cfoutput>";
		objForm.fHasta.description="<cfoutput>#LB_Hasta#</cfoutput>";
	</script>
	
	<cf_web_portlet_end>
<cf_templatefooter>	