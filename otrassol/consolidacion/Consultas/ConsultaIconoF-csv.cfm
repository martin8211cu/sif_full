<cfset nombreArc="#LvarFile#-#Session.Usucodigo#">
<cfset getPageContext().getResponse().setHeader('Content-Disposition', 'attachment; filename=#nombreArc#.csv')>
<cfset getPageContext().getResponse().setHeader('Content-Type', 'application/vnd.ms-excel')>
<!---
<cfset getPageContext().getResponse().setHeader('Content-Disposition', 'attachment; filename="IconoF.txt"')>
<cfset getPageContext().getResponse().setHeader('Content-Type', 'text/plain')>
--->
<cfoutput>Sociedad,Soc_Asoc,Ejercicio_periodo,Cuenta_consolidacion,Referencia_I,Referencia_II,Descripcion,Monto,Moneda,Monto_Debe,Monto_Haber,Moneda_Contabilizacion
</cfoutput>
<cfoutput query="rsReporte"
>"#Sociedad#","#Soc_Asoc#","#Ejercicio_periodo#","#Cuenta_consolidacion#","#Referencia_I#","#Referencia_II#","#Descripcion#",#NumberFormat(Monto, '0.00')#,"#Moneda#",#NumberFormat(Monto_Debe, '0.00')#,#NumberFormat(Monto_Haber, '0.00')#,"#Moneda_Contabilizacion#"
</cfoutput>
