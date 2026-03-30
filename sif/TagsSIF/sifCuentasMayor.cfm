<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 			default="" 				type="string"> <!--- consulta por defecto --->
<cfparam name="Attributes.Cmayor" 			default="Cmayor" 		type="string"> <!--- Nombres del código  --->
<cfparam name="Attributes.Ecodigo" 			default="Ecodigo"	 	type="string"> <!--- Nombres del código  --->
<cfparam name="Attributes.Cdescripcion" 	default="Cdescripcion" 	type="string"> <!--- Nombres de la  --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="30" 			type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.FuncJSalAbrir" 	default="" 				type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" 				type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.frame" 			default="frOficina" 	type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.cargar_mascara" 	default="" 				type="string"> <!--- Nombre del campo de Mascara (PCEMid), si no viene en blanco, significa que se quiere cargar la mascara --->
<cfparam name="Attributes.Ctipos" 			default="" 				type="string"> <!--- indica si filtra por tipo --->

<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >
	<cfset queryName = "rsCuentasMayor_#trim(Attributes.Cmayor)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select Cmayor, Cdescripcion
		from CtasMayor
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Attributes.idquery#">
        <cfif Attributes.Ctipos NEQ "">
        	and Ctipo in (<cfqueryparam cfsqltype="cf_sql_char" value="#attributes.Ctipos#" list="yes">)
        </cfif>
	</cfquery>
</cfif>
<!--- query --->

<script language="JavaScript">
	<!--//
	var popUpWinSN<cfoutput>#Attributes.Cmayor#</cfoutput>=0;
	function popUpWindow<cfoutput>#Attributes.Cmayor#</cfoutput>(URLStr, left, top, width, height){
		if(popUpWinSN<cfoutput>#Attributes.Cmayor#</cfoutput>) {
			if(!popUpWinSN<cfoutput>#Attributes.Cmayor#</cfoutput>.closed) popUpWinSN<cfoutput>#Attributes.Cmayor#</cfoutput>.close();
		}
		popUpWinSN<cfoutput>#Attributes.Cmayor#</cfoutput> = open(URLStr, 'popUpWinSN<cfoutput>#Attributes.Cmayor#</cfoutput>', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		window.onfocus = closePopUp<cfoutput>#Attributes.Cmayor#</cfoutput>;
	}
	function closePopUp<cfoutput>#Attributes.Cmayor#</cfoutput>(){
		if(popUpWinSN<cfoutput>#Attributes.Cmayor#</cfoutput>) {
			if(!popUpWinSN<cfoutput>#Attributes.Cmayor#</cfoutput>.closed) popUpWinSN<cfoutput>#Attributes.Cmayor#</cfoutput>.close();
			popUpWinSN<cfoutput>#Attributes.Cmayor#</cfoutput>=null;
		}
	}
	function doConlisCuentasMayor<cfoutput>#Attributes.Cmayor#</cfoutput>() {
		<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
		var params ="";
		params = "<cfoutput>?formulario=#Attributes.form#&codigo=#Attributes.Cmayor#&desc=#Attributes.Cdescripcion#&tipo=#Attributes.Ctipos#</cfoutput>";
		<cfif Len(Trim(Attributes.cargar_mascara))>
			params = params+"&cargar_mascara=<cfoutput>#Attributes.cargar_mascara#</cfoutput>";
		</cfif>
		<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
			params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
		</cfif>	
		popUpWindow<cfoutput>#Attributes.Cmayor#</cfoutput>("/cfmx/sif/Utiles/ConlisCuentasMayor.cfm"+params,250,200,650,400);
		
	}
	function TraeCuentasMayor<cfoutput>#Attributes.Cmayor#</cfoutput>(valor) {
		var params ="";
		params = "<cfoutput>&codigo=#Attributes.Cmayor#&desc=#Attributes.Cdescripcion#&tipo=#Attributes.Ctipos#</cfoutput>";
		<!---
		params = "<cfoutput>&id=#Attributes.Cmayor#&desc=#Attributes.Cdescripcion#&codigo=#Attributes.Cmayor#&frame=#Attributes.frame#</cfoutput>";
		--->
		
		<cfif Len(Trim(Attributes.cargar_mascara))>
			params = params+"&cargar_mascara=<cfoutput>#Attributes.cargar_mascara#</cfoutput>";
		</cfif>
		<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
			params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
		</cfif>	
	
		if (valor!='') {
			document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>").src="/cfmx/sif/Utiles/sifCuentasMayorquery.cfm?valor="+valor+"&formulario="+"<cfoutput>#Attributes.form#</cfoutput>"+params;
		}
		else{
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Cmayor#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Cdescripcion#</cfoutput>.value = '';
		}
		
		<cfoutput>
			if (window.func#Attributes.Cmayor#) {
				window.func#Attributes.Cmayor#()
			}
		</cfoutput>	
	
		return;
	}
	//-->
</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<cfoutput>

<tr>
	<td nowrap width="1%">
		<input tabindex="#Attributes.tabindex#"
		type="text" name="#Attributes.Cmayor#" id="#Attributes.Cmayor#"
		maxlength="4" size="6" style="text-align: right;" 
		onBlur="javascript: TraeCuentasMayor#Attributes.Cmayor#(document.#Attributes.form#.#Evaluate('Attributes.Cmayor')#.value);" 
		value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).Cmayor)#</cfif>">
   </td>
   <td nowrap width="1%">
		<input tabindex="-1" type="text" name="#Attributes.Cdescripcion#" id="#Attributes.Cdescripcion#" maxlength="50" size="#Attributes.size#" disabled 
		value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery))>#Trim(Evaluate(queryName).Cdescripcion)#</cfif>">
	</td>
	<td width="98%">
		<a  href="##" tabindex="-1"><img id="Cmayor" src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Cuentas de Mayor" name="BidImagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisCuentasMayor#Attributes.Cmayor#();'></a>
	</td>
</tr>
</table>
</cfoutput>
<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" style="visibility:visible ;"></iframe>
