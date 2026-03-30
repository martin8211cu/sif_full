<!--- Recibe conexion, form, name y desc --->

<cfquery name="rs" datasource="#session.dsn#">
Select Oficodigo as CGE1COD
from Oficinas 
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
<!---select CGE1COD  from  CGE000--->
</cfquery>



<script language="JavaScript" type="text/javascript">

function Asignar(ocodigo, name,desc) {

	if (window.opener != null) {

		<cfoutput>
		window.opener.document.#Url.form#.#Url.id#.value = ocodigo;
		
		window.opener.document.#Url.form#.#Url.name#.value = name;

		window.opener.document.#Url.form#.#Url.desc#.value = desc;

		window.opener.document.#Url.form#.CGM1IM.disabled = false;
		</cfoutput>

		window.close();

	}

}

</script>



<cfif isdefined("Url.CGE5COD") and not isdefined("Form.CGE5COD")>

	<cfparam name="Form.CGE5COD" default="#Url.CGE5COD#">

</cfif>



<cfif isdefined("Url.CGE5DES") and not isdefined("Form.CGE5DES")>

	<cfparam name="Form.CGE5DES" default="#Url.CGE5DES#">

</cfif>





<cfset filtro = "">

<cfset navegacion = "">

<cfset cond = "">

<cfif isdefined("Form.CGE5COD") and Len(Trim(Form.CGE5COD)) NEQ 0>

	<cfset cond = " and">

	<cfset filtro = filtro & cond & " upper(Oficodigo) like '%" & #UCase(Form.CGE5COD)# & "%'">

	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CGE5COD=" & Form.CGE5COD>

</cfif>

<cfif isdefined("Form.CGE5DES") and Len(Trim(Form.CGE5DES)) NEQ 0>

	<cfset cond = " and">

 	<cfset filtro = filtro & cond & " upper(Odescripcion) like '%" & #UCase(Form.CGE5DES)# & "%'">

	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CGE5DES=" & Form.CGE5DES>

</cfif>

<html>

<head>

<title>Catálogo de UEN</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link href="/cfmx/sif/Contaweb/css/estilos.css" rel="stylesheet" type="text/css">

</head>

<body>

<cfoutput>

	<form style="margin:0; " name="filtroOrdenes" method="post">

	

		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">

			<tr>

				<td align="right"><strong>Código</strong></td>

				<td> 

					<input name="CGE5COD" type="text" id="name" size="14" maxlength="14" value="<cfif isdefined("Form.CGE5COD")>#Form.CGE5COD#</cfif>">

				</td>

				<td align="right"><strong>Descripción</strong></td>

				<td> 

					<input name="CGE5DES" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.CGE5DES")>#Form.CGE5DES#</cfif>">

				</td>

				<td align="center">

					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">

				</td>

			</tr>

		</table>

	</form>

</cfoutput>

<cfinvoke 

 component="sif.Componentes.pListas"

 method="pLista"

 returnvariable="pListaRet">

	<cfinvokeargument name="tabla" value="Oficinas"/><!--- CGE005,CGE000 --->

 	<cfinvokeargument name="columnas" value="Ocodigo, Oficodigo, Odescripcion"/><!--- CGE005.CGE5COD,CGE5DES --->

	<cfinvokeargument name="desplegar" value="Oficodigo, Odescripcion"/><!--- CGE5COD,CGE5DES --->

	<cfinvokeargument name="etiquetas" value="Código,Descripción"/>

	<cfinvokeargument name="formatos" value=""/>

	<cfinvokeargument name="filtro" value="  Ecodigo=#session.Ecodigo# #filtro#"/><!--- CGE005.CGE1COD = CGE000.CGE1COD --->

	<cfinvokeargument name="align" value="left, left"/>

	<cfinvokeargument name="ajustar" value=""/>

	<cfinvokeargument name="irA" value="cjcConlis.cfm"/>

	<cfinvokeargument name="formName" value="listauEN"/>

	<cfinvokeargument name="MaxRows" value="20"/>

	<cfinvokeargument name="funcion" value="Asignar"/>

	<cfinvokeargument name="fparams" value="Ocodigo, Oficodigo, Odescripcion"/><!--- CGE5COD,CGE5DES--->

	<cfinvokeargument name="navegacion" value="#navegacion#"/>

	<cfinvokeargument name="Conexion" value="#url.conexion#"/>

</cfinvoke>

</body>

</html>
