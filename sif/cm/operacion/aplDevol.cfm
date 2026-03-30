<cftransaction>
	<!--- Afectacion de Orden de Compra--->
	<cfquery datasource="#session.DSN#" name="dataOrden">
		select DDRlinea, DOlinea, DDRcantorigen, DDRgenreclamo
		from DDocumentosRecepcion
		where EDRid=<cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
		  and Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfloop query="dataOrden">
		<cfif dataOrden.DDRcantorigen lte 0 >
			<cfset Request.Error.Backs = 1 >
			<cf_errorCode	code = "50283" msg = "Error al aplicar documento de Recepción.<br>Existen líneas del documento con cantidades en cero.">
			<cfabort>
		</cfif>

		<cfset factor = 0 >

		<cfif trim(form["UcodigoOC_#dataOrden.CurrentRow#"]) neq trim(form["Ucodigo_#dataOrden.CurrentRow#"])>
			<cfquery name="rsConversion" datasource="#session.DSN#">
				select Ucodigo, Ucodigoref, CUfactor 
				from ConversionUnidades 
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Ucodigo = '#trim(form["UcodigoOC_#dataOrden.CurrentRow#"])#'
				and Ucodigoref = '#trim(form["Ucodigo_#dataOrden.CurrentRow#"])#'
			</cfquery>

			<cfif rsConversion.recordCount gt 0 and len(trim(rsConversion.CUfactor))>
				<cfset factor = rsConversion.CUfactor>

			<cfelse>
				<cfquery name="rsConversionArt" datasource="#session.DSN#">
					select distinct a.Aid, b.Adescripcion, b.Ucodigo, c.Ucodigo as Ucodigoref, CUAfactor
					from DDocumentosRecepcion a
					
					inner join Articulos b
					on a.Aid=b.Aid
					
					inner join ConversionUnidadesArt c
					on b.Aid=c.Aid
					
					where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and EDRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
					and a.Aid = #trim(form["Aid_#dataOrden.CurrentRow#"])#
					and b.Ucodigo = '#trim(form["UcodigoOC_#dataOrden.CurrentRow#"])#'
					and c.Ucodigo = '#trim(form["Ucodigo_#dataOrden.CurrentRow#"])#'
				</cfquery>
				<cfif rsConversionArt.recordCount gt 0 and len(trim(rsConversionArt.CUAfactor))>
					<cfset factor = rsConversionArt.CUAfactor>
				</cfif>
			</cfif>	
		<cfelse>
			<cfset factor = 1 >
		</cfif>

		<cfif factor eq 0 >
			<cftransaction action="rollback"/>
			<cfset Request.Error.Backs = 1 >
			<cf_errorCode	code = "50284"
							msg  = "Error al aplicar documento de Recepción.<br>No se encontró el factor de conversión de la unidad @errorDat_1@ a la unidad @errorDat_2@"
							errorDat_1="#form['UcodigoOC_#dataOrden.CurrentRow#']#"
							errorDat_2="#form['Ucodigo_#dataOrden.CurrentRow#']#"
			>
			<cfabort>
		</cfif>

		<cfif dataOrden.DDRgenreclamo eq 0 >
			<cfquery datasource="#session.DSN#">
				update DOrdenCM
				set DOcantsurtida = DOcantsurtida - (#dataOrden.DDRcantorigen#/#factor#)
				where DOlinea=<cfqueryparam value="#dataOrden.DOlinea#" cfsqltype="cf_sql_numeric">
				  and Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
		
		<!--- se guarda la cantidad convertida --->
		<cfquery datasource="#session.DSN#">
			update DDocumentosRecepcion
			set DDRcantordenconv = (#dataOrden.DDRcantorigen#/#factor#)
			where DDRlinea = <cfqueryparam value="#dataOrden.DDRlinea#" cfsqltype="cf_sql_numeric">
			and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfloop>
	
	<!--- Pase a Historicos --->
	<cfquery datasource="#session.DSN#">
		insert into HEDocumentosRecepcion( EDRid, Ecodigo, TDRcodigo, Mcodigo, EDRtc, Aid, CFid, EDRnumero, EDRfechadoc, EDRfecharec, EOidorden, SNcodigo, EDRreferencia, EDRdescpro, EDRimppro, EDRobs, EDRperiodo, EDRmes, HEDRestadoreclamo, idBL, Usucodigo, fechaalta )
		select EDRid, Ecodigo, TDRcodigo, Mcodigo, EDRtc, Aid, CFid, EDRnumero, EDRfechadoc, EDRfecharec, EOidorden, SNcodigo, EDRreferencia, EDRdescpro, EDRimppro, EDRobs, EDRperiodo, EDRmes, 0, idBL, Usucodigo, fechaalta 
		from EDocumentosRecepcion
		where EDRid=<cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
	</cfquery>

	<cfquery datasource="#session.DSN#">
		insert into HDDocumentosRecepcion (DDRlinea, Ecodigo, EDRid, DOlinea, Usucodigo, fechaalta, Aid, Cid, DDRtipoitem, DDRcantrec, DDRcantorigen, DDRpreciou, DDRdesclinea, DDRtotallin, DDRcostopro, DDRcostototal)
		select DDRlinea, Ecodigo, EDRid, DOlinea, Usucodigo, fechaalta, Aid, Cid, DDRtipoitem, DDRcantrec, DDRcantorigen, DDRpreciou, DDRdesclinea, DDRtotallin, DDRcostopro, DDRcostototal
		from DDocumentosRecepcion
		where EDRid=<cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
	</cfquery>

	<!--- recupera alguno de los compradores registrados en la linea--->
	<cfquery name="dataComprador" datasource="#session.DSN#">
		select b.CMCid
		from EDocumentosRecepcion a
		
		inner join EOrdenCM b
		on a.Ecodigo=b.Ecodigo
		   and a.EOidorden=b.EOidorden
		
		where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.EDRid=<cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
	</cfquery>

	<cfquery name="rsGeneraReclamo" datasource="#session.DSN#">
		select *
		from DDocumentosRecepcion
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and DDRgenreclamo=1
		  and EDRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
	</cfquery>	  

	<!--- GENERACION DE RECLAMOS --->
	<cfset hayReclamo = false >
	<cfif rsGeneraReclamo.RecordCount gt 0>
		<!--- Generacion de Reclamos --->
		<cfquery datasource="#session.DSN#" name="selectInsert">
			select  SNcodigo, SNcodigo as SNcodigorec, 
			EDRid, EDRnumero,  
			EDRobs
			from HEDocumentosRecepcion
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and EDRid=<cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfquery datasource="#session.DSN#" name="insert">
			insert into EReclamos (
			Ecodigo, SNcodigo, SNcodigorec, 
			EDRid, CMCid, EDRnumero, EDRfecharec, 
			Usucodigo, fechaalta, ERestado, ERobs
			)
			VALUES(
			   #session.Ecodigo#,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectInsert.SNcodigo#"    	voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectInsert.SNcodigorec#" 	voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectInsert.EDRid#"       	voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#dataComprador.CMCid#"      	voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#selectInsert.EDRnumero#"   	voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp" 		value="#Now()#"						voidNull>,
			   #session.Usucodigo#,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#Now()#"   					voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="0"					    	voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_clob"              value="#selectInsert.ERobs#"       	voidNull>
			)
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>	
		<cf_dbidentity2 datasource="#session.DSN#" name="insert">
		
		<cfquery datasource="#session.DSN#">
			insert into DReclamos(ERid, Ecodigo, DDRlinea, DRcantorig, DRcantrec, DRpreciooc, DRpreciorec, DRfecharec, DRfechacomp, Usucodigo, fechaalta, DRestado, DDRobsreclamo )
			select c.ERid, a.Ecodigo, a.DDRlinea, a.DDRcantorigen, a.DDRcantrec, d.DOpreciou, a.DDRpreciou, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, #session.Usucodigo#, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 10, DDRobsreclamo 
			from HDDocumentosRecepcion a
			
			inner join HEDocumentosRecepcion b
			on a.EDRid=b.EDRid
			and a.Ecodigo=b.Ecodigo
			
			inner join EReclamos c
			on b.EDRid=c.EDRid
			and a.Ecodigo=b.Ecodigo
			
			inner join DOrdenCM d
			on a.DOlinea=d.DOlinea
			
			inner join DDocumentosRecepcion e
			on a.DDRlinea=e.DDRlinea
			
			where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and e.DDRgenreclamo=1
			  and a.EDRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
		</cfquery>
		<cfset hayReclamo = true >
	</cfif>

	<cfif form.tipo eq 'D'>
		<cfquery datasource="#session.DSN#">
			update DDocumentosRecepcion
			set DDRcantrec = DDRcantrec*-1,
				DDRcantorigen = DDRcantorigen*-1,
				DDRcantordenconv = DDRcantordenconv*-1,
				DDRpreciou = DDRpreciou*-1
			where EDRid=<cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
		</cfquery>

		<cfquery datasource="#session.DSN#">
			update HDDocumentosRecepcion
			set DDRcantrec = DDRcantrec*-1,
				DDRcantorigen = DDRcantorigen*-1,
				<!--- DDRcantordenconv = DDRcantordenconv*-1, --->
				DDRpreciou = DDRpreciou*-1
			where EDRid=<cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>
	
	<!--- CAMBIA ESTADO AL DOCUMENTO--->	
	<cfquery datasource="#session.DSN#">
		update EDocumentosRecepcion
		set EDRestado = 10
		where EDRid=<cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
	</cfquery>

</cftransaction>

<!--- INTERFAZ --->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.fnProcesoNuevoSoin(iif(form.tipo eq 'R',101,103),"EDRid=#form.EDRid#","R")>


<!--- ENVIA CORREO AL COMPRADOR, SI HAY RECLAMO --->
<cfif hayReclamo ><!--- reclamo --->
	<cfinclude template="reclamos-correo.cfm">

	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
	<cfset dataUsuario = sec.getUsuarioByRef(dataComprador.CMCid, session.EcodigoSDC, 'CMCompradores') >
	<cfif dataUsuario.recordCount gt 0>
		<cfset pnombre = dataUsuario.Pnombre & ' ' & dataUsuario.Papellido1 & ' ' & dataUsuario.Papellido2 >
		
		<cfset _mailBody  = mailBody(insert.identity, dataUsuario.Usucodigo, pnombre, 1) >
		
		<cfif len(trim(dataUsuario.Pemail1))>
			<cfquery datasource="asp">
				insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
				values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="gestion@soin.co.cr">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#dataUsuario.Pemail1#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="Generación de Reclamo. Sistema de Compras">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#_mailBody#">, 1)
			</cfquery>
		</cfif>
	</cfif>
	
	<!--- ENVIA CORREO AL SOCIO DEL RECLAMO, SI HAY RECLAMO --->
	<cfquery name="rsSocio" datasource="#session.DSN#">
		select SNcodigorec
		from EReclamos
		where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insert.identity#">
	</cfquery>
	<cfset dataSocio = sec.getUsuarioByRef(rsSocio.SNcodigorec, session.EcodigoSDC, 'SNegocios') >
	<cfif dataSocio.recordCount gt 0>
		<cfset SNnombre = dataSocio.Pnombre & ' ' & dataSocio.Papellido1 & ' ' & dataSocio.Papellido2 >
		<cfset _mailBody  = mailBody(insert.identity, dataSocio.Usucodigo, SNnombre, 0) >
		
		<cfif len(trim(dataSocio.Pemail1))>
			<cfquery datasource="asp">
				insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
				values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="gestion@soin.co.cr">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#dataSocio.Pemail1#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="Generación de Reclamo. Sistema de Compras">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#_mailBody#">, 1)
			</cfquery>
		</cfif>
	</cfif>
</cfif><!--- reclamo --->

