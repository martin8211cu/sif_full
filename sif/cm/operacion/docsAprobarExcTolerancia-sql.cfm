<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cffunction name="hayReclamo" access="public" returntype="boolean" output="true">
	<cfargument name="val_DDRlinea" type="numeric" required="yes">
	
	<cfset resultado = false>	
	<cfquery name="rsInfoDetalle" datasource="#session.dsn#">
		select  
				#LvarOBJ_PrecioU.enSQL_AS("ddr.DDRpreciou")#,
				#LvarOBJ_PrecioU.enSQL_AS("docm.DOpreciou")#,
				coalesce(docm.DOporcdesc, 0.00) as DOporcdesc,
				coalesce(ddr.DDRdescporclin, 0.00) as DDRdescporclin,
				coalesce(ddr.DDRimptoporclin, 0.00) as DDRimptoporclin,
				imp.Iporcentaje as IporcentajeOC, 
				ddr.DDRcantorigen,
				ddr.DDRcantrec
		from DDocumentosRecepcion ddr
			inner join DOrdenCM docm
				on docm.DOlinea = ddr.DOlinea
				and docm.Ecodigo = ddr.Ecodigo

			inner join Impuestos imp
				on imp.Icodigo = docm.Icodigo
				and imp.Ecodigo = docm.Ecodigo
		where ddr.DDRlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#val_DDRlinea#">
	</cfquery>			


	<cfif isdefined('rsInfoDetalle') and rsInfoDetalle.recordCount GT 0>
		<!--- Revisa el Precio Unitario. --->
		<cfif rsInfoDetalle.DDRpreciou NEQ rsInfoDetalle.DOpreciou>
			<cfset resultado = true>
		</cfif>
		<!--- Revisa el Porcentaje Descuento. --->
		<cfif rsInfoDetalle.DOporcdesc NEQ rsInfoDetalle.DDRdescporclin>
			<cfset resultado = true>
		</cfif>
		<!--- Revisa el Impuesto. --->
		<cfif rsInfoDetalle.DDRimptoporclin NEQ rsInfoDetalle.IporcentajeOC>
			<cfset resultado = true>
		</cfif>
		<!--- Revisa la cantidad en factura contra la recibida. --->
		<cfif rsInfoDetalle.DDRcantorigen NEQ rsInfoDetalle.DDRcantrec>
			<cfset resultado = true>
		</cfif>
		<!--- Verifica todo menos la tolerancia --->
	</cfif>		

	<cfreturn resultado>
</cffunction>

<cfif isdefined("form.Opcion")>
	<!--- Modificar reclamo y observaciones de aprobación --->
	<cfif form.Opcion eq "Modificar">

		<!--- 1. Hace las modificaciones a la línea --->
		<cfquery name="rsUpdateDetalle" datasource="#session.dsn#">
			update DDocumentosRecepcion
			set DDRobstolerancia = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.DDRobstolerancia#">
				  , DDRobsreclamo = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.DDRobsreclamo#">
				
			where DDRlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DDRlinea#">
		</cfquery>

	<!--- Aprobación de las líneas --->
	<cfelseif form.Opcion eq "AprobarLinea" or form.Opcion eq "RechazarLinea" or form.Opcion eq "AprobarLineasFiltro">
		<cftransaction>
			<!--- 1. Actualiza los valores a las líneas --->
			<cfif form.Opcion eq "AprobarLinea">
				<!--- 1.1. Actualiza el campo de tolerancia aprobada de la línea en modo cambio a aprobado --->
				<cfquery name="rsAprobarLinea" datasource="#session.dsn#">
					update DDocumentosRecepcion
					set DDRaprobtolerancia = 10
					where DDRlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DDRlinea#">
				</cfquery>
				<!--- Verifica si en la linea existen condiciones distintas a la violacion de la tolerancia para que exista el reclamo --->
				<cfif not hayReclamo(form.DDRlinea)>
					<!--- Si no hay limpia el check de reclamo para la linea --->				
					<cfquery name="rsUpdateDetalle" datasource="#session.dsn#">
						update DDocumentosRecepcion
							set DDRgenreclamo = 0
						where DDRlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DDRlinea#">
					</cfquery>				
				</cfif>
			<cfelseif form.Opcion eq "RechazarLinea">
				<!--- 1.1. Actualiza el campo de tolerancia aprobada de la línea en modo cambio a rechazado --->
				<cfquery name="rsAprobarLinea" datasource="#session.dsn#">
					update DDocumentosRecepcion
					set DDRaprobtolerancia = 20
						, DDRgenreclamo = 1
					where DDRlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DDRlinea#">
				</cfquery>			
			</cfif>
			
			<!--- 2. Obtiene la cantidad de líneas que quedan sin aprobar --->
			<cfquery name="rsLineasSinAprobar" datasource="#session.dsn#">
				select 1
				from DDocumentosRecepcion
				where EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
					and DDRaprobtolerancia=5
			</cfquery>
			
			<!--- 3. Si no quedan líneas sin aprobar cambia el estado del documento a tolerancia aprobada --->
			<cfif rsLineasSinAprobar.RecordCount eq 0>			
				<cfquery name="rsUpdateEstadoDocumento" datasource="#session.dsn#">
					update EDocumentosRecepcion
					set EDRestado = 5
					where EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
				</cfquery>				
			</cfif>
			
		</cftransaction>

		<!--- 4. Si no quedan líneas sin aprobar, envía un correo de notificación al usuario que registró la recepción para que la aplique --->
		<cfif rsLineasSinAprobar.RecordCount eq 0>
			
			<cfset resultadoEnvio = "">

			<cfquery name="rsCorreo" datasource="#session.dsn#">
				select distinct dp.Pemail1, dp.Pnombre #_Cat# ' ' #_Cat#  dp.Papellido1 #_Cat# ' ' #_Cat# dp.Papellido2 as Destino,
								edr.Usucodigo, usu.CEcodigo
				from EDocumentosRecepcion edr
					inner join Usuario usu
						on usu.Usucodigo = edr.Usucodigo
						
					inner join DatosPersonales dp
						on dp.datos_personales = usu.datos_personales
						
				where edr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and edr.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
			</cfquery>
			
			<cfinclude template="correoNotificaUsuarioRecepcion.cfm">
			
			<cfif isdefined("rsCorreo") and rsCorreo.RecordCount gt 0 and len(trim(rsCorreo.Pemail1)) gt 0>
				<cfset _contenido_correo = contenidoCorreoUsuarioRecepcion(form.EDRid, rsCorreo.Destino, 2, rsCorreo.Usucodigo, rsCorreo.CEcodigo)>
					
				<cfquery datasource="asp">
					insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
					values (<cfqueryparam cfsqltype="cf_sql_varchar" value="gestion@soin.co.cr">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCorreo.Pemail1#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="Notificación. Sistema de Compras">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#_contenido_correo#">,
							1)
				</cfquery>

				<cfset resultadoEnvio = "El documento fue verificado. La notificación fue enviada al usuario que registró la recepción">
			<cfelse>
				<cfset resultadoEnvio = "El documento fue verificado. El usuario que registró la recepción no cuenta con correo electrónico, no se puede enviar notificación">
			</cfif>
		</cfif>

	</cfif>

	<cfoutput>
	<form action="" method="post" name="formSQL">
		<!--- Si no quedan líneas por aprobar, guarda el resultado del correo que va a ser mostrado al abrir la lista --->
		<cfif isdefined("rsLineasSinAprobar") and rsLineasSinAprobar.RecordCount eq 0>
			<cfif isdefined("resultadoEnvio") and len(trim(resultadoEnvio)) gt 0>
				<input name="resultadoEnvio" type="hidden" value="#resultadoEnvio#">
			</cfif>
		<!--- Si quedan líneas, guarda los filtros, para volver a abrir el documento --->
		<cfelse>
			<input name="EDRid" type="hidden" value="<cfif isdefined("form.EDRid") and len(trim(form.EDRid))>#form.EDRid#</cfif>">
			
			<cfif form.Opcion eq "Modificar">
				<input name="DDRlinea" type="hidden" value="<cfif isdefined("form.DDRlinea") and len(trim(form.DDRlinea))>#form.DDRlinea#</cfif>">

				<cfif isdefined("form.PageNum_lista")>
					<input type="hidden" name="PageNum_lista" value="#form.PageNum_lista#">
				</cfif>
			</cfif>
			
			<cfif isdefined("form.numparteF") and len(trim(form.numparteF)) gt 0>
				<input type="hidden" name="numparteF" value="#form.numparteF#">
			</cfif>
			<cfif isdefined("form.DOalternaF") and len(trim(form.DOalternaF)) gt 0>
				<input type="hidden" name="DOalternaF" value="#form.DOalternaF#">
			</cfif>
			<cfif isdefined("form.DOobservacionesF") and len(trim(form.DOobservacionesF)) gt 0>
				<input type="hidden" name="DOobservacionesF" value="#form.DOobservacionesF#">
			</cfif>
			<cfif isdefined("form.AcodigoF") and len(trim(form.AcodigoF)) gt 0>
				<input type="hidden" name="AcodigoF" value="#form.AcodigoF#">
			</cfif>
			<cfif isdefined("form.DOdescripcionF") and len(trim(form.DOdescripcionF)) gt 0>
				<input type="hidden" name="DOdescripcionF" value="#form.DOdescripcionF#">
			</cfif>
			<cfif isdefined("form.CMCid1")>
				<input type="hidden" name="CMCid1" value="#form.CMCid1#">
			</cfif>
			<cfif isdefined("form.Reclamo") and len(trim(form.Reclamo)) gt 0>
				<input type="hidden" name="Reclamo" value="#form.Reclamo#">
			</cfif>
		</cfif>
	</form>
	</cfoutput>
	
	<html>
		<head></head>
		<body>
			<script language="JavaScript1.2" type="text/javascript">
				<!--- Si ya no quedan líneas por aprobar, regresa a la lista de documentos --->
				<cfif isdefined("rsLineasSinAprobar") and rsLineasSinAprobar.RecordCount eq 0>
					document.forms[0].action = 'docsAprobarExcTolerancia-lista.cfm';
					
				<!--- Si quedan, regresa al documento --->
				<cfelse>
					document.forms[0].action = 'docsAprobarExcTolerancia.cfm';
				</cfif>
				
				document.forms[0].submit();
			</script>
		</body>
	</html>

</cfif>