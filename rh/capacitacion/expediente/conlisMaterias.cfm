<!---
<cfquery name="rsMaterias" datasource="#session.DSN#">
	select Mcodigo, Msiglas, Mnombre
	from RHMateria
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	order by Msiglas
</cfquery>

<cfif isdefined("url.formulario") and not isdefined("form.formulario")>
	<cfset form.formulario = url.formulario>
<cfelse>	
	<cfset form.formulario = form1>
</cfif>
<cfif isdefined("url.index") and not isdefined("form.index")>
	<cfset form.index = url.index>
</cfif>
<!--- Recibe conexion, form, name y desc --->
<script language="JavaScript" type="text/javascript">
function Asignar<cfoutput>#index#</cfoutput>(Mcodigo,Msiglas,Mnombre) {
	if (window.opener != null) {	
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.Mcodigo<cfoutput>#form.index#</cfoutput>.value = Mcodigo;
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.Msiglas<cfoutput>#form.index#</cfoutput>.value = Msiglas;
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.Mnombre<cfoutput>#form.index#</cfoutput>.value = Mnombre;
		window.close();
	}
}
</script>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.fMsiglas") and Len(Trim(Form.fMsiglas)) NEQ 0>	
	<cfset filtro = filtro & " and upper(a.Msiglas) like '%" & UCase(Form.fMsiglas) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fMsiglas=" & Form.fMsiglas>
</cfif>
<cfif isdefined("Form.fMnombre") and Len(Trim(Form.fMnombre)) NEQ 0>
 	<cfset filtro = filtro & " and upper(a.Mnombre) like '%" & UCase(Form.fMnombre) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fMnombre=" & Form.fMnombre>
</cfif>

--->
<html>
<head>
<title><cf_translate key="LB_ListaDeMaterias" xmlFile="/rh/generales.xml">Lista de Materias</cf_translate></title>


</head>
<body>


<!---
<cfoutput>
<form style="margin:0;" name="filtroCursos" method="post">
<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">	
<!---
	<cfif Len(Trim(index))>
		<input type="hidden" name="index" value="#index#">
	</cfif>			  	
	<tr>
		<td width="7%" align="right"><strong>Siglas</strong></td>
		<td width="12%"> 
			<input name="fMsiglas" type="text" id="desc" size="10" maxlength="15" value="<cfif isdefined("Form.fMsiglas")>#Form.fMsiglas#</cfif>" onFocus="javascript:this.select();">
		</td>
		<td width="11%" align="right"><strong>Descripci&oacute;n</strong></td>
		<td width="32%"> 
			<input name="fMnombre" type="text" id="desc" size="40" maxlength="50" value="<cfif isdefined("Form.fMnombre")>#Form.fMnombre#</cfif>" onFocus="javascript:this.select();">
		</td>				
		<td width="38%" align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>	
--->	
</table>
</form>
</cfoutput>

<cfquery name="lista" datasource="#session.DSN#">
	select a.Mcodigo,a.Msiglas,a.Mnombre
	from RHMateria a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
	#preservesinglequotes(filtro)#
	order by a.Msiglas, a.Mnombre
</cfquery>
--->
<!---
<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="query" value="#lista#"/>
	<cfinvokeargument name="desplegar" value="Msiglas,Mnombre"/>
	<cfinvokeargument name="etiquetas" value="Siglas, Descripción materia"/>
	<cfinvokeargument name="formatos" value="V,V"/>
	<cfinvokeargument name="align" value="left,left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisMaterias.cfm"/>
	<cfinvokeargument name="formName" value="lista"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar#index#"/>
	<cfinvokeargument name="fparams" value="Mcodigo,Msiglas,Mnombre"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="yes"/>
	<!---<cfinvokeargument name="Cortes" value="RHIAnombre"/>--->
</cfinvoke>
--->

</body>
</html
