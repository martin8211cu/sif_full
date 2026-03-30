<cfinvoke component="sif.Componentes.Translate" method="Translate"
	 Default="Asesores" Key="LB_Asesores" returnvariable="LB_Asesores"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate"
	 Default="Mantenimiento de Asesores" Key="LB_Mantenimiento_de_Asesores" returnvariable="LB_Mantenimiento_de_Asesores"/>


<cf_templateheader> 
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cf_web_portlet_start border="true" titulo="Mantenimiento de Asesores" skin="#Session.Preferences.Skin#">
	<table>
		<tr>
			<td width="50%" valign="top">
			<cfinvoke component="sif.Componentes.Translate" method="Translate"
				Key="LB_NOMBRE" Default="Nombre" returnvariable="LB_NOMBRE"/>
				<!---LISTA DE ASESORES--->
					<cfquery name="rsSQL" datasource="#session.dsn#">
					select ta.Usucodigo,de.DEid, DEnombre #LvarCNCT# ' ' #LvarCNCT# DEapellido1 #LvarCNCT# ' ' #LvarCNCT# DEapellido2 as Nombre
					from RHAsesor ta
						inner join UsuarioReferencia r
								inner join DatosEmpleado de
									on <cf_dbfunction name="to_char" args="de.DEid">=r.llave
									and r.STabla='DatosEmpleado'
							on r.Usucodigo=ta.Usucodigo			
					where ta.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				</cfquery>
				<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
						query="#rsSQL#"
						desplegar="Nombre"
						etiquetas="#LB_NOMBRE#"
						formatos="S"
						align="left"
						ira=""
						showEmptyListMsg="yes"
						keys="DEid"	
						MaxRows="20"
					/>		
			</td>
			<td width="50%" valign="top">
				<cfinclude template="asesores-form.cfm">
			</td>
		</tr>
	</table>
	
  <cf_web_portlet_end>
<cf_templatefooter>