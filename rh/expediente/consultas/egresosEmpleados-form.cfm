<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha_Desde" Default="Fecha Desde" returnvariable="LB_Fecha_Desde"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha_Hasta" Default="Fecha Hasta" returnvariable="LB_Fecha_Hasta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Ordenar_por" Default="Ordenar por" returnvariable="LB_Ordenar_por"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Ceedula" Default="C&eacute;dula" returnvariable="CMB_Ceedula"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Nombre" Default="Nombre" returnvariable="CMB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Fecha_de_Ingreso" Default="Fecha de Ingreso" returnvariable="CMB_Fecha_de_Ingreso"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Fecha_de_Egreso" Default="Fecha de Egreso" returnvariable="CMB_Fecha_de_Egreso"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Accioon" Default="Acci&oacute;n" returnvariable="CMB_Accioon"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Motivo_Salida" Default="Motivo de Salida" returnvariable="CMB_Motivo_Salida"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Formato" Default="Formato" returnvariable="LB_Formato"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Flashpaper" Default="Flashpaper" returnvariable="CMB_Flashpaper"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_PDF" Default="PDF" returnvariable="CMB_PDF"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Excel" Default="Excel" returnvariable="CMB_Excel"/>
<cfoutput>
<form action="egresosEmpleados-sql.cfm" method="get" name="form1" style="margin:0">
	<table width="100%" border="0" cellspacing="0" cellpadding="1" style="margin:0">
	  <tr>
		<td  align="right" nowrap><strong>#LB_Fecha_Desde#&nbsp;:&nbsp;</strong>&nbsp;</td>
		<td>
			<cf_sifcalendario name="FechaDesde" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
		</td>
	  </tr>
	  <tr>
		<td  align="right" nowrap><strong>#LB_Fecha_Hasta#&nbsp;:&nbsp;</strong>&nbsp;</td>
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
				<option value="3">#CMB_Fecha_de_Ingreso#</option>
				<option value="4" selected>#CMB_Fecha_de_Egreso#</option>
				<option value="5">#CMB_Accioon#</option>
				<option value="6">#CMB_Motivo_Salida#</option>
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
	<cf_qformsrequiredfield args="FechaDesde,#LB_Fecha_Desde#">
	<cf_qformsrequiredfield args="FechaHasta,#LB_Fecha_Hasta#">
	<cf_qformsrequiredfield args="OrderBy,#LB_Ordenar_por#">
	<cf_qformsrequiredfield args="formato,#LB_Formato#">
</cf_qforms>