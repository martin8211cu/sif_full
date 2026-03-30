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
	direccion1,direccion2,estado,codPostal,ciudad,pais: Datos de la tarjeta por insertar o actualizar.
	title: indica el encabezado del portletcito (action=input)
--->

<cfparam name="Attributes.action">
<cfparam name="Attributes.Conexion" default="asp">
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
		ret.pais = "MX";
		return ret;
	}
</cfscript>

<cffunction name="ReadDataObject">
	<cfargument name="key" required="yes">
	<cfquery datasource="#Attributes.Conexion#" name="ReadDataObject_QueryDirecciones">
		select * from Direcciones
		where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#key#" null="#Len(key) IS 0#">
	</cfquery>

	<cfquery datasource="#session.dsn#" name="rsClaveE">
		select * from CSATEstados
		where CSATdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(ReadDataObject_QueryDirecciones.estado)#">

	</cfquery>

	<cfset ret = NewDataObject()>
	<cfif ReadDataObject_QueryDirecciones.RecordCount>
		<cfset ret.id_direccion = ReadDataObject_QueryDirecciones.id_direccion>
		<cfset ret.atencion = Trim(ReadDataObject_QueryDirecciones.atencion)>
		<cfset ret.direccion1 = Trim(ReadDataObject_QueryDirecciones.direccion1)>
		<cfset ret.direccion2 = Trim(ReadDataObject_QueryDirecciones.direccion2)>
		<cfset ret.ciudad = Trim(ReadDataObject_QueryDirecciones.ciudad)>
		<cfset ret.estado = Trim(ReadDataObject_QueryDirecciones.estado)>
		<cfif ReadDataObject_QueryDirecciones.Ppais eq 'MX'>
			<cfset ret.codPostal = Trim(ReadDataObject_QueryDirecciones.CSATcodigo)>
		<cfelse>
			<cfset ret.codPostal = Trim(ReadDataObject_QueryDirecciones.codPostal)>
		</cfif>

		<cfset ret.pais = ReadDataObject_QueryDirecciones.Ppais>
		<cfif rsClaveE.RecordCount gt 0>
			<cfset ret.EstadoC = Trim(rsClaveE.CSATcodigo)>
		</cfif>
	</cfif>
	<cfreturn ret>
</cffunction>

<cffunction name="InsertDataObject">
    <cfargument name="userdata" required="yes">
	<!--- Oparrales --->
	<cfquery name="rsEclave" datasource="minisif">
		Select
			e.CSATdescripcion
		from CSATEstados e
		inner join Pais p on p.CSATPclave = e.Pclave
		where e.CSATdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.estado#">
	</cfquery>
	<cfset varEstado = (trim(rsEclave.CSATdescripcion) eq '' ? -1 : rsEclave.CSATdescripcion)>

	<cfquery datasource="#Attributes.Conexion#" name="inserted">
		insert INTO Direcciones (
			atencion, direccion1, direccion2,
			ciudad, estado, codPostal, Ppais,
			BMUsucodigo, BMfechamod,CSATcodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.atencion#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.direccion1#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.direccion2#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.ciudad#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#varEstado#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.codpostal#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.pais#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfif userdata.pais eq 'MX'>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codpostal#">
			<cfelse>
				''
			</cfif>)

		<cf_dbidentity1 verificar_transaccion="false" datasource="#Attributes.Conexion#">
	</cfquery>

	<cf_dbidentity2 verificar_transaccion="false" datasource="#Attributes.Conexion#" name="inserted">
	<cfreturn inserted.identity>
</cffunction>

<cffunction name="UpdateDataObject">
<cfargument name="userdata" required="yes">
	<cfquery datasource="#Attributes.Conexion#" name="updated">
		update Direcciones
		set atencion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.atencion#">,
			direccion1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.direccion1#">,
			direccion2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.direccion2#">,
			ciudad = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.ciudad#">,
			estado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.estado#">,
			codPostal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.codPostal#">,
			Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.pais#">,
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfif userdata.pais eq 'MX'>
				CSATcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.codPostal#">
			<cfelse>
				CSATcodigo = ''
			</cfif>
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
	<cfparam name="Attributes.tamano_letra"  default="">
	<cfparam name="Attributes.negrita"  default="true">
	<cfparam name="Attributes.tabindex"  default="1">
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

	<cfquery name="qpais" datasource="#Attributes.Conexion#" >
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
	<cfquery datasource="#Attributes.Conexion#" name="rsPais">
		select Ppais, Pnombre
		from Pais
		order by Pnombre
	</cfquery>

	<!--- start of action=input --->
	<cfoutput>
	<cfset list1 = " ,.,á,é,í,ó,ú">
	<cfset list2 = "_,_,a,e,i,o,u">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_#ReplaceList(Attributes.title,list1,list2)#"
	Default="#Attributes.title#"
	returnvariable="LB_V1"/>

	<table border="0" width="100%">
		<cfif Len(Trim(Attributes.title))>
			<tr>
				<td colspan="2" align="center" class="tituloListas">#LB_V1#</td>
			</tr>
		</cfif>
	    <tr>
			<td nowrap align="right"><font  style="font-size:#Attributes.tamano_letra#px"><cfif Attributes.negrita><b></cfif><cf_translate  key="LB_AtencionA">Contacto</cf_translate>:&nbsp;<cfif Attributes.negrita></b></cfif></font></td>
			<td ><input tabindex="#Attributes.tabindex#" style="font-size:#Attributes.tamano_letra#px" name="#Attributes.prefix#atencion" id="#Attributes.prefix#atencion" onFocus="this.select()" size="60" maxlength="255" value="#userdata.atencion#" ></td>
		</tr>
	    <tr>
	      	<td nowrap align="right"><font  style="font-size:#Attributes.tamano_letra#px"><cfif Attributes.negrita><b></cfif><cf_translate  key="LB_Direccion1">Direcci&oacute;n 1</cf_translate>:&nbsp;<cfif Attributes.negrita></b></cfif></font></td>
	      	<td ><input tabindex="#Attributes.tabindex#" style="font-size:#Attributes.tamano_letra#px" name="#Attributes.prefix#direccion1" id="#Attributes.prefix#direccion1" onFocus="this.select()" size="60" maxlength="255" value="#userdata.direccion1#" ></td>
    	</tr>
	    <tr>
	      	<td nowrap align="right"><font  style="font-size:#Attributes.tamano_letra#px"><cfif Attributes.negrita><b></cfif><cf_translate  key="LB_Direccion2">Direcci&oacute;n 2</cf_translate>:&nbsp;<cfif Attributes.negrita></b></cfif></font></td>
	    	<td ><input tabindex="#Attributes.tabindex#" style="font-size:#Attributes.tamano_letra#px" name="#Attributes.prefix#direccion2" id="#Attributes.prefix#direccion2" onFocus="this.select()" size="60" maxlength="255"  value="#userdata.direccion2#"  ></td>
    	</tr>
		<tr>
			<td align="right"><font  style="font-size:#Attributes.tamano_letra#px"><cfif Attributes.negrita><b></cfif><cf_translate  key="LB_Pais">Pa&iacute;s</cf_translate>:&nbsp;<cfif Attributes.negrita></b></cfif></font></td>
			<td valign="top">
			<select name="#Attributes.prefix#pais" onchange="cambiaEstados(this);" id="#Attributes.prefix#pais" style="font-size:#Attributes.tamano_letra#px" tabindex="#Attributes.tabindex#" >
				<option value="" selected>-- Seleccione --</option>
				<cfloop query="rsPais">
				<option value="#rsPais.Ppais#" <cfif userdata.pais eq  rsPais.Ppais>selected</cfif>>#rsPais.Pnombre#</option>
				</cfloop>
			</select>
			</td>
		</tr>
		<tr>
			<td align="right"><font  style="font-size:#Attributes.tamano_letra#px"><cfif Attributes.negrita><b></cfif><cf_translate  key="LB_Estado">Estado</cf_translate>:&nbsp;<cfif Attributes.negrita></b></cfif></font></td>
			<!--- <td valign="top"><input tabindex="#Attributes.tabindex#" style="font-size:#Attributes.tamano_letra#px" name="#Attributes.prefix#estado" type="text" id="#Attributes.prefix#estado" onFocus="this.select()" value="#userdata.estado#" size="30" maxlength="30" ></td> --->
			<td align="top">
				<select name="#Attributes.prefix#estado" id="#Attributes.prefix#estado" style="font-size:#Attributes.tamano_letra#px" tabindex="#Attributes.tabindex#" onchange="cambiaFiltro(this);">
					<option value="" selected>-- Seleccione --</option>
					<!--- <option value="-1">-- Seleccione --</option> --->
				</select>
			</td>
		</tr>
		<tr>
			<td align="right"><font  style="font-size:#Attributes.tamano_letra#px"><cfif Attributes.negrita><b></cfif><cf_translate  key="LB_Ciudad">Ciudad</cf_translate>:&nbsp;<cfif Attributes.negrita></b></cfif></font></td>
			<td valign="top"><input tabindex="#Attributes.tabindex#" style="font-size:#Attributes.tamano_letra#px" name="#Attributes.prefix#ciudad" type="text" id="#Attributes.prefix#ciudad" onFocus="this.select()" value="#userdata.ciudad#" size="30" maxlength="30" ></td>
		</tr>
		<tr>
			<td align="right" nowrap="nowrap"><font  style="font-size:#Attributes.tamano_letra#px"><cfif Attributes.negrita><b></cfif><cf_translate  key="LB_CodigoPostal">C&oacute;digo Postal</cf_translate>:&nbsp;<cfif Attributes.negrita></b></cfif></font></td>
			<td valign="top" id="unCP">
				<div id="miConlis">
					<cfset valuesArray = ArrayNew(1)>
					<cfif trim(userdata.codPostal) neq ''>
						<cfquery name="rsCatalogo" datasource="#session.dsn#">
							select a.CSATcodigo,a.CSATEcodigo,e.CSATdescripcion
							from CSATCodPostal a inner join CSATEstados e
							on a.CSATEcodigo = e.CSATcodigo
							where a.CSATcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userdata.codPostal#">
						</cfquery>
						<cfset ArrayAppend(valuesArray, '#trim(rsCatalogo.CSATcodigo)#')>
						<!--- <cfset ArrayAppend(valuesArray, '#trim(rsCatalogo.CSATEcodigo)#')> --->
						<cfset ArrayAppend(valuesArray, '#trim(rsCatalogo.CSATdescripcion)#')>
					</cfif>

					<cf_conlis title="Codigo Postal"
							campos = "#Attributes.prefix#codpostal,#Attributes.prefix#codDescripcion"
							desplegables = "S,S"
							modificables = "S,N"
							size = "8,27"
							tabla="CSATCodPostal a inner join CSATEstados e on e.CSATcodigo = a.CSATEcodigo"
							columnas="a.CSATcodigo as #Attributes.prefix#codpostal,concat(a.CSATEcodigo,' - ',e.CSATdescripcion) as #Attributes.prefix#codDescripcion"
							desplegar="#Attributes.prefix#codpostal,#Attributes.prefix#codDescripcion"
							etiquetas="Codigo,Estado"
							formatos="S,S"
							align="left,left"
							asignar="#Attributes.prefix#codpostal, #Attributes.prefix#codDescripcion"
							asignarformatos="S,S"
							showEmptyListMsg="true"
							debug="false"
							tabindex="1"
							form="#Attributes.form#"
							conexion="#session.dsn#"
							filtrar_por="a.CSATcodigo ,e.CSATdescripcion"
							valuesArray="#valuesArray#"
							>
				</div>
			</td>
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
		<td  align="left" nowrap><cfif Attributes.negrita><b></cfif><cf_translate  key="LB_AtencionA">Atenci&oacute;n a</cf_translate> <cfif Attributes.negrita></b></cfif></td>
		<td align="right" nowrap>
		#userdata.atencion# </td>
		</tr></cfif>
		<cfif len(Trim(userdata.direccion1))><tr>
		<td  align="left" nowrap><cfif Attributes.negrita><b></cfif><cf_translate  key="LB_Direccion1">Direcci&oacute;n 1</cf_translate><cfif Attributes.negrita></b></cfif></td>
		<td align="right" nowrap>
		#userdata.direccion1# </td>
		</tr></cfif>
		<cfif len(Trim(userdata.direccion2))><tr>
		<td  align="left" nowrap><cfif Attributes.negrita><b></cfif><cf_translate  key="LB_Direccion2">Direcci&oacute;n 2</cf_translate><cfif Attributes.negrita></b></cfif></td>
		<td align="right" nowrap>
		#userdata.direccion2# </td>
		</tr></cfif>
		<cfif len(Trim(userdata.ciudad))><tr>
		<td  align="left" nowrap><cfif Attributes.negrita><b></cfif><cf_translate  key="LB_Ciudad">Ciudad</cf_translate><cfif Attributes.negrita></b></cfif></td>
		<td align="right" nowrap>
		#userdata.ciudad# </td>
		</tr></cfif>
		<cfif IsDefined('userdata.estado') and len(Trim(userdata.estado))>
		<tr>
			<td   align="left"nowrap>
				<cfif Attributes.negrita>
					<b>
				</cfif>
				<cf_translate  key="LB_Estado">Estado</cf_translate>
				<cfif Attributes.negrita>
					</b>
				</cfif>
			</td>
			<td align="right" nowrap>
				#userdata.estado#
			</td>
		</tr>
		<cfelse>
			<tr>
				<td align="left"nowrap></td>
				<td align="left"nowrap></td>
			</tr>
		</cfif>
		<cfif len(Trim(userdata.codPostal))><tr>
		<td  align="left"><cfif Attributes.negrita><b></cfif><cf_translate  key="LB_CodigoPostal">C&oacute;digo Postal</cf_translate><cfif Attributes.negrita></b></cfif></td>
		<td valign="top" align="right">
		#userdata.codPostal#</td>
		</tr></cfif>
		<cfif len(Trim(userdata.pais))><tr>
		<td  align="left"><cfif Attributes.negrita><b></cfif><cf_translate  key="LB_Pais">Pa&iacute;s</cf_translate><cfif Attributes.negrita></b></cfif></td>
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
<!--- oparrales --->
<script type="text/javascript">

	var contador = 0;

	if(contador == 0)
	{
		<cfoutput>
			cambiaEstados(document.getElementById('#Attributes.prefix#pais'));
		</cfoutput>
	}

	function cambiaEstados(Pais)
	{
		var clvPais = Pais.options[Pais.selectedIndex].value;
		<cfoutput>
		var estadoD = '';
		<cfif IsDefined('userData.estado')>
			estadoD = '#trim(userData.estado)#';
		</cfif>
		$.ajax({
     		type: "POST",
     		url: "/cfmx/sif/Utiles/ajaxCambiaEstados.cfc?method=getOptions",
     		data: {'ClavePais' : clvPais,
     				'EstadoD' : estadoD},
            success: function(obj)
            {
            	//sobreescribiendo el contenido del combo de estados.
            	document.getElementById('#Attributes.prefix#estado').innerHTML = obj;
            	contador = 1;
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
                   alert("Status: " + textStatus); alert("Error: " + errorThrown);
               }
    	});

		if(clvPais != 'MX')
		{
	    	document.getElementById('miInput').style.display = 'block';
	    	document.getElementById('miConlis').style.display = 'none';
		}
		else
		{
			document.getElementById('miInput').style.display = 'none';
	    	document.getElementById('miConlis').style.display = 'block';
		}
		</cfoutput>
	}
</script>
