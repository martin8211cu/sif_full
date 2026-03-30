<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 10 de octubre del 2005
	Motivo: Cambiar la lista q muestra el conlis, agregar un campo para mostrar en la lista. 
			Se agregó el campo SNnumero. Se cambio la forma de crear la lista, 
			ahora se utiliza el componente plistas.cfc.
 --->
<cfset navegacion = ''>
<cfif isdefined('url.tipo') and not isdefined('form.tipo')>
	<cfset form.tipo = url.tipo>
</cfif>
<cfif isdefined('url.form') and not isdefined('form.form1')>
	<cfset form.form1 = url.form>
</cfif>
<cfif isdefined('url.id') and not isdefined('form.id')>
	<cfset form.id = url.id>
</cfif>
<cfif isdefined('url.desc') and not isdefined('form.desc')>
	<cfset form.desc = url.desc>
</cfif>
<cfif isdefined('url.identificacion') and not isdefined('form.identificacion')>
	<cfset form.identificacion = url.identificacion>
</cfif>
<cfif isdefined('url.numero') and not isdefined('form.numero')>
	<cfset form.numero = url.numero>
</cfif>

<cfif isdefined('url.Filtro_SNidentificacion') and not isdefined('form.Filtro_SNidentificacion')>
	<cfset form.Filtro_SNidentificacion = url.Filtro_SNidentificacion>
</cfif>
<cfif isdefined('url.Filtro_SNnumero') and not isdefined('form.Filtro_SNnumero')>
	<cfset form.Filtro_SNnumero = url.Filtro_SNnumero>
</cfif>

<cfif isdefined('url.Filtro_SNnombre') and not isdefined('form.Filtro_SNnombres')>
	<cfset form.Filtro_SNnombre = url.Filtro_SNnombre>
</cfif>

<cfif isdefined('form.tipo') and LEN(TRIM(form.tipo))>
	<cfset navegacion = navegacion & "&tipo=" & Form.tipo>
</cfif>
<cfif isdefined('form.form1') and LEN(TRIM(form.form1))>
	<cfset navegacion = navegacion & "&form=" & Form.form1>
</cfif>
<cfif isdefined('form.id') and LEN(TRIM(form.id))>
	<cfset navegacion = navegacion & "&id=" & Form.id>
</cfif>
<cfif isdefined('form.desc') and LEN(TRIM(form.desc))>
	<cfset navegacion = navegacion & "&desc=" & Form.desc>
</cfif>
<cfif isdefined('form.identificacion') and LEN(TRIM(form.identificacion))>
	<cfset navegacion = navegacion & "&identificacion=" & Form.identificacion>
</cfif>
<cfif isdefined('form.numero') and LEN(TRIM(form.numero))>
	<cfset navegacion = navegacion & "&numero=" & Form.numero>
</cfif>

<!--- <cfdump var="#url#">
<cfdump var="#form#">
 --->
<html>
<head>
<title>Lista de <cfoutput><cfif form.tipo EQ "P">Proveedores<cfelseif form.tipo EQ "C">Clientes<cfelse>Socios de Negocio</cfif></cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<cf_templatecss>
</head>

<cfquery name="conlis" datasource="#Session.DSN#">	
	select SNcodigo, SNnombre, SNidentificacion, SNnumero
	from SNegocios a 
	inner join EstadoSNegocios b
	   on a.ESNid = b.ESNid
	  and b.ESNfacturacion = 1
	  <cfif isdefined("form.tipo") and (Len(Trim(form.tipo)) GT 0)>
		<cfif form.tipo EQ "P">
		  and SNtiposocio != 'C'
		<cfelseif form.tipo EQ "C">
		  and SNtiposocio != 'P'
		</cfif>	  
	</cfif>
	  and a.SNinactivo = 0
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	<cfif isdefined("form.Filtro_SNidentificacion") and LEN(TRIM(form.Filtro_SNidentificacion))>
  	  and upper(ltrim(rtrim(SNidentificacion))) like '%#Ucase(trim(form.Filtro_SNidentificacion))#%'
	</cfif>
	<cfif isdefined("form.Filtro_SNnumero") and LEN(TRIM(form.Filtro_SNnumero))>
  	  and upper(ltrim(rtrim(SNnumero))) like '%#Ucase(trim(form.Filtro_SNnumero))#%'
	</cfif>
	<cfif isdefined("form.Filtro_SNnombre") and LEN(TRIM(form.Filtro_SNnombre))>
	  and upper(SNnombre) like '%#Ucase(form.Filtro_SNnombre)#%'
	</cfif>	  
	order by SNnumero, SNnombre, SNidentificacion 
</cfquery>

<cfif form.tipo EQ "P">
	<cfset socio = "Proveedor">
<cfelseif form.tipo EQ "C">
	<cfset socio = "Cliente">
<cfelse>
	<cfset socio = "Socio">
</cfif>
<cfif isdefined('form.Filtro_SNidentificacion') and LEN(TRIM(form.Filtro_SNidentificacion))>
	<cfset navegacion = navegacion & "&Filtro_SNidentificacion=" & Form.Filtro_SNidentificacion>
</cfif>
<cfif isdefined('form.Filtro_SNnumero') and LEN(TRIM(form.Filtro_SNnumero))>
	<cfset navegacion = navegacion & "&Filtro_SNnumero=" & Form.Filtro_SNnumero>
</cfif>
<cfif isdefined('form.Filtro_SNnombre') and LEN(TRIM(form.Filtro_SNnombre))>
	<cfset navegacion = navegacion & "&Filtro_SNnombre=" & Form.Filtro_SNnombre>
</cfif>

<script language="JavaScript1.2">
function Asignar(valor1, valor2, valor3, valor4) {
	window.opener.document.<cfoutput>#form.form1#.#form.id#</cfoutput>.value=valor1;
	window.opener.document.<cfoutput>#form.form1#.#form.desc#</cfoutput>.value=valor2;
	window.opener.document.<cfoutput>#form.form1#.#form.identificacion#</cfoutput>.value=valor3;
	window.opener.document.<cfoutput>#form.form1#.#form.numero#</cfoutput>.value=valor4;
	if (window.opener.funcSNcodigo) {window.opener.funcSNcodigo()}
	window.close();
	<!--- <cfif Len(Trim(url.FuncJSalCerrar)) GT 0><cfoutput>window.opener.#url.FuncJSalCerrar#;</cfoutput></cfif> --->
}

</script>

<body>
<form action="ConlisSNFactCxC.cfm" method="post" name="conlis">
	<input name="tipo" type="hidden" value="<cfif isdefined('form.tipo')><cfoutput>#form.tipo#</cfoutput></cfif>">
	<input name="form1" type="hidden" value="<cfif isdefined('form.form1')><cfoutput>#form.form1#</cfoutput></cfif>">
	<input name="id" type="hidden" value="<cfif isdefined('form.id')><cfoutput>#form.id#</cfoutput></cfif>">
	<input name="identificacion" type="hidden" value="<cfif isdefined('form.identificacion')><cfoutput>#form.identificacion#</cfoutput></cfif>">
	<input name="desc" type="hidden" value="<cfif isdefined('form.desc')><cfoutput>#form.desc#</cfoutput></cfif>">
	<input name="numero" type="hidden" value="<cfif isdefined('form.numero')><cfoutput>#form.numero#</cfoutput></cfif>">
	<table width="95%" border="0" cellspacing="0" align="center">
		<tr> 
			<td align="center">
				<cfinvoke
					component="rh.Componentes.pListas"
					method="pListaQuery"
					returnvariable="rsLista"
					query="#conlis#"
					desplegar="SNnumero,SNidentificacion,SNnombre"
					etiquetas="Código, Identificación, Nombre"
					formatos="S,S,S"
					align="left,left,left"
					ajustar="N"
					irA="ConlisSNFactCxC.cfm"
					keys="SNnumero"
					mostrar_filtro="true"
					maxrows ="12"
					funcion="Asignar"
					fparams="SNcodigo,SNnombre,SNidentificacion,SNnumero"
					navegacion = "#navegacion#"
					showEmptyListMsg="true">
			</td>
		</tr>
	</table>
</form>
</body>
</html>

