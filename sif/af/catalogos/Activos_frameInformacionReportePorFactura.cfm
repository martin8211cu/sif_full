<cfset ListaImg = "JPG,BMP,GIF,PNG">
<cf_dbfunction name="OP_concat"	args="" returnvariable="LvarConcat">
<!--- Validaciones --->
<cfif not isdefined("form.Ecodigo") >
	<cfset form.Ecodigo = #session.Ecodigo#>
</cfif>

<cfif isdefined("url.Auto") and len(trim(url.Auto))>
	<cfset form.Auto = url.Auto>
</cfif>

<cfif not isdefined("form.Auto")>
	<cfset form.Auto = 'N'>
</cfif>

<cfif isdefined("url.AID") and len(trim(url.AID)) and not isdefined('form.AID')>
		<cfset form.AID = url.AID>
	</cfif>

<cfif form.Auto eq 'S'>
	<cfif isdefined("url.AID") and len(trim(url.AID))>
		<cfset form.AID = url.AID>
	</cfif>

	<cfset form.Ecodigo = #session.Ecodigo#>
	<cfset form.consulta = 'S'>

	<cf_templatecss>
	<title>Informaci&oacute;n del Activo</title>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Informaci&oacute;n del Activo'>
</cfif>


<!--- Invocaciones del componente Activo --->
<cfinvoke component="sif.af.Componentes.Activo" method="getActivo" Aid="#form.Aid#" Ecodigo="#form.Ecodigo#" returnvariable="rsActivo"/>
<cfinvoke component="sif.af.Componentes.Activo" method="getCurrentAnotacion" Aid="#form.Aid#" Ecodigo="#form.Ecodigo#" returnvariable="rsAnotacion"/>
<cfinvoke component="sif.af.Componentes.Activo" method="getCurrentSaldos" Aid="#form.Aid#" Ecodigo="#form.Ecodigo#"  returnvariable="rsSaldos">
	<cfif isdefined("form.Periodofin") and len(trim(form.Periodofin)) and form.Periodofin gt 0>
		<cfinvokeargument name="Periodo" value="#form.Periodofin#">
		<cfif isdefined("form.Mesfin") and len(trim(form.Mesfin)) and form.Mesfin gt 0>
			<cfinvokeargument name="Mes" value="#form.Mesfin#">
		<cfelse>
			<cfinvokeargument name="Mes" value="12">
		</cfif>
	</cfif>
</cfinvoke>
<!--- Obtiene el nombre del archivo de la pantalla actual --->
<cfset archivo = GetFileFromPath(GetTemplatePath())>
<cfif form.Auto eq 'S'>
	<cfset archivo = 'Activos.cfm'>
</cfif>
<cfoutput>
	<!--- Pintado de la Información --->
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
  	<tr>
    <td valign="top" alang="center">
	<table width="100%" cellpadding="2" cellspacing="0" align="center">
				<tr><td nowrap>&nbsp;</td></tr>
				<tr><td nowrap>&nbsp;</td></tr>
				<tr>
					<td><strong><font size="+1">Informaci&oacute;n General</font></strong></td>
				</tr>
				<tr><td nowrap>&nbsp;</td></tr>

				<tr>
					<td nowrap align="right">Placa:</td>
					<td ><strong>#rsActivo.Aplaca#</strong></td>
					<td nowrap align="right">Numero de Serie:</td>
					<td><strong>#rsActivo.Aserie#</strong></td>
				</tr>
				<tr>
					<td nowrap align="right">Descripci&oacute;n:</td>
					<td nowrap><strong>#rsActivo.Adescripcion#</strong></td>
					<td width="13%" nowrap div align="right">Marca:</td>
					<td colspan="2"><strong>#rsActivo.AFMdescripcion#</strong></td>

				</tr>

				<tr>
					<td nowrap align="right">Estado:</td>
					<td><strong><cfif rsActivo.Astatus eq 0>Activo<cfelse>Retirado</cfif></strong></td>
					<td width="13%" nowrap div align="right">Modelo:</td>
					<td colspan="2"><strong>#rsActivo.AFMMdescripcion#</strong></td>
				</tr>

				<tr>
					<td nowrap align="right">Factura:</td>
					<td><strong>#rsActivo.Documento#</strong></td>
					<td width="13%" nowrap div align="right">Tipo:</td>
				  	<td colspan="2"><strong>#rsActivo.AFCdescripcion#</strong></td>
				</tr>

				<tr>
					<td nowrap align="right">Responsable:</td>
					<td colspan="2"><strong>#rsSaldos.query.empleado#</strong></td>
				</tr>

				<tr>
					<td nowrap align="right">Depreciable:</td>
					<td colspan="2"><strong><cfif rsActivo.ACdepreciable EQ "S">SI<cfelse>NO</cfif></strong></td>
				</tr>

				<tr>
					<td nowrap align="right">Revaluable:</td>
					<td colspan="2"><strong><cfif rsActivo.ACrevalua EQ "S">SI<cfelse>NO</cfif></strong></td>
				</tr>

				<tr><td nowrap>&nbsp;</td></tr>
				<tr><td nowrap>&nbsp;</td></tr>
				<tr>
					<td><strong><font size="+1">Valores del Activo</font></strong></td>
				</tr>
				<tr><td nowrap>&nbsp;</td></tr>

				<tr>
					<td nowrap align="right">Vida &Uacute;til:</td>
				  	<td><strong>#rsActivo.Avutil#&nbsp;meses</strong></td>
				  	<td width="13%" nowrap div align="right">Fecha Adquisici&oacute;n:</td>
					<td width="30%"><strong>#LSDateFormat(rsActivo.Afechaadq,"dd/mm/yyyy")#</strong></td>
				</tr>

				<tr>
					<td nowrap align="right">Valor Residual:</td>
					<td><strong>#LSCurrencyFormat(rsActivo.Avalrescate,"none")#</strong></td>
					<td nowrap align="right">Inicio Depreciaci&oacute;n:</td>
					<td><strong>#LSDateFormat(rsActivo.Afechainidep,"dd/mm/yyyy")#</strong></td>
				</tr>

				<tr>
					<td nowrap align="right">Saldo Vida &Uacute;til:</td>
					<td><strong><cfif trim(rsActivo.AFSsaldovutiladq) GT 0>#rsActivo.AFSsaldovutiladq#<cfelse>0</cfif> meses</strong></td>
					<td nowrap align="right">Inicio Revaluaci&oacute;n:</td>
					<td><strong>#LSDateFormat(rsActivo.Afechainirev,"dd/mm/yyyy")#</strong></td>
				</tr>

				<tr><td nowrap>&nbsp;</td></tr>
				<tr><td nowrap>&nbsp;</td></tr>
				<tr>
					<td><strong><font size="+1">Saldos del Activo</font></strong></td>
				</tr>
				<tr><td nowrap>&nbsp;</td></tr>

				<tr>
					<td nowrap="nowrap" align="right"> Valor de Adquisici&oacute;n:</td>
					<td><strong>#LSCurrencyFormat(rsSaldos.query.AFSvaladq,"none")#</strong></td>
					<td nowrap="nowrap" align="right"> Dep. Acum. de Adquisici&oacute;n:&nbsp;</td>
					<td><strong>#LSCurrencyFormat(rsSaldos.query.AFSdepacumadq,"none")#</strong></td>
				</tr>

				<tr>
					<td nowrap="nowrap" align="right"> Valor de Mejoras:&nbsp;</td>
					<td><strong>#LSCurrencyFormat(rsSaldos.query.AFSvalmej,"none")#</strong></td>
					<td nowrap="nowrap" align="right"> Dep. Acum. de Mejoras:&nbsp;</td>
					<td><strong>#LSCurrencyFormat(rsSaldos.query.AFSdepacummej,"none")#</strong></td>
				</tr>

				<tr>
					<td nowrap="nowrap" align="right"> Valor de Revaluaci&oacute;n:&nbsp;</td>
					<td><strong>#LSCurrencyFormat(rsSaldos.query.AFSvalrev,"none")#</strong></td>
					<td nowrap="nowrap" align="right"> Dep. Acum. de Revaluaci&oacute;n:&nbsp;</td>
					<td><strong>#LSCurrencyFormat(rsSaldos.query.AFSdepacumrev,"none")#</strong></td>
				</tr>

				<tr>
					<td colspan="2">&nbsp;</td>
					<td nowrap="nowrap" align="right"> Valor en Libros:&nbsp;</td>
					<td><strong>#LSCurrencyFormat(rsSaldos.query.AFSvallibros,"none")#</strong></td>
				</tr>
		</table>
	<br>
	</td>
	<cfif archivo EQ "Activos.cfm" and rsActivo.Astatus EQ 0 >
	<td valign="top" width="300">
		<!--- Información Adicional solo se observa en el Mantenimiento --->
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr><td nowrap>&nbsp;</td></tr>
		<!--- Pintado de Tipificación del Activo --->
		<tr>
		<td valign="top">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Tipificación del Activo'>
			<cfinclude template="jerarquiaArbol.cfm" >
		<cf_web_portlet_end>
		</td>
		</tr>
		<tr><td nowrap>&nbsp;</td></tr>
		<cfif rsSaldos.query.recordcount gt 0>
			<!--- información general --->
			<tr>
			<td valign="top">
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='información general'>
				<table width="100%" cellpadding="0" cellspacing="0" align="center">
					<tr>
						<td><strong>Empresa</strong></td>
					</tr>
					<tr>
						<td>&nbsp;&nbsp;#rsSaldos.query.Edescripcion#</td>
					</tr>
					<tr>
						<td><strong>Centro Funcional</strong></td>
					</tr>
					<tr>
						<td>&nbsp;&nbsp;#rsSaldos.query.CFcodigo#-#rsSaldos.query.CFdescripcion# </td>
					</tr>
					<tr>
						<td><strong>Responsable</strong></td>
					</tr>
					<tr>
						<td>&nbsp;&nbsp;#rsSaldos.query.empleado#</td>
					</tr>
				</table>
			<cf_web_portlet_end>
			</td>
			</tr>
			<tr><td nowrap>&nbsp;</td></tr>
		</cfif>
		<!--- Pintado de la Anotación Vigente --->
		<tr>
		<td align="center" valign="top">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='&Uacute;ltima Anotaci&oacute;n del Activo'>
		<cfif rsAnotacion.recordcount gt 0>
			<table width="100%" cellpadding="0" cellspacing="0" align="center">
					<tr><td>&nbsp;</td></tr>
					<tr><td align="center">
						<cfquery datasource="#session.dsn#" name="rsImagen" maxrows="1">
							select
							a.Aid, a.AFAlinea,
							a.AFimagen as logo, a.ts_rversion,
							a.AFextension as extension,
							b.AFAtexto, a.AFnombre
							from AFImagenes a inner join  AFAnotaciones b
							 on a.Aid = b. Aid  and a.AFAlinea = b.AFAlinea
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">
								and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
								and a.AFAlinea = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAnotacion.AFAlinea#">
						</cfquery>
						<cfif rsImagen.recordcount and Len(rsImagen.logo) GT 1>
						  <cfif rsImagen.extension neq '' and listContains(ListaImg,rsImagen.extension)>
								<cfinvoke component="sif.Componentes.DButils"
											method="toTimeStamp"
											returnvariable="tsurl">
									<cfinvokeargument name="arTimeStamp" value="#rsImagen.ts_rversion#"/>
								</cfinvoke>
								<img src="/cfmx/home/public/logo_activo.cfm?Aid=#form.Aid#&AFAlinea=#rsAnotacion.AFAlinea#&ts=#tsurl#" style="width:150px; height:150px"  border="0">
								<img src="/cfmx/home/public/logo_activo.cfm?Aid=#form.Aid#&AFAlinea=#rsAnotacion.AFAlinea#&ts=#tsurl#"  border="0">
							<cfelse>
							   <table align="center" border="0">
								  <tr>
									<td align="center"><strong>Archivo</strong></td>
									<td align="center"><strong>Descargar</strong></td>
								</tr>
								<tr>
									<td align="center">#rsImagen.AFnombre#</td>
									<td align="center"><img alt='Descargar Archivo' style="cursor:pointer;" border='0' src='../../imagenes/RS_D.gif' onClick='javascript:sbDownload(<cfoutput>#rsImagen.Aid#</cfoutput>, <cfoutput>#rsImagen.AFAlinea#</cfoutput>);'/> </td>
								</tr>
							</cfif>
						<cfelse>
							<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">Imágen no registrada.</td>
								</tr>
							</table>
						</cfif>
					</td></tr>
				</table>
			<table width="95%" cellpadding="2" cellspacing="0" border="0" align="center">
				<tr>
					<td>&nbsp;</td>
					<td align="center"><strong>#LSDateFormat(rsAnotacion.AFAfecha1,'dd/mm/yyyy')#</strong>:&nbsp;#rsAnotacion.AFAtexto#</td>
				</tr>
			</table>
		<cfelse>
			No hay anotaciones registradas para este Activo.
		</cfif>
		<cf_web_portlet_end>
		</td>
		</tr>
		</table>
		<br />
		<form action="ListaActivos.cfm" method="post" name="formN">
			<cfif isdefined("form.consulta") and len(trim(form.consulta)) and form.consulta eq 'S'>
					<cfif form.Auto eq 'N'>
						<cf_botones values="Regresar" names="Regresar">
					</cfif>
			<cfelse>
					<cf_botones values="Modificar Activo, Regresar" names="Modificar, Regresar">
			</cfif>

		</form>
		<cfoutput>
		<script language="javascript1.2" type="text/javascript">
			<cfif isdefined("form.consulta") and len(trim(form.consulta)) and form.consulta eq 'N'>
				function funcModificar() {
					open('Activos_frameActivo.cfm?Aid=#form.aid#', 'Activos', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height=230,left=250, top=200,screenX=250,screenY=200');
					return false;
				}
			<cfelse>
				function funcRegresar(){
					document.formN.action = "../consultas/ActivosEnCE/Activos.cfm";
					document.formN.submit();
				}
			</cfif>
		</script>
		</cfoutput>
	</td>
	</cfif>
	</tr>
	</table>
	<script language="javascript1.2" type="text/javascript">
	function sbDownload(Aid,AFAlinea)
	{
		location.href = "Activos_frameAnotacion_sql.cfm?Aid=" + Aid + "&AFAlinea=" + AFAlinea + "&Download";
	}
	</script>
</cfoutput>