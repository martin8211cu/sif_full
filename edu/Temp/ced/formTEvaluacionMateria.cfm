<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif #form.modo# EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- ==================== --->
<!---       Consultas      --->
<!--- ==================== --->

<!--- 1. Lineas de detalle a pintar --->
<cfset form.EPcodigo = 50 >
<cfquery name="rsLineas" datasource="#session.DSN#">
	select convert(varchar, EPcodigo) as EPcodigo, convert(varchar, EPCcodigo) as EPCcodigo, EPCnombre, EPCporcentaje 
	from EvaluacionPlanConcepto 
	<cfif isdefined("form.EPcodigo") and form.EPcodigo neq "" >	
		where EPcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPcodigo#">
	</cfif>
</cfquery>

<!--- 2. Combo de Planes de Evaluacion --->
<cfquery name="rsPlan" datasource="#session.DSN#">
	select EPcodigo, EPnombre 
	from EvaluacionPlan 
	where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>

<script language="JavaScript1.2" type="text/javascript">
	function cambiar_plan(value){
		if (value != "") {
			document.all['EVtabla'].src="/educ/ced/plan/tablaEvaluacion.cfm?EPcodigo=" + value;
		}
	}
</script>

<form action="SQLEvaluacionConcepto.cfm" method="post" name="periodoevaluacion" onSubmit="MM_validateForm('ECnombre','','R');return document.MM_returnValue">
		<table width="100%" border="0" cellpadding="1" cellspacing="1">
			<tr>
				<td align="left" width="10%" nowrap>Plan de Evaluci&oacute;n:&nbsp;</td>
				<td align="left" colspan="2">
					<select name="EPcodigo" onChange="javascript:cambiar_plan(this.value);">
						<option value="">Seleccionar Plan...</option>
						<cfoutput query="rsPlan">					
							<cfif modo EQ 'ALTA'>
								<option value="#rsPlan.EPcodigo#">#rsPlan.EPnombre#</option>
							<!---
							<cfelseif modo NEQ 'ALTA'>
								<option value="#rsPlan.EPcodigo#" <cfif #rsFormDetalle.ECcodigo# EQ #rsConceptos.ECcodigo#>selected</cfif>  >#rsConceptos.ECnombre#</option>
								--->
							</cfif>
						</cfoutput>						
					</select>
				</td>
			</tr>

			<!--- Aqui se genera la tabla de evalucion segun el plan seleccionado --->	
			<tr>
				<td colspan="3" align="center">
					<div id="divTabla">
						<table>
						</table>
					</div>
				</td>
			</tr>			

			<tr>
				<td colspan="3"><iframe height="0" width="0" name="EVtabla" frameborder="0"></iframe></td>
			</tr>				
		</table>
</form>