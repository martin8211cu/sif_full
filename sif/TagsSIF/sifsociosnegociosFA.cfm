<!---  
	Modificado por: Ana Villavicencio
	Fecha: 02 de marzo del 2006
	Motivo: Agregar atributo de display en none al iframe del tag
	 		Se corrigió navegacion de tab.
 		   	Se agregó la funcion conlis_keyup, para q funcionara el F2.	
--->


<cfset def = QueryNew("SNcodigo")>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.SNcodigo" default="SNcodigo" type="string"> <!--- Nombres del código del socio --->
<cfparam name="Attributes.SNnombre" default="SNnombre" type="string"> <!--- Nombres de la descripción del socio --->
<cfparam name="Attributes.SNnumero" default="SNnumero" type="string"> <!--- Nombres de la identificación del socio Ej: 9-089-679 --->
<cfparam name="Attributes.SNtiposocio" default="" type="string"> <!--- Si es proveedor (no clientes) ó si es cliente (no proveedor) --->
<cfparam name="Attributes.frame" default="frsocios" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.FuncJSalAbrir" default="" type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar" default="" type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.readonly" default="false" type="boolean">

<!--- consultas --->
<cfquery name="rsSocios" datasource="#Attributes.Conexion#">
	select SNcodigo, SNnumero, SNtiposocio, SNnombre, SNFecha, SNtipo, SNvencompras, SNvenventas, SNinactivo, ts_rversion 
	from SNegocios 
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	  and SNinactivo = 0
	<cfif Attributes.SNtiposocio EQ "P">
	  and SNtiposocio != 'C'
	<cfelseif Attributes.SNtiposocio EQ "C">
	  and SNtiposocio != 'P'
	</cfif>	  
</cfquery>
<cfset longitud = len(Trim(rsSocios.SNnumero))>

<cfif Attributes.SNtiposocio EQ "P">
	<cfset socios = "Proveedores">
<cfelseif Attributes.SNtiposocio EQ "C">
	<cfset socios = "Clientes">
<cfelse>
	<cfset socios = "Socios">
</cfif>


<script language="JavaScript">
var popUpWin=0;
function popUpWindow(URLStr, left, top, width, height)
{
  if(popUpWin)
  {
	if(!popUpWin.closed) popUpWin.close();
  }
  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
}

//funcion para habilitar el F2
	function conlis_keyup_<cfoutput>#Attributes.SNcodigo#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlis<cfoutput>#Attributes.SNcodigo#</cfoutput>();
		}
	}

function doConlis<cfoutput>#Attributes.SNcodigo#</cfoutput>() {
	<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
	var params ="";
	params = "<cfoutput>?form=#Attributes.form#&id=#Attributes.SNcodigo#&desc=#Attributes.SNnombre#&identificacion=#Attributes.SNnumero#&tipo=#Attributes.SNtiposocio#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	
	popUpWindow("/cfmx/sif/Utiles/ConlisSociosNegociosFA.cfm"+params,250,200,650,350);
}

function TraeSocio<cfoutput>#Attributes.SNcodigo#</cfoutput>(dato) {
	var params ="";
	params = "<cfoutput>&id=#Attributes.SNcodigo#&desc=#Attributes.SNnombre#&identificacion=#Attributes.SNnumero#&SNtiposocio=#Attributes.SNtiposocio#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	

	var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
	fr.src="/cfmx/sif/Utiles/sifsociosnegociosFAquery.cfm?SNnumero="+dato+"&form="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
	
	return;
}
</script>

  <table width="" border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
	<td nowrap>
		<input type="text" name="#Attributes.SNnumero#" id="#Attributes.SNnumero#" maxlength="10" size="11" 
		onblur="javascript:TraeSocio#Attributes.SNcodigo#(document.#Attributes.form#.#Evaluate('Attributes.SNnumero')#.value);" 
		onfocus="this.select()"				
		onkeyup="javascript:conlis_keyup_#Attributes.SNcodigo#(event);"
		<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
		value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.SNnumero)#</cfif>" <cfif Attributes.readonly>readonly="true" </cfif> />
	</td>
	
	<td nowrap>
		<input type="text" name="#Attributes.SNnombre#" id="#Attributes.SNnombre#" maxlength="255" size="30" disabled tabindex="-1"
		value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.SNnombre)#</cfif>">
			<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de #socios#" name="imagen" width="18" height="14" border="0" align="absmiddle" onclick='javascript:doConlis#Attributes.SNcodigo#();'></a>	</td>		
	<input type="hidden" name="#Attributes.SNcodigo#" id="#Attributes.SNcodigo#" value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.SNcodigo)#</cfif>">			
	</cfoutput>
  </table>
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" id="<cfoutput>#Attributes.frame#</cfoutput>" 
	marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" 
	style=" display:none"></iframe>