<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 			default="" 		 		type="string"> <!--- consulta por defecto --->
<cfparam name="Attributes.Bid" 				default="Bid"	 		type="string"> <!--- Nombres del código del banco --->
<cfparam name="Attributes.PBid" 			default="-1"	 		type="integer"> <!--- Nombres del código del banco --->
<cfparam name="Attributes.Bdescripcion"		default="Bdescripcion" 	type="string"> <!--- Nombres del banco --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="30" 			type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.modificable"		default="true" 			type="string"> <!--- Editable o no editable --->

<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >
	<cfset queryName = "rsBanco_#trim(Attributes.Bid)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select A.Bid, A.Bdescripcion
		from Bancos A
		where A.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">		  
		  and A.Bid=<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.PBid#">
		  
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
	params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.Bid#&desc=#Attributes.Bdescripcion#</cfoutput>";
	popUpWindow<cfoutput>#Attributes.Bid#</cfoutput>("/cfmx/sif/Utiles/ConlisPVMBancos.cfm"+params,250,200,650,400);
}

</script>

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
	<tr>
		<td nowrap width="1%">
			<input tabindex="-1" type="text" name="#Attributes.Bdescripcion#" id="#Attributes.Bdescripcion#" maxlength="50" size="#Attributes.size#" disabled 
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).Bdescripcion)#</cfif>" >
		</td>		
		<cfif Attributes.modificable>
		<td width="98%">
			<a  href="##" tabindex="-1"><img id="Bid" src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Bancos" name="BidImagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisBanco#Attributes.Bid#();'></a>
		</td>
		<cfelse>
		<td width="98%">&nbsp;

		</td>		
		</cfif>
		<input type="hidden" name="#Attributes.Bid#" id="#Attributes.Bid#" 
		value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).Bid)#</cfif>">
	</tr>
	</cfoutput>
  </table>