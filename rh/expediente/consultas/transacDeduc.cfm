<!-- InstanceBegin template="/Templates/LMenuRH1.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>
	
	<cf_templatearea name="body">

<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->	
                    <!-- InstanceBeginEditable name="MenuJS" --> 
		  <!-- InstanceEndEditable -->					
					<!-- InstanceBeginEditable name="Mantenimiento" -->
	  <cf_web_portlet_start titulo="Transacciones de Deducci&oacute;n" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
				  <td>
				  
					<cfset navegacionDed = "">
					<cfset navegacionDed = navegacionDed & Iif(Len(Trim(navegacionDed)) NEQ 0, DE("&"), DE("")) & "o=7">
					<cfif isdefined("Form.DEid")>
						<cfset navegacionDed = navegacionDed & Iif(Len(Trim(navegacionDed)) NEQ 0, DE("&"), DE("")) & "DEid=" & Form.DEid>
					</cfif>
					<cfif isdefined("Form.sel")>
						<cfset navegacionDed = navegacionDed & Iif(Len(Trim(navegacionDed)) NEQ 0, DE("&"), DE("")) & "sel=" & Form.sel>
					</cfif> 
				  
				  
					<form style="margin:0" name="filtro" method="post">
						<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
							<tr>
								<td>Socio</td>
								<td>Fecha</td>
								<td>Estado</td>
							</tr>
	
							<tr>
								<td><cf_rhsociosnegociosFA form="filtro" frame="frame_filtro" sncodigo="fSNcodigo" snnombre="fSNnombre" snnumero="fSNnumero" > </td>
								<td><cf_sifcalendario form="filtro" name="fFecha" value=""></td>
								<td>
									<select name="fEstado">
										<option value="">Todos</option>
										<option value="1">Activos</option>
										<option value="0">Inactivos</option>
									</select>
								</td>
								<td>
									<input type="submit" name="btnFiltrar" value="Filtrar">
									<input name="DEid" type="hidden" value="<cfif isdefined("form.DEid")><cfoutput>#form.DEid#</cfoutput></cfif>">
									<input name="o" type="hidden" value="7">
									<input name="sel" type="hidden" value="1">			
								</td>
							</tr>
						</table>
					</form>
					
					<cfquery name="rsLista" datasource="#session.DSN#">
						select a.DEid, a.Did, a.Ddescripcion, a.SNcodigo, b.SNnombre, case a.Dmetodo when 0 then 'Porcentaje' when 1 then 'Valor' end as Dmetodo, a.Dvalor,Dfechaini, Dfechafin, 7 as o, 1 as sel
						from DeduccionesEmpleado a, SNegocios b
						where a.Ecodigo=b.Ecodigo 
						  and a.SNcodigo=b.SNcodigo 
						  and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
						  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

						<cfif isdefined("form.fSNcodigo") and len(trim(form.fSNcodigo)) gt 0>
							 and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fSNcodigo#">
						</cfif>
	
						<cfif isdefined("form.fFecha") and len(trim(form.fFecha)) gt 0>
							and a.Dfechaini >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fFecha)#">
						</cfif>
	
						<cfif isdefined("form.fEstado") and len(trim(form.fEstado)) gt 0>
							and a.Dactivo = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.fEstado#">
						</cfif>
	
						order by Ddescripcion
					</cfquery>

					<cfinvoke 
						component="rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaDed">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="desplegar" value="Ddescripcion, Dmetodo, Dvalor"/>
							<cfinvokeargument name="etiquetas" value="Deducci&oacute;n, Método, Valor"/>
							<cfinvokeargument name="formatos" value="V, V, M"/>
							<cfinvokeargument name="formName" value="listaDeducciones"/>	
							<cfinvokeargument name="align" value="left,left, rigth"/>
							<cfinvokeargument name="ajustar" value="N"/>				
							<cfinvokeargument name="irA" value="expediente-cons.cfm"/>			
							<cfinvokeargument name="navegacion" value="#navegacionDed#"/>
							<cfinvokeargument name="keys" value="Did"/>
					</cfinvoke>		
				  </td>
				</tr>
			  </table> 
	  <cf_web_portlet_end>
      <!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->