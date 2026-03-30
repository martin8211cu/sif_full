<cf_templateheader title="Clasificación de Artículos y Servicios para Socios de Negocio">

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Clasificación de Artículos y Servicios para Socios de Negocio'>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="3">
						<cfinclude template="../../portlets/pNavegacion.cfm">
					</td>
				</tr>
				
				<!---  --->
				<cfif isDefined("url.SNcodigo") and not isDefined("form.SNcodigo")>
				  <cfset form.SNcodigo = url.SNcodigo>
				</cfif>	
				<cfif isDefined("url.filtro_SNnombre") and not isDefined("form.filtro_SNnombre")>
				  <cfset form.filtro_SNnombre = url.filtro_SNnombre>
				</cfif>	
				<cfif isDefined("url.filtro_SNnumero") and not isDefined("form.filtro_SNnumero")>
				  <cfset form.filtro_SNnumero = url.filtro_SNnumero>
				</cfif>		

				<!--- Variables para Navegacin --->
				<!-- Aqui van los campos Llave Definidos para la tabla -->
				<cfif isdefined("url._")>
					<cf_navegacion name = "filtro_SNnombre" default = "">
					<cf_navegacion name = "filtro_SNnumero" default = "">
				<cfelse>
					<cf_navegacion name = "filtro_SNnombre" default = "" session="">
					<cf_navegacion name = "filtro_SNnumero" default = "" session="">
				</cfif>			
				<TR><TD>&nbsp;</TD></TR>
				<tr> 
					<td valign="top" width="50%"> 	
						<cfquery name="rsLista" datasource="#session.DSN#">
							select  distinct b.SNnumero, b.SNnombre, a.SNcodigo
							from ClasificacionItemsProv a
								inner join SNegocios b
									on a.SNcodigo = b.SNcodigo
									and a.Ecodigo = b.Ecodigo
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">		
							<cfif isdefined('form.filtro_SNnombre')and len(trim(form.filtro_SNnombre)) >
								and upper(b.SNnombre) like upper('%#form.filtro_SNnombre#%')
							</cfif>	
							<cfif isdefined('form.filtro_SNnumero')and len(trim(form.filtro_SNnumero)) >
								and upper(b.SNnumero) like upper('%#form.filtro_SNnumero#%')
							</cfif>	
							Order by  b.SNnumero, b.SNnombre  
						</cfquery>
						
						<cfinvoke 
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="desplegar" value="SNnumero, SNnombre"/>
							<cfinvokeargument name="etiquetas" value="C&oacute;digo, Nombre"/>
							<cfinvokeargument name="formatos" value="V,V"/>
							<cfinvokeargument name="align" value="left,left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="ClasificacionSocioNeg.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
						   <cfinvokeargument name="PageIndex" value="1"/>
						   <cfinvokeargument name="formName" value="form2"/>
							<cfinvokeargument name="incluyeForm" value="true"/>
							<cfinvokeargument name="usaAjax" value="true"/>
							<cfinvokeargument name="conexion" value="#session.dsn#"/>
							<cfinvokeargument name="mostrar_filtro" value="true"/>
							<cfinvokeargument name="filtrar_automatico" value="true"/>
						</cfinvoke>
					</td>
					<td valign="top" width="50%">
					<cfif isdefined('form.SNcodigo') and len(trim(form.SNcodigo)) or isdefined ('url.SNcodigo')>
						<cfset SNcodigo = #form.SNcodigo#>
					</cfif>
						<cfinclude template="formClasificacionSocioNeg.cfm">
					
					</td>
				</tr>
			</table>
<cf_web_portlet_end>
<cf_templatefooter>
