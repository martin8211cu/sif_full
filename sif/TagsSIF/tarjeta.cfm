<!---
	<cf_tarjeta action="input" key="#id_tarjeta#" default="#data_defaults#">
	<cf_tarjeta action="input" data="#data_tarjeta#" default="#data_defaults#">
	<cf_tarjeta action="select" key="#id_tarjeta#" name="variable_name">
	<cf_tarjeta action="insert" name="variable_name" [ readfrom="form." ]>
	<cf_tarjeta action="insert" name="variable_name" tc_tipo="AMEX"
			tc_nombre="ALAN LEE" tc_numero="370712345612345" tc_vence="12/05" tc_digito="1234" direccion="#data_direccion#" >
	<cf_tarjeta action="update" key="#id_tarjeta#" name="variable_name" [ readfrom="form." ]>
	<cf_tarjeta action="update" key="#id_tarjeta#" name="variable_name" tc_tipo="AMEX"
			tc_nombre="ALAN LEE" tc_numero="370712345612345" tc_vence="12/05" tc_digito="1234" direccion="#data_direccion#" >
	<cf_tarjeta action="new" name="variable_name">
	<cf_tarjeta action="readform" name="variable_name" prefix="...">
Parametros:
	action: indica el tipo de acción por realizar.
		input: dibuja un table con los campos de entrada necesarios para capturar una tarjeta
		select: lee los datos de una tarjeta y los regresa en una variable
		insert: inserta una nueva tarjeta. regresa los datos en una variable
		update: actualiza los valores de una tarjeta, y los regresa nuevamente en una variable
	key:    es la llave de la tarjeta que se va a leer (action=select) o actualizar (action=update)
	data:  es la variable que contiene los datos de la tarjeta que se van a desplegar, si está
			vacío despliega el formulario en modo alta (action=input)
	tc_tipo,tc_nombre,tc_numero,tc_vence,tc_digito: Datos de la tarjeta por insertar o actualizar.
	title: indica el encabezado del portletcito (action=input)
--->
<cfparam name="Attributes.action" default="input">

<cffunction name="NewDataObject">
	<cfscript>
		var ret = StructNew();
		ret.id_tarjeta = "";
		ret.tc_tipo = "";
		ret.tc_nombre = "";
		ret.tc_numero = "";
		ret.tc_vence_mes = "";
		ret.tc_vence_ano = "";
		ret.tc_digito = "";
	</cfscript>
	<cf_direccion action="new" name="newobj_direccion">
	<cfset ret.direccion = newobj_direccion>
	<cfreturn ret>
</cffunction>

<cffunction name="ReadDataObject">
<cfargument name="key" required="yes">
	<cfquery datasource="aspsecure" name="ReadDataObject_QueryTarjeta">
		select * from Tarjeta
		where id_tarjeta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#key#" null="#Len(key) IS 0#">
	</cfquery>
	<cfset ret = NewDataObject()>
	<cfif ReadDataObject_QueryTarjeta.RecordCount>
		<cfset ret.id_tarjeta   = ReadDataObject_QueryTarjeta.id_tarjeta>
		<cfset ret.tc_tipo      = ReadDataObject_QueryTarjeta.tc_tipo>
		<cfset ret.tc_nombre    = ReadDataObject_QueryTarjeta.tc_nombre>
		<cfset ret.tc_numero    = ReadDataObject_QueryTarjeta.tc_numero>
		<cfset ret.tc_vence_mes = ReadDataObject_QueryTarjeta.tc_vence_mes>
		<cfset ret.tc_vence_ano = ReadDataObject_QueryTarjeta.tc_vence_ano>
		<cfset ret.tc_digito    = ReadDataObject_QueryTarjeta.tc_digito>
		<cf_direccion action="select" key="#ReadDataObject_QueryTarjeta.id_direccion#" name="ReadDataObject_Direccion">
		<cfset ret.direccion = ReadDataObject_Direccion>
	</cfif>
	<cfreturn ret>
</cffunction>

<cffunction name="InsertDataObject">
<cfargument name="userdata" required="yes">
	<cf_direccion action="insert" data="#userdata.direccion#" name="InsertDataObject_direccion">
	<cfset userdata.direccion = InsertDataObject_direccion>
	<cfquery datasource="aspsecure" name="inserted">
		insert into Tarjeta (
			id_direccion, tc_tipo, tc_nombre, tc_numero,
			tc_vence_mes, tc_vence_ano, tc_digito,
			BMUsucodigo, BMfechamod)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#userdata.direccion.id_direccion#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.tc_tipo#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.tc_nombre#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.tc_numero#">,
			<cfqueryparam cfsqltype="cf_sql_integer"     value="#userdata.tc_vence_mes#">,
			<cfqueryparam cfsqltype="cf_sql_integer"     value="#userdata.tc_vence_ano#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.tc_digito#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
		select @@identity as newkey
	</cfquery>
	<cfreturn inserted.newkey>
</cffunction>

<cffunction name="EqualsDataObject">
<cfargument name="obj1" required="yes">
<cfargument name="obj2" required="yes">

	<cfreturn obj1.tc_tipo      EQ obj2.tc_tipo
		  AND obj1.tc_nombre    EQ obj2.tc_nombre
		  AND obj1.tc_numero    EQ obj2.tc_numero
		  AND obj1.tc_vence_mes EQ obj2.tc_vence_mes
		  AND obj1.tc_vence_ano EQ obj2.tc_vence_ano
		  AND obj1.tc_digito    EQ obj2.tc_digito>
</cffunction>

<cffunction name="DireccionDelUsuarioConectado">
	<cfquery datasource="asp" name="DireccionDelUsuarioConectado_QueryUsuarioConectado">
		select id_direccion
		from Usuario
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	</cfquery>
	<cfreturn DireccionDelUsuarioConectado_QueryUsuarioConectado.id_direccion>
</cffunction>

<cfif ListFindNoCase('input,display,insert,update,hidden', attributes.action)>
	<!--- tags que requieren datos: data | key | default --->
	<cfparam name="Attributes.key"     default="">
	<cfparam name="Attributes.data"    default="">
	<cfparam name="Attributes.default" default="">
	<cfparam name="Attributes.title"   default="Forma de pago">
	<cfparam name="Attributes.prefix"  default="">
	<cfset userdata = "">
	<cfif IsStruct(Attributes.data) or IsQuery(Attributes.data)>
		<cfset userdata = Attributes.data>
	<cfelseif IsSimpleValue(Attributes.key) and Len(Trim(Attributes.key)) NEQ 0>
		<cfset userdata = ReadDataObject(Attributes.key)>
	<cfelseif NOT IsSimpleValue(Attributes.default)>
		<cfset userdata = StructCopy(Attributes.default)>
		<cfset userdata.id_tarjeta = "">
	<cfelse>
		<cfset userdata = NewDataObject()>
		<cf_direccion action="select" name="miDireccion" key="#DireccionDelUsuarioConectado()#">
		<cfset userdata.direccion = miDireccion>
	</cfif>
</cfif>

<cfif ListFindNoCase('insert,select,update,readform,new', attributes.action)>
	<!--- tags que requieren name --->
	<cfparam name="Attributes.name">
</cfif>

<cfif attributes.action is 'input'>
	<!--- start of action=input --->
	<cfoutput>
	<table border="0" width="100%"><tr>
	      <td colspan="2" align="center" class="tituloListas">#Attributes.title#</td>
          <td align="center" class="tituloListas">&nbsp;</td>
	</tr>
	    <tr>
	      <td align="right"><b>Tipo de Tarjeta:&nbsp;</b></td>
	      <td>
            <select name="tc_tipo" id="tc_tipo">
              <option value="VISA">Tarjeta de Cr&eacute;dito VISA</option>
              <option value="AMEX">Tarjeta de Cr&eacute;dito American Express</option>
              <option value="MC">Tarjeta de Cr&eacute;dito MasterCard</option>
            </select>
          </td>
          <td width="100" rowspan="5" valign="top"><a href="javascript:popUp('https://digitalid.verisign.com/as2/6f9c3fe1a3b3c8402b450dfa2c054233')">		
		    <img src="/cfmx/tienda/tienda/images/Verisign-Secure-White98x102.gif" width="98" height="102" border="0"></a><a href="javascript:popUp('https://digitalid.verisign.com/as2/6f9c3fe1a3b3c8402b450dfa2c054233')">
	  <script type='text/javascript' language='JavaScript'>
function popUp(url) {
sealWin=window.open(url,"win",'toolbar=0,location=0,directories=0,status=1,menubar=1,scrollbars=1,resizable=1,width=500,height=450');
self.name = "mainWin";
}
  </script>
  </a></td>
      </tr>
	    <tr>
	      <td align="right"><b>No. Tarjeta:&nbsp;</b></td>
	      <td>
            <input name="tc_numero" type="text" id="tc_numero" value="" size="25" maxlength="20">
          </td>
      </tr>
	    <tr>
	      <td nowrap align="right"><b>Nombre como aparece en la Tarjeta:&nbsp;</b></td>
	      <td valign="top">
            <input name="tc_nombre" type="text" id="tc_nombre" value="#UCase(userdata.tc_nombre)#" size="35" maxlength="60">
          </td>
      </tr>
	    <tr>
	      <td nowrap align="right"><b>Vencimiento:&nbsp;</b></td>
	      <td>
            <select name="tc_vence_mes" id="tc_vence_mes">
			  <option value="">[mes]</option>
              <option value="01">01 - Enero</option>
              <option value="02">02 - Febrero</option>
              <option value="03">03 - Marzo</option>
              <option value="04">04 - Abril</option>
              <option value="05">05 - Mayo</option>
              <option value="06">06 - Junio</option>
              <option value="07">07 - Julio</option>
              <option value="08">08 - Agosto</option>
              <option value="09">09 - Setiembre</option>
              <option value="10">10 - Octubre</option>
              <option value="11">11 - Noviembre</option>
              <option value="12">12 - Diciembre</option>
            </select>
            <select name="tc_vence_ano" id="tc_vence_ano" >
			  <option value="">[a&ntilde;o]</option>
              <cfset ano = DatePart('yyyy', Now())>
              <cfloop from="#ano#" to="#ano+20#" step="1" index="i">
                <option value="#i#">#i#</option>
              </cfloop>
            </select>
          </td>
      </tr>
	    <tr>
	      <td nowrap align="right"><b>D&iacute;gito Verificador:&nbsp;</b></td>
	      <td><input name="tc_digito" type="text" id="tc_digito" size="8" maxlength="5">
	        <a href="##" onClick="javascript:window.open('/cfmx/tienda/tienda/public/cvc.html','_blank','toolbar=no,width=500,status=no')" style="text-decoration:underline;">&iquest;Qu&eacute; es esto?</a></td>
      </tr>
	<tr><td colspan="3">
	<cf_direccion action="input" title="Dirección del estado de cuenta" data="#userdata.direccion#" prefix="#Attributes.prefix#stmtaddr"></td></tr>
	</table>
	</cfoutput>
	<!--- end of action=input --->
<cfelseif attributes.action is "display">
	<cfoutput>
	<table width="100%" border="0" cellpadding="2" cellspacing="0"><tr>
	      <td colspan="3" align="center" class="tituloListas">#Attributes.title#</td>
          <td align="center">&nbsp;</td>
	</tr>
	  <tr>
	    <td width="1%" rowspan="4" align="left" valign="top">
		<cfif userdata.tc_tipo eq "AMEX">
			  <img src="/cfmx/tienda/tienda/images/card/AMEX.gif" alt="American Express" width="35" height="36" >&nbsp;
		  <cfelseif trim(userdata.tc_tipo) eq "MC">
			  <img src="/cfmx/tienda/tienda/images/card/MC.gif" alt="Master Card" width="45" height="29" >&nbsp;
		  <cfelseif userdata.tc_tipo eq "VISA">
			  <img src="/cfmx/tienda/tienda/images/card/VISA.gif" alt="Visa" width="38" height="24" >&nbsp;
		</cfif></td>
		<td align="left"><b>No. Tarjeta</b></td>
		<td nowrap align="right">
		  <cfif len(trim(userdata.tc_numero)) GT 4>
	  		#repeatstring('X', max(len(trim(userdata.tc_numero))-4,8))##right(trim(userdata.tc_numero), 4)#
	<cfelse>
  #trim(userdata.tc_numero)#
		  </cfif>
		</td>
	    <td rowspan="5" align="right"  width="100" valign="top"><a href="javascript:popUp('https://digitalid.verisign.com/as2/6f9c3fe1a3b3c8402b450dfa2c054233')">		
		  <img src="/cfmx/tienda/tienda/images/Verisign-Secure-White98x102.gif" width="98" height="102" border="0"></a><a href="javascript:popUp('https://digitalid.verisign.com/as2/6f9c3fe1a3b3c8402b450dfa2c054233')">
	  <script type='text/javascript' language='JavaScript'>
function popUp(url) {
sealWin=window.open(url,"win",'toolbar=0,location=0,directories=0,status=1,menubar=1,scrollbars=1,resizable=1,width=500,height=450');
self.name = "mainWin";
}
  </script>
  </a></td>
	  </tr>
	  <tr>
	    <td  align="left" nowrap><b>Nombre como aparece en la Tarjeta</b></td>
		<td nowrap align="right">
	#userdata.tc_nombre# </td>
      </tr>
	  <tr>
	    <td  align="left"><b>Vencimiento</b></td>
		<td nowrap align="right">
			  #userdata.tc_vence_mes# / #userdata.tc_vence_ano#
		</td>
      </tr>
	  <tr>
	    <td  align="left" nowrap><b>D&iacute;gito Verificador</b></td>
		<td align="right" nowrap>
	#userdata.tc_digito# </td>
      </tr>
	  <tr><td>&nbsp;
	  </td><td colspan="2">
	  <cf_direccion action="display" data="#userdata.direccion#" title="Dirección del estado de cuenta" prefix="#Attributes.prefix#stmtaddr">
	  </td>
      </tr>
  </table>
  </cfoutput>
	<!--- end of action=display --->
<cfelseif attributes.action is "hidden">
	<cfoutput>
		<cf_direccion action="hidden" data="#userdata.direccion#" prefix="#Attributes.prefix#stmtaddr">
		<input type="hidden" name="tc_tipo" value="#userdata.tc_tipo#" >
		<input name="tc_numero" type="hidden" value="#userdata.tc_numero#">
		<input name="tc_nombre" type="hidden" value="#userdata.tc_nombre#" >
		<input name="tc_vence_mes" type="hidden" value="#userdata.tc_vence_mes#">
		<input name="tc_vence_ano" type="hidden" value="#userdata.tc_vence_ano#">
		<input name="tc_digito" type="hidden" value="#userdata.tc_digito#">
		<cfif isdefined("userdata.id_tarjeta")>
		<input type="hidden" name="tarjeta" value="#userdata.id_tarjeta#">
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
	<cfset ret = NewDataObject()>
	<cf_direccion action="readform" prefix="#Attributes.prefix#stmtaddr" name="direccion">
	<cfset ret.direccion = direccion>
	<cfif (IsDefined("form." & Attributes.prefix & "id_tarjeta"))>
		<cfset ret.id_tarjeta = form[Attributes.prefix & "id_tarjeta"]></cfif>
	<cfif (IsDefined("form." & Attributes.prefix & "tc_tipo"))>
		<cfset ret.tc_tipo = form[Attributes.prefix & "tc_tipo"]></cfif>
	<cfif (IsDefined("form." & Attributes.prefix & "tc_nombre"))>
		<cfset ret.tc_nombre = form[Attributes.prefix & "tc_nombre"]></cfif>
	<cfif (IsDefined("form." & Attributes.prefix & "tc_numero"))>
		<cfset ret.tc_numero = form[Attributes.prefix & "tc_numero"]></cfif>
	<cfif (IsDefined("form." & Attributes.prefix & "tc_vence_mes"))>
		<cfset ret.tc_vence_mes = form[Attributes.prefix & "tc_vence_mes"]></cfif>
	<cfif (IsDefined("form." & Attributes.prefix & "tc_vence_ano"))>
		<cfset ret.tc_vence_ano = form[Attributes.prefix & "tc_vence_ano"]></cfif>
	<cfif (IsDefined("form." & Attributes.prefix & "tc_digito"))>
		<cfset ret.tc_digito = form[Attributes.prefix & "tc_digito"]></cfif>
	<cfset Caller[Attributes.name] = ret>
	<!--- end of action=readform --->
<cfelseif Attributes.action is 'select'>
	<cfset Caller[Attributes.name] = ReadDataObject(Attributes.key)>
	<!--- end of action=select --->
<cfelseif Attributes.action is 'insert'>
	<cfset inserted_id = InsertDataObject(userdata)>
	<cfset ret = ReadDataObject(inserted_id)>
	<cfset Caller[Attributes.name] = ret>
	<!--- end of action=insert --->
<cfelseif Attributes.action is 'update'>
	<cfif IsDefined("userdata.id_tarjeta") and Len(Trim(userdata.id_tarjeta)) NEQ 0>
		<cfif NOT (EqualsDataObject(userdata, ReadDataObject(userdata.id_tarjeta)))>
			<cfset inserted_id = InsertDataObject(userdata)>
			<cfset ret = ReadDataObject(inserted_id)>
		</cfif>
	<cfelse>
		<cfset inserted_id = InsertDataObject(userdata)>
		<cfset ret = ReadDataObject(inserted_id)>
	</cfif>
	<cfset Caller[Attributes.name] = ret>
	<!--- end of action=update --->
<cfelseif Attributes.action is 'list'>
	



<cfelseif Attributes.action is 'link.add'>
<!--- ver posibilidad de usar objetos del XXXDataObject --->
<cfelseif Attributes.action is 'link.remove'>
<cfelseif Attributes.action is 'link.input'>
<cfelseif Attributes.action is 'link.get'>
<!---
<cf_tarjeta action="link.add"    data="#tarj#" type="user" associd="#session.Usucodigo#">
<cf_tarjeta action="link.remove" data="#tarj#" type="user" associd="#session.Usucodigo#">
<cf_tarjeta action="link.input"  data="#tarj#" type="user" associd="#session.Usucodigo#">
<cf_tarjeta action="link.get"    data="#tarj#" type="user" associd="#session.Usucodigo#">
--->

<cfelse>
	<cf_errorCode	code = "50622"
					msg  = "Action inválido (@errorDat_1@)"
					errorDat_1="#Attributes.action#"
	>
</cfif>

