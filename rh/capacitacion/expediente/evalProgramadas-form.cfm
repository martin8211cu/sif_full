<cfset modoCEvaluaciones= "ALTA">
<cfif isdefined("form.RHEEid") and len(trim(form.RHEEid))>
	<cfset modoCEvaluaciones = "CAMBIO">
</cfif>
<cfif modoCEvaluaciones neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
		select a.RHEEid, a.RHEEdescripcion, a.RHEEfecha, a.RHEEfhasta, a.RHEEfdesde, a.PCid, a.ts_rversion
		from RHEEvaluacionDes a
		
		inner join RHListaEvalDes b
		on a.Ecodigo=b.Ecodigo
		and b.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		
		where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.RHEEestado=5
		and a.RHEEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
	</cfquery>
</cfif>

<cfquery name="cuestionarios" datasource="#session.DSN#">
	select a.PCid, a.PCnombre, a.PCdescripcion, 1 as agrupador
	from PortalCuestionario a
	  inner join RHEvaluacionCuestionarios b
		on a.PCid = b.PCid
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<form name="formCEvaluaciones" action="evalProgramadas-sql.cfm" method="post">
	<table width="100%" cellpadding="2" cellspacing="0">
		<cfoutput>
		<input type="hidden" name="DEid" value="#form.DEid#">
		<input type="hidden" name="RHPcodigo" value="#trim(puesto.RHPcodigo)#">
		<input type="hidden" name="tab" value="7">
		<tr>
			<td align="right"><strong><cf_translate key="LB_Descripcion">Descripción</cf_translate>:&nbsp;</strong></td>
			<td><input type="text" name="RHEEdescripcion" size="60" maxlength="80" value="<cfif modoCEvaluaciones neq 'ALTA'>#trim(data.RHEEdescripcion)#</cfif>" onfocus="this.select();" ></td>
		</tr>
		<tr>
			<td align="right"><strong><cf_translate key="LB_Desde">Desde</cf_translate>:&nbsp;</strong></td>
			<td><table><tr>
			<td>
				<cfif modoCEvaluaciones neq 'ALTA'>
					<cf_sifcalendario conexion="#session.DSN#" form="formCEvaluaciones" name="RHEEfdesde" value="#LSDateformat(data.RHEEfdesde,'dd/mm/yyyy')#">
				<cfelse>
					<cf_sifcalendario conexion="#session.DSN#" form="formCEvaluaciones" name="RHEEfdesde" value="">
				</cfif>
			</td>
			<td>&nbsp;</td>
			<td align="right"><strong><cf_translate key="LB_Hasta">Hasta</cf_translate>:&nbsp;</strong></td>
			<td>
				<cfif modoCEvaluaciones neq 'ALTA'>
					<cf_sifcalendario conexion="#session.DSN#" form="formCEvaluaciones" name="RHEEfhasta" value="#LSDateFormat(data.RHEEfhasta,'dd/mm/yyyy')#">
				<cfelse>
					<cf_sifcalendario conexion="#session.DSN#" form="formCEvaluaciones" name="RHEEfhasta" value="">
				</cfif>
			</td>
			</tr></table></td>
		</tr>
		</cfoutput>
		
		  <tr>
			<td colspan="1" align="right"><strong><cf_translate key="LB_Tipo_de_evaluacion">Tipo de evaluación</cf_translate>:&nbsp;</strong></td>
			<td colspan="2">	
				<select name="PCid" id="PCid">
					<option value="-1" style="font-style:italic" <cfif isdefined("data.PCid") and data.PCid EQ -1>selected</cfif>>Cuestionarios por habilidad</option>
					<option value="0" style="font-style:italic"  <cfif isdefined("data.PCid") and data.PCid EQ 0>selected</cfif>>Cuestionarios por conocimiento</option>
					   <cfoutput query="cuestionarios" group="agrupador">
							<optgroup label="Cuestionario específico">
								<cfoutput>
									<option value="#cuestionarios.PCid#" <cfif isdefined("data.PCid") and data.PCid EQ cuestionarios.PCid>selected</cfif>>#cuestionarios.PCdescripcion#</option>
								</cfoutput>
							</optgroup>
					   </cfoutput>
				 </select>
			  </td>
		  </tr>
						
		<cfoutput>
		<!--- Botones --->
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2" align="center">
		<cfif modoCEvaluaciones eq 'ALTA'>
			<input type="submit" name="AltaEval" value="<cf_translate key='BTN_Agregar'>Agregar</cf_translate>" onclick="javascript: habilitarValidacion();">
			<input type="reset" name="Limpiar" value="<cf_translate key='BTN_Limpiar'>Limpiar</cf_translate>">
		<cfelse>
			<input type="submit" name="CambioEval" value="<cf_translate key='BTN_Modificar'>Modificar</cf_translate>" onclick="habilitarValidacion();">
			<input type="submit" name="BajaEval" value="<cf_translate key='BTN_Eliminar'>Eliminar</cf_translate>" onclick="if ( confirm('<cf_translate key="LB_Desea_eliminar_el_registro?">Desea eliminar el registro?</cf_translate>') ){deshabilitarValidacion(); return true;} return false;">
			<input type="submit" name="NuevoEval" value="<cf_translate key='BTN_Nuevo'>Nuevo</cf_translate>" onclick="deshabilitarValidacion();">
		</cfif>
		</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>

	</table>

	<cfif modoCEvaluaciones neq 'ALTA'>
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="RHEEid" value="#data.RHEEid#">
	</cfif>
	</cfoutput>

</form>


<script language="JavaScript" type="text/javascript">	
	qFormAPI.errorColor = "#FFFFCC";
	objForm7 = new qForm("formCEvaluaciones");

	objForm7.RHEEdescripcion.required = true;
	objForm7.RHEEdescripcion.description="<cf_translate key='LB_Descripcion'>Descripción</cf_translate>";				
	objForm7.RHEEfdesde.required = true;
	objForm7.RHEEfdesde.description="<cf_translate key='LB_Fecha_de_inicio'>Fecha de inicio</cf_translate>";				
	objForm7.RHEEfhasta.required= true;
	objForm7.RHEEfhasta.description="<cf_translate key='LB_Fecha_hasta'>Fecha hasta</cf_translate>";	

	function habilitarValidacion(){
		objForm7.RHEEdescripcion.required = true;
		objForm7.RHEEfdesde.required = true;
		objForm7.RHEEfhasta.required= true;
	}

	function deshabilitarValidacion(){
		objForm7.RHEEdescripcion.required = false;
		objForm7.RHEEfdesde.required = false;
		objForm7.RHEEfhasta.required= false;
	}	
</script>
