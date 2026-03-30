<cfset checked   = "<img border=0 src=/cfmx/sif/imagenes/checked.gif>" >
<cfset unchecked = "<img border=0 src=/cfmx/sif/imagenes/unchecked.gif>" >
<cf_templateheader title="Estructura Programática">
	<cf_web_portlet_start titulo="Cat&aacute;logo de Estructuras">
	<br>
	<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="60%" valign="top">
				<cfif isDefined("Url.ID_Estr") and not isDefined("form.ID_Estr")>
				  <cfset form.ID_Estr = Url.ID_Estr>
				</cfif>
				<cfif isDefined("Url.EPdescripcion") and not isDefined("form.EPdescripcion")>
				  <cfset form.EPdescripcion = Url.EPdescripcion>
				</cfif>

				<cfif isDefined("Url.EPcodigo") and not isDefined("form.EPcodigo")>
				  <cfset form.EPcodigo = Url.EPcodigo>
				</cfif>

				<!--- Variables para Navegación --->
				<cfif isdefined("url.FiltroEPdescripcion") and len(trim(url.FiltroEPdescripcion))>
					<cfset form.FiltroEPdescripcion = url.FiltroEPdescripcion>
				</cfif>
				<cfif isdefined("url.FiltroEPcodigo") and len(trim(url.FiltroEPcodigo))>
					<cfset form.FiltroEPcodigo = url.FiltroEPcodigo>
				</cfif>

				<cfif isdefined("url._")>
					<cf_navegacion name = "FiltroEPcodigo" default = "">
					<cf_navegacion name = "FiltroEPdescripcion" default = "">
				<cfelse>
					<cf_navegacion name = "FiltroEPcodigo" default = "" session="">
					<cf_navegacion name = "FiltroEPdescripcion" default = "" session="">
				</cfif>


				<cfquery name="rsLista" datasource="#session.dsn#">
                select
                    a.Ecodigo,
                    a.ID_Estr,
                    a.EPcodigo,
                    a.EPdescripcion
				from CGEstrProg a
					where a.Ecodigo = #session.Ecodigo#
					<cfif isdefined('form.FiltroEPdescripcion')and len(trim(form.FiltroEPdescripcion)) >
						and upper(a.EPdescripcion) like upper('%#form.FiltroEPdescripcion#%')
					</cfif>
					<cfif isdefined('form.FiltroEPcodigo')and len(trim(form.FiltroEPcodigo)) >
						and upper(a.EPcodigo) like upper('%#form.FiltroEPcodigo#%')
					</cfif>
				</cfquery>
			<cfoutput>
				<form action="EstructuraP_SQL.cfm" name="form2" method="post">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0px;">
					<tr>
						<td class="titulolistas" colspan="1"><strong>C&oacute;digo</strong></td>
						<td class="titulolistas" colspan="2"><strong>Descripci&oacute;n</strong></td>
					</tr>
					<tr>
						<td class="titulolistas"><input type="text" name="FiltroEPcodigo"  tabindex="1" value="<cfif isdefined('form.FiltroEPcodigo')>#form.FiltroEPcodigo#</cfif>" size="5" maxlength="5"></td>
						<td class="titulolistas"><input type="text" name="FiltroEPdescripcion"  tabindex="1" value="<cfif isdefined('form.FiltroEPdescripcion')>#form.FiltroEPdescripcion#</cfif>" size="60" maxlength="60"></td>
						<td class="titulolistas"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="2" onclick="funcFiltrar();" /></td>
					</tr>
					<tr><td colspan="4"><hr></td></tr>
				</table>
					<input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);" style="background:background-color ">
					<label for="chkTodos">Seleccionar Todos</label>
				</form>

			</cfoutput>
				<cfif isdefined('form.FiltroEPcodigo')and len(trim(form.FiltroEPcodigo)) or
				isdefined('form.FiltroEPdescripcion')and len(trim(form.FiltroEPdescripcion)) >
					<cfset LvarDireccion = 'EstructuraP.cfm'>
				<cfelse>
					<cfset LvarDireccion = 'EstructuraP.cfm?_'>
				</cfif>

				<cfinvoke
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="rsLista"
					query="#rsLista#"
					columnas="EPcodigo,EPdescripcion"
					desplegar="EPcodigo,EPdescripcion"
					etiquetas="Código,Descripci&oacute;n"
					formatos="S,S"
					align="left,left"
					ajustar="S"
					keys="EPcodigo"
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
					<cfinclude template="EstructuraP_form.cfm">
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
				alert('Debe de seleccionar al menos una estructura.');
				return false;
			}
			if (confirm("¿Está seguro de que desea Eliminar la(s) estructura(s) seleccionado(s)?")) {

				document.form3.action = "EstructuraP_SQL.cfm";

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
			document.form2.action='EstructuraP.cfm';
			document.form2.submit;
		}
</script>
