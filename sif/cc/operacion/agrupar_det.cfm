<!---Principao--->
<cfquery name="rsSQL" datasource="#session.dsn#">
	select * from EAgrupador where EAid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EAid#">
</cfquery>


<!---Informacion de la configuracion--->
<cfquery name="rsConfig" datasource="#session.dsn#">
	select * from CxCGeneracion where CxCGid= #rsSQL.CxCGid#
</cfquery>


<!---Monedas--->
<cfquery name="rsMoneda" datasource="#session.DSN#">
	select Mcodigo, Mnombre, Miso4217
	from Monedas
	where Ecodigo=
	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>	

<!---Jala la informacion--->
<cfquery name="rsCobros" datasource="#session.dsn#">
	select 
		d.DdocumentoId,
		(select min(SNcodigo) from Documentos where DdocumentoId= d.DdocumentoId) as SNcodigo,
		(select min(s.SNnombre) from SNegocios s,Documentos c where c.DdocumentoId=d.DdocumentoId and s.SNcodigo=c.SNcodigo ) as SNnombre,
		(select min(s.SNnumero) from SNegocios s,Documentos c where c.DdocumentoId=d.DdocumentoId and s.SNcodigo=c.SNcodigo ) as SNumero,
		(select min(Mnombre) from Monedas where Mcodigo=d.McodigoOri) as Mnombre,
		(select min(Miso4217) from Monedas where Mcodigo=d.McodigoOri) as Miso42172,
		(select min(Miso4217) from Monedas where Mcodigo=d.McodigoD) as Miso4217,
		d.Ddocumento,
		d.CCTcodigo,
		d.McodigoD,
		d.McodigoOri,
		d.DAmontoD,
		d.DAretencion,
		d.Aplica,
		DAmontoC		
	from DAgrupador d
		inner join Documentos f
		on f.DdocumentoId=d.DdocumentoId
		and f.Dsaldo > 0 
	where EAid= #form.EAid#
	and  not exists (select 1 from DPagos where Ddocumento=d.Ddocumento)
	order by SNumero,d.McodigoOri,d.Ddocumento
</cfquery>

<cfif rsCobros.recordCount eq 0>
	<table width="100%">
		<tr>
			<td>&nbsp;
				
			</td>
		</tr>
		<tr>
			<td align="center">
				<cfoutput><strong>---No se encontraron registros---</strong></cfoutput>
			</td>
		</tr>
		<cfabort>
	</table>
</cfif>


<!---<cfdump var="#rsCobros#">--->
<form name="form2" action="agrupador_sql.cfm" method="post">
		<cfoutput>
			<input type="hidden" name="btnBorrarSel">
			<input type="hidden" name="EAid" value="#form.EAid#">
				<table border="0"  cellpadding="0" cellspacing="0">
				<tr bgcolor="CCCCCC">
			
				<td></td><td></td><td></td>
				<td style="padding-left:30px;" align="center"><input type="checkbox" name="todos"  onclick="MarcaTodos(this)"/></td>
				<td></td>
				<td style="padding-left:30px;" align="center">Aplica</td>
				<td style="padding-left:30px;" align="center">Documento</td>
				<td style="padding-left:30px;" align="center">Tipo de Transacción</td>
				<td style="padding-left:30px;" align="center">Monto del Documento</td>
				<td></td>
				<td style="padding-left:30px;" align="center">Retención del Documento</td>
				<td></td>
				<td style="padding-left:30px;" align="center">Moneda de Cobro</td>
				<td style="padding-left:30px;" align="center">Monto Moneda de Cobro</td>
			</cfoutput>
		<tr>
		
		
		<cfoutput query="rsCobros" group="SNcodigo">	
			<tr>
				<td colspan="12" nowrap="nowrap"><strong>Socio de Negocios: </strong>#rsCobros.SNumero#-#rsCobros.SNnombre#</td>
			</tr>
			
			<cfoutput group="McodigoOri">
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td colspan="9" nowrap="nowrap"><strong>Moneda Documento: </strong>#rsCobros.Mnombre#</td>
				</tr>		
					<cfoutput>	
						<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
							<td></td><td><td></td></td><td></td>
							<td>
								<a href="javascript: borraLinea(#rsCobros.DdocumentoId#);">
								<img border="0" src="../../imagenes/Borrar01_S.gif" alt="Excluir la linea de Generación de Recibos">
								</a>	
							</td>
							<td style="padding-left:30px;" align="center">
								<input type="checkbox"  name="chkaplica" value="#rsCobros.DdocumentoId#" onclick="ModAplica(this,#rsCobros.DdocumentoId#)" <cfif rsCobros.Aplica eq 1>  checked="checked" </cfif>/>
							</td>
							<td style="padding-left:30px;">#rsCobros.Ddocumento#</td>
								<input type="hidden" name="doc" value="#rsCobros.Ddocumento#">
							<td style="padding-left:30px;">#rsCobros.CCTcodigo#</td>
								<cfif rsCobros.McodigoOri eq rsCobros.McodigoD> 
									<cfset LvarM = 'yes'>
								<cfelse>
									<cfset LvarM='no'>
								</cfif>
							<td style="padding-left:30px;">
								<cf_inputNumber name="MontoM_#rsCobros.DdocumentoId#"  size="15" enteros="13" decimales="2" value="#rsCobros.DAmontoD#"  readOnly="#LvarM#" onChange="CambiaMontoM(#rsCobros.DdocumentoId#,this.value)">
							</td>
							<td>#rsCobros.Miso42172#s</td>
							<td style="padding-left:30px;"><cf_inputNumber name="Mretencion_#rsCobros.DdocumentoId#"  size="15" enteros="13" decimales="2"  readOnly="#LvarM#"  value="#rsCobros.DAretencion#"onChange="CambiaMontoR(#rsCobros.DdocumentoId#,this.value)"> </td>
							<td>#rsCobros.Miso42172#s</td>							
							<td style="padding-left:30px;">
								<select name="Mcodigos" onchange="CambioM(#rsCobros.DdocumentoId#,this.value,#rsCobros.McodigoOri#)">  
									<cfif rsMoneda.RecordCount>
										<cfloop query="rsMoneda">
											<option value="#rsMoneda.Mcodigo#" <cfif #rsMoneda.Mcodigo# EQ rsCobros.McodigoD> selected</cfif>>#rsMoneda.Miso4217#</option>
										</cfloop>
									</cfif>
								</select>
							</td>			
							<td style="padding-left:30px;"><cf_inputNumber name="MontoC_#rsCobros.DdocumentoId#" size="15" enteros="13" decimales="2" value="#rsCobros.DAmontoC#" onChange="CambiaMontoC(#rsCobros.DdocumentoId#,this.value)"></td>
						</tr>
						
					</cfoutput>
			</cfoutput>	
			<tr><td>&nbsp;</td></tr>
		</cfoutput>	
	</table>
			<table width="100%">
				<tr>
					<td align="center" colspan="6"><input type="submit" name="Aplicar" value="Aplicar" /></td>
				</tr>
			</table>
	<iframe name="ifrCambioVal" id="ifrCambioVal" marginheight="0" marginwidth="10" frameborder="0" height="0" width="0" scrolling="auto"></iframe>

<!---	<iframe name="ifrCambioVal" id="ifrCambioVal" marginheight="0" marginwidth="10" frameborder="1" height="500" width="500" scrolling="auto"></iframe>
--->
</form>

<script language="javascript" type="text/javascript">
	<cfoutput>
		function CambioM(Doc,MonedaDoc, MonedaCobro){	
			var LvarMonedaIgual = (MonedaCobro == MonedaDoc);
			setReadOnly(document.form2["MontoM_" + Doc], LvarMonedaIgual);
			setReadOnly(document.form2["Mretencion_" + Doc], LvarMonedaIgual);
			CambiaMoneda(Doc,MonedaDoc,MonedaCobro)
		}
	</cfoutput>
	
	function setReadOnly (obj,readonly){
		if (readonly)
		{
			obj.style.textAlign 	= "right";
			obj.style.border		= "solid 1px #CCCCCC";
			//obj.style.background	= "inherit";
			obj.readOnly			= true;
		}
		else
		{
			obj.style.textAlign 	= "right";
			obj.style.border		= "solid 1px #7f9db9";
			//obj.style.background	= "#FFFFFF";
			obj.readOnly 			= false;
		}
	}
	<cfoutput>
	
	function ModAplica(obj,doc){
//	alert (obj.value);
		if (obj.checked)
		{
			document.getElementById('ifrCambioVal').src = 'agrupaCambiaValor.cfm?doc='+obj.value+'&tipo=1&value=1&EAid=#form.EAid#';
		}
		else
		{
			document.getElementById('ifrCambioVal').src = 'agrupaCambiaValor.cfm?doc='+obj.value+'&tipo=1&value=0&EAid=#form.EAid#';
		}
	}
	
	function MarcaTodos(obj){
		var id = '';
		var obj2 =  document.form2.chkaplica;
		if (obj2.length){
			for (i=0; i<obj2.length; i++){
				obj2[i].checked = obj.checked;
				if (id == '') {
					id = obj2[i].value;
				}
				else{
					id = id +'|'+ obj2[i].value;
				}
				
			}
		}
		else{
			obj2.checked = obj.checked;
			id = obj2.value;
		}
		
		if (obj.checked){		
			document.getElementById('ifrCambioVal').src = 'agrupaCambiaValor.cfm?doc='+id+'&tipo=7&value=1&EAid=#form.EAid#';
		}
		else{
			document.getElementById('ifrCambioVal').src = 'agrupaCambiaValor.cfm?doc='+id+'&tipo=7&value=0&EAid=#form.EAid#';
		}

	}

	function CambiaMoneda(doc,monedaD,monedaC)
		{
			if (monedaD==monedaC){
			document.getElementById('ifrCambioVal').src = 'agrupaCambiaValor.cfm?moneda='+monedaD+'&tipo=2&doc='+doc+'&value=1&EAid=#form.EAid#';
			}
			else{
			document.getElementById('ifrCambioVal').src = 'agrupaCambiaValor.cfm?moneda='+monedaD+'&tipo=2&doc='+doc+'&value=0&EAid=#form.EAid#';
			}
		}
		
	function CambiaMontoM(doc,monto)
		{
		if (monto!= ''){
		document.getElementById('ifrCambioVal').src = 'agrupaCambiaValor.cfm?monto='+qf(monto)+'&tipo=3&doc='+doc+'&EAid=#form.EAid#';
		}
		}
			
	function CambiaMontoR(doc,monto)
		{
		if (monto!= ''){
		document.getElementById('ifrCambioVal').src = 'agrupaCambiaValor.cfm?monto='+qf(monto)+'&tipo=4&doc='+doc+'&EAid=#form.EAid#';
		}
		}
		
	function CambiaMontoC(doc,monto)
		{
		if (monto!= ''){
		document.getElementById('ifrCambioVal').src = 'agrupaCambiaValor.cfm?monto='+qf(monto)+'&tipo=5&doc='+doc+'&EAid=#form.EAid#';
		}
		}
		
	function borraLinea(doc){
		if ( confirm('Desea excluir la Linea de la Generación de Recibos?') )
		{
			document.form2.btnBorrarSel.value= doc;
			document.form2.submit();			
		}
	}
	
	</cfoutput>
</script>

