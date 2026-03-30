<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"		type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 			type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.id" 				default="" 					type="string">  <!--- consulta por defecto --->
<cfparam name="Attributes.EPDid" 			default="EPDid" 			type="string"> <!--- Nombre del id de la Poliza --->
<cfparam name="Attributes.EPDnumero" 		default="EPDnumero" 		type="string"> <!--- Nombre del codigo de la Poliza  --->
<cfparam name="Attributes.EPDdescripcion" 	default="EPDdescripcion" 	type="string"> <!--- Nombre de la descripcion de la Poliza --->
<cfparam name="Attributes.frame" 			default="frPoliza" 		type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.tabindex" 		default="" 					type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="30" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.conlis" 			default="true"				type="boolean"> <!--- Si se despliega el Conlis o no y si se puede cambiar o no --->
<cfparam name="Attributes.excluir" 			default="" 					type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.FuncJSalAbrir" 	default="" 					type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" 					type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.invisible" 		default="false"				type="boolean"> <!--- Si se despliegan los inputs--->

<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.id") and len(trim(Attributes.id)) >
	<cfset queryName = "rsPoliza_#trim(Attributes.EPDid)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		Select EPDid, EPDnumero, EPDdescripcion
		from EPolizaDesalmacenaje
		where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and EPDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
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

function doConlisPoliza<cfoutput>#Attributes.EPDid#</cfoutput>() {
	<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
	var params ="";
	params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.EPDid#&codigo=#Attributes.EPDnumero#&desc=#Attributes.EPDdescripcion#&excluir=#Attributes.excluir#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	
	popUpWindow("/cfmx/sif/Utiles/ConlisPoliza.cfm"+params,250,200,650,400);
}

function TraePoliza<cfoutput>#Attributes.EPDnumero#</cfoutput>(valor) {
	var params ="";
	params = "<cfoutput>&id=#Attributes.EPDid#&desc=#Attributes.EPDdescripcion#&codigo=#Attributes.EPDnumero#&excluir=#Attributes.excluir#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	

	if (valor!="") {
		document.all["<cfoutput>#Attributes.frame#</cfoutput>"].src="/cfmx/sif/Utiles/sifPolizaquery.cfm?valor="+valor+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
	}
	else{
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.EPDid#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.EPDnumero#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.EPDdescripcion#</cfoutput>.value = '';
		<cfoutput>if (window.func#Attributes.EPDnumero#) {window.func#Attributes.EPDnumero#()}</cfoutput>
	}
	return;
}
</script>

<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td nowrap width="1%">
			<input type="<cfif attributes.invisible>hidden<cfelse>text</cfif>" name="#Attributes.EPDnumero#" id="#Attributes.EPDnumero#" maxlength="15" size="10" <cfif Attributes.conlis> onblur="javascript:TraePoliza#Attributes.EPDnumero#(document.#Attributes.form#.#Evaluate('Attributes.EPDnumero')#.value);"</cfif> onfocus="this.select()" <cfif not Attributes.conlis>readonly="true"</cfif> tabindex="#Attributes.tabindex#"
			value="<cfif isdefined("Attributes.id") and len(trim(Attributes.id)) >#Trim(Evaluate(queryName).EPDnumero)#</cfif>">
		</td>
	
		<td nowrap width="1%">
			<input tabindex="-1" type="<cfif attributes.invisible>hidden<cfelse>text</cfif>" name="#Attributes.EPDdescripcion#" id="#Attributes.EPDdescripcion#" maxlength="255" size="#Attributes.size#" readonly="true" 
				value="<cfif isdefined("Attributes.id") and len(trim(Attributes.id)) >#Trim(Evaluate(queryName).EPDdescripcion)#</cfif>">
		</td>
	
		<td width="98%">&nbsp;
			<cfif Attributes.conlis>
				<a href="##" tabindex="-1">
					<img id="Almimagen" src="/cfmx/sif/imagenes/Description.gif" alt="Lista de P&oacute;lizas" name="Polimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisPoliza#Attributes.EPDid#();'>
				</a>
			<cfelse>
				&nbsp;			
			</cfif>
		</td>
		<input type="hidden" name="#Attributes.EPDid#" id="#Attributes.EPDid#" value="<cfif isdefined("Attributes.id") and len(trim(Attributes.id)) >#Trim(Evaluate(queryName).EPDid)#</cfif>">
	</tr>
</table>
</cfoutput>

	<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>