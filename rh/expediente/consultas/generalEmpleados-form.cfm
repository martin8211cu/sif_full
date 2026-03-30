<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha_de_Corte" Default="Fecha de Corte" returnvariable="LB_Fecha_de_Corte"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha_Desde" Default="Fecha Desde" returnvariable="LB_Fecha_Desde"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha_Hasta" Default="Fecha Hasta" returnvariable="LB_Fecha_Hasta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Ordenar_por" Default="Ordenar por" returnvariable="LB_Ordenar_por"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_CFuncional" Default="Centro Funcional" returnvariable="CMB_CFuncional"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_CFuncionalConta" Default="Centro Funcional Contable" returnvariable="CMB_CFuncionalConta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Puesto" Default="Puesto" returnvariable="CMB_Puesto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Ceedula" Default="C&eacute;dula" returnvariable="CMB_Ceedula"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Nombre" Default="Nombre" returnvariable="CMB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_FechaNac" Default="Fecha de Nacimiento" returnvariable="CMB_FechaNac"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Sexo" Default="Sexo" returnvariable="CMB_Sexo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_EstadoCivil" Default="Estado Civil" returnvariable="CMB_EstadoCivil"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_FormaDePago" Default="Forma De Pago" returnvariable="CMB_FormaDePago"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_FrecuenciaDePago" Default="Frecuencia De Pago" returnvariable="CMB_FrecuenciaDePago"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Salario" Default="Salario" returnvariable="CMB_Salario"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Direccioon" Default="Direcci&oacute;n" returnvariable="CMB_Direccioon"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Teleefono" Default="Tel&eacute;fono" returnvariable="CMB_Teleefono"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Formato" Default="Formato" returnvariable="LB_Formato"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Flashpaper" Default="Flashpaper" returnvariable="CMB_Flashpaper"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_PDF" Default="PDF" returnvariable="CMB_PDF"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_HTML" Default="HTML" returnvariable="CMB_HTML"/>
<cfoutput>
<body onLoad="Evaluar()">
<form action="generalEmpleados-sql.cfm" method="get" name="form1" style="margin:0">
	<table width="100%" border="0" cellspacing="1" cellpadding="1" style="margin:0">
	  <tr id="fDesde">
		<td align="right" nowrap><strong>#LB_Fecha_Desde#&nbsp;:&nbsp;</strong>&nbsp; </td>				
		<td><cf_sifcalendario name="FechaDesde" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"></td>					
	  </tr>	
	  
	  <tr>	     
		<td width="1%"  align="right" nowrap><input type="checkbox" name="ActivarRango" id="ActivarRango" onClick="AtivarRangoFechas(this)"/>
		<cf_translate key="LB_Fecha_de_Corte"><strong>Fecha de Corte&nbsp;:&nbsp;&nbsp;</strong></cf_translate></td>		
		<!---<input align="right"  type="text" value="<strong>#LB_Fecha_de_Corte#</strong>&nbsp;:&nbsp;&nbsp;" name="EtiqFechaDesde"  id="EtiqFechaDesde"   >--->		
		<td><cf_sifcalendario name="FechaHasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"></td>
	  </tr>
	  
	  <tr>
		<td  align="right" nowrap><strong>#LB_Ordenar_por#&nbsp;:&nbsp;</strong>&nbsp;</td>
		<td>
			<select name="OrderBy">
				<option value="1">#CMB_CFuncional#</option>
				<option value="3">#CMB_CFuncionalConta#</option>
				<option value="5">#CMB_Puesto#</option>
				<option value="7">#CMB_Ceedula#</option>
				<option value="8">#CMB_Nombre#</option>
				<option value="9">#CMB_FechaNac#</option>
				<option value="10">#CMB_Sexo#</option>
				<option value="11">#CMB_EstadoCivil#</option>
				<option value="12">#CMB_FormaDePago#</option>
				<option value="13">#CMB_FrecuenciaDePago#</option>
				<option value="14 desc">#CMB_Salario#</option>
				<option value="15">#CMB_Direccioon#</option>
				<option value="16">#CMB_Teleefono#</option>
			</select>
		</td>
	  </tr>
	  <tr>
		<td  align="right" nowrap><strong>#LB_Formato#&nbsp;:&nbsp;</strong>&nbsp;</td>
		<td>
			<select name="formato">
				<option value="flashpaper">#CMB_Flashpaper#</option>
				<option value="pdf">#CMB_PDF#</option>
				<option value="HTML">#CMB_HTML#</option>
			</select>
		</td>
	  </tr>
	</table>
	<cf_botones values="Consultar,Limpiar">
</form>
</body>
</cfoutput>
<cf_qforms>
	<cf_qformsrequiredfield args="FechaHasta,#LB_Fecha_de_Corte#">
	<cf_qformsrequiredfield args="OrderBy,#LB_Ordenar_por#">
	<cf_qformsrequiredfield args="formato,#LB_Formato#">
</cf_qforms>

<script>
function Evaluar(){
var objCheckBox = document.getElementById('ActivarRango');
	AtivarRangoFechas(objCheckBox);
}

function AtivarRangoFechas(obj)
{
	var objDesde =document.getElementById('fDesde');
	var EtiqFechaDesde =document.getElementById('EtiqFechaDesde');
	if (obj.checked){					
		document.getElementById('FechaDesde').value = '01/01/1900';
		objDesde.style.display='none';	
		if (EtiqFechaDesde) EtiqFechaDesde.value='Fecha de Corte';	
	} else {				
		objDesde.style.display='';	
		if (EtiqFechaDesde) EtiqFechaDesde.value='Fecha Hasta';	
	}		
}
</script>