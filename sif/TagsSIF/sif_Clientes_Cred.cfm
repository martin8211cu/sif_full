<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		 default="#Session.DSN#"		type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			 default="form1" 			    type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 	 		 default="" 					type="string">  <!--- consulta por defecto --->
<cfparam name="Attributes.CDCcodigo" 		 default="CDCcodigo"			type="string"> <!--- Nombres del código del socio --->
<cfparam name="Attributes.CDCnombre" 		 default="CDCnombre"			type="string"> <!--- Nombres de la descripción del socio --->
<cfparam name="Attributes.CDCidentificacion" default="CDCidentificacion"	type="string"> <!--- Nombres de la identificación del socio Ej: 9-089-679 --->
<cfparam name="Attributes.frame" 			 default="frdetallista" 		type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.FuncJSalAbrir" 	 default="" 					type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"	 default="" 					type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" 		 default="" 					type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			 default="30" 				type="string"> <!--- Tabindex del campo editable --->

<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >
	<cfset queryName = "rsSocio_#trim(Attributes.CDCnombre)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		Select a.CDCcodigo,a.SNcodigo,CDCnombre,CDCidentificacion,SNnombre,SNidentificacion
		from FACSnegocios a
		inner join ClientesDetallistasCorp b
			on b.CDCcodigo=a.CDCcodigo
			and b.CEcodigo=a.Ecodigo
		inner join SNegocios c
			on c.SNcodigo=a.SNcodigo
			and c.Ecodigo=a.Ecodigo
where a.Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
	</cfquery>
</cfif>
<!--- query --->


<script language="JavaScript">
<cfif Not Isdefined("Request.sif_cliente_detallista_functions")>
var popUpWin=0;
function blur_cedula(ctl){
	var value = ctl.value;
	value = value.replace(/^([0-9])-([0-9]{3})-([0-9]{4})$/,'$1-0$2-$3');
	value = value.replace(/^([0-9])-([0-9]{4})-([0-9]{3})$/,'$1-$2-0$3');
	value = value.replace(/^([0-9])-([0-9]{3})-([0-9]{3})$/,'$1-0$2-0$3');
	value = value.replace(/^([0-9])([0-9]{3})([0-9]{3})$/,'$1-0$2-0$3');
	value = value.replace(/^([0-9])([0-9]{4})([0-9]{4})$/,'$1-$2-$3');
	ctl.value = value;
}
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
</cfif>
function doConlisSocio<cfoutput>#Attributes.CDCcodigo#</cfoutput>() {
	<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
	var params ="";
	params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.CDCidentificacion#&codigo=#Attributes.CDCcodigo#&desc=#Attributes.CDCnombre#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	
	popUpWindow("/cfmx/sif/Utiles/ConlisClientes_Cred.cfm"+params,250,200,650,400);
}

function TraeCliente<cfoutput>#Attributes.CDCcodigo#</cfoutput>(codigo) {
	var params ="";
	blur_cedula(document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.CDCidentificacion#</cfoutput>);
	params = "<cfoutput>&id=#Attributes.CDCidentificacion#&desc=#Attributes.CDCnombre#&codigo=#Attributes.CDCcodigo#&numero=#Attributes.CDCidentificacion#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	

	if (codigo!="") {
		var obj_frame = document.all ? document.all["<cfoutput>#Attributes.frame#</cfoutput>"] : document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
		obj_frame.src="/cfmx/sif/Utiles/ConlisClientes_Cred.cfm?codigo="+codigo+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
	}
	else{
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.CDCcodigo#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.CDCidentificacion#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.CDCnombre#</cfoutput>.value = '';
	}
	return;
}
</script>

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
	<tr>
		<td nowrap width="1%">
			<input type="text" name="#Attributes.CDCidentificacion#" id="#Attributes.CDCidentificacion#" maxlength="15" size="10" onblur="javascript:TraeCliente#Attributes.CDCidentificacion#(document.#Attributes.form#.#Evaluate('Attributes.CDCidentificacion')#.value);" onfocus="this.select()"	tabindex="#Attributes.tabindex#"
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).CDCcodigo)#</cfif>">
		</td>
		<td nowrap width="1%">
			<input tabindex="-1" type="text" name="#Attributes.CDCnombre#" id="#Attributes.CDCnombre#" maxlength="255" size="#Attributes.size#" disabled 
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).CDCnombre)#</cfif>">
		</td>
		<cfif not isdefined("modo") or modo eq 'Alta'>
		<td width="98%">&nbsp;<a href="##" tabindex="-1"><img id="SNimagen" src="/cfmx/sif/imagenes/Description.gif" alt="Lista de clientes" name="SNimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisSocio#Attributes.CDCcodigo#();'></a></td>
		<cfelse>
		<td width="98%">&nbsp;</td>
		</cfif>
		<input type="hidden" name="#Attributes.CDCcodigo#" id="#Attributes.CDCcodigo#" value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).CDCcodigo)#</cfif>">		
	</tr>
	</cfoutput>
  </table>
<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>
