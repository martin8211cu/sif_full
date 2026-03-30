<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBlogin">


<cffunction name="UpdateQuota" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" 				type="string" 	required="Yes"  displayname="Id del Login">
   <cfargument name="LGmailQuota" 			type="string" 	required="Yes"  displayname="Quota para el login">
  <cfargument name="datasource" 			type="string" 	required="No" 	default="#session.DSN#">
  <!---Los siguientes parametros por ahora no se usan--->
  <cfargument name="registrar_en_bitacora" 	type="boolean" 	required="No" 	default="No">
  <cfargument name="BLautomatica" 			type="string" 	required="No" 	default="0" displayname="BLautomatica">
  <cfargument name="BLobs" 					type="string" 	required="No" 	default="">

	<cfquery datasource="#Arguments.datasource#">								<!---Actualiza la Quota del Login--->
		update ISBlogin
		set LGmailQuota = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGmailQuota#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
</cffunction>



<cffunction name="EnviarMensajeCliente" output="false" returntype="boolean" access="remote">
  <cfargument name="Contratoid" 			type="numeric" 	required="Yes"  displayname="Id del Contrato">
  <cfargument name="LGnumero" 				type="numeric" 	required="Yes"  displayname="Login id">
  <cfargument name="MSoperacion" 			type="string" 	required="Yes" 	default="I" 		displayname="Tipo de operacion">
  <cfargument name="MSfechaEnvio" 			type="string" 	required="no" 	default="#now()#" 	displayname="Fecha de envio del mensaje">
  <cfargument name="MSsaldo" 				type="numeric" 	required="no" 	default="0" 		displayname="Saldo_Mensajes_Cliente">
  <cfargument name="MSmotivo" 				type="string" 	required="no" 	default="I" 		displayname="Motivo_Mensajes_Cliente">
  <cfargument name="MStexto" 				type="string" 	required="no" 	default="" 			displayname="Texto_Mensajes_Cliente">
  <cfargument name="datasource" 			type="string" 	required="No" 	default="#session.DSN#">

	<!--- Verificar si existe mayorista en el paquete, si existe lo inserta en la tabla: ISBmensajeCliente --->			
	<cfquery datasource="#Arguments.datasource#" name="rsMayorista">
		select b.MRidMayorista  
		from ISBproducto a
			inner join ISBpaquete b
			on b.PQcodigo = a.PQcodigo
			and Habilitado=1
		where a.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#">
	</cfquery>
	
	<cfif isdefined('rsMayorista') and len(trim(rsMayorista.MRidMayorista))>
		<cfinvoke component="saci.comp.ISBmensajesCliente" method="Alta">	
			<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
			<cfinvokeargument name="MSoperacion" value="#Arguments.MSoperacion#">
			<cfinvokeargument name="MSfechaEnvio" value="#Arguments.MSfechaEnvio#">
			<cfinvokeargument name="MSsaldo" value="#Arguments.MSsaldo#">
			<cfinvokeargument name="MSmotivo" value="#Arguments.MSmotivo#">
			<cfif len(trim(Arguments.MStexto))><cfinvokeargument name="MStexto" value="#Arguments.MStexto#"></cfif>
		</cfinvoke>				
		<cfset ret=true>
	<cfelse>
		<cfset ret=false>
	</cfif>
	<cfreturn ret>
</cffunction>



<cffunction name="cambioContratoLogin" output="false" returntype="void" access="remote">
  <cfargument name="Contratoid"				type="numeric" 	required="Yes"  displayname="Contrato id">
  <cfargument name="LGnumero" 				type="string" 	required="Yes"  displayname="Id del Login">
  <cfargument name="LGlogin" 				type="string" 	required="No"   default=""	displayname="Login">
  <cfargument name="PQcodigo" 				type="string" 	required="No"  	default=""	displayname="Código del Paquete">
  <cfargument name="datasource" 			type="string" 	required="No" 	default="#session.DSN#">
  <cfargument name="registrar_en_bitacora" 	type="boolean" 	required="No" 	default="true">
  
  <cfargument name="BLautomatica" 			type="string" 	required="No" 	default="0" displayname="BLautomatica">
  <cfargument name="BLobs" 					type="string" 	required="No" 	default="Cambio del login #Arguments.LGlogin# al producto #Arguments.Contratoid#">
  
  	<cfif not len(trim(Arguments.LGnumero)) and  not len(trim(Arguments.LGlogin))><!---Es obligatorio resibir LGnumero ó LGlogin en los argumentos--->
		<cfthrow message="Error: El componente debe resibir en sus agumentos 'LGnumero'  ó 'LGlogin', no permite que los dos argumentos esten nulos.">
	</cfif>
  	
	<cfif not len(Arguments.PQcodigo)>										<!---Obtiene el codigo del paquete en caso de que no venga definido en los argumentos--->
		<cfquery datasource="#Arguments.datasource#" name="rsPaquete">
			select PQcodigo from ISBproducto
			where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#">
		</cfquery>
		<cfif rsPaquete.recordCount GT 0><cfset Arguments.PQcodigo = rsPaquete.PQcodigo>
		<cfelse><cfthrow message="Error: No existe un paquete definido para el Contratoid #Arguments.Contratoid#"></cfif>
	</cfif>

	<cfif not len(trim(Arguments.LGlogin))>
		<cfquery  name="rsLogin" datasource="#Arguments.datasource#">		<!---Obtinene el LGlogin del login actual en caso de que no venga definido--->				
			select LGlogin from ISBlogin where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
		</cfquery>
		<cfif rsLogin.recordCount EQ 0 >
			<cfthrow message="Error: el login no corresponde a ningun login en la base de datos">
		<cfelse>
			<cfset Arguments.LGlogin = rsLogin.LGlogin>
		</cfif>
	</cfif>
	
	<cfquery  name="rsServs" datasource="#Arguments.datasource#">			<!---Obtiene los servicios del login--->
		select TScodigo from ISBserviciosLogin where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
	
	<cfloop query="rsServs">
		<!---Actualiza con el nuevo paquete los servicios del login--->
		<cfinvoke component="saci.comp.ISBserviciosLogin" method="UpdatePaqueteServicio">	
			<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
			<cfinvokeargument name="TScodigo" value="#rsServs.TScodigo#">
			<cfinvokeargument name="PQcodigo" value="#Arguments.PQcodigo#">
			<cfinvokeargument name="datasource" value="#Arguments.datasource#">
		</cfinvoke>
	</cfloop>
	
	<cfquery datasource="#Arguments.datasource#">								<!---Cambio de Contratoid en el login--->
		update ISBlogin
		set Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
	
	<cfif isdefined('Arguments.LGnumero') and len(trim(Arguments.LGnumero))>
		<cfif Arguments.registrar_en_bitacora>
			<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta">		<!---registro en la bitacora del cambio realizado --->
				<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
				<cfinvokeargument name="LGlogin" value="#Arguments.LGlogin#">
				<cfinvokeargument name="BLautomatica" value="#Arguments.BLautomatica#">				
				<cfinvokeargument name="BLobs" value="#Arguments.BLobs#">
				<cfinvokeargument name="BLfecha" value="#now()#">
			</cfinvoke>
		</cfif>
	<cfelse>
		<cfthrow message="Error: El login no existe.">
	</cfif>
</cffunction>




<cffunction name="RetirarLogin" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" 				type="numeric" 	required="Yes"  displayname="Login id">
  <cfargument name="datasource" 			type="string" 	required="No" 	default="#session.DSN#">
  <cfargument name="registrar_en_bitacora" 	type="boolean" 	required="No" 	default="true">
  <cfargument name="fecha" 					type="date" 	required="No"   default="#now()#" 	displayname="Fecha en que se realizo el retiro">
  <cfargument name="MRid" 					type="string" 	required="No"  	default="" 			displayname="Id Motivo de Retiro"> <!---es requerido si borradoLogico es false--->
  <cfargument name="BLautomatica" 			type="string" 	required="no" 	default="0"	 		displayname="BLautomatica">
  <cfargument name="BLobs" 					type="string" 	required="no" 	default="Retiro del login #Arguments.LGnumero#">
  
  <cfargument name="AGid" 					type="string" 	required="no" 	default="" 			displayname="Agente">
  <cfargument name="MSoperacion" 			type="string" 	required="no" 	default="B" 		displayname="Tipo de operacion">
  <cfargument name="MSfechaEnvio" 			type="string" 	required="no" 	default="#now()#" 	displayname="Fecha de envio del mensaje">
  <cfargument name="MSsaldo" 				type="numeric" 	required="no" 	default="0" 		displayname="Saldo_Mensajes_Cliente">
  <cfargument name="MSmotivo" 				type="string" 	required="no" 	default="I" 		displayname="Motivo_Mensajes_Cliente">
  <cfargument name="MStexto" 				type="string" 	required="no" 	default="" 			displayname="Texto_Mensajes_Cliente">
  <cfargument name="borradoLogico" 			type="boolean" 	required="no" 	default="false" 	displayname="">
  <cfargument name="LGevento" 				type="string" 	required="no" 	default="SACI" 		displayname="origen del último evento">
  
 	<cfif not borradoLogico and not len(trim(Arguments.MRid))>
		<cfthrow message="Error el Motivo de Retiro es requerido.">
	</cfif>
  
 	<cfquery  name="rsLogin" datasource="#Arguments.datasource#">				<!---Obtinene el login actual--->
		select distinct LGlogin,Contratoid from ISBlogin where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
	
	<cfquery datasource="#Arguments.datasource#">							
		update ISBlogin
		set Habilitado = 2
		, LGfechaRetiro = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha#">
		, LGevento = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LGevento#">
		<cfif borradoLogico><!---Borrado Logico de Login--->
			<cfset Arguments.BLobs = "Borrado logico del login #Arguments.LGnumero#">
		<cfelse><!---Retiro temporal y Borrado Logico de Login--->
			, MRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MRid#">
		</cfif>
		, BMUsucodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
	
	<cfif isdefined('rsLogin') and len(trim(rsLogin.LGlogin))>
		<cfif Arguments.registrar_en_bitacora>
			<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta">		<!---registro en la bitacora del cambio realizado --->
				<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
				<cfinvokeargument name="LGlogin" value="#rsLogin.LGlogin#">
				<cfinvokeargument name="BLautomatica" value="#Arguments.BLautomatica#">				
				<cfinvokeargument name="BLobs" value="#Arguments.BLobs#">
				<cfinvokeargument name="BLfecha" value="#now()#">
			</cfinvoke>
		</cfif>
	<cfelse>
		<cfthrow message="Error: El login no existe.">
	</cfif>
	
	<cfif isdefined("Arguments.LGnumero") and len(trim(Arguments.LGnumero))>
		<!---Registra un mensaje al cliente si el producto es de tipo cablera --->
		<cfinvoke component="saci.comp.ISBlogin" method="EnviarMensajeCliente">
			<cfinvokeargument name="Contratoid"	value="#rsLogin.Contratoid#">
			<cfinvokeargument name="LGnumero"	value="#Arguments.LGnumero#">
			<cfinvokeargument name="BLautomatica"value="#Arguments.BLautomatica#">
			<cfif len(Arguments.AGid)><cfinvokeargument name="AGid"	value="#Arguments.AGid#"></cfif>
			<cfinvokeargument name="MSoperacion"	value="#Arguments.MSoperacion#">
			<cfinvokeargument name="MSfechaEnvio"	value="#Arguments.MSfechaEnvio#">
			<cfinvokeargument name="MSsaldo"		value="#Arguments.MSsaldo#">
			<cfinvokeargument name="MSmotivo"		value="#Arguments.MSmotivo#">
			<cfif len(Arguments.MStexto)><cfinvokeargument name="MStexto"	value="#Arguments.MStexto#">
			<!---<cfelse><cfinvokeargument name="MStexto"value="Retiro de Login.">---></cfif>
			<cfinvokeargument name="datasource"value="#Arguments.datasource#">
		</cfinvoke>
	</cfif>
	
</cffunction>




<cffunction name="ReprogramarLogin" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" 				type="numeric"	required="Yes"  displayname="Login id">
  <cfargument name="LGlogin" 				type="string"	required="Yes"  displayname="Login">
  <cfargument name="Snumero" 				type="numeric"	required="Yes"  displayname="Sobre">
  <cfargument name="CNsuscriptor" 			type="string" 	required="No" 	default="" 			displayname="Suscriptor">
  <cfargument name="CNnumero" 				type="string" 	required="No"  	default="" 			displayname="Contrato">
  <cfargument name="datasource" 			type="string" 	required="No" 	default="#session.DSN#">
  <cfargument name="registrar_en_bitacora" 	type="boolean" 	required="No" 	default="true">
  <cfargument name="BLautomatica" 			type="string" 	required="no" 	default="0" 		displayname="BLautomatica">
  <cfargument name="BLobs" 					type="string" 	required="no" 	default="Reprogramacion del login #Arguments.LGnumero#">
  
  <cfargument name="AGid" 					type="string" 	required="no" 	default=""			displayname="Agente">
  <cfargument name="MSoperacion" 			type="string" 	required="no" 	default="P" 		displayname="Tipo de operacion">
  <cfargument name="MSfechaEnvio" 			type="string" 	required="no" 	default="#now()#" 	displayname="Fecha de envio del mensaje">
  <cfargument name="MSsaldo" 				type="numeric" 	required="no" 	default="0" 		displayname="Saldo_Mensajes_Cliente">
  <cfargument name="MSmotivo" 				type="string" 	required="no" 	default="I" 		displayname="Motivo_Mensajes_Cliente">
  <cfargument name="MStexto" 				type="string" 	required="no" 	default="" 			displayname="Texto_Mensajes_Cliente">
  <cfargument name="LGevento" 				type="string" 	required="no" 	default="SACI" 		displayname="origen del último evento">
   	
	<cfquery  name="rsLogin" datasource="#Arguments.datasource#">				<!---Obtinene el login actual--->
		select LGlogin,Contratoid from ISBlogin where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
	
	<!--- Verificar existencia de Login --->
	<cfinvoke component="saci.comp.ISBlogin" method="Existe" returnvariable="ExisteLogin">
		<cfinvokeargument name="LGlogin" value="#Arguments.LGlogin#">
		<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
	</cfinvoke>
	
	<cfif not ExisteLogin>
		<!--- Modificar Login --->
		<cfif trim(rsLogin.LGlogin) NEQ trim(Arguments.LGlogin)>
			<cfinvoke component="saci.comp.ISBlogin" method="CambioLogin">
				<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
				<cfinvokeargument name="LGlogin" value="#Arguments.LGlogin#">
			</cfinvoke>
		</cfif>	
	</cfif>
	
	<!--- Asignar el nuevo sobre si viene asignado --->
	<cfif isdefined("Arguments.Snumero") and Len(Trim(Arguments.Snumero)) And Arguments.Snumero NEQ 0>
		<cfinvoke component="saci.comp.ISBsobres" method="Asigna_Login">
			<cfinvokeargument name="Snumero" value="#Arguments.Snumero#">
			<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
		</cfinvoke>
		
		<!--- Se realiza el update del sobre y la Habilitación del login en el mismo momento para que se genere un único
				evento de la interfaz H005_RegrogramacionLogin, y no se dispare el cambio de password por sobre
		
		<cfinvoke component="saci.comp.ISBlogin" method="Asignar_Sobre">
			<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
			<cfinvokeargument name="Snumero" value="#Arguments.Snumero#">
		</cfinvoke>
		--->
		
		<!--- Activar el sobre --->
		<cfinvoke component="saci.comp.ISBsobres" method="Activacion" returnvariable="LvarError">
			<cfinvokeargument name="Snumero" value="#Arguments.Snumero#">
		</cfinvoke>
	</cfif>	
	
	<!--- Asignar el subscriptor si viene asignado --->
	<cfif isdefined("Arguments.CNsuscriptor") and Len(Trim(Arguments.CNsuscriptor))>
		<cfinvoke component="saci.comp.ISBproducto" method="CambioSuscriptor">
			<cfinvokeargument name="Contratoid" value="#rsLogin.Contratoid#">
			<cfinvokeargument name="CNsuscriptor" value="#Arguments.CNsuscriptor#">
			<cfif isdefined("Arguments.CNnumero") and Len(Trim(Arguments.CNnumero))><cfinvokeargument name="CNnumero" value="#Arguments.CNnumero#"></cfif>
		</cfinvoke>
	</cfif>
	
	<!---Desbloquear el login en caso de que el bloqueo no sea por spam--->
	<cfquery name="rsBloqueos" datasource="#Arguments.datasource#">
		select BLQid,MBmotivo from ISBbloqueoLogin 
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
		and MBmotivo != '04'
	</cfquery>
	<cfloop query="rsBloqueos">	
		<cfset BLQid=rsBloqueos.BLQid>
		<cfset motivo=rsBloqueos.MBmotivo>
		<cfinvoke component="saci.comp.ISBbloqueoLogin"method="Desbloquear">
			<cfinvokeargument name="BLQid" value="#BLQid#">
			<cfinvokeargument name="BLQhasta" value="#now()#">
			<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
			<cfinvokeargument name="MBmotivo" value="#motivo#">
		</cfinvoke>
	</cfloop>
	
	
	<!---Reactivacion de Login--->
	<cfquery datasource="#Arguments.datasource#">								
		update ISBlogin
		set Habilitado = 1
	<cfif isdefined("Arguments.Snumero") and Len(Trim(Arguments.Snumero)) And Arguments.Snumero NEQ 0>
		, Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Snumero#">
	</cfif>	
		, LGfechaRetiro = null
		, MRid = null
		, LGevento = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LGevento#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>

	<!---registro en la bitacora del cambio realizado --->
	<cfif isdefined('rsLogin') and len(trim(rsLogin.LGlogin))>
		<cfif Arguments.registrar_en_bitacora>
			<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta">		
				<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
				<cfinvokeargument name="LGlogin" value="#rsLogin.LGlogin#">
				<cfinvokeargument name="BLautomatica" value="#Arguments.BLautomatica#">				
				<cfinvokeargument name="BLobs" value="#Arguments.BLobs#">
				<cfinvokeargument name="BLfecha" value="#now()#">
			</cfinvoke>
		</cfif>
	<cfelse>
		<cfthrow message="Error: El login no existe.">
	</cfif>
	
	<!---Registra un mensaje al cliente si el producto es de tipo cablera --->
	<cfif isdefined("Arguments.LGnumero") and len(trim(Arguments.LGnumero))>
		<cfinvoke component="saci.comp.ISBlogin" method="EnviarMensajeCliente">
			<cfinvokeargument name="Contratoid"	value="#rsLogin.Contratoid#">
			<cfinvokeargument name="LGnumero"	value="#Arguments.LGnumero#">
			<cfinvokeargument name="BLautomatica"value="#Arguments.BLautomatica#">
			<cfif len(Arguments.AGid)><cfinvokeargument name="AGid"	value="#Arguments.AGid#"></cfif>
			<cfinvokeargument name="MSoperacion"	value="#Arguments.MSoperacion#">
			<cfinvokeargument name="MSfechaEnvio"	value="#Arguments.MSfechaEnvio#">
			<cfinvokeargument name="MSsaldo"		value="#Arguments.MSsaldo#">
			<cfinvokeargument name="MSmotivo"		value="#Arguments.MSmotivo#">
			<cfif len(Arguments.MStexto)><cfinvokeargument name="MStexto"	value="#Arguments.MStexto#">
			<!---<cfelse><cfinvokeargument name="MStexto"value="Reprogramación de Login.">---></cfif>
			<cfinvokeargument name="datasource"value="#Arguments.datasource#">
		</cfinvoke>
	</cfif>
</cffunction>



<cffunction name="Bloqueo" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero"				type="numeric"	required="Yes"  displayname="Login id">
  <cfargument name="MBmotivo" 				type="string" 	required="Yes"  displayname="Motivo de bloqueo">
  <cfargument name="datasource" 			type="string" 	required="No" 	default="#session.DSN#">
  <cfargument name="registrar_en_bitacora" 	type="boolean" 	required="No" 	default="true">
  
  <cfargument name="BLautomatica" 			type="string" 	required="no" 	default="0" displayname="BLautomatica">
  <cfargument name="BLobs" 					type="string" 	required="no" 	default="Bloqueo del login #Arguments.LGnumero# por el motivo #Arguments.MBmotivo#" displayname="Observaciones">
  
  <cfargument name="AGid" 					type="string" 	required="no" 	default=""  		displayname="Agente">
  <cfargument name="MSoperacion" 			type="string" 	required="no" 	default="L" 		displayname="Tipo de operacion">
  <cfargument name="MSfechaEnvio" 			type="string" 	required="no" 	default="#now()#" 	displayname="Fecha de envio del mensaje">
  <cfargument name="MSsaldo" 				type="numeric" 	required="no" 	default="0" 		displayname="Saldo_Mensajes_Cliente">
  <cfargument name="MSmotivo" 				type="string" 	required="no" 	default="I" 		displayname="Motivo_Mensajes_Cliente">
  <cfargument name="MStexto" 				type="string" 	required="no" 	default=""  		displayname="Texto_Mensajes_Cliente">
  
	<cfquery  name="rsLogin" datasource="#Arguments.datasource#">			<!---Obtinene el login actual--->
		select LGlogin, Contratoid, LGbloqueado
		from ISBlogin where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
	<cfif rsLogin.LGbloqueado neq 1>
		<cfquery datasource="#Arguments.datasource#">							<!---Bloqueo de Login--->
			update ISBlogin
			set LGbloqueado = 1
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
		</cfquery>
	</cfif>

	<cfif isdefined('rsLogin') and rsLogin.LGlogin NEQ ''>
		<cfif Arguments.registrar_en_bitacora>
			<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta"  > <!---registro en la bitacora del cambio realizado --->
				<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
				<cfinvokeargument name="LGlogin" value="#rsLogin.LGlogin#">
				<cfinvokeargument name="BLautomatica" value="#Arguments.BLautomatica#">				
				<cfinvokeargument name="BLobs" value="#Arguments.BLobs#">
				<cfinvokeargument name="BLfecha" value="#now()#">
			</cfinvoke>
		</cfif>
	</cfif>
	
	<!---Registra un mensaje al cliente si el producto es de tipo cablera --->
	<cfif isdefined("Arguments.LGnumero") and len(trim(Arguments.LGnumero))>
		<cfinvoke component="saci.comp.ISBlogin" method="EnviarMensajeCliente">
			<cfinvokeargument name="Contratoid"	value="#rsLogin.Contratoid#">
			<cfinvokeargument name="LGnumero"	value="#Arguments.LGnumero#">
			<cfinvokeargument name="BLautomatica"value="#Arguments.BLautomatica#">
			<cfif len(Arguments.AGid)><cfinvokeargument name="AGid"	value="#Arguments.AGid#"></cfif>
			<cfinvokeargument name="MSoperacion"	value="#Arguments.MSoperacion#">
			<cfinvokeargument name="MSfechaEnvio"	value="#Arguments.MSfechaEnvio#">
			<cfinvokeargument name="MSsaldo"		value="#Arguments.MSsaldo#">
			<cfinvokeargument name="MSmotivo"		value="#Arguments.MBmotivo#">
			<cfif len(Arguments.MStexto)><cfinvokeargument name="MStexto"	value="#Arguments.MStexto#">
			<!---<cfelse><cfinvokeargument name="MStexto"value="Bloqueo de Login.">---></cfif>
			<cfinvokeargument name="datasource"value="#Arguments.datasource#">
		</cfinvoke>
	</cfif>
</cffunction>




<cffunction name="Desbloqueo" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" 				type="numeric" 	required="Yes"  displayname="Login id">
  <cfargument name="datasource" 			type="string" 	required="No" 	default="#session.DSN#">
  <cfargument name="registrar_en_bitacora" 	type="boolean" 	required="No" 	default="true">
  <cfargument name="BLautomatica" 			type="string" 	required="no" 	default="0" displayname="BLautomatica">
  <cfargument name="BLobs" 					type="string" 	required="no" 	default="Desbloqueo de login del #Arguments.LGnumero#">
  
  <cfargument name="AGid" 					type="string" 	required="no" 	default=""  		displayname="Agente">
  <cfargument name="MSoperacion" 			type="string" 	required="no" 	default="D" 		displayname="Tipo de operacion">
  <cfargument name="MSfechaEnvio" 			type="string" 	required="no" 	default="#now()#" 	displayname="Fecha de envio del mensaje">
  <cfargument name="MSsaldo" 				type="numeric" 	required="no" 	default="0" 		displayname="Saldo_Mensajes_Cliente">
  <cfargument name="MSmotivo" 				type="string" 	required="no" 	default="I" 		displayname="Motivo_Mensajes_Cliente">
  <cfargument name="MStexto" 				type="string" 	required="no" 	default="Desbloqueo de Login" displayname="Texto_Mensajes_Cliente">
  
	<cfquery  name="rsLogin" datasource="#Arguments.datasource#">		<!---Obtinene el login actual--->
		select LGlogin,Contratoid,LGbloqueado 
		from ISBlogin 
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
	<cfif isdefined('rsLogin') and rsLogin.LGbloqueado neq 0>
		<cfquery datasource="#Arguments.datasource#">
			update ISBlogin
			set LGbloqueado = 0
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
		</cfquery>
	</cfif>
	<cfif Arguments.registrar_en_bitacora>
		<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta"  >	<!---registro en la bitacora del cambio realizado --->
			<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
			<cfinvokeargument name="LGlogin" value="#rsLogin.LGlogin#">
			<cfinvokeargument name="BLautomatica" value="#Arguments.BLautomatica#">				
			<cfinvokeargument name="BLobs" value="#Arguments.BLobs#">
			<cfinvokeargument name="BLfecha" value="#now()#">
		</cfinvoke>
	</cfif>
	
	<!---Registra un mensaje al cliente si el producto es de tipo cablera --->
	<cfif isdefined("Arguments.LGnumero") and len(trim(Arguments.LGnumero))>
		<cfinvoke component="saci.comp.ISBlogin" method="EnviarMensajeCliente">
			<cfinvokeargument name="Contratoid"	value="#rsLogin.Contratoid#">
			<cfinvokeargument name="LGnumero"	value="#Arguments.LGnumero#">
			<cfinvokeargument name="BLautomatica"value="#Arguments.BLautomatica#">
			<cfif len(Arguments.AGid)><cfinvokeargument name="AGid"	value="#Arguments.AGid#"></cfif>
			<cfinvokeargument name="MSoperacion"	value="#Arguments.MSoperacion#">
			<cfinvokeargument name="MSfechaEnvio"	value="#Arguments.MSfechaEnvio#">
			<cfinvokeargument name="MSsaldo"		value="#Arguments.MSsaldo#">
			<cfinvokeargument name="MSmotivo"		value="#Arguments.MSmotivo#">
			<cfif len(Arguments.MStexto)><cfinvokeargument name="MStexto"	value="#Arguments.MStexto#">
			<!---<cfelse><cfinvokeargument name="MStexto"value="Des-bloqueo de Login.">---></cfif>
			<cfinvokeargument name="datasource"value="#Arguments.datasource#">
		</cfinvoke>
	</cfif>
</cffunction>


<cffunction name="Inactivacion" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" 				type="numeric" required="Yes"  	displayname="Login id">
  <cfargument name="datasource" 			type="string" required="No" 	default="#session.DSN#">
  <cfargument name="registrar_en_bitacora" 	type="boolean" required="No" 	default="true">
  <cfargument name="BLautomatica" 			type="string" 	required="no" 	default="0" displayname="BLautomatica">
  <cfargument name="BLobs" 					type="string" 	required="no" 	default="Inactivacion del login #Arguments.LGnumero#">
  		
	<cfquery  name="rsLogin" datasource="#Arguments.datasource#">		<!---Obtinene el login actual--->
		select LGlogin from ISBlogin where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
	
	<cfquery datasource="#Arguments.datasource#">
		update ISBlogin
		set Habilitado = 0
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
	
	<cfif Arguments.registrar_en_bitacora>
		<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta"  >	<!---registro en la bitacora del cambio realizado --->
			<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
			<cfinvokeargument name="LGlogin" value="#rsLogin.LGlogin#">
			<cfinvokeargument name="BLautomatica" value="#Arguments.BLautomatica#">				
			<cfinvokeargument name="BLobs" value="#Arguments.BLobs#">
			<cfinvokeargument name="BLfecha" value="#now()#">
		</cfinvoke>
	</cfif>
</cffunction>




<cffunction name="Activacion" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" 				type="numeric" 	required="Yes"  displayname="Login id">
  <cfargument name="datasource" 			type="string" 	required="No" 	default="#session.DSN#">
  <cfargument name="registrar_en_bitacora" 	type="boolean" 	required="No" 	default="true">
  <cfargument name="BLautomatica" 			type="string" 	required="no" 	default="0" displayname="BLautomatica">
  <cfargument name="BLobs" 					type="string" 	required="no" 	default="Activacion del login #Arguments.LGnumero#">
  	
	<cfquery  name="rsLogin" datasource="#Arguments.datasource#">		<!---Obtinene el login actual--->
		select LGlogin from ISBlogin where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
	
	<cfquery datasource="#Arguments.datasource#">
		update ISBlogin
		set Habilitado = 1
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
	
	<cfif Arguments.registrar_en_bitacora>
		<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta"  >	<!---registro en la bitacora del cambio realizado --->
			<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
			<cfinvokeargument name="LGlogin" value="#rsLogin.LGlogin#">
			<cfinvokeargument name="BLautomatica" value="#Arguments.BLautomatica#">				
			<cfinvokeargument name="BLobs" value="#Arguments.BLobs#">
			<cfinvokeargument name="BLfecha" value="#now()#">
		</cfinvoke>
	</cfif>
</cffunction>




<cffunction name="Existe" output="false" returntype="boolean" access="remote">
  <cfargument name="LGlogin" 	type="string" 	required="Yes"  displayname="Login">
  <cfargument name="LGnumero" 	type="numeric" 	required="No"  	displayname="Login id">
  <cfargument name="datasource" type="string" 	required="No" 	default="#session.DSN#">
 
 	<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="plazoLogines">
		<cfinvokeargument name="Pcodigo" value="40">
	</cfinvoke>
		
  <cfset ret = false>
  <cfquery name="chkExistencia" datasource="#Arguments.datasource#">
  	select count(1) as cantidad
	from ISBlogin
	where LGlogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.LGlogin#">
	and Habilitado != 4
	<cfif isdefined("Arguments.LGnumero") and Len(Trim(Arguments.LGnumero))>
		and LGnumero <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
<!---	<cfelse>
		and ( 	(LGfechaRetiro is null) or 
				(datediff(day,LGfechaRetiro,<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#plazoLogines#">)
			)--->
	</cfif>
  </cfquery>
 
  <cfif chkExistencia.cantidad GT 0>	
  	<cfset ret = true>	
  </cfif>
  <cfreturn ret>
</cffunction>




<cffunction name="Asignar_Sobre" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" 				type="numeric"	required="Yes"  displayname="Login id">
  <cfargument name="Snumero" 				type="numeric" 	required="Yes"  displayname="Número visible del sobre">
  <cfargument name="datasource" 			type="string" 	required="No" 	default="#session.DSN#">
  <cfargument name="registrar_en_bitacora" 	type="boolean" 	required="No" 	default="true">
  <cfargument name="BLautomatica" 			type="string" 	required="no" 	default="0" displayname="BLautomatica">
  <cfargument name="BLobs" 					type="string" 	required="no" 	default="Asignacion del sobre #Arguments.Snumero# al login #Arguments.LGnumero#">
  	
	<cfquery name="rsSobre" datasource="#session.dsn#">
		select 1 as cantSobres
		from ISBsobres
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Snumero#">
	</cfquery>
		
	<cfif isdefined('rsSobre') and rsSobre.cantSobres GT 0>
		<cfquery  name="rsLogin" datasource="#Arguments.datasource#">		<!---Obtinene el login actual--->
			select LGlogin from ISBlogin where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
		</cfquery>
		
		<cfquery datasource="#Arguments.datasource#">
			update ISBlogin
			set Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Snumero#">
			where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
		</cfquery>
		
		<cfif Arguments.registrar_en_bitacora>
			<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta"  >	<!---registro en la bitacora del cambio realizado --->
				<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
				<cfinvokeargument name="LGlogin" value="#rsLogin.LGlogin#">
				<cfinvokeargument name="BLautomatica" value="#Arguments.BLautomatica#">				
				<cfinvokeargument name="BLobs" value="#Arguments.BLobs#">
				<cfinvokeargument name="BLfecha" value="#now()#">
			</cfinvoke>
		</cfif>	
	<cfelse>
		<cfthrow message="Error, el sobre n&uacute;mero #Arguments.Snumero# no existe. La asignaci&oacute;n del sobre fall&oacute;">
	</cfif>
</cffunction>



<cffunction name="Cambio_Servicios" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" 				type="numeric"	required="Yes"  displayname="Login id">
  <cfargument name="Servicios" 				type="string" 	required="No" 	default="" displayname="Define el conjunto de servicios asociados al Login">
  <cfargument name="datasource" 			type="string" 	required="No" 	default="#session.DSN#">
  <cfargument name="registrar_en_bitacora" 	type="boolean" 	required="No" 	default="true">
  <cfargument name="BLautomatica" 			type="string" 	required="no" 	default="0" displayname="BLautomatica">
  <cfargument name="BLobs" 					type="string" 	required="no" 	default="Cambio de servicios del login #Arguments.LGnumero#">
  
	<cfquery  name="rsLogin" datasource="#Arguments.datasource#">		<!---Obtinene el login actual--->
		select LGlogin from ISBlogin where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
	
	<!--- Cambiar configuración de servicios si vienen definidos --->
	<cfif Len(Trim(Arguments.Servicios))>
		<cfquery datasource="#Arguments.datasource#">
			update ISBserviciosLogin
			set Habilitado = case when exists (
				select 1
				from ISBlogin a
					inner join ISBproducto b
						on b.Contratoid = a.Contratoid
					inner join ISBservicio c
						on c.PQcodigo = b.PQcodigo
						and c.TScodigo in (<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Servicios#" list="yes" separator=",">)
						and c.Habilitado = 1
						and c.PQcodigo = ISBserviciosLogin.PQcodigo
						and c.TScodigo = ISBserviciosLogin.TScodigo
				where a.LGnumero = ISBserviciosLogin.LGnumero
			)  then 1 else 0 end
			where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">
		</cfquery>

		<cfquery datasource="#Arguments.datasource#">
			insert into ISBserviciosLogin (LGnumero, TScodigo, PQcodigo, SLpassword, Habilitado, BMUsucodigo)
			select a.LGnumero, c.TScodigo, c.PQcodigo, '*', 1, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			from ISBlogin a
				inner join ISBproducto b
					on b.Contratoid = a.Contratoid
				inner join ISBservicio c
					on c.PQcodigo = b.PQcodigo
					and c.TScodigo in (<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Servicios#" list="yes" separator=",">)
					and c.Habilitado = 1
			where a.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">
			and not exists (
				select 1
				from ISBserviciosLogin x
				where x.LGnumero = a.LGnumero
				and x.PQcodigo = c.PQcodigo
				and x.TScodigo = c.TScodigo
			)
		</cfquery>

	<!--- Inabilita todos los servicios asociados al Login --->
	<cfelse>
		<cfquery datasource="#Arguments.datasource#">
			update ISBserviciosLogin
			set Habilitado = 0
			where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">
		</cfquery>
	</cfif>
	
	<cfif Arguments.registrar_en_bitacora>
		<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta"  >	<!---registro en la bitacora del cambio realizado --->
			<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
			<cfinvokeargument name="LGlogin" value="#rsLogin.LGlogin#">
			<cfinvokeargument name="BLautomatica" value="#Arguments.BLautomatica#">				
			<cfinvokeargument name="BLobs" value="#Arguments.BLobs#">
			<cfinvokeargument name="BLfecha" value="#now()#">
		</cfinvoke>
	</cfif>
</cffunction>



<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" 				type="numeric" 	required="Yes" 	displayname="Login id">
  <cfargument name="Contratoid" 			type="numeric" 	required="No"  	displayname="Contratoid">
  <cfargument name="Snumero" 				type="string" 	required="No"  	displayname="Número visible del sobre">
  <cfargument name="LGlogin" 				type="string" 	required="Yes"  displayname="Login">
  <cfargument name="LGrealName" 			type="string" 	required="No" 	default="" displayname="RealName">
  <cfargument name="LGmailQuota" 			type="string" 	required="No"  	displayname="Mail Quota (KB)">
  <cfargument name="LGroaming" 				type="boolean" 	required="Yes"  displayname="Tiene roaming">
  <cfargument name="LGprincipal" 			type="boolean" 	required="Yes"  displayname="Login Principal">
  <cfargument name="LGapertura" 			type="string" 	required="No"  	displayname="Fecha de Activacion">
  <cfargument name="LGcese" 				type="string" 	required="No"  	displayname="Fecha Inhabilitación">
  <cfargument name="LGserids" 				type="string" 	required="No" 	default="" displayname="Llave sist. externo">
  <cfargument name="Habilitado" 			type="numeric" 	required="Yes"  displayname="Habilitado">
  <cfargument name="LGbloqueado" 			type="boolean" 	required="Yes"  displayname="Bloqueado">
  <cfargument name="LGmostrarGuia" 			type="boolean" 	required="Yes"  displayname="Mostrar en guía telemática">
  <cfargument name="LGtelefono" 			type="string" 	required="No" 	default="" displayname="Teléfono para acceso conmutado">
  <cfargument name="ts_rversion" 			type="string" 	required="No" 	displayname="ts_rversion">
  <cfargument name="datasource" 			type="string" 	required="No" 	default="#session.DSN#">
  <cfargument name="registrar_en_bitacora" 	type="boolean" 	required="No" 	default="true">
  <cfargument name="BLautomatica" 			type="string" 	required="no" 	default="0" displayname="BLautomatica">
  <cfargument name="BLobs" 					type="string" 	required="no" 	default="Cambio de los datos del login #Arguments.LGnumero#">
  

	<cfquery name="rsSobre" datasource="#session.dsn#">
		select 1 as cantSobres
		from ISBsobres
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Snumero#">
	</cfquery>  
  
	<cfif isdefined('rsSobre') and rsSobre.cantSobres GT 0>
		<cfif isdefined("Arguments.ts_rversion") and Len(Trim(Arguments.ts_rversion))>
			<cf_dbtimestamp datasource="#Arguments.datasource#"
							table="ISBlogin"
							redirect="metadata.code.cfm"
							timestamp="#Arguments.ts_rversion#"
							field1="LGnumero"
							type1="numeric"
							value1="#Arguments.LGnumero#">
		</cfif>
		
		<cfif Arguments.LGprincipal>
			<cfquery datasource="#Arguments.datasource#">
				update ISBlogin 
				set LGprincipal = 0
				, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
	
				where Contratoid = <cfif isdefined("Arguments.Contratoid") and Len(Trim(Arguments.Contratoid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#"><cfelse>null</cfif>
				and LGnumero <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">
				and LGprincipal = 1
			</cfquery>
		</cfif>
		
		<cfquery datasource="#Arguments.datasource#">
			update ISBlogin
			set Contratoid = <cfif isdefined("Arguments.Contratoid") and Len(Trim(Arguments.Contratoid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#"><cfelse>null</cfif>
			, LGlogin = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LGlogin#" null="#Len(Arguments.LGlogin) Is 0#">
			, Snumero = <cfif isdefined("Arguments.Snumero") and Len(Trim(Arguments.Snumero))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Snumero#"><cfelse>null</cfif>
			
			, LGrealName = <cfif isdefined("Arguments.LGrealName") and Len(Trim(Arguments.LGrealName))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LGrealName#"><cfelse>null</cfif>
			, LGmailQuota = <cfif isdefined("Arguments.LGmailQuota") and Len(Trim(Arguments.LGmailQuota))><cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LGmailQuota#"><cfelse>null</cfif>
			, LGroaming = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.LGroaming#" null="#Len(Arguments.LGroaming) Is 0#">
			, LGprincipal = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.LGprincipal#" null="#Len(Arguments.LGprincipal) Is 0#">
			
			, LGapertura = <cfif isdefined("Arguments.LGapertura") and Len(Trim(Arguments.LGapertura))><cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.LGapertura#"><cfelse>null</cfif>
			, LGcese = <cfif isdefined("Arguments.LGcese") and Len(Trim(Arguments.LGcese))><cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.LGcese#"><cfelse>null</cfif>
			, LGserids = <cfif isdefined("Arguments.LGserids") and Len(Trim(Arguments.LGserids))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LGserids#"><cfelse>null</cfif>
			, Habilitado = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">
			
			, LGbloqueado = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.LGbloqueado#" null="#Len(Arguments.LGbloqueado) Is 0#">
			, LGmostrarGuia = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.LGmostrarGuia#" null="#Len(Arguments.LGmostrarGuia) Is 0#">
			, LGtelefono = <cfif isdefined("Arguments.LGtelefono") and Len(Trim(Arguments.LGtelefono))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LGtelefono#"><cfelse>null</cfif>
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			
			where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">
		</cfquery>
	
		<cfif Arguments.registrar_en_bitacora>
			<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta"  >	<!---registro en la bitacora del cambio realizado --->
				<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
				<cfinvokeargument name="LGlogin" value="#Arguments.LGlogin#">
				<cfinvokeargument name="BLautomatica" value="#Arguments.BLautomatica#">				
				<cfinvokeargument name="BLobs" value="#Arguments.BLobs#">
				<cfinvokeargument name="BLfecha" value="#now()#">
			</cfinvoke>
		</cfif>
	<cfelse>
		<cfthrow message="Error, el sobre n&uacute;mero #Arguments.Snumero# no existe. La actualizaci&oacute;n del log&iacute;n fall&oacute;">
	</cfif>
</cffunction>

<cffunction name="CambioLogin" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" 				type="numeric"	required="Yes"  displayname="Login id">
  <cfargument name="LGlogin" 				type="string" 	required="Yes"  displayname="Login">
  <cfargument name="datasource" 			type="string" 	required="No" 	default="#session.DSN#">
  <cfargument name="registrar_en_bitacora" 	type="boolean" 	required="No" 	default="true">
  <cfargument name="BLautomatica" 			type="string" 	required="no" 	default="0" displayname="BLautomatica">
  <cfargument name="BLobs" 					type="string" 	required="no" 	default="Cambio de login #Arguments.LGnumero# a #Arguments.LGlogin#">
  <cfargument name="LGevento" 				type="string" 	required="no" 	default="SACI" 		displayname="origen del último evento">
  	
	<cfquery  name="rsLogin" datasource="#Arguments.datasource#">			<!---Obtinene el login actual--->
		select LGlogin from ISBlogin where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
	
	<cfinvoke component="saci.comp.ISBcambioLogin" method="Alta"  >			<!---Insercion en la tabla de ISBcambioLogin--->
		<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
		<cfinvokeargument name="LGloginAnterior" value="#rsLogin.LGlogin#">
		<cfinvokeargument name="LGfechaCambio" value="#now()#">
	</cfinvoke>
	
	<cfif Arguments.registrar_en_bitacora>
		<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta"  >	<!---registro en la bitacora del cambio realizado --->
			<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
			<cfinvokeargument name="LGlogin" value="#Arguments.LGlogin#">
			<cfinvokeargument name="BLautomatica" value="#Arguments.BLautomatica#">				
			<cfinvokeargument name="BLobs" value="#Arguments.BLobs#">
			<cfinvokeargument name="BLfecha" value="#now()#">
		</cfinvoke>
	</cfif>
	
	<cfquery datasource="#Arguments.datasource#">							<!---Actualiza el login--->
		update ISBlogin
		set LGlogin = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LGlogin#" null="#Len(Arguments.LGlogin) Is 0#">
		, LGevento = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LGevento#"> 
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">
	</cfquery>
</cffunction>




<cffunction name="CambioRealName" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" 				type="numeric" 	required="Yes"  displayname="Login id">
  <cfargument name="LGrealName" 			type="string" 	required="Yes" 	displayname="RealName">
  <cfargument name="datasource" 			type="string" 	required="No" 	default="#session.DSN#">
  <cfargument name="registrar_en_bitacora" 	type="boolean" 	required="No" 	default="true">
  <cfargument name="BLautomatica" 			type="string" 	required="no" 	default="0" displayname="BLautomatica">
  <cfargument name="BLobs" 					type="string" 	required="no" 	default="Cambio de Real Name del login #Arguments.LGnumero#">
  
	<cfquery  name="rsLogin" datasource="#Arguments.datasource#">		<!---Obtinene el login actual--->
		select LGlogin from ISBlogin where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
	
	<cfquery datasource="#Arguments.datasource#">
		update ISBlogin
		set LGrealName = <cfif isdefined("Arguments.LGrealName") and Len(Trim(Arguments.LGrealName))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LGrealName#"><cfelse>null</cfif>
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">
	</cfquery>
	
	<cfif Arguments.registrar_en_bitacora>
		<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta"  >	<!---registro en la bitacora del cambio realizado --->
			<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
			<cfinvokeargument name="LGlogin" value="#rsLogin.LGlogin#">
			<cfinvokeargument name="BLautomatica" value="#Arguments.BLautomatica#">				
			<cfinvokeargument name="BLobs" value="#Arguments.BLobs#">
			<cfinvokeargument name="BLfecha" value="#now()#">
		</cfinvoke>
	</cfif>
</cffunction>




<cffunction name="CambioMailQuota" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" 				type="numeric"	required="Yes"  displayname="Login id">
  <cfargument name="LGmailQuota" 			type="string" 	required="Yes" 	displayname="Mail Quota (KB)">
  <cfargument name="datasource" 			type="string" 	required="No" 	default="#session.DSN#">
  <cfargument name="registrar_en_bitacora" 	type="boolean" 	required="No" 	default="true">
  <cfargument name="BLautomatica" 			type="string" 	required="no" 	default="0" displayname="BLautomatica">
  <cfargument name="BLobs" 					type="string" 	required="no" 	default="Cambio de MailQuota del login #Arguments.LGnumero#">
 
	<cfquery  name="rsLogin" datasource="#Arguments.datasource#">		<!---Obtinene el login actual--->
		select LGlogin from ISBlogin where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
	
	<cfquery datasource="#Arguments.datasource#">
		update ISBlogin
		set  LGmailQuota = <cfif isdefined("Arguments.LGmailQuota") and Len(Trim(Arguments.LGmailQuota))><cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LGmailQuota#"><cfelse>null</cfif>
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">
	</cfquery>
	
	<cfif Arguments.registrar_en_bitacora>
		<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta"  >	<!---registro en la bitacora del cambio realizado --->
			<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
			<cfinvokeargument name="LGlogin" value="#rsLogin.LGlogin#">
			<cfinvokeargument name="BLautomatica" value="#Arguments.BLautomatica#">				
			<cfinvokeargument name="BLobs" value="#Arguments.BLobs#">
			<cfinvokeargument name="BLfecha" value="#now()#">
		</cfinvoke>
	</cfif>
</cffunction>




<cffunction name="CambioTelefono" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" 				type="numeric" 	required="Yes"  displayname="Login id">
  <cfargument name="LGtelefono" 			type="string" 	required="Yes" 	displayname="Teléfono para acceso conmutado">
  <cfargument name="datasource" 			type="string" 	required="No" 	default="#session.DSN#">
  <cfargument name="registrar_en_bitacora" 	type="boolean" 	required="No" 	default="true">
  <cfargument name="BLautomatica" 			type="string" 	required="no" 	default="0" displayname="BLautomatica">
  <cfargument name="BLobs" 					type="string" 	required="no" 	default="Cambio de telefono del login #Arguments.LGnumero#">
 		
	<cfquery  name="rsLogin" datasource="#Arguments.datasource#">		<!---Obtinene el login actual--->
		select LGlogin from ISBlogin where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
	
	<cfquery datasource="#Arguments.datasource#">
		update ISBlogin
		set LGtelefono = <cfif isdefined("Arguments.LGtelefono") and Len(Trim(Arguments.LGtelefono))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LGtelefono#"><cfelse>null</cfif>
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">
	</cfquery>
	
	<!---registro en la bitacora del cambio realizado --->
	<cfif Arguments.registrar_en_bitacora>
		<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta"  >	
			<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
			<cfinvokeargument name="LGlogin" value="#rsLogin.LGlogin#">
			<cfinvokeargument name="BLautomatica" value="#Arguments.BLautomatica#">				
			<cfinvokeargument name="BLobs" value="#Arguments.BLobs#">
			<cfinvokeargument name="BLfecha" value="#now()#">
		</cfinvoke>
	</cfif>
</cffunction>




<cffunction name="AltaForwarding" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" 				type="numeric" 	required="Yes"  displayname="Login id">
  <cfargument name="LGmailForward" 			type="string" 	required="Yes">
  <cfargument name="datasource" 			type="string" 	required="No" 	default="#session.DSN#">
  <cfargument name="registrar_en_bitacora" 	type="boolean" 	required="No" 	default="true">
  <cfargument name="BLautomatica" 			type="string" 	required="no" 	default="0" displayname="BLautomatica">
  <cfargument name="BLobs" 					type="string" 	required="no" 	default="Agregado de Forwarding al login #Arguments.LGnumero#">
 	
	<cfquery  name="rsLogin" datasource="#Arguments.datasource#">		<!---Obtinene el login actual--->
		select LGlogin from ISBlogin where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
	
	<cfinvoke component="saci.comp.ISBmailForward" method="Alta">
		<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
		<cfinvokeargument name="LGmailForward" value="#Arguments.LGmailForward#">
	</cfinvoke>
	
	<!---registro en la bitacora del cambio realizado --->
	<cfif Arguments.registrar_en_bitacora>
		<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta"  >	
			<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
			<cfinvokeargument name="LGlogin" value="#rsLogin.LGlogin#">
			<cfinvokeargument name="BLautomatica" value="#Arguments.BLautomatica#">				
			<cfinvokeargument name="BLobs" value="#Arguments.BLobs#">
			<cfinvokeargument name="BLfecha" value="#now()#">
		</cfinvoke>
	</cfif>
</cffunction>




<cffunction name="BajaForwarding" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" 				type="numeric"	required="Yes"  displayname="Login id">
  <cfargument name="LGmailForward" 			type="string" 	required="Yes">
  <cfargument name="datasource" 			type="string" 	required="No" 	default="#session.DSN#">
  <cfargument name="registrar_en_bitacora" 	type="boolean" 	required="No" 	default="true">
  <cfargument name="BLautomatica" 			type="string" 	required="no" 	default="0" displayname="BLautomatica">
  <cfargument name="BLobs" 					type="string" 	required="no" 	default="Borrado de Forwarding del login #Arguments.LGnumero#">
 	
	<cfquery  name="rsLogin" datasource="#Arguments.datasource#">		<!---Obtinene el login actual--->
		select LGlogin from ISBlogin where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
	
	<cfinvoke component="saci.comp.ISBmailForward" method="Baja">
		<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
		<cfinvokeargument name="LGmailForward" value="#Arguments.LGmailForward#">
	</cfinvoke>
	
	<!---registro en la bitacora del cambio realizado --->
	<cfif Arguments.registrar_en_bitacora>
		<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta"  >	
			<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
			<cfinvokeargument name="LGlogin" value="#rsLogin.LGlogin#">
			<cfinvokeargument name="BLautomatica" value="#Arguments.BLautomatica#">				
			<cfinvokeargument name="BLobs" value="#Arguments.BLobs#">
			<cfinvokeargument name="BLfecha" value="#now()#">
		</cfinvoke>
	</cfif>
</cffunction>




<cffunction name="CambioPassword" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" 				type="numeric"	required="Yes"  displayname="Login id">
  <cfargument name="TScodigo" 				type="string" 	required="Yes"  displayname="Tipo de servicio">
  <cfargument name="SLpassword" 			type="string" 	required="Yes">
  <cfargument name="datasource" 			type="string" 	required="No" 	default="#session.DSN#">
  <cfargument name="registrar_en_bitacora" 	type="boolean" 	required="No" 	default="true">
  <cfargument name="BLautomatica" 			type="string" 	required="no" 	default="0" displayname="BLautomatica">
  <cfargument name="BLobs" 					type="string" 	required="no" 	default="Cambio de Password para el servicio #Arguments.TScodigo# en el login #Arguments.LGnumero#">
 	
	<cfquery  name="rsLogin" datasource="#Arguments.datasource#">		<!---Obtiene el login actual--->
		select LGlogin from ISBlogin where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
	
	<cfinvoke component="saci.comp.ISBserviciosLogin" method="CambioPassword">
		<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
		<cfinvokeargument name="TScodigo" value="#Arguments.TScodigo#">
		<cfinvokeargument name="SLpassword" value="#Arguments.SLpassword#">
	</cfinvoke>
	
	<!---registro en la bitacora del cambio realizado --->
	<cfif Arguments.registrar_en_bitacora>
		<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta"  >	
			<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
			<cfinvokeargument name="LGlogin" value="#rsLogin.LGlogin#">
			<cfinvokeargument name="BLautomatica" value="#Arguments.BLautomatica#">				
			<cfinvokeargument name="BLobs" value="#Arguments.BLobs#">
			<cfinvokeargument name="BLfecha" value="#now()#">
			<cfinvokeargument name="BLpasswordHash" value="#Arguments.SLpassword#">
		</cfinvoke>
	</cfif>	
</cffunction>

<cffunction name="CambioPasswordSobre" output="false" returntype="void" access="remote">
	<cfargument name="Snumero" type="numeric" required="yes" displayname="Sobre id">
	<cfargument name="LGnumero" type="numeric" required="yes" displayname="Login id">
	<cfargument name="LGlogin" type="string" required="yes" displayname="Login">
	<cfargument name="BLautomatica" type="boolean" required="no" default="false" displayname="Anotación automática">
	
	<!--- Poner el sobre como activo --->
	<cfinvoke component="ISBsobres" method="cambioEstado">
		<cfinvokeargument name="Snumero" value="#Arguments.Snumero#">
		<cfinvokeargument name="Sestado" value="1"> <!--- Estado asignado al cliente --->
	</cfinvoke>
	
	<!--- Asignarlo al login --->
	<cfinvoke component="ISBsobres" method="Asigna_Login">
		<cfinvokeargument name="Snumero" value="#Arguments.Snumero#">
		<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
	</cfinvoke>
	
	<!--- Anotación en la bitácora --->
	<cfinvoke component="ISBbitacoraLogin" method="Alta">
	  <cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
	  <cfinvokeargument name="LGlogin" value="#Arguments.LGlogin#">
	  <cfinvokeargument name="BLautomatica" value="#Arguments.BLautomatica#">
	  <cfinvokeargument name="BLobs" value="Cambio de password por sobre">
	</cfinvoke>
</cffunction>


<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" 				type="numeric"	required="Yes"  displayname="Login id">
  <cfargument name="datasource" 			type="string" 	required="No" 	default="#session.DSN#">
  <cfargument name="registrar_en_bitacora" 	type="boolean" 	required="No" 	default="true">
  <cfargument name="BLautomatica" 			type="string" 	required="no" 	default="0" displayname="BLautomatica">
  <cfargument name="BLobs" 					type="string" 	required="no" 	default="Borrado del login #Arguments.LGnumero#">
 	
	<cfquery  name="rsLogin" datasource="#Arguments.datasource#">		<!---Obtinene el login actual--->
		select LGlogin from ISBlogin where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
	
	<cfquery datasource="#Arguments.datasource#">
		delete ISBserviciosLogin
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">
	</cfquery>

	<cfquery datasource="#Arguments.datasource#">
		delete ISBlogin
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">
	</cfquery>
	
	<!---registro en la bitacora del cambio realizado --->
	<cfif Arguments.registrar_en_bitacora>
		<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta"  >	
			<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
			<cfinvokeargument name="LGlogin" value="#rsLogin.LGlogin#">
			<cfinvokeargument name="BLautomatica" value="#Arguments.BLautomatica#">				
			<cfinvokeargument name="BLobs" value="#Arguments.BLobs#">
			<cfinvokeargument name="BLfecha" value="#now()#">
		</cfinvoke>
	</cfif>
</cffunction>

<cffunction name="BajaContrato" output="false" returntype="void" access="remote">
  <cfargument name="Contratoid" 			type="numeric"	required="Yes"  displayname="ID Producto">
  <cfargument name="datasource" 			type="string" 	required="No" 	default="#session.DSN#">
  <cfargument name="registrar_en_bitacora" 	type="boolean" 	required="No" 	default="true">
  <cfargument name="BLautomatica" 			type="string" 	required="no" 	default="0" displayname="BLautomatica">
  <cfargument name="BLobs" 					type="string" 	required="no" 	default="Borrado del login #Arguments.LGnumero# por borrado del Contrato #Arguments.Contratoid#">
 
	<cfquery datasource="#Arguments.datasource#">
		delete ISBserviciosLogin
		where exists (
			select 1
			from ISBlogin x
			where x.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#" null="#Len(Arguments.Contratoid) Is 0#">
			and x.LGnumero = ISBserviciosLogin.LGnumero
		)
	</cfquery>

	<cfquery datasource="#Arguments.datasource#">
		delete ISBlogin
		where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#" null="#Len(Arguments.Contratoid) Is 0#">
	</cfquery>
	
	<!---registro en la bitacora del cambio realizado --->
	<cfif Arguments.registrar_en_bitacora>
		<cfquery  name="logines" datasource="#Arguments.datasource#">			
			select distinct LGnumero, LGlogin from ISBlogin
			where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#" null="#Len(Arguments.Contratoid) Is 0#">
		</cfquery>
	
		<cfif isdefined('logines') and logines.recordCount GT 0>
			<cfloop query="logines">
				<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta">	
					<cfinvokeargument name="LGnumero" value="#logines.LGnumero#">
					<cfinvokeargument name="LGlogin" value="#logines.LGlogin#">
					<cfinvokeargument name="BLautomatica" value="#Arguments.BLautomatica#">				
					<cfinvokeargument name="BLobs" value="#Arguments.BLobs#">
					<cfinvokeargument name="BLfecha" value="#now()#">
				</cfinvoke>
			</cfloop>
		</cfif>			
	</cfif>
</cffunction>

<cffunction name="BajaCuenta" output="false" returntype="void" access="remote">
  <cfargument name="CTid" 					type="numeric" 	required="Yes"  displayname="ID Cuenta">
  <cfargument name="datasource" 			type="string" 	required="No" 	default="#session.DSN#">
  <cfargument name="registrar_en_bitacora" 	type="boolean" 	required="No" 	default="true">
  <cfargument name="BLautomatica" 			type="string" 	required="no" 	default="0" displayname="BLautomatica">
  <cfargument name="BLobs" 					type="string" 	required="no" 	default="Borrado de login por borrado de la Cuenta #Arguments.CTid#">
  <cfargument name="soloEnCaptura" 			type="string" 	required="no" 	default="0" displayname="Solo_Productos_en_captura">  
 
	<cfquery datasource="#Arguments.datasource#">
		delete ISBserviciosLogin
		where exists (
			select 1
			from ISBproducto x
				inner join ISBlogin y
					on y.Contratoid = x.Contratoid
					and y.LGnumero = ISBserviciosLogin.LGnumero
			where x.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">
				<cfif isdefined('Arguments.soloEnCaptura') and Arguments.soloEnCaptura NEQ '0'>
					and x.CTcondicion = 'C'
				</cfif>			
		)
	</cfquery>

	<cfquery datasource="#Arguments.datasource#">
	
		delete ISBlogin
		where exists (
			select 1
			from ISBproducto x
			where x.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">
				and x.Contratoid = ISBlogin.Contratoid
				<cfif isdefined('Arguments.soloEnCaptura') and Arguments.soloEnCaptura NEQ '0'>
					and x.CTcondicion = 'C'
				</cfif>				
		)
	</cfquery>
	
	<!---registro en la bitacora de login del cambio realizado --->
	<cfif Arguments.registrar_en_bitacora>
		<cfquery  name="logines" datasource="#Arguments.datasource#">			
			select distinct LGnumero,LGlogin from ISBlogin
			where exists (
				select 1
				from ISBproducto x
				where x.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">
				and x.Contratoid = ISBlogin.Contratoid
			)
		</cfquery>
	
		<cfif isdefined('logines') and logines.recordCount GT 0>
			<cfloop query="logines">
				<cfset varBLobs = "Borrado del login #logines.LGnumero# por borrado de la Cuenta #Arguments.CTid#">

				<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta"  >	
					<cfinvokeargument name="LGnumero" value="#logines.LGnumero#">
					<cfinvokeargument name="LGlogin" value="#logines.LGlogin#">
					<cfinvokeargument name="BLautomatica" value="#Arguments.BLautomatica#">				
					<cfinvokeargument name="BLobs" value="#varBLobs#">
					<cfinvokeargument name="BLfecha" value="#now()#">
				</cfinvoke>
			</cfloop>
		</cfif>
	</cfif>
</cffunction>

<cffunction name="Alta" output="false" returntype="numeric" access="remote">
  <cfargument name="Contratoid" 			type="numeric"	required="No"  	displayname="Contratoid">
  <cfargument name="Snumero" 				type="string" 	required="No"  	displayname="Número visible del sobre">
  <cfargument name="LGlogin" 				type="string" 	required="Yes" 	displayname="Login">
  <cfargument name="LGrealName" 			type="string" 	required="No" 	default="" displayname="RealName">
  <cfargument name="LGmailQuota" 			type="string" 	required="No"  	displayname="Mail Quota (KB)">
  <cfargument name="LGroaming" 				type="boolean" 	required="Yes"  displayname="Tiene roaming">
  <cfargument name="LGprincipal" 			type="boolean" 	required="Yes"  displayname="Login Principal">
  <cfargument name="LGapertura" 			type="date" 	required="No"  	displayname="Fecha de Activacion">
  <cfargument name="LGcese" 				type="date" 	required="No"  	displayname="Fecha Inhabilitación">
  <cfargument name="LGserids" 				type="string" 	required="No" 	default="" displayname="Llave sist. externo">
  <cfargument name="Habilitado" 			type="numeric" 	required="Yes"  displayname="Habilitado">
  <cfargument name="LGbloqueado" 			type="boolean" 	required="Yes"  displayname="Bloqueado">
  <cfargument name="LGmostrarGuia" 			type="boolean" 	required="Yes"  displayname="Mostrar en guía telemática">
  <cfargument name="LGtelefono" 			type="string" 	required="No" 	default="" displayname="Teléfono para acceso conmutado">
  <cfargument name="Servicios" 				type="string" 	required="No" 	default="" displayname="Define el conjunto de servicios asociados al Login">
  <cfargument name="datasource" 			type="string" 	required="No" 	default="#session.DSN#">
  <cfargument name="registrar_en_bitacora" 	type="boolean" 	required="No" 	default="true">
  <cfargument name="BLautomatica" 			type="string" 	required="no" 	default="0" displayname="BLautomatica">
  <cfargument name="BLobs" 					type="string" 	required="no" 	default="Agregado del login #Arguments.LGlogin#">
  <cfargument name="LGfechaRetiro" 			type="date" 	required="No"  	displayname="Fecha de retiro">
  <cfargument name="MRid"                     type="numeric" required="no" displayname="Motivo de retiro">

	
	<cfif isdefined('Arguments.Snumero') and Len(Trim(Arguments.Snumero))>
	<cfquery name="rsSobre" datasource="#session.dsn#">
		select 1 as cantSobres
		from ISBsobres
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Snumero#">
	</cfquery>
	</cfif>
	
	<cfif isdefined('rsSobre') and rsSobre.cantSobres GT 0>
		<cfif Arguments.LGprincipal>
			<cfquery datasource="#Arguments.datasource#">
				update ISBlogin 
				set LGprincipal = 0
				, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
	
				where Contratoid = <cfif isdefined("Arguments.Contratoid") and Len(Trim(Arguments.Contratoid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#"><cfelse>null</cfif>
				and LGprincipal = 1
			</cfquery>
		</cfif>
	
	</cfif>
		<cfquery datasource="#Arguments.datasource#" name="rsAlta">
			insert into ISBlogin (
				Contratoid,
				Snumero,
				LGlogin,
				
				LGrealName,
				LGmailQuota,
				LGroaming,
				LGprincipal,
				
				LGapertura,
				LGcese,
				LGserids,
				Habilitado,
	
				LGbloqueado,
				LGmostrarGuia,
				LGtelefono,
				LGfechaRetiro,
				
				MRid,
				BMUsucodigo)
			values (
				<cfif isdefined("Arguments.Contratoid") and Len(Trim(Arguments.Contratoid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#"><cfelse>null</cfif>,
				<cfif isdefined("Arguments.Snumero") and Len(Trim(Arguments.Snumero))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Snumero#"><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LGlogin#" null="#Len(Arguments.LGlogin) Is 0#">,
				
				<cfif isdefined("Arguments.LGrealName") and Len(Trim(Arguments.LGrealName))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LGrealName#"><cfelse>null</cfif>,
				<cfif isdefined("Arguments.LGmailQuota") and Len(Trim(Arguments.LGmailQuota))><cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LGmailQuota#"><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.LGroaming#" null="#Len(Arguments.LGroaming) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.LGprincipal#" null="#Len(Arguments.LGprincipal) Is 0#">,
				
				<cfif isdefined("Arguments.LGapertura") and Len(Trim(Arguments.LGapertura))><cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.LGapertura#"><cfelse>null</cfif>,
				<cfif isdefined("Arguments.LGcese") and Len(Trim(Arguments.LGcese))><cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.LGcese#"><cfelse>null</cfif>,
				<cfif isdefined("Arguments.LGserids") and Len(Trim(Arguments.LGserids))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LGserids#"><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">,
	
				<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.LGbloqueado#" null="#Len(Arguments.LGbloqueado) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.LGmostrarGuia#" null="#Len(Arguments.LGmostrarGuia) Is 0#">,
				<cfif isdefined("Arguments.LGtelefono") and Len(Trim(Arguments.LGtelefono))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LGtelefono#"><cfelse>null</cfif>,
				<cfif isdefined("Arguments.LGfechaRetiro") and Len(Trim(Arguments.LGfechaRetiro))><cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.LGfechaRetiro#"><cfelse>null</cfif>,
				
				<cfif IsDefined('Arguments.MRid') and Len(Arguments.MRid)><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MRid#"><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			)
			<cf_dbidentity1 datasource="#Arguments.datasource#" verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 datasource="#Arguments.datasource#" name="rsAlta" verificar_transaccion="false">
	
		<!--- Agregar servicios si vienen definidos --->
		<cfif Len(Trim(Arguments.Servicios))>
			<cfquery datasource="#Arguments.datasource#">
				insert into ISBserviciosLogin (LGnumero, TScodigo, PQcodigo, SLpassword, Habilitado, BMUsucodigo)
				select a.LGnumero, c.TScodigo, c.PQcodigo, '*', 1, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				from ISBlogin a
					inner join ISBproducto b
						on b.Contratoid = a.Contratoid
					inner join ISBservicio c
						on c.PQcodigo = b.PQcodigo
						and c.TScodigo in (<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Servicios#" list="yes" separator=",">)
						and c.Habilitado = 1
				where a.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAlta.identity#">
			</cfquery>
		</cfif>
	
		<!---registro en la bitacora del cambio realizado --->
		<cfif Arguments.registrar_en_bitacora>
			<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta"  >	
				<cfinvokeargument name="LGnumero" value="#rsAlta.identity#">
				<cfinvokeargument name="LGlogin" value="#Arguments.LGlogin#">
				<cfinvokeargument name="BLautomatica" value="#Arguments.BLautomatica#">				
				<cfinvokeargument name="BLobs" value="#Arguments.BLobs#">
				<cfinvokeargument name="BLfecha" value="#now()#">
			</cfinvoke>
		</cfif>
		
		<cfreturn rsAlta.identity>	
	<!---<cfelse>--->
		<!---<cfthrow message="Error, el sobre n&uacute;mero #Arguments.Snumero# no existe. La inserci&oacute;n del log&iacute;n fall&oacute;">--->
	<!---</cfif>--->
</cffunction>

</cfcomponent>
