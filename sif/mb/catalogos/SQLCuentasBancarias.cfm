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
<cfset LvarPagina = "CuentasBancarias.cfm">
<cfif isdefined("TCESQLCtsBancarias")>
	<cfset LvarPagina = "TCECuentasBancarias.cfm">
</cfif>

<cfif not isdefined("Form.Nuevo")>
	<cftry>
			<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2010" default="" returnvariable="InterfazCatalogos"/>
			<cfif isdefined("Form.Alta")>
				<cfquery name="CuentasBInsert" datasource="#session.DSN#">
				insert into CuentasBancos (Bid, Ecodigo, Ocodigo, Mcodigo, Ccuenta, Ccuentacom, Ccuentaint, CBcodigo, CBdescripcion, 
										   CBcc, CBTcodigo, CBdato1, CBidioma, EIid
										   <cfif LEN(TRIM(InterfazCatalogos)) and InterfazCatalogos EQ 1>,CBclave,CBcodigoext</cfif>,CcuentaintPag,
										   CVirtual) 
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">,
					<cfif isDefined("Form.Ccuentacom") and Len(Trim(Form.Ccuentacom)) GT 0>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuentacom#">,
					<cfelse>
						null,
					</cfif>
					<cfif isDefined("Form.Ccuentaint") and Len(Trim(Form.Ccuentaint)) GT 0>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuentaint#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBcc#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CBTcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBdato1#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CBidioma#">,
					<cfif isdefined('Form.EIid') and LEN(Form.EIid) GT 0>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIid#">
					<cfelse>
						null
					</cfif>
					<cfif LEN(TRIM(InterfazCatalogos)) and InterfazCatalogos EQ 1>
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBclave#">
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBcodigoext#">
					</cfif>
					<cfif isDefined("Form.Ccuentaintpag") and Len(Trim(Form.Ccuentaintpag)) GT 0>
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuentaintpag#">
					<cfelse>
						,null
					</cfif>
					,<cfif isDefined("form.cvirtual") and form.cvirtual eq 'on'>1<cfelse>0</cfif>
				)
				</cfquery>
				<cfset modo="ALTA">
				
			<cfelseif isdefined("Form.Baja")>			
				<cfquery name="CuentasBDetele" datasource="#session.DSN#">
					delete from CuentasBancos
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBid#">
					  and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
				</cfquery>
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Cambio")>
				<cf_dbtimestamp datasource="#session.dsn#"
			 			table="CuentasBancos"
			 			redirect="formCuentasBancarias.cfm"
			 			timestamp="#form.ts_rversion#"
						field1="CBid" 
						type1="numeric" 
						value1="#form.CBid#"
						>
				<cfquery name="CuentasBUpdate" datasource="#session.DSN#">
					update CuentasBancos set
						Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">,
						Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
						Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
						Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">,
						CVirtual = <cfif isDefined("form.cvirtual") and form.cvirtual eq 'on'>1<cfelse>0</cfif>,
						<cfif isDefined("Form.Ccuentacom") and Len(Trim(Form.Ccuentacom)) GT 0>
							Ccuentacom = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuentacom#">,
						<cfelse>
							Ccuentacom = null,
						</cfif>	
						<cfif isDefined("Form.Ccuentaint") and Len(Trim(Form.Ccuentaint)) GT 0>
							Ccuentaint = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuentaint#">,
						<cfelse>
							Ccuentaint = null,
						</cfif>	
						CBcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBcodigo#">,
						CBdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBdescripcion#">,
						CBcc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBcc#">,
						CBTcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBTcodigo#">,
						CBdato1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBdato1#">,
						CBidioma=<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CBidioma#">,
						EIid = 
							<cfif isdefined('form.EIid') and LEN(form.EIid) GT 0>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIid#">
							<cfelse>
								null
							</cfif>
						<cfif LEN(TRIM(InterfazCatalogos)) and InterfazCatalogos EQ 1>
						,CBclave=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBclave#">
						,CBcodigoext=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBcodigoext#">
						</cfif>
						,CcuentaintPag =
							<cfif isDefined("Form.Ccuentaintpag") and Len(Trim(Form.Ccuentaintpag)) GT 0>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuentaintpag#">
							<cfelse>
							null
							</cfif>
					where CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBid#">
				</cfquery>
				<!--- Actualiza las Cuentas Detino para TEF equivalentes --->
				<cfquery name="rsDst" datasource="#Session.DSN#">
					select  d.TESTPid, TESTPcodigoTipo,
							case 
								when TESTPcodigoTipo = 0 then b.BcodigoACH
								when TESTPcodigoTipo = 1 then b.Iaba
								when TESTPcodigoTipo = 2 then b.BcodigoSWIFT
								when TESTPcodigoTipo = 3 then b.BcodigoIBAN
								when TESTPcodigoTipo = 10 then b.BcodigoOtro
							end as TESTPcodigo,
							b.Bid, b.Bdescripcion as TESTPbanco, b.Bdireccion as TESTPdireccion, b.Btelefon as TESTPtelefono,
							cb.CBid, case when cb.CBTcodigo = 1 then 2 else 1 end as TESTPtipo, 
							case 
								when TESTPtipoCtaPropia = 1 then cb.CBcodigo else cb.CBcc
							end as TESTPcuenta,
							m.Miso4217 
					  from TEStransferenciaP d
						inner join CuentasBancos cb
							on d.CBid = d.CBid
						inner join Bancos b
							on b.Bid = cb.Bid
						inner join Monedas m
							on m.Mcodigo = cb.Mcodigo
					 where cb.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBid#">
                     	and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">  
				</cfquery>
				<cfloop query="rsDst">
					<cfquery datasource="#Session.DSN#">
						UPDATE TEStransferenciaP
						   SET TESTPestado        = 0,
							   <!--- Informacion del Banco --->
							   Bid                = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#rsDst.Bid#">,
							   TESTPcodigo        = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#rsDst.TESTPcodigo#">,
							   TESTPbanco         = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#rsDst.TESTPbanco#">,
							   TESTPdireccion     = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#rsDst.TESTPdireccion#">,
							   TESTPtelefono      = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#rsDst.TESTPtelefono#">,
		
							   <!--- Informacion de la Cuenta --->
							   CBid               = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#rsDst.CBid#">,
							   TESTPtipo          = <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#rsDst.TESTPtipo#">,
							<cfif rsDst.TESTPcodigoTipo EQ "0">
							   TESTPcuenta        = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#rsDst.TESTPcuenta#">,
							</cfif>
							   Miso4217           = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="3"   value="#rsDst.Miso4217#">,
							   BMUsucodigo        = #session.Usucodigo#
						 WHERE TESTPid            = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#rsDst.TESTPid#">
					</cfquery>
				</cfloop>
				<cfset modo="CAMBIO">								  				  
			</cfif>			
		<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
<cfelse>
	<cfset modo="ALTA">		
</cfif>

<form action="<cfoutput>#LvarPagina#</cfoutput><cfif isdefined('url.desde') and Trim(url.desde) eq 'rh'>?desde=rh</cfif>" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">

	<cfif modo neq 'ALTA'>
		<input name="CBid" type="hidden" value="<cfif isdefined("Form.CBid")><cfoutput>#Form.CBid#</cfoutput></cfif>">
	</cfif>

	<input name="Bid" type="hidden" value="<cfif isdefined("Form.Bid")><cfoutput>#Form.Bid#</cfoutput></cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">	
	<input name="desde" type="hidden" value="<cfif isdefined("form.desde")><cfoutput>#form.desde#</cfoutput></cfif>">
</form>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>

