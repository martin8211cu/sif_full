<cfinvoke component="sif.Componentes.Translate"	method="Translate" XmlFile="/rh/generales.xml"
	Default="Motivos" Key="LB_Motivos"  returnvariable="LB_Motivos"/>
<cfinvoke component="sif.Componentes.Translate"	method="Translate" XmlFile="/rh/generales.xml"
	Default="Motivos de Pedimento de Personal" Key="LB_Motivos_de_Pedimento_de_Personal"  returnvariable="LB_Motivos_de_Pedimento_de_Personal"/>
<cfinvoke component="sif.Componentes.Translate"	method="Translate" XmlFile="/rh/generales.xml"
	Default="Código" Key="LB_Codigo"  returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"	method="Translate" XmlFile="/rh/generales.xml"
	Default="Descripción" Key="LB_Descripcion"  returnvariable="LB_Descripcion"/>
	
<cf_templateheader> 
 <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#">
 <cfif isdefined ('url.RHMid') and not isdefined ('form.RHMid') and len(trim(url.RHMid)) gt 0>
 	<cfset form.RHMid=url.RHMid>
 </cfif>
 	<table>
		<tr>
			<td width="50%" valign="top">
				<cf_translatedata name="get" tabla="RHMotivos" col="RHMdescripcion" returnvariable="LvarRHMdescripcion">
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select RHMid,RHMcodigo,#LvarRHMdescripcion# as RHMdescripcion from 
					RHMotivos
					where Ecodigo=#session.Ecodigo#
				</cfquery>
				<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
						query="#rsSQL#"
						columnas="RHMid,RHMcodigo,RHMdescripcion"
						desplegar="RHMcodigo,RHMdescripcion"
						etiquetas="#LB_Codigo#,#LB_Descripcion#"
						formatos="S,S"
						align="left,left"
						ira=""
						showEmptyListMsg="yes"
						keys="RHMid"	
						MaxRows="20"
					/>		
			</td>
			<td width="50%" valign="top">
				<cfinclude template="motivos-form.cfm">
			</td>
		</tr>
	</table>
	
  <cf_web_portlet_end>
<cf_templatefooter>
	