<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Bancos"
	Default="Bancos"
	returnvariable="Translate"/>
<cf_templateheader title="#Request.Translate('LB_Bancos','Bancos','/sif/generales.xml')#">	
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#Translate#'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2">
					<cfif isdefined('url.desde') and trim(url.desde) EQ 'rh'>
						<cfset form.desde = url.desde >
					</cfif>
					
					<cfset desde = '' >
					<cfif isdefined('form.desde') and trim(form.desde) EQ 'rh'>
						<cfset desde = ", 'rh' as desde" >
						<cfset regresar = "/cfmx/rh/indexEstructura.cfm">	
						<cfset navBarItems = ArrayNew(1)>
						<cfset navBarLinks = ArrayNew(1)>
						<cfset navBarStatusText = ArrayNew(1)>			 
						<cfset navBarItems[1] = "Estructura Organizacional">
						<cfset navBarLinks[1] = "/cfmx/rh/indexEstructura.cfm">
						<cfset navBarStatusText[1] = "/cfmx/rh/indexEstructura.cfm">			
					
					  <cfinclude template="/sif/portlets/pNavegacion.cfm">					
					<cfelse>
						<cfinclude template="../../portlets/pNavegacionMB.cfm">
					</cfif>
				</td>
			</tr>
			<tr>
				<td width="50%" valign="top">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_Bancos"
						Default="Bancos"
						returnvariable="LB_Bancos"/>
					<cfif isdefined("Form.Pagina") and Form.Pagina NEQ "">
						<cfset Pagenum_lista = Form.Pagina>
					</cfif> 
                    
                    <!---
						Validador para los casos en que la transaccion se realiza
						desde la opcion de bancos o desde tarjetas de credito. 
					 --->
                    <cfset LvarIrA="Bancos.cfm">
                    <cfif isdefined("LvarTCEBancos")>
                    	<cfset LvarIrA="TCEBancos.cfm">
                    </cfif>
                    <!---Variable "LvarIrA" para redireccion segun sea el caso--->
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH" 
						tabla="Bancos" 
						columnas="Bid, Bdescripcion #desde#" 
						desplegar="Bdescripcion"
						etiquetas="#LB_Bancos#"
						formatos=""
						filtro="Ecodigo=#session.Ecodigo#"
						align="left"
						checkboxes="N"
						ira="#LvarIrA#"
						keys="Bid">
					</cfinvoke>
				</td>
				<td width="50%">
					<cfinclude template="formBancos.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>