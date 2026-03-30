<!--- Recibe conexion, form, name y desc --->
<cfquery name="departamento" datasource="#session.Fondos.dsn#">
	SELECT DEPCOD,DEPDES
	FROM PLX002
</cfquery>	

<script language="JavaScript" type="text/javascript">
function AsignarDep(id){
	<cfoutput>
		window.opener.document.#Url.form#.#Url.name2#.value = "";
		window.opener.document.#Url.form#.#Url.desc2#.value = "";
	</cfoutput>

	<cfoutput query="departamento">
	if (#Trim(departamento.DEPCOD)#==id) {
		window.opener.document.#Url.form#.#Url.name2#.value = '#Trim(departamento.DEPCOD)#';
		window.opener.document.#Url.form#.#Url.desc2#.value = '#Trim(departamento.DEPDES)#';
	}			
	</cfoutput>
}

function Asignar(id,name,desc,depcod) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Url.form#.#Url.id#.value   = id;
		window.opener.document.#Url.form#.#Url.name#.value = name;
		window.opener.document.#Url.form#.#Url.desc#.value = desc;
		
		if (depcod != null) {
			AsignarDep(depcod)
		}
		</cfoutput>
		window.close();
	}
}
</script>

<cfif isdefined("Url.EMPCED") and not isdefined("Form.EMPCED")>
	<cfparam name="Form.EMPCED" default="#Url.EMPCED#">
</cfif>

<cfif isdefined("Url.NOMBRE") and not isdefined("Form.NOMBRE")>
	<cfparam name="Form.NOMBRE" default="#Url.NOMBRE#">
</cfif>

<cfif isdefined("Url.EMPCOD") and not isdefined("Form.EMPCOD")>
	<cfparam name="Form.EMPCOD" default="#Url.EMPCOD#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfset cond = "">
<cfif isdefined("Form.EMPCED") and Len(Trim(Form.EMPCED)) NEQ 0>
	
	<cfset filtro = filtro & cond & " upper(EMPCED) like '%" & #UCase(Form.EMPCED)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EMPCED=" & Form.EMPCED>
	<cfset cond = " and">
</cfif>
<cfif isdefined("Form.NOMBRE") and Len(Trim(Form.NOMBRE)) NEQ 0>
	
 	<cfset filtro = filtro & cond & " upper(EMPNOM + EMPAPA + EMPAMA) like '%" & #UCase(Form.NOMBRE)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "NOMBRE=" & Form.NOMBRE>
	<cfset cond = " and">
</cfif>
<html>
<head>
<title>Catálogo de Empleados</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
	<form style="margin:0; " name="filtroEmpleado" method="post">
	
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>Cédula</strong></td>
				<td> 
					<input name="EMPCED" type="text" id="name" size="16" maxlength="16" value="<cfif isdefined("Form.EMPCED")>#Form.EMPCED#</cfif>">
				</td>
				<td align="right"><strong>Nombre</strong></td>
				<td> 
					<input name="NOMBRE" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.NOMBRE")>#Form.NOMBRE#</cfif>">
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
				</td>
			</tr>
		</table>
	</form>
</cfoutput>

<cfinvoke 
 component="sif.fondos.Componentes.pListas"
 method="pLista"
 returnvariable="pListaRet">
	<cfinvokeargument name="tabla" value="PLM001"/>
 	<cfinvokeargument name="columnas" value="EMPCOD,EMPCED,EMPNOM +' '+EMPAPA+' '+EMPAMA  NOMBRE,DEPCOD"/>
	<cfinvokeargument name="desplegar" value="EMPCED,NOMBRE"/>
	<cfinvokeargument name="etiquetas" value="Cédula,Nombre"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="#filtro#"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="cjcConlis.cfm"/>
	<cfinvokeargument name="formName" value="listaempleados"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="EMPCOD,EMPCED,NOMBRE,DEPCOD"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>

</cfinvoke>
</body>
</html>