
<cfparam name="action" default="EncuestasSal.cfm">

<cfset modo="CAMBIO">
<cfset modoD="ALTA">

<cfif isdefined("Form.EPid") and len(form.EPid) GT 0>
	<cfquery name="puesto" datasource="sifpublica">
		select EEid, EAid, EPid
		from EncuestaPuesto
		where EPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPid#">
	</cfquery>

	<!---
	<cfset Empid = ListGetAt(Form.Codigo, 1, '|')>
	<cfset Puestoid = ListGetAt(Form.Codigo, 2, '|')>
	<cfset Areaid = ListGetAt(Form.Codigo, 3, '|')>
	--->

	<cfset Empid = puesto.EEid >
	<cfset Puestoid = puesto.EPid >
	<cfset Areaid = puesto.EAid >
</cfif>

<cfif not isdefined("Form.NuevoD")>
<cftransaction>
	<cfif isdefined("Form.AgregarE")>
		<cfquery name="rsUltEnc" datasource="sifpublica">
			select Efechaanterior
			from Encuesta
			where Eid =(select max(Eid)
						 from Encuesta)
		</cfquery>
		<cfif isdefined("rsUltEnc") and rsUltEnc.RecordCount GT 0>
				<cfset Form.Efechaanterior = rsUltEnc.Efechaanterior>
			<cfelse> 
				<cfset Form.Efechaanterior = LSDateFormat(Now(),'dd/mm/yyyy')>
		</cfif>	
		<cfquery name="EncuestaInsert" datasource="sifpublica">
			insert into Encuesta(EEid, Edescripcion, Efecha, Efechaanterior, BMUsucodigo, BMfechaalta)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Edescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.Efecha)#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Form.Efechaanterior#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
			<cf_dbidentity1 datasource="sifpublica">
		</cfquery>
		<cf_dbidentity2 datasource="sifpublica" name="EncuestaInsert">
		<cfset Form.Eid = EncuestaInsert.identity>
		<cfset modo="CAMBIO">
		<cfset modoD="ALTA">
	<cfelseif isdefined("Form.CambioE")>
		<cfquery name="EncuestaUpdate" datasource="sifpublica">
			update Encuesta 
			set	Edescripcion =<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Edescripcion#">
			where Eid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eid#">
		</cfquery>
		<cfset modo="CAMBIO">
	<cfelseif isdefined("Form.BajaE")>
		<cfquery name="EncuestaSalDelete" datasource="sifpublica">
			delete from EncuestaSalarios
			where Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eid#">
		</cfquery>
		<cfquery name="EncuestaDelete" datasource="sifpublica">
			delete from Encuesta
			where Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eid#">
		</cfquery>

		<cfset modo = "ALTA">
		<cfset modoD = "ALTA">
	<cfelseif isdefined("Form.AgregarD")>
		<cfquery name="ConsMonedas" datasource="sifpublica">
			select distinct(Moneda)
			from EncuestaSalarios
			where Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eid#">
		</cfquery>
		<cfquery name="chkExists" datasource="sifpublica">
			select 1
			from EncuestaSalarios
			where Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eid#">
			  and EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empid#">
			  and EPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Puestoid#">
			  and ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETid#">
			  and Moneda = <cfqueryparam cfsqltype="cf_sql_numeric" value="1">
		</cfquery>
		
		<cfif chkExists.recordCount GT 0>
			<cfset msg = "El Puesto ya fue seleccionado">
			<cfthrow message="#msg#">
			<cfabort>
		</cfif>	
		<cfif isdefined("ConsMonedas") and ConsMonedas.RecordCount GT 0>
			<cfloop query="ConsMonedas">
				<cfquery name="EncSalInsert" datasource="sifpublica">
					insert into EncuestaSalarios(EEid,ETid,Eid,EPid,EScantobs,ESp25,ESp50,ESp75,
												 ESpromedioanterior,ESpromedio,ESvariacion,BMUsucodigo,BMfechaalta,Moneda)
					values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Empid#">,
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETid#">,
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eid#">,
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Puestoid#">,
						   0,0,0,0,0,0,0,
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#ConsMonedas.Moneda#">)
				</cfquery>
			</cfloop>
		<cfelse>
			<cfquery name="EncSalInsert" datasource="sifpublica">
				insert into EncuestaSalarios(EEid,ETid,Eid,EPid,EScantobs,ESp25,ESp50,ESp75,
											 ESpromedioanterior,ESpromedio,ESvariacion,BMUsucodigo,BMfechaalta,Moneda)
				values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Empid#">,
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETid#">,
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eid#">,
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Puestoid#">,
					   0,0,0,0,0,0,0,
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="1">)
			</cfquery>
		</cfif>
		<cfset modoD = "ALTA">
	<cfelseif isdefined("Form.CambioD")>
		<cfif isdefined("Form.ESid") and LEN(form.ESid) GT 0>
			<cfquery name="EncSalUpdate" datasource="sifpublica">
				update EncuestaSalarios
				set ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETid#">,
					EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empid#">,
					EPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Puestoid#">
				where ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESid#">
			</cfquery>
		</cfif>
		<cfquery name="EncUpdate" datasource="sifpublica">
			Update Encuesta 
			Set Edescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Edescripcion#"/>
			where Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eid#">
		</cfquery>
	<cfelseif isdefined("Form.BajaD")>
		<cfquery name="EncSalDelete" datasource="sifpublica">
			delete from EncuestaSalarios
			where ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESid#">
		</cfquery>
	</cfif>
	
</cftransaction>
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<cfif isdefined("Form.NuevoE")>
		<input name="NuevoE" type="hidden" value="Nuevo"> 
	</cfif>	
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="modoD" type="hidden" value="<cfif isdefined("modoD")><cfoutput>#modoD#</cfoutput></cfif>">	
	<cfif isdefined("Form.Eid") and not isDefined("Form.Baja")>
		<input name="Eid" type="hidden" value="<cfoutput>#Form.Eid#</cfoutput>">
	</cfif>
	<cfif modoD NEQ 'ALTA'>
   		<input name="ESid" type="hidden" value="<cfif isdefined("Form.ESid")>#Form.ESid#</cfif>">    	
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">
</form>
</cfoutput>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


