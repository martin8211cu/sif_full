<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"		type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 			type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 			default="" 					type="string">  <!--- consulta por defecto --->
<cfparam name="Attributes.RHEDVid" 			default="RHEDVid" 			type="string"> <!--- ID del dato variable --->
<cfparam name="Attributes.RHEDVcodigo" 		default="RHEDVcodigo" 		type="string"> <!--- Código del dato variable  --->
<cfparam name="Attributes.RHEDVdescripcion" default="RHEDVdescripcion" 	type="string"> <!--- Descripcion dato variable--->
<cfparam name="Attributes.frame" 			default="frdatos" 			type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.FuncJSalAbrir" 	default="" 					type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" 					type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" 		default="" 					type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="50" 				type="string"> <!--- Tabindex del campo editable --->

<!--- consultas --->
<!--- query --->
<cf_translatedata name="get" tabla="RHEDatosVariables" col="RHEDVdescripcion" returnvariable="LvarRHEDVdescripcion">
<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >
	<cfset queryName = "rsDato_#trim(Attributes.RHEDVid)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select RHEDVid, RHEDVcodigo, #LvarRHEDVdescripcion# as RHEDVdescripcion 
		from RHEDatosVariables
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and  RHEDVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idquery#">		
	</cfquery>
</cfif>

<cfset socios = "Datos Variables">

<script language="JavaScript">
var popUpWin=0;
function popUpWindow(URLStr, left, top, width, height){
	if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
  	}
  	popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp;
}
function closePopUp(){
	if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
		popUpWin=null;
  	}
}
function doConlisDatosVariables<cfoutput>#Attributes.RHEDVid#</cfoutput>() {
	<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
	var params ="";
	params = "<cfoutput>?formulario=#Attributes.form#&RHEDVid=#Attributes.RHEDVid#&RHEDVcodigo=#Attributes.RHEDVcodigo#&RHEDVdescripcion=#Attributes.RHEDVdescripcion#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>
	popUpWindow("/cfmx/rh/Utiles/ConlisDatosVariables.cfm"+params,250,200,650,400);
}

function conlis_keyup_<cfoutput>#Attributes.RHEDVid#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisDatosVariables<cfoutput>#Attributes.RHEDVid#</cfoutput>();
		}
	}

function TraeDatos<cfoutput>#Attributes.RHEDVcodigo#</cfoutput>(RHEDVcodigo) {
	var params ="";
	params = "<cfoutput>&RHEDVid=#Attributes.RHEDVid#&RHEDVdescripcion=#Attributes.RHEDVdescripcion#&RHEDVcodigo=#Attributes.RHEDVcodigo#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	
	
	if (RHEDVcodigo!="") {
		document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>").src="/cfmx/rh/Utiles/DatosVariablesquery.cfm?codigo="+RHEDVcodigo+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
	}
	else{
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.RHEDVcodigo#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.RHEDVid#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.RHEDVdescripcion#</cfoutput>.value = '';
	}
	return;
}
</script>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
	<tr>
		<td nowrap valign="top">
			<input type="text" name="#Attributes.RHEDVcodigo#" id="#Attributes.RHEDVcodigo#" maxlength="15" size="10" onblur="javascript:TraeDatos#Attributes.RHEDVcodigo#(document.#Attributes.form#.#Attributes.RHEDVcodigo#.value);" onfocus="this.select()"	tabindex="#Attributes.tabindex#"
			onKeyUp="javascript:conlis_keyup_<cfoutput>#Attributes.RHEDVid#</cfoutput>(event);" value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).RHEDVcodigo)#</cfif>">
		</td>
		<td nowrap valign="top">
			<input tabindex="-1" type="text" name="#Attributes.RHEDVdescripcion#" id="#Attributes.RHEDVdescripcion#" maxlength="255" size="#Attributes.size#" disabled 
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#HTMLEditFormat(REReplaceNoCase(Evaluate(queryName).RHEDVdescripcion, '\r|\n|<[^>]*>', '', 'all'))#</cfif>"><a href="##" tabindex="-1"><img id="SNimagen" src="/cfmx/rh/imagenes/Description.gif" alt="Lista de #socios#" name="SNimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisDatosVariables#Attributes.RHEDVid#();'></a>
		</td>
		<input type="hidden" name="#Attributes.RHEDVid#" id="#Attributes.RHEDVid#" value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).RHEDVid)#</cfif>">
	</tr>
	</cfoutput>
  </table>
<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>