<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"		type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 			type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 			default="" 					type="string"> <!--- consulta por defecto --->
<cfparam name="Attributes.RHEEid" 			default="RHEEid" 			type="string"> <!--- Nombres del código del socio --->
<cfparam name="Attributes.RHEEdescripcion" 	default="RHEEdescripcion" 	type="string"> <!--- Nombres de la identificación del socio Ej: 9-089-679 --->
<cfparam name="Attributes.tabindex" 		default="" 					type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="30"				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.tipo" 			default="0"					type="string"> <!--- tipo de evaluación 0 = todos 1 = por habilidad 2 = por cuestionario 3 = por concimientos 4 = habilidades o conocimientos --->
<cfparam name="Attributes.Cerradas" 		default="N"					type="string"> <!--- tipo de evaluación 0 = todos 1 = por habilidad 2 = por cuestionario 3 = por concimientos 4 = habilidades o conocimientos --->
<cfparam name="Attributes.DEid" 		    default=""					type="string"> <!---para que salgan solo los cuestionarios propiso del empleado, si no viene en los atributos trae a todos--->

<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery))>
	<cfset queryName = "rsEvaluacion_#trim(Attributes.RHEEid)#">
	<cf_translatedata name="get" tabla="RHEEvaluacionDes" col="RHEEdescripcion" returnvariable="LvarRHEEdescripcion">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select RHEEid, #LvarRHEEdescripcion# as RHEEdescripcion
		from RHEEvaluacionDes
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and RHEEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idquery#">
		  
		  <cfif isdefined('Attributes.DEid') and len(trim(Attributes.DEid))>
		  and RHEEid in (select distinct RHEEid from RHListaEvalDes where Ecodigo = #Session.Ecodigo# and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.DEid#">)
		  </cfif> 
		  
	</cfquery>
</cfif>
<!--- query --->

<script language="JavaScript">
var popUpWinSN=0;
function popUpWindow<cfoutput>#Attributes.RHEEid#</cfoutput>(URLStr, left, top, width, height){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
  	}
  	popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp<cfoutput>#Attributes.RHEEid#</cfoutput>;
}
function closePopUp<cfoutput>#Attributes.RHEEid#</cfoutput>(){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
		popUpWinSN=null;
  	}
}
function doConlisEvaluacion<cfoutput>#Attributes.RHEEid#</cfoutput>() {
	var params ="";
	params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.RHEEid#&desc=#Attributes.RHEEdescripcion#&tipo=#Attributes.tipo#&Cerradas=#Attributes.Cerradas#&DEid=#Attributes.DEid#</cfoutput>";

	popUpWindow<cfoutput>#Attributes.RHEEid#</cfoutput>("/cfmx/rh/Utiles/conlisEvaluacion.cfm"+params,250,200,650,400);
}

</script>

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
	<tr>
		<td nowrap width="1%">
			<input tabindex="-1" type="text" name="#Attributes.RHEEdescripcion#" id="#Attributes.RHEEdescripcion#" maxlength="255" size="#Attributes.size#" disabled 
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).RHEEdescripcion)#</cfif>">
		</td>
		<td width="98%"><a  href="##" tabindex="-1"><img id="SNimagen" src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Concursos" name="SNimagen" width="18" height="14" border="0" align="absmiddle" onclick='javascript:doConlisEvaluacion#Attributes.RHEEid#();'></a></td>
		<input type="hidden" name="#Attributes.RHEEid#" id="#Attributes.RHEEid#" value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).RHEEid)#</cfif>">
	</tr>
	</cfoutput>
  </table>