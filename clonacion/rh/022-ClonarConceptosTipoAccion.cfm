<cf_dbstruct name="#arguments.Tabla#" returnvariable="rsStruct" datasource="#arguments.conexionO#">

<cfif isdefined("rsStruct") and rsStruct.RecordCount neq 0 >
	<cfquery dbtype="query" name="rscampos">
		select *
		from rsStruct 
		where rsStruct.identity = 0
			and upper(rsStruct.name) not in ('ECODIGO','CIID','RHTID')
	</cfquery>
	
	<cfset campos = ''>
	<cfset tipos  = ''>
	<cfset Scampos = ''>
	<cfset nReg = 1 >
	
	<cfset cinsert = ''>
	<cfset icampos = ''>
	<cfset iscampos = ''>
	<cfset itipos  = ''>
	<cfset nReg1 = 1 >
	
	<cfloop query="rscampos">
		<cfif  #nReg# NEQ #rscampos.recordCount#> 
			<cfset Scampos = Scampos & 'a.'&rscampos.name & ','>
			<cfset campos = campos & rscampos.name & ','>
			<cfset tipos  = tipos & rscampos.cf_type & ','>
		<cfelse>
			<cfset Scampos = Scampos & 'a.'&rscampos.name>
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
			<cfset iscampos = iscampos & ' a.'& rsStruct.name &','>	
			<cfset icampos = icampos & rsStruct.name &','>	
			<cfset itipos  = itipos  &  rsStruct.cf_type & ','>
		<cfelse>
			<cfset cinsert = cinsert & rsStruct.name & ' '& rsStruct.db_type & #largo#>	
			<cfset icampos = icampos & rsStruct.name>	
			<cfset iscampos = iscampos & ' a.'& rsStruct.name>	
			<cfset itipos  = itipos  & rsStruct.cf_type & ','>		
		</cfif>
		<cfset nReg1 = nReg1 + 1 >
	</cfloop>
</cfif>
<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSNO#" returnvariable="TablaOrigen">
<cf_dbdatabase table="#arguments.Padre#" datasource="#form.DSND#" returnvariable="PadreDestino">

<cf_dbdatabase table="#arguments.Padre#" datasource="#form.DSNO#" returnvariable="PadreOrigen">
<cf_dbdatabase table="#arguments.Padre#" datasource="#form.DSND#" returnvariable="PadreDestino">

<cf_dbdatabase table="RHTipoAccion" datasource="#form.DSNO#" returnvariable="RHTipoAccion_Origen">
<cf_dbdatabase table="RHTipoAccion" datasource="#form.DSND#" returnvariable="RHTipoAccion_Destino">

<cf_dbdatabase table="CIncidentes" datasource="#form.DSNO#" returnvariable="CIncidentes_Origen">
<cf_dbdatabase table="CIncidentes" datasource="#form.DSND#" returnvariable="CIncidentes_Destino">

<cfset tmpConceptosTipoAccion = 'tmpConceptosTipoAccion' >

<cfif not isdefined("form.chkSQL")>
	<cftransaction>
		<cftry>
			<cfquery datasource="#arguments.conexionD#" name="rsExisten">
				select *
					from ConceptosTipoAccion
					where CIid in (select CIid from CIncidentes where Ecodigo = #EcodigoNuevo#)
						and RHTid    in (select RHTid from RHTipoAccion where Ecodigo = #EcodigoNuevo#)
			</cfquery>
			
<!---			<cfdump var="#rsExisten#">--->
	
			<cfif isdefined("rsExisten") and rsExisten.RecordCount neq 0>
				<cfquery datasource="#arguments.conexionD#">
					delete from ConceptosTipoAccion
						where CIid in (select CIid from CIncidentes where Ecodigo = #EcodigoNuevo#)
							and RHTid in (select RHTid from RHTipoAccion where Ecodigo = #EcodigoNuevo#)
				</cfquery>
			</cfif>

			<cfquery datasource="#arguments.conexionD#" name="x">
			
				insert into ConceptosTipoAccion(CIid, RHTid, #campos#)
					
					Select c2.CIid, b2.RHTid, #Scampos# 
						from #TablaOrigen# a, 
							 #RHTipoAccion_Origen# b1, #CIncidentes_Origen# c1, 
							 #RHTipoAccion_Destino# b2, #CIncidentes_Destino# c2
						 
						Where a.CIid 	= c1.CIid
							and   a.RHTid	= b1.RHTid
							and   b1.Ecodigo	= #EcodigoViejo#
							and   c1.Ecodigo	= #EcodigoViejo#
							
							and   c1.CIcodigo 	= c2.CIcodigo
							and   b1.RHTcodigo 	= b2.RHTcodigo
							
							and   b2.Ecodigo	= #EcodigoNuevo#
							and   c2.Ecodigo	= #EcodigoNuevo#			
								
<!---						and a.CScodigo not in (select CScodigo from #TablaOrigen# a where a.Ecodigo = #EcodigoNuevo#)--->
			</cfquery>
			<cfcatch type="database">
				<cftransaction action="rollback"/>
				<cfset  ErrorMessage  =  '#cfcatch.Detail#>'>
				<cfrethrow>
			</cfcatch>
		</cftry>
	</cftransaction>
<cfelse>

<!---incluir los datos de origen para hacer la actualizacion regla de tres--->
	<cfquery datasource="#arguments.conexionD#" name="rsOrigen">
		Select #iscampos#
			from #TablaOrigen# a, 
				 #RHTipoAccion_Origen# b1, #CIncidentes_Origen# c1 
			Where a.CIid 	= c1.CIid
				and   a.RHTid	= b1.RHTid
				and   b1.Ecodigo	= #EcodigoViejo#
				and   c1.Ecodigo	= #EcodigoViejo#
	</cfquery>

	<cfset insert_campos = ''>
	<cfset hilera = '/* Conceptos tipo accion #chr(13)# Clonacion Conceptos tipo accion, se crea una tabla temporal tmpConceptosTipoAccion que es usada para hacer actualizaciones mas adelante */ #chr(13)#' >
	<cfset temporal = 'create table #tmpConceptosTipoAccion# (#cinsert#)'>
	
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
		<cfset sql_insert = "insert into #tmpConceptosTipoAccion#(#icampos#) values (#insert_campos#">
		<cfset hilera = hilera & sql_insert & '#chr(13)#'>
		<cfset insert_campos = ''>
		
	</cfloop>

<!-------------------------------------------------------------------------------------------->


<cfset hilera = hilera & '#chr(13)#/* Conceptos tipo de incicencia */#chr(13)#'>
	
	<cfset hilera = hilera & '#chr(13)#/*Actulizacion de CIid y RHTid en la tabla temporal*/ #chr(13)# 
	
update tmpConceptosTipoAccion set CIid = (
Select c2.CIid
from  tmpRHTipoAccion b1, tmpCIncidentes c1, 
         RHTipoAccion b2,  CIncidentes c2

Where tmpConceptosTipoAccion.CIid 	= c1.CIid
	and   tmpConceptosTipoAccion.RHTid	= b1.RHTid
	and   b1.Ecodigo	=1097
	and   c1.Ecodigo	= 1097

	and   c1.CIcodigo 	= c2.CIcodigo
	and   b1.RHTcodigo 	= b2.RHTcodigo

	and   b2.Ecodigo	= 1198
	and   c2.Ecodigo	= 1198)

,RHTid  = ( Select b2.RHTid
from  tmpRHTipoAccion b1, tmpCIncidentes c1, 
		 RHTipoAccion b2,  CIncidentes c2

Where tmpConceptosTipoAccion.CIid 	= c1.CIid
		and   tmpConceptosTipoAccion.RHTid	= b1.RHTid
		and   b1.Ecodigo	= #EcodigoViejo#
		and   c1.Ecodigo	= #EcodigoViejo#

		and   c1.CIcodigo 	= c2.CIcodigo
		and   b1.RHTcodigo 	= b2.RHTcodigo

		and   b2.Ecodigo	= #EcodigoNuevo#
		and   c2.Ecodigo	= #EcodigoNuevo#) #chr(13)#'>
		
		
	<cfset hilera = hilera & '#chr(13)#/*Insert Conceptos tipo de incicencia ya actualizados*/#chr(13)#
	insert into ConceptosTipoAccion  (#icampos#) (select #icampos# from tmpConceptosTipoAccion)'>	





<!---	<cfquery datasource="#arguments.conexionD#" name="x">
		Select c2.CIid, b2.RHTid, #Scampos# 
						from #TablaOrigen# a, 
							 #RHTipoAccion_Origen# b1, #CIncidentes_Origen# c1, 
							 #RHTipoAccion_Destino# b2, #CIncidentes_Destino# c2
						 
						Where a.CIid 	= c1.CIid
							and   a.RHTid	= b1.RHTid
							and   b1.Ecodigo	= #EcodigoViejo#
							and   c1.Ecodigo	= #EcodigoViejo#
							
							and   c1.CIcodigo 	= c2.CIcodigo
							and   b1.RHTcodigo 	= b2.RHTcodigo
							
							and   b2.Ecodigo	= #EcodigoNuevo#
							and   c2.Ecodigo	= #EcodigoNuevo#
	</cfquery>--->


<!---
	<cfquery datasource="#arguments.conexionD#" name="x">
		Select a.CIid, a.RHTid, #Scampos# 
			from #TablaOrigen# a, 
				 #RHTipoAccion_Origen# b1, #CIncidentes_Origen# c1 
			Where a.CIid 	= c1.CIid
				and   a.RHTid	= b1.RHTid
				and   b1.Ecodigo	= #EcodigoViejo#
				and   c1.Ecodigo	= #EcodigoViejo#
	</cfquery>
	
	
	<cfset insert_campos = ''>
	<cfset hilera = hilera & ''>
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
		<cfset sql_insert = "insert into #arguments.Tabla#(CIid, RHTid,#campos#) values (#x.CIid#, #x.RHTid#,#insert_campos#">
		<cfset hilera = hilera & sql_insert & '#chr(13)#'>
		<cfset insert_campos = ''>
	</cfloop>--->

	<cfset archivo = "#TablaOrigen#">
	<cfset LvarDir = expandPath("/clonacion/scripts/")>

	<cfset txtfile = #LvarDir#&'022-ConceptosTipoAccion.txt'>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">

	<cfset session.LvarFiles = session.LvarFiles & '022-ConceptosTipoAccion.txt,'>
</cfif>

<!---<cf_dump var="#x#">--->


