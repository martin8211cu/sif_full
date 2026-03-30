
<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
	<cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 


<!---creo la tabla temporal--->
<cfquery  name="rsImportador" datasource="#session.dsn#">
	select * from #table_name# 
</cfquery>

<!---Llamo al archivo txt--->
<cfloop query="rsImportador">
	<cfset session.Importador.Avance = rsImportador.currentRow/rsImportador.recordCount>

	<!---Variables--->
	<cfquery name="rsOfi" datasource="#session.dsn#">
		select Ocodigo 
		from Oficinas 
		where Oficodigo='#rsImportador.Oficodigo#'
		and Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfset Ocodigo= rsOfi.Ocodigo>
	
	
	
	<!---Validar archivo de texto--->
	<!--- Existencia de lineas blancas en el archivo de texto--->
	<cfif len(trim(rsImportador.Oficodigo)) eq 0 or len(trim(rsImportador.CGCporcentaje)) eq 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error! Existen Columnas en el archivo que estan en blanco')
		</cfquery>
	</cfif>
	
	<!---Validacion #1: Existencia del Activo--->
	<cfif isdefined("rsOfi") and rsOfi.recordcount eq 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error! El codigo de Oficina #rsImportador.Oficodigo# no existe')
		</cfquery>
	</cfif>
	
	<!---Validacion #2: totales de porcentajes--->
	<cfset tot=0>
	<cfloop query="rsImportador">
			<cfset valor=#rsImportador.CGCporcentaje#>
			<cfset tot=tot+valor>
	</cfloop>

	<cfif tot lt 100>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error! El porcentaje de oficinas no puede ser menor que cien')
		</cfquery>
	</cfif>
	<cfif tot gt 100>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error! El porcentaje de oficinas no puede ser mayor que cien')
		</cfquery>
	</cfif>
	
	<cfif (rsImportador.currentRow mod 179 EQ 0)>
		<cfoutput>
			<!-- Flush:
			#repeatString("*",1024)#
			-->
		</cfoutput>
		<!--- veamos si hay que cancelar el proceso --->
		<cfflush interval="64">
	</cfif>
	
	
				
	<cfquery name="rsErrores" datasource="#session.DSN#">
		select count(1) as cantidad
		from #errores#
	</cfquery>
	
	<cfif rsErrores.cantidad eq 0>
		<cfquery name="inOxC" datasource="#session.dsn#">
			insert into OficinasxClasificacion(
				PCCDclaid,
				PCDcatid,
				CGCperiodo,
				CGCmes,
				Ocodigo,
				CGCporcentaje,
				Ecodigo)
			values
				(
				#form.PCCDclaid#,
				null,
				#form.speriodo#,
				#form.smes#,
				#Ocodigo#,
				#rsImportador.CGCporcentaje#,
				#session.Ecodigo#
				)
		</cfquery>	
	</cfif>
</cfloop>		


<cfif rsErrores.cantidad gt 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		select Error as MSG
		from #errores#
		order by Error
	</cfquery>
	<cfreturn>		
</cfif>



