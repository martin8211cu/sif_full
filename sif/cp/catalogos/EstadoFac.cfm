<cf_templateheader title="Estado">
	<cf_web_portlet_start titulo="Estados de Factura">
	<br>
	<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="60%" valign="top">
				<cfif isDefined("Url.FTidEstado") and not isDefined("form.FTidEstado")>
				  <cfset form.FTidEstado = Url.FTidEstado>
				</cfif>		
				<cfif isDefined("Url.FTdescripcion") and not isDefined("form.FTdescripcion")>
				  <cfset form.FTdescripcion = Url.FTdescripcion>
				</cfif>
				<cfif isDefined("Url.FTcodigo") and not isDefined("form.FTcodigo")>
				  <cfset form.FTcodigo = Url.FTcodigo>
				</cfif>
				<!--- Variables para Navegación --->
				<cfif isdefined("url.FiltroFTdescripcion") and len(trim(url.FiltroFTdescripcion))>
					<cfset form.FiltroFTdescripcion = url.FiltroFTdescripcion>
				</cfif>	
				<cfif isdefined("url.FiltroFTcodigo") and len(trim(url.FiltroFTcodigo))>
					<cfset form.FiltroFTcodigo = url.FiltroFTcodigo>
				</cfif>			
						
				<cfif isdefined("url._")>
					<cf_navegacion name = "FiltroFTcodigo" default = "">
					<cf_navegacion name = "FiltroFTdescripcion" default = "">
				<cfelse>
					<cf_navegacion name = "FiltroFTcodigo" default = "" session="">
					<cf_navegacion name = "FiltroFTdescripcion" default = "" session="">
				</cfif>					
				<cfquery name="rsLista" datasource="#session.dsn#">
					select 
						a.FTidEstado,
						a.Ecodigo ,
						a.FTcodigo,
						a.FTdescripcion ,
						case a.FTfolio when 1 then 'S' when 0 then 'N' else '' end as FTfolio,
						a.ts_rversion 
					from EstadoFact a
					where a.Ecodigo = #session.Ecodigo# 
<!---					and a.FTPvalorAutomatico = 0
--->					<cfif isdefined('form.FiltroFTdescripcion')and len(trim(form.FiltroFTdescripcion)) >
						and upper(a.FTdescripcion) like upper('%#form.FiltroFTdescripcion#%')
					</cfif>	
					<cfif isdefined('form.FiltroFTcodigo')and len(trim(form.FiltroFTcodigo)) >
						and upper(a.FTcodigo) like upper('%#form.FiltroFTcodigo#%')
					</cfif>	
				</cfquery>	
				
			<cfoutput>
				<form action="EstadoFac_SQL.cfm" name="form2" method="post">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0px;">
					<tr>
						<td class="titulolistas" colspan="1"><strong>C&oacute;digo</strong></td>
						<td class="titulolistas" colspan="2"><strong>Descripci&oacute;n</strong></td>
					</tr>
					<tr>
						<td class="titulolistas"><input type="text" name="FiltroFTcodigo"  tabindex="1" value="<cfif isdefined('form.FiltroFTcodigo')>#form.FiltroFTcodigo#</cfif>"></td>
						<td class="titulolistas"><input type="text" name="FiltroFTdescripcion"  tabindex="1" value="<cfif isdefined('form.FiltroFTdescripcion')>#form.FiltroFTdescripcion#</cfif>"></td>
						<td class="titulolistas"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="2" onclick="funcFiltrar();" /></td>
					</tr>
					<tr><td colspan="4"><hr></td></tr>
				</table> 
					<input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);" style="background:background-color ">
					<label for="chkTodos">Seleccionar Todos</label>
				</form>	
				
			</cfoutput>
				<cfif isdefined('form.FiltroFTcodigo')and len(trim(form.FiltroFTcodigo)) or isdefined('form.FiltroFTdescripcion')and len(trim(form.FiltroFTdescripcion)) >
					<cfset LvarDireccion = 'EstadoFac.cfm'>
				<cfelse>
					<cfset LvarDireccion = 'EstadoFac.cfm?_'>
				</cfif>
				
				<cfinvoke
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="rsLista"
					query="#rsLista#"
					columnas="FTcodigo,FTdescripcion,case FTfolio when 1 then 'S' when 0 then 'N' end as FTfolio"
					desplegar="FTcodigo,FTdescripcion, FTfolio"
					etiquetas="Código,Descripci&oacute;n,Genera Folio"
					formatos="S,S,U"
					align="left,left,left"
					ajustar="S"
					keys="FTidEstado"
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
					<cfinclude template="EstadoFac_form.cfm"> 
					</td>			
				</tr>
			</table>
		<br>
	<cf_web_portlet_end>
<cf_templatefooter>
	
<script language="javascript" type="text/javascript">
		function funcEliminar(){
			if (confirm("¿Está seguro de que desea Eliminar el Estado(s) seleccionado(s)?")) {
				document.form3.action = "EstadoFac_SQL.cfm";
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
				}
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
			document.form2.action='EstadoFac.cfm';
			document.form2.submit;
		}
</script>		
