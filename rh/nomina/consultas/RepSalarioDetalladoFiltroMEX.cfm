<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaHasta" Default="Fecha Hasta" returnvariable="LB_FechaHasta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Ordenar_por" Default="Ordenar por" returnvariable="LB_Ordenar_por"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_CFuncional" Default="Centro Funcional" returnvariable="CMB_CFuncional"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Puesto" Default="Puesto" returnvariable="CMB_Puesto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Ceedula" Default="Identificaci&oacute;n" returnvariable="CMB_Ceedula"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Nombre" Default="Nombre" returnvariable="CMB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_FechaNac" Default="Fecha de Nacimiento" returnvariable="CMB_FechaNac"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Salario" Default="Salario" returnvariable="CMB_Salario"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Formato" Default="Formato" returnvariable="LB_Formato"/>

<cfoutput>
<form action="RepSalarioDetalladoReporteMEX.cfm" method="post" name="form1" style="margin:0">
	<table width="100%" border="0" cellspacing="0" cellpadding="1" style="margin:0">
		<tr>
			<td nowrap align="right"> <strong> <cf_translate  key="LB_FechadeCorte">Fecha de Corte</cf_translate> :&nbsp;</strong></td>
			<td><cf_sifcalendario form="form1" tabindex="1" name="FechaHasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"></td>
		</tr>
		<tr>
			<td width="10%" align="right" nowrap><strong><cf_translate key="LB_CentroFuncional" XmlFile="/rh/generales.xml">Centro Funcional</cf_translate>:&nbsp;</strong></td>
			<td ><cf_rhcfuncional tabindex="1"></td>
		</tr>
		<tr>
			<td nowrap width="35%" align="right" ></td>
			<td nowrap width="65%" >
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1%" valign="middle">
							<input type="checkbox" name="dependencias" tabindex="1">
						</td>
						<td valign="middle">
							<cf_translate key="LB_Incluir_Dependencias">Incluir Dependencias</cf_translate>&nbsp;</label></td>
					</tr>
				</table>
			</td>
		</tr>
	<tr>
		<td  align="right" nowrap><strong>#LB_Ordenar_por#&nbsp;:&nbsp;</strong>&nbsp;</td>
		<td>
			<select name="OrderBy">
				<option value="1">#CMB_Nombre#</option>
				<option value="2">#CMB_Ceedula#</option>
				<option value="3,1">#CMB_CFuncional#</option>
				<option value="4,1">#CMB_Puesto#</option>
			</select></td>
	</tr>
	</table>
	<cf_botones values="Consultar,Limpiar">
</form>
</cfoutput>
<cf_qforms>
	<cf_qformsrequiredfield args="FechaHasta,#LB_FechaHasta#">
	<cf_qformsrequiredfield args="OrderBy,#LB_Ordenar_por#">
</cf_qforms>