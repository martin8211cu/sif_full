<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.id" 				default="" 				type="string">  <!--- consulta por defecto --->
<cfparam name="Attributes.Aid" 				default="Aid" 			type="string"> <!--- Nombre del id de Almacen --->
<cfparam name="Attributes.Almcodigo" 		default="Almcodigo" 	type="string"> <!--- Nombre del codigo de Almacen  --->
<cfparam name="Attributes.Bdescripcion" 	default="Bdescripcion" 	type="string"> <!--- Nombtre de la descripcion de Almacen --->
<cfparam name="Attributes.excluir" 			default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.frame" 			default="fralmacen" 	type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.FuncJSalAbrir" 	default="" 				type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" 				type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="30" 			type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.readOnly" 		default="no" 		    type="string"> <!--- Lo inhabilita en modo cambio --->
<cfparam name="Attributes.Acodigo" 			default="" 				type="string"> <!--- Indica si debe interactuar con Acodigo --->
<cfparam name="Attributes.Ecodigo" 			default="#session.Ecodigo#" type="numeric"> 
<cfparam name="Attributes.FilUsucodigo" 	default="no"             type="boolean"> <!--- Filtrar los almacenes por el Usuario --->

<cfif isdefined("Attributes.id") and len(trim(Attributes.id)) >
	<cfset queryName = "rsAlmacen_#trim(Attributes.Almcodigo)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select Aid, Almcodigo, Bdescripcion
		from Almacen
		where Ecodigo=<cfqueryparam value="#Attributes.Ecodigo#" cfsqltype="cf_sql_integer">
		and Aid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
		order by Almcodigo
	</cfquery>
</cfif>

<!--- query --->
<cfoutput>
<div style="display: inline-block; white-space: nowrap;">
<input type="text" name="#Attributes.Almcodigo#" id="#Attributes.Almcodigo#" maxlength="15" size="10" onblur="javascript:TraeAlmacen#Attributes.Almcodigo#(document.#Attributes.form#.#Evaluate('Attributes.Almcodigo')#.value);" onfocus="this.select()"	tabindex="#Attributes.tabindex#"onKeyUp="javascript:conlis_keyup_#Attributes.Almcodigo#(event);" value="<cfif isdefined("Attributes.id") and len(trim(Attributes.id)) >#Trim(Evaluate(queryName).Almcodigo)#</cfif>"<cfif Attributes.readOnly eq 'yes'>disabled</cfif>>
	<input tabindex="-1" type="text" name="#Attributes.Bdescripcion#" id="#Attributes.Bdescripcion#" maxlength="255" size="#Attributes.size#" disabled value="<cfif isdefined("Attributes.id") and len(trim(Attributes.id)) >#Trim(Evaluate(queryName).Bdescripcion)#</cfif>">
	<a href="##" tabindex="-1">			  
		<cfif Attributes.readOnly neq 'yes'>
			<img id="Almimagen" src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Almac&eacute;nes" name="Almimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisAlmacen#Attributes.Almcodigo#();'>
		</cfif>
	</a>
	<input type="hidden" name="#Attributes.Aid#" id="#Attributes.Aid#" value="<cfif isdefined("Attributes.id") and len(trim(Attributes.id)) >#Trim(Evaluate(queryName).Aid)#</cfif>">
	<iframe id="#Attributes.frame#" name="#Attributes.frame#" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>
</div>
</cfoutput>

<script language="javascript1.2" type="text/javascript">
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

function doConlisAlmacen<cfoutput>#Attributes.Almcodigo#</cfoutput>() {
	<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
	var params ="";
	params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.Aid#&FilUsucodigo=#Attributes.FilUsucodigo#&codigo=#Attributes.Almcodigo#&desc=#Attributes.Bdescripcion#&excluir=#Attributes.excluir#&Ecodigo=#Attributes.Ecodigo#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	
	popUpWindow("/cfmx/sif/Utiles/ConlisAlmacen.cfm"+params,250,200,650,400);
}

function TraeAlmacen<cfoutput>#Attributes.Almcodigo#</cfoutput>(valor) {
	var params ="";
	params = "<cfoutput>&id=#Attributes.Aid#&desc=#Attributes.Bdescripcion#&FilUsucodigo=#Attributes.FilUsucodigo#&codigo=#Attributes.Almcodigo#&excluir=#Attributes.excluir#&Ecodigo=#Attributes.Ecodigo#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	
	<cfif Attributes.Acodigo NEQ ""> 
		params = params + "<cfoutput>&Acodigo=#Attributes.Acodigo#</cfoutput>";
	</cfif>	

	if (valor!="") {
		document.all["<cfoutput>#Attributes.frame#</cfoutput>"].src="/cfmx/sif/Utiles/sifalmacenquery.cfm?valor="+valor+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
	}
	else{
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Aid#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Almcodigo#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Bdescripcion#</cfoutput>.value = '';
		<cfoutput>if (window.func#Attributes.Almcodigo#Antes) {window.func#Attributes.Almcodigo#Antes()}</cfoutput>
	}
	return;
}
	function conlis_keyup_<cfoutput>#Attributes.Almcodigo#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisAlmacen<cfoutput>#Attributes.Almcodigo#</cfoutput>();
		}
	}	
</script>