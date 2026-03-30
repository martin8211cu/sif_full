<!--- Recibe conexion, form, name y desc --->
<!--- 
<cfquery name="rsDpto" datasource="#session.Fondos.dsn#">
	select  top 10 DEPCOD,DEPDES
	from PLX002
	order by DEPCOD
</cfquery>	
 --->
<script language="JavaScript" type="text/javascript">
	function Asignar(id,name,desc,depcod,depdes) {
		if (window.opener != null) {
			<cfoutput>
				window.opener.document.#Url.form#.#Url.id#.value   = id;
				window.opener.document.#Url.form#.#Url.name#.value = name;
				window.opener.document.#Url.form#.#Url.desc#.value = desc;
				window.opener.document.#Url.form#.#Url.name2#.value = depcod;
				window.opener.document.#Url.form#.#Url.desc2#.value = depdes;
				/*				
				if (depcod != null) {
					AsignarDep(depcod)
				}
				*/
			</cfoutput>
			window.close();
		}
	}
	
	<!--- 	
	function AsignarDep(id){
		/*
		<cfoutput>
			window.opener.document.#Url.form#.#Url.name2#.value = "";
			window.opener.document.#Url.form#.#Url.desc2#.value = "";
		</cfoutput>
		<cfoutput query="rsDpto">
			if (#Trim(rsDpto.DEPCOD)#==id) {
				window.opener.document.#Url.form#.#Url.name2#.value = '#Trim(rsDpto.DEPCOD)#';
				window.opener.document.#Url.form#.#Url.desc2#.value = '#Trim(rsDpto.DEPDES)#';
			}
		</cfoutput>
		*/
	} 
	--->
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
<cfset cond = " and ">
<cfif isdefined("Form.EMPCED") and Len(Trim(Form.EMPCED)) NEQ 0>
	
	<cfset filtro = filtro & cond & " EMPCED like '%" & #Form.EMPCED# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EMPCED=" & Form.EMPCED>
	<cfset cond = " and">
</cfif>
<cfif isdefined("Form.NOMBRE") and Len(Trim(Form.NOMBRE)) NEQ 0>
	
 	<cfset filtro = filtro & cond & " upper(ltrim(rtrim(EMPNOM)) + ' ' + ltrim(rtrim(EMPAPA)) + ' ' + ltrim(rtrim(EMPAMA))) like '%" & #UCase(Form.NOMBRE)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "NOMBRE=" & Form.NOMBRE>
	<cfset cond = " and">
</cfif>
<html>
<head>
<title>Catálogo de Empleados</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/cfmx/sif/fondos/css/estilos.css" rel="stylesheet" type="text/css">
</head>
<body>

<!--- Se le asigna al filtro una condicion no posible para que no salga nada --->
<cfif isdefined("URL.filtrarinicio") 
      and not URL.filtrarinicio 
	  and not isdefined("Form.EMPCED")
	  and not isdefined("Form.NOMBRE")>
	<cfset filtro = " and 1=2 ">
</cfif>
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
	<cfinvokeargument name="tabla" value="PLM001,PLX002"/>
 	<cfinvokeargument name="columnas" value="EMPCOD,EMPCED,EMPNOM +' '+EMPAPA+' '+EMPAMA  NOMBRE,PLM001.DEPCOD,PLX002.DEPDES"/>
	<cfinvokeargument name="desplegar" value="EMPCED,NOMBRE"/>
	<cfinvokeargument name="etiquetas" value="Cédula,Nombre"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="PLM001.DEPCOD = PLX002.DEPCOD #filtro#"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="cjcConlis.cfm"/>
	<cfinvokeargument name="formName" value="listaempleados"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="EMPCOD,EMPCED,NOMBRE,DEPCOD,DEPDES"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
	<cfinvokeargument name="RowCount" value="20"/>
</cfinvoke>

<cfif isdefined("URL.filtrarinicio") 
	  and not URL.filtrarinicio
	  and not isdefined("Form.EMPCED") 
	  and not isdefined("Form.NOMBRE")>
	<center>
	<BR>Para buscar un empleado por favor utilice los filtros
	</center>
</cfif>
</body>
</html>
