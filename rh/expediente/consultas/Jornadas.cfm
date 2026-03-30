
<!--- Toma las Jornadas para mostrarlas en el comboBox --->
<cfquery name="rsJornadas" datasource="#Session.DSN#">
	select RHJid, {fn concat({fn concat(rtrim(RHJcodigo) , ' - ' )},  RHJdescripcion )} as Descripcion
	from RHJornadas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_RecursosHumanos"
Default="Recursos Humanos"
XmlFile="/rh/generales.xml"
returnvariable="LB_RecursosHumanos"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_ReporteDeJornada"
Default="Reporte de Jornada"
returnvariable="LB_ReporteDeJornada"/>

<cf_templateheader title="#LB_RecursosHumanos#">

	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_ReporteDeJornada#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<cfoutput>
			<form method="get" name="form1" action="Jornadas-report.cfm" style="margin:0;" >
				<table width="98%" border="0" cellspacing="0" cellpadding="2" align="center">
					<tr>
						<td width="40%" valign="top">
							<table width="100%">
								<tr>
									<td valign="top">
										<cf_web_portlet_start border="true" titulo="#LB_ReporteDeJornada#" skin="info1">
									  		<div align="justify">
									  			<p>
												<cf_translate key="AYUDA_ReporteDeJornadasLaborales">
												Reporte de Jornadas Laborales. El reporte muestra todas las jornadas si no se especifica una en el campo de Jornada, y muestra los emplados por jornada si se activa la opción de Mostrar Empleados.
												</cf_translate></p>
											</div>
										<cf_web_portlet_end>
									</td>
								</tr>
							</table>  
						</td>
						<td valign="top">
							<table width="100%" cellpadding="2" cellspacing="2" align="center">
								<tr>
									<td align="right">
										<strong><cf_translate  key="LB_Jornada">Jornada</cf_translate>:&nbsp;</strong>
									</td>
									<td colspan="3">
										<select name="RHJid">
										<option value="">----<cf_translate  key="CMB_Todas">Todas</cf_translate>----</option>
										<cfloop query="rsJornadas">
											<option value="#RHJid#">#Descripcion#</option>
										</cfloop>
										</select>
									</td>
								</tr>
								<tr>
									
									<td align="right">
										<input name="empleados" type="checkbox" value="1" />
									</td>
									<td>
										<strong><cf_translate  key="CHK_MostrarEmpleados">Mostrar Empleados</cf_translate>&nbsp;</strong>
									</td>
								
								</tr>
								<tr>
									<td align="right"><strong><cf_translate  key="LB_Formato">Formato</cf_translate>:&nbsp;</strong></td>
									<td colspan="3">
										<select name="formato">
											<option value="flashpaper"><cf_translate  key="CMB_Flashpaper">Flashpaper</cf_translate></option>
											<option value="pdf"><cf_translate  key="CMB_PDF">PDF</cf_translate></option>
											<option value="excel"><cf_translate  key="CMB_Excel">Excel</cf_translate></option>
										</select>
									</td>
							    </tr>
								<tr>
									<td align="center" colspan="4">
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="BTN_Limpiar"
									Default="Limpiar"
									XmlFile="/rh/generales.xml"
									returnvariable="BTN_Limpiar"/>
									
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="BTN_Consultar"
									Default="Consultar"
									XmlFile="/rh/generales.xml"
									returnvariable="BTN_Consultar"/>
									<cfoutput>										
									<input type="submit" name="Consultar" value="#BTN_Consultar#">
									<input type="reset" name="Limpiar" value="#BTN_Limpiar#">
									</cfoutput>										
									</td>
								</tr>
								<tr>
									<td colspan="4">&nbsp;</td>
								</tr>
							</table>
						</td>	
					</tr>
				</table>
			</form>
		</cfoutput>	
		
	<cf_web_portlet_end>
<cf_templatefooter>

