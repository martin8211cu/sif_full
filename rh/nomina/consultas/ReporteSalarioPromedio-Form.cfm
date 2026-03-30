<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_HTML" Default="HTML" returnvariable="CMB_HTML"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/generales.xml" Key="BTN_Consultar" Default="Consultar" returnvariable="BTN_Consultar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/generales.xml" Key="BTN_Limpiar" Default="Filtrar" returnvariable="BTN_Limpiar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/generales.xml" Key="LB_Empleado" Default="Empleado" returnvariable="LB_Empleado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/generales.xml" Key="LB_Concepto" Default="Concepto" returnvariable="LB_Concepto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/generales.xml" Key="LB_Fecha" Default="Fecha" returnvariable="LB_Fecha"/>

<form  name="form1" id="form1" method="post" action="ReporteSalarioPromedio-SQL.cfm">
<table width="75%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><strong><cfoutput>#LB_Empleado#</cfoutput>:</strong>&nbsp;<cf_rhempleado></td>
    <td><strong><cfoutput>#LB_Fecha#</cfoutput>:</strong>&nbsp;<cf_sifcalendario></td>
  </tr>
  <tr><td><strong><cfoutput>#LB_Concepto#</cfoutput>:</strong>&nbsp;<cf_rhcincidentes IncluirTipo="3"></td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  	<td colspan="2">
		<div align="center"> 
			<cfoutput>
        	<input type="submit"  class="btnNormal" name="Submit"  value="#BTN_Consultar#">&nbsp;
			<input type="button" class="btnLimpiar" name="Limpiar" value="#BTN_Limpiar#"  onClick="javascript: limpiar();">
			</cfoutput>
        </div>
	</td>
  </tr>
</table>
<input type="hidden" name="fromForm" value="1" />
</form> 
<cf_qforms>
<script language="javascript" type="text/javascript">
objForm = new qForm("form1");
objForm.onSubmit="ReporteSalarioPromedio-SQL.cfm";
objForm.DEid.description = "Empleado";	
objForm.fecha.description = "Fecha";	
objForm.CIid.description = "Concepto";	
objForm.DEid.required = true;	
objForm.fecha.required = true;	
objForm.CIid.required = true;	
</script>