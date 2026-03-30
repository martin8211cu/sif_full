<!---
	<cf_direccion action="input" key="#datos_personales#" default="#data_defaults#">
	<cf_direccion action="input" data="#data_direccion#" default="#data_defaults#">
	<cf_direccion action="select" key="#datos_personales#" name="variable_name">
	<cf_direccion action="insert" name="variable_name" data="...">
	<cf_direccion action="insert" name="variable_name" apellido1=".." apellido2="..
			oficina=".." celular=".." casa=".." sexo=".." >
	<cf_direccion action="update" key="#id_tarjeta#" name="variable_name" data="...">
	<cf_direccion action="update" key="#id_tarjeta#" name="variable_name" apellido1=".." apellido2="..
			oficina=".." celular=".." casa=".." sexo=".." >
	<cf_direccion action="new" name="variable_name">
	<cf_direccion action="readform" name="variable_name" prefix="...">
Parametros:
	action: indica el tipo de acción por realizar.
		input: dibuja un table con los campos de entrada necesarios para capturar una tarjeta
		select: lee los datos de una tarjeta y los regresa en una variable
		insert: inserta una nueva tarjeta. regresa los datos en una variable
		update: actualiza los valores de una tarjeta, y los regresa nuevamente en una variable
	key:    es la llave de la tarjeta que se va a leer (action=select) o actualizar (action=update)
	data:  es la variable que contiene los datos de la tarjeta que se van a desplegar, si está
			vacío despliega el formulario en modo alta (action=input)
	default:es la variable que contiene los datos de la tarjeta que se van a desplegar, 
			La diferencia con data radica en que si se utiliza el default, no se tomará en cuenta su id
			(action=input)
	apellido1,apellido2,oficina,celular,casa,sexo: Datos de la tarjeta por insertar o actualizar.
	title: indica el encabezado del portletcito (action=input)
--->
<cfparam name="Attributes.action">
<cfparam name="Attributes.datasource" default="asp">

<cfscript>
	function NewDataObject() {
		var ret = StructNew();
		ret.id = "";
		ret.datos_personales = "";
		ret.nombre = "";
		ret.apellido1 = "";
		ret.apellido2 = "";
		ret.nacimiento = ""; // Date
		ret.sexo = "M";
		ret.casa = "";
		ret.oficina = "";
		ret.celular = "";
		ret.fax = "";
		ret.pagertel = "";
		ret.pagernum = "";
		ret.email1 = "";
		ret.email2 = "";
		ret.web = "";
		return ret;
	}
</cfscript>

<cffunction name="ReadDataObject">
<cfargument name="key" required="yes">
	<cfquery datasource="#Attributes.datasource#" name="ReadDataObject_Query">
		select datos_personales,
			   Pnombre, 
			   Papellido1, 
			   Papellido2,
			   Pid,
			   Psexo,
			   Pnacimiento,
			   Pcasa,
			   Poficina,
			   Pcelular,
			   Pfax,
			   Ppagertel,
			   Ppagernum,
			   Pemail1,
			   Pemail2,
			   Pweb
		from DatosPersonales b
		where datos_personales = <cfqueryparam cfsqltype="cf_sql_numeric" value="#key#" null="#Len(key) IS 0#">
	</cfquery>
	<cfset ret = NewDataObject()>
	<cfif ReadDataObject_Query.RecordCount>
		<cfset ret.datos_personales = ReadDataObject_Query.datos_personales>
		<cfset ret.id               = Trim(ReadDataObject_Query.Pid)>
		<cfset ret.nombre           = Trim(ReadDataObject_Query.Pnombre)>
		<cfset ret.apellido1        = Trim(ReadDataObject_Query.Papellido1)>
		<cfset ret.apellido2        = Trim(ReadDataObject_Query.Papellido2)>
		<cfset ret.nacimiento       = LSDateFormat(ReadDataObject_Query.Pnacimiento,'dd/mm/yyyy')>
		<cfset ret.sexo             = ReadDataObject_Query.Psexo>
		<cfset ret.casa             = Trim(ReadDataObject_Query.Pcasa)>
		<cfset ret.oficina          = Trim(ReadDataObject_Query.Poficina)>
		<cfset ret.celular          = Trim(ReadDataObject_Query.Pcelular)>
		<cfset ret.fax              = Trim(ReadDataObject_Query.Pfax)>
		<cfset ret.pagertel         = Trim(ReadDataObject_Query.Ppagertel)>
		<cfset ret.pagernum         = Trim(ReadDataObject_Query.Ppagernum)>
		<cfset ret.email1           = Trim(ReadDataObject_Query.Pemail1)>
		<cfset ret.email2           = Trim(ReadDataObject_Query.Pemail2)>
		<cfset ret.web              = Trim(ReadDataObject_Query.Pweb)>
	</cfif>
	<cfreturn ret>
</cffunction>

<cffunction name="InsertDataObject">
<cfargument name="userdata" required="yes">
	<cftransaction>
		<cfquery datasource="#Attributes.datasource#" name="inserted">
			insert INTO  DatosPersonales (
				Pid, Pnombre, Papellido1, Papellido2, Pnacimiento,
				Psexo, Pcasa, Poficina, Pcelular, Pfax, 
				Ppagertel, Ppagernum, Pemail1, Pemail2, Pweb,
				BMUsucodigo, BMfechamod)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar"   value="#userdata.id#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"   value="#userdata.nombre#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"   value="#userdata.apellido1#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"   value="#userdata.apellido2#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#userdata.nacimiento#" null="#Len(Trim(userdata.nacimiento)) EQ 0#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.sexo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.casa#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.oficina#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.celular#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.fax#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.pagertel#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.pagernum#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.email1#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.email2#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.web#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
				
				<cf_dbidentity1  datasource="#Attributes.datasource#">
			</cfquery>
			<cf_dbidentity2  datasource="#Attributes.datasource#" name="inserted">

	</cftransaction>
	<cfreturn inserted.identity>
</cffunction>

<cffunction name="UpdateDataObject">
<cfargument name="userdata" required="yes">
	<cfquery datasource="#Attributes.datasource#" name="updated">
		update DatosPersonales
		set Pid         = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.id#">,
			Pnombre     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.nombre#">,
			Papellido1  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.apellido1#">,
			Papellido2  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.apellido2#">,
			Pnacimiento = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#userdata.nacimiento#" null="#Len(Trim(userdata.nacimiento)) EQ 0#">,
			
			Psexo       = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.sexo#">,
			Pcasa       = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.casa#">,
			Poficina    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.oficina#">,
			Pcelular    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.celular#">,
			Pfax        = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.fax#">,
			
			Ppagertel   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.pagertel#">,
			Ppagernum   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.pagernum#">,
			Pemail1     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.email1#">,
			Pemail2     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.email2#">,
			Pweb        = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.web#">,
			
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		where datos_personales = <cfqueryparam cfsqltype="cf_sql_numeric" value="#userdata.datos_personales#">
	</cfquery>
</cffunction>

<cfif ListFindNoCase('input,display,insert,update,hidden', attributes.action)>
	<!--- tags que requieren datos: data | key | default --->
	<cfparam name="Attributes.key"     default="">
	<cfparam name="Attributes.data"    default="">
	<cfparam name="Attributes.default" default="">
	<cfparam name="Attributes.title"   default="Datos Personales">
	<cfparam name="Attributes.prefix"  default="">
	<cfset userdata = "">
	<cfif IsStruct(Attributes.data) or IsQuery(Attributes.data)>
		<cfset userdata = Attributes.data>
	<cfelseif IsSimpleValue(Attributes.key) and Len(Attributes.key) NEQ 0>
		<cfset userdata = ReadDataObject(Attributes.key)>
	<cfelseif NOT IsSimpleValue(Attributes.default)>
		<cfset userdata = StructCopy(Attributes.default)>
		<cfset userdata.datos_personales = "">
	<cfelse>
		<cfset userdata = NewDataObject()>
	</cfif>
</cfif>

<cfif ListFindNoCase('insert,select,update,readform,new', attributes.action)>
	<!--- tags que requieren name --->
	<cfparam name="Attributes.name" default="cf_datospersonales">
</cfif>


<cfset list1 = " ,.,á,é,í,ó,ú">
<cfset list2 = "_,_,a,e,i,o,u">
<cfif attributes.action is 'input'>
	<cfparam name="Attributes.form" default="form1">
	
	<cfoutput>
	<cfinvoke component="Translate"
	method="Translate"
	Key="LB_#ReplaceList(Attributes.title,list1,list2)#"
	Default="#Attributes.title#"
	returnvariable="LB_V1"/> 
	
	
	<table border="0" width="100%">
		    <tr>
	      <td colspan="2" align="center" class="tituloListas">#LB_V1#</td>
    </tr>
	    <tr>
	      <td nowrap align="right"><b><cf_translate  key="LB_Identificacion">Identificaci&oacute;n</cf_translate>:&nbsp;</b></td>
	      <td ><input name="#Attributes.prefix#id" id="#Attributes.prefix#id" onFocus="this.select()" size="30" maxlength="60" value="#userdata.id#" ></td>
    </tr>
	    <tr>
	      <td nowrap align="right"><b><cf_translate  key="LB_Nombre">Nombre</cf_translate>:&nbsp;</b></td>
	      <td ><input name="#Attributes.prefix#nombre" id="#Attributes.prefix#nombre" onFocus="this.select()" size="30" maxlength="60" value="#userdata.nombre#" ></td>
    </tr>
	    <tr>
	      <td nowrap align="right"><b><cf_translate  key="LB_Apellido1">Apellido 1</cf_translate>:&nbsp;</b></td>
	      <td ><input name="#Attributes.prefix#apellido1" id="#Attributes.prefix#apellido1" onFocus="this.select()" size="30" maxlength="60" value="#userdata.apellido1#" ></td>
    </tr>
	    <tr>
	      <td nowrap align="right"><b><cf_translate  key="LB_Apellido2">Apellido 2</cf_translate>:&nbsp;</b></td>
	      <td ><input name="#Attributes.prefix#apellido2" id="#Attributes.prefix#apellido2" onFocus="this.select()" size="30" maxlength="60" value="#userdata.apellido2#"  ></td>
    </tr>
	    <tr>
	      <td nowrap align="right"><b><cf_translate  key="LB_FechaDeNacimiento">Fecha de nacimiento</cf_translate>:&nbsp;</b></td>
	      <td>
			 <cf_sifcalendario form="#Attributes.form#" value="#userdata.nacimiento#" name="#Attributes.prefix#nacimiento">
		  </td>
    </tr>
	    <tr>
	      <td align="right"><b><cf_translate  key="LB_Sexo">Sexo</cf_translate>:&nbsp;</b></td>
	      <td valign="top">
            <select name="#Attributes.prefix#sexo" id="#Attributes.prefix#sexo">
			<option value="M" <cfif userdata.sexo eq  'M'>selected</cfif>><cf_translate  key="LB_Masculino">Masculino</cf_translate></option>
			<option value="F" <cfif userdata.sexo eq  'F'>selected</cfif>><cf_translate  key="LB_Femenino">Femenino</cf_translate></option>
            </select>
          </td>
    </tr>
	    <tr>
	      <td align="right"><b><cf_translate  key="LB_TelefonoDeCasa">Tel&eacute;fono de casa</cf_translate>:&nbsp;</b></td>
	      <td valign="top"><input name="#Attributes.prefix#casa" type="text" id="#Attributes.prefix#casa" onFocus="this.select()" value="#userdata.casa#" size="15" maxlength="30" ></td>
    </tr>
	    <tr>
	      <td align="right"><b><cf_translate  key="LB_TelefonoDeOficina">Tel&eacute;fono de oficina</cf_translate>:&nbsp;</b></td>
	      <td valign="top"><input name="#Attributes.prefix#oficina" type="text" id="#Attributes.prefix#oficina" onFocus="this.select()" value="#userdata.oficina#" size="15" maxlength="30" ></td>
    </tr>
	    <tr>
	      <td align="right"><b><cf_translate  key="LB_TelefonoCelular">Tel&eacute;fono celular</cf_translate>:&nbsp;</b></td>
	      <td valign="top"><input name="#Attributes.prefix#celular" type="text" id="#Attributes.prefix#celular" onFocus="this.select()" value="#userdata.celular#" size="15" maxlength="60"></td>
    </tr>
	    <tr>
	      <td align="right"><b><cf_translate  key="LB_NumeroDeFax">N&uacute;mero de fax</cf_translate>:&nbsp;</b></td>
	      <td valign="top"><input name="#Attributes.prefix#fax" type="text" id="#Attributes.prefix#fax" onFocus="this.select()" value="#userdata.fax#" size="15" maxlength="30" ></td>
    </tr>

	    <tr>
	      <td align="right"><b><cf_translate  key="LB_TelefonoDePager">Tel&eacute;fono de pager</cf_translate>:&nbsp;</b></td>
	      <td valign="top"><input name="#Attributes.prefix#pagertel" type="text" id="#Attributes.prefix#pagertel" onFocus="this.select()" value="#userdata.pagertel#" size="15" maxlength="30" ></td>
    </tr>
	    <tr>
	      <td align="right"><b><cf_translate  key="LB_NumeroDePager">N&uacute;mero de pager</cf_translate>:&nbsp;</b></td>
	      <td valign="top"><input name="#Attributes.prefix#pagernum" type="text" id="#Attributes.prefix#pagernum" onFocus="this.select()" value="#userdata.pagernum#" size="15" maxlength="30" ></td>
    </tr>
	    <tr>
	      <td align="right"><b><cf_translate  key="LB_Email">Email</cf_translate>:&nbsp;</b></td>
	      <td valign="top"><input name="#Attributes.prefix#email1" type="text" id="#Attributes.prefix#email1" onFocus="this.select()" value="#userdata.email1#" size="30" maxlength="60" ></td>
    </tr>
	    <tr>
	      <td align="right"><b><cf_translate  key="LB_EmailAdicional">Email adicional</cf_translate>:&nbsp;</b></td>
	      <td valign="top"><input name="#Attributes.prefix#email2" type="text" id="#Attributes.prefix#email2" onFocus="this.select()" value="#userdata.email2#" size="30" maxlength="60" ></td>
    </tr>
	    <tr>
	      <td align="right"><b><cf_translate  key="LB_PainaWebPersonal">P&aacute;gina web personal</cf_translate>:&nbsp;</b></td>
	      <td valign="top"><input name="#Attributes.prefix#web" type="text" id="#Attributes.prefix#web" onFocus="this.select()" value="#userdata.web#" size="50" maxlength="255" ></td>
    </tr>
	</table>
	
	</cfoutput>
	<!--- end of action=input --->
<cfelseif attributes.action is 'display'>
	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr>
		  <td colspan="2"  align="center" class="tituloListas">#Attributes.title#</td>
		  </tr>
		<tr>
		<td  align="left" nowrap><b><cf_translate  key="LB_Identificacion">Identificaci&oacute;n</cf_translate></b></td>
		<td align="right" nowrap>
		#userdata.id# </td>
		</tr>
		<tr>
		<td  align="left" nowrap><b<cf_translate  key="LB_Nombre">Nombre</cf_translate>></b></td>
		<td align="right" nowrap>
		#userdata.nombre# </td>
		</tr>
		<tr>
		<td  align="left" nowrap><b><cf_translate  key="LB_Apellido1">Apellido 1</cf_translate></b></td>
		<td align="right" nowrap>
		#userdata.apellido1# </td>
		</tr>
		<tr>
		<td  align="left" nowrap><b><cf_translate  key="LB_Apellido2">Apellido 2</cf_translate></b></td>
		<td align="right" nowrap>
		#userdata.apellido2# </td>
		</tr>
		<tr>
		<td  align="left" nowrap><b><cf_translate  key="LB_FechaDeNacimiento">Fecha de nacimiento</cf_translate></b></td>
		<td align="right" nowrap>
		#LSDateFormat(userdata.nacimiento,'dd/mm/yyyy')# </td>
		</tr>
		<tr>
		<td  align="left"><b><cf_translate  key="LB_Sexo">Sexo</cf_translate></b></td>
		<td valign="top" align="right">
		#userdata.Psexo#</td>
		</tr>
		<tr>
		<td  align="left" nowrap><b><cf_translate  key="LB_TelefonoDeCasa">Tel&eacute;fono de casa</cf_translate></b></td>
		<td align="right" nowrap>
		#userdata.casa# </td>
		</tr>
		<tr>
		<td   align="left"nowrap><b><cf_translate  key="LB_TelefonoDeOficina">Tel&eacute;fono de  oficina</cf_translate></b></td>
		<td align="right" nowrap>
		#userdata.oficina# </td>
		</tr>
		<tr>
		<td  align="left"><b><cf_translate  key="LB_TelefonoCelular">Tel&eacute;fono celular</cf_translate></b></td>
		<td valign="top" align="right">
		#userdata.celular#</td>
		</tr>
		<tr>
		<td  align="left"><b><cf_translate  key="LB_NumeroFeFax">N&uacute;mero de fax</cf_translate></b></td>
		<td valign="top" align="right">
		#userdata.fax#</td>
		</tr>

		<tr>
		<td  align="left"><b><cf_translate  key="LB_TelefonoDePager">Tel&eacute;fono de pager</cf_translate></b></td>
		<td valign="top" align="right">
		#userdata.pagertel#</td>
		</tr>
		<tr>
		<td  align="left"><b><cf_translate  key="LB_NumeroDePager">N&uacute;mero de pager</cf_translate></b></td>
		<td valign="top" align="right">
		#userdata.pagernum#</td>
		</tr>
		<tr>
		<td  align="left"><b><cf_translate  key="LB_CorreoElectronico">Correo electr&oacute;nico</cf_translate></b></td>
		<td valign="top" align="right">
		#userdata.email1#</td>
		</tr>
		<tr>
		<td  align="left"><b><cf_translate  key="LB_CorreoElectronicoAdicional">Correo electr&oacute;nico adicional</cf_translate></b></td>
		<td valign="top" align="right">
		#userdata.email2#</td>
		</tr>
		<tr>
		<td  align="left"><b><cf_translate  key="LB_PaginaWebPersonal">P&aacute;gina web personal</cf_translate></b></td>
		<td valign="top" align="right">
		#userdata.web#</td>
		</tr>
		</table>
	</cfoutput>
	<!--- end of action=display --->
<cfelseif attributes.action is 'hidden'>
	<cfoutput>
		<input name="#Attributes.prefix#id" type="hidden" id="#Attributes.prefix#id" value="#userdata.id#">
		<input name="#Attributes.prefix#nombre" type="hidden" id="#Attributes.prefix#nombre" value="#userdata.nombre#">
		<input name="#Attributes.prefix#apellido1" type="hidden" id="#Attributes.prefix#apellido1" value="#userdata.apellido1#">
		<input name="#Attributes.prefix#apellido2" type="hidden" id="#Attributes.prefix#apellido2" value="#userdata.apellido2#">
		<input name="#Attributes.prefix#nacimiento" type="hidden" id="#Attributes.prefix#nacimiento" value="#LSDateFormat(userdata.nacimiento,'dd/mm/yyyy')#">
		<input name="#Attributes.prefix#sexo" type="hidden" id="#Attributes.prefix#sexo" value="#userdata.sexo#">
		<input name="#Attributes.prefix#casa" type="hidden" id="#Attributes.prefix#casa" value="#userdata.casa#">
		<input name="#Attributes.prefix#oficina" type="hidden" id="#Attributes.prefix#oficina" value="#userdata.oficina#">
		<input name="#Attributes.prefix#celular" type="hidden" id="#Attributes.prefix#celular" value="#userdata.celular#">
		<input name="#Attributes.prefix#fax" type="hidden" id="#Attributes.prefix#fax" value="#userdata.fax#">

		<input name="#Attributes.prefix#pagertel" type="hidden" id="#Attributes.prefix#pagertel" value="#userdata.faxpagertel#">
		<input name="#Attributes.prefix#pagernum" type="hidden" id="#Attributes.prefix#pagernum" value="#userdata.pagernum#">
		<input name="#Attributes.prefix#email1" type="hidden" id="#Attributes.prefix#email1" value="#userdata.email1#">
		<input name="#Attributes.prefix#email2" type="hidden" id="#Attributes.prefix#email2" value="#userdata.email2#">
		<input name="#Attributes.prefix#web" type="hidden" id="#Attributes.prefix#web" value="#userdata.web#">
		<cfif isdefined("userdata.datos_personales")>
		<input type="hidden" name="#Attributes.prefix#datos_personales" id="#Attributes.prefix#datos_personales" value="#userdata.datos_personales#">
		</cfif>
	</cfoutput>
	<!--- end of action=hidden --->
<cfelseif Attributes.action is 'new'>
	<cfparam name="Attributes.name">
	<cfset ret = NewDataObject()>
	<cfset Caller[Attributes.name] = ret>
	<!--- end of action=new --->
<cfelseif Attributes.action is 'readform'>
	<cfparam name="Attributes.name">
	<cfparam name="Attributes.prefix"  default="">
	<cfscript>
		ret = NewDataObject();
		if (IsDefined("form." & Attributes.prefix & "datos_personales"))
			ret.datos_personales = form[Attributes.prefix & "datos_personales"];
		if (IsDefined("form." & Attributes.prefix & "id"))
			ret.id = form[Attributes.prefix & "id"];
		if (IsDefined("form." & Attributes.prefix & "nombre"))
			ret.nombre = form[Attributes.prefix & "nombre"];
		if (IsDefined("form." & Attributes.prefix & "apellido1"))
			ret.apellido1 = form[Attributes.prefix & "apellido1"];
		if (IsDefined("form." & Attributes.prefix & "apellido2"))
			ret.apellido2 = form[Attributes.prefix & "apellido2"];
		if (IsDefined("form." & Attributes.prefix & "nacimiento") and Len(Trim(form[Attributes.prefix & "nacimiento"])) )
			ret.nacimiento = ParseDateTime( form[Attributes.prefix & "nacimiento"], 'dd-mm-yyyy');
			
		if (IsDefined("form." & Attributes.prefix & "sexo"))
			ret.sexo = form[Attributes.prefix & "sexo"];
		if (IsDefined("form." & Attributes.prefix & "casa"))
			ret.casa = form[Attributes.prefix & "casa"];
		if (IsDefined("form." & Attributes.prefix & "oficina"))
			ret.oficina = form[Attributes.prefix & "oficina"];
		if (IsDefined("form." & Attributes.prefix & "celular"))
			ret.celular = form[Attributes.prefix & "celular"];
		if (IsDefined("form." & Attributes.prefix & "fax"))
			ret.fax = form[Attributes.prefix & "fax"];

		if (IsDefined("form." & Attributes.prefix & "pagertel"))
			ret.pagertel = form[Attributes.prefix & "pagertel"];
		if (IsDefined("form." & Attributes.prefix & "pagernum"))
			ret.pagernum = form[Attributes.prefix & "pagernum"];
		if (IsDefined("form." & Attributes.prefix & "email1"))
			ret.email1 = form[Attributes.prefix & "email1"];
		if (IsDefined("form." & Attributes.prefix & "email2"))
			ret.email2 = form[Attributes.prefix & "email2"];
		if (IsDefined("form." & Attributes.prefix & "web"))
			ret.web = form[Attributes.prefix & "web"];
		Caller[Attributes.name] = ret;
	</cfscript>
	<!--- end of action=readform --->
<cfelseif Attributes.action is 'select'>
	<cfset Caller[Attributes.name] = ReadDataObject(Attributes.key)>
	<!--- end of action=readform --->
<cfelseif Attributes.action is 'insert'>
	<cfset inserted_id = InsertDataObject(userdata)>
	<cfset ret = ReadDataObject(inserted_id)>
	<cfset Caller[Attributes.name] = ret>
	<!--- end of action=readform --->
<cfelseif Attributes.action is 'update'>
	<cfif IsDefined("userdata.datos_personales") and Len(Trim(userdata.datos_personales)) NEQ 0>
		<cfset UpdateDataObject(userdata)>
		<cfset ret = ReadDataObject(userdata.datos_personales)>
	<cfelse>
		<cfset inserted_id = InsertDataObject(userdata)>
		<cfset ret = ReadDataObject(inserted_id)>
	</cfif>
	<cfset Caller[Attributes.name] = ret>
	<!--- end of action=update --->
<cfelse>
	<cfthrow message="Action invalido: #Attributes.action#">
</cfif>