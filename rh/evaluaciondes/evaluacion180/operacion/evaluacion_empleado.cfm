<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
﻿<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_templatecss>
  		<cfinclude template="/rh/Utiles/params.cfm">
		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0>
		<!---Averiguar el DEid del usuario logueado---->
		<cfquery name="rsDEid" datasource="#session.DSN#">
			select llave as DEid
			from UsuarioReferencia
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				and STabla = 'DatosEmpleado'
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">	
		</cfquery>			
		<cfif rsDEid.RecordCount NEQ 0>
			<!---Datos de empleado---->
			<cfquery name="rsEmpleado" datasource="#Session.DSN#">
				select 	a.DEid, 
						a.DEidentificacion, 
						a.DEnombre, 
						a.DEapellido1, 
						a.DEapellido2,
						n.NTIdescripcion,
						d.RHPcodigo, 
						d.RHPdescripcion,
						f.CFdescripcion							
				from DatosEmpleado a
					inner join NTipoIdentificacion n
						on a.NTIcodigo = n.NTIcodigo	

					inner join LineaTiempo c
						on a.DEid = c.DEid
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between c.LTdesde and c.LThasta
					
						inner join RHPlazas d
							on c.RHPid = d.RHPid

							inner join RHPuestos e
								on d.RHPpuesto = e.RHPcodigo

							inner join CFuncional f
								on d.CFid = f.CFid

				where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDEid.DEid#">
			</cfquery>
<cfdump var="#rsEmpleado#">		
			<cfoutput>
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
				<tr>
					<td><table width="100%" cellpadding="3" cellspacing="0">
						<tr> 
						  <td class="#Session.preferences.Skin#_thcenter" colspan="2"><cf_translate key="LB_Datos_Generales">DATOS GENERALES</cf_translate></td>
						</tr>
						<tr> 
						  <td width="10%" align="center" valign="top" style="padding-left: 10px; padding-right: 10px;"> 
							 <cfinclude template="frame-foto.cfm">
						  </td>
						  <td valign="top" nowrap> 
							  <table width="100%" border="0" cellpadding="5" cellspacing="0">
								<tr> 
								  <td class="fileLabel" width="10%" nowrap><cf_translate key="LB_Nombre_Completo">Nombre Completo</cf_translate>:</td>
								  <td><b><font size="3">#rsEmpleado.DEnombre# #rsEmpleado.DEapellido1# #rsEmpleado.DEapellido2#</font></b></td>
								</tr>
								<tr> 
								  <td class="fileLabel" nowrap>#rsEmpleado.NTIdescripcion#:</td>
								  <td>#rsEmpleado.DEidentificacion#</td>
								</tr>
							  </table>
						  </td>
						</tr>
					</td></table>
				</tr>
				<tr>
					<td>
						<table width="100%" cellpadding="0" cellspacing="0">
							<form name="form1">
					
							</form>
						</table>
					</td>
				</tr>
			</table>
			</cfoutput>
		</cfif>
  	<cf_web_portlet_end>
<cf_templatefooter>
