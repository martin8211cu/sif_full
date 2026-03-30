
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cfoutput>#nav__SPdescripcion#</cfoutput>
	</cf_templatearea> 
	<cf_templatearea name="body">
		<cf_web_portlet titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>
			<!--- Aqui se incluye el form --->
			<cfif isdefined("Url.persona") and not isdefined("Form.persona")>
				<cfparam name="Form.persona" default="#Url.persona#">
			</cfif> 
			<cfif isdefined("Url.o") and not isdefined("form.tab")> 
				<cfparam name="form.tab" default="#Url.o#">
			</cfif> 
			<cfif isdefined("form.persona")>
				<cfparam name="Form.persona" default="#form.persona#">
			</cfif> 
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
			<cfif isdefined('url.Filtro_Estado') and not isdefined('form.Filtro_Estado')>
				<cfparam name="form.Filtro_Estado" default="#url.Filtro_Estado#">
			</cfif>
			<cfif isdefined('url.Filtro_Grado') and not isdefined('form.Filtro_Grado')>
				<cfparam name="form.Filtro_Grado" default="#url.Filtro_Grado#">
			</cfif>
			<cfif isdefined('url.Filtro_Ndescripcion') and not isdefined('form.Filtro_Ndescripcion')>
				<cfparam name="form.Filtro_Ndescripcion" default="#url.Filtro_Ndescripcion#">
			</cfif>
			<cfif isdefined('url.Filtro_Nombre') and not isdefined('form.Filtro_Nombre')>
				<cfparam name="form.Filtro_Nombre" default="#url.Filtro_Nombre#">
			</cfif>
			<cfif isdefined('url.Filtro_Pid') and not isdefined('form.Filtro_Pid')>
				<cfparam name="form.Filtro_Pid" default="#url.Filtro_Pid#">
			</cfif>
			<cfif isdefined('url.NoMatr') and not isdefined('form.NoMatr')>
				<cfparam name="form.NoMatr" default="#url.NoMatr#">
			</cfif>
			<cfif isdefined('url.tab') and not isdefined('form.tab')>
				<cfparam name="form.tab" default="#url.tab#">
			</cfif>
			<cfset Lvar_regresaLista = 'ListaAlumno.cfm'>
			<cfset Lvar_regresaLista = Lvar_regresaLista & Iif(Len(Trim(Lvar_regresaLista)) NEQ 0, DE("?"), DE("")) & "Pagina=" &form.Pagina>				
			
			<cfset Lvar_tabs = ''>
			<cfset Lvar_tabs = Lvar_tabs & Iif(Len(Trim(Lvar_tabs)) NEQ 0, DE("&"), DE("")) & "Pagina=" &form.Pagina> 
			<cfif isdefined('form.persona')>
			<cfset Lvar_regresaLista = Lvar_regresaLista & Iif(Len(Trim(Lvar_regresaLista)) NEQ 0, DE("&"), DE("")) & "persona=" &form.persona>
			<cfset Lvar_tabs = Lvar_tabs & Iif(Len(Trim(Lvar_tabs)) NEQ 0, DE("&"), DE("")) & "persona=" &form.persona> 
			</cfif>
			<cfif isdefined('form.Filtro_Estado')>
				<cfset Lvar_regresaLista = Lvar_regresaLista & Iif(Len(Trim(Lvar_regresaLista)) NEQ 0, DE("&"), DE("")) & "Filtro_Estado=" &form.Filtro_Estado>				
				<cfset Lvar_tabs = Lvar_tabs & Iif(Len(Trim(Lvar_tabs)) NEQ 0, DE("&"), DE("")) & "Filtro_Estado=" &form.Filtro_Estado>				
			</cfif>
			<cfif isdefined('form.Filtro_Grado')>
				<cfset Lvar_regresaLista = Lvar_regresaLista & Iif(Len(Trim(Lvar_regresaLista)) NEQ 0, DE("&"), DE("")) & "Filtro_Grado=" &form.Filtro_Grado>	
				<cfset Lvar_tabs = Lvar_tabs & Iif(Len(Trim(Lvar_tabs)) NEQ 0, DE("&"), DE("")) & "Filtro_Grado=" &form.Filtro_Grado>	
			</cfif>
			<cfif isdefined('form.Filtro_Ndescripcion')>
				<cfset Lvar_regresaLista = Lvar_regresaLista & Iif(Len(Trim(Lvar_regresaLista)) NEQ 0, DE("&"), DE("")) & "Filtro_Ndescripcion=" &form.Filtro_Ndescripcion>
				<cfset Lvar_tabs = Lvar_tabs & Iif(Len(Trim(Lvar_tabs)) NEQ 0, DE("&"), DE("")) & "Filtro_Ndescripcion=" &form.Filtro_Ndescripcion>
			</cfif>
			<cfif isdefined('form.Filtro_Nombre')>
				<cfset Lvar_regresaLista = Lvar_regresaLista & Iif(Len(Trim(Lvar_regresaLista)) NEQ 0, DE("&"), DE("")) & "Filtro_Nombre=" &form.Filtro_Nombre>
				<cfset Lvar_tabs = Lvar_tabs & Iif(Len(Trim(Lvar_tabs)) NEQ 0, DE("&"), DE("")) & "Filtro_Nombre=" &form.Filtro_Nombre>
			</cfif>
			<cfif isdefined('form.Filtro_Pid')>
				<cfset Lvar_regresaLista = Lvar_regresaLista & Iif(Len(Trim(Lvar_regresaLista)) NEQ 0, DE("&"), DE("")) & "Filtro_Pid=" &form.Filtro_Pid>
				<cfset Lvar_tabs = Lvar_tabs & Iif(Len(Trim(Lvar_tabs)) NEQ 0, DE("&"), DE("")) & "Filtro_Pid=" &form.Filtro_Pid>
			</cfif>
			<cfif isdefined('form.NoMatr')>
				<cfset Lvar_regresaLista = Lvar_regresaLista & Iif(Len(Trim(Lvar_regresaLista)) NEQ 0, DE("&"), DE("")) & "NoMatr=" &form.NoMatr>
				<cfset Lvar_tabs = Lvar_tabs & Iif(Len(Trim(Lvar_tabs)) NEQ 0, DE("&"), DE("")) & "NoMatr=" &form.NoMatr>
			</cfif>
			<cfif isdefined('form.HFiltro_Estado')>
				<cfset Lvar_regresaLista = Lvar_regresaLista & Iif(Len(Trim(Lvar_regresaLista)) NEQ 0, DE("&"), DE("")) & "HFiltro_Estado=" &form.HFiltro_Estado>				
				<cfset Lvar_tabs = Lvar_tabs & Iif(Len(Trim(Lvar_tabs)) NEQ 0, DE("&"), DE("")) & "HFiltro_Estado=" &form.HFiltro_Estado>				
			</cfif>
			<cfif isdefined('form.HFiltro_Grado')>
				<cfset Lvar_regresaLista = Lvar_regresaLista & Iif(Len(Trim(Lvar_regresaLista)) NEQ 0, DE("&"), DE("")) & "HFiltro_Grado=" &form.HFiltro_Grado>	
				<cfset Lvar_tabs = Lvar_tabs & Iif(Len(Trim(Lvar_tabs)) NEQ 0, DE("&"), DE("")) & "HFiltro_Grado=" &form.HFiltro_Grado>	
			</cfif>
			<cfif isdefined('form.HFiltro_Ndescripcion')>
				<cfset Lvar_regresaLista = Lvar_regresaLista & Iif(Len(Trim(Lvar_regresaLista)) NEQ 0, DE("&"), DE("")) & "HFiltro_Ndescripcion=" &form.HFiltro_Ndescripcion>
				<cfset Lvar_tabs = Lvar_tabs & Iif(Len(Trim(Lvar_tabs)) NEQ 0, DE("&"), DE("")) & "HFiltro_Ndescripcion=" &form.HFiltro_Ndescripcion>
			</cfif>
			<cfif isdefined('form.HFiltro_Nombre')>
				<cfset Lvar_regresaLista = Lvar_regresaLista & Iif(Len(Trim(Lvar_regresaLista)) NEQ 0, DE("&"), DE("")) & "HFiltro_Nombre=" &form.HFiltro_Nombre>
				<cfset Lvar_tabs = Lvar_tabs & Iif(Len(Trim(Lvar_tabs)) NEQ 0, DE("&"), DE("")) & "HFiltro_Nombre=" &form.HFiltro_Nombre>
			</cfif>
			<cfif isdefined('form.HFiltro_Pid')>
				<cfset Lvar_regresaLista = Lvar_regresaLista & Iif(Len(Trim(Lvar_regresaLista)) NEQ 0, DE("&"), DE("")) & "HFiltro_Pid=" &form.HFiltro_Pid>
				<cfset Lvar_tabs = Lvar_tabs & Iif(Len(Trim(Lvar_tabs)) NEQ 0, DE("&"), DE("")) & "HFiltro_Pid=" &form.HFiltro_Pid>
			</cfif>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<form name="regAlum" action="alumno.cfm" method="post">
							<cfoutput>
				  				<input type="hidden" name="persona" value="<cfif isdefined("Form.persona")>#Form.persona#</cfif>">
								<input type="hidden" name="o" value="<cfif isdefined("form.tab")>#form.tab#</cfif>">
							</cfoutput>
						</form>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<form name="formBuscar" method="post" action="">
								<tr>
									<td align="right" valign="middle">
										<a href="<cfoutput>#Lvar_regresaLista#</cfoutput>">
										Seleccionar Alumno: <img src="../../Imagenes/find.small.png" name="imageBusca" id="imageBusca" border="0">
										</a>
									</td>
								</tr>
							</form>
						</table>
					</td>
				</tr>
				<tr id="TRDatosEmp">
					<td >
						
						<cfinclude template="frame-header.cfm">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<cfif isDefined("Form.persona") >
								<cfoutput>
								<form name="Regresar" method="post" action="alumno.cfm"> 
									<input type="hidden" name="persona" value="#Form.persona#">
									<input type="hidden" name="o" value="<cfif isdefined("form.tab")>#form.tab#</cfif>">
									<input name="Pagina" type="hidden" value="<cfif isdefined('form.Pagina')>#form.Pagina#</cfif>">
								</form>
								</cfoutput>
								<cfset regresar = "javascript: document.Regresar.submit();">
							</cfif>
							<tr>
								<td>
									<cfparam name="form.tab" default="1">
									<cf_tabs width="100%">
										<cf_tab text="#tabNames[1]#" selected="#form.tab eq 1#">
											<cfif form.tab eq 1><cfinclude template="formAlumno.cfm"></cfif>
										</cf_tab>
										<cfif isdefined('form.persona') and LEN(TRIM(form.persona))>
											<cf_tab text=#tabNames[2]# selected="#form.tab eq 2#">
												<cfif form.tab eq 2><cfinclude template="formDatMed.cfm"></cfif>
											</cf_tab>
											<cf_tab text=#tabNames[3]# selected="#form.tab eq 3#">
												<cfif form.tab eq 3><cfinclude template="formEncarg.cfm"></cfif>
											</cf_tab>
										</cfif>
									</cf_tabs>
									<script type="text/javascript">
										 function tab_set_current(n) {
												location.href = "alumno.cfm?tab="+n+"<cfoutput>&#Lvar_tabs#</cfoutput>";
											}
									</script>
								</td>
							</tr>
						</table>
						
					</td>
				</tr>
			</table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>

