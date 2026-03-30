<!--- =============================================================== --->
<!--- Autor:  Rodrigo Rivera                                          --->
<!--- Nombre: Arrendamiento                                           --->
<!--- Fecha:  28/03/2014                                              --->
<!--- Última Modificación: 16/04/2014                                 --->
<!--- =============================================================== --->
<cfsetting enablecfoutputonly="yes">


<cfquery name="get_Data" datasource="#Session.DSN#">
SELECT [IDArrend]
      ,[Ecodigo]
      ,[FechaCierreMes]
      ,[DiasAbarcaCierre]
      ,[NumPago]
      ,[FechaInicio]
      ,[FechaPagoBanco]
      ,[FechaPagoEmpresa]
      ,[DiasPeriodo]
      ,[SaldoInsoluto]
      ,[Capital]
      ,[Intereses]
      ,[PagoMensual]
      ,[IVA]
      ,[IntDevengNoCob]
      ,[InteresRestante]
      ,[Estado]
      ,[BMUsucodigo]
  FROM [TablaAmort]
  WHERE [IDArrend] = #form.idarrend# and [Ecodigo] = #session.ecodigo#
</cfquery>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Archivo" Default="TablaAmortizacion"
returnvariable="LB_Archivo" xmlfile = "formRCuentas.xml"/>

<cf_exportQueryToFile query="#get_Data#" filename="TablaAmort.xls" jdbc="false">

<!--- <cfheader name="Content-Disposition" value="inline; filename=tablaAmort.tsv">
<cfcontent type="vnd.ms-excel">

<cfoutput query="get_Data">
#FechaCierreMes##CHR(9)##DiasAbarcaCierre##CHR(9)##NumPago##CHR(9)##FechaInicio##CHR(9)##FechaPagoBanco##CHR(9)##FechaPagoEmpresa##CHR(9)##DiasPeriodo##CHR(9)##SaldoInsoluto##CHR(9)##Capital##CHR(9)##Intereses##CHR(9)##PagoMensual##CHR(9)##IVA##CHR(9)##IntDevengNoCob##CHR(9)##InteresRestante# 
</cfoutput>--->
