
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Listado_General_de_Empleados"
	Default="Listado General de Empleados"
	returnvariable="LB_Listado_General_de_Empleados"/>

<cfset LvarFileName = "Lst_GeneralEmp_#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
<cfoutput>
<cfset activarRango = (isdefined("url.ActivarRango")? '&ActivarRango=on': '' )>
<cf_htmlReportsHeaders 
title="#LB_Listado_General_de_Empleados#" 
filename="#LvarFileName#"
param="&url.OrderBy=#url.OrderBy#&FechaHasta=#url.FechaHasta#&FechaDesde=#url.FechaDesde#&formato=#Url.formato##activarRango#"
irA="generalEmpleados.cfm" 
>
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
			<td bgcolor="##CCCCCC" class="RLTtopline" colspan="26" align="center">
				<font  style="font-size:13px; font-family:'Arial'">#Session.Enombre#</font>			</td>
		</tr>
		<tr>
			<td bgcolor="##CCCCCC" class="RLTtopline" colspan="26" align="center">
				<font  style="font-size:13px; font-family:'Arial'">#LB_Listado_General_de_Empleados#</font>			</td>
		</tr>
		<tr>
			<td  bgcolor="##CCCCCC" colspan="26" align="right" class="Completoline">
				<font  style="font-size:11px; font-family:'Arial'">
					<cf_translate  key="LB_Usuario">Usuario:</cf_translate>&nbsp;#Session.Usulogin#
					<cf_translate  key="LB_Fecha">Fecha:</cf_translate>&nbsp;#LSDateFormat(Now(), "dd/mm/yyyy")#				</font>			</td>
		</tr>
		<tr>
			<td  colspan="26" align="center">
				<font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;			</td>
			</tr>		
		<tr>
			<td  nowrap bgcolor="##CCCCCC" class="LTtopline" align="center" colspan="2"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate></font></td>
			<td  nowrap bgcolor="##CCCCCC" class="LTtopline" align="center" colspan="2"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_CentroFuncionalContable">Centro Funcional Contable</cf_translate></font></td>
			<td  nowrap bgcolor="##CCCCCC" class="LTtopline" align="center" colspan="2"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Puesto">Puesto</cf_translate></font></td>
			<td  nowrap bgcolor="##CCCCCC" class="LTtopline" align="center" colspan="2"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Departamento">Departamento</cf_translate></font></td>
			<td  nowrap bgcolor="##CCCCCC" class="LTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Fecha_de_ingreso">Fecha de ingreso</cf_translate></font></td>
			<td  nowrap bgcolor="##CCCCCC" class="LTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Cedula">C&eacute;dula</cf_translate></font></td>
			<td  nowrap bgcolor="##CCCCCC" class="LTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Nombre">Nombre</cf_translate></font></td>
			<td  nowrap bgcolor="##CCCCCC" class="LTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_FechaNacimiento">Fecha Nacimiento</cf_translate></font></td>
			<td  nowrap bgcolor="##CCCCCC" class="LTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Sexo">Sexo</cf_translate></font></td>
			<td  nowrap bgcolor="##CCCCCC" class="LTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_EstadoCivil">Estado Civil</cf_translate></font></td>
			
			<td  nowrap bgcolor="##CCCCCC" class="RLTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Banco">Banco</cf_translate></font></td>
			<td  nowrap bgcolor="##CCCCCC" class="RLTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Cuenta">Cuenta</cf_translate></font></td>
			<td  nowrap bgcolor="##CCCCCC" class="RLTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_TipoCuenta">Tipo Cuenta</cf_translate></font></td>
			<td  nowrap bgcolor="##CCCCCC" class="RLTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_CuentaCliente">Cuenta Cliente</cf_translate></font></td>						
			
			<td  nowrap bgcolor="##CCCCCC" class="LTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Forma_De_Pago">Forma de Pago</cf_translate></font></td>
			<td  nowrap bgcolor="##CCCCCC" class="LTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Frecuencia_De_Pago">Frecuencia de Pago</cf_translate></font></td>
			<td  nowrap bgcolor="##CCCCCC" class="LTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Salario">Salario</cf_translate></font></td>
			<td  nowrap bgcolor="##CCCCCC" class="LTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Direccion">Direcci&oacute;n</cf_translate></font></td>
			<td  nowrap bgcolor="##CCCCCC" class="LTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_CP">C&oacute;digo Postal</cf_translate></font></td>
			<td  nowrap bgcolor="##CCCCCC" class="RLTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Telefono">Tel<font  style="font-size:11px; font-family:'Arial'">&eacute;</font>fono</cf_translate>
			<td  nowrap bgcolor="##CCCCCC" class="RLTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Correo">Correo</cf_translate>
			</font></td>
			<td  nowrap bgcolor="##CCCCCC" class="RLTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_TipoContrato">Tipo de Contrato</cf_translate></font></td>
			
			
		</tr>
		<cfloop query="rsReporte">
		<tr>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.CFcodigo)#</font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.CFdescripcion)#</font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.CFcodigoconta)#</font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.CFdescripcionconta)#</font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.RHPcodigo)#</font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.RHPdescpuesto)#</font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.Deptocodigo)#</font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.Ddescripcion)#</font></td>
			<td  nowrap  class="LTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'">#LSDateFormat(rsReporte.Antiguedad,"dd/mm/yyyy")#</font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.DEidentificacion)#</font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.DEnombre)#</font></td>
			<td  nowrap  class="LTtopline" align="center"><font  style="font-size:11px; font-family:'Arial'">#LSDateFormat(rsReporte.DEfechanac,"dd/mm/yyyy")#</font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.DEsexo)#</font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.DEcivil)#</font></td>
			
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'"><cfif len(trim(rsReporte.Banco))>#trim(rsReporte.Banco)#<cfelse>&nbsp;</cfif></font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'"><cfif len(trim(rsReporte.Cuenta))>#trim(rsReporte.Cuenta)#<cfelse>&nbsp;</cfif></font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'"><cfif len(trim(rsReporte.TipoCuenta))>#trim(rsReporte.TipoCuenta)#<cfelse>&nbsp;</cfif></font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'"><cfif len(trim(rsReporte.cuentaCliente))>#trim(rsReporte.cuentaCliente)#<cfelse>&nbsp;</cfif></font></td>
			
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.FormaDePago)#</font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.FrecuenciaDePago)#</font></td>
			<td  nowrap  class="LTtopline" align="right"><font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsReporte.Salario,',.00')#</font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'"><cfif len(trim(rsReporte.DEdireccion))>#trim(rsReporte.DEdireccion)#<cfelse>&nbsp;</cfif></font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'"><cfif len(trim(rsReporte.DEcodPostal))>#trim(rsReporte.DEcodPostal)#<cfelse>&nbsp;</cfif></font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'"><cfif len(trim(rsReporte.DEtelefono))>#trim(rsReporte.DEtelefono)#<cfelse>&nbsp;</cfif></font></td>
			<td  nowrap  class="LTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'"><cfif len(trim(rsReporte.Correo))>#trim(rsReporte.Correo)#<cfelse>&nbsp;</cfif></font></td>
				
			<td  nowrap  class="RLTtopline" align="left"><font  style="font-size:11px; font-family:'Arial'"><cfif len(trim(rsReporte.tipoContrato))>#trim(rsReporte.tipoContrato)#<cfelse>&nbsp;</cfif></font></td>
			
			
		</tr>		
		</cfloop>
		<tr>
			<td  bgcolor="##CCCCCC" colspan="25" align="right" class="Completoline">&nbsp;			</td>
		</tr>
	</table>
	
	
</cfoutput>

