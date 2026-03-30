<cfset ListaImg = "JPG,BMP,GIF,PNG">
<cf_dbfunction name="OP_concat"	args="" returnvariable="LvarConcat">
<br />
<cfset archivo = GetFileFromPath(GetTemplatePath())>
<cfif archivo EQ "Activos.cfm">
	<cfinclude template="Activos_frameEncabezado.cfm">
</cfif>
<!--- Variables del Form --->
<cfif isdefined("url.CAMBIO") and not isdefined("form.CAMBIO")>
	<cfset form.CAMBIO = url.CAMBIO >
</cfif>
<cfif isdefined("url.Aid") and not isdefined("form.Aid")>
	<cfset form.Aid = url.Aid >
</cfif>
<cfif isdefined("url.AFAfecha1") and not isdefined("form.AFAfecha1")>
	<cfset form.AFAfecha1 = url.AFAfecha1 >
</cfif>

<!--- Variables del Filtro --->
<cfif isdefined("url.f_AFAfecha") and not isdefined("form.f_AFAfecha")>
	<cfset form.f_AFAfecha = url.f_AFAfecha >
</cfif>
<cfif isdefined("url.f_AFAtexto") and not isdefined("form.f_AFAtexto")>
	<cfset form.f_AFAtexto = url.f_AFAtexto >
</cfif>
<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select Ecodigo,Aid,AFAlinea,AFAtipo,AFAfecha,AFAtexto,AFAfecha1,AFAfecha2,ts_rversion, Observaciones
		from AFAnotaciones a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
		and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
		and a.AFAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFAlinea#">
	</cfquery>
</cfif>

<!--- Control de variables de la navegación --->
<cfset navegacion = '&consulta=#form.consulta#&Ecodigo=#form.Ecodigo#'>
<cfif isdefined("form.f_AFAfecha") and len(trim(form.f_AFAfecha)) >
	<cfset navegacion = navegacion & '&f_AFAfecha = #form.f_AFAfecha#'>
</cfif>
<cfif isdefined("form.f_AFAtexto") and len(trim(form.f_AFAtexto)) >
	<cfset navegacion = navegacion & '&f_AFAtexto = #form.f_AFAtexto#'>
</cfif>

<!--- Se incluye un JavaScript --->
<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="50%" valign="top">
			<cfoutput>
				<form style="margin:0;" name="filtroActivos" method="post" action="Activos.cfm">
					<input type="hidden" name="Aid" value="#form.Aid#">
					<input type="hidden" name="tab" value="2">
					<input type="hidden" name="consulta" value="#form.consulta#">
					<input type="hidden" name="Ecodigo" value="#form.Ecodigo#">

					<table border="0" width="100%" cellpadding="0" cellspacing="0" class="tituloListas" >
						<tr>
							<td nowrap ><strong>Fecha:&nbsp;</strong></td>
							<td nowrap >&nbsp;</td>
							<td nowrap ><strong>Anotaci&oacute;n:&nbsp;</strong></td>
							<td nowrap >&nbsp;</td>
						</tr>
						<tr>
							<td nowrap >
								<cfif isdefined("form.f_AFAfecha") and len(trim(form.f_AFAfecha))>
									<cfset fechaFiltro = LSDateFormat(form.f_AFAfecha,'dd/mm/yyyy')>
								<cfelse>
									<cfset fechaFiltro = ''>
								</cfif>
								<cf_sifcalendario tabindex="1" form="filtroActivos" name="f_AFAfecha" value="#fechaFiltro#">
							</td>
							<td nowrap >&nbsp;</td>
							<td nowrap ><input type="text" name="f_AFAtexto" tabindex="1" value="<cfif isdefined("form.f_AFAtexto") and len(trim(form.f_AFAtexto)) >#form.f_AFAtexto#</cfif>" size="30" maxlength="50"></td>
							<td nowrap align="center"><input type="submit" name="filtrar" value="Filtrar" tabindex="1"></td>
						</tr>
					</table>
				</form>
			</cfoutput>

			<cfquery name="rsLista" datasource="#session.DSN#">
				select Aid, AFAlinea, AFAfecha1, AFAtexto, 2 as tab, Observaciones
				from AFAnotaciones
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
					and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
					<cfif isdefined("form.f_AFAfecha") and len(trim(form.f_AFAfecha)) >
						and AFAfecha1 >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedatetime(form.f_AFAfecha)#">
					</cfif>
					<cfif isdefined("form.f_AFAtexto") and len(trim(form.f_AFAtexto)) >
						and rtrim(upper(substring(<cf_dbfunction name='to_char' args='AFAtexto'>,1,255))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.f_AFAtexto)#%">
					</cfif>
			</cfquery>

			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" name="jos">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="AFAfecha1,AFAtexto"/>
				<cfinvokeargument name="etiquetas" value="Fecha,Anotación"/>
				<cfinvokeargument name="formatos" value="D,S"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="formName" value="ListaActivos"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="keys" value="AFAlinea"/>
				<cfinvokeargument name="ira" value="Activos.cfm?consulta=#form.consulta#&Ecodigo=#form.Ecodigo#"/>
				<cfinvokeargument name="MaxRows" value="10"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="PageIndex" value="1"/>
			</cfinvoke>
		</td>

		<td width="50%" valign="top">
			<cfoutput>
				<form name="formActivos" method="post" action="Activos_frameAnotacion_sql.cfm" enctype="multipart/form-data">
					<!--- Se Obtiene el timestamp en modo CAMBIO --->
					<cfif modo NEQ 'ALTA'>
						<cfset ts = "">
						<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
							<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
						</cfinvoke>
						<input type="hidden" name="ts_rversion" value="#ts#">
						<input type="hidden" name="AFAlinea" value="#form.AFAlinea#">
					</cfif>
					<input type="hidden" name="Aid" value="#form.Aid#">

					<table width="100%" border="0" cellspacing="2" cellpadding="0">
						<tr>
							<td nowrap align="right"><strong>Anotaci&oacute;n:</strong>&nbsp;</td>
							<td><input type="text" name="Anotacion" maxlength="80" size="57" tabindex="1" <cfif modo neq "ALTA">value="#rsForm.AFAtexto#"</cfif>></td>
						</tr>

						<tr>
							<td nowrap align="right"><strong>Archivo/Imagen:</strong>&nbsp;</td>
							<td><input type="file" name="AFimagen" value="" onChange="javascript:extraeNombre(this.value);" size="40" tabindex="1"></td>
							<input type="hidden" name="AFnombreImagen" value="">
							<input type="hidden" name="AFnombre" value="">
						</tr>

						<tr>
							<td nowrap align="right"><strong>Fecha Anotaci&oacute;n:</strong>&nbsp;</td>
							<td>
								<cfif modo neq "ALTA">
									<cfset fechaAnotacion = LSDateFormat(rsform.AFAfecha1,'dd/mm/yyyy')>
								<cfelse>
									<cfset fechaAnotacion = LSDateFormat(now(),'dd/mm/yyyy')>
								</cfif>
								<cf_sifcalendario tabindex="1" form="formActivos" name="AFAfecha1" value="#fechaAnotacion#">
							</td>
						</tr>

					<!--- JMRV. Inicio. Muestra el campo de las observaciones. 18/07/2014 --->
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td nowrap align="right"><strong>Observaciones:</strong>&nbsp;</td>
								<td valign="top" id="cfportlet4tdcont" class="portlet_tdcontenido" colspan="3">
								 <table width="100%" align="center" cellspacing="0" cellpadding="0">
									<tbody>
										<tr>
											<td><cfif modo neq "ALTA">#rsForm.Observaciones#</cfif></td>
										</tr>
									</tbody>
								</table>
						       </td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					<!--- JMRV. Fin. 18/07/2014 --->

						<cfif modo NEQ 'ALTA'>
							<tr><td colspan="2" align="center">
							<cfquery datasource="#session.dsn#" name="rsImagen" maxrows="1">
									select
									a.Aid, a.AFAlinea,
									 a.AFimagen as logo, a.ts_rversion, a.AFextension as extension,
									 b.AFAtexto,a.AFnombre
									from AFImagenes a   inner join AFAnotaciones b
									   on a.Aid = b.Aid and a.AFAlinea = b.AFAlinea
									where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">
									and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
									and a.AFAlinea = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.AFAlinea#">
							  </cfquery>
								<cfif rsImagen.recordcount and Len(rsImagen.logo) GT 1 >
									<cfif rsImagen.extension neq '' and listContains(ListaImg,rsImagen.extension)>
										<cfinvoke component="sif.Componentes.DButils"
													method="toTimeStamp"
													returnvariable="tsurl">
											<cfinvokeargument name="arTimeStamp" value="#rsImagen.ts_rversion#"/>
										</cfinvoke>
										<img src="/cfmx/home/public/logo_activo.cfm?Aid=#form.Aid#&AFAlinea=#rsForm.AFAlinea#&ts=#tsurl#" style="width:150px; height:150px;"  border="0">
                                   <cfelse>
										<table align="center" border="0">
										  <tr>
											<td align="center"><strong>Archivo</strong></td>
											<td align="center"><strong>Descargar</strong></td>
										</tr>
										<tr>
											<td align="center">#rsImagen.AFnombre#</td>
											<td align="center"><img alt='Descargar Archivo' border='0' style="cursor:pointer;" src='../../imagenes/RS_D.gif' onClick='javascript:sbDownload(<cfoutput>#rsImagen.Aid#</cfoutput>, <cfoutput>#rsImagen.AFAlinea#</cfoutput>);'/> </td>
										</tr>
										</table>
								   </cfif>
								<cfelse>
									<table width="50%" align="center" border="0" cellspacing="0" cellpadding="0">
										<tr>

											<td align="center">La &Uacute;ltima anotaci&oacute;n no registró una im&aacute;gen o archivo del Activo.</td>

										</tr>
									</table>
								</cfif>
								</td></tr>
						</cfif>

						<tr><td colspan="2">&nbsp;</td></tr>
						<cfif isdefined("form.consulta") and len(trim(form.consulta)) and form.consulta eq 'N'>
						<tr>
							<td colspan="2" align="center">
								<cf_botones modo="#modo#" tabindex="1">
							</td>
						</tr>
						</cfif>
					</table>

					<!--- Campos ocultos para mantener el filtro (si existe)--->
					<cfif isdefined("form.f_AFAfecha") and len(trim(form.f_AFAfecha))>
						<input type="hidden" name="f_AFAfecha" value="#trim(form.f_AFAfecha)#">
					</cfif>
					<cfif isdefined("form.f_AFAtexto") and len(trim(form.f_AFAtexto))>
						<input type="hidden" name="f_AFAtexto" value="#trim(form.f_AFAtexto)#">
					</cfif>

				</form>
			</cfoutput>
		</td>
	</tr>
</table>

<cf_qforms form="formActivos">
<script language="JavaScript1.2" type="text/javascript">
	<cfoutput>
		objForm.Anotacion.description="#JSStringFormat('Anotación')#";
		objForm.AFAfecha1.description="#JSStringFormat('Fecha Anotación')#";
	</cfoutput>

	function habilitarValidacion() {
		objForm.Anotacion.required = true;
		objForm.AFAfecha1.required = true;
	}

	function deshabilitarValidacion() {
		objForm.Anotacion.required = false;
		objForm.AFAfecha1.required = false;
	}
	function extraeNombre(value){
	 var extensionTemp = "";
	  var nombreArchivo = "";

	 for(i=value.length-1;i>=0;i--)
	  {
		  if(value.charAt(i) == '.')
			{
			   break;
			}
		    else
		    {
		     extensionTemp = value.charAt(i)+extensionTemp ;
		    }
	   }

		document.formActivos.AFnombreImagen.value=extensionTemp;

	 for(i=value.length-1;i>=0;i--)
	  {
		  if(value.charAt(i) == '\\')
			{
			   break;
			}
		    else
		    {
		     nombreArchivo = value.charAt(i)+nombreArchivo ;
		    }
	   }

		document.formActivos.AFnombre.value=nombreArchivo;


	}
	function sbDownload(Aid,AFAlinea)
	{
		location.href = "Activos_frameAnotacion_sql.cfm?Aid=" + Aid + "&AFAlinea=" + AFAlinea + "&Download";
	}
	objForm.Anotacion.obj.focus();
</script>