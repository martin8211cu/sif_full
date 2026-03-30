<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha_de_Corte" Default="Fecha de Corte" returnvariable="LB_Fecha_de_Corte"/>
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


<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Empleado" Default="Empleado" returnvariable="LB_Empleado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CentroFuncional" Default="Centro Funcional" returnvariable="LB_CentroFuncional"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha_Desde" Default="Fecha Desde" returnvariable="LB_Fecha_Desde"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha_Hasta" Default="Fecha Hasta" returnvariable="LB_Fecha_Hasta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha_de_Corte" Default="Fecha de Corte" returnvariable="LB_Fecha_de_Corte"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Ordenar_por" Default="Ordenar por" returnvariable="LB_Ordenar_por"/>

<body>
<form action="generalEmpleados-datosVariables-sql.cfm" method="get" name="form1" style="margin:0">
	<table width="100%" border="0" cellspacing="1" cellpadding="1" style="margin:0">
	  
	  <tr>
		<td align="right" nowrap><strong>#LB_CentroFuncional#&nbsp;:&nbsp;</strong>&nbsp; </td>	
		<td> <cf_rhcfuncional form="form1" tabindex="1"> </td>
	</tr>
	  
	  <tr>
		<td align="right" nowrap>&nbsp;</td>	
		<td align="right" valign="middle">
			<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td width="1%" valign="middle"><input type="checkbox" name="dependencias" id="dependencias" tabindex="1"></td>
				<td valign="middle">
					<label for="dependencias" style="font-style:normal; font-variant:normal; font-weight:normal">
					<cf_translate key="LB_Incluir_Dependencias">Incluir Dependencias</cf_translate>&nbsp;
					</label>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	  
	  <tr> 
	  	<td align="right" nowrap><strong>#LB_Empleado#&nbsp;:&nbsp;</strong>&nbsp; </td>	
		<td><cf_rhempleado form="form1" size="40" validateCFid="true" tabindex="1"></td>
	  </tr> 
	
	  
	  <tr>	     
		<td width="1%"  align="right" nowrap>
		<cf_translate key="LB_Fecha_de_Corte"><strong>Fecha de Corte&nbsp;:&nbsp;&nbsp;</strong></cf_translate></td>		
		<td><cf_sifcalendario name="FechaHasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"></td>
	  </tr>
	
	  <tr>
		<td  align="right" nowrap><strong>#LB_Ordenar_por#&nbsp;:&nbsp;</strong>&nbsp;</td>
		<td>
			<select name="OrderBy">
				<option value="1">#CMB_CFuncional#</option>
				<option value="5">#CMB_Puesto#</option>
				<option value="7">#CMB_Ceedula#</option>
				<option value="8">#CMB_Nombre#</option>
			</select>
		</td>
	  </tr>
	  
	  <tr>
		<td  align="right" nowrap><strong>#LB_Formato#&nbsp;:&nbsp;</strong>&nbsp;</td>
		<td>
			<select name="formato">
				<!---<option value="flashpaper">#CMB_Flashpaper#</option>
				<option value="pdf">#CMB_PDF#</option>--->
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
