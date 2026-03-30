<cf_templateheader title="Tipos de Servicio"> 

 <cf_web_portlet_start border="true" titulo="Tipos de Servicio" skin="#Session.Preferences.Skin#">
 <cfif isdefined ('url.RHTSid') and not isdefined ('form.RHTSid') and len(trim(url.RHTSid)) gt 0>
 	<cfset form.RHTSid=url.RHTSid>
 </cfif>
 	<table>
		<tr>
			<td width="50%" valign="top">
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select RHTSid,RHTScodigo,RHTSdescripcion from 
					RHTiposServ
					where Ecodigo=#session.Ecodigo#
				</cfquery>
				<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
						query="#rsSQL#"
						columnas="RHTSid,RHTScodigo,RHTSdescripcion"
						desplegar="RHTScodigo,RHTSdescripcion"
						etiquetas="Codigo,Descripcion"
						formatos="S,S"
						align="left,left"
						ira=""
						showEmptyListMsg="yes"
						keys="RHTSid"	
						MaxRows="13"
					/>		
			</td>
			<td width="50%" valign="top">
				<cfinclude template="tiposServ-form.cfm">
			</td>
		</tr>
	</table>
	
  <cf_web_portlet_end>
<cf_templatefooter>
	