<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 2-1-2005.
		Motivo: Se corrige el uso de la varible de session "modulo". También se corrige la navegación de la lista.
	Modificado por Hector Garcia Beita.
		Fecha: 22-07-2011.
		Motivo: Se agregan variables de redirección para los casos en que el 
		fuente sea llamado desde la opción de tarjetas de credito mediante includes
		con validadores segun sea el caso
 --->
 
 
<!---
	Validador para los casos en que la transaccion se realiza
	desde la opcion de bancos o desde tarjetas de credito. 
--->
<cfset LvarIrA="TransaccionesBanco.cfm">
<cfset LvarIrABanco="Banco.cfm">
<cfset LvarBTEtce= 0>
<cfif isdefined("LvarTCETransaccionesBancos")>
	<cfset LvarIrA="TCETransaccionesBanco.cfm">
    <cfset LvarIrABanco="TCEBanco.cfm">
    <cfset LvarBTEtce= 1>
</cfif>

<cfif not isdefined("form.Bid") and not isdefined("url.Bid")>
	<!---Redireccion Banco o TCEBanco (Tarjetas de Credito)--->
	<cflocation addtoken="no" url="#LvarIrABanco#">
</cfif>
      
                         
<cfparam name="session.modulo" default="MB">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
	<!--- <cf_translate key="LB_SIFBancos" XmlFile="/sif/generales.xml">SIF - Bancos</cf_translate> --->
	<cf_templateheader title="#Request.Translate('LB_SIFBancos','SIF - Bancos','/sif/generales.xml')#">
		<cfif isdefined("url.modo") and len(trim(url.modo)) and not isdefined("form.modo")>
			<cfset form.modo = url.modo>
		</cfif>
		<cfif isdefined("url.Bid") and len(trim(url.Bid)) and not isdefined("form.Bid")>
			<cfset form.Bid = url.Bid>
		</cfif>
		<cfif isdefined("url.BTEcodigo") and len(trim(url.BTEcodigo)) and not isdefined("form.BTEcodigo")>
			<cfset form.BTEcodigo = url.BTEcodigo>
		</cfif>
		<cfif isdefined("form.LvarBid") and len(trim(form.LvarBid)) and not len(trim(form.Bid))>
			<cfset form.Bid = form.LvarBid>
		</cfif>	

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_TransaccionesBancos"
					Default="Transacciones Bancos"
					returnvariable="LB_TransaccionesBancos"/>
		            <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_TransaccionesBancos#'>
	
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr><td colspan="2">
								<cfinclude template="../../portlets/pNavegacionMB.cfm">
							<tr>
							<td width="50%" valign="top"> 
							  <cfif isdefined("Form.Pagina") and Form.Pagina NEQ "">
								<cfset Pagenum_lista = #Form.Pagina#>
							  </cfif>  				  
							  <cfset navegacion = "">	
							  <cfset navegacion = navegacion & "&desde=#session.modulo#">
							  <cfset navegacion = navegacion & "&Bid=#form.Bid#">
							   
							  <cfquery name="rsLista" datasource="#session.DSN#">
								select 
									Bid,
									BTEcodigo,
									BTEdescripcion,
									case when BTEtipo = 'C' then 'Crédito' else 'Débito' end as BTEtipo,
									BMUsucodigo
								from TransaccionesBanco
								where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
                                and BTEtce = <cfqueryparam cfsqltype="cf_sql_bit" value="#LvarBTEtce#">
							  </cfquery>
							  <cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_Transaccion"
									Default="Transacci&oacute;n"
									XmlFile="/sif/generales.xml"
									returnvariable="LB_Transaccion"/>

							  <cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_Descripcion"
									Default="Descripci&oacute;n"
									XmlFile="/sif/generales.xml"
									returnvariable="LB_Descripcion"/>

							  <cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_Tipo"
									Default="Tipo"
									XmlFile="/sif/generales.xml"
									returnvariable="LB_Tipo"/>
								
                               <!---Redireccion TransaccionesBanco o TCETransaccionesBanco (Tarjetas de Credito)--->
 							  <cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
									query="#rsLista#" 
									desplegar="BTEcodigo, BTEdescripcion, BTEtipo"
									etiquetas="#LB_Transaccion#,#LB_Descripcion#,#LB_Tipo#"
									formatos="S,S, S"
									align="left, left, left"
									checkboxes="N"
									maxrows="16"
									ira="#LvarIrA#"
									keys="Bid, BTEcodigo"
									navegacion="#navegacion#"
									showEmptyListMsg ="true"
								/>
                        
							</td>                            
							<td width="50%" valign="top">
                            <cfinclude template="formTransaccionesBanco.cfm">
                            </td>
						  </tr>
						</table>
            	
		            <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>