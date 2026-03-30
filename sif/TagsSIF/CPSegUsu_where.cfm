<cfset def = QueryNew("CFid")> 

<!--- Parámetros del TAG --->
<cfparam name="Attributes.name" 			default="CFid" type="string"> 	<!--- Nombre del campo CFid en form y session --->
<cfparam name="Attributes.aliasCuentas"		default="cp" type="string"> 	<!--- Alias de la tabla que contiene el CPcuenta --->
<cfparam name="Attributes.aliasOficina"		default="" type="string"> 		<!--- Alias de la tabla que contiene el Ocodigo --->
<cfparam name="Attributes.Consultar" 		default="no" type="boolean"> 	<!--- Seguridad para Consultar --->
<cfparam name="Attributes.Formulacion" 		default="no" type="boolean"> 	<!--- Seguridad para Formular --->
<cfparam name="Attributes.Traslados" 		default="no" type="boolean"> 	<!--- Seguridad para Trasladar --->
<cfparam name="Attributes.Reservas" 		default="no" type="boolean"> 	<!--- Seguridad para Provisiones --->
<cfparam name="Attributes.sinUsucodigo"		default="no" type="boolean"> 	<!--- Lista todas las cuentas para un Centro Funcional --->
<cfparam name="Attributes.SoloCFs" 			default="no" type="boolean"> 	<!--- Lista los Centros Funcionales del Usuario (combo)  --->
<cfparam name="Attributes.returnVariable" 	default="" type="string"> 		<!--- Nombre de la variable que contendrá el codigo. Si no se pone se incluye en un <cfoutput> --->
<cfparam name="Attributes.verSeguridadUsu" 	default="yes" type="boolean"> 	<!--- Verifica la seguridad especifica de usuario --->
<cf_CPSegUsu_setCFid name="#Attributes.name#">
<cfif not isdefined("form.#Attributes.name#")>
	<cf_errorCode	code = "50615" msg = "No se utilizó el <cf_CPSegUsu_cboCFid>">
</cfif>
<cfif not (Attributes.Consultar or Attributes.Formulacion or Attributes.Traslados or Attributes.Reservas)>
	<cf_errorCode	code = "50616" msg = "Se debe indicar un tipo de Acceso: Consultar, Formulacion, Traslados, ó Reservas (Provisiones Presupuestarias)">
</cfif>
<cfif form[Attributes.name] EQ "-100" AND Attributes.sinUsucodigo>
	<cf_errorCode	code = "50617" msg = "No se permite (Todas las cuentas del usuario) y (Todas las cuentas del centro Funcional)">
</cfif>
<cfif Attributes.SoloCFs AND Attributes.sinUsucodigo>
	<cf_errorCode	code = "50618" msg = "No se permite (Solo Centros Funcionales) y (Todas las cuentas del centro Funcional)">
</cfif>
<cfoutput>

<cfset LvarSybase = Application.dsinfo[#session.dsn#].type EQ "sybase">
<cfsavecontent variable="LvarCPSegUsuWhere">
<cfif Attributes.SoloCFs>
	AND (
		<cfif LvarSybase>
		SELECT	count(1)
		  FROM	CPSeguridadUsuario CP_usu (index CPSeguridadUsuario_01)
		<cfelse>
		SELECT 	/*+ index(cpu,CPSeguridadUsuario_01) */
				count(1)
		  FROM	CPSeguridadUsuario CP_usu 
			inner join CFuncional CP_cf
				 on CP_cf.CFid = CP_usu.CFid
				and CP_cf.CFestado=1
		</cfif>
		 where CP_usu.Ecodigo	= #session.Ecodigo#
		   and CP_usu.Usucodigo	= #session.Usucodigo#
		<cfif isdefined('Attributes.aliasCF') and len(trim('Attributes.aliasCF')) and (Attributes.aliasCF neq '')>
		   and CP_usu.CFid		= #Attributes.aliasCF#.#Attributes.name#
		</cfif>
		<cfif Attributes.Consultar>
		   and CP_usu.CPSUconsultar = 1
		<cfelseif Attributes.Formulacion>
		   and CP_usu.CPSUformulacion = 1
		<cfelseif Attributes.Traslados>
		   and CP_usu.CPSUtraslados = 1
		<cfelseif Attributes.Reservas>
		   and CP_usu.CPSUreservas = 1
		</cfif>
	) > 0
<cfelse>
	AND (
		( 
		<cfif Attributes.sinUsucodigo>
		  <cfif LvarSybase>
			SELECT	count(1)
			  FROM	CPSeguridadMascarasCtasP CP_msk (index CPSeguridadMascarasCtasP_01)
		  <cfelse>
			SELECT 	/*+ index(cpm,CPSeguridadMascarasCtasP_01) */
					count(1)
			  FROM	CPSeguridadMascarasCtasP CP_msk
		  </cfif>
				inner join CFuncional CP_cf
					 on CP_cf.CFid = CP_msk.CFid
					and CP_cf.CFestado=1
			 WHERE CP_msk.Ecodigo		= #session.Ecodigo#
			   and CP_msk.CFid			= #form[Attributes.name]#
			   and <cf_dbfunction name="like"	args="#Attributes.aliasCuentas#.CPformato,CP_msk.CPSMascaraP">
			<cfif Attributes.Consultar>
				and CP_msk.CPSMconsultar = 1
			<cfelseif Attributes.Formulacion>
				and CP_msk.CPSMformulacion = 1
			<cfelseif Attributes.Traslados>
				and CP_msk.CPSMtraslados = 1
			<cfelseif Attributes.Reservas>
				and CP_msk.CPSMreservas = 1
			</cfif>
			<cfif Attributes.aliasOficina NEQ "">
				and CP_cf.Ocodigo = #Attributes.aliasOficina#.Ocodigo
				and CP_cf.Ecodigo = #Attributes.aliasOficina#.Ecodigo
			</cfif>
		<cfelse>
			<cfif LvarSybase>
			SELECT 	count(1)
			  FROM	CPSeguridadUsuario CP_usu (index CPSeguridadUsuario_01)
			<cfelse>
			SELECT 	/*+ index(cpu,CPSeguridadUsuario_01) index(cpm,CPSeguridadMascarasCtasP_01) */
					count(1)
			  FROM	CPSeguridadUsuario CP_usu
			</cfif>
				inner join CPSeguridadMascarasCtasP CP_msk  <cfif LvarSybase>(index CPSeguridadMascarasCtasP_01)</cfif>
					inner join CFuncional CP_cf
						 on CP_cf.CFid = CP_msk.CFid
						and CP_cf.CFestado=1
					 on CP_msk.Ecodigo 		= CP_usu.Ecodigo
					and CP_msk.CFid 		= CP_usu.CFid
					and CP_msk.Usucodigo 	IS NULL		<!--- and coalesce(CP_msk.Usucodigo,CP_usu.Usucodigo) = CP_usu.Usucodigo --->
				<cfif Attributes.Consultar>
					and CP_msk.CPSMconsultar = 1 and CP_usu.CPSUconsultar = 1
				<cfelseif Attributes.Formulacion>
					and CP_msk.CPSMformulacion = 1 and CP_usu.CPSUformulacion = 1
				<cfelseif Attributes.Traslados>
					and CP_msk.CPSMtraslados = 1 and CP_usu.CPSUtraslados = 1
				<cfelseif Attributes.Reservas>
					and CP_msk.CPSMreservas = 1 and CP_usu.CPSUreservas = 1
				</cfif>
			 WHERE CP_usu.Ecodigo		= #session.Ecodigo#
			   and CP_usu.Usucodigo	= #session.Usucodigo#
			<cfif form[Attributes.name] NEQ "-100" and len(trim('form[Attributes.name]')) and form[Attributes.name] neq ''>
			   and CP_usu.CFid			= #form[Attributes.name]#
			</cfif>
			   and <cf_dbfunction name="like"	args="#Attributes.aliasCuentas#.CPformato,CP_msk.CPSMascaraP">
			<cfif Attributes.aliasOficina NEQ "">
			   and CP_cf.Ocodigo = #Attributes.aliasOficina#.Ocodigo
			   and CP_cf.Ecodigo = #Attributes.aliasOficina#.Ecodigo
			</cfif>
		</cfif>
		) > 0
	<cfif (Attributes.Consultar or Attributes.Formulacion) AND form[Attributes.name] EQ "-100" and Attributes.verSeguridadUsu>
	OR
		( 
			SELECT count(1)
			  FROM CPSeguridadMascarasCtasP CP_msk
			 WHERE CP_msk.Ecodigo		= #session.Ecodigo#
			   and CP_msk.CFid			IS NULL
			   and CP_msk.Usucodigo	= #session.Usucodigo#
			<cfif Attributes.Consultar>
			   and CP_msk.CPSMconsultar = 1
			<cfelseif Attributes.Formulacion>
			   and CP_msk.CPSMformulacion = 1
			</cfif>
			   and <cf_dbfunction name="like"	args="#Attributes.aliasCuentas#.CPformato,CP_msk.CPSMascaraP">
		) > 0
	</cfif>
  )
</cfif>
</cfsavecontent>
</cfoutput>
<cfif Attributes.returnVariable EQ "">
	<cfoutput>#LvarCPSegUsuWhere#</cfoutput>
<cfelse>
	<cfset Caller[Attributes.returnVariable] = LvarCPSegUsuWhere>
</cfif>


