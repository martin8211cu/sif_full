<!---
	<cf_direccion action="input" key="#id_direccion#" default="#data_defaults#">
	<cf_direccion action="input" data="#data_direccion#" default="#data_defaults#">
	<cf_direccion action="select" key="#id_direccion#" name="variable_name">
	<cf_direccion action="insert" name="variable_name" data="...">
	<cf_direccion action="insert" name="variable_name" direccion1=".." direccion2="..
			estado=".." codPostal=".." ciudad=".." pais=".." >
	<cf_direccion action="update" key="#id_tarjeta#" name="variable_name" data="...">
	<cf_direccion action="update" key="#id_tarjeta#" name="variable_name" direccion1=".." direccion2="..
			estado=".." codPostal=".." ciudad=".." pais=".." >
	<cf_direccion action="new" name="variable_name">
	<cf_direccion action="readform" name="variable_name" prefix="...">
Parametros:
	action: indica el tipo de accin por realizar.
		input: dibuja un table con los campos de entrada necesarios para capturar una tarjeta
		select: lee los datos de una tarjeta y los regresa en una variable
		insert: inserta una nueva tarjeta. regresa los datos en una variable
		update: actualiza los valores de una tarjeta, y los regresa nuevamente en una variable
	key:    es la llave de la tarjeta que se va a leer (action=select) o actualizar (action=update)
	data:  es la variable que contiene los datos de la tarjeta que se van a desplegar, si est
			vaco despliega el formulario en modo alta (action=input)
	default:es la variable que contiene los datos de la tarjeta que se van a desplegar, 
			La diferencia con data radica en que si se utiliza el default, no se tomar en cuenta su id
			(action=input)
	direccion1,direccion2,estado,codPostal,ciudad,pais: Datos de la tarjeta por insertar o actualizar.
	title: indica el encabezado del portletcito (action=input)
--->
<cfparam name="Attributes.action">
<cfparam name="Attributes.tabindex" default="">
<cfparam name="Attributes.datasource" default="">
<cfif Len(Attributes.datasource) EQ 0>
	<cfset Attributes.datasource = session.dsn>
</cfif>
<cfparam name="Attributes.form" default="form1">
<cfscript>
	function NewDataObject() {
		var ret = StructNew();
		ret.id_direccion = "";
		ret.atencion = "";
		ret.direccion1 = "";
		ret.direccion2 = "";
		ret.ciudad = "";
		ret.estado = "";
		ret.codPostal = "";
		ret.pais = "";
		return ret;
	}
</cfscript>

<cffunction name="ReadDataObject">
	<cfargument name="key" required="yes">

	<cfquery datasource="#Attributes.datasource#" name="ReadDataObject_QueryDirecciones">
		select * from DireccionesSIF
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
		<cfset ret.codPostal = Trim(ReadDataObject_QueryDirecciones.codPostal)>
		<cfset ret.pais = ReadDataObject_QueryDirecciones.Ppais>
		<!--- adicion danim, 12/4/05 : traer direccion completa --->
		<cfset comp = ArrayNew(1)> 
		<cfif Len(ret.atencion)><cfset ArrayAppend(comp, ret.atencion)></cfif>
		<cfif Len(ret.direccion1)><cfset ArrayAppend(comp, ret.direccion1)></cfif>
		<cfif Len(ret.direccion2)><cfset ArrayAppend(comp, ret.direccion2)></cfif>
		<cfif Len(ret.ciudad)><cfset ArrayAppend(comp, ret.ciudad)></cfif>
		<cfif Len(ret.estado)+Len(ret.codPostal)>
			<cfif Len(ret.estado)>
				<cfset ArrayAppend(comp, ret.estado & " " & ret.codPostal)>
			<cfelse>
				<cfset ArrayAppend(comp, "ZIP " & ret.codPostal)>
			</cfif>
		</cfif>
		<cfset ret.completa = ArrayToList(comp, Chr(13)&Chr(10))>
	</cfif>
	<cfreturn ret>
</cffunction>

<cffunction name="InsertDataObject">
<cfargument name="userdata" required="yes">
	<cftransaction>
		<cfquery datasource="#Attributes.datasource#" name="inserted">
			insert INTO DireccionesSIF (
				atencion, direccion1, direccion2,
				ciudad, estado, codPostal, Ppais,
				BMUsucodigo, BMfechamod)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.atencion#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.direccion1#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.direccion2#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.ciudad#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.estado#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.codPostal#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.pais#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
				
			<cf_dbidentity1 datasource="#Attributes.datasource#">
		</cfquery>
		
		<cf_dbidentity2 datasource="#Attributes.datasource#" name="inserted">
	</cftransaction>
	
	<cfreturn inserted.identity>
</cffunction>

<cffunction name="UpdateDataObject">
<cfargument name="userdata" required="yes">
	<cfquery datasource="#Attributes.datasource#" name="updated">
		update DireccionesSIF
		set atencion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.atencion#">,
			direccion1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.direccion1#">,
			direccion2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.direccion2#">,
			ciudad = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.ciudad#">,
			estado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.estado#">,
			codPostal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.codPostal#">,
			Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.pais#">,
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
	<cfparam name="Attributes.title"   default="Direcci&oacute;n">
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
	
	<cfquery name="qpais" datasource="#Attributes.datasource#" >
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
	<cfquery datasource="#Attributes.datasource#" name="rsPais">
		select Ppais, Pnombre
		from Pais
		<!--- where Ppais = 'PA' --->
		order by Pnombre
	</cfquery>
	<cfquery name="rsPaisE" datasource="#session.DSN#">
		select Ppais
		from Empresas emp
			inner join Empresa e
					inner join Direcciones d
					on d.id_direccion = e.id_direccion
			on e.Ecodigo = emp.EcodigoSDC
		where emp.Ecodigo = #session.Ecodigo#
	</cfquery>

	<!--- start of action=input --->
	<cfoutput>
	<table border="0" width="100%">
	<cfif Len(Trim(Attributes.title))>
		    <tr>
	      <td colspan="2" align="center" class="tituloListas">#Attributes.title#</td>
    </tr></cfif>
	    <tr>
	      <td nowrap align="right"><b><cf_translate  key="LB_AtencionA">Atenci&oacute;n a</cf_translate>:&nbsp;</b></td>
	      <td ><input <cfif len(trim(Attributes.tabindex))>tabindex = "#Attributes.tabindex#"</cfif> name="#Attributes.prefix#atencion" id="#Attributes.prefix#atencion" onFocus="this.select()" size="60" maxlength="255" value="#userdata.atencion#" ></td>
    </tr>
	    <tr>
	      <td nowrap align="right"><b><cf_translate  key="LB_Direccion1">Direcci&oacute;n 1</cf_translate>:&nbsp;</b></td>
	      <td ><input <cfif len(trim(Attributes.tabindex))>tabindex = "#Attributes.tabindex#"</cfif> name="#Attributes.prefix#direccion1" id="#Attributes.prefix#direccion1" onfocus="this.select()" size="60" maxlength="255" value="#userdata.direccion1#" /></td>
	    </tr>
	    <tr>
		  <td nowrap align="right"><b><cf_translate  key="LB_Direccion2">Direcci&oacute;n 2</cf_translate>:&nbsp;</b></td>
	      <td ><input <cfif len(trim(Attributes.tabindex))>tabindex = "#Attributes.tabindex#"</cfif> name="#Attributes.prefix#direccion2" id="#Attributes.prefix#direccion2" onFocus="this.select()" size="60" maxlength="255"  value="#userdata.direccion2#"  ></td>
    </tr>
	    <tr>
	      <td align="right"><b><cf_translate  key="LB_Ciudad">Ciudad</cf_translate>:&nbsp;</b></td>
	      <td valign="top"><input <cfif len(trim(Attributes.tabindex))>tabindex = "#Attributes.tabindex#"</cfif> name="#Attributes.prefix#ciudad" type="text" id="#Attributes.prefix#ciudad" onFocus="this.select()" value="#userdata.ciudad#" size="30" maxlength="30" ></td>
    </tr>
	    <tr>
	      <td align="right"><b><cf_translate  key="LB_Estado">Estado</cf_translate>:&nbsp;</b></td>
	      <td valign="top"><input <cfif len(trim(Attributes.tabindex))>tabindex = "#Attributes.tabindex#"</cfif> name="#Attributes.prefix#estado" type="text" id="#Attributes.prefix#estado" onFocus="this.select()" value="#userdata.estado#" size="30" maxlength="30" ></td>
    </tr>
	    <tr>
	      <td align="right"><b><cf_translate  key="LB_CodigoPostal">C&oacute;digo Postal</cf_translate>:&nbsp;</b></td>
	      <td valign="top">
		  	<cfset valuesArray = ArrayNew(1)>
		  	<cfif trim(userdata.codPostal) neq ''>
				<cfquery name="rsCatalogo" datasource="#session.dsn#">
					select a.CSATcodigo,a.CSATEcodigo, concat(a.CSATEcodigo,' - ',e.CSATdescripcion) as CSATdescripcion
					from CSATCodPostal a inner join CSATEstados e
					on a.CSATEcodigo = e.CSATcodigo
					where a.CSATcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.codPostal#">
				</cfquery>
				<cfset ArrayAppend(valuesArray, '#trim(rsCatalogo.CSATcodigo)#')>
				<!--- <cfset ArrayAppend(valuesArray, '#trim(rsCatalogo.CSATEcodigo)#')> --->
				<cfset ArrayAppend(valuesArray, '#trim(rsCatalogo.CSATdescripcion)#')>
			</cfif>

			<cf_conlis title="Codigo Postal"
					alt = "El campo Código Postal del Socio"
					campos = "#Attributes.prefix#codPostal,#Attributes.prefix#descPostal"
					desplegables = "S,S"
					modificables = "S,N"
					size = "8,27"
					tabla="CSATCodPostal a inner join CSATEstados e on e.CSATcodigo = a.CSATEcodigo"
					columnas="a.CSATcodigo as #Attributes.prefix#codPostal,concat(a.CSATEcodigo,' - ',e.CSATdescripcion) as #Attributes.prefix#descPostal"
					desplegar="#Attributes.prefix#codPostal,#Attributes.prefix#descPostal"
					etiquetas="Codigo,Estado"
					formatos="S,S"
					align="left,left"
					asignar="#Attributes.prefix#codPostal, #Attributes.prefix#descPostal"
					asignarformatos="S,S"
					showEmptyListMsg="true"
					debug="false"
					tabindex="1"
					form="#Attributes.form#"
					conexion="#session.dsn#"
					filtrar_por="a.CSATcodigo,e.CSATdescripcion"
					valuesArray="#valuesArray#"
					>
		  </td>
    </tr>
	
	<cfif userdata.pais EQ ''>
		<cfset userdata.pais = rsPaisE.Ppais>
	</cfif>
	    <tr>
	      <td align="right"><b><cf_translate  key="LB_Pais">Pa&iacute;s</cf_translate>:&nbsp;</b></td>
	      <td valign="top">
            <select <cfif len(trim(Attributes.tabindex))>tabindex = "#Attributes.tabindex#"</cfif> name="#Attributes.prefix#pais" id="#Attributes.prefix#pais">
              <cfloop query="rsPais">
					<option value="#rsPais.Ppais#" <cfif userdata.pais eq  rsPais.Ppais>selected</cfif>>#rsPais.Pnombre#</option>
              </cfloop>
            </select>          </td>
    </tr>
	</table>
	
	</cfoutput>
	<!--- end of action=input --->
<cfelseif attributes.action is 'display'>
	
	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<cfif Len(Trim(Attributes.title))>
		<tr>
		  <td colspan="2"  align="center" class="tituloListas">#Attributes.title#</td>
		  </tr></cfif>
		<cfif len(Trim(userdata.atencion))>
		<tr>
		<td  align="left" nowrap><b><cf_translate  key="LB_AtencionA">Atenci&oacute;n a</cf_translate></b></td>
		<td align="right" nowrap>
		#userdata.atencion# </td>
		</tr></cfif>
		<cfif len(Trim(userdata.direccion1))><tr>
		<td  align="left" nowrap><b><cf_translate  key="LB_Direccion1">Direcci&oacute;n 1</cf_translate></b></td>
		<td align="right" nowrap>
		#userdata.direccion1# </td>
		</tr></cfif>
		<cfif len(Trim(userdata.direccion2))><tr>
		<td  align="left" nowrap><b><cf_translate  key="LB_Direccion2">Direcci&oacute;n 2</cf_translate></b></td>
		<td align="right" nowrap>
		#userdata.direccion2# </td>
		</tr></cfif>
		<cfif len(Trim(userdata.ciudad))><tr>
		<td  align="left" nowrap><b><cf_translate  key="LB_Ciudad">Ciudad</cf_translate></b></td>
		<td align="right" nowrap>
		#userdata.ciudad# </td>
		</tr></cfif>
		<cfif len(Trim(userdata.estado))><tr>
		<td   align="left"nowrap><b><cf_translate  key="LB_Estado">Estado</cf_translate></b></td>
		<td align="right" nowrap>
		#userdata.estado# </td>
		</tr></cfif>
		<cfif len(Trim(userdata.codPostal))><tr>
		<td  align="left"><b><cf_translate  key="LB_CodigoPostal">C&oacute;digo Postal</cf_translate></b></td>
		<td valign="top" align="right">
		#userdata.codPostal#</td>
		</tr></cfif>
		<cfif len(Trim(userdata.pais))><tr>
		<td  align="left"><b><cf_translate  key="LB_CodigoPostal">Pais</cf_translate></b></td>
		<td valign="top" align="right">
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
		<cfif Len(Trim(userdata.ciudad))+Len(Trim(userdata.estado))+Len(Trim(userdata.codPostal))>
		<tr>
		<td nowrap>
		#userdata.ciudad#<cfif Len(Trim(userdata.ciudad))*Len(Trim(userdata.estado))>, </cfif> #userdata.estado# #userdata.codPostal# </td>
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
		<input name="#Attributes.prefix#codPostal" type="hidden" id="#Attributes.prefix#codPostal" value="#userdata.codPostal#">
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
		if (IsDefined("form." & Attributes.prefix & "codPostal"))
			ret.codPostal = form[Attributes.prefix & "codPostal"];
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
	<cf_errorCode	code = "50622"
					msg  = "Action invalido: @errorDat_1@"
					errorDat_1="#Attributes.action#"
	>
</cfif>

