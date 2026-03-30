<cfinvoke key="LB_Archivo" 			default="EstadoDeResultados" 	returnvariable="LB_Archivo" 		component="sif.Componentes.Translate" method="Translate" xmlfile="EstadoResultados-result.xml"/>
<cfinvoke key="LB_Titulo" 			default="Estado De Resultados -Conversión de Moneda" 	returnvariable="LB_Titulo" 		component="sif.Componentes.Translate" method="Translate"/>

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
					<cfset LvarIr = 'EstadoResultados_INFO.cfm'>
				<cfelse>
					<cfset LvarIr = 'EstadoResultados.cfm'>
				</cfif>
			</cfif>
						
			
			
			<cfif not isDefined("form.toExcel")>
				<cfif not isdefined("form.btnDownload")>
					<cf_templatecss>
				</cfif>
				<cfset LvarFileName = "#LB_Archivo##Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
				<cf_htmlReportsHeaders 
					title="#LB_Titulo#" 
					filename="#LvarFileName#"
					irA="#LvarIr#" 
					>					
				
				
			</cfif>
			<cfinclude template="EstadoResultados-form.cfm">

		</td>	
	</tr>
</table>



					