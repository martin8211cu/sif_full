<!---
 * 24 Apr 2006 - Creación en Java
 * 15 Ago 2006 - Conversión a CFC
 * Implementa la comunicacin con el servicio remoto de iPlanet Directory Server
 * 5.2 mediante las instrucciones ldapmodify a travs de ssh.
 * 
 * Los parámetros de configuración utilizados son:
 * ldap.host. Nombre del equipo donde se encuentra el directorio.
 * ldap.port. Nombre del equipo donde se encuentra el directorio.
 * ldap.user. Usuario administrador del directorio.
 * ldap.pass. Contraseña del administrador

// Validar que los atributos no tengan el separador ($), o usar otro
// separador

--->
<cfcomponent output="no" extends="ShellService">

	<cfset This.Enabled = getParametro(520) is 1>
	<cfset This.LdapSuffix = getParametro(521)>
	<cfset This.AltMailDomain = getParametro(522)>
	<cfset This.MailHost = getParametro(523)>
	<cfset This.ldaphost = getParametro(524)>
	<cfset This.ldapuser = getParametro(525)>
	<cfset This.ldappass = getParametro(526)>
	<cfset This.ldapport = getParametro(527)>
	<cfset This.mailEnabled = getParametro(528)>

	<!---add--->
	<cffunction name="add" returntype="void" output="false" hint="Crea un usuario en servidor de correo iPlanet/SunONE">
		<cfargument name="Usuario" type="string" required="yes" hint="Nombre del usuario por agregar (uid)">
		<cfargument name="MailQuotaKB" type="string" required="yes" hint="Tamaño del casillero del correo, en KB">
		<cfargument name="RealName" type="string" required="yes" hint="Nombre de la cuenta por agregar (cn)">
		<cfargument name="Nombre" type="string" required="yes" hint="Nombres(s) de la persona">
		<cfargument name="Apellido" type="string" required="yes" hint="Apellidos(s) de la persona">
		<cfargument name="UserPassword" type="string" required="yes" hint="Contraseña del usuario">
		<cfset var attributes = ArrayNew(1)>
		<cfif Not checkEnabled()><cfreturn></cfif>
		<cftry>
			<cfset control_mensaje( 'IPL-0001', 'usuario:#Arguments.usuario#' )>
			<cfif This.Debug>
				<cflog file="isb_interfaz" text="add (#Arguments.Usuario#)">
			</cfif>
			<cfif existePerfil(Arguments.Usuario)>
				<cfset control_mensaje( 'IPL-0004', 'usuario:#Arguments.usuario# ya existe'  )>
				<cfreturn>
			</cfif>
			<cfquery datasource="#session.dsn#" name="attrs">
				select linea, atributo, valor
				from ISBparametrosLDAP
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				<cfif Not This.mailEnabled>
				  and correo = 0
				</cfif>
				order by atributo, linea
			</cfquery>
			
			 <!---Cuando en  un cliente Jurídico no vienen los apellidos--->
			 <cfif Arguments.Apellido eq ' ' >
			 	<cfset Arguments.Apellido = 'EMPTY'>
			 </cfif>	
			 
			<cfset attributes = calcAttributes(Arguments, attrs)>
			<cfldap server="#This.ldaphost#" port="#This.ldapport#"
				username="#This.ldapuser#" password="#This.ldappass#"
				action="add"
				dn="#getDN(Arguments.Usuario)#" attributes="#ArrayToList(attributes, ';')#" separator="$">
		<cfcatch type="any">
			<cfset iplanet_catch(cfcatch)>
		</cfcatch>
		</cftry>
	</cffunction>
	<!---update--->
	<cffunction name="update" returntype="void" output="false" hint="Modifica los datos de la cuenta en el servidor iplanet directory server.">
		<cfargument name="Usuario" type="string" required="yes" hint="Nombre del usuario por modificar (uid)">
		<cfargument name="MailQuotaKB" type="string" required="yes" hint="Tamaño del casillero del correo, en KB">
		<cfargument name="RealName" type="string" required="yes" hint="Nombre de la cuenta por agregar (cn)">
		<cfargument name="Nombre" type="string" required="yes" hint="Nombres(s) de la persona">
		<cfargument name="Apellido" type="string" required="yes" hint="Apellidos(s) de la persona">
		<cfset var attributes = ArrayNew(1)>
		<cfif Not checkEnabled()><cfreturn></cfif>
		<cftry>
			<cfset control_mensaje( 'IPL-0006', 'usuario:#Arguments.usuario#' )>
			<cfif This.Debug>
				<cflog file="isb_interfaz" text="update (#Arguments.Usuario#)">
			</cfif><!---
			<cfif not existePerfil(Arguments.Usuario)><cfreturn></cfif>--->
			<cfquery datasource="#session.dsn#" name="attrs">
				select linea, atributo, valor
				from ISBparametrosLDAP
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and atributo != 'uid'
				  and charindex('##', valor) != 0 <!--- sólo los que son variables --->
				  and charindex('##USERPASSWORD##', upper (valor)) = 0<!--- el password no se reenvía --->
				<cfif Not This.mailEnabled>
				  and correo = 0
				</cfif>
				order by atributo, linea
			</cfquery>
			<cfset attributes = calcAttributes(Arguments, attrs)>
			<cfldap server="#This.ldaphost#" port="#This.ldapport#"
				username="#This.ldapuser#" password="#This.ldappass#"
				action="modify" 
				dn="#getDN(Arguments.Usuario)#" attributes="#ArrayToList(attributes, ';')#" separator="$">
		<cfcatch type="any">
			<cfset iplanet_catch(cfcatch)>
		</cfcatch>
		</cftry>
	</cffunction>
	<!---updatePassword--->
	<cffunction name="updatePassword" returntype="void" output="false" hint="Modifica los datos de la cuenta en el servidor iplanet directory server.">
		<cfargument name="Usuario" type="string" required="yes" hint="Nombre del usuario por modificar (uid)">
		<cfargument name="UserPassword" type="string" required="yes" hint="Tamaño del casillero del correo, en KB">
		<cfset var attributes = ArrayNew(1)>
		<cfif Not checkEnabled()><cfreturn></cfif>
		<cftry>
			<cfset control_mensaje( 'IPL-0007', 'usuario:#Arguments.usuario#' )>
			<cfif This.Debug>
				<cflog file="isb_interfaz" text="updatePassword (#Arguments.Usuario#)">
			</cfif>
			<cfif not existePerfil(Arguments.Usuario)><cfreturn></cfif>
			<cfquery datasource="#session.dsn#" name="attrs">
				select linea, atributo, valor
				from ISBparametrosLDAP
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and atributo != 'uid'
				  and charindex('##', valor) != 0 <!--- sólo los que son variables --->
				  and charindex('##USERPASSWORD##', upper (valor)) != 0<!--- sólo el password se reenvía --->
				<cfif Not This.mailEnabled>
				  and correo = 0
				</cfif>
				order by atributo, linea
			</cfquery>
			<cfset attributes = calcAttributes(Arguments, attrs)>
			<cfldap server="#This.ldaphost#" port="#This.ldapport#"
				username="#This.ldapuser#" password="#This.ldappass#"
				action="modify" 
				dn="#getDN(Arguments.Usuario)#" attributes="#ArrayToList(attributes, ';')#" separator="$">
		<cfcatch type="any">
			<cfset iplanet_catch(cfcatch)>
		</cfcatch>
		</cftry>
	</cffunction>
	<!---testPassword--->
	<cffunction name="testPassword" returntype="boolean" output="true" hint="Indica si el password es válido">
		<cfargument name="Usuario" type="string" required="yes" hint="Nombre del usuario por modificar (uid)">
		<cfargument name="UserPassword" type="string" required="yes" hint="Tamaño del casillero del correo, en KB">
		<cfif Not checkEnabled()><cfreturn false></cfif>
		<cftry>
			<cfif This.Debug>
				<cflog file="isb_interfaz" text="testPassword (#Arguments.Usuario#)">
			</cfif>
			<cfif not existePerfil(Arguments.Usuario)><cfreturn false></cfif>
			<cfset control_mensaje( 'IPL-0008', 'usuario:#Arguments.usuario#' )>
			<cfldap server="#This.ldaphost#" port="#This.ldapport#"
				username="#getDN(Arguments.Usuario)#" password="#Arguments.UserPassword#"
				action="query" filter="uid=#Arguments.usuario#" 
				attributes="uid" name="rs" start="#This.ldapsuffix#" separator="$">
			<cfcatch type="any">
				<cfreturn false>
			</cfcatch>
		</cftry>
		<cfreturn true>
	</cffunction>
	<!---addMailForward--->
	<cffunction name="addMailForward" returntype="void" output="false" hint="Agrega un mail forward en el servidor iplanet directory server.">
		<cfargument name="Usuario" type="string" required="yes" hint="Nombre del usuario por modificar (uid)">
		<cfargument name="MailForwardAddress" type="string" required="yes" hint="Direcciones para reenvo del correo, separadas por coma">
		<cfif Not checkEnabled()><cfreturn></cfif>
		<cftry>
			<cfif This.Debug>
				<cflog file="isb_interfaz" text="addMailForward (#Arguments.Usuario#, #Arguments.MailForwardAddress#)">
			</cfif>
			<cfif not existePerfil(Arguments.Usuario)><cfreturn></cfif>
			<cfif This.mailEnabled and Len(Arguments.MailForwardAddress)>
				<cfset control_mensaje( 'IPL-0009', 'usuario:#Arguments.usuario#' )>
				<!--- Buscar mailDelivery/Forwarding del usuario
					Se especifica separator para que sea una coma sin espacios --->
				<cfldap server="#This.ldaphost#" port="#This.ldapport#"
					username="#This.ldapuser#" password="#This.ldappass#"
					action="query" filter="uid=#Arguments.Usuario#" name="existe" 
					attributes="mailDeliveryOption,mailForwardingAddress" start="#This.ldapsuffix#" separator=",">
				<!--- Agregar si no existe --->
				<cfif Not ListFind(existe.mailDeliveryOption, 'forward')>
					<cfset control_mensaje( 'IPL-0002', 'attributes:mailDeliveryOption=forward' )>
					<cfldap server="#This.ldaphost#" port="#This.ldapport#"
						username="#This.ldapuser#" password="#This.ldappass#"
						action="modify" modifytype="add"
						dn="#getDN(Arguments.Usuario)#" attributes="mailDeliveryOption=forward">
				</cfif>
				<cfif Not ListFind(existe.mailForwardingAddress, Arguments.MailForwardAddress)>
					<cfset control_mensaje( 'IPL-0002', 'attributes:mailForwardingAddress=#Arguments.MailForwardAddress#' )>
					<cfldap server="#This.ldaphost#" port="#This.ldapport#"
						username="#This.ldapuser#" password="#This.ldappass#"
						action="modify" modifytype="add"
						dn="#getDN(Arguments.Usuario)#" attributes="mailForwardingAddress=#Arguments.MailForwardAddress#">
				<cfelse>
					<cfset control_mensaje( 'IPL-0015', 'duplicado:#Arguments.MailForwardAddress#' )>
				</cfif>
			</cfif>
		<cfcatch type="any">
			<cfset iplanet_catch(cfcatch)>
		</cfcatch>
		</cftry>
	</cffunction>
	<!---deleteMailForward--->
	<cffunction name="deleteMailForward" returntype="void" output="false" hint="Elimina un forwarding address.">
		<cfargument name="Usuario" type="string" required="yes" hint="Nombre del usuario por modificar (uid)">
		<cfargument name="MailForwardAddress" type="string" required="yes" hint="Direcciones para reenvo del correo, separadas por coma">

		<cfif Not checkEnabled()><cfreturn></cfif>
		<cftry>
			<cfif This.Debug>
				<cflog file="isb_interfaz" text="deleteMailForward (#Arguments.Usuario#, #Arguments.MailForwardAddress#)">
			</cfif>
			<cfif not existePerfil(Arguments.Usuario)><cfreturn></cfif>
			<cfif This.mailEnabled and Len(Arguments.MailForwardAddress)>
				<cfset control_mensaje( 'IPL-0010', 'usuario:#Arguments.usuario#' )>
				<!--- Buscar mailDelivery/Forwarding del usuario.
					Se especifica separator para que sea una coma sin espacios --->
				<cfldap server="#This.ldaphost#" port="#This.ldapport#"
					username="#This.ldapuser#" password="#This.ldappass#"
					action="query" filter="uid=#Arguments.Usuario#" name="existe" 
					attributes="mailDeliveryOption,mailForwardingAddress" start="#This.ldapsuffix#" separator=",">
				<!--- Borrar si existe --->
				<cfif ListFind(existe.mailForwardingAddress, Arguments.MailForwardAddress)>
					<cfset control_mensaje( 'IPL-0002', 'attributes:mailForwardingAddress=#Arguments.MailForwardAddress#' )>
					<cfldap server="#This.ldaphost#" port="#This.ldapport#"
						username="#This.ldapuser#" password="#This.ldappass#"
						action="modify" modifytype="delete"
						dn="#getDN(Arguments.Usuario)#" attributes="mailForwardingAddress=#Arguments.MailForwardAddress#">
					<!--- Solamente si era el único mailForwardingAddress lo borramos --->
					<cfif ListFind(existe.mailDeliveryOption, 'forward') And ListLen(existe.mailForwardingAddress)>
						<cfset control_mensaje( 'IPL-0002', 'attributes:mailDeliveryOption=forward' )>
						<cfldap server="#This.ldaphost#" port="#This.ldapport#"
							username="#This.ldapuser#" password="#This.ldappass#"
							action="modify" modifytype="delete"
							dn="#getDN(Arguments.Usuario)#" attributes="mailDeliveryOption=forward">
					</cfif>
				<cfelse>
					<cfset control_mensaje( 'IPL-0016', 'no encontrado:#Arguments.MailForwardAddress#' )>
				</cfif>
			</cfif>
		<cfcatch type="any">
			<cfset iplanet_catch(cfcatch)>
		</cfcatch>
		</cftry>
	</cffunction>
	<!---lock--->
	<cffunction name="lock" returntype="void" output="false" hint="Bloquea la cuenta en el servidor iplanet directory server.">
		<cfargument name="Usuario" type="string" required="yes" hint="Nombre del usuario por modificar (uid)">
		<cfset var attributes = ArrayNew(1)>
		<cfif Not checkEnabled()><cfreturn></cfif>
		<cftry>
			<cfif This.Debug>
				<cflog file="isb_interfaz" text="lock (#Arguments.Usuario#)">
			</cfif>
			<cfif not existePerfil(Arguments.Usuario)><cfreturn></cfif>
			<cfif This.mailEnabled>
				<cfset control_mensaje( 'IPL-0011', 'usuario:#Arguments.usuario#' )>
				<!--- atributos que no funcionan sin servidor de Messaging Server --->
				<cfset ArrayAppend(attributes, 'inetUserStatus=inactive')>
				<cfset control_mensaje( 'IPL-0002', 'attributes:#ArrayToList(attributes, '; ')#' )>
				<cfldap server="#This.ldaphost#" port="#This.ldapport#"
					username="#This.ldapuser#" password="#This.ldappass#"
					action="modify" 
					dn="#getDN(Arguments.Usuario)#" attributes="#ArrayToList(attributes, ';')#" separator="$">
			</cfif>
		<cfcatch type="any">
			<cfset iplanet_catch(cfcatch)>
		</cfcatch>
		</cftry>
	</cffunction>
	<!---unlock--->
	<cffunction name="unlock" returntype="void" output="false" hint="Desbloquea la cuenta en el servidor iplanet directory server.">
		<cfargument name="Usuario" type="string" required="yes" hint="Nombre del usuario por modificar (uid)">
		<cfset var attributes = ArrayNew(1)>
		<cfif Not checkEnabled()><cfreturn></cfif>
		<cftry>
			<cfif This.Debug>
				<cflog file="isb_interfaz" text="unlock (#Arguments.Usuario#)">
			</cfif>
			<cfif not existePerfil(Arguments.Usuario)><cfreturn></cfif>
			<cfif This.mailEnabled>
				<cfset control_mensaje( 'IPL-0012', 'usuario:#Arguments.usuario#' )>
				<!--- atributos que no funcionan sin servidor de Messaging Server --->
				<cfset ArrayAppend(attributes, 'inetUserStatus=active')>
				<cfset control_mensaje( 'IPL-0002', 'attributes:#ArrayToList(attributes, '; ')#' )>
				<cfldap server="#This.ldaphost#" port="#This.ldapport#"
					username="#This.ldapuser#" password="#This.ldappass#"
					action="modify" 
					dn="#getDN(Arguments.Usuario)#" attributes="#ArrayToList(attributes, ';')#" separator="$">
			</cfif>
		<cfcatch type="any">
			<cfset iplanet_catch(cfcatch)>
		</cfcatch>
		</cftry>
	</cffunction>
	<!---delete--->
	<cffunction name="delete" returntype="void" output="false" hint="Borra un usuario en servidor de correo iPlanet/SunONE">
		<cfargument name="Usuario" type="string" required="yes" hint="Nombre del usuario por agregar (uid)">
		<cfif Not checkEnabled()><cfreturn></cfif>
		<cftry>
			<cfif This.Debug>
				<cflog file="isb_interfaz" text="delete (#Arguments.Usuario#)">
			</cfif>
			<cfif not existePerfil(Arguments.Usuario)><cfreturn></cfif>
			<cfset control_mensaje( 'IPL-0013', 'usuario:#Arguments.usuario#' )>
			<cfldap server="#This.ldaphost#" port="#This.ldapport#"
				username="#This.ldapuser#" password="#This.ldappass#"
				action="delete"
				dn="#getDN(Arguments.Usuario)#">
		<cfcatch type="any">
			<cfset iplanet_catch(cfcatch)>
		</cfcatch>
		</cftry>
	</cffunction>
	<!---getDN--->
	<cffunction name="getDN" returntype="string" output="false" hint="Calcula el DN esperado para un usuario">
		<cfargument name="Usuario" type="string" required="yes" hint="Usuario cuyo DN calcular">
		<cfreturn 'uid=' & Arguments.Usuario & ',' & This.LdapSuffix>
	</cffunction>
	<!---dump--->
	<cffunction name="dump" returntype="boolean" output="true" hint="Muestra la información del usuario">
		<cfargument name="uid" type="string" required="yes" hint="Nombre del usuario por desplegar">
		<cfargument name="title" type="string" default="" required="yes" hint="Titulo por desplegar">
		<cfif Not checkEnabled()><div>Interfaz inhabilitada</div><cfreturn false></cfif>
		<cftry>
			<cfset cols = 'dn,uid,givenName,sn,cn,objectClass,inetUserStatus,mailDeliveryOption,mailForwardingAddress'>
			<cfldap server="#This.ldaphost#" port="#This.ldapport#"
				username="#This.ldapuser#" password="#This.ldappass#"
				action="query" filter="uid=#Arguments.uid#" 
				attributes="#cols#" name="rs" start="#This.ldapsuffix#">
			<table style="background-color:##CCCCCC" >
				<tr><td style="background-color:##999999" colspan="2">
					<strong>#HTMLEditFormat( Arguments.uid)#</strong> - 
					# HTMLEditFormat( title )#
					</td></tr>
				<cfloop list="#cols#" index="col"><tr><td>#HTMLEditFormat( col)#</td>
					<td>#HTMLEditFormat( Evaluate('rs.' & col))#</td></tr></cfloop>
			</table>
			<cfreturn rs.RecordCount neq 0>
		<cfcatch type="any">
			<cfoutput><div style="color:red">#cfcatch.Message# #cfcatch.Detail#</div></cfoutput>
		</cfcatch>
		</cftry>
		<cfreturn false>
	</cffunction>
	<!---rename--->
	<cffunction name="rename" output="false" returntype="void" hint="Actualiza el login del usuario">
		<cfargument name="usuario" type="string" required="yes" hint="Nombre actual (anterior)">
		<cfargument name="nuevo" type="string" required="yes" hint="Nombre nuevo">
		<cfif Not checkEnabled()><cfreturn></cfif>
		<cftry>
			<cfset control_mensaje( 'IPL-0014', 'usuario:#Arguments.usuario#' )>
			<cfif This.Debug>
				<cflog file="isb_interfaz" text="rename (#Arguments.Usuario#, #Arguments.nuevo#)">
			</cfif>
			<cfif not existePerfil(Arguments.Usuario)><cfreturn></cfif>
			PENDIENTE: Modificar atributos de email
			<cfset control_mensaje( 'IPL-0002', 'uid=#Arguments.nuevo#' )>
			<cfldap server="#This.ldaphost#" port="#This.ldapport#"
				username="#This.ldapuser#" password="#This.ldappass#"
				action="modifydn" 
				dn="#getDN(Arguments.Usuario)#" attributes="uid=#Arguments.nuevo#">
		<cfcatch type="any">
			<cfset iplanet_catch(cfcatch)>
		</cfcatch>
		</cftry>
	</cffunction>
	<!---existePerfil--->
	<cffunction name="existePerfil" output="false" returntype="boolean" hint="Revisa si el usuario existe">
		<cfargument name="usuario" type="string" required="no" hint="Recibe el nombre del usuario por consultar">
		<cfif Not checkEnabled()><cfreturn false></cfif>
		<cfldap server="#This.ldaphost#" port="#This.ldapport#"
			username="#This.ldapuser#" password="#This.ldappass#"
			action="query" filter="uid=#Arguments.usuario#" 
			attributes="uid" name="rs" start="#This.ldapsuffix#">
		<cfset control_mensaje( 'IPL-0003', 'existePerfil(#Arguments.usuario#): #rs.RecordCount NEQ 0#' )>
		<cfreturn rs.RecordCount NEQ 0>
	</cffunction>
	<!---iplanet_catch--->
	<cffunction name="iplanet_catch" returntype="void" output="false" access="private">
		<!--- hacer un mapeo similar al de shellService.check_exitCode --->
		<cfargument name="error" type="any">
		<cfset control_catch (Arguments.error)>
	</cffunction>
	<!---checkEnabled--->
	<cffunction name="checkEnabled" returntype="boolean" output="false">
		<cfif Not This.Enabled>
			<cfset control_mensaje( 'IPL-0005', 'La interfaz con iPlanet está inactiva' )>
		</cfif>
		<cfreturn This.Enabled>
	</cffunction>
	<!--- calcAttributes --->
	<cffunction name="calcAttributes">
		<cfargument name="baseArguments" type="struct" required="yes">
		<cfargument name="attrs" type="query" required="yes">
		<!--- Variables válidas en definición de parámetros:
			[Arguments] Usuario, MailQuotaKB, Nombre, Apellido, RealName, UserPassword
			[This]         MailHost, AltMailDomain
		--->
		<cfset var ret_array = ArrayNew(1)>
		<cfset StructAppend(Variables, Arguments.baseArguments)>
		<cfset StructAppend(Variables, This)>
		<cfoutput query="Arguments.attrs" group="atributo">
			<!--- este bloque hay que factorizarlo, cuando haga la cirugía --->
			<cfset ValorMultiple = ''>
			<cfoutput>
				<cfset ValorEval = Arguments.attrs.valor>
				<cfset pos2 = 1>
				<cfloop condition="Find('##', ValorEval)">
					<cfset pos1 = Find('##', ValorEval, pos2)>
					<cfif pos1 is 0><cfbreak></cfif>
					<cfset pos2 = Find('##', ValorEval, pos1 + 1)>
					<cfif pos2 is 0><cfbreak></cfif>
					<cfif pos1 GE 1 And (pos2 - pos1 - 1 GT 0)>
						<cfset expresion = Mid(ValorEval, pos1+1, pos2 - pos1 - 1)>
						<!--- Uso Mid() porque ni Right() ni Left() admiten longitudes cero --->
						<cfset ValorEval = Mid(ValorEval, 1, pos1 - 1) & Evaluate(expresion) & Mid(ValorEval, pos2 + 1, Len(ValorEval))>
						<cfset pos2 = pos1 + Len(expresion)>
					<cfelse>
						<cfset pos2 = pos1 + 1>
					</cfif>
				</cfloop>
				
				<cfif Not Len(ValorEval)><cfset ValorEval = 'EMPTY'></cfif>
				<cfset ValorMultiple = ListAppend(ValorMultiple, ValorEval, '$')>
			</cfoutput>
			<cfset ArrayAppend(ret_array, Arguments.attrs.atributo & '=' & ValorMultiple)>
			<!---<cflog file="iplanet2" text="#Arguments.attrs.atributo# = #ValorEval#">--->
		</cfoutput>
		<cflog file="iplanet2" text="attributes==>#ArrayToList(ret_array, ';')#">
		<cfset control_mensaje( 'IPL-0002', 'attributes:#ArrayToList(ret_array, '; ')#' )>
		<cfset server.atts = ret_array>
		<cfreturn ret_array>
	</cffunction>
</cfcomponent>
