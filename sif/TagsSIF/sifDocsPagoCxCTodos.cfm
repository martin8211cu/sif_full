<!---  
	Modificado por: Ana Villavicencio
	Fecha: 23 de febrero del 2006
	Motivo: Agregar atributo de display en none al iframe del tag
	 		Se corrigió navegacion de tab.
 		   	Se agregó la funcion conlis_keyup, para q funcionara el F2.	
--->

<cfset def = QueryNew('dato')>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" type="String" default=""> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.id" default="SNcodigo2" type="string"> <!--- Nombre del id --->
<cfparam name="Attributes.name" default="Documento" type="string">  <!---Nombre del Documento --->
<cfparam name="Attributes.desc" default="DTM" type="string"> <!--- Nombre de la Descripción --->
<cfparam name="Attributes.GSNid" default="0" type="string"> <!--- Nombre de la Grupo Socio Negogios --->
<cfparam name="Attributes.CCTcodigoConlis" default="CCTcodigoConlis" type="string"> <!--- Ccueta --->
<cfparam name="Attributes.frame" default="frDocsPagoCxC" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.size" default="35" type="string"> <!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.empresa" type="string" default=""> <!--- empresa --->

<cfif len(trim(Attributes.Conexion)) LT 1>
	<cfset Attributes.Conexion = Session.DSN>
</cfif>
<cfif len(trim(Attributes.Empresa)) LT 1>
	<cfset Attributes.Empresa = Session.Ecodigo>
</cfif>

<cfoutput>

<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow#Attributes.name#(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//Llama el conlis
	function doConlisDocsPagoCxC#Attributes.name#(DatoCCTcodigo) {
		var params ="";
		
		params = "&form=#Attributes.form#&CCTcodigoConlis=#Attributes.CCTcodigoConlis#&id=#Attributes.id#&name=#Attributes.name#&desc=#Attributes.desc#&conexion=#Attributes.conexion#&empresa=#Attributes.empresa#&SNcodigo="+document.#Attributes.form#.SNcodigo.value;
		
		<cfif Attributes.GSNid eq 1>
		params = params + "&GSNid="+document.#Attributes.form#.GSNid.value;
		</cfif>
		
		popUpWindow#Attributes.name#("/cfmx/sif/Utiles/ConlisDocsPagoCxCTodos.cfm?DatoCCTcodigo="+DatoCCTcodigo+params,100,50,800,650);
	}
	//funcion para habilitar el F2
	function conlis_keyup_<cfoutput>#Attributes.name#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisDocsPagoCxC#Attributes.name#();
		}
	}
	//Obtiene la descripción con base al código
	function TraeDocsPagoCxC#Attributes.name#(dato) {		
		var params ="";
		var doc = document.#attributes.form#.#attributes.name#.value;
		params = "&id=#Attributes.id#&name=#Attributes.name#&desc=#Attributes.desc#&conexion=#Attributes.conexion#&ecodigo=#Attributes.empresa#&SNcodigo="+document.#Attributes.form#.SNcodigo.value+"&CCTcodigoJss="+document.#Attributes.form#.#Attributes.CCTcodigoConlis#.value+"&DocumentoC="+doc+"&CCTcodigoConlis=#Attributes.CCTcodigoConlis#";
		<cfif Attributes.GSNid eq 1>
		params = params + "&GSNid="+document.#Attributes.form#.GSNid.value;
		</cfif>

		if (dato.value!="") {																																								
			var fr = document.getElementById("#Attributes.frame#");
			fr.src = "/cfmx/sif/Utiles/sifDocsPagoCxCTodosquery.cfm?dato="+dato.value+"&form="+"#Attributes.form#"+params;
			/*fr.src = "/cfmx/sif/Utiles/sifDocsPagoCxCquery.cfm?dato="+dato+"&form="+"#Attributes.form#"+params;*/
		}
		else{			
			limpiarDocsPagoCxC();
		}
		return;
	}
	function limpiarDocsPagoCxC(){		
		document.#Attributes.form#.#Attributes.id#.value="";
		document.#Attributes.form#.#Attributes.name#.value="";
		document.#Attributes.form#.#Attributes.desc#.value="";
	}
</script>

<cfquery name="rsTransaccionesD" datasource="#Session.DSN#">
	select CCTcodigo, CCTdescripcion 
	from CCTransacciones 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	and CCTtipo = 'D' 
	and isnull(CCTpago,0) != 1
	order by CCTcodigo 
</cfquery>

<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset id = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.id')#')#')">
		<cfset name = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name')#')#')">
		<cfset desc = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.desc')#')#')">
	</cfif>
	
	<tr>
		<td nowrap>
			<input type="hidden"
			name="#Attributes.id#" id="#Attributes.id#"
			value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#id#')#</cfif>">
			
			<input type="hidden"
			name="Cod#Attributes.id#" id="Cod#Attributes.id#"
			value="<!--- Solo se llena al cambiar para asignar los valores de la pantalla dinámicamente || usado por la variable codigo || --->">
			
			<select name="#Attributes.CCTcodigoConlis#"  id="#Attributes.CCTcodigoConlis#"  
				onChange="javascript: limpiarDocsPagoCxC();" tabindex="#Attributes.tabindex#">
				<cfloop query="rsTransaccionesD"> 
					<option value="#rsTransaccionesD.CCTcodigo#" <cfif isdefined("Attributes.query") and isdefined("Attributes.query.CCTcodigoConlis") and rsTransaccionesD.CCTcodigo eq Evaluate("Attributes.query.CCTcodigoConlis")>selected</cfif>>#rsTransaccionesD.CCTcodigo#</option>
					<!--- <cfif isdefined("Attributes.query") and isdefined("Attributes.query.NTIcodigo#index#") and rsTipoId.NTIcodigo eq Evaluate("Attributes.query.NTIcodigo#index#")>selected</cfif> --->
 					<!---<option value="#rsTipoId.NTIcodigo#" <cfif isdefined("Attributes.query") and isdefined("Attributes.query.NTIcodigo#index#") and rsTipoId.NTIcodigo eq Evaluate("Attributes.query.NTIcodigo#index#")>selected</cfif>>#rsTipoId.NTIdescripcion#</option> --->					
				</cfloop> 
			</select>
		</td>
		<td nowrap>
			<input type="text"
				name="#Attributes.name#" id="#Attributes.name#"
				<cfif Len(Trim(Attributes.tabindex)) GT 0>tabindex="#Attributes.tabindex#" </cfif>
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#name#')#</cfif>" 
				onBlur="javascript: TraeDocsPagoCxC#Attributes.name#(this); 
						if (window.func#Attributes.name#) {func#Attributes.name#();}" 
				onFocus="this.select()"
				onkeyup="javascript:conlis_keyup_#Attributes.name#(event);"
				size="17" 
				maxlength="20"
				<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>readonly<cfelse></cfif>>
				<!----onBlur="javascript: TraeDocsPagoCxC#Attributes.name#(document.#Attributes.form#.#Attributes.CCTcodigoConlis#.value); 
						if (window.func#Attributes.name#) {func#Attributes.name#();}" 
				onFocus="this.select()"----->
		</td>
		<td nowrap>
			<input type="text"
				name="#Attributes.desc#" id="#Attributes.desc#"
				tabindex="-1" disabled
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#desc#')#</cfif>" 
				size="#Attributes.size#" 
				maxlength="80">
			<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de documentos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisDocsPagoCxC#Attributes.name#(document.#Attributes.form#.#Attributes.CCTcodigoConlis#.value);'></a>
		</td>
	</tr>
</table>
<iframe name="#Attributes.frame#" id="#Attributes.frame#" marginheight="0" 
	marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="display:none"></iframe>
</cfoutput>