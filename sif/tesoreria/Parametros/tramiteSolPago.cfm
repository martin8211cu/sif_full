<cf_templateheader title="Trámites Solicitudes de Pago">
	<cf_web_portlet_start titulo="Trámites Solicitudes de Pago">
	<br>
	<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="60%" valign="top">
				<cfif isDefined("Url.TESTPid") and not isDefined("form.TESTPid")>
				  <cfset form.TESTPid = Url.TESTPid>
				</cfif>		
				<cfif isDefined("Url.FTdescripcion") and not isDefined("form.FTdescripcion")>
				  <cfset form.FTdescripcion = Url.FTdescripcion>
				</cfif>
				<cfif isDefined("Url.FTcodigo") and not isDefined("form.FTcodigo")>
				  <cfset form.FTcodigo = Url.FTcodigo>
				</cfif>
				<!--- Variables para Navegación --->
				<cfif isdefined("url.FiltroCFcodigo") and len(trim(url.FiltroCFcodigo))>
					<cfset form.FiltroCFcodigo = url.FiltroCFcodigo>
				</cfif>	
				<!--- Variables para Navegación --->
				<cfif isdefined("url.FiltroCFuncional") and len(trim(url.FiltroCFuncional))>
					<cfset form.FiltroCFuncional = url.FiltroCFuncional>
				</cfif>	
				<cfif isdefined("url.FiltroTramite") and len(trim(url.FiltroTramite))>
					<cfset form.FiltroTramite = url.FiltroTramite>
				</cfif>			
						
				<cfif isdefined("url._")>
					<cf_navegacion name = "FiltroCFcodigo" default = "">
					<cf_navegacion name = "FiltroCFuncional" default = "">
					<cf_navegacion name = "FiltroTramite" default = "">
				<cfelse>
					<cf_navegacion name = "FiltroCFcodigo" default = "" session="">
					<cf_navegacion name = "FiltroCFuncional" default = "" session="">
					<cf_navegacion name = "FiltroTramite" default = "" session="">
				</cfif>					
				<cfquery name="rsLista" datasource="#session.dsn#">

					select 
						tr.Name,
						cf.CFcodigo, cf.CFdescripcion,
						a.TESTPid,
						a.ProcessId,
						a.CFid,
						a.Ecodigo,
						a.BMFecha,
						a.BMUsucodigo
					from TESTramiteSolPago a
					inner join CFuncional cf
						on cf.CFid = a.CFid
					inner join WfProcess tr
						on tr.ProcessId = a.ProcessId
					where a.Ecodigo = #session.Ecodigo# 
					<cfif isdefined('form.FiltroCFcodigo')and len(trim(form.FiltroCFcodigo)) >
						and upper(cf.CFcodigo) like upper('%#form.FiltroCFcodigo#%')
					</cfif>	
					<cfif isdefined('form.FiltroCFuncional')and len(trim(form.FiltroCFuncional)) >
						and upper(cf.CFdescripcion) like upper('%#form.FiltroCFuncional#%')
					</cfif>	
					<cfif isdefined('form.FiltroTramite')and len(trim(form.FiltroTramite)) >
						and upper(tr.Name) like upper('%#form.FiltroTramite#%')
					</cfif>	
				</cfquery>	
				
			<cfoutput>
				<form action="tramiteSolPago_SQL.cfm" name="form2" method="post">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0px;">
					<tr>
						<td class="titulolistas" colspan="1"><strong>Codigo</strong></td>
						<td class="titulolistas" colspan="1"><strong>Centro Funcional</strong></td>
						<td class="titulolistas" colspan="2"><strong>Trámite</strong></td>
					</tr>
					<tr>
						<td class="titulolistas"><input type="text" name="FiltroCFcodigo"  tabindex="1" value="<cfif isdefined('form.FiltroCFodigo')>#form.FiltroCFcodigo#</cfif>"></td>
						<td class="titulolistas"><input type="text" name="FiltroCFuncional"  tabindex="1" value="<cfif isdefined('form.FiltroCFuncional')>#form.FiltroCFuncional#</cfif>"></td>
						<td class="titulolistas"><input type="text" name="FiltroTramite"  tabindex="1" value="<cfif isdefined('form.FiltroTramite')>#form.FiltroTramite#</cfif>"></td>
						<td class="titulolistas"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="2" onclick="funcFiltrar();" class="btnNormal" /></td>
					</tr>
					<tr><td colspan="4"><hr></td></tr>
				</table> 
			</form>	
				
			</cfoutput>
				<cfif isdefined('form.FiltroCFcodigo')and len(trim(form.FiltroCFcodigo)) or isdefined('form.FiltroCFuncional')and len(trim(form.FiltroCFuncional)) or isdefined('form.FiltroTramite')and len(trim(form.FiltroTramite)) >
					<cfset LvarDireccion = 'tramiteSolPago.cfm'>
				<cfelse>
					<cfset LvarDireccion = 'tramiteSolPago.cfm?_'>
				</cfif>
				
				<cfinvoke
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="rsLista"
					query="#rsLista#"
					columnas="CFdescripcion,Name"
					desplegar="CFcodigo,CFdescripcion,Name"
					etiquetas="Codigo, Centro Funcional,Tr&aacute;mite"
					formatos="S,S,S"
					align="left,left,left"
					ajustar="S"
					keys="TESTPid"
					irA="#LvarDireccion#"
					maxrows="5"
					pageindex="3"
					navegacion="#navegacion#?ProcessId=ProcessId"  				 
					showEmptyListMsg= "true"
					checkboxes= "N"
					form_method="post"
					formname= "form3"
					usaAJAX = "no"
					/>
					</td>
					<td width="5%">&nbsp;</td>
					<td width="55%" valign="top">
					<cfinclude template="tramiteSolPago_form.cfm"> 
					</td>			
				</tr>
			</table>
		<br>
	<cf_web_portlet_end>
<cf_templatefooter>
	
<script language="javascript" type="text/javascript">
		function funcEliminar(){
			if (confirm("¿Está seguro de que desea Eliminar el Estado(s) seleccionado(s)?")) {
				document.form3.action = "tramiteSolPago_SQL.cfm";
				return true;
			}
			return false;
		}
		function funcFiltrar(){
			document.form2.action='tramiteSolPago.cfm';
			document.form2.submit;
		}
</script>		
