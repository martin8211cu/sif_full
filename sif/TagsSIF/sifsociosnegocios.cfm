<!---
<cfquery name="def" datasource="asp">
	select -1 as SNcodigo
</cfquery>
--->

<cfset def = QueryNew("SNcodigo")>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.SNcodigo" default="SNcodigo" type="string"> <!--- Nombres del código del socio --->
<cfparam name="Attributes.SNnombre" default="SNnombre" type="string"> <!--- Nombres de la descripción del socio --->
<cfparam name="Attributes.SNidentificacion" default="SNidentificacion" type="string"> <!--- Nombres de la identificación del socio Ej: 9-089-679 --->
<cfparam name="Attributes.SNtiposocio" default="" type="string"> <!--- Si es proveedor (no clientes) ó si es cliente (no proveedor) --->
<cfparam name="Attributes.frame" default="frsocios" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.FuncJSalAbrir" default="" type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar" default="" type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" default="" type="string"> <!--- Tamaño del objeto de Descripción --->

<!--- consultas --->
<cfquery name="rsSocios" datasource="#Attributes.Conexion#">
	select SNcodigo, SNidentificacion, SNtiposocio, SNnombre, SNFecha, SNtipo, SNvencompras, SNvenventas, SNinactivo, ts_rversion 
	from SNegocios 
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	  and SNinactivo = 0
	<cfif Attributes.SNtiposocio EQ "P">
	  and SNtiposocio != 'C'
	<cfelseif Attributes.SNtiposocio EQ "C">
	  and SNtiposocio != 'P'
	</cfif>	  
</cfquery>
<cfset longitud = len(Trim(rsSocios.SNidentificacion))>

<cfif Attributes.SNtiposocio EQ "P">
	<cfset socios = "Proveedores">
<cfelseif Attributes.SNtiposocio EQ "C">
	<cfset socios = "Clientes">
<cfelse>
	<cfset socios = "Socios">
</cfif>


<script language="JavaScript">
var popUpWin<cfoutput>#Attributes.SNcodigo#</cfoutput>=0;
function popUpWindow<cfoutput>#Attributes.SNcodigo#</cfoutput>(URLStr, left, top, width, height)
{
  if(popUpWin<cfoutput>#Attributes.SNcodigo#</cfoutput>)
  {
	if(!popUpWin<cfoutput>#Attributes.SNcodigo#</cfoutput>.closed) popUpWin.close();
  }
  popUpWin<cfoutput>#Attributes.SNcodigo#</cfoutput> = open(URLStr, 'popUpWin<cfoutput>#Attributes.SNcodigo#</cfoutput>', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
}

function doConlis<cfoutput>#Attributes.SNcodigo#</cfoutput>() {
	<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
	var params ="";
	params = "<cfoutput>?form=#Attributes.form#&id=#Attributes.SNcodigo#&desc=#Attributes.SNnombre#&identificacion=#Attributes.SNidentificacion#&tipo=#Attributes.SNtiposocio#</cfoutput>";
	<cfif Len(Trim(Attributes.FuncJSalCerrar))>
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	
	popUpWindow<cfoutput>#Attributes.SNcodigo#</cfoutput>("/cfmx/sif/Utiles/ConlisSociosNegocios.cfm"+params,250,200,650,350);
}


function TraeSocio<cfoutput>#Attributes.SNcodigo#</cfoutput>(dato) {
	var params ="";
	params = "<cfoutput>&id=#Attributes.SNcodigo#&desc=#Attributes.SNnombre#&identificacion=#Attributes.SNnombre#</cfoutput>";
	<cfif Len(Trim(Attributes.FuncJSalCerrar))>
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	

	if (dato!="") {
		document.all["<cfoutput>#Attributes.frame#</cfoutput>"].src="/cfmx/sif/Utiles/sifsociosnegociosquery.cfm?SNidentificacion="+dato+"&form="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
	}
	else {
		<cfoutput>
			document.#Attributes.form#.#Attributes.SNcodigo#.value="";
			document.#Attributes.form#.#Attributes.SNnombre#.value="";
			document.#Attributes.form#.#Attributes.SNidentificacion#.value="";
			<cfif Len(Trim(Attributes.FuncJSalCerrar))>
				#Attributes.FuncJSalCerrar#
			</cfif>
		</cfoutput>
	}
	
	return;
}
</script>

  <table width="" border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
	<td nowrap>			
		<input type="text" name="#Attributes.SNidentificacion#" id="#Attributes.SNidentificacion#" maxlength="30" size="15" onblur="javascript:TraeSocio#Attributes.SNcodigo#(document.#Attributes.form#.#Evaluate('Attributes.SNidentificacion')#.value);" onfocus="this.select()"	tabindex="#Attributes.tabindex#"
		value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.SNidentificacion)#</cfif>">
	</td>
	
	<td nowrap>
		<input tabindex="-1" type="text" name="#Attributes.SNnombre#" id="#Attributes.SNnombre#" maxlength="255" size="#Attributes.size#" disabled 
		value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.SNnombre)#</cfif>">
			<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de #socios#" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlis#Attributes.SNcodigo#();'></a>		
	</td>		
	<input type="hidden" name="#Attributes.SNcodigo#" id="#Attributes.SNcodigo#" value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.SNcodigo)#</cfif>">
	</cfoutput>
	
  </table>
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="/cfmx/sif/Utiles/sifsociosnegociosquery.cfm" ></iframe>