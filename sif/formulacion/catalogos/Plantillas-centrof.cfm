<cfparam name="CFid" default="">
<cfparam name="CFdescripcion" default="">
<cfparam name="CFcodigo" default="">
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<table border="0" cellpadding="1" cellspacing="1" align="center" width="100%">
<tr>
	<td colspan="2" align="center">
		<form action="Plantillas-sql.cfm" method="post" name="formPlantillaCentros">
			<input type="hidden" name="tab"    value="<cfoutput>#form.tab#</cfoutput>"/>
			<table border="0" cellpadding="1" cellspacing="1" align="center">
				<tr>
					<td>
						Centro Funcional:
					</td>
					<td>
					<cf_conlis
						Campos="CFid,CFcodigo,CFdescripcion"
						tabindex="1"
						Desplegables="N,S,S"
						Modificables="N,S,N"
						form="formPlantillaCentros"
						Size="0,15,35"
						Title="Lista de Centros Funcionales"
						Tabla="CFuncional cf"
						Columnas="CFid,CFcodigo,CFdescripcion"
						Filtro="cf.Ecodigo = #Session.Ecodigo# and not exists(select 1 from FPDCentrosF a where a.CFid = cf.CFid and a.FPEPid = #plantilla.FPEPid#) order by CFcodigo,CFdescripcion"
						Desplegar="CFcodigo,CFdescripcion"
						Etiquetas="C&oacute;digo,Descripci&oacute;n"
						filtrar_por="CFcodigo,CFdescripcion"
						Formatos="S,S"
						Align="left,left"
						Asignar="CFid,CFcodigo,CFdescripcion"
						Asignarformatos="I,S,S"/>
					</td>
					</tr>
					<tr>
					<td colspan="2" align="center">
						<input type="hidden" name="FPEPid" value="<cfoutput>#plantilla.FPEPid#</cfoutput>"/>
						<input type="checkbox" name="includeAll" value="1" /> Incluir Dependencias
						<input type="submit" name="btnAgregarCentro" value="Agregar Centro" class="btnGuardar" />
					</td>
				</tr>
			</table>
		</form>
		<cf_qforms form="formPlantillaCentros" objForm="objPlantillaCentros">
			<cf_qformsRequiredField name="CFcodigo" 	 description="Centro Funcional">
		</cf_qforms>
	</td>
</tr>
<tr>
	<td width="100%" style="border:inset">
		<form action="Plantillas-sql.cfm" method="post" name="formCentrosF">
			<input type="hidden" name="FPEPid" value="<cfoutput>#plantilla.FPEPid#</cfoutput>"/>
			<input type="hidden" name="tab"    value="<cfoutput>#form.tab#</cfoutput>"/>
			
			<cf_dbfunction name="to_char"	args="a.FPDCFid"  returnvariable="FPDCFid">
		<cfquery name="rsCentrosF" datasource="#session.dsn#">
			select a.FPDCFid, a.FPEPid, b.CFcodigo, b.CFdescripcion,
			case when (select count(1) from FPDEstimacion ed inner join FPEEstimacion ee on ee.FPEEid = ed.FPEEid where ee.CFid = a.CFid and ed.FPEPid = a.FPEPid and ee.FPEEestado <> 7) > 0 or a.CFid = #plantilla.CFid# then '' else 
			'<input name="imageFieldCF" value="'#_Cat##PreserveSingleQuotes(FPDCFid)##_Cat#'"type="image" src="/cfmx/sif/imagenes/Borrar01_S.gif" width="16" height="16" border="0" onclick="return eliminarCentro(this);">' end as borrar
			from FPDCentrosF a
				inner join CFuncional b
					on b.CFid = a.CFid
			where Ecodigo = #session.Ecodigo# and  a.FPEPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#plantilla.FPEPid#">
			<cfif isdefined('form.filtro_CFcodigo')and len(trim(form.filtro_CFcodigo))>
				and rtrim(upper(b.CFcodigo)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#rtrim(Ucase(form.filtro_CFcodigo))#%">
			</cfif>	
			<cfif isdefined('form.filtro_CFdescripcion')and len(trim(form.filtro_CFdescripcion))>
				and rtrim(upper(b.CFdescripcion)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#rtrim(Ucase(form.filtro_CFdescripcion))#%">
			</cfif>	
		</cfquery>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
			query="#rsCentrosF#" 
			conexion="#session.dsn#"
			desplegar="CFcodigo, CFdescripcion,Borrar"
			etiquetas="Código del Centro Funcional, Descripción"
			formatos="S,S,US"
			mostrar_filtro="true"
			formName="formCentrosF"
			align="left,left,left"
			checkboxes="N"
			ira="Plantillas.cfm?FPEPid=#plantilla.FPEPid#&tab=2"
			keys="FPDCFid"
			usaAJAX = "true"
			PageIndex="2"
			incluyeForm = "false"
			showLink = "false">
		</cfinvoke>
	</form>
	</td>
</tr>
</table>
<script language="javascript1.2" type="text/javascript">
	function eliminarCentro(a){
		if (confirm('¿Desea Eliminar el Centro Funcional?'))
		{
			document.formCentrosF.action = "Plantillas-sql.cfm?btnEliminarCentro=true&FPDCFid="+a.value;
			document.formCentrosF.submit();
		}
		else
			return false;
	}
</script>