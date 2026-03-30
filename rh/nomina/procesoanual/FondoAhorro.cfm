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
	Key="LB_Codigo"
	Default="C&oacute;digo"
	returnvariable="LB_Codigo"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	returnvariable="LB_Descripcion"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaInicio"
	Default="Fecha Inicio"
	returnvariable="LB_FechaInicio"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaFinal"
	Default="Fecha Final"
	returnvariable="LB_FechaFinal"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Estatus"
	Default="Estatus"
	returnvariable="LB_Estatus"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Mensaje_No_Hay_Calculos_De_Fondo_Ahorro"
	Default="No Hay Calculos De Fondo Ahorro"
	returnvariable="LB_Mensaje_No_Hay_Calculos_De_Fondo_Ahorro"/>
    
<cfquery name="rsFOAlista" datasource="#session.DSN#">
	select RHCFOAid, RHCFOAcodigo,RHCFOAdesc,RHCFOAfechaInicio,RHCFOAfechaFinal, 
    case  when RHCFOAEstatus = 0 then 'En Proceso'
    	  when RHCFOAEstatus = 1 then 'Calculo Cerrado'
    	  else 'Pagado'
    end as Estatus
	from RHCierreFOA
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfset LvarBotones = "Nuevo">
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top" nowrap="nowrap">
				<cf_web_portlet_start titulo="#LB_CalculoFondoAhorro#">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
	                    <tr valign="top">
                        	<td width="50%" nowrap="nowrap">
                            	<cfinvoke 
                                    component="rh.Componentes.pListas"
                                    method="pListaQuery"
                                    returnvariable="pListaRet">
                                        <cfinvokeargument name="query" value="#rsFOAlista#"/>
                                        <cfinvokeargument name="desplegar" value="RHCFOAcodigo,RHCFOAdesc,RHCFOAfechaInicio,RHCFOAfechaFinal, Estatus"/>
                                        <cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#, #LB_FechaInicio#,#LB_FechaFinal#,#LB_Estatus#"/>
                                        <cfinvokeargument name="formatos" value="S,S,D,D,U"/>
                                        <cfinvokeargument name="align" value="left,left,left,left,left"/>
                                        <cfinvokeargument name="ajustar" value="S,S,S,S,S"/>
                                        <cfinvokeargument name="checkboxes" value="N"/>				
                                        <!---<cfinvokeargument name="filtrar_por" value="RHAAid"/>--->
                                        <cfinvokeargument name="mostrar_filtro" value="true"/>
                                        <cfinvokeargument name="showEmptyListMsg" value="true"/>
                                        <cfinvokeargument name="keys" value="RHCFOAid"/>
                                        <cfinvokeargument name="ira" value="FondoAhorro-form.cfm"/>
                                        <cfinvokeargument name="Botones" value="#LvarBotones#"/>
                                        <cfinvokeargument name="emptylistmsg" value=" --- #LB_Mensaje_No_Hay_Calculos_De_Fondo_Ahorro# ---"/>
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