<form name="form1" action="" method="post">
	<table width="100%" border="0">
		<tr>
			<td>
				<cfinvoke 
							 component="sif.Componentes.pListas"
							 method="pLista"
							 returnvariable="pListaRet">
						<cfinvokeargument name="columnas"  			value="	
																			b.Bid
																			
																			,b.Bdescripcion 		as Beneficiario
																			
																			,p.CBPTCid
																			,p.CBPTCdescripcion 	as Descripcion
																			,p.CBPTCfecha			as Fecha
																			,p.CBid
																			,p.TESid
																			,p.TESMPcodigo
																			,p.TESTPid
																			,p.TESBid
																			,p.CBPTCtipocambio
																			,p.CBPTCestatus
																			,(select coalesce((select coalesce(sum(CBDPTCmonto),0) from CBDPagoTCEdetalle where CBPTCid = pb.CBPTCid) / pb.CBPTCtipocambio,0)
                                                                                                        from CBEPagoTCE pb 
                                                                                                        where pb.CBPTCid = p.CBPTCid) as Monto"/>
																				
						<cfinvokeargument name="tabla"  			value="	CBEPagoTCE p
																				,CuentasBancos cb
																				,Bancos b"/>
						
						<cfinvokeargument name="filtro"   			value="		  cb.Ecodigo = #Session.Ecodigo#
																			  and cb.CBid = p.CBid
																			  and b.Bid = cb.Bid
																			  and p.CBPTCestatus = 13 	
																			  and coalesce(CBPTCidOri,0) = 0
																			  and not exists(
																						select 1
																						from CBEPagoTCE
																						where CBPTCidOri = p.CBPTCid 
																						) 
																			  "/>
						
						<cfinvokeargument name="desplegar"  		value="Beneficiario, Descripcion, Fecha, Monto"/>
						<cfinvokeargument name="etiquetas"  		value="Beneficiario, Descripci&oacute;n, Fecha, Monto"/>
						<cfinvokeargument name="formatos"   		value="S,S,D,S"/>
						<cfinvokeargument name="align"      		value="left,left,left,left"/>
						<cfinvokeargument name="ajustar"    		value="N"/>
						<cfinvokeargument name="irA"        		value="TCEPagosCancelados-Reporte.cfm"/>
						<cfinvokeargument name="showLink" 			value="true"/>
						<cfinvokeargument name="checkboxes" 	 	value="S"/>
						<cfinvokeargument name="botones"    		value="Duplicar"/>
						<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
						<cfinvokeargument name="maxrows" 			value="15"/>
						
						<cfinvokeargument name="keys"             	value="	CBPTCid,
																			Descripcion,
																			Fecha,
																			CBid,
																			TESid,
																			TESMPcodigo,
																			TESTPid,
																			TESBid,
																			CBPTCtipocambio"/>
					
						<cfinvokeargument name="formname"			value="form1"/>
						<cfinvokeargument name="incluyeform"		value="false"/>
				
				</cfinvoke>
				<input name="marcados" type="hidden" value="">
			</td>
		</tr>
		<tr>
			<input type="hidden" name="onlyRead" value="1">
		</tr>
	</table>
</form>

<script language="JavaScript1.2" type="text/javascript">

	function funcMarca(){
		var f = document.form1;
		if (f.chk != null) {
			if (f.chk.value) {
			
				if (f.chk.checked) {
					f.marcados.value = f.marcados.value + ',' + f.chk.value;
				}
			} else {
				for (var i=0; i<f.chk.length; i++) {
					if (f.chk[i].checked) {
						if (f.length==0)
							f.marcados.value =  f.chk[i].value;
						else
							f.marcados.value = f.marcados.value + ',' + f.chk[i].value;
					}
				}
			}
		}
	}
	
	function funcDuplicar()
	{
		funcMarca(document.form1.chkAllItems);
		if (document.form1.marcados.value.length > 0 ){
			document.form1.action = "TCEPagosCancelados-sql.cfm";	
			return true;			
		}else{
			alert("Debe seleccionar el pago que desea duplicar");
			return false;
			}
		}
</script>	