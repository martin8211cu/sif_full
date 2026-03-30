<cfif isDefined("Url.GEAid") and not isDefined("form.GEAid")>
  <cfset form.GEAid = Url.GEAid>

</cfif>
<cfif isDefined("Url.imprime") and not isDefined("form.imprime")>
  <cfset form.imprime = Url.imprime>
</cfif>
 
<cfif isdefined('form.GEAid') and form.GEAid NEQ ''>

	<cfquery datasource="#session.dsn#" name="rsReporteTotal">
		Select 
			sa.GEAnumero
			,sa.CFid
			,sa.TESSPid
			, sa.UsucodigoSolicitud
			,tb.TESBeneficiario as pagueseA
			, sa.GEAestado
			, sa.Mcodigo
			, e.Edescripcion
			, m.Mnombre, m.Miso4217
			, sa.GEAfechaSolicitud
			, sa.GEAfechaPagar
			, sa.GEAtotalOri
			, sa.GEAdescripcion
			, sa.GEAidDuplicado
		,{fn concat({fn concat({fn concat({fn concat(dp.Pnombre , ' ' )}, dp.Papellido1 )}, ' ' )}, dp.Papellido2 )} as confeccionadoPor
			, case sa.GEAtipo
				when 0 		then 'SOLICITUD DE PAGO MANUAL'
				when 5 		then 'SOLICITUD DE PAGO MANUAL POR CENTRO FUNCIONAL' 
				when 1 		then 'SOLICITUD DE PAGO DE DOCUMENTOS DE CxP'
				when 2 		then 'SOLICITUD DE PAGO DE ANTICIPOS DE CxP' 
				when 3 		then 'SOLICITUD DE DEVOLUCIN DE ANTICIPOS DE CxC' 
				when 4 		then 'SOLICITUD DE DEVOLUCIN DE ANTICIPOS DE POS' 
				when 100 	then 'SOLICITUD DE PAGO POR INTERFAZ'
				when 6     then 'SOLICITUD DE ANTICIPO DE GASTOS EMPLEADO' 
				else 'SOLICITUD DE PAGO'
			end as Titulo
			, case sa.GEAestado					
				when 0   then 'En Preparacin'
				when 1   then 'En Proceso de Aprobacin'
				when 2   then 'Solicitud Aprobada'
				when 3   then 'Solicitud Rechazada'
				when 23  then 'Solicitud Rechazada en Tesorera'
				when 10  then 'Solicitud Aprobada e Incluida en Preparacin de OP. ' 
				when 101 then 'Solicitud Aprobada e Incluida en Proceso de Aprobacin de OP. ' 
				when 103 then 'Solicitud Rechazada en OP. '
				when 11  then 'Solicitud Aprobada e Incluida en Proceso de Emisin de OP. '
				when 110 then 'Solicitud Emitida en OP. sin Aplicar'
				when 12  then 'Solicitud Pagada en OP.' 
				when 13  then 'Solicitud Anulada en OP. ' 
				else 'Estado Desconocido'					
			end as Estado
			, case sa.GEAestado					
				when 3   then 	'MOTIVO RECHAZO:'
				else '&nbsp;'					
			end as Motivo1
		
			,{fn concat({fn concat({fn concat({fn concat(dpR.Pnombre , ' ' )}, dpR.Papellido1 )}, ' ' )}, dpR.Papellido2 )} as canceladoPor
			
			,tes.TESdescripcion
			,sa.CFid, cfn.CFdescripcion
			,uA.Usulogin
			, x.TESSPmsgRechazo
		from GEanticipo sa
		
			inner join Empresas e
				on e.Ecodigo=sa.Ecodigo		
		
			inner join Monedas m
				on m.Ecodigo=sa.Ecodigo
					and m.Mcodigo=sa.Mcodigo
		
			left outer join CFuncional cfn
				on cfn.CFid = sa.CFid
		
			left outer join Tesoreria tes
				on tes.TESid = sa.TESid			
			
			left outer join TESbeneficiario tb
				 on tb.TESBid	= sa.TESBid

			inner join Usuario u
				inner join DatosPersonales dp
					on dp.datos_personales=u.datos_personales
				on u.Usucodigo=sa.UsucodigoSolicitud
		
		left join Usuario uR
				inner join DatosPersonales dpR
					on dpR.datos_personales=uR.datos_personales
				on uR.Usucodigo=sa.BMUsucodigo
			left join Usuario uA
				on uA.Usucodigo=sa.BMUsucodigo
				
				left join TESsolicitudPago x
				on sa.TESSPid = x.TESSPid
						
		where sa.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
 			and sa.GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">	
	</cfquery>	
</cfif>

<style type="text/css">
<!--
.style1 {
	font-size: 18px;
	font-weight: bold;
	font-family: Arial, Helvetica, sans-serif;
}
.style4 {font-size: 14px}
.style7 {font-size: 14px; font-weight: bold; }
.style8 {
	font-family: "Courier New", Courier, mono;
	font-size: 14px;
}
.style9 {font-family: Georgia, "Times New Roman", Times, serif}
-->
</style>

<cfif isdefined('rsReporteTotal') and rsReporteTotal.recordCount GT 0>
	<cfobject component="sif.Componentes.montoEnLetras" name="LvarObj">
	<cfoutput>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="25%">&nbsp;</td>
			<td width="55%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
		</tr>		
		<tr>
			<td colspan="4" align="center"><span class="style1">#rsReporteTotal.Titulo#</span></td>
		</tr>
		<tr>
			<td colspan="4" align="center"><strong>(#rsReporteTotal.Estado#)</strong></td>
		</tr>
	<cfif rsReporteTotal.GEAestado EQ "0">
		<tr>
			<td colspan="4" align="center"><strong>*** IMPRESI&Oacute;N PRELIMINAR NO OFICIAL ***</strong></td>
		</tr>
	</cfif>
	<cfif NOT listFind("0,1,3",rsReporteTotal.GEAestado)>
		<tr>
			<td>&nbsp;</td>
		</tr>
	</cfif>
		<tr>
	<cfif NOT listFind("0,1,3",rsReporteTotal.GEAestado)>
			<td nowrap><strong>TESORERIA ASIGNADA:&nbsp;</strong></td>
			<td><span class="style4">#rsReporteTotal.GEAdescripcion#</span></td>
	<cfelseif rsReporteTotal.CFid EQ "">
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select 	t_e.TESdescripcion, 
					case  
						when t_e.TESid  is not null then 'Emp.' 
						else 'ERROR' 
					end as tipo
			  from Empresas e
					left join TESempresas te
						inner join Tesoreria t_e
							on t_e.TESid = te.TESid
						on te.Ecodigo = e.Ecodigo
			 where e.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfif rsSQL.tipo EQ "ERROR">
			<cf_errorCode	code = "50738"
							msg  = "LA EMPRESA '@errorDat_1@' NO ESTA ASIGNADA A NINGUNA TESORERA<BR>(Incluirlo en la opcin 'Definicin de Tesorerias Corporativas')"
							errorDat_1="#rsSQL.Edescripcion#"
			>
		</cfif>
			<td nowrap><strong>TESORERIA A ASIGNAR (#rsSQL.tipo#):&nbsp;</strong></td>
			<td><span class="style4">#rsSQL.TESdescripcion#</span></td>
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select 	coalesce(t_cf.TESdescripcion,t_e.TESdescripcion) as TESdescripcion, 
					case  
						when t_cf.TESid is not null then 'C.F.' 
						when t_e.TESid  is not null then 'Emp.' 
						else 'ERROR' 
					end as tipo
			  from CFuncional cf
				inner join Empresas e
					left join TESempresas te
						inner join Tesoreria t_e
							on t_e.TESid = te.TESid
						on te.Ecodigo = e.Ecodigo
					on e.Ecodigo = cf.Ecodigo
				left join TEScentrosFuncionales tcf
					inner join Tesoreria t_cf
						on t_cf.TESid = tcf.TESid
					on tcf.Ecodigo	= e.Ecodigo
				   and tcf.CFid		= cf.CFid
			 where cf.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporteTotal.CFid#">
		</cfquery>
		<cfif rsSQL.tipo EQ "ERROR">
			<cf_errorCode	code = "50739"
							msg  = "NI EL CENTRO FUNCIONAL '@errorDat_1@ - @errorDat_2@' NI LA EMPRESA '@errorDat_3@' ESTAN ASIGNADOS A NINGUNA TESORERA<BR>(Incluirlo en la opcin 'Definicin de Tesoreras Corporativas')"
							errorDat_1="#rsSQL.CFcodigo#"
							errorDat_2="#rsSQL.CFdescripcion#"
							errorDat_3="#rsSQL.Edescripcion#"
			>
		</cfif>
			<td nowrap><strong>TESORERIA A ASIGNAR (#rsSQL.tipo#):&nbsp;</strong></td>
			<td><span class="style4">#rsSQL.TESdescripcion#</span></td>
	</cfif>
			<td nowrap align="right"><strong>NM. SP:&nbsp;&nbsp;</strong></td>
			<td nowrap align="center"><span class="style1">#rsReporteTotal.GEAnumero#</span></td>
		</tr>
		<tr>
			<td nowrap><strong>NOMBRE DE LA COMPA&Ntilde;IA:&nbsp;</strong></td>
			<td>
				<table width="100%"><tr>
					<td>
						<span class="style4">#rsReporteTotal.Edescripcion#</span>
					<td>
					<td style="text-align:right">
						<strong>C.F:</strong>&nbsp;<span class="style4">#rsReporteTotal.CFdescripcion#</span>
					</td>
				</tr></table>
			</td>
			<td nowrap align="right"><strong>FECHA SP:&nbsp;&nbsp;</strong></td>
			<td nowrap align="left"><span class="style4">#LSDateFormat(rsReporteTotal.GEAfechaSolicitud,'dd/mm/yyyy')#</span></td>
		  </tr>
		  <tr>
			<td></td>
			<td><span class="style4"></td>
		  </tr>
		  <tr>
			<td><strong>P&Aacute;GUESE A LA ORDEN DE:</strong></td>
			<td><span class="style4">#rsReporteTotal.pagueseA#</span></td>
		  </tr>
		  <tr>
			<td><strong>ENDOSO:</strong></td>
			<td style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
			<td nowrap align="right">
				<strong>&nbsp;Por Total #rsReporteTotal.Miso4217#s:&nbsp;&nbsp;</strong>
			</td>
			<td nowrap align="left">
				<span class="style4">#LSNumberFormat(rsReporteTotal.GEAtotalOri,',9.00')#</span>
			</td>
		  </tr>		  
		  <tr>
			<td><strong>LA SUMA DE:</strong></td>
			<td colspan="5">#LvarObj.fnMontoEnLetras(rsReporteTotal.GEAtotalOri)# <strong>#rsReporteTotal.Mnombre#</strong></td>
		  </tr>
		  <tr>
		    <td><strong>EXPLICACI&Oacute;N:</strong></td>
			<td colspan="2" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
	      </tr>

		<tr>
			<td><strong>PARA PAGAR EL:</strong></td>
			<td><span class="style4">#DateFormat(rsReporteTotal.GEAfechaPagar,"DD/MM/YYYY")#</span></td>
		</tr>
		
		
	<cfif rsReporteTotal.Motivo1 NEQ "&nbsp;">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="4" style="padding-left:100px; padding-right:100px">
				<table width="100%"  border="0" cellspacing="1" cellpadding="1" style="border:solid 1px gray;">
					<tr>
						<td bgcolor="##E4E4E4" style="border-bottom:solid 1px gray; padding-left:2px; padding-right:20px;">
							<strong>#rsReporteTotal.Motivo1#</strong>
							<strong>#rsReporteTotal.TESSPmsgRechazo#</strong>
						</td>
					</tr>
					<tr>
						<td style="border-top:solid 1px gray; padding-left:2px; padding-right:2px;">
							<strong>Cancelado por:&nbsp;</strong>#rsReporteTotal.canceladoPor#
						</td>
					</tr>
				<cfif rsReporteTotal.GEAidDuplicado EQ "">
					<tr>
						<td style="border-top:solid 1px gray; padding-left:2px; padding-right:2px;">
							<strong>(NO SE HA DUPLICADO)</strong>
						</td>
						</tr>
					<tr>
						<td style="border-top:solid 1px gray; padding-left:2px; padding-right:2px;">
							<strong>DUPLICADO CON:</strong>
							SPs: #LvarTESSPnumD#
						</td>
					</tr>
				</cfif>
				</table>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	<cfelse>			
		  <tr>
			<td nowrap valign="top"><strong>SIRVASE PAGAR MEDIANTE: </strong></td>
			<td nowrap colspan="2">
				<table width="100%" border="0">
					<tr>
						<td width="10%" nowrap>
							<input type="checkbox" name="checkbox" value="checkbox">
							<strong>Cheque</strong>
						</td>
						<td width="30%">&nbsp;</td>
						<td width="5%">&nbsp;</td>
						<td width="10%" nowrap>
							<input type="checkbox" name="checkbox3" value="checkbox">
							<strong>Caja Menuda</strong>
						</td>
						<td width="30%" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td nowrap>
							<input type="checkbox" name="checkbox2" value="checkbox">
							<strong>Banco</strong>
						</td>
						<td style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
						<td>&nbsp;</td>
						<td nowrap>
							<input type="checkbox" name="checkbox4" value="checkbox">
							<strong>Transferencia</strong>
						</td>
						<td style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>
	</cfif>			
		<tr>
			<td colspan="4" align="right">
				<table>
					<tr>
						<td align="right"><strong>CONFECCIONADO:</strong>&nbsp;&nbsp;</td>
						<td>#rsReporteTotal.confeccionadoPor#</td>
					</tr>
					<tr>
						<td align="right"><strong>FECHA:</strong>&nbsp;&nbsp;</td>
						<td>#LSDateFormat(rsReporteTotal.GEAfechaSolicitud,'dd/mm/yyyy')#</td>
					</tr>
					<tr>
						<td align="right"><strong>HORA:</strong>&nbsp;&nbsp;</td>
						<td>#LSTimeFormat(rsReporteTotal.GEAfechaSolicitud)#</td>
					</tr>
				</table>
			</td>
		<tr>
			<td>&nbsp;</td>
		</tr>			  
	</table>
	<table width="100%"  border="1" cellspacing="0" cellpadding="0" class="caja">
		  <tr>
			<td>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="200" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7">CUENTA FINANCIERA</span></td>
					<td width="283" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7">DETALLE DEL PAGO</span></td>
					<td width="160" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7">D&Eacute;BITO</span></td>
					<td width="160" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7">CR&Eacute;DITO</span></td>
					<cfif rsReporteTotal.recordCount LT 19>
						<td width="161" valign="top" rowspan="19" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;">
					<cfelse>
						<td width="161" valign="top" rowspan="#rsReporteTotal.recordCount + 3#" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;">
					</cfif>
					
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
					    <td width="2%" nowrap>&nbsp;</td>
						<td width="98%" nowrap><strong>Ordenado por: </strong></td>
					  </tr>
					  <tr>
					    <td>&nbsp;</td>
						<td>&nbsp;</td>
					  </tr>					  					  
					  <tr>
					    <td style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
						<td style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					  </tr>
					  <tr>
					    <td>&nbsp;</td>
						<td><strong>Revisado por: </strong></td>
					  </tr>
					  <tr>
					    <td>&nbsp;</td>
						<td>&nbsp;</td>
					  </tr>								  
					  <tr>
					    <td style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
						<td style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					  </tr>	  
					  <tr>
					    <td>&nbsp;</td>
						<td><strong>Aprobado por: </strong></td>
					  </tr>
					  <tr>
					    <td>&nbsp;</td>
						<td>&nbsp;</td>
					  </tr>					  					  
					  <tr>
					    <td colspan="2" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;#rsReporteTotal.Usulogin#</td>
					  </tr>
					  <tr>
					    <td nowrap>&nbsp;</td>
						<td nowrap><strong>Refrendado por: </strong></td>
					  </tr>
					  <tr>
					    <td>&nbsp;</td>
						<td>&nbsp;</td>
					  </tr>					  					  
					  <tr>
					    <td style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
						<td style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					  </tr>
					  <tr>
					    <td>&nbsp;</td>
						<td><strong>Forma del env&iacute;o: </strong></td>
					  </tr>					  					  
					  <tr>
					    <td>&nbsp;</td>
						<td><input type="checkbox"  name="checkbox5" value="checkbox">
		Valija</td>
					  </tr>
					  <tr>
					    <td>&nbsp;</td>
						<td><input type="checkbox" name="checkbox52" value="checkbox">
		Correo</td>
					  </tr>
					  <tr>
					    <td>&nbsp;</td>
						<td><input type="checkbox" name="checkbox53" value="checkbox">
		Llamar</td>
					  </tr>
					  <tr>
					    <td>&nbsp;</td>
						<td nowrap><input type="checkbox" name="checkbox54" value="checkbox">
		Pasar a Recoger</td>
					  </tr>
					  <tr>
					    <td>&nbsp;</td>
						<td><input type="checkbox" name="checkbox55" value="checkbox">
		Otros</td>
					  </tr>
					  <tr>
					    <td>&nbsp;</td>
						<td>&nbsp;</td>
					  </tr>
					</table>					
				  </td>
				  </tr>
		
				  <cfloop query="rsReporteTotal">
					  <cfset LvarListaNon = (CurrentRow MOD 2)>
					  <tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
						<!---<td align="left" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style8">#rsReporteTotal.CFid#</span></td>--->
						<td align="left" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style8">#rsReporteTotal.CFid#</span></td>						
						<td align="left" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style8">#rsReporteTotal.GEAdescripcion#</span></td>
						<cfif rsReporteTotal.GEAtotalOri GT 0>
							<td nowrap align="right" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style8">#LSNumberFormat(rsReporteTotal.GEAtotalOri,',9.00')#</span>&nbsp;&nbsp;</td>
							<td align="right" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;">&nbsp;</td>
						<cfelse>
							<td nowrap align="right" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;">&nbsp;</td>
							<td align="right" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style8">#LSNumberFormat(Abs(rsReporteTotal.GEAtotalOri),',9.00')#</span>&nbsp;&nbsp;</td>
						</cfif>
					  </tr>				  
				  </cfloop>		  
				  <tr class=<cfif LvarListaNon + 1>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon + 1>listaNon<cfelse>listaPar</cfif>';">
					<td style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;">&nbsp;</td>
					<td style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;">&nbsp;</td>
					<td style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;">&nbsp;</td>
					<td nowrap style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;" align="right"><strong>#LSNumberFormat(rsReporteTotal.GEAtotalOri,',9.00')#</strong>&nbsp;&nbsp;</td>
				  </tr>			

				<cfif rsReporteTotal.recordCount LT 19>
					<cfloop index = "LoopCount" from = "1" to = "#20 - rsReporteTotal.recordCount#">
					  <tr>
						<td style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;">&nbsp;</td>
						<td style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;">&nbsp;</td>
						<td style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;">&nbsp;</td>
						<td style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;">&nbsp;</td>
					  </tr>			
					</cfloop>
				</cfif>
				</table>	
			</td>
		  </tr>
		</table>		
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td colspan="5">&nbsp;</td>
		  </tr>		
		  <tr>
			<!---<td width="27%"><strong>INSTRUCCI&Oacute;N:</strong></td>--->
			<!---<td colspan="4" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">
				<span class="style4">&nbsp;#rsReporteTotal.TESOPinstruccion#</span>
			</td>--->
		  </tr>
		  <tr>
			<td colspan="5">&nbsp;</td>
		  </tr>		
		  <tr>
			<td width="10%"><strong>TEL&Eacute;FONO:</strong></td>
			<td width="15%" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
			<td width="6%"><strong>&nbsp;EXT.</strong></td>
			<td width="19%" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
			<td width="50%">&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="5">&nbsp;</td>
		  </tr>				  
		  <tr>
			<!---<td valign="top" nowrap><strong>OBSERVACIONES PARA ORDEN DE PAGO:</strong></td>
			<td colspan="4" style="border:solid 1px gray;">
				<span class="style4">#replace(rsReporteTotal.GEAdescripcion,chr(10),"<BR>","ALL")#</span>
			</td>--->
		  </tr>
		</table>
	</cfoutput>		  	
<cfelse>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		Select count(1) as cantidad
		  from GEanticipo sp
		 where sp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
 		  <!--- and sp.GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#" null="#form.GEAid EQ ""#">	--->
	</cfquery>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
		  <td align="center">&nbsp;</td>
		</tr>	  
		<tr>
			<cfif rsSQL.cantidad EQ 0>
				<td align="center"><strong>No se encontr&oacute; la solicitud de pago seleccionada, favor int&eacute;ntelo de nuevo </strong></td>
			<cfelse>
				<td align="center"><strong>La solicitud de pago seleccionada est vaca, favor int&eacute;ntelo de nuevo </strong></td>
			</cfif>

			</cfif>
		</tr>	  
		<tr>
		  <td align="center">&nbsp;</td>
		</tr>
		<tr>
		  <td align="center">&nbsp;</td> 
		</tr>				  
	</table>


