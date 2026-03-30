<cf_templateheader title="Mantenimiento de Tesorería">
	<cf_navegacion name="TESid" navegacion="">
	<cf_templatecss>
	<cfset titulo = 'Tesorer&iacute;as Corporativas'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
		<table width="100%" border="0" cellspacing="6">
		  <tr>
			<td valign="top">
				<cfquery datasource="#session.dsn#" name="lista">
					select TESid,TEScodigo,TESdescripcion,Edescripcion
					from Tesoreria t
						inner join Empresas e
							on e.Ecodigo=t.EcodigoAdm
					WHERE CEcodigo  =  #session.CEcodigo#  
				</cfquery>
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#lista#"
					desplegar="TEScodigo,TESdescripcion,Edescripcion"
					etiquetas="C&oacute;digo, Tesorer&iacute;a,Empresa Administradora"
					formatos="S,S,S"
                    PageIndex="1"
					align="left,left,left"
					ira="Tesoreria.cfm"
					keys="TESid"
				/>		
			</td>
			<td valign="top">
				<cfinclude template="Tesoreria_form.cfm">
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>	


