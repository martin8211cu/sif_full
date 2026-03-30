<!---
	<cf_direccion action="input" key="#id_direccion#" default="#data_defaults#">
	<cf_direccion action="input" data="#data_direccion#" default="#data_defaults#">
	<cf_direccion action="select" key="#id_direccion#" name="variable_name">
	<cf_direccion action="insert" name="variable_name" data="...">
	<cf_direccion action="insert" name="variable_name" direccion1=".." direccion2="..
			estado=".." cod_Postal=".." ciudad=".." pais=".." >
	<cf_direccion action="update" key="#id_tarjeta#" name="variable_name" data="...">
	<cf_direccion action="update" key="#id_tarjeta#" name="variable_name" direccion1=".." direccion2="..
			estado=".." cod_Postal=".." ciudad=".." pais=".." >
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
	direccion1,direccion2,estado,cod_Postal,ciudad,pais: Datos de la tarjeta por insertar o actualizar.
	title: indica el encabezado del portletcito (action=input)
--->
<cfparam name="Attributes.action">

<cfscript>
	function NewDataObject() {
		var ret = StructNew();
		ret.id_direccion = "";
		ret.atencion = "";
		ret.direccion1 = "";
		ret.direccion2 = "";
		ret.ciudad = "";
		ret.estado = "";
		ret.cod_Postal = "";
		ret.pais = "CR";
		return ret;
	}
</cfscript>

<cffunction name="ReadDataObject">
	<cfargument name="key" required="yes">

	<cfquery datasource="#session.tramites.dsn#" name="ReadDataObject_QueryDirecciones">
		select * from TPDirecciones
		where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#key#" null="#Len(key) IS 0#">
	</cfquery>
	

	<cfset ret = NewDataObject()>
	<cfif ReadDataObject_QueryDirecciones.RecordCount>
		<cfset ret.id_direccion = ReadDataObject_QueryDirecciones.id_direccion>
		<cfset ret.atencion = Trim(ReadDataObject_QueryDirecciones.atencion)>
		<cfset ret.direccion1 = Trim(ReadDataObject_QueryDirecciones.direccion1)>
		<cfset ret.direccion2 = Trim(ReadDataObject_QueryDirecciones.direccion2)>
		<cfset ret.ciudad = Trim(ReadDataObject_QueryDirecciones.ciudad)>
		<cfset ret.estado = Trim(ReadDataObject_QueryDirecciones.estado)>
		<cfset ret.cod_Postal = Trim(ReadDataObject_QueryDirecciones.cod_Postal)>
		<cfset ret.pais = ReadDataObject_QueryDirecciones.pais>
	</cfif>
	<cfreturn ret>
</cffunction>

<cffunction name="InsertDataObject">
<cfargument name="userdata" required="yes">
	<cftransaction>
		<cfquery datasource="#session.tramites.dsn#" name="inserted">
			insert INTO TPDirecciones (
				atencion, direccion1, direccion2,
				ciudad, estado, cod_postal, pais,
				BMUsucodigo, BMfechamod)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.atencion#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.direccion1#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.direccion2#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.ciudad#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.estado#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.cod_Postal#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.pais#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
				
			<cf_dbidentity1  datasource="#session.tramites.dsn#">
		</cfquery>
		
		<cf_dbidentity2  datasource="#session.tramites.dsn#" name="inserted">
	</cftransaction>
	
	<cfreturn inserted.identity>
</cffunction>

<cffunction name="UpdateDataObject">
<cfargument name="userdata" required="yes">
	<cfquery datasource="#session.tramites.dsn#" name="updated">
		update TPDirecciones
		set atencion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.atencion#">,
			direccion1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.direccion1#">,
			direccion2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.direccion2#">,
			ciudad = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.ciudad#">,
			estado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.estado#">,
			cod_postal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.cod_Postal#">,
			pais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.pais#">,
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#userdata.id_direccion#">
	</cfquery>
</cffunction>

<cfif ListFindNoCase('input,display,label,insert,update,hidden', attributes.action)>
	<!--- tags que requieren datos: data | key | default --->
	<cfparam name="Attributes.key"     default="">
	<cfparam name="Attributes.data"    default="">
	<cfparam name="Attributes.default" default="">
	<cfparam name="Attributes.title"   default="Dirección">
	<cfparam name="Attributes.prefix"  default="">
	<cfset userdata = "">
	<cfif IsStruct(Attributes.data) or IsQuery(Attributes.data)>
		<cfset userdata = Attributes.data>
	<cfelseif IsSimpleValue(Attributes.key) and Len(Attributes.key) NEQ 0>
		<cfset userdata = ReadDataObject(Attributes.key)>
	<cfelseif NOT IsSimpleValue(Attributes.default)>
		<cfset userdata = StructCopy(Attributes.default)>
		<cfset userdata.id_direccion = "">
	<cfelse>
		<cfset userdata = NewDataObject()>
	</cfif>
</cfif>

<cffunction name="NombrePais" output="false" access="private">
	<cfargument name="pais" required="yes">
	
	<cfquery name="qpais" datasource="asp" >
		select Pnombre
		from Pais
		where Ppais=<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.pais#">
	</cfquery>
	<cfreturn qpais.Pnombre>
</cffunction> 

<cfif ListFindNoCase('insert,select,update,readform,new', attributes.action)>
	<!--- tags que requieren name --->
	<cfparam name="Attributes.name" default="cf_direccion">
</cfif>

<cfif attributes.action is 'input'>
	<!--- start of action=input --->
	<cfquery datasource="asp" name="rsPais">
		select Ppais, Pnombre
		from Pais
		order by Pnombre
	</cfquery>
	
	<!--- start of action=input --->
	<cfoutput>
	<table border="0" width="100%">
	<cfif Len(Trim(Attributes.title))>
		    <tr>
	      <td colspan="2" align="center" class="tituloListas">#Attributes.title#</td>
    </tr></cfif>
	    <tr>
	      <td nowrap align="left">Atenci&oacute;n a:&nbsp;</td>
	      <td ><input name="#Attributes.prefix#atencion" id="#Attributes.prefix#atencion" onFocus="this.select()" size="60" maxlength="255" value="#userdata.atencion#" ></td>
    </tr>
	    <tr>
	      <td nowrap align="left">Direcci&oacute;n 1:&nbsp;</td>
	      <td ><input name="#Attributes.prefix#direccion1" id="#Attributes.prefix#direccion1" onFocus="this.select()" size="60" maxlength="255" value="#userdata.direccion1#" ></td>
    </tr>
	    <tr>
	      <td nowrap align="left">Direcci&oacute;n 2:&nbsp;</td>
	      <td ><input name="#Attributes.prefix#direccion2" id="#Attributes.prefix#direccion2" onFocus="this.select()" size="60" maxlength="255"  value="#userdata.direccion2#"  ></td>
    </tr>
	    <tr>
	      <td align="left">Ciudad:&nbsp;</td>
	      <td valign="top"><input name="#Attributes.prefix#ciudad" type="text" id="#Attributes.prefix#ciudad" onFocus="this.select()" value="#userdata.ciudad#" size="30" maxlength="30" ></td>
    </tr>
	    <tr>
	      <td align="left">Estado:&nbsp;</td>
	      <td valign="top"><input name="#Attributes.prefix#estado" type="text" id="#Attributes.prefix#estado" onFocus="this.select()" value="#userdata.estado#" size="30" maxlength="30" ></td>
    </tr>
	    <tr>
	      <td align="left">C&oacute;digo Postal:&nbsp;</td>
	      <td valign="top"><input name="#Attributes.prefix#cod_Postal" type="text" id="#Attributes.prefix#cod_Postal" onFocus="this.select()" value="#userdata.cod_Postal#" size="30" maxlength="60"></td>
    </tr>
	    <tr>
	      <td align="left">Pa&iacute;s:&nbsp;</td>
	      <td valign="top">
            <select name="#Attributes.prefix#pais" id="#Attributes.prefix#pais">
              <cfloop query="rsPais">
                <option value="#rsPais.Ppais#" <cfif userdata.pais eq  rsPais.Ppais>selected</cfif>>#rsPais.Pnombre#</option>
              </cfloop>
            </select>
          </td>
    </tr>
	</table>
	
	</cfoutput>
	<!--- end of action=input --->
<cfelseif attributes.action is 'display'>
	
	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
<!---
		<cfif Len(Trim(Attributes.title))>
		<tr>
		  <td colspan="2"  align="center" class="tituloListas">#Attributes.title#</td>
		  </tr></cfif>
--->		  
		  
		<!---
		<cfif len(Trim(userdata.atencion))>
		<tr>
		<td  align="left" nowrap>Atenci&oacute;n a </td>
		<td align="right" nowrap>
		#userdata.atencion# </td>
		</tr></cfif>
--->		
		
		
		<cfif len(Trim(userdata.direccion1))><tr>
		<!---<td  align="left" nowrap>Direcci&oacute;n</td>--->
		<td align="left" nowrap>
		#userdata.direccion1# </td>
		</tr></cfif>

		<!---
		<cfif len(Trim(userdata.direccion2))><tr>
		<!---<td  align="left" nowrap><cfif len(Trim(userdata.direccion1))>&nbsp;<cfelse>Direcci&oacute;n</cfif></td>--->
		<td align="right" nowrap>
		#userdata.direccion2# </td>
		</tr></cfif>
--->		
		
		<cfif len(Trim(userdata.ciudad))><tr>
		<!---<td  align="left" nowrap>Ciudad</td>--->
		<td align="left" nowrap>
		#userdata.ciudad# </td>
		</tr></cfif>
		<cfif len(Trim(userdata.estado))><tr>
		<!---<td   align="left"nowrap>Estado</td>--->
		<td align="left" nowrap>
		#userdata.estado# </td>
		</tr></cfif>
		<cfif len(Trim(userdata.cod_Postal))><tr>
		<!---<td  align="left">C&oacute;digo Postal</td>--->
		<td valign="top" align="left">
		#userdata.cod_Postal#</td>
		</tr></cfif>
		<cfif len(Trim(userdata.pais))><tr>
		<!---<td  align="left">Pa&iacute;s</td>--->
		<td valign="top" align="left">
		#NombrePais(userdata.pais)#</td>
		</tr></cfif>
		</table>
	</cfoutput>
	<!--- end of action=display --->
<cfelseif attributes.action is 'label'>

	<cfoutput>
		<table border="0" cellspacing="0" cellpadding="1">
		<cfif Len(Trim(Attributes.title))>
		<tr>
		  <td  align="center" class="tituloListas">#Attributes.title#</td>
		  </tr>
		<tr></cfif>
		<cfif Len(Trim(userdata.atencion))>
		<td nowrap>
		#userdata.atencion# </td>
		</tr>
		</cfif>
		<cfif Len(Trim(userdata.direccion1))>
		<tr>
		<td nowrap>
		#userdata.direccion1# </td>
		</tr>
		</cfif>
		<cfif Len(Trim(userdata.direccion2))>
		<tr>
		<td nowrap>
		#userdata.direccion2# </td>
		</tr>
		</cfif>
		<cfif Len(Trim(userdata.ciudad))+Len(Trim(userdata.estado))+Len(Trim(userdata.cod_Postal))>
		<tr>
		<td nowrap>
		#userdata.ciudad#<cfif Len(Trim(userdata.ciudad))*Len(Trim(userdata.estado))>, </cfif> #userdata.estado# #userdata.cod_Postal# </td>
		</tr>
		</cfif>
		<cfif Len(Trim(userdata.pais))>
		<tr>
		<td valign="top">
		#NombrePais(userdata.pais)#</td>
		</tr>
		</cfif>
	  </table>
	</cfoutput>
	<!--- end of action=label --->
<cfelseif attributes.action is 'hidden'>
	<cfoutput>
		<input name="#Attributes.prefix#atencion" type="hidden" id="#Attributes.prefix#atencion" value="#userdata.atencion#">
		<input name="#Attributes.prefix#direccion1" type="hidden" id="#Attributes.prefix#direccion1" value="#userdata.direccion1#">
		<input name="#Attributes.prefix#direccion2" type="hidden" id="#Attributes.prefix#direccion2" value="#userdata.direccion2#">
		<input name="#Attributes.prefix#ciudad" type="hidden" id="#Attributes.prefix#ciudad" value="#userdata.ciudad#">
		<input name="#Attributes.prefix#estado" type="hidden" id="#Attributes.prefix#estado" value="#userdata.estado#">
		<input name="#Attributes.prefix#cod_Postal" type="hidden" id="#Attributes.prefix#cod_Postal" value="#userdata.cod_Postal#">
		<input name="#Attributes.prefix#pais" type="hidden" id="#Attributes.prefix#pais" value="#userdata.pais#">
		<cfif isdefined("userdata.id_direccion")>
		<input type="hidden" name="#Attributes.prefix#id_direccion" id="#Attributes.prefix#id_direccion" value="#userdata.id_direccion#">
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
		if (IsDefined("form." & Attributes.prefix & "id_direccion"))
			ret.id_direccion = form[Attributes.prefix & "id_direccion"];
		if (IsDefined("form." & Attributes.prefix & "atencion"))
			ret.atencion = form[Attributes.prefix & "atencion"];
		if (IsDefined("form." & Attributes.prefix & "direccion1"))
			ret.direccion1 = form[Attributes.prefix & "direccion1"];
		if (IsDefined("form." & Attributes.prefix & "direccion2"))
			ret.direccion2 = form[Attributes.prefix & "direccion2"];
		if (IsDefined("form." & Attributes.prefix & "ciudad"))
			ret.ciudad = form[Attributes.prefix & "ciudad"];
		if (IsDefined("form." & Attributes.prefix & "estado"))
			ret.estado = form[Attributes.prefix & "estado"];
		if (IsDefined("form." & Attributes.prefix & "cod_Postal"))
			ret.cod_Postal = form[Attributes.prefix & "cod_Postal"];
		if (IsDefined("form." & Attributes.prefix & "pais"))
			ret.pais = form[Attributes.prefix & "pais"];
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
	<!--- end of action=readform --->
	<cfif IsDefined("userdata.id_direccion") and Len(Trim(userdata.id_direccion)) NEQ 0>
		<cfset UpdateDataObject(userdata)>
		<cfset ret = ReadDataObject(userdata.id_direccion)>
	<cfelse>
		<cfset inserted_id = InsertDataObject(userdata)>
		<cfset ret = ReadDataObject(inserted_id)>
	</cfif>
	<cfset Caller[Attributes.name] = ret>
<cfelse>
	<cfthrow message="Action invalido: #Attributes.action#">
</cfif>