<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfif form.tipo eq 'R'>
	<cfparam name="action" default="documentos.cfm">
<cfelse>
	<cfparam name="action" default="devolucion.cfm">
</cfif>

<cfif not isdefined("form.btnNuevoD")>
	<!---<cftry>--->
		<!--- Caso 1: Agregar Encabezado --->
		
		<cfif isdefined("form.btnAgregarE")>
			<cftransaction>
				<cfquery name="insert" datasource="#session.DSN#" >
					insert into EDocumentosRecepcion( Ecodigo, TDRcodigo, Mcodigo, EDRtc, Aid, CFid, CPTcodigo, EDRnumero, EDRfechadoc, EDRfecharec, EOidorden, SNcodigo, EDRreferencia, Usucodigo, fechaalta, EDRdescpro, EDRimppro, EDRobs, EDRperiodo, EDRmes, EDRestado )
								 values ( #session.Ecodigo#,
										  <cfqueryparam value="#form.TDRcodigo#"  	cfsqltype="cf_sql_varchar">, 
										  <cfqueryparam value="#form.Mcodigo#" cfsqltype="cf_sql_numeric">, 
										  <cfqueryparam value="#form.EDRtc#" cfsqltype="cf_sql_float">,
										  <cfif isdefined("form.Aid") and len(trim(form.Aid))><cfqueryparam value="#form.Aid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>, 
										  <cfif isdefined("form.CFid") and len(trim(form.CFid))><cfqueryparam value="#form.CFid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>, 
										  <cfqueryparam value="#form.CPTcodigo#"  	cfsqltype="cf_sql_varchar">,
										  <cfqueryparam value="#form.EDRnumero#"  	cfsqltype="cf_sql_varchar">,
										  <cfqueryparam value="#LSParseDateTime(form.EDRfechadoc)#" cfsqltype="cf_sql_timestamp">,
										  <cfqueryparam value="#LSParseDateTime(form.EDRfecharec)#" cfsqltype="cf_sql_timestamp">,
										  <cfqueryparam value="#form.EOidorden#" cfsqltype="cf_sql_numeric">, 
										  <cfqueryparam value="#form.SNcodigo#" 	cfsqltype="cf_sql_integer">,
										  <cfif len(form.EDRreferencia) gt 25><cfqueryparam value="#mid(form.EDRreferencia,1,25)#" cfsqltype="cf_sql_varchar"><cfelse><cfqueryparam value="#form.EDRreferencia#" cfsqltype="cf_sql_varchar"></cfif>,
										  #session.Usucodigo#,
										  <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
										  <cfqueryparam value="#form.EDRdescpro#" cfsqltype="cf_sql_money">,
										  <cfqueryparam value="#form.EDRimppro#" cfsqltype="cf_sql_money">,
										  <cfqueryparam value="#form.EDRobs#"  	cfsqltype="cf_sql_longvarchar">, 
										  <cfqueryparam value="#form.EDRperiodo#" 	cfsqltype="cf_sql_integer">,
										  <cfqueryparam value="#form.EDRmes#" 	cfsqltype="cf_sql_integer">,
										  0 )
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>	
				<cf_dbidentity2 datasource="#session.DSN#" name="insert">
				
				<!--- inserta detalles de la orden de compra seleccionada --->
				<cfquery name="insertd" datasource="#session.DSN#">
					insert into DDocumentosRecepcion(Ecodigo, EDRid, DOlinea, Usucodigo, fechaalta, DDRtipoitem, Aid, Cid, DDRcantrec, DDRcantorigen, DDRcantreclamo, DDRpreciou, DDRprecioorig, DDRdesclinea, DDRtotallin, DDRcostopro, DDRcostototal, DDRgenreclamo, Ucodigo)
					select 	#session.Ecodigo#, 
							#insert.identity#, 
							DOlinea, 
							#session.Usucodigo#, 
							<cf_dbfunction name="now">,
							CMtipo, 
							Aid, 
							Cid,
							DOcantsurtida, 
							DOcantsurtida, 
							0,
							0,
							DOpreciou,
							0, 
							round(DOcantsurtida*DOpreciou,2), 
							0, 0, 0,
							Ucodigo
					from DOrdenCM
					where Ecodigo=#session.Ecodigo#
					  and EOidorden=<cfqueryparam value="#form.EOidorden#" cfsqltype="cf_sql_numeric">
					  and DOcantsurtida > 0
					  and DOlinea not in 
						(
							select DOlinea from DDocumentosRecepcion a inner join EDocumentosRecepcion b 
							inner join TipoDocumentoR c on b.TDRcodigo = c.TDRcodigo and b.Ecodigo = c.Ecodigo and c.TDRtipo = 'D'
							on a.EDRid = b.EDRid and a.Ecodigo = b.Ecodigo and b.EDRestado < 10
							where a.Ecodigo = DOrdenCM.Ecodigo and a.DOlinea = DOrdenCM.DOlinea
						)
				</cfquery>
			</cftransaction>

			<cfset modo="CAMBIO">
		</cfif>				
			
		<!--- Caso 2: Borrar un Encabezado de Requisicion --->
		<cfif isdefined("form.btnBorrarE")>
			<cfquery name="deleted" datasource="#session.DSN#" >
				delete from DDocumentosRecepcion
				where EDRid = <cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
				  and Ecodigo=#session.Ecodigo#
			</cfquery>	  
			<cfquery name="delete" datasource="#session.DSN#" >
				delete from EDocumentosRecepcion
				where EDRid = <cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
				  and Ecodigo=#session.Ecodigo#
			</cfquery>	  
			<cfset modo="ALTA">

			<cfif form.tipo eq 'R'>
				<cfset action = 'documentos-lista.cfm' >
			<cfelse>
				<cfset action = 'devolucion-lista.cfm' >
			</cfif>

		</cfif>
			  
		<cfif isdefined("form.btnModificar")>
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
						EDRtc       = <cfqueryparam value="#form.EDRtc#" cfsqltype="cf_sql_float">,
						CPTcodigo   =	<cfqueryparam value="#form.CPTcodigo#"  	cfsqltype="cf_sql_varchar">,
						EDRnumero   = <cfqueryparam value="#form.EDRnumero#"  	cfsqltype="cf_sql_varchar">,
						EDRfechadoc = 	<cfqueryparam value="#LSParseDateTime(form.EDRfechadoc)#" cfsqltype="cf_sql_timestamp">,
						EDRfecharec = 	<cfqueryparam value="#LSParseDateTime(form.EDRfecharec)#" cfsqltype="cf_sql_timestamp">,
						EDRreferencia = <cfqueryparam value="#form.EDRreferencia#"  	cfsqltype="cf_sql_varchar">,
						EDRdescpro = <cfqueryparam value="#form.EDRdescpro#" cfsqltype="cf_sql_money">,
						EDRimppro = <cfqueryparam value="#form.EDRimppro#" cfsqltype="cf_sql_money">,
						EDRobs = <cfqueryparam value="#form.EDRobs#" cfsqltype="cf_sql_longvarchar">,
						Aid    = <cfif isdefined("form.Aid") and len(trim(form.Aid))><cfqueryparam value="#form.Aid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
						CFid    = <cfif isdefined("form.CFid") and len(trim(form.CFid))><cfqueryparam value="#form.CFid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>
					where EDRid = <cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
					  and Ecodigo=#session.Ecodigo#
				</cfquery>

			<cfset modo="CAMBIO">
		</cfif>	

		<cfif isdefined("form.btnModificar") or isdefined("form.btnAplicar") and not isdefined('form.chk')>
			<cfloop from="1" to="#cantidad#" index="i">
				<cfset totallin = Replace(form['DDRcantorigen_#i#'],',','') * Replace(form['DDRpreciou_#i#'],',','')>
				<cfif isdefined("form.DDRgenreclamo_#i#") and form.tipo eq 'R'>
					<cfset reclamo = Replace(form['DDRcantorigen_#i#'],',','') - Replace(form['DDRcantrec_#i#'],',','')>
				<cfelse>
					<cfset reclamo = 0 >
				</cfif>

				<cfquery datasource="#session.DSN#">
					update DDocumentosRecepcion
					set DDRcantorigen = <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form['DDRcantorigen_#i#'],',','')#">,
						DDRcantrec = 0,
						DDRpreciou = #LvarOBJ_PrecioU.enCF(Replace(form['DDRpreciou_#i#'],',',''))#,
						DDRtotallin = <cfqueryparam cfsqltype="cf_sql_money" value="#totallin#">,
						DDRobsreclamo = <cfif isdefined("form.DDRgenreclamo_#i#")><cfif len(trim(form['DDRobsreclamo_#i#']))><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form['DDRobsreclamo_#i#']#"><cfelse>null</cfif><cfelse>null</cfif>,
						DDRgenreclamo = <cfif isdefined("form.DDRgenreclamo_#i#")>1<cfelse>0</cfif>,
						DDRcantreclamo = <cfif isdefined("form.DDRgenreclamo_#i#")><cfqueryparam cfsqltype="cf_sql_float" value="#reclamo#"><cfelse>0</cfif>,
						Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form['Ucodigo_#i#']#">
					where Ecodigo= #session.Ecodigo#
					  and DDRlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form['DDRlinea_#i#'])#">
				</cfquery>
			</cfloop>
		</cfif>
		<cfif isdefined("Form.btnAplicar")>
			<cfset action = 'devolucion-lista.cfm' >

			<cfif isdefined("form.chk") and form.chk NEQ ''>
				<cfloop list="#form.chk#" index="pkEDRid">
					<cfinclude template="aplDevolCHK.cfm">
				</cfloop>	
			<cfelse>
				<cfinclude template="aplDevol.cfm">
			</cfif>	
		<cfelseif isdefined("Form.btnAgregarLinea")>
			<cfquery name="verifpoliza" datasource="#session.DSN#" maxrows="1">
				select #LvarOBJ_PrecioU.enSQL_AS("DPDvalordeclarado / DPDcantidad", "ValorUnitario")#
				from DPolizaDesalmacenaje 
				where DOlinea = <cfqueryparam value="#form.DOlinea#" cfsqltype="cf_sql_numeric">
				  and Ecodigo = #session.Ecodigo#
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
						DDRtotallin, DDRcostopro, DDRcostototal, DDRgenreclamo, Ucodigo)
				select 	#session.Ecodigo#, 
						#form.EDRid#, 
						do.DOlinea, 
						#session.Usucodigo#, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						do.CMtipo, 
						do.Aid, 
						do.Cid,
						0, 
						do.DOcantsurtida, 
						0,
						#LvarOBJ_PrecioU.enCF(costounitario)#,
						<cfif costounitario NEQ 0.00>
							#LvarOBJ_PrecioU.enCF(costounitario)#,
						<cfelse>
							do.DOpreciou,
						</cfif>
						0, 
						round( DOcantsurtida*DOpreciou, 2), 
						0, 0, 0,
						Ucodigo
				from DOrdenCM do
				where Ecodigo = #session.Ecodigo#
				  and DOlinea = <cfqueryparam value="#form.DOlinea#" cfsqltype="cf_sql_numeric">
			  	  and DOcantsurtida > 0
				  and DOlinea not in 
					(
						select DOlinea from DDocumentosRecepcion a inner join EDocumentosRecepcion b 
						inner join TipoDocumentoR c on b.TDRcodigo = c.TDRcodigo and b.Ecodigo = c.Ecodigo and c.TDRtipo = 'D'
						on a.EDRid = b.EDRid and a.Ecodigo = b.Ecodigo and b.EDRestado < 10
						where a.Ecodigo = do.Ecodigo and a.DOlinea = do.DOlinea
					)
			</cfquery>

		<!--- Elimina linea de detalle --->
		<cfelseif isdefined("form._delete") and len(trim(form._delete)) and isdefined("form.IDdelete") and len(trim(form.IDdelete))>
			<cfquery datasource="#session.DSN#">
				delete from DDocumentosRecepcion
				where EDRid=<cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
				  and DDRlinea=<cfqueryparam value="#form.IDdelete#" cfsqltype="cf_sql_numeric">
			</cfquery>
		</cfif>
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="EDRid" type="hidden" value="<cfif isdefined("form.EDRid") and len(trim(form.EDRid))>#form.EDRid#<cfelseif isdefined("insert")>#insert.identity#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
	<input name="tipo" type="hidden" value="#form.tipo#">
</form>
</cfoutput>

<html><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></html>