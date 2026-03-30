<!--- parametros para llamado del conlis --->
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>
<cfif isdefined("Url.RHEDVid") and not isdefined("Form.RHEDVid")>
	<cfparam name="Form.RHEDVid" default="#Url.RHEDVid#">
</cfif>
<cfif isdefined("Url.RHEDVcodigo") and not isdefined("Form.RHEDVcodigo")>
	<cfparam name="Form.RHEDVcodigo" default="#Url.RHEDVcodigo#">
</cfif>
<cfif isdefined("Url.RHEDVdescripcion") and not isdefined("Form.RHEDVdescripcion")>
	<cfparam name="Form.RHEDVdescripcion" default="#Url.RHEDVdescripcion#">
</cfif>

<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(RHEDVid, RHEDVcodigo,RHEDVdescripcion) {	
	var prueba = '';
	var prueba2 = '';
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#form.formulario#.#form.RHEDVid#.value = RHEDVid;
		window.opener.document.#form.formulario#.#form.RHEDVcodigo#.value = trim(RHEDVcodigo);
		window.opener.document.#form.formulario#.#form.RHEDVdescripcion#.value = RHEDVdescripcion;
		if (window.opener.func#form.RHEDVcodigo#) {
			window.opener.func#form.RHEDVcodigo#();
		}
		</cfoutput>
		window.close();
	}
}
</script>

<!--- Filtro --->
<cfif isdefined("Url.codigo") and not isdefined("Form.codigo")>
	<cfparam name="Form.codigo" default="#Url.codigo#">
</cfif>
<cfif isdefined("Url.descripcion") and not isdefined("Form.descripcion")>
	<cfparam name="Form.descripcion" default="#Url.descripcion#">
</cfif>

<cfset filtro = "">
<cfset desc = "Datos Variables" >

<cfset navegacion = "&formulario=#form.formulario#&RHEDVcodigo=#form.RHEDVcodigo#&RHEDVdescripcion=#form.RHEDVcodigo#&RHEDVid=#form.RHEDVid#">
<cfif isdefined("Form.codigo") and Len(Trim(Form.codigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(RHEDVcodigo) like '%" & UCase(Form.codigo) & "%'">
	<cfset navegacion = navegacion & "&codigo=" & Form.codigo>
</cfif>
<cfif isdefined("Form.descripcion") and Len(Trim(Form.descripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(RHEDVdescripcion) like '%" & UCase(Form.descripcion) & "%'">
	<cfset navegacion = navegacion & "&descripcion=" & Form.descripcion>
</cfif>

<html>
<head>
<title><cf_translate  key="LB_ListaDeDatosVariables">Lista de Datos Variables</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="LB_CODIGO"
default="C&oacute;digo"
xmlfile="/rh/generales.xml"
returnvariable="LB_CODIGO"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="LB_DESCRIPCION"
default="Descripci&oacute;n"
xmlfile="/rh/generales.xml"
returnvariable="LB_DESCRIPCION"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="BTN_Filtrar"
default="Filtrar"
xmlfile="/rh/generales.xml"
returnvariable="BTN_Filtrar"/>

<table width="100%" cellpadding="2" cellspacing="0">
	<!---<tr><td><table width="100%"><tr><td class="tituloMantenimiento" align="center"><font size="2">Conceptos de Servicio</font></td></tr></table></td></tr>--->
	<tr><td>
		<cfoutput>
		<form style="margin:0;" name="filtroEmpleado" method="post" action="ConlisDatosVariables.cfm" >
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>#LB_Codigo#</strong></td>
				<td> 
					<input name="codigo" type="text" id="codigo" size="10" maxlength="10" onClick="this.select();" value="<cfif isdefined("Form.codigo")>#Form.codigo#</cfif>">
				</td>
				<td align="right"><strong>#LB_DESCRIPCION#</strong></td>
				<td> 
					<input name="descripcion" type="text" id="desc" size="40" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.descripcion")>#Form.descripcion#</cfif>">					
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#">
					<cfif isdefined("form.formulario") and len(trim(form.formulario))>
						<input type="hidden" name="formulario" value="#form.formulario#">
					</cfif>
					<cfif isdefined("form.RHEDVid") and len(trim(form.RHEDVid))>
						<input type="hidden" name="RHEDVid" value="#form.RHEDVid#">
					</cfif>
					<cfif isdefined("form.RHEDVcodigo") and len(trim(form.RHEDVcodigo))>
						<input type="hidden" name="RHEDVcodigo" value="#form.RHEDVcodigo#">
					</cfif>
					<cfif isdefined("form.RHEDVdescripcion") and len(trim(form.RHEDVdescripcion))>
						<input type="hidden" name="RHEDVdescripcion" value="#form.RHEDVdescripcion#">
					</cfif>
					<input type="hidden" name="tipo" value="<cfif isdefined("form.tipo") and len(trim(form.tipo))>#form.tipo#</cfif>">
				</td>
			</tr>
		</table>
		</form>
		</cfoutput>
	</td></tr>
	
	<tr><td>
		<cfquery name="rsLista" datasource="#session.DSN#">
			select RHEDVid, RHEDVcodigo, RHEDVdescripcion
			from RHEDatosVariables
			where  Ecodigo= <cfqueryparam value="#session.Ecodigo#"  cfsqltype="cf_sql_integer">
			   and RHEDVtipo = 0
			<cfif isdefined("filtro") and len(trim(filtro))>
				#preservesinglequotes(filtro)#
			</cfif>
			order by RHEDVcodigo			
		</cfquery>
							
		<!---- Se crea una estructura rsLista2 donde se cargan los datos del query para usar la funcion REreplaceNocase()--->			
		<cfset rsLista2 = querynew("RHEDVid, RHEDVcodigo, RHEDVdescripcion")>
		<cfset cont = 1>
		<cfloop query="rsLista">
			<cfset res = queryaddrow(rsLista2)>
			<cfset res = querysetcell(rsLista2, 'RHEDVid', rsLista.RHEDVid, cont)>
			<cfset res = querysetcell(rsLista2, 'RHEDVcodigo', rsLista.RHEDVcodigo, cont)>
			<cfset res = querysetcell(rsLista2, 'RHEDVdescripcion', 
				REReplaceNoCase(rsLista.RHEDVdescripcion, '\r|\n|<[^>]*>', '', 'all'), cont)>
			<cfset cont = cont + 1>
		</cfloop>			
										
		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista2#"/>
			<cfinvokeargument name="desplegar" value="RHEDVcodigo, RHEDVdescripcion"/>
			<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisDatosVariables.cfm"/>
			<cfinvokeargument name="formName" value="form1"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="RHEDVid, RHEDVcodigo, RHEDVdescripcion"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>