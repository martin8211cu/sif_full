<cfparam name="FPCCID" default="-1">
<cfif len(trim(FPCCID)) eq 0>
	<cfset FPCCID = -1>
</cfif>
<table border="0" cellpadding="1" cellspacing="1" align="center" width="100%">
<tr>
	<td colspan="2" align="center">
		<form action="Plantillas-sql.cfm" method="post" name="formPlantillaConceptos">
			<input type="hidden" name="tab" 		value="<cfoutput>#form.tab#</cfoutput>">
			<table border="0" cellpadding="1" cellspacing="1" align="center">
				<tr>
					<td>
						Clasificaciones:
					</td>
					<td>
						<cf_ConceptoGatosIngresos form="formPlantillaConceptos" titulo="Clasificaciones de Ingresos y Egresos" name="FPCCid" value="#FPCCID#" popup="true" tabindex="1" filtro="not exists(select 1 from FPDPlantilla where FPCCid = FPCatConcepto.FPCCid and FPEPid = #plantilla.FPEPid#) and FPCCtipo = '#plantilla.FPCCtipo#' and FPCCconcepto = '#plantilla.FPCCconcepto#'">
					</td>
					<td>
						<input type="hidden" name="FPEPid" value="<cfoutput>#plantilla.FPEPid#</cfoutput>"/>
						<input type="submit" name="btnAgregarConcep" value="Agregar Clasificaciones" class="btnGuardar" />
					</td>
				</tr>
			</table>
		</form>
	</td>
</tr>
<tr>
	<td width="50%" style="border:inset" valign="top">
		<cfquery name="rsCategorias" datasource="#session.dsn#">
			select a.FPDPid, a.FPEPid, b.FPCCid, b.FPCCcodigo, b.FPCCdescripcion,
			case when (select count(1) from FPDEstimacion ed inner join FPEEstimacion ee on ee.FPEEid = ed.FPEEid where ed.FPCCid = a.FPCCid and ed.FPEPid = #plantilla.FPEPid# and ee.FPEEestado <> 7) > 0 then '' else 
			'<input name="imageFieldC" type="image" src="/cfmx/sif/imagenes/Borrar01_S.gif" width="16" height="16" border="0" onclick="javascript:eliminarConcepto();">' end as borrar
			from FPDPlantilla a
				inner join FPCatConcepto b
					on b.FPCCid = a.FPCCid
			where Ecodigo = #session.Ecodigo# and a.FPEPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#plantilla.FPEPid#">
			<cfif isdefined('form.filtro_FPCCcodigo')and len(trim(form.filtro_FPCCcodigo))>
				and rtrim(upper(FPCCcodigo)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#rtrim(Ucase(form.filtro_FPCCcodigo))#%">
			</cfif>	
			<cfif isdefined('form.filtro_FPCCdescripcion')and len(trim(form.filtro_FPCCdescripcion))>
				and rtrim(upper(FPCCdescripcion)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#rtrim(Ucase(form.filtro_FPCCdescripcion))#%">
			</cfif>
			order by b.FPCCcodigo, b.FPCCdescripcion
		</cfquery>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
			query="#rsCategorias#" 
			conexion="#session.dsn#"
			desplegar="FPCCcodigo, FPCCdescripcion,Borrar"
			etiquetas="Código, Descripción"
			formatos="S,S,US"
			mostrar_filtro="true"
			formName="formCategoria"
			align="left,left,left"
			checkboxes="N"
			ira="Plantillas.cfm?FPEPid=#plantilla.FPEPid#&tab=1"
			keys="FPDPid">
		</cfinvoke>
	</td>
	<td valign="top" style="border:inset">
		<cfset seleccionado = -1>
		<cfif isdefined('form.FPCCid') and len(trim(form.FPCCid))>
			<cfquery datasource="#session.dsn#" name="rsQuery">
				select 	FPCCid,FPCCcodigo, FPCCdescripcion, FPCCconcepto, FPCCTablaC,
				(select count(1) from FPCatConcepto as hijos where hijos.Ecodigo = #session.Ecodigo# and hijos.FPCCidPadre = FPCatConcepto.FPCCid) as cantHijos
				from FPCatConcepto FPCatConcepto
				where Ecodigo = #session.Ecodigo# and FPCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPCCid#">
				order by FPCCcodigo, FPCCdescripcion
			</cfquery>
			<cfset seleccionado = form.FPCCid>
		<cfelse>
			<cfquery datasource="#session.dsn#" name="rsQuery">
				select 	FPCCid,FPCCcodigo, FPCCdescripcion, FPCCconcepto, FPCCTablaC,
				(select count(1) from FPCatConcepto as hijos where hijos.Ecodigo = #session.Ecodigo# and hijos.FPCCidPadre = FPCatConcepto.FPCCid) as cantHijos
				from FPCatConcepto FPCatConcepto
				where 0 != 0
				order by FPCCcodigo, FPCCdescripcion
			</cfquery>
		</cfif>
		<cf_ConceptoGatosIngresos name="FPCCid_Conc" query="#rsQuery#" tabindex="2" mostrarConceptos="true" desIrA="true" selecionadoCAT="#seleccionado#">
	</td>
</tr>
</table>
<cf_qforms form="formPlantillaConceptos" objForm="objPlantillaConceptos">
	<cf_qformsRequiredField name="FPCCid" 	 description="Categoría">
	<cf_qformsRequiredField name="FPEPid"    description="Id Encabezado">
</cf_qforms>
<script language="javascript1.2" type="text/javascript">
	
	function eliminarConcepto(){
		if (confirm('¿Desea Eliminar la Clasificacion?')){
			document.formCategoria.action = "Plantillas-sql.cfm?btnEliminarConcep=true";
		}
	}
	
</script>
