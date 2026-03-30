<!--- 	Archivo: vigenciasTablasSalSQL.cfm
		Fecha de Creación: 14 de Abril del 2004
		Creado por: Dorian Abarca Gómez
		
		SQL de Tabla "Vigencias por Tabla de Pago"

			+RHVigenciasTabla
				(
					RHVTid			numeric identity
					
					RHTTid			numeric
					RHVTfecharige	datetime
					RHVTfechahasta	datetime
					RHVTtablabase	numeric
					RHVTporcentaje	smoney
					RHVTdocumento	varchar(80)
					RHVTestado		char(1)
					Ecodigo			int
					RHVTcodigo		int
					RHVTdescripcion	varchar(60)
					
					BMUsucodigo		numeric
					BMfalta			datetime
					BMfmod			datetime
					ts_rversion		ts_rversion
				)
				
			+Reglas para RHVigenciasTabla
				-RHVTfechahasta: debe gravarse '61000101'.
				-RHVTtablabase : si se quiere definir, debe ser definido en el alta, no se puede modificar.
				-RHVTporcentaje: si se usa tabla base, debe tener valor numerico mayor que cero, sino, debe ser nulo tambien.
				-Proceso de Generación con tabla base: se corre un proceso de generación de Montos por Categoria de Pago sobre la tabla 
					respectiva (RHMontosCategoria),	cuando viene definido RHVTtablabase, multiplicando los montos de esta tabla definido 
					por RHVTporcentaje, el porcentaje de aumento, para esta nueva tabla. En modo cambio puede cambiar solo el porcentaje 
					para lo que se corre un proceso de actualización de los montos existentes.
				-RHVTestado : debe gravarse 'P', solo se pueden actualizar registros con estado 'P'.
--->

<!--- Parámetros Requeridos --->
<cfparam name="Form.RHTTid" type="numeric">
<cfparam name="Form.PAGENUMPADRE" type="numeric" default="1">
<cfif isdefined("Form.Alta")>
	<cfparam name="Form.RHVTfecharige" type="string">
	<cfparam name="Form.RHVTtablabase" type="string" default=""><!--- Ver reglas descritas en encabezado --->
	<cfparam name="Form.RHVTporcentaje" type="string" default=""><!--- Ver reglas descritas en encabezado --->
	<cfparam name="Form.RHVTdocumento" type="string" default=""><!--- Ver reglas descritas en encabezado --->
	<cfparam name="Form.RHVTdescripcion" type="string" default="">
	<cfif len(trim(Form.RHVTtablabase)) gt 0 and ( len(trim(Form.RHVTporcentaje)) lte 0 or Form.RHVTporcentaje lte 0 )>
		<cfset err='Error en vigenciasTablasSalSQL.cfm. El valor del porcentaje debe ser un numero mayor que cero cuando se define una tabla base.'>
		<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&ErrMsg=Errores Encontrados<br>&ErrDet=#URLEncodedFormat(err)#" addtoken="no">	
		<cfabort>
	</cfif>
<cfelseif isdefined("Form.Cambio")>
	<cfparam name="Form.RHVTid" type="numeric">
	<cfparam name="Form.PAGENUM" type="numeric" default="1">
	<cfparam name="Form.ts_rversion" type="string">
	<cfparam name="Form.RHVTfecharige" type="string">
	<cfparam name="Form.RHVTdescripcion" type="string" default="">
	<cfquery name="rsGetTablaBase" datasource="#session.dsn#">
		select RHVTtablabase
		from RHVigenciasTabla
		where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
	</cfquery>
	<cfif rsGetTablaBase.RecordCount gt 0>
		<cfset Form.RHVTtablabase = rsGetTablaBase.RHVTtablabase>
	<cfelse>
		<cfset Form.RHVTtablabase = "">
	</cfif>
	<cfparam name="Form.RHVTporcentaje" type="string" default=""><!--- Ver reglas descritas en encabezado --->
	<cfparam name="Form.RHVTdocumento" type="string" default=""><!--- Ver reglas descritas en encabezado --->
	<cfif len(trim(Form.RHVTtablabase)) gt 0 and ( len(trim(Form.RHVTporcentaje)) lte 0 or Form.RHVTporcentaje lte 0 )>
		<cfset err='Error en vigenciasTablasSalSQL.cfm. El valor del porcentaje debe ser un numero mayor que cero cuando se define una tabla base.'>
		<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&ErrMsg=Errores Encontrados<br>&ErrDet=#URLEncodedFormat(err)#" addtoken="no">	
		<cfabort>
	</cfif>
<cfelseif isdefined("Form.Baja")>
	<cfparam name="Form.RHVTid" type="numeric">
<cfelseif isdefined("Form.AltaMonto")>
	<cfparam name="Form.RHVTid" type="numeric">
	<cfparam name="Form.PAGENUM" type="numeric" default="1">
	<cfparam name="Form.CSid" type="numeric">
	<cfparam name="Form.RHMCmonto" type="numeric">
	<cfparam name="Form.RHMCmontomin" type="numeric">
	<cfparam name="Form.RHMCmontomax" type="numeric">
<cfelseif isdefined("Form.CambioMonto")>
	<cfparam name="Form.RHMCid" type="numeric">
	<cfparam name="Form.RHVTid" type="numeric">
	<cfparam name="Form.PAGENUM" type="numeric" default="1">
	<cfparam name="Form.PageNum_data" type="numeric" default="1">
	<cfparam name="Form.RHMCmonto" type="numeric">
	<cfparam name="Form.RHMCmontomin" type="numeric">
	<cfparam name="Form.RHMCmontomax" type="numeric">
	<cfparam name="Form.timestampmonto" type="string">
<cfelseif isdefined("Form.BajaMonto")>
	<cfparam name="Form.RHMCid" type="numeric">
	<cfparam name="Form.RHVTid" type="numeric">
	<cfparam name="Form.PAGENUM" type="numeric" default="1">
</cfif>

<!--- Consulta --->
<cfif not isdefined("Form.Nuevo")>
	<cftransaction>
		<cfif isdefined("Form.AltaMonto")>
			<!--- Obtener RHCPlinea --->
			<cfif isdefined('Form.RHTTid') and Len(Trim(Form.RHTTid)) NEQ 0 and isdefined('Form.RHCid') and Len(Trim(Form.RHCid)) NEQ 0 and isdefined('Form.RHMPPid') and Len(Trim(Form.RHMPPid)) NEQ 0>
				<cfquery name="rsCatPaso" datasource="#Session.DSN#">
					select RHCPlinea
					from RHCategoriasPuesto
					where RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
					and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCid#">
					and RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHMPPid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
				<cfif Len(Trim(rsCatPaso.RHCPlinea))>
					<cfset Form.RHCPlinea = rsCatPaso.RHCPlinea>
				</cfif>
			</cfif>
			<cfif not isdefined("Form.RHCPlinea")>
				<cfset err='La Categoría/Puesto #Form.RHCcodigo# - #Form.RHMPPcodigo# no está definida.'>
				<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&ErrMsg=Errores Encontrados<br>&ErrDet=#URLEncodedFormat(err)#" addtoken="no">	
			</cfif>
			<!--- Chequear que no se agregue la misma categoría dos veces --->
			<cfquery name="checkRHCPlinea" datasource="#Session.DSN#">
				select 1
				from RHMontosCategoria
				where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
				and RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCPlinea#">
				and CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CSid#">
			</cfquery>
			<cfif checkRHCPlinea.recordCount>
				<cfset err='El monto para el componente salarial seleccionado ya había sido insertado.'>
				<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&ErrMsg=Errores Encontrados<br>&ErrDet=#URLEncodedFormat(err)#" addtoken="no">	
			</cfif>
		</cfif>
	
		<cfif not isdefined("Form.Alta")>
			<cfquery name="ABC_RHVigenciasTabla" datasource="#Session.DSN#">
				select 1
				from RHVigenciasTabla
				where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
				and ts_rversion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lcase(Form.ts_rversion)#">
				and RHVTestado = 'P'
			</cfquery>
		</cfif>
		
			<cfif not isdefined("ABC_RHVigenciasTabla") or (isdefined("ABC_RHVigenciasTabla") and ABC_RHVigenciasTabla.RecordCount gt 0)>
		  	<!----========================= VALIDAR QUE LA NUEVA VIGENCIA SEA MAYOR A LA ULTIMA VIGENCIA =========================----->
			<cfquery name="verificaFechaRige" datasource="#session.DSN#">
				select count(1) as cantRegistros
				from RHVigenciasTabla a
				where  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.RHVTfecharige)#">  <=(select max(RHVTfecharige ) 
																														from RHVigenciasTabla b					
																														where b.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
																													   )
					and a.RHTTid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
			</cfquery>
	  
			<cfif isdefined("Form.Alta") and isdefined("verificaFechaRige") and verificaFechaRige.RecordCount NEQ 0 and verificaFechaRige.cantRegistros EQ 0>
				<cfquery name="MaximaVigencia" datasource="#session.DSN#">
					select coalesce(max(RHVTcodigo),0) + 1 as codigo  
					from RHVigenciasTabla
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
				
				<cfquery name="ABC_RHVigenciasTabla" datasource="#session.DSN#">
					insert RHVigenciasTabla (RHTTid,RHVTfecharige,RHVTtablabase,RHVTporcentaje,RHVTdocumento,Ecodigo,RHVTcodigo,RHVTdescripcion,BMUsucodigo,RHVTestado,RHVTfechahasta,BMfalta,BMfmod)
					values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHVTfecharige)#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTtablabase#" null="#len(trim(Form.RHVTtablabase)) eq 0#">,
						<cfqueryparam cfsqltype="cf_sql_money" value="#Form.RHVTporcentaje#" null="#len(trim(Form.RHVTtablabase)) eq 0#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHVTdocumento#" null="#len(trim(Form.RHVTdocumento)) eq 0#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						#MaximaVigencia.codigo#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHVTdescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						'P',
						<cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(6100, 01, 01)#">,
						<cf_dbfunction name="today">,
						<cf_dbfunction name="today">
						)
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>	
				<cf_dbidentity2 datasource="#session.DSN#" name="ABC_RHVigenciasTabla">
				<cfset RHVTid = ABC_RHVigenciasTabla.identity>
				
				<cfif len(trim(Form.RHVTtablabase)) gt 0>
				<cfquery name="ABC_RHVigenciasTabla" datasource="#session.DSN#">
						insert RHMontosCategoria (RHVTid, CSid, RHCPlinea, RHMCmonto, RHVTfrige, RHVTfhasta, BMfalta, BMfmod, BMUsucodigo, RHMCmontomax, RHMCmontomin)
						select #RHVTid#, CSid, RHCPlinea, 
							   RHMCmonto,
							   <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHVTfecharige)#">,
							   <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(6100, 01, 01)#">,
							   <cf_dbfunction name="today">, <cf_dbfunction name="today">,
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
							   RHMCmontomax + (RHMCmontomax * (<cfqueryparam cfsqltype="cf_sql_money" value="#Form.RHVTporcentaje#">/100)), 
							   RHMCmontomin + (RHMCmontomin * (<cfqueryparam cfsqltype="cf_sql_money" value="#Form.RHVTporcentaje#">/100))
						from RHMontosCategoria 
						where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTtablabase#">
				</cfquery>	
				</cfif>
			<cfelseif isdefined("Form.Alta") and isdefined("verificaFechaRige") and verificaFechaRige.RecordCount NEQ 0 and verificaFechaRige.cantRegistros NEQ 0>
				<cfset err='La fecha rige de la vigencia debe ser mayor a la última vigencia para la tabla salarial'>
				<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&ErrMsg=Errores Encontrados<br>&ErrDet=#URLEncodedFormat(err)#" addtoken="no">	
			</cfif>	  
		  <!----====================== VALIDAR QUE AL APLICAR HAYAN MONTOS PARA LA VIGENCIA ================================----->		  
			<cfif isdefined("Form.Aplicar")>
				<cfquery name="rsVerificaComponentes" datasource="#session.DSN#">
					select count(1) as cantRegistros
					from RHMontosCategoria a
						inner join RHVigenciasTabla b
							on a.RHVTid = b.RHVTid
							and b.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
					where a.RHVTid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
				</cfquery>
				<cfif isdefined("rsVerificaComponentes") and rsVerificaComponentes.RecordCount NEQ 0 and rsVerificaComponentes.cantRegistros EQ 0>
					<cfset err='La vigencia no puede ser aplicada porque no tiene componentes asociados'>
					<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&ErrMsg=Errores Encontrados<br>&ErrDet=#URLEncodedFormat(err)#" addtoken="no">	
				</cfif>
			</cfif>
		  <!----=============================================================================================================----->		  

			<cfif isdefined("Form.Cambio")>
				<cfquery datasource="#Session.DSN#">
				update RHVigenciasTabla
				set RHVTfecharige = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSParseDateTime(Form.RHVTfecharige)#">,
					RHVTporcentaje = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.RHVTporcentaje#" null="#len(trim(Form.RHVTtablabase)) eq 0#">,
					RHVTdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHVTdocumento#" null="#len(trim(Form.RHVTdocumento)) eq 0#">,
					RHVTdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHVTdescripcion#">,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					BMfmod = <cf_dbfunction name="today">
				where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
				</cfquery>
				<cfif len(trim(Form.RHVTtablabase)) gt 0>
					<cfquery datasource="#Session.DSN#">
						update RHMontosCategoria set 
							RHMCmonto = 
								coalesce(
									(select a.RHMCmonto + (a.RHMCmonto * (<cfqueryparam cfsqltype="cf_sql_money" value="#Form.RHVTporcentaje#">/100.00))
									from RHMontosCategoria a 
										inner join RHVigenciasTabla b
											on b.RHVTid = a.RHVTid
											and b.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTtablabase#">
									where a.RHCPlinea = RHMontosCategoria.RHCPlinea
									and a.CSid = RHMontosCategoria.CSid
									),
								RHMCmonto),
							RHMCmontomin = 
								coalesce(
									(select a.RHMCmontomin + (a.RHMCmontomin * (<cfqueryparam cfsqltype="cf_sql_money" value="#Form.RHVTporcentaje#">/100.00))
									from RHMontosCategoria a 
										inner join RHVigenciasTabla b
											on b.RHVTid = a.RHVTid
											and b.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTtablabase#">
									where a.RHCPlinea = RHMontosCategoria.RHCPlinea
									and a.CSid = RHMontosCategoria.CSid
									),
								RHMCmontomin),
							RHMCmontomax = 
								coalesce(
									(select a.RHMCmontomax + (a.RHMCmontomax * (<cfqueryparam cfsqltype="cf_sql_money" value="#Form.RHVTporcentaje#">/100.00))
									from RHMontosCategoria a 
										inner join RHVigenciasTabla b
											on b.RHVTid = a.RHVTid
											and b.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTtablabase#">
									where a.RHCPlinea = RHMontosCategoria.RHCPlinea
									and a.CSid = RHMontosCategoria.CSid
									),
								RHMCmontomax)
						where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">		
					</cfquery>		
				</cfif>
			<cfelseif isdefined("Form.Aplicar")>
				<cfquery datasource="#Session.DSN#" name="FechaVigencias">
				select RHVTfecharige,RHVTfechahasta
				from RHVigenciasTabla 
				where RHVTid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
				</cfquery>
				
				<cfquery datasource="#Session.DSN#">
				update RHMontosCategoria set
					RHVTfhasta = <cf_dbfunction name="dateadd" args="-1, #FechaVigencias.RHVTfecharige# ,DD">
				from RHVigenciasTabla a
				where a.RHVTestado = 'A'
				and a.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
				and coalesce(a.RHVTfechahasta,<cfqueryparam cfsqltype="cf_sql_date" value="#createdate(6100,01,01)#">) = <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(6100,01,01)#">
				and a.RHVTid = RHMontosCategoria.RHVTid
				</cfquery>
				
				<cfquery datasource="#Session.DSN#">
				update RHVigenciasTabla 
				set RHVTfechahasta = <cf_dbfunction name="dateadd" args="-1, #FechaVigencias.RHVTfecharige# ,DD"> 
				where RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
				and RHVTestado = 'A'
				and coalesce(RHVTfechahasta,<cfqueryparam cfsqltype="cf_sql_date" value="#createdate(6100,01,01)#">) = <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(6100,01,01)#">
				</cfquery>
				
				<cfquery datasource="#Session.DSN#">
				update RHVigenciasTabla set RHVTestado = 'A'
				where RHVTid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
				</cfquery>

				<cfquery datasource="#Session.DSN#">
				update RHMontosCategoria 
					set RHVTfrige  = (select aa.RHVTfecharige from RHVigenciasTabla aa where aa.RHVTid = RHMontosCategoria.RHVTid), 
					RHVTfhasta = (select bb.RHVTfechahasta from RHVigenciasTabla bb where bb.RHVTid = RHMontosCategoria.RHVTid)
				where RHVTid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
				</cfquery>
				
			<cfelseif isdefined("Form.Baja")>
				<cfquery datasource="#Session.DSN#">
				delete from RHMontosCategoria
				where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
				</cfquery>
				
				<cfquery datasource="#Session.DSN#">
				delete from RHVigenciasTabla
				where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
				</cfquery>
				
			<cfelseif isdefined("Form.AltaMonto")>
				<cfquery datasource="#Session.DSN#" name="ABC_RHVigenciasTabla">
				insert RHMontosCategoria (RHVTid, CSid, RHCPlinea, RHMCmonto, RHVTfrige, RHVTfhasta, BMfalta, BMfmod, BMUsucodigo, RHMCmontomax, RHMCmontomin)
				select 
					a.RHVTid, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CSid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCPlinea#">, 
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.RHMCmonto#">, 
					a.RHVTfecharige, 
					a.RHVTfechahasta,
					<cf_dbfunction name="today">, 
					<cf_dbfunction name="today">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.RHMCmontomax#">, 
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.RHMCmontomin#">
				from RHVigenciasTabla a
				where a.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="ABC_RHVigenciasTabla">
				<cfset RHVTid = ABC_RHVigenciasTabla.identity>
				
			<cfelseif isdefined("Form.CambioMonto")>
				<cfquery datasource="#Session.DSN#">
				update RHMontosCategoria set
					RHMCmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.RHMCmonto#">,
					RHMCmontomin = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.RHMCmontomin#">,
					RHMCmontomax = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.RHMCmontomax#">
				where RHMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHMCid#">
				and ts_rversion =  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lcase(Form.timestampmonto)#">
				</cfquery>
				
			<cfelseif isdefined("Form.BajaMonto")>
				<cfquery datasource="#Session.DSN#">
				delete from RHMontosCategoria
				where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
				and RHMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHMCid#">
				</cfquery>
			</cfif>
			
		  </cfquery>
		  </cfif>
	</cftransaction>
</cfif>

<!--- Envia a la pantalla --->
<!---
<cfif isdefined("Form.CambioMonto")>
	<cflocation url="vigenciasTablasSal.cfm?RHTTid=#Form.RHTTid#&PAGENUMPADRE=#Form.PAGENUMPADRE#&RHVTid=#Form.RHVTid#&PAGENUM=#Form.PAGENUM#&RHMCid=#Form.RHMCid#&PageNum_data=#Form.PageNum_data#">
<cfelseif isdefined("Form.Cambio") or isdefined("Form.AltaMonto") or isdefined("Form.BajaMonto") or isdefined("Form.NuevoMonto")>
	<cflocation url="vigenciasTablasSal.cfm?RHTTid=#Form.RHTTid#&PAGENUMPADRE=#Form.PAGENUMPADRE#&RHVTid=#Form.RHVTid#&PAGENUM=#Form.PAGENUM#">
<cfelse>
	<cflocation url="vigenciasTablasSal.cfm?RHTTid=#Form.RHTTid#&PAGENUMPADRE=#Form.PAGENUMPADRE#">
</cfif>
--->
<cfset params = "?RHTTid=" & Form.RHTTid>
<cfif isdefined("Form.RHVTid") and Len(Trim(Form.RHVTid)) and not (isdefined("Form.Baja") or isdefined("Form.Nuevo"))>
	<cfset params = params & "&RHVTid=" & Form.RHVTid>
</cfif>
<cfif isdefined("Form.RHMCid") and Len(Trim(Form.RHMCid)) and not (isdefined("Form.BajaMonto") or isdefined("Form.NuevoMonto"))>
	<cfset params = params & "&RHMCid=" & Form.RHMCid>
</cfif>
<cfif isdefined("Form.PageNum_lista2") and Len(Trim(Form.PageNum_lista2))>
	<cfset params = params & "&PageNum_lista2=" & Form.PageNum_lista2>
</cfif>
<cfif isdefined("Form.PageNum_lista3") and Len(Trim(Form.PageNum_lista3))>
	<cfset params = params & "&PageNum_lista3=" & Form.PageNum_lista3>
</cfif>
<cfif isdefined("Form.PAGENUM") and Len(Trim(Form.PAGENUM))>
	<cfset params = params & "&PAGENUM=" & Form.PAGENUM>
</cfif>
<cfif isdefined("Form.PAGENUMPADRE") and Len(Trim(Form.PAGENUMPADRE))>
	<cfset params = params & "&PAGENUMPADRE=" & Form.PAGENUMPADRE>
</cfif>

<cflocation url="vigenciasTablasSal.cfm#params#">
