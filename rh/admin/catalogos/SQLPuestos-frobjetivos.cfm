<cfparam name="action" default="Puestos.cfm">
<cfparam name="modo1" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfif isdefined("form.Cambio")>
			<cfquery name="RHDescPuestoConsulta" datasource="#session.DSN#">
				select 1 
				from RHDescriptivoPuesto a, RHPuestos b  
				where a.Ecodigo = b.Ecodigo and a.RHPcodigo = b.RHPcodigo
				and b.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and b.RHPcodigo = '#form.RHPcodigo#'
			</cfquery>
		
			<cfif isdefined("RHDescPuestoConsulta") and RHDescPuestoConsulta.RecordCount GT 0>
				<cfquery name="RHPuestoObtenerCodigo" datasource="#session.DSN#">
					select RHPcodigo 
					from RHPuestos
                    where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
	                and RHPcodigo ='#form.RHPcodigo#'
				</cfquery>
				
				<cf_dbtimestamp
					datasource="#session.dsn#"
					table="RHDescriptivoPuesto"
					redirect="SQLPuestos-frobjetivos.cfm"
					timestamp="#form.ts_rversion#"
					field1="Ecodigo" type1="numeric" value1="#session.Ecodigo#"
					field2="RHPcodigo" type2="char" value2="#RHPuestoObtenerCodigo.RHPcodigo#">

				<cfquery name="RHDescPuestoUpdate" datasource="#session.DSN#">
					update RHDescriptivoPuesto 
					set RHDPobjetivos = <cfqueryparam value="#form.TextoResp#" cfsqltype="cf_sql_longvarchar">,
					BMusumod = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
					BMfechamod = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and RHPcodigo =  (select RHPcodigo from RHPuestos
                                          where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
										  and RHPcodigo ='#form.RHPcodigo#') 
				</cfquery>
				<cfquery name="RHRHPuestosUpdate" datasource="#session.DSN#">
					update RHPuestos 
					set  BMusumod = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
						 BMfechamod = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and RHPcodigo = '#form.RHPcodigo#' 
				</cfquery>	


			<cfelse>
			    <cfquery name="RHPuestoObtenerCodigo" datasource="#session.DSN#">
					select RHPcodigo from RHPuestos
                    where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
	                and RHPcodigo ='#form.RHPcodigo#'
				</cfquery>
				
				<cfquery name="RHDescPuestoInsert" datasource="#session.DSN#">
					insert into RHDescriptivoPuesto
					(RHPcodigo, Ecodigo, BMusuario, BMfecha, RHDPobjetivos)
					values(<cfqueryparam value="#RHPuestoObtenerCodigo.RHPcodigo#" cfsqltype="cf_sql_char">,
							<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
							<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#form.TextoResp#" cfsqltype="cf_sql_longvarchar">)
				</cfquery>
				<cfquery name="RHRHPuestosUpdate" datasource="#session.DSN#">
					update RHPuestos 
					set  BMusumod = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
						 BMfechamod = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and RHPcodigo = '#form.RHPcodigo#' 
				</cfquery>				
			
			</cfif>
			<cfset modo1 = 'CAMBIO'>
		</cfif>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>	

<cfif isdefined("form.btnnuevocf")>
	<cflocation url="Puestos.cfm?o=3&sel=1&RHPcodigo=#form.RHPcodigo#">
<cfelse>

	<cfif isdefined("form.btnALTACF")>
		<!--- ya esta insertado el centro funcional --->	
		<cfquery name="rs_existe" datasource="#session.DSN#">
			select RHDPCFid, RHDPCFresp
			from RHDescriptivoPuestoCF
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPcodigo#">
			  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		</cfquery>
		
		<cfif rs_existe.recordcount gt 0>
			<cfquery datasource="#session.DSN#">
				update RHDescriptivoPuestoCF
				set RHDPCFresp = <cfqueryparam value="#form.TextoRespCF#" cfsqltype="cf_sql_longvarchar">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPcodigo#">
				  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
			</cfquery>
			<cflocation url="Puestos.cfm?o=3&sel=1&RHPcodigo=#form.RHPcodigo#">
		</cfif>

		<cfquery datasource="#session.DSN#">
			insert into RHDescriptivoPuestoCF( CFid, RHPcodigo, Ecodigo, RHDPCFresp, BMUsucodigo )
			values ( 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">,
					  	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam value="#form.TextoRespCF#" cfsqltype="cf_sql_longvarchar">,
						<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric"> )
		</cfquery>
			<cflocation url="Puestos.cfm?o=3&sel=1&RHPcodigo=#form.RHPcodigo#">
	<cfelseif isdefined("form.btnCAMBIOCF")>
		<cfquery datasource="#session.DSN#">
			update RHDescriptivoPuestoCF
			set RHDPCFresp = <cfqueryparam value="#form.TextoRespCF#" cfsqltype="cf_sql_longvarchar">
			where RHDPCFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPCFid#">
		</cfquery>
		<cflocation url="Puestos.cfm?o=3&sel=1&RHPcodigo=#form.RHPcodigo#&RHDPCFid=#form.RHDPCFid#">
	<cfelseif isdefined("form.btnBAJACF")>
		<cfquery datasource="#session.DSN#">
			delete from RHDescriptivoPuestoCF
			where RHDPCFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPCFid#">
		</cfquery>
		<cflocation url="Puestos.cfm?o=3&sel=1&RHPcodigo=#form.RHPcodigo#">
	</cfif>
</cfif>


<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="sel"    type="hidden" value="1">
	<input name="o" type="hidden" value="3">
	<input name="modo1"   type="hidden" value="<cfif isdefined("modo1")>#modo1#</cfif>">
	<cfif modo1 eq 'CAMBIO'><input name="RHPcodigo" type="hidden" value="#form.RHPcodigo#"></cfif>
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>