<cfif isdefined("Url.empresa") and Len(Trim(Url.empresa))>
	<cfparam name="Form.empresa" default="#Url.empresa#">
</cfif>
<cfif isdefined("Form.empresa") and Len(Trim(Form.empresa))>
	<cfset LvarEmpresa = Form.empresa>
<cfelse>
	<cfset LvarEmpresa = Session.Ecodigo>
</cfif>
<cfif isdefined("Url.negociado") and Len(Trim(Url.negociado))>
	<cfparam name="Form.negociado" default="#Url.negociado#">
</cfif>
<cfif isdefined("Form.negociado") and Len(Trim(Form.negociado))>
	<cfset LvarNegociado = Form.negociado>
<cfelse>
	<cfset LvarNegociado = 0>
</cfif>
<cfif isdefined("Url.id") and Len(Trim(Url.id))>
	<cfparam name="Form.id" default="#Url.id#">
</cfif>
<cfif isdefined("Url.sql") and Len(Trim(Url.sql))>
	<cfparam name="Form.sql" default="#Url.sql#">
</cfif>

<cfparam name="Url.recargo" default="false">
<cfif isdefined("Url.recargo") and Len(Trim(Url.recargo))>
	<cfparam name="Form.recargo" default="#Url.recargo#">
</cfif>

<html>
<head>
<title>Lista de Componentes Salariales</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>

<cfif isdefined("Form.id") and isdefined("Form.sql")>

	<cfinclude template="ConlisCompSalarial-sql#Form.sql#.cfm">
	<cfinclude template="ConlisCompSalarial-lista#Form.sql#.cfm">

	<table width="100%" border="0" cellspacing="0" cellpadding="2">
	  <tr>
		<td class="tituloAlterno">Seleccione el Componente Salarial que desea Agregar</td>
	  </tr>
	</table>
	<br>

	<cfinvoke 
	 component="rh.Componentes.pListas"
	 method="pListaQuery"
	 returnvariable="pListaRet">
		<cfinvokeargument name="query" value="#rsComponentes#"/>
		<cfinvokeargument name="desplegar" value="CSdescripcion, Comportamiento"/>
		<cfinvokeargument name="etiquetas" value="Componente Salarial, M&eacute;todo de C&aacute;lculo"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="align" value="left, left"/>
		<cfinvokeargument name="ajustar" value=""/>
		<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
		<cfinvokeargument name="formName" value="listaComponentes"/>
		<cfinvokeargument name="MaxRows" value="15"/>
		<cfinvokeargument name="debug" value="N"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="EmptyListMsg" value="No quedan ning&uacute;n componente salarial por agregar"/>
		<cfif rsComponentes.recordCount EQ 0>
			<cfinvokeargument name="botones" value="Cerrar"/>
		</cfif>
	</cfinvoke>

	<cfif rsComponentes.recordCount EQ 0>
		<script language="javascript" type="text/javascript">
			function funcCerrar() {
				window.close();
				return false;
			}
		</script>
	</cfif>

</cfif>

</body>
</html>
