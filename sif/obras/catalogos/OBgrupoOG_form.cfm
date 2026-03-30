<cfquery datasource="#session.dsn#" name="rsForm">
	select OBGid
	     , OBGcodigo
	     , OBGdescripcion
	     , OBGtexto
	     , PCEcatidOG
	     , BMUsucodigo
	     , ts_rversion
		 ,
		 	(
				select count(1)
				  from OBgrupoOGvalores
				 where OBGid = g.OBGid
			) as Detalles
	  from OBgrupoOG g
	 where OBGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBGid#" null="#Len(form.OBGid) Is 0#">

</cfquery>

<cfoutput>
<form name="form1" id="form1" method="post" action="OBgrupoOG_sql.cfm">
	<table summary="Tabla de entrada">
		<tr>
			<td colspan="2" class="subTitulo">
				Mantenimiento al Grupo de Objetos de Gasto
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Codigo Grupo</strong>
			</td>
			<td valign="top">
				<input 	type="text" 
						name="OBGcodigo" id="OBGcodigo"
						value="#rsForm.OBGcodigo#"
						maxlength="10"
						size="10"
				 >
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Descripcion</strong>
			</td>
			<td valign="top">
				<input 	type="text" 
						name="OBGdescripcion" id="OBGdescripcion"
						value="#rsForm.OBGdescripcion#"
						maxlength="40"
						size="40"
				 >
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Catálogo de Objeto de Gasto</strong>
			</td>
			<td valign="top">
				<cf_conlis
					Title="Lista de Catálogos"
					readonly="#rsForm.Detalles GT 0#"
					Campos="PCEcatidOG=PCEcatid, PCEcodigo, PCEdescripcion"
					Desplegables="N,S,S"
					Modificables="N,S,N"
					Size="0,10,40"

					traerInicial="#rsForm.PCEcatidOG NEQ ''#"  
					traerFiltro="PCEcatid = #rsForm.PCEcatidOG#"  

					Columnas="PCEcatid, PCEcodigo, PCEdescripcion"
					Tabla="PCECatalogo"
					Filtro="CEcodigo = #session.CEcodigo# order by PCEcodigo"
					Desplegar="PCEcodigo, PCEdescripcion"
					Etiquetas="Código,Descripción"
					Formatos="S,S"
					Align="left,left"

					Asignar="PCEcatidOG, PCEcodigo, PCEdescripcion"
					Asignarformatos="S,S,S"
					MaxRowsQuery="200"
					form="form1"
				/>										
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Texto</strong>
			</td>
			<td valign="top">
				<textarea 	name="OBGtexto" id="OBGtexto"
							rows="6" cols="50" 
							style="font-family:Arial, Helvetica, sans-serif;font-size:12px" 
							onfocus="this.select();"
				>#HTMLEditFormat(rsForm.OBGtexto)#</textarea>
			</td>
		</tr>

		<tr>
			<td colspan="2" class="formButtons">
			<cfif rsForm.RecordCount>
				<cf_botones  regresar='OBgrupoOG.cfm' modo='CAMBIO'>
			<cfelse>
				<cf_botones  regresar='OBgrupoOG.cfm' modo='ALTA'>
			</cfif>
			</td>
		</tr>
	</table>

	<input type="hidden" name="OBGid" value="#HTMLEditFormat(rsForm.OBGid)#">
	<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(rsForm.BMUsucodigo)#">

	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
		artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">

</form>
<cf_qforms form="form1" objForm="LobjQForm">
	<cf_qformsRequiredField args="OBGcodigo, Código del Grupo Objeto de Gasto">
	<cf_qformsRequiredField args="OBGdescripcion, Descripcion del Grupo Objeto de Gasto">
	<cf_qformsRequiredField args="PCEcodigo, Catálogo para Objeto de Gasto">
</cf_qforms>
<cfif rsForm.recordCount NEQ 0>
	<cfquery datasource="#session.dsn#" name="rsLista">
		select PCDcatidOG
		  from OBgrupoOGvalores g
		 where OBGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBGid#" null="#Len(form.OBGid) Is 0#">
	</cfquery>
	<form name="formLista" method="post" action="OBgrupoOG_sql.cfm">
		<input type="hidden" name="OBGid" value="#HTMLEditFormat(rsForm.OBGid)#">
		<input type="hidden" name="PCDcatidOGlist" value="#HTMLEditFormat(ValueList(rsLista.PCDcatidOG))#">
		<cfinvoke component="sif.Componentes.pListas" method="pLista"
			tabla="
					PCDCatalogo v
						left join OBgrupoOGvalores d
							on d.PCDcatidOG = v.PCDcatid
					"
			columnas="v.PCDcatid, d.PCDcatidOG, v.PCDvalor, v.PCDdescripcion"
			filtro="v.PCEcatid = #rsForm.PCEcatidOG# order by v.PCDvalor"
			desplegar="PCDvalor,PCDdescripcion"
			etiquetas="Código,Descripcion del Objeto Gasto"
			formatos="S,S"
			align="left,left"
			ira="OBgrupoOG_sql.cfm"
			form_method="post"
			incluyeForm="false"
			keys="PCDcatid"
			showLink="no"
			checkBoxes="S"
			checkedcol="PCDcatidOG"
			botones="Modificar_Valores,Agregar_Todos,Eliminar_Todos"
			formName="formLista"
			mostrar_filtro="yes"
			filtrar_automatico="yes"
			width="70%"
		/>
	</form>
</cfif>
</cfoutput>

