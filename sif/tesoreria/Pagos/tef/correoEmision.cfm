<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cf_templatecss>

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

<cfquery datasource="#session.dsn#" name="lista">
			Select	op.TESOPid,
					TESOPnumero,
					TESOPbeneficiarioId, 
					TESOPbeneficiario #_Cat# TESOPbeneficiarioSuf as TESOPbeneficiario,
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
            	and op.TESOPid =#LvarTESOPid#
                 
		</cfquery>
        
        </p>
        Estimado proveedor,
        <cfoutput>#rsEmpresa.Edescripcion#</cfoutput> realizó una transferencia de fondos a la cuenta <cfoutput>#lista.TESTPcuenta# </cfoutput>
        del banco <cfoutput>#lista.TESTPbanco#</cfoutput> por un monto de  <cfoutput>#LSNumberFormat(lista.TESOPtotalPago,"9,9.99")#</cfoutput>
        <cfoutput>#lista.Miso4217Pago#</cfoutput>, por concepto de:
        </p> 
       
        
        
		<table align="center" width="100%" border="0" summary="Reporte" cellpadding="0" cellspacing="0">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center" class="RLTtopline" bgcolor="CCCCCC" colspan="8" width="33%" align="center" valign="top" nowrap="nowrap"><cfoutput><strong>Lista de Ordenes de Pago</strong></cfoutput></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td width="100%" colspan="8" align="center">
				<table width="100%" border="0" cellspacing="0" >
					<cfloop query="lista">
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
                           cf.CFformato
						from TESdetallePago a
						 inner join TESsolicitudPago p
     						on a.TESSPid = p.TESSPid
                         inner join  CFinanciera cf
                            on a.CFcuentaDB = cf.CFcuenta  
						where a.TESOPid = #lista.TESOPid#
					  </cfquery>
					   <tr>
     				   <td align="center" valign="top" nowrap="nowrap"><strong></strong></td>
					   <td align="center" colspan="2" valign="top" bgcolor="#E0EFFE" nowrap="nowrap"><strong>Tipo</strong></td>
					   <td align="center" colspan="2" valign="top" bgcolor="#E0EFFE" nowrap="nowrap"><strong>Documento</strong></td>
					   <td align="center" colspan="2" valign="top" bgcolor="#E0EFFE" nowrap="nowrap"><strong>Descripción</strong></td>
					   <td align="center" valign="top" bgcolor="#E0EFFE" nowrap="nowrap"><strong>Monto</strong></td>					   </tr>
					  <cfloop query="rsDetOP">
					      <tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
						   <td align="center" valign="top"><strong></strong></td>
                           <td align="center" colspan="2" valign="top" nowrap="nowrap"><cfoutput>#rsDetOP.TESDPtipoDocumento#</cfoutput></td>
						   <td align="center" colspan="2" valign="top"><cfoutput>#rsDetOP.TESDPdocumentoOri#</cfoutput></td>
						   <td align="center" colspan="2" valign="top" nowrap="nowrap"><cfoutput>#rsDetOP.TESDPdescripcion#</cfoutput></td>
						   <td align="center" valign="top"><cfoutput>#LSNumberFormat(rsDetOP.TESDPmontoPago,"0,0.00")#</cfoutput></td>
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
 	Se informa que Grupo Nación GN, S.A. buscando el mejoramiento continuo tiene a su disposición el sistema de pago por medio de transferencia electrónica de fondos. 
    Mediante esta modalidad sus pagos quedarán aplicados directamente a su cuenta bancaria los días viernes de cada semana, para mayor información comunicarse con el 
    departamento de Tesorería a los teléfonos 2247-4160 y 2247-4143.
		
		
<!---<cfif form.formato NEQ "txt">
	<cfreport format="#form.Formato#" template= "ReporteOrdenPago.cfr" query="#lista#">
		<cfreportparam name="Edescripcion" value="#session.Enombre#">
	</cfreport>
<cfelse>
	<cf_exportQueryToFile query="#lista#" separador="#chr(9)#" filename="Reporte_De_OrdenesPago_#session.Usucodigo#_#LSDateFormat(Now(),'ddmmyyyy')#_#LSTimeFormat(Now(),'hh:mm:ss')#.txt" jdbc="false">
</cfif>--->


