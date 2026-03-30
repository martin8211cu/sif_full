<!--- 
	Creado por Gustavo Fonseca Hernández.
	Fecha: 8-6-2005.
	Motivo: Creación del tag para los beneficiarios.
 --->


<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 			default="#Session.DSN#"		type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 				default="form1" 			type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 				default="" 					type="string"> <!--- consulta por defecto --->
<cfparam name="Attributes.TESBeneficiario" 		default="TESBeneficiario" 	type="string"> <!--- Nombres del Beneficiario --->
<cfparam name="Attributes.TESBeneficiarioId"	default="TESBeneficiarioId"	type="string"> <!--- Identificacion del Beneficiario --->
<cfparam name="Attributes.frame" 				default="frbeneficiarios"	type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.FuncJSalAbrir" 		default="" 					type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"		default="" 					type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" 			default="" 					type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 				default="30" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.conlis" 				default="true" 				type="boolean"> <!--- Bandera para pintar o no la imagencilla que abre el conlis y permitir editar el codigo --->
<cfparam name="Attributes.modificable" default="true" type="boolean"> <!--- Parámetros para impedir la modificación del dato --->

<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery))>
	<cfset queryName = "rsSocio_#trim(Attributes.TESBeneficiario)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select TESBeneficiarioId, TESBeneficiarioId, TESBeneficiario
		from TESbeneficiario 
		where CEcodigo = <cfqueryparam value="#Session.CEcodigo#" cfsqltype="cf_sql_integer">
		  and TESBeneficiarioId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.idquery#">
	</cfquery>
</cfif>
<!--- query --->

<script language="JavaScript">
var popUpWinSN=0;
function popUpWindow<cfoutput>#Attributes.TESBeneficiarioId#</cfoutput>(URLStr, left, top, width, height){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
  	}
  	popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp<cfoutput>#Attributes.TESBeneficiarioId#</cfoutput>;
}
function closePopUp<cfoutput>#Attributes.TESBeneficiarioId#</cfoutput>(){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
		popUpWinSN=null;
  	}
}
function doConlisBeneficiario<cfoutput>#Attributes.TESBeneficiarioId#</cfoutput>() {
	<cfif Attributes.modificable>
			<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
			var params ="";
			params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.TESBeneficiarioId#&codigo=#Attributes.TESBeneficiarioId#&desc=#Attributes.TESBeneficiario#</cfoutput>";
			<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0> 
				params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
			</cfif>	
		
			popUpWindow<cfoutput>#Attributes.TESBeneficiarioId#</cfoutput>("/cfmx/sif/Utiles/ConlisBeneficiarios.cfm"+params,250,200,650,400);
	</cfif>
}

function TraeBeneficiario<cfoutput>#Attributes.TESBeneficiarioId#</cfoutput>(codigo) {
	<cfif Attributes.modificable>
			var params ="";
			params = "<cfoutput>&id=#Attributes.TESBeneficiarioId#&desc=#Attributes.TESBeneficiario#&numero=#Attributes.TESBeneficiarioId#</cfoutput>";
			<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0> 
				params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
			</cfif>	
			
			if (codigo!="") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/sif/Utiles/sifbeneficiariosquery.cfm?codigo="+codigo+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
			
				<!--- document.getElementById["<cfoutput>#Attributes.frame#</cfoutput>"].src= --->
			}
			else{
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.TESBeneficiarioId#</cfoutput>.value = '';
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>B#Attributes.TESBeneficiarioId#</cfoutput>.value = '';
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.TESBeneficiario#</cfoutput>.value = '';
			}
			return;
	</cfif>
}

<!---  --->
function funcSQL<cfoutput>#Attributes.TESBeneficiarioId#</cfoutput>(codigo, desc) {
	<cfif Attributes.modificable> 
			var paramsB ="";
			paramsB = "<cfoutput>&id=#Attributes.TESBeneficiarioId#&numero=#Attributes.TESBeneficiarioId#</cfoutput>";
			
			
			if (codigo!="" && desc!="") { 
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/sif/Utiles/sifbeneficiariosinsertquery.cfm?codigo="+codigo+"&desc="+desc+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+paramsB;
			
			}
			 else{
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.TESBeneficiarioId#</cfoutput>.value = '';
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>B#Attributes.TESBeneficiarioId#</cfoutput>.value = '';
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.TESBeneficiario#</cfoutput>.value = '';
			
			}
			return;
</cfif>
}
<!---  --->

</script>
<!---
 --->
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
	<tr>
		<td nowrap width="1%">
			<input 
				type="text" 
				name="#Attributes.TESBeneficiarioId#" 
				id="#Attributes.TESBeneficiarioId#" 
				maxlength="30" 
				size="10" 
				<cfif not Attributes.modificable>
					disabled
				</cfif>
				onblur="javascript:TraeBeneficiario#Attributes.TESBeneficiarioId#(document.#Attributes.form#.#Attributes.TESBeneficiarioId#.value);" 
				onfocus="this.select()"	
				<cfif isdefined("Attributes.conlis") and Attributes.conlis EQ false>
					readonly="true"
				</cfif>
				tabindex="#Attributes.tabindex#"
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).TESBeneficiarioId)#</cfif>">
		</td>
		<td nowrap width="1%">
			<input tabindex="-1" type="text" name="#Attributes.TESBeneficiario#" id="#Attributes.TESBeneficiario#" maxlength="255" onblur="javascript:funcSQL#Attributes.TESBeneficiarioId#(document.#Attributes.form#.#Attributes.TESBeneficiarioId#.value, document.#Attributes.form#.#Attributes.TESBeneficiario#.value);"  size="#Attributes.size#" disabled 
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).TESBeneficiario)#</cfif>">
		</td>
		<td width="98%">
			
			<cfif isdefined("Attributes.conlis") and Attributes.conlis EQ true>
				&nbsp;<a  href="##" tabindex="-1"><img id="SNimagen" class="imgIconConlist" alt="Lista de Beneficiarios" name="SNimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisBeneficiario#Attributes.TESBeneficiarioId#();'></a>
			</cfif>
		</td>
		<input type="hidden" name="B#Attributes.TESBeneficiarioId#" id="B#Attributes.TESBeneficiarioId#" value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).TESBeneficiarioId)#</cfif>">
	</tr>
	</cfoutput>
	
  </table>
<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>