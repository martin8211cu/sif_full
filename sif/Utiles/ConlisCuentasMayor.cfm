<!--- parametros para llamado del conlis --->
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>
<cfif isdefined("Url.codigo") and not isdefined("Form.codigo")>
	<cfparam name="Form.codigo" default="#Url.codigo#">
</cfif>
<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>
<cfif isdefined("Url.tipo") and not isdefined("Form.tipo")>
	<cfparam name="Form.tipo" default="#Url.tipo#">
</cfif>
<cfif isdefined("Url.cargar_mascara") and not isdefined("Form.cargar_mascara")>
	<cfparam name="Form.cargar_mascara" default="#Url.cargar_mascara#">
</cfif>
<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(codigo,desc) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#form.formulario#.#form.codigo#.value = codigo;
		window.opener.document.#form.formulario#.#form.desc#.value = desc;
		<cfif isdefined("form.cargar_mascara")>
			window.opener.document.#form.formulario#.#form.cargar_mascara#.value = arguments[2];
		</cfif>
		</cfoutput>
		window.close();
	}
}
</script>

<!--- Filtro --->

<cfif isdefined("Url.Cmayor") and not isdefined("Form.Cmayor")>
	<cfparam name="Form.Cmayor" default="#Url.Cmayor#">
</cfif>

<cfif isdefined("Url.Cdescripcion") and not isdefined("Form.Cdescripcion")>
	<cfparam name="Form.Cdescripcion" default="#Url.Cdescripcion#">
</cfif>

<cfset navegacion = "">
<cfif isdefined("Form.Cmayor") and Len(Trim(Form.Cmayor)) NEQ 0>
	<cfset navegacion = navegacion & "&Cmayor=" & Form.Cmayor>
</cfif>
<cfif isdefined("Form.Cdescripcion") and Len(Trim(Form.Cdescripcion)) NEQ 0>
	<cfset navegacion = navegacion & "&Cdescripcion=" & Form.Cdescripcion>
</cfif>
<cfif isdefined("Form.Ctipo") and Len(Trim(Form.Ctipo)) NEQ 0>
	<cfset navegacion = navegacion & "&Ctipo=" & Form.Ctipo>
</cfif>
<cfif isdefined("Form.formulario") and Len(Trim(Form.formulario)) NEQ 0>
	<cfset navegacion = navegacion & "&formulario=" & Form.formulario>
</cfif>
<cfif isdefined("Form.codigo") and Len(Trim(Form.codigo)) NEQ 0>
	<cfset navegacion = navegacion & "&codigo=" & Form.codigo>
</cfif>
<cfif isdefined("Form.desc") and Len(Trim(Form.desc)) NEQ 0>
	<cfset navegacion = navegacion & "&desc=" & Form.desc>
</cfif>
<cfif isdefined("Form.cargar_mascara") and Len(Trim(Form.cargar_mascara)) NEQ 0>
	<cfset navegacion = navegacion & "&cargar_mascara=" & Form.cargar_mascara>
</cfif>

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Codigo" returnvariable="LB_Codigo" default = "C&oacute;digo" xmlfile="ConlisAlmacen.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Descripcion" returnvariable="LB_Descripcion" default = "Descripci&oacute;n" xmlfile="ConlisAlmacen.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ListCtaMayor" returnvariable="LB_ListCtaMayor" default = "Lista de Cuentas de Mayor">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Filtrar" returnvariable="BTN_Filtrar" default = "Filtrar" xmlfile="ConlisAlmacen.xml">


<html>
<head>
<title><cfoutput>#LB_ListCtaMayor#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
<tr>
	<td>
		<cfoutput>
			<form style="margin:0;" name="filtroCuentasMayor" method="post" action="ConlisCuentasMayor.cfm" >
				<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
					<tr>
				<td align="right"><strong>#LB_Codigo#</strong></td>
				<td> 
					<input name="Cmayor" type="text" id="codigo" size="20" maxlength="9" onClick="this.select();" value="<cfif isdefined("Form.Cmayor")>#Form.Cmayor#</cfif>">
				</td>
					
				<td align="right"><strong>#LB_Descripcion#</strong></td>
				<td> 
					<input name="Cdescripcion" type="text" id="desc" size="40" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.Cdescripcion")>#Form.Cdescripcion#</cfif>">
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#">
					<cfif isdefined("form.formulario") and len(trim(form.formulario))>
						<input type="hidden" name="formulario" value="#form.formulario#">
					</cfif>
					<cfif isdefined("form.codigo") and len(trim(form.codigo))>
						<input type="hidden" name="codigo" value="#form.codigo#">
					</cfif>
					<cfif isdefined("form.desc") and len(trim(form.desc))>
						<input type="hidden" name="desc" value="#form.desc#">
					</cfif>
					<cfif isdefined("form.cargar_mascara") and len(trim(form.cargar_mascara))>
						<input type="hidden" name="cargar_mascara" value="#form.cargar_mascara#">
					</cfif>
				</td>
			</tr>
		</table>
		</form>
		</cfoutput>
	</td></tr>
	<tr><td>
		<cfquery name="rsLista" datasource="#session.DSN#">
			select Cmayor, Cdescripcion, PCEMid
			from CtasMayor 
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			
			<cfif isdefined("Form.Cmayor") and Len(Trim(Form.Cmayor)) >
				and upper(Cmayor) like '%#trim(ucase(form.Cmayor))#%'
			</cfif>
			<cfif isdefined("Form.Cdescripcion") and Len(Trim(Form.Cdescripcion))>
				and upper(Cdescripcion) like '%#trim(ucase(form.Cdescripcion))#%'
			</cfif>
            <cfif isdefined("form.tipo") and Len(Trim(form.tipo))>
				and upper(Ctipo) like '%#trim(ucase(form.tipo))#%'
			</cfif>
			order by Cmayor, Cdescripcion
		</cfquery>

		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="Cmayor, Cdescripcion"/>
			<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#"/>
			<cfinvokeargument name="formatos" value="V, V"/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisCuentasMayor.cfm"/>
			<cfinvokeargument name="formName" value="form1"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfif isdefined("Form.cargar_mascara")>
				<cfinvokeargument name="fparams" value="Cmayor, Cdescripcion, PCEMid"/>
			<cfelse>
				<cfinvokeargument name="fparams" value="Cmayor, Cdescripcion"/>
			</cfif>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>

