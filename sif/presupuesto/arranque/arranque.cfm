<cf_templateheader title="Arranque del Control de Presupuesto con base en Saldos Contables Presupuestales">
	<cfinclude template="arranque_verif.cfm">
	
	<cfset LvarIdx = 1>
	<cfset LvarEmpresas = arrayNew(1)>
	<cfset rsEcodigos = rsEcodigos()>
	<cfloop query="rsEcodigos">
		<cfset LvarMcodigoEmpresa	= rsEcodigos.Mcodigo>
		
		<!---
			1. Obtiene el Periodo Contable
			2. Verifica que no exista ningún Período de Presupuesto ni ninguna Cuenta de Presupuesto
			3. Obtiene las máscaras asociadas a las cuentas mayores en SaldosContablesP
			4. Obtiene las Cuentas de Mayor asociadas a las máscaras ajustadas
		--->
		<cfset LvarEmpresas[LvarIdx] = verifica_arranque (rsEcodigos.Ecodigo)>
		<cfset LvarEmpresas[LvarIdx].Empresa = rsEcodigos.Edescripcion>

		<cfset LvarIdx = LvarIdx + 1>
	</cfloop>

	<form name="frmArranque" method="post" action="arranque_sql.cfm">
		<table>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td width="10%"></td>
				<td width="80%">
					Este proceso Arranca el Control de Presupuesto para un Cliente Empresarial que cumpla con los siguientes requisitos:
					<ul>
					  <li>que ya haya iniciado su Período Contable</li>
				      <li>que haya definido Saldos Contables Presupuestales</li>
				      <li>que no tenga definido ningun Período de Presupuesto </li>
				      <li>que no haya definido ninguna máscara de Presupuesto </li>
				  </ul>
				</td>
				<td width="10%"></td>
			</tr>
		</table>

		<table align="center">
			<tr><td>&nbsp;</td></tr>

		<cfif isdefined("url.Arrancar") and url.Arrancar EQ "1">
			<cfset application.CParranque = false>
		</cfif>
		<cfparam name="application.CParranque" default="false">
		<cfif application.CParranque>
			<tr>
				<td style="color:#00FF00"><strong>Proceso en Ejecucion</strong></td>
			<tr>
		<cfelse>
			<tr>
				<td></td>
				<td>
					El siguiente proceso se ejecuta en las empresas indicadas del Cliente Empresarial:				</td>
				<td></td>
			</tr>
			<tr>
			  <td></td>
			  <td>&nbsp;</td>
			  <td></td>
			</tr>
			<tr>
			  <td></td>
			  <td><strong>PASO 1: Creación del Período y Versión de Presupuesto </strong></td>
			  <td></td>
			</tr>
			<tr>
				<td></td>
				<td>
					&nbsp;
					1. Obtiene el Periodo Contable				</td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td>
					&nbsp;
					2. Verifica que no exista ningún Período de Presupuesto ni ninguna Cuenta de Presupuesto				</td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td>
					&nbsp;
					3. Obtiene las máscaras asociadas a las cuentas mayores en SaldosContablesP				</td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td>
					&nbsp;
					4. Ajusta las máscaras convirtiendo todos sus niveles en presupuesto (Cta.Presupuesto = Cta.Contable)</td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td>
					&nbsp;
				5. Crea todas las cuentas de Presupuesto para todas Cuentas Financieras de las Cuentas de Mayor asociadas las máscaras ajustadas</td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td>
					&nbsp;
					6. Crea un Período de Presupuesto igual al Período Contable				</td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td>
					&nbsp;
					7. Crea una Version de Formulación de Presupuesto para el Período de Presupuesto				</td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td>
					&nbsp;
					8. Agrega todas las Cuentas de Presupuesto a la Versión</td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td>
					&nbsp;
					10. Actualiza la Formulación con base en los Saldos Contables Presupuestales (SaldosContablesP)</td>
				<td></td>
			</tr>
			<tr>
			  <td></td>
			  <td>&nbsp;</td>
			  <td></td>
			</tr>
			<tr>
				<td></td>
				<td>
					<strong>PASO 2: Aplicación de la Versión de Presupuesto (Inicia el Control de Presupuesto)</strong></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td>&nbsp;</td>
				<td></td>
			</tr>
			<tr>
			  <td></td>
			  <td><strong>PASO 3: NAP de Ejecución de Arranque de Presupuesto con base en Movimientos Contables </strong></td>
			  <td></td>
			</tr>
			<tr>
				<td></td>
				<td>&nbsp;</td>
				<td></td>
			</tr>
			<tr>
				<td colspan="3" align="center">
					<input type="submit" name="btnArrancar" value="Arrancar"
					/>
				</td>
			</tr>
		</cfif>
		</table>

		<table align="center">
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td></td>
				<td><strong>EMPRESA</strong></td>
				<td align="center"><strong>PERIODO</strong></td>
				<td align="center"><strong>MES<BR>ACTUAL</strong></td>
				<td align="center"><strong>CREAR<BR>VERSION</strong></td>
				<td align="center"><strong>APLICAR<BR>VERSION</strong></td>
				<td align="center"><strong>GENERAR<BR>EJECUCION</strong></td>
			</tr>
		<cfoutput>
		<cfloop index="LvarIdx" from="1" to="#arrayLen(LvarEmpresas)#">
			<cfset LvarError = false>
			<cfset LvarArrancar = false>
			<cfif LvarEmpresas[LvarIdx].ERROR NEQ "" AND LvarEmpresas[LvarIdx].MesAct NEQ 0>
				<cfset LvarError = true>
			<cfelseif LvarEmpresas[LvarIdx].GenerarEjecucion>
				<cfset LvarArrancar = true>
			</cfif>
			
			<tr>
				<td>
				<cfif LvarEmpresas[LvarIdx].Error EQ "">
					<cfif LvarEmpresas[LvarIdx].GenerarEjecucion>
						<input type="checkbox" name="chkEcodigo" 
							 value="#LvarEmpresas[LvarIdx].Ecodigo#"
						/>
					<cfelse>
						<input type="checkbox" name="chkEcodigo"  
							 value="#LvarEmpresas[LvarIdx].Ecodigo#"
							 onclick="if (this.checked) return (confirm('Desea Generar los NAPs de Ejecución de Arranque faltantes'));"
						/>
					</cfif>
				</cfif>
				</td>
				<td>#LvarEmpresas[LvarIdx].Empresa#</td>
				<cfif LvarEmpresas[LvarIdx].MesIni EQ 0 AND LvarEmpresas[LvarIdx].Error NEQ "">
					<td colspan="5" style="color:##FF0000">#LvarEmpresas[LvarIdx].ERROR#</td>
				<cfelse>
					<td>#fnFormatMes(LvarEmpresas[LvarIdx].MesIni)# - #fnFormatMes(LvarEmpresas[LvarIdx].MesFin)#</td>
					<td align="center">#fnFormatMes(LvarEmpresas[LvarIdx].MesAct)#</td>
					<cfif LvarEmpresas[LvarIdx].Error NEQ "">
						<td colspan="3" style="color:##FF0000">ERROR: #LvarEmpresas[LvarIdx].Error#</td>
					<cfelseif NOT LvarEmpresas[LvarIdx].GenerarEjecucion>
						<td colspan="3" style="color:##0000FF"><strong>CONTROL DE PRESUPUESTO YA HA SIDO ARRANCADO</strong></td>
					<cfelse>
						<td align="center"><cfif LvarEmpresas[LvarIdx].CrearVersion>SI<cfelse><font color="##0000FF">Listo</font></cfif></td>
						<td align="center"><cfif LvarEmpresas[LvarIdx].AplicarVersion>SI<cfelse><font color="##0000FF">Listo</font></cfif></td>
						<td align="center"><cfif LvarEmpresas[LvarIdx].GenerarEjecucion>SI<cfelse><font color="##0000FF">Listo</font></cfif></td>
					</cfif>
				</cfif>
			</tr>
		</cfloop>
		</cfoutput>
	</form>
<cf_templatefooter>