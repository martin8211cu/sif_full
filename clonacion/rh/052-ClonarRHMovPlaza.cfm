<cf_dbstruct name="#arguments.Tabla#" returnvariable="rsStruct" datasource="#arguments.conexionO#">

<!---<cf_dump var="#form#">--->

<cfif isdefined("rsStruct") and rsStruct.RecordCount neq 0 >
	<cfquery dbtype="query" name="rscampos">
		select *
		from rsStruct 
		where rsStruct.identity = 0
			and upper(rsStruct.name) not in ('ECODIGO')
	</cfquery>

	<!---<cf_dump var="#rscampos#">--->
	
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


campos
<cf_dump var="#campos#">


<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSNO#" returnvariable="TablaOrigen">
<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSND#" returnvariable="TablaDestino">

<cf_dbdatabase table="#arguments.Padre#" datasource="#form.DSNO#" returnvariable="PadreOrigen">
<cf_dbdatabase table="#arguments.Padre#" datasource="#form.DSND#" returnvariable="PadreDestino">

<cfif not isdefined("form.chkSQL")>
	<cftransaction>
		<cftry>
			<!---<cfquery datasource="#arguments.conexionD#" name="rsExisten">
				Select Ecodigo, RHTMcodigo from RHTipoMovimiento Where Ecodigo=#EcodigoNuevo#
					and RHTMcodigo in (select RHTMcodigo from #TablaOrigen# where Ecodigo = #EcodigoViejo#)
			</cfquery>
			
				<!---<cfdump var="#rsExisten#">--->

			<cfif isdefined("rsExisten") and rsExisten.RecordCount neq 0>
				<cfloop query="rsExisten" >
					<cfloop index = "lcampo" list = "#campos#" delimiters = ",">
						<cfquery datasource="#arguments.conexionD#" name="x">
							update RHTipoMovimiento  set  #lcampo#   = 	(select  #lcampo#   from #TablaOrigen# v
																	 Where v.Ecodigo = #EcodigoViejo# 
																		and v.RHTMcodigo = '#rsExisten.RHTMcodigo#' )
								 Where Ecodigo = #EcodigoNuevo# 
										and RHTMcodigo = '#rsExisten.RHTMcodigo#'
						</cfquery>
					</cfloop>
				</cfloop>--->
				
				<!---<cfquery datasource="#arguments.conexionD#">
					delete from RHTPuestos Where Ecodigo=#EcodigoNuevo#
						and RHTPcodigo in (select RHTPcodigo from #TablaOrigen# where Ecodigo = #EcodigoViejo#)
				</cfquery>

			</cfif>--->
			<!---RHPPcodigo, RHPPdescripcion,  RHPPfechav, Mcodigo,  BMfecha, a.BMUsucodigo--->
			<cfquery datasource="#arguments.conexionD#" name="x">
		<!---	RHMPid NUMERIC(18,0) IDENTITY,
        Ecodigo INT,
        RHPPid NUMERIC(18,0) NULL,
        RHPPcodigo CHAR(10) NULL,
        RHPPdescripcion VARCHAR(80) NULL,
        RHMPPid NUMERIC(18,0) NULL,
        RHCid NUMERIC(18,0) NULL,
        RHTTid NUMERIC(18,0) NULL,
        RHTMid NUMERIC(18,0),
        RHMPfdesde DATETIME NULL,
        RHMPfhasta DATETIME NULL,
        RHMPestado CHAR(1) DEFAULT 'P',
        RHMPnegociado CHAR(1),
        RHMPmonto MONEY DEFAULT 0.00,
        Mcodigo NUMERIC(18,0) NULL,
        id_tramite NUMERIC(18,0) NULL,
        RHMPestadoplaza CHAR(1) DEFAULT 'A',
        CFidant NUMERIC(18,0) NULL,
        CFidnuevo NUMERIC(18,0) NULL,
        CFidcostoant NUMERIC(18,0) NULL,
        CFidcostonuevo NUMERIC(18,0) NULL,
        BMfecha DATETIME,
        BMUsucodigo NUMERIC(18,0),
        ts_rversion TIMESTAMP NULL,
        RHFid NUMERIC(18,0) NULL,
        CPcuenta NUMERIC(18,0) NULL,
        CFcuenta NUMERIC(18,0) NULL,
        RHPcodigo CHAR(10) NULL,
        NAP NUMERIC(18,0) NULL,
        NAP2 NUMERIC(18,0) NULL,
        NRP NUMERIC(18,0) NULL,--->
		
			insert RHMovPlaza 
				(Ecodigo, RHPPid, RHPPcodigo, RHPPdescripcion, RHMPPid, RHCid, RHTTid, RHTMid, RHMPfdesde, RHMPfhasta, RHMPestado, RHMPnegociado, RHMPmonto, 
				 Mcodigo, id_tramite, RHMPestadoplaza, CFidant, CFidnuevo, CFidcostoant, CFidcostonuevo, BMfecha, BMUsucodigo, CPcuenta, CFcuenta)
				
				select a.Ecodigo, a.RHPPid, a.RHPPcodigo, a.RHPPdescripcion,  null, null, null, d.RHTMid, '19000101', '61000101', 'A', 'T', 1000000, 
				b.Mcodigo, null, 'A', null, null, null, null, getdate(),a.BMUsucodigo, null, null
				
				from RHPlazaPresupuestaria a, Empresas b, RHPlazas c, RHTipoMovimiento  d
				where a.Ecodigo 	=	#EcodigoNuevo#
				and b.Ecodigo 		=	a.Ecodigo
				and b.Ecodigo 		= 	c.Ecodigo
				and a.Ecodigo 		= 	d.Ecodigo
				and a.RHPPcodigo 	=	c.RHPcodigo
				and not exists (select 1 from RHMovPlaza x where x.Ecodigo = a.Ecodigo and x.RHPPid = a.RHPPid)
				
				<!---insert into RHTipoMovimiento(Ecodigo, #campos#)
					select #EcodigoNuevo#, #campos# 
						from   #TablaOrigen# a, #PadreOrigen# b
							where  a.Ecodigo	=	#EcodigoViejo#
								and    a.RHPPcodigo	=	b.RHPcodigo  
								and    b.Ecodigo	=	#EcodigoViejo#--->
									
			</cfquery>
			<cfcatch type="database">
				<cftransaction action="rollback"/>
				<cfset  ErrorMessage  =  '#cfcatch.Detail#>'>
				<cfrethrow>

			</cfcatch>
		</cftry>
	</cftransaction>
<cfelse>
	<cfquery datasource="#arguments.conexionD#" name="x">
	
	<!---RHPPid, RHPPcodigo, RHPPdescripcion, RHMPPid,RHCid, RHTTid, RHTMid, 
	RHMPfdesde, RHMPfhasta, RHMPestado, RHMPnegociado, RHMPmonto, Mcodigo,
	id_tramite, RHMPestadoplaza, CFidant, CFidnuevo, CFidcostoant, CFidcostonuevo,
	BMfecha, CPcuenta, CFcuenta, RHFid, RHPcodigo, NAP, NAP2, NRP--->
	
	
		select #EcodigoNuevo# as Ecodigo, #campos#
			from   #TablaOrigen# a, #PadreOrigen# b
				where  a.Ecodigo	=	#EcodigoViejo#
					and    a.RHPPcodigo	=	b.RHPcodigo  
					and    b.Ecodigo	=	#EcodigoViejo#
	</cfquery>
	<cfset insert_campos = ''>
	<cfset hilera = ''>
	<cfloop query="x">
		<cfset data  = ListToArray(campos,',') >
		<cfset types = ListToArray(tipos,',') >
		
		<cfloop from="1" to ="#arraylen(data)#" index="i">
			<cfif len(trim(evaluate('x.#data[i]#'))) NEQ 0> 
				<cfset valor = trim(evaluate('x.#data[i]#'))> 
				<cfif #types[i]# EQ 'S'>
					<cfset valor = "'#valor#'">
				</cfif>
				<cfif #types[i]# EQ 'D'>
					<cfset valor ="'" & LSDateformat(LSParseDateTime(valor),'YYYYMMDD') & "'">
				</cfif>
			<cfelse> 
				<cfset valor = 'null' >
			</cfif>
			<cfset insert_campos = insert_campos & #valor#>
			<cfif i NEQ #arraylen(data)#>
				<cfset insert_campos = insert_campos & ','>
			<cfelse>
				<cfset insert_campos = insert_campos & ')'>
			</cfif>
		</cfloop>
		<cfset sql_insert = "insert into #arguments.Tabla#(Ecodigo,#campos#) values (#x.Ecodigo#,#insert_campos#">
		<cfset hilera = hilera & sql_insert & '#chr(13)#'>
		<cfset insert_campos = ''>
	</cfloop>
	
	<cfset hilera = hilera & 'update RHPlazaPresupuestaria
						set Mcodigo = (Select Mcodigo
									From Empresas
									Where Ecodigo = #EcodigoNuevo#)
						where Ecodigo = #EcodigoNuevo#' & '#chr(13)#'>

	<cfset archivo = "#TablaOrigen#">
	<cfset LvarDir = expandPath("/clonacion/scripts/")>

	<cfset txtfile = #LvarDir#&'051-RHTPlazaPresupuestaria.txt'>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">

	<cfset session.LvarFiles = session.LvarFiles & '051-RHTPlazaPresupuestaria.txt,'>
</cfif>


