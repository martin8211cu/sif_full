
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_EliminarAnexo" 	default="Eliminar Anexo"
	returnvariable="LB_EliminarAnexo" xmlfile="anexo-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_DescargarAnexo" 	default="Descargar Anexo"
	returnvariable="LB_DescargarAnexo" xmlfile="anexo-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_CargarSoinAnexos" 	default="Cargar con SOINanexos"
	returnvariable="LB_CargarSoinAnexos" xmlfile="anexo-form.xml"/>
<cfquery name="rsAnexoXml" datasource="#session.DSN#">
	select 	AnexoId,
			ts_rversion,
			<cf_dbfunction name="length" args="AnexoDef"> as len_XML,
			'*' as AnexoEof,
			<cf_dbfunction name="length" args="AnexoXLS"> as len_XLS
	from Anexoim
		where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">
</cfquery>
<cfif rsAnexoXml.len_XML EQ "3">
	<cfquery name="rsAnexoXml" datasource="#session.DSN#">
		select 	AnexoId,
				ts_rversion,
				<cf_dbfunction name="length" args="AnexoDef">as len_XML,
				AnexoDef as AnexoEof,
				<cf_dbfunction name="length" args="AnexoXLS"> as len_XLS
		from Anexoim
			where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">
	</cfquery>
</cfif>
<cfif rsAnexoXml.AnexoId EQ "">
	<cfquery name="rsAnexoXml" datasource="#session.DSN#">
		insert into Anexoim
		(
			AnexoId,
			Ecodigo
		)
		values(
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">,
			#session.Ecodigo#
		)
	</cfquery>
	<cfquery name="rsAnexoXml" datasource="#session.DSN#">
		select 	AnexoId,
				ts_rversion,
				<cf_dbfunction name="length" args="AnexoDef"> as len_XML,
				'*' as AnexoEof,
				<cf_dbfunction name="length" args="AnexoXLS"> as len_XLS
		from Anexoim
			where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">
	</cfquery>
</cfif>
<cfinvoke
	component="sif.Componentes.DButils"
	method="toTimeStamp"
	returnvariable="tsurl">
	<cfinvokeargument name="arTimeStamp" value="#rsAnexoXml.ts_rversion#"/>
</cfinvoke>
<form name="formAnexoMain" id="formAnexoMain" method="post" action="anexo-form-apply.cfm">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td colspan="10">
				<cfoutput>
					<iframe width="100%" height="288" src="../../html/query.cfm?tipo=D&AnexoId=#rsAnexoXml.AnexoId#">
					</iframe>
				</cfoutput>
			</td>
		</tr>
	</table>
	<br>
	<table width="100%" cellpadding="0" cellspacing="0"  align="center">
		<tr>
			<td align="center">
				<cfoutput>
					<!---
						danim, 26-Sep-2005.
						Quitar botón de "Grabar".
						El botón de Grabar, en algunos casos, genera un XML cuyos <ss:Cell> no contienen <ss:NamedCell>,
						por lo que al calcular el anexo no se pueden encontrar las celdas que se deban modificar.
						Parece que es un error del OWC, pues excel sí lo genera bien al guardar como XML.
						Ver http://msdn.microsoft.com/library/default.asp?url=/library/en-us/dnexcl2k2/html/odc_xmlss.asp
						<input type="Submit" name="Grabar" value="Grabar" onClick="PrepareseParaGrabarAnexo(this.form);">
						--->
					<input type="Submit" name="Borrar" value="#LB_EliminarAnexo#" 						onClick="return ConfirmaBorrar();">
					<input type="button" name="Descargar" id="Descargar" value="#LB_DescargarAnexo#" onClick="DescargarAnexo()"
					<cfif rsAnexoXml.len_XLS LTE 1>
						disabled
					</cfif>
					>
					<input type="submit" name="SOINanexos" value="#LB_CargarSoinAnexos#" 			onClick="return CargarConSOINAnexos();">
					<input type="hidden" name="xmldata" id="xmldata" value="">
					<input type="hidden" name="AnexoId" id="AnexoId" value="#HTMLEditFormat(url.AnexoId)#">
					<input type="submit" name="ExportarAmexo" value="Exportar Configuraci&oacute;n" onClick="return ExportarAnexo();">
					<input type="button" name="ImportaAmexo" value="Importa Configuraci&oacute;n" onClick="return ImportarAnexo();">
				</cfoutput>
			</td>
		</tr>
	</table>
</form>
<script language="JavaScript1.2" type="text/javascript">
<!-- Begin
	<!---
			danim, 26-Sep-2005.
			Quitar botón de "Grabar". Ver notas arriba
	function PrepareseParaGrabarAnexo (f){
		f.xmldata.value = f.grid1.XMLdata;
	}
	--->
	function ExportarAnexo(){
        document.getElementById("formAnexoMain").action="Exportar.cfm?AnexoId=#rsAnexoXml.AnexoId#";
        document.getElementById("formAnexoMain").submit();
	}

	function ImportarAnexo(){
        document.getElementById("formAnexoMain").action="Importar.cfm";
        document.getElementById("formAnexoMain").submit();
	}

	function CargarConSOINAnexos(){
	<cfoutput>
		<cfif not Len(rsAnexoXml.AnexoId)>
			alert('Aun no se ha cargado la definición de este anexo.');
			return false;
		</cfif>
	</cfoutput>
	}
	function ConfirmaBorrar(){
		return confirm('¿Está seguro de que desea eliminar este anexo?');
	}
	function DescargarAnexo(){
	<cfoutput>
		<cfif Len(rsAnexoXml.AnexoId)>
			window.open('download/download.cfm?AnexoId=#rsAnexoXml.AnexoId#&XLS=1','_self');
<cfelse>
			alert('Aun no se ha cargado la definición de este anexo.');
		</cfif>
	</cfoutput>
	}
	<!---
		danim, 26-Sep-2005.
		Mostrar siempre el botón de "Descargar"
	if(document.mostrarDescargar)document.getElementById('Descargar').style.display="inline";
	--->
// End -->
</script>
