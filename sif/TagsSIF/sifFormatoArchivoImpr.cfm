<cfparam name="Attributes.EIcodigo" default="EIcodigo" type="string"> <!--- Nombres del código del importador --->
<cfparam name="Attributes.Tipo"     default="I"        type="string">

<cfquery name="rsImportador" datasource="sifcontrol">
	select *
	from EImportador a
	where EIcodigo =  <cfqueryparam cfsqltype="cf_sql_char" value="#Attributes.EIcodigo#">
</cfquery>

<cfif rsImportador.EIdelimitador eq 'C'>
	<cfset Delimitador = 'Coma'>
<cfelseif rsImportador.EIdelimitador eq 'T'>
	<cfset Delimitador = 'Tab'>
<cfelseif rsImportador.EIdelimitador eq 'L'>
	<cfset Delimitador = 'Linea'>
<cfelseif rsImportador.EIdelimitador eq 'X'>
	<cfset Delimitador = 'Punto y Coma (;)'>
<cfelse>
	<cfset Delimitador = 'Pipe'>
</cfif>

<cfset Tipo = 'ImportadorSimple'>
<cfif rsImportador.EIimporta>
	<cfset Tipo = 'ImportadorSimple'>
<cfelseif rsImportador.EIexporta>
	<cfset Tipo = 'ExportadorSimple'>
<cfelseif rsImportador.EIimportaComplejo>
	<cfset Tipo = 'ImportadorComplejo'>
</cfif>


<cfset t=createObject("component", "sif.Componentes.Translate")>
<cfset LB_Texto = t.translate('LB_Texto','Texto','/rh/generales.xml')>
<cfset LB_NumeroEntero = t.translate('LB_NumeroEntero','Número entero','/rh/generales.xml')>
<cfset LB_Monto = t.translate('LB_Monto','Monto','/rh/generales.xml')>
<cfset LB_Fecha = t.translate('LB_Fecha','Fecha','/rh/generales.xml')>
<cfset LB_NumeroConDecimales = t.translate('LB_NumeroConDecimales','Número con decimales','/rh/generales.xml')>

<cfoutput>
	<!--- Importador Simple --->
	<cfif Tipo eq "ImportadorSimple">
		<cfquery name="lista" datasource="sifcontrol">
			select b.DInumero,b.DInombre, b.DIdescripcion, b.DItipo, b.DIlongitud
			from EImportador a
			inner join DImportador b
			on b.EIid = a.EIid
			where rtrim(EIcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#rtrim(Attributes.EIcodigo)#">
			order by b.DItiporeg,b.DInumero
		</cfquery>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="LB_PasosParaLaImportacion"
			default="Pasos para la Importación"
			returnvariable="LB_PasosParaLaImportacion" xmlFile="/rh/generales.xml"/>

		<cf_web_portlet_start border="true" titulo="#LB_PasosParaLaImportacion#" skin="info1">
			<cf_translate  key="AYUDA_SeleccionDeArchivo" xmlFile="/rh/generales.xml">
				<li><u>Selecci&oacute;n de archivo:</u> Seleccione el archivo que desea importar presionando el botón de <strong>Browse</strong></li><br>
			</cf_translate>

			<cf_translate  key="AYUDA_Importacion"  xmlFile="/rh/generales.xml">
			<li><u>Importaci&oacute;n:</u> Una vez seleccionado el archivo presione el bot&oacute;n de <strong>Importar</strong></li><br>
			</cf_translate>

			<cf_translate  key="AYUDA_ResumenDeImportacion"  xmlFile="/rh/generales.xml">
			<li><u>Resumen de Importaci&oacute;n:</u> Al importar el archivo se mostrar&aacute; informaci&oacute;n relacionada con la importaci&oacute;n.</li><br>
			</cf_translate>

			<cf_translate  key="AYUDA_Revision"  xmlFile="/rh/generales.xml">
			<li><u>Revisi&oacute;n:</u> Una vez importado el archivo, se puede revisar y confirmar su generaci&oacute;n al dar click en <strong>Regresar</strong>.<br>
			</cf_translate>
			  <br>
		<cf_web_portlet_end>

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_FormatoDeArchivoDeImportacion"
		default="Formato de Archivo de Importación"
		returnvariable="LB_FormatoDeArchivoDeImportacion" xmlFile="/rh/generales.xml"/>

		<cf_web_portlet_start border="true" titulo="#LB_FormatoDeArchivoDeImportacion#" skin="info1">
			<cf_translate  key="AYUDA_ElArchivoDebeSerUnArchivoPlanoConElSiguienteFormato"  xmlFile="/rh/generales.xml">
			El archivo debe ser un archivo plano con el siguiente formato: <br><br>
			Separador de columnas: &nbsp; (#Delimitador#)<br>
			Fin de l&iacute;nea: &nbsp; &lt;Enter&gt; &nbsp; (chr(13))<br><br>
			</cf_translate>
			<strong><cf_translate  key="LB_Columnas"  xmlFile="/rh/generales.xml">Columnas</cf_translate>:</strong><br><br>
			<table class="table" cellpadding="2" cellspacing="0">
				<cfloop query="lista">
					<tr>
						<td style="font-size:11px;">#lista.DInumero#</td>
						<td>&nbsp;</td>
						<td style="font-size:11px;">#t.translate('LB_DIdescripcion',lista.DIdescripcion,'/rh/generales.xml')#</td>
						<td>&nbsp;</td>
						<cfif lista.DITipo eq 'varchar'>
							<td style="font-size:11px;">#LB_Texto#</td>
						<cfelseif lista.DITipo eq 'datetime'>
							<td style="font-size:11px;">#LB_Fecha#</td>
						<cfelseif lista.DITipo eq 'numeric'>
							<td style="font-size:11px;">#LB_NumeroConDecimales#</td>
						<cfelseif lista.DITipo eq 'money'>
							<td style="font-size:11px;">#LB_Monto#</td>
						<cfelseif lista.DITipo eq 'int'>
							<td style="font-size:11px;">#LB_NumeroEntero#</td>
						<cfelseif lista.DITipo eq 'float'>
							<td style="font-size:11px;">#LB_NumeroConDecimales#</td>
						<cfelse>
							<td style="font-size:11px;">#t.translate('LB_DItipo',lista.DItipo,'/rh/generales.xml')#</td>
						</cfif>
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

	<!--- Exportado Simple --->
	<cfelseif Tipo eq "ExportadorSimple">

		<cfquery name="lista" datasource="sifcontrol">
			select b.DInumero,b.DInombre, b.DIdescripcion, b.DItipo, b.DIlongitud
			from EImportador a
			inner join DImportador b
			on b.EIid = a.EIid
			where rtrim(EIcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#rtrim(Attributes.EIcodigo)#">
			order by b.DItiporeg,b.DInumero
		</cfquery>

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_PasosParaLaExportacion"
		default="Pasos para la Exportación"
		returnvariable="LB_PasosParaLaExportacion" xmlFile="/rh/generales.xml"/>

		<cf_web_portlet_start border="true" titulo="#LB_PasosParaLaExportacion#" skin="info1">
			<cf_translate  key="AYUDA_CapturarTodosLosCamposRequeridos"  xmlFile="/rh/generales.xml">
			<li><u>Capturar todos los campos requeridos.</u><br>
			</cf_translate>

			<cf_translate  key="AYUDA_Exportacion"  xmlFile="/rh/generales.xml">
			<li><u>Exportaci&oacute;n:</u> Una vez capturados los parámetros del exportador presione el bot&oacute;n de <strong>Siguiente</strong>.</li>
			</cf_translate>
			<br>
			  <br>
		<cf_web_portlet_end>

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_FormatoDeArchivoDeExportacion"
		default="Formato de Archivo de Exportación"
		returnvariable="LB_FormatoDeArchivoDeExportacion" xmlFile="/rh/generales.xml"/>

		<cf_web_portlet_start border="true" titulo="#LB_FormatoDeArchivoDeExportacion#" skin="info1">
			<cf_translate  key="AYUDA_ElArchivoQueSeExportaraContieneElSiguienteFormato"  xmlFile="/rh/generales.xml">
			El archivo que se exportara contiene el siguiente formato: <br><br>
			Separador de columnas: &nbsp; (#Delimitador#)<br>
			Fin de l&iacute;nea: &nbsp; &lt;Enter&gt; &nbsp; (chr(13))<br><br>
			</cf_translate>
			<strong><cf_translate  key="LB_Columnas"  xmlFile="/rh/generales.xml">Columnas</cf_translate>:</strong><br><br>
			<table class="table" cellpadding="2" cellspacing="0">
				<tr>
					<td style="font-size:11px;"><cf_translate  key="LB_Parametro"  xmlFile="/rh/generales.xml">Parámetro</cf_translate></td>
					<td>&nbsp;</td>
					<td style="font-size:11px;"><cf_translate  key="LB_Nombre"  xmlFile="/rh/generales.xml">Nombre</cf_translate></td>
					<td>&nbsp;</td>
					<td style="font-size:11px;"><cf_translate  key="LB_Descripcion"  xmlFile="/rh/generales.xml">Descripción</cf_translate></td>
					<td>&nbsp;</td>
					<td style="font-size:11px;"><cf_translate  key="LB_Tipo"  xmlFile="/rh/generales.xml">Tipo</cf_translate></td>
					<td>&nbsp;</td>
				</tr>
				<cfloop query="lista">
					<tr>
						<td style="font-size:11px;" align="right"><cfif #lista.DInumero# LT 0><img src="../imagenes/w-check.gif"/></cfif></td>
						<td>&nbsp;</td>
						<td style="font-size:11px;">#t.translate('LB_DIdescripcion',lista.DIdescripcion,'/rh/generales.xml')#</td>
						<td>&nbsp;</td>
						<cfif lista.DITipo eq 'varchar'>
							<td style="font-size:11px;">#LB_Texto#</td>
						<cfelseif lista.DITipo eq 'datetime'>
							<td style="font-size:11px;">#LB_Fecha#</td>
						<cfelseif lista.DITipo eq 'numeric'>
							<td style="font-size:11px;">#LB_NumeroConDecimales#</td>
						<cfelseif lista.DITipo eq 'money'>
							<td style="font-size:11px;">#LB_Monto#</td>
						<cfelseif lista.DITipo eq 'int'>
							<td style="font-size:11px;">#LB_NumeroEntero#</td>
						<cfelseif lista.DITipo eq 'float'>
							<td style="font-size:11px;">#LB_NumeroConDecimales#</td>
						<cfelse>
							<td style="font-size:11px;">#t.translate('LB_DItipo',lista.DItipo,'/rh/generales.xml')#</td>
						</cfif>
						<td>&nbsp;</td>
					</tr>
				</cfloop>
			</table>
		<cf_web_portlet_end>

	<!--- Importador Complejo --->
	<cfelseif Tipo eq "ImportadorComplejo">

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_FormatoDeArchivoDeImportacionComplejo"
		default="Formato de Archivo de Importación Complejo"
		returnvariable="LB_FormatoDeArchivoDeImportacionComplejo" xmlFile="/rh/generales.xml"/>

		<cfquery name="paginas" datasource="sifcontrol">
			select distinct p.PIid, p.EIid, p.PIDescripcion, p.PIOrden
			from EImportador e
			inner join PImportadores p
				on p.EIid = e.EIid
			where rtrim(EIcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#rtrim(Attributes.EIcodigo)#">
			order by p.PIOrden
		</cfquery>

		<cf_web_portlet_start border="true" titulo="#LB_FormatoDeArchivoDeImportacionComplejo#" skin="info1">
			<cf_translate  key="AYUDA_ElArchivoDebeSerUnArchivoPlanoConElSiguienteFormato"  xmlFile="/rh/generales.xml">
			El archivo debe ser un archivo de extensión .xls <br><br>
			</cf_translate>

			<cfif paginas.RecordCount NEQ 0>
				<cf_tabs width="100%">
					<cfloop query="paginas">
						<cfquery name="detallesHoja" datasource="sifcontrol">
							select distinct d.DInumero,d.DInombre, d.DIdescripcion, d.DItipo, d.DIlongitud
							from PImportadores p
							inner join DImportador d
							on d.EIid = p.EIid
							where d.EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#paginas.EIid#">
								and d.PIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#paginas.PIid#">
							order by d.DItiporeg,d.DInumero
						</cfquery>

						<cf_tab text="Hoja #paginas.PIOrden#">
							<br>
							<strong><cf_translate  key="LB_Columnas" xmlFile="/rh/generales.xml">Columnas</cf_translate>:</strong><br><br>
							<table class="table" cellpadding="2" cellspacing="0">
								<cfloop query="detallesHoja">
									<tr>
										<td style="font-size:11px;">#detallesHoja.DInumero#</td>
										<td>&nbsp;</td>
										<td style="font-size:11px;">#detallesHoja.DIdescripcion#</td>
										<td>&nbsp;</td>
										<cfif detallesHoja.DITipo eq 'varchar'>
											<td style="font-size:11px;">Texto</td>
										<cfelseif detallesHoja.DITipo eq 'datetime'>
											<td style="font-size:11px;">Fecha</td>
										<cfelseif detallesHoja.DITipo eq 'numeric'>
											<td style="font-size:11px;">Numero con decimales</td>
										<cfelseif detallesHoja.DITipo eq 'money'>
											<td style="font-size:11px;">Monto</td>
										<cfelseif detallesHoja.DITipo eq 'int'>
											<td style="font-size:11px;">Numero Entero</td>
										<cfelseif detallesHoja.DITipo eq 'float'>
											<td style="font-size:11px;">Numero con decimales</td>
										<cfelse>
											<td style="font-size:11px;">#detallesHoja.DItipo#</td>
										</cfif>
										<td>&nbsp;</td>
										<cfif detallesHoja.DITipo eq 'varchar'>
											<td style="font-size:11px;">(#detallesHoja.DIlongitud#)</td>
										<cfelse>
											<td style="font-size:11px;">#detallesHoja.DIlongitud#</td>
										</cfif>
									</tr>
								</cfloop>
							</table>
						</cf_tab>
					</cfloop>
				</cf_tabs>
			</cfif>
		<cf_web_portlet_end>
	</cfif>
</cfoutput>