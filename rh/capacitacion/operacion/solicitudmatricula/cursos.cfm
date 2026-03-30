<cfparam name="form.RHIAid" default="">
<cfparam name="form.filtro_Mnombre" default="">
<cfparam name="form.filtro_RHCfdesde" default="">
<cfparam name="form.filtro_RHCfhasta" default="">
<cfparam name="form.filtro_disponible" default="">

<cfif LSIsDate(form.filtro_RHCfdesde)>
	<cftry>
		<cfset form.filtro_RHCfdesde = LSDateFormat(LSParseDateTime(form.filtro_RHCfdesde),'DD/MM/YYYY')>
	<cfcatch type="any"><cfset form.filtro_RHCfdesde = "">
		</cfcatch></cftry>
<cfelse>
	<cfset form.filtro_RHCfdesde = "">
</cfif>
<cfif LSIsDate(form.filtro_RHCfhasta)>
	<cftry>
		<cfset form.filtro_RHCfhasta = LSDateFormat(LSParseDateTime(form.filtro_RHCfhasta),'DD/MM/YYYY')>
	<cfcatch type="any"><cfset form.filtro_RHCfhasta = "">
		</cfcatch></cftry>
<cfelse>
	<cfset form.filtro_RHCfhasta = "">
</cfif>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Untitled Document</title>
</head>

<cfquery datasource="#session.dsn#" name="cursos">
	select m.Msiglas,m.Mcodigo, m.Mnombre
	from RHMateria m
	where m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  <cfif Len(form.filtro_Mnombre)>
	  and upper(m.Mnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(form.filtro_Mnombre)#%">
	  </cfif>
	order by m.Mnombre
</cfquery>

<body style="margin:0;background-color:white;">
<form style="margin:0" action="cursos.cfm" method="post" name="listaCursos" id="listaCursos" >
<table style="background-color:blue;color:white;width:100%">
<tr>
  <td align="left">
Cursos disponibles para capacitaci&oacute;n</td>
  <td align="center" onclick="cancelar()" style="cursor:pointer;border:solid 1px gray">X</td></tr></table>
<cfset navegacion="">
			<cfinvoke 
				 component="rh.Componentes.pListas"
				 method="pListaQuery" 
				 mostrar_filtro="yes" >
					<cfinvokeargument name="query" value="#cursos#"/>
					<cfinvokeargument name="desplegar" value="Msiglas,Mnombre"/>
					<cfinvokeargument name="etiquetas" value="Curso, "/>
					<cfinvokeargument name="formatos" value="S,S"/>
					<cfinvokeargument name="align" value="left,left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="funcion" value="selecciona"/>
					<cfinvokeargument name="fparams" value="Mcodigo,Mnombre"/>
					<cfinvokeargument name="checkboxes" value="N">
					<cfinvokeargument name="keys" value="Mcodigo">
					<cfinvokeargument name="formName" value="listaCursos">
					<cfinvokeargument name="incluyeform" value="no">
					<cfinvokeargument name="cortes" value="">
					<cfinvokeargument name="showEmptyListMsg" value="true">
					<cfinvokeargument name="EmptyListMsg" value="*** NO SE HAN REGISTRADO CURSOS ***">
					<cfinvokeargument name="navegacion" value="#navegacion#">
		  </cfinvoke>
		  </form>
<script type="text/javascript">
<!--
	function selecciona(Mcodigo,Mnombre){
		var w = window.parent?window.parent:window.opener;
		if (w) {
			w.seleccionar_curso(null,Mcodigo,Mnombre,"","","","","");
		}
	}
	function cancelar(){
		var w = window.parent?window.parent:window.opener;
		if (w) {
			w.cancelar_curso();
		}
	}
//-->
</script>
</body>
</html>
