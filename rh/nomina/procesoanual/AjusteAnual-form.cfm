<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_AjusteAnual"
	Default="Ajuste Anual"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_AjusteAnual"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CalculoAnual"
	Default="C&aacute;lculo de Ajuste Anual"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_CalculoAnual"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConceptosPago"
	Default="Selecci&oacute;n de Conceptos de Pago"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_ConceptosPago"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nomina"
	Default="Descargar archivos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Nomina"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EmpleadosNoAA"
	Default="Empleados para no calcular Ajuste Anual"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_EmpleadosNoAA"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Generacion"
	Default="Generaci&oacute;n de Empleados"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Generacion"/>
    
<cfif not isdefined("form.RHAAid") and isdefined("url.RHAAid") and len(trim(url.RHAAid))>
	<cfset form.RHAAid = url.RHAAid>
</cfif>

<cfset modoE = "ALTA">
<cfif isdefined("form.RHAAid") and len(trim(form.RHAAid))>
	<cfset modoE = "CAMBIO">
</cfif>

<cfif isdefined("form.RHAAid") and len(trim(form.RHAAid))>
<cfquery name="rsRHAjusteAnual" datasource="#session.DSN#">
	select RHAAid,RHAAEstatus
	from RHAjusteAnual
	where Ecodigo = #session.Ecodigo#
    	and RHAAid = #form.RHAAid#
</cfquery>
</cfif>

<cfif isdefined("rsRHAjusteAnual") and rsRHAjusteAnual.RHAAEstatus EQ 1 >
	<cfset modoE = "CERRADA">
</cfif>

<!---<cfthrow message= "#modoE#">--->
    
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top" nowrap="nowrap">
            	<cfif modoE EQ "ALTA" or modoE EQ "CAMBIO">
				<cf_web_portlet_start titulo="#LB_CalculoAnual#">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
	                    <tr valign="top">
							<td align="center" width="100%" nowrap="nowrap" height="450" valign="top">
	                            <cfif isdefined("url.tab") and not isdefined("form.tab")>
									<cfset form.tab = url.tab >
                                </cfif>
                                <cfif not (isdefined("form.tab") and ListContains('1,2,3,4', form.tab) )>
                                    <cfset form.tab = 1 >
                                </cfif> 
                                <cf_tabs width="99%">
                                    <cf_tab text="#LB_CalculoAnual#" selected="#form.tab eq 1#">
                                        <cf_web_portlet_start border="true" titulo="#LB_CalculoAnual#" >
                                            <cfinclude template="Paso1-AjusteAnual.cfm">
                                        <cf_web_portlet_end>
                                    </cf_tab>
                                    <cfif modoE eq "CAMBIO">
                                        <cf_tab text="#LB_ConceptosPago#" selected="#form.tab eq 2#">
                                            <cf_web_portlet_start border="true" titulo="#LB_ConceptosPago#" >
                                                <cfinclude template="Paso2-AjusteAnual.cfm">
                                            <cf_web_portlet_end>
                                        </cf_tab>
                                        
                                        <cfquery name="rsSelectConceptos" datasource="#session.DSN#">
                                     		select count(*) as conceptos 
                                        	from DRHAjusteAnual drh
												inner join RHAjusteAnual rha on rha.RHAAid = drh.RHAAid
											where rha.Ecodigo = #session.Ecodigo# 
		  										and drh.RHAAid = #form.RHAAid#
                                    	</cfquery>
                                    <cfif isdefined ("rsSelectConceptos") and rsSelectConceptos.conceptos neq 0>
                                        <cf_tab text="#LB_EmpleadosNoAA#" selected="#form.tab eq 3#">
                                            <cf_web_portlet_start border="true" titulo="#LB_EmpleadosNoAA#" >
                                                <cfinclude template="Paso3-AjusteAnual.cfm">
                                            <cf_web_portlet_end>
                                        </cf_tab>
                                    </cfif>
                                    	<cfquery name="rsSelectNomina" datasource="#session.DSN#">
                                        	select count(*) as empisr 
                                            from RHAjusteAnualAcumulado rhaaa
                                            	inner join RHAjusteAnual rha on rha.RHAAid = rhaaa.RHAAid
											where rhaaa.RHAAid = '#form.RHAAid#'
												and rhaaa.RHAAAcumuladoISPT not in ('')
                                        </cfquery>
                                    <cfif isdefined ("rsSelectNomina") and rsSelectNomina.empisr GT 0>
                                    	<cf_tab text="#LB_Nomina#" selected="#form.tab eq 4#">
                                            <cf_web_portlet_start border="true" titulo="#LB_Nomina#" >
                                                <cfinclude template="Paso4-AjusteAnual.cfm">
                                            <cf_web_portlet_end>
                                        </cf_tab>
                                     <cfelseif isdefined ("form.tab") and #form.tab# EQ 4>
                                     	<cf_tab text="#LB_Nomina#" selected="#form.tab eq 4#">
                                            <cf_web_portlet_start border="true" titulo="#LB_Nomina#" >
                                                <cfinclude template="Paso4-AjusteAnual.cfm">
                                            <cf_web_portlet_end>
                                        </cf_tab>
                                     </cfif>
                                    </cfif>
                                </cf_tabs>
                            </td> 
						</tr>
					</table>
				<cf_web_portlet_end>
                <cfelseif modoE EQ 'CERRADA'>
                 	<cflocation url="/cfmx/rh/nomina/procesoanual/repAjusteAnual.cfm?RHAAid=#Form.RHAAid#">
                </cfif>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>	