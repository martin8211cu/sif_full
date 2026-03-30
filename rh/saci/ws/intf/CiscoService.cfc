<!---
 * 26 Apr 2006 - Creación en Java
 * 10 Ago 2006 - Conversión a CFC
 *
 * Implementa la comunicación con el servicio remoto de Cisco Secure ACS 3.2
 * mediante las instrucciones CLI/* a través de ssh.
 * 
 * Se utilizan los siguientes parámetros de configuración:
 * This.PathCommandsCLI. Ruta del directorio CLI/, adonde están los
 *    binarios para interactuar con el Cisco ACS, incluyendo, si es necesario, ssh.
 *    Debe incluir el slash final.
 * This.HostDBCisco. Host donde se encuentra la base de datos de
 *     configuracin del Cisco ACS
 * This.PortDBCisco. Puerto donde se encuentra la base de datos de
 *     configuración del Cisco ACS
 * PackageParentGroup. Grupo padre para la creación de paquetes
 * DisabledUsersGroup. Grupo al cual mover los usuario para inhabilitarlos
 * 
--->
<cfcomponent extends="ShellService" output="no">

	<cfset This.Enabled = getParametro(500) is 1>
	<cfset This.PathCommandsCLI = getParametro(501)>
	<cfset This.HostDBCisco = getParametro(502)>
	<cfset This.PortDBCisco = getParametro(503)>
	<cfset This.PackageParentGroup = getParametro(504)>
	<cfset This.DisabledUsersGroup = getParametro(505)>
	<cfset This.autoriza = getParametro(506)>
	<cfset This.modoShell = getParametro(510)>

	<!--- createPackage --->
	<cffunction name="createPackage" output="false" returntype="numeric" hint="Cero si no hubo error, o el número de error si hubo">
		<cfargument name="grupo" type="string" required="yes" hint="Recibe el nombre del grupo">
		<cfargument name="clave" type="string" required="yes" hint="Recibe la clave">
		<cfargument name="parentGroup" type="string" default="#This.PackageParentGroup#" hint="Grupo/Paquete padre">
		<cfargument name="maxSession" type="string" default="" hint="Número Maximo de Sesiones">
		<cfargument name="tunnelID" type="string" default="" hint="Para crear grupos de VPN">
		<cfargument name="tunnelIP" type="string" default="" hint="Para crear grupos de VPN">
		<cfargument name="tunnelType" type="string" default="" hint="Para crear grupos de VPN">
		<cfargument name="tunnelPassword" type="string" default="" hint="Para crear grupos de VPN">
		<cfargument name="PQfileConfigura" type="string" default="N" hint="Archivo por utilizar: T(acacs)/R(adius)/A(mbos)/N(inguno)">
		<!--- 
			Crea un paquete o grupo en la Base de Datos del CiscoSecure, utilizando
			la linea de comando del Cisco "AddProfile".
		--->
		<cfif Not checkEnabled()><cfreturn 0></cfif>
		<cfif existePerfil('', Arguments.grupo)><cfreturn 0></cfif>
		<cfif Arguments.PQfileConfigura EQ 'N'><cfreturn 1></cfif> <!--- No se crea en Cisco Paquete solo para Correo --->
		
		<cfset cmd = This.PathCommandsCLI
				& "AddProfile -h " & This.HostDBCisco
				& " -p " & This.PortDBCisco
				& " -g " & Arguments.grupo
				& " -pr " & Arguments.parentGroup>
		<!---
		<cfif Len(clave)>
			<cfset cmd = cmd & " -pw CHAP," & shellEscape(clave) & " PAP," & shellEscape(clave) & " DES," & shellEscape(clave)>
		</cfif>
		--->
		<cfif Arguments.PQfileConfigura NEQ 'N'>
			<cfif Not ListFind('T,R,A,N', Arguments.PQfileConfigura)>
				<cfthrow message="Argumento no valido: PQfileConfigura" errorcode="ARG-0002">
			</cfif>
			<cfset cmd = cmd & ' -s ~/saci/saci_' & ListGetAt('tacacs,radius,ambos', ListFind('T,R,A', Arguments.PQfileConfigura)) & '.txt'>
		</cfif>
		<cfif Len(Arguments.maxSession)>
			<!--- si es grupo VPN se almacena el max session --->
			<cfset cmd = cmd & " -a " & shellEscape(
					"set server max-sessions=" & Arguments.maxSession & 
					"\nset server max-authority=" & This.autoriza)>
		</cfif>
		<cfif Len(Arguments.tunnelPassword)>
			<!--- si es grupo VPN se almacena el max session --->
			<cfset cmd = cmd & " -a " & shellEscape(
				"service=ppp { protocol=vpdn { set tunnel-id="
				& Arguments.tunnelID & "\n set ip-addresses="
				& Arguments.tunnelIP & "\n set tunnel-type="
				& Arguments.tunnelType & "\n set "
				& Arguments.tunnelType & "-tunnel-password="
				& Arguments.tunnelPassword & " } }")>
		</cfif>
		<cfreturn shellExecute(cmd,'cisco','AddProfile')>
		<!--- OK: retval = 0 --->
	</cffunction>

	<!--- deletePackage --->
	<cffunction name="deletePackage" output="false" returntype="numeric" hint="Cero si no hubo error, o el número de error si hubo">
		<!--- 
			Borra un paquete o grupo de la Base de Datos del CiscoSecure, utilizando
			la linea de comando del Cisco "DeleteProfile".
		 --->
		<cfargument name="grupo" type="string" required="yes" hint="Recibe el nombre del grupo">
		<cfif Not checkEnabled()><cfreturn 0></cfif>

		<cfset cmd = This.PathCommandsCLI & "DeleteProfile -h " & This.HostDBCisco
				& " -p " & This.PortDBCisco & " -g " & grupo>
		<cfreturn shellExecute(cmd,'cisco','DeleteProfile')>
		<!--- OK: retval = 0 --->
	</cffunction>
	
	<!--- createUser --->
	<cffunction name="createUser" output="false" returntype="numeric" hint="Cero si no hubo error, o el número de error si hubo">
		<cfargument name="usuario" type="string" required="yes" hint="Recibe el nombre del usuario por crear">
		<cfargument name="clave" type="string" required="yes" hint="Clave por asignar">
		<cfargument name="parentGroup" type="string" required="yes" hint="Grupo/Paquete padre">
		<cfargument name="listaTelefonos" type="string" default="" required="no" hint="Telefono para paquete de un solo telefono">
		<cfargument name="maxSession" type="string" default="" required="no" hint="número Maximo de Sesiones">
		<cfargument name="newTimeout" type="string" default="" required="no" hint="Para crear usuarios temporales.">
		<!---
			 * Crea un usuario dentro de un paquete o grupo en la Base de Datos del
			 * CiscoSecure, utilizando la linea de comando del Cisco "AddProfile".
			 * El parámetro newTimeout no se llama "timeout" porque es nombre reservado en <cfinvoke>
		
				Instrucción base para AddProfile
				/opt/ACS/CLI/AddProfile -h orion -p 9900 -u [login] -pr [paquete] -pw CHAP,[pass] -pw PAP,[pass] -pw DES,[pass] -prv WEB,[pass],0
				
				Para Prepagos (con timeout en minutos) se agrega
				  -a 'service=ppp { protocol=lcp {default attribute=permit \n set timeout=600 } \n protocol=ip { set addr-pool=default } }']
				
				Para HOGAR - restriccion por telefono se agrega
				  -a 'allow '""' '""' '"2800782"'  \n allow '""' '""' '"async"'  \n refuse '""' '""' '""''
				
				Para los VPN: incluir en login "usuario@dominio", el paquete es "Usuarios_dominio"
				  -a 'set server max-sessions = 1 \n set server max-authority=MSS.uranonuevo'
				
				Para bloquear un 900, indique:
					el login es el # de telefono (7 digitos), el grupo es NO_AUTORIZADOS_900
		--->
	
		<cfif Not checkEnabled()><cfreturn 0></cfif>

		<cfif Arguments.parentGroup is "__SOIN_DEFUALT_ENABLED_GROUPS__">
			<cfset Arguments.parentGroup = This.PackageParentGroup>
		</cfif>
		<cfset control_mensaje( 'CIS-0001', 'usuario:#Arguments.usuario#, ' &
			'paquete #Arguments.parentGroup#, ' &
			'telefono #Arguments.listaTelefonos#, ' &
			'maxSession #Arguments.maxSession#, ' &
			'timeout #Arguments.newTimeout#' )>
		<cfif existePerfil(Arguments.Usuario)>
			<cfset control_mensaje( 'CIS-0004', 'usuario:#Arguments.usuario# ya existe'  )>
			<cfreturn 0>
		</cfif>
		<cfset cmd = This.PathCommandsCLI
				& "AddProfile -h " & This.HostDBCisco
				& " -p " & This.PortDBCisco
				& " -u " & shellEscape(usuario)
				& " " & "-pr ">
		<cfset cmd = cmd & Arguments.parentGroup>
		<cfif Len(clave)>
			<cfset cmd = cmd & " -pw CHAP," & shellEscape(clave)
				& " -pw PAP," & shellEscape(clave) & " -pw DES," & shellEscape(clave)
				& " -prv WEB," & shellEscape(clave) & ",0 ">
		</cfif>

		<!--- Comprueba que envian Num Max Conexiones al login VPN --->
		<cfif Len(Arguments.maxSession) And Len(Arguments.maxSession) LT 4>
			<!--- si es usuario VPN se almacena las conexiones --->
			<cfset cmd = cmd & " -a " & shellEscape(
					"set server max-sessions=" & Arguments.maxSession & 
					"\nset server max-authority=" & This.autoriza)>
		</cfif>
		<cfif Len(Arguments.listaTelefonos) GE 7>
			<!--- Comprueba que envian Lista de Telefonos (Internet Hogar) --->
			<!--- Note que las comillas (") se duplican dentro de un string --->
			<!--- validar que mida 7 caracteres como mínimo para que sea válido --->
			<cfset cmd = cmd & " -a " & shellEscape(profileTelefono(Arguments.listaTelefonos, 'shell')) >
		</cfif>
		<cfif Len(Arguments.newTimeout)>
			<cfif Arguments.newTimeout LT 0>
				<cfset Arguments.newTimeout = 0>
			</cfif>
			<cfset cmd = cmd & " -a " & shellEscape(
					"service=ppp { "
					& "\nprotocol=lcp { "
					& "\ndefault attribute=permit"
					& "\nset timeout=" & Arguments.newTimeout & " "
					& "\n}  "
					& "\nprotocol=ip { "
					& "\nset addr-pool=default "
					& "\n}  "
					& "\n} ")>
		</cfif>
		<cfreturn shellExecute(cmd,'cisco','AddProfile')>
	</cffunction>
	
	<cffunction name="profileTelefono" output="false" returntype="string" hint="Arma el atributo de telefono">
		<cfargument name="telefono" type="string" required="yes">
		<cfargument name="modo" type="string">
		<cfif modo is 'sql'>
			<cfreturn "allow """" """" """ & Arguments.telefono & """"
					& "#Chr(10)#allow """" """" ""async""#Chr(10)#refuse """" """" """"#Chr(10)#">
		<cfelse>
			<cfreturn "allow """" """" """ & Arguments.telefono & """"
					& "\nallow """" """" ""async""\nrefuse """" """" """"">
		</cfif>
	</cffunction>

	<!--- deleteUser --->
	<cffunction name="deleteUser" output="false" returntype="numeric" hint="Cero si no hubo error, o el número de error si hubo">
		<cfargument name="usuario" type="string" required="yes" hint="Recibe el nombre del usuario por eliminar">
		<!---
			Borra un usuario de la Base de Datos del CiscoSecure, utilizando la linea
			de comando del Cisco "DeleteProfile".
		--->
		<cfif Not checkEnabled()><cfreturn 0></cfif>
		<cfset control_mensaje( 'CIS-0002', 'usuario:#Arguments.usuario#' )>
		<cfif not existePerfil(usuario)><cfreturn 0></cfif>
		<cfset cmd = This.PathCommandsCLI & "DeleteProfile -h " & This.HostDBCisco
				& " -p " & This.PortDBCisco & " -u " & shellEscape(usuario)>
		<cfreturn shellExecute(cmd,'cisco','DeleteProfile')>
	</cffunction>

	<!--- changeUserParent --->
	<cffunction name="changeUserParent" output="false" returntype="numeric" hint="Cero si no hubo error, o el número de error si hubo">
		<cfargument name="usuario" type="string" required="yes" hint="Recibe el nombre del usuario cuyo padre cambiar">
		<cfargument name="newParent" type="string" required="yes" hint="Recibe el nombre del nuevo grupo padre">
		<!---
			Permite cambiar el padre de los Usuarios de la Base de Datos del
			CiscoSecure, utilizando las linea de comando del Cisco : "ChangeParent".
			Es casi igual al changePackageParent, excepto por la opción -u
		--->
		<cfif Not checkEnabled()><cfreturn 0></cfif>

		<cfif newParent is "__SOIN_DEFUALT_ENABLED_GROUPS__">
			<cfset newParent = This.PackageParentGroup>
		<cfelseif newParent is "__SOIN_DEFUALT_DISABLED_GROUPS__">
			<cfset newParent = This.DisabledUsersGroup>
		</cfif>
		<cfset control_mensaje( 'CIS-0006', 'usuario:#Arguments.usuario#, paquete #Arguments.newParent#' )>
		<cfset cmd = This.PathCommandsCLI & "ChangeParent -h " & This.HostDBCisco
				& " -p " & This.PortDBCisco & " -u " & shellEscape(usuario) & " -dg " & newParent>
		<cfreturn shellExecute(cmd,'cisco','ChangeParent')>
	</cffunction>

	<!--- updatePassword --->
	<cffunction name="updatePassword" output="false" returntype="numeric" hint="Cero si no hubo error, o el número de error si hubo">
		<cfargument name="usuario" type="string" required="yes" hint="Recibe el nombre del usuario por eliminar">
		<cfargument name="newPassword" type="string" required="yes" hint="Recibe la clave nueva">
		<!--- updatePassword
		 * Permite cambiar el padre de los Usuarios de la Base de Datos del
		 * CiscoSecure, utilizando las linea de comando del Cisco : "UpdatePassword".
		--->
		<cfset pwtypes = 'CHAP,PAP,DES'>
		<cfset status = 0><!--- OK --->
		<cfset control_mensaje( 'CIS-0007', 'usuario:#Arguments.usuario#' )>
		<cfloop list="#pwtypes#" index="pwtype">
			<!--- Envía la instrucción por ejecutar.--->
			<cfset cmd = This.PathCommandsCLI & "UpdatePassword -h " & This.HostDBCisco
					& " -p " & This.PortDBCisco & " -u " & shellEscape(usuario) & " " & " -pr "
					& pwtype & " -npw "
					& shellEscape(newPassword)>
			<cfset status = shellExecute(cmd,'cisco','UpdatePassword')>
			<cfif status NEQ 0><!--- no se hace rollback, se reintentará más tarde --->
				<cfbreak>
			</cfif>
		</cfloop>
		<cfreturn status>
	</cffunction>
	
	<!---getProfileBlob--->
	<cffunction name="getProfileBlob" access="private" output="false" returntype="struct" hint="Regresa cs_profile_blob">
		<cfargument name="usuario" type="string" required="yes" hint="Usuario por modificar">
		<cfquery datasource="csdb" name="getProfileBlob_q">
			select
				cup.profile_id,
				cpb.blob_ordinal,
				cpb.blob_data,
				cpb.profile_id as blob_profile_id
			from cs_user_profile cup
				left join cs_profile_blob cpb
					on cup.profile_id = cpb.profile_id
			where cup.user_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.usuario#">
			order by blob_ordinal
		</cfquery>
		<cfset ret = StructNew()>
		<cfif (getProfileBlob_q.RecordCount GE 1) OR Len(getProfileBlob_q.blob_profile_id)>
			<cfset ret.RecordCount = getProfileBlob_q.RecordCount>
		<cfelse>
			<cfset ret.RecordCount = 0>
		</cfif>
		<cfset ret.profile_id = getProfileBlob_q.profile_id>
		<cfset ret.blob_data = ValueList(getProfileBlob_q.blob_data, '')>
		<cfreturn ret>
	</cffunction>

	<!---updateProfileBlob--->
	<cffunction name="updateProfileBlob" access="private" output="false" returntype="void" hint="Modifica cs_profile_blob manipulando el blob_ordinal">
		<cfargument name="profile_id" type="numeric" required="yes" hint="csdb profile_id por modificar">
		<cfargument name="blob_data" type="string" required="yes" hint="blob_data por almacenar">
		<cfargument name="original" type="struct" required="yes" hint="Estructura regresada por getProfileBlob">
		<cfif Arguments.original.blob_data eq Arguments.blob_data>
			<cfreturn>
		</cfif>
		<cfset control_mensaje( 'CIS-0008', 'profile_id:#Arguments.profile_id#' )>
		<cfset newRecordCount = Ceiling( Len(Arguments.blob_data) / 255)>
		<!---<cfset control_mensaje( 'DBG-0000', 'newRecordCount:#newRecordCount#, original.profile_id:#original.profile_id#' )>
		<cfset control_mensaje( 'DBG-0000', 'Arguments.original.blob_data:#Arguments.original.blob_data#')>
		<cfset control_mensaje( 'DBG-0000', 'blob_data:#blob_data#')>--->
		<cfif newRecordCount  LT Arguments.original.RecordCount >
			<cfquery datasource="csdb">
				delete cs_profile_blob
				where profile_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#original.profile_id#">
				  and blob_ordinal > <cfqueryparam cfsqltype="cf_sql_integer" value="#newRecordCount#">
			</cfquery>
		</cfif>
		<cfif newRecordCount>
			<cfloop from="1" to="#newRecordCount#" index="rownum">
				<cfif rownum LE Arguments.original.RecordCount and (Len(trim(Arguments.original.blob_data)))>
					<cfquery datasource="csdb">
						update cs_profile_blob
						set blob_data = <cfqueryparam cfsqltype="cf_sql_varchar" value="#new_blob#">
						where profile_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#original.profile_id#">
							and blob_ordinal = <cfqueryparam cfsqltype="cf_sql_integer" value="#rownum#">
					</cfquery>
				<cfelse>
					<cfquery datasource="csdb">
						insert into cs_profile_blob (profile_id, blob_ordinal, blob_data, profile_ts)
						values (
							<cfqueryparam cfsqltype="cf_sql_integer" value="#original.profile_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rownum#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#Mid(Arguments.blob_data, rownum*255-254, 255)#">,
							getdate())
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
	</cffunction>
	
	<!---updateTimeout--->
	<cffunction name="updateTimeout" output="false" returntype="numeric" hint="Actualiza el timeout del usuario">
		<!---
		Para la implementación de esta función, se asume que cada profile tiene un único cs_profile_blob asignado.
		Esto se cumple para todos los usuarios de acceso en servidor orion el 1-Sep-2006.
		Los únicos usuarios con más de un profile son internos del sistema, y no usuarios de acceso telefónico.
		La siguiente consulta lo comprueba:
			select * from cs_user_profile where profile_id in
				(select profile_id from cs_profile_blob group by profile_id having count(1) > 1)
		--->
		<cfargument name="usuario" type="string" required="yes" hint="Usuario por modificar">
		<cfargument name="newTimeout" type="string" required="yes" hint="Nuevo timeout">
		<cfif Not checkEnabled()><cfreturn 0></cfif>
		
		<cfif Len(Arguments.newTimeout) And (Arguments.newTimeout LT 0)>
			<cfset Arguments.newTimeout = 0>
		</cfif>
		<cfset control_mensaje( 'CIS-0009', 'usuario:#Arguments.usuario#,timeout:#Arguments.newTimeout#' )>
		<cfset original = getProfileBlob(Arguments.usuario)>
		<cfif original.RecordCount neq 1>
			<cfthrow message="No existe el perfil #Arguments.usuario# en Cisco. [rc=#original.RecordCount#]">
		</cfif>
		<cfset new_blob = original.blob_data>

		<cfset regex = REFind('protocol=lcp.*{.*timeout=([0-9]*).*}', new_blob, 1, true)>
		
		<cfif ArrayLen(regex.pos) neq 2>
			<cfthrow message="El perfil #original.profile_id# no tiene timeout en Cisco. [blob_data]=[#original.blob_data#]">
		</cfif>
		
		<cfset timeout_original = Mid(new_blob, regex.pos[2] , regex.len[2])>
		<cfif timeout_original neq newTimeout>
			<cfset new_blob = Left(new_blob, regex.pos[2] - 1) & Arguments.newTimeout & Right(new_blob, Len(new_blob) - regex.pos[2] - regex.len[2] + 1)>
			<cfset updateProfileBlob(original.profile_id, new_blob, original)>
			<!--- Debugging information --->
			<cfset This.cmd = 'SQL: update timeout'>
			<cfset This.stdout = 'update_cs_profile_blob#Chr(10)#set blob_data = "#new_blob#"#Chr(10)#where profile_id =#original.profile_id##Chr(10)# '>
		<cfelse>
			<!--- Debugging information --->
			<cfset This.cmd = 'SQL: update timeout'>
			<cfset This.stdout = 'update_cs_profile_blob NO SE REALIZA#Chr(10)#set blob_data = "#new_blob#"#Chr(10)#where profile_id =#original.profile_id##Chr(10)# '>
		</cfif>
		<cfset This.stderr = ''>
		<cfset This.exitValue = 0>
		
		<cfreturn 0>
	</cffunction>

	<!---renameUser--->
	<cffunction name="renameUser" output="false" returntype="numeric" hint="Actualiza el login del usuario">
		<!---
			Se conecta directo a la base de datos.
		--->
		<cfargument name="usuario" type="string" required="yes" hint="Nombre actual (anterior)">
		<cfargument name="nuevo" type="string" required="yes" hint="Nombre nuevo">
		<cfif Not checkEnabled()><cfreturn 0></cfif>
		<cfset control_mensaje( 'CIS-0010', 'usuario:#Arguments.usuario# por #Arguments.nuevo#' )>
		<!---verificar origen--->
		<cfquery datasource="csdb" name="original">
			select profile_id
			from cs_user_profile
			where user_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.usuario#">
		</cfquery>
		<cfif original.RecordCount is 0>
			<!--- falta guardar inconsistencia --->
			<cfthrow message="Usuario #Arguments.usuario# no existe en Cisco (cs_user_profile)" errorcode="CIS-0012">
		</cfif>

		<!---verificar destino--->
		<cfquery datasource="csdb" name="destino">
			select profile_id
			from cs_user_profile
			where user_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.nuevo#">
		</cfquery>
		<cfif destino.RecordCount>
			<cfthrow message="El usuario #Arguments.nuevo# ya existe en Cisco (cs_user_profile)" errorcode="CIS-0004">
		</cfif>
		<!---actualizar--->
		<cfquery datasource="csdb">
			update cs_user_profile
			set user_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.nuevo#">
			where user_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.usuario#">
		</cfquery>
		<!--- Debugging information --->
		<cfset This.cmd = 'SQL: rename user'>
		<cfset This.stdout = 'update cs_user_profile set user_name = "#Arguments.nuevo#" where user_name = "#Arguments.usuario#"'>
		<cfset This.stderr = ''>
		<cfset This.exitValue = 0>
		
		<cfreturn 0>
	</cffunction>

	<!--- UpdateProfile --->
	<cffunction name="UpdateProfile" output="false" returntype="numeric" hint="Cero si no hubo error, o el número de error si hubo">
		<cfargument name="telefono" type="string" required="yes" hint="El número de teléfono">
		<cfargument name="grupo" type="string" required="yes" hint="recibe el grupo de cisco">
		<!--- 
			Realiza un UpdateProfile para el bloqueo de un teléfono Prepagos.
		--->
		<cfset cmdrefuse = 'refuse "" "" "#Arguments.telefono#"'>
		<cfset cmd = This.PathCommandsCLI
				& "UpdateProfile -h " & This.HostDBCisco
				& " -p " & This.PortDBCisco
				& " -g " & Arguments.grupo
				& " -a " & shellEscape(cmdrefuse)>
						
		<cfreturn shellExecute(cmd,'cisco','UpdateProfile')>
		<!--- OK: retval = 0 --->
	</cffunction>
	
	<!---updateTelefono--->
	<cffunction name="updateTelefono" output="false" returntype="numeric" hint="Actualiza el teléfono del usuario">
		<!---
			Se conecta directo a la base de datos.
		--->
		<cfargument name="usuario" type="string" required="yes" hint="Usuario cuyo perfil modificar">
		<cfargument name="telefono" type="string" required="yes" hint="Nombre nuevo">
		<cfif Not checkEnabled()><cfreturn 0></cfif>
		<cfset control_mensaje( 'CIS-0005', 'usuario:#Arguments.usuario#, telefono:#Arguments.telefono#' )>
		<cfset Arguments.telefono = Trim(Arguments.telefono)>
		<cfif Len(Arguments.telefono) and Not REFind('^[0-9]+$', Arguments.telefono)>
			<cfthrow message="Número de teléfono inválido">
		</cfif>

		<cfset original = getProfileBlob(Arguments.usuario)>
		<!--- es posible que original.blob_data esté vacío,
			si el paquete anterior no tenía restricción por número de teléfono
			Lo que se vale es que el usuario no exista del todo--->
		<cfif original.RecordCount neq 1>
			<cfthrow message="No existe el perfil #Arguments.usuario# en Cisco. [rc=#original.RecordCount#]">
		</cfif>
		<cfset new_blob = original.blob_data>

		<cfset regex = REFind('allow "" "" "([0-9]*)"', new_blob, 1, true)>
		<cfset telefono_actual = ''>
		<cfif ArrayLen(regex.pos) is 2>
			<cfset telefono_actual = Mid(new_blob, regex.pos[2], regex.len[2])>
		</cfif>
		<cfset control_mensaje( 'DBG-0000', 'telefono_actual:#telefono_actual#, Arguments.telefono:#Arguments.telefono#' )>
		
		<cfif telefono_actual neq Arguments.telefono>
			<cfif Len(telefono_actual) and Len(Arguments.telefono) GE 7>
				<!--- modificar telefono existente --->
				<!--- validar que mida 7 caracteres como mínimo para que sea válido --->
				<cfset new_blob = Left(new_blob, regex.pos[2] - 1) & Arguments.telefono & Right(new_blob, Len(new_blob) - regex.pos[2] - regex.len[2] + 1)>
			<cfelseif Len(Arguments.telefono) GE 7>
				<!--- agregar telefono --->
				<!--- validar que mida 7 caracteres como mínimo para que sea válido --->
				<cfif Len(new_blob) And Right(new_blob,1) neq Chr(10)>
					<cfset new_blob = new_blob & Chr(10)>
				</cfif>
				<cfset new_blob = new_blob & profileTelefono(Arguments.telefono, 'sql')>
			<cfelseif Len(telefono_actual)>
				<!--- eliminar telefono, aquí la longitud del teléfono anterior no es relevante --->
				<cfset new_blob = REReplace(new_blob, 'allow "" "" "[0-9]*"[#chr(13)##chr(10)#]?', '')>
				<cfset new_blob = REReplace(new_blob, 'allow "" "" "async"[#chr(13)##chr(10)#]?', '')>
				<cfset new_blob = REReplace(new_blob, 'refuse "" "" ""[#chr(13)##chr(10)#]?', '')>
			</cfif>		
			
			<!---<cfset control_mensaje( 'DBG-0000', 'telefono_actual:#telefono_actual#, new_blob:#new_blob#' )>--->
			<cfset updateProfileBlob(original.profile_id, new_blob, original)>
			<cfset This.cmd = 'SQL: update telefono (modificar de #telefono_actual# a #Arguments.telefono#)'>
			<cfset This.stdout = 'update cs_profile_blob#Chr(10)#profile_id =#original.profile_id##Chr(10)#blob_data = "#new_blob#"#Chr(10)#'>
		<cfelse>
			<cfset This.cmd = 'SQL: update telefono (igual)'>
			<cfset This.stdout = 'update cs_profile_blob NO ES NECESARIO#Chr(10)#profile_id =#original.profile_id##Chr(10)#blob_data = "#new_blob#"#Chr(10)#'>
		</cfif>
		<!--- Debugging information --->
		<cfset This.stderr = ''>
		<cfset This.exitValue = 0>
		
		<cfreturn 0>
	</cffunction>

	<!--- getUserInfo--->
	<cffunction name="getUserInfo" output="false" returntype="string" hint="Regresa la salida de la instrucción">
		<cfargument name="usuario" type="string" required="yes" hint="Recibe el nombre del usuario por eliminar">
		<!---
		 Lee un usuario de la Base de Datos del CiscoSecure, utilizando la linea
		 de comando del Cisco "ViewProfile".
		 --->
		<cfif Not checkEnabled()><cfreturn 0></cfif>
		<cfset cmd = This.PathCommandsCLI & "ViewProfile -h " & This.HostDBCisco
				& " -p " & This.PortDBCisco & " -u " & shellEscape(usuario)>
		<cfset shellExecute(cmd,'cisco','ViewProfile')>
		<cfset blob_data = getProfileBlob(Arguments.usuario).blob_data>
		<cfif Len(blob_data)>	
			<cfset blob_data = "cs_profile_blob:" & Chr(10) & blob_data>
		<cfelse>
			<cfset blob_data = "no cs_profile_blob">
		</cfif>
		<cfset This.stdout = "ViewProfile:" & Chr(10) & This.stdout & Chr(10) & blob_data>
		<cfreturn This.stdout>
	</cffunction>
	<!--- existePerfil --->
	<cffunction name="existePerfil" output="false" returntype="boolean" hint="Indica si el perfil del grupo o usuario indicados existen">
		<cfargument name="usuario" type="string" default="" hint="Recibe el nombre del usuario por consultar">
		<cfargument name="grupo" type="string" default="" hint="Recibe el nombre del grupo por consultar">
		<cfif Len(Arguments.usuario)>
			<cfquery datasource="csdb" name="existe">
				select 1
				from cs_user_profile
				where user_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.usuario#">
			</cfquery>
		<cfelseif Len(Arguments.grupo)>
			<cfquery datasource="csdb" name="existe">
				select 1
				from cs_group_profile
				where group_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.grupo#">
			</cfquery>
		<cfelse>
			<cfthrow message="Especifique usuario o grupo">
		</cfif>
		<cfset control_mensaje( 'CIS-0003', 'existePerfil(#Arguments.usuario#,#Arguments.grupo#): #existe.RecordCount NEQ 0#' )>
		<cfreturn existe.RecordCount neq 0>
	</cffunction>
	<!---checkEnabled--->
	<cffunction name="checkEnabled" returntype="boolean">
		<cfif Not This.Enabled>
			<cfset control_mensaje( 'CIS-0005', 'La interfaz con iPlanet está inactiva' )>
		</cfif>
		<cfreturn This.Enabled>
	</cffunction>
</cfcomponent>