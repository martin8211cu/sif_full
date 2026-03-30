<cfset params = 'RHASid='& url.RHASid &'&puntos='& url.puntos &'&porcentaje='&url.porcentaje>
<cf_reportWFormat url="/rh/adminsalarios/consultas/analisis-salarial2-repgenerado.cfm" orientacion="landscape"
 params="#params#">
