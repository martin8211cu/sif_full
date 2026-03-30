<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"		type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 			type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 			default="" 					type="string"> <!--- id de registro para desplegar --->
<cfparam name="Attributes.id" 				default="RHPPid" 			type="string"> <!--- Nombres del id de la pp --->
<cfparam name="Attributes.codigo" 			default="RHPPcodigo"		type="string"> <!--- Nombres del codigo de la pp --->
<cfparam name="Attributes.descripcion" 		default="RHPPdescripcion" 	type="string"> <!--- Nombres de la descripcion de la pp --->
<cfparam name="Attributes.frame" 			default="frpp"	 			type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.FuncJSalAbrir" 	default="" 					type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" 					type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" 		default="" 					type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="30" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.conlis" 			default="true" 				type="boolean"> <!--- Bandera para pintar o no la imagencilla que abre el conlis y permitir editar el codigo --->
<cfparam name="Attributes.modificable" default="true" type="boolean"><!--- Parámetros para impedir la modificación del dato --->

<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery))>
	<cfset queryName = "rsPP_#trim(Attributes.codigo)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select RHPPid as id, RHPPcodigo as codigo, RHPPdescripcion as descr
		from RHPlazaPresupuestaria 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
		  and RHPPid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idquery#">
	</cfquery>
</cfif>
<!--- query --->

<script language="JavaScript">
var popUpWinPP=0;
function popUpWindow<cfoutput>#Attributes.codigo#</cfoutput>(URLStr, left, top, width, height){
	if(popUpWinPP) {
		if(!popUpWinPP.closed) popUpWinPP.close();
  	}
  	popUpWinPP = open(URLStr, 'popUpWinPP', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp<cfoutput>#Attributes.codigo#</cfoutput>;
}
function closePopUp<cfoutput>#Attributes.codigo#</cfoutput>(){
	if(popUpWinPP) {
		if(!popUpWinPP.closed) popUpWinPP.close();
		popUpWinPP=null;
  	}
}
function doConlis<cfoutput>#Attributes.codigo#</cfoutput>() {
	<cfif Attributes.modificable>
			<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
			var params ="";
			params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.id#&codigo=#Attributes.codigo#&desc=#Attributes.descripcion#</cfoutput>";
			<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0> 
				params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
			</cfif>	
		
			popUpWindow<cfoutput>#Attributes.codigo#</cfoutput>("/cfmx/rh/Utiles/conlisPlazaPresupuestaria.cfm"+params,250,200,650,400);
	</cfif>
}

function TraeDatos<cfoutput>#Attributes.codigo#</cfoutput>(codigo) {
	<cfif Attributes.modificable>
			var params ="";
			params = "<cfoutput>&id=#Attributes.id#&desc=#Attributes.descripcion#&codigo=#Attributes.codigo#</cfoutput>";
			<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0> 
				params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
			</cfif>	
			
			if (codigo!="") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/rh/Utiles/rhplpresupuestariaquery.cfm?dato="+codigo+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
			}
			else{
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.id#</cfoutput>.value = '';
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.codigo#</cfoutput>.value = '';
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.descripcion#</cfoutput>.value = '';
			}
			return;
	</cfif>
}
</script>

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
	<tr>
		<td nowrap width="1%">
			<input 
				type="text" 
				name="#Attributes.codigo#" 
				id="#Attributes.codigo#" 
				maxlength="15" 
				size="10" 
				<cfif not Attributes.modificable>
					disabled
				</cfif>
				onblur="javascript:TraeDatos#Attributes.codigo#(document.#Attributes.form#.#Attributes.codigo#.value);" 
				onfocus="this.select()"	
				<cfif isdefined("Attributes.conlis") and Attributes.conlis EQ false>
					readonly="true"
				</cfif>
				tabindex="#Attributes.tabindex#"
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).codigo)#</cfif>">
		</td>
		<td nowrap width="1%">
			<input tabindex="-1" type="text" name="#Attributes.descripcion#" id="#Attributes.descripcion#" maxlength="255" size="#Attributes.size#" disabled 
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).descr)#</cfif>">
		</td>
		<td width="98%">
			
			<cfif isdefined("Attributes.conlis") and Attributes.conlis EQ true>
				&nbsp;<a  href="##" tabindex="-1"><img id="SNimagen" src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Plazas Presupuestarias" name="SNimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlis#Attributes.codigo#();'></a>
			</cfif>
		</td>
		<input type="hidden" name="#Attributes.id#" id="#Attributes.id#" value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).id)#</cfif>">
	</tr>
	</cfoutput>
	
  </table>
	<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>