<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cancelacion de Documentos'>

<cfquery name="rsReversion" datasource="#session.dsn#">
		select distinct SN.SNcodigoext, 
		TESDPdocumentoOri = (select top 1 TESDPdocumentoOri from TESdetallePago where DP.TESSPid = TESSPid),
		convert(varchar,EP.TESOPfechaGeneracion, 103) as TESOPfechaGeneracion, 
		TESDPfechaVencimiento = (select top 1 convert(varchar, DP.TESDPfechaVencimiento, 103)where DP.TESSPid = TESSPid),
		'01' as Mcodigo,
		MontoPago = (select sum(TESDPmontoPago) from TESdetallePago where TESOPid = DP.TESOPid and TESSPid = DP.TESSPid),	 
		'N' as Tipo_Factoraje, '', convert(varchar,EP.TESOPfechaPago,103) TESOPfechaPago, 'D' as Tipo_Compra,
		(select top 1 Rubro = case DD.DDtipo
	    					when 'S' then (select substring (cuentac,1,5) from Conceptos where Cid = DD.DDcoditem and 	                            substring (cuentac,1,5) != 39908) 
   							when 'F' then (select substring (cuentac,1,5) from Conceptos where Ccodigo = 'AF' and                            substring (cuentac,1,5) != 39908) 
							end 
		from TESordenPago O
  		inner join TESdetallePago D on D.TESOPid = O.TESOPid
  		inner join HEDocumentosCP CP on CP.IDdocumento = D.TESDPidDocumento
  		inner join HDDocumentosCP DD on DD.IDdocumento  = CP.IDdocumento
  		where  D.TESSPid = DP.TESSPid
  		and D.TESDPtipoDocumento = 1
  		and NOT (TESDPmontoAprobadoOri <= 0 and TESDPdescripcion like '- Credito:%')  
  		and D.RlineaId is null and D.MlineaId is null)as Rubro, 
		datediff(dd, EP.TESOPfechaGeneracion, DP.TESDPfechaVencimiento) as Plazo_Pago 
		from TESordenPago EP
		inner join TESdetallePago DP on EP.TESOPid = DP.TESOPid
		inner join SNegocios SN on SN.SNid = EP.SNid and EP.EcodigoPago = SN.Ecodigo
        where TESOPestado != 10 and TESOPestado != 13
		and EP.Miso4217Pago = 'MXP'
		----and EP.Miso4217Pago = DP.Miso4217Ori		
	    and Integracion = 1 
		and TESDPmoduloOri = 'CPFC'
	  	and TESDPfechaVencimiento =  #Session.FechaVen#
		order by TESDPdocumentoOri
	</cfquery>

	<cfset Separador = '|'>
	<cfset Archivo = 'ReporteNafinsa'>
  	<cf_ExportTxt query="#rsReversion#" separador="#Separador#" filename="#Archivo#.txt" jdbc="false">

