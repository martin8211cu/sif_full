<!---
	Modificado por: Ana Villavicencio
	Fecha: 27 de febrero del 2006
	Motivo: Agregar atributo de display en none al iframe del tag
	 		Se corrigió navegacion de tab.
 		   	Se agregó la funcion conlis_keyup, para q funcionara el F2.
--->

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"			type="String">  <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 				type="String">  <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 			default="" 						type="string">  <!--- consulta por defecto --->
<cfparam name="Attributes.SNcodigo" 		default="SNcodigo" 				type="string">  <!--- Nombres del código del socio --->
<cfparam name="Attributes.SNnombre" 		default="SNnombre" 				type="string">  <!--- Nombres de la descripción del socio --->
<cfparam name="Attributes.SNnumero" 		default="SNnumero"				type="string">
<cfparam name="Attributes.IdRegimenFiscal" 	default="IdRegimenFiscal"		type="string">  <!--- Nombres de la identificación del socio Ej: 9-089-679 --->
<cfparam name="Attributes.SNtiposocio" 		default="" 						type="string">  <!--- Si es proveedor (no clientes) ó si es cliente (no proveedor) --->
<cfparam name="Attributes.frame" 			default="frsocios" 				type="string">  <!--- Nombre del frame --->
<cfparam name="Attributes.FuncJSalAbrir" 	default="" 						type="string">  <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" 						type="string">  <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalModificar" default="" 					type="string">  <!--- función .js al cambiar el valor del conlis --->
<cfparam name="Attributes.tabindex" 		default="1" 					type="string">  <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="30" 					type="string">  <!--- Tabindex del campo editable --->
<cfparam name="Attributes.conlis" 			default="true" 					type="boolean"> <!--- Bandera para pintar o no la imagencilla que abre el conlis y permitir editar el codigo --->
<cfparam name="Attributes.SNid" 		    default="" 						type="string">
<cfparam name="Attributes.modificable" 		default="true" 					type="boolean"> <!--- Parámetros para impedir la modificación del dato --->
<cfparam name="Attributes.relacionadoId" 	default="-1" 					type="numeric"> <!--- SNid --->
<cfparam name="Attributes.Ecodigo" 			default="#Session.Ecodigo#" 	type="numeric"> <!--- SNid --->
<cfparam name="Attributes.SoloCorportativo" default="false" 				type="boolean">
<cfparam name="Attributes.ClientesAmbos"    default="NO" 				    type="string">
<cfparam name="Attributes.Proveedores"      default="NO" 				    type="string">
<cfparam name="Attributes.CargaCtaOrigen"   default="NO" 				    type="string">

<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery))>
	<cfset queryName = "rsSocio_#trim(Attributes.SNnombre)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select SNcodigo, SNnumero, SNnombre, SNid, IdRegimenFiscal
		from SNegocios
		where Ecodigo = <cfqueryparam value="#Attributes.Ecodigo#" cfsqltype="cf_sql_integer">
		  and SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.idquery#">
	      and SNinactivo = 0
		<cfif isdefined("Attributes.SNtiposocio") and len(trim(Attributes.SNtiposocio))>
			<cfif Attributes.SNtiposocio neq 'A'>
				and SNtiposocio in ('A', '#Attributes.SNtiposocio#')
			<cfelse>
				and SNtiposocio = 'A'
			</cfif>
		</cfif>
		<cfif Attributes.SoloCorportativo>
			and SNesCorporativo = 1
		</cfif>
	</cfquery>
</cfif>

<!--- query --->
<cfset socios = "Socios de Negocios">
<cfif Attributes.SNtiposocio eq "P">
	<cfset socios = "Proveedores">
<cfelseif Attributes.SNtiposocio eq "C">
	<cfset socios = "Clientes">
</cfif>

<script language="JavaScript">
var popUpWinSN=0;
function popUpWindow<cfoutput>#Attributes.SNcodigo#</cfoutput>(URLStr, left, top, width, height){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
  	}
  	popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp<cfoutput>#Attributes.SNcodigo#</cfoutput>;
}
function closePopUp<cfoutput>#Attributes.SNcodigo#</cfoutput>(){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
		popUpWinSN=null;
  	}
}

//funcion para habilitar el F2
	function conlis_keyup_<cfoutput>#Attributes.SNcodigo#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisSocio<cfoutput>#Attributes.SNcodigo#</cfoutput>();
		}
	}

function doConlisSocio<cfoutput>#Attributes.SNcodigo#</cfoutput>() {
	<cfif Attributes.modificable>
			<cfif len(trim(Attributes.FuncJSalAbrir))>
				<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
			</cfif>
			var params ="";
			params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.SNcodigo#&codigo=#Attributes.SNnumero#&desc=#Attributes.SNnombre#&tipo=#Attributes.SNtiposocio#&Ecodigo=#Attributes.Ecodigo#&SoloCorportativo=#Attributes.SoloCorportativo#</cfoutput>";

			<cfif len(trim("#Attributes.SNid#"))>
				params = params + "<cfoutput>&SNid=#Attributes.SNid#</cfoutput>";
			</cfif>
			<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0>
				params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
			</cfif>
			<cfif Attributes.relacionadoId NEQ -1>
				params = params + "<cfoutput>&SNidRel=#Attributes.relacionadoId#</cfoutput>";
			</cfif>
			<cfif Attributes.ClientesAmbos EQ 'SI'>
				params = params + "<cfoutput>&soloClientesAmbos=#Attributes.ClientesAmbos#</cfoutput>";
			</cfif>
			<cfif Attributes.Proveedores EQ 'SI'>
				params = params + "<cfoutput>&soloProveedores=#Attributes.Proveedores#</cfoutput>";
			</cfif>
			<cfif Attributes.CargaCtaOrigen EQ 'SI'>
				params = params + "<cfoutput>&CargaCtaOrigen=#Attributes.CargaCtaOrigen#</cfoutput>";
			</cfif>

			popUpWindow<cfoutput>#Attributes.SNcodigo#</cfoutput>("/cfmx/sif/Utiles/ConlisSociosNegocios2.cfm"+params,250,200,650,400);
	</cfif>
}

function TraeSocio<cfoutput>#Attributes.SNcodigo#</cfoutput>(codigo) {
	<cfif Attributes.modificable>
			var params ="";
			params = "<cfoutput>&id=#Attributes.SNcodigo#&desc=#Attributes.SNnombre#&numero=#Attributes.SNnumero#&tipo=#Attributes.SNtiposocio#&Ecodigo=#Attributes.Ecodigo#</cfoutput>";
			<cfif Len(Trim("#Attributes.SNid#")) GT 0>
				params = params + "<cfoutput>&SNid=#Attributes.SNid#</cfoutput>";
			</cfif>
			<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0>
				params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
			</cfif>

			if (codigo.length > 0 &&  (codigo!="" || codigo!=" ")) {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/sif/Utiles/sifsocionegociosquery2.cfm?codigo="+codigo+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
			}
			else{
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.SNcodigo#</cfoutput>.value = '';
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.SNnumero#</cfoutput>.value = '';
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.SNnombre#</cfoutput>.value = '';
				<cfif len(trim(Attributes.SNid))>document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.SNid#</cfoutput>.value = '';</cfif>
				<cfoutput>if (window.func#Attributes.SNnumero#) {window.func#Attributes.SNnumero#()}</cfoutput>
			}
			return;
	</cfif>
}
</script>

  <table width="1%" border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
	<tr>
		<td nowrap width="1%">
			<input
				type="text"
				name="#Attributes.SNnumero#"
				id="#Attributes.SNnumero#"
				placeholder="Numero"
				maxlength="15"
				size="10"
				<cfif not Attributes.modificable>
					disabled
				</cfif>
				onblur="javascript:TraeSocio#Attributes.SNcodigo#(document.#Attributes.form#.#Attributes.SNnumero#.value); #Attributes.FuncJSalModificar#;"
				onfocus="this.select(); #Attributes.FuncJSalModificar#;"
				<cfif isdefined("Attributes.conlis") and Attributes.conlis EQ false>
					readonly="true"
				</cfif>
				tabindex="#Attributes.tabindex#"
				onkeyup="javascript:conlis_keyup_#Attributes.SNcodigo#(event); #Attributes.FuncJSalModificar#;"
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).SNnumero)#</cfif>">
		</td>
		<td nowrap width="1%">
			<input tabindex="-1" placeholder="Socio de Negocios" type="text" name="#Attributes.SNnombre#" id="#Attributes.SNnombre#" maxlength="255" size="#Attributes.size#" disabled
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).SNnombre)#</cfif>">
			<!--Segundo Input Regimen Fiscal
			<input
				type="text"
				name="#Attributes.IdRegimenFiscal#"
				id="#Attributes.IdRegimenFiscal#"
				placeholder="Id Regimen Fiscal"
				maxlength="10"
				size="10"
				block:none
				<cfif not Attributes.modificable>
					disabled
				</cfif>
				onblur="javascript:TraeSocio#Attributes.IdRegimenFiscal#(document.#Attributes.form#.#Attributes.IdRegimenFiscal#.value); #Attributes.FuncJSalModificar#;"
				onfocus="this.select(); #Attributes.FuncJSalModificar#;"
				<cfif isdefined("Attributes.conlis") and Attributes.conlis EQ false>
					readonly="true"
				</cfif>
				tabindex="#Attributes.tabindex#"
				onkeyup="javascript:conlis_keyup_#Attributes.IdRegimenFiscal#(event); #Attributes.FuncJSalModificar#;"
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).IdRegimenFiscal)#</cfif>">

		</td>
		<!-- Fin Segundo Input Regimen Fiscal -->

		<td width="98%">
			<cfif isdefined("Attributes.conlis") and Attributes.conlis EQ true>
				<a  href="##" tabindex="-1">
					<img id="SNimagen" src="/cfmx/sif/imagenes/Description.gif" alt="Lista de #socios#" name="SNimagen"
					 width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisSocio#Attributes.SNcodigo#();'>
					 </a>
			</cfif>
		</td>
		<input type="hidden" name="#Attributes.SNcodigo#" id="#Attributes.SNcodigo#" value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).SNcodigo)#</cfif>">
       <cfif len(trim(Attributes.SNid))>
       		<input type="hidden" name="#Attributes.SNid#" id="#Attributes.SNid#" value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).SNid)#</cfif>">
       </cfif>
	</tr>
	</cfoutput>

  </table>
<iframe style="display:none; visibility:hidden" id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>"
	marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>