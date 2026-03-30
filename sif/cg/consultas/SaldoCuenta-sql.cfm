<style type="text/css">
	#printerIframe {
		position: absolute;
		width: 0px; height: 0px;
		border-style: none;
		/* visibility: hidden; */
	}

</style>
			
	<cfif isdefined("form.ADMIN") and form.ADMIN eq 'S'>
		<cfset LvarIr  = 'IntregacionCuenta.cfm'>
	<cfelse>
	
		<cfif isdefined("LvarInfo")>
			<cfset LvarIr = 'SaldoCuenta_INFO.cfm'>
		<cfelse>
			<cfset LvarIr = 'SaldoCuenta.cfm'>
		</cfif>

	</cfif>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Titulo" 	default="Integraci&oacute;n de Cuenta de Mayor" 
returnvariable="LB_Titulo" xmlfile="SaldoCuenta-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Archivo" 	default="SaldoCuenta" 
returnvariable="LB_Archivo" xmlfile="SaldoCuenta-sql.xml"/>
		
<cfset LvarFileName = "#LB_Archivo#_#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
	<cf_htmlReportsHeaders 
		title="#LB_Titulo#" 
		filename="#LvarFileName#"
		irA="#LvarIr#" 
		>
		<cfif not isdefined("form.btnDownload")>
			<cf_templatecss>
		</cfif>	
		<cfinclude template="SaldoCuenta-report.cfm">

<script language="javascript1.2" type="text/javascript">
	function fnImgPrint() {
		window.print()	
	}
</script>