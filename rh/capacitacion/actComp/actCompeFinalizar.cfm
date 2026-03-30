<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaDeInicio"
	Default="Fecha de Inicio"
	returnvariable="LB_FechaDeInicio"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaDeFin"
	Default="Fecha de Fin"
	returnvariable="LB_FechaDeFin"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaDeCorte"
	Default="Fecha de Corte"
	returnvariable="LB_FechaDeCorte"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ItemsEvaluables"
	Default="Items Evaluables"
	returnvariable="LB_ItemsEvaluables"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_JefesQueEvaluan"
	Default="Jefes que Eval&uacute;an"
	returnvariable="LB_JefesQueEvaluan"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PersonasAEvaluar"
	Default="Personas a Evaluar"
	returnvariable="LB_PersonasAEvaluar"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Ambos"
	Default="Ambos"
	returnvariable="LB_Ambos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Conocimientos"
	Default="Conocimientos"
	returnvariable="LB_Conocimientos"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Habilidades"
	Default="Habilidades"
	returnvariable="LB_Habilidades"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CentrosFuncionalesAsignados"
	Default="Centros Funcionales Asignados"
	returnvariable="LB_CentrosFuncionalesAsignados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoSePuedeHabilitarLaRelacionPorqueNoHayEmpleadosParaEvaluar"
	Default="No se puede habilitar la relaci&oacute;n porque no hay empleados para evaluar."
	returnvariable="MSG_NoSePuedeHabilitarLaRelacionPorqueNoHayEmpleadosParaEvaluar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoSePuedeHabilitarLaRelacionPorqueHayEvaluadoresSinEmpleadosAsignados"
	Default="No se puede habilitar la relaci&oacute;n porque hay evaluadores sin empleados asignados."
	returnvariable="MSG_NoSePuedeHabilitarLaRelacionPorqueHayEvaluadoresSinEmpleadosAsignados"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaHabilitarLaRelacion"
	Default="Desea habilitar la relación?"
	returnvariable="MSG_DeseaHabilitarLaRelacion"/>	
<!--- FIN VARIABLES DE TRADUCCION --->

<cfquery name="rsForm" datasource="#session.DSN#">
	select RHRCdesc,RHRCfdesde,RHRCfhasta,RHRCfcorte,RHRCitems,RHRCestado
	from RHRelacionCalificacion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHRCid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#"> 
</cfquery>
<cfquery name="rsEvaluadores" datasource="#session.DSN#">
	select count(1) as CantEvaluadores
	from RHEvaluadoresCalificacion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHRCid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#"> 
</cfquery>
<cfquery name="rsEmpleados" datasource="#session.DSN#">
	select count(1) as CantEmpleados
	from RHEmpleadosCF
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHRCid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#"> 
</cfquery>

<!--- VERIFICA QUE TODOS LOS EVALUADORES TENGAN ASIGNADOS EMPLEADOS A EVALUAR
	DE LO CONTRARIO NO LA HABILITA --->
<cfset vHabilita = 0>
<cfquery name="rsEvaluadoresA" datasource="#session.DSN#">
	select count(1) as cant
	from RHEvaluadoresCalificacion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and RHRCid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
</cfquery>
<cfquery name="rsEvaluadoresAsig" datasource="#session.DSN#">
	select count(distinct DEidJefe) as cant
	from RHEmpleadosCF
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and RHRCid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#"> 
</cfquery>

<cfif rsEvaluadoresA.cant  NEQ rsEvaluadoresAsig.cant>
	<cfset vHabilita = 2>
<cfelseif rsEmpleados.CantEmpleados EQ 0>	
<!--- SI NO HAY EMPLEADOS A EVALUAR ENTONCES NO PERMITE HABILITAR --->
	<cfset vHabilita = 1>
<cfelse>
	<cfset vHabilita = 0>
</cfif>

<cfoutput>
<table width="85%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr><td>&nbsp;</td></tr>
	<tr>
    	<td>
			<table width="60%" align="center" border="0" cellspacing="2" cellpadding="5">
				<tr>
					<td nowrap><strong>#LB_Descripcion#:</strong>&nbsp; </td>
					<td nowrap>#rsForm.RHRCdesc#</td>
				</tr>
				<tr>
					<td nowrap><strong>#LB_FechaDeInicio#:</strong></td>
					<td nowrap>#LSDateFormat(rsForm.RHRCfdesde,'dd/mm/yyyy')#</td>
				</tr>
				<tr>
					<td nowrap><strong>#LB_FechaDeFin#:</strong></td>
					<td nowrap>#LSDateFormat(rsForm.RHRCfhasta,'dd/mm/yyyy')#</td>
				</tr>
				<tr>
					<td nowrap><strong>#LB_FechaDeCorte#:</strong></td>
					<td nowrap>#LSDateFormat(rsForm.RHRCfcorte,'dd/mm/yyyy')#</td>
				</tr>
				<tr>
					<td nowrap><strong>#LB_ItemsEvaluables#:</strong></td>
					<td nowrap>
						<cfswitch expression="#rsForm.RHRCitems#">
							<cfcase value="A">#LB_Ambos#</cfcase>
							<cfcase value="C">#LB_Conocimientos#</cfcase>
							<cfcase value="H">#LB_Habilidades#</cfcase>
						</cfswitch>
					</td>
				</tr>
				<tr>
					<td nowrap><strong>#LB_JefesQueEvaluan#:</strong></td>
					<td nowrap>#rsEvaluadores.CantEvaluadores#</td>
				</tr>
				<tr>
					<td nowrap><strong>#LB_PersonasAEvaluar#:</strong></td>
					<td nowrap>#rsEmpleados.CantEmpleados#</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td>
			
			<form action="actCompetencias.cfm" method="post" name="form0">
				<input type="hidden" name="SEL" value="">
				<input type="hidden" name="RHRCid" value="<cfoutput>#form.RHRCid#</cfoutput>">
				<input type="hidden" name="Habilita" 
					value="#vHabilita#">
				<cfif isdefined('rsForm') and rsForm.recordCount GT 0 and rsForm.RHRCestado EQ 0>
					<cf_botones values="Anterior,Habilitar" names="Anterior,BTNHABILITAR" tabindex="1">
				<cfelse>
					<cf_botones values="Anterior" names="Anterior" tabindex="1">
				</cfif>				
				
			</form>	
		</td>
	</tr>	
	<tr><td>&nbsp;</td></tr>		
</table>
</cfoutput>
<script language="javascript" type="text/javascript">
	function funcAnterior(){
		document.form0.SEL.value = "5";
		return true;
	}
	function funcBTNHABILITAR(){
		var habilita = document.form0.Habilita.value;
		if (habilita == 0 && confirm('<cfoutput>#MSG_DeseaHabilitarLaRelacion#</cfoutput>')){
			document.form0.action = "actCompeFinalizar_sql.cfm";
			return true;
		}else if (habilita == 1){
			alert('<cfoutput>#MSG_NoSePuedeHabilitarLaRelacionPorqueNoHayEmpleadosParaEvaluar#</cfoutput>');
			return false;
		}else if (habilita == 2){
			alert('<cfoutput>#MSG_NoSePuedeHabilitarLaRelacionPorqueHayEvaluadoresSinEmpleadosAsignados#</cfoutput>');
			return false;
		
		}
	}	
</script>