<!--- NOTA: El reporte no incluye los datos variables de los familiares --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Listado_DVariables_de_Empleados"
	Default="Listado Datos Variables de Empleados"
	returnvariable="LB_Listado_DVariables_de_Empleados"/>

<cfset LvarFileName = "Lst_GeneralEmp_#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
<cfoutput>

<cf_htmlReportsHeaders 
title="#LB_Listado_DVariables_de_Empleados#" 
filename="#LvarFileName#"
param="&url.OrderBy=#url.OrderBy#&FechaHasta=#url.FechaHasta#&formato=#Url.formato#"
irA="generalEmpleados-datosVariables.cfm">

</cfoutput>
<style type="text/css">
	.RLTtopline {
		border-bottom-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	
	.LTtopline {
		border-bottom-width: none;
		border-bottom-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	.LRTtopline {
		border-bottom-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}
	
	.RTtopline {
		border-bottom-width: none;
		border-bottom-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	
	.Completoline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	
	.topline {
			border-top-width: 1px;
			border-top-style: solid;
			border-top-color: #000000;
			border-right-style: none;
			border-bottom-style: none;
			border-left-style: none;
		}
	
	.bottonline {
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-bottom-color: #000000;
			border-right-style: none;
			border-top-style: none;
			border-left-style: none;
		}
		
	.RLTbottomline {
		border-top-width: none;
		border-left-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000			
	}	
	
	.RLTbottomline2 {
		border-top-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000			
	}
	
	.RLline {
		border-top-width: none;
		border-bottom-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
	}
	
	.LTbottomline {
		border-top-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000			
	}		
		
</style>

<cfoutput>
	<table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td bgcolor="##CCCCCC" class="RLTtopline" colspan="19" align="center">
				<font  style="font-size:13px; font-family:'Arial'">#Session.Enombre#</font>			</td>
		</tr>
		<tr>
			<td bgcolor="##CCCCCC" class="RLTtopline" colspan="19" align="center">
				<font  style="font-size:13px; font-family:'Arial'">#LB_Listado_DVariables_de_Empleados#</font>			</td>
		</tr>
		<tr>
			<td  bgcolor="##CCCCCC" colspan="19" align="right" class="Completoline">
				<font  style="font-size:11px; font-family:'Arial'">
					<cf_translate  key="LB_Usuario">Usuario:</cf_translate>&nbsp;#Session.Usulogin#
					<cf_translate  key="LB_Fecha">Fecha:</cf_translate>&nbsp;#LSDateFormat(Now(), "dd/mm/yyyy")#				</font>			</td>
		</tr>
		<tr>
			<td  colspan="19" align="center">
				<font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;			</td>
			</tr>		
		<tr>
			<td  nowrap bgcolor="##CCCCCC" class="LTtopline" align="center" colspan="2"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate></font></td>
			<td  nowrap bgcolor="##CCCCCC" class="LTtopline" align="center" colspan="2"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Puesto">Puesto</cf_translate></font></td>
			<td  nowrap bgcolor="##CCCCCC" class="LTtopline" align="center" colspan="2"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Departamento">Departamento</cf_translate></font></td>
			<td  nowrap bgcolor="##CCCCCC" class="LTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Fecha_de_ingreso">Fecha de ingreso</cf_translate></font></td>
			<td  nowrap bgcolor="##CCCCCC" class="LTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Cedula">C&eacute;dula</cf_translate></font></td>
			<td  nowrap bgcolor="##CCCCCC" class="LTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Nombre">Nombre</cf_translate></font></td>
			<td  nowrap bgcolor="##CCCCCC" class="RLTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Celular">Celular</cf_translate>
			<td  nowrap bgcolor="##CCCCCC" class="LTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Sexo">Sexo</cf_translate></font></td>
			<cfloop query="rsDatosVariablesEtiquetas">
				<td  nowrap bgcolor="##CCCCCC" class="LTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_FechaNacimiento">#rsDatosVariablesEtiquetas.RHEtiqueta#</cf_translate></font></td>
			</cfloop>
								
		</tr>
		
		<cfloop query="rsReporte">
		<tr>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.CFcodigo)#</font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.CFdescripcion)#</font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.RHPcodigo)#</font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.RHPdescpuesto)#</font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.Deptocodigo)#</font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.Ddescripcion)#</font></td>
			<td  nowrap  class="LTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'">#LSDateFormat(rsReporte.Antiguedad,"dd/mm/yyyy")#</font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.DEidentificacion)#</font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.DEnombre)#</font></td>
			<td  nowrap  class="RLTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'"><cfif len(trim(rsReporte.DEcelular))>#trim(rsReporte.DEcelular)#<cfelse>&nbsp;</cfif></font></td>
			<td  nowrap  class="LTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.DEsexo)#</font></td>
			
			
			<cfquery dbtype="query" name="rsDatosEmpleado">
				select * from rsReporte where DEid = #rsReporte.DEid#
			</cfquery>
			
			<cfloop query="rsDatosVariablesEtiquetas">
				<cfset etiqueta = rsDatosVariablesEtiquetas.RHEcol>
				<cfif isdefined("rsDatosEmpleado.#etiqueta#")>	
					<cfset valorVariable = Evaluate("rsDatosEmpleado.#etiqueta#")>
				<cfelse>
					<cfset valorVariable = ''>
				</cfif>
				<td  nowrap  class="LTtopline" align="center">
                	<cfif len(trim(valorVariable))>
					<font  style="font-size:11px; font-family:'Arial'">
					<cfoutput>#valorVariable#</cfoutput>
					</font>
                    <cfelse>&nbsp;
                    </cfif>
				</td>
			</cfloop>
			
		</tr>		
		</cfloop>
		<tr>
			<td  bgcolor="##CCCCCC" colspan="20" align="right" class="Completoline">&nbsp;			</td>
		</tr>
	</table>
	
	
</cfoutput>

