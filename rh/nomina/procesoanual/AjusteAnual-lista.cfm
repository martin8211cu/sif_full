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
	Key="LB_Codigo"
	Default="C&oacute;digo"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Codigo"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Periodo"
	Default="Periodo"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Periodo"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Mensaje_No_Hay_Calculos_De_Ajuste_Anual"
	Default="Mensaje no hay C&aacute;lculos de Ajuste Anual"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Mensaje_No_Hay_Calculos_De_Ajuste_Anual"/>
       
<cfquery name="rsRHAjusteAnuallista" datasource="#session.DSN#">
	select RHAAid,RHAAcodigo,RHAAdescrip,RHAAPeriodo, case when RHAAEstatus = 0 then 'Sin Aplicar' else 'Aplicado' end as Estado 
	from RHAjusteAnual
	where Ecodigo = #session.Ecodigo#
</cfquery>

<cfset LvarBotones = "Nuevo">
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top" nowrap="nowrap">
				<cf_web_portlet_start titulo="#LB_CalculoAnual#">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
	                    <tr valign="top">
                        	<td width="50%" nowrap="nowrap">
                            	<cfinvoke 
                                    component="rh.Componentes.pListas"
                                    method="pListaQuery"
                                    returnvariable="pListaRet">
                                        <cfinvokeargument name="query" value="#rsRHAjusteAnuallista#"/>
                                        <cfinvokeargument name="desplegar" value="RHAAcodigo, RHAAdescrip, RHAAPeriodo, Estado"/>
                                        <cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#, #LB_Periodo#,Estado"/>
                                        <cfinvokeargument name="formatos" value="S,S,I,U"/>
                                        <cfinvokeargument name="align" value="left,left,left,left"/>
                                        <cfinvokeargument name="ajustar" value="S,S,S,S"/>
                                        <cfinvokeargument name="checkboxes" value="N"/>				
                                        <!---<cfinvokeargument name="filtrar_por" value="RHAAid"/>
                                        <cfinvokeargument name="mostrar_filtro" value="true"/>--->
                                        <cfinvokeargument name="showEmptyListMsg" value="true"/>
                                        <cfinvokeargument name="keys" value="RHAAid"/>
                                        <cfinvokeargument name="ira" value="AjusteAnual-form.cfm"/>
                                        <cfinvokeargument name="Botones" value="#LvarBotones#"/>
                                        <cfinvokeargument name="emptylistmsg" value=" --- #LB_Mensaje_No_Hay_Calculos_De_Ajuste_Anual# ---"/>
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