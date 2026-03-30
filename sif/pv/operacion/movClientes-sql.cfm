<cfinclude template="../../Utiles/sifConcat.cfm">
<cfoutput>
	<cftransaction>
		<cfloop list="#form.chk#" index="id">
			<!--- Insert de Registro de aplicación de Adelanto Original --->
			<cfquery datasource="#session.DSN#">
				insert into FAX016( Ecodigo,
									CDCcodigo,
									FAX16FEC,
									FAX16MON,
									FAM01COD,
									FAX16NDC,
									FAX16TIP,
									FAX16OBS,
									FAX14CON,
									fechaalta,
									BMUsucodigo)
				select 	Ecodigo,
						CDCcodigo,
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
						FAX14MON-FAX14MAP,
						FAM01COD,
						'N/A',
						'--',
						'Traslado de Adelanto a Cliente: ' #_Cat# ( select CDCnombre
																 from ClientesDetallistasCorp
																 where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
																 and CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigodest#">),
						FAX14CON,
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				from FAX014
				where CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#"> <!--- CDCcodigo Origen --->
				  and FAX14CON = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">  <!--- FAX14CON (ConsecutivoAdelanto) --->
			</cfquery>
	
			<cfquery name="consecutivo" datasource="#session.dsn#">
				select coalesce(max(FAX14CON),0)+1 as idDestino
				from FAX014 
				where CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigodest#">
			</cfquery>
			<cfset vIdDestino = consecutivo.idDestino >
	
			<!--- Insert de registro nuevo para el cliente destino --->
			<cfquery datasource="#session.DSN#">
				insert into FAX014(	Ecodigo,
									CDCcodigo,
									FAX14CON,
									FAX01NTR,
									FAX14DOC,
									FAX14TDC,
									FAX14CLA,
									FAX14FEC,
									FAX14MON,
									FAX14MAP,
									FAM01COD,
									Mcodigo,
									CFcuenta,
									IdTipoAd,
									FAX14STS,
									FAX14DRE,
									FAX14DRE2,
									TransExterna,
									BMUsucodigo,
									fechaalta )
				select	Ecodigo,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigodest#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#vIdDestino#">,
						FAX01NTR,
						FAX14DOC,
						FAX14TDC,
						FAX14CLA,
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
						FAX14MON-FAX14MAP,
						0.00,
						FAM01COD,
						Mcodigo,
						CFcuenta,
						IdTipoAd,
						FAX14STS,
						FAX14DRE,
						FAX14DRE2,
						TransExterna,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				from FAX014
				where CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#"> <!--- CDCcodigo Origen --->
				  and FAX14CON = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">  <!--- FAX14CON (ConsecutivoAdelanto) --->
			</cfquery>	
			
			<!--- Insert de Bitacora --->
			<cfquery datasource="#session.DSN#">
				insert into FABitacoraTrasladoAd( Ecodigo,
												  FABMotivo,
												  CDCcodigoOri,
												  FAX14CONOri,
												  CDCcodigoDest,
												  FAX14CONDest,
												  FABIP_Maquina,
												  BMUsucodigo,
												  fechaalta )
				values( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FABmotivo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigodest#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#vIdDestino#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.sitio.ip#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> )
			</cfquery>
			
			<!--- update de registro original --->
			<cfquery datasource="#session.DSN#">
				update FAX014 
				set FAX14MAP = FAX14MON, 
					FAX14STS = '2'
				where CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#"> <!--- CDCcodigo Origen --->
				  and FAX14CON = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">  <!--- FAX14CON (ConsecutivoAdelanto) --->
			</cfquery>		
		</cfloop>
	</cftransaction>
</cfoutput>

<cflocation url="movClientes-reporte.cfm?CDCcodigo=#form.CDCcodigo#&FAX14DOC=#form.FAX14DOC#&CDCcodigodest=#form.CDCcodigodest#&chk=#form.chk#&FABmotivo=#form.Fabmotivo#"/>