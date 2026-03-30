<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FondoAhorro"
	Default="Fondo de Ahorro"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_FondoAhorro"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CalculoFondoAhorro"
	Default="C&aacute;lculo de Fondo de Ahorro"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_CalculoFondoAhorro"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_InteresGenerado"
	Default="Inter&eacute;s Generado"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_InteresGenerado"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ImporteInteresGenerado"
	Default="Captura de Importe de Inter&eacute;s Generado"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_ImporteInteresGenerado"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EmpleadosGenerados"
	Default="Empleados Generados"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_EmpleadosGenerados"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Relacion_Calculo_Nomina"
	Default="Relacion de C&aacute;lculo de Nomina"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Relacion_Calculo_Nomina"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Cierre_Calculo_Nomina"
	Default="Cierre de C&aacute;lculo de Nomina"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Cierre_Calculo_Nomina"/>


<cfset modoE = "ALTA">
<cfif isdefined('url.RHCFOAid') and len(trim(url.RHCFOAid)) GT 0>
	<cfset modoE = "CAMBIO">
	<cfset RHCFOAid = #url.RHCFOAid#>
<cfelseif isdefined('form.RHCFOAid') and len(trim(form.RHCFOAid)) GT 0>
	<cfset modoE = "CAMBIO">
    <cfset RHCFOAid = #form.RHCFOAid#>
</cfif>


<!---<cf_dump var = "#RHCFOAid#">--->

<!---<cfoutput>       
<form name= "form" method="post" style="margin: 0;">--->
<input type="hidden" name="RHCFOAid" value="#RHCFOAid#">
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top" nowrap="nowrap">
<!---            	<cfif modoE EQ "ALTA" or modoE EQ "CAMBIO">--->
				<cf_web_portlet_start titulo="#LB_CalculoFondoAhorro#">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
	                    <tr valign="top">
							<td align="center" width="100%" nowrap="nowrap" height="450" valign="top">

	                            <cfif isdefined("url.tab") and not isdefined("form.tab")>
									<cfset form.tab = url.tab >
                                </cfif>
                                
                                <cfif isdefined("url.tab") and isdefined("form.tab") and url.tab EQ 6>
									<cfset form.tab = url.tab >
                                </cfif>
                                
                                <cfif not (isdefined("form.tab") and ListContains('1,2,3,4,5,6', form.tab))>
                                    <cfset form.tab = 1>
                                    <cfset url.Primera = 0>
									<cfset url.Segunda = 0>
                                </cfif> 
                                                            	
                                <cf_tabs width="99%">
                                    <cf_tab text="#LB_CalculoFondoAhorro#" selected="#form.tab eq 1#">
                                        <cf_web_portlet_start border="true" titulo="#LB_CalculoFondoAhorro#" >
                                            <cfinclude template="Paso1-FondoAhorro.cfm">
                                        <cf_web_portlet_end>
                                    </cf_tab>
                                    <cfif isdefined('modoE') and modoE EQ 'Cambio'>
                                    	<cf_tab text="#LB_InteresGenerado#" selected="#form.tab eq 2#">
                                    		<cf_web_portlet_start border="true" titulo="#LB_ImporteInteresGenerado#" >
                                        		<cfinclude template="Paso2-FondoAhorro.cfm">
                                        	<cf_web_portlet_end>
                                     	</cf_tab>
                                        
                                    <!---<cf_dump var = "#form#">--->
                                    <!--- <cf_dump var = "#url#">--->
                                     <cfquery name="rsEmpleados" datasource = "#session.DSN#">
                                     	select COUNT(1) as cantidad
										from RHCierreFOA a inner join RHDCierreFOA b
											on a.RHCFOAid = b.RHCFOAid
										where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											and a.RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHCFOAid#">
                                     </cfquery>
                                     
                                     <cfif isdefined('rsEmpleados') and rsEmpleados.cantidad GT 0>
                                        <cf_tab text="#LB_EmpleadosGenerados#" selected="#form.tab eq 3#">
                                            <cf_web_portlet_start border="true" titulo="#LB_EmpleadosGenerados#" >
                                                <cfinclude template="Paso3-FondoAhorro.cfm">
                                            <cf_web_portlet_end>
                                        </cf_tab>
                                      </cfif>
                                     
                                      <cfquery name="rsEstatus" datasource = "#session.DSN#">
                                     	select RHCFOAestatus
										from RHCierreFOA 
										where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											and RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHCFOAid#">
                                     </cfquery>
                                     
                                    <!--- <cf_dump var = #url#>--->
                                     
									 <cfif isdefined('rsEstatus') and rsEstatus.RHCFOAestatus EQ 1 and not isdefined('form.tab') EQ 5 and not isdefined("form.btnAplicar")>
                                      	<cf_tab text="#LB_Relacion_Calculo_Nomina#" selected="#form.tab eq 4#">
                                            <cf_web_portlet_start border="true" titulo="#LB_Relacion_Calculo_Nomina#">
                                                <cfinclude template="Paso4-FondoAhorro.cfm">
                                            <cf_web_portlet_end>
                                        </cf_tab>                                  
                                     </cfif>
                                     
                                     <cfif isdefined("form.btnAplicar")>
                                        <cf_tab text="#LB_Cierre_Calculo_Nomina#" selected="#form.tab eq 5#">
                                            <cf_web_portlet_start border="true" titulo="#LB_Cierre_Calculo_Nomina#" >
                                                <cfinclude template="Paso5-FondoAhorro.cfm">
                                            <cf_web_portlet_end>
                                        </cf_tab>
                                     </cfif>
                                    </cfif>
                                </cf_tabs>
                            </td> 
						</tr>
					</table>
				<cf_web_portlet_end>
<!---                </cfif>--->
			</td>	
		</tr>
	</table>	
<cf_templatefooter>	
<!---</form>
</cfoutput>--->