<cfif isdefined("FZ")>

		<cfquery name="Marcadas" datasource="#session.Fondos.dsn#">
		SELECT  A.CJ01ID,CJ3NUM
		FROM CJX003 A, CJM001 B
		WHERE A.CJ3EST not in (3) 
		  AND A.CJ3APL=1
		  AND A.CJ3SEL='S'
		  AND A.CJ01ID = B.CJ01ID 
		  AND B.CJM00COD = '#session.Fondos.fondo#'
		</cfquery>
		
		<cfif Marcadas.recordcount gt 0>
		
			<cfoutput query="Marcadas">
		
				<cfset Var_NLiq = #Marcadas.CJ3NUM#>
				<cfset Var_Caja = #Marcadas.CJ01ID#>
			
				<cftry>			
					<cfquery name="Pendientes" datasource="#session.Fondos.dsn#">
					set nocount on 
					
					exec cj_AplReitegroCj 
						@CJ01ID='#Var_Caja#',
						@CJ3NUM=#Var_NLiq#
					
					set nocount off
					</cfquery>
				
					<cfcatch type="any">	
						<script language="JavaScript">
							var  mensaje = new String("#trim(cfcatch.Detail)#");
							mensaje = mensaje.substring(40,300)
							alert(mensaje)
							history.back()
						</script>
						<cfabort>
					</cfcatch> 
				</cftry>			
							
			</cfoutput>
		
		</cfif>

</cfif>
<cflocation url="cjc_ReintegrosPendientes.cfm" addtoken="no">