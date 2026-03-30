<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cf_templatecss>
<cf_htmlReportsHeaders
	irA="ReporteOrdenPagoDet.cfm"
	FileName="GestionEmpleados.xls"
	title="Consultas Gestion Empleados">

<style type="text/css">
<!--
.style5 {font-size: 18px; font-weight: bold; }
-->

</style>
<cfquery datasource="#session.DSN#" name="rsEmpresa">
		select
				Edescripcion,
				Ecodigo
		from Empresas
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

      <cfset LvarFiltroLote = "  order by op.TESOPnumero">

<cfif isdefined('form.TESCFLid') and len(trim(#form.TESCFLid#)) and isdefined('form.TESCFLid2') and len(trim(#form.TESCFLid2#))>
   <cfif form.TESCFLid lt form.TESCFLid2>
      <cfset LvarFiltroLote= " and op.TESCFLid >= "& #form.TESCFLid# & " and op.TESCFLid < "& #form.TESCFLid2# & " order by op.TESCFLid, op.TESOPnumero">
   <cfelseif form.TESCFLid gt form.TESCFLid2>
      <cfset LvarFiltroLote= " and op.TESCFLid < "& #form.TESCFLid# & " and op.TESCFLid >= "& #form.TESCFLid2# & " order by op.TESCFLid, op.TESOPnumero">
   <cfelseif form.TESCFLid eq form.TESCFLid2>
      <cfset LvarFiltroLote= " and op.TESCFLid = "& #form.TESCFLid# >
   </cfif>
</cfif>

<cfif isdefined('form.TESTLid') and len(trim(#form.TESTLid#)) and isdefined('form.TESTLid2') and len(trim(#form.TESTLid2#))>
   <cfif form.TESTLid lt form.TESTLid2>
      <cfset LvarFiltroLote= " and op.TESTLid >= "& #form.TESTLid# & " and op.TESTLid < "& #form.TESTLid2# & " order by op.TESTLid, op.TESOPnumero">
   <cfelseif form.TESTLid gt form.TESTLid2>
      <cfset LvarFiltroLote= " and op.TESTLid < "& #form.TESTLid# & " and op.TESTLid >= "& #form.TESTLid2# & " order by op.TESTLid, op.TESOPnumero">
   <cfelseif form.TESTLid eq form.TESTLid2>
      <cfset LvarFiltroLote= " and op.TESTLid = "& #form.TESTLid# >
   </cfif>
</cfif>


<cfquery datasource="#session.dsn#" name="lista">
		Select	count(1) as cantidad
		from TESordenPago op
			left join CuentasBancos cb
				inner join Bancos b
					on b.Bid = cb.Bid
				 on cb.CBid=CBidPago
			left join TESmedioPago mp
				 on mp.TESid 		= #session.Tesoreria.TESid#
				and mp.CBid			= op.CBidPago
				and mp.TESMPcodigo 	= op.TESMPcodigo
			left outer join Empresas e
				on e.Ecodigo=op.EcodigoPago
            left outer join TEScontrolFormulariosD lfd
                    on op. TESCFLid = lfd.TESCFLid
                    and  op.TESOPid= lfd.TESOPid
            left outer join TEStransferenciasD ltd
                    on op. TESTLid = ltd.TESTLid
                    and  op.TESOPid= ltd.TESOPid
            left outer join TEStransferenciaP p
                    on op.TESTPid   = p.TESTPid
		where op.TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			<cfif len(trim(form.TESOPnumero_F))>
				and TESOPnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#TESOPnumero_F#">
			</cfif>
			<cfif len(trim(form.Beneficiario_F))>
				and upper(TESOPbeneficiario #_Cat# ' ' #_Cat# TESOPbeneficiarioSuf) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(trim(form.Beneficiario_F))#%">
			</cfif>
			<cfif len(trim(form.TESOPfechaPago_I))>
				and TESOPfechaPago >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(form.TESOPfechaPago_I)#">
			</cfif>
			<cfif len(trim(form.TESOPfechaPago_F))>
				and TESOPfechaPago <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(form.TESOPfechaPago_F)#">
			</cfif>

			<cfif len(trim(form.CBidPago_F)) and form.CBidPago_F NEQ '-1'>
				and CBidPago=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBidPago_F#">
			<cfelse>
				<cfif isdefined('form.EcodigoPago_F') and len(trim(form.EcodigoPago_F)) and form.EcodigoPago_F NEQ '-1'>
					and op.EcodigoPago=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoPago_F#">
				</cfif>
				<cfif isdefined('form.Miso4217Pago_F') and len(trim(form.Miso4217Pago_F)) and form.Miso4217Pago_F NEQ '-1'>
					and op.Miso4217Pago=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Miso4217Pago_F#">
				</cfif>
			</cfif>
			<cfif form.TESOPestado_F NEQ -1 AND form.TESOPestado_F NEQ "">
			  and TESOPestado = #form.TESOPestado_F#
			</cfif>
			<cfif form.docPago_F NEQ "">
				AND case mp.TESTMPtipo
					when 1 then <cf_dbfunction name="to_char" args="op.TESCFDnumFormulario">
					when 2 then (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
					when 3 then (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
					when 4 then (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
					when 5 then (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
				end = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.docPago_F#">
			</cfif>
            <!---#LvarFiltroLote#--->
          <!---  order by op.TESCFLid,op.TESOPnumero--->
</cfquery>
<cfif lista.cantidad GT 3000>
	<cf_errorCode	code = "50052" msg = "Su consulta posee demasiados registros, por favor defina de nuevo los filtros y vuelva a intentarlo.">
<cfelseif lista.cantidad EQ 0>
	<cf_errorCode	code = "50349" msg = "No se han generado registros para este reporte.">
</cfif>
<cfquery datasource="#session.dsn#" name="lista">
			Select	op.TESOPid,
					TESOPnumero,
					TESOPbeneficiarioId,
					TESOPbeneficiario as TESOPbeneficiario,
					TESOPfechaPago,
					op.Miso4217Pago,
					coalesce(Edescripcion, '-') as empPago,
					Bdescripcion as bcoPago,
					coalesce(CBcodigo,'-') as CBcodigo,
					coalesce(TESOPtotalPago,0) as TESOPtotalPago,
					case mp.TESTMPtipo
						when 1 then 'CHK ' #_Cat# <cf_dbfunction name="to_char" args="op.TESCFDnumFormulario">
						when 2 then 'TRI ' #_Cat# (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
						when 3 then 'TRE ' #_Cat# (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
						when 4 then 'TRM ' #_Cat# (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
						when 5 then 'TCE ' #_Cat# (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
					end as DocPago,
					TESOPmsgRechazo,
					10 as PASO,
					case op.TESOPestado
						when  10 then 'Preparación'
						when  11 then 'En Emisión'
                        when  110 then 'Sin Aplicar'
						when  12 then 'Aplicada'
						when  13 then 'Anulada'
						when 101 then 'Aprobación'
						when 103 then 'Rechazada'
						else 'Estado desconocido'
					end as TESOPestado,
                       coalesce(<cf_dbfunction name="to_char"	args="lfd.TESCFLid">,<cf_dbfunction name="to_char"	args="ltd.TESTLid">) as lote,
                    CBcodigo as cuenta,
                    coalesce(p.TESTPcuenta, '--') as TESTPcuenta , coalesce(p.TESTPbanco, '--') as TESTPbanco
              from TESordenPago op
				left join CuentasBancos cb
					inner join Bancos b
						on b.Bid = cb.Bid
					 on cb.CBid=CBidPago
				left join TESmedioPago mp
					 on mp.TESid 		= #session.Tesoreria.TESid#
					and mp.CBid			= op.CBidPago
					and mp.TESMPcodigo 	= op.TESMPcodigo
				left outer join Empresas e
					on e.Ecodigo=op.EcodigoPago
                left outer join TEScontrolFormulariosD lfd
                    on op. TESCFLid = lfd.TESCFLid
                    and  op.TESOPid= lfd.TESOPid
                left outer join TEStransferenciasD ltd
                    on op. TESTLid = ltd.TESTLid
                    and  op.TESOPid= ltd.TESOPid
                left outer join TEStransferenciaP p
                    on op.TESTPid   = p.TESTPid
			where op.TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
            	and coalesce(cb.CBesTCE,0) = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
				<cfif len(trim(form.TESOPnumero_F))>
					and TESOPnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#TESOPnumero_F#">
				</cfif>
				<cfif len(trim(form.Beneficiario_F))>
					and upper(TESOPbeneficiario #_Cat# ' ' #_Cat# TESOPbeneficiarioSuf) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(trim(form.Beneficiario_F))#%">
				</cfif>
				<cfif len(trim(form.TESOPfechaPago_I))>
					and TESOPfechaPago >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(form.TESOPfechaPago_I)#">
				</cfif>
				<cfif len(trim(form.TESOPfechaPago_F))>
					and TESOPfechaPago <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(form.TESOPfechaPago_F)#">
				</cfif>

				<cfif len(trim(form.CBidPago_F)) and form.CBidPago_F NEQ '-1'>
					and CBidPago=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBidPago_F#">
				<cfelse>
					<cfif isdefined('form.EcodigoPago_F') and len(trim(form.EcodigoPago_F)) and form.EcodigoPago_F NEQ '-1'>
						and op.EcodigoPago=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoPago_F#">
					</cfif>
					<cfif isdefined('form.Miso4217Pago_F') and len(trim(form.Miso4217Pago_F)) and form.Miso4217Pago_F NEQ '-1'>
						and op.Miso4217Pago=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Miso4217Pago_F#">
					</cfif>
				</cfif>
				<cfif form.TESOPestado_F NEQ -1 AND form.TESOPestado_F NEQ "">
				  and TESOPestado = #form.TESOPestado_F#
				</cfif>
				<cfif form.docPago_F NEQ "">
					AND case mp.TESTMPtipo
						when 1 then <cf_dbfunction name="to_char" args="op.TESCFDnumFormulario">
						when 2 then (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
						when 3 then (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
						when 4 then (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
						when 5 then (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
					end = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.docPago_F#">
				</cfif>
                 #LvarFiltroLote#
            <!---  <cfif isdefined('form.lote') and form.lote eq 1>
                 order by op.TESCFLid,op.TESOPnumero
              <cfelse>
                 order by op.TESTLid,op.TESOPnumero
              </cfif>  --->

		</cfquery>
		<table align="center" width="100%" border="0" summary="Reporte" cellpadding="0" cellspacing="0">
		<tr class="listaPar">
			<td align="center" valign="top" colspan="12" nowrap="nowrap"><strong><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong></td>
		</tr>
		<tr class="listaPar">
			<td align="center" valign="top" colspan="12"><strong></strong></td>
		</tr>
		<tr><td align="center" valign="top" colspan="12"><strong>Reporte de Ordenes de Pago</strong></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center" class="RLTtopline" bgcolor="CCCCCC" colspan="8" width="33%" align="center" valign="top" nowrap="nowrap" ><cfoutput><strong>Lista de Ordenes de Pago</strong></cfoutput></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td width="100%" colspan="9" align="center">
				<table width="100%" border="0" cellspacing="0" >
					<tr>
     				   <td align="center" valign="top" bgcolor="#999999" nowrap="nowrap"><strong>N° Orden</strong></td>
					   <td align="center" valign="top" bgcolor="#999999" nowrap="nowrap"><strong>Cédula</strong></td>
					   <td align="center" colspan="2" valign="top" bgcolor="#999999" nowrap="nowrap"><strong>Beneficiario</strong></td>
					   <td align="center" valign="top" bgcolor="#999999" nowrap="nowrap"><strong>Fecha Pago</strong></td>
					   <td align="center" valign="top" bgcolor="#999999" nowrap="nowrap"><strong>Estado</strong></td>
                       <td align="center" valign="top" bgcolor="#999999" nowrap="nowrap"><strong>Lote</strong></td>
					   <td align="center" valign="top" bgcolor="#999999" nowrap="nowrap"><strong>Empresa de Pago</strong></td>
					   <td align="center" valign="top" bgcolor="#999999" nowrap="nowrap"><strong>Cuenta de Pago</strong></td>
					   <td align="center" valign="top" bgcolor="#999999" nowrap="nowrap"><strong>Banco</strong></td>
					   <td align="center" valign="top" bgcolor="#999999" nowrap="nowrap"><strong> Doc. Pago </strong></td>
                       <td align="center" valign="top" bgcolor="#999999" nowrap="nowrap"><strong> Cuenta Transferencia </strong></td>
                       <td align="center" valign="top" bgcolor="#999999" nowrap="nowrap"><strong> Banco Pago </strong></td>
					   <td align="center" valign="top" bgcolor="#999999" nowrap="nowrap"><strong> Moneda Pago </strong></td>
					   <td align="center" valign="top" bgcolor="#999999" nowrap="nowrap"><strong> Monto Pagar </strong></td>


					</tr>
					<cfloop query="lista">
                    <tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
                           <td align="center" valign="top" bgcolor="#CCCCCC"><cfoutput>#lista.TESOPnumero#</cfoutput></td>
						   <td align="center" colspan="2" valign="top" bgcolor="#CCCCCC"><cfoutput>#lista.TESOPbeneficiarioId#</cfoutput></td>
					       <td align="center" valign="top" bgcolor="#CCCCCC"><cfoutput>#lista.TESOPbeneficiario#</cfoutput></td>
						   <td align="center" valign="top" bgcolor="#CCCCCC"><cfoutput>#LSDateFormat(lista.TESOPfechaPago,'DD-MM-YYYY')#</cfoutput></td>
						   <td align="center" valign="top" bgcolor="#CCCCCC"><cfoutput>#lista.TESOPestado#</cfoutput></td>
                           <td align="center" valign="top" bgcolor="#CCCCCC"><cfoutput>#lista.lote#</cfoutput></td>
						   <td align="center" valign="top" bgcolor="#CCCCCC"><cfoutput>#lista.empPago#</cfoutput></td>
						   <td align="center" valign="top" bgcolor="#CCCCCC"><cfoutput>#lista.CBcodigo#</cfoutput></td>
						   <td align="center" valign="top" bgcolor="#CCCCCC"><cfoutput>#lista.bcoPago#</cfoutput></td>
						   <td align="center" valign="top" bgcolor="#CCCCCC"><cfoutput>#lista.DocPago#</cfoutput></strong></td>
						   <td align="center" valign="top" bgcolor="#CCCCCC"><cfoutput>#lista.TESTPcuenta#</cfoutput></strong></td>
   						   <td align="center" valign="top" bgcolor="#CCCCCC"><cfoutput>#lista.TESTPbanco#</cfoutput></strong></td>
                           <td align="center" valign="top" bgcolor="#CCCCCC"><cfoutput>#lista.Miso4217Pago#</cfoutput></td>
						   <td align="right" valign="top" bgcolor="#CCCCCC"><cfoutput>#LSNumberFormat(lista.TESOPtotalPago,"9,9.99")#</cfoutput></td>
					</tr>
					  <cfquery name="rsDetOP" datasource="#session.dsn#">
					      select
						    case a.TESDPtipoDocumento
						    when 0 then 'SP. Manual'
                            when 1 then 'SP. Documentos CxP'
                            when 2 then 'SP. Creacion Anticipo CxP'
                            when 3 then 'SP. Devolucion Anticipo CxC'
                            when 4 then 'SP.Devolucion Anticipos'
                            when 5 then 'SP. Manual X CF'
                            when 6 then 'SP. Anticipos Empleados'
                            when 7 then 'Liquidacion Gastos Empleados'
                            when 8 then 'Fondeo Reintegro Caja Chica'
                            when 9 then 'NA'
                            when 10 then 'Bancos'
                            when 100 then 'Interfaz'
                        end as TESDPtipoDocumento,
						   a.TESDPdocumentoOri,
						   a.TESDPreferenciaOri,
						   a.TESDPdescripcion,
						   coalesce(a.TESDPmontoPago,0) as TESDPmontoPago,
						   coalesce(p.TESSPnumero,0) as TESSPnumero ,
						   coalesce(p.TESSPid,0) as TESSPid,
                           cf.CFformato,
                           isnull(o.Odescripcion,'') as Odescripcion
						from TESdetallePago a
						 left outer join Oficinas o
						    on  a.OcodigoOri = o.Ocodigo
						    and o.Ecodigo=a.EcodigoOri
						 inner join TESsolicitudPago p
     						on a.TESSPid = p.TESSPid
                         inner join  CFinanciera cf
                            on a.CFcuentaDB = cf.CFcuenta
						where a.TESOPid = #lista.TESOPid#
						<cfif isdefined('form.Ocodigo') and len(trim(form.Ocodigo)) and form.Ocodigo NEQ '-1'>
							and a.OcodigoOri=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
						</cfif>
					  </cfquery>
					   <tr>
     				   <td align="center" valign="top" nowrap="nowrap"><strong></strong></td>
					   <td align="center" colspan="2" valign="top" bgcolor="#E0EFFE" nowrap="nowrap"><strong>Tipo</strong></td>
					   <td align="center" colspan="2" valign="top" bgcolor="#E0EFFE" nowrap="nowrap"><strong>Documento</strong></td>
					   <td align="center" colspan="2" valign="top" bgcolor="#E0EFFE" nowrap="nowrap"><strong>Oficina</strong></td>
					   <td align="center" colspan="2" valign="top" bgcolor="#E0EFFE" nowrap="nowrap"><strong>Referencia</strong></td>
					   <td align="center" colspan="2" valign="top" bgcolor="#E0EFFE" nowrap="nowrap"><strong>Descripción</strong></td>
					   <td align="center" valign="top" bgcolor="#E0EFFE" nowrap="nowrap"><strong>Monto</strong></td>
                       <td align="center" colspan="2" valign="top" bgcolor="#E0EFFE" nowrap="nowrap"><strong>Cuenta</strong></td>
					   <td align="center" valign="top" bgcolor="#E0EFFE" nowrap="nowrap"><strong>Solicitud de pago</strong></td>
					   </tr>
					  <cfloop query="rsDetOP">
					      <tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
						   <td align="center" valign="top"><strong></strong></td>
                           <td align="center" colspan="2" valign="top" nowrap="nowrap"><cfoutput>#rsDetOP.TESDPtipoDocumento#</cfoutput></td>
						   <td align="center" colspan="2" valign="top"><cfoutput>#rsDetOP.TESDPdocumentoOri#</cfoutput></td>
						    <td align="center" colspan="2" valign="top"><cfoutput>#rsDetOP.Odescripcion#</cfoutput></td>
					       <td align="center" colspan="2" valign="top"><cfoutput>#rsDetOP.TESDPreferenciaOri#</cfoutput></td>
						   <td align="center" colspan="2" valign="top" nowrap="nowrap"><cfoutput>#rsDetOP.TESDPdescripcion#</cfoutput></td>
						   <td align="center" valign="top"><cfoutput>#LSNumberFormat(rsDetOP.TESDPmontoPago,"0,0.00")#</cfoutput></td>
                           <td align="center" colspan="2" valign="top"><cfoutput>#rsDetOP.CFformato#</cfoutput></td>
						   <td align="center" valign="top"><cfoutput>#rsDetOP.TESSPnumero#</cfoutput></td>
				        </tr>
				      </cfloop>
					  <tr><td>&nbsp;</td></tr>
					</cfloop>
			  </table>
			</td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap" colspan="2"></td>
		</tr>
		<tr><td align="center" nowrap="nowrap" colspan="12"><p>&nbsp;</p>
				  <p>***Fin de Linea***</p></td></tr>
	</table>



<!---<cfif form.formato NEQ "txt">
	<cfreport format="#form.Formato#" template= "ReporteOrdenPago.cfr" query="#lista#">
		<cfreportparam name="Edescripcion" value="#session.Enombre#">
	</cfreport>
<cfelse>
	<cf_exportQueryToFile query="#lista#" separador="#chr(9)#" filename="Reporte_De_OrdenesPago_#session.Usucodigo#_#LSDateFormat(Now(),'ddmmyyyy')#_#LSTimeFormat(Now(),'hh:mm:ss')#.txt" jdbc="false">
</cfif>--->


