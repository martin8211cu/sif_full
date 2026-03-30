<!--- Proveduria Corporativa --->
<cfparam name="form.EcodigoE" default="#session.Ecodigo#">
<cfset lvarProvCorp = false>
<cfset lvarFiltroEcodigo = #session.Ecodigo#>
<cfquery name="rsProvCorp" datasource="#session.DSN#">
	select Pvalor 
	from Parametros 
	where Ecodigo=#session.Ecodigo#
	and Pcodigo=5100
</cfquery>
<cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
	<cfset lvarProvCorp = true>
	<cfquery name="rsEProvCorp" datasource="#session.DSN#">
		select EPCid
		from EProveduriaCorporativa
		where Ecodigo = #session.Ecodigo#
		 and EPCempresaAdmin = #session.Ecodigo#
	</cfquery>
	<cfif rsEProvCorp.recordcount gte 1>
		<cfquery name="rsDProvCorp" datasource="#session.DSN#">
			select DPCecodigo as Ecodigo, Edescripcion
			from DProveduriaCorporativa dpc
				inner join Empresas e
					on e.Ecodigo = dpc.DPCecodigo
			where dpc.Ecodigo = #session.Ecodigo#
			 and dpc.EPCid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsEProvCorp.EPCid)#" list="yes">)
			union
			select e.Ecodigo, e.Edescripcion
			from Empresas e
			where e.Ecodigo = #session.Ecodigo#
			order by 2
		</cfquery>
        <cfloop from="1" to="#rsDProvCorp.recordcount#" index="i">
            <cfset Ecodigos = ValueList(rsDProvCorp.Ecodigo)>
        </cfloop>
	</cfif>    
	<cfif not isdefined('Session.Compras.ProcesoCompra.Ecodigo')>
		<cfset Session.Compras.ProcesoCompra.Ecodigo = session.Ecodigo>
	</cfif>
</cfif>
<table align="left" width="100%">
    <cfif rsEProvCorp.recordcount gte 1>    
        <tr>
            <td nowrap align="right"><strong>Empresa:&nbsp;</strong></td>
            <td colspan="2">
                <select name="EcodigoE" onchange="document.form1.submit();">
                    <option value="<cfoutput>#Ecodigos#</cfoutput>">--Todas--</option>
                    <cfloop query="rsDProvCorp">
                        <option value="<cfoutput>#rsDProvCorp.Ecodigo#</cfoutput>" <cfif (isdefined('form.EcodigoE') and form.EcodigoE eq rsDProvCorp.Ecodigo)> selected</cfif>><cfoutput>#rsDProvCorp.Edescripcion#</cfoutput></option>		
                    </cfloop>	
                </select>  
            </td>
        </tr>
     <cfelse>
        <input type="hidden" name="EcodigoE" value="-2"/>
    </cfif>
    <tr>
        <td width="23%" align="right" nowrap><strong>Del Proveedor:</strong>&nbsp;</td>
        <td width="30%" nowrap>
            <cf_sifsociosnegocios3 sntiposocio="P" sncodigo="snegocios1" snnumero="numero1" snnombre="nombre1" frame="frame1" Ecodigo="#form.EcodigoE#" form="form1">
        </td>
    </tr>
    <tr>
        <td align="right" nowrap><strong>&nbsp;Hasta:</strong>&nbsp;</td>
        <td nowrap>
            <cf_sifsociosnegocios3 sntiposocio="P" sncodigo="snegocios2" snnumero="numero2" snnombre="nombre2" frame="frame2" Ecodigo="#form.EcodigoE#" form="form1">
        </td>
    </tr>
     <tr>
            <td style="text-align:right"><strong>Rango:&nbsp;</strong></td>
            <td colspan="2" align="center">
                <table width="100%">
                    <tr>
                        <td align="left" width="45%">
                            <input type="radio" id="TipoRango1" name="TipoRango" checked="checked" onclick="javascript:CambioRango();"/>
                             Por fecha
                        </td>
                        <td width="2%">&nbsp;</td>
                        <td width="53%" align="left">
                            <input type="radio" id="TipoRango2" name="TipoRango" onclick="javascript:CambioRango();"/>
                             Por Periodo - Mes
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr id="PeriodoMes" style="display:none">
            <td align="right"><strong>Periodo:&nbsp;</strong></td>
            <td>
                &nbsp;<select name="Periodo" id="Periodo">
                <cfloop query = "rsPeriodos">
                    <option value="<cfoutput>#rsPeriodos.Speriodo#</cfoutput>"><cfoutput>#rsPeriodos.Speriodo#</cfoutput></option>
                </cfloop>
                </select>
            </td>
            <td width="45%">    
            <strong>&nbsp;Mes:</strong>
                &nbsp;<select name="Mes" id="Mes">
                    <option value="1"><cfoutput>#CMB_Enero#</cfoutput></option>
                    <option value="2"><cfoutput>#CMB_Febrero#</cfoutput></option>
                    <option value="3"><cfoutput>#CMB_Marzo#</cfoutput></option>
                    <option value="4"><cfoutput>#CMB_Abril#</cfoutput></option>
                    <option value="5"><cfoutput>#CMB_Mayo#</cfoutput></option>
                    <option value="6"><cfoutput>#CMB_Junio#</cfoutput></option>
                    <option value="7"><cfoutput>#CMB_Julio#</cfoutput></option>
                    <option value="8"><cfoutput>#CMB_Agosto#</cfoutput></option>
                    <option value="9"><cfoutput>#CMB_Setiembre#</cfoutput></option>
                    <option value="10"><cfoutput>#CMB_Octubre#</cfoutput></option>
                    <option value="11"><cfoutput>#CMB_Noviembre#</cfoutput></option>
                    <option value="12"><cfoutput>#CMB_Diciembre#</cfoutput></option>
                </select>
            </td>
        </tr>
        <input type="hidden" id="Rango" name="Rango" value="Fecha" />
        <tr id="Fecha" style="display:">
            <td align="right"><strong>Fecha Desde:&nbsp;</strong></td>
            <td>
                <cf_sifcalendario name="fechaDes">
            </td>
           <td  align="left" ><strong>&nbsp;&nbsp;Fecha Hasta:&nbsp;</strong></td>
            <td width="2%" align="left">
                <cf_sifcalendario name="fechaHas">
            </td>
        </tr>
        <tr>
            <td nowrap align="right"><strong>Tipo:&nbsp;</strong></td>
            <td width="34%" >
                    &nbsp;<select name="Tipo" onchange="javascript:cambio_TiposOC(this);">
                        <option value="T">---Todas---</option>
                        <option value="L">Local</option>
                        <option value="I">Internacional</option>
                    </select>
            </td>
        </tr>
         <tr>
            <td nowrap align="right"><strong>Tipo de &Oacute;rden:&nbsp;</strong></td>
            <td width="34%" >
                    &nbsp;<select name="TipoOrden">
                        <option value="T">---Todas---</option>
                    </select>
            </td>
        </tr>
        <tr id="MostrarFechas">
            <td align="right" valign="baseline"><strong>Mostrar Fechas:</strong></td>
            <td>
                <input type="checkbox" name="showDates" />
            </td>    
        </tr>
        <tr><td>&nbsp;</td></tr>
</table>

<script language="JavaScript" type="text/javascript">
			var popUpWin = 0;
			function popUpWindow(URLStr, left, top, width, height){
				if(popUpWin){
					if(!popUpWin.closed) popUpWin.close();
				}
				popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			}
			
			function CambioRango(){
			if(document.getElementById('TipoRango1').checked){
				document.getElementById('PeriodoMes').style.display='none';
				document.getElementById('Fecha').style.display='';
				document.getElementById('Rango').value='Fecha';
			}
			else {
				document.getElementById('Fecha').style.display='none';
				document.getElementById('PeriodoMes').style.display='';
				document.getElementById('Rango').value='PeriodoMes';
			}
		}
		
		/*
			Funcion que realiza la carga de los tipos de ordenes de compra según 
			si es Local o Internacional
		*/
		function cambio_TiposOC(obj){
			var form = obj.form;
			var combo = form.TipoOrden;
			
			combo.length = 1;
			combo.options[0].text = '-- Todas --';
			combo.options[0].value = 'T';
			var i = 1;
			<cfoutput query="rsTipoOrdenes">
				var tmp = #rsTipoOrdenes.CMTOimportacion#;
				if (obj.value == 'T')
					{
						combo.length++;
						combo.options[i].text = '#rsTipoOrdenes.CMTOdescripcion#';
						combo.options[i].value = '#rsTipoOrdenes.CMTOcodigo#';
						i++;
					}else
					{
						if (obj.value == 'I' && tmp== 1) {
								combo.length++;
								combo.options[i].text = '#rsTipoOrdenes.CMTOdescripcion#';
								combo.options[i].value = '#rsTipoOrdenes.CMTOcodigo#';
								i++;
							}else{	
									if (obj.value == 'L' && tmp == 0) {	
										combo.length++;
										combo.options[i].text = '#rsTipoOrdenes.CMTOdescripcion#';
										combo.options[i].value = '#rsTipoOrdenes.CMTOcodigo#';
										i++;
									}
							}	
					}
			</cfoutput>
		}
</script>