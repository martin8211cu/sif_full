<!---  
	Creado por: Gabriel E. Sanchez Huerta.
	Fecha: 14 de Julio del 2010.
	Motivo: Seleccionar los Departamentos.
--->


<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="string"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="string"> <!--- Nombre del form --->
<cfparam name="Attributes.id" 				default=""				type="string"> <!--- consulta por defecto --->
<cfparam name="Attributes.Dcodigo"			default="Dcodigo" 		type="string"> <!--- Nombre del id del Departamento --->
<cfparam name="Attributes.Deptocodigo" 		default="Deptocodigo" 	type="string"> <!--- Nombre del codigo del Departamento --->
<cfparam name="Attributes.Ddescripcion" 	default="Ddescripcion" 	type="string"> <!--- Nombre de la descripcion del Departamento --->
<cfparam name="Attributes.excluir" 			default="" 				type="string"> 
<cfparam name="Attributes.frame" 			default="frDepartamento" 	type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.FuncJSalAbrir" 	default="" 				type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" 				type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="30" 			type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.modificable" 		default="true"			type="boolean"><!--- Parámetros para impedir la modificación del dato --->


<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.id") and len(trim(Attributes.id)) >
	<cfset queryName = "rsDepartamento#trim(Attributes.Deptocodigo)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		Select Dcodigo, Deptocodigo, Ddescripcion
		from Departamentos
		where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and Dcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.id#">
	</cfquery>
</cfif>
<!--- query --->

<script language="JavaScript">
var popUpWin=0;
function popUpWindow(URLStr, left, top, width, height){
	if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
  	}
  	popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp;
}
function closePopUp(){
	if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
		popUpWin=null;
  	}
}
//funcion para habilitar el F2
	function conlis_keyup_<cfoutput>#Attributes.Deptocodigo#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisDepartamento<cfoutput>#Attributes.Deptocodigo#</cfoutput>();
		}
	}
function doConlisDepartamento<cfoutput>#Attributes.Deptocodigo#</cfoutput>() {
	 <cfif Attributes.modificable>
		<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
		var params ="";
		params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.Dcodigo#&codigo=#Attributes.Deptocodigo#&desc=#Attributes.Ddescripcion#&excluir=#Attributes.excluir#</cfoutput>";
		<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
			params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
		</cfif>	
		popUpWindow("/cfmx/Mex/Produccion/Parametros/ConlisDepartamentos.cfm"+params,250,200,650,400);
	</cfif>
}

function TraeDepartamento<cfoutput>#Attributes.Deptocodigo#</cfoutput>(valor) {
	var params ="";
	params = "<cfoutput>&id=#Attributes.Dcodigo#&desc=#Attributes.Ddescripcion#&codigo=#Attributes.Deptocodigo#&excluir=#Attributes.excluir#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	

	if (valor!="") {
		//document.all["<cfoutput>#Attributes.frame#</cfoutput>"].src="/cfmx/Produccion/Parametros/sifDepartamentoquery.cfm?valor="+valor+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
		var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
		fr.src = "/cfmx/Departamento/Parametros/sifDepartamentoquery.cfm?valor="+valor+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;		
	}
	else{
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Dcodigo#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Deptocodigo#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Ddescripcion#</cfoutput>.value = '';
		<cfoutput>if (window.func#Attributes.Deptocodigo#) {window.func#Attributes.Deptocodigo#()}</cfoutput>
	}
	return;
}
</script>

<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td nowrap width="1%">
			<input type="text" name="#Attributes.Deptocodigo#" id="#Attributes.Deptocodigo#" 
			maxlength="15" <cfif not Attributes.modificable>disabled</cfif> size="10" 
			onblur="javascript:TraeDepartamento#Attributes.Deptocodigo#(document.#Attributes.form#.#Evaluate('Attributes.Deptocodigo')#.value);" 
			onfocus="this.select()"	tabindex="#Attributes.tabindex#"
			onkeyup="javascript:conlis_keyup_#Attributes.Deptocodigo#(event);"
			value="<cfif isdefined("Attributes.id") and len(trim(Attributes.id))>#Trim(Evaluate(queryName).Deptocodigo)#</cfif>">
		</td>
	
		<td nowrap width="1%">
			<input tabindex="-1" type="text" name="#Attributes.Ddescripcion#" id="#Attributes.Ddescripcion#" maxlength="255" size="#Attributes.size#" disabled 
				value="<cfif isdefined("Attributes.id") and len(trim(Attributes.id))>#Trim(Evaluate(queryName).Ddescripcion)#</cfif>">
		</td>
	
		<td width="98%" nowrap>
			<a href="##" tabindex="-1"><img id="Almimagen" src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Departamentos" name="Almimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisDepartamento#Attributes.Deptocodigo#();'></a>
			<input type="hidden" name="#Attributes.Dcodigo#" id="#Attributes.Dcodigo#" value="<cfif isdefined("Attributes.id") and len(trim(Attributes.id))>#Trim(Evaluate(queryName).Dcodigo)#</cfif>">
		</td>
	</tr>
</table>
</cfoutput>

	<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" 
		marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" style="display:none; "></iframe>