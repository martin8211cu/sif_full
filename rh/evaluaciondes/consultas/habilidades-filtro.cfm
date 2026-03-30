<cfquery name="rsRelEval" datasource="#session.DSN#">
	Select RHEEid,RHEEdescripcion
	from RHEEvaluacionDes
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and PCid = -1
</cfquery>

<form name="formFiltro" method="post" action="habilidades.cfm" onSubmit="javascript: return validaFiltro(this);" style="margin: '0' ">
  	<table width="100%" border="0" class="areaFiltro">
    	<tr>
      		<td width="25%" align="right" nowrap="true"><strong><cf_translate key="LB_RelacionDeEvaluacion">Relaci&oacute;n de Evaluaci&oacute;n</cf_translate>: </strong></td>
			<td width="33%">
				<select name="RHEEid_f" tabindex="1">
					<cfif isdefined('rsRelEval') and rsRelEval.recordCount GT 0>
						<cfoutput query="rsRelEval">
							<option value="#RHEEid#" <cfif isdefined('form.RHEEid_f') and form.RHEEid_f EQ rsRelEval.RHEEid> selected</cfif>>#RHEEdescripcion#</option>
						</cfoutput>
					</cfif>
				</select>
			</td>
      		<td width="42%" rowspan="3" valign="middle" align="center">
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Filtrar"
					Default="Filtrar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Filtrar"/>
				<cfoutput><input name="btnFiltrar" type="submit" id="#BTN_Filtrar#" value="#BTN_Filtrar#" tabindex="2"></cfoutput>
			</td>
    	</tr>
    	<tr>
      		<td align="right"><strong><cf_translate key="LB_Puesto" XmlFile="/rh/generales.xml">Puesto</cf_translate>:</strong></td>
      		<td>
				<cfif isdefined('form.RHPcodigo_f') and form.RHPcodigo_f NEQ ''>
					<cfquery name="rsPuestosFiltro" datasource="#session.DSN#">
						Select coalesce(RHPcodigoext,RHPcodigo) as RHPcodigoext,RHPcodigo as RHPcodigo_f,RHPdescpuesto as RHPdescpuesto_f
						from RHPuestos
						where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and RHPcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo_f#">
					</cfquery>

					<cf_rhpuesto name="RHPcodigo_f" desc="RHPdescpuesto_f" form="formFiltro" query="#rsPuestosFiltro#" tabindex="1">
				<cfelse>
					<cf_rhpuesto name="RHPcodigo_f" desc="RHPdescpuesto_f" form="formFiltro" tabindex="1">
				</cfif>			
			</td>
    	</tr>
    	<tr>
      		<td align="right"><strong><cf_translate key="LB_Empleado" XmlFile="/rh/generales.xml">Empleado</cf_translate>:</strong></td>
      		<td>
				<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0>
					<cfquery name="rsEmpBuscar" datasource="#Session.DSN#">
						select convert(varchar, b.DEid) as DEid,
							   {fn concat(b.DEnombre,{fn concat(' ',{fn concat(b.DEapellido1,{fn concat(' ',b.DEapellido2)})})})} as NombreEmp,
							   b.DEidentificacion,
							   b.NTIcodigo
						from DatosEmpleado b
						where b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
						and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					</cfquery>
					<cf_rhempleado size="70" form="formFiltro" query="#rsEmpBuscar#" tabindex="1"> 
				<cfelse>
					<cf_rhempleado size="70" form="formFiltro" tabindex="1"> 
				</cfif>			
			</td>
    	</tr>
		<cfif isdefined('form.btnFiltrar') and isdefined('form.RHEEid_f') and form.RHEEid_f NEQ ''>
			<tr><td colspan="3">&nbsp;</td></tr>		
		</cfif>
  	</table>
</form>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeSeleccionarUnaRelaciondeEvaluacion"
	Default="Debe seleccionar una relación de Evaluación"
	returnvariable="MSG_DebeSeleccionarUnaRelaciondeEvaluacion"/>
<script language="javascript" type="text/javascript">
	function validaFiltro(f){
		if(f.RHEEid_f.value == ''){
			alert('<cfoutput>#MSG_DebeSeleccionarUnaRelaciondeEvaluacion#</cfoutput>');
			return false;
		}
		
		return true;
	}
</script>