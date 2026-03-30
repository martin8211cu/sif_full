<!--- Parmetros del TAG --->
<!--- se usa en sociosdgenerales para obtener el padre --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexin --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 			default="" 				type="string">  <!--- consulta por defecto --->
<cfparam name="Attributes.SNcodigo" 		default="SNcodigo" 		type="string"> <!--- Nombres del cdigo del socio --->
<cfparam name="Attributes.SNnombre" 		default="SNnombre" 		type="string"> <!--- Nombres de la descripcin del socio --->
<cfparam name="Attributes.SNnumero" 		default="SNnumero" 		type="string"> <!--- Nombres de la identificacin del socio Ej: 9-089-679 --->
<cfparam name="Attributes.SNtiposocio" 		default="" 				type="string"> <!--- Si es proveedor (no clientes)  si es cliente (no proveedor) --->
<cfparam name="Attributes.GSNid" 			default="0"				type="string"> <!--- Define si hay un input GSNid en el form. Si es parte de un Grupo de Socio de Negocios --->
<cfparam name="Attributes.frame" 			default="frsocios" 		type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.FuncJSalAbrir" 	default="" 				type="string"> <!--- funcin .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" 				type="string"> <!--- funcin .js despus de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="30" 			type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.conlis" 			default="true" 			type="boolean"> <!--- Bandera para pintar o no la imagencilla que abre el conlis y permitir editar el codigo --->
<cfparam name="Attributes.excepto"                                                ><!--- SNid por evitar, por ser yo mismo --->

<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >
	<cfset queryName = "rsSocio_#trim(Attributes.SNnombre)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select SNcodigo, SNnumero, SNnombre, GSNid
		from SNegocios 
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.idquery#">
		  <cfif Len(Attributes.excepto)>
	      and SNid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.excepto#">
		  </cfif>
		<cfif isdefined("Attributes.SNtiposocio") and len(trim(Attributes.SNtiposocio))>
			<cfif Attributes.SNtiposocio neq 'A'>
				and SNtiposocio in ('A', '#Attributes.SNtiposocio#')
			<cfelse>
				and SNtiposocio = 'A'
			</cfif>
		</cfif> 
		<!--- no quito el query para mostrar los datos aunque estén "malos", ie, el padre tenga padre --->
		and SNidPadre is null 
	</cfquery>
</cfif>
<!--- query --->

<cfset socios = "Socios de Negocios">
<cfif Attributes.SNtiposocio eq "P">
	<cfset socios = "Proveedores">
<cfelseif Attributes.SNtiposocio eq "C">
	<cfset socios = "Clientes">
</cfif>

<script language="JavaScript">
var popUpWinSN=0;
function popUpWindow(URLStr, left, top, width, height){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
  	}
  	popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp;
}
function closePopUp(){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
		popUpWinSN=null;
  	}
}
function doConlisSocio<cfoutput>#Attributes.SNcodigo#</cfoutput>() {
	<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
	var params ="";
	params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.SNcodigo#&codigo=#Attributes.SNnumero#&desc=#Attributes.SNnombre#&tipo=#Attributes.SNtiposocio#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	

	<cfif Attributes.GSNid eq 1>
		params = params + "&GSNid="+document.<cfoutput>#Attributes.form#</cfoutput>.GSNid.value;
	</cfif>
	params = params + "&excepto=<cfoutput>#JSStringFormat(NumberFormat(Attributes.excepto,'0'))#</cfoutput>";
	popUpWindow("/cfmx/sif/Utiles/ConlisSociosRelac.cfm"+params,250,200,650,400);
}

function TraeSocio<cfoutput>#Attributes.SNcodigo#</cfoutput>(codigo) {
	var params ="";
	params = "<cfoutput>&id=#Attributes.SNcodigo#&desc=#Attributes.SNnombre#&numero=#Attributes.SNnumero#&tipo=#Attributes.SNtiposocio#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	
	
	<cfif Attributes.GSNid eq 1>
		params = params + "&GSNid="+document.<cfoutput>#Attributes.form#</cfoutput>.GSNid.value;
	</cfif>
	params = params + "&excepto=<cfoutput>#JSStringFormat(NumberFormat(Attributes.excepto,'0'))#</cfoutput>";
	if (codigo!="") {
		document.all["<cfoutput>#Attributes.frame#</cfoutput>"].src="/cfmx/sif/Utiles/sifsocios_relac_query.cfm?codigo="+codigo+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
	}
	else{
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.SNcodigo#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.SNnumero#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.SNnombre#</cfoutput>.value = '';
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
				name="#Attributes.SNnumero#" 
				id="#Attributes.SNnumero#" 
				maxlength="15" 
				size="10" 
				onblur="javascript:TraeSocio#Attributes.SNcodigo#(document.#Attributes.form#.#Attributes.SNnumero#.value);" 
				onfocus="this.select()"	
				<cfif isdefined("Attributes.conlis") and Attributes.conlis EQ false>
					readonly="true"
				</cfif>
				tabindex="#Attributes.tabindex#"
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).SNnumero)#</cfif>">
		</td>
		<td nowrap width="1%">
			<input tabindex="-1" type="text" name="#Attributes.SNnombre#" id="#Attributes.SNnombre#" maxlength="255" size="#Attributes.size#" disabled 
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).SNnombre)#</cfif>">
		</td>
		<td width="98%">
			
			<cfif isdefined("Attributes.conlis") and Attributes.conlis EQ true>
				&nbsp;<a  href="##" tabindex="-1"><img id="SNimagen" src="/cfmx/sif/imagenes/Description.gif" alt="Lista de #socios#" name="SNimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisSocio#Attributes.SNcodigo#();'></a>
			</cfif>
		</td>
		<input type="hidden" name="#Attributes.SNcodigo#" id="#Attributes.SNcodigo#" value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).SNcodigo)#</cfif>">
		<input type="hidden" name="#Attributes.GSNid#" id="#Attributes.GSNid#" 
		value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).GSNid)#</cfif>">
	</tr>
	</cfoutput>
	
  </table>
<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>