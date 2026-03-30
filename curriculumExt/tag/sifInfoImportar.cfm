
	<cfparam name="Attributes.EIid"     type="numeric" default="0">
	<cfparam name="Attributes.EIcodigo" type="string"  default="">
	<cfparam name="Attributes.mode"     type="string">
	<cfparam name="Attributes.width"    type="string" default="300">
	<cfparam name="Attributes.height"   type="string" default="300">
	<cfparam name="Attributes.form"     type="string"  default="formexport">
	<cfparam name="Attributes.exec"     type="boolean" default="no">
	
	<!--- solo para exportación --->
	<cfparam name="Attributes.html"     type="boolean" default="no">
	<cfparam name="Attributes.header"   type="boolean" default="#Attributes.html#">
	<cfparam name="Attributes.name"     type="string"  default="">
	<cfparam Name="ThisTag.parameters"  default="#arrayNew(1)#">
	
	<cfif Attributes.EIid EQ 0 AND Len(Attributes.EIcodigo) EQ 0>
		<cfthrow message="Debe especificarse al menos uno de los siguientes atributos:  EIid, EIcodigo">
	</cfif>
	
	<cfquery datasource="sifcontrol" name="formatos">
		select * from EImportador
		where (Ecodigo is null
		   or Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" null="#Len(session.Ecodigo) is 0#">)
		<cfif Attributes.EIid NEQ 0>
		  and EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.EIid#">
		</cfif>
		<cfif Len(Attributes.EIcodigo) NEQ 0>
		  and EIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.EIcodigo#">
		</cfif>
	</cfquery>

	<cfquery datasource="sifcontrol" name="formatosArchivo">
		select * 
		from DImportador
		where EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.EIid#">
	</cfquery>
	<cfif formatos.RecordCount EQ 1>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td width="3%">&nbsp;</td>
				<td align="center" valign="top" width="97%">
					<cf_web_portlet border="true" titulo="Pasos para la Importación" skin="info1">
						<li><u>Selecci&oacute;n de archivo:</u> Seleccione el archivo que desea importar presionando el botón de <strong>Browse</strong></li><br>
						<li><u>Importaci&oacute;n:</u> Una vez seleccionado el archivo presione el bot&oacute;n de <strong>Importar</strong></li><br>
						<li><u>Resumen de Importaci&oacute;n:</u> Al importar el archivo se mostrar&aacute; informaci&oacute;n relacionada con la importaci&oacute;n.</li><br>
						<li><u>Revisi&oacute;n:</u> Una vez importado el archivo puede revisar la importaci&oacute;n de la informaci&oacute;n.<br><br>
					</cf_web_portlet><br><br>
					<cf_web_portlet border="true" titulo="Formato de Archivo de Importaci&oacute;n" skin="info1">
						El archivo debe ser un archivo plano con el siguiente formato: <br>
						Separador de columnas: <cfif formatos.EIdelimitador EQ 'C'> &nbsp; , &nbsp; (coma)
												<cfelseif formatos.EIdelimitador EQ 'T'> Tabulador
												<cfelseif formatos.EIdelimitador EQ 'L'> Línea
												<cfelseif formatos.EIdelimitador EQ 'P'> | (pipe)</cfif><br>
						Fin de l&iacute;nea: &nbsp; &lt;Enter&gt; &nbsp; (chr(13))<br>
						Las fechas deben tener el formato YYYYMMDD, ej: 20031012 (12/10/2003)<br><br>
						<strong>Columnas:</strong><br>
						<cfset index = 1>
						<cfoutput query="formatosArchivo">
							#index#.#formatosArchivo.DIdescripcion#<br>
							<cfset index = index + 1>
						</cfoutput>
						<br>
					</cf_web_portlet>
				</td>
			</tr>
		</table>		
	</cfif>
