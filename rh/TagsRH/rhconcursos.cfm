<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 			default="" 				type="string"> <!--- consulta por defecto --->
<cfparam name="Attributes.RHCconcurso" 		default="RHCconcurso" 	type="string"> <!--- Nombres del código del socio --->
<cfparam name="Attributes.RHCcodigo" 		default="RHCcodigo" 	type="string"> <!--- Nombres de la descripción del socio --->
<cfparam name="Attributes.RHCdescripcion" 	default="RHCdescripcion" type="string"> <!--- Nombres de la identificación del socio Ej: 9-089-679 --->
<cfparam name="Attributes.frame" 			default="frame"			type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="30"			type="string"> <!--- Tabindex del campo editable --->

<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery))>
	<cfset queryName = "rsConcurso_#trim(Attributes.RHCcodigo)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select RHCconcurso, RHCcodigo, RHCdescripcion
		from RHConcursos 
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and RHCconcurso=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idquery#">
	</cfquery>
</cfif>
<!--- query --->

<script language="JavaScript">
var popUpWinSN=0;
function popUpWindow<cfoutput>#Attributes.RHCcodigo#</cfoutput>(URLStr, left, top, width, height){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
  	}
  	popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp<cfoutput>#Attributes.RHCcodigo#</cfoutput>;
}
function closePopUp<cfoutput>#Attributes.RHCcodigo#</cfoutput>(){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
		popUpWinSN=null;
  	}
}
function doConlisConcurso<cfoutput>#Attributes.RHCcodigo#</cfoutput>() {
	var params ="";
	params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.RHCconcurso#&codigo=#Attributes.RHCcodigo#&desc=#Attributes.RHCdescripcion#</cfoutput>";

	popUpWindow<cfoutput>#Attributes.RHCcodigo#</cfoutput>("/cfmx/rh/Utiles/conlisConcursos.cfm"+params,250,200,650,400);
}

function TraeConcurso<cfoutput>#Attributes.RHCcodigo#</cfoutput>(codigo) {
	var params ="";
	params = "<cfoutput>&id=#Attributes.RHCconcurso#&codigo=#Attributes.RHCcodigo#&desc=#Attributes.RHCdescripcion#</cfoutput>";
	
	if (codigo!="") {
	var fr = document.getElementById("<cfoutput>#Attributes.frame##Attributes.RHCcodigo#</cfoutput>");
	fr.src = "/cfmx/rh/Utiles/rhconcursosquery.cfm?valor="+codigo+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
	}
	else{
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.RHCconcurso#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.RHCcodigo#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.RHCdescripcion#</cfoutput>.value = '';
	}
	return;
}
</script>

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
	<tr>
		<td nowrap width="1%">
			<input 
				type="text" 
				name="#Attributes.RHCcodigo#" 
				id="#Attributes.RHCcodigo#" 
				maxlength="15" 
				size="10" 
				onblur="javascript:TraeConcurso#Attributes.RHCcodigo#(document.#Attributes.form#.#Attributes.RHCcodigo#.value);" 
				onfocus="this.select()"	
				<cfif isdefined("Attributes.conlis") and Attributes.conlis EQ false>
					readonly="true"
				</cfif>
				tabindex="#Attributes.tabindex#"
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).RHCcodigo)#</cfif>">
		</td>
		<td nowrap width="1%">
			<input tabindex="-1" type="text" name="#Attributes.RHCdescripcion#" id="#Attributes.RHCdescripcion#" maxlength="255" size="#Attributes.size#" disabled 
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).RHCdescripcion)#</cfif>">
		</td>
		<td width="98%"><a  href="##" tabindex="-1"><img id="SNimagen" src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Concursos" name="SNimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisConcurso#Attributes.RHCcodigo#();'></a></td>
		<input type="hidden" name="#Attributes.RHCconcurso#" id="#Attributes.RHCconcurso#" value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).RHCconcurso)#</cfif>">
	</tr>
	</cfoutput>
	
  </table>
<iframe id="<cfoutput>#Attributes.frame##Attributes.RHCcodigo#</cfoutput>" name="<cfoutput>#Attributes.frame##Attributes.RHCcodigo#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>