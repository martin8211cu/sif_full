<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfif form.tipo eq 'R'>
	<cfparam name="action" default="documentos.cfm">
<cfelse>
	<cfparam name="action" default="devolucion.cfm">
</cfif>
<cfinclude template="reclamos-correo.cfm">

<!--- Maximos digitos para el numero del doc de recepcion --->
<cfquery name="rsMaxDig" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="720">
</cfquery>

<cfif not isdefined("form.btnNuevoD")>
		<cfif isdefined("form.btnNotificar")>
			<cfset msg = "">
			<cfinclude template="Notifica-correo.cfm">
			<cfif isdefined("form.CFid") and len(trim(form.CFid))>
				<cfquery name="rsCorreos" datasource="#session.DSN#">
					select distinct dp.Pemail1, dp.Pnombre #_Cat# ' ' #_Cat#  dp.Papellido1 #_Cat# ' ' #_Cat# dp.Papellido2 as Destino
					from EDocumentosRecepcion e
						inner join CFuncional cf
							on e.CFid = cf.CFid
						inner join Usuario u
							on u.Usucodigo = cf.CFuresponsable
						inner join DatosPersonales dp
							on dp.datos_personales = u.datos_personales
							and coalesce(rtrim(dp.Pemail1),'') <> ''
						inner join DDocumentosRecepcion a
							on a.EDRid = e.EDRid
							and a.DDRtipoitem = 'A'		
							and a.Aid is not null
					where e.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and e.EDRid = <cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
					order by dp.Pemail1
				</cfquery>
				<cfif isdefined('rsCorreos') and rsCorreos.RecordCount GT 0>
					<cfloop query="rsCorreos">
						<cfset _mailBody  = mailBody(form.EDRid,rsCorreos.Destino, 0)>
						<cfif len(trim(rsCorreos.Pemail1))>
							<cfquery datasource="asp">
								insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
								values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="gestion@soin.co.cr">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCorreos.Pemail1#">,  
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="Notificación. Sistema de Compras">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#_mailBody#">, 1)
							</cfquery>
						</cfif>
					</cfloop>
					<cfset msg = "La notificación fue enviada a el responsable del centro funcional">
				<cfelse>
					<cfset msg = "El responsable del centro funcional no cuenta con correo electrónico, no se puede enviar notificación">
				</cfif>
			<cfelse>
				<cfquery name="rsCorreosAL" datasource="#session.DSN#">
					select distinct dp.Pemail1,
									dp.Pnombre #_Cat# ' ' #_Cat#  dp.Papellido1 #_Cat# ' ' #_Cat# dp.Papellido2 as Destino
					from DDocumentosRecepcion a
						inner join EDocumentosRecepcion e
							on a.EDRid = e.EDRid 
							and a.Ecodigo = e.Ecodigo
						inner join AResponsables ar
							on e.Aid = ar.Aid
							and e.Ecodigo = ar.Ecodigo
						inner join Usuario u			
							on u.Usucodigo = ar.Usucodigo
						inner join DatosPersonales dp
							on dp.datos_personales = u.datos_personales
					where a.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and a.EDRid = <cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
						and a.Aid is not null
						and a.DDRtipoitem = 'A'
					order by dp.Pemail1				
				</cfquery>
				<cfif isdefined('rsCorreosAL') and rsCorreosAL.recordCount GT 0>
					<cfloop query="rsCorreosAL">
						<cfset _mailBody  = mailBody(form.EDRid,rsCorreosAL.Destino, 1)> 
						<cfif len(trim(rsCorreosAL.Pemail1))>
							<cfquery datasource="asp">
								insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
								values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="gestion@soin.co.cr">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCorreosAL.Pemail1#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="Notificación. Sistema de Compras">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#_mailBody#">, 1)
							</cfquery>
						</cfif>
					</cfloop>

					<cfset msg = "La notificación fue enviada a el o los responsables del almacén">
				<cfelse>
					<cfset msg = "El o los responsable(s) del almacén no cuenta con correo electrónico, no se puede enviar notificación">
				</cfif>						
			</cfif>
		</cfif>
		<!--- Caso 1: Agregar Encabezado --->
		<cfif isdefined("form.btnAgregarE")>
			<cfif isdefined('rsMaxDig') and rsMaxDig.recordCount GT 0 and rsMaxDig.Pvalor NEQ '' and Len(Trim(form.EDRnumero)) LT rsMaxDig.Pvalor>
				<cfset numDoc = RepeatString('0', rsMaxDig.Pvalor - (Len(Trim(form.EDRnumero)))) & Trim(form.EDRnumero)>
			<cfelse>
				<cfset numDoc = Trim(form.EDRnumero)>
			</cfif>
		
			<cfquery name="rsNumero" datasource="#session.DSN#">
				Select EDRnumero
				from EDocumentosRecepcion
				where Ecodigo=<cfqueryparam value="#session.Ecodigo#" 		cfsqltype="cf_sql_integer">					
					and EDRnumero=<cfqueryparam value="#numDoc#"  			cfsqltype="cf_sql_varchar">
					and SNcodigo=<cfqueryparam value="#form.SNcodigo#"		cfsqltype="cf_sql_numeric" >
			</cfquery>
		
			<cfif isdefined('rsNumero') and rsNumero.recordCount GT 0>
				<cf_errorCode	code = "50295" msg = "El número del documento de recepción recientemente ingresado ya existe en la base de datos, favor digitar uno diferente.">
			<cfelse>
				<cftransaction>				
					<cfquery name="insert" datasource="#session.DSN#" >
						insert into EDocumentosRecepcion( Ecodigo, TDRcodigo, Mcodigo, EDRtc, Aid, CFid, CPTcodigo, EDRnumero, EDRfechadoc, EDRfecharec, EOidorden, SNcodigo, EDRreferencia, Usucodigo, fechaalta, EDRdescpro, EDRimppro, EDRobs, EDRperiodo, EDRmes, EDRestado )
									 values ( <cfqueryparam value="#session.Ecodigo#" 	cfsqltype="cf_sql_integer">,
											  <cfqueryparam value="#form.TDRcodigo#"  			cfsqltype="cf_sql_varchar">, 
											  <cfqueryparam value="#form.Mcodigo#" 		cfsqltype="cf_sql_numeric">, 
											  <cfqueryparam value="#form.EDRtc#" 		cfsqltype="cf_sql_float">,
											  <cfif isdefined("form.Aid") and len(trim(form.Aid))><cfqueryparam value="#form.Aid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>, 
											  <cfif isdefined("form.CFid") and len(trim(form.CFid))><cfqueryparam value="#form.CFid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>, 
											  <cfqueryparam value="#form.CPTcodigo#"  	cfsqltype="cf_sql_varchar">,
											  <cfqueryparam value="#numDoc#"  	cfsqltype="cf_sql_varchar">,
											  <cfqueryparam value="#LSParseDateTime(form.EDRfechadoc)#" cfsqltype="cf_sql_timestamp">,
											  <cfqueryparam value="#LSParseDateTime(form.EDRfecharec)#" cfsqltype="cf_sql_timestamp">,
											  <cfqueryparam value="#form.EOidorden#" cfsqltype="cf_sql_numeric">, 
											  <cfqueryparam value="#form.SNcodigo#" 	cfsqltype="cf_sql_integer">,
											  <cfif len(form.EDRreferencia) gt 25><cfqueryparam value="#mid(form.EDRreferencia,1,25)#" cfsqltype="cf_sql_varchar"><cfelse><cfqueryparam value="#form.EDRreferencia#" cfsqltype="cf_sql_varchar"></cfif>,
											  <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
											  <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
											  <cfqueryparam value="#Replace(form.EDRdescpro,',','','all')#" cfsqltype="cf_sql_money">,
											  <cfqueryparam value="#Replace(form.EDRimppro,',','','all')#" cfsqltype="cf_sql_money">,
											  <cfqueryparam value="#form.EDRobs#"  	cfsqltype="cf_sql_longvarchar">, 
											  <cfqueryparam value="#Replace(form.EDRperiodo,',','','all')#" 	cfsqltype="cf_sql_integer">,
											  <cfqueryparam value="#form.EDRmes#" 	cfsqltype="cf_sql_integer">,
											  0 )
						<cf_dbidentity1 datasource="#session.DSN#">
					</cfquery>	
					<cf_dbidentity2 datasource="#session.DSN#" name="insert">

				</cftransaction>
			</cfif>

			<cfset modo="CAMBIO">
		</cfif>				
		<!--- Caso 2: Borrar un Encabezado de Requisicion --->
		<cfif isdefined("form.btnBorrarE")>
			<cfquery name="deleted" datasource="#session.DSN#" >
				delete from DDocumentosRecepcion
				where EDRid = <cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
				  and Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery>	  
			<cfquery name="delete" datasource="#session.DSN#" >
				delete from EDocumentosRecepcion
				where EDRid = <cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
				  and Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery>	  
			<cfset modo="ALTA">

			<cfif form.tipo eq 'R'>
				<cfset action = 'documentos-lista.cfm' >
			<cfelse>
				<cfset action = 'devolucion-lista.cfm' >
			</cfif>
		</cfif>
		<cfif isdefined("form.btnModificarE")>
			<cfif isdefined('rsMaxDig') and rsMaxDig.recordCount GT 0 and rsMaxDig.Pvalor NEQ '' and Len(Trim(form.EDRnumero)) LT rsMaxDig.Pvalor>
				<cfset numDoc = RepeatString('0', rsMaxDig.Pvalor - (Len(Trim(form.EDRnumero)))) & Trim(form.EDRnumero)>
			<cfelse>
				<cfset numDoc = Trim(form.EDRnumero)>
			</cfif>
					
			<cfquery name="rsNumero" datasource="#session.DSN#">
				Select EDRnumero
				from EDocumentosRecepcion
				where Ecodigo=<cfqueryparam value="#session.Ecodigo#" 		cfsqltype="cf_sql_integer">					
					and EDRnumero=<cfqueryparam value="#numDoc#"  			cfsqltype="cf_sql_varchar">
					and SNcodigo=<cfqueryparam value="#form.SNcodigo#"		cfsqltype="cf_sql_numeric" >
					and EDRid not in (<cfqueryparam value="#form.EDRid#" 	cfsqltype="cf_sql_numeric">)					
			</cfquery>				
		
			<cfif isdefined('rsNumero') and rsNumero.recordCount GT 0>
				<cf_errorCode	code = "50295" msg = "El número del documento de recepción recientemente ingresado ya existe en la base de datos, favor digitar uno diferente.">
			<cfelse>
				<cf_dbtimestamp datasource="#session.dsn#"
								table="EDocumentosRecepcion"
								redirect="documentos-lista.cfm"
								timestamp="#form.ts_rversion#"
								field1="EDRid" 
								type1="numeric" 
								value1="#form.EDRid#"
								field2="Ecodigo" 
								type2="integer" 
								value2="#session.Ecodigo#" >
				<cfquery name="update" datasource="#session.DSN#">
					update EDocumentosRecepcion
					set TDRcodigo   = <cfqueryparam value="#form.TDRcodigo#"  	cfsqltype="cf_sql_varchar">, 
						Mcodigo     = <cfqueryparam value="#form.Mcodigo#" cfsqltype="cf_sql_numeric">, 
						<cfif isdefined("form.EDRtc") and len(trim(form.EDRtc)) gt 0>
						EDRtc       = <cfqueryparam value="#form.EDRtc#" cfsqltype="cf_sql_float">,
						</cfif>
						CPTcodigo   =	<cfqueryparam value="#form.CPTcodigo#"  	cfsqltype="cf_sql_varchar">,
						EDRnumero	= <cfqueryparam value="#numDoc#"  	cfsqltype="cf_sql_varchar">,
						EDRfechadoc = 	<cfqueryparam value="#LSParseDateTime(form.EDRfechadoc)#" cfsqltype="cf_sql_timestamp">,
						EDRfecharec = 	<cfqueryparam value="#LSParseDateTime(form.EDRfecharec)#" cfsqltype="cf_sql_timestamp">,
						EDRreferencia = <cfqueryparam value="#form.EDRreferencia#"  	cfsqltype="cf_sql_varchar">,
						EDRdescpro = <cfqueryparam value="#Replace(form.EDRdescpro,',','','all')#" cfsqltype="cf_sql_money">,
						EDRimppro = <cfqueryparam value="#Replace(form.EDRimppro,',','','all')#" cfsqltype="cf_sql_money">,
						<cfif (isdefined("form.Aid") and len(trim(form.Aid)) gt 0) or (isdefined("form.CFid") and len(trim(form.CFid)) gt 0)>
						Aid = <cfif isdefined("form.Aid") and len(trim(form.Aid))><cfqueryparam value="#form.Aid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
						CFid = <cfif isdefined("form.CFid") and len(trim(form.CFid))><cfqueryparam value="#form.CFid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
						</cfif>
						EDRobs = <cfqueryparam value="#form.EDRobs#" cfsqltype="cf_sql_longvarchar">
					where EDRid = <cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
					  and Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>

			<cfset modo="CAMBIO">
		</cfif>	
<!---===================MODIFICAR UNA LINEA DE DETALLE==================--->			
<cfif isdefined("form.btnModificar") and not isdefined('form.chk')>	
	<cfif isdefined("form.DDRgenreclamo") and form.tipo eq 'R'>
        <cfset reclamo = Replace(form.DDRcantorigen,',','','all') - Replace(form.DDRcantrec,',','','all')>
    <cfelse>
        <cfset reclamo = 0 >
    </cfif>
	<!---- Obtener el porcentaje de impuesto ---->
    <cfquery name="rsImpuesto" datasource="#session.DSN#">
        select Iporcentaje 
         from Impuestos
        where Ecodigo = #session.Ecodigo#
          and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">					
    </cfquery>			
	<!--- Calculo del factor de conversion --->
	<cfset factor = 0 >
	<cfif isdefined('form.Aid') and len(trim(form.Aid))>
		<cfif trim(form.UcodigoOC) neq trim(form.Ucodigo)>
            <cfquery name="rsConversion" datasource="#session.DSN#">
                select Ucodigo, Ucodigoref, CUfactor 
                  from ConversionUnidades 
                where Ecodigo	 = #session.Ecodigo#
                  and Ucodigo 	 = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.UcodigoOC)#">
                  and Ucodigoref = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.Ucodigo)#">
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
                    where a.Ecodigo	= #session.Ecodigo#
                      and EDRid		= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.EDRid#">
                      and a.Aid 	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#trim(form.Aid)#">
                      and b.Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" 	value="#trim(form.UcodigoOC)#">
                      and c.Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" 	value="#trim(form.Ucodigo)#">
                </cfquery>
                <cfif rsConversionArt.recordCount gt 0 and len(trim(rsConversionArt.CUAfactor))>
                    <cfset factor = rsConversionArt.CUAfactor>
                </cfif>
			</cfif>	
		<cfelse>
			<cfset factor = 1 >
		</cfif>
	<cfelse>
			<cfset factor = 1 >
	</cfif>
	<cfif factor eq 0 >
        <cf_errorCode	code = "50296"
                        msg  = "Error al modificar el documento de Recepción.<br>No se encontró el factor de conversión de la unidad @errorDat_1@ a la unidad @errorDat_2@"
                        errorDat_1="#form.UcodigoOC#"
                        errorDat_2="#form.Ucodigo#"
        >
    </cfif>
     <cfif NOT ISDEFINED("form.DDRobsreclamo") OR NOT LEN(TRIM(form.DDRobsreclamo))>
     	<cfset form.DDRobsreclamo = "">
     </cfif>
     <cfif NOT ISDEFINED("form.Icodigo") OR NOT LEN(TRIM(form.Icodigo))>
     	<cfset form.Icodigo = "">
     </cfif>
     <cfif NOT ISDEFINED('rsImpuesto') OR rsImpuesto.recordCount EQ 0>
        <cfset DDRimptoporclin = "">
    </cfif>
    <!---Se modifica la linea--->
	<cfquery datasource="#session.DSN#">
		update DDocumentosRecepcion set 
        	DDRcantorigen 	 = <cf_jdbcquery_param cfsqltype="cf_sql_float" 	  value="#Replace(form.DDRcantorigen,',','','all')#">,
            Ucodigo 		 = <cf_jdbcquery_param cfsqltype="cf_sql_char" 		  value="#form.Ucodigo#">,
            DDRdescporclin 	 = <cf_jdbcquery_param cfsqltype="cf_sql_float" 	  value="#Replace(form.DDRdescporclin,',','','all')#">, 
			DDRdesclinea 	 = <cf_jdbcquery_param cfsqltype="cf_sql_money" 	  value="#Replace(form.DDRdesclinea,',','','all')#">, 
			DDRtotallincd 	 = <cf_jdbcquery_param cfsqltype="cf_sql_money" 	  value="#Replace(form.DDRtotallincd,',','','all')#">, 
			DDRmtoimpfact 	 = <cf_jdbcquery_param cfsqltype="cf_sql_money" 	  value="#Replace(form.DDRmtoimpfact,',','','all')#">,
			DDRcantrec 		 = <cf_jdbcquery_param cfsqltype="cf_sql_float"    	  value="#Replace(DDRcantrec,',','','all')#">,
            DDRobsreclamo    = <cf_jdbcquery_param cfsqltype="cf_sql_longvarchar" value="#form.DDRobsreclamo#" voidnull>,
            Icodigo 		 = <cf_jdbcquery_param cfsqltype="cf_sql_char" 		  value="#form.Icodigo#" voidnull>,
            DDRimptoporclin  = <cf_jdbcquery_param cfsqltype="cf_sql_float" 	  value="#Replace(rsImpuesto.Iporcentaje,',','','all')#" voidnull>,
			DDRcantordenconv = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	  value="#Replace(form.DDRcantorigen,',','','all')/factor#">
			<cfif not isdefined('form.EPDid')>
                ,DDRtotallin = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.DDRtotallin,',','','all')#">
                ,DDRpreciou = #LvarOBJ_PrecioU.enCF(Replace(form.DDRpreciou,',','','all'))#
            </cfif>
		where Ecodigo  = #session.Ecodigo#
		  and DDRlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.DDRlinea)#">
	</cfquery>
		<!---- Update del monto total de los impuestos de todas las líneas en el encabezado ----->
        <cfif isdefined('form.totImpuestos') and form.totImpuestos NEQ ''>
            <cfquery datasource="#session.DSN#">
                Update EDocumentosRecepcion
                    set EDRimppro  = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.totImpuestos,',','','all')#">,
                        EDRdescpro = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.totDescuentos,',','','all')#">
                where Ecodigo = #session.Ecodigo#
                  and EDRid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
            </cfquery>			
        </cfif>
        <cfinclude template="docum-funciones.cfm">
        <cfset MontoReclamo = CalculoReclamoAuto(session.dsn,session.Ecodigo,form.EDRid,form.DDRlinea)>
        <cfif MontoReclamo GT 0 and form.tipo EQ 'R' >
     		<cfset DDRcantrec = form.DDRcantrec>
    	 <cfelse>
     		<cfset DDRcantrec = 0>
     	</cfif>
            <cfquery datasource="#session.DSN#">
                update DDocumentosRecepcion set
                    <cfif MontoReclamo GT 0>
                         DDRgenreclamo = 1,
                     <cfelse>
                        DDRgenreclamo = 0,
                     </cfif>
                        DDRcantreclamo = <cf_jdbcquery_param cfsqltype="cf_sql_float" value="#reclamo#" voidnull>
                  where Ecodigo  = #session.Ecodigo#
                    and DDRlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.DDRlinea)#">
            </cfquery>	
</cfif>
<!---►►►APLICACIÓN DEL DOCUMENTO DE RECEPCIÓN◄◄◄--->		
		<cfif isdefined("Form.btnAplicar")>
			<cfif form.tipo eq 'R'>
				<cfset action = 'documentos-lista.cfm' >
			<cfelse>
				<cfset action = 'devolucion-lista.cfm' >
			</cfif>

			<cfinclude template="docum-funciones.cfm">			
			<cfinclude template="correoNotificaCompradorRecepcion.cfm">
			<cfinclude template="correoNotificaUsuarioRecepcion.cfm">
			
            <!---►►Aplicacion desde la lista, por ahora se quito la funcionalidad, ya que la logica esta replicada y no hacen lo mismo, hay que sacarlo a componente, desde dentro del Documento esta la logica Correcta◄◄--->
			<cfif isdefined("form.chk") and form.chk NEQ ''>
            	<cf_dump var="Realice la aplicación desde dentro del Documento">
				<cfloop list="#form.chk#" index="pkEDRid">
					<cfinclude template="aplicaDocumRecepcCHK.cfm">
				</cfloop>
			<!---►►Aplicacion desde dentro de un Documento de Recepcion◄◄--->
            <cfelse>
				<!---►►Actualizacion de los Impuestos y Descuentos◄◄--->
				<cfquery datasource="#session.DSN#">
					Update EDocumentosRecepcion
						set EDRimppro  = <cfqueryparam value="#Replace(form.EDRimppro,',','','all')#"  cfsqltype="cf_sql_money">,
							EDRdescpro = <cfqueryparam value="#Replace(form.EDRdescpro,',','','all')#" cfsqltype="cf_sql_money">
					where Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and EDRid   = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#form.EDRid#">
				</cfquery>						
				<cfinclude template="aplicaDocumRecepc.cfm">
			</cfif>

		<cfelseif isdefined("Form.btnAgregarLinea")>
			<!--- Ahora no se utiliza porque se agrega directamente del Conlis --->
			<cfquery name="verifpoliza" datasource="#session.DSN#" maxrows="1">
				select #LvarOBJ_PrecioU.enSQL_AS("round(DPDvalordeclarado / DPDcantidad", "ValorUnitario")#
				from DPolizaDesalmacenaje 
				where DOlinea = <cfqueryparam value="#form.DOlinea#" cfsqltype="cf_sql_numeric">
				  and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfif verifpoliza.recordcount GT 0 and verifpoliza.ValorUnitario GT 0.0000>
				<cfset costounitario = LvarOBJ_PrecioU.enCF(verifpoliza.ValorUnitario)>
			<cfelse>
				<cfset costounitario = LvarOBJ_PrecioU.enCF(0)>
			</cfif>

			<!--- inserta detalles de la orden de compra seleccionada --->
			<cfquery name="insertd" datasource="#session.DSN#">
				insert into DDocumentosRecepcion(
						Ecodigo, EDRid, DOlinea, Usucodigo, 
						fechaalta, DDRtipoitem, Aid, Cid, 
						DDRcantrec, DDRcantorigen, DDRcantreclamo, 
						DDRpreciou, DDRprecioorig, DDRdesclinea, 
						DDRtotallin, DDRcostopro, DDRcostototal, DDRgenreclamo, Ucodigo, Icodigo)
				select 	#session.Ecodigo#, 
						#form.EDRid#, 
						do.DOlinea, 
						#session.Usucodigo#, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						do.CMtipo, 
						do.Aid, 
						do.Cid,
						0, 
						0, 
						0,
						#LvarOBJ_PrecioU.enCF(costounitario)#,
						<cfif costounitario NEQ 0.00>
							#LvarOBJ_PrecioU.enCF(costounitario)#,
						<cfelse>
							#LvarOBJ_PrecioU.enSQL_AS("do.DOpreciou")#,
						</cfif>
						EOdesc*(DOtotal+DOtotal*Iporcentaje/100)/(EOtotal+EOdesc),
						round(
						(do.DOcantidad - do.DOcantsurtida) * 
						<cfif costounitario NEQ 0.00>
							#costounitario#
						<cfelse>
							do.DOpreciou
						</cfif>,2)
						, 
						0, 0, 0,
						do.Ucodigo,
						do.Icodigo
				from DOrdenCM do 
					inner join EOrdenCM eo 
                    	on eo.EOidorden = do.EOidorden 
                        
					inner join Impuestos i 
                    	on do.Icodigo  = i.Icodigo 
                        and do.Ecodigo = <cfqueryparam value="#session.Ecodigo#" 	cfsqltype="cf_sql_integer">		
				where do.DOlinea = <cfqueryparam value="#form.DOlinea#" cfsqltype="cf_sql_numeric">
				  and do.DOcantsurtida < do.DOcantidad
				  and do.DOlinea not in(select DOlinea 
                  							from DDocumentosRecepcion a 
                                       			inner join EDocumentosRecepcion b 
                                            		inner join TipoDocumentoR c 
                                            			on b.TDRcodigo = c.TDRcodigo 
                                            		   and b.Ecodigo   = c.Ecodigo 
                                            		   and c.TDRtipo   = 'R'
                                        		 on a.EDRid   = b.EDRid 
                                        		and a.Ecodigo = b.Ecodigo 
                                        		and b.EDRestado < 10
                                    		where a.DOlinea = do.DOlinea)
			</cfquery>
		</cfif>

		<!--- Elimina linea de detalle o actualiza los montos del encabezado si se modifico una linea --->
		<cfif isdefined('form.btnBorrarD') or (isdefined('form.btnModificar') and not isdefined('form.chk'))>
			<cfif isdefined('form.btnBorrarD')>
				<cfquery datasource="#session.DSN#">
					delete from DDocumentosRecepcion
					where EDRid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
					  and DDRlinea	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DDRlinea#">
				</cfquery>
				
				<!--- Actualización del campo "EOidorden" con la orden que tenga el mayor plazo --->
				<cfquery name="rsOrdenMaxPlazo" datasource="#session.dsn#">
					select distinct eo.EOidorden
					from DDocumentosRecepcion ddr
						inner join DOrdenCM do
							on do.DOlinea = ddr.DOlinea
							
						inner join EOrdenCM eo
							on eo.EOidorden = do.EOidorden
							
					where ddr.EDRid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
					  and ddr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and eo.EOplazo  = (select max(eo1.EOplazo)
											from DDocumentosRecepcion ddr1
												inner join DOrdenCM do1
													on do1.DOlinea = ddr1.DOlinea
												inner join EOrdenCM eo1
													on eo1.EOidorden = do1.EOidorden
											where ddr1.EDRid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
										  	  and ddr1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
				</cfquery>
				
				<cfquery name="rsUpdateOrdenEncabezado" datasource="#session.dsn#">
					update EDocumentosRecepcion
						<cfif rsOrdenMaxPlazo.RecordCount eq 0 or len(trim(rsOrdenMaxPlazo.EOidorden)) eq 0>
						set EOidorden = 1
						<cfelse>
						set EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOrdenMaxPlazo.EOidorden#">
						</cfif>
					where EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
			</cfif>
			
			<cfquery name="rsTotales" datasource="#session.DSN#">
				Select 
					coalesce(sum(DDRdesclinea),0) as desDoc,
					coalesce(sum((DDRtotallincd  *  coalesce(i.Iporcentaje,i2.Iporcentaje,0) )/100),0) as sumImpuestoCD
				
				from DDocumentosRecepcion a
						inner join DOrdenCM b
							on a.DOlinea = b.DOlinea
				
						left outer join Impuestos i
							 on i.Ecodigo = a.Ecodigo
							and i.Icodigo = a.Icodigo			
				
						inner join Impuestos i2
							 on i2.Ecodigo = a.Ecodigo
							and i2.Icodigo = b.Icodigo	
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and EDRid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
			</cfquery>

			<cfif isdefined('rsTotales') and rsTotales.recordCount GT 0>
                <cfquery datasource="#session.DSN#">
                    Update EDocumentosRecepcion set 
                            EDRimppro = <cfqueryparam value="#rsTotales.sumImpuestoCD#" cfsqltype="cf_sql_money">,
                            EDRdescpro = <cfqueryparam value="#rsTotales.desDoc#" cfsqltype="cf_sql_money">
                    where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                        and EDRid = <cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
                </cfquery>
			</cfif>
		</cfif>
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="EDRid" type="hidden" value="<cfif isdefined("form.EDRid") and len(trim(form.EDRid))>#form.EDRid#<cfelseif isdefined("insert")>#insert.identity#</cfif>">
	<input name="DDRlinea" type="hidden" value="<cfif isdefined("form.DDRlinea") and len(trim(form.DDRlinea))>#form.DDRlinea#</cfif>">	
	<cfif isdefined("form.DOlinea") and len(trim(form.DOlinea)) and not isdefined('form.btnBorrarD')>
		<input name="DOlinea" type="hidden" value="#form.DOlinea#">		
	</cfif>
	<cfif isdefined("form.Aid") and len(trim(form.Aid))>
		<input type="hidden" name="Aid" value="#form.Aid#">		
	</cfif>	
	<cfif isdefined("form.btnNotificar")>
		<input type="hidden" name="msg" value="#msg#">		
	</cfif>		
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
	<input name="tipo" type="hidden" value="#form.tipo#">
</form>
</cfoutput>

<html><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></html>

