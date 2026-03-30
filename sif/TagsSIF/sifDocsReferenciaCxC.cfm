<!---------
	Modificado por: Ana Villavicencio
	Fecha: 24 de febrero del 2006
	Motivo: Agregar atributo de display en none al iframe del tag
	 		Se corrigió navegacion de tab.
 		   	Se agregó la funcion conlis_keyup, para q funcionara el F2.	

	Modificado por: Ana Villavicencio
	Fecha de modificacin: 03 de agosto del 2005
	Motivo:	se corrigio error a la hora de limpiar el campo de la descripcion del documento, 
			limpiaba el campo SNcodigo y esto afectaba el proceso.
----------->
<cfset def = QueryNew('dato')>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" type="String" default=""> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.SNcodigo" default="SNcodigo" type="string"> <!--- Nombre del id --->
<cfparam name="Attributes.name" default="EDdocref" type="string">  <!---Nombre del Documento --->
<!--- <cfparam name="Attributes.desc" default="DTM" type="string"> Nombre de la Descripción --->
<cfparam name="Attributes.GSNid" default="0" type="string"> <!--- Nombre de la Grupo Socio Negogios --->
<cfparam name="Attributes.CCTcodigoConlis" default="CCTcodigoConlis" type="string"> <!--- Tipo de documento --->
<cfparam name="Attributes.frame" default="frDocsReferenciaCxC" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.size" default="35" type="string"> <!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.empresa" type="string" default=""> <!--- empresa --->

<cfif len(trim(Attributes.Conexion)) LT 1>
	<cfset Attributes.Conexion = Session.DSN>
</cfif>
<cfif len(trim(Attributes.Empresa)) LT 1>
	<cfset Attributes.Empresa = Session.Ecodigo>
</cfif>

<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	<cfoutput>
	var sn = document.#Attributes.form#.#Attributes.SNcodigo#.value;
	</cfoutput>
	//Levanta el Conlis
	function popUpWindow<cfoutput>#Attributes.name#</cfoutput>(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//funcion para habilitar el F2
	function conlis_keyup_<cfoutput>#Attributes.name#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisDocsReferenciaCxC<cfoutput>#Attributes.name#</cfoutput>();
		}
	}
	//Llama el conlis
	function doConlisDocsReferenciaCxC<cfoutput>#Attributes.name#</cfoutput>() {
		var params ="";
		<cfoutput>
		var CCTcod = document.#Attributes.form#.#Attributes.CCTcodigoConlis#.value;
		</cfoutput>
		if (sn != "") {
			params = "?<cfoutput>form=#Attributes.form#&name=#Attributes.name#&CCTcodigoConlis=#Attributes.CCTcodigoConlis#&conexion=#Attributes.conexion#&empresa=#Attributes.empresa#&SNcodigo=</cfoutput>"+sn + "&CCTcodigo=" + CCTcod;
	
			popUpWindow<cfoutput>#Attributes.name#</cfoutput>("/cfmx/sif/Utiles/ConlisDocsReferenciaCxC.cfm"+params,250,200,650,400);
		}else{
			alert('Debe seleccionar un cliente');
			return false;
		}
		
	}
	
</script>

<cfquery name="rsTransaccionesD" datasource="#Session.DSN#">
	select CCTcodigo, CCTdescripcion 
	from CCTransacciones 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	and CCTtipo  = 'D' 
	order by CCTcodigo 
</cfquery>


<table width="" border="0" cellspacing="0" cellpadding="0">
  <cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
    <cfset SNcodigo = "#Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.SNcodigo')#')#')#">
    <cfset name = "#Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name')#')#')#">
    <cfset CCTcodigoConlis = "#Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.CCTcodigoConlis')#')#')#">
  </cfif>
  <tr>
    <td nowrap> <cfoutput>
        <select name="#Attributes.CCTcodigoConlis#"  id="#Attributes.CCTcodigoConlis#"  
				onChange="javascript: limpiarDocsReferenciaCxC();" tabindex="#Attributes.tabindex#">
      </cfoutput> 
	  <cfoutput query="rsTransaccionesD">
        <option value="#rsTransaccionesD.CCTcodigo#" 
			<cfif ListLen(Attributes.query.columnList) GT 1 and rsTransaccionesD.CCTcodigo EQ #CCTcodigoConlis#>selected</cfif> > #rsTransaccionesD.CCTcodigo# </option>
      </cfoutput>
      </select>
    </td>
    <td nowrap> <cfoutput>
        <input type="text"
				name="#Attributes.name#" id="#Attributes.name#"
				<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#name#</cfif>" 
				onBlur="javascript: TraeDocsReferenciaCxC#Attributes.name#(document.#Attributes.form#.#Attributes.CCTcodigoConlis#.value); 
						if (window.func#Attributes.name#) {func#Attributes.name#();}" 
				onFocus="this.select()"
				onkeyup="javascript:conlis_keyup_#Attributes.name#(event);"
				size="17" 
				maxlength="20">
    </cfoutput></td>
    <td nowrap>
      <!--- <input type="text"
				name="#Attributes.desc#" id="#Attributes.desc#"
				tabindex="-1" disabled
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#desc#</cfif>" 
				size="#Attributes.size#" 
				maxlength="80"> --->
      <a href="#" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de documentos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisDocsReferenciaCxC<cfoutput>#Attributes.name#</cfoutput>();'></a> </td>
  </tr>
</table>
<script language="JavaScript" type="text/javascript">
	<cfoutput>

	var CCTcodigoJsm = document.#Attributes.form#.#Attributes.CCTcodigoConlis#.value;
	
	</cfoutput>
	
	//Obtiene la descripción con base al código
	function TraeDocsReferenciaCxC<cfoutput>#Attributes.name#</cfoutput>(dato) {
		var params ="";
		<cfoutput>
		var doc = document.#attributes.form#.#attributes.name#.value;
		</cfoutput>
		if (sn != "") {
		params = "<cfoutput>&name=#Attributes.name#&conexion=#Attributes.conexion#&ecodigo=#Attributes.empresa#&SNcodigo=</cfoutput>"+sn+"&CCTcodigoJss="+CCTcodigoJsm+"&DocumentoC="+doc;
		if (dato!="") {																																							
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/sif/Utiles/sifDocsReferenciaCxCquery.cfm?dato="+dato+"&form="+"<cfoutput>#Attributes.form#</cfoutput>"+params;
		}
		else{
			limpiarDocsReferenciaCxC();
		}
		return;}
		else {
			alert('Debe seleccionar un cliente');
			return false;		
		}
	}
	function limpiarDocsReferenciaCxC(){
	<cfoutput>
		document.#Attributes.form#.#Attributes.name#.value="";
	</cfoutput>
	}
</script>
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" id="<cfoutput>#Attributes.frame#</cfoutput>" 
	marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src=""  
	style=" display:none;visibility: hidden;"></iframe>
