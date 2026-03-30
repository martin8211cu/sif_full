<cfinclude template="anexo-validar-permiso.cfm">
<cfif IsDefined('form.Borrar')>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			delete from AnexoEm
			where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoId#">
		</cfquery>
		<cfquery datasource="#session.dsn#">
			delete from AnexoPermisoDef
			where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoId#">
		</cfquery>
		<cfquery datasource="#session.dsn#">
			delete from AnexoCelD
			where AnexoCelId in (
				select AnexoCelId
				from AnexoCel
				where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoId#"> )
		</cfquery>
		<cfquery datasource="#session.dsn#">
			delete from AnexoCel
			where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoId#">
		</cfquery>
		<cfquery datasource="#session.dsn#">
			delete from AnexoCalculoRango
			where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoId#">
		</cfquery>
		<cfquery datasource="#session.dsn#">
			delete from AnexoCalculo
			where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoId#">
		</cfquery>
		<cfquery datasource="#session.dsn#">
			delete from AnexoVersion
			where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoId#">
		</cfquery>
		<cfquery datasource="#session.dsn#">
			delete from Anexoim
			where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoId#">
		</cfquery>
		<cfquery datasource="#session.dsn#">
			delete from Anexo
			where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoId#">
		</cfquery>
	</cftransaction>
	<cflocation url="index.cfm">
</cfif>

	
<cfif isdefined("form.SOINanexos")>
	<cfoutput>
			<cfset LvarObj = createObject("component","sif.an.WS.anexosWS")>
			<cfset LvarWSkey = LvarObj.fnInicializarSeguridad("UPLOAD")>

			<iframe id="ifrSoinAnexosOPs"
					src="/cfmx/sif/an/WS/SoinAnexosOPs.cfm?AnexoId=#Form.AnexoId#&XLOP=UPLOAD&WSkey=#LvarWSkey#"
					width="0"
					height="0"
			></iframe>
		<table cellpadding="0" cellspacing="0" height="100%" align="center" style="text-align:center; vertical-align:middle">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td width="700" height="50" style="border-top:1px solid ##000000;border-right:1px solid ##000000;border-left:1px solid ##000000; font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px;">
					<table>
						<tr>
							<td style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px;">&nbsp;

							</td>
						</tr>
						<tr>
							<td style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px;">
								1. Escoja la opción Open o Abrir en la pantalla de Download o Descargar Archivo SoinAnexosOPs.xls
							</td>
						</tr>
						<tr>
							<td style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px;">
								2. Escoja en Excel el Workbook que corresponda al <strong>Diseño del Anexo</strong> que desea cargar
							</td>
						</tr>
						<tr>
							<td style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px;">
								3. Utilice en Excel la opcion <font style="background-color:##CBCBCB">&nbsp;Guardar Diseño&nbsp;</font> de SOINanexos para cargar el <strong>Diseño del Anexo</strong>
							</td>
						</tr>
						<tr>
							<td style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px;">
								4. Presione <font style="background-color:##CBCBCB">&nbsp;OK&nbsp;</font> cuando termine el Proceso en Excel de Guardar el <strong>Diseño del Anexo</strong>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="700" height="50" style="border-bottom:1px solid ##000000;border-right:1px solid ##000000;border-left:1px solid ##000000;">
					<input value="&nbsp;&nbsp;OK&nbsp;&nbsp;" type="button" onClick="location.href='anexo.cfm?AnexoId=#URLEncodedFormat(form.AnexoId)#';">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	</cfoutput>
	<cfabort>
	<script language="javascript">
		window.open('/cfmx/sif/an/WS/SoinAnexosOPs.cfm?AnexoId=#rsAnexoXml.AnexoId#&XLOP=UPLOAD','_self');
		alert ("1. Modifique el diseño del Anexo en Excel\n2. Guarde el diseño del Anexo en la base de datos con el SOINanexos\n3. Presione OK para continuar...");
		location.href="anexo.cfm?AnexoId=<cfoutput>#form.AnexoId#</cfoutput>";
	</script>
	<cfabort>
</cfif>

<cfif isdefined("Form.xmldata") and len(trim(xmldata)) GT 0>
	<cfset Request.excel_xml = form.xmldata>

	<cfinvoke component="sif.an.operacion.admin.anexo-UpParseoXML"
		method="GuardarAnexo"
		AnexoId = "#Form.AnexoId#"
		AnexoEditor = "E"  /><!--- E = editado --->

	<cfquery datasource="#session.dsn#">
		update Anexo
		set AnexoFec = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
		    BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoId#">
	</cfquery>
</cfif>
<cflocation url="anexo.cfm?AnexoId=#URLEncodedFormat(form.AnexoId)#">