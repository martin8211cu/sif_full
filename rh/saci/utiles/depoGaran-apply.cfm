s<cfset valSufijo = "">
<cfif isdefined('cargaSufijo') and cargaSufijo NEQ ''>
	<cfset valSufijo = cargaSufijo>	
</cfif>

<cfif isdefined('modo') and modo EQ 'CAMBIO' and isdefined("form.Gid#valSufijo#") and Evaluate("form.Gid#valSufijo# NEQ ''")>
	
		<cfif isdefined("form.Gtipo#valSufijo#") and ListFind('10',Evaluate('form.Gtipo#valSufijo#'))>					
			
			<cfquery name="rsgarantias" datasource="#Session.DSN#">
				select DEPNUM
				from ISBgarantia	
				where Gid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('Form.Gid#valSufijo#')#">
			</cfquery>	
			
			 <cfquery name="rsDEPDOC" datasource="SACISIIC">
				select count(1) as cant
				from SSXDEP	
				where DEPDOC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('form.Gref#valSufijo#')#">
				and DEPNUM != <cfqueryparam cfsqltype="cf_sql_float" value="#rsgarantias.DEPNUM#">
			</cfquery>
				
			<cfif isdefined('rsDEPDOC') and  rsDEPDOC.cant gt 0>					
				<cfthrow message="Error; La Referencia #Evaluate('form.Gref#valSufijo#')# ya existe.">
			</cfif>	
		</cfif>
	
	<cfinvoke component="saci.comp.ISBgarantia" method="Cambio">
		<cfinvokeargument name="Gid" value="#Evaluate('form.Gid#valSufijo#')#">
		<cfinvokeargument name="Contratoid" value="#Evaluate('form.Contratoid#valSufijo#')#">
		<cfif isdefined("Form.EFid#valSufijo#") and Len(Trim(Evaluate('form.EFid#valSufijo#')))>
			<cfif isdefined("form.Gtipo#valSufijo#") and ListFind('3,9,10',Evaluate('form.Gtipo#valSufijo#'))>
			<cfinvokeargument name="EFid" value="#Evaluate('form.EFid#valSufijo#')#">
			</cfif>
		</cfif>
		<cfif isdefined("Form.Miso4217#valSufijo#") and Len(Trim(Evaluate('form.Miso4217#valSufijo#')))>
			<cfinvokeargument name="Miso4217" value="#Evaluate('form.Miso4217#valSufijo#')#">
		</cfif>
		<cfif isdefined("Form.Gtipo#valSufijo#") and Len(Trim(Evaluate('Form.Gtipo#valSufijo#')))>
			<cfinvokeargument name="Gtipo" value="#Evaluate('form.Gtipo#valSufijo#')#">
		</cfif>	
		<cfif isdefined("Form.Gref#valSufijo#") and Len(Trim(Evaluate('Form.Gref#valSufijo#')))>
			<cfinvokeargument name="Gref" value="#Evaluate('form.Gref#valSufijo#')#">
		</cfif>	
		<cfif isdefined("Form.Gmonto#valSufijo#") and Len(Trim(Evaluate('Form.Gmonto#valSufijo#')))>
			<cfinvokeargument name="Gmonto" value="#Replace(Evaluate('form.Gmonto#valSufijo#'),',','','all')#">
		</cfif>
		<cfif isdefined("Form.Ginicio#valSufijo#") and Len(Trim(Evaluate('Form.Ginicio#valSufijo#')))>
			<cfif isdefined("form.Gtipo#valSufijo#") and ListFind('3,9,10',Evaluate('form.Gtipo#valSufijo#'))>
				<cfinvokeargument name="Ginicio" value="#LSParseDateTime(Evaluate('form.Ginicio#valSufijo#'))#">
			</cfif>
		</cfif>
		<cfinvokeargument name="Gvence" value="#CreateDate(6100, 01, 01)#">
		<cfif isdefined("Form.Gcustodio#valSufijo#") and Len(Trim(Evaluate('Form.Gcustodio#valSufijo#')))>
			<cfinvokeargument name="Gcustodio" value="#Evaluate('form.Gcustodio#valSufijo#')#">
		</cfif>	
		<cfinvokeargument name="Gestado" value="S">
		<cfif isdefined("Form.Gobs#valSufijo#") and Len(Trim(Evaluate('Form.Gobs#valSufijo#')))>
			<cfinvokeargument name="Gobs" value="#Evaluate('form.Gobs#valSufijo#')#">
		</cfif>		
	</cfinvoke>
<cfelse>
	<cfif isdefined('form.CTid') 
			and form.CTid NEQ '' 
			and isdefined('loginid') 
			and len(trim(loginid)) GT 0>
	
		<cfset contrato = "">	
		<!--- ALTA --->
		<cfif isdefined('form.contratoid') and len(trim(form.contratoid)) GT 0>
			<cfset contrato = form.contratoid>	
		<cfelseif isdefined('form.pkg_rep') and len(trim(form.pkg_rep)) GT 0>
			<cfset contrato = form.pkg_rep>
		<cfelseif isdefined('form.pkg') and len(trim(form.pkg)) GT 0>
			<cfset contrato = form.pkg>		
		</cfif>
	
		<cfif len(trim(contrato))>
			<cfset llaveGaran = 'T' & contrato & '_' & loginid & '_'>	
			<cfquery name="rsGARAN" datasource="#session.DSN#">
				select isnull(max(convert(int,substring(Gid,#len(llaveGaran) + 1#,255))),0) as maxId
				from ISBgarantia
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and (
						Gid like '#llaveGaran#[0-9]' or
						Gid like '#llaveGaran#[0-9][0-9]' or					
						Gid like '#llaveGaran#[0-9][0-9][0-9]' or					
						Gid like '#llaveGaran#[0-9][0-9][0-9][0-9]' or					
						Gid like '#llaveGaran#[0-9][0-9][0-9][0-9][0-9]' or					
						Gid like '#llaveGaran#[0-9][0-9][0-9][0-9][0-9][0-9]' or					
						Gid like '#llaveGaran#[0-9][0-9][0-9][0-9][0-9][0-9][0-9]' or					
						Gid like '#llaveGaran#[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
			</cfquery>
	
			<cfif isdefined('rsGARAN') and rsGARAN.recordCount GT 0>
				<cfset maxNum = rsGARAN.maxId + 1>
				
				<cfset llaveGaran = llaveGaran & NumberFormat(maxNum,"00000000")>
			<cfelse>
				<cfset llaveGaran = llaveGaran & '00000001'>
			</cfif>
	
			<cfif isdefined("form.Gtipo#valSufijo#") and ListFind('10',Evaluate('form.Gtipo#valSufijo#')) and Len(Trim(Evaluate('form.Gref#valSufijo#')))>			

				<cfquery name="rsDEPDOC" datasource="SACISIIC">
					select count(1) as cant
					from SSXDEP
					where DEPDOC = <cfqueryparam cfsqltype="cf_sql_char" value="#Evaluate('form.Gref#valSufijo#')#">
				</cfquery>	
					
				<cfif isdefined('rsDEPDOC') and rsDEPDOC.cant gt 0>
					<cfthrow message="Error; La  #Evaluate('form.Gref#valSufijo#')# ya existe.">
				</cfif>	
			</cfif>			
			<cfinvoke component="saci.comp.ISBgarantia" method="Alta">
				<cfinvokeargument name="Gid" value="#llaveGaran#">
				<cfinvokeargument name="Contratoid" value="#contrato#">
				<cfif isdefined("Form.EFid#valSufijo#") and Len(Trim(Evaluate('form.EFid#valSufijo#')))>			
					<cfif isdefined("form.Gtipo#valSufijo#") and ListFind('3,9,10',Evaluate('form.Gtipo#valSufijo#'))>
					<cfinvokeargument name="EFid" value="#Evaluate('form.EFid#valSufijo#')#">
					</cfif>
				</cfif>					
				<cfif isdefined("Form.Miso4217#valSufijo#") and Len(Trim(Evaluate('form.Miso4217#valSufijo#')))>
					<cfinvokeargument name="Miso4217" value="#Evaluate('form.Miso4217#valSufijo#')#">
				</cfif>					
				<cfinvokeargument name="Gtipo" value="#Evaluate('form.Gtipo#valSufijo#')#">
				<cfif isdefined("Form.Gref#valSufijo#") and Len(Trim(Evaluate('form.Gref#valSufijo#')))>
					<cfinvokeargument name="Gref" value="#Evaluate('form.Gref#valSufijo#')#">
				</cfif>			
				<cfif isdefined("Form.Gmonto#valSufijo#") and Len(Trim(Evaluate('Form.Gmonto#valSufijo#')))>
					<cfinvokeargument name="Gmonto" value="#Replace(Evaluate('form.Gmonto#valSufijo#'),',','','all')#">
				</cfif>					
				<cfif isdefined("Form.Ginicio#valSufijo#") and Len(Trim(Evaluate('Form.Ginicio#valSufijo#')))>
					<cfinvokeargument name="Ginicio" value="#LSParseDateTime(Evaluate('form.Ginicio#valSufijo#'))#">
				</cfif>					
				<cfinvokeargument name="Gvence" value="#CreateDate(6100, 01, 01)#">
				<cfif isdefined("Form.Gcustodio#valSufijo#") and Len(Trim(Evaluate('form.Gcustodio#valSufijo#')))>
					<cfinvokeargument name="Gcustodio" value="#Evaluate('form.Gcustodio#valSufijo#')#">
				</cfif>				
				<cfinvokeargument name="Gestado" value="S">
				<cfif isdefined("Form.Gobs#valSufijo#") and Len(Trim(Evaluate('form.Gobs#valSufijo#')))>
					<cfinvokeargument name="Gobs" value="#Evaluate('form.Gobs#valSufijo#')#">
				</cfif>		
			</cfinvoke>				
		<cfelse>
			<cfthrow message="Error, la llave del contrato no se encuentra, no se puede insertar el deposito de garantia.">
		</cfif>
	</cfif>
</cfif>