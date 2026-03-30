<cfparam name="Attributes.formName" 		default="form1" 					type="String">
<cfparam name="Attributes.sufijo" 			default="" 							type="string">
<cfparam name="Attributes.OBOid" 			default="-1" 						type="numeric">
<cfparam name="Attributes.etiqueta" 		default="Obras en Contrucción:" 	type="string">
<cfparam name="Attributes.left" 			default="100" 						type="integer">
<cfparam name="Attributes.top" 				default="200" 						type="integer">
<cfparam name="Attributes.width" 			default="800" 						type="integer">
<cfparam name="Attributes.height" 			default="500" 						type="integer">
<cfparam name="Attributes.Ecodigo" 			default="#session.Ecodigo#" 		type="numeric">
<cfparam name="Attributes.readonly"			default="false" 					type="boolean">
<cfparam name="Attributes.style" 			default="" 							type="string">	<!--- style asociado a la caja de texto --->
<cfparam name="Attributes.OBPcodigo" 		default="" 							type="string">
<cfparam name="Attributes.OBOcodigo" 		default="" 							type="string">
<cfparam name="Attributes.esFiltro" 		default="false" 					type="boolean">

<cfparam name="rsObra.OBOid" 				default="">
<cfparam name="rsObra.OBOcodigo" 			default="">
<cfparam name="rsObra.OBOdescripcion" 		default="">
<cfparam name="rsObra.OBPid" 				default="">
<cfparam name="rsObra.OBPcodigo" 			default="">
<cfparam name="rsObra.OBPdescripcion" 		default="">
<cfparam name="color" 						default="##FFFFFF">

<cfif len(trim(Attributes.OBOid)) and Attributes.OBOid GT 0>
	<cfinvoke component="sif.Componentes.OB_Obras" method="GetObra" returnvariable="rsObra">
		<cfinvokeargument name="OBOid"		value="#Attributes.OBOid#">
		<cfinvokeargument name="filtro"		value="false">	
	</cfinvoke>
<cfelseif len(trim(Attributes.OBPcodigo))>
	<cfinvoke component="sif.Componentes.OB_Obras" method="GetProyecto" returnvariable="rsObra">
		<cfinvokeargument name="OBPcodigo"		value="#Attributes.OBPcodigo#">
		<cfinvokeargument name="filtro"			value="false">		
	</cfinvoke>
	<cfif len(trim(Attributes.OBOcodigo)) and len(trim(rsObra.OBPid))>
		<cfinvoke component="sif.Componentes.OB_Obras" method="GetObra" returnvariable="rsObra">
			<cfinvokeargument name="OBPid"		value="#rsObra.OBPid#">
			<cfinvokeargument name="OBOcodigo"	value="#Attributes.OBOcodigo#">
			<cfinvokeargument name="filtro"		value="false">	
		</cfinvoke>
	</cfif>
<cfelseif Attributes.esFiltro>
	<cfset rsObra.OBOcodigo = "#Attributes.OBOcodigo#">
	<cfset rsObra.OBPcodigo = "#Attributes.OBPcodigo#">
</cfif>
<cfoutput>
<table border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>#Attributes.etiqueta#&nbsp;</td>
		<td nowrap="nowrap">
			<input type="hidden"	name="OBPid#Attributes.sufijo#" 			id="OBPid#Attributes.sufijo#" 			value="#trim(rsObra.OBPid)#" 		/>
			<input type="text" 		name="OBPcodigo#Attributes.sufijo#" 		id="OBPcodigo#Attributes.sufijo#" 		value="#trim(rsObra.OBPcodigo)#" size="10" title="Proyecto" onchange="fnBuscarProyecto#Attributes.sufijo#(this)" <cfif Attributes.readonly>readonly style="background-color:#color#;#Attributes.style#"</cfif>/>
			<input type="hidden"	name="OBOid#Attributes.sufijo#" 			id="OBOid#Attributes.sufijo#" 			value="<cfif isdefined('rsObra.OBOid')>#trim(rsObra.OBOid)#</cfif>"/>
			<input type="text" 		name="OBOcodigo#Attributes.sufijo#" 		id="OBOcodigo#Attributes.sufijo#" 		value="<cfif isdefined('rsObra.OBOcodigo')>#trim(rsObra.OBOcodigo)#</cfif>" size="10" title="Obra" onchange="fnBuscarObra#Attributes.sufijo#(this)" <cfif Attributes.readonly>readonly style="background-color:#color#;#Attributes.style#"</cfif>/>
			<input type="text" 		name="OBOdescripcion#Attributes.sufijo#" 	id="OBOdescripcion#Attributes.sufijo#" 	value="<cfif (isdefined('rsObra.OBPdescripcion') and isdefined('rsObra.OBOdescripcion')) and  (len(trim(rsObra.OBPdescripcion)) or len(trim(rsObra.OBPdescripcion)))>#rsObra.OBPdescripcion#/#rsObra.OBOdescripcion#</cfif>" size="30" style="background-color:#color#;#Attributes.style#" title="Proyecto/Obra" readonly/>
			<iframe name="iframeObra#Attributes.sufijo#" id="iframeObra#Attributes.sufijo#" marginheight="0" marginwidth="10" frameborder="0" height="#Attributes.height#" width="#Attributes.width#" scrolling="auto" style="display:none"></iframe>
		<cfif not Attributes.readonly>
			<a href="javascript:doConlisTagObra#Attributes.sufijo#();" id = "href_#Attributes.sufijo#" tabindex="-1">
				<img src="/cfmx/sif/imagenes/Description.gif"
					alt="Lista de Proyectos y Obras" 
					name="imagen" 
					id = "img#Attributes.sufijo#"
					width="18" height="14" 
					border="0" align="absmiddle" 
				>
			</a>
		</cfif>
		</td>
	</tr>
</table>
<script language="javascript1.2" type="text/javascript">

	var popUpWin=null;
	function popUpWindow#Attributes.sufijo#(URLStr, left, top, width, height){
	  if(popUpWin){
		if(!popUpWin.closed)
			popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=no,copyhistory=no,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top);
	}
	
	function doConlisTagObra#Attributes.sufijo#(){
		<cfset param = "sufijo=#Attributes.sufijo#&formName=#Attributes.formName#&width=#Attributes.width#&height=#Attributes.height#&Ecodigo=#Attributes.Ecodigo#">
		popUpWindow#Attributes.sufijo#('/cfmx/sif/Utiles/OBProyObra.cfm?<cfoutput>#param#</cfoutput>',#Attributes.left#,#Attributes.top#,#Attributes.width#,#Attributes.height#);
	}
	
	function asignarValores#Attributes.sufijo#(OBOid, OBOcodigo, OBOdescripcion, OBPid, OBPcodigo, OBPdescripcion){
		document.#Attributes.formName#.OBPid#Attributes.sufijo#.value = OBPid;
		document.#Attributes.formName#.OBPcodigo#Attributes.sufijo#.value = OBPcodigo;
		document.#Attributes.formName#.OBOid#Attributes.sufijo#.value = OBOid;
		document.#Attributes.formName#.OBOcodigo#Attributes.sufijo#.value = OBOcodigo;
		if(OBPdescripcion.length > 0 || OBOdescripcion.length > 0)
			document.#Attributes.formName#.OBOdescripcion#Attributes.sufijo#.value = OBPdescripcion + " / " + OBOdescripcion;
		else
			document.#Attributes.formName#.OBOdescripcion#Attributes.sufijo#.value = "";
	}
	
	function fnBuscarProyecto#Attributes.sufijo#(obj){
		v = trim(obj.value);
		if(v.length > 0)
			document.getElementById('iframeObra#Attributes.sufijo#').src="../../Utiles/ConlisOBProyObra.cfm?esPorTab=true&formName=#Attributes.formName#&sufijo=#Attributes.sufijo#&nivel=0&OBPcodigo="+obj.value;
		else if(v.length == 0){
			document.#Attributes.formName#.OBPid#Attributes.sufijo#.value = "";
			document.#Attributes.formName#.OBOid#Attributes.sufijo#.value = "";
			document.#Attributes.formName#.OBPcodigo#Attributes.sufijo#.value = "";
			document.#Attributes.formName#.OBOcodigo#Attributes.sufijo#.value = "";
			document.#Attributes.formName#.OBOdescripcion#Attributes.sufijo#.value = "";
		}
	}
	
	function fnBuscarObra#Attributes.sufijo#(obj){
		v1 = trim(obj.value);
		OBPid = document.#Attributes.formName#.OBPid#Attributes.sufijo#.value;
		v2 = trim(document.#Attributes.formName#.OBPid#Attributes.sufijo#.value);
		if(v1.length > 0 && v2.length > 0)
			document.getElementById('iframeObra#Attributes.sufijo#').src="../../Utiles/ConlisOBProyObra.cfm?esPorTab=true&formName=#Attributes.formName#&sufijo=#Attributes.sufijo#&nivel=1&OBPid="+OBPid+"&OBOcodigo="+obj.value;
		if(v1.length == 0){
			document.#Attributes.formName#.OBOdescripcion#Attributes.sufijo#.value = "";
			document.#Attributes.formName#.OBOid#Attributes.sufijo#.value = "";
		}
	}
	
	function trim(valor){
		if(valor)
			return valor.replace(/^\s+/g,'').replace(/\s+$/g,'');
		return '';
	}
</script>
</cfoutput>