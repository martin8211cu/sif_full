
<!---<cf_translate key="LB_TarjetasCredito" XmlFile="/sif/generales.xml">Tarjetas de Credito Empresarial</cf_translate> --->
<cf_templateheader title="#Request.Translate('LB_TarjetasCredito','Tarjetas de Credito Empresarial','/sif/generales.xml')#">

<cfset LvarPagina = "TCEBanco.cfm">
<cfset LvarIrAPagina = "TCECatalogo.cfm">
<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("form.Descripcion_filtro") and len(trim(form.Descripcion_filtro)) gt 0 >
	<cfset filtro = filtro & " and upper(a.CBTCDescripcion) like '%#ucase(form.Descripcion_filtro)#%'" >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Descripcion_filtro=" & form.Descripcion_filtro>
</cfif>

<cfif isdefined("form.Numero_filtro") and len(trim(form.Numero_filtro)) gt 0 >
	<cfset filtro = filtro & " and upper(a.CBTNumTarjeta) like '%#ucase(form.Numero_filtro)#%'" >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Numero_filtro=" & form.Numero_filtro>
</cfif>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_TarjetasCredito"
					Default="Tarjetas de Cr&eacute;dito Empresarial"
					returnvariable="LB_TarjetasCredito"/>
		            <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_TarjetasCredito#'>
	
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
						<td width="60%" valign="top"> 
							<form style="margin:0;" name="filtro1" method="post">
                                    <table border="0" width="100%" class="areaFiltro">
                                        <tr> 
                                            <cfoutput>
                                                <td><strong>Descripci&oacute;n</strong></td>
                                                <td><strong>N&uacute;mero</strong></td>
                                            </cfoutput>
                                        </tr>
                                        <tr> 
                                            <td><input type="text" name="Descripcion_filtro" value="<cfif isdefined("form.Descripcion_filtro") and len(trim(form.Descripcion_filtro)) gt 0 ><cfoutput>#form.Descripcion_filtro#</cfoutput></cfif>" size="30" maxlength="40" onFocus="javascript:this.select();" ></td>
                                            <td><input type="text" name="Numero_filtro" value="<cfif isdefined("form.Numero_filtro") and len(trim(form.Numero_filtro)) gt 0 ><cfoutput>#form.Numero_filtro#</cfoutput></cfif>" size="40" maxlength="20" onFocus="javascript:this.select();" ></td>
                                            <td nowrap>
                                                <input type="submit" name="Filtrar" value="Filtrar">
                                            </td>
                                        	<input type="hidden" id="Bid" name="Bid" value="<cfif isdefined("form.Bid") and len(trim(form.Bid)) neq 0><cfoutput>#form.Bid#</cfoutput></cfif>">
                                        </tr>								
                                    </table>
                           	</form>
                                                        							
						 	<cfif isdefined("Form.Pagina") and Form.Pagina NEQ "">
									<cfset Form.Pagina = 1>
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
                                
                            <cfquery name="rsSQL" datasource="#session.dsn#">
                                select count(1) as cantidad
                                  from CBTMarcas
                            </cfquery>
                            
                            <cfif rsSQL.cantidad EQ 0>
                                <cfquery datasource="#session.dsn#">
                                    insert into CBTMarcas (CBTMarca, CBTMascara)
                                    values ('VISA','4XXX XXXX XXXX X[XXX]')
                                </cfquery>
                                <cfquery datasource="#session.dsn#">
                                    insert into CBTMarcas (CBTMarca, CBTMascara)
                                    values ('MasterCard','5XXX XXXX XXXX XXXX')
                                </cfquery>
                                <cfquery datasource="#session.dsn#">
                                    insert into CBTMarcas (CBTMarca, CBTMascara)
                                    values ('AmericanExpress','3XXX XXXXXX XXXXX')
                                </cfquery>
                                <cfquery datasource="#session.dsn#">
                                    insert into CBTMarcas (CBTMarca, CBTMascara)
                                    values ('Discover','6011 XXXX XXXX XXXX')
                                </cfquery>
                                <cfquery datasource="#session.dsn#">
                                    insert into CBTMarcas (CBTMarca, CBTMascara)
                                    values ('DinersClub','3XXX XXXXXX XXXX')
                                </cfquery>
                            </cfif>
                            
							<cfquery name="rsMonedaLoc" datasource="#session.DSN#">
                                select e.Mcodigo, m.Mnombre 
                                from Empresas e
                                inner join Monedas m
                                on m.Mcodigo = e.Mcodigo 
                                where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                            </cfquery>	

                            <cf_dbfunction name="concat" args="'<div style=""width:150px;"">' + a.CBTNumTarjeta + '</div>'" returnvariable="LvarCBTNumTarjeta" delimiters="+">
                            <cf_dbfunction name="concat" args="'<div style=""width:350px;"">' + a.CBTCDescripcion + '</div>'" returnvariable="LvarCBTCDescripcion" delimiters="+">

							<!---Redireccion CuentasBancarias o TCECuentasBancarias (Tarjetas de Credito)--->						 
							<cfinvoke component="sif.Componentes.pListas" method="pListaRH" 
								tabla="CBTarjetaCredito a
                                	   inner join Bancos b
                                       on b.Bid = a.Bid
                                       and b.Ecodigo = a.Ecodigo
                                       inner join CuentasBancos c
                                       on c.CBTCid = a.CBTCid
                                       and c.Ecodigo = a.Ecodigo
                                       and c.Mcodigo = #rsMonedaLoc.Mcodigo#" 
								columnas="a.CBTCid, c.CBid, a.Bid, #LvarCBTCDescripcion# as CBTCDescripcion, #LvarCBTNumTarjeta# as CBTNumTarjeta, b.Bdescripcion #desde#" 
								desplegar="CBTCDescripcion, CBTNumTarjeta"
								etiquetas="#LB_Descripcion#,#LB_Numero#"
								formatos="S,S"
                                filtro="a.Ecodigo = #session.Ecodigo# and a.Bid = #Form.Bid# #filtro#"
								align="left, left"
								checkboxes="N"
								maxrows="5"
 								ira="#LvarIrAPagina#"
                                navegacion = "#navegacion#"
								keys="CBTCid" 
                                ajustar="S">
							</cfinvoke>
						</td>
						<td width="40%" valign="top"><cfinclude template="TCECatalogo-form.cfm"></td>
					  </tr>
					  <tr><td colspan="2">&nbsp;</td></tr>
					  <tr><td colspan="2">&nbsp;</td></tr>
					</table>
            	
		            <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>