<cfif isdefined("Url.Aplaca") and not isdefined("Form.Aplaca")>
	<cfparam name="Form.Aplaca" default="#Url.Aplaca#">
</cfif>

<cfif isdefined("Url.Adescripcion") and not isdefined("Form.Adescripcion")>
	<cfparam name="Form.Adescripcion" default="#Url.Adescripcion#">
</cfif>
<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>

<cfif isdefined("Url.desc2") and not isdefined("Form.desc2")>
	<cfparam name="Form.desc2" default="#Url.desc2#">
</cfif>

<cfif isdefined("Url.name") and not isdefined("Form.name")>
	<cfparam name="Form.name" default="#Url.name#">
</cfif>

<cfif isdefined("Url.name2") and not isdefined("Form.name2")>
	<cfparam name="Form.name2" default="#Url.name2#">
</cfif>

<cfoutput>
	<cfset navegacion = "&desc=#Form.desc#&name=#Form.name#">
	<cfif isdefined("Url.desc2")>
		<cfset navegacion = navegacion & "&desc2=" & Form.desc2>
	</cfif>
	<cfif isdefined("Url.name2")>
		<cfset navegacion = navegacion & "&name2=" & Form.name2>
	</cfif>
</cfoutput>
<html>
<head>
<title>Lista de Placas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>

<style type="text/css">
<!--- estos estilos se usan para reducir el tamaño del HTML del arbol --->
.ar1 {background-color:#D4DBF2;cursor:pointer;}
.ar2 {background-color:#ffffff;cursor:pointer;}
</style>


<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(codigo, desc) {
	if (window.opener != null) {
		<cfoutput>
			window.opener.document.form1.#form.name#.value = trim(codigo);
			window.opener.document.form1.#form.desc#.value = desc;
			<cfif isdefined("Url.name2") and Len(Trim(Url.name2)) NEQ 0>
				window.opener.document.form1.#Url.name2#.value = trim(codigo);
			</cfif>		
			<cfif isdefined("Url.desc2") and Len(Trim(Url.desc2)) NEQ 0>
				window.opener.document.form1.#Url.desc2#.value = desc;
			</cfif>	
			if(window.opener.document.form1.errorFlag)
				window.opener.document.form1.errorFlag.value="1";						
		</cfoutput>
		window.close();
	}
}
</script>
</head>
<body>
<cfoutput>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
<tr>
<td valign="top">

	<form name="filtroPlaca" method="post" action="ConlisPlaca.cfm">
	<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
		<tr>
			<td align="right"><strong>Placa</strong></td>
			<td> 
				<input name="Aplaca" type="text" id="name" size="20" maxlength="20" value="<cfif isdefined("Form.Aplaca")>#Form.Aplaca#</cfif>">
			</td>
			<td align="right"><strong>Descripci&oacute;n</strong></td>
			<td> 
				<input name="Adescripcion" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.Adescripcion")>#Form.Adescripcion#</cfif>">
			</td>
			<td align="center">
				<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
				<cfif isdefined("form.formulario") and len(trim(form.formulario))>
					<input type="hidden" name="formulario" value="#form.formulario#">
				</cfif>
				<cfif isdefined("form.name") and len(trim(form.name))>
					<input type="hidden" name="name" value="#form.name#">
				</cfif>
				<cfif isdefined("form.desc") and len(trim(form.desc))>
					<input type="hidden" name="desc" value="#form.desc#">
				</cfif>				
			</td>			
		</tr>
	</table>
	</form>
	<cfquery name="rsLista"  datasource="#session.DSN#">
		select A.Aplaca as Aplaca,A.Adescripcion as Adescripcion
		from Activos A 
				inner join AFResponsables B 
				  on  B.Aid = A.Aid
				  and B.Ecodigo = A.Ecodigo
		where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and B.AFRfini <= getdate()
		and B.AFRffin >= getdate()
		<cfif isdefined("Form.Aplaca") and Len(Trim(Form.Aplaca)) NEQ 0>
			and upper(A.Aplaca) like '%#UCase(Form.Aplaca)#%'
		</cfif>
		<cfif isdefined("Form.Adescripcion") and Len(Trim(Form.Adescripcion)) NEQ 0>
			and upper(A.Adescripcion) like '%#UCase(Form.Adescripcion)#%'
		</cfif>		  
		union
		select distinct CRDRplaca as Aplaca,A.CRDRdescripcion as Adescripcion 
		from CRDocumentoResponsabilidad A
		where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		AND CRDRplaca is not null
		<cfif isdefined("Form.Aplaca") and Len(Trim(Form.Aplaca)) NEQ 0>
			and upper(A.CRDRplaca) like '%#UCase(Form.Aplaca)#%'
		</cfif>
		<cfif isdefined("Form.Adescripcion") and Len(Trim(Form.Adescripcion)) NEQ 0>
			and upper(A.CRDRdescripcion) like '%#UCase(Form.Adescripcion)#%'
		</cfif>		  
		order by 1
	</cfquery>	

	<cfif isdefined("Form.Aplaca") and Len(Trim(Form.Aplaca)) NEQ 0>
		<cfset navegacion = navegacion & "&Aplaca=" & Form.Aplaca>
	</cfif>
	<cfif isdefined("Form.Adescripcion") and Len(Trim(Form.Adescripcion)) NEQ 0>
		<cfset navegacion = navegacion & "&Adescripcion=" & Form.Adescripcion>
	</cfif>
	<cfinvoke 
	 component="rh.Componentes.pListas"
	 method="pListaQuery"
	 returnvariable="pListaRet">
		<cfinvokeargument name="query" value="#rsLista#"/>
		<cfinvokeargument name="desplegar" value="Aplaca, Adescripcion"/>
		<cfinvokeargument name="etiquetas" value="Placa, Descripción"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="align" value="left, left"/>
		<cfinvokeargument name="ajustar" value=""/>
		<cfinvokeargument name="irA" value="ConlisPlaca.cfm"/>
		<cfinvokeargument name="formName" value="listaPlaca"/>
		<cfinvokeargument name="MaxRows" value="15"/>
		<cfinvokeargument name="funcion" value="Asignar"/>
		<cfinvokeargument name="fparams" value="Aplaca, Adescripcion"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
		<cfinvokeargument name="debug" value="N"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
	</cfinvoke>
</td></tr>
</table>
	
	</cfoutput>
</body>
</html>