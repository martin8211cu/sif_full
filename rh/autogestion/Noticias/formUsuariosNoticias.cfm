<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" XmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Noticias" Default="Noticias de Autogesti&oacute;n" returnvariable="LB_Noticias" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_DeseaEliminarElRegistro" Default="Desea eliminar el registro?" returnvariable="LB_DeseaEliminarElRegistro" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Regresar" Default="Regresar" returnvariable="LB_Regresar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_ListaPuestos" Default="Lista de Puestos" returnvariable="LB_ListaPuestos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Codigo" Default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_PuedeSeleccionarCentroFuncionalOPuesto" Default="Puede seleccionar centro funcional o puesto" returnvariable="LB_CFPuestoExcluyentes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Agregar" Default="Agregar" returnvariable="LB_Agregar" component="sif.Componentes.Translate" method="Translate"/>

<cfif isdefined("url.IdNoticia") and len(trim(url.IdNoticia))>
	<cfset form.IdNoticia = url.IdNoticia>
</cfif>

<cfif isdefined("form.IdNoticia") and len(trim(form.IdNoticia))>	
	<cfquery name="rsTitulo" datasource="#session.DSN#">
		select Titulo
		from EncabNoticias
		where IdNoticia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdNoticia#"> 
	</cfquery>
	<!---Carga arreglo del conlis de puestos y de centro funcional--->
	<cfquery name="rsDetalleUsuarios" datasource="#session.DSN#">
		select a.IdNoticia, a.CFid, a.RHPcodigo, a.ts_rversion
		from DetUsuariosNoticias a			
		where a.IdNoticia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdNoticia#"> 
	</cfquery>	
</cfif>
	<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr><td>&nbsp;</td></tr>				
		<cfif isdefined("rsTitulo") and rsTitulo.RecordCount NEQ 0>
			<tr>
				<td colspan="4" align="center"><strong><cf_translate key="LB_Noticia">Noticia</cf_translate>:&nbsp;#rsTitulo.Titulo#</strong></td>
			</tr>
		</cfif>
		<tr><td>&nbsp;</td></tr>
		<form action="SQLUsuariosNoticias.cfm"  method="post" name="form1" id="form1">
			<input type="hidden" name="IdNoticia" value="<cfif isdefined("form.IdNoticia") and len(trim(form.IdNoticia))>#form.IdNoticia#</cfif>">
			<!---Detalle de usuarios que pueden visualizar la noticia--->				
			<tr>
				<td colspan="4" align="center"><cf_translate key="LB_SeleccioneElPuestoOCentroFuncional">Seleccione el puesto o centro funcional de los empleados que podr&aacute;n visualizar la noticia</cf_translate></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="right"><strong><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:&nbsp;</strong></td>
				<td>
					<cf_rhcfuncional form="form1" name="CFcodigo" desc="CFdescripcion" id="CFid" codigosize='10' size='30' >
				</td>
				<td align="right"><strong><cf_translate key="LB_Puesto">Puesto</cf_translate>:&nbsp;</strong></td>
				<td>
					<cf_conlis title="#LB_ListaPuestos#"
					campos = "RHPcodigo,RHPdescpuesto" 
					desplegables = "S,S" 
					modificables = "S,N" 
					size = "10,25"
					asignar="RHPcodigo,RHPdescpuesto"
					asignarformatos="S,S"
					tabla="	RHPuestos a"																	
					columnas="a.RHPcodigo,a.RHPdescpuesto"
					filtro="a.Ecodigo =#session.Ecodigo#"
					desplegar="RHPcodigo,RHPdescpuesto"
					etiquetas="	#LB_Codigo#, 
								#LB_Descripcion#"
					formatos="S,S"
					align="left,left"
					showEmptyListMsg="true"
					debug="false"
					form="form1"
					width="800"
					height="500"
					left="70"
					top="20"
					filtrar_por="RHPcodigo,RHPdescpuesto"
					index="3"> 
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="4" align="center">
					<input type="submit" name="btnAgregar" value="#LB_Agregar#">&nbsp;
					<input type="button" name="btnRegresar" value="#LB_Regresar#" onClick="javascript: funcRegresarLista();">
				</td>
			</tr>
		</form>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>					
		<tr>
			<td colspan="2" align="center"><strong><cf_translate key="LB_CentrosFuncionalesAsignados">Centros Funcionales Asignados</cf_translate></strong></td>
			<td colspan="2" align="center"><strong><cf_translate key="LB_PuestosAsignados">Puestos Asignados</cf_translate></strong></td>
		</tr>
		<tr><td>&nbsp;</td></tr>				
		<tr>
			<td colspan="4">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td width="49%" valign="top">
							<table width="100%" cellpadding="0" cellspacing="0" border="0">
								<tr>
									<td>
										<cfquery name="rsLista" datasource="#session.DSN#">
											select 	a.Id, a.IdNoticia, b.CFcodigo, b.CFdescripcion,
													'<img src="/cfmx/rh/imagenes/Borrar01_S.gif" border="0">' as Borrar
											from DetUsuariosNoticias a
												inner join CFuncional b
													on a.CFid = b.CFid
													and a.Ecodigo = b.Ecodigo
											where a.IdNoticia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdNoticia#">
												and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
										</cfquery>
										<cfinvoke 
											component="rh.Componentes.pListas"
											method="pListaQuery"
											returnvariable="pListaRet">
											<cfinvokeargument name="query" value="#rsLista#"/>
											<cfinvokeargument name="desplegar" value="CFcodigo,CFdescripcion,Borrar"/>
											<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#,&nbsp;"/>
											<cfinvokeargument name="formatos" value="V,V,V"/>
											<cfinvokeargument name="align" value="left,left,right"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="checkboxes" value="N"/>
											<cfinvokeargument name="irA" value="SQLUsuariosNoticias.cfm"/>
											<cfinvokeargument name="keys" value="Id"/>
											<cfinvokeargument name="showEmptyListMsg" value="true"/>
											<cfinvokeargument name="maxrows" value="20"/>
											<cfinvokeargument name="ira" value="SQLUsuariosNoticias.cfm"/>
										</cfinvoke>
									</td>
								</tr>
							</table>
						</td>
						<td width="1%">&nbsp;</td>
						<td width="50%" valign="top">
							<table width="100%" cellpadding="0" cellspacing="0" border="0">
								<tr>
									<td>
										<cfquery name="rsLista" datasource="#session.DSN#">
											select 	a.Id, a.IdNoticia, b.RHPdescpuesto, b.RHPcodigo
													,'<img src="/cfmx/rh/imagenes/Borrar01_S.gif" border="0">' as Borrar
											from DetUsuariosNoticias a
												inner join RHPuestos b
													on a.RHPcodigo = b.RHPcodigo
													and a.Ecodigo = b.Ecodigo
											where a.IdNoticia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdNoticia#">
												and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
										</cfquery>
										<cfinvoke 
											component="rh.Componentes.pListas"
											method="pListaQuery"
											returnvariable="pListaRet">
											<cfinvokeargument name="query" value="#rsLista#"/>
											<cfinvokeargument name="desplegar" value="RHPcodigo,RHPdescpuesto,Borrar"/>
											<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#,&nbsp;"/>
											<cfinvokeargument name="formatos" value="V,V,V"/>
											<cfinvokeargument name="align" value="left,left,right"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="checkboxes" value="N"/>
											<cfinvokeargument name="keys" value="Id"/>
											<cfinvokeargument name="showEmptyListMsg" value="true"/>
											<cfinvokeargument name="maxrows" value="20"/>
											<cfinvokeargument name="ira" value="SQLUsuariosNoticias.cfm"/>
											<cfinvokeargument name="formName" value="form2"/>
										</cfinvoke>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>				
	</table>					
	</cfoutput>	
	<script language="JavaScript" type="text/javascript">	
		function funcRegresarLista(){
			location.href = 'NoticiasAutogestion.cfm';
		}
	</script>