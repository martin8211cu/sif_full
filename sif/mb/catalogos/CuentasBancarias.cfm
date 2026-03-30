<!---
	Modificado por Hector Garcia Beita.
		Fecha: 22-07-2011.
		Motivo: Se agregan variables de redirección para los casos en que el 
		fuente sea llamado desde la opción de tarjetas de credito mediante includes
		con validadores segun sea el caso
--->

<!--- <cf_translate key="LB_CuentasBancarias" XmlFile="/sif/generales.xml">Cuentas Bancarias</cf_translate> --->
<cf_templateheader title="#Request.Translate('LB_CuentasBancarias','Cuentas Bancarias','/sif/generales.xml')#">

<!---
	Validador para los casos en que la transaccion se realiza
	desde la opcion de bancos o desde tarjetas de credito. 
 --->
<cfset LvarPagina = "Bancos.cfm">
<cfset LvarIrAPagina = "CuentasBancarias.cfm">
<cfif isdefined("LvarTCECuentasBancarias")>
	<cfset LvarPagina = "TCEBanco.cfm">
   	<cfset LvarIrAPagina = "TCECuentasBancarias.cfm">
</cfif>


		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_CuentasBancarias"
					Default="Cuentas Bancarias"
					returnvariable="LB_CuentasBancarias"/>
		            <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_CuentasBancarias#'>
	
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td colspan="2">
									<cfif isdefined('url.desde') and trim(url.desde) EQ 'rh'>
										<cfset form.desde = url.desde >
									</cfif>
			
								  <cfset desde = '' >
								  <cfif isdefined('form.desde') and trim(form.desde) EQ 'rh'>
										<cfset desde = ", 'rh' as desde" >
                                        <!---Redireccion Bancos o TCEBancos--->
                                        <cfset regresar = "#LvarPagina#">
                                        
                                        
                                        <cfset navBarItems = ArrayNew(1)>
                                        <cfset navBarLinks = ArrayNew(1)>
                                        <cfset navBarStatusText = ArrayNew(1)>			 
                                        <cfset navBarItems[1] = "Estructura Organizacional">
                                        <cfset navBarLinks[1] = "/cfmx/rh/indexEstructura.cfm">
                                        <cfset navBarStatusText[1] = "/cfmx/rh/indexEstructura.cfm">			
                                        
                                        <cfinclude template="/sif/portlets/pNavegacion.cfm">					
                                <cfelse>
										<cfoutput>
                                        <cfif isdefined("form.Bid") and len(trim(form.Bid)) >
                                        <!---Redireccion Bancos o TCEBancos--->
											<cfset regresar = "#LvarPagina#">
                                        <cfelse>
                                        <!---Redireccion Bancos o TCEBancos--->
                                            <cfset regresar = "#LvarPagina#">
                                        </cfif>
                                        </cfoutput>
                                        <cfinclude template="/sif/portlets/pNavegacionMB.cfm">
								</cfif>
							</td>
						</tr>
		
					  <tr>
						<td width="49%" valign="top"> 
						  <cfif isdefined('Form.PageNum') and Form.PageNum NEQ "" >
						  		<cfset Form.PageNum = 1>
						  </cfif>
						  <cfif isdefined("Form.Pagina") and Form.Pagina NEQ "">
									<cfset Pagenum_lista = #Form.Pagina#>
							</cfif>
		
							<cfif not isdefined("Form.Bid")>
                            	 <!---Redireccion Bancos o TCEBancos--->
  								<cflocation addtoken="no" url="#LvarPagina#">
							</cfif>
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_Descripcion"
								Default="Descripci&oacute;n"
								XmlFile="/sif/generales.xml"
								returnvariable="LB_Descripcion"/>
								
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_Numero"
								Default="N&uacute;mero"
								XmlFile="/sif/generales.xml"	
								returnvariable="LB_Numero"/>
								
								<!---Redireccion CuentasBancarias o TCECuentasBancarias (Tarjetas de Credito)--->
							<cfinvoke component="sif.Componentes.pListas" method="pListaRH" 
								tabla="CuentasBancos a, Bancos b" 
								columnas="a.CBid, a.Bid, a.CBdescripcion, a.CBcodigo, b.Bdescripcion #desde#" 
								desplegar="CBdescripcion, CBcodigo"
								etiquetas="#LB_Descripcion#,#LB_Numero#"
								formatos=""
								filtro="a.Ecodigo = #session.Ecodigo# and a.CBesTCE = 0 and a.Bid = #Form.Bid# and a.Bid = b.Bid"
								align="left, left"
								checkboxes="N"
								maxrows="15"
 								ira="#LvarIrAPagina#"
								keys="CBid" >
							</cfinvoke>
						</td>
						<td width="50%"><cfinclude template="formCuentasBancarias.cfm"></td>
					  </tr>
					  <tr><td colspan="2">&nbsp;</td></tr>
					  <tr><td colspan="2">&nbsp;</td></tr>
					</table>
            	
		            <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>