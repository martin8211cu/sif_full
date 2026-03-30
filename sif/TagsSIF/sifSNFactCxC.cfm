<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 24 de febrero del 2006
	Motivo: Agregar atributo de display en none al iframe del tag
	 		Se corrigió navegacion de tab.
 		   	Se agregó la funcion conlis_keyup, para q funcionara el F2.	
			
	Modificado por: Ana Villavicencio
	Fecha: 10 de octubre del 2005
	Motivo:  Cambiar el tamaño del popup y ka posicion en la pantalla
	
	Modificado por: Ana Villavicencio R.
	Fecha: 12 de julio del 2005
	Motivo: No funcionaba cuando se digitaba la identificación del socios de negocios.  
			No hacia la actualización de los diferentes campos relacionados con el socio
			de negocios
 --->

<cfset def = QueryNew("SNcodigo")>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.id" default="SNcodigo" type="string"> <!--- Código del socio --->
<cfparam name="Attributes.SNnombre" default="SNnombre" type="string"> <!--- Nombres de la descripción del socio --->
<cfparam name="Attributes.SNidentificacion" default="SNidentificacion" type="string"> <!--- Nombres de la identificación del socio Ej: 9-089-679 --->
<cfparam name="Attributes.SNnumero" default="SNnumero" type="string"> <!--- Codigo del Socio de Negocios --->
<cfparam name="Attributes.SNtiposocio" default="" type="string"> <!--- Si es proveedor (no clientes) ó si es cliente (no proveedor) --->
<cfparam name="Attributes.frame" default="frsocios" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.FuncJSalAbrir" default="" type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar" default="" type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- Tabindex del campo editable --->

<!--- consultas --->
<cfquery name="rsSocios" datasource="#Attributes.Conexion#">
	select SNcodigo, SNidentificacion, SNtiposocio, SNnombre, SNnumero, SNFecha, SNtipo, SNvencompras, SNvenventas, SNinactivo, a.ts_rversion 
	from SNegocios a, EstadoSNegocios b
	where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	  and a.SNinactivo = 0
	  and a.ESNid = b.ESNid
	  and b.ESNfacturacion = 1
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
var popUpWin=0;
function popUpWindow(URLStr, left, top, width, height){
  if(popUpWin){
	if(!popUpWin.closed) popUpWin.close();
  }
  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
  window.onfocus = closePopUp<cfoutput>#Attributes.id#</cfoutput>;
}

function closePopUp<cfoutput>#Attributes.id#</cfoutput>(){
	if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
		popUpWin=null;
  	}
}

//funcion para habilitar el F2
	function conlis_keyup_<cfoutput>#Attributes.id#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlis<cfoutput>#Attributes.id#</cfoutput>();
		}
	}
	
function doConlis<cfoutput>#Attributes.id#</cfoutput>() {
	<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
	var params ="";
	params = "<cfoutput>?form=#Attributes.form#&id=#Attributes.id#&desc=#Attributes.SNnombre#&identificacion=#Attributes.SNidentificacion#&numero=#Attributes.SNnumero#&tipo=#Attributes.SNtiposocio#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	
	popUpWindow("/cfmx/sif/Utiles/ConlisSNFactCxC.cfm"+params,200,200,700,325);
}


function TraeSocio<cfoutput>#Attributes.id#</cfoutput>(dato) {
			var params ="";
			params = "<cfoutput>&id=#Attributes.id#&desc=#Attributes.SNnombre#&identificacion=#Attributes.SNidentificacion#&numero=#Attributes.SNnumero#&tipo=#Attributes.SNtiposocio#</cfoutput>";
			<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
				params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
			</cfif>	
		
			if (dato!="") {
				var frm = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
				frm.src="/cfmx/sif/Utiles/sifSNFactCxCquery.cfm?SNnumero="+dato+"&form="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
			}
			else{
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.id#</cfoutput>.value = '';
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.SNidentificacion#</cfoutput>.value = '';
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.SNnumero#</cfoutput>.value = '';
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.SNnombre#</cfoutput>.value = '';
			}
			
			return;
}
</script>

  <table width="" border="0" cellspacing="0" cellpadding="0">
    <cfoutput>
    <td nowrap>
        <input 
			type="text" 
			name="#Attributes.SNnumero#" id="#Attributes.SNnumero#" maxlength="30" size="15" 
			onBlur="javascript:TraeSocio#Attributes.id#(document.#Attributes.form#.#Evaluate('Attributes.SNnumero')#.value);" 
			onFocus="this.select()"	tabindex="#Attributes.tabindex#"
			onkeyup="javascript:conlis_keyup_#Attributes.id#(event);"
		value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.SNnumero)#</cfif>">
      </td>
        <td nowrap>
          <input tabindex="-1" type="text" name="#Attributes.SNnombre#" id="#Attributes.SNnombre#" maxlength="255" size="30" disabled 
		value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.SNnombre)#</cfif>">
          <a href="##" tabindex="-1"> <img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de #socios#" 
					name="imagen" width="18" height="14" border="0" align="absmiddle" 
					onClick='javascript:doConlis#Attributes.id#();'> </a> </td>
        <input type="hidden" name="#Attributes.id#" id="#Attributes.id#" value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.SNcodigo)#</cfif>">
        <input type="hidden" name="#Attributes.SNidentificacion#" id="#Attributes.SNidentificacion#" value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.SNidentificacion)#</cfif>">
    </cfoutput>
  </table>
  <iframe id="<cfoutput>#Attributes.frame#</cfoutput>" 
		name="<cfoutput>#Attributes.frame#</cfoutput>" 
		marginheight="0" marginwidth="0" frameborder="0" 
		height="0" width="0" scrolling="auto"
		style=" display:none" ></iframe>