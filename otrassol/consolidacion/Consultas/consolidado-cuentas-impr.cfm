<cfoutput>
<table width="99%" align="center" cellpadding="0" cellspacing="0">
	<tr align="center"><td align="center"><font size="4" face="Verdana, Arial, Helvetica, sans-serif"><strong>#session.Enombre#</strong></font></td></tr>
	<tr align="center"><td align="center"><font size="4" face="Verdana, Arial, Helvetica, sans-serif"><strong>Consolidado de Empresas</strong></font></td></tr>
	<tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Tipo: <cfif form.tipo eq 1>Balance General<cfelse>Estado de Resultados</cfif></strong></font></td></tr>
	<tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Nivel: #form.Nivel#</strong></font></td></tr>

<cfif isdefined("Form.mcodigoopt") and Form.mcodigoopt EQ "-2">
	<tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Moneda : #rsMonedaLocal.Mnombre#</strong></font></td></tr>
<cfelseif isdefined("Form.mcodigoopt") and Form.mcodigoopt EQ "-3" or Form.mcodigoopt EQ "-4">
	<tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Moneda : #rsMonedaConvertida.Mnombre#</strong></font></td></tr>
</cfif>

	<tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Periodo: #form.mes#/#form.Periodo#</strong></font></td></tr>
</table>
</cfoutput>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td class="tituloListas">Cuenta</td>
		<td class="tituloListas">Descripci&oacute;n</td>
		<td class="tituloListas" align="right">Consolidado</td>
		<cfoutput query="empresa">
			<td class="tituloListas" align="right">#empresa.nombre#</td>
			<!--- TOTALIZAR --->
			<cfset totales['#empresa.codigo#'] = 0>
			<cfset subtotales['#empresa.codigo#'] = 0>
		</cfoutput>
	</tr>

	<cfif datos.recordcount gt 0 >
		<cfset primer_nivel = false >
		<cfoutput query="datos" group="subtipo">
		
			<!--- Subtotalizar el reporte cuando cambia el subtipo --->
			<cfif subtotalizar eq 1>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr >
						<td colspan="2" align="center" style="border-top: 1px solid ##f5f5f5;"><strong>SubTotal</strong></td>
						<td align="right" style="border-top: 1px solid ##f5f5f5;"><strong>#LSNumberFormat(subtotales[0],',9.00')#</strong></td>
						<cfset subtotales[0] = 0>
						<cfloop query="empresa">
							<td align="right" style="border-top: 1px solid ##f5f5f5;"><strong>#LSNumberFormat(subtotales['#empresa.codigo#'],',9.00')#</strong></td>
							<cfset subtotales['#empresa.codigo#'] = 0>
						</cfloop>
					</tr>	
					<tr>
						<td>&nbsp;</td>
					</tr>
			</cfif>

			<tr><td class="encabReporte" colspan="#3+empresa.recordcount#">
				<cfswitch expression="#datos.subtipo#">
					<cfcase value="200">
						Activo
					</cfcase>
					<cfcase value="210">
						Pasivo
					</cfcase>
					<cfcase value="220">
						Capital
					</cfcase>
					<cfcase value="1">
						Ingresos
					</cfcase>
					<cfcase value="2">
						Costos de Operaci&oacute;n
					</cfcase>
					<cfcase value="3" >
						Gastos Administrativos
					</cfcase>
					<cfcase value="4">
						Otros Ingresos Gravables
					</cfcase>
					<cfcase value="5">
						Otros Gastos Deducibles
					</cfcase>
					<cfcase value="6">
						Otros Ingresos No Gravables
					</cfcase>
					<cfcase value="7">
						Otros Gastos No Deducibles
					</cfcase>
					<cfcase value="8">
						Impuestos
					</cfcase>
					<cfdefaultcase>
						Sin Definir
					</cfdefaultcase>
				</cfswitch>
				<cfset subtotalizar = 1>
			</td></tr>
			<cfoutput group="Cuenta">
				<cfif datos.nivel eq 0 >
					<cfset primer_nivel = true >
				</cfif>
				<tr <cfif datos.nivel eq 0>bgcolor="##f5f5f5"</cfif> >
					<td style="padding-left: 3px;" 
						<cfif datos.nivel eq 0>class="negrita"</cfif>>
						<cfif datos.Cuenta NEQ "zzzzzzzz">
							#datos.Cuenta#
						<cfelse>
							&nbsp;
						</cfif>
						</td>
					<cfif len(trim(datos.nivel)) neq 0>
						<td style="padding-left: #(12*datos.nivel)+3#px;" <cfif datos.nivel eq 0>class="negrita"</cfif>>
					<cfelse>
						<td>
					</cfif>
						#datos.Cdescripcion#</td>
				<cfoutput>
					<td align="right" <cfif primer_nivel>class="negrita"</cfif>>#LSNumberFormat(datos.saldo,',9.00')#</td>
					
					<!--- manejo de totales --->
					<cfif primer_nivel>
						<cfset subtotales['#datos.ecodigo#'] = subtotales['#datos.ecodigo#'] + datos.saldo >

						<cfif form.tipo eq 1 >
							<cfif datos.tipo NEQ 'A'>
								<cfset totales['#datos.ecodigo#'] = totales['#datos.ecodigo#'] + datos.saldo >
							</cfif>					
						<cfelse>
							<cfif datos.tipo eq 'I'>
								<cfset totales['#datos.ecodigo#'] = totales['#datos.ecodigo#'] + datos.saldo >
							<cfelse>
								<cfset totales['#datos.ecodigo#'] = totales['#datos.ecodigo#'] - datos.saldo >
							</cfif>
						
						</cfif>


					</cfif>
				</cfoutput>
				</tr>
				<cfset primer_nivel = false >
			</cfoutput>
		</cfoutput>	

		<cfif subtotalizar eq 1>
				<tr>
					<td>&nbsp;</td>
				</tr>

				<tr >
					<cfoutput>
					<td colspan="2" align="center" style="border-top: 1px solid ##f5f5f5;"><strong>SubTotal</strong></td>
					<td align="right" style="border-top: 1px solid ##f5f5f5;"><strong>#LSNumberFormat(subtotales[0],',9.00')#</strong></td>
					<cfset subtotales[0] = 0>
					<cfloop query="empresa">
						<td align="right" style="border-top: 1px solid ##f5f5f5;"><strong>#LSNumberFormat(subtotales['#empresa.codigo#'],',9.00')#</strong></td>
						<cfset subtotales['#empresa.codigo#'] = 0>
					</cfloop>
					</cfoutput>
				</tr>	
				<tr>
					<td>&nbsp;</td>
				</tr>
		</cfif>
		<tr><td>&nbsp;</td></tr>
		<tr >
			<cfoutput>
			<td colspan="2" align="center" style="border-top: 1px solid ##f5f5f5;">
			<cfif form.tipo eq 1 >
				<strong>Total Pasivo y Capital</strong>
			<cfelse>
				<strong>Utilidad</strong>
			</cfif>
			</td>
			<td align="right" style="border-top: 1px solid ##f5f5f5;"><strong>#LSNumberFormat(totales[0],',9.00')#</strong></td>
			</cfoutput>
			<cfoutput query="empresa">
				<td align="right" style="border-top: 1px solid ##f5f5f5;"><strong>#LSNumberFormat(totales['#empresa.codigo#'],',9.00')#</strong></td>
			</cfoutput>
		</tr>	
		<tr><td>&nbsp;</td></tr>
		<cfoutput>
		<tr><td colspan="#3+empresa.recordcount#" align="center">--- Fin del Reporte ---</td></tr>
		</cfoutput>
	<cfelse>
		<tr><td colspan="2">--- No se encontraron registros ---</td></tr>
	</cfif>
</table>
<br />
