
<cfquery name="Pendientes" datasource="#session.Fondos.dsn#">
SELECT A.orden_pago
FROM CJINTESPI A, CJINTDSPI B
WHERE A.orden_pago = B.orden_pago
</cfquery>

<cfoutput query="Pendientes">

		<cftry>
		
			<cfquery datasource="#session.Fondos.dsn#"  name="sqlproc">
			set nocount on 
			
			exec sp_Interfaz_SPI_FDS
					@orden_pago	= #orden_pago#,
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

</cfoutput>