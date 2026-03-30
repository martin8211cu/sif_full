<cfif isdefined("url.id_inst") and not isdefined("form.id_inst")>
	<cfset form.id_inst =  url.id_inst >
</cfif>
<cfif isdefined("url.id_grupo") and not isdefined("form.id_grupo")>
	<cfset form.id_grupo =  url.id_grupo >
</cfif>

<!--- Recibe conexion, form, name y desc --->
<script language="JavaScript" type="text/javascript">
function Asignar(id,name) {
	if (window.opener != null) {
		window.opener.document.formfg.id_funcionario.value = id;
		window.opener.document.formfg.nombre.value = name;
		window.close();
	}
}
</script>

<cfif isdefined("Url.fnombre") and not isdefined("Form.fnombre")>
	<cfparam name="Form.fnombre" default="#Url.fnombre#">
</cfif>
<cfif isdefined("Url.fapellido1") and not isdefined("Form.fapellido1")>
	<cfparam name="Form.fapellido1" default="#Url.fapellido1#">
</cfif>
<cfif isdefined("Url.fapellido2") and not isdefined("Form.fapellido2")>
	<cfparam name="Form.fapellido2" default="#Url.fapellido2#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.fnombre") and Len(Trim(Form.fnombre)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fnombre=" & Form.fnombre>
</cfif>
<cfif isdefined("Form.fapellido1") and Len(Trim(Form.fapellido1)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fapellido1=" & Form.fapellido1>
</cfif>
<cfif isdefined("Form.fapellido2") and Len(Trim(Form.fapellido2)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fapellido2=" & Form.fapellido2>
</cfif>

<html>
<head>
<title>Lista de Funcionarios</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form style="margin:0;" name="filtro" method="post">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>Nombre:&nbsp;</strong></td>
		<td> 
			<input name="fnombre" type="text" id="desc" size="20" maxlength="60" value="<cfif isdefined("Form.fnombre")>#Form.fnombre#</cfif>" onFocus="javascript:this.select();">
		</td>
		<td align="right"><strong>Apellidos:&nbsp;</strong></td>
		<td> 
			<input name="fapellido1" type="text" id="fapellido1" size="20" maxlength="60" value="<cfif isdefined("Form.fapellido1")>#Form.fapellido1#</cfif>" onFocus="javascript:this.select();">
			<input name="fapellido2" type="text" id="fapellido2" size="20" maxlength="60" value="<cfif isdefined("Form.fapellido2")>#Form.fapellido2#</cfif>" onFocus="javascript:this.select();">
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
		<input type="hidden" name="id_inst" value="#form.id_inst#">
		<input type="hidden" name="id_grupo" value="#form.id_grupo#">
	</tr>
</table>
</form>
</cfoutput>

<cfquery name="rsLista" datasource="#session.tramites.dsn#">
	select f.id_funcionario, nombre ||' '|| apellido1 ||' '|| apellido2 as nombre

	from TPFuncionario f
	
	inner join TPPersona p
	on p.id_persona = f.id_persona
	
	<cfif isdefined("form.fnombre") and len(trim(form.fnombre))>
		and upper(nombre) like '%#ucase(form.fnombre)#%'
	</cfif>
	<cfif isdefined("form.fapellido1") and len(trim(form.fapellido1))>
		and upper(apellido1) like '%#ucase(form.fapellido1)#%'
	</cfif>
	<cfif isdefined("form.fapellido2") and len(trim(form.fapellido2))>
		and upper(apellido2) like '%#ucase(form.fapellido2)#%'
	</cfif>
	
	where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between f.vigente_desde and vigente_hasta
	and id_funcionario not in ( select id_funcionario 
								from TPFuncionarioGrupo fg
								inner join TPGrupo g
								on g.id_grupo=fg.id_grupo
								and g.id_grupo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_grupo#">
								and g.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#"> )
	order by 2
</cfquery>

<cfinvoke 
 component="sif.rh.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="query" value="#rsLista#"/>
	<cfinvokeargument name="desplegar" value="nombre"/>
	<cfinvokeargument name="etiquetas" value="Funcionario"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="align" value="left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisFuncionarios.cfm"/>
	<cfinvokeargument name="MaxRows" value="25"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="id_funcionario,nombre"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="yes"/>
</cfinvoke>
</body>
</html>