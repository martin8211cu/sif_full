<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">
<cfparam name="form.MaxRows" default="15">

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cf_templateheader title="Mantenimiento de Impresión Órdenes de Pago">
	<cf_web_portlet_start titulo="Mantenimiento de Impresión Órdenes de Pago">
		<style type="text/css">
		<!--
		.style1 {
			color: #FF0000;
			font-weight: bold;
		}
		-->
		</style>

		<cf_navegacion name="fTESOPidioma">
		<cf_navegacion name="fTESOPRevisado">
		<cf_navegacion name="fTESOPAprobado">
		<cf_navegacion name="fTESOPRefrendado">
		
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
		<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
			<cfset form.Pagina = url.Pagina>
		</cfif>
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
		<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
			<cfset form.Pagina = url.PageNum_Lista>
		</cfif>
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
		<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
			<cfset form.Pagina = form.PageNum>
		</cfif>
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
		<cfif isdefined("url.Pagina2") and len(trim(url.Pagina2))>
			<cfset form.Pagina2 = url.Pagina2>
		</cfif>
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
		<cfif isdefined("url.PageNum_Lista2") and len(trim(url.PageNum_Lista2))>
			<cfset form.Pagina2 = url.PageNum_Lista2>
		</cfif>
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
		<cfif isdefined("url.PageNum2") and len(trim(url.PageNum2))>
			<cfset form.Pagina2 = url.PageNum2>
		</cfif>
		<table width="100%" border="0" cellspacing="6">
			<tr>
				<td  nowrap valign="top" width="80%">
					<form name="formlista" action="OPProcEmi.cfm" method="post">
						<cfoutput>
						<input name="Pagina" type="hidden" value="#form.Pagina#">
						<table border="0" cellpadding="1" cellspacing="0" class="tituloAlterno" width="100%">
							 <tr>
								<td nowrap align="right" width="10%">
									<strong>Trabajar con Tesorería:</strong>&nbsp;
								</td>
								<td align="left" colspan="8">
									<cf_cboTESid tipo="" onchange="this.form.submit();" tabindex="1">
								</td>
							</tr>	
							<tr>
								<td align="right"><strong>Idioma:</strong></td>
								<td width="10%" align="left">
									<input name="fTESOPidioma" type="text" size="8" maxlength="10" tabindex="1"
										value="<cfif isdefined("form.fTESOPidioma") and len(trim(form.fTESOPidioma))>#form.fTESOPidioma#</cfif>">
								</td>
								<td align="right"><strong>&nbsp;Revisado:</strong></td>
								<td align="left">
									<input name="fTESOPRevisado" type="text"  size="15" maxlength="30" tabindex="1"
										value="<cfif isdefined("form.fTESOPRevisado") and len(trim(form.fTESOPRevisado))>#form.fTESOPRevisado#</cfif>">
								</td>
								<td align="right"><strong>&nbsp;Aprobado:</strong></td>
								<td width="10%" align="left">
									<input name="fTESOPAprobado" type="text" size="15" maxlength="30" tabindex="1"
										value="<cfif isdefined("form.fTESOPAprobado") and len(trim(form.fTESOPAprobado))>#form.fTESOPAprobado#</cfif>">
								</td>
								<td align="right"><strong>&nbsp;Refrendado:</strong></td>
								<td align="left">
									<input name="fTESOPRefrendado" type="text"  size="15" maxlength="30" tabindex="1"
										value="<cfif isdefined("form.fTESOPRefrendado") and len(trim(form.fTESOPRefrendado))>#form.fTESOPRefrendado#</cfif>">
								</td>
								
								<td>
									<cf_botones exclude="ALTA,CAMBIO,BAJA,LIMPIAR" include="btnFiltrar"  includevalues="Filtrar" tabindex="1" >
								</td>	
							</tr>
						</table>
						</cfoutput>
					<cfinclude template="../../Utiles/sifConcat.cfm">
					<cfquery datasource="#session.dsn#" name="lista">
						select 
							TESOPidioma,
							case when len(TESOPRevisado) > 15 then substring(TESOPRevisado,1,12) #_Cat# ' ...' else TESOPRevisado end as TESOPRevisado, 
							case when len(TESOPAprobado) > 15 then substring(TESOPAprobado,1,12) #_Cat# ' ...' else TESOPAprobado end as TESOPAprobado, 
							case when len(TESOPRefrendado) > 15 then substring(TESOPRefrendado,1,12) #_Cat# ' ...' else TESOPRefrendado end as TESOPRefrendado
						  from TESOPprocEmi 
						 where TESid = #session.tesoreria.TESid#
						 
						 <cfif isdefined("form.fTESOPidioma") and len(trim(form.fTESOPidioma))>
							and TESOPidioma like '%#form.fTESOPidioma#%'
						 </cfif>
						 <cfif isdefined("form.fTESOPRevisado") and len(trim(form.fTESOPRevisado))>
							and upper(TESOPRevisado) like '%#ucase(form.fTESOPRevisado)#%'
						 </cfif>
						 <cfif isdefined("form.fTESOPAprobado") and len(trim(form.fTESOPAprobado))>
							and upper(TESOPAprobado) like '%#ucase(form.fTESOPAprobado)#%'
						 </cfif>
						 <cfif isdefined("form.fTESOPRefrendado") and len(trim(form.fTESOPRefrendado))>
							and upper(TESOPRefrendado) like '%#ucase(form.fTESOPRefrendado)#%'
						 </cfif>
						 order by TESOPidioma
					</cfquery>
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
						query="#lista#"
						desplegar="TESOPidioma, TESOPRevisado, TESOPAprobado, TESOPRefrendado"
						etiquetas="Idioma, Revisado, Aprobado, Refrendado"
						formatos="S,S,S,S"
						ajustar="true"
						showEmptyListMsg="yes"
						align="left,left,left, left"
						ira="OPProcEmi_form.cfm"
						botones="Nuevo"
						MaxRows="#form.MaxRows#"
						navegacion="#navegacion#"
						incluyeForm="false"
						formName="formlista"
					/>		
					</form>
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
	<script language="JavaScript" type="text/javascript">
		function funcNuevo(){	
			var parametros = "<cfoutput>Pagina=#form.Pagina#&fTESOPidioma=<cfif isdefined('form.fTESOPidioma')>#form.fTESOPidioma#</cfif>&fTESOPRevisado=<cfif isdefined('form.fTESOPRevisado')>#form.fTESOPRevisado#</cfif>&fTESOPAprobado=<cfif isdefined('form.fTESOPAprobado')>#form.fTESOPAprobado#</cfif>&fTESOPRefrendado=<cfif isdefined('form.fTESOPRefrendado')>#form.fTESOPRefrendado#</cfif></cfoutput>";
			location.href ='OPProcEmi_form.cfm?' + parametros;
			return false;
		}
	</script><!--- fTESOPidioma fTESOPRevisado fTESOPAprobado fTESOPRefrendado --->
<cf_templatefooter>