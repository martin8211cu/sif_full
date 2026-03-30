<cf_templateheader title="Exportador Descripci&oacute;n de Cuentas">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Exportador Descripci&oacute;n de Cuentas">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<form name="form1" action="ExportarCuentas_Form.cfm" method="post">
			<table width="100%" border="0" cellspacing="1" cellpadding="1">
				<tr>
					<td align="right"><strong>Fecha Creación Inicial:</strong>&nbsp;</td>
					<td ><cf_sifcalendario name="finicio"  tabindex="1"></td>
				</tr>
				<tr>
					<td align="right"><strong>Fecha Creación Final:</strong>&nbsp;</td>
					<td ><cf_sifcalendario name="ffinal"  tabindex="1"></td>
				</tr>
				<tr>
					<td width="35%" align="right"><strong>Cuenta Inicial:</strong>&nbsp;</td>
					<td nowrap> 
						<cf_conlis title="Lista de Cuentas"
							campos = "CFcuenta, CFformato, CFdescripcion" 
							desplegables = "N,S,S" 
							modificables = "N,S,N" 
							size = "0,0,40"
							tabla="CFinanciera t"
							columnas="t.CFcuenta,  t.CFformato, t.CFdescripcion"
							filtro="t.Ecodigo = #Session.Ecodigo# order by t.CFformato, CFdescripcion"
							desplegar="CFformato, CFdescripcion"
							etiquetas="C&oacute;digo, Descripci&oacute;n"
							formatos="S,S"
							align="left,left"
							asignar="CFcuenta, CFformato, CFdescripcion"
							asignarformatos="S,S,S"
							showEmptyListMsg="true"
							debug="false"
							tabindex="1">
					</td>
				</tr>
				<tr>
					<td align="right"><strong>Cuenta Final:</strong>&nbsp;</td>
					<td nowrap> 
						<cf_conlis title="Lista de Cuentas"
							campos = "CFcuenta2, CFformato2, CFdescripcion2" 
							desplegables = "N,S,S" 
							modificables = "N,S,N" 
							size = "0,0,40"
							tabla="CFinanciera t"
							columnas="t.CFcuenta as CFcuenta2,  t.CFformato as CFformato2, t.CFdescripcion as CFdescripcion2"
							filtro="t.Ecodigo = #Session.Ecodigo# order by t.CFformato, CFdescripcion"
							filtrar_por="CFformato, CFdescripcion"
							desplegar="CFformato2, CFdescripcion2"
							etiquetas="C&oacute;digo, Descripci&oacute;n"
							formatos="S,S"
							align="left,left"
							asignar="CFcuenta2, CFformato2, CFdescripcion2"
							asignarformatos="S,S,S"
							showEmptyListMsg="true"
							debug="false"
							tabindex="1">
					</td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr>
					<td colspan="2" align="center">
						<cf_botones values="Exportar" names="Exportar" tabindex="1">
					</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;
						
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<strong>Para importar el archivo generado:</strong><BR>
						1) Elimine la primera línea de títulos<BR>
						2) Modifique las descripciones que desea cambiar<BR>
						3) Elimine las descripciones que no desea cambiar<BR>
						4) Incluya nuevas cuentas que no existen (Únicamente tipo F=Cuentas Financieras)<BR>
						5) Salve el archivo con formato CVS=Separado por comas<BR>

						<BR><BR>
						<strong>TipoCuenta:</strong><BR>
						F = Cuentas Financieras + Contables + Presupuesto (si son iguales)<BR>
						C = Únicamente Cuenta Contable (cuando difiere de la financiera)<BR>
						P = Únicamente Cuentas de Presupuesto (cuando difiere de la financiera)<BR>
					</td>
				</tr>
			</table>
		</form>	
	<cf_web_portlet_end>
<cf_templatefooter>