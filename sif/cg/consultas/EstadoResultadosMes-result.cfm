<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
			<style type="text/css">
				#printerIframe {
		  			position: absolute;
		  			width: 0px; height: 0px;
		 			border-style: none;
		  			/* visibility: hidden; */
				}
			</style>
			<cfif isdefined("form.ADMIN") and form.ADMIN eq 'S'>
				<cfset LvarIr  = 'EstadoResultadosAdmin.cfm'>
			<cfelse>
				<cfif isdefined("LvarInfo")>
					<cfset LvarIr = 'EstadoResultadosMes_INFO.cfm'>
				<cfelse>
					<cfset LvarIr = 'EstadoResultadosMes.cfm'>
				</cfif>
			</cfif>
						
			
			
			<cfif not isDefined("form.toExcel")>
				<cfif not isdefined("form.btnDownload")>
					<cf_templatecss>
				</cfif>
				<cfset LvarFileName = "EstadoResultados#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
				<cf_htmlReportsHeaders 
					title="Estado de Resultaldos" 
					filename="#LvarFileName#"
					irA="#LvarIr#" 
					>					
				
				
			</cfif>
			<cfinclude template="EstadoResultadosMes-form.cfm">

		</td>	
	</tr>
</table>



					