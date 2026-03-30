<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"		type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 			type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 			default="" 					type="string">  <!--- consulta por defecto --->
<cfparam name="Attributes.Vid" 				default="RHEDVid"			type="string"> <!--- ID del dato variable del tag encabezado --->
<cfparam name="Attributes.RHEDVid2" 		default="RHEDVid2" 			type="string"> <!--- ID del dato variable --->
<cfparam name="Attributes.RHDDVcodigo" 		default="RHDDVcodigo" 		type="string"> <!--- Código del dato variable  --->
<cfparam name="Attributes.RHDDVdescripcion" default="RHDDVdescripcion" 	type="string"> <!--- descripcion del dato variable  --->
<cfparam name="Attributes.size" 			default="50" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.RHDDVlinea" 		default="RHDDVlinea" 		type="string"> <!--- linea del dato variable  --->
<cfparam name="Attributes.frame" 			default="frdatos2" 			type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.FuncJSalAbrir" 	default="" 					type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" 					type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" 		default="" 					type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="50" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.filtrado" 		default="N" 				type="string"> <!--- Parametro para saber si el tag depende del tad del encabezado --->

<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >
	<cfset queryName = "rsDato_#trim(Attributes.Vid)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select RHEDVid, RHDDVlinea, RHDDVcodigo, RHDDVdescripcion
		from RHDDatosVariables
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and  RHDDVlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idquery#">	
	</cfquery>	
</cfif>

<cfset socios = "Valores de Datos Variables">

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
function doConlisDatosVariables<cfoutput>#Attributes.RHDDVlinea#</cfoutput>() {						
	<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
	var params ="";	
	params = "<cfoutput>?formulario=#Attributes.form#&RHEDVid2=#Attributes.RHEDVid2#&RHDDVcodigo=#Attributes.RHDDVcodigo#&RHDDVdescripcion=#Attributes.RHDDVdescripcion#&RHDDVlinea=#Attributes.RHDDVlinea#</cfoutput>";

	//If para saber si este tag depende de otro (encabezado)
	<cfif Attributes.filtrado eq "S">
		//Si el objeto HTML que contiene el id del dato variable  no es vacio
		if (document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Vid#</cfoutput>.value == ''){
			alert("<cf_translate key='LB_DebeSeleccionarUnDatoVariable' xmlFile='/rh/generales.xml'>Debe seleccionar un dato variable</cf_translate>");
		}
		else{
			params += "&Vid=" + document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Vid#</cfoutput>.value;
			<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
				params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
			</cfif>		
			popUpWindow("/cfmx/rh/Utiles/ConlisDatosVariablesD.cfm"+params,250,200,650,400);	
		}
	</cfif>		
}

function conlis_keyup_<cfoutput>#Attributes.RHDDVlinea#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisDatosVariables<cfoutput>#Attributes.RHDDVlinea#</cfoutput>();
		}
	}

function TraeDatos<cfoutput>#Attributes.RHDDVcodigo#</cfoutput>(RHDDVcodigo) {
	var params ="";
	params = "<cfoutput>&RHEDVid2=#Attributes.RHEDVid2#&RHDDVdescripcion=#Attributes.RHDDVdescripcion#&RHDDVcodigo=#Attributes.RHDDVcodigo#&RHDDVlinea=#Attributes.RHDDVlinea#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	
	
	//If para saber si este tag depende de otro (encabezado)
	<cfif Attributes.filtrado eq "S">
		//Si el objeto HTML que contiene el id del dato variable  no es vacio
		if (document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Vid#</cfoutput>.value == ''){
			alert("Debe seleccionar un dato variable");
		}
		else{
			params += "&Vid=" + document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Vid#</cfoutput>.value;	
			if (RHDDVcodigo!="") {
				document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>").src="/cfmx/rh/Utiles/DatosVariablesDquery.cfm?codigo="+RHDDVcodigo+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
			}
			else{
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.RHDDVcodigo#</cfoutput>.value = '';
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.RHEDVid2#</cfoutput>.value = '';
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.RHDDVdescripcion#</cfoutput>.value = '';
			}
		}	
	</cfif>	

	return;
}
</script>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
	<tr>				
		<td nowrap valign="top">
			<input type="text" name="#Attributes.RHDDVcodigo#" id="#Attributes.RHDDVcodigo#" maxlength="15" size="10" onblur="javascript:TraeDatos#Attributes.RHDDVcodigo#(document.#Attributes.form#.#Attributes.RHDDVcodigo#.value);" onfocus="this.select()"	tabindex="#Attributes.tabindex#"
			onKeyUp="javascript:conlis_keyup_<cfoutput>#Attributes.RHDDVlinea#</cfoutput>(event);" value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).RHDDVcodigo)#</cfif>">
		</td>
		<td nowrap valign="top">
			<input tabindex="-1" type="text" name="#Attributes.RHDDVdescripcion#" id="#Attributes.RHDDVdescripcion#" maxlength="255" size="#Attributes.size#" disabled 
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).RHDDVdescripcion)#</cfif>"><a href="##" tabindex="-1"><img id="SNimagen" src="/cfmx/rh/imagenes/Description.gif" alt="Lista de #socios#" name="SNimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisDatosVariables#Attributes.RHDDVlinea#();'></a>
		</td>
		<input type="hidden" name="#Attributes.RHDDVlinea#" id="#Attributes.RHDDVlinea#" value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).RHDDVlinea)#</cfif>">
		<input type="hidden" name="#Attributes.RHEDVid2#" id="#Attributes.RHEDVid2#" value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).RHEDVid)#</cfif>"><!---Si esta definido el idquery es porque la pantalla que llama al tag esta en modo cambio ---->
	</tr>
	</cfoutput>
  </table>
<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>