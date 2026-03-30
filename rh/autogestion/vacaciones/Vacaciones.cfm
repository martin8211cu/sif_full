<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_RecursosHumanos"
Default="Recursos Humanos"
XmlFile="/rh/generales.xml"
returnvariable="LB_RecursosHumanos"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_ConsultaDeSaldoDeVacaciones"
Default="Consulta de Saldo de Vacaciones"
returnvariable="LB_ConsultaDeSaldoDeVacaciones"/> 


<cfquery name="RSDeid" datasource="#session.DSN#">
	select ltrim(rtrim(llave)) as Deid  from UsuarioReferencia  
	where  Usucodigo   = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
	and STabla = 'DatosEmpleado'
	and Ecodigo = <cfqueryparam value="#session.EcodigoSDC#" cfsqltype="cf_sql_numeric">
</cfquery>

<cfif RSDeid.recordCount GT 0>
	<cfinvoke component="rh.Componentes.RH_Funciones" 
		method="DeterminaJefe"
		DEid = "#RSDeid.DEid#"
		fecha = "#Now()#"
		returnvariable="esjefe">
	<cfif isdefined("esjefe.CFID") and len(trim(esjefe.CFID))>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_RecursosHumanos"
			Default="Recursos Humanos"
			XmlFile="/rh/generales.xml"
			returnvariable="LB_RecursosHumanos"/>
		<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
			<cf_templatecss>
			<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
			<cfinclude template="/rh/Utiles/params.cfm">
			<cfset Session.Params.ModoDespliegue = 1>
			<cfset Session.cache_empresarial = 0>			
			<cf_web_portlet_start titulo="#LB_ConsultaDeSaldoDeVacaciones#">
				<cfinclude template="/rh/portlets/pNavegacion.cfm">
				<form name="form1" method="post" action="VacacionesRep.cfm">
					<table width="100%"  border="0" cellspacing="0" cellpadding="2" align="center">
						<tr>
							<td width="45%"  valign="top"rowspan="6" align="center">
								<cf_web_portlet_start border="true" titulo="#LB_ConsultaDeSaldoDeVacaciones#" skin="info1">
									<div align="justify">
									<p> 
									<cf_translate  key="LB_LeyendaQueExplicaElReporte">
										<li>En este reporte se muestran el detalle del saldo de las vacaciones de los empleados hasta la fecha de corte seleccionada.</li>
										<br><br>
										<li>El encargado del centro funcional podr&aacute; consultar el saldo de vacaciones de sus colaboradores.</li> 
									</cf_translate>
									</p>
									</div>
								<cf_web_portlet_end> 
							</td>
							<td colspan="2" align="right" class="fileLabel">&nbsp;</td>
						</tr>
						<tr>
							<td class="fileLabel" align="right">
								<strong><cf_translate  key="LB_FechaCorte">Fecha Corte</cf_translate>:</strong>
							</td>
							<td>
								<cf_sifcalendario form="form1" tabindex="1" name="Fcorte" value="#LSDateFormat(Now(), 'dd/mm/yyyy')#">
							</td>
						</tr>
						<tr>
							<td class="fileLabel" align="right">
								<strong><cf_translate  key="LB_Formato">Formato</cf_translate>:</strong>
							</td>
							<td>
								<select name="formato" tabindex="5">
								<option value="HTML" selected="selected"><cf_translate  key="CMB_HTML">HTML</cf_translate></option>
								<option value="Excel"><cf_translate  key="CMB_Excel">Excel tabulado </cf_translate></option>
								</select>
							</td>
						</tr>
						<tr>
							<td colspan="1"  align="right">
								<input  type="checkbox" name="limitar" tabindex="6" value="1">
							</td>
							<td colspan="2">
								<strong><cf_translate key="CHK_Limitar_consulta_a_un_nivel">Limitar consulta a un nivel.</cf_translate></strong>
							</td>
						</tr>
						
						<tr>
							<td colspan="3" align="center">&nbsp;</td>
						</tr>					
						<tr>
							<td colspan="3" align="center" class="fileLabel">
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Generar"
								Default="Generar"
								XmlFile="/rh/generales.xml"
								returnvariable="BTN_Generar"/>
								<input name="btnConsultar" type="submit" id="btnConsultar" value="<cfoutput>#BTN_Generar#</cfoutput>">
							</td>
						</tr>
						<tr>
							<td colspan="3" align="center" class="fileLabel">&nbsp;</td>
						</tr>
					</table>
					<input  type="hidden" name="CFID"  value="<cfoutput>#esjefe.CFID#</cfoutput>">
				</form>
			<cf_web_portlet_end>
		<cf_templatefooter>	
	<cfelse>
		<cf_template template="#session.sitio.template#">
			<cf_templatearea name="title">
				<cf_translate key="LB_RecursosHumanos" XmlFile="/rh/generales.xml">Recursos Humanos</cf_translate>
			</cf_templatearea>
			<cf_templatearea name="body">
				<cf_templatecss>	
				 <cf_web_portlet_start border="true" titulo="#LB_ConsultaDeSaldoDeVacaciones#" skin="#Session.Preferences.Skin#">
					<table width="100%" border="0">
						<tr>
							<td>
								&nbsp;
							</td>
						</tr>
						<tr>
							<td align="center">
								<font  style="font-size:15px"><cf_translate key="LB_mensajealerta">Para accesar esta opci&oacute;n tiene que ser empleado y adem&aacute;s encargado de un centro funcional</cf_translate></font>
							</td>
						</tr>
						<tr>
							<td>
								&nbsp;
							</td>
						</tr>
					</table>
				<cf_web_portlet_end>
			</cf_templatearea>
		</cf_template>
	</cfif>	
<cfelse>
	<cf_template template="#session.sitio.template#">
		<cf_templatearea name="title">
			<cf_translate key="LB_RecursosHumanos" XmlFile="/rh/generales.xml">Recursos Humanos</cf_translate>
		</cf_templatearea>
		<cf_templatearea name="body">
			<cf_templatecss>	
			 <cf_web_portlet_start border="true" titulo="#LB_ConsultaDeSaldoDeVacaciones#" skin="#Session.Preferences.Skin#">
			 	<table width="100%" border="0">
					<tr>
						<td>
							&nbsp;
						</td>
					</tr>
					<tr>
						<td align="center">
							<font  style="font-size:15px"><cf_translate key="LB_mensajealerta">Para accesar esta opci&oacute;n tiene que ser empleado y adem&aacute;s encargado de un centro funcional</cf_translate></font>
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
					</tr>
				</table>
			<cf_web_portlet_end>
		</cf_templatearea>
	</cf_template>
</cfif>	
