	<cfif isdefined("form.CTEidentificacion") and len(trim(form.CTEidentificacion))>
		<cfquery name="rsDato" datasource="#session.dsn#">
				select 
				s.QPctaSaldosSaldo,
				a.ts_rversion,
				c.QPcteid,
				c.QPcteNombre,
				t.QPtipoCteDes,
				a.QPvtaTagid,
				d.QPTPAN,
				c.QPcteDocumento,
				a.BMFecha,   
				a.Ecodigo,             
				a.QPTidTag,        
				a.QPctaSaldosid,  
				a.Ocodigo,        
				a.BMusucodigo,
				a.QPvtaEstado 
			from QPventaTags a 
				inner join QPassTag d
					on d.QPTidTag = a.QPTidTag
			
				inner join QPcliente c 
					on c.QPcteid = a.QPcteid 
					
				inner join QPcuentaSaldos s
					on s.QPctaSaldosid = a.QPctaSaldosid 		
							
				inner join QPtipoCliente t
					on c.QPtipoCteid =t.QPtipoCteid 
	
				inner join Usuario u
					on a.BMusucodigo = u.Usucodigo
				inner join DatosPersonales p
					on p.datos_personales = u.datos_personales
	
			where a.Ecodigo = #session.Ecodigo#
			and c.QPcteDocumento = '#form.CTEidentificacion#'
			and a.QPvtaEstado =1
		</cfquery>
				
		<cfif len(trim(rsDato.QPcteid))>
		  <cfset modo = "CAMBIO">
		<cfelse>
		  <cfset modo = "ALTA">
		</cfif>
	<cfelse>
		<cfset modo = "ALTA">
	</cfif>
	
	<cfquery name="rsMovimientos" datasource="#session.dsn#">
		select 
			a.QPMovid,   
			a.QPMovCodigo,
			a.QPMovDescripcion,
			a.Ecodigo,                   
			a.BMFecha,                
			a.BMUsucodigo   
		from QPMovimiento a
		where a.Ecodigo = #session.Ecodigo#
			order by a.QPMovCodigo
	</cfquery>

	<cfif modo neq 'ALTA'>
		<cfquery name="rsDispositivo" datasource="#session.dsn#">
			select 
				s.QPctaSaldosSaldo,
				d.QPvtaTagPlaca,
				t.QPTidTag,
				a.QPcteDocumento,
				t.QPTPAN,
				s.QPctaSaldosid
			from QPcliente a
				inner join QPtipoCliente b
				on b.QPtipoCteid = a.QPtipoCteid

				inner join QPventaTags d 
					on d.QPcteid = a.QPcteid 
					
				inner join QPcuentaSaldos s
					on s.QPctaSaldosid = d.QPctaSaldosid 
					
					
				inner join QPassTag t
				on t.QPTidTag = d.QPTidTag

			where a.Ecodigo = #session.Ecodigo#
			and a.QPcteid = #rsDato.QPcteid#
			and d.QPvtaEstado = 1
		</cfquery>
	</cfif> 

<cfparam name="LvarCTEtipo" default="">
	<cfoutput>
		<form action="QPassMovimiento_Lista.cfm" method="post" name="form1"> 
		<table width="100%" align="left" border="0">
        	<tr>
            	<td align="center">
       				<fieldset style="width:88%">
					<legend>Datos Cliente</legend>
						<table width="100%" align="left" border="0">
							<tr>
								<td align="right" nowrap>*<strong>Ident.:</strong>&nbsp;</td>
								<td align="left" nowrap="nowrap">
									<cfif modo EQ "ALTA"> 
										<select  tabindex="1" name="CTEtipo" onChange="cambiarMascara(this.value);">
											<cfloop query="rsTiposCliente">
												<option value="#rsTiposCliente.QPtipoCteid#">#rsTiposCliente.QPtipoCteDes#</option>
											</cfloop>
										</select>	
									<cfelse>
										<cfif modo NEQ 'ALTA'>#trim(rsDato.QPtipoCteDes)#</cfif>
									</cfif>
									
									<input tabindex="1" type="text" name="CTEidentificacion" size="30" value="<cfif modo NEQ "ALTA">#trim(rsDato.QPcteDocumento)#</cfif>" alt="Identificacin"> 
                    			</td>
                   				<td align="right">*<strong>Cliente:</strong></td>
								<td colspan="3">
									<input type="text" name="QPcteNombre" maxlength="101" size="40" id="QPcteNombre" tabindex="1" style="border-spacing:inherit"  value="<cfif modo NEQ 'ALTA'>#trim(rsDato.QPcteNombre)#</cfif>"<cfif modo NEQ 'ALTA'>readonly=""</cfif>/> 
								</td>
								<cfif modo eq 'ALTA'>
								<td align="center" colspan="3"><cf_botones values="Buscar TAG" names="btnFiltrar" functions = "funcVerT();"></td>
								</cfif>
							</tr>
                			<tr>	
                				<td>&nbsp;</td>
								<td align="right">
									<input  tabindex="-1" type="text" name="SNmask" size="30" readonly value="#LvarCTEtipo#" style="border:none;"> 
								</td>
							</tr>
							<tr>
                				<td colspan="6">&nbsp;</td>
              			  </tr>
						</table>
               		 </fieldset>
					 
					<cfif modo neq 'ALTA'>		 
					<table width="100%" align="left" border="0">
					<tr>
						<td align="center">
							<fieldset style="width:88%">
							<legend>TAG</legend>
								<table width="100%" align="left" border="0">
									<tr>
										<td align="right" nowrap><strong>Movimientos</strong>&nbsp;</td>
										<td align="left" nowrap="nowrap">
											<select name="movimiento" tabindex="1">
												<cfloop query="rsMovimientos">
													<option value="#rsMovimientos.QPMovid#">#rsMovimientos.QPMovCodigo#-#rsMovimientos.QPMovDescripcion#</option>
												</cfloop>
											</select>
										</td>
										
										<td align="right"></td>
										<td colspan="3">
											<cfif rsDispositivo.recordcount gt 0>
												<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
												   <cfinvokeargument name="query"            value="#rsDispositivo#"/>
												   <cfinvokeargument name="desplegar"        value="QPTPAN,QPvtaTagPlaca,QPctaSaldosSaldo"/>
												   <cfinvokeargument name="etiquetas"        value="TAG,Placa,Saldo"/>
												   <cfinvokeargument name="formatos"         value="S,S,M"/>
												   <cfinvokeargument name="align"            value="left,left,left"/>
												   <cfinvokeargument name="ajustar"          value="S"/>
												   <cfinvokeargument name="irA"              value="QPassMovimiento_Lista.cfm"/>
												   <cfinvokeargument name="showEmptyListMsg" value="true"/>
												   <cfinvokeargument name="keys"             value="QPTidTag, QPctaSaldosid"/>
												   <cfinvokeargument name="showEmptyListMsg" value="true"/>
												   <cfinvokeargument name="showLink"         value="true"/>
												   <cfinvokeargument name="incluyeform"      value="false"/>
												   <cfinvokeargument name="form_method"		 value="post"/>
												   <cfinvokeargument name="formname" 		 value="form1"/>
												</cfinvoke>
											  </cfif>									
										</td>
									</tr>
									
									<tr>	
										<td>&nbsp;</td>
										<td align="right">
											<input  tabindex="-1" type="text" name="SNmask" size="30" readonly value="#LvarCTEtipo#" style="border:none;"> 
										</td>
									</tr>
									<tr>
										<td colspan="6">&nbsp;</td>
								  </tr>
								 </fieldset> 
							</table>
							</cfif>
						</td>
					</tr>
			
					<tr>
						<td align="center">
								 <iframe id="frMovimiento" name="frMovimiento" src="frMovimiento.cfm" frameborder="1" height="0" width="0"  scrolling="no"></iframe>
						 </td>
					 </tr>			
						<td colspan="3">
							<cfset ts = "">
							<cfif modo NEQ "ALTA">
								<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsDato.ts_rversion#" returnvariable="ts">        
								</cfinvoke>
							
							<!---<input type="hidden" name="QPctaSaldosid" value="#rsDato.QPctaSaldosid#">--->
							<input type="hidden" name="QPcteid" value="#rsDato.QPcteid#">
						</cfif>
					</td>
				</tr>
       		 </table>
		</form>
</cfoutput>
<cf_qforms form="form1">
    <cf_qformsrequiredfield args="CTEidentificacion,Identificacin">
    <cf_qformsrequiredfield args="QPcteNombre,Cliente">
</cf_qforms>
<cfoutput>
    <script language="javascript1" type="text/javascript">
		<cfif modo EQ "ALTA">
			document.form1.CTEtipo.focus();
		</cfif>
	
		function funcCliente(){
			document.getElementById("frMovimiento").src = "frMovimiento.cfm?CTEidentificacion="+document.form1.CTEidentificacion.value+"&CTEtipo="+document.form1.CTEtipo.value;
		}
		
		function funcVerT(){
			document.form1.action='QPassMovimiento.cfm';
			document.form1.submit;
		}
    </script>
</cfoutput>



