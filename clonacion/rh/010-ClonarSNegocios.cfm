<cf_dbstruct name="#arguments.Tabla#" returnvariable="rsStruct" datasource="#arguments.conexionO#">

<cfif isdefined("rsStruct") and rsStruct.RecordCount neq 0 >
	<cfquery dbtype="query" name="rscampos">
		select *
		from rsStruct 
			where rsStruct.identity = 0
			and upper(rsStruct.name) not in ('ECODIGO','ESNID','ECODIGOINCLUSION','ID_DIRECCION','MCODIGO')
	</cfquery>
	
	<cfset campos = ''>
	<cfset tipos  = ''>
	<cfset nReg = 1 >
	
	<cfset cinsert = ''>
	<cfset icampos = ''>
	<cfset itipos  = ''>
	<cfset nReg1 = 1 >
	
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
	
	<cfloop query="rsStruct">
		<cfif rsStruct.cf_type  EQ 'S'>
			<cfset largo = '(#rsStruct.len#) null'> 
		<cfelse> 
			<cfset largo = ' null'>  
		</cfif>
		<cfif rsStruct.dbm_type  EQ 'L'>
			<cfset largo = ' DEFAULT 0'> 
		</cfif>
		
		<cfif  #nReg1# NEQ #rsStruct.recordCount#> 
			<cfset cinsert = cinsert & rsStruct.name & ' '& rsStruct.db_type & #largo# & ','>	
			<cfset icampos = icampos & rsStruct.name &','>	
			<cfset itipos  = itipos  &  rsStruct.cf_type & ','>
		<cfelse>
			<cfset cinsert = cinsert & rsStruct.name & ' '& rsStruct.db_type & #largo#>	
			<cfset icampos = icampos & rsStruct.name>	
			<cfset itipos  = itipos  & rsStruct.cf_type & ','>		
		</cfif>
		<cfset nReg1 = nReg1 + 1 >
	</cfloop>
</cfif>	

<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSNO#" returnvariable="TablaOrigen">
<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSND#" returnvariable="TablaDestino">

<cf_dbdatabase table="#arguments.Padre#" datasource="#form.DSNO#" returnvariable="PadreOrigen">
<cf_dbdatabase table="#arguments.Padre#" datasource="#form.DSND#" returnvariable="PadreDestino">

<cf_dbdatabase table="CContables" datasource="#form.DSNO#" returnvariable="CContables_O">
<cf_dbdatabase table="CContables" datasource="#form.DSND#" returnvariable="CContables_D">

<cfset tmpSNegocios = 'tmpSNegocios' >

<cfif not isdefined("form.chkSQL")>

	<cftransaction>
		<cftry>
			<cfquery datasource="#arguments.conexionD#" name="rsExisten">
				Select Ecodigo,SNcodigo from SNegocios Where Ecodigo=#EcodigoNuevo#
					and SNcodigo in (select SNcodigo from #TablaOrigen# where Ecodigo = #EcodigoViejo#)
			</cfquery>
			
			<!---<cf_dump var="#rsExisten#">--->
			
<!---			<cfif isdefined("rsExisten") and rsExisten.RecordCount neq 0>
				<cfloop query="rsExisten" >
					<cfloop index = "lcampo" list = "#campos#" delimiters = ",">
						<cfquery datasource="#arguments.conexionD#" name="x">
							update SNegocios  set  #lcampo#   = 	(select  #lcampo#   from #TablaOrigen# v
																	 Where v.Ecodigo = #EcodigoViejo# 
																		and v.SNcodigo = #rsExisten.SNcodigo# )
								 Where Ecodigo = #EcodigoNuevo# 
										and SNcodigo = #rsExisten.SNcodigo#
						</cfquery>
					</cfloop>
				</cfloop>
			</cfif>--->
			
			<!---<cf_dump var="#rsExisten#">--->
			<cfquery datasource="#arguments.conexionD#" name="x">
				insert into SNegocios(Ecodigo, ESNid, EcodigoInclusion, Mcodigo, #campos#)
					Select #EcodigoNuevo#, c.ESNid,  #EcodigoNuevo#, (select max(Mcodigo) from Monedas where Ecodigo = #EcodigoNuevo#) ,#campos#
						From #TablaOrigen# a, #PadreOrigen# b, #PadreDestino# c 
						Where a.ESNid=b.ESNid
							and a.Ecodigo	=	#EcodigoViejo#
							and a.ESNid		=	b.ESNid
							and b.ESNcodigo	=	c.ESNcodigo
							and c.Ecodigo	=	#EcodigoNuevo#
							and (select count(1) from SNegocios d where d.Ecodigo = #EcodigoNuevo# and SNcodigo = d.SNcodigo) = 0
			</cfquery>

<!---<cf_dump var="#x#">--->
			<cfquery datasource="#arguments.conexionD#" name="actualiza">
				update SNegocios
					set SNcuentacxp = (select SNcuentacxp 
								from #TablaOrigen# b 
								where b.Ecodigo = #EcodigoViejo#
									and b.SNcodigo = SNegocios.SNcodigo)
					where Ecodigo = #EcodigoNuevo#
			</cfquery>

			<cfquery datasource="#arguments.conexionD#" name="actualiza">
				update SNegocios
					set SNcuentacxp = ( Select b.Ccuenta
							  from #CContables_O# a, #CContables_D# b
							  Where SNegocios.SNcuentacxp=a.Ccuenta
							  and a.Ecodigo		=	#EcodigoViejo#
							  and a.Cformato	=	b.Cformato
							  and b.Ecodigo		=	#EcodigoNuevo#)
					Where Ecodigo = #EcodigoNuevo#
						and SNcuentacxp is not null
			</cfquery>
			
			<cfquery datasource="#arguments.conexionD#" name="actualiza">
				update SNegocios
					set SNcuentacxc= (Select b.Ccuenta
							  from #CContables_O# a, #CContables_D# b
							  Where SNegocios.SNcuentacxc=a.Ccuenta
							  and a.Ecodigo		=	#EcodigoViejo#
							  and a.Cformato	=	b.Cformato
							  and b.Ecodigo		=	#EcodigoNuevo#)
					Where Ecodigo =	#EcodigoNuevo#
					and SNcuentacxc is not null
			</cfquery>
			<cfcatch type="any">
				<cftransaction action="rollback"/>
				<cfset  ErrorMessage  =  '#cfcatch.Detail#>'>
<!---				<cfrethrow message="#ErrorMessage#">--->
				<cfrethrow>
			</cfcatch>
		</cftry>
	</cftransaction>
<cfelse>

	<!---incluir los datos de origen para hacer la actualizacion regla de tres--->
	<cfquery datasource="#arguments.conexionD#" name="rsOrigen">
		Select #icampos#
			From #TablaOrigen# 
				Where Ecodigo= #EcodigoViejo#
	</cfquery>

	<cfset insert_campos = ''>
	<cfset hilera = '/* Socios de Negocio #chr(13)# Clonacion de datos de oficinas, se crea una tabla temporal tmpSNegocios que es usada para hacer actualizaciones mas adelante */ #chr(13)#' >
	<cfset temporal = 'create table #tmpSNegocios# (#cinsert#)'>
	
	<cfset hilera = hilera & temporal & '#chr(13)#'>
	
	<cfloop query="rsOrigen">
		<cfset idata  = ListToArray(icampos,',') >
		<cfset itypes = ListToArray(itipos,',') >
		
		<cfloop from="1" to ="#arraylen(idata)#" index="i">
			<cfif len(trim(evaluate('rsOrigen.#idata[i]#'))) NEQ 0> 
				<cfset valor = trim(evaluate('rsOrigen.#idata[i]#'))> 
				<cfif #itypes[i]# EQ 'S'>
					<cfset valor = "'#valor#'">
				</cfif>
				<cfif #itypes[i]# EQ 'D'>
					<cfset valor ="'" & LSDateformat(LSParseDateTime(valor),'YYYYMMDD') & "'">
				</cfif>
			<cfelse> 
				<cfset valor = 'null' >
			</cfif>
			<cfset insert_campos = insert_campos & #valor#>
			<cfif i NEQ #arraylen(idata)#>
				<cfset insert_campos = insert_campos & ','>
			<cfelse>
				<cfset insert_campos = insert_campos & ')'>
			</cfif>
		</cfloop>
		<cfset sql_insert = "insert into #tmpSNegocios#(#icampos#) values (#insert_campos#">
		<cfset hilera = hilera & sql_insert & '#chr(13)#'>
		<cfset insert_campos = ''>
		
	</cfloop>

<!-------------------------------------------------------------------------------------------->

	<cfquery datasource="#arguments.conexionD#" name="x">
		Select #EcodigoNuevo# as Ecodigo, b.ESNid, Mcodigo, #campos#
			From #TablaOrigen# a, #PadreOrigen# b
				Where a.ESNid=b.ESNid 
					and a.Ecodigo	=	#EcodigoViejo#
					and a.ESNid		=	b.ESNid
					
<!---		Select #EcodigoNuevo# as Ecodigo, c.ESNid, (select max(Mcodigo) from Monedas where Ecodigo = #EcodigoNuevo#) as Mcodigo,#campos#
			From #TablaOrigen# a, #PadreOrigen# b, #PadreDestino# c 
				Where a.ESNid=b.ESNid 
					and a.Ecodigo	=	#EcodigoViejo#
					and a.ESNid		=	b.ESNid
					and b.ESNcodigo	=	c.ESNcodigo
					and c.Ecodigo	=	#EcodigoNuevo#
--->					
	</cfquery>
	
	<!---<cf_dump var="#x#">--->
	
	
	<cfset insert_campos = ''>
	<cfset hilera = hilera & '#chr(13)#/* Socios de Negocio */ #chr(13)#' >
	<cfset hilera = hilera & 'declare @x  int #chr(13)#	select @x  =  Mcodigo from Monedas where Ecodigo = #EcodigoNuevo# #chr(13)#'>
	<cfset hilera = hilera & 'declare @tmp   NUMERIC #chr(13)#	select @tmp  =  ESNid from EstadoSNegocios where Ecodigo = #EcodigoNuevo# and ESNcodigo like #chr(39)#99%#chr(39)# #chr(13)#'>

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
		
		
		<cfset sql_insert = "insert into #arguments.Tabla#(Ecodigo,ESNid,Mcodigo,#campos#) values (#x.Ecodigo#,@tmp,@x,#insert_campos#">
		<cfset hilera = hilera & sql_insert & '#chr(13)#'>
		<cfset insert_campos = ''>
	</cfloop>
	
	<cfset hilera = hilera & ' #chr(13)# update SNegocios set ESNid =  (select d.ESNid
		from tmpSNegocios a,  tmpEstadoSNegocios c, EstadoSNegocios d
		where a.SNcodigo = SNegocios.SNcodigo
		and c.ESNid = a.ESNid
		and c.ESNcodigo = d.ESNcodigo
		and d.Ecodigo = #EcodigoNuevo# )
	where Ecodigo = #EcodigoNuevo# #chr(13)#'>
	
	<cfset hilera = hilera & ' #chr(13)# update SNegocios
	set SNcuentacxp = (select SNcuentacxp 
				from #TablaOrigen# b 
				where b.Ecodigo = #EcodigoViejo#
					and b.SNcodigo = SNegocios.SNcodigo)
	where Ecodigo = #EcodigoNuevo#' & '#chr(13)#'>
					
	<cfset hilera = hilera & ' #chr(13)#update SNegocios
	set SNcuentacxp = ( Select b.Ccuenta
			  from tmpCContables a, #CContables_D# b
			  Where SNegocios.SNcuentacxp=a.Ccuenta
			  and a.Ecodigo		=	#EcodigoViejo#
			  and a.Cformato	=	b.Cformato
			  and b.Ecodigo		=	#EcodigoNuevo#)
	Where Ecodigo = #EcodigoNuevo#
		and SNcuentacxp is not null' & '#chr(13)#'>
					
	<cfset hilera = hilera & ' #chr(13)# update SNegocios
	set SNcuentacxc= (Select b.Ccuenta
			  from tmpCContables a, #CContables_D# b
			  Where SNegocios.SNcuentacxc=a.Ccuenta
			  and a.Ecodigo		=	#EcodigoViejo#
			  and a.Cformato	=	b.Cformato
			  and b.Ecodigo		=	#EcodigoNuevo#)
	Where Ecodigo =	#EcodigoNuevo#
	and SNcuentacxc is not null' & '#chr(13)#'>

	<cfset archivo = "#TablaOrigen#">
	<cfset LvarDir = expandPath("/clonacion/scripts/")>

	<cfset txtfile = #LvarDir#&'010-SNegocios.txt'>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">

	<cfset session.LvarFiles = session.LvarFiles & '010-SNegocios.txt,'>
</cfif>

<!---<cf_dump var="#x#">--->


