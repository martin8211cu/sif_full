<cfset checked   = "<img border=0 src=/cfmx/sif/imagenes/checked.gif>" >
<cfset unchecked = "<img border=0 src=/cfmx/sif/imagenes/unchecked.gif>" >
<cf_templateheader title="Evento">
	<cf_web_portlet_start titulo="Cat&aacute;logo de Eventos">
	<br>
	<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="60%" valign="top">
				<cfif isDefined("Url.ID_Evento") and not isDefined("form.ID_Evento")>
				  <cfset form.ID_Evento = Url.ID_Evento>
				</cfif>		
				<cfif isDefined("Url.EVdescripcion") and not isDefined("form.EVdescripcion")>
				  <cfset form.EVdescripcion = Url.EVdescripcion>
				</cfif>
                
				<cfif isDefined("Url.EVcodigo") and not isDefined("form.EVcodigo")>
				  <cfset form.EVcodigo = Url.EVcodigo>
				</cfif>
                
				<!--- Variables para Navegación --->
				<cfif isdefined("url.FiltroEVdescripcion") and len(trim(url.FiltroEVdescripcion))>
					<cfset form.FiltroEVdescripcion = url.FiltroEVdescripcion>
				</cfif>	
				<cfif isdefined("url.FiltroEVcodigo") and len(trim(url.FiltroEVcodigo))>
					<cfset form.FiltroEVcodigo = url.FiltroEVcodigo>
				</cfif>			
						
				<cfif isdefined("url._")>
					<cf_navegacion name = "FiltroEVcodigo" default = "">
					<cf_navegacion name = "FiltroEVdescripcion" default = "">
				<cfelse>
					<cf_navegacion name = "FiltroEVcodigo" default = "" session="">
					<cf_navegacion name = "FiltroEVdescripcion" default = "" session="">
				</cfif>	


				<cfquery name="rsLista" datasource="#session.dsn#">
                select 
                    a.Ecodigo,
                    a.ID_Evento,
                    a.EVcodigo,
                    a.EVdescripcion,
                    case when a.EVactivo = 0 then '#unchecked#' else '#checked#' end as EVactivo
				from EEvento a
					where a.Ecodigo = #session.Ecodigo# 
					<cfif isdefined('form.FiltroEVdescripcion')and len(trim(form.FiltroEVdescripcion)) >
						and upper(a.EVdescripcion) like upper('%#form.FiltroEVdescripcion#%')
					</cfif>	
					<cfif isdefined('form.FiltroEVcodigo')and len(trim(form.FiltroEVcodigo)) >
						and upper(a.EVcodigo) like upper('%#form.FiltroEVcodigo#%')
					</cfif>	
                    and a.EVgenerico = 0
				</cfquery>	
			<cfoutput>
				<form action="Evento_SQL.cfm" name="form2" method="post">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0px;">
					<tr>
						<td class="titulolistas" colspan="1"><strong>C&oacute;digo</strong></td>
						<td class="titulolistas" colspan="2"><strong>Descripci&oacute;n</strong></td>
					</tr>
					<tr>
						<td class="titulolistas"><input type="text" name="FiltroEVcodigo"  tabindex="1" value="<cfif isdefined('form.FiltroEVcodigo')>#form.FiltroEVcodigo#</cfif>" size="5" maxlength="5"></td>
						<td class="titulolistas"><input type="text" name="FiltroEVdescripcion"  tabindex="1" value="<cfif isdefined('form.FiltroFTdescripcion')>#form.FiltroEVdescripcion#</cfif>" size="60" maxlength="60"></td>
						<td class="titulolistas"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="2" onclick="funcFiltrar();" /></td>
					</tr>
					<tr><td colspan="4"><hr></td></tr>
				</table> 
					<input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);" style="background:background-color ">
					<label for="chkTodos">Seleccionar Todos</label>
				</form>	
				
			</cfoutput>
				<cfif isdefined('form.FiltroEVcodigo')and len(trim(form.FiltroEVcodigo)) or 
				isdefined('form.FiltroEVdescripcion')and len(trim(form.FiltroEVdescripcion)) >
					<cfset LvarDireccion = 'Evento.cfm'>
				<cfelse>
					<cfset LvarDireccion = 'Evento.cfm?_'>
				</cfif>
				
				<cfinvoke
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="rsLista"
					query="#rsLista#"
					columnas="EVcodigo,EVdescripcion,EVactivo"
					desplegar="EVcodigo,EVdescripcion,EVactivo"
					etiquetas="Código,Descripci&oacute;n,Activo"
					formatos="S,S,U"
					align="left,left,left"
					ajustar="S"
					keys="EVcodigo"
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
					<cfinclude template="Evento_form.cfm"> 
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
				alert('Debe de seleccionar al menos un evento.');
				return false;			
			}	
			if (confirm("¿Está seguro de que desea Eliminar el Evento(s) seleccionado(s)?")) {
				
				document.form3.action = "Evento_SQL.cfm";
				
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
			document.form2.action='Evento.cfm';
			document.form2.submit;
		}
</script>		
