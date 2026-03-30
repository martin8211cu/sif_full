<!--- 
	Combinaciones aceptables
	cambioPass = false, showId = true, readonly = false		// Se puede escoger la persona para la creación de su usuario, pero no se le puede cambiar su password
	cambioPass = false, showId = true, readonly = true		// La persona viene como parámetro y no se puede escoger otra, se le puede crear usuario, pero no se le puede cambiar su password
	cambioPass = true, showId = true, readonly = false		// Se puede escoger la persona para la creación de su usuario y/o cambio de su password
	cambioPass = true, showId = true, readonly = true		// La persona viene como parámetro y no se puede escoger otra, se le puede crear usuario y se le puede cambiar su password
	cambioPass = true, showId = false, readonly = false		// Cambio de Password para el Usuario logueado sin necesidad de mostrar quién es
--->

<cfparam	name="Attributes.id"				type="string"	default="">							<!--- Id en ISBpersona --->
<cfparam 	name="Attributes.sufijo" 			type="string"	default="">							<!--- sufijo a agregar en todos los campos, se usa en caso de que se use varias veces el mismo tag en la misma pantalla --->
<cfparam 	name="Attributes.alignEtiquetas" 	type="string"	default="right">					<!--- alineación de etiquetas --->
<cfparam 	name="Attributes.form" 				type="string"	default="form1">					<!--- nombre del formulario --->
<cfparam 	name="Attributes.showId" 			type="boolean"	default="true">						<!--- indica si se muestra el campo de identificacion --->
<cfparam 	name="Attributes.readonly" 			type="boolean"	default="false">					<!--- indica si la identificacion es fija y no se puede cambiar, requiere que se envie el id --->
<cfparam 	name="Attributes.cambioPass" 		type="boolean"	default="false">					<!--- indica si permite cambiar la contraseña --->
<cfparam 	name="Attributes.modificarRoles" 	type="boolean"	default="false">					<!--- indica si permite modificar los roles en pantalla--->
<cfparam 	name="Attributes.rolesAMostrar" 	type="string"	default="CLIENTE,AGENTE,VENDEDOR">	<!--- roles que se pueden Mostrar en Pantalla --->
<cfparam 	name="Attributes.Ecodigo" 			type="string"	default="#Session.Ecodigo#">		<!--- código de empresa --->
<cfparam 	name="Attributes.EcodigoSDC" 		type="string"	default="#Session.EcodigoSDC#">		<!--- Código de Empresa del Portal --->
<cfparam 	name="Attributes.Conexion" 			type="string"	default="#Session.DSN#">			<!--- cache de conexion --->
<cfparam 	name="Attributes.showName" 			type="string"	default="true">						<!--- Si el atributo read Only es True y mostrar nombre es false entonces no se muestra el nombre de la persona, es util en el caso de Administracion de Cuentas --->
<cfparam 	name="Attributes.porFila" 			type="boolean"	default="false">					<!--- se utiliza para indicar si se pintan los niveles por columna o fila --->
<cfparam 	name="Attributes.columnas" 			type="string"	default="3">						<!--- Numero de columnas en que desea que se desplieglen los campos( el maximo de columnas es tres por la cantidad de campos que se despliegan al Especificar Usuario y password)--->
<cfparam 	name="Attributes.agente" 			type="string"	default="-1">						 <!---código del agente, si no es agente el código es -1--->

<cfif Attributes.readonly and Len(Trim(Attributes.id)) EQ 0>
	<cfthrow message="Para utilizar el atributo de readonly en true debe especificarse el atributo id">
</cfif>


<cfset ExistePersona = Len(Trim(Attributes.id))>
<cfset ExisteCuenta = false>

<cfif ExistePersona>
	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
	<cfset rsUsuario = sec.getUsuarioByRef(Attributes.id, Session.EcodigoSDC, 'ISBpersona')>
	<cfset ExisteUsuario = rsUsuario.recordCount GT 0>

	
	<cfquery name="rsDatosPersona" datasource="#Attributes.Conexion#">
		select b.Pquien, b.Pid,
			   case when b.Ppersoneria = 'J' then rtrim(b.PrazonSocial) else rtrim(rtrim(b.Pnombre) || ' ' || rtrim(b.Papellido) || ' ' || b.Papellido2) end as NombreCompleto
		from ISBpersona b
		where b.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
	</cfquery>

	<cfif isdefined("form.cue") and Len(form.cue)>	
		<cfquery name="rsLogin" datasource="#Attributes.Conexion#">
			select rtrim(a.LGlogin) || '@racsa.co.cr' as Pemail
			from ISBlogin a
				inner join ISBproducto b
					on b.Contratoid = a.Contratoid
					and b.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.cue#">
				inner join ISBserviciosLogin c
					on c.LGnumero = a.LGnumero
					and c.TScodigo = 'MAIL'
			order by b.Contratoid
		</cfquery>
	
	<cfset ExisteCuenta = true>
	</cfif>
	
	<cfquery name="rsUsuarios" datasource="#Attributes.Conexion#">
		select a.Usucodigo,a.Usulogin,
				case 
					when a.Uestado = 1 Then 'Activo'
					else 'Inactivo'
				end as Estado
		from asp..Usuario a
		inner join asp..DatosPersonales b
		on a.datos_personales = b.datos_personales
		inner join ISBpersona c
		on b.Pid = c.Pid
		where c.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
	</cfquery>

	
<cfelse>
	<cfset ExisteUsuario = false>
</cfif>

<cfset rolesAsignados = ''>
<cfif ExisteUsuario>
	<cfquery name="rsRoles" datasource="#Attributes.Conexion#">
		select rtrim(SRcodigo) as SRcodigo
		from UsuarioRol
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUsuario.Usucodigo#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.EcodigoSDC#">
		and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="SACI">
		<cfif Len(Trim(Attributes.rolesAMostrar))>
		and SRcodigo in (<cfqueryparam cfsqltype="cf_sql_char" value="#Attributes.rolesAMostrar#" list="yes" separator=",">)
		</cfif>
	</cfquery>
	<cfset rolesAsignados = ValueList(rsRoles.SRcodigo, ',')>

	
		<!--- Bloqueos del Usuario--->
	<cfif isdefined("form.AGid")>
		<cfquery name="bloqueos" datasource="asp">
			Select u.Usucodigo, bloqueo, fecha, razon, case when desbloqueado = 1 then 'Si' else 'No' end as desbloq
				from UsuarioReferencia r
				inner join Usuario u
					on r.Usucodigo = u.Usucodigo
					and r.llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AGid#" null="#Len(form.AGid) is 0#">
					and r.STabla = 'ISBagente'
				inner join aspmonitor..UsuarioBloqueo b
					on u.Usucodigo = b.Usucodigo
				order by bloqueo desc
		</cfquery>
	</cfif>
</cfif>

<cfoutput>

	<table width="100%" border="0" cellspacing="0" cellpadding="2">
	  <cfif Attributes.showId>
	  <tr>
	  	<td height="20" width="40%" <cfif not Attributes.porFila> align="right"<cfelse> align="center"</cfif>class="menuhead">
			<cfif not Attributes.readonly>
				<table border="0" cellspacing="0" cellpadding="2" <cfif not Attributes.porFila> align="right"<cfelse> align="center"</cfif>>
					<cf_identificacion
						id = "#Attributes.id#"
						form = "#Attributes.form#"
						sufijo = "#Attributes.sufijo#"
						alignEtiquetas = "#Attributes.alignEtiquetas#"
						editable = "false"
						ocultarPersoneria = "true"
						Ecodigo = "#Attributes.Ecodigo#"
						Conexion = "#Attributes.Conexion#"
						funcionValorEnBlanco = "resetUsuario#Attributes.sufijo#"
						funcion = "CargarValoresUsuarioTodo#Attributes.sufijo#"
						incluyeTabla = "false"
					>
				</table>
			<cfelse>
				<input type="hidden" name="Pquien#Attributes.sufijo#" id="Pquien#Attributes.sufijo#" value="#Attributes.id#" />
				<cfif Attributes.showName>
					#rsDatosPersona.Pid#
				</cfif>
			
			</cfif>
		</td>
		<cfif Attributes.porFila></tr><tr></cfif>
		<td <cfif not Attributes.porFila> class="menuhead" <cfelse>height="20" width="40%" align="center"</cfif>>
			
			<cfif Attributes.porFila>
			<table border="0" cellspacing="0" cellpadding="2" <cfif not Attributes.porFila> align="right"<cfelse> align="center"</cfif> >
			<tr><td align="center" class="menuhead">
			</cfif>	
			
					<cfset nombre = "">
					<cfif ExistePersona>
						<cfset nombre = rsDatosPersona.NombreCompleto>
					</cfif>
					<input type="hidden" name="NombreCompleto#Attributes.sufijo#" id="NombreCompleto#Attributes.sufijo#" style="background-color: transparent; border: 0;" size="50" value="#nombre#" tabindex="-1" readonly />
					<cfif Attributes.showName>
						#rsDatosPersona.NombreCompleto#
					</cfif>
			
			<cfif Attributes.porFila>		
			</td></tr></table>
			</cfif>
		</td>
	  </tr>
	  
	  
	  <tr id="boxbotones#Attributes.sufijo#" style="display: none;">
	  	<td height="20" <cfif not Attributes.porFila>colspan="2" align="left" <cfelse> align="center"</cfif>>
			<table <cfif not Attributes.porFila>width="100%"<cfelse> width="40%"</cfif>  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td>
					<input name="rdGen#Attributes.sufijo#" id="rdGen#Attributes.sufijo#" type="radio" value="1" style="border: none;" onClick="javascript: showLogin#Attributes.sufijo#(this.value);" tabindex="1" checked><label for="rdGen1">Crear Usuario y enviar por correo</label>
				</td>
				<cfif Attributes.porFila></tr><tr></cfif>
				<td>
					<input name="rdGen#Attributes.sufijo#" id="rdGen#Attributes.sufijo#" type="radio" value="2" style="border: none;" onClick="javascript: showLogin#Attributes.sufijo#(this.value);" tabindex="1"><label for="rdGen2">Especificar Usuario y <cf_traducir key="clave">Contrase&ntilde;a</cf_traducir></label>
				</td>
			 	<cfif Attributes.porFila></tr><tr></cfif>
				<td <cfif Attributes.agente eq -1 or rsUsuarios.RecordCount eq 0 or (isdefined(form.tipo) and form.tipo eq 'Externo')> style="display:none;"</cfif>>
					<input name="rdGen#Attributes.sufijo#" id="rdGen#Attributes.sufijo#" type="radio" value="3" style="border: none;" onClick="javascript: showLogin#Attributes.sufijo#(this.value);" tabindex="1"><label for="rdGen3">Asignar rol a usuario existente</label>
				</td>

			  </tr>
			</table>
		</td>
	  </tr>
	  </cfif>
	  <tr>
	    <td <cfif not Attributes.porFila>colspan="2" align="left" <cfelse>align="center"</cfif> height="20">
			<table id="trUsuarioPass#Attributes.sufijo#" <cfif not Attributes.porFila>width="100%"<cfelse> width="50%"</cfif> border="0" cellspacing="0" cellpadding="2" <cfif not (ExisteUsuario and Attributes.cambioPass)> style="display: none;"</cfif>>
			  <tr>
				<td align="#Attributes.alignEtiquetas#" nowrap>Usuario SACI</td>
				<td>
					<cfif not Attributes.showId>
						<input type="hidden" name="Pid#Attributes.sufijo#" value="#Attributes.id#" />
					</cfif>
					<input type="hidden" name="userid#Attributes.sufijo#" id="userid#Attributes.sufijo#" value="<cfif ExisteUsuario>#rsUsuario.Usucodigo#</cfif>" />
					<input type="text" name="user#Attributes.sufijo#" id="user#Attributes.sufijo#" size="30" maxlength="30" tabindex="1" value="<cfif ExisteUsuario>#rsUsuario.Usulogin#</cfif>" <cfif ExisteUsuario>style="background-color: transparent; border: 0;" readonly</cfif>/>
				</td>
				<cfif Attributes.porFila></tr><tr></cfif>
				<td align="#Attributes.alignEtiquetas#" nowrap><cf_traducir key="clave">Contrase&ntilde;a</cf_traducir></td>
				<td>
					<input type="password" name="userPass1#Attributes.sufijo#" id="userPass1#Attributes.sufijo#" size="30" maxlength="30" value="<cfif ExisteUsuario>**********</cfif>" tabindex="1" />
				</td>
				<cfif Attributes.porFila></tr><tr></cfif>
				<td align="#Attributes.alignEtiquetas#" nowrap>Confirmar <cf_traducir key="clave">Contrase&ntilde;a</cf_traducir></td>
				<td>
					<input type="password" name="userPass2#Attributes.sufijo#" id="userPass2#Attributes.sufijo#" size="30" maxlength="30" value="<cfif ExisteUsuario>**********</cfif>" tabindex="1" />
				</td>
			  </tr>
			</table>
			<table id="trCorreo#Attributes.sufijo#" width="50%" border="0" cellspacing="0" cellpadding="2" style="display: none;">
			  <tr>
				<td align="#Attributes.alignEtiquetas#" nowrap>Correo</td>
				<td>					
					<input type="text" name="userEmail#Attributes.sufijo#" size="40" maxlength="40" value="<cfif isdefined('rsLogin') and Len(rsLogin.Pemail)> #rsLogin.Pemail# <cfelse>''</cfif>" tabindex="1"/>
				</td>
			  </tr>
			</table>
			<cfif Attributes.agente gt 0>
			<table id="trUsuario#Attributes.sufijo#" width="100%" border="0" cellspacing="0" cellpadding="3" style="display: none;">
			  <tr>
				<td width="82%" align="#Attributes.alignEtiquetas#" nowrap>Usuario SACI</td>
				<td>
					<select name="userexistente#Attributes.sufijo#"  maxlength="40" id="userexistente#Attributes.sufijo#" tabindex="1">
					<cfloop query="rsUsuarios">					
						<option value="#rsUsuarios.Usulogin#">#rsUsuarios.Usulogin#</option>
					</cfloop>
					</select>
				</td>
			  </tr>
			</table>
			</cfif>

		</td>
      </tr>
	<tr>
	    <td <cfif not Attributes.porFila>colspan="2"</cfif>  align="center" height="20">
			<table id="trMensaje#Attributes.sufijo#" <cfif not ExisteUsuario> style="display: none;"</cfif> width="100%" border="0" cellspacing="0" cellpadding="2">
				<tr>				
					<td align="center" colspan="4">
					<label>										
					<cfif ExisteUsuario and isdefined('rsUsuarios')>
						<cfif Attributes.showId>El usuario (#rsUsuarios.Usulogin#) está #rsUsuarios.Estado#.</cfif>
					</cfif>
					</label>
					<label>
					<cfif Attributes.cambioPass>Para cambiar la contrase&ntilde;a proceda a digitarla nuevamente.</cfif>					
					</label>
					</td>
				</tr>
		  </table>
		</td>
	</tr>
	  <tr>
	    <td <cfif not Attributes.porFila>colspan="2"</cfif> height="20" align="center">
			<table id="trRoles#Attributes.sufijo#" <cfif not ExisteUsuario> style="display: none;"</cfif> border="0" cellspacing="0" cellpadding="2" align="center">
			  <tr>
				<td align="right"><label>Grupos a los cuales pertenece el usuario:</label></td>
				<cfloop list="#Attributes.rolesAMostrar#" index="i">
					<td>
						<cfif ListFind(rolesAsignados, i, ',') NEQ 0>
							<img id="checked#Attributes.sufijo#" src="/cfmx/saci/images/checked.gif" border="0">
						<cfelse>
							<img id="unchecked#Attributes.sufijo#" src="/cfmx/saci/images/unchecked.gif" border="0">
						</cfif>
					</td>
					<td>#i#</td>
				</cfloop>
			  </tr>
			  <tr>	
					<table id=bloqueos>					
	  		  		<cfif isdefined('bloqueos.RecordCount') and bloqueos.RecordCount>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td width="15%" align="left" nowrap="nowrap"><strong>Bloqueos</strong></td>
						</tr>
						<tr>
							<td style="border:ridge" align="left" nowrap="nowrap"><strong>Fecha</strong></td>
							<td style="border:ridge" align="left" nowrap="nowrap"><strong>Bloqueado Hasta</strong></td>
							<td style="border:ridge" align="left" nowrap="nowrap"><strong>Razón</strong></td>
							<td style="border:ridge" align="left" nowrap="nowrap"><strong>Desbloqueado</strong></td>
						</tr>
						<cfloop query="bloqueos">	
							<tr>
							  <td align="left">#LSdateformat(bloqueos.fecha,'dd/mm/yyyy')# #LSdateformat(bloqueos.fecha,'HH:mm:ss')#</td>
							  <td align="left">#LSdateformat(bloqueos.bloqueo,'dd/mm/yyyy')# #LSdateformat(bloqueos.bloqueo,'HH:mm:ss')#</td>
							  <td align="left">#bloqueos.razon#</td>
							  <td align="left">#bloqueos.desbloq#</td>
							</tr>
						</cfloop>
			  		</cfif>					
					</table>
				</tr> 	
			</table>
		</td>
      </tr>
	</table>

	<cfif not isdefined("Request.FrameUsuarioSACI")>
		<iframe id="frusuariosaci" name="frusuariosaci" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
		<cfset Request.FrameUsuarioSACI = True>
	</cfif>
	
	<cfif Attributes.showId>
	<script language="javascript" type="text/javascript">
		function showLogin#Attributes.sufijo#(v) {
			var a = document.getElementById("trUsuarioPass#Attributes.sufijo#");
			var b = document.getElementById("trCorreo#Attributes.sufijo#");
			var c = document.getElementById("trUsuario#Attributes.sufijo#");

			if (v == '2') {
				a.style.display = '';
				b.style.display = 'none';
				if (c != undefined) 
					c.style.display = 'none';
			}
			else if (v == '1') {
				a.style.display = 'none';
				b.style.display = '';
				if (c != undefined) 
				c.style.display = 'none';
			} else if (v == '3') {
				a.style.display = 'none';
				b.style.display = 'none';
				if (c != undefined) 
				c.style.display = '';
			}
		}

		function ConsultarUsuario#Attributes.sufijo#(persona,agente) 
		{
			var fr = document.getElementById("frusuariosaci");
			<cfif ExisteCuenta and isdefined('rsLogin.Pemail') and Len(rsLogin.Pemail)>
				fr.src = '/cfmx/saci/utiles/queryUsuarioSACI.cfm?pq='+persona+'&agente='+agente+'&sufijo=#Attributes.sufijo#&conexion=#Attributes.Conexion#&Pemail=#rsLogin.Pemail#';
			<cfelse>
				fr.src = '/cfmx/saci/utiles/queryUsuarioSACI.cfm?pq='+persona+'&agente='+agente+'&sufijo=#Attributes.sufijo#&conexion=#Attributes.Conexion#';
			</cfif>
		}
		
<!--- 
		function ConsultarUsuario#Attributes.sufijo#(persona) 
		{
			var fr = document.getElementById("frusuariosaci");
			fr.src = '/cfmx/saci/utiles/queryUsuarioSACI.cfm?pq='+persona+		'&sufijo=#Attributes.sufijo#&conexion=#Attributes.Conexion#';
		}
--->		
		
		function CargarValoresUsuario#Attributes.sufijo#() {
			var a = document.getElementById("trUsuarioPass#Attributes.sufijo#");
			var b = document.getElementById("trCorreo#Attributes.sufijo#");
			var c = document.getElementById("trMensaje#Attributes.sufijo#");
			var d = document.getElementById("boxbotones#Attributes.sufijo#");
			if (document.#Attributes.form#.NombreCompleto#Attributes.sufijo#) 
			document.#Attributes.form#.NombreCompleto#Attributes.sufijo#.value = arguments[1];
			document.#Attributes.form#.userEmail#Attributes.sufijo#.value = arguments[2];
			if (arguments[0]) {
				a.style.display = '<cfif not Attributes.cambioPass>none</cfif>';
				<cfif Attributes.cambioPass>
					document.#Attributes.form#.user#Attributes.sufijo#.value = arguments[3];
					document.#Attributes.form#.userPass1#Attributes.sufijo#.value = '**********';
					document.#Attributes.form#.userPass2#Attributes.sufijo#.value = '**********';
				<cfelse>
					document.#Attributes.form#.user#Attributes.sufijo#.value = '';
					document.#Attributes.form#.userPass1#Attributes.sufijo#.value = '';
					document.#Attributes.form#.userPass2#Attributes.sufijo#.value = '';
				</cfif>
				b.style.display = 'none';
				c.style.display = '';
				d.style.display = 'none';
			} else {
				c.style.display = 'none';
				d.style.display = '';
				showLogin#Attributes.sufijo#((document.#Attributes.form#.rdGen#Attributes.sufijo#[0].checked?'1':'2'));
				document.#Attributes.form#.user#Attributes.sufijo#.value = '';
				document.#Attributes.form#.userPass1#Attributes.sufijo#.value = '';
				document.#Attributes.form#.userPass2#Attributes.sufijo#.value = '';
			}
		}
		
		function resetUsuario#Attributes.sufijo#() {
			var a = document.getElementById("trUsuarioPass#Attributes.sufijo#");
			var b = document.getElementById("trCorreo#Attributes.sufijo#");
			var c = document.getElementById("trMensaje#Attributes.sufijo#");
			var d = document.getElementById("boxbotones#Attributes.sufijo#");
			a.style.display = 'none';
			b.style.display = 'none';
			c.style.display = 'none';
			d.style.display = 'none';
			if (document.#Attributes.form#.NombreCompleto#Attributes.sufijo#) document.#Attributes.form#.NombreCompleto#Attributes.sufijo#.value = '';
			document.#Attributes.form#.user#Attributes.sufijo#.value = '';
			document.#Attributes.form#.userPass1#Attributes.sufijo#.value = '';
			document.#Attributes.form#.userPass2#Attributes.sufijo#.value = '';
			document.#Attributes.form#.userEmail#Attributes.sufijo#.value = '';

		}

		function CargarValoresUsuarioTodo#Attributes.sufijo#() {
			<cfif not Attributes.readonly>
				formatMascara#Attributes.sufijo#();		//funcion que se encuentra en el tag de identificacion, se usa para dar formato a la identificacion dependiendo de la personeria. Se ejecuta al traer un nuevo identificador.
			</cfif>
<!---			ConsultarUsuario#Attributes.sufijo#(document.#Attributes.form#.Pquien#Attributes.sufijo#.value);--->
				ConsultarUsuario#Attributes.sufijo#(document.#Attributes.form#.Pquien#Attributes.sufijo#.value,#Attributes.agente#);
		}
		
		function validarCreacion() {
			var a = document.getElementById("boxbotones");
			if ((a.style.display == 'none') || (document.form1.rdGen[0].checked && document.form1.userEmail.value == '') || (document.form1.rdGen[1].checked && (document.form1.user.value == '' || document.form1.userPass1.value == ''))) {
				alert('No se puede crear el usuario porque ya tiene un usuario creado o no ha llenado los campos requeridos para crear el usuario');
				return false;
			}
			if (document.form1.rdGen[1].checked) {
				if (document.form1.userPass1.value != document.form1.userPass2.value) {
					alert('La confirmación de la contraseña es diferente a la contraseña digitada. Digite ambas nuevamente.');
					return false;
				}
			}
			
			if (document.form1.rdGen[2].checked) {
				if (document.form1.userexistente == "") {
					alert('Error.No existe Usuario.');
					return false;
				}
			}
			
			return true;
		}

		<cfif ExistePersona>
			CargarValoresUsuarioTodo#Attributes.sufijo#();
		</cfif>
		
	</script>
	</cfif>
	
</cfoutput>
