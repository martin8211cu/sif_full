<cfset checked   = "<img border=0 src=/cfmx/sif/imagenes/checked.gif>" >
<cfset unchecked = "<img border=0 src=/cfmx/sif/imagenes/unchecked.gif>" >
<cf_templateheader title="Motivos de Salida">
	<cf_web_portlet_start titulo="Cat&aacute;logo Motivos de Salida de Activos">
	<br>
	<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="60%" valign="top">
				<cfif isDefined("Url.AFMSid") and not isDefined("form.AFMSid")>
				  <cfset form.AFMSid = Url.AFMSid>
				</cfif>
				<cfif isDefined("Url.AFMSdescripcion") and not isDefined("form.AFMSdescripcion")>
				  <cfset form.AFMSdescripcion = Url.AFMSdescripcion>
				</cfif>

				<cfif isDefined("Url.AFMScodigo") and not isDefined("form.AFMScodigo")>
				  <cfset form.AFMScodigo = Url.AFMScodigo>
				</cfif>

				<!--- Variables para Navegación --->
				<cfif isdefined("url.FiltroAFMSdescripcion") and len(trim(url.FiltroAFMSdescripcion))>
					<cfset form.FiltroAFMSdescripcion = url.FiltroAFMSdescripcion>
				</cfif>
				<cfif isdefined("url.FiltroAFMScodigo") and len(trim(url.FiltroAFMScodigo))>
					<cfset form.FiltroAFMScodigo = url.FiltroAFMScodigo>
				</cfif>

				<cfif isdefined("url._")>
					<cf_navegacion name = "FiltroAFMScodigo" default = "">
					<cf_navegacion name = "FiltroAFMSdescripcion" default = "">
				<cfelse>
					<cf_navegacion name = "FiltroAFMScodigo" default = "" session="">
					<cf_navegacion name = "FiltroAFMSdescripcion" default = "" session="">
				</cfif>


				<cfquery name="rsLista" datasource="#session.dsn#">
                select
                    a.Ecodigo,
                    a.AFMSid,
                    a.AFMScodigo,
                    a.AFMSdescripcion
				from AFMotivosSalida a
					where a.Ecodigo = #session.Ecodigo#
					<cfif isdefined('form.FiltroAFMSdescripcion')and len(trim(form.FiltroAFMSdescripcion)) >
						and upper(a.AFMSdescripcion) like upper('%#form.FiltroAFMSdescripcion#%')
					</cfif>
					<cfif isdefined('form.FiltroAFMScodigo')and len(trim(form.FiltroAFMScodigo)) >
						and upper(a.AFMScodigo) like upper('%#form.FiltroAFMScodigo#%')
					</cfif>
				</cfquery>
			<cfoutput>
				<form action="motivoSalida_SQL.cfm" name="form2" method="post">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0px;">
					<tr>
						<td class="titulolistas" colspan="1"><strong>C&oacute;digo</strong></td>
						<td class="titulolistas" colspan="2"><strong>Descripci&oacute;n</strong></td>
					</tr>
					<tr>
						<td class="titulolistas"><input type="text" name="FiltroAFMScodigo"  tabindex="1" value="<cfif isdefined('form.FiltroAFMScodigo')>#form.FiltroAFMScodigo#</cfif>" size="5" maxlength="5"></td>
						<td class="titulolistas"><input type="text" name="FiltroAFMSdescripcion"  tabindex="1" value="<cfif isdefined('form.FiltroAFMSdescripcion')>#form.FiltroAFMSdescripcion#</cfif>" size="60" maxlength="60"></td>
						<td class="titulolistas"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="2" onclick="funcFiltrar();" /></td>
					</tr>
					<tr><td colspan="4"><hr></td></tr>
				</table>
					<input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);" style="background:background-color ">
					<label for="chkTodos">Seleccionar Todos</label>
				</form>

			</cfoutput>
				<cfif isdefined('form.FiltroAFMScodigo')and len(trim(form.FiltroAFMScodigo)) or
				isdefined('form.FiltroAFMSdescripcion')and len(trim(form.FiltroAFMSdescripcion)) >
					<cfset LvarDireccion = 'motivoSalida.cfm'>
				<cfelse>
					<cfset LvarDireccion = 'motivoSalida.cfm?_'>
				</cfif>

				<cfinvoke
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="rsLista"
					query="#rsLista#"
					columnas="AFMScodigo,AFMSdescripcion"
					desplegar="AFMScodigo,AFMSdescripcion"
					etiquetas="Código,Descripci&oacute;n"
					formatos="S,S"
					align="left,left"
					ajustar="S"
					keys="AFMScodigo"
					irA="#LvarDireccion#"
					maxrows="15"
					pageindex="3"
					navegacion="#navegacion#"
					showEmptyListMsg= "true"
					checkboxes= "S"
					Botones ="Eliminar"
					form_method="post"
					formname= "form3"
					usaAJAX = "no"
					/>

					</td>
					<td width="5%">&nbsp;</td>
					<td width="55%" valign="top">
					<cfinclude template="motivoSalida_form.cfm">
					</td>
				</tr>
			</table>
		<br>
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="javascript" type="text/javascript">
		function algunoMarcado(){
			var aplica = false;
			if (document.form3.chk) {
				if (document.form3.chk.value) {
					aplica = document.form3.chk.checked;
				} else {
					for (var i=0; i<document.form3.chk.length; i++) {
						if (document.form3.chk[i].checked) {
							aplica = true;
							break;
						}
					}
				}
			}
			return aplica;
		}

		function funcEliminar(){
			if (!algunoMarcado()) {
				alert('Debe de seleccionar al menos un Motivo.');
				return false;
			}
			if (confirm("¿Está seguro de que desea Eliminar lo(s) motivo(s) seleccionado(s)?")) {

				document.form3.action = "motivoSalida_SQL.cfm";

				return true;
			}
			return false;
		}

		function Marcar(c) {
			if (c.checked) {
				for (counter = 0; counter < document.form3.chk.length; counter++)
				{
					if ((!document.form3.chk[counter].checked) && (!document.form3.chk[counter].disabled))
						{  document.form3.chk[counter].checked = true;}
				};
				if ((counter==0)  && (!document.form3.chk.disabled)) {
					document.form3.chk.checked = true;
				}
			}
			else {
				for (var counter = 0; counter < document.form3.chk.length; counter++)
				{
					if ((document.form3.chk[counter].checked) && (!document.form3.chk[counter].disabled))
						{  document.form3.chk[counter].checked = false;}
				};
				if ((counter==0) && (!document.form3.chk.disabled)) {
					document.form3.chk.checked = false;
				}
			};
		}

		function funcFiltrar(){
			document.form2.action='motivoSalida.cfm';
			document.form2.submit;
		}
</script>
