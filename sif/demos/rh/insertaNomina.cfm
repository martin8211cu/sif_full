<!--- 1. Tipos de Nomina --->
<cfquery name="data" datasource="#session.DSNnuevo#">
	select * 
	from TiposNomina 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#"> 
	<!----and Tcodigo='QUI'--->
</cfquery>
<cfif data.recordcount eq 0 >
	<cfquery datasource="#session.DSNnuevo#">
		insert into TiposNomina(Ecodigo, Tcodigo, Mcodigo, Tdescripcion, Ttipopago, BMUsucodigo)
		select <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">, Tcodigo, Mcodigo, Tdescripcion, Ttipopago,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">
		from TiposNomina
		where Ecodigo=#vn_Ecodigo#
		<!---and Tcodigo='QUI'--->
	</cfquery>
	
	<!--- insercion de los dias de no pago --->
	<cfquery name="dataDias" datasource="#session.DSNnuevo#">
		select * 
		from DiasTiposNomina 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#"> 
		<!---and Tcodigo='QUI'--->
	</cfquery>	
	<cfif dataDias.recordcount eq 0 >
		<cfquery datasource="#session.DSNnuevo#">
			insert INTO DiasTiposNomina 
				(Ecodigo, Tcodigo, DTNdia, Usucodigo, Ulocalizacion, BMUsucodigo)
			Select <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
				 Tcodigo, DTNdia, Usucodigo, Ulocalizacion, 
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">
			from DiasTiposNomina
			where Ecodigo = #vn_Ecodigo#
				<!---and Tcodigo='QUI'	--->
		</cfquery>
	</cfif>
</cfif>

<!--- 2. CalendarioPagos --->
<cfquery name="dataPagos" datasource="#session.DSNnuevo#">
	Select *
	from  CalendarioPagos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#"> 
		<!----and Tcodigo='QUI'--->
</cfquery>

<cfif dataPagos.recordcount eq 0 >
	<cfquery datasource="#session.DSNnuevo#">
		insert INTO CalendarioPagos 
			(Ecodigo, CPcodigo, Tcodigo, CPdesde, CPhasta, CPfpago, CPperiodo, CPmes, CPfcalculo,
			 CPfenvio, CPusucalc, CPusuloccalc, CPusuenvio, CPusulocenvio, Usucodigo, Ulocalizacion,
			  CPtipo, CPdescripcion, CPnorenta, CPnocargasley, CPnocargas, BMUsucodigo)
			  
		Select <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
			 CPcodigo, Tcodigo, CPdesde, CPhasta, CPfpago, CPperiodo, CPmes, CPfcalculo,
			 CPfenvio, CPusucalc, CPusuloccalc, CPusuenvio, CPusulocenvio, Usucodigo, Ulocalizacion,
			 CPtipo, CPdescripcion, CPnorenta, CPnocargasley, CPnocargas, 
			 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">
		from  CalendarioPagos
		where Ecodigo=#vn_Ecodigo#
			<!---and Tcodigo='QUI'--->
	</cfquery>
</cfif>

<!--- 3. Conceptos de Pago --->
<cfquery name="dataConcep" datasource="#session.DSNnuevo#">
	Select *
	from CIncidentes
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#"> 
</cfquery>

<cfif dataConcep.recordcount eq 0 >
	<!--- Encabezados de Conceptos de Pago --->
	<cfquery datasource="#session.DSNnuevo#">
		insert INTO CIncidentes 
			(Ecodigo, CIcodigo, CIdescripcion, CIfactor, CItipo, CInegativo, CIcantmin, CIcantmax, 
			Usucodigo, Ulocalizacion, CInorealizado, CInorenta, CInocargas, CInodeducciones, CIvacaciones,
			CIcuentac, CIredondeo, CIafectasalprom, CInocargasley, CIafectacomision, CItipoexencion, CIexencion,
			BMUsucodigo)
		Select <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
			CIcodigo, CIdescripcion, CIfactor, CItipo, CInegativo, CIcantmin, CIcantmax, 
			Usucodigo, Ulocalizacion, CInorealizado, CInorenta, CInocargas, CInodeducciones, CIvacaciones,
			CIcuentac, CIredondeo, CIafectasalprom, CInocargasley, CIafectacomision, CItipoexencion, CIexencion,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">
		from CIncidentes
		where Ecodigo=#vn_Ecodigo#
	</cfquery>
	
	<!--- Detalles de los Conceptos de Pago --->
	<cfquery name="rsCIncidentesD" datasource="#session.DSNnuevo#">
		Select 
			CIcodigo,cid.CIid, CIcantidad, cid.CItipo, CIcalculo, CIdia, CImes
		from CIncidentesD cid
			inner join CIncidentes ci
				on ci.CIid = cid.CIid
					and Ecodigo = #vn_Ecodigo#
	</cfquery>
	<cfloop query="rsCIncidentesD">
		<cfquery name="rs" datasource="#session.DSNnuevo#"><!---para c/u encontrar el CIid (identity) que pertenece a ese CIcodigo---->
			Select CIid
			from CIncidentes 
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
				and CIcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#rsCIncidentesD.CIcodigo#">
		</cfquery>
		<cfquery name="CIncidentesD" datasource="#session.DSNnuevo#">
			insert INTO CIncidentesD 
				(CIid, CIcantidad, CItipo, CIcalculo, CIdia, CImes, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.CIid#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCIncidentesD.CIcantidad#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#rsCIncidentesD.CItipo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCIncidentesD.CIcalculo#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCIncidentesD.CIdia#" null="#len(trim(rsCIncidentesD.CIdia)) EQ 0#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCIncidentesD.CImes#" null="#len(trim(rsCIncidentesD.CImes)) EQ 0#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">)
		</cfquery>
	</cfloop>
</cfif>

<!--- 4. Tipos de Deduccion --->
<cfquery name="dataTiposDeducc" datasource="#session.DSNnuevo#">
	Select *
	from TDeduccion 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#"> 
</cfquery>

<cfif dataTiposDeducc.recordcount eq 0 >
	<cfquery datasource="#session.DSNnuevo#">
		insert INTO TDeduccion 
			(Ecodigo, TDcodigo, TDdescripcion, Usucodigo, Ulocalizacion, TDfecha, TDobligatoria, TDprioridad,
			 TDparcial, TDordmonto, TDordfecha, BMUsucodigo, TDfinanciada, Ccuenta, CFcuenta, cuentaint,
			 CFcuentaint, TDesrenta, SNcodigo)
		 
		Select <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">, TDcodigo,
			 TDdescripcion, Usucodigo, Ulocalizacion, TDfecha, TDobligatoria, TDprioridad,
			 TDparcial, TDordmonto, TDordfecha, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
			 TDfinanciada, Ccuenta, CFcuenta, cuentaint, CFcuentaint, TDesrenta, SNcodigo
		from TDeduccion 
		where Ecodigo=#vn_Ecodigo#
			and (
				SNcodigo in (
							Select SNcodigo
							from SNegocios
							where Ecodigo=#vn_Ecodigo#
								<!---
								and SNnumero like '%000-00%'
								and SNidentificacion like 'B%'	
								---->			
						)
				or SNcodigo is null
				)
	</cfquery>
</cfif>

<!--- 5. Estados de Socios de Negocios --->
<cfquery name="dataEstSNegoc" datasource="#session.DSNnuevo#">
	Select *
	from EstadoSNegocios
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#"> 
</cfquery>

<cfif dataEstSNegoc.recordcount eq 0>
	<cfquery datasource="#session.DSNnuevo#">
		insert EstadoSNegocios 
			(Ecodigo, ESNcodigo, ESNdescripcion, ESNfacturacion, BMUsucodigo)
		
		Select <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
			 ESNcodigo, ESNdescripcion, ESNfacturacion, 
			 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">
		from EstadoSNegocios 
		where Ecodigo=#vn_Ecodigo#
	</cfquery>
</cfif>

<!--- 6. Socios de Negocios --->
<cfquery name="dataSNegoc" datasource="#session.DSNnuevo#">
	Select *
	from SNegocios
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#"> 
</cfquery>

<cfif dataSNegoc.recordcount eq 0 >
	<cfquery name="rsEstSNeg" datasource="#session.DSNnuevo#">
		Select  ESNid
		from EstadoSNegocios 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#"> 
	</cfquery>
	
	<cfif isdefined('rsEstSNeg') and rsEstSNeg.recordCount GT 0>
		<cfquery datasource="#session.DSNnuevo#">
			insert SNegocios (Ecodigo, SNcodigo, SNidentificacion, SNtipo, SNnombre, SNdireccion, Ppais, SNtelefono,
				SNFax, SNemail, LOCidioma, SNcertificado, SNactivoportal, SNcodigoext, SNFecha, SNtiposocio, SNvencompras,
				SNvenventas, SNinactivo, EUcodigo, SNnumero, SNcuentacxc, SNcuentacxp, CDid, LPid, SNplazoentrega, SNplazocredito,
				cuentac, CSNid, GSNid, ESNid, DEidEjecutivo, DEidVendedor, DEidCobrador, ZCSNid, Mcodigo, SNmontoLimiteCC,
				SNdiasVencimientoCC, SNdiasMoraCC, SNdocAsociadoCC, SNesCorporativo, SNidCorporativo, SNidPadre, id_direccion,
				EcodigoInclusion, SNinclusionAutoriz, SNidEquivalente, BMUsucodigo, SNnombrePago)
			
			Select <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
				SNcodigo, SNidentificacion, SNtipo, SNnombre, SNdireccion, Ppais, SNtelefono,
				SNFax, SNemail, LOCidioma, SNcertificado, SNactivoportal, SNcodigoext, SNFecha, SNtiposocio, SNvencompras,
				SNvenventas, SNinactivo, EUcodigo, SNnumero, SNcuentacxc, SNcuentacxp, CDid, LPid, SNplazoentrega, SNplazocredito,
				cuentac, CSNid, GSNid, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstSNeg.ESNid#">, DEidEjecutivo, DEidVendedor, DEidCobrador, ZCSNid, Mcodigo, SNmontoLimiteCC,
				SNdiasVencimientoCC, SNdiasMoraCC, SNdocAsociadoCC, SNesCorporativo, SNidCorporativo, SNidPadre, id_direccion,
				EcodigoInclusion, SNinclusionAutoriz, SNidEquivalente, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">
				, SNnombrePago
			from SNegocios
			where Ecodigo=#vn_Ecodigo#
				<!----and SNnumero like '%000-00%'---->
				<!---and SNnumero like '%000-%'--->
		</cfquery>
	</cfif>
</cfif>

<!--- 7. Tipos de Deduccion --->
<cfquery name="dataTiposDeducc" datasource="#session.DSNnuevo#">
	Select *
	from TDeduccion 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#"> 
</cfquery>

<cfif dataTiposDeducc.recordcount eq 0 >
	<cfquery datasource="#session.DSNnuevo#">
		insert INTO TDeduccion 
			(Ecodigo, TDcodigo, TDdescripcion, Usucodigo, Ulocalizacion, TDfecha, TDobligatoria, TDprioridad,
			 TDparcial, TDordmonto, TDordfecha, BMUsucodigo, TDfinanciada, Ccuenta, CFcuenta, cuentaint,
			 CFcuentaint, TDesrenta, SNcodigo)
		
		Select <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">, TDcodigo,
			 TDdescripcion, Usucodigo, Ulocalizacion, TDfecha, TDobligatoria, TDprioridad,
			 TDparcial, TDordmonto, TDordfecha, BMUsucodigo, TDfinanciada, Ccuenta, CFcuenta, 
			 cuentaint, CFcuentaint, TDesrenta, SNcodigo
		from TDeduccion 
		where Ecodigo=#vn_Ecodigo#
	</cfquery>
</cfif>

<!--- 8. Cargas Obrero-Patronales --->
<cfquery name="dataCargas" datasource="#session.DSNnuevo#">
	Select *
	from ECargas
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#"> 
</cfquery>

<cfif dataCargas.recordcount eq 0 >
	<cfquery datasource="#session.DSNnuevo#">
		insert INTO ECargas 
			(Ecodigo, ECcodigo, ECdescripcion, Usucodigo, Ulocalizacion, ECfecha, ECauto, BMUsucodigo)
		
		Select <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
			 ECcodigo, ECdescripcion, Usucodigo, Ulocalizacion, ECfecha, ECauto, 
			 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">
		from ECargas 
		where Ecodigo = #vn_Ecodigo#
	</cfquery>

	<!--- Detalles de Cargas Obrero-Patronales --->
	<cfquery name="rsDCargas" datasource="#session.DSNnuevo#">
		Select 
			ECcodigo,dc.ECid, dc.Ecodigo, SNcodigo, DCcodigo, DCmetodo, DCdescripcion, DCvaloremp, DCvalorpat, DCprovision, DCnorenta, DCtipo, SNreferencia, DCcuentac, DCtiporango, DCrangomin, DCrangomax
		from DCargas dc
			inner join ECargas  ec
				on ec.ECid = dc.ECid
					and ec.Ecodigo  = dc.Ecodigo 
		where dc.Ecodigo = #vn_Ecodigo#
			and SNcodigo in (
				Select SNcodigo
				from SNegocios
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
					<!---and SNnumero like '%000-00%'--->
			)
	</cfquery>

	<cfloop query="rsDCargas">
		<cfquery name="rs" datasource="#session.DSNnuevo#"><!---para c/u encontrar el ECid (identity) que pertenece a ese ECcodigo---->	
			Select ECid
			from ECargas
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
				and ECcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#rsDCargas.ECcodigo#">
		</cfquery>

		<cfquery name="ConceptosTipoAccion" datasource="#session.DSNnuevo#">
			insert INTO DCargas 
				(ECid, Ecodigo, SNcodigo, DCcodigo, DCmetodo, DCdescripcion, DCvaloremp, DCvalorpat,
				 DCprovision, DCnorenta, DCtipo, SNreferencia, DCcuentac, DCtiporango, DCrangomin, 
				 DCrangomax, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.ECid#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDCargas.SNcodigo#" null="#Len(trim(rsDCargas.SNcodigo)) EQ 0#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#rsDCargas.DCcodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDCargas.DCmetodo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDCargas.DCdescripcion#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#rsDCargas.DCvaloremp#">,  
				<cfqueryparam cfsqltype="cf_sql_money" value="#rsDCargas.DCvalorpat#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#rsDCargas.DCprovision#">, 
				<cfqueryparam cfsqltype="cf_sql_bit" value="#rsDCargas.DCnorenta#">, 
				<cfqueryparam cfsqltype="cf_sql_bit" value="#rsDCargas.DCtipo#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDCargas.SNreferencia#" null="#Len(trim(rsDCargas.SNreferencia)) EQ 0#">,  
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDCargas.DCcuentac#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDCargas.DCtiporango#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#rsDCargas.DCrangomin#">,  
				<cfqueryparam cfsqltype="cf_sql_money" value="#rsDCargas.DCrangomax#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">)
		</cfquery>
	</cfloop>	
</cfif>

<!--- 9. Tipos de Accion --->
<cfquery name="dataTiposAccion" datasource="#session.DSNnuevo#">
	Select *
	from RHTipoAccion
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#"> 
</cfquery>

<cfif dataTiposAccion.recordcount eq 0 >
	<cfquery datasource="#session.DSNnuevo#">
		insert INTO RHTipoAccion 
			(Ecodigo, RHTcodigo, RHTdesc, RHTpaga, RHTpfijo, RHTpmax, RHTcomportam, 
			RHTposterior, RHTautogestion, RHTindefinido, RHTcempresa, RHTctiponomina, RHTcregimenv, 
			RHTcoficina, RHTcdepto, RHTcplaza, RHTcpuesto, RHTccomp, RHTcsalariofijo, RHTccatpaso, 
			RHTvisible, RHTcjornada, RHTidtramite, RHTnorenta, RHTnocargas, RHTnodeducciones, 
			RHTnoretroactiva, RHTcuentac, CIncidente1, CIncidente2, RHTcantdiascont, RHTnocargasley, 
			RHTnoveriplaza, RHTliquidatotal, BMUsucodigo, RHTdatoinforme, RHTpension)
		
		Select <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
			RHTcodigo, RHTdesc, RHTpaga, RHTpfijo, RHTpmax, RHTcomportam, 
			RHTposterior, RHTautogestion, RHTindefinido, RHTcempresa, RHTctiponomina, RHTcregimenv, 
			RHTcoficina, RHTcdepto, RHTcplaza, RHTcpuesto, RHTccomp, RHTcsalariofijo, RHTccatpaso, 
			RHTvisible, RHTcjornada, RHTidtramite, RHTnorenta, RHTnocargas, RHTnodeducciones, 
			RHTnoretroactiva, RHTcuentac, CIncidente1, CIncidente2, RHTcantdiascont, RHTnocargasley, 
			RHTnoveriplaza, RHTliquidatotal, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
			 RHTdatoinforme, RHTpension
		from RHTipoAccion
		where Ecodigo = #vn_Ecodigo#	
	</cfquery>

	<!--- Detalles de Tipo Accion --->
	<cfquery name="rsConTipoAccion" datasource="#session.DSNnuevo#">
		Select RHTcodigo, CIid, cta.RHTid, Usucodigo, Ulocalizacion, CTAsalario
		from	ConceptosTipoAccion cta
			inner join RHTipoAccion ta
				on ta.RHTid=cta.RHTid
					and Ecodigo = #vn_Ecodigo#
	</cfquery>
	
	<cfif isdefined('rsConTipoAccion') and rsConTipoAccion.recordCount GT 0>
		<cfloop query="rsConTipoAccion">
			<cfquery name="rs" datasource="#session.DSNnuevo#"><!---para c/u encontrar el RHTid (identity) que pertenece a ese RHTcodigo---->
				Select RHTid
				from RHTipoAccion 
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
					and RHTcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#rsConTipoAccion.RHTcodigo#">
			</cfquery>
			<cfquery name="ConceptosTipoAccion" datasource="#session.DSNnuevo#">
				insert INTO ConceptosTipoAccion 
					(CIid, RHTid, Usucodigo, Ulocalizacion, CTAsalario, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConTipoAccion.CIid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.RHTid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConTipoAccion.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#rsConTipoAccion.Ulocalizacion#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsConTipoAccion.CTAsalario#">,  
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">)
			</cfquery>
		</cfloop>
	</cfif>
</cfif>