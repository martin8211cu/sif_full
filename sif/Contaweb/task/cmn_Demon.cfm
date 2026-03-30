<cflock scope="application" timeout="5" throwontimeout="no">
	<!--- 	<cfquery datasource="asp">waitfor delay '0:0:20' </cfquery>  --->
	<cfoutput> inicia demonio #Now()#<br></cfoutput>
	
	<cfquery datasource="#session.dsn#"  name="sqldemon" >		 
	select  IDArchivo,Usuario 
	from  tbl_archivoscf
	where  Status = 'P' 
	<!--- and fechaejec <= getdate()	 --->
	</cfquery>
	<!---********************* Funciones ***********************--->
	
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
	</cffunction>
	  
	<cfloop query="sqldemon"> 
		<cftry>
		  	<cfinclude template="cmn_CreaArchivo.cfm">
			<cfcatch type="any">
				<!--- Insert tbl_erroresarch(idarchivo,Error)
				values(#sqldemon.idarchivo#,'#cfcatch.Detail#') --->
	        </cfcatch>
	    </cftry>	
	</cfloop>	
	<cfoutput> finaliza demonio #Now()#<br></cfoutput>
</cflock>
