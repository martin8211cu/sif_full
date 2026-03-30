<cfparam name="modo" default="ALTA">
<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfquery name="ABC_cuentaFormaPago" datasource="#session.DSN#">
			set nocount on

			<cfif isdefined("form.Alta")>
				declare @newVFPcodigo numeric

				insert ValorFormaPago 
						(FPcodigo, VFPnombre, VFPdefault)
				values 	(
						  <cfqueryparam value="#form.FPcodigo#" 	cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#form.VFPnombre#" 	cfsqltype="cf_sql_varchar">
						<cfif isdefined('form.VFPdefault')>
							, 1
						<cfelse>
							, 0
						</cfif>
						)
					
				select @newVFPcodigo = @@identity
				insert 	CuentaFormaPago
						(cliente_empresarial, VFPcodigo)
				values 	(
						<cfqueryparam value="#form.cliente_empresarial#" 	cfsqltype="cf_sql_numeric">
						, @newVFPcodigo
						)

				<cfif isdefined('form.VFPdefault')>
				update ValorFormaPago 
				   set VFPdefault = 0
				  from ValorFormaPago v, CuentaFormaPago c
				 where c.cliente_empresarial = <cfqueryparam value="#form.cliente_empresarial#" cfsqltype="cf_sql_numeric">
				   and c.VFPcodigo <> @newVFPcodigo
				   and c.VFPcodigo = v.VFPcodigo
				</cfif>

					insert ValorFormaPagoDatos (VFPcodigo, FPDcodigo, VFPDvalor)
					select v.VFPcodigo
						, FPDcodigo
						, ''
					from  CuentaFormaPago c
						, ValorFormaPago v
						, FormaPago fp
						, FormaPagoDatos fpd
					where c.cliente_empresarial=<cfqueryparam value="#form.cliente_empresarial#" 	cfsqltype="cf_sql_numeric">
						and c.VFPcodigo=@newVFPcodigo
						and c.VFPcodigo=v.VFPcodigo
						and v.FPcodigo=fp.FPcodigo
						and fp.FPcodigo=fpd.FPcodigo
						
					select @newVFPcodigo as newVFPcodigo
			<cfelseif isdefined("form.Cambio")>
				update ValorFormaPago
					set VFPnombre = <cfqueryparam value="#form.VFPnombre#" cfsqltype="cf_sql_varchar">
					<cfif isdefined('form.VFPdefault')>
						, VFPdefault=1
					<cfelse>
						, VFPdefault=0
					</cfif>
				 from ValorFormaPago v, CuentaFormaPago c
				where c.cliente_empresarial = <cfqueryparam value="#form.cliente_empresarial#" cfsqltype="cf_sql_numeric">
				  and c.VFPcodigo = <cfqueryparam value="#form.VFPcodigo#" cfsqltype="cf_sql_numeric">
				  and c.VFPcodigo = v.VFPcodigo
			  
				<cfif isdefined('form.VFPdefault')>
					update ValorFormaPago 
					   set VFPdefault = 0
					  from ValorFormaPago v, CuentaFormaPago c
					 where c.cliente_empresarial = <cfqueryparam value="#form.cliente_empresarial#" cfsqltype="cf_sql_numeric">
					   and c.VFPcodigo <> <cfqueryparam value="#form.VFPcodigo#" cfsqltype="cf_sql_numeric">
					   and c.VFPcodigo = v.VFPcodigo
				</cfif>

				<cfloop index="cont" from="1" to="#form.FPDcantidad#">
					<cfif evaluate("form.FPDcodigo2_#cont#") EQ "">
						insert ValorFormaPagoDatos (VFPcodigo,FPDcodigo,VFPDvalor)
						values (
								<cfqueryparam value="#form.VFPcodigo#" cfsqltype="cf_sql_numeric">
							 ,	<cfqueryparam value="#evaluate("form.FPDcodigo_#cont#")#" cfsqltype="cf_sql_numeric">
							 , 	<cfqueryparam value="#evaluate("form.VFPDvalor_#cont#")#" cfsqltype="cf_sql_varchar">
							 )
					<cfelse>
						update ValorFormaPagoDatos
							set VFPDvalor = <cfqueryparam value="#evaluate("form.VFPDvalor_#cont#")#" cfsqltype="cf_sql_varchar">
						where VFPcodigo = <cfqueryparam value="#form.VFPcodigo#" cfsqltype="cf_sql_numeric">
							and FPDcodigo = <cfqueryparam value="#evaluate("form.FPDcodigo_#cont#")#" cfsqltype="cf_sql_numeric">
					</cfif>
				</cfloop>
				  <cfset modo = 'CAMBIO'>
			<cfelseif isdefined("form.Baja")>
				delete CuentaFormaPago
				 where cliente_empresarial = <cfqueryparam value="#form.cliente_empresarial#" cfsqltype="cf_sql_numeric">
				   and VFPcodigo = <cfqueryparam value="#form.VFPcodigo#" cfsqltype="cf_sql_numeric">

				delete ValorFormaPagoDatos
				where VFPcodigo= <cfqueryparam value="#form.VFPcodigo#" cfsqltype="cf_sql_numeric">
		
				delete ValorFormaPago
				where VFPcodigo= <cfqueryparam value="#form.VFPcodigo#" cfsqltype="cf_sql_numeric">
			</cfif>

			set nocount off				
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>	

<cfif not isdefined('form.VFPcodigo') and isdefined('form.Alta')>
	<cfset valorVFPcodigo = ABC_cuentaFormaPago.newVFPcodigo>
	<cfset modo="CAMBIO">
<cfelseif isdefined('form.Cambio')>
	<cfset valorVFPcodigo = form.VFPcodigo>
</cfif>

<cfoutput>
	<form action="CuentaPrincipal_tabs.cfm" method="post" name="sql">
		<input name="cliente_empresarial"   type="hidden" value="#form.cliente_empresarial#">
		<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<cfif modo eq 'CAMBIO'><input name="VFPcodigo" type="hidden" value="#valorVFPcodigo#"></cfif>
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
	</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
