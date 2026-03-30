<cfparam name="modo" default="ALTA">
<cfparam name="modoC" default="ALTA">
<cfparam name="modoR" default="ALTA">
<cfparam name="modoS" default="ALTA">

<!---  Para ver si hay que borrar los valores de una caracteristica si viene seleccionada alguna de estas casillas --->
<cfif isDefined("form.CambioC") and
		isDefined("form.METECtipo") and
		form.METECtipo NEQ 'list'>
	<cfset borrarValores = true>
	<cfset insertarValores = false>
<cfelseif isDefined("form.CambioC") and
		(isdefined("form.cambiarValores") 
		and form.cambiarValores eq 'true'
		and isdefined("form.MEVCdescripciones") 
		and len(trim(form.MEVCdescripciones )) gt 0)>
	<cfset borrarValores = true>
	<cfset insertarValores = true>
<cfelse>
	<cfset borrarValores = false>
	<cfset insertarValores = false>
</cfif>

<cfif not isdefined("form.Nuevo") >
		<cftransaction>
		<cftry>	
			<cfquery name="abc_tipoentidad" datasource="#session.DSN#">
				set nocount on
				<cfif isdefined("form.ALTA")>
					insert METipoEntidad ( METEformato, METEdesc, METEmenu, 
							METEident, METEemail, METEimagen, METEtext, METEfacturable, METEusuario, 
							METEetiqident, METEetiqemail, METEetiqimagen, 
							METEetiqtext, METEetiqnom, Usucodigo, Ulocalizacion, METEfechareg)
					values (
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.METEformato#">, 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.METEdesc#">, 
							<cfif isdefined("form.METEmenu")>1<cfelse>0</cfif>, 
							<cfif isdefined("form.METEident")>1<cfelse>0</cfif>, 
							<cfif isdefined("form.METEemail")>1<cfelse>0</cfif>, 
							<cfif isdefined("form.METEimagen")>1<cfelse>0</cfif>, 
							<cfif isdefined("form.METEtext")>1<cfelse>0</cfif>, 
							<cfif isdefined("form.METEfacturable")>1<cfelse>0</cfif>, 
							<cfif isdefined("form.METEusuario")>1<cfelse>0</cfif>, 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.METEetiqident#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.METEetiqemail#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.METEetiqimagen#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.METEetiqtext#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.METEetiqnom#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
							getdate()
							)
				<cfelseif isdefined("form.CAMBIO") >
					update METipoEntidad
							set METEdesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.METEdesc#">, 
							METEmenu = <cfif isdefined("form.METEmenu")>1<cfelse>0</cfif>, 
							METEident = <cfif isdefined("form.METEident")>1<cfelse>0</cfif>, 
							METEemail = <cfif isdefined("form.METEemail")>1<cfelse>0</cfif>, 
							METEimagen = <cfif isdefined("form.METEimagen")>1<cfelse>0</cfif>, 
							METEtext = <cfif isdefined("form.METEtext")>1<cfelse>0</cfif>, 
							METEfacturable = <cfif isdefined("form.METEfacturable")>1<cfelse>0</cfif>, 
							METEusuario = <cfif isdefined("form.METEusuario")>1<cfelse>0</cfif>, 
							METEetiqident = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.METEetiqident#">,
							METEetiqemail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.METEetiqemail#">,
							METEetiqimagen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.METEetiqimagen#">,
							METEetiqtext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.METEetiqtext#">,
							METEetiqnom = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.METEetiqnom#">,
							Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
					where METEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#" >
					  and ts_rversion = convert(varbinary,#lcase(form.ts_rversion)#)
					<cfset modo = "CAMBIO">
				<cfelseif isdefined("form.BAJA")>
<!---
					--Borrar también los datos de las entidades

					delete MECaracteristicaEntidad
					where METECid in (select METECid from METECaracteristica
					where METEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">)
					
					delete MERelacionEntidad
					where MEEid in (select MEEid from MEEntidad
					where METEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">)
					
					delete MERelacionEntidad
					where MEEid2 in (select MEEid from MEEntidad
					where METEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">)
					
					delete MERelacionEntidad
					where METRid in (select METRid from MERelacionesPermitidas 
					where METEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">)
					
					
					delete MEDDonacion
					where MEEid in (select MEEid from MEEntidad
					where METEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">)
					
					delete MEEntidad
					where METEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">
--->
					--Está en una Transacción, entonces si algo falla todo se devuelve.
					delete MEVCaracteristica 
					from METipoEntidad a, METECaracteristica b, MEVCaracteristica c
					where a.METEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">
					  and a.METEid = b.METEid
					  and b.METECid = c.METECid
					
					delete METECaracteristica 
					where METEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">
					
					delete MERelacionesPermitidas 
					where METEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">
					
					delete MERelacionesPermitidas 
					where METEidrel = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">
					
					delete MEServicioEntidad
					where METEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">
					
					delete METipoEntidad
					where METEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">
				<cfelseif isDefined("form.NuevoC")>
					<cfset modo = "CAMBIO">
					<cfset modoC = "ALTA">
				<cfelseif isDefined("form.AltaC")>
					declare @METECid numeric
					
					insert METECaracteristica (METEid, METECdescripcion, METECtipo, 
						METECtexto,METECcantidad,METECvalor,METECfecha,METECbit,
						METECgrupolocale, METECrefpais,
						METECfacturable, METECdesplegar, METEClista, METECrequerido, METECeditable, 
						METEorden, METEfila, METEcol, Usucodigo, Ulocalizacion, METEfechareg)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.METECdescripcion#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.METECtipo#">, 
						<cfqueryparam cfsqltype="cf_sql_bit" value="#form.METECtipo IS 'char'#">, 
						<cfqueryparam cfsqltype="cf_sql_bit" value="#form.METECtipo IS 'num'#">, 
						<cfqueryparam cfsqltype="cf_sql_bit" value="#form.METECtipo IS 'money'#">, 
						<cfqueryparam cfsqltype="cf_sql_bit" value="#form.METECtipo IS 'date'#">, 
						<cfqueryparam cfsqltype="cf_sql_bit" value="#form.METECtipo IS 'bit'#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.METECgrupolocale#" null="#Len(form.METECgrupolocale) EQ 0#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METECrefpais#" null="#Len(form.METECrefpais) EQ 0#">, 
						1, 
						<cfif isdefined("form.METECdesplegar")>1<cfelse>0</cfif>, 
						<cfif isdefined("form.METEClista")>1<cfelse>0</cfif>, 
						<cfif isdefined("form.METECrequerido")>1<cfelse>0</cfif>, 
						<cfif isdefined("form.METECeditable")>1<cfelse>0</cfif>, 

						<cfif isdefined("form.METEorden") and len(trim(form.METEorden))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEorden#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.METEfila#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.METEcol#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, 
						getdate()
					)
					
					select @METECid = @@identity
					
					<cfif isdefined("form.MEVCdescripciones") and len(trim(form.MEVCdescripciones )) gt 0>
						<cfset arrMEVCdescripciones = ListToArray(form.MEVCdescripciones)>
						<cfloop from="1" to="#ArrayLen(arrMEVCdescripciones)#" index="i">
							insert MEVCaracteristica (METECid, MEVCvalor, MEVCdescripcion, Usucodigo, Ulocalizacion, MEVCfechareg)
							values (
								@METECid,
								0.0, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#arrMEVCdescripciones[i]#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, 
								getdate()
							)
						</cfloop>
					</cfif>
					<cfset modo = "CAMBIO">		
				<cfelseif isDefined("form.CambioC")>
					<cfif borrarValores>
						delete MEVCaracteristica 
						where METECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METECid#">				
					</cfif>
					<cfif insertarValores>
						<cfset arrMEVCdescripciones = ListToArray(form.MEVCdescripciones)>
						<cfloop from="1" to="#ArrayLen(arrMEVCdescripciones)#" index="i">
							insert MEVCaracteristica (METECid, MEVCvalor, MEVCdescripcion, Usucodigo, Ulocalizacion, MEVCfechareg)
							values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METECid#">, 
								0.0, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#arrMEVCdescripciones[i]#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, 
								getdate()
							)
						</cfloop>
					</cfif>
					
					update METECaracteristica set
						METECdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.METECdescripcion#">, 
						METECtipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.METECtipo#">, 
						METECtexto = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.METECtipo IS 'char'#">, 
						METECcantidad = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.METECtipo IS 'num'#">, 
						METECvalor = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.METECtipo IS 'money'#">, 
						METECfecha = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.METECtipo IS 'date'#">, 
						METECbit = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.METECtipo IS 'bit'#">, 
						METECgrupolocale = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.METECgrupolocale#" null="#Len(form.METECgrupolocale) EQ 0#">, 
						METECrefpais = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METECrefpais#" null="#Len(form.METECrefpais) EQ 0#">, 
						METECdesplegar = <cfif isdefined("form.METECdesplegar")>1<cfelse>0</cfif>, 
						METEClista = <cfif isdefined("form.METEClista")>1<cfelse>0</cfif>, 
						METECrequerido = <cfif isdefined("form.METECrequerido")>1<cfelse>0</cfif>, 
						METECeditable = <cfif isdefined("form.METECeditable")>1<cfelse>0</cfif>, 
						METEorden = <cfif isdefined("form.METEorden") and len(trim(form.METEorden))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEorden#"><cfelse>null</cfif>,
						METEfila = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.METEfila#">, 
						METEcol = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.METEcol#">, 
						Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
						Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
					where METECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METECid#">
					  and METEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">
					  and ts_rversion = convert(varbinary,#lcase(form.ts_rversion)#)
									
					<cfset modo = "CAMBIO">
					<cfset modoC = "ALTA">	
				
				<cfelseif isDefined("form.EliminarC")>
					delete MECaracteristicaEntidad
					where METECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METECid#">				
				
					delete MEVCaracteristica 
					where METECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METECid#">				
				
					delete METECaracteristica 
					where METECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METECid#">
					  and METEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">
		
					<cfset modo = "CAMBIO">
					<cfset modoC = "ALTA">
									
				<cfelseif isdefined("form.ModificarC") and Trim(form.ModificarC) EQ "ModificarC">
					<cfset modo = "CAMBIO">
					<cfset modoC = "CAMBIO">
		
				<cfelseif isdefined("form.ModificarR") and Trim(form.ModificarR) EQ "ModificarR">
					<cfset modo = "CAMBIO">
					<cfset modoR = "CAMBIO">

				<cfelseif isdefined("form.ModificarS") and Trim(form.ModificarS) EQ "ModificarS">
					<cfset modo = "CAMBIO">
					<cfset modoS = "CAMBIO">
					
				<cfelseif isDefined("form.NuevoR")>
					<cfset modo = "CAMBIO">
					<cfset modoR = "ALTA">
		
				<cfelseif isDefined("form.AltaR")>
					insert MERelacionesPermitidas (
						METEid, METEidrel, 
						MERPdescripcion1, MERPdescripcion2, MERPtipo,
						MERPorden,
						MERPnuevos,
						MERPconlis,
						MERPver_hijos,
						MERPmin_hijos,
						MERPmax_hijos,
						MERPsug_hijos,
						MERPver_padres,
						MERPmin_padres,
						MERPmax_padres,
						MERPsug_padres)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEidrel#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MERPdescripcion1#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MERPdescripcion2#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MERPtipo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.MERPorden#">, 
						<cfif isdefined("form.MERPnuevos")>1<cfelse>0</cfif>, 
						<cfif isdefined("form.MERPconlis")>1<cfelse>0</cfif>, 
						<cfif isdefined("form.MERPver_hijos")>1<cfelse>0</cfif>, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.MERPmin_hijos#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.MERPmax_hijos#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.MERPsug_hijos#">, 
						<cfif isdefined("form.MERPver_padres")>1<cfelse>0</cfif>, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.MERPmin_padres#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.MERPmax_padres#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.MERPsug_padres#">
						)				
					<cfset modo = "CAMBIO">
		
				<cfelseif isDefined("form.CambioR")>					
					update MERelacionesPermitidas set
						MERPdescripcion1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MERPdescripcion1#">, 
						MERPdescripcion2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MERPdescripcion2#">,
						MERPtipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MERPtipo#">,
						MERPorden = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MERPorden#">, 
						MERPnuevos = <cfif isdefined("form.MERPnuevos")>1<cfelse>0</cfif>, 
						MERPconlis = <cfif isdefined("form.MERPconlis")>1<cfelse>0</cfif>, 
						MERPver_hijos = <cfif isdefined("form.MERPver_hijos")>1<cfelse>0</cfif>, 
						MERPmin_hijos = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MERPmin_hijos#">, 
						MERPmax_hijos = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MERPmax_hijos#">, 
						MERPsug_hijos = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MERPsug_hijos#">, 
						MERPver_padres = <cfif isdefined("form.MERPver_padres")>1<cfelse>0</cfif>, 
						MERPmin_padres = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MERPmin_padres#">, 
						MERPmax_padres = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MERPmax_padres#">, 
						MERPsug_padres = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MERPsug_padres#">
					where METRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METRid#">
					  and ts_rversion = convert(varbinary,#lcase(form.ts_rversion)#)
					<cfset modo = "CAMBIO">
					<cfset modoR = "ALTA">	
		
				<cfelseif isDefined("form.EliminarR")>
					delete MERelacionesPermitidas
					where METRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METRid#">
					<cfset modo = "CAMBIO">
					<cfset modoR = "ALTA">

				<cfelseif isDefined("form.NuevoS")>
					<cfset modo = "CAMBIO">
					<cfset modoS = "ALTA">
		
				<cfelseif isDefined("form.AltaS")>
					insert MEServicioEntidad (
						METEid, MESid, METEetiq, METEorden)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MESid#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.METEetiq#">, 
						<cfif isdefined("form.METEorden") and len(trim(form.METEorden))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEorden#"><cfelse>null</cfif>
					)
					<cfset modo = "CAMBIO">
					
				<cfelseif isDefined("form.CambioS")>
					update MEServicioEntidad set
						METEetiq = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.METEetiq#">, 
						METEorden = <cfif isdefined("form.METEorden") and len(trim(form.METEorden))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEorden#"><cfelse>null</cfif>
					where METEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">
						and MESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MESid#">
					  	and ts_rversion = convert(varbinary,#lcase(form.ts_rversion)#)
					<cfset modo = "CAMBIO">
					<cfset modoS = "ALTA">	
		
				<cfelseif isDefined("form.EliminarS")>
					delete MEServicioEntidad
					where METEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">
						and MESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MESid#">
					<cfset modo = "CAMBIO">
					<cfset modoS = "ALTA">
					
				</cfif>
				set nocount off
			</cfquery>
		<cfcatch type="any">
			<cftransaction action="rollback">
			<cfdump var="#cfcatch#">
			<cfinclude template="../../../errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
		</cftry>
		</cftransaction>
</cfif>

<cfoutput>
<form action="TipoEntidad.cfm" method="post">
	<input type="hidden" name="TABSEL" id="TABSEL" value="#form.TABSEL#">
	<input type="hidden" name="modo" value="#modo#">		
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="METEid" value="#form.METEid#">
						
		<cfif modoC neq 'ALTA'>
			<input type="hidden" name="modoC" value="CAMBIO">			
			<!--- Llave de la Característica --->
			<cfif isDefined("form.METECid")>
				<input type="hidden" name="METECid" value="#form.METECid#">
			</cfif>
		</cfif>
		
		<cfif modoR neq 'ALTA'>
			<input type="hidden" name="modoR" value="CAMBIO">
						
			<!--- Llave de la Relación Permitida --->		
			<input type="hidden" name="METEidrel" value="#form.METEidrel#">
			<input type="hidden" name="METRid" value="#form.METRid#">					
		
		</cfif>
		
		<cfif modoS neq 'ALTA'>
			<input type="hidden" name="modoS" value="CAMBIO">
						
			<!--- Llave de la Relación Permitida --->		
			<input type="hidden" name="MESid" value="#form.MESid#">
		
		</cfif>
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("form.Pagina")>#form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<!---
<cfdump var="#form#">
<a href="javascript: document.forms[0].submit();">Continuar</a>--->
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

