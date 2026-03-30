<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha_de_Corte" Default="Fecha de Corte" returnvariable="LB_Fecha_de_Corte"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Ordenar_por" Default="Ordenar por" returnvariable="LB_Ordenar_por"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Ceedula" Default="C&eacute;dula" returnvariable="CMB_Ceedula"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Nombre" Default="Nombre" returnvariable="CMB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_CentroFuncional" Default="Centro Funcional" returnvariable="CMB_CentroFuncional"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Puesto" Default="Puesto" returnvariable="CMB_Puesto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Salario" Default="Salario" returnvariable="CMB_Salario"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Formato" Default="Formato" returnvariable="LB_Formato"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Flashpaper" Default="Flashpaper" returnvariable="CMB_Flashpaper"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_PDF" Default="PDF" returnvariable="CMB_PDF"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Excel" Default="Excel" returnvariable="CMB_Excel"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Agrupar_por" Default="Agrupar por" returnvariable="LB_Agrupar_por"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Ninguno" Default="Ninguno" returnvariable="CMB_Ninguno"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_CentroFuncional" Default="CentroFuncional" returnvariable="CMB_CentroFuncional"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Puesto" Default="Puesto" returnvariable="CMB_Puesto"/>
<cfoutput>
<form action="salariosEmpleados-sql.cfm" method="get" name="form1" style="margin:0">
	<table width="100%" border="0" cellspacing="0" cellpadding="1" style="margin:0">
	  <tr>
		<td  align="right" nowrap><strong>#LB_Fecha_de_Corte#&nbsp;:&nbsp;</strong>&nbsp;</td>
		<td>
			<cf_sifcalendario name="FechaHasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
		</td>
	  </tr>
	  <tr>
		<td  align="right" nowrap><strong>#LB_Ordenar_por#&nbsp;:&nbsp;</strong>&nbsp;</td>
		<td>
			<select name="OrderBy">
				<option value="1">#CMB_Ceedula#</option>
				<option value="2">#CMB_Nombre#</option>
				<option value="3">#CMB_CentroFuncional#</option>
				<option value="5">#CMB_Puesto#</option>
				<option value="7 desc">#CMB_Salario#</option>
			</select>
		</td>
	  </tr>
	  <tr>
		<td  align="right" nowrap><strong>#LB_Agrupar_por#&nbsp;:&nbsp;</strong>&nbsp;</td>
		<td>
			<select name="GroupBy">
				<option value="0">#CMB_Ninguno#</option>
				<option value="3">#CMB_CentroFuncional#</option>
				<option value="5">#CMB_Puesto#</option>
			</select>
		</td>
	  </tr>
	  <tr>
		<td  align="right" nowrap><strong>#LB_Formato#&nbsp;:&nbsp;</strong>&nbsp;</td>
		<td>
			<select name="formato">
				<option value="flashpaper">#CMB_Flashpaper#</option>
				<option value="pdf">#CMB_PDF#</option>
				<option value="excel">#CMB_Excel#</option>
			</select>
		</td>
	  </tr>
	</table>
	<cf_botones values="Consultar,Limpiar">
</form>
</cfoutput>
<cf_qforms>
	<cf_qformsrequiredfield args="FechaHasta,#LB_Fecha_de_Corte#">
	<cf_qformsrequiredfield args="OrderBy,#LB_Ordenar_por#">
	<cf_qformsrequiredfield args="GroupBy,#LB_Agrupar_por#">
	<cf_qformsrequiredfield args="formato,#LB_Formato#">
</cf_qforms>