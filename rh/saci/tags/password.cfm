<cfparam 	name="Attributes.name"		type="string"	default="password">				<!--- nombre del input --->
<cfparam 	name="Attributes.user"		type="string"	default="user">					<!--- login para el password --->
<cfparam 	name="Attributes.etiqueta"	type="string"	default="">						<!--- etiqueta definida en caso de error --->
<cfparam 	name="Attributes.value"		type="string"	default="">						<!--- valor del input --->
<cfparam 	name="Attributes.size"		type="string"	default="30">					<!--- size del input --->
<cfparam 	name="Attributes.mini"		type="string"	default="6">					<!--- cantidad minima de caracteres en el password --->
<cfparam 	name="Attributes.maxi"		type="string"	default="16">					<!--- cantidad maxima de caracteres en el password --->
<cfparam 	name="Attributes.maxlength"	type="string"	default="30">					<!--- maximo size del input --->
<cfparam 	name="Attributes.form"		type="string"	default="form1">				<!--- form --->
<cfparam 	name="Attributes.sufijo" 	type="string"	default="">						<!--- sufijo a agregar en todos los campos, se usa en caso de que se use varias veces el mismo tag en la misma pantalla --->
<cfparam 	name="Attributes.idpersona" type="string"	default="#Session.Usucodigo#">	<!--- cliente id --->
<cfparam 	name="Attributes.Ecodigo" 	type="string"	default="#Session.Ecodigo#">	<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 	type="string"	default="#Session.DSN#">		<!--- cache de conexion --->

<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="PG_caracteresValidos">
	<cfinvokeargument name="Pcodigo" value="50">
</cfinvoke>

<cfoutput>
	<cfinvoke component="home.Componentes.Politicas" method="trae_parametros_cuenta" returnvariable="data" CEcodigo="#session.CEcodigo#"/>
	
	<input name="#Attributes.name##Attributes.sufijo#" id="#Attributes.name##Attributes.sufijo#" type="password" value="#Attributes.value#" size="#Attributes.size#" onFocus="this.select()"  onchange="val_password#Attributes.name##Attributes.sufijo#('#HTMLEditFormat( JSStringFormat(Attributes.user))#', document.#Attributes.form#.#Attributes.name##Attributes.sufijo#.value)" tabindex="1"/>
			<img src="/cfmx/asp/admin/politicas/global/aceptado.gif" alt="ok" name="img_pass_ok_#Attributes.name##Attributes.sufijo#" width="13" height="12" id="img_pass_ok_#Attributes.name##Attributes.sufijo#" longdesc="Contraseña aceptada" style="display:none" />
			<img src="/cfmx/asp/admin/politicas/global/rechazado.gif" alt="ok" name="img_pass_mal_#Attributes.name##Attributes.sufijo#" width="13" height="12" id="img_pass_mal_#Attributes.name##Attributes.sufijo#" longdesc="Contraseña rechazada" />
			
	<script language="javascript" type="text/javascript">
		function o(s){
			return document.all ? document.all[s] : document.getElementById(s);
		}
		function val_password#Attributes.name##Attributes.sufijo#(u, p) {
			var div = o('div_test_msg');
			var valida = validarPassword(u, p);
			o('img_pass_ok_#Attributes.name##Attributes.sufijo#').style.display = !valida.errpass.length ? '' : 'none';
			o('img_pass_mal_#Attributes.name##Attributes.sufijo#').style.display = valida.errpass.length ? '' : 'none';
			
			if(valida.errpass.length != 0) alert(valida.errpass);
		
			return valida;
		}
	</script>
	<cfinvoke component="home.Componentes.ValidarPassword" method="javascript" data="#data#"/>
		
</cfoutput>
