<cfif modoE NEQ 'ALTA'>
	<cfquery name="rsdataEnc" datasource="sifpublica" >
		select ELPid, ELPfdesde, ELPfhasta, Estado, ELPdescripcion, Observaciones, ELPplazocredito, ELPincimpuestos, ts_rversion
		from EListaPrecios
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#"> 
  		  and ELPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ELPid#">
	</cfquery>
</cfif>

<cfoutput>
<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center" >
	<tr>
		<td>
			<table width="100%" cellpadding="1" cellspacing="0" align="center"  border="0" >
				<tr>
					<td align="right" nowrap>
						<strong>Fecha desde:</strong>&nbsp;
					</td>
					
					<cfif isdefined("rsdataEnc.ELPfdesde") and len(trim(rsdataEnc.ELPfdesde))>
						<cfset vfechadesde = LSDateFormat(rsdataEnc.ELPfdesde,'dd/mm/yyyy')>
					<cfelse>
						<cfset vfechadesde = ''>
					</cfif>
					
					<td>
						<cf_sifcalendario form="form1" name="ELPfdesde" value="#vfechadesde#">
					</td>
					<td align="right" nowrap>
						<strong>Fecha hasta:</strong>&nbsp;
					</td>
					
					<cfif isdefined("rsdataEnc.ELPfhasta") and len(trim(rsdataEnc.ELPfhasta))>
						<cfset vfechahasta = LSDateFormat(rsdataEnc.ELPfhasta,'dd/mm/yyyy')>
					<cfelse>
						<cfset vfechahasta = ''>
					</cfif>
					
					<td>
						<cf_sifcalendario form="form1" name="ELPfhasta" value="#vfechahasta#">
					</td>
					<td align="right" nowrap>
						<input type="checkbox" name="ELPincimpuestos" value="<cfif modoE NEQ "ALTA">#rsdataEnc.ELPincimpuestos#</cfif>" <cfif modoE NEQ "ALTA" and rsdataEnc.ELPincimpuestos EQ "1">checked</cfif> >
					</td>
					<td nowrap>
						<strong>Precios Incluyen Impuestos </strong>
					</td>
				</tr>
				
				<tr>
					<td align="right" nowrap>
						<strong>Descripci&oacute;n:</strong>&nbsp;
					</td>
					<td nowrap>
						<input type="text" name="ELPdescripcion" value="<cfif modoE neq 'ALTA'>#rsdataEnc.ELPdescripcion#</cfif>" size="60" maxlength="80">
					</td>
					<td align="right"nowrap>
						<strong>Estado:</strong>&nbsp;
					</td>
					<td nowrap>
						<select name="Estado">
							<option value="1" <cfif modoE NEQ 'ALTA' and rsdataEnc.Estado EQ 1>selected</cfif>>Activa</option>
							<option value="2" <cfif modoE NEQ 'ALTA' and rsdataEnc.Estado EQ 2>selected</cfif>>Inactiva</option>
						</select>
					</td>
					<td align="right" nowrap>&nbsp;</td>

					<td nowrap>
						<table width="30%">
                      		<tr>
                        		<td nowrap>
									<strong>
										<a href="javascript:info();" title="<cfif modoE eq 'ALTA'>Definir<cfelse>Ver/Modificar</cfif> informac&oacute;n adicional (Observaciones)">
                          				<cfif modoE eq 'ALTA'>Definir&nbsp;<cfelse>Ver/Modificar&nbsp;</cfif>informaci&oacute;n adicional</a>
									</strong>&nbsp;
								</td>
								<td>
									<a href="javascript:info();"><img border="0" src="../../imagenes/iedit.gif" alt="<cfif modoE eq 'ALTA'>Definir<cfelse>Ver/Modificar</cfif> informac&oacute;n adicional (Observaciones)"></a>
								</td>
                     		</tr>
                      		<input name="Observaciones" type="hidden" value="<cfif modoE NEQ "ALTA">#rsdataEnc.Observaciones#</cfif>" >
                    	</table>
					</td>
				</tr>
				
				<tr>
					<td align="right" nowrap><strong>Plazo Cr&eacute;dito:</strong>&nbsp;</td>
				  <td nowrap>
						<input type="text" name="ELPplazocredito" value="<cfif modoE neq 'ALTA'>#rsdataEnc.ELPplazocredito#<cfelse>0</cfif>" size="5" maxlength="4" style="text-align:right;" onBlur="javascript:fm(this,0);" onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"> 
					    <strong>d&iacute;as </strong>
					</td>
					<td colspan="2" nowrap>&nbsp;</td>
					<td colspan="2" nowrap align="center">
						<cfif modoE NEQ 'ALTA'>
							<input name="AlmObjecto" type="button" value="Almacenar Objetos" onClick="javascript:AlmacenarObjetos('#rsdataEnc.ELPid#');" >
						</cfif>
					</td>
				</tr>
				
				<tr><td colspan="6" nowrap>&nbsp;</td></tr>
				
				<cfif modoE neq "ALTA">
      				<cfset ts = "">
      				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsdataEnc.ts_rversion#" returnvariable="ts">
      				</cfinvoke>
      				<input type="hidden" name="ts_rversion" value="#ts#">
					<input type="hidden" name="ELPid" value="#form.ELPid#">
    			</cfif>

			</table>
	</tr>
</table>
</cfoutput>

<script type="text/javascript" language="JavaScript1.2" >

	function info(){
		open('ListaPreciosEnc-info.cfm', 'ListaPrecios', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height=260,left=250, top=200,screenX=250,screenY=200');
	}

	function AlmacenarObjetos(valor){
		if (valor != "") {
			document.form1.action = 'ObjetosListaPrecios.cfm';
			document.form1.submit();
		}
		return false;
	}
	
	function mostrarCampos(value){
		document.getElementById("td1").style.display = ( value ? 'none' : '' );
		document.getElementById("td2").style.display = ( value ? 'none' : '' );
	}

</script>
