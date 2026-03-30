<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 			default="" 				type="string"> <!--- consulta por defecto --->
<cfparam name="Attributes.id_menu" 			default="id_menu"	 		type="string"> <!--- Nombres del código de la maquina --->
<cfparam name="Attributes.id_root" 			default="id_root"	 	type="string"> <!--- Nombres del código de la maquina --->
<cfparam name="Attributes.Ecodigo" 			default="Ecodigo"	 	type="string"> <!--- Nombres del código de la maquina --->
<cfparam name="Attributes.nombre_menu" 		default="nombre_menu" type="string"> <!--- Nombres de la descripción de la maquina --->
<cfparam name="Attributes.descripcion_menu" default="descripcion_menu" type="string"> <!--- Nombres de la descripción de la maquina --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="30" 			type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.excluir" 			default="" 				type="string">
<cfparam name="Attributes.FuncJSalAbrir" 	default="" 				type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" 				type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.frame" 			default="frOMenu" 		type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.SScodigo"  		default="" 				type="string">
<cfparam name="Attributes.SRcodigo"  		default="" 				type="string">


<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >
	<cfset queryName = "rsMenus_#trim(Attributes.id_menu)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select id_menu, nombre_menu, orden_menu, case when ocultar_menu=1 then 'X' else ' ' end as ocultar_x
		from SMenu
		where 1=1
		and id_menu = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idquery#">
	</cfquery>
</cfif>
<!--- query --->

<script language="JavaScript">
	<!--//
	var popUpWinSN<cfoutput>#Attributes.id_menu#</cfoutput>=0;
	function popUpWindow<cfoutput>#Attributes.id_menu#</cfoutput>(URLStr, left, top, width, height){
		if(popUpWinSN<cfoutput>#Attributes.id_menu#</cfoutput>) {
			if(!popUpWinSN<cfoutput>#Attributes.id_menu#</cfoutput>.closed) popUpWinSN<cfoutput>#Attributes.id_menu#</cfoutput>.close();
		}
		popUpWinSN<cfoutput>#Attributes.id_menu#</cfoutput> = open(URLStr, 'popUpWinSN<cfoutput>#Attributes.id_menu#</cfoutput>', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		window.onfocus = closePopUp<cfoutput>#Attributes.id_menu#</cfoutput>;
	}
	function closePopUp<cfoutput>#Attributes.id_menu#</cfoutput>(){
		if(popUpWinSN<cfoutput>#Attributes.id_menu#</cfoutput>) {
			if(!popUpWinSN<cfoutput>#Attributes.id_menu#</cfoutput>.closed) popUpWinSN<cfoutput>#Attributes.id_menu#</cfoutput>.close();
			popUpWinSN<cfoutput>#Attributes.id_menu#</cfoutput>=null;
		}
	}
	function doConlisMenus<cfoutput>#Attributes.id_root#</cfoutput>() {
		<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
		var params ="";
		params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.id_menu#&codigo=#Attributes.id_root#&desc=#Attributes.nombre_menu#&excluir=#Attributes.excluir#&SScodigo=#Attributes.SScodigo#&SRcodigo=#Attributes.SRcodigo#</cfoutput>";
		<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
			params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
		</cfif>	
		popUpWindow<cfoutput>#Attributes.id_menu#</cfoutput>("ConlisMenus.cfm"+params,250,200,650,400);
		
	}
	function TraeMenus<cfoutput>#Attributes.id_root#</cfoutput>(valor) {
		var params ="";
		params = "<cfoutput>&id=#Attributes.id_menu#&desc=#Attributes.nombre_menu#&codigo=#Attributes.id_root#&excluir=#Attributes.excluir#&frame=#Attributes.frame#&SScodigo=#Attributes.SScodigo#&SRcodigo=#Attributes.SRcodigo#</cfoutput>";
		
		<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
			params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
		</cfif>	
	
		if (valor!='') {
			document.all["<cfoutput>#Attributes.frame#</cfoutput>"].src="sifMenusquery.cfm?valor="+valor+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
		
		}
		else{
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.id_menu#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.id_root#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.nombre_menu#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.SScodigo#</cfoutput>.value = '';
		}
		
		<cfoutput>
			if (window.func#Attributes.id_root#) {
				window.func#Attributes.id_root#()
			}
		</cfoutput>	
	
		return;
	}
	//-->
</script>
<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js">//</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<cfoutput>
<tr>
	<td nowrap width="1%">
		<input tabindex="#Attributes.tabindex#"
		type="text" name="#Attributes.id_root#" id="#Attributes.id_root#"
		maxlength="9" size="10" style="text-align: right;" 
		onBlur="javascript: fm(this,-1); TraeMenus#Attributes.id_root#(document.#Attributes.form#.#Evaluate('Attributes.id_root')#.value);" 
		onFocus="javascript: this.select(); this.value=qf(this);"  
		onKeyUp="javascript: if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
		value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).id_root)#</cfif>">
   </td>
   <td nowrap width="1%">
		<input tabindex="-1" type="text" name="#Attributes.nombre_menu#" id="#Attributes.nombre_menu#" maxlength="50" size="#Attributes.size#" disabled 
		value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).nombre_menu)#</cfif>">
	</td>
	<td width="98%">
		<a  href="##" tabindex="-1"><img id="id_root" src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Transacciones de Depósito" name="BidImagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisMenus#Attributes.id_root#();'></a>
	</td>
	<input type="hidden" name="#Attributes.id_menu#" id="#Attributes.id_menu#" 
	value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).id_menu)#</cfif>">
</tr>
</table>
</cfoutput>
<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>


