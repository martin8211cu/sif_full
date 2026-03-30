<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 			default="" 				type="string"> <!--- consulta por defecto --->
<cfparam name="Attributes.Bid" 				default="Bid"	 		type="string"> <!--- Nombres del código del socio --->
<cfparam name="Attributes.FAM18DES" 		default="FAM18DES" 		type="string"> <!--- Nombres de la descripción del socio --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="30" 			type="string"> <!--- Tabindex del campo editable --->

<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >
	<cfset queryName = "rsBanco_#trim(Attributes.Bid)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select Bid, FAM18DES
		from FAM018 
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and Bid=<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.idquery#">
	</cfquery>
</cfif>
<!--- query --->

<script language="JavaScript">
var popUpWinSN<cfoutput>#Attributes.Bid#</cfoutput>=0;
function popUpWindow<cfoutput>#Attributes.Bid#</cfoutput>(URLStr, left, top, width, height){
	if(popUpWinSN<cfoutput>#Attributes.Bid#</cfoutput>) {
		if(!popUpWinSN<cfoutput>#Attributes.Bid#</cfoutput>.closed) popUpWinSN<cfoutput>#Attributes.Bid#</cfoutput>.close();
  	}
  	popUpWinSN<cfoutput>#Attributes.Bid#</cfoutput> = open(URLStr, 'popUpWinSN<cfoutput>#Attributes.Bid#</cfoutput>', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp<cfoutput>#Attributes.Bid#</cfoutput>;
}

function closePopUp<cfoutput>#Attributes.Bid#</cfoutput>(){
	if(popUpWinSN<cfoutput>#Attributes.Bid#</cfoutput>) {
		if(!popUpWinSN<cfoutput>#Attributes.Bid#</cfoutput>.closed) popUpWinSN<cfoutput>#Attributes.Bid#</cfoutput>.close();
		popUpWinSN<cfoutput>#Attributes.Bid#</cfoutput>=null;
  	}
}

function doConlisBanco<cfoutput>#Attributes.Bid#</cfoutput>() {
	var params ="";
	params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.Bid#&desc=#Attributes.FAM18DES#</cfoutput>";
	popUpWindow<cfoutput>#Attributes.Bid#</cfoutput>("/cfmx/sif/Utiles/ConlisPVBancos.cfm"+params,250,200,650,400);
}

</script>

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
	<tr>
		<td nowrap width="1%">
			<input tabindex="-1" type="text" name="#Attributes.FAM18DES#" id="#Attributes.FAM18DES#" maxlength="50" size="#Attributes.size#" disabled 
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).FAM18DES)#</cfif>" >
		</td>
		<td width="98%">
			<a  href="##" tabindex="-1"><img id="Bid" src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Bancos" name="BidImagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisBanco#Attributes.Bid#();'></a>
		</td>
		<input type="hidden" name="#Attributes.Bid#" id="#Attributes.Bid#" 
		value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).Bid)#</cfif>">
	</tr>
	</cfoutput>
  </table>