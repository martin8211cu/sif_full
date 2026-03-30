<!--- Inicia la verificacion de los procesos pendientes --->
<cflock scope="application" timeout="5" throwontimeout="no">

	<!--- Empieza con la verificacion de las relaciones --->
	<cfoutput> inicia demonio #Now()#<br></cfoutput>
	<cfquery datasource="#session.Conta.dsn#"  name="sqldemon" >	
	select  id,usuario,tipo_proceso
	from  tbl_transaccionescf
	where estado = 'P' 
	  and convert(datetime, convert(varchar, fecha, 112) + ' '  +convert(varchar,  horageneracion, 8)) <= getdate()
	<!--- 
	and fecha <= getdate()
	and convert(datetime, convert(varchar, getdate(), 112) + ' '  +convert(varchar,  horageneracion, 8)) 
	 <= convert(datetime, convert(varchar, getdate(), 112) + ' '  +convert(varchar, getdate(), 8))
	 --->
	</cfquery>
	
	<!---********************* Funciones ***********************
	<cffunction name="fnGraba">
		<cfargument name="contenido" required="yes">
		<cfargument name="fin" required="no" default="no">
		<cfset contenido = replace(contenido,"   "," ","All")>
		<cfset contenidohtml = contenidohtml & contenido>
		<cfif len(contenidohtml) GT 1048576>
			<cffile action="append" file="#tempfile_TXT#" output="#contenidohtml#">
			<cfset contenidohtml = "">
		</cfif>
		<cfif fin>
			<cffile action="append" file="#tempfile_TXT#" output="#contenidohtml#">
			<cfset contenidohtml = "">
		</cfif>
	</cffunction>--->
	
		
	<cfloop query="sqldemon">
	  <cfinclude template="cmn_PosteaRelaciones.cfm">
	</cfloop>
	<cfoutput> fin demonio #Now()#<br></cfoutput>

</cflock>