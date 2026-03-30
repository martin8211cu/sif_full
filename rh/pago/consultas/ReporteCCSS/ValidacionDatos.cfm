<cf_templatecss>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Parametros Generales"
	Default="Par&aacute;metros Generales"
	returnvariable="LB_Parametros_Generales"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tipos_de_Movimiento"
	Default="Tipos de Movimiento"
	returnvariable="LB_Tipos_de_Movimiento"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Oficinas"
	Default="Oficinas"
	returnvariable="LB_Oficinas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empleados"
	Default="Empleados"
	returnvariable="LB_Empleados"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Puestos"
	Default="Puestos"
	returnvariable="LB_Puestos"/>	

		

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<cf_tabs width="100%">
					<cf_tab text="#LB_Parametros_Generales#" selected="true">
						<cfinclude template="ValidacionParametros.cfm">
					</cf_tab>
					<cf_tab text="#LB_Tipos_de_Movimiento#" >
						<cfinclude template="ValidacionTipos.cfm">
					</cf_tab>
					<cf_tab text="#LB_Oficinas#" >
						<cfinclude template="ValidacionOficinas.cfm">
					</cf_tab>
					<cf_tab text="#LB_Empleados#" >
						<cfinclude template="ValidacionEmpleados.cfm">
					</cf_tab>
					<cf_tab text="#LB_Puestos#" >
						<cfinclude template="ValidacionPuestos.cfm">
					</cf_tab>
				</cf_tabs>		
			</td>
		</tr>
	</table>
</cfoutput>