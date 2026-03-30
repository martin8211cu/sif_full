<style>
	td{font-family:"Courier New", Courier, monospace; font-size:14pt;}
</style>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Semanal" Default="Semanal" returnvariable="LB_Semanal"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Bisemanal" Default="Bisemanal" returnvariable="LB_Bisemanal"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Quincenal" Default="Quincenal" returnvariable="LB_Quincenal"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_AJUSTE" Default="AJUSTE" returnvariable="LB_AJUSTE"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DEVOLUCION" Default="DEVOLUCION" returnvariable="LB_DEVOLUCION"/>

<!----
<cfquery name="rsMostrarSalarioNominal" datasource="#session.DSN#">
	select coalesce(Pvalor,'0') as  Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Pcodigo = 1040
</cfquery>

<cfif rsMostrarSalarioNominal.Pvalor eq 1>
	<cfquery name="rsRCNid" dbtype="query">
		select max(RCNid) as RCNid
		from ConceptosPago
	</cfquery>
	<cfquery name="rsTiposNomina" datasource="#Session.DSN#" maxrows="1">
		select 	b.Ttipopago,
				case b.Ttipopago when 0 then '#LB_Semanal#'
					when 1 then '#LB_Bisemanal#'
					when 2 then '#LB_Quincenal#'
				else ''
				end as   descripcion,
				c.CPhasta,
				c.Tcodigo
		from CalendarioPagos c
			inner join TiposNomina b 
				on c.Tcodigo = b.Tcodigo
		where c.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and c.CPid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRCNid.RCNid#">
	</cfquery>		
</cfif>
---->

<cfset lineaslleva = 0>	<!---Lineas por boleta--->
<cfset lineaspagina = 0><!---Lineas por pagina--->
<cfset boletas = 1>		<!---Total de paginas de todo--->

<cfsavecontent variable="DETALLE">
	<cfif ConceptosPago.RecordCount NEQ 0>
	<table width="98%" cellpadding="1" cellspacing="0">
		<cfoutput query="ConceptosPago" group="DEid">										
			<!---
			<cfset var_salarioTipoNomina=0>
			<cfif rsMostrarSalarioNominal.Pvalor eq 1 and isdefined("rsTiposNomina") and rsTiposNomina.Ttipopago neq 3>		
				<cfset salario = 0>
				<cfquery name="rsLineaTiempo" datasource="#Session.DSN#">
					select coalesce(LTsalario ,0) as salario
					from LineaTiempo
					where <cfqueryparam cfsqltype="cf_sql_date" value="#rsTiposNomina.CPhasta#"> between LTdesde and LThasta
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ConceptosPago.DEid#">
				</cfquery>
				<cfif rsLineaTiempo.RecordCount NEQ 0>
					<cfset salario = rsLineaTiempo.salario>
				</cfif>				
				<cfinvoke component="rh.Componentes.RH_Funciones" 
					method="salarioTipoNomina"
					salario = "#salario#"
					Tcodigo = "#rsTiposNomina.Tcodigo#"
					returnvariable="var_salarioTipoNomina">
			</cfif>
			---->
			
			<!---Si existen cargas que deben mostrarse en forma resumida se sumarizan. CarolRS--->
			<cfquery dbtype="query" name="CargasResumidas">
				select resumeCargasDesc as descconceptoB,sum(montoconceptoB) as montoconceptoB
				from ConceptosPago
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ConceptosPago.DEid#">
				and resumeCargas = 1
				group by resumeCargasDesc
			</cfquery>
			
			<cfset lineasEmp = ConceptosPago.lineasEmp>
			<!---Datos del Encabezado--->
			<cfset vs_nomina = ConceptosPago.nomina>
			<cfset vs_desdenomina = ConceptosPago.desdenomina>
			<cfset vs_hastanomina = ConceptosPago.hastanomina>			
			<cfquery name="rsEmpleado" datasource="#session.DSN#">
				select <cf_dbfunction name="concat" args="DEapellido1,' ',DEapellido2,' ',DEnombre"> as empleado
				from DatosEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ConceptosPago.DEid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cfset vs_empleado = rsEmpleado.empleado>
			<cfset vs_cuenta = ConceptosPago.cuenta>
			<cfset vs_departamento = ConceptosPago.departamento>
			<cfset vs_puntoventa = ConceptosPago.puntoventa>
			<!---Datos del Detalle--->
			<cfset vs_devengado = ConceptosPago.devengado>
			<cfset vs_deducido = ConceptosPago.deducido>
			<cfset vs_neto = ConceptosPago.neto>
			<cfset vs_etiquetacta = ConceptosPago.EtiquetaCuenta>
			<cfsavecontent variable="Encabezado">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td colspan="2">#session.Enombre#</td>
					</tr>
					<tr>
						<td colspan="2"><cf_translate key="LB_Boleta_Pago">Boleta de Pago</cf_translate></td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td width="5%" nowrap="nowrap"><cf_translate key="LB_NombreEmpleado">Nombre Empleado</cf_translate></td>
						<td>:&nbsp;#vs_empleado#</td>
						<td align="right"><cf_translate key="LB_Devengado">Devengado</cf_translate>:&nbsp;</td>
						<td align="right">#LSNumberFormat(ConceptosPago.devengado, '999,999,999,999,999.99')#</td>				
					</tr>
					<tr>
						<td width="5%" nowrap="nowrap"><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate></td>
						<td>:&nbsp;<cfif len(trim(vs_departamento)) GT 32>#Mid(vs_departamento,1,32)#<cfelse>#vs_departamento#</cfif></td>
						<td align="right"><cf_translate key="LB_Deducciones">Deducciones</cf_translate>:&nbsp;</td>
						<td align="right">#LSNumberFormat(ConceptosPago.deducido, '999,999,999,999,999.99')#</td>						
					</tr>
					<tr>
						<td><cf_translate key="LB_Nomina">N&oacute;mina</cf_translate></td>
						<td>:&nbsp;<cfif len(trim(vs_nomina)) GT 32>#Mid(vs_nomina,1,32)#<cfelse>#vs_nomina#</cfif></td>
						<td align="right"><cf_translate key="LB_Neto">Neto</cf_translate>:&nbsp;</td>
						<td align="right">
							#LSNumberFormat(ConceptosPago.neto, '999,999,999,999,999.99')#
						</td>							
					</tr>
					<tr>
						<td><cf_translate key="LB_Periodo">Periodo</cf_translate></td>
						<td>
							:<cf_translate key="LB_Del">Del</cf_translate>&nbsp;#LSDateFormat(vs_desdenomina,'dd/mm/yyyy')#&nbsp;<cf_translate key="LB_al">al</cf_translate>&nbsp;&nbsp;#LSDateFormat(vs_hastanomina,'dd/mm/yyyy')#
						</td>
						<!----
						<cfif rsMostrarSalarioNominal.Pvalor eq 1>
							<td align="right"><cfif len(trim(rsTiposNomina.descripcion)) GT 10>#Mid(rsTiposNomina.descripcion,1,10)#<cfelse>#rsTiposNomina.descripcion#</cfif>:&nbsp;</td>
							<td align="right">#LSNumberFormat(var_salarioTipoNomina, '(___,___,___,___,___.__)')#</td>
						</cfif>	
						---->						
					</tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</cfsavecontent>			
			<cfset iniciopagina = false> 
			<cfif iniciopagina><!---ConceptosPago.CurrentRow NEQ 1--->
				<tr><td>11&nbsp;</td></tr>
				<tr><td>22&nbsp;</td></tr>
				<tr><td>33&nbsp;</td></tr>
				<tr><td>44&nbsp;</td></tr>			
			</cfif>			
			<cfset continuar = true>
			<!---ENCABEZADO--->	
			<cfset x = boletas mod 2>
			<cfif x EQ 0 and boletas GT 2>
				<tr><td height="50px">&nbsp;</td></tr>	
			</cfif>						
			<tr><td colspan="7">#Encabezado#</td></tr>
			<cfset lineaslleva = 9>	<!----Lineas del encabezado---->
			<cfset lineaspagina = lineaspagina+lineaslleva>	
			<cfset boletas = boletas+1>		
			<!---CICLO DE CONCEPTOS---->
			<cfset CONTADOR = 1><!---Cantidad de conceptos por boleta--->
			
			<cfset displayCargasResumidas = 0> <!---Pintado de Cargas Resumidas. Indicador para saber si las cargas resumidas ya fureon pintadas en el reporte para un empleado en especifico. CarolRS--->
			
			<cfoutput>
				<cfif CONTADOR EQ 1><!---En la primera linea del detalle se pinta el encabezado-labels del mismo---->						
					<tr>
						<!----INGRESOS--->
						<td valign="top" style="border-bottom: 1px dashed black;" width="250">
							<cf_translate  key="LB_Ingresos">Ingresos</cf_translate>
						</td>
						<td valign="top" style="border-bottom: 1px dashed black;" width="80"><cf_translate  key="LB_Cantidad">Cantidad</cf_translate></td>
						<td align="right" valign="top" style="border-bottom: 1px dashed black;" width="120"><cf_translate  key="LB_Monto">Monto</cf_translate></td>
						<td width="7">&nbsp;</td>
						<!---DEDUCCIONES---->
						<td valign="top" style="border-bottom: 1px dashed black;" width="330"><cf_translate  key="LB_Deducciones">Deducciones</cf_translate></td>
						<td valign="top" style="text-align:right;border-bottom: 1px dashed black;" width="120"><cf_translate  key="LB_Monto">Monto</cf_translate></td>
					</tr>
				</cfif>								
				<tr>
					<!----INGRESOS--->
					<td valign="top" nowrap>
						<cfif trim(ConceptosPago.descconcepto) EQ 'RETROACTIVOS'>
							<cfset ConceptosPago.descconcepto = '#LB_AJUSTE# #ConceptosPago.descconcepto#'>
						</cfif>
						<cfif len(trim(descconcepto))>
							<cfif len(descconcepto) GT 23>
								#Mid(descconcepto, 1, 23)#
							<cfelse>
								#descconcepto#
							</cfif>								
						<cfelse>&nbsp;</cfif>
					</td>
					<td valign="top" nowrap align="center">
						<cfif trim(ConceptosPago.descconcepto) NEQ 'RETROACTIVOS'>						
							<cfif len(trim(cantconcepto))>#LSNumberFormat(cantconcepto,'999.99')#<cfelse>&nbsp;</cfif>
						<cfelse>
							&nbsp;
						</cfif>	
					</td>
					<td valign="top" style="text-align:right;">
						<cfif ConceptosPago.montoconcepto NEQ 0 and len(trim(ConceptosPago.descconcepto)) NEQ 0>
							#LSNumberFormat(ConceptosPago.montoconcepto,'999,999,999,999,999.99')#					
						<cfelseif len(trim(ConceptosPago.descconcepto)) NEQ 0>
							#LSNumberFormat(ConceptosPago.montoconcepto,'999,999,999,999,999.99')#
						<cfelse>
							&nbsp;
						</cfif>					
					</td>
					<td >&nbsp;</td>
					<!---DEDUCCIONES---->
						
					<cfif ConceptosPago.resumeCargas EQ 0> <!---si hay cargas resumidas, se separan de las no resumidas--->
						
						<td valign="top" nowrap="nowrap">						
							<cfif len(trim(ConceptosPago.montoconceptoB)) NEQ 0 and trim(ConceptosPago.montoconceptoB) LT 0 >
								<cfset ConceptosPago.descconceptoB = '#LB_DEVOLUCION# #ConceptosPago.descconceptoB#'>
							</cfif>						
							<cfif len(trim(descconceptoB))>
								<cfif len(descconceptoB) GT 29>
									#Mid(descconceptoB, 1, 29)#
								<cfelse>
									#descconceptoB#
								</cfif>									
							<cfelse>&nbsp;</cfif>	
						</td>
						<td valign="top" style="text-align:right">
							<cfif ConceptosPago.montoconceptoB NEQ 0 and len(trim(ConceptosPago.montoconceptoB)) NEQ 0>
								#LSNumberFormat(ConceptosPago.montoconceptoB,'999,999,999,999,999.99')#					
							<cfelseif len(trim(ConceptosPago.montoconceptoB)) NEQ 0>
								#LSNumberFormat(ConceptosPago.montoconceptoB,'999,999,999,999,999.99')#
							<cfelse>
								&nbsp;
							</cfif>
						</td>
					
					<cfelseif displayCargasResumidas EQ 0 and CargasResumidas.recordCount gt 0>	<!---Si no se han pintado aun cargas resumidas y existen cargas resumidas por pintar. CarolRS--->
						<td valign="top" nowrap="nowrap">						
							<cfif len(trim(CargasResumidas.montoconceptoB)) NEQ 0 and trim(CargasResumidas.montoconceptoB) LT 0 >
								<cfset CargasResumidas.descconceptoB = '#LB_DEVOLUCION# #CargasResumidas.descconceptoB#'>
							</cfif>						
							<cfif len(trim(CargasResumidas.descconceptoB))>
								<cfif len(CargasResumidas.descconceptoB) GT 29>
									#Mid(CargasResumidas.descconceptoB, 1, 29)#
								<cfelse>
									#CargasResumidas.descconceptoB#
								</cfif>									
							<cfelse>&nbsp;</cfif>	
						</td>
						<td valign="top" style="text-align:right">
							<cfif CargasResumidas.montoconceptoB NEQ 0 and len(trim(CargasResumidas.montoconceptoB)) NEQ 0>
								#LSNumberFormat(CargasResumidas.montoconceptoB,'999,999,999,999,999.99')#					
							<cfelseif len(trim(CargasResumidas.montoconceptoB)) NEQ 0>
								#LSNumberFormat(CargasResumidas.montoconceptoB,'999,999,999,999,999.99')#
							<cfelse>
								&nbsp;
							</cfif>
						</td>	
						
						<cfset displayCargasResumidas = 1> <!---Indica que las cargas resumidas para el empleado ya fueron pintadas para que no se pienten nuevamente. CarolRS--->
					</cfif>
						
				</tr>	
			<!---Si son mas de 11 conceptos colocarlos en otra boleta, hacer corte---->
			<cfif vb_pagebreak>
				<cfif CONTADOR GTE 11>
					<!----ETIQUETA DEL PIE DE PAGINA ---->
					<tr><td>&nbsp;</td></tr>
					<cfif len(trim(rsEtiquetaPie.Mensaje)) GT 250>		
						<tr><td colspan="7" width="950" nowrap="nowrap">#Mid(rsEtiquetaPie.Mensaje,1,250)#</td></tr>
					<cfelse>
						<tr>
							<td colspan="7" width="950">#trim(rsEtiquetaPie.Mensaje)#</td>
						</tr>
					</cfif>	
					<cfset lineaslleva = lineaslleva+5>
					<cfset lineaspagina = lineaspagina+5>
					<cfif lineaspagina GTE 46>
						<tr><td style="page-break-before:always;"></td></tr>
						<cfset lineaspagina = 0>		
						<cfset iniciopagina = true>
					<cfelse>		
						<cfif lineaslleva  LT 29 and lineaspagina GT 1>
							<cfset vn_hasta = 29-lineaslleva>					
							<cfloop index="i" from="1" to="#vn_hasta#">
								<cfif lineaspagina GTE 52 and ConceptosPago.CurrentRow NEQ ConceptosPago.RecordCount>
									<tr><td style="page-break-before:always;"></td></tr>
									<cfset iniciopagina = true>
									<cfset lineaspagina = 0>
									<cfbreak>
								</cfif>
								<tr><td>&nbsp;</td></tr>
								<cfset lineaspagina = lineaspagina+1>
							</cfloop>				
						</cfif>
					</cfif>	
					<cfif CONTADOR NEQ lineasEmp>
						<cfset CONTADOR = 0>		
						<cfset x = boletas mod 2>
						<cfif x EQ 0 and boletas GT 2>
							<tr><td height="40px">&nbsp;</td></tr>	
						</cfif>
						<tr><td colspan="7">#Encabezado#</td></tr>
						<cfset lineaslleva = 9>
						<cfset lineaspagina = lineaspagina+lineaslleva>
						<cfset boletas = boletas+1>	
					<cfelseif CONTADOR EQ lineasEmp>
						<cfset continuar = false>
					</cfif>
				</cfif>
			</cfif>
			<!---Fin de si son mas de 11 conceptos---->
			
			<cfset CONTADOR = CONTADOR+1>
			<cfset lineaslleva = lineaslleva+1><!----Linea de c/concepto---->
			<cfset lineaspagina = lineaspagina+1>
			</cfoutput>

			<cfif continuar>
				<!----ETIQUETA DEL PIE DE PAGINA ---->
				<tr><td>&nbsp;</td></tr>
				<cfif len(trim(rsEtiquetaPie.Mensaje)) GT 250>				
					<tr><td colspan="7" width="950" nowrap="nowrap">#Mid(rsEtiquetaPie.Mensaje,1,250)#</td></tr>
				<cfelse>
					<tr>
						<td colspan="7" width="950">#trim(rsEtiquetaPie.Mensaje)#</td>
					</tr>
				</cfif>	
				<cfset lineaslleva = lineaslleva+5>	
				<cfset lineaspagina = lineaspagina+5>			
				<cfset continuar = true>
			
				<cfif lineaspagina GTE 52 and ConceptosPago.CurrentRow NEQ ConceptosPago.RecordCount>
					<cfset lineaspagina = 0>
					<cfset iniciopagina = true>
					<tr><td style="page-break-before:always;"></td></tr>
				<cfelse>
					<!---RELLENAR---->
					<cfif lineaslleva  LT 29 and lineaspagina GT 1>
						<cfset vn_hasta = 29-lineaslleva>					
						<cfloop index="i" from="1" to="#vn_hasta#">
							<cfif lineaspagina GTE 52 and ConceptosPago.CurrentRow NEQ ConceptosPago.RecordCount>
								<tr><td style="page-break-before:always;"></td></tr>
								<cfset lineaspagina = 0>
								<cfset iniciopagina = true>
								<cfbreak>
							</cfif>
							<tr><td>&nbsp;</td></tr>
							<cfset lineaspagina = lineaspagina+1>
						</cfloop>
						<cfif lineaspagina GTE 52 and ConceptosPago.CurrentRow NEQ ConceptosPago.RecordCount>
							<cfset iniciopagina = true>
						</cfif>				
					</cfif>
				</cfif>
			</cfif>		
		</cfoutput>
	</table>
	<cfelse>
		<table width="98%" cellpadding="0" cellspacing="0" align="center">
			<tr><td align="center">------ <cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> ------</td></tr>
		</table>
	</cfif>
</cfsavecontent>
