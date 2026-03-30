<cfquery datasource="#session.dsn#" name="rsForm">
	select 
			d.OBTPid, 	tp.OBTPcodigo,	tp.OBTPdescripcion
		,	d.OBPid, 	p.OBPcodigo,	p.OBPdescripcion
		,	d.OBOid, 	o.OBOcodigo,	o.OBOdescripcion
		,	d.OBEid, 	e.OBEcodigo,	e.OBEdescripcion
		,	d.OBDdescripcion
		,	d.OBDtexto
		,	d.OBDarchivo
		,	d.OBDbinario
		,	d.ts_rversion
	  from OBdocumentacion d
		left join OBtipoProyecto tp
			on tp.OBTPid = d.OBTPid
		left join OBproyecto p
			on p.OBPid = d.OBPid
		left join OBobra o
			on o.OBOid = d.OBOid
		left join OBetapa e
			on e.OBEid = d.OBEid
	 where d.OBDid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBDid#" null="#Len(form.OBDid) Is 0#">
</cfquery>

<cfif rsForm.recordCount EQ 0>
	<cfquery datasource="#session.dsn#" name="rsPARAM">
		select tp.OBTPid,  tp.OBTPcodigo,  tp.OBTPdescripcion
			,	p.OBPid, 	p.OBPcodigo,	p.OBPdescripcion
			,	o.OBOid, 	o.OBOcodigo,	o.OBOdescripcion
			,	e.OBEid, 	e.OBEcodigo,	e.OBEdescripcion
		  from OBtipoProyecto tp
			left join OBproyecto p
				on p.OBPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.obras.OBD.OBPid#" null="#Len(session.obras.OBD.OBPid) Is 0#">
			left join OBobra o
				on o.OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.obras.OBD.OBOid#" null="#Len(session.obras.OBD.OBOid) Is 0#">
			left join OBetapa e
				on e.OBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.obras.OBD.OBEid#" null="#Len(session.obras.OBD.OBEid) Is 0#">
		 where tp.OBTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.obras.OBD.OBTPid#" null="#Len(session.obras.OBD.OBTPid) Is 0#">
	</cfquery>
<cfelse>
	<cfset rsPARAM = rsForm>
</cfif>

<cfoutput>
<Form enctype="multipart/form-data" name="formOBD" id="formOBD" method="post" action="OBdocumentacion_sql.cfm">
	<table summary="Tabla de entrada">
		<tr>
			<td colspan="2" class="subTitulo">
				Mantenimiento a la Documentación
				<cfif rsPARAM.OBTPid EQ "">
				<cfelseif rsPARAM.OBPid EQ "">
					del Tipo de Proyecto
				<cfelseif rsPARAM.OBOid EQ "">
					del Proyecto
				<cfelseif rsPARAM.OBOid EQ "">
					de la Obra
				<cfelse>
					de la Etapa
				</cfif>
			</td>
		</tr>

	<cfif rsPARAM.OBTPid EQ "">
		</table></form>
		<cfreturn>
	</cfif>
		<tr>
			<td valign="top" nowrap="nowrap">
				<strong>Tipo de Proyecto&nbsp;</strong>
			</td>
			<td valign="top">
				<strong>#rsPARAM.OBTPcodigo# - #rsPARAM.OBTPdescripcion#</strong>
			</td>
		</tr>
	<cfif rsPARAM.OBPid NEQ "">
		<tr>
			<td valign="top" nowrap="nowrap">
				<strong>Proyecto&nbsp;</strong>
			</td>
			<td valign="top">
				<strong>#rsPARAM.OBPcodigo# - #rsPARAM.OBPdescripcion#</strong>
			</td>
		</tr>
		<cfif rsPARAM.OBOid NEQ "">
			<tr>
				<td valign="top" nowrap="nowrap">
					<strong>Obra&nbsp;</strong>
				</td>
				<td valign="top">
					<strong>#rsPARAM.OBOcodigo# - #rsPARAM.OBOdescripcion#</strong>
				</td>
			</tr>
			<cfif rsPARAM.OBEid NEQ "">
				<tr>
					<td valign="top" nowrap="nowrap">
						<strong>Etapa&nbsp;</strong>
					</td>
					<td valign="top">
						<strong>#rsPARAM.OBEcodigo# - #rsPARAM.OBEdescripcion#</strong>
					</td>
				</tr>
			</cfif>
		</cfif>
	</cfif>

		<tr><td>&nbsp;</td></tr>
		
		<tr>
			<td valign="top">
				<strong>Descripcion&nbsp;</strong>
			</td>
			<td valign="top">
				<input type="text" name="OBDdescripcion" id="OBDdescripcion" 
						value="#HTMLEditFormat(rsForm.OBDdescripcion)#" 
						size="40" maxlength="40"
						onfocus="this.select()"  
				>
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Texto&nbsp;</strong>
			</td>
			<td valign="top">
				<textarea 	name="OBDtexto" id="OBDtexto"
							style="font-family:Arial, Helvetica, sans-serif;font-size:12px" rows="6" cols="50" 
							onfocus="this.select();"
				>#HTMLEditFormat(rsForm.OBDtexto)#</textarea>
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Archivo&nbsp;</strong>
			</td>
			<td valign="top">
						
				<input type="text" name="OBDarchivo" id="OBDarchivo" 
						value="#HTMLEditFormat(rsForm.OBDarchivo)#" 
						size="40" maxlength="40"
						readonly="yes" tabindex="-1" style="border:solid 1px ##CCCCCC; background:inherit"
				>
			</td>
		</tr>

		<tr>
			<td>
				
			</td>
			<td>
				<input type="file" name="OBDbinario" value="hola" size="30">
			</td>
		</tr>

		<tr>
			<td colspan="2" class="rsFormButtons">
			<cfif rsForm.RecordCount>
				<cf_botones  modo='CAMBIO'	regresar="OBdocumentacion.cfm" include="Download">
			<cfelse>
				<cf_botones  modo='ALTA'	regresar="OBdocumentacion.cfm" >
			</cfif>
			</td>
		</tr>
	</table>
	<a name="etapa"></a>
	<input type="hidden" name="OBTPid" value="#rsPARAM.OBTPid#">
	<input type="hidden" name="OBPid"  value="#rsPARAM.OBPid#">
	<input type="hidden" name="OBOid"  value="#rsPARAM.OBOid#">
	<input type="hidden" name="OBEid"  value="#rsPARAM.OBEid#">

	<input type="hidden" name="OBDid"  value="#form.OBDid#">

	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
		artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">
</rsForm>

<script>
	function fnVerificar()
	{
		var LvarArchivo	= document.formOBD.OBDarchivo.value;
		var LvarBinario	= document.formOBD.OBDbinario.value;
		var LvarTexto	= document.formOBD.OBDtexto.value;

		if (LvarBinario.replace(/\s*/,"") == "")
		{
			if (LvarArchivo.replace(/\s*/,"") != "")
				return;
	
			if (LvarTexto.replace(/\s*/,"") == "")
				this.error = "Debe escribir un Texto o escoger un Archivo de Documentación";
		}
		else
		{
			var LvarPto = LvarBinario.lastIndexOf("\\");
			if (LvarPto < 0) LvarPto = LvarBinario.lastIndexOf("/");
			if (LvarPto < 0) LvarPto = LvarBinario.lastIndexOf(":");

			document.formOBD.OBDarchivo.value = LvarBinario.substr(LvarPto+1);
		}
	}		 
</script>

<cf_QForms Form="formOBD" objForm="LvarQformOBD">
	<cf_QFormsRequiredField args="OBDdescripcion,Descripcion,fnVerificar">
</cf_QForms>

</cfoutput>
