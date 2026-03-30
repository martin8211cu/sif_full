<cfif isdefined("url.DEid") and len(trim(url.DEid)) and not isdefined("form.DEid")>
	<cfset form.DEid = url.DEid >
</cfif>

<cfif isdefined("url.fMnombre") and len(trim(url.fMnombre)) and not isdefined("form.fMnombre")>
	<cfset form.fMnombre = url.fMnombre >
</cfif>

<cfif isdefined("url.RHIAid") and len(trim(url.RHIAid)) and not isdefined("form.RHIAid")>
	<cfset form.RHIAid = url.RHIAid >
</cfif>

<cfif isdefined("url.formulario") and not isdefined("form.formulario")>
	<cfset form.formulario = url.formulario>
<cfelse>	
	<cfset form.formulario = form1>
</cfif>

<!--- Recibe conexion, form, name y desc --->
<script language="JavaScript" type="text/javascript">
function Asignar(id,name,desc) {
	if (window.opener != null) {
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.Mcodigo.value = id;
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.Mnombre.value = desc;
		window.close();
	}
}
</script>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.fMcodigo") and Len(Trim(Form.fMcodigo)) NEQ 0>
	<cfset filtro = filtro & " and Mcodigo = #Form.fMcodigo# ">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fMcodigo=" & Form.fMcodigo>
</cfif>
<cfif isdefined("Form.fMnombre") and Len(Trim(Form.fMnombre)) NEQ 0>
 	<cfset filtro = filtro & " and upper(Mnombre) like '%" & #UCase(Form.fMnombre)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fMnombre=" & Form.fMnombre>
</cfif>
<cfif isdefined("Form.RHIAid") and Len(Trim(Form.RHIAid)) NEQ 0>
 	<cfset filtro = filtro & " and RHIAid = #Form.RHIAid#">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHIAid=" & Form.RHIAid>
</cfif>

<html>
<head>
<title><cf_translate key="LB_ListaDeMaterias" xmlFile="/rh/generales.xml">Lista de Materias</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form style="margin:0;" name="filtroEmpleado" method="post">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>Descripci&oacute;n</strong></td>
		<td> 
			<input name="fMnombre" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.fMnombre")>#Form.fMnombre#</cfif>" onFocus="javascript:this.select();">
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
		<cfif isdefined("form.RHIAid") and len(trim(form.RHIAid))><input type="hidden" name="RHIAid" value="#form.RHIAid#"></cfif>
	</tr>
</table>
</form>
</cfoutput>

<cfquery name="lista" datasource="#session.DSN#">
	select Mcodigo, Mnombre, Msiglas
	from RHMateria
	where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Mactivo = 1

	<cfif isdefined("Form.fMnombre") and Len(Trim(Form.fMnombre)) NEQ 0>
		and upper(Mnombre) like '%#UCase(Form.fMnombre)#%'
	</cfif>

	and Mcodigo in ( select Mcodigo
						 from RHOfertaAcademica
						 where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						   and RHIAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIAid#"> )
	order by Msiglas, Mnombre
</cfquery>

<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="query" value="#lista#"/>
	<cfinvokeargument name="desplegar" value="Mnombre"/>
	<cfinvokeargument name="etiquetas" value="Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="align" value="left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisRHMaterias.cfm"/>
	<cfinvokeargument name="formName" value="lista"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="Mcodigo,Msiglas,Mnombre"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="yes"/>
</cfinvoke>
</body>
</html>