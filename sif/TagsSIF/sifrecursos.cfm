<cfset def = QueryNew('dato')>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.id" default="PRJRid" type="string"> <!--- Nombre del id --->
<cfparam name="Attributes.name" default="PRJRcodigo" type="string"> <!--- Nombre del Código --->
<cfparam name="Attributes.UcodigoOculto" default="_Ucodigo_#Attributes.id#" type="string"> <!--- Nombre de la Unidad del Artículo --->
<cfparam name="Attributes.frame" default="frrecurso" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.desc" default="PRJRdescripcion" type="string"> <!--- Nombre de la Descripción --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.size" default="30" type="string"> <!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.filtroextra"	default="" type="string"> <!--- filtro adicional para la consulta de Recursos --->

<cfparam name="Attributes.modo"	 default="ALTA" type="string">
<cfparam name="Attributes.dmodo" default="ALTA" type="string">

<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow<cfoutput>#Attributes.name#</cfoutput>(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//Llama el conlis
	function doConlisRecursos<cfoutput>#Attributes.name#</cfoutput>() {
		var params ="";
		params = "<cfoutput>?form=#Attributes.form#&id=#Attributes.id#&name=#Attributes.name#&desc=#Attributes.desc#&filtroextra=#Attributes.filtroextra#&conexion=#Attributes.conexion#&ucodigo_oculto=#Attributes.UcodigoOculto#</cfoutput>";

		<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
			params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
		</cfif>	

		params += "&cmp_unitario=PRJPIcostoUnitario&mod_cant=PRJPIcantidad";
		popUpWindow<cfoutput>#Attributes.name#</cfoutput>("/cfmx/sif/Utiles/ConlisRecursos.cfm"+params,160,200,800,430);
	}
	//Obtiene la descripción con base al código
	function TraeRecursos<cfoutput>#Attributes.name#</cfoutput>(dato) {
		var params ="";
		params = "<cfoutput>&id=#Attributes.id#&name=#Attributes.name#&desc=#Attributes.desc#&filtroextra=#Attributes.filtroextra#&conexion=#Attributes.conexion#&ecodigo=#Session.Ecodigo#&ucodigo_oculto=#Attributes.UcodigoOculto#</cfoutput>";

		<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
			params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
		</cfif>	
		
		params += "&cmp_unitario=PRJPIcostoUnitario&mod_cant=PRJPIcantidad";

		if (dato!="") {			
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/sif/Utiles/sifrecursoquery.cfm?dato="+dato+"&formulario="+"<cfoutput>#Attributes.form#</cfoutput>"+params;
		}
		else{
			document.<cfoutput>#Attributes.form#.#Attributes.id#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.#Attributes.name#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.#Attributes.desc#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#</cfoutput>.PRJPIcostoUnitario.value = '';
			document.<cfoutput>#Attributes.form#</cfoutput>.PRJPIcantidad.value = '';
			document.<cfoutput>#Attributes.form#.#Attributes.name#</cfoutput>.focus();
			if (window.funcExtra<cfoutput>#trim(Attributes.name)#</cfoutput>) {window.funcExtra<cfoutput>#trim(Attributes.name)#</cfoutput>();}
		}

		return;
	}	
</script>
<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset id = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.id')#')#')">
		<cfset name = Trim(Evaluate('Attributes.query.' & Attributes.name))>
		<cfset desc = Trim(Evaluate('Attributes.query.' & Attributes.desc))>
	</cfif>
	<cfoutput>
	<tr>
		<td align="right"><strong>Recurso:&nbsp;</strong></td>
		<td>
			<input type="hidden"
				name="#Attributes.id#" id="#Attributes.id#"
				value="<cfif isdefined('Attributes.query') and  Attributes.query.RecordCount gt 0 and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#id#')#</cfif>" >
				
			<input type="text"
				name="#Attributes.name#" id="#Attributes.name#"
				<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
				value="<cfif isdefined('Attributes.query') and Attributes.query.RecordCount gt 0 and ListLen(Attributes.query.columnList) GT 1>#trim(name)#</cfif>" 
				onBlur="javascript: TraeRecursos#Attributes.name#(document.#Attributes.form#.#Attributes.name#.value);" onFocus="this.select()"
				size="10" 
				maxlength="10"
				<cfif isdefined("Attributes.modo") and Attributes.modo eq 'CAMBIO' and not isdefined("ban")>disabled</cfif>>

		</td>
		<td nowrap>
			<input type="text"
				name="#Attributes.desc#" id="#Attributes.desc#"
				tabindex="-1" disabled
				value="<cfif isdefined('Attributes.query')  and  Attributes.query.RecordCount gt 0 and ListLen(Attributes.query.columnList) GT 1>#desc#</cfif>" 
				size="#Attributes.size#" 
				maxlength="80" >
				<!--- 
				<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Art&iacute;culos" name="img#Attributes.name#" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisRecursos#Attributes.name#();'></a>
				 --->				
				<cfif isdefined("ban")>
					<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Art&iacute;culos" name="img#Attributes.name#" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisRecursos#Attributes.name#();'></a>				
				<cfelse>
					<cfif not isdefined("Attributes.modo")>
						<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Art&iacute;culos" name="img#Attributes.name#" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisRecursos#Attributes.name#();'></a>									
					<cfelse>
						<cfif Attributes.modo neq 'CAMBIO'>
							<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Art&iacute;culos" name="img#Attributes.name#" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisRecursos#Attributes.name#();'></a>															
						</cfif>
					</cfif>
				</cfif>
		</td>
	</tr>
	<tr>
		<td align="right"><strong>Cantidad:&nbsp;</strong></td>
		<td colspan="2">
			<input type="text" 
			name="PRJPIcantidad"
			value="<cfif isdefined('Attributes.query') 
			        and  Attributes.query.RecordCount gt 0 
					and ListLen(Attributes.query.columnList) GT 1>
					      #Attributes.query.PRJPIcantidad#
				   <cfelse>0.00000</cfif>"
			size="20" 
			maxlength="15" 
			style="text-align: right;" 
			onblur="javascript:if (this.value == ''){this.value='1.00';}"
			onfocus="javascript:this.value=qf(this); this.select();"  
			onkeyup="javascript:if(snumber(this,event,5)){ if(Key(event)=='13') {this.blur();}}" 
			tabindex="2">
			<input type="text" disabled tabindex="-1" name="UcodigoProd" id="UcodigoProd" style="border:none; background-color:##FFFFFF"
			value="<cfif isdefined('Attributes.query') 
			        and  Attributes.query.RecordCount gt 0 
					and ListLen(Attributes.query.columnList) GT 1>
					      #Attributes.query.Ucodigo#
				   </cfif>"
			>
		</td>			
	</tr>	
	<tr>
		<td align="right"><strong>Costo Unitario:&nbsp;</strong></td>
		<td nowrap colspan="2">
			<input type="text" name="PRJPIcostoUnitario" 
			value="<cfif isdefined('Attributes.query') 
			        and  Attributes.query.RecordCount gt 0 
					and ListLen(Attributes.query.columnList) GT 1>
					      #LSNumberFormat(Attributes.query.PRJPIcostoUnitario,',9.00000')#
				   <cfelse>0.00000</cfif>"		
			size="20" 
			maxlength="15" 
			style="text-align: right;" 
			onblur="javascript:fm(this,2); "  
			onfocus="javascript:this.value=qf(this); this.select();"  
			onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
			tabindex="2">
		</td>
	</tr>
	</cfoutput>
</table>
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" id="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: ;"></iframe>

