<cfset checked   = "<img border=0 src=/cfmx/sif/imagenes/checked.gif>" >
<cfset unchecked = "<img border=0 src=/cfmx/sif/imagenes/unchecked.gif>" >
<cf_templateheader title="Destinos de Salida de Activos">
	<cf_web_portlet_start titulo="Cat&aacute;logo de Destinos de Salidas">
	<br>
	<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="60%" valign="top">
				<cfif isDefined("Url.AFDSid") and not isDefined("form.AFDSid")>
				  <cfset form.AFDSid = Url.AFDSid>
				</cfif>
				<cfif isDefined("Url.AFDdescripcion") and not isDefined("form.AFDdescripcion")>
				  <cfset form.AFDdescripcion = Url.AFDdescripcion>
				</cfif>

				<cfif isDefined("Url.AFDcodigo") and not isDefined("form.AFDcodigo")>
				  <cfset form.AFDcodigo = Url.AFDcodigo>
				</cfif>

				<!--- Variables para Navegación --->
				<cfif isdefined("url.FiltroAFDdescripcion") and len(trim(url.FiltroAFDdescripcion))>
					<cfset form.FiltroAFDdescripcion = url.FiltroAFDdescripcion>
				</cfif>
				<cfif isdefined("url.FiltroAFDcodigo") and len(trim(url.FiltroAFDcodigo))>
					<cfset form.FiltroAFDcodigo = url.FiltroAFDcodigo>
				</cfif>

				<cfif isdefined("url._")>
					<cf_navegacion name = "FiltroAFDcodigo" default = "">
					<cf_navegacion name = "FiltroAFDdescripcion" default = "">
				<cfelse>
					<cf_navegacion name = "FiltroAFDcodigo" default = "" session="">
					<cf_navegacion name = "FiltroAFDdescripcion" default = "" session="">
				</cfif>


				<cfquery name="rsLista" datasource="#session.dsn#">
                select
                    a.Ecodigo,
                    a.AFDSid,
                    a.AFDcodigo,
                    a.AFDdescripcion
				from AFDestinosSalida a
					where a.Ecodigo = #session.Ecodigo#
					<cfif isdefined('form.FiltroAFDdescripcion')and len(trim(form.FiltroAFDdescripcion)) >
						and upper(a.AFDdescripcion) like upper('%#form.FiltroAFDdescripcion#%')
					</cfif>
					<cfif isdefined('form.FiltroAFDcodigo')and len(trim(form.FiltroAFDcodigo)) >
						and upper(a.AFDcodigo) like upper('%#form.FiltroAFDcodigo#%')
					</cfif>
				</cfquery>
			<cfoutput>
				<form action="destinoSalida_SQL.cfm" name="form2" method="post">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0px;">
					<tr>
						<td class="titulolistas" colspan="1"><strong>Destino</strong></td>
						<td class="titulolistas" colspan="2"><strong>Descripci&oacute;n</strong></td>
					</tr>
					<tr>
						<td class="titulolistas"><input type="text" name="FiltroAFDcodigo"  tabindex="1" value="<cfif isdefined('form.FiltroAFDcodigo')>#form.FiltroAFDcodigo#</cfif>" size="10" maxlength="10"></td>
						<td class="titulolistas"><input type="text" name="FiltroAFDdescripcion"  tabindex="1" value="<cfif isdefined('form.FiltroAFDdescripcion')>#form.FiltroAFDdescripcion#</cfif>" size="60" maxlength="60"></td>
						<td class="titulolistas"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="2" onclick="funcFiltrar();" /></td>
					</tr>
					<tr><td colspan="4"><hr></td></tr>
				</table>
					<input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);" style="background:background-color ">
					<label for="chkTodos">Seleccionar Todos</label>
				</form>

			</cfoutput>
				<cfif isdefined('form.FiltroAFDcodigo')and len(trim(form.FiltroAFDcodigo)) or
				isdefined('form.FiltroAFDdescripcion')and len(trim(form.FiltroAFDdescripcion)) >
					<cfset LvarDireccion = 'destinoSalida.cfm'>
				<cfelse>
					<cfset LvarDireccion = 'destinoSalida.cfm?_'>
				</cfif>

				<cfinvoke
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="rsLista"
					query="#rsLista#"
					columnas="AFDcodigo,AFDdescripcion"
					desplegar="AFDcodigo,AFDdescripcion"
					etiquetas="Destino,Descripci&oacute;n"
					formatos="S,S"
					align="left,left"
					ajustar="S"
					keys="AFDcodigo"
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
					<cfinclude template="destinoSalida_form.cfm">
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
				alert('Debe de seleccionar al menos un destino.');
				return false;
			}
			if (confirm("¿Está seguro de que desea Eliminar lo(s) destino(s) seleccionado(s)?")) {

				document.form3.action = "destinoSalida_SQL.cfm";

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
			document.form2.action='destinoSalida.cfm';
			document.form2.submit;
		}
</script>
