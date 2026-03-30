<!---
	Estados de las Escalas
	0: En Proceso
	10: Aplicada
	20: Pasada
--->

<cfif not isdefined("Form.Nuevo") and not isdefined("Form.NuevoD")>
	<cftransaction>
		<cfif isdefined("Form.Alta")>
			<!--- Chequear si ya existe la Escala Actual --->
			<cfquery name="chkEscalas" datasource="#Session.DSN#">
				select count(1) as cantidad
				from RHEscalaSalHAY
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and EScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EScodigo#">
			</cfquery>
			<cfif chkEscalas.cantidad GT 0>
				<cfset Request.Error.Backs = 1>
				<cfthrow message="Ya existe una escala salarial con el mismo código">
			</cfif>
			
			<!--- Actualizar Escala Previa a la Actual --->
			<cfquery name="updUltimaEscala" datasource="#Session.DSN#">
				update RHEscalaSalHAY set
					ESfhasta = <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d', -1, LSParseDateTime(Form.ESfdesde))#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and ESfhasta = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(6100,01,01)#">
			</cfquery>
			<!--- Insertar Nueva Escala --->
			<cfquery name="insEscala" datasource="#Session.DSN#">
				insert into RHEscalaSalHAY (Ecodigo, EScodigo, ESdescripcion, ESfdesde, ESfhasta, ESestado, fechaalta, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.EScodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESdescripcion#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.ESfdesde)#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(6100,01,01)#">, 
					0,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="insEscala">
			<cfset Form.ESid = insEscala.identity>
			
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="updEscala" datasource="#Session.DSN#">
				update RHEscalaSalHAY set
					EScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EScodigo#">,
					ESdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESdescripcion#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ESid#">
			</cfquery>

		<cfelseif isdefined("Form.Baja")>

			<cfquery name="delExcepciones" datasource="#Session.DSN#">
				delete from RHNivelesPuestoHAY
				where exists (
					select 1
					from RHDEscalaSalHAY a
					where a.ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ESid#">
					and RHNivelesPuestoHAY.DESlinea = a.DESlinea
				)
			</cfquery>

			<cfquery name="delNiveles" datasource="#Session.DSN#">
				delete from RHDEscalaSalHAY
				where ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ESid#">
			</cfquery>

			<cfquery name="delEscala" datasource="#Session.DSN#">
				delete from RHEscalaSalHAY
				where ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ESid#">
			</cfquery>
		
		<cfelseif isdefined("Form.AltaD")>
			<!--- Chequear si ya existe el Nivel --->
			<cfquery name="chkNiveles" datasource="#Session.DSN#">
				select count(1) as cantidad
				from RHDEscalaSalHAY
				where ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ESid#">
				and DESnivel = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.DESnivel#">
			</cfquery>
			<cfif chkNiveles.cantidad GT 0>
				<cfset Request.Error.Backs = 1>
				<cfthrow message="El nivel ya existe para la escala salarial seleccionada">
			</cfif>
			
			<cfquery name="insNiveles" datasource="#Session.DSN#">
				insert into RHDEscalaSalHAY (ESid, DESnivel, DESptodesde, DESptohasta, DESsalmin, DESsalmax, DESsalprom, fechaalta, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ESid#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.DESnivel#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DESptodesde#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DESptohasta#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DESsalmin#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DESsalmax#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DESsalprom#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				)
			</cfquery>

		<cfelseif isdefined("Form.BajaD") and Form.BajaD EQ '1' and isdefined("Form.DESlinea_del") and Len(Trim(Form.DESlinea_del))>

			<cfquery name="delExcepciones" datasource="#Session.DSN#">
				delete from RHNivelesPuestoHAY
				where exists (
					select 1
					from RHDEscalaSalHAY a
					where a.DESlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DESlinea_del#">
					and a.ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ESid#">
					and RHNivelesPuestoHAY.DESlinea = a.DESlinea
				)
			</cfquery>

			<cfquery name="delNiveles" datasource="#Session.DSN#">
				delete from RHDEscalaSalHAY
				where DESlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DESlinea_del#">
				and ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ESid#">
			</cfquery>

		<cfelseif isdefined("Form.Aplicar")>
			<!--- Poner en estado Pasada todas las escalas anteriores a la actual --->
			<cfquery name="updEscalasAnteriores" datasource="#Session.DSN#">
				update RHEscalaSalHAY set
					ESestado = 20
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and ESfdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.ESfdesde)#">
				and ESestado = 10
			</cfquery>
			<!--- Chequear si existen escalas aplicadas posteriores a la que se está aplicando para saber en qué estado se debe poner la escala actual --->
			<cfquery name="chkEscalas" datasource="#Session.DSN#">
				select count(1) as cantidad
				from RHEscalaSalHAY
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and ESfdesde > <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.ESfdesde)#">
				and ESestado = 10
			</cfquery>
			<cfif chkEscalas.cantidad EQ 0>
				<cfset NuevoEstado = 10>
			<cfelse>
				<cfset NuevoEstado = 20>
			</cfif>
		
			<cfquery name="updEscala" datasource="#Session.DSN#">
				update RHEscalaSalHAY set
					ESestado = #NuevoEstado#
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ESid#">
			</cfquery>
			
		<cfelseif isdefined("Form.AgregarExc")>
			<!--- Chequear si ya existe el Puesto --->
			<cfquery name="chkPuesto" datasource="#Session.DSN#">
				select count(1) as cantidad
				from RHNivelesPuestoHAY
				where DESlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DESlinea#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">
			</cfquery>
			<cfif chkPuesto.cantidad GT 0>
				<cfset Request.Error.Backs = 1>
				<cfthrow message="La excepción para el puesto en el nivel salarial seleccionado ya había sido registrada anteriormente.">
			</cfif>
			
			<cfquery name="insExcepciones" datasource="#Session.DSN#">
				insert into RHNivelesPuestoHAY (DESlinea, Ecodigo, RHPcodigo, salmin, salmax, salprom, puntosactuales, fechaalta, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DESlinea#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.salmin#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.salmax#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.salprom#">,
					0, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				)
			</cfquery>
			
		<cfelseif isdefined("Form.BajaExc") and Form.BajaExc EQ '1' and isdefined("Form.RHPcodigo_del") and Len(Trim(Form.RHPcodigo_del))>

			<cfquery name="delNiveles" datasource="#Session.DSN#">
				delete from RHNivelesPuestoHAY
				where DESlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DESlinea#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo_del#">
			</cfquery>

		</cfif>
		
	</cftransaction>
</cfif>

<cfoutput>
<form action="EscalaSalarial.cfm" method="post" name="sql">
	<cfif not isdefined("Form.Nuevo") and not isdefined("Form.Baja") and isdefined("Form.ESid") and Len(Trim(Form.ESid))>
   		<input name="ESid" type="hidden" value="<cfif isdefined("Form.ESid")>#Form.ESid#</cfif>">
	</cfif>
	<cfif not isdefined("Form.NuevoD") and not isdefined("Form.BajaD") and isdefined("Form.DESlinea") and Len(Trim(Form.DESlinea))>
		<input type="hidden" name="DESlinea" id="DESlinea" value="#Form.DESlinea#">
	</cfif>
	<cfif isdefined("Form.PageNum1") and Len(Trim(Form.PageNum1))>
		<input type="hidden" name="PageNum1" id="PageNum1" value="#Form.PageNum1#">
	</cfif>
	<cfif isdefined("Form.PageNum2") and Len(Trim(Form.PageNum2))>
		<input type="hidden" name="PageNum2" id="PageNum2" value="#Form.PageNum2#">
	</cfif>
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
