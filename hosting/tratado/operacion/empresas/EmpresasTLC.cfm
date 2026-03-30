<!--- <cfdump var="#form#">
<cfdump var="#url#">
<cfdump var="#cgi#"> --->
<!--- ========================================================== --->
<!--- 						TRADUCCION							 --->
<!--- ========================================================== --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Cedula_Juridica"
	Default="C&eacute;dula Juridica"
	returnvariable="LB_Cedula_Juridica"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Nombre"
	Default="Nombre"
	returnvariable="vNombre"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Filtrar"
	Default="Filtrar"
	returnvariable="vFiltrar"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Nueva_Empresa"
	Default="Nueva Empresa"
	returnvariable="LB_Nueva_Empresa"/>
<!--- ========================================================== --->
<!--- ========================================================== --->

<cfif isdefined("Url.nombreFiltro") and not isdefined("Form.nombreFiltro")>
	<cfparam name="Form.nombreFiltro" default="#Url.nombreFiltro#">
</cfif>
<cfif isdefined("Url.CedulaFiltro") and not isdefined("Form.CedulaFiltro")>
	<cfparam name="Form.CedulaFiltro" default="#Url.CedulaFiltro#">
</cfif>		
<cfif isdefined("Url.filtrado") and not isdefined("Form.filtrado")>
	<cfparam name="Form.filtrado" default="#Url.filtrado#">
</cfif>	


<cfif isdefined("Url.ETLCid") and not isdefined("Form.ETLCid")>
	<cfparam name="Form.ETLCid" default="#Url.ETLCid#">
</cfif>
<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
	<cfparam name="Form.sel" default="#Url.sel#">
</cfif>		
<cfset filtro = "">
<cfset navegacion = "">
<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtrado=Filtrar">
<cfif isdefined("Form.ETLCid")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ETLCid=" & #form.ETLCid#>				
	<cfset filtro = filtro & " and ETLCid = #form.ETLCid#">
</cfif>
<cfif isdefined("Form.nombreFiltro") and Len(Trim(Form.nombreFiltro)) NEQ 0>
	<cfset filtro = filtro & " and upper(ETLCnomPatrono) like '%" & #UCase(Form.nombreFiltro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "nombreFiltro=" & Form.nombreFiltro>
</cfif>
<cfif isdefined("Form.CedulaFiltro") and Len(Trim(Form.CedulaFiltro)) NEQ 0>
	<cfset filtro = filtro & " and upper(ETLCpatrono)  like '%" & UCase(Form.CedulaFiltro) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CedulaFiltro=" & Form.CedulaFiltro>
</cfif>
<cfif isdefined("Form.sel") and form.sel NEQ 1>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "sel=" & form.sel>				
</cfif>		

<cfquery name="rsLista" datasource="#session.DSN#">
	select 	ETLCid,
			ETLCpatrono,
			ETLCnomPatrono,
			1 as o, 
			1 as sel,
			<cfif isdefined("CGI.HTTP_REFERER") and findNoCase('ConciliacionTLC', CGI.HTTP_REFERER, 1) or isdefined("form.ConciliacionTLC")>
				1 as ConciliacionTLC,
			</cfif>
		   'ALTA' as modo
	from EmpresasTLC
	<cfif isdefined("filtro") and len(trim(filtro))>
		where 1=1 #PreserveSingleQuotes(filtro)#
	</cfif>
	<cfif isdefined("CGI.HTTP_REFERER") and findNoCase('ConciliacionTLC', CGI.HTTP_REFERER, 1) or isdefined("form.ConciliacionTLC")>
		order by ETLCnomPatrono
	<cfelse>
		order by ETLCpatrono
	</cfif>
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="vertical-align:top">
	<cfset regresar = "/cfmx/hosting/tratado/index.cfm">
	<cfif isdefined("CGI.HTTP_REFERER") and findNoCase('ConciliacionTLC', CGI.HTTP_REFERER, 1) or isdefined("form.ConciliacionTLC")>
		<tr><td>&nbsp;</td></tr>	
	<cfelse>
		<tr><td><cfinclude template="../../../../sif/portlets/pNavegacion.cfm"></td></tr>	
	</cfif>
	  
	<tr style="display: ;" id="verFiltroListaEmpl"> 
		<td> 
			<cfif isdefined("CGI.HTTP_REFERER") and findNoCase('ConciliacionTLC', CGI.HTTP_REFERER, 1) or isdefined("form.ConciliacionTLC")>
				<cfset LvarAction = 'ConciliacionTLC.cfm'>
			<cfelse>
				<cfset LvarAction = 'Empresas-lista.cfm'>
			</cfif>
			<form name="formFiltroListaEmpresa" method="post" action="#LvarAction#">
				<cfif isdefined("CGI.HTTP_REFERER") and findNoCase('ConciliacionTLC', CGI.HTTP_REFERER, 1) or isdefined("form.ConciliacionTLC")>
					<input type="hidden" name="ConciliacionTLC" value="1" />
				</cfif>
				<input type="hidden" name="filtrado" value="<cfif isdefined('form.btnFiltrar') or isdefined('form.filtrado')>Filtrar</cfif>">
				<input type="hidden" name="sel" value="<cfif isdefined('form.sel')><cfoutput>#form.sel#</cfoutput><cfelse>0</cfif>">				
				
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
					<tr> 
						<td width="27%" height="17" class="fileLabel"><cfoutput>#LB_Cedula_Juridica#</cfoutput></td>
						<td width="68%" class="fileLabel"><cfoutput>#vNombre#</cfoutput></td>
						<td width="5%" colspan="2" rowspan="2"><input name="btnFiltrar" class="btnFiltrar" type="submit" id="btnFiltrar" value="<cfoutput>#vFiltrar#</cfoutput>"></td>
					</tr>
					<tr> 
						<td><input name="CedulaFiltro" type="text" id="CedulaFiltro" size="10" maxlength="60" value="<cfif isdefined('form.CedulaFiltro')><cfoutput>#form.CedulaFiltro#</cfoutput></cfif>"></td>
						<td><input name="nombreFiltro" type="text" id="nombreFiltro2" size="30" maxlength="260" value="<cfif isdefined('form.nombreFiltro')><cfoutput>#form.nombreFiltro#</cfoutput></cfif>"></td>
					</tr>
				</table>
			</form>
		</td>
	</tr>		
	<tr style="display: ;" id="verLista"> 
		<td> 
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
					<cfif isdefined("CGI.HTTP_REFERER") and findNoCase('ConciliacionTLC', CGI.HTTP_REFERER, 1) or isdefined("form.ConciliacionTLC")>
						<cfset LvarIrA = 'EmpresasTLC.cfm'>
						<cfset LvarMaxRows = 10>
					<cfelse>
						<cfset LvarIrA = 'Empresas.cfm'>
						<cfset LvarMaxRows = 20>
					</cfif>
						<cfinvoke 
							component="sif.rh.Componentes.pListas"
							method=	"pListaQuery"
							returnvariable="pListaEmpl"
								query 				= "#rsLista#"
								desplegar			= "ETLCpatrono, ETLCnomPatrono"
								etiquetas			= "#LB_Cedula_Juridica#,#vNombre#"
								formatos			= "S,S"
								formName			= "listaEmpresas"	
								align				= "left,left"
								ajustar				= "S"
								irA					= "#LvarIrA#"
								navegacion			= "#navegacion#"
								showEmptyListMsg	= "true"
								maxrows				= "#LvarMaxRows#"
								keys 				= "ETLCid"/>
					</td>
				</tr>
				<tr>
					<td align="center">
						<cfif isdefined("CGI.HTTP_REFERER") and findNoCase('ConciliacionTLC', CGI.HTTP_REFERER, 1) or isdefined("form.ConciliacionTLC")>
							&nbsp;
						<cfelse>
							<form name="formNuevoEmplLista" method="post" action="Empresas.cfm">
								<input type="hidden" name="o" value="1">
								<input type="hidden" name="sel" value="1">
								<input name="btnNuevoLista" class="btnNuevo" type="submit" value="<cfoutput>#LB_Nueva_Empresa#</cfoutput>">
							</form>
						</cfif>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<script language="JavaScript" type="text/javascript">
var Bandera = "L";
function buscar(){
}				
function limpiaFiltrado(){
document.formFiltroListaEmpresa.filtrado.value = "";
document.formFiltroListaEmpresa.sel.value = 0;
}
</script>		
						