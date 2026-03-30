<cfset subtotales = structnew()>
<cfset subtotales['0'] = 0>
<cfset totales = structnew()>
<cfset totales['0'] = 0>
<cfset subtotalizar = 0>
<cfset totales[0] = 0>
<cfset subtotales[0] = 0>

<!--- TOTALIZAR --->
<cfoutput query="empresa">
	<cfset totales['#empresa.codigo#'] = 0>
	<cfset subtotales['#empresa.codigo#'] = 0>
</cfoutput>

	<cfif datos.recordcount gt 0 >
		<cfset primer_nivel = false >
		<cfset LvarEsActivo = false>
		<cfset LvarEsUtilidad = false>
		<cfoutput query="datos" group="subtipo">
		
			<cfif datos.subtipo EQ 200>
				<cfset LvarEsActivo = true>
			</cfif>
			<!--- Subtotalizar el reporte cuando cambia el subtipo --->
			<cfif subtotalizar eq 1>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr >
						<cfif LvarEsActivo>
							<cfset LvarEsActivo = false>
							<cfset LvarSubtotal = "TOTAL ACTIVOS">
							<cfset LvarStyle="background-color:##444466;font-weight: bold;color: ##FFFFFF;">
							<cfset LvarAlign="left">
						<cfelse>
							<cfset LvarSubtotal = "Subtotal">
							<cfset LvarStyle="">
							<cfset LvarAlign="center">
						</cfif>
						<td colspan="2" align="#LvarAlign#" style="border-top: 1px solid ##f5f5f5;#LvarStyle#" class="Datos" x:num>
							<strong>#LvarSubtotal#</strong>
						</td>
                        <cfif not isdefined('form.btnDownload')>
							<td align="right" style="border-top: 1px solid ##f5f5f5;#LvarStyle#" class="Datos" x:num><strong>#LSNumberFormat(subtotales[0],',9.00')#</strong></td>
                       	<cfelse>
							<td align="right" style="border-top: 1px solid ##f5f5f5;#LvarStyle#" class="Datos" x:num><strong>#replace(LSNumberFormat(subtotales[0],'(0.00)'),",",".")#</strong></td>                        	
                     	</cfif>
						<cfset subtotales[0] = 0>
						<cfloop query="empresa">
                        	<cfif not isdefined('form.btnDownload')>
								<td align="right" style="border-top: 1px solid ##f5f5f5;#LvarStyle#" class="Datos" x:num><strong>#LSNumberFormat(subtotales['#empresa.codigo#'],',9.00')#</strong></td>
                         	<cfelse>
								<td align="right" style="border-top: 1px solid ##f5f5f5;#LvarStyle#" class="Datos" x:num><strong>#replace(LSNumberFormat(subtotales['#empresa.codigo#'],'(0.00)'),",",".")#</strong></td>                            	
                           	</cfif>
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
					<cfcase value="300">
						Resultado del Período
						<cfset LvarEsUtilidad = true>
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
				<!--- En datos.Cuenta EQ "UTILIDAD" es lo mismo que utilidades retenidas --->
				<tr <cfif datos.nivel eq 0>bgcolor="##f5f5f5"</cfif> >
					<td style="padding-left: 3px;" nowrap
						class="<cfif datos.nivel eq 0>negrita </cfif> Datos" style='mso-number-format:"\##\,\##\##0\.00";' x:num>
						<cfif datos.Cuenta NEQ "UTILIDAD">
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
						#datos.Cdescripcion#
					</td>                	
				<cfoutput> <!--- Detalle por Empresa --->
					<cfif not isdefined('form.btnDownload')>
						<td align="right" class="<cfif primer_nivel>negrita </cfif>Datos" style='mso-number-format:"\##\,\##\##0\.00";' x:num>#LSNumberFormat(datos.saldo, ',9.00')#</td>
					<cfelse>
						<td align="right" class="<cfif primer_nivel>negrita </cfif>Datos" style='mso-number-format:"\##\,\##\##0\.00";' x:num>#replace(LSNumberFormat(datos.saldo,'(0.00)'),",",".")#</td>                            	                        	
					</cfif>
					
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
		<cfif subtotalizar eq 1 AND NOT LvarEsUtilidad>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr >
					<cfoutput>
					<td colspan="2" align="center" style="border-top: 1px solid ##f5f5f5;"><strong>SubTotal</strong></td>
                    <cfif not isdefined('form.btnDownload')>
						<td align="right" style="border-top: 1px solid ##f5f5f5;" class="Datos" x:num><strong>#LSNumberFormat(subtotales[0],',9.00')#</strong></td>
                  	<cfelse>
						<td align="right" style="border-top: 1px solid ##f5f5f5;" class="Datos" x:num><strong>#replace(LSNumberFormat(subtotales[0],'(0.00)'),",",".")#</strong></td>                    	
                 	</cfif>
					<cfset subtotales[0] = 0>
					<cfloop query="empresa">
                    	<cfif not isdefined('form.btnDownload')>
							<td align="right" style="border-top: 1px solid ##f5f5f5;" class="Datos" x:num><strong>#LSNumberFormat(subtotales['#empresa.codigo#'],',9.00')#</strong></td>
                      	<cfelse>
							<td align="right" style="border-top: 1px solid ##f5f5f5;" class="Datos" x:num><strong>#replace(LSNumberFormat(subtotales['#empresa.codigo#'],'(0.00)'),",",".")#</strong></td>                        	
                      	</cfif>
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
			<td colspan="2" align="left" style="border-top: 1px solid ##f5f5f5;background-color:##444466;font-weight: bold;color: ##FFFFFF;">

			<cfif form.tipo eq 1 >
				<strong>TOTAL PASIVO Y CAPITAL</strong>
			<cfelse>
				<strong>RESULTADO DEL PERIODO</strong>
			</cfif>
			</td>
            <cfif not isdefined('form.btnDownload')>
				<td align="right" style="border-top: 1px solid ##f5f5f5;background-color:##444466;font-weight: bold;color: ##FFFFFF;" class="Datos" x:num><strong>#LSNumberFormat(totales[0],',9.00')#</strong></td>
         	<cfelse>
            	<td align="right" style="border-top: 1px solid ##f5f5f5;background-color:##444466;font-weight: bold;color: ##FFFFFF;" class="Datos" x:num><strong>#replace(LSNumberFormat(totales[0],'(0.00)'),",",".")#</strong></td>
            </cfif>
			</cfoutput>
			<cfoutput query="empresa">
            	<cfif not isdefined('form.btnDownload')>
					<td align="right" style="border-top: 1px solid ##f5f5f5;background-color:##444466;font-weight: bold;color: ##FFFFFF;" class="Datos" x:num><strong>#LSNumberFormat(totales['#empresa.codigo#'],',9.00')#</strong></td>
               	<cfelse>
                	<td align="right" style="border-top: 1px solid ##f5f5f5;background-color:##444466;font-weight: bold;color: ##FFFFFF;" class="Datos" x:num><strong>#replace(LSNumberFormat(totales['#empresa.codigo#'],'(0.00)'),",",".")#</strong></td>
              	</cfif>
			</cfoutput>
		</tr>	
		<tr><td>&nbsp;</td></tr>
		<cfoutput>
			<cfif form.tipo EQ 1>
				<tr><td colspan="#3+empresa.recordcount#" align="center"><strong>--- Fin Cuentas de Balance ---</strong></td></tr>
			<cfelse>
				<tr><td colspan="#3+empresa.recordcount#" align="center"><strong>--- Fin Cuentas de Resultado ---</strong></td></tr>
			</cfif>
			<tr><td>&nbsp;</td></tr>
		</cfoutput>
	<cfelse>
		<tr><td colspan="2">--- No se encontraron registros ---</td></tr>
	</cfif>
