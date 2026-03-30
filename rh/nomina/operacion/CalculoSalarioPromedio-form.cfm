<cfoutput>
<form name="form1" action="" method="post">
	<table  width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td class="fileLabel"><strong><cf_translate key="LB_Fecha">Fecha</cf_translate>:</strong></td>
			<td>
				<cfset fecha = LSDateFormat(Now(), 'dd/mm/yyyy')>
				<cf_sifcalendario form="form1" value="#fecha#" name="fecha" tabindex="1"></td>
		</tr>
		<tr>
			<td class="fileLabel"><strong><cf_translate key="LB_Empleado">Empleado</cf_translate>:
			  
			</strong></td>
			<td>
				<cf_rhempleado size="80" tabindex="1">			</td>
		</tr>
		<tr>
		  <td colspan="2" align="center">
			<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="BTN_Generar"
					default="Generar"
					xmlfile="/rh/generales.xml"
					returnvariable="BTN_Generar"/><input name="generar" type="button" tabindex="1" value="#BTN_Generar#" onclick="javascript:consultar();" /></td>
		</tr>
		<tr>
		  <td colspan="2" align="center">
		  	<iframe id="IF_Reportes" name="IF_Reportes" marginheight="0" marginwidth="0" frameborder="0" height="500" width="100%" 
			src="">
			</iframe>
		  </td>
		</tr>  
	</table>
</form>
</cfoutput>
<!--- Variables para Traduccion--->

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empleado"
	Default="Empleado es requerido"
	returnvariable="LB_Empleado"/> 
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha"
	Default="Fecha  es requerida"
	returnvariable="LB_Fecha"/> 	

<script language="JavaScript">

	function valida(){
		if (document.form1.DEid.value == "") { alert("<cfoutput>#LB_Empleado#</cfoutput>"); return false}
		if (document.form1.fecha.value == "") { alert("<cfoutput>#LB_Fecha#</cfoutput>");  return false}
		return true
	}
	function  consultar(){
		if(valida()){
			var  params = "?DEid="+document.form1.DEid.value+"&fecha="+document.form1.fecha.value;
			var frame  = document.getElementById("IF_Reportes");
			frame.src 	= "CalculoSalarioPromedio-sql.cfm"+params;
		}
	}	
	function filtrar(){
		document.form1.action = '';
		document.form1.botonSel.value = 'btnFiltrar';
		objForm.fecha.required = false;
		objForm.DEidentificacion.required = false;
	}
	
	function limpiar(){
		document.form1.DEid.value   	       	= '';
		document.form1.DEidentificacion.value  	= '';
		document.form1.fecha.value 	   		= ''; 
	}
</script>