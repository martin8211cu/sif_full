<cfif isdefined("form.id_root")>
	<!---- Insert en SRolMenu --->
	<cfquery name="Existencia" datasource="asp">
		select 1 
		from SRolMenu 
		where id_root = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_root#">
		and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#"> 
		and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SRcodigo#"> 
	</cfquery>
	<cfif Existencia.recordcount eq 0 >	
		<cfquery datasource="asp">
			insert into SRolMenu(SScodigo, SRcodigo, id_root, default_menu, BMUsucodigo)
			values ( <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#form.SRcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_root#">,
					 0,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
		</cfquery>
	</cfif>
	<script language="javascript" type="text/javascript">
		window.opener.document.form1.submit();
		window.close();
	</script>
	<cfabort>
</cfif>

<!--- parametros para llamado del conlis --->
<cfif isdefined("Url.fid_root") and not isdefined("Form.fid_root")>
	<cfparam name="Form.fid_root" default="#Url.fid_root#">
</cfif>
<cfif isdefined("Url.fnombre_menu") and not isdefined("Form.fnombre_menu")>
	<cfparam name="Form.fnombre_menu" default="#Url.fnombre_menu#">
</cfif>
<cfif isdefined("Url.SScodigo") and not isdefined("Form.SScodigo")>
	<cfparam name="Form.SScodigo" default="#Url.SScodigo#">
</cfif>
<cfif isdefined("Url.SRcodigo") and not isdefined("Form.SRcodigo")>
	<cfparam name="Form.SRcodigo" default="#Url.SRcodigo#">
</cfif>

<cfset navegacion = "">
<cfif isdefined("Form.fid_root") and Len(Trim(Form.fid_root)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"),DE("")) & "fid_root=" & Form.fid_root>
</cfif>
<cfif isdefined("Form.fnombre_menu") and Len(Trim(Form.fnombre_menu)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"),DE("")) & "fnombre_menu=" & Form.fnombre_menu>
</cfif>
<cfif isdefined("Form.SRcodigo") and Len(Trim(Form.SRcodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"),DE("")) & "SRcodigo=" & Form.SRcodigo>
</cfif>
<cfif isdefined("Form.SScodigo") and Len(Trim(Form.SScodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"),DE("")) & "SScodigo=" & Form.SScodigo>
</cfif>

<html>
<head>
<title>Menus</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
<tr>
	<td>
		<cfoutput>
			<form style="margin:0;" name="filtroMenus" method="post" action="ConlisMenus.cfm" >
				<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
					<tr>
				<td align="right">
					<strong>Posición</strong>
				</td>
				<td> 
					<input name="fid_root" type="text" id="fid_root" size="20" maxlength="9" onClick="this.select();" value="<cfif isdefined("Form.fid_root")>#Form.fid_root#</cfif>">
				</td>
					
				<td align="right"><strong>Descripci&oacute;n</strong></td>
				<td> 
					<input name="fnombre_menu" type="text" id="desc" size="40" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.fnombre_menu")>#Form.fnombre_menu#</cfif>">
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
					<input name="SScodigo" type="hidden" id="SScodigo" size="20" maxlength="9" value="#Form.SScodigo#">
					<input name="SRcodigo" type="hidden" id="SRcodigo" size="20" maxlength="9" value="#Form.SRcodigo#">
				</td>
			</tr>
		</table>
		</form>
		</cfoutput>
	</td></tr>
	
	<tr><td>
		<cfquery name="rsLista" datasource="asp">
		select '#Form.SScodigo#' as SScodigo, '#Form.SRcodigo#' as SRcodigo, 
			   <cfif isdefined("Form.fid_root") and Len(Trim(Form.fid_root))>
			   '#Form.fid_root#' as fid_root,
			   </cfif>
			   <cfif isdefined("Form.fnombre_menu") and Len(Trim(Form.fnombre_menu))>
			   '#Form.fnombre_menu#' as fnombre_menu,
			   </cfif>
			   id_root, id_menu, nombre_menu, orden_menu, case when ocultar_menu=1 then 'X' else ' ' end as ocultar_x
		from SMenu
		where 1=1
		<cfif isdefined("Form.id_root") and Len(Trim(Form.id_root)) >
			and id_root = form.id_root
		</cfif>
		<cfif isdefined("Form.fnombre_menu") and Len(Trim(Form.fnombre_menu))>
			and upper(nombre_menu) like '%#trim(ucase(form.fnombre_menu))#%'
		</cfif>
		order by orden_menu, id_root
		</cfquery>

		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="orden_menu, nombre_menu"/>
			<cfinvokeargument name="etiquetas" value="Posici&oacute;n, Men&uacute;"/>
			<cfinvokeargument name="formatos" value="V, V"/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisMenus.cfm"/>
			<cfinvokeargument name="formName" value="form1"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>
