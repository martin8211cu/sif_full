<!--- NUEVO CONLIS PARA EL MODULO DE CUENTAS POR COBRAR
	  TOMA EN CUENTA LA TABLA RolEmpleadoSNegocios EL CUAL CONTIENE LOS EMPLEADOS 
	  QUE TIENEN ASIGNADO UN ROL (VENDEDOR, COMPRADOR, EJECUTIVO DE VENTAS)
	  ESTE CONLIS ES IGUAL AL CONLIS DE RH CON EXCEPCION  DE Q TIENE UN PARAMETRO MAS
	  QUE INDICA CUAL ROL ES EL Q SE NECESITA
	  
	Modificado por: Ana Villavicencio
	Fecha: 10 de octubre del 2005
	Motivo: Correccion de error cuando se digitaba el numero de identificacion, cedula o pasaporte, 
		  daba error de q no encontraba un objeto, no existía, además hacia referencia de un objeto con otro nombre.
	Línea: 94		
	  
 --->
<cfset def = QueryNew('dato')>

<cfparam name="Attributes.TipoId" default="" type="string"> <!--- Indica si el Tipo de Identificación que se va a manejar, cuando no se indica se coloca un combo --->
<cfparam name="Attributes.Conlis" default="true" type="boolean"> <!--- Indica si se va a permitir abrir un conlis de Empleados --->
<cfparam name="Attributes.index" default="0" type="numeric"> <!--- Se utiliza cuando se quiere colocar varios tags en la misma pantalla --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.frame" default="FRempleado" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.size" default="30" type="numeric"> <!--- Tamaño del Nombre del Empleado --->
<cfparam name="Attributes.tabindex" default="0" type="numeric"> <!--- TabIndex del Campo Editable --->
<cfparam name="Attributes.conlis" default="true" 			type="boolean"> <!--- muestra conlis o no --->
<cfparam name="Attributes.rol" default="0" type="numeric"> <!--- rol q debe de tener el empleado --->

<cfif Attributes.index NEQ 0>
	<cfset index = "" & Attributes.index>
<cfelse>
	<cfset index = "">
</cfif>

<cfif Len(Trim(Attributes.TipoId)) EQ 0>
	<cfquery name="rsTipoId" datasource="#Session.DSN#">
		select NTIcodigo, NTIdescripcion, NTIcaracteres, NTImascara
		from NTipoIdentificacion	
		<!--- where Ecodigo = #session.Ecodigo# ---> <!--- no se ocupa --->
	</cfquery>
</cfif>

<script language="JavaScript" type="text/javascript">
//funcion para habilitar el F2
	function conlis_keyup_<cfoutput>#index#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisEmpleados<cfoutput>#index#</cfoutput>();
		}
	}

	<cfif Attributes.Conlis>
	function doConlisEmpleados<cfoutput>#index#</cfoutput>() {
		var width = 600;
		var height = 500;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		
		<cfoutput>
			<cfif Attributes.TipoId EQ "-1">
					var nuevo = window.open('/cfmx/rh/Utiles/ConlisEmpleadosCxC.cfm?f=#Attributes.form#&p1=DEid#index#&p2=NTIcodigo#index#&p3=DEidentificacion#index#&p4=NombreEmp#index#&rol=#Attributes.rol#','ListaEmpleados','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
			<cfelse>
					var nuevo = window.open('/cfmx/rh/Utiles/ConlisEmpleadosCxC.cfm?NTIcodigo='+document.#Attributes.form#.NTIcodigo#index#.value+'&f=#Attributes.form#&p1=DEid#index#&p2=NTIcodigo#index#&p3=DEidentificacion#index#&p4=NombreEmp#index#&rol=#Attributes.rol#','ListaEmpleados','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
			</cfif>
		</cfoutput>
		
		nuevo.focus();
	}
	
	function ResetEmployee<cfoutput>#index#</cfoutput>() {
		document.<cfoutput>#Attributes.form#.DEid#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.DEidentificacion#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.NombreEmp#index#</cfoutput>.value = "";
	}
	</cfif>

	function TraeEmpleado<cfoutput>#index#</cfoutput>(TipoId, Ident,rol) {
		window.ctlid = document.<cfoutput>#Attributes.form#</cfoutput>.DEid<cfoutput>#index#</cfoutput>;
		window.ctlident = document.<cfoutput>#Attributes.form#</cfoutput>.DEidentificacion<cfoutput>#index#</cfoutput>;
		window.ctlemp = document.<cfoutput>#Attributes.form#</cfoutput>.NombreEmp<cfoutput>#index#</cfoutput>;
		//window.ctlrol = document.<cfoutput>#Attributes.form#</cfoutput>.rol<cfoutput>#index#</cfoutput>;
		if (document.<cfoutput>#Attributes.form#.DEidentificacion#index#</cfoutput>.value != "") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/rh/Utiles/rhempleadoqueryCxC.cfm?NTIcodigo="+TipoId+"&DEidentificacion="+Ident+"&rol="+rol;
		} else {
			ResetEmployee<cfoutput>#index#</cfoutput>();
		}
		return true;
	}

<cfif Len(Trim(Attributes.TipoId)) EQ 0>
	var tipomask = new Object();
	<cfloop query="rsTipoId">
		tipomask['<cfoutput>#rsTipoId.NTIcodigo#</cfoutput>'] = '<cfoutput>#rsTipoId.NTImascara#</cfoutput>';
	</cfloop>
</cfif>

</script>

<cfoutput>
<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
		<cfif Len(Trim(Attributes.TipoId)) EQ 0>
			<select name="NTIcodigo#index#" id="NTIcodigo#index#" 
				onChange="javascript: ResetEmployee#index#();" <cfif isDefined("Attributes.tabindex") and len(trim(Attributes.tabindex)) gt 0>tabindex="#Attributes.tabindex#"</cfif>>
			  <cfloop query="rsTipoId">
				<option value="#rsTipoId.NTIcodigo#" <cfif isdefined("Attributes.query") and isdefined("Attributes.query.NTIcodigo#index#") and rsTipoId.NTIcodigo eq Evaluate("Attributes.query.NTIcodigo#index#")>selected</cfif>>#rsTipoId.NTIdescripcion#</option>
			  </cfloop>
			</select>		
		<cfelse>
			<input type="hidden" name="NTIcodigo#index#" id="NTicodigo#index#" value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.NTIcodigo#index#")>#Evaluate("Attributes.query.NTIcodigo#index#")#<cfelse>#Attributes.TipoId#</cfif>">
		</cfif>
		</td>
		<td>
			<input type="hidden" name="DEid#index#" 
			value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.DEid#index#")>#Evaluate("Attributes.query.DEid#index#")#</cfif>">
			<input type="text"
				name="DEidentificacion#index#" id="DEidentificacion#index#"
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.DEidentificacion#index#")>#Evaluate("Attributes.query.DEidentificacion#index#")#</cfif>"
				size="9"
				onkeyup="javascript:conlis_keyup_#index#(event);"
				onblur="javascript: TraeEmpleado#index#(document.#Attributes.form#.NTIcodigo#index#.value,document.#Attributes.form#.DEidentificacion#index#.value,#Attributes.rol#);"
				<cfif isDefined("Attributes.tabindex") and len(trim(Attributes.tabindex)) gt 0>tabindex="#Attributes.tabindex#"</cfif>>
		</td>
	    <td nowrap>
			<input type="text"
				name="NombreEmp#index#" id="NombreEmp#index#"
				tabindex="-1"
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.NombreEmp#index#")>#Evaluate("Attributes.query.NombreEmp#index#")#</cfif>" 
				maxlength="80"
				size="#Attributes.size#"
				readonly='true'>
			<cfif Attributes.Conlis><a href="javascript: doConlisEmpleados#index#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Empleados" name="imagen" width="18" height="14" border="0" align="absmiddle"></a></cfif>
		</td>
	</tr>
</table>
</cfoutput>

<cfif not isdefined("Request.EmployeeTag")>
	<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" 
		marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" 
		style=" display:none;visibility: hidden;"></iframe>
	<cfset Request.EmployeeTag = True>
</cfif>
