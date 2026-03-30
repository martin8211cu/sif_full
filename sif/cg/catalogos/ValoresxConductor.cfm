<cf_templateheader title="Contabilidad General" bodyTag="onload='init_page()'">
	<table width="100%"  border="1" cellspacing="0" cellpadding="0">
	  <tr>
		<td valign="top" nowrap>
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo de Valores por Conductor'>
				<cfinclude template="../../cg/consultas/Funciones.cfm">
				<cfscript>
					//Procesa los datos del filtro cuando vienen en url
					if (isdefined("url.CGCperiodo") and len(trim(url.CGCperiodo))) form.CGCperiodo = url.CGCperiodo;
					if (isdefined("url.CGCid") and len(trim(url.CGCid))) form.CGCid = url.CGCid;
					if (isdefined("url.CGCmes") and len(trim(url.CGCmes))) form.CGCmes = url.CGCmes;
					if (isdefined("url.filter") and len(trim(url.filter))) form.filter = url.filter;
					
				</cfscript>
				<cfparam name="form.CGCperiodo" default="#Year(Now())#">
				<!----<table width="100%" align="center"  border="0" cellspacing="1" cellpadding="1">
					<tr><td><cfinclude template="filtroAFIndices.cfm"></td></tr>
				</table>---->
				
				<cfquery name="rsHayConductores" datasource="#session.dsn#">
				Select count(1) as hayCd
				from CGConductores
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
				</cfquery>				
				
				<cfif rsHayConductores.hayCd gt 0>
								
					<table width="100%" align="center"  border="0" cellspacing="1" cellpadding="1">
						<tr>
							<td>
								<cfinclude template="formValoresxConductor.cfm">
							</td>
						</tr>
					</table>
					<table width="100%" align="center"  border="0" cellspacing="1" cellpadding="1">
						<tr>
							<td>
								<cfinclude template="listaValoresxConductor.cfm">
								<!--- 
								<cfif isdefined("URL.DefValores") and URL.DefValores eq 1>
									<cfinclude template="listaValoresxConductor.cfm">
								<cfelse>
									<cfinclude template="listaValoresxConductor.cfm">
								</cfif> --->
							</td>
						</tr>
						<tr>
							<td><font color="red">(*) No aplica para filtrar</font></td>
						</tr>
					</table>
				
				
				<cfelse>
				
					<table align="center" cellpadding="0" cellspacing="0">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="center">
							No es posible parametrizar valores debido a que no hay conductores definidos en el sistema.<br>
							Para incluir Conductores simplemente ingrese en el catálogo de conductores e inclúyalos.
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="center">
							<input type="button" name="Regresar" class="btnAnterior" value="Regresar" onclick="javascript: history.back();" tabindex="1">
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					</table>
					
				</cfif>				
				
			<cf_web_portlet_end>
		</td>	
	  </tr>
	</table>
<script language="javascript" type="text/javascript">
	function init_page(){
			if(document.form1.CGCid){
				document.form1.CGCid.focus();				
			}
	}
</script>

<cf_templatefooter>