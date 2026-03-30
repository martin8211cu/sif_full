<!--- VARIABLES DE TRADUCCION --->
<!---============= TRADUCCION ================---->
<cfinvoke Key="BTN_Crear_Nuevo" Default="Crear Nuevo" returnvariable="BTN_Crear_Nuevo" component="sif.Componentes.Translate"method="Translate"/>
<cfinvoke Key="BTN_Regresar" Default="Regresar" returnvariable="BTN_Regresar" component="sif.Componentes.Translate" method="Translate" xmlfile='/rh/generales.xml'/>
<cfinvoke Key="BTN_Listado" Default="Listado" returnvariable="BTN_Listado" component="sif.Componentes.Translate" method="Translate" xmlfile='/rh/generales.xml'/>
<cfinvoke Key="BTN_Consultar" Default="Consultar" returnvariable="BTN_Consultar"component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_Regresar" Default="Regresar" returnvariable="BTN_Regresar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_Formato" Default="Formato"	 returnvariable="MSG_Formato" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_Empleado" Default="Empleado"	 returnvariable="MSG_Empleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_Fecha" Default="Fecha"	 returnvariable="MSG_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isdefined("url.DEid") and len(trim(url.DEid)) gt 0>
	<cfset form.DEid = url.DEid>
</cfif>
<cfparam name="form.DEid" default=""><!--- OPCIONAL --->
<cfif isdefined('url.IEid') and not isdefined('form.IEid')>
	<cfset form.IEid = url.IEid>
</cfif>
<cfif isdefined('url.EFEid') and not isdefined('form.EFEid')>
	<cfset form.EFEid = url.EFEid>
</cfif>
<!------>
<cfquery name="rsFormatos2" datasource="#Session.DSN#">
	select distinct b.EFEid,
		   {fn concat(c.TEdescripcion,{fn concat(': ',{fn concat(<cf_dbfunction name="to_char" args="b.EFEcodigo" >,{fn concat(' - ',b.EFEdescripcion)})})})} as Descripcion
	from UsuariosTipoExpediente a

	inner join EFormatosExpediente b
	  on a.TEid = b.TEid

	inner join TipoExpediente c
	  on a.TEid = c.TEid

	where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	order by 2
</cfquery>


<!--- Tipo de Expediente --->
<cfquery name="rs_parametro_920" datasource="#session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo = 920
</cfquery>

<cfif len(trim(rs_parametro_920.Pvalor))>
	<cfquery name="rs_expediente" datasource="#session.DSN#">
		select TEid, TEcodigo, TEdescripcion
		from TipoExpediente
		where TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_parametro_920.Pvalor#">
	</cfquery>
</cfif>
<!--- Tipo de Formato por Expediente --->
<cfquery name="rs_parametro_930" datasource="#session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo = 930
</cfquery>
<cfif len(trim(rs_parametro_930.Pvalor))>
	<cfquery name="rs_formato" datasource="#session.DSN#">
		select EFEid, EFEcodigo, EFEdescripcion
		from EFormatosExpediente
		where EFEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_parametro_930.Pvalor#">
	</cfquery>
</cfif>

<cfif isdefined("rs_expediente") and isdefined("rs_formato")>
	<cfset rsFormatos = querynew('TEid,TEcodigo,TEdescripcion,EFEid,EFEcodigo,EFEdescripcion') >
	<cfset QueryAddRow(rsFormatos)>
	<cfset QuerySetCell(rsFormatos, "TEid", rs_expediente.TEid)>
	<cfset QuerySetCell(rsFormatos, "TEcodigo", rs_expediente.TEcodigo)>
	<cfset QuerySetCell(rsFormatos, "TEdescripcion", rs_expediente.TEdescripcion )>
	<cfset QuerySetCell(rsFormatos, "EFEid", rs_formato.EFEid )>
	<cfset QuerySetCell(rsFormatos, "EFEcodigo", rs_formato.EFEcodigo)>
	<cfset QuerySetCell(rsFormatos, "EFEdescripcion", rs_formato.EFEdescripcion)>
</cfif>

<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
<script language="javascript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>




	<cfif isdefined("rsFormatos")>
		<cfoutput>
			<form name="form1" action="#GetFileFromPath(GetTemplatePath())#" method="post" style="margin: 0">
				<input type="hidden" name="o" value="3">
				<table width="95%" border="0" cellspacing="0" cellpadding="2" align="center">
				  <tr>
					<td colspan="2">&nbsp;</td>
				  </tr>
				  <tr>
					<td colspan="2" class="#Session.preferences.Skin#_thcenter"><cf_translate key="LB_Seleccione_el_formato_que_desea_trabajar">SELECCIONE EL FORMATO QUE DESEA TRABAJAR</cf_translate></td>
				  </tr>
				  <tr>
					<td colspan="2">&nbsp;</td>
				  </tr>

					<tr>
						<td class="fileLabel"><cf_translate key="LB_Formato">Formato</cf_translate>:</td>
					<td>
						<cfif isdefined("rsFormatos")>
							<!--- #rsFormatos.TEdescripcion#: #rsFormatos.EFEcodigo#-#rsFormatos.EFEdescripcion#
							<input type="hidden" name="EFEid" id="EFEid" value="#rsFormatos.EFEid#" /> --->

							<select name="EFEid">
								<!--- <option value=""><cf_translate key="LB_Seleccione_un_formato_de_expediente">(Seleccione un Formato de Expediente)</cf_translate></option> --->
							<cfloop query="rsFormatos2">
								<option value="#EFEid#" <cfif isdefined("rsFormatos.EFEid") and len(trim(rsFormatos.EFEid)) and rsFormatos.EFEid eq EFEid>  selected </cfif>>#Descripcion#</option>
							</cfloop>
							</select>
							<!------>
						<cfelse>
							<cf_translate key="LB_Debe_definir_en_Parametros_del_Sistema_el_Tipo_de_Expediente_y_Tipo_de_Formato_que_por_defecto_se_usaran_en_Medicina_de_Empresa">Debe definir en Par&aacute;metros del Sistema, el Tipo de Expediente y Tipo de Formato que por defecto se usaran en Medicina de Empresa.</cf_translate><br />
						</cfif>
					</td>
					<!---  <td><cf_translate key="LB_Tipo_Expediente_Medico">Tipo de Expediente M&eacute;dico</cf_translate>:</td>
					  <td>
						<cfquery name="rs_expedientes" datasource="#session.DSN#">
							select TEid, TEcodigo, TEdescripcion
							from TipoExpediente
							where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
							order by TEdescripcion
						</cfquery>
						<select name="TEid" onchange="javascript:cambiar_expediente(this.value);">
							<option value="">-<cf_translate key="LB_seleccionar" xmlfile="/rh/generales.xml">seleccionar</cf_translate> -</option>
							<cfloop query="rs_expedientes">
								<option value="#rs_expedientes.TEid#" <cfif (not isdefined('form.TEid') or LEN(TRIM(form.TEid)) EQ 0)  and isdefined("rs_parametro_920") and rs_parametro_920.Pvalor eq rs_expedientes.TEid>selected="selected"</cfif> <cfif isdefined('form.TEid') and form.TEid eq rs_expedientes.TEid>selected="selected"</cfif>>#rs_expedientes.TEdescripcion#</option>
							</cfloop>
						</select>
					  </td>
					</tr>

					<tr>
						<td><cf_translate key="LB_Tipo_Formato_Expediente">Tipo de Formato de Expediente M&eacute;dico</cf_translate>:</td>
						<td>
							<select name="EFEid">
								<option value="">-<cf_translate key="LB_seleccionar" xmlfile="/rh/generales.xml">seleccionar</cf_translate> -</option>
							</select>
							<iframe name="expediente" id="expediente" frameborder="0" width="0" height="0" style="display:none; visibility:hidden;"></iframe>
						</td>
					</tr>


					<script language="javascript1.2" type="text/javascript">
						function cambiar_expediente(id, id_selected){
							document.getElementById('expediente').src = '/cfmx/rh/Utiles/traerFormatosExpediente.cfm?id='+id+'&id_selected='+id_selected;
						}
						<cfif not isdefined('form.EFEid') and isdefined("rs_parametro_920") and len(trim(rs_parametro_920.Pvalor))>
							document.form1.EFEid.value = #rs_parametro_920.Pvalor#;
						<cfelseif LEN(TRIM(form.EFEid))>
							document.form1.EFEid.value = #form.EFEid#;
						</cfif>
					</script>--->
				  <tr>
					<td class="fileLabel"><cf_translate key="LB_Empleado">Empleado</cf_translate>:</td>
					<td>
					<!--- Por si se recibe el codigo de empleado desde la pantalla de la agenda médica --->
					<cfif Len(form.DEid) Is 0 Or REFind('^[0-9]+$', form.DEid)Is 0>
						<cfset QueryEmpleado=QueryNew("")>
					<cfelse>
						<cfquery datasource="#session.dsn#" name="QueryEmpleado">
							select 	NTIcodigo, DEid, DEidentificacion,
									{fn concat({fn concat({fn concat({ fn concat(DEnombre, ' ') },DEapellido1)}, ' ')},DEapellido2) } as NombreEmp
							from DatosEmpleado
							where DEid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#form.DEid#">
							  and Ecodigo = #session.Ecodigo#
						</cfquery>
					</cfif>
						<cf_rhempleado size="60" query="#QueryEmpleado#" showTipoId ="false" TipoId ="-1">
					</td>
				  </tr>
				  <tr>
					<td class="fileLabel"><cf_translate key="LB_Fecha">Fecha</cf_translate>:</td>
					<td>
						<cf_sifcalendario form="form1" name="IEfecha" value="#LSDateFormat(Now(), 'DD/MM/YYYY')#">
					</td>
				  </tr>
				  <tr>
					<td colspan="2">&nbsp;</td>
				  </tr>
				  <tr>
					<td colspan="2" align="center">
						<cfif isdefined("rsFormatos")>
							<input type="submit" name="btnCrear" class="btnNuevo" value="#BTN_Crear_Nuevo#">
							<input type="submit" name="btnConsultar"  class="btnFiltrar" value="#BTN_Consultar#" onClick="javascript: consultar();">
							<input type="button" name="btnRegresar"  class="btnAnterior" value="<cfif isdefined("cookie.expMedico_registrar") and cookie.expMedico_registrar eq 'Expediente-lista.cfm' >#BTN_Listado#<cfelse>#BTN_Regresar#</cfif>" onClick="javascript: regresar();">
						</cfif>
					</td>
				  </tr>
				  <tr>
					<td colspan="2">&nbsp;</td>
				  </tr>
				</table>
			</form>

		</cfoutput>

		<script language="javascript" type="text/javascript">
			qFormAPI.errorColor = "#FFFFCC";
			objForm = new qForm("form1");

			<cfoutput>
				<cfif isdefined("rsFormatos") and rsFormatos.recordCount GT 0>
				objForm.EFEid.required = true;
				objForm.EFEid.description = "#MSG_Formato#";
				</cfif>

				objForm.DEid.required = true;
				objForm.DEid.description = "#MSG_Empleado#";

				objForm.IEfecha.required = true;
				objForm.IEfecha.description = "#MSG_Fecha#";
			</cfoutput>
			function consultar(){
				objForm.IEfecha.required = false;
				<cfif isdefined("rsFormatos") and rsFormatos.recordCount GT 0>
				objForm.EFEid.required = false;
				</cfif>
				objForm.obj.action = "cons-expediente.cfm";
			}

			function regresar(){
				<cfif isdefined("cookie.expMedico_registrar") and cookie.expMedico_registrar eq 'Expediente-lista.cfm' >
					location.href = '/cfmx/rh/expedientemng/Expediente-lista.cfm';
				<cfelse>
					location.href = '/cfmx/rh/Medico/Consultorio.cfm';
				</cfif>
			}
			<cfif (isdefined('form.EFEid') and LEN(TRIM(form.EFEid))) or rs_parametro_920.RecordCount>
			cambiar_expediente(document.form1.TEid.value,'<cfoutput><cfif isdefined('form.EFEid') and LEN(TRIM(form.EFEid))>#form.EFEid#<cfelse>#rs_parametro_930.Pvalor#</cfif></cfoutput>');
			</cfif>
		</script>
	<cfelse>
		<br />
		<div align="center"><cf_translate key="LB_Debe_definir_en_Parametros_del_Sistema_el_Tipo_de_Expediente_y_Tipo_de_Formato_que_por_defecto_se_usaran_en_Medicina_de_Empresa">Debe definir en Par&aacute;metros del Sistema, el Tipo de Expediente y Tipo de Formato que por defecto se usaran en Medicina de Empresa.</cf_translate><br /></div>
		<br />
		<div align="center"><input type="button" name="Regresar" id="Regresar" class="btnAnterior" value="<cfoutput>#BTN_Regresar#</cfoutput>" onclick="javascript: location.href='/cfmx/rh/Medico/Consultorio.cfm';" /></div>
	</cfif>