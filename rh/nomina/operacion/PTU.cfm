<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
    Key="LB_CalculoPTU"
	Default="Cálculo del PTU"
    XmlFile="/rh/generales.xml"
	returnvariable="LB_CalculoPTU"/>
<cfinvoke Key="LB_CODIGO" 
	Default="Código" 
    XmlFile="/rh/generales.xml" 
    returnvariable="LB_CODIGO" 
    component="sif.Componentes.Translate" 
    method="Translate"/>			
<cfinvoke Key="LB_DESCRIPCION" 
	Default="Descripción" 
    XmlFile="/rh/generales.xml" 
    returnvariable="LB_DESCRIPCION" 
    component="sif.Componentes.Translate" 
    method="Translate"/>	        
<cfinvoke Key="LB_FechaDesde" 
	Default="Fecha Desde" 
    XmlFile="/rh/generales.xml" 
    returnvariable="LB_FechaDesde" 
    component="sif.Componentes.Translate" 
    method="Translate"/>		
<cfinvoke Key="LB_FechaHasta" 
	Default="Fecha Hasta" 
    XmlFile="/rh/generales.xml" 
    returnvariable="LB_FechaHasta" 
    component="sif.Componentes.Translate" 
    method="Translate"/>
 
 <cfinvoke Key="LB_txtCantDias" 
	Default="Cantidad de Dias" 
    XmlFile="/rh/generales.xml" 
    returnvariable="LB_txtCantDias" 
    component="sif.Componentes.Translate" 
    method="Translate"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_No_registros_de_Calculo_del_PTU"
	Default="No hay registros de Calculo del PTU"
	returnvariable="MSG_No_registros_de_Calculo_del_PTU"/>

<cfif isdefined("form.RHPTUEid") and len(trim(form.RHPTUEid)) EQ 0 and isdefined("form.RHPTUEid_3") and len(trim(form.RHPTUEid_3))>
	<cfset form.RHPTUEid = #form.RHPTUEid_3#>
</cfif>

<cfif isdefined("form.RHPTUEid") and len(trim(form.RHPTUEid)) EQ 0 and isdefined("form.RHPTUEid_4") and len(trim(form.RHPTUEid_4))>
	<cfset form.RHPTUEid = #form.RHPTUEid_4#>
</cfif>

<!---<cf_dump var = "#form.RHPTUEid#">--->

<cfif not isdefined("form.RHPTUEid") and isdefined("url.RHPTUEid") and len(trim(url.RHPTUEid))>
	<cfset form.RHPTUEid = url.RHPTUEid>
</cfif>

<cfset modoE = "ALTA">
<cfif isdefined("form.RHPTUEid") and len(trim(form.RHPTUEid))>
	<cfset modoE = "Cambio">
</cfif>

<!---<cf_dump var = "#tab#">--->
<cfif modoE eq 'Cambio'>
    <cfquery name="rsRHPTUEestado" datasource="#session.DSN#">
        select 
            RHPTUEEstado
        from RHPTUE a
        where a.RHPTUEid = #form.RHPTUEid#
        and a.Ecodigo = #session.Ecodigo#
    </cfquery>
</cfif>

<!---<cf_dump var = "#form#">--->
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top" nowrap="nowrap">
				<cf_web_portlet_start titulo="#LB_CalculoPTU#">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
	                    <tr valign="top">
							<td align="center" width="100%" nowrap="nowrap" height="450" valign="top">
	                            <cfif isdefined("url.tab") and not isdefined("form.tab")>
									<cfset form.tab = url.tab >
                                </cfif>
                                <cfif not ( isdefined("form.tab") and ListContains('1,2,3,4,5', form.tab) )>
                                    <cfset form.tab = 1 >
                                </cfif> 
                                <!---<cf_dump var = "#form#">--->
                                <cf_tabs width="99%">
                                    <cf_tab text="Cálculo del PTU" selected="#form.tab eq 1#">
                                        <cf_web_portlet_start border="true" titulo="Cálculo del PTU" >
                                            <cfinclude template="PTUE-Tab1.cfm">
                                        <cf_web_portlet_end>
                                    </cf_tab>
                                    <cfif modoE eq "CAMBIO" and rsRHPTUEestado.RHPTUEEstado eq 0>
                                        
                                        <cfquery name="rsVerificaEmpleados" datasource="#session.DSN#">
                                            select count(1) as cantidad
                                            from RHPTUEMpleados
                                            where RHPTUEid = #form.RHPTUEid#
                                        </cfquery>
                                        <cf_tab text="Generación de Empleados para el cálculo" selected="#form.tab eq 2#">
                                            <cf_web_portlet_start border="true" titulo="Generación de Empleados para el cálculo" >
                                                <cfinclude template="PTUD-Tab2.cfm">
                                            <cf_web_portlet_end>
                                        </cf_tab>
                                        <cfif isdefined ("rsVerificaEmpleados") and rsVerificaEmpleados.cantidad gt 0>
                                            <cf_tab text="Empleados Generados" selected="#form.tab eq 3#">
                                                <cf_web_portlet_start border="true" titulo="Empleados Generados" >
                                                    <cfinclude template="PTUDemp-Tab3.cfm">
                                                <cf_web_portlet_end>
                                            </cf_tab>
                                        </cfif>
                                        
                                         <cfquery name="rsVerificaEmpleados2" datasource="#session.DSN#">
                                            select count(1) as cantidad
                                            from RHPTUEMpleados
                                            where RHPTUEid = #form.RHPTUEid#
                                            and RHPTUEMNetaRecibir is not null
                                        </cfquery>
                                        <cfif isdefined ("rsVerificaEmpleados2") and rsVerificaEmpleados2.cantidad GT 0>
                                            <cf_tab text="Reconocer Empleados Generados" selected="#form.tab eq 4#">
                                                <cf_web_portlet_start border="true" titulo="Reconocer Empleados Generados" >
                                                    <cfinclude template="PTUDemp-Tab4.cfm">
                                                <cf_web_portlet_end>
                                            </cf_tab>
                                        </cfif>
                                    <cfelseif modoE eq "CAMBIO" and rsRHPTUEestado.RHPTUEEstado eq 1>
                                    	<!---<cf_dump var = "#form#">--->
	                                    <!--- Si el PTU está cerrado quiere decir que ya se verificó antes que todos los datos estan calculados --->
                                    	<cf_tab text="Reconocer Empleados Generados" selected="#form.tab eq 4#">
                                            <cf_web_portlet_start border="true" titulo="Reconocer Empleados Generados" >
                                                <cfinclude template="PTUDemp-Tab4.cfm">
                                            <cf_web_portlet_end>
                                        </cf_tab>
                                        <cf_tab text="Relación de Cálculo de Nómina PTU" selected="#form.tab eq 5#">
                                            <cf_web_portlet_start border="true" titulo="Relación de Cálculo de Nómina PTU" >
                                                <cfinclude template="PTUDRel-Tab5.cfm">
                                            <cf_web_portlet_end>
                                        </cf_tab>
                                    </cfif>
                                </cf_tabs>
                            </td> 
						</tr>
					</table>
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>	
