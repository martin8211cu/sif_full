<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"		type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 			type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 			default="" 					type="string"> <!--- consulta por defecto --->
<cfparam name="Attributes.RHIid" 			default="RHIid" 			type="string"> <!--- Nombres del código del socio --->
<cfparam name="Attributes.RHIdescripcion" 	default="RHIdescripcion" 	type="string"> <!--- Nombres de la identificación del socio Ej: 9-089-679 --->
<cfparam name="Attributes.tabindex" 		default="" 					type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="30"				type="string"> <!--- Tabindex del campo editable --->


<!--- Lista --->
<cfset idList= ListAppend(0,1,2,3,4,5,6,7)>
<cfset incosList= ListAppend('Omisión de Marca de Entrada','Omision de Marca de Salida','Dia Extra','Dia de Ausencia',
								'Llegada Anticipada','Llegada Tardía','Salida Anticipada','Salida Tardía')>
<!--- Lista --->
<cfif isdefined("Attributes.RHIid") and len(trim(Attributes.RHIid))>
	<cfloop list="idList" index="i">
		<cfif trim(listGetAt(idList, i)) EQ Attributes.RHIid>
			<cfset Attributes.RHIdescripcion = listGetAt(incosList, i)>
		</cfif>
	</cfloop>
</cfif>


<!--- consultas --->
<!--- query --->
<!--- <cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery))>
	<cfset queryName = "rsEvaluacion_#trim(Attributes.RHIid)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select RHIid, RHIdescripcion
		from RHEEvaluacionDes
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and RHIid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idquery#">
	</cfquery>
</cfif> --->
<!--- query --->

<!--- 
<script language="JavaScript">
var popUpWinSN=0;
function popUpWindow<cfoutput>#Attributes.RHIid#</cfoutput>(URLStr, left, top, width, height){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
  	}
  	popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp<cfoutput>#Attributes.RHIid#</cfoutput>;
}
function closePopUp<cfoutput>#Attributes.RHIid#</cfoutput>(){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
		popUpWinSN=null;
  	}
}
function doconlisInconsistencias<cfoutput>#Attributes.RHIid#</cfoutput>() {
	var params ="";
	params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.RHIid#&desc=#Attributes.RHIdescripcion#</cfoutput>";

	popUpWindow<cfoutput>#Attributes.RHIid#</cfoutput>("/cfmx/rh/Utiles/conlisInconsistencias.cfm"+params,250,200,650,400);
}

</script>

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
	<tr>
		<td nowrap width="1%">
			<input tabindex="-1" type="text" name="#Attributes.RHIdescripcion#" id="#Attributes.RHIdescripcion#" maxlength="255" size="#Attributes.size#" disabled 
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).RHIdescripcion)#</cfif>">
		</td>
		<td width="98%"><a  href="##" tabindex="-1"><img id="SNimagen" src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Concursos" name="SNimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doconlisInconsistencias#Attributes.RHIid#();'></a></td>
		<input type="hidden" name="#Attributes.RHIid#" id="#Attributes.RHIid#" value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).RHIid)#</cfif>">
	</tr>
	</cfoutput>
  </table> --->