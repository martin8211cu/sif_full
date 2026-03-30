<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 			default="" 				type="string">  <!--- consulta por defecto --->
<cfparam name="Attributes.Mcodigo" 			default="Mcodigo" 		type="string"> <!--- Codigo de la materia --->
<cfparam name="Attributes.Mnombre" 			default="Mnombre" 		type="string"> <!--- Nombre de la materia --->
<cfparam name="Attributes.Msiglas" 			default="Msiglas" 		type="string"> <!--- Siglas de la materia --->
<cfparam name="Attributes.frame" 			default="frsocios" 		type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="50" 			type="string"> <!--- Tabindex del campo editable --->

<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >
	<cfset queryName = "rsMateria_#trim(Attributes.Mcodigo)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select Mcodigo, Mnombre, Msiglas
		from RHMateria
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idquery#">
	</cfquery>
</cfif>
<!--- query --->

<cfset titulo = "Cursos">

<script language="JavaScript">
var popUpWinSN<cfoutput>#Attributes.Mcodigo#</cfoutput>=0;
function popUpWindow<cfoutput>#Attributes.Mcodigo#</cfoutput>(URLStr, left, top, width, height){
	if(popUpWinSN<cfoutput>#Attributes.Mcodigo#</cfoutput>) {
		if(!popUpWinSN<cfoutput>#Attributes.Mcodigo#</cfoutput>.closed) popUpWinSN<cfoutput>#Attributes.Mcodigo#</cfoutput>.close();
  	}
  	popUpWinSN<cfoutput>#Attributes.Mcodigo#</cfoutput> = open(URLStr, 'popUpWinSN<cfoutput>#Attributes.Mcodigo#</cfoutput>', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp<cfoutput>#Attributes.Mcodigo#</cfoutput>;
}
function closePopUp<cfoutput>#Attributes.Mcodigo#</cfoutput>(){
	if(popUpWinSN<cfoutput>#Attributes.Mcodigo#</cfoutput>) {
		if(!popUpWinSN<cfoutput>#Attributes.Mcodigo#</cfoutput>.closed) popUpWinSN<cfoutput>#Attributes.Mcodigo#</cfoutput>.close();
		popUpWinSN<cfoutput>#Attributes.Mcodigo#</cfoutput>=null;
  	}
}
function doConlisMaterias<cfoutput>#Attributes.Mcodigo#</cfoutput>() {
	var params ="";
	params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.Mcodigo#&desc=#Attributes.Mnombre#&siglas=#Attributes.Msiglas#</cfoutput>";
	popUpWindow<cfoutput>#Attributes.Mcodigo#</cfoutput>("/cfmx/sif/Utiles/ConlisMaterias.cfm"+params,250,200,650,400);
}

function TraeMateria<cfoutput>#Attributes.Mcodigo#</cfoutput>(codigo) {
	var params ="";
	params = "<cfoutput>&id=#Attributes.Mcodigo#</cfoutput>";
	if (codigo!="") {
		document.getElementById('<cfoutput>frame#Attributes.Mcodigo#</cfoutput>').src = "../../../Utiles/conlisMaterias-query.cfm?codigo="+codigo+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
		//document.all["<cfoutput>#Attributes.frame#</cfoutput>"].src="/cfmx/sif/Utiles/conlisMaterias-query.cfm?codigo="+codigo+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
	}
	else{
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Msiglas#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Mcodigo#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Mnombre#</cfoutput>.value = '';
	}
	return;
}
</script>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
	<tr>
		<td width="7%"> 
			<input 
				type="text" 
				name="#Attributes.Msiglas#" 
				id="#Attributes.Msiglas#" 
				maxlength="15" 
				size="10" 
				onblur="javascript: TraeMateria#Attributes.Mcodigo#(this.value);" 
				onfocus="this.select()"	
				tabindex="#Attributes.tabindex#"
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).Mcodigo)#</cfif>">
		</td>
		<td nowrap width="1%">
			<input tabindex="-1" type="text" name="#Attributes.Mnombre#" id="#Attributes.Mnombre#" maxlength="255" size="#Attributes.size#" disabled 
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).Mnombre)#</cfif>">
		</td>
		<td width="98%"><a  href="##" tabindex="-1"><img id="Mimagen#Attributes.Mcodigo#" src="/cfmx/sif/imagenes/Description.gif" alt="Lista de #titulo#" name="SNimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisMaterias#Attributes.Mcodigo#();'></a></td>
		<input type="hidden" name="#Attributes.Mcodigo#" id="#Attributes.Mcodigo#" value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).Mcodigo)#</cfif>">
	</tr>
	</cfoutput>
  </table>
<iframe id="<cfoutput>frame#Attributes.Mcodigo#</cfoutput>" name="<cfoutput>frame#Attributes.Mcodigo#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>