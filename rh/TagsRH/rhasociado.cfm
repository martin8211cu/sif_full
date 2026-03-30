<cfset def = QueryNew('dato')>

<cfparam name="Attributes.TipoId" default="" type="string"> <!--- Indica si se va a manejar el Tipo de Identificación, cuando no se indica se coloca un combo, se puede colocar un -1 para indicar que no se va a manejar el tipo de identificación --->
<cfparam name="Attributes.index" default="0" type="numeric"> <!--- Se utiliza cuando se quiere colocar varios tags en la misma pantalla --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.idasociado" default="" type="string">  <!--- DEid del Empleado utilizado cuando no se envía el query --->
<cfparam name="Attributes.frame" default="FRempleado" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.size" default="30" type="numeric"> <!--- Tamaño del Nombre del Empleado --->
<cfparam name="Attributes.tabindex" default="0" type="numeric"> <!--- TabIndex del Campo Editable --->
<cfparam name="Attributes.DEid" default="DEid" type="string"> <!--- Nombre del campo de Id del Empleado --->
<cfparam name="Attributes.ACAid" default="ACAid" type="string"> <!--- Nombre del campo de Id del Empleado --->
<cfparam name="Attributes.DEidentificacion" default="DEidentificacion" type="string"> <!--- Nombre del campo de Identificacion del Empleado --->
<cfparam name="Attributes.Nombre" default="NombreEmp" type="string"> <!--- Nombre del campo de Nombre del Empleado --->
<cfparam name="Attributes.Usucodigo" default="Usucodigo" type="string"> <!--- Nombre del Campo de Codigo de Usuario, el campo de Usuario solo aparece cuando esta activado el parámetro validateUser --->
<cfparam name="Attributes.showTipoId" default="true" type="boolean"> <!--- Parámetro para indicar si se quiere trabajar con el tipo de identificación --->
<cfparam name="Attributes.validateUser" default="false" type="boolean"> <!--- Parámetro para validar que los empleados mostrados tengan Usuario, se usa básicamente en el conlis y el traeEmpleado --->
<cfparam name="Attributes.validateComprador" default="false" type="boolean"> <!--- Parámetro para validar que los empleados mostrados sean vendedores --->
<cfparam name="Attributes.validateCFid" default="false" type="boolean"> <!--- Parámetro para indicar si se toma en cuenta el Centro Funcional a la hora de filtrar los empleados --->
<cfparam name="Attributes.FuncJSalAbrir" default="" type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar" default="" type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.Conlis" default="true" type="boolean"> <!--- Indica si se va a permitir abrir un conlis de Empleados --->
<cfparam name="Attributes.readonly" default="false" type="boolean"> <!--- Indica si el tag se usa de solo lectura --->
<cfparam name="Attributes.CFid" default="CFid" type="string"> <!--- Nombre del campo de Centro Funcional, únicamente se utiliza si validateCFid se encuentra en true --->
<cfparam name="Attributes.EmpleadosActivos" default="false" type="boolean"><!--- Si se prende va a validar que el empleado este activo en la línea del tiempo --->

<cfif Attributes.index NEQ 0>
	<cfset index = "" & Attributes.index>
<cfelse>
	<cfset index = "">
</cfif>

<cfif Attributes.showTipoId and Attributes.TipoId NEQ "-1">
	<cfquery name="rsTipoId" datasource="#Session.DSN#">
		select NTIcodigo, NTIdescripcion, NTIcaracteres, NTImascara
		from NTipoIdentificacion	
		where Ecodigo = #Session.Ecodigo#
	</cfquery>
</cfif>

<cfset NTIcodigoValue = Attributes.TipoId>
<cfset DEidValue = "">
<cfset ACAidValue = "">
<cfset DEidentificacionValue = "">
<cfset NombreValue = "">

<!--- Querys para cuando no se envia el parámetro de query --->
<cfif not ( isdefined("Attributes.query") 
	   		and isdefined("Attributes.query.#Attributes.ACAid##index#")
		  ) 
	  and isdefined("Attributes.idasociado") and Len(Trim(Attributes.idasociado))>
	<cfquery name="queryEmpleado#index#" datasource="#session.DSN#">
		select  a.NTIcodigo as NTIcodigo#index#, 
				a.DEid as #Attributes.DEid##index#, 
				b.ACAid as #Attributes.ACAid##index#, 
				a.DEidentificacion as #Attributes.DEidentificacion##index#, 
				{fn concat(		{fn concat(		
				{fn concat(		{fn concat(
				a.DEapellido1 , ' ')} , a.DEapellido2 )} ,  ', ' )} ,  a.DEnombre )}				
				 as #Attributes.Nombre##index#
		from DatosEmpleado a, ACAsociados b
		where b.ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idasociado#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and b.DEid=a.DEid
	</cfquery>
</cfif>
<cfif isdefined("Attributes.query") and isdefined("Attributes.query.NTIcodigo#index#")>
	<cfset NTIcodigoValue = Evaluate("Attributes.query.NTIcodigo#index#")>
<cfelseif isdefined("queryEmpleado#index#") and isdefined("queryEmpleado#index#.NTIcodigo#index#")>
	<cfset NTIcodigoValue = Evaluate("queryEmpleado#index#.NTIcodigo#index#")>
</cfif>
<cfif isdefined("Attributes.query") and isdefined("Attributes.query.#Attributes.DEid##index#")>
	<cfset DEidValue = Evaluate("Attributes.query.#Attributes.DEid##index#")>
<cfelseif isdefined("queryEmpleado#index#") and isdefined("queryEmpleado#index#.#Attributes.DEid##index#")>
	<cfset DEidValue = Evaluate("queryEmpleado#index#.#Attributes.DEid##index#")>
</cfif>
<cfif isdefined("Attributes.query") and isdefined("Attributes.query.#Attributes.ACAid##index#")>
	<cfset ACAidValue = Evaluate("Attributes.query.#Attributes.ACAid##index#")>
<cfelseif isdefined("queryEmpleado#index#") and isdefined("queryEmpleado#index#.#Attributes.ACAid##index#")>
	<cfset ACAidValue = Evaluate("queryEmpleado#index#.#Attributes.ACAid##index#")>
</cfif>
<cfif isdefined("Attributes.query") and isdefined("Attributes.query.#Attributes.DEidentificacion##index#")>
	<cfset DEidentificacionValue = Evaluate("Attributes.query.#Attributes.DEidentificacion##index#")>
<cfelseif isdefined("queryEmpleado#index#") and isdefined("queryEmpleado#index#.#Attributes.DEidentificacion##index#")>
	<cfset DEidentificacionValue = Evaluate("queryEmpleado#index#.#Attributes.DEidentificacion##index#")>
</cfif>
<cfif isdefined("Attributes.query") and isdefined("Attributes.query.#Attributes.Nombre##index#")>
	<cfset NombreValue = Evaluate("Attributes.query.#Attributes.Nombre##index#")>
<cfelseif isdefined("queryEmpleado#index#") and isdefined("queryEmpleado#index#.#Attributes.Nombre##index#")>
	<cfset NombreValue = Evaluate("queryEmpleado#index#.#Attributes.Nombre##index#")>
</cfif>

<cfif Attributes.validateUser>
	<cfquery name="queryUsuario#index#" datasource="asp">
		select a.Usucodigo as #Attributes.Usucodigo##index#
		from UsuarioReferencia a
		where a.STabla = 'DatosEmpleado'
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
		and a.llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DEidValue#">
	</cfquery>
</cfif>

<script language="JavaScript" type="text/javascript">
	<cfif not (Attributes.readonly OR not Attributes.Conlis)>
	//funcion para habilitar el F2
	function conlis_keyup_<cfoutput>#index#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisAsociados<cfoutput>#index#</cfoutput>();
		}
	}
	function doConlisAsociados<cfoutput>#index#</cfoutput>() {
		<cfif Len(Trim(Attributes.FuncJSalAbrir))>
			<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
		</cfif>
		var width = 700;
		var height = 400;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		
		<cfoutput>
		params = '?f=#Attributes.form#&p1=#Attributes.DEid##index#&p2=NTIcodigo#index#&p3=#Attributes.DEidentificacion##index#&p4=#Attributes.Nombre##index#&p5=#Attributes.Usucodigo##index#&p6=#Attributes.ACAid##index#&p7=_Tcodigo#index#&p8=_periodicidad#index#';
		<cfif Attributes.TipoId NEQ "-1">
			params = params + '&NTIcodigo='+document.#Attributes.form#.NTIcodigo#index#.value;
		</cfif>
		<cfif Len(Trim(Attributes.FuncJSalCerrar)) GT 0> 
			params = params + '&FuncJSalCerrar=#Attributes.FuncJSalCerrar#';
		</cfif>
		</cfoutput>

		var nuevo = window.open('/cfmx/rh/Utiles/ConlisAsociados.cfm'+params,'ListaEmpleados','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		nuevo.focus();
	}
	
	<cfif not Attributes.readonly>
	function ResetEmployee<cfoutput>#index#</cfoutput>() {
		document.<cfoutput>#Attributes.form#.#Attributes.DEid##index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.#Attributes.ACAid##index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.#Attributes.DEidentificacion##index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.#Attributes.Nombre##index#</cfoutput>.value = "";
	}
	</cfif>

	function TraeAsociado<cfoutput>#index#</cfoutput>(TipoId, Ident) {
		window.ctlid = document.<cfoutput>#Attributes.form#.#Attributes.DEid##index#</cfoutput>;
		window.ctlacaid = document.<cfoutput>#Attributes.form#.#Attributes.ACAid##index#</cfoutput>;		
		window.ctlident = document.<cfoutput>#Attributes.form#.#Attributes.DEidentificacion##index#</cfoutput>;
		window.ctlemp = document.<cfoutput>#Attributes.form#.#Attributes.Nombre##index#</cfoutput>;
		if (document.<cfoutput>#Attributes.form#.#Attributes.DEidentificacion##index#</cfoutput>.value != "") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			params = '<cfoutput>&f=#Attributes.form#&p1=#Attributes.DEid##index#&p2=NTIcodigo#index#&p3=#Attributes.DEidentificacion##index#&p4=#Attributes.Nombre##index#&p5=#Attributes.Usucodigo##index#&p6=#Attributes.ACAid##index#&p7=_Tcodigo#index#&p8=_periodicidad#index#</cfoutput>';
			fr.src = "/cfmx/rh/Utiles/rhasociadoquery.cfm?NTIcodigo="+TipoId+"&DEidentificacion="+Ident+params;
		} else {
			ResetEmployee<cfoutput>#index#</cfoutput>();
			if (window.funcACAid) funcACAid();
		}
		return true;
	}

	<cfif Attributes.TipoId NEQ "-1">
		var tipomask = new Object();
		<cfloop query="rsTipoId">
			tipomask['<cfoutput>#rsTipoId.NTIcodigo#</cfoutput>'] = '<cfoutput>#rsTipoId.NTImascara#</cfoutput>';
		</cfloop>
	</cfif>
	
	</cfif>

</script>

<cfoutput>
<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<cfif Attributes.showTipoId>
			<td>
				<cfif not (Attributes.readonly OR Attributes.TipoId EQ "-1")>
					<select name="NTIcodigo#index#" id="NTicodigo#index#" onChange="javascript: ResetEmployee#index#();" <cfif isDefined("Attributes.tabindex") and len(trim(Attributes.tabindex)) gt 0>tabindex="#Attributes.tabindex#"</cfif>>
					<cfloop query="rsTipoId">
						<option value="#rsTipoId.NTIcodigo#"<cfif NTIcodigoValue EQ rsTipoId.NTIcodigo> selected</cfif>>#rsTipoId.NTIdescripcion#</option>
					</cfloop>
					</select>
				<cfelse>
					<input type="hidden" name="NTIcodigo#index#" id="NTicodigo#index#" value="#NTIcodigoValue#">
				</cfif>
			</td>
		</cfif>
		<td>
			<input type="hidden" name="#Attributes.DEid##index#" value="#DEidValue#">
			<input type="hidden" name="#Attributes.ACAid##index#" value="#ACAidValue#">			
			<input type="hidden" name="_Tcodigo#index#" value="">
			<input type="hidden" name="_periodicidad#index#" value="">
			<input type="text"
			name="#Attributes.DEidentificacion##index#" id="#Attributes.DEidentificacion##index#"
			value="#DEidentificacionValue#"
			<cfif not Attributes.readonly>
			onkeyup="javascript:conlis_keyup_#index#(event);"
			onblur="javascript: TraeAsociado#index#(document.#Attributes.form#.NTIcodigo#index#.value,document.#Attributes.form#.#Attributes.DEidentificacion##index#.value);"
			<cfelse>
			disabled='disabled'
			</cfif>
			<cfif isDefined("Attributes.tabindex") and len(trim(Attributes.tabindex)) gt 0>tabindex="#Attributes.tabindex#"</cfif>>
		</td>
	    <td nowrap>
			<input type="text"
				name="#Attributes.Nombre##index#" id="#Attributes.Nombre##index#"
				tabindex="-1"
				value="#NombreValue#" 
				maxlength="80"
				size="#Attributes.size#"
				disabled='true'>
		</td>
		<td>
			<cfif not (Attributes.readonly OR not Attributes.Conlis)><a href="javascript: doConlisAsociados#index#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Empleados" name="imagen" width="18" height="14" border="0" align="absmiddle"></a></cfif>
			<cfif Attributes.validateUser>
				<input type="hidden" name="#Attributes.Usucodigo#" id="#Attributes.Usucodigo#" value="<cfif isdefined("queryUsuario#index#") and isdefined("queryUsuario#index#.#Attributes.Usucodigo##index#")>#Evaluate("queryUsuario#index#.#Attributes.Usucodigo##index#")#</cfif>">
			</cfif>
		</td>
	</tr>
</table>
</cfoutput>

<cfif not isdefined("Request.EmployeeTag")>
	<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden; display: none;"></iframe>
	<cfset Request.EmployeeTag = True>
</cfif>
