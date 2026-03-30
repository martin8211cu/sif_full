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

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_No_registros_de_Calculo_del_PTU"
	Default="No hay registros de Calculo del PTU"
	returnvariable="MSG_No_registros_de_Calculo_del_PTU"/>

<cfif not isdefined("form.RHPTUEid") and isdefined("url.RHPTUEid") and len(trim(url.RHPTUEid))>
	<cfset form.RHPTUEid = url.RHPTUEid>
</cfif>

<cfset modoE = "ALTA">



<cfquery name="rsRHPTUElista" datasource="#session.DSN#">
	select 
		a.RHPTUEid,
    	a.RHPTUEcodigo,
	    a.RHPTUEdescripcion,
    	a.FechaDesde,
	    a.FechaHasta,
    	a.Ecodigo,
        case when a.RHPTUEPagado = 0 then 'Sin Pagar' else 'Pagado' end as Estado
    from RHPTUE a
    where a.Ecodigo = #session.Ecodigo#
    order by a.RHPTUEid desc
</cfquery>


<cfset LvarBotones = "Nuevo">
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top" nowrap="nowrap">
				<cf_web_portlet_start titulo="#LB_CalculoPTU#">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
	                    <tr valign="top">
                        	<td width="50%" nowrap="nowrap">
                            	<cfinvoke 
                                    component="rh.Componentes.pListas"
                                    method="pListaQuery"
                                    returnvariable="pListaRet">
                                        <cfinvokeargument name="query" value="#rsRHPTUElista#"/>
                                        <cfinvokeargument name="desplegar" value="RHPTUEcodigo, RHPTUEdescripcion, FechaDesde, FechaHasta, Estado"/>
                                        <cfinvokeargument name="etiquetas" value="#LB_CODIGO#, #LB_DESCRIPCION#, #LB_FechaDesde#, #LB_FechaHasta#, Estado"/>
                                        <cfinvokeargument name="formatos" value="S,S,D,D,U"/>
                                        <cfinvokeargument name="align" value="left,left,left,left,left"/>
                                        <cfinvokeargument name="ajustar" value="S,S,S,S,S"/>
                                        <cfinvokeargument name="checkboxes" value="N"/>				
                                        <cfinvokeargument name="filtrar_por" value="RHPTUEcodigo,RHPTUEdescripcion"/>
                                        <cfinvokeargument name="mostrar_filtro" value="true"/>
                                        <cfinvokeargument name="showEmptyListMsg" value="true"/>
                                        <cfinvokeargument name="keys" value="RHPTUEid"/>
                                        <cfinvokeargument name="ira" value="PTU.cfm"/>
                                        <cfinvokeargument name="Botones" value="#LvarBotones#"/>
                                        <cfinvokeargument name="emptylistmsg" value=" --- #MSG_No_registros_de_Calculo_del_PTU# ---"/>
                                        <cfinvokeargument name="maxrows" value="0"/>
                                        <cfinvokeargument name="PageIndex" value="L"/>
                                </cfinvoke>
                            </td>
                        </tr>
					</table>
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>	
