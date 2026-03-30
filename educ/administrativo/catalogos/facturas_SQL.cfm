<cfset modo = "ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.AltaD")>
		<cfquery name="rsSec" datasource="#Session.DSN#">
			select isnull(max(FADsecuencia), 0) as FADsecuencia
			from FacturaEduDetalle
		</cfquery>
		<cfif isdefined('rsSec') and rsSec.recordCount GT 0>
			<cfset varSecDetFact = rsSec.FADsecuencia + 1>	
		<cfelse>
			<cfset varSecDetFact = 0>
		</cfif>
	</cfif>
	
	<cftry>
		<cfquery name="ABC_tiposCiclos" datasource="#Session.DSN#">
			set nocount on
				<cfif isdefined("Form.Alta")>
					insert FacturaEdu 
					(FACfecha, FACnombre, FACmonto, FACestado, Ecodigo, Apersona, FACtipo, FACobservaciones, FACmonedaISO, FACtipoCambio, FACsaldo)
					values ( 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSdateformat(Form.FACfecha,'YYYYMMDD')#">
						, <cfqueryparam value="#form.FACnombre#" cfsqltype="cf_sql_varchar">
						, 0
						, <cfqueryparam value="#form.FACestado#" cfsqltype="cf_sql_tinyint">
						, <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#form.codApersona#" cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#form.FACtipo#" cfsqltype="cf_sql_tinyint">
						, <cfqueryparam value="#form.FACobservaciones#" cfsqltype="cf_sql_varchar">
						, 'CRC'
						, 1
						, 0)
				
					select @@identity as newFactura
				
					<cfset modo="CAMBIO">
				<cfelseif isdefined("Form.Baja")>
					delete FacturaEduDetalle
					where FACcodigo = <cfqueryparam value="#form.FACcodigo#" cfsqltype="cf_sql_numeric">
									
					delete FacturaEdu
					where FACcodigo = <cfqueryparam value="#form.FACcodigo#" cfsqltype="cf_sql_numeric">
					   
					<cfset modo="ALTA">
				<cfelseif isdefined("Form.Cambio")>
					update FacturaEdu set
						FACnombre = <cfqueryparam value="#form.FACnombre#" cfsqltype="cf_sql_varchar">,
						FACfecha = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSdateformat(Form.FACfecha,'YYYYMMDD')#">, 					
						FACestado = <cfqueryparam value="#form.FACestado#" cfsqltype="cf_sql_tinyint">,
						FACtipo = <cfqueryparam value="#form.FACtipo#" cfsqltype="cf_sql_tinyint">,
						FACobservaciones = <cfqueryparam value="#form.FACobservaciones#" cfsqltype="cf_sql_varchar">
					where FACcodigo = <cfqueryparam value="#form.FACcodigo#" cfsqltype="cf_sql_numeric">
					  
					<cfset modo="CAMBIO">
<!--- DETALLE DE FACTURA --->					
				<cfelseif isdefined("Form.AltaD")>
					insert FacturaEduDetalle 
					(FACcodigo, FADsecuencia, TTcodigo, FADdescripcion, FADcantidad, FADunitario, FADmonto, FADdescuento, FADexento)
					values (
						<cfqueryparam value="#form.FACcodigo#" cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#varSecDetFact#" cfsqltype="cf_sql_tinyint">
						, <cfqueryparam value="#form.TTcodigo#" cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#form.FADdescripcion#" cfsqltype="cf_sql_varchar">
						, <cfqueryparam value="#form.FADcantidad#" cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#form.FADunitario#" cfsqltype="cf_sql_float">
						, <cfqueryparam value="#(form.FADcantidad * form.FADunitario)#" cfsqltype="cf_sql_float">
						, <cfqueryparam value="#form.FADdescuento#" cfsqltype="cf_sql_float">
						<cfif isdefined('form.FADexento')>
							, 1
						<cfelse>
							, 0
						</cfif>)

					<cfset modo="CAMBIO">
					<cfset modoD="CAMBIO">
				<cfelseif isdefined("Form.BajaD")>					
					delete FacturaEduDetalle
					where FACcodigo = <cfqueryparam value="#form.FACcodigo#" cfsqltype="cf_sql_numeric">
						and FADsecuencia = <cfqueryparam value="#form.FADsecuencia#" cfsqltype="cf_sql_tinyint">
						
					<cfset modo="CAMBIO">
					<cfset modoD="ALTA">					  										
				<cfelseif isdefined("Form.CambioD")>				
					update FacturaEduDetalle set
						TTcodigo = <cfqueryparam value="#form.TTcodigo#" cfsqltype="cf_sql_numeric">,
						FADdescripcion = <cfqueryparam value="#form.FADdescripcion#" cfsqltype="cf_sql_varchar">,
						FADcantidad = <cfqueryparam value="#form.FADcantidad#" cfsqltype="cf_sql_numeric">,						
						FADunitario = <cfqueryparam value="#form.FADunitario#" cfsqltype="cf_sql_float">,						
						FADmonto = <cfqueryparam value="#(form.FADcantidad * form.FADunitario)#" cfsqltype="cf_sql_float">,
						FADdescuento = <cfqueryparam value="#form.FADdescuento#" cfsqltype="cf_sql_float">
						<cfif isdefined('form.FADexento')>
							, FADexento = 1
						<cfelse>
							, FADexento = 0
						</cfif>						
					where FACcodigo = <cfqueryparam value="#form.FACcodigo#" cfsqltype="cf_sql_numeric">
						and FADsecuencia = <cfqueryparam value="#form.FADsecuencia#" cfsqltype="cf_sql_tinyint">
					  
					<cfset modo="CAMBIO">
					<cfset modoD="CAMBIO">					  				
				<cfelseif isdefined("Form.NuevoD")>
					<cfset modo="CAMBIO">
					<cfset modoD="ALTA">
				</cfif>
			set nocount off
		</cfquery>

		<!--- Calculo de los campos de Monto, Descuento e Impuesto de la tabla de FacturaEdu --->
		<cfif isdefined('modoD') and not isdefined('form.NuevoD')>
			<cfif isdefined('form.AltaD')>
				<cfset codSecuencia = varSecDetFact>
			<cfelseif isdefined('form.FADsecuencia') and form.FADsecuencia NEQ ''>
				<cfset codSecuencia = form.FADsecuencia>
			</cfif>

			<cfif isdefined('codSecuencia') and codSecuencia NEQ ''>
				<cfquery name="C_ActFactura" datasource="#Session.DSN#">
					select FADexento
						, (FADcantidad * FADunitario) as monto
						, FADdescuento
						, ((FADcantidad * FADunitario) - FADdescuento) as Bruto
						, (((FADcantidad * FADunitario) - FADdescuento) * 0.13 ) as Impuesto
						, ((FADcantidad * FADunitario) + (((FADcantidad * FADunitario) - FADdescuento) * 0.13 )) as Neto
					from FacturaEduDetalle fd
						, FacturaEdu f
					where fd.FACcodigo=<cfqueryparam value="#form.FACcodigo#" cfsqltype="cf_sql_numeric">
						and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						and fd.FACcodigo=f.FACcodigo
					order by FADdescripcion
				</cfquery>
				
				<cfset montoDet = 0>
				<cfset montoEnc = 0>
				<cfset descuento = 0>					
				<cfset impues = 0>					
				<cfif isdefined('C_ActFactura') and C_ActFactura.recordCount GT 0>					
					<cfloop query="C_ActFactura">
						<cfset montoDet = montoDet + C_ActFactura.monto>
						<cfset montoEnc = montoEnc + (C_ActFactura.monto - C_ActFactura.FADdescuento)>
						<cfset descuento = descuento + C_ActFactura.FADdescuento>
						<cfif C_ActFactura.FADexento EQ 0>
							<cfset impues = impues + ((C_ActFactura.monto - C_ActFactura.FADdescuento) * 0.13)>
						</cfif>
					</cfloop>
				</cfif>
				
				<cfquery name="C_Factura" datasource="#Session.DSN#">
					set nocount on
						update FacturaEdu set
							FACmonto 		= <cfqueryparam value="#montoEnc#" cfsqltype="cf_sql_float">,
							FACimpuesto 	= <cfqueryparam value="#impues#" cfsqltype="cf_sql_float">,								
							FACdescuento 	= <cfqueryparam value="#descuento#" cfsqltype="cf_sql_float">
						where FACcodigo = <cfqueryparam value="#form.FACcodigo#" cfsqltype="cf_sql_numeric">
					set nocount off
				</cfquery>
			</cfif>
		</cfif>	
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<cfif isdefined("Form.Alta") and isdefined('ABC_tiposCiclos') and ABC_tiposCiclos.recordCount GT 0>
	<cfset nuevaFact = ABC_tiposCiclos.newFactura>
</cfif>

<form action="facturas.cfm" method="post" name="sql">
	<cfoutput>
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="codApersona" type="hidden" id="codApersona" value="<cfif isdefined("form.codApersona") and form.codApersona NEQ ''>#form.codApersona#</cfif>">	
		<input name="FACcodigo" id="FACcodigo" type="hidden" value="<cfif isdefined("Form.FACcodigo") and modo NEQ 'ALTA'>#Form.FACcodigo#<cfelseif isdefined('nuevaFact')>#nuevaFact#</cfif>">
		<cfif isdefined('modoD') and not isdefined('form.NuevoD') AND not isdefined('form.BajaD')>
			<input name="FADsecuencia" id="FADsecuencia" type="hidden" value="#codSecuencia#">	
		</cfif>
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
	</cfoutput>	
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
