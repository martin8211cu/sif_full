<cfif isdefined("OP")>

	<cfloop list="#OP#" delimiters="," index="ordenpg">

		<cftry>
		
			<cfquery datasource="#session.Fondos.dsn#"  name="sqlproc">
			set nocount on 
			
			exec sp_Interfaz_SPI_FDS
					@orden_pago	= #ordenpg#,
					@usr 		= '#session.usuario#'
					
			set nocount off 
			</cfquery>
			
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
	
	</cfloop>
	<script>alert("Los Pagos han sido procesados exitosamente")</script>
	<cflocation addtoken="no" url="cjc_ColaPagos.cfm">

</cfif>