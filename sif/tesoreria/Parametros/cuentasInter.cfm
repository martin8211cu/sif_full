<cf_templateheader title="Mantenimiento de Tesorería">
	<cfset titulo = 'Registro de Cuentas Intercompañ&iacute;as'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
		<!--- Verifica si existe la compañia, y de no existir la incluye --->
		<cfquery datasource="#session.dsn#" name="verifica_empresa">
		Select Ecodigo
		from PARcuentasIntercompania
		where Ecodigo = #Session.Ecodigo#
		</cfquery>

		<cfif verifica_empresa.recordcount eq 0>

			<cfquery datasource="#session.dsn#" name="InsEmpresa">
			Insert into PARcuentasIntercompania(Ecodigo,           
							    CFmascaraCXC,
							    CFmascaraCXP,
							    BMUsucodigo)
			values(                             #Session.Ecodigo#, 
							    null,        
							    null,        
							    null)
			</cfquery>

		</cfif>
		
		<table width="100%" border="0" cellspacing="6" align="center">
		  <tr>
			<!---
			<td valign="top">
				<cfquery datasource="#session.dsn#" name="lista">
					select TESid,TESdescripcion
					from Tesoreria
					<!--- falta el where --->
				</cfquery>
				
		
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#lista#"
					desplegar="TESid,TESdescripcion"
					etiquetas="ID Tesoreria, Tesoreria"
					formatos="S,S"
					align="left,left"
					ira="Tesoreria.cfm"
					form_method="get"
					keys="TESid"
				/>		
			</td> --->
			<td valign="top">
				<cfinclude template="cuentasInter_form.cfm">
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>	


