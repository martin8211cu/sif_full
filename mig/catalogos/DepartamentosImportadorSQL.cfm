<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="ErroresImpDeptoV1" returnvariable="ErroresImpDeptoV1" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>
<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">



<cfquery name="ERR" datasource="#session.DSN#">
	Insert into #ErroresImpDeptoV1# (Error)
	select 'El Departamento ' #_Cat# Deptocodigo #_Cat# ' esta repetido en el Archivo.'
	from #table_name# 
	group by Deptocodigo
	having count(1) > 1
</cfquery>

<cfquery  name="rsImportador" datasource="#session.dsn#">
  select * from #table_name# 
</cfquery>

<cfset session.Importador.SubTipo = "2">
<cfloop query="rsImportador">
	<cfset session.Importador.Avance = rsImportador.currentRow/rsImportador.recordCount>

	<cfif (rsImportador.currentRow mod 179 EQ 0)>
		<cfoutput>
			<!-- Flush:
				#repeatString("*",1024)#
			-->
		</cfoutput>
		<!--- veamos si hay que cancelar el proceso --->
		<cfflush interval="64">
	</cfif>
	<cfif len(trim(rsImportador.MIGGcodigo)) EQ 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpDeptoV1# (Error)
			values ('El C&oacute;digo de la Gerencia no puede ir en blanco')
		</cfquery>
	</cfif>	
	<cfif len(trim(rsImportador.Deptocodigo)) EQ 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpDeptoV1# (Error)
			values ('El C&oacute;digo del Departamento no puede ir en blanco')
		</cfquery>
	</cfif>	
	<cfif len(trim(rsImportador.Ddescripcion)) EQ 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpDeptoV1# (Error)
			values ('La descripci&oacute;n no puede ir en blanco.')
		</cfquery>
	</cfif>

	<!---No contenido de espacios en blanco en el codigo--->
	<cfif len(trim(rsImportador.Deptocodigo))>

		<!---No caracteres especiales--->
		<cfif FindOneOf('$%&-+*!|##@" ', rsImportador.Deptocodigo) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpDeptoV1# (Error)
				values ('El c&oacute;digo no puede contener caracteres especiales.')
			</cfquery>
		</cfif>
	</cfif>
	
	<cfif len(trim(rsImportador.MIGGcodigo)) NEQ 0>
		<cfquery name="rsGerencias" datasource="#session.dsn#">
			select MIGGid,MIGGcodigo,MIGGdescripcion
			from MIGGerencia
			where MIGGcodigo = '#trim(rsImportador.MIGGcodigo)#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfif rsGerencias.recordCount EQ 0>	
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpDeptoV1# (Error)
				values ('La Gerencia #rsImportador.MIGGcodigo# no existe en el Sistema')
			</cfquery>
		</cfif>
	</cfif>	
	
	<cfquery name="rsErrores" datasource="#session.DSN#">
		select count(1) as cantidad
		from #ErroresImpDeptoV1#
	</cfquery>
<!---Si hay errores no hace la inserción--->
	<cfif rsErrores.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #ErroresImpDeptoV1#
		</cfquery>
		<cfreturn>
<!---Hace lo inserción en caso de que no hayan errores.--->
	<cfelse>
		<cfquery name="rsDept" datasource="#session.dsn#">
			select Dcodigo,Deptocodigo
			from Departamentos
			where Deptocodigo = '#trim(rsImportador.Deptocodigo)#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfif rsDept.Dcodigo EQ "">
			<cfquery name="rsCont" datasource="#Session.DSN#">
				select (coalesce(max(Dcodigo),0)+1) as Cont
				from Departamentos 
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">				
			</cfquery>
			<cfquery name="insert" datasource="#Session.DSN#">
				insert into Departamentos (Ecodigo, Dcodigo, Deptocodigo, Ddescripcion, MIGGid,BMUsucodigo)
					values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> , 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCont.Cont#"> , 
							 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(rsImportador.Deptocodigo)#">, 
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsImportador.Ddescripcion)#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGerencias.MIGGid#">,
							 #session.Usucodigo#
							 
					)
			 </cfquery>			
		<cfelse>
			<cfquery name="Update" datasource="#Session.DSN#">
				update Departamentos 
				set Ddescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsImportador.Ddescripcion)#">,
					MIGGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGerencias.MIGGid#">
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and Dcodigo = <cfqueryparam value="#rsDept.Dcodigo#" cfsqltype="cf_sql_integer">
				  and Deptocodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDept.Deptocodigo#">
			</cfquery>		
		</cfif>
	</cfif>
</cfloop>		

<cfset session.Importador.SubTipo = 3>

