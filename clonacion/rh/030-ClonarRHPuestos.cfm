<cf_dbstruct name="#arguments.Tabla#" returnvariable="rsStruct" datasource="#arguments.conexionO#">

<cfif isdefined("rsStruct") and rsStruct.RecordCount neq 0 >
	<cfquery dbtype="query" name="rscampos">
		select *
		from rsStruct 
		where rsStruct.identity = 0
			and upper(rsStruct.name) not in ('ECODIGO','RHTPID','RHPEID','RHGMID')
	</cfquery>
	
	<cfset campos = ''>
	<cfset tipos  = ''>
	<cfset nReg = 1 >
	
	<cfloop query="rscampos">
		<cfif  #nReg# NEQ #rscampos.recordCount#> 
			<cfset campos = campos & rscampos.name & ','>
			<cfset tipos  = tipos & rscampos.cf_type & ','>
		<cfelse>
			<cfset campos = campos & rscampos.name>
			<cfset tipos  = tipos & rscampos.cf_type & ','>
		</cfif>
		<cfset nReg = nReg + 1 >
	</cfloop>
</cfif>
<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSNO#" returnvariable="TablaOrigen">
<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSND#" returnvariable="TablaDestino">

<cf_dbdatabase table="RHPuestosExternos" datasource="#form.DSNO#" returnvariable="RHPuestosExternos_O">
<cf_dbdatabase table="RHPuestosExternos" datasource="#form.DSND#" returnvariable="RHPuestosExternos_D">

<cf_dbdatabase table="CFuncional" datasource="#form.DSNO#" returnvariable="CFuncional_O">
<cf_dbdatabase table="CFuncional" datasource="#form.DSND#" returnvariable="CFuncional_D">

<cf_dbdatabase table="RHMaestroPuestoP" datasource="#form.DSNO#" returnvariable="RHMaestroPuestoP_O">
<cf_dbdatabase table="RHMaestroPuestoP" datasource="#form.DSND#" returnvariable="RHMaestroPuestoP_D">

<cf_dbdatabase table="RHTPuestos" datasource="#form.DSNO#" returnvariable="RHTPuestos_O">
<cf_dbdatabase table="RHTPuestos" datasource="#form.DSND#" returnvariable="RHTPuestos_D">

<cf_dbdatabase table="RHGrupoMaterias" datasource="#form.DSNO#" returnvariable="RHGrupoMaterias_O">
<cf_dbdatabase table="RHGrupoMaterias" datasource="#form.DSND#" returnvariable="RHGrupoMaterias_D">

<cfif not isdefined("form.chkSQL")>
	<cftransaction>
		<cftry>
			<cfquery datasource="#arguments.conexionD#" name="rsExisten">
				Select Ecodigo,RHPcodigo from RHPuestos Where Ecodigo=#EcodigoNuevo#
					and RHPcodigo in (select RHPcodigo from #TablaOrigen# where Ecodigo = #EcodigoViejo#)
			</cfquery>
			<!---<cf_dump var="#rsExisten#">--->
			
			<cfquery datasource="#arguments.conexionD#" name="rsTmp">
				ALTER TABLE RHPuestos ADD RHTPidtmp numeric(18,0) NULL
				ALTER TABLE RHPuestos ADD RHPEidtmp numeric(18,0) NULL
				ALTER TABLE RHPuestos ADD RHGMidtmp numeric(18,0) NULL
			</cfquery>
			
			<!---<cfif isdefined("rsExisten") and rsExisten.RecordCount neq 0>
				<cfloop query="rsExisten" >
					<cfloop index = "lcampo" list = "#campos#" delimiters = ",">
						<cfquery datasource="#arguments.conexionD#" name="x">
							update RHPuestos  set  #lcampo#   = 	(select  #lcampo#   from #TablaOrigen# v
																	 Where v.Ecodigo = #EcodigoViejo# 
																		and v.RHPcodigo = '#rsExisten.RHPcodigo#' )
								 Where Ecodigo = #EcodigoNuevo# 
										and RHPcodigo = '#rsExisten.RHPcodigo#'
						</cfquery>
					</cfloop>
				</cfloop>
			</cfif>--->
			
			<cfquery datasource="#arguments.conexionD#" name="x">
				insert into RHPuestos(Ecodigo, RHTPidtmp, RHPEidtmp, RHGMidtmp, #campos#)
					Select #EcodigoNuevo#, RHTPid, RHPEid, RHGMid, #campos#
						From #TablaOrigen# 
							Where Ecodigo= #EcodigoViejo#
								and RHPcodigo not in (select RHPcodigo from #TablaDestino# a where a.Ecodigo = #EcodigoNuevo#)
			</cfquery>
			
			<cfquery datasource="#arguments.conexionD#" name="x">
				update RHPuestos set RHPEid = (Select c.RHPEid
					from #RHPuestosExternos_O# b, #RHPuestosExternos_D# c
						Where RHPuestos.RHPEidtmp = b.RHPEid
							and b.Ecodigo			=	#EcodigoViejo#
							and b.RHPEcodigo		=	c.RHPEcodigo
							and b.RHPEdescripcion	=	c.RHPEdescripcion
							and c.Ecodigo			=	#EcodigoNuevo#)
				Where Ecodigo = #EcodigoNuevo#
			</cfquery>

			<cfquery datasource="#arguments.conexionD#" name="x">
				update RHPuestos set RHGMid = (Select c.RHGMid
					from #RHGrupoMaterias_O# b, #RHGrupoMaterias_D# c
						Where RHPuestos.RHGMidtmp = b.RHGMid
							and b.Ecodigo			=	#EcodigoViejo#
							and b.RHGMcodigo		=	c.RHGMcodigo
							and b.Descripcion		=	c.Descripcion
							and c.Ecodigo			=	#EcodigoNuevo#)
				Where Ecodigo = #EcodigoNuevo#
			</cfquery>
	
			<cfquery datasource="#arguments.conexionD#" name="x">
				update RHPuestos set RHTPid = (Select c.RHTPid
					from #RHTPuestos_O# b, #RHTPuestos_D# c
						Where RHPuestos.RHTPidtmp 	= b.RHTPid
							and b.Ecodigo			=	#EcodigoViejo#
							and b.RHTPcodigo		=	c.RHTPcodigo
							and b.RHTPdescripcion	=	c.RHTPdescripcion
							and c.Ecodigo			=	#EcodigoNuevo#)
				Where Ecodigo = #EcodigoNuevo#
			</cfquery>			
			
			<cfquery datasource="#arguments.conexionD#" name="x">
				update RHPuestos set CFid = (Select c.CFid
					from #CFuncional_O# b, #CFuncional_D# c
						Where RHPuestos.CFid = b.CFid
							and b.Ecodigo	=	#EcodigoViejo#
							and b.CFcodigo	=	c.CFcodigo
							and c.Ecodigo	=	#EcodigoNuevo#)
					Where Ecodigo = #EcodigoNuevo#
			</cfquery>		
			
			<cfquery datasource="#arguments.conexionD#" name="x">
				update RHPuestos set RHMPPid = (Select MAX(c.RHMPPid)
					from #RHMaestroPuestoP_O# b, #RHMaestroPuestoP_D# c
						Where RHPuestos.RHMPPid = b.RHMPPid
							and b.Ecodigo		=	#EcodigoViejo#
							and b.RHMPPcodigo	=	c.RHMPPcodigo
							and c.Ecodigo		=	#EcodigoNuevo#)
					Where Ecodigo = #EcodigoNuevo#
			</cfquery>	

			<cfcatch type="any">
				<cftransaction action="rollback"/>
				<cfset  ErrorMessage  =  '#cfcatch.Detail#>'>
				<!---<cfthrow message="#ErrorMessage#">--->
				<cfrethrow>
			</cfcatch>
		</cftry>
	</cftransaction>
	<cfquery datasource="#arguments.conexionD#" name="rsTmp">
			ALTER TABLE RHPuestos DROP RHTPidtmp, RHPEidtmp,RHGMidtmp
	</cfquery>
</cfif>

<!---<cf_dump var="x">--->


