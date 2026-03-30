<cf_dbstruct name="#arguments.Tabla#" returnvariable="rsStruct" datasource="#arguments.conexionO#">

<cfif isdefined("rsStruct") and rsStruct.RecordCount neq 0 >
	<cfquery dbtype="query" name="rscampos">
		select *
		from rsStruct 
		where rsStruct.identity = 0
			and upper(rsStruct.name) not in ('ECODIGO','CCUENTA','TMPCCUENTA')
	</cfquery>
	
	<!---<cf_dump var="#rscampos#">--->
	
	<cfset campos = ''>
	<cfset nReg = 1 >
	
	<cfloop query="rscampos">
		<cfif  #nReg# NEQ #rscampos.recordCount#> 
			<cfset campos = campos & rscampos.name & ','>
		<cfelse>
			<cfset campos = campos & rscampos.name>
		</cfif>
		<cfset nReg = nReg + 1 >
	</cfloop>
	
<!---				<cfquery datasource="#arguments.conexionD#" name="x">
			
		<!---		USE minisif
				go--->
				ALTER TABLE minisif..CFinanciera ADD tmpCcuenta numeric(18,0) NULL
	<!---			go--->
				
			</cfquery>--->
			
	<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSNO#" returnvariable="TablaOrigen">
	<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSND#" returnvariable="TablaDestino">
	<cfset CPVigencia_O  =  #session.DSNO# & 'CPVigencia' >
	<cfset CPVigencia_D  =  #session.DSND# & 'CPVigencia' >
	
	<cfset CContables_O  = 	#session.DSNO# & 'CContables' >
	<cfset CContables_D  = 	#session.DSND# & 'CContables' >		
	<cftransaction>
		<cftry>
			<cfquery datasource="#arguments.conexionD#" name="rsExisten">
				Select Ecodigo,CFformato from CFinanciera Where Ecodigo=#EcodigoNuevo#
					and CFformato in (select CFformato from #TablaOrigen# where Ecodigo = #EcodigoViejo#)
			</cfquery>
			
<!---			<cfdump var="#rsExisten#">--->
			
			<!---<cfif isdefined("rsExisten") and rsExisten.RecordCount neq 0>
				<cfloop query="rsExisten" >
					<cfloop index = "lcampo" list = "#campos#" delimiters = ",">
						<cfquery datasource="#arguments.conexionD#" name="x">
							update CFinanciera  set  #lcampo#   = 	(select  #lcampo#   from #TablaOrigen# v
																	 Where v.Ecodigo = #EcodigoViejo# 
																		and v.CFformato = '#rsExisten.CFformato#')
								 Where Ecodigo = #EcodigoNuevo# 
										and CFformato = '#rsExisten.CFformato#'
						</cfquery>
					</cfloop>
				</cfloop>
			</cfif>--->
			
			
			<!---<cf_dump var="#arguments.conexionD#">--->
			<cfquery datasource="#arguments.conexionD#" name="x">
	<!---			insert into minisif..CFinanciera(Ecodigo, tmpCcuenta, #campos#)
					Select #EcodigoNuevo#, Ccuenta, #campos#
						From #TablaOrigen# 
						Where Ecodigo= #EcodigoViejo#
							and CFformato not in (select CFformato from #TablaDestino# a where a.Ecodigo = #EcodigoNuevo#)--->
							
					insert into minisif..CFinanciera(Ecodigo, tmpCcuenta, CPVid,
						Cmayor,CFformato,PCDcatid,CFdescripcion,CFdescripcionF,
						CFmovimiento,CFpadre,CPcuenta,BMUfechaAlta,CmayorSF,CdetSF) 
						Select 1189, Ccuenta, CPVid,Cmayor,CFformato,PCDcatid,CFdescripcion,CFdescripcionF,CFmovimiento,CFpadre,CPcuenta,BMUfechaAlta,CmayorSF,CdetSF 
							From minisif_base..CFinanciera  mb
								Where Ecodigo= 1097 
								and (select count(1) from minisif..CFinanciera a where a.Ecodigo = 1189 and CFformato=mb.CFformato)	= 0
			</cfquery>
			
			<cfquery datasource="#arguments.conexionD#" name="Actualiza">
				update CFinanciera
					set Ccuenta = (Select c.Ccuenta
						from #CContables_O# b, #CContables_D# c
							where CFinanciera.tmpCcuenta = b.Ccuenta
								and b.Ecodigo	=	#EcodigoViejo#
								and b.Cformato	=	c.Cformato
								and c.Ecodigo	=	#EcodigoNuevo#)
				Where Ecodigo	=	#EcodigoNuevo#
			</cfquery>
			
			<!---<cfdump var="#x#">--->

			<cfquery datasource="#arguments.conexionD#" name="Actualiza">
				update CFinanciera
					set CFpadre = (Select c.CFcuenta
						from #TablaOrigen# b, #TablaDestino# c
						where CFinanciera.CFpadre = b.CFcuenta
						and b.Ecodigo 	=	#EcodigoViejo#
						and b.CFformato	=	c.CFformato
						and c.Ecodigo	=	#EcodigoNuevo#)
					Where Ecodigo	=	#EcodigoNuevo#
						and CFinanciera.CFpadre is not null
			</cfquery>
			
			<cfquery datasource="#arguments.conexionD#" name="Actualiza">
				update CFinanciera
				set CPVid = (Select c.CPVid
					from #CPVigencia_O# b, #CPVigencia_D# c
						where CFinanciera.CPVid = b.CPVid
							and b.Ecodigo	=	#EcodigoViejo#
							and b.Cmayor	=	c.Cmayor
							and c.Ecodigo	=	#EcodigoNuevo#)
				Where Ecodigo	=	#EcodigoNuevo#
			</cfquery>
			
			<cfif isdefined("rsExisten") and rsExisten.RecordCount eq 0>
				<cfquery datasource="#arguments.conexionD#" name="Actualiza">
					update CFinanciera
						set Ccuenta = (Select c.Ccuenta
							from #CContables_O# b, #CContables_D# c
								where CFinanciera.tmpCcuenta = b.Ccuenta
									and b.Ecodigo	=	#EcodigoViejo#
									and b.Cformato	=	c.Cformato
									and c.Ecodigo	=	#EcodigoNuevo#)
					Where Ecodigo	=	#EcodigoNuevo#
				</cfquery>
			</cfif>				
			<cfcatch type="any">
				<cftransaction action="rollback"/>
				<cfset  ErrorMessage  =  '#cfcatch.Detail#>'>
				<cfrethrow>
			</cfcatch>
		</cftry>
	</cftransaction>
</cfif>

<cf_dump var="rsExisten">