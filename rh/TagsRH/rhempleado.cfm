<cfset def = QueryNew('dato')>

<cfparam name="Attributes.TipoId" default="-1" type="string"> <!--- Indica si se va a manejar el Tipo de Identificación, cuando no se indica se coloca un combo, se puede colocar un -1 para indicar que no se va a manejar el tipo de identificación --->
<cfparam name="Attributes.index" default="0" type="numeric"> <!--- Se utiliza cuando se quiere colocar varios tags en la misma pantalla --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.idempleado" default="" type="string">  <!--- DEid del Empleado utilizado cuando no se envía el query --->
<cfparam name="Attributes.frame" default="FRempleado" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.size" default="30" type="numeric"> <!--- Tamaño del Nombre del Empleado --->
<cfparam name="Attributes.tabindex" default="0" type="numeric"> <!--- TabIndex del Campo Editable --->
<cfparam name="Attributes.DEid" default="DEid" type="string"> <!--- Nombre del campo de Id del Empleado --->
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
<cfparam name="Attributes.Asociado" default="false" type="boolean"><!--- Indicador para que exija que el empleado sea Asociado Activo --->
<cfparam name="Attributes.JefeDEid" default="" type="string"><!--- filtra los empleados que tienen como jefe al empleado definido (empleados activos) --->
<cfparam name="Attributes.Ecodigo" default="#session.Ecodigo#"  type="integer"><!--- Manda el Ecodigo de la empresa si no es la default (clonacion) --->
<cfparam name="Attributes.DSN" default="#session.DSN#" type="string"><!--- Manda el DSN de la empresa si no es la default (clonacion) --->
<cfparam name="Attributes.AgregarEnLista" default="false" type="boolean"><!--- permite agregar empleados a una lista por medio del boton (+) --->
<cfparam name="Attributes.corporativo" default="false" type="boolean"><!--- muestra todos los empleados de la corporacion --->
<cfparam name="Attributes.TipoTabla" default="HTML" type="string"><!--- Indica el tipo de tabla que se utilizara (HTML o Bootstrap) --->


<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#Attributes.DSN#" 
	ecodigo="#session.Ecodigo#" pvalor="2045" default="0" returnvariable="idAuto"/>

<cfif Attributes.index NEQ 0>
	<cfset index = "" & Attributes.index>
<cfelse>
	<cfset index = "">
</cfif>

<cfif Attributes.AgregarEnLista>
	<cf_importJquery>
	<cfif len(trim(Attributes.index)) eq 0>
		<cfset index=1>
	</cfif>
</cfif>	


<cfif Attributes.showTipoId and Attributes.TipoId NEQ "-1">

	<cfquery name="rsTipoId" datasource="#Attributes.DSN#">
		select NTIcodigo, NTIdescripcion, NTIcaracteres, NTImascara
		from NTipoIdentificacion	
		where Ecodigo = #session.Ecodigo#
        <cfif #idAuto# EQ 1>	
            and NTIcodigo = 'G'
        </cfif>
	</cfquery>
	
    <!---
    <cfquery name="rsTipoId" datasource="#Attributes.DSN#">
        select b.VSvalor as NTIcodigo, VSdesc as NTIdescripcion
        from Idiomas a
            inner join VSidioma b
            on b.Iid = a.Iid
            and b.VSgrupo = 0
        where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.idioma#">
        <cfif #idAuto# EQ 1>	
            and b.VSvalor = 'G'
        </cfif>
        order by b.VSvalor
    </cfquery>--->
     
</cfif>

<cfset NTIcodigoValue = Attributes.TipoId>
<cfset DEidValue = "">
<cfset DEidentificacionValue = "">
<cfset NombreValue = "">


<!--- 1. Atributo especificado --->
<cfif isdefined("Attributes.tarjeta") and Attributes.tarjeta >
	<cfset v_tarjeta    = false >
<!--- 2. Atributo no especificado --->
<cfelse>
	<!--- lee valor de session si esta definido, si no lo esta definido lo crea en session --->
	<!--- 2.1 esta definida la variable de session  --->
	<cfif isdefined("session.tagempleados.tarjeta") and len(trim(session.tagempleados.tarjeta))>
		<!--- usa identificacion [session.tagempleados.tarjeta=true] --->
		<cfif session.tagempleados.tarjeta >
			<cfset v_tarjeta    = true >
		<!--- usa tarjeta [session.tagempleados.tarjeta=false] --->
		<cfelse>
			<cfset v_tarjeta    = false >
		</cfif>
	<!--- 2.2 no esta definida la variable de session. Debe leer el parametro 910, si no existe el valor debe ser true, 
			  osea por defecto va a usar identificacion --->
	<cfelse>
		<!--- 2.2.1 Leer variable de session --->
		<cfquery name="rs_parametro_910" datasource="#Attributes.DSN#">
			select coalesce(Pvalor, '0') as Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
			  and Pcodigo = 910
		</cfquery>
		<!--- Parametro 910: 1 ==> usa tarjeta | 0, nulo, vacio ==> no la usa --->
		<cfif len(trim(rs_parametro_910.Pvalor))>
			<!--- usa identificacion --->
			<cfif rs_parametro_910.Pvalor eq 0 >
				<cfset v_tarjeta    = false >
				<cfset session.tagempleados.tarjeta = false >
			<!--- usa tarjeta --->
			<cfelse>
				<cfset v_tarjeta    = true >
				<cfset session.tagempleados.tarjeta = true >				
			</cfif>
		<!--- parametro no definido o vacio, por defecto no usa tarjeta --->
		<cfelse>
			<cfset v_tarjeta    = false >
			<cfset session.tagempleados.tarjeta = false >
		</cfif>
	</cfif>
</cfif>

<!--- Querys para cuando no se envia el parámetro de query --->
<cfif not (isdefined("Attributes.query") and isdefined("Attributes.query.#Attributes.DEid##index#")) and isdefined("Attributes.idempleado") and Len(Trim(Attributes.idempleado))>
	<cfquery name="queryEmpleado#index#" datasource="#Attributes.DSN#">
		select  a.NTIcodigo as NTIcodigo#index#, 
				a.DEid as #Attributes.DEid##index#, 
				a.DEidentificacion as #Attributes.DEidentificacion##index#, 
				{fn concat(		{fn concat(		
				{fn concat(		{fn concat(
				a.DEapellido1 , ' ')} , a.DEapellido2 )} ,  ', ' )} ,  a.DEnombre )}				
				 as #Attributes.Nombre##index#
		from DatosEmpleado a
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idempleado#">
		and a.Ecodigo in (<cfif attributes.corporativo>
							select Ecodigo from Empresas where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	                      <cfelse>          
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
						  </cfif>
						  )
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
		and a.llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DEidValue#">
	</cfquery>
</cfif>

<script language="JavaScript" type="text/javascript">
	<cfif not (Attributes.readonly OR not Attributes.Conlis)>
	//funcion para habilitar el F2
	function conlis_keyup_<cfoutput>#index#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisEmpleados<cfoutput>#index#</cfoutput>();
		}
	}
	function doConlisEmpleados<cfoutput>#index#</cfoutput>() {
		<cfif Len(Trim(Attributes.FuncJSalAbrir))>
			<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
		</cfif>
		var width = 700;
		var height = 400;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		
		<cfoutput>
		params = '?f=#Attributes.form#&p1=#Attributes.DEid##index#&p2=NTIcodigo#index#&p3=#Attributes.DEidentificacion##index#&p4=#Attributes.Nombre##index#&p5=#Attributes.Usucodigo##index#&Ecodigo=#Attributes.Ecodigo##index#&DSN=#Attributes.DSN#&JefeDEid=#Attributes.JefeDEid#';
		params = params + '&shid=<cfif Attributes.showTipoId>1<cfelse>0</cfif>';
		params = params + '&valus=<cfif Attributes.validateUser>1<cfelse>0</cfif>';
		params = params + '&valcomp=<cfif Attributes.validateComprador>1<cfelse>0</cfif>';
		params = params + '&valemp=<cfif Attributes.EmpleadosActivos>1<cfelse>0</cfif>';
		params = params + '&valasoc=<cfif Attributes.Asociado>1<cfelse>0</cfif>';
		params = params + '&corporativo=<cfif Attributes.corporativo>1<cfelse>0</cfif>';
		<cfif Attributes.TipoId NEQ "-1">
			params = params + '&NTIcodigo='+document.#Attributes.form#.NTIcodigo#index#.value;
		</cfif>
		<cfif v_tarjeta>
			params = params + '&tarjeta=1';
		</cfif>
		<cfif Attributes.validateCFid>
			params = params + '&CFid='+document.#Attributes.form#.#Attributes.CFid##index#.value;
		</cfif>
		<cfif Len(Trim(Attributes.FuncJSalCerrar)) GT 0> 
			params = params + '&FuncJSalCerrar=#Attributes.FuncJSalCerrar#';
		</cfif>
		</cfoutput>

		var nuevo = window.open('/cfmx/rh/Utiles/ConlisEmpleados.cfm'+params,'ListaEmpleados','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		nuevo.focus();
	}
	
	<cfif not Attributes.readonly>
	function ResetEmployee<cfoutput>#index#</cfoutput>() {
		document.<cfoutput>#Attributes.form#.#Attributes.DEid##index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.#Attributes.DEidentificacion##index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.#Attributes.Nombre##index#</cfoutput>.value = "";
	}
	</cfif>

	function TraeEmpleado<cfoutput>#index#</cfoutput>(TipoId, Ident) {
		window.ctlid = document.<cfoutput>#Attributes.form#.#Attributes.DEid##index#</cfoutput>;
		window.ctlident = document.<cfoutput>#Attributes.form#.#Attributes.DEidentificacion##index#</cfoutput>;
		window.ctlemp = document.<cfoutput>#Attributes.form#.#Attributes.Nombre##index#</cfoutput>;
		<cfif Attributes.validateUser>
		window.ctlusu = document.<cfoutput>#Attributes.form#.#Attributes.Usucodigo##index#</cfoutput>;
		</cfif>
		if (document.<cfoutput>#Attributes.form#.#Attributes.DEidentificacion##index#</cfoutput>.value != "") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			var params = '&valus=<cfif Attributes.validateUser>1<cfelse>0</cfif>';
			params = params + '&valcomp=<cfif Attributes.validateComprador>1<cfelse>0</cfif>';
			params = params + '&valemp=<cfif Attributes.EmpleadosActivos>1<cfelse>0</cfif>';
			params = params + '&valasoc=<cfif Attributes.Asociado>1<cfelse>0</cfif>';
			params = params + '&corporativo=<cfif Attributes.corporativo>1<cfelse>0</cfif>';
			<cfif Attributes.validateCFid>
				params = params + '&CFid='+document.<cfoutput>#Attributes.form#.#Attributes.CFid##index#</cfoutput>.value;
			</cfif>
			fr.src = "/cfmx/rh/Utiles/rhempleadoquery.cfm?NTIcodigo="+TipoId+"&DEidentificacion="+Ident+params;
		} else {
			ResetEmployee<cfoutput>#index#</cfoutput>();
			if (window.funcDEid) funcDEid();
		}
		return true;
	}

<!---	<cfif Attributes.TipoId NEQ "-1" and isdefined("rsTipoId") >
		var tipomask = new Object();
		<cfloop query="rsTipoId">
			tipomask['<cfoutput>#rsTipoId.NTIcodigo#</cfoutput>'] = '<cfoutput>#rsTipoId.NTImascara#</cfoutput>';
		</cfloop>
	</cfif>--->
	
		<cfif Attributes.AgregarEnLista>
			function AgregarEmpleadoLista<cfoutput>#index#</cfoutput>(){
					var existe = 0;
		
					if($('#ListaDEidEmpleado<cfoutput>#index#</cfoutput>').length){
						$('input.ListaDEidEmpleado<cfoutput>#index#</cfoutput>').each(function() {
							if($('#<cfoutput>#Attributes.DEid##index#</cfoutput>').val() == $(this).val()){ existe=1;}
						});
					}
					if(existe == 1){
						alert("Este Empleado ya se encuentra agregado");
					}
					else{	
						if($('#<cfoutput>#Attributes.DEid##index#</cfoutput>').val() == ''){
							alert("Debe seleccionar un Empleado");
						}	
						else{	
						   $('#ListaEmpleados<cfoutput>#index#</cfoutput>').append("<tr><td nowrap='nowrap'><input class='<cfoutput>ListaDEidEmpleado#index#</cfoutput>' type='hidden' id='<cfoutput>ListaDEidEmpleado#index#</cfoutput>' name='<cfoutput>ListaDEidEmpleado#index#</cfoutput>' value="+$('#<cfoutput>#Attributes.DEid##index#</cfoutput>').val()+">"+$('#<cfoutput>DEidentificacion#index#</cfoutput>').val()+" - " +$('#<cfoutput>#Attributes.Nombre##index#</cfoutput>').val()+ "<img src='/cfmx/plantillas/Sapiens/css/images/btnEliminar.gif' onclick='QuitarEmpleadoLista<cfoutput>#index#</cfoutput>(this)' ></td></tr>");
						   $('#<cfoutput>#Attributes.DEid##index#</cfoutput>').val(""); 
						   $('#<cfoutput>#Attributes.DEidentificacion##index#</cfoutput>').val(""); 
						   $('#<cfoutput>#Attributes.Nombre##index#</cfoutput>').val(""); 
						} 
					}	
			}
			function QuitarEmpleadoLista<cfoutput>#index#</cfoutput>(elemento){
				$(elemento).parent().parent().remove(); 
			}
		</cfif>	
	
	</cfif>
	

	
</script>


<cfif attributes.TipoTabla EQ "HTML">
	

	<cfoutput>
	<table border="0" cellspacing="0" cellpadding="0">
		<tr>
			<cfset pinto_NTIcodigo = false >
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
					<cfset pinto_NTIcodigo = true >				
				</td>
			</cfif>
			
			<cfif not pinto_NTIcodigo>
				<input type="hidden" name="NTIcodigo#index#" id="NTicodigo#index#" value="#NTIcodigoValue#">
			</cfif>
			
			<td>
				<input type="hidden" name="#Attributes.DEid##index#" id="#Attributes.DEid##index#"  value="#DEidValue#">
				<input type="text"
				name="#Attributes.DEidentificacion##index#" id="#Attributes.DEidentificacion##index#"
				value="#DEidentificacionValue#"
				<cfif not Attributes.readonly>
				onkeyup="javascript:conlis_keyup_#index#(event);"
				onblur="javascript: TraeEmpleado#index#(document.#Attributes.form#.NTIcodigo#index#.value,document.#Attributes.form#.#Attributes.DEidentificacion##index#.value);"
				<cfelse>
				readonly='true'
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
					readonly='true'>
			</td>
			<td>
				<cfif not (Attributes.readonly OR not Attributes.Conlis)><a href="javascript: doConlisEmpleados#index#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Empleados" name="imagen" width="18" height="14" border="0" align="absmiddle"></a></cfif>
				<cfif Attributes.validateUser>
					<input type="hidden" name="#Attributes.Usucodigo#" id="#Attributes.Usucodigo#" value="<cfif isdefined("queryUsuario#index#") and isdefined("queryUsuario#index#.#Attributes.Usucodigo##index#")>#Evaluate("queryUsuario#index#.#Attributes.Usucodigo##index#")#</cfif>">
				</cfif>
			</td>
			<cfif Attributes.AgregarEnLista>
			<td>
				<input type="button" onclick="AgregarEmpleadoLista<cfoutput>#index#</cfoutput>()" value="+" class="btnNormal" />
			</td>				
			</cfif>
		</tr>
		<cfif Attributes.AgregarEnLista>
		<tr>
			<td colspan="5">
				<table id="ListaEmpleados<cfoutput>#index#</cfoutput>">
				</table>
			</td>
		</tr>
		</cfif>
	</table>
	</cfoutput>

	<cfif not isdefined("Request.EmployeeTag")>
		<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden; display:none;"></iframe>
		<cfset Request.EmployeeTag = True>
	</cfif>

</cfif>


<cfif attributes.TipoTabla EQ "Bootstrap">
	
	<cfoutput>
	<!--- <table border="0" cellspacing="0" cellpadding="0"> --->
		<div class="row">
			<cfset pinto_NTIcodigo = false >
			<cfif Attributes.showTipoId>
				<!--- <div class="col-sm-1">
				 --->	<cfif not (Attributes.readonly OR Attributes.TipoId EQ "-1")>
						<div class="col-sm-1">
							<select style="width: 100%" name="NTIcodigo#index#" id="NTicodigo#index#" onChange="javascript: ResetEmployee#index#();" <cfif isDefined("Attributes.tabindex") and len(trim(Attributes.tabindex)) gt 0>tabindex="#Attributes.tabindex#"</cfif>>
							<cfloop query="rsTipoId">
								<option value="#rsTipoId.NTIcodigo#"<cfif NTIcodigoValue EQ rsTipoId.NTIcodigo> selected</cfif>>#rsTipoId.NTIdescripcion#</option>
							</cfloop>
							</select>
						</div>
					<cfelse>
						<div>
							<input type="hidden" name="NTIcodigo#index#" id="NTicodigo#index#" value="#NTIcodigoValue#">
						</div>
					</cfif>
					<cfset pinto_NTIcodigo = true >				
				<!--- </div> --->
			</cfif>
			
			<cfif not pinto_NTIcodigo>
				<input type="hidden" name="NTIcodigo#index#" id="NTicodigo#index#" value="#NTIcodigoValue#">
			</cfif>
			
			<div class="col-sm-5">
				<input type="hidden" name="#Attributes.DEid##index#" id="#Attributes.DEid##index#"  value="#DEidValue#">
				<input style="width: 100%;" type="text"
				name="#Attributes.DEidentificacion##index#" id="#Attributes.DEidentificacion##index#"
				value="#DEidentificacionValue#"
				<cfif not Attributes.readonly>
				onkeyup="javascript:conlis_keyup_#index#(event);"
				onblur="javascript: TraeEmpleado#index#(document.#Attributes.form#.NTIcodigo#index#.value,document.#Attributes.form#.#Attributes.DEidentificacion##index#.value);"
				<cfelse>
				readonly='true'
				</cfif>
				<cfif isDefined("Attributes.tabindex") and len(trim(Attributes.tabindex)) gt 0>tabindex="#Attributes.tabindex#"</cfif>>
			</div>
			<div class="col-sm-5">
				<input type="text"
					name="#Attributes.Nombre##index#" id="#Attributes.Nombre##index#"
					tabindex="-1"
					value="#NombreValue#" 
					maxlength="80"
					size="#Attributes.size#"
					readonly='true' style="
    width: 100%;
">
			</div>
			<div class="col-sm-1">

				<cfif not (Attributes.readonly OR not Attributes.Conlis)><a href="javascript: doConlisEmpleados#index#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Empleados" name="imagen" width="18" height="14" border="0" align="absmiddle"></a></cfif>
				<cfif Attributes.validateUser>
					<input type="hidden" name="#Attributes.Usucodigo#" id="#Attributes.Usucodigo#" value="<cfif isdefined("queryUsuario#index#") and isdefined("queryUsuario#index#.#Attributes.Usucodigo##index#")>#Evaluate("queryUsuario#index#.#Attributes.Usucodigo##index#")#</cfif>" style="
    width: 100%;
">
				</cfif>
			</div>
			<cfif Attributes.AgregarEnLista>
			<div class="col-sm-1">
				<input type="button" onclick="AgregarEmpleadoLista<cfoutput>#index#</cfoutput>()" value="+" class="btnNormal" />
			</div>				
			</cfif>
		</div>
		<cfif Attributes.AgregarEnLista>
		<div class="row">
			<div class="col-sm-1">
				<table id="ListaEmpleados<cfoutput>#index#</cfoutput>">
				</table>
			</div>
		</div>
		</cfif>
	<!--- </table> --->
	</cfoutput>

	<cfif not isdefined("Request.EmployeeTag")>
		<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden; display:none;"></iframe>
		<cfset Request.EmployeeTag = True>
	</cfif>

</cfif>