<cfif isdefined("Form.CTid") and Len(Trim(Form.CTid))>
	<cfquery name="tipoCuenta" datasource="#Session.DSN#">
		select a.CUECUE, a.CTtipoUso, a.Habilitado
		from ISBcuenta a
		where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
	</cfquery>

	<cfquery name="productosCapturados" datasource="#Session.DSN#">
		select count(1) as cantidad
		from ISBproducto a
		where a.CTcondicion = 'C'
		and a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
	</cfquery>
	
</cfif>
<cfoutput>
	<cf_web_portlet_start tituloalign="left" titulo="Contrato de Servicios">
		<script language="javascript" type="text/javascript">
			function goPage(f, paso) {				
				if (f.cue.value == '' && paso > 1) {
					alert('Debe seleccionar una cuenta antes de continuar');
				} 
				else{
				
					continuar=true; 
					if(arguments[2] != undefined){					
						pasoTMP = new Number(f.paso.value);					
						if((pasoTMP + 1) < paso){
							alert('Antes de activar debe revisar todos los pasos.');
							continuar=false;
						}else{
							<cfif session.saci.depositoGaranOK>
								if(!confirm('Desea activar los servicios en la cuenta ?'))
									continuar=false;									
							<cfelse>
								alert('Error, hay un error en la interfaz de Depósito de Garantía,\n no se permite la activación de la cuenta.');
								continuar=false;	
							</cfif>
						}					
					}
					
					if(continuar){
						if(paso > f.paso.value && paso != '7'){
							if(validar(document.form1)){
								if (arguments[2] != undefined) { 
									f.action="agente_cuenta-apply.cfm";
									f.submit();								
								}else{
									document.form1.submitMenu.value = 1;
									document.form1.submit();									
								}
							}
						}else{
							f.paso.value = paso;
							f.submit();
						}
					}
				}				
			}
		</script>
		
		<form name="formCuadroOpt" action="#CurrentPage#" method="get" style="margin: 0;">
			<cfinclude template="agente-hiddens.cfm">
			<input type="hidden"  name="Activar" value="Activar"/>
			<table border="0" cellpadding="2" cellspacing="0" width="100%">
			 
			 <!---<!--- 0 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso GT 0>
					<img src="/cfmx/saci/images/w-check.gif" border="0">
				  <cfelseif Form.paso EQ 0>
					<img src="/cfmx/saci/images/addressGo.gif" border="0">
				  <cfelse>
					&nbsp;
				  </cfif>
				</td>
				<td width="1%" align="right"> <img src="/cfmx/saci/images/number1_16.gif" border="0"> </td>
				<td  nowrap>
					<a href="javascript: goPage(document.formCuadroOpt, 0);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
						<cfif Form.paso EQ 0><strong></cfif>Selecci&oacute;n de Cuenta<cfif Form.paso EQ 0></strong></cfif>
					</a>
				</td>
			  </tr>--->
			 
			  <!--- 1 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso GT 1>
					<img src="/cfmx/saci/images/w-check.gif" border="0">
				  <cfelseif Form.paso EQ 1>
					<img src="/cfmx/saci/images/addressGo.gif" border="0">
				  <cfelse>
					&nbsp;
				  </cfif>
				</td>
				<td width="1%" align="right"> <img src="/cfmx/saci/images/number1_16.gif" border="0"> </td>
				<td  nowrap>
					<a href="javascript: goPage(document.formCuadroOpt, 1);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
						<cfif Form.paso EQ 1><strong></cfif>Configurar Servicios<cfif Form.paso EQ 1></strong></cfif>
					</a>
				</td>
			  </tr>
	
			  <!--- 2 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso GT 2>
					<img src="/cfmx/saci/images/w-check.gif" border="0">
				  <cfelseif Form.paso EQ 2>
					<img src="/cfmx/saci/images/addressGo.gif" border="0">
				  <cfelse>
					&nbsp;
				  </cfif>
				</td>
				<td align="right"><img src="/cfmx/saci/images/number2_16.gif" border="0"></td>
				<td  nowrap>
					<cfif ExisteAgente>
					<a href="javascript: goPage(document.formCuadroOpt, 2);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						<cfif Form.paso EQ 2><strong></cfif>Mecanismo de Env&iacute;o<cfif Form.paso EQ 2></strong></cfif>
					<cfif ExisteAgente>
					</a>
					</cfif>
				</td>
			  </tr>
	
			  <!--- 3 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso GT 3>
					<img src="/cfmx/saci/images/w-check.gif" border="0">
				  <cfelseif Form.paso EQ 3>
					<img src="/cfmx/saci/images/addressGo.gif" border="0">
				  <cfelse>
					&nbsp;
				  </cfif>
				</td>
				<td align="right"><img src="/cfmx/saci/images/number3_16.gif" border="0"></td>
				<td  nowrap>
					<cfif ExisteAgente>
					<a href="javascript: goPage(document.formCuadroOpt, 3);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						<cfif Form.paso EQ 3><strong></cfif>Forma de Cobro<cfif Form.paso EQ 3></strong></cfif>
					<cfif ExisteAgente>
					</a>
					</cfif>
				</td>
			  </tr>
			  
			  <!--- 4 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso GT 4>
					<img src="/cfmx/saci/images/w-check.gif" border="0">
				  <cfelseif Form.paso EQ 4>
					<img src="/cfmx/saci/images/addressGo.gif" border="0">
				  <cfelse>
					&nbsp;
				  </cfif>
				</td>
				<td align="right"><img src="/cfmx/saci/images/number4_16.gif" border="0"></td>
				<td  nowrap>
					<cfif ExisteAgente>
					<a href="javascript: goPage(document.formCuadroOpt, 4);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						<cfif Form.paso EQ 4><strong></cfif>Dep&oacute;sito de Garant&iacute;a<cfif Form.paso EQ 4></strong></cfif>
					<cfif ExisteAgente>
					</a>
					</cfif>
				</td>
			  </tr>
			  
			  <!--- 5 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso GT 5>
					<img src="/cfmx/saci/images/w-check.gif" border="0">
				  <cfelseif Form.paso EQ 5>
					<img src="/cfmx/saci/images/addressGo.gif" border="0">
				  <cfelse>
					&nbsp;
				  </cfif>
				</td>
				<td align="right"><img src="/cfmx/saci/images/number5_16.gif" border="0"></td>
				<td  nowrap>
					<cfif ExisteAgente>
					<a href="javascript: goPage(document.formCuadroOpt, 5);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						<cfif Form.paso EQ 5><strong></cfif>Comprobar Informaci&oacute;n<cfif Form.paso EQ 5></strong></cfif>
					<cfif ExisteAgente>
					</a>
					</cfif>
				</td>
			  </tr>
			 
			<!--- Activacion--->
			<cfif isdefined("tipoCuenta") and tipoCuenta.CTtipoUso NEQ 'F' and isdefined("productosCapturados") and productosCapturados.cantidad GT 0>	  
				  <tr>
					<td width="1%" align="right">&nbsp;</td>
					<td align="right"><img src="/cfmx/saci/images/number6_16.gif" border="0"></td>
					<td  nowrap>
						<cfif ExisteAgente>
						<a href="javascript: goPage(document.formCuadroOpt,6,'activar');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
						</cfif>
						<cfif Form.paso EQ 6><strong></cfif>Activar<cfif Form.paso EQ 6></strong></cfif>
						<cfif ExisteAgente>
						</a>
						</cfif>
					</td>
				  </tr>
				  
			 <cfelse>
			 
			   <!--- Reimpresion --->
				<cfif isdefined("Form.CTid") and Len(Trim(Form.CTid))>
					<tr>
						<td width="1%" align="right" nowrap style="border-top:groove;">&nbsp;</td>
						<td align="right" style="border-top:groove;"><img src="/cfmx/saci/images/number6_16.gif" border="0"></td>
						<td  nowrap style="border-top:groove;">
							<cfif ExisteAgente>
							<a href="javascript: goPage(document.formCuadroOpt, 7);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
							</cfif>
							<cfif Form.paso EQ 7><strong></cfif>Imprimir<cfif Form.paso EQ 7></strong></cfif>
							<cfif ExisteAgente>
							</a>
							</cfif>
						</td>
					</tr>
				</cfif>
				
			</cfif>
			</table>
		</form>
	<cf_web_portlet_end>  
</cfoutput>
