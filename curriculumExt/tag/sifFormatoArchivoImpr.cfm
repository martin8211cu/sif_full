<cfparam name="Attributes.EIcodigo" default="EIcodigo" type="string"> <!--- Nombres del código del importador --->
<cfparam name="Attributes.Tipo"     default="I"        type="string">

<cfquery name="Determina_delimitador" datasource="sifcontrol">
	select * 
	from EImportador a
	where EIcodigo =  <cfqueryparam cfsqltype="cf_sql_char" value="#Attributes.EIcodigo#">
</cfquery>

<cfif Determina_delimitador.EIdelimitador eq 'C'>
	<cfset Delimitador = 'Coma'>
<cfelseif Determina_delimitador.EIdelimitador eq 'T'>
	<cfset Delimitador = 'Tab'>
<cfelseif Determina_delimitador.EIdelimitador eq 'L'>
	<cfset Delimitador = 'Linea'>
<cfelseif Determina_delimitador.EIdelimitador eq 'X'>
	<cfset Delimitador = 'Punto y Coma (;)'>
<cfelse>
	<cfset Delimitador = 'Pipe'>	
</cfif>

<cfquery name="lista" datasource="sifcontrol">
	select b.DInumero,b.DInombre, b.DIdescripcion, b.DItipo, b.DIlongitud
	from EImportador a
	 inner join DImportador b
	  on b.EIid = a.EIid
	where rtrim(EIcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#rtrim(Attributes.EIcodigo)#">
	order by b.DInumero
</cfquery>

<cfoutput>
	<cfif Attributes.Tipo eq "I">
		<cfinvoke component="Translate"
			method="Translate"
			key="LB_PasosParaLaImportacion"
			default="Pasos para la Importación"
			returnvariable="LB_PasosParaLaImportacion"/>
		
		
		<cf_web_portlet_start border="true" titulo="#LB_PasosParaLaImportacion#" skin="info1">
			<cf_translate  key="AYUDA_SeleccionDeArchivo">
				<li><u>Selecci&oacute;n de archivo:</u> Seleccione el archivo que desea importar presionando el botón de <strong>Browse</strong></li><br>
			</cf_translate>
			
			<cf_translate  key="AYUDA_Importacion">
			<li><u>Importaci&oacute;n:</u> Una vez seleccionado el archivo presione el bot&oacute;n de <strong>Importar</strong></li><br>
			</cf_translate>
			
			<cf_translate  key="AYUDA_ResumenDeImportacion">
			<li><u>Resumen de Importaci&oacute;n:</u> Al importar el archivo se mostrar&aacute; informaci&oacute;n relacionada con la importaci&oacute;n.</li><br>
			</cf_translate>
			
			<cf_translate  key="AYUDA_Revision">
			<li><u>Revisi&oacute;n:</u> Una vez importado el archivo, se puede revisar y confirmar su generaci&oacute;n al dar click en <strong>Regresar</strong>.<br>
			</cf_translate>
			  <br>
		<cf_web_portlet_end>
	<cfelse>
		<cfinvoke component="Translate"
		method="Translate"
		key="LB_PasosParaLaExportacion"
		default="Pasos para la Exportación"
		returnvariable="LB_PasosParaLaExportacion"/>
		
		<cf_web_portlet_start border="true" titulo="#LB_PasosParaLaExportacion#" skin="info1">
			<cf_translate  key="AYUDA_CapturarTodosLosCamposRequeridos">
			<li><u>Capturar todos los campos requeridos.</u><br>
			</cf_translate>
			
			<cf_translate  key="AYUDA_Exportacion">
			<li><u>Exportaci&oacute;n:</u> Una vez capturados los parámetros del exportador presione el bot&oacute;n de <strong>Siguiente</strong>.</li>
			</cf_translate>
			<br>
			  <br>
		<cf_web_portlet_end>
	</cfif>
	

	<cfif Attributes.Tipo eq "I">
		<cfinvoke component="Translate"
		method="Translate"
		key="LB_FormatoDeArchivoDeImportacion"
		default="Formato de Archivo de Importación"
		returnvariable="LB_FormatoDeArchivoDeImportacion"/>
		
		<cf_web_portlet_start border="true" titulo="#LB_FormatoDeArchivoDeImportacion#" skin="info1">
			<cf_translate  key="AYUDA_ElArchivoDebeSerUnArchivoPlanoConElSiguienteFormato">
			El archivo debe ser un archivo plano con el siguiente formato: <br><br>
			Separador de columnas: &nbsp; (#Delimitador#)<br>
			Fin de l&iacute;nea: &nbsp; &lt;Enter&gt; &nbsp; (chr(13))<br><br>
			</cf_translate>
			<strong><cf_translate  key="LB_Columnas">Columnas</cf_translate>:</strong><br><br>				
			<table cellpadding="2" cellspacing="0">
				<cfloop query="lista">
					<tr>
						<td style="font-size:11px;">#lista.DInumero#</td>
						<td>&nbsp;</td>
						<td style="font-size:11px;">#lista.DInombre#</td>
						<td>&nbsp;</td>
						<td style="font-size:11px;">#lista.DIdescripcion#</td>
						<td>&nbsp;</td>
						<td style="font-size:11px;">#lista.DITipo#</td>
						<td>&nbsp;</td>
						<cfif lista.DITipo eq 'varchar'>
							<td style="font-size:11px;">(#lista.DIlongitud#)</td>
						<cfelse>
							<td style="font-size:11px;">#lista.DIlongitud#</td>
						</cfif>
					</tr>
				</cfloop>
			</table>
		<cf_web_portlet_end>
	<cfelse>
		<cfinvoke component="Translate"
		method="Translate"
		key="LB_FormatoDeArchivoDeExportacion"
		default="Formato de Archivo de Exportación"
		returnvariable="LB_FormatoDeArchivoDeExportacion"/>
		
		<cf_web_portlet_start border="true" titulo="#LB_FormatoDeArchivoDeExportacion#" skin="info1">
			<cf_translate  key="AYUDA_ElArchivoQueSeExportaraContieneElSiguienteFormato">
			El archivo que se exportara contiene el siguiente formato: <br><br>
			Separador de columnas: &nbsp; (#Delimitador#)<br>
			Fin de l&iacute;nea: &nbsp; &lt;Enter&gt; &nbsp; (chr(13))<br><br>
			</cf_translate>
			<strong><cf_translate  key="LB_Columnas">Columnas</cf_translate>:</strong><br><br>				
			<table cellpadding="2" cellspacing="0">
				<tr>
					<td style="font-size:11px;"><cf_translate  key="LB_Parametro">Parámetro</cf_translate></td>
					<td>&nbsp;</td>
					<td style="font-size:11px;"><cf_translate  key="LB_Nombre">Nombre</cf_translate></td>
					<td>&nbsp;</td>
					<td style="font-size:11px;"><cf_translate  key="LB_Descripcion">Descripción</cf_translate></td>
					<td>&nbsp;</td>
					<td style="font-size:11px;"><cf_translate  key="LB_Tipo">Tipo</cf_translate></td>
					<td>&nbsp;</td>
				</tr>
				<cfloop query="lista">
					<tr>
						<td style="font-size:11px;" align="right"><cfif #lista.DInumero# LT 0><img src="../imagenes/w-check.gif"/></cfif></td>
						<td>&nbsp;</td>
						<td style="font-size:11px;">#lista.DInombre#</td>
						<td>&nbsp;</td>
						<td style="font-size:11px;">#lista.DIdescripcion#</td>
						<td>&nbsp;</td>
						<td style="font-size:11px;">#lista.DITipo#</td>
						<td>&nbsp;</td>
					</tr>
				</cfloop>
			</table>
		<cf_web_portlet_end>
	</cfif>	
	<br><br>
</cfoutput>	