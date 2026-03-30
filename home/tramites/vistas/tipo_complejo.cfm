<cfparam name="Attributes.name" type="string">
<cfparam name="Attributes.value" type="string" default="">
<cfparam name="Attributes.valueid" type="string" default="">
<cfparam name="Attributes.id_tipocampo" type="numeric">
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->

<cfquery datasource="#session.tramites.dsn#" name="cf_tipocomplejo_info">
	select es_persona
	from DDTipo
	where id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id_tipocampo#">
</cfquery>

<cfoutput>

<cfset vistascfc = CreateObject("component","home.tramites.componentes.vistas")>

<cfset jsargs = "'" & JSStringFormat(Attributes.id_tipocampo) & "','"
				& JSStringFormat(Attributes.form) & "','"
				& JSStringFormat(Attributes.name) & "','"
				& JSStringFormat(Attributes.name) & "_T'">

<input type="hidden" name="#HTMLEditFormat(Attributes.name)#"
	id="#HTMLEditFormat(Attributes.name)#" 
	value="#HTMLEditFormat(vistascfc.unir_valor(Attributes.valueid,Attributes.value))#">

<cfif cf_tipocomplejo_info.es_persona EQ 1>
	<input type="text" name="#HTMLEditFormat(Attributes.name)#_IDEN"
		id="#HTMLEditFormat(Attributes.name)#_IDEN" 
		value="#HTMLEditFormat(Trim(ListFirst(Attributes.value,' ')))#" size="10" 
		readonly="readonly"
		onclick="javascript:seleccionar_documento(#jsargs#)" style="cursor:pointer ">
	<cfset Attributes.value = Trim(ListRest(Attributes.value,' '))>
	<input type="text" name="#HTMLEditFormat(Attributes.name)#_NOM"
		id="#HTMLEditFormat(Attributes.name)#_NOM" 
		value="#HTMLEditFormat(Trim(ListFirst(Attributes.value,'-')))#" size="35" 
		readonly="readonly"
		onclick="javascript:seleccionar_documento(#jsargs#)" style="cursor:pointer ">
	<!---
		este guión y el espacio después de la cédula son
		sumamente importantes, lo genera el conlis.cfm y se usa aquí para
		separar en dos cajas la cédula y el nombre de la persona
		CEDULA NOMBRE - OTROS DATOS.  EJ:
		105550555 JUAN SOLANO - 12/10/2004 NOTA 94
	--->
	<cfset Attributes.value = Trim(ListRest(Attributes.value,'-'))>
</cfif>

<input type="text" name="#HTMLEditFormat(Attributes.name)#_TXT"
	id="#HTMLEditFormat(Attributes.name)#_TXT" 
	value="#HTMLEditFormat(Attributes.value)#" size="20" 
	readonly="readonly"
	onclick="javascript:seleccionar_documento(#jsargs#)" style="cursor:pointer ">
<a href="javascript:seleccionar_documento(#jsargs#)">
<img src="/cfmx/sif/imagenes/Description.gif" width="18" height="14" border="0">
</a>
</cfoutput>
<cfif Not StructKeyExists(Request,'CF_TIPO_COMPLEJO_JAVASCRIPT')>
<cfset Request.CF_TIPO_COMPLEJO_JAVASCRIPT = 1>
<script type="text/javascript">
<!--<cfoutput>
	var popUpWin_seleccionar_documento=null;
	function popUpWindow_seleccionar_documento(URLStr, left, top, width, height)
	{
	  if(popUpWin_seleccionar_documento)
	  {
		if(!popUpWin_seleccionar_documento.closed) popUpWin_seleccionar_documento.close();
	  }
	  popUpWin_seleccionar_documento = open(URLStr, 'popUpWin_seleccionar_documento', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function seleccionar_documento(id_tipocampo,formname,objid,objtxt){
		var conlisArgs = '?id_tipo='+escape(id_tipocampo)
			+ '&formname=' + escape(formname)
			+ '&objid=' + escape(objid)
			+ '&objiden=' + escape(objid+'_IDEN')
			+ '&objnom=' + escape(objid+'_NOM')
			+ '&objtxt=' + escape(objid+'_TXT');
		popUpWindow_seleccionar_documento('/cfmx/home/tramites/vistas/conlis.cfm'
			+conlisArgs,250,200,650,550);
	}
//</cfoutput>-->
</script>
</cfif>
