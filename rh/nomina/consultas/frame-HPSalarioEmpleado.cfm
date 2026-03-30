<cfquery name="rsSalarioEmpleado" datasource="#Session.DSN#">
	select 	SEsalariobruto, SEincidencias, SErenta, SEcargasempleado, 
			SEcargaspatrono,  SEdeducciones, SEliquido
	from HSalarioEmpleado 
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
</cfquery>
<cfoutput>
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#Session.DSN#" ecodigo="#session.Ecodigo#" pvalor="785" default="0" returnvariable="UnificaSalarioB"/>

	<cfif rsSalarioEmpleado.RecordCount gt 0 >
		<tr> 
		  <td nowrap class="FileLabel" ><cf_translate  key="LB_Bruto" xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml">Salario Bruto</cf_translate>:&nbsp;</td>
		  <cfif not UnificaSalarioB><td nowrap class="FileLabel" ><cf_translate  key="LB_Incidencias" xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml">Incidencias</cf_translate>:&nbsp;</td></cfif>
		  <td nowrap class="FileLabel" ><cf_translate  key="LB_Renta" xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml">Renta</cf_translate>:&nbsp;</td>
		  <td nowrap class="FileLabel" ><cf_translate  key="LB_CargasEmpleado" xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml">Cargas Empleado</cf_translate>:&nbsp;</td>
		  <td nowrap class="FileLabel" ><cf_translate  key="LB_Deducciones" xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml">Deducciones</cf_translate>:&nbsp;</td>
		  <td nowrap class="FileLabel" ><cf_translate  key="LB_Liquido" xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml">Salario Líquido</cf_translate>:&nbsp;</td>
		</tr>
		<tr>
		  <td nowrap>#rsMoneda.Msimbolo# <cfif not UnificaSalarioB>#LSCurrencyFormat(rsSalarioEmpleado.SEsalariobruto,'none')#<cfelse>#LSCurrencyFormat(rsSalarioEmpleado.SEsalariobruto+rsSalarioEmpleado.SEincidencias,'none')#</cfif></td>
		  <cfif not UnificaSalarioB><td nowrap>#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEincidencias,'none')#</td></cfif>
		  <td nowrap>#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SErenta,'none')#</td>
		  <td nowrap>#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEcargasempleado,'none')#</td>
		  <td nowrap>#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEdeducciones,'none')#</td>
		  <td nowrap>#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEliquido,'none')#</td>
		</tr>
	<cfelse>
		<tr><td colspan="6" align="center"><cf_translate  key="LB_NoHayPagosAsociadosAlEmpleado">No hay Pagos asociados al empleado</cf_translate></td></tr>
	</cfif>	
</cfoutput>