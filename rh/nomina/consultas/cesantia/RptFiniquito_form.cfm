<!--- OPARRALES 2019-01-23
	- Reporte para mostrar conceptos aplicables en Liquidacion/Finiquitos
	- Filtrados por Empleado y/o Fecha de cesantia.
 --->

<cfinvoke key="LB_FechaBaja" default="Fecha Inicio" xmlfile="/rh/RptFiniquitos.xml" returnvariable="LB_FechaBaja" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FechaFin" default="Fecha Fin" xmlfile="/rh/RptFiniquitos.xml" returnvariable="LB_FechaFin" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Empleado" default="Empleado" xmlfile="/rh/RptFiniquitos.xml" returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Buscar" default="Buscar" xmlfile="/rh/RptFiniquitos.xml" returnvariable="LB_Buscar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Identificacion" default="Identificacion" xmlfile="/rh/RptFiniquitos.xml" returnvariable="LB_Identificacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Nombre" default="Nombre" xmlfile="/rh/RptFiniquitos.xml" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate"/>

<cfoutput>
	<form name="form1" action="RptFiniquito_sql.cfm" method="post" title="Filtros de Busqueda">
		<table width="35%" align="center" border="0">
			<tr>
				<td align="right"><strong>#LB_Empleado#:&nbsp;</strong></td>
				<td colspan="3">
					<cf_conlis
						campos="DEid,DEidentificacion,DEnombre"
						desplegables="N,S,S"
						size="0,10,30"
						modificables="N,S,N"
						title="Lista de Empleados"
						tabla="DatosEmpleado de, RHLiqFL lf"
						columnas="de.DEid,DEidentificacion,concat(DEnombre,' ',DEapellido1,' ',DEapellido2) DEnombre"
						filtro="de.Ecodigo=#session.Ecodigo# and de.DEid = lf.DEid and lf.Ecodigo = de.Ecodigo order by DEidentificacion"
						desplegar="DEidentificacion,DEnombre"
						filtrar_por="DEidentificacion"
						etiquetas="#LB_Identificacion#,#LB_Nombre#"
						formatos="S,S"
						align="left,left"
						asignar="DEid,DEidentificacion,DEnombre"
						asignarformatos="S,S,S"
						showEmptyListMsg="true"
						tabindex="1"
						top="100"
						left="200"
						width="650"
						height="600"
						alt="ID,#LB_Identificacion#,#LB_Nombre#">
				</td>
			</tr>
			<tr>
				<td align="right"><strong>#LB_FechaBaja#:&nbsp;</strong></td>
				<td>
					<cf_sifcalendario form="form1" name="FIni" value="">
				</td>
				<td align="right"><strong>#LB_FechaFin#:&nbsp;&nbsp;</strong></td>
				<td align="left">
					<cf_sifcalendario form="form1" name="FFin" value="">
				</td>
			</tr>
			<tr>
				<td colspan="4" align="center">
					<input type="submit" name="btnBuscar" id="btnBuscar" value="#LB_Buscar#">
				</td>
			</tr>
			<tr><td colspan="4">&nbsp;</tr>
		</table>
	</form>
</cfoutput>