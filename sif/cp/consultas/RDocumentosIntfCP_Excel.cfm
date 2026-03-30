	<cfset dataurl = 'consultas/RDocumentosIntfCP_reporte.cfm?&botonSel=btnConsultar&btnConsultar=Consultar&'>
	<cfif isdefined("url.CPTcodigo") and len(trim(url.CPTcodigo))>
		<cfset dataurl = dataurl&'CPTcodigo='&url.CPTcodigo&'&'>
	</cfif>
	<cfif isdefined("url.FechaIni") and len(trim(url.FechaIni))>
		<cfset dataurl = dataurl&'FechaIni='&url.FechaIni&'&'>
	</cfif>
	<cfif isdefined("url.FechaFin") and len(trim(url.FechaFin))>
		<cfset dataurl = dataurl&'FechaFin='&url.FechaFin&'&'>
	</cfif>
	<cfif isdefined("url.fSNcodigo") and len(trim(url.fSNcodigo))>
		<cfset dataurl = dataurl&'fSNcodigo='&url.fSNcodigo&'&'>
	</cfif>
	<cfif isdefined("url.fSNnumero") and len(trim(url.fSNnumero))>
		<cfset dataurl = dataurl&'fSNnumero='&url.fSNnumero&'&'>
	</cfif>

<cfinclude  template="RDocumentosIntfCP_sql.cfm">

<!---QUERY-EXCEL--->
		<cfquery name="rsDocexcel" dbtype="query" >
			select NumeroSocio,SNRFC as RFCSocio,SNnombre AS NombreSocio,CodigoTransacion as TipoTransaccion,Documento,
                NumeroBOL as Boleta,Oficina,FechaDocumento,IVA, IEPS, SubTotal,MontoTotal
			from rsIntF10
			union all
			select '','','','','','','','',moneynull,moneynull,moneynull,moneynull from rsIntF10Sum
			union all
			select 'Documentos',cast(TotalRegistros as varchar),'','','','','','',SumIVA,SumIEPS,SumSubTotal,SumMontoTotal
			from rsIntF10Sum
		</cfquery>


		<cf_QueryToFile 
		query="#rsDocexcel#" 
		filename="ConsultadeDocumentosdeCxP_#session.Usucodigo#_#DateFormat(Now(), "yyyymmdd")#_#TimeFormat(Now(),'hhmmss')#.xls" 
		titulo="Consulta de Documentos de CxP por Interfaz #DateFormat(Now(), "yyyymmdd")#"
		>
