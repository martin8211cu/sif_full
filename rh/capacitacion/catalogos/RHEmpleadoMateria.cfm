<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">
		<cf_templatecss>
		<cfinclude template="/rh/Utiles/params.cfm">
		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0>

		<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
			<cfset form.DEid = url.DEid >
		</cfif>

		<cf_web_portlet_start border="true" titulo="Plan de Capacitaci&oacute;n" skin="#Session.Preferences.Skin#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">

			<cfinclude template="../../expediente/consultas/consultas-frame-header.cfm">
			<cfoutput>
			<table width="99%" border="0" cellpadding="3" cellspacing="0" align="center">
			  <tr>
				<td width="10%" rowspan="9" align="center" valign="top" style="padding-left: 10px; padding-right: 10px; padding-top: 10px;" nowrap>
					<cf_sifleerimagen autosize="false" border="false" tabla="RHImagenEmpleado" campo="foto" condicion="DEid = #rsEmpleado.DEid#" conexion="#Session.DSN#" width="75" height="100">
				</td> 
				<td class="fileLabel" width="10%" nowrap><cf_translate key="NombreExp">Nombre Completo</cf_translate>: </td>
				<td><b><font size="3">#rsEmpleado.DEnombre# #rsEmpleado.DEapellido1# #rsEmpleado.DEapellido2#</font></b></td>
			  </tr>
			  <tr>
				<td class="fileLabel" nowrap><cf_translate key="CedulaExp">#rsEmpleado.NTIdescripcion#</cf_translate>:</td>
				<td>#rsEmpleado.DEidentificacion#</td>
			  </tr>
			  <tr>
				<td class="fileLabel" nowrap><cf_translate key="SexExp">Sexo</cf_translate>:</td>
				<td>#rsEmpleado.Sexo#</td>
			  </tr>
			  <tr>
				<td class="fileLabel" nowrap><cf_translate key="EstadoCivilExp">Estado Civil</cf_translate>:</td>
				<td>#rsEmpleado.EstadoCivil#</td>
			  </tr>
			  <tr>
				<td class="fileLabel" nowrap><cf_translate key="FecNacExp">Fecha de Nacimiento</cf_translate>:</td>
				<td><cf_locale name="date" value="#rsEmpleado.FechaNacimiento#"/></td>
			  </tr>
			  <tr>
				<td class="fileLabel" nowrap><cf_translate key="DireccionExp">Direccion</cf_translate>:</td>
				<td>#rsEmpleado.DEdireccion#</td>
			  </tr>
			  <tr>
				<td class="fileLabel" nowrap><cf_translate key="NDependietesExp">No. de Dependientes</cf_translate>:</td>
				<td>#rsEmpleado.DEcantdep#</td>
			  </tr>
			  <tr>
				<td class="fileLabel" nowrap><cf_translate key="BancoExp">Banco</cf_translate>:</td>
				<td>#rsEmpleado.Bdescripcion#</td>
			  </tr>
			  <tr>
				<td class="fileLabel" nowrap><cf_translate key="CuentaCExp">Cuenta Cliente</cf_translate>:</td>
				<td>#rsEmpleado.CBcc# (#rsEmpleado.Mnombre#)</td>
			  </tr>
			</table>
			</cfoutput>




			<table width="100%" border="0" cellspacing="6">
				<tr><td colspan="2" bgcolor="#CCCCCC" align="center" style="padding:3; " ><strong>Plan de Capacitaci&oacute;n</strong></td></tr>
				<tr>
					<td valign="top" width="50%">
						<cfquery datasource="#session.dsn#" name="lista">
							select em.DEid, 
								   em.Mcodigo, 
								   {fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )}  as DEnombre,
								   m.Msiglas,
								   m.Mnombre
							from RHEmpleadoMateria em
							
							inner join DatosEmpleado de
							on em.Ecodigo=de.Ecodigo
							and em.DEid=de.DEid
							
							inner join RHMateria m
							on em.Mcodigo=m.Mcodigo
							and em.Ecodigo=m.Ecodigo
							
							where em.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
							and em.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
							order by DEnombre, Msiglas, Mnombre
						</cfquery>
				
						<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
							query="#lista#"
							desplegar="Msiglas,Mnombre"
							etiquetas="C&oacute;digo,Materia"
							formatos="S,S"
							align="left,left"
							ira="RHEmpleadoMateria.cfm"
							keys="DEid,Mcodigo"
							showEmptyListMsg="yes"/>		
					</td>
					<td valign="top" width="50%">
						<cfif isdefined("url.Mcodigo") and not isdefined("form.Mcodigo")>
							<cfset form.Mcodigo = url.Mcodigo >
						</cfif>
						<cfinclude template="RHEmpleadoMateria-form.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>