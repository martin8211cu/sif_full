<cf_templateheader title="Motivos"> 

 <cf_web_portlet_start border="true" titulo="Motivos de Pedimento de Personal" skin="#Session.Preferences.Skin#">
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
						etiquetas="Codigo,Descripcion"
						formatos="S,S"
						align="left,left"
						ira=""
						showEmptyListMsg="yes"
						keys="RHMid"	
						MaxRows="2"
					/>		
			</td>
			<td width="50%" valign="top">
				<cfinclude template="motivos-form.cfm">
			</td>
		</tr>
	</table>
	
  <cf_web_portlet_end>
<cf_templatefooter>
	