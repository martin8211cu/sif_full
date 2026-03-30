<!--- <cfdump var="#form#">
<cfdump var="#url#"> --->
<cfif isdefined("Url.Company") and not isdefined("Form.Company")>
	<cfparam name="Form.Company" default="#Url.Company#">
</cfif>	
<cfif isdefined("Url.Rep") and not isdefined("Form.Rep")>
	<cfparam name="Form.Rep" default="#Url.Rep#">
</cfif>	
<cfif isdefined("Url.filtrado2") and not isdefined("Form.filtrado2")>
	<cfparam name="Form.filtrado2" default="#Url.filtrado2#">
</cfif>	
<cfif isdefined("Url.sel2") and not isdefined("Form.sel2")>
	<cfparam name="Form.sel2" default="#Url.sel2#">
</cfif>		
<cfset url.Pagina2 = ' ' >

<cfset filtro2 = "">
<cfset navegacion2 = "PageNum_lista2=">
<cfset navegacion2 = navegacion2 & Iif(Len(Trim(navegacion2)) NEQ 0, DE("&"), DE("")) & "filtrado2=Filtrar">
<cfif isdefined("Form.COMPANYFILTRO") and Len(Trim(Form.COMPANYFILTRO)) NEQ 0>
	<cfset filtro2 = filtro2 & " and upper(Company) like '%" & #UCase(Form.COMPANYFILTRO)# & "%'">
	<cfset navegacion2 = navegacion2 & Iif(Len(Trim(navegacion2)) NEQ 0, DE("&"), DE("")) & "Company=" & Form.COMPANYFILTRO>
<cfelseif isdefined("form.Company") and len(trim(form.Company)) NEQ 0>
	<cfset filtro2 = filtro2 & " and upper(Company) like '%" & #UCase(Form.Company)# & "%'">
	<cfset navegacion2 = navegacion2 & Iif(Len(Trim(navegacion2)) NEQ 0, DE("&"), DE("")) & "Company=" & Form.Company>
</cfif>

<cfif isdefined("Form.sel2") and form.sel2 NEQ 1>
	<cfset navegacion2 = navegacion2 & Iif(Len(Trim(navegacion2)) NEQ 0, DE("&"), DE("")) & "sel2=" & form.sel2>				
</cfif>		

<cfquery name="rsLista2" datasource="#Session.DSN#" maxrows="300">
	select 
		Company,
		Rep,
		1 as o2, 
		1 as sel2,
		<cfif isdefined("CGI.HTTP_REFERER") and findNoCase('ConciliacionTLC', CGI.HTTP_REFERER, 1) or isdefined("form.ConciliacionTLC")>
			1 as ConciliacionTLC,
		</cfif>
	   'ALTA' as modo
	from TLCEmpresasImp
	where Encontrado = '0'
	<cfif isdefined("filtro2") and len(trim(filtro2))>
		 #PreserveSingleQuotes(filtro2)#
	</cfif>
	order by Company
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="vertical-align:top">
	<cfset regresar = "/cfmx/hosting/tratado/index.cfm">
	<tr><td>&nbsp;</td></tr>	
	<tr style="display: ;" id="verFiltroListaEmpl2"> 
		<td> 
			<form name="formFiltroTLCEmpresaImp" method="post" action="TLCEmpresasImp.cfm">
				<cfif isdefined("CGI.HTTP_REFERER") and findNoCase('ConciliacionTLC', CGI.HTTP_REFERER, 1) or isdefined("form.ConciliacionTLC")>
					<input type="hidden" name="ConciliacionTLC" value="1" />
				</cfif>
				<input type="hidden" name="filtrado2" value="<cfif isdefined('form.btnFiltrar') or isdefined('form.filtrado2')>Filtrar</cfif>">
				<input type="hidden" name="sel2" value="<cfif isdefined('form.sel2')><cfoutput>#form.sel2#</cfoutput><cfelse>0</cfif>">				
				
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
					<tr> 
						<td width="27%" height="17" class="fileLabel">Empresa</td>
						<td width="5%" colspan="2" rowspan="2"><input name="btnFiltrar2" class="btnFiltrar2" type="submit" id="btnFiltrar2" value="Filtar"></td>
					</tr>
					<tr> 
						<td><input name="CompanyFiltro" type="text" id="CompanyFiltro" size="50" maxlength="60" value="<cfif isdefined('form.CompanyFiltro')><cfoutput>#form.CompanyFiltro#</cfoutput></cfif>"></td>
					</tr>
				</table>
			</form>
		</td>
	</tr>		
	<tr style="display: ;" id="verLista2"> 
		<td> 
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<cfif isdefined("CGI.HTTP_REFERER") and findNoCase('ConciliacionTLC', CGI.HTTP_REFERER, 1) or isdefined("form.ConciliacionTLC")>
							<cfset LvarIrA = ' '>
							<cfset LvarMaxRows = 10>
						<cfelse>
							<cfset LvarIrA = 'Empresas.cfm'>
							<cfset LvarMaxRows = 20>
						</cfif>
						<cfinvoke 
							component="sif.rh.Componentes.pListas"
							method=	"pListaQuery"
							returnvariable="pListaEmpl"
								query 				= "#rsLista2#"
								desplegar			= "Company"
								etiquetas			= "Empresa"
								formatos			= "S"
								formName			= "listaEmpresas2"
								align 				= "left"
								ajustar				= "S"
								PageIndex			= "2"
								irA					= "TLCEmpresasImp.cfm"
								navegacion			= "#navegacion2#"
								showEmptyListMsg	= "true"
								maxrows				= "#LvarMaxRows#"
								keys				= "Company"/>
					</td>
				</tr>
				<tr>
					<td align="center">
						&nbsp;
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>