<!--- Valida que los parametros vengan por URL --->
<cfif isdefined("url.chkvercategoria")>
	<cfset form.chkvercategoria = url.chkvercategoria >
</cfif>
<cfif isdefined("url.chkvercf")>
	<cfset form.chkvercf = url.chkvercf >
</cfif>
<cfif isdefined("url.chkverclase")>
	<cfset form.chkverclase = url.chkverclase >
</cfif>
<cfif isdefined("url.chkverserie")>
	<cfset form.chkverserie = url.chkverserie >
</cfif>
<cfif isdefined("url.chkverestado")>
	<cfset form.chkverestado = url.chkverestado >
</cfif>
<cfif isdefined("url.chkverddet")>
	<cfset form.chkverddet = url.chkverddet >
</cfif>
<cfif isdefined("url.chkverdres")>
	<cfset form.chkverdres = url.chkverdres >
</cfif>
<cfif isdefined("url.chkverusuario")>
	<cfset form.chkverusuario = url.chkverusuario >
</cfif>
<cfif isdefined("url.chkveringreso")>
	<cfset form.chkveringreso = url.chkveringreso >
</cfif>
<cfif isdefined("url.chkverfultran")>
	<cfset form.chkverfultran = url.chkverfultran >
</cfif>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>

<!--- Consulta --->
<cfquery name="rsTipoDocumento" datasource="#session.DSN#">
	select CRTDid, CRTDdescripcion, CRTDdefault 
	from CRTipoDocumento
 	where Ecodigo = #Session.Ecodigo#
</cfquery>

<cf_templateheader title="#nav__SPdescripcion#">
	<cf_templatecss>
			<cfoutput>#pNavegacion#</cfoutput>	
			
	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Documentos por Empleado">
    
		<cfoutput>
		<script language="javascript" type="text/javascript">
			function verifica()
			{
				var codEmpleado=document.getElementById('DEidentificacion').value;
				var empleado=document.getElementById('DEnombrecompleto').value;
				
				if((codEmpleado!=null && codEmpleado!="") && (empleado!=null && empleado!=""))
				{
					return true;
				}else{
					alert('Debe de seleccionar un empleado para opder generar el reporte.');
					return false;
				}
				return false;
			}
			
		</script>
			<form method="post" name="form1" action="ValesPorEmpleado-sql.cfm" onsubmit="javascript:return verifica();">
				<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td valign="top" width="30%">
							<table width="100%">
								<tr>
								<td valign="top">	
								<cf_web_portlet_start border="true" titulo="Documentos por Empleado" skin="info1">
									<div align="justify">
										&Eacute;ste reporte muestra <br>
										la lista de todos los documentos  <br>
										que se encuentran asociados a un empleado. 
									</div>
								<cf_web_portlet_end>
								</td>
								</tr>
							</table>  
						</td>
						<td width="50%" valign="top">
							<table width="100%"  border="0" cellspacing="2" cellpadding="2">
								<tr>
									<td width="42%" align="right">Empleado:</td>
									<td>
										<cf_dbfunction name="concat" args="DEapellido1 ,' ',DEapellido2 ,' ',DEnombre" returnvariable="DEnombrecompleto">
										<cfset ValuesArray=ArrayNew(1)>
										<cf_conlis
											Campos="DEid,DEidentificacion,DEnombrecompleto"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,10,40"
											Tabindex="1"
											ValuesArray="#ValuesArray#"
											Title="Lista de Empleados"
											Tabla="DatosEmpleado"
											Columnas="DEid,DEidentificacion,#DEnombrecompleto# as DEnombrecompleto"
											Filtro="Ecodigo = #Session.Ecodigo# order by DEidentificacion,DEnombrecompleto"
											Desplegar="DEidentificacion,DEnombrecompleto"
											Etiquetas="Identificaci&oacute;n,Nombre"
											filtrar_por="DEidentificacion,#DEnombrecompleto#"
											Formatos="S,S"
											Align="left,left"
											Asignar="DEid,DEidentificacion,DEnombrecompleto"
											Asignarformatos="I,S,S"
											MaxRowsQuery="200"/>
									</td>
								</tr>
								<tr>
									<td align="right">Tipo de Documento:</td>
									<td>
										<select name="TipoVale" tabindex="6">
											<option value="-1" label="Todos" <cfif isdefined("CRTDdefault") and trim(CRTDdefault) NEQ 1 > selected </cfif> >Todos</option>
											<cfloop query="rsTipoDocumento">
												<option value="#CRTDid#" label="#CRTDdescripcion#" <cfif isdefined("CRTDdefault") and trim(CRTDdefault) EQ 1> selected </cfif> >#CRTDdescripcion#</option>
											</cfloop>
										</select> 
									</td>
								</tr>
								<tr>
									<td align="right">Estado:</td>
									<td>
										<select name="VER" tabindex="2">
											<option value="A,T" selected>Activos y En Tr&aacute;nsito</option>																										
											<option value="A">Activos</option>
											<option value="I">Inactivos</option>
											<option value="T">En Tr&aacute;nsito</option>
											<option value="">Todos</option>
										</select>
									</td>
								</tr>	
								<tr><td colspan="2">&nbsp;</td></tr>
								<tr>
									<td colspan="2" align="right">
									
										<fieldset style="width:80%;">
										<legend style="font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:normal; font-weight:bolder;">Información Opcional</legend>
										<table cellpadding="0" cellspacing="0" align="right" style="width:80%">
											<tr><td colspan="4">&nbsp;</td></tr>
											<tr>
												<td align="right" nowrap="nowrap"><strong>Mostrar Fecha de Ingreso:</strong></td>
												<td>
													<input type="checkbox" name="chkveringreso" 
														<cfif not isdefined("url.reporte")>checked="checked"</cfif> 
														<cfif isdefined("form.chkveringreso")>checked</cfif> />														</td>
												<td align="right" nowrap="nowrap"><strong>Mostrar Fecha &Uacute;ltima Transacción:</strong></td>
												<td>
													<input type="checkbox" name="chkverfultran" 
														<cfif not isdefined("url.reporte")>checked="checked"</cfif> 
														<cfif isdefined("form.chkverfultran")>checked</cfif> />														</td>
											</tr>													
											
											<tr>
												<td align="right"><strong>Mostrar Desc. Resumida:</strong></td>
												<td>
													<input type="checkbox" name="chkverdres" 
														<cfif isdefined("form.chkverdres")>checked</cfif> />														</td>
												<td align="right"><strong>Mostrar Desc. Detallada:</strong></td>
												<td>
													<input type="checkbox" name="chkverddet" 
														<cfif not isdefined("url.reporte")>checked="checked"</cfif> 
														<cfif isdefined("form.chkverddet")>checked</cfif> />														</td>
											</tr>

											<tr>
												<td align="right"><strong>Mostrar Serie:</strong></td>
												<td>
													<input type="checkbox" name="chkverserie" 
														<cfif not isdefined("url.reporte")>checked="checked"</cfif> 
														<cfif isdefined("form.chkverserie")>checked</cfif> />														</td>
												<td align="right"><strong>Mostrar Estado:</strong></td>
												<td>
													<input type="checkbox" name="chkverestado" 
														<cfif isdefined("form.chkverestado")>checked</cfif> />														</td>
											</tr>

											<tr>
												<td align="right"><strong>Mostrar Categor&iacute;a:</strong></td>
												<td>
													<input type="checkbox" name="chkvercategoria"  
														<cfif isdefined("form.chkvercategoria")>checked</cfif> />														</td>
												<td align="right"><strong>Mostrar Clase:</strong></td>
												<td>
													<input type="checkbox" name="chkverclase" 
														<cfif isdefined("form.chkverclase")>checked</cfif> />														</td>
											</tr>

											<tr>
												<td align="right"><strong>Mostrar Centro Funcional:</strong></td>
												<td>
													<input type="checkbox" name="chkvercf"
														<cfif not isdefined("url.reporte")>checked="checked"</cfif> 
														<cfif isdefined("form.chkvercf")>checked</cfif> />														</td>
												<td align="right"><strong>Mostrar Usuario:</strong></td>
												<td>
													<input type="checkbox" name="chkverusuario" 
														<cfif isdefined("form.chkverusuario")>checked</cfif> />														</td>													
											</tr>
											
										</table>											
										</fieldset>
									</td>
								</tr>																					
								<tr>
									<td colspan="2" align="center">&nbsp;</td>
								</tr>
								<tr>
									<td colspan="2" align="center"><input type="submit" value="Consultar" name="Reporte" tabindex="3"></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</form>
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>