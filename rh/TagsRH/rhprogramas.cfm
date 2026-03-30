<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 			default="" 				type="string"> <!--- consulta por defecto --->
<cfparam name="Attributes.id" 				default="RHGMid"		type="string"> <!--- Nombres del código del socio --->
<cfparam name="Attributes.codigo" 			default="RHGMcodigo" 	type="string"> <!--- Nombres del código del socio --->
<cfparam name="Attributes.desc" 			default="descripcion"	type="string"> <!--- Nombres de la descripción del socio --->
<cfparam name="Attributes.frame" 			default="frprogramas"	type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="40" 			type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.quitar" 			default="" 				type="string"> <!--- Tabindex del campo editable --->

<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >
	<cfset queryName = "rsGrupoMateria_#trim(Attributes.codigo)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select RHGMcodigo as codigo, Descripcion as descripcion, RHGMid as id
		from RHGrupoMaterias
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and RHGMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idquery#">
	</cfquery>
</cfif>
<!--- query --->

<cfset titulo = "Programas">

<script language="JavaScript">
var popUpWin<cfoutput>#Attributes.codigo#</cfoutput>=0;
function popUpWindow<cfoutput>#Attributes.codigo#</cfoutput>(URLStr, left, top, width, height){
	if(popUpWin<cfoutput>#Attributes.codigo#</cfoutput>) {
		if(!popUpWin<cfoutput>#Attributes.codigo#</cfoutput>.closed) popUpWin<cfoutput>#Attributes.codigo#</cfoutput>.close();
  	}
  	popUpWin<cfoutput>#Attributes.codigo#</cfoutput> = open(URLStr, 'popUpWin<cfoutput>#Attributes.codigo#</cfoutput>', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp<cfoutput>#Attributes.codigo#</cfoutput>;
}
function closePopUp<cfoutput>#Attributes.codigo#</cfoutput>(){
	if(popUpWin<cfoutput>#Attributes.codigo#</cfoutput>) {
		if(!popUpWin<cfoutput>#Attributes.codigo#</cfoutput>.closed) popUpWin<cfoutput>#Attributes.codigo#</cfoutput>.close();
		popUpWin<cfoutput>#Attributes.codigo#</cfoutput>=null;
  	}
}
function doConlis<cfoutput>#Attributes.codigo#</cfoutput>() {
	var params ="";
	params = "<cfoutput>?form=#Attributes.form#&id=#Attributes.id#&cod=#Attributes.codigo#&desc=#Attributes.desc#&quitar=#Attributes.quitar#</cfoutput>";
	popUpWindow<cfoutput>#Attributes.codigo#</cfoutput>("/cfmx/rh/Utiles/ConlisGrupoMaterias.cfm"+params,250,200,650,400);
}
</script>

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
	<tr>
		<td nowrap width="1%">
			<input tabindex="-1" type="text" name="#Attributes.codigo#" id="#Attributes.codigo#" maxlength="255" size="15" disabled
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).codigo)#</cfif>">
		</td>
		<td nowrap width="1%">
			<input tabindex="-1" type="text" name="#Attributes.desc#" id="#Attributes.desc#" maxlength="255" size="#Attributes.size#" disabled 
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).descripcion)#</cfif>">
		</td>
		<td width="98%"><a  href="##" tabindex="-1"><img id="Mimagen#Attributes.codigo#" src="/cfmx/rh/imagenes/Description.gif" alt="Lista de #titulo#" name="SNimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlis#Attributes.codigo#();'></a></td>
		<input type="hidden" name="#Attributes.id#" id="#Attributes.id#" value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).id)#</cfif>">
	</tr>
	</cfoutput>
	
  </table>
<iframe id="<cfoutput>frame#Attributes.codigo#</cfoutput>" name="<cfoutput>frame#Attributes.codigo#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>