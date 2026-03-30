<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EmpleadosGenerados"
	Default="Empleados Generados"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_EmpleadosGenerados"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DetalleFOA"
	Default="Detalle de Fondo de Ahorro"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_DetalleFOA"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaDesde" Default="Fecha Desde" returnvariable="LB_FechaDesde"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaHasta" Default="Fecha Hasta" returnvariable="LB_FechaHasta"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion" Default="Identificacion" returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre" Default="Nombre" returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaInicio" Default="Fecha Inicio" returnvariable="LB_FechaInicio"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaFin" Default="Fecha Fin" returnvariable="LB_FechaFin"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FOAEmpresa" Default="Fondo de Ahorro Empresa" returnvariable="LB_FOAEmpresa"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FOAEmpleado" Default="Fondo de Ahorro Empleado" returnvariable="LB_FOAEmpleado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Interes" Default="Inter&eacute;s" returnvariable="LB_Interes"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoInteres" Default="Monto de Inter&eacute;s" returnvariable="LB_MontoInteres"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_No_registros_de_Fondo_Ahorro" Default="No registros de Fondo Ahorro" returnvariable="MSG_No_registros_de_Fondo_Ahorro"/>


<cfif isdefined('url.RHCFOAid') and len(trim(url.RHCFOAid)) GT 0>
	<cfset RHCFOAid = #url.RHCFOAid#>
<cfelseif isdefined('form.RHCFOAid') and len(trim(form.RHCFOAid)) GT 0>
	<cfset RHCFOAid = #form.RHCFOAid#>
</cfif>

<cfquery name="rsFOA" datasource="#session.DSN#">
	select a.RHCFOAid, a.RHCFOAcodigo, a.RHCFOAfechaInicio,a.RHCFOAfechaFinal, a.RHCFOAdesc, a.RHCFOAestatus
	from RHCierreFOA a inner join RHDCierreFOA b
		on a.RHCFOAid = b.RHCFOAid
        inner join DatosEmpleado c on c.DEid = b.DEid and c.Ecodigo = a.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHCFOAid#">
</cfquery>

<cfquery name="rsEmpleadoFOA" datasource="#session.DSN#">
	select a.RHCFOAid,c.DEidentificacion, 	
			{fn concat(c.DEapellido1,{fn concat(' ',{fn concat(c.DEapellido2,{fn concat(',',{fn concat(' ',c.DEnombre)})})})})} as Nombre_Empleado,
            b.*
	from RHCierreFOA a inner join RHDCierreFOA b
		on a.RHCFOAid = b.RHCFOAid
        inner join DatosEmpleado c on c.DEid = b.DEid and c.Ecodigo = a.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHCFOAid#">
</cfquery>

<!---<cf_dump var = "#rsFOA#">--->

<cfoutput>
<form name= "form3" method="post" style="margin: 0;" action="FondoAhorro-sql.cfm">
<input type="hidden" name="RHCFOAid" value="#RHCFOAid#">
<table width="100%">
	<tr>
		<td align="center">
        	<table width="90%">
            	<tr height="20px">
                    <td colspan="3" align="center"> 
                    </td>
                </tr>
                <tr>
                	<td width="25%" align="right"> 
                     	#LB_DetalleFOA#:
                    </td>
                    <td width="25%" align="left"> 
						#rsFOA.RHCFOAcodigo# - #rsFOA.RHCFOAdesc# 
                    </td>
                    <td width="50%" align="left"> 
                    	
                    </td>
                </tr>
                <tr>
                	<td width="25%" align="right"> 
                    	#LB_FechaDesde#:
                    </td>
                    <td width="25%" align="left"> 
						#LSDateFormat(rsFOA.RHCFOAfechaInicio,'dd-MM-yyyy')#
                    </td>
                    <td width="50%" align="left"> 

                    </td>
                </tr>
                <tr>
                	<td width="25%" align="right"> 
                    	#LB_FechaHasta#:
                    </td>
                    <td width="25%" align="left"> 
						#LSDateFormat(rsFOA.RHCFOAfechaFinal,'dd-MM-yyyy')#
                    </td>
                    <td width="50%" align="left"> 

                    </td>
                </tr>
                
                <tr>
                	<td colspan= "3">
                		<fieldset style="background-color:##CCCCCC; border: 1px solid ##AAAAAA; height: 15;">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20" align="center">
								<tr>
									<td class="fileLabel">&nbsp;Lista de Empleados</td>
								</tr>
							</table>
						</fieldset>
                	</td>
                </tr>
                <tr height="20px">
                	<td colspan= "3">
                    <cfset formatos="S,S,M,M,M,M">
                	<cfset align="left,left,center,center,center,center">
                	<cfset ajustar="S,S,S,S,S,S"> 
                    <cfinvoke 
					component="rh.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rsEmpleadoFOA#"/>
						<cfinvokeargument name="desplegar" value="DEidentificacion,Nombre_Empleado,RHDCFOAempresa, RHDCFOAempleado,RHDCFOAinteres,RHDCFOAmonto"/>
						<cfinvokeargument name="etiquetas" value="#LB_Identificacion#,#LB_Nombre#,#LB_FOAEmpresa#,#LB_FOAEmpleado#,#LB_Interes#,#LB_MontoInteres#"/>
						<cfinvokeargument name="formatos" value="#formatos#"/>
						<cfinvokeargument name="align" value="#align#"/>
                        <cfinvokeargument name="ajustar" value="#ajustar#"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="emptylistmsg" value=" --- #MSG_No_registros_de_Fondo_Ahorro# ---"/>
                        <cfinvokeargument name="PageIndex" value="0"/>
						<!---<cfinvokeargument name="keys" value="RHCFOAid"/>--->
						<!---<cfinvokeargument name="ira" value="PTU.cfm"/>--->
						<cfinvokeargument name="maxrows" value="10"/>                      						
					</cfinvoke>            	
                    </td>
                </tr>
                <tr>
                	<td colspan= "3" align="center">
                    	<input name="btnVerReporte" type="submit" value="Ver Reporte"> 
                        <cfif isdefined('rsFOA') and rsFOA.RHCFOAestatus EQ 0>       
                    		<input name="btnCerrarFondo" type="submit" value="Cerrar Fondo de Ahorro" onclick="return funcCerrar()";>   
                        </cfif>                  	
                    </td>
                </tr>
            </table>
		</td>
	</tr>
</table>
</form>
</cfoutput>


<script language="javascript" type="text/javascript">

	function funcCerrar(){
		if (confirm('¿Desea cerrar el c\u00e1lculo de Fondo de Ahorro para la Relaci\u00f3n de C\u00e1lculo?')){
			return true;
			}else{
			return false;
			}
		}
</script>