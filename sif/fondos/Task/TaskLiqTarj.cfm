<cflock scope="application" timeout="5" throwontimeout="no">
<cftry>
		
	<cfquery datasource="#session.Fondos.dsn#"  name="rssectores">
	SELECT CG31COD FROM CGE031 WHERE CGE1COD = 'ICE6'	
	</cfquery>

	<cfloop query="rssectores">

		<cfset Nsector = rssectores.CG31COD>
		
		<cfquery datasource="#session.Fondos.dsn#"  name="sqlver">
			select count(CJX04NUM) as total
			from CJX007 A, CJM000 B, CGE032 C
			where Upper(A.CJX07UMR)	= Upper('Generico')
			     and A.CJX07AP  = 'S' 	  		     
			     and A.CJM00COD = B.CJM00COD
			     and B.CGE5COD  = C.CGE5COD
			     and C.CG31COD  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Nsector#">
			     and C.CG31TIP  = 'C'		
		</cfquery>

		<cfif sqlver.total gt 0>

			<cfquery datasource="#session.Fondos.dsn#"  name="sqlproc">
			set nocount on 
				
			exec cj_Aplica_Liquidacion_TJ
					  @usr='Generico'
					, @sector = <cfqueryparam cfsqltype="cf_sql_integer" value="#Nsector#">
						
			set nocount off 
			</cfquery>
		
		</cfif>
		
	</cfloop>	

	<cfcatch type="any">	
		<script language="JavaScript">
			var  mensaje = new String("<cfoutput>#trim(cfcatch.Detail)#</cfoutput>");
			mensaje = mensaje.substring(40,300)
			alert(mensaje)
			history.back()
		</script>
		<cfabort>
	</cfcatch> 

</cftry>
</cflock>