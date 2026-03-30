<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Todos = t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset LB_Todas = t.Translate('LB_Todos','Todas','/sif/generales.xml')>
<cfset MSG_CantDoc = t.Translate('MSG_CantDoc','La cantidad de Documentos a presentar sobrepasa los 20,000 registros.','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset MSG_AGenerar = t.Translate('MSG_AGenerar','Se van a generar','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset MSG_RegFiltro = t.Translate('MSG_RegFiltro','registros con los filtros actuales','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset MSG_RangoFiltro = t.Translate('MSG_RangoFiltro','Reduzca el rango utilizando los filtros.','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset MSG_ProcCanc = t.Translate('MSG_ProcCanc','Proceso Cancelado.','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_Debito = t.Translate('LB_Debito','Débito','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_Credito = t.Translate('LB_Credito','Crédito','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset TIT_ImpHist = t.Translate('TIT_ImpHist','Reporte de saldos de documentos de CxP por Socio','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset TIT_Rep = t.Translate('TIT_Rep','Reporte de Saldos de Documentos de CxP por Socio','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_DelSocio = t.Translate('LB_DelSocio','Socio de negocio','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_DelSocioIND = t.Translate('LB_DelSocioIND','Identificaci&oacute;n','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_DelSocioc = t.Translate('LB_DelSocioc','C&oacute;digo Socio','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_DesdeFec = t.Translate('LB_DesdeFec','Desde la fecha','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_HastaFec = t.Translate('LB_HastaFec','Hasta la fecha','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_TipoTr = t.Translate('LB_TipoTr','Tipo de la Transacci&oacute;n','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_FechaCons = t.Translate('LB_FechaCons','Fecha de la Consulta','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_Socio = t.Translate('LB_Socio','Socio','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_Hora = t.Translate('LB_Hora','Hora','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_TotTr = t.Translate('LB_TotTr','Totales por Transacci&oacute;n','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_TotSoc = t.Translate('LB_TotSoc','Totales por Socio','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_TotMon = t.Translate('LB_TotMon','Totales por Moneda','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_Total = t.Translate('LB_Total','Saldo','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_Tipo = t.Translate('LB_Tipo','Tipo','/sif/generales.xml')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha Documento','/sif/generales.xml')>
<cfset LB_FechaVencimiento = t.Translate('LB_FechaVencimiento','Fecha Vencimiento','/sif/generales.xml')>
<cfset LB_Oficina = t.Translate('LB_Oficina','Oficina','/sif/generales.xml')>
<cfset LB_Folio = t.Translate('LB_Folio','Folio Referencia','/sif/generales.xml')>
<!--- 
<cfinvoke component="sif.Componentes.DButils"
		  method="toTimeStamp"
		  returnvariable="tsurl">
	<cfinvokeargument name="arTimeStamp" value="#empresats.ts_rversion#"/>
</cfinvoke> --->

<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>

<cfif isdefined("form.CHK_DOCSALDO")>
	<cfset form.Saldo = 1>
<cfelse>
	<cfset form.Saldo= 0>
</cfif>

<cfif isdefined("form.Documento") and len(trim(form.Documento))>
	<cfset form.Documento = form.Documento>
<cfelse>
	<cfset form.Documento = "">
</cfif>

<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo)) and form.Ocodigo NEQ -1>
	<cfset form.Ocodigo = form.Ocodigo>
<cfelse>
	<cfset form.Ocodigo = "">
</cfif>

<cfquery name="rsProc" datasource="#session.DSN#">
	select 
		sum(he.Dtotal) as MontoOrigen,
		sum(he.Dtotal * he.Dtipocambio) as MontoLocal,
		min(he.Dtipocambio) as TC,
		m.Mcodigo as Mcodigo, 
		min(m.Mnombre) as Mnombre,
		s.SNcodigo as SNcodigo, 
		min(s.SNnombre) as SNnombre, 
		<cf_dbfunction name="sPart"		args="min(s.SNnumero),1,9"> as SNnumero,
		min(s.SNidentificacion) as SNidentificacion, 
		he.IDdocumento as IDdocumento,
		he.Ddocumento as Recibo, 
		he.CPTcodigo as CPTcodigo,
		min(he.Ecodigo) as Ecodigo,
		he.Dfecha as Fecha, 
		min(he.EDusuario) EDusuario,
		he.FolioReferencia FolioReferencia,
		min(o.Oficodigo) as Oficina,
		o.Odescripcion as OficinaDes,
		convert(varchar,he.Dfecha, 103) as Dfecha,
		convert(varchar,he.Dfechavenc, 103) as FechaDocumentoVencimiento,
		he.IDdocumento,
		(coalesce(
			(select min(ee.Cconcepto)
			from HEContables ee
			where  ee.IDcontable = bm.IDcontable),

			(select min(e.Cconcepto)
			from EContables e
			where  e.IDcontable = bm.IDcontable)

		)) as Lote,
		(coalesce(
			(
				select min(h.Edocumento)
				from HEContables h
				where  h.IDcontable = bm.IDcontable
			), 
			(
				select min(bb.Edocumento)
				from EContables bb
				where  bb.IDcontable = bm.IDcontable
			)				
		)) as Asiento,
		min( coalesce(ed.EDsaldo, 0.00) ) as EDsaldo,
		min( coalesce (ds.direccion1, ds.direccion2, 'N/A') ) as direccion
	from HEDocumentosCP he
		inner join SNegocios s
			on s.SNcodigo = he.SNcodigo
				and s.Ecodigo = he.Ecodigo
		left outer join SNDirecciones sd
				inner join DireccionesSIF ds
				on ds.id_direccion = sd.id_direccion
			on sd.id_direccion = he.id_direccion
			and sd.SNid = s.SNid
		inner join Monedas m
			on m.Mcodigo = he.Mcodigo 
		inner join Oficinas o
			on o.Ecodigo = he.Ecodigo
			and o.Ocodigo = he.Ocodigo
		left outer join BMovimientosCxP bm
			on bm.SNcodigo = he.SNcodigo
			  and bm.Ddocumento = he.Ddocumento
			  and bm.CPTcodigo = he.CPTcodigo
			  and bm.Ecodigo = he.Ecodigo
			  and bm.CPTRcodigo = he.CPTcodigo
			  and bm.DRdocumento = he.Ddocumento
		inner join CPTransacciones b
			on b.Ecodigo = he.Ecodigo
				and b.CPTcodigo =he.CPTcodigo
		<cfif form.Saldo eq 1>
			inner 
		<cfelse>
			left outer
		</cfif>
			join EDocumentosCP ed
				on ed.IDdocumento = he.IDdocumento
				<cfif form.Saldo eq 1>
				and ed.EDsaldo > 0
				</cfif>
	where he.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and he.Dfecha between  #lsparsedatetime(form.fechaIni)# and #lsparsedatetime(form.fechaFin)#
		  and he.CPTcodigo ='FC'
		  and he.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#"> 
	 	<cfif isdefined("form.Documento") and len(Trim(form.Documento))>
			and he.Ddocumento like '%#form.Documento#%'
	  	</cfif>
	  	<cfif isdefined("form.Ocodigo") and len(Trim(form.Ocodigo)) and form.Ocodigo NEQ -1>
			and he.Ocodigo = #form.Ocodigo#
	  	</cfif>
		group by 
			 m.Mcodigo,
			 s.SNcodigo, 
			 he.IDdocumento, 
			 he.Ddocumento, 
			 he.CPTcodigo,
			 he.Dfecha,
			 bm.IDcontable,
			 o.Odescripcion,
			 he.Dfechavenc,
			 he.FolioReferencia
		order by  o.Odescripcion asc, he.Dfecha asc
</cfquery>
		
<!----- ----->
<cfset HoraReporte = Now()> 



<cfset thisPath = ExpandPath("*.*")>
<cfset thisImg = GetDirectoryFromPath(thisPath)&'imgEmplogo.png'>
<cfif !fileExists(thisImg)>
    <cfquery datasource="asp" name="rsecodigo" maxrows="1">
        select e.Ecodigo
        from Empresa e
        where  Ereferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
    </cfquery>
    <cfquery datasource="asp" name="rs" maxrows="1">
        select
        e.Elogo
        from Empresa e
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsecodigo.Ecodigo#">
    </cfquery>
    <cfif Len(rs.Elogo) LE 1>
        <cflocation url="not_avail.gif" addtoken="no">
    <cfelse>
        <cffile action="write" file="#thisImg#" output="#rs.Elogo#" >
    </cfif>
</cfif>


<cf_importLibs>
<cf_htmlReportsHeaders 
	title="#TIT_ImpHist#"
	filename="RepPagosRealizadosCxP.xls"
	irA="RFacturasSaldosCxP.cfm"
	download="yes"
	preview="no">

<cfquery name="rsEmpresa" datasource="#session.dsn#">
  select Edescripcion,EIdentificacion,ETelefono1, ETelefono2,EDireccion2, ts_rversion from Empresas where Ecodigo = #session.Ecodigo#
</cfquery>

<cfinvoke 
component="sif.Componentes.DButils"
method="toTimeStamp"
returnvariable="tsurl" arTimeStamp="#rsEmpresa.ts_rversion#"> 
</cfinvoke>




<table border="0" cellspacing="0" cellpadding="0" width="92%" align="center">
	<tr><cfoutput>
		<td  colspan="2" rowspan="3" bgcolor="##E4E4E4">
			<img src="/cfmx/home/public/logo_empresa.cfm?EcodigoSDC=#session.EcodigoSDC#&amp;ts=#tsurl#" class="iconoEmpresa" alt="logo" border="0" height="100" width="150" />
		</td>
		<td colspan="5" align="center" bgcolor="##E4E4E4">
			<font size="4"><span class="style3"><strong>#Session.Enombre#</strong></span></font><br>
			<span class="style1">#TIT_Rep#</span><br>
			<span class="style1">#LB_DesdeFec#: #dateformat(form.fechaIni,'dd/mm/yyyy')#&nbsp;&nbsp;#LB_HastaFec#:
			#dateformat(form.fechaFin,'dd/mm/yyyy')#
			</span>
		</td>
		<td colspan="2" rowspan="3" bgcolor="##E4E4E4">
			&nbsp;
		</td>
		</cfoutput>
	</tr>			
	<tr>
		<cfoutput><td colspan="9" align="center" bgcolor="##E4E4E4">&nbsp;</td></cfoutput>
	</tr>
	<tr>
		<td colspan="5" align="center" bgcolor="#E4E4E4">
			<cfoutput>
				<font size="2"><strong>#LB_FechaCons#:&nbsp;</strong>#LSDateFormat(HoraReporte,'dd/mm/yyyy')#&nbsp;<strong>#LB_Hora#:&nbsp;</strong>#TimeFormat(HoraReporte,'medium')#
				</font>
			</cfoutput>
		</td>
	</tr>
	<tr bgcolor="#E4E4E4">
		<td colspan="3" align="left">
			<span class="style1"><cfoutput>#LB_DelSocioc#:</cfoutput></span>&nbsp;&nbsp;  
			<span class="style2"><cfoutput>#rsProc.SNnumero#</cfoutput></span>&nbsp;&nbsp;
		</td> 
		<td colspan="3" align="center">	
			<span class="style1"><cfoutput>#LB_DelSocio#:</cfoutput></span>   
			<span class="style2"><cfoutput>#rsProc.SNnombre#</cfoutput></span>&nbsp;&nbsp;  
		</td>
		<td colspan="3" align="right">
			<span class="style1"><cfoutput>#LB_DelSocioIND#:</cfoutput></span>   
			<span class="style2"><cfoutput>	#rsProc.SNidentificacion#</cfoutput></span>
		</td>
	</tr>				
	<tr  class="style5" bgcolor="#E4E4E4">
			<td colspan="9" align="left"  style="font-size: 12px;">
				<cfoutput>
					<font size="2">Docs con Saldo:</font>
				</cfoutput>
			</td>
	</tr>
	<cfset px = 12>
	<tr class="style5" bgcolor="#E4E4E4">
		<td colspan="9" align="left">
			<cfoutput>	
				<font size="2">Moneda:#rsProc.Mnombre#</font>
			</cfoutput>
		</td>
	</tr>
	<tr class="style5" bgcolor="#E4E4E4">
		<cfoutput>
			<td nowrap="nowrap" align="center" style="width: 12%;">#LB_Folio#</td>
			<td nowrap="nowrap" align="center" style="width: 5%;">#LB_Moneda#</td>
			<td nowrap="nowrap" align="center" style="width: 12%;">#LB_TipoTr#</td>
			<td nowrap="nowrap" align="center" style="width: 15%;">#LB_Documento#</td>
			<td nowrap="nowrap" align="center" style="width: 15%;">#LB_Oficina#</td>		
			<td nowrap="nowrap" align="center" style="width: 10%;">#LB_Fecha#</td>
			<td nowrap="nowrap" align="center" style="width: 12%;">#LB_FechaVencimiento#</td>
			<td nowrap="nowrap" align="center" style="width: 12%;">#LB_Monto#</td>
			<td align="center" nowrap="nowrap" style="width: 7%;">&nbsp;</td>
		</cfoutput>
	</tr>	
	    <cfset SaldoTotalFinal = 0>
	    <!--- <cfsavecontent variable="strTHeadSN">JARR encabezado SN ---> 
	    <cfloop query="rsProc">
		    <cfset SaldoFinal = 0>
			<cfset saldotemp  = 0>
			<cfoutput>
				
			<cfquery name="rsReporteDet" datasource="#session.DSN#">
				select 
					bm.Ddocumento as Recibo,
					convert(varchar,bm.BMfecha, 103) as BMfecha,
				    coalesce(
				        (select min(h.Edocumento)
				        from HEContables h
						where h.IDcontable = bm.IDcontable)
				        ,
				        (select min(h.Edocumento)
				        from EContables h
						where h.IDcontable = bm.IDcontable)
				    ) as Asiento,
					bm.Dtipocambio,
					(
					  select sum(b.Dtotal) 
					  	from BMovimientos b
					   	where b.Ecodigo = bm.Ecodigo
							and b.CCTcodigo = bm.CPTcodigo
							and b.Ddocumento = bm.Ddocumento
							and b.CCTRcodigo = bm.CPTRcodigo 
							and b.DRdocumento = bm.DRdocumento
							and b.BMfecha = bm.BMfecha
					) as MontoOrigen,
					convert(varchar,bm.Dvencimiento, 103) as FechaDocumentoVencimiento,
					(
					  select sum(bb.Dtotal * bb.Dtipocambio) 
						from BMovimientos bb
					   	where bb.Ecodigo = bm.Ecodigo
							and bb.CCTcodigo = bm.CPTcodigo
							and bb.Ddocumento = bm.Ddocumento
							and bb.CCTRcodigo = bm.CPTRcodigo 
							and bb.DRdocumento = bm.DRdocumento
							and bb.BMfecha = bm.BMfecha
					) as MontoLocal,
					(select cc.Cformato
							from CContables cc
							where cc.Ccuenta = bm.Ccuenta) as CuentaDelDetalle,
					bm.Mcodigo,
					m.Mnombre,
					bm.BMmontoref,
					bm.CPTcodigo,
					bm.Ocodigo as Oficina,
					convert(varchar,hd.Dfecha, 103) as Dfecha,
					bm.DRdocumento,
					bm.SNcodigo,
					o.Odescripcion as OficinaDes
					from HEDocumentosCP hd
						inner join BMovimientosCxP bm on bm.Ecodigo = hd.Ecodigo
								and (bm.CPTRcodigo <> bm.CPTcodigo or bm.DRdocumento <> bm.Ddocumento)
						inner join Monedas m
							on m.Mcodigo = bm.Mcodigo
						inner join Oficinas o
							on o.Ecodigo = bm.Ecodigo
							and o.Ocodigo = bm.Ocodigo 
						where 
						bm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and bm.DRdocumento = <cfqueryparam cfsqltype="cf_sql_char" maxlength="20" value="#rsProc.Recibo#">
						and bm.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
						and hd.IDdocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsProc.IDdocumento#">
					union
						select 
						bm.Ddocumento as Recibo,
						convert(varchar,bm.BMfecha, 103) as BMfecha,
						hc.Edocumento as Asiento,
						bm.Dtipocambio,
						(
						  select sum(b.Dtotal) 
						  	from BMovimientos b
						   	where b.Ecodigo = bm.Ecodigo
								and b.CCTcodigo = bm.CPTcodigo
								and b.Ddocumento = bm.Ddocumento
								and b.CCTRcodigo = bm.CPTRcodigo 
								and b.DRdocumento = bm.DRdocumento
								and b.BMfecha = bm.BMfecha
						) as MontoOrigen,
						convert(varchar,bm.Dvencimiento, 103) as FechaDocumentoVencimiento,
						(
						  select sum(bb.Dtotal * bb.Dtipocambio) 
							from BMovimientos bb
						   	where bb.Ecodigo = bm.Ecodigo
								and bb.CCTcodigo = bm.CPTcodigo
								and bb.Ddocumento = bm.Ddocumento
								and bb.CCTRcodigo = bm.CPTRcodigo
								and bb.DRdocumento = bm.DRdocumento
								and bb.BMfecha = bm.BMfecha
						) as MontoLocal,
						(select cc.Cformato
								from CContables cc
								where cc.Ccuenta = bm.Ccuenta) as CuentaDelDetalle,
						bm.Mcodigo,
						m.Mnombre,
						bm.BMmontoref,
						bm.CPTcodigo,
						bm.Ocodigo as Oficina,
						convert(varchar,hd.Dfecha, 103) as Dfecha,
						bm.DRdocumento,
						bm.SNcodigo,
						o.Odescripcion as OficinaDes
						
						from HEDocumentosCP hd
						inner join BMovimientosCxP bm on bm.Ecodigo = hd.Ecodigo
								and (bm.CPTRcodigo <> bm.CPTcodigo or bm.DRdocumento <> bm.Ddocumento)
						inner join Monedas m
							on m.Mcodigo = bm.Mcodigo
						inner join EContables hc
							on hc.IDcontable = bm.IDcontable
						inner join Oficinas o
							on o.Ecodigo = bm.Ecodigo
							and o.Ocodigo = bm.Ocodigo
					where 
						bm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and bm.DRdocumento = <cfqueryparam cfsqltype="cf_sql_char" maxlength="20" value="#rsProc.Recibo#">
						and bm.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
						and hd.IDdocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsProc.IDdocumento#">
					order by CPTcodigo
			</cfquery>

		
	        <!--- cabecera --->
			<tr class="style2">
			<cfoutput>
				<td nowrap="nowrap" align="center">#((ltrim(rtrim(rsProc.FolioReferencia)) eq '') ? 'Sin Referencia' : rsProc.FolioReferencia)#</td>
				<td nowrap="nowrap" align="center">#rsProc.Mnombre#</td>
				<td nowrap="nowrap" align="center">#CPTcodigo#</td>
				<td nowrap="nowrap" align="center">#rsProc.Recibo#</td>
				<td nowrap="nowrap" align="center">#rsProc.OficinaDes#</td>
				<td nowrap="nowrap" align="center">#rsProc.Dfecha#</td>
				<td nowrap="nowrap" align="center">#rsProc.FechaDocumentoVencimiento#</td>
				<td nowrap="nowrap" align="right">#NumberFormat(rsProc.MontoLocal,',_.__')#</td>
				<td nowrap="nowrap" align="right">&nbsp;</td>
			</cfoutput>
			</tr>
			
			<cfif rsProc.recordCount GT 0>
				<cfset SaldoFinal = (#rsProc.MontoLocal#)>
			<cfelse>
				<cfset SaldoFinal = -1> 
			</cfif>

		    </cfoutput>

	        <!--- loop del detalle --->
			<cfloop query="rsReporteDet">
				<cfoutput>
				<cfset px = 0>
					<cfif rsReporteDet.CPTcodigo Neq 'FC'> 
						<cfset px = 10> 
				 	</cfif>
				<tr class="style2">
					<cfquery name="rsReporteFolioRef" datasource="#session.DSN#">
						select FolioReferencia,* from HEDocumentosCP 
		 					where Ddocumento  = '#rsReporteDet.Recibo#'
						 and Ecodigo = #session.Ecodigo#
					</cfquery>	
					<td nowrap="nowrap" align="center">#((ltrim(rtrim(rsReporteFolioRef.FolioReferencia)) eq '') ? 'Sin Referencia' : rsReporteFolioRef.FolioReferencia)#</td>
					<td nowrap="nowrap" align="center">#rsReporteDet.Mnombre#</td>
					<td nowrap="nowrap" align="center">#rsReporteDet.CPTcodigo#</td>
					<td nowrap="nowrap" align="center">#rsReporteDet.Recibo#</td>
					<td nowrap="nowrap" align="center">#rsReporteDet.OficinaDes#</td>
					
					<cfquery name="rsReporteFecha" datasource="#session.DSN#">
						select convert(varchar,Dfecha, 103) as Dfecha from BMovimientosCxP 
						 where ltrim(ltrim(Ddocumento)) = ltrim(rtrim('#rsReporteDet.Recibo#'))
						 and CPTcodigo <> 'FC'
						 <cfif CPTcodigo Neq 'RE'>
						 and CPTRcodigo <> 'FC'
						 </cfif>
						 and Ecodigo = #session.Ecodigo#
					</cfquery>
		
					<td nowrap="nowrap" align="center">#rsReporteFecha.Dfecha#</td>
					<td nowrap="nowrap" align="center">N/A</td>
					<td nowrap="nowrap" align="right">#NumberFormat(rsReporteDet.BMmontoref,',_.__')#</td>
					<td nowrap="nowrap" align="right">&nbsp;</td>
					<cfset SaldoFinal -= #rsReporteDet.BMmontoref#>			
	  		    </cfoutput>	
				</tr>
			<!--- Sacamos el total --->
			</cfloop>
			<tr class="style5" bgcolor="#E4E4E4">
				<td align="left" colspan="7" nowrap="nowrap">&nbsp;</td>
				<cfoutput>
				<td align="center">Saldo Final:</td>
				<td align="right" class="Totales">#NumberFormat(SaldoFinal,',_.__')#</td>
				</cfoutput>
				</td>	
			</tr> 
			<cfset SaldoTotalFinal += SaldoFinal>			
        </cfloop>
       <!---  </cfsavecontent>
		<cfoutput>#strTHeadSN#</cfoutput> --->
	<tr class="style5">
		<td  align="left" colspan="9" nowrap="nowrap">&nbsp;</td>
	</tr> 
    <tr class="style5" bgcolor="#E4E4E4">
		<td  align="left" colspan="7" nowrap="nowrap">&nbsp;</td>
		<cfoutput>
		<td align="center"><strong>Saldo Total:</strong></td>
		<td align="right" class="Totales"><strong>#NumberFormat(SaldoTotalFinal,',_.__')#</strong></td>
		</cfoutput>
		</td>	
	</tr> 

</table>
