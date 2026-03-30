<!--- <cfdump var="#Session#"> --->

<cfinvoke 
	component="interfacesSoin.Componentes.interfaces"
	method="sbIniciarSession"
	CEcodigo          = "1"
	EcodigoSDC      = "2"
	Usucodigo         = "3"
/>


<cflock scope="application" timeout="5" throwontimeout="no">
	<cfoutput> inicia proceso de traslado de asientos : #Now()#<br></cfoutput>
	<cfquery datasource="#session.dsn#"  name="RSDoc" >		 
		select a.ECIid,Edescripcion
		from EContablesImportacion a
			inner join ConceptoContableE b
			on a.Ecodigo = b.Ecodigo
			and a.Cconcepto = b.Cconcepto
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<!--- <cfdump var="#RSDoc#"> --->
	<cfloop query="RSDoc"> 
		<cfoutput> procesando  #RSDoc.Edescripcion#<br></cfoutput>
		<cftry>
			<cfinvoke component="sif.Componentes.CG_AplicaImportacionAsiento" method="CG_AplicaImportacionAsiento">
				<cfinvokeargument name="ECIid" value="#RSDoc.ECIid#">
			</cfinvoke>
			<cfcatch type="any">
				<!--- <cfdump var="#cfcatch#"> --->
				<cfoutput> NO SE PUDO PROCESAR  #RSDoc.Edescripcion#<br></cfoutput>
	        </cfcatch>
	    </cftry>	
	</cfloop>	
	<cfoutput> finaliza proceso de traslado de asientos : #Now()#<br></cfoutput>
</cflock>
