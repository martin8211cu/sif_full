<!---RVNP--->
<!--- 
	****************************************
	****Consulta de Renta*******************
	****Ultima  modificación: 14/02/2007****
	****Ultima   modificación  realizada****
	****por:   Dorian    Abarca   Gómez.****
	****Descripción:  Se modificó porque****
	****no    tomaba    en  cuenta   los****
	****componentes  que no cargan renta****
	****y  no  obtenía correctamente las****
	****deducciones    de    renta   por****
	****familiares      (hijos/conyuge).****
	****************************************
--->
<!--- Etiquetas de Traducción --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="JS_PeriodoInicial" Default="Periodo Inicial" 	returnvariable="JS_PeriodoInicial"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="JS_MesInicial" Default="Mes Inicial" 	returnvariable="JS_MesInicial"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="JS_PeriodoFinal" Default="Periodo Final" 	returnvariable="JS_PeriodoFinal"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="JS_MesFinal" Default="Mes Final" 	returnvariable="JS_MesFinal"/>
<!--- Formulario de Filtro por 1)periodos / mes, desde / hasta (REQUERIDOS) y 2)Empleado (OPCIONAL) --->
<cfoutput>
	<form method="post" name="form1" action="reporteRentaK-sql.cfm">
		<table width="1%" cellpadding="0" cellspacing="2" align="center">
			<tr>
				<td nowrap align="right"><strong><cf_translate  key="LB_PeriodoMesInicial">Periodo /Mes Inicial</cf_translate>:&nbsp;</strong></td>
				<td><cf_rhperiodos name="periodo_inicial"></td>
				<td><cf_meses name="mes_inicial"></td>
				<td width="300"><span style="font-size='9px';color='red'">* **</span></td>
			</tr>
			<tr>
				<td nowrap align="right"><strong><cf_translate  key="LB_PeriodoMesFinal">Periodo /Mes Final</cf_translate>:&nbsp;</strong></td>
				<td><cf_rhperiodos name="periodo_final"></td>
				<td><cf_meses name="mes_final"></td>
				<td><span style="font-size='9px';color='red'">* **</span></td>
			</tr>
			<tr>
				<td align="right"><strong><cf_translate  key="LB_Empleado">Empleado</cf_translate>:&nbsp;</strong></td>
				<td colspan="3"><cf_rhempleado></td>
			</tr>
			<tr>
				<td align="right"></td>
				<td colspan="3">
					<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
					<td>
					<input type="checkbox" name="IncuirNoRenta">
					</td>
					<td width="100%">
					<strong><cf_translate  key="LB_Incluir_Empleados_que_no_aplican_renta">Incluir Empleados que no aplican renta</cf_translate></strong>
					</td>
					</tr>				
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="4">
					<p style="font-size='9px';color='red'">* <cf_translate  key="LB_requeridos">requeridos</cf_translate>.
					<br>** <cf_translate  key="LB_deben_pertenecer_a_la_misma_tabla_de_renta">deben pertenecer a la misma tabla de renta</cf_translate>.</p>
				</td>
			</tr>
		</table>
		<cf_botones values="Consultar">
	</form>
</cfoutput>
<!--- Valida que sean requeridos los periodos / mes, desde / hasta --->
<cf_qforms>
	<cf_qformsrequiredfield args="periodo_inicial, #JS_PeriodoInicial#">
	<cf_qformsrequiredfield args="mes_inicial, #JS_MesInicial#">
	<cf_qformsrequiredfield args="periodo_final, #JS_PeriodoFinal#">
	<cf_qformsrequiredfield args="mes_final, #JS_MesFinal#">
</cf_qforms>