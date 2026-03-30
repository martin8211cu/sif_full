

<cfquery datasource="#session.dsn#" name="rsForm_OBPO">
	select oo.Ecodigo
	     , oo.OBPid
	     , oo.Ocodigo
	     , oo.BMUsucodigo
	     , oo.ts_rversion
	
	  from OBproyectoOficinas oo
	 where oo.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" null="#Len(form.Ecodigo) Is 0#">
	   and oo.OBPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.obras.OBPid#">
	   and oo.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#" null="#Len(form.Ocodigo) Is 0#">

</cfquery>

<cfoutput>
<form name="form_OBPO" id="form_OBPO" method="post" action="OBproyectoOficinas_sql.cfm">
	<table summary="Tabla de entrada">
		<tr>
			<td colspan="2" class="subTitulo">
				Oficinas perimitidas dentro de un proyecto
			</td>
		</tr>

		<cfquery datasource="#session.dsn#" name="rsOBP">
			select OBPid, OBPcodigo, OBPdescripcion, PCEcatidObr, CFformatoPry
			  from OBproyecto
			 where OBPid = #session.obras.OBPid#
		</cfquery>
		<tr>
			<td valign="top">
				<strong>Proyecto</strong>
			</td>
			<td valign="top">
				<strong>#rsOBP.OBPcodigo# - #rsOBP.OBPdescripcion#</strong>
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Oficina</strong>
			</td>
			<td valign="top">

				<cf_conlis
					Campos="Ocodigo, Oficodigo, Odescripcion"
					Desplegables="N,S,S"
					Modificables="N,S,N"
					Size="0,10,40"

					traerInicial = "#rsForm_OBPO.Ocodigo NEQ ""#"
					traerFiltro = "Ocodigo=#rsForm_OBPO.Ocodigo#" 

					Title="Lista de Oficinas"
					Tabla="Oficinas ofi"
					Columnas="Ocodigo, Oficodigo, Odescripcion"
					Filtro="Ecodigo = #session.Ecodigo#"
					Desplegar="Oficodigo, Odescripcion"
					Etiquetas="Codigo,Descripción"
					filtrar_por="Oficodigo, Odescripcion"
					Formatos="S,S"
					Align="left,left"

					Asignar="Ocodigo, Oficodigo, Odescripcion"
					Asignarformatos="S,S,S"
					MaxRowsQuery="200"
					form="form_OBPO"
				/>										
			</td>
		</tr>

		<tr>
			<td colspan="2" class="formButtons">
			<cfif rsForm_OBPO.RecordCount>
				<cf_botones  regresar='OBproyecto.cfm?_' modo='CAMBIO'
							form="form_OBPO"
				>
			<cfelse>
				<cf_botones  regresar='OBproyecto.cfm?_' modo='ALTA'
							form="form_OBPO"
				>
			</cfif>
			</td>
		</tr>
	</table>
	<input type="hidden" name="Ecodigo" value="#HTMLEditFormat(rsForm_OBPO.Ecodigo)#">
	<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(rsForm_OBPO.BMUsucodigo)#">

	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
		artimestamp="#rsForm_OBPO.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">

</form>
<cf_qforms form="form_OBPO" objForm="LobjQForm_OBPO">
	<cf_qformsRequiredField args="Ocodigo, Código Oficina">
</cf_qforms>
</cfoutput>

