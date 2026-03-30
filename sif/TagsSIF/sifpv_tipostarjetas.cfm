<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#session.dsn#"	type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 			default="" 				type="string"> <!--- consulta por defecto --->
<cfparam name="Attributes.tc_tipo" 			default="tc_tipo" 		type="string"> <!---  --->
<cfparam name="Attributes.nombre_tipo_tarjeta" 	default="nombre_tipo_tarjeta"	type="string"> <!---nombre del tipo de tarjeta--->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="30" 			type="string"> <!--- Tabindex del campo editable --->

<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >
	<cfset queryName = "rsTiposTarjetas_#trim(Attributes.tc_tipo)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select tc_tipo, nombre_tipo_tarjeta
		from TipoTarjeta 
		where tc_tipo=<cfqueryparam cfsqltype="cf_sql_char" value="#Attributes.idquery#">
	</cfquery>
</cfif>
<!--- query --->

<script language="JavaScript">
var popUpWinSN<cfoutput>#Attributes.tc_tipo#</cfoutput>=0;
function popUpWindow<cfoutput>#Attributes.tc_tipo#</cfoutput>(URLStr, left, top, width, height){
	if(popUpWinSN<cfoutput>#Attributes.tc_tipo#</cfoutput>) {
		if(!popUpWinSN<cfoutput>#Attributes.tc_tipo#</cfoutput>.closed) popUpWinSN<cfoutput>#Attributes.tc_tipo#</cfoutput>.close();
  	}
  	popUpWinSN<cfoutput>#Attributes.tc_tipo#</cfoutput> = open(URLStr, 'popUpWinSN<cfoutput>#Attributes.tc_tipo#</cfoutput>', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp<cfoutput>#Attributes.tc_tipo#</cfoutput>;
}

function closePopUp<cfoutput>#Attributes.tc_tipo#</cfoutput>(){
	if(popUpWinSN<cfoutput>#Attributes.tc_tipo#</cfoutput>) {
		if(!popUpWinSN<cfoutput>#Attributes.tc_tipo#</cfoutput>.closed) popUpWinSN<cfoutput>#Attributes.tc_tipo#</cfoutput>.close();
		popUpWinSN<cfoutput>#Attributes.tc_tipo#</cfoutput>=null;
  	}
}

function doConlisTiposTarjetas<cfoutput>#Attributes.tc_tipo#</cfoutput>() {
	var params ="";
	params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.tc_tipo#&desc=#Attributes.nombre_tipo_tarjeta#</cfoutput>";
	popUpWindow<cfoutput>#Attributes.tc_tipo#</cfoutput>("/cfmx/sif/Utiles/ConlisTiposTarjetas.cfm"+params,250,200,650,400);
}

</script>

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
	<tr>
		
		<td nowrap width="1%">
			<input tabindex="-1" type="text" name="#Attributes.tc_tipo#" id="#Attributes.tc_tipo#" maxlength="4" size="10" readonly="true" 
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).tc_tipo)#</cfif>" >
		</td>
		<td nowrap width="1%">
			<input tabindex="-1" type="text" name="#Attributes.nombre_tipo_tarjeta#" id="#Attributes.nombre_tipo_tarjeta#" maxlength="30" size="#Attributes.size#" readonly="true"  
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).nombre_tipo_tarjeta)#</cfif>" >
		</td>
		<td width="98%">
			<a  href="##" tabindex="-1"><img id="tc_tipo" src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Tipos de Tarjetas de Créditos" name="BidImagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisTiposTarjetas#Attributes.tc_tipo#();'></a>
		</tr>
	</cfoutput>
  </table>