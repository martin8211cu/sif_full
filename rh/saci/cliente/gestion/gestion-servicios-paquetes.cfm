<cfquery name="rsPaquetes" datasource="#session.DSN#">
	Select 
		paq.PQcodigo
		, paq.PQdescripcion
		, coalesce(paq.PQtarifaBasica,-1) as PQtarifaBasica
		, coalesce(paq.PQhorasBasica,-1) as PQhorasBasica
		, coalesce(paq.PQprecioExc,-1) as PQprecioExc
		, s.SVcantidad
		, coalesce(paq.PQmailQuota,-1) as PQmailQuota	
		, m.Msimbolo
	from ISBpaquete paq
		inner join ISBservicio s
			on s.PQcodigo=paq.PQcodigo
	
		inner join ISBservicioTipo st
			on st.TScodigo=s.TScodigo
				and st.TScodigo='MAIL'
				and st.Ecodigo=paq.Ecodigo
				
		left outer join Monedas m
			on m.Ecodigo=st.Ecodigo
				and m.Miso4217=paq.Miso4217					
	
	where paq.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and PQautogestion = 1
	order by paq.PQdescripcion
</cfquery>
<cfoutput>

<form method="post" name="form1" action="gestion.cfm" onsubmit="return valida_continuar();">
	<input name="PQcodigo_n" type="hidden" value="<cfif isdefined("form.PQcodigo_n") and len(trim(form.PQcodigo_n))>#form.PQcodigo_n#</cfif>"/>
	<cfinclude template="gestion-hiddens.cfm">
	<table cellpadding="4" cellspacing="4" width="100%" height="200">
		<tr>
			<td align="center" valign="top" width="60%">
				<center><strong>Elija el servicio que desea agregar.</strong></center>
				<table cellpadding="4" cellspacing="4">
					<cfloop query="rsPaquetes">
						<tr>
							<td><input name="rpaquete" id="rpaquete" type="radio" value="#rsPaquetes.PQcodigo#" onchange="javascript: doShowInfo('#rsPaquetes.PQcodigo#')" <cfif isdefined("form.PQcodigo_n") and len(trim(form.PQcodigo_n)) and form.PQcodigo_n EQ rsPaquetes.PQcodigo>checked</cfif>/><td>
							<td><label id="L#rsPaquetes.PQcodigo#" style="font-style:normal;color:##999999" onmouseover="javascript: showInfo('#rsPaquetes.PQcodigo#')">#rsPaquetes.PQdescripcion#</label> </td>
						</tr>
					</cfloop>
				</table>
				<center><cf_botones values="Continuar" names="Siguiente"></center>
			</td>
			
			<td align="center" id="PQ0" valign="top">
				<cf_web_portlet_start tipo="box">
				<table cellpadding="0" cellspacing="0" border="0"  width="100%">
					<tr><td valign="top" class="cfmenu_menu" >
						<b>Indicaciones:</b><br>
							Seleccione el servicio que desea agregar y haga clic en "Continuar".<br>
							Para obtener más información sobre el servicio, debe posicionar el puntero del mouse 
							sobre el nombre del servicio.
					</td></tr>
				</table>
				<cf_web_portlet_end>
			</td>
			
			<cfloop query="rsPaquetes">
				<cfset PQdescripcion = rsPaquetes.PQdescripcion>
				<cfset PQcodigo = rsPaquetes.PQcodigo>
				<td align="center" id="PQ#PQcodigo#" style="display:none" valign="top">	
					
					<cf_web_portlet_start tipo="box">
						<cfif isdefined('rsPaquetes') and rsPaquetes.recordCount GT 0>
							<!--- Informacion del servicio --->
							<table cellpadding="0" cellspacing="0" border="0" width="100%">
								<tr><td valign="top" colspan="5" class="cfmenu_menu">
									<b>Indicaciones:</b><br>
									Seleccione el servicio que desea agregar y haga clic en "Continuar". <br>
								</td></tr>
								<tr><td valign="top" colspan="5" class="cfmenu_menu">
									<b style="color:##990000">#PQdescripcion#</b>
								</td></tr>
								<tr><td valign="top" colspan="5" class="cfmenu_menu">
									<strong>Informaci&oacute;n de Servicios</strong>
								</td></tr>
								<tr>
									<td valign="top" class="cfmenu_menu">
										<label>Tarifa B&aacute;sica</label>
									</td> 
									<td class="cfmenu_menu">
										<label>Derecho<br>Horas Mensuales</label>
									</td> 
									<td class="cfmenu_menu" nowrap>
										<label>Costo Adic.<br>x Hora</label>
									</td>
									<td class="cfmenu_menu">
										<label>Cant Correos</label>
									</td>
									<td class="cfmenu_menu">
										<label>Cuota Mail</label>&nbsp;(KB)
									</td>																						
								</tr>
								<tr>
									<td align="right" class="cfmenu_menu">#rsPaquetes.Msimbolo#&nbsp;#LsCurrencyFormat(rsPaquetes.PQtarifaBasica,"none")#</td>																						
									<td align="right" class="cfmenu_menu">#rsPaquetes.PQhorasBasica#</td>
									<td align="right" class="cfmenu_menu">
										<cfif rsPaquetes.PQprecioExc EQ -1>
											&nbsp;
										<cfelse>
											#rsPaquetes.Msimbolo#&nbsp;#LsCurrencyFormat(rsPaquetes.PQprecioExc,"none")#
										</cfif>											
									</td>
									<td align="right" class="cfmenu_menu">#rsPaquetes.SVcantidad#</td>
									<td align="right" class="cfmenu_menu" nowrap>
										<cfif rsPaquetes.PQmailQuota EQ -1>
											&nbsp;
										<cfelse>
											#LsCurrencyFormat(rsPaquetes.PQmailQuota,"none")#
										</cfif>							
														
									</td>
								</tr>										
							</table>								
						</cfif>
					<cf_web_portlet_end>
					
				</td>
			</cfloop>
		</tr>
		
	</table>
</form>
	<script language="javascript" type="text/javascript">
		
		function valida_continuar(){
			var error_msg = '';
			var checked=false;
			var i;
			var cod = ""; 
			
			if(#rsPaquetes.RecordCount#==1){
				if(document.form1.rpaquete.checked)	checked=true;
			}
			else{
				for (i=0;i<#rsPaquetes.RecordCount#;i++){ 
				   if(document.form1.rpaquete[i].checked){ 
						cod = document.form1.rpaquete[i].value;
						checked=true;
						 break;
					} 
				}
			}
			if(checked == false ){
				var error_msg = '\n Debe elegir el servicio que desea agregar.';
			}
			if( error_msg != ''){
				alert("Por favor revise los siguiente datos:"+error_msg);
				 return false;
			}
			else{	
				document.form1.PQcodigo_n.value = cod;
				document.form1.adser.value = 2;//indica que el siguiente paso es la eleccion de los logines
				return true;
			}
			
		}
		function doShowInfo(cod){
			showInfo(cod);
		}
		
		function showInfo(cod){
			document.getElementById("PQ0").style.display="none";
			<cfloop query="rsPaquetes">
				document.getElementById("PQ#rsPaquetes.PQcodigo#").style.display="none";
				document.getElementById("L#rsPaquetes.PQcodigo#").style.color="##999999";
			</cfloop>
			if(cod != undefined){
				document.getElementById('PQ'+cod).style.display="";
				document.getElementById('L'+cod).style.color="##000000";
			}
			else
				document.getElementById("PQ0").style.display="";
		}
	</script>
</cfoutput>