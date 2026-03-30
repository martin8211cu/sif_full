<!--- INICIO DE CASOS DE PRUEBA --->

<!--- 1. Alta, No viene la tabla base definida 
<cfset Form.Alta = "Agregar">
<cfset Form.RHTTid = 42>
<cfset Form.PAGENUMPADRE = 1>
<!--- <cfset Form.RHVTid = > --->
<cfset Form.RHVTfecharige = '01/01/2004'>
<cfset Form.RHVTtablabase = ''>
<cfset Form.RHVTporcentaje = ''>
<cfset Form.RHVTdocumento = ''>
<!--- <cfset Form.ts_rversion = ''> --->
--->

<!--- 2. Alta, No viene la tabla base definida, pero viene porcentaje. 
<cfset Form.Alta = "Agregar">
<cfset Form.RHTTid = 6>
<cfset Form.PAGENUMPADRE = 1>
<!--- <cfset Form.RHVTid = > --->
<cfset Form.RHVTfecharige = '14/04/2004'>
<cfset Form.RHVTtablabase = ''>
<cfset Form.RHVTporcentaje = '5'>
<cfset Form.RHVTdocumento = ''>
<!--- <cfset Form.ts_rversion = ''> --->
--->

<!--- 3. Alta, Viene la tabla base definida: a: sin porcentaje, b: con porcentje en cero, c: con porcentaje. 
<cfset Form.Alta = "Agregar">
<cfset Form.RHTTid = 6>
<cfset Form.PAGENUMPADRE = 1>
<!--- <cfset Form.RHVTid = > --->
<cfset Form.RHVTfecharige = '14/04/2004'>
<cfset Form.RHVTtablabase = '1'>
<cfset Form.RHVTporcentaje = '5'>
<cfset Form.RHVTdocumento = ''>
<!--- <cfset Form.ts_rversion = ''> --->
--->

<!--- FIN DE CASOS DE PRUEBA --->