<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 			default="#Session.DSN#"		type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 				default="form1" 			type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 				default="" 					type="string"> <!--- id de registro para desplegar --->
<cfparam name="Attributes.id" 					default="RHMPPid" 			type="string"> <!--- Nombres del id de la pp --->
<cfparam name="Attributes.codigo" 				default="RHMPPcodigo"		type="string"> <!--- Nombres del codigo de la pp --->
<cfparam name="Attributes.descripcion" 			default="RHMPPdescripcion" 	type="string"> <!--- Nombres de la descripcion de la pp --->
<cfparam name="Attributes.frame" 				default="frpp"	 			type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.FuncJSalAbrir" 		default="" 					type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"		default="" 					type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" 			default="" 					type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 				default="25" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.conlis" 				default="true" 				type="boolean"> <!--- Bandera para pintar o no la imagencilla que abre el conlis y permitir editar el codigo --->
<cfparam name="Attributes.modificable" 			default="true" 				type="boolean"><!--- Parámetros para impedir la modificación del dato --->
<cfparam name="Attributes.categoria" 			default="RHCid" 			type="string"><!--- Nombre del campo de la categoria --->
<cfparam name="Attributes.tablasalarial" 		default="RHTTid" 			type="string"><!--- Nombre del campo de la tabla salarial --->
<cfparam name="Attributes.empresa" 				default="#Session.Ecodigo#" type="string">	<!--- Empresa a la que pertenecen los puestos --->
<cfparam name="Attributes.ValidaCatPuesto" 		default="false" 			type="boolean"><!--- Indica si requiere validar la existencia del puesto en Categorias Puesto --->

<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery))>
	<cfset queryName = "rsPP_#trim(Attributes.descripcion)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select  distinct u.RHMPPid as id, 
				   u.RHMPPcodigo as codigo,
				   u.RHMPPdescripcion as descripcion,
				   t.RHCid,
				   t.RHCdescripcion,
				   t.RHCcodigo
				 
		from RHMontosCategoria a 
		
		inner join RHVigenciasTabla b 
		on b.RHVTid = a.RHVTid 
		
		
		inner join ComponentesSalariales c 
		on c.CSid = a.CSid 
		
		left outer join RHCategoriasPuesto r 
		on r.RHCPlinea = a.RHCPlinea 
		
		left outer join RHTTablaSalarial s 
		on s.RHTTid = r.RHTTid 
		
		left outer join RHCategoria t 
			inner join RHSolicitudPlaza sp
			on sp.RHCid=t.RHCid			
		on t.RHCid = r.RHCid 
		
		left outer join RHMaestroPuestoP u 
		on u.RHMPPid = r.RHMPPid 

		where u.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#" >
		and u.RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idquery#">
		and sp.RHSPid=#form.RHSPid#	
		
	</cfquery>
	<!---	select RHMPPid as id, RHMPPcodigo as codigo, RHMPPdescripcion as descripcion,c.RHCid,c.RHCdescripcion,c.RHCcodigo
		from RHMaestroPuestoP p
		inner join RHCategoria c
		on p.RHCid=c.RHCid
		where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.empresa#" >
		  and RHMPPid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idquery#">--->
</cfif>
	<cfquery name="valPlan" datasource="#session.dsn#">
		select Pvalor from RHParametros where Pcodigo=540
	</cfquery>
<!--- query --->

<script language="JavaScript">
var popUpWinPP=0;
function popUpWindow<cfoutput>#Attributes.codigo#</cfoutput>(URLStr, left, top, width, height){
	if(popUpWinPP) {
		if(!popUpWinPP.closed) popUpWinPP.close();
  	}
  	popUpWinPP = open(URLStr, 'popUpWinPP', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp<cfoutput>#Attributes.codigo#</cfoutput>;
}
function closePopUp<cfoutput>#Attributes.codigo#</cfoutput>(){
	if(popUpWinPP) {
		if(!popUpWinPP.closed) popUpWinPP.close();
		popUpWinPP=null;
  	}
}
function doConlis<cfoutput>#Attributes.codigo#</cfoutput>() {
	<cfif Attributes.modificable>
			<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
			var params ="";
			params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.id#&codigo=#Attributes.codigo#&desc=#Attributes.descripcion#&empresa=#Attributes.empresa#</cfoutput>";
			<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0> 
				params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
			</cfif>	
			<cfif attributes.ValidaCatPuesto>
			<cfoutput>
				if (document.#attributes.form#.#attributes.tablasalarial#.value != '' ) {
					params = params + '&RHTTid=' + document.#attributes.form#.#attributes.tablasalarial#.value;
				}
				/*if (document.#attributes.form#.#attributes.categoria#.value != '' ) {
					params = params + '&RHCid=' + document.#attributes.form#.#attributes.categoria#.value;
				}*/
			</cfoutput>			
			</cfif>
			popUpWindow<cfoutput>#Attributes.codigo#</cfoutput>("/cfmx/rh/Utiles/conlisMaestroPuestosCat.cfm"+params,250,200,650,400);
	</cfif>
}

function TraeDatos<cfoutput>#Attributes.codigo#</cfoutput>(codigo) {
	<cfif Attributes.modificable>
			<cfoutput>
			if (window.func#Attributes.codigo#) {window.func#Attributes.codigo#()}		
			</cfoutput>
			var params ="";
			params = "<cfoutput>&id=#Attributes.id#&desc=#Attributes.descripcion#&codigo=#Attributes.codigo#&empresa=#Attributes.empresa#</cfoutput>";
			<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0> 
				params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
			</cfif>	
			
			<cfif attributes.ValidaCatPuesto>
			<cfoutput>
				if (document.#attributes.form#.#attributes.tablasalarial#.value != '' ){
					params = params + '&RHTTid=' + document.#attributes.form#.#attributes.tablasalarial#.value;
				}
							
				
				/*if ( document.#attributes.form#.#attributes.categoria#.value != '' ){
					params = params + '&RHCid=' + document.#attributes.form#.#attributes.categoria#.value;
				}
			*/
			</cfoutput>			
			</cfif>
			
			if (codigo!="") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/rh/Utiles/rhmaestropuestosquery.cfm?dato="+codigo+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
			}
			else{
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.id#</cfoutput>.value = '';
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.codigo#</cfoutput>.value = '';
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.descripcion#</cfoutput>.value = '';
				document.<cfoutput>#Attributes.form#</cfoutput>.LvarCid.value='';	
				document.<cfoutput>#Attributes.form#</cfoutput>.LvarPid.value='';		
				document.<cfoutput>#Attributes.form#</cfoutput>.LvarPuesto.value='';
				document.<cfoutput>#Attributes.form#</cfoutput>.LvarCat.value='';
			}
			return;
	</cfif>
}
</script>

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
	<tr>
		<td nowrap width="1%">
			<input 
				type="text" 
				name="#Attributes.codigo#" 
				id="#Attributes.codigo#" 
				maxlength="15" 
				size="10" 
				<cfif not Attributes.modificable>
					disabled
				</cfif>
				onblur="javascript:TraeDatos#Attributes.codigo#(document.#Attributes.form#.#Attributes.codigo#.value);" 
				onfocus="this.select()"	
				<cfif isdefined("Attributes.conlis") and Attributes.conlis EQ false>
					readonly="true"
				</cfif>
				tabindex="#Attributes.tabindex#"
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).codigo)#</cfif>">
		</td>
		<td nowrap width="1%">
			<input tabindex="-1" type="text" name="#Attributes.descripcion#" id="#Attributes.descripcion#" maxlength="255" size="#Attributes.size#" disabled 
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).descripcion)#</cfif>">
		</td>
		<td width="98%">
			
			<cfif isdefined("Attributes.conlis") and Attributes.conlis EQ true>
				&nbsp;<a  href="##" tabindex="-1"><img id="img#Attributes.codigo#" src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Plazas Presupuestarias" name="SNimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlis#Attributes.codigo#();'></a>
			</cfif>
		</td>
		<input type="hidden" name="#Attributes.id#" id="#Attributes.id#" value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).id)#</cfif>">
	</tr>
	
	</cfoutput>
	
  </table>
	<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>