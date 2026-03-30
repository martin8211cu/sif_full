<cfcomponent output="false" displayname="WSAutenticacion" extends="crc.Componentes.CRCBase" hint="Componente para manejo de autenticacion">

	<cffunction name="init" access="private" returntype="CRCCompras"> 
		<cfargument name="DSN" 	   type="string" default="#Session.DSN#" >
		<cfargument name="Ecodigo" type="string" default="#Session.Ecodigo#" >		
		<cfset Super.init(arguments.DSN, arguments.Ecodigo)>

		<cfreturn this>
	</cffunction>
	
	<cffunction name="generarCodigoVerificacion" access="private" returntype="struct">
		<cfargument name="SNid" required="true" type="numeric">

		<!--- Generar un código de verificación de 6 dígitos --->
		<cfset var codigo = numberFormat(randRange(100000,999999), "000000")>

		<!--- Guardar el código en la base de datos o en sesión según la lógica de negocio --->
		<cfquery datasource="#this.DSN#">
			UPDATE SNegocios
			SET CodigoVerificacion = <cfqueryparam value="#codigo#" cfsqltype="cf_sql_varchar">
			WHERE SNid = <cfqueryparam value="#arguments.SNid#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfreturn {success=true, codigo=codigo}>
	</cffunction>

	<cffunction name="verificarCodigo" access="public" returntype="struct">
		<cfargument name="email" required="true" type="string">
		<cfargument name="codigo" required="true" type="string">

		<cfquery name="qVerificacion" datasource="#this.DSN#">
			SELECT
				sn.Ecodigo, sn.SNcodigo, sn.SNidentificacion, sn.SNidentificacion2, sn.SNtiposocio, sn.SNnombre, sn.SNdireccion,
				sn.SNtelefono, sn.SNFax, sn.SNemail, sn.SNFecha,
				sn.SNnumero, sn.SNcodigoext,
				sn.id_direccion, sn.SNidPadre, sn.SNid,
				sn.disT, sn.TarjH, sn.SNFechaNacimiento
			FROM SNegocios sn
			WHERE ltrim(rtrim(sn.SNemail)) = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
				AND sn.CodigoVerificacion = <cfqueryparam value="#arguments.codigo#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfif qVerificacion.recordCount GT 0>
			<cfset user = this.db.queryRowToStruct(qVerificacion, 1)>
			<cfreturn {success=true, user=user}>
		<cfelse>
			<cfreturn {success=false, message="Código de verificación incorrecto o usuario no encontrado."}>
		</cfif>
	</cffunction>
	
	<cffunction name="obtenerSocioPorEmail" access="public" returntype="struct">
		<cfargument name="email" required="true" type="string">

		<cfquery name="qVerificacion" datasource="#this.DSN#">
			SELECT
				sn.Ecodigo, sn.SNcodigo, sn.SNidentificacion, sn.SNidentificacion2, sn.SNtiposocio, sn.SNnombre, sn.SNdireccion,
				sn.SNtelefono, sn.SNFax, sn.SNemail, sn.SNFecha,
				sn.SNnumero, sn.SNcodigoext,
				sn.id_direccion, sn.SNidPadre, sn.SNid,
				sn.disT, sn.TarjH, sn.SNFechaNacimiento
			FROM SNegocios sn
			WHERE ltrim(rtrim(sn.SNemail)) = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfif qVerificacion.recordCount GT 0>
			<cfset user = this.db.queryRowToStruct(qVerificacion, 1)>
			<cfreturn {success=true, user=user}>
		<cfelse>
			<cfreturn {success=false, message="Código de verificación incorrecto o usuario no encontrado."}>
		</cfif>
	</cffunction>


	<cffunction name="enviarCodigoVerificacion" access="public" returntype="struct">
		<cfargument name="email" required="true" type="string">
		
		<cfquery name="qGetSNid" datasource="#this.DSN#">
			select sn.SNid
			from SNegocios sn
			where (sn.disT = 1 or sn.TarjH = 1)
				and ltrim(rtrim(sn.SNemail)) = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfif qGetSNid.recordCount GT 0>
			<cfset socio = this.db.queryRowToStruct(qGetSNid, 1)>
			<cfset codigoData = generarCodigoVerificacion(SNid=socio.SNid)>
			<cfset codigo = codigoData.codigo>
			<cfset enviadoPor = "MS_WtAxDI@alateamtech.space">
			<cfset contenido = "Tu código de verificación es: <strong>#codigo#</strong>">
			<!--- Enviar el código por correo electrónico --->
			<cfquery name="rsInserta" datasource="#this.DSN#">
				insert into SMTPQueue ( SMTPremitente, 	SMTPdestinatario, 	SMTPasunto,
										SMTPtexto, 		SMTPintentos, 		SMTPcreado,
										SMTPenviado, 	SMTPhtml, 			BMUsucodigo )
				values ( <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#enviadoPor#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.email#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="Código de verificación">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#contenido#">,
						0,	#now()#,	#now()#,	1,
						1
						)
			</cfquery>

			<cfquery name="qVerificacion" datasource="#this.DSN#">
				select
					sn.Ecodigo, sn.SNcodigo, sn.SNidentificacion,sn.SNidentificacion2, sn.SNtiposocio, sn.SNnombre, sn.SNdireccion,
					sn.SNtelefono, sn.SNFax, sn.SNemail, sn.SNFecha,
					sn.SNnumero,sn.SNcodigoext,
					sn.id_direccion, sn.SNidPadre, sn.SNid,
					sn.disT,sn.TarjH, sn.SNFechaNacimiento,
					sn.CodigoVerificacion
				from SNegocios sn
				where (sn.disT = 1 or sn.TarjH = 1)
					and ltrim(rtrim(sn.SNemail)) = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfset user = this.db.queryRowToStruct(qVerificacion, 1)>
			<cfreturn user>
		<cfelse>
			<cfthrow type="NoUserFound" message="No se encontro un usuario con el correo electronico proporcionado.">
		</cfif>
	</cffunction>

</cfcomponent>