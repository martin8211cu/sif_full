<!---
	Modificado por Hector Garcia Beita.
	Fecha: 22-07-2011.
	Motivo: Se agregan variables de redirección para los casos en que el
	fuente sea llamado desde la opción de tarjetas de credito mediante includes
	con validadores segun sea el caso
--->

<cfparam name="modo" default="ALTA">

<!---
	Validador para los casos en que la transaccion se realiza
	desde la opcion de bancos o desde tarjetas de credito.
 --->
<cfset LvarPagina = "Bancos.cfm">
<cfif isdefined("LvarTCESQLBancos")>
	<cfset LvarPagina = "TCEBancos.cfm">
</cfif>

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
    	<cfif isdefined("form.archivo") and Len(Trim(form.archivo)) gt 0 >
        	<cfinclude template="/rh/Utiles/imagen.cfm">
       	</cfif>
		<cfquery name="ABC_Bancos" datasource="#Session.DSN#">
			insert into Bancos (
					Ecodigo, Bcodigo, Bdescripcion, Bdireccion, Btelefon, Bfax, Bemail,
					BcodigoACH, Iaba, BcodigoSWIFT, BcodigoIBAN, BcodigoOtro,Blogo,
					EIid, Bcodigocli,CEBSid,RFC, BancoExtranjero, plantillaDispersion)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Bcodigo#"			null="#trim(Form.Bcodigo) EQ ""#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Bdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Bdireccion#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Btelefon#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Bfax#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Bemail#">,

				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.BcodigoACH#"		null="#trim(Form.BcodigoACH) EQ ""#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Iaba#"			null="#trim(Form.Iaba) EQ ""#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.BcodigoSWIFT#"	null="#trim(Form.BcodigoSWIFT) EQ ""#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.BcodigoIBAN#"		null="#trim(Form.BcodigoIBAN) EQ ""#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.BcodigoOtro#"		null="#trim(Form.BcodigoOtro) EQ ""#">,
                <cfif isdefined("ts")>
                    <cfqueryparam cfsqltype="cf_sql_blob" value="#tmp#">
                <cfelse>
                    null
                 </cfif>,
				<cfif isdefined('form.EIid') and LEN(form.EIid) GT 0>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EIid#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined("form.Bcodigocli") and len(trim(form.Bcodigocli))>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Bcodigocli#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined("form.CEBSid") and len(trim(form.CEBSid))>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CEBSid#">,
				<cfelse>
					null,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RFC#">,
				<cfif isdefined('form.BancoExtranjero')> 1 <cfelse> 0 </cfif>, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PlantillaDisp#"			null="#trim(Form.PlantillaDisp) EQ ""#">)				
		</cfquery>
			<cfset modo="ALTA">
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="ABC_Bancos" datasource="#Session.DSN#">
			delete from Bancos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
		</cfquery>
		<cf_sifcomplementofinanciero action='delete'
				tabla="Bancos"
				form = "form1"
				llave="#Form.Bid#" />
		<cfset modo="ALTA">
	 <!---Redireccion Bancos o TCEBancos(Tarjetas de Credito)--->
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="Bancos"
 				redirect="#LvarPagina#"
  				timestamp="#form.ts_rversion#"
				field1="Bid"
				type1="numeric"
				value1="#form.Bid#">
		<cfquery name="ABC_Bancos" datasource="#Session.DSN#">
			update Bancos set
				Bcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Bcodigo#"			null="#trim(Form.Bcodigo) EQ ""#">,
				Bdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Bdescripcion#">,
				Bdireccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Bdireccion#">,
				Btelefon = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Btelefon#">,
				Bfax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Bfax#">,
				Bemail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Bemail#">,

				BcodigoACH		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.BcodigoACH#"		null="#trim(Form.BcodigoACH) EQ ""#">,
				Iaba			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Iaba#"				null="#trim(Form.Iaba) EQ ""#">,
				BcodigoSWIFT	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.BcodigoSWIFT#"		null="#trim(Form.BcodigoSWIFT) EQ ""#">,
				BcodigoIBAN		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.BcodigoIBAN#"		null="#trim(Form.BcodigoIBAN) EQ ""#">,
				BcodigoOtro		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.BcodigoOtro#"		null="#trim(Form.BcodigoOtro) EQ ""#">,
				BancoExtranjero = <cfif isdefined('form.BancoExtranjero')> 1 <cfelse> 0 </cfif>,

				EIid =
					<cfif isdefined('form.EIid') and LEN(form.EIid) GT 0>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIid#">
					<cfelse>
						null
					</cfif>,
				Bcodigocli =
					<cfif isdefined("form.Bcodigocli") and len(trim(form.Bcodigocli))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Bcodigocli#">
					<cfelse>
						null
					</cfif>,
				CEBSid =
					<cfif isdefined("form.CEBSid") and len(trim(form.CEBSid))>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CEBSid#">
					<cfelse>
						null
					</cfif>,
				RFC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RFC#">,
				plantillaDispersion =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PlantillaDisp#" null="#trim(Form.PlantillaDisp) EQ ""#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
		</cfquery>
		<cfquery name="ABC_Bancos" datasource="#Session.DSN#">
			update TEStransferenciaP
			   set
					TESTPcodigo =
						case TESTPcodigoTipo
							when 0 then 	<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.BcodigoACH #">
							when 1 then 	<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.Iaba#">
							when 2 then 	<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.BcodigoSWIFT#">
							when 3 then 	<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.BcodigoIBAN#">
							else 			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.BcodigoOtro#">
						end,
					TESTPbanco		= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.Bdescripcion#">,
					TESTPdireccion	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.Bdireccion#">,
					TESTPtelefono	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.Btelefon#">
			 where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
			   and TESTPestado <> 2 <!---No Borrado--->
		</cfquery>
		<cf_sifcomplementofinanciero action='update'
			tabla="Bancos"
			form = "form1"
			llave="#Form.Bid#" />
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<!---VALIDADOR--->

<form action="<cfoutput>#LvarPagina#</cfoutput><cfif isdefined('url.desde') and Trim(url.desde) eq 'rh'>?desde=rh</cfif>" method="post" name="sql">
	<cfif isdefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="Nuevo">
	</cfif>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">

	<cfif modo neq 'ALTA'>
		<input name="Bid" type="hidden" value="<cfif isdefined("Form.Bid")><cfoutput>#Form.Bid#</cfoutput></cfif>">
	</cfif>

	<input name="desde" type="hidden" value="<cfif isdefined("form.desde")><cfoutput>#form.desde#</cfoutput></cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">
</form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
