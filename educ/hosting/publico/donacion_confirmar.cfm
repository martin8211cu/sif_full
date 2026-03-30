<cfparam name="form.MEDforma_pago" default="T">

<cfquery name="proyectos" datasource="#session.dsn#">
	select MEDproyecto, MEDnombre
	from MEDProyecto 
	where Ecodigo = #session.Ecodigo#
	  and (MEDinicio is null or getdate() >= MEDinicio )
	  and (MEDfinal  is null or getdate() < dateadd(dd,1,MEDfinal) )
	order by MEDprioridad
</cfquery>

<cfif isdefined("form.tarjeta")>
	<cfquery name="datosTarjeta" datasource="#session.DSN#">
	select MEpersona, MEDnombre, MEDtctipo, MEDtcnumero, MEDtcvence, MEDtcnombre, MEDtcdigito, MEDtcdireccion1, MEDtcdireccion2, MEDtcciudad, MEDtcestado, MEDtcpais, MEDtczip, BMUsucodigo, BMUlocalizacion, BMUsulogin, BMfechamod
	from MEDTarjetas
	where MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.MEpersona#">
	  and MEDtcid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.tarjeta#">
  </cfquery>
  
<!--- Setea las variables del form--->
<cfset  form.MEDtctipo = datosTarjeta.MEDtctipo  >
<cfset  form.MEDtcnumero = datosTarjeta.MEDtcnumero >
<cfset  form.MEDtcnombre = datosTarjeta.MEDtcnombre  >
<cfset  form.MEDtcvence = datosTarjeta.MEDtcvence  >
<cfset  form.MEDtcdigito = datosTarjeta.MEDtcdigito  >
<cfset  form.MEDtcdireccion1 = datosTarjeta.MEDtcdireccion1  >
<cfset  form.MEDtcdireccion2 = datosTarjeta.MEDtcdireccion2  >
<cfset  form.MEDtcciudad = datosTarjeta.MEDtcciudad  >
<cfset  form.MEDtcestado = datosTarjeta.MEDtcestado  >
<cfset  form.MEDtczip = datosTarjeta.MEDtczip  >
<cfset  form.MEDtcpais = datosTarjeta.MEDtcpais  >

</cfif>

<cfquery name="pais" datasource="asp">
	select Pnombre
	from Pais
	where Ppais=<cfqueryparam cfsqltype="cf_sql_char" value="#form.MEDtcpais#">
</cfquery>


<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Registro de Donaciones
</cf_templatearea>
<cf_templatearea name="body">
	<cfset navBarItems = ArrayNew(1)>
	<cfset navBarLinks = ArrayNew(1)>
	<cfset navBarStatusText = ArrayNew(1)>
		
	<cfset ArrayAppend(navBarItems,'Donaciones')>
	<cfset ArrayAppend(navBarLinks,'/cfmx/hosting/publico/donacion.cfm')>
	<cfset ArrayAppend(navBarStatusText,'Menú de Donaciones')>
	<cfset Regresar = "/cfmx/hosting/publico/donacion.cfm">
	<cfinclude template="pNavegacion.cfm">

	<script language="javascript1.4" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>

	<table width="100%"  border="0" cellspacing="0" cellpadding="2" >
		<tr>
			<td width="1%">&nbsp;</td>
			<td align="center">
				<cf_web_portlet titulo="" border="true" skin="info1" >
					<table border="0" width="100%" cellpadding="0" cellspacing="0" align="center">
						<tr>
							<td width="80%">
								<table border="0" width="100%" cellpadding="0" cellspacing="0" align="center">
									<tr><td align="center"><b>Confirmar Donaci&oacute;n</b></td></tr>

									<tr>
										<td><p>Los datos que se muestran a continuación corresponden a la donación que desea aportar a nuestra Iglesia. Si esta seguro de llevar a cabo la donación haga click en el botón Confirmar.</p></td>
									</tr>

									<tr>
										<td><p>Esta información es totalmente confidencial y la misma está protegida para máxima seguridad. Ningún usuario del Internet puede leer esta información, la misma ha sido codificada exclusivamente para nuestra Iglesia.</p></td>
									</tr>
								</table>
							</td>
							<td width="20%" align="center" valign="middle"><img border="0" src="images/Verisign-Secure-White98x102.gif" ></td>
						</tr>
					</table>
				</cf_web_portlet>
			</td>
			<td colspan="2" valign="middle" align="center"></td>
		</tr>

		<tr>
			<td width="1%">&nbsp;</td>
			<td valign="top" colspan="3" align="center">
				<cfoutput>

				<cfset tipo_pago = "Tarjeta de cr&eacute;dito">

				<form action="donacion_apply.cfm" method="post" name="form1" style="margin:0" >
					<cfif isdefined("session.MEEid") and len(trim(session.MEEid)) gt 0><input type="hidden" name="MEEid" value="#session.MEEid#"></cfif>
					<input type="hidden" name="MEDfecha" value="#LSDateFormat(Now(),'yyyymmdd')#">
		
					<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="3" style="border-top-width:1px; border-top-style:solid; border-top-color:##999999; border-left-width:1px; border-left-style:solid; border-left-color:##999999; border-right-width:1px; border-right-style:solid; border-right-color:##999999; border-bottom-width:1px; border-bottom-style:solid; border-bottom-color:##999999;">

						<tr><td colspan="2" class="tituloListas" align="center">Donación</td></tr>

						<tr>
							<td nowrap valign="baseline"  align="left"><b>Concepto/Proyecto</b></td>
							<td nowrap align="right">
								<input type="hidden" name="MEDproyecto" value="#form.MEDproyecto#">
								<cfloop query="proyectos">
									<cfif form.MEDproyecto eq MEDproyecto>#MEDnombre#</cfif>
								</cfloop>
							</td>
						</tr>

						<tr>
							<td nowrap  align="left"><b>Monto</b></td>
							<td nowrap align="right">
								<input name="MEDimporte" type="hidden" value="#form.MEDimporte#" >
								<input name="MEDmoneda"  type="hidden" value="#form.MEDmoneda#" >
								#LSCurrencyFormat(form.MEDimporte,'none')#&nbsp;
								#form.MEDmoneda#
							</td>

						</tr>
						
						<tr>
							<td  align="left"><b>Fecha</b></td>
							<td align="right">#LSDateFormat(Now(),'dd/mm/yyyy')#</td>
						</tr>


						<tr>
							<td align="left" nowrap ><b>Forma de pago</b></td>
							<td nowrap align="right">
								<input name="MEDforma_pago"  type="hidden" value="#form.MEDforma_pago#" >
								#tipo_pago#
							</td>
						</tr>

						<tr>
							<td nowrap colspan="2" align="center" ><cfif isdefined("form.anonimo")><input name="anonimo" type="hidden" value="1">Esta donaci&oacute;n será registrada de forma an&oacute;nima.</cfif></td>

						</tr>

						<tr><td colspan="2" class="tituloListas" align="center">Información sobre la Forma de Pago ( #tipo_pago# )</td></tr>

						<tr>
							<td colspan="2" nowrap>
								<table border="0" width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<td width="1%" nowrap align="center" valign="top">
											<cfif form.MEDtctipo eq "AMEX">
												<input type="hidden" name="MEDtctipo" value="AMEX" >
												<img src="images/card/AMEX.gif" alt="American Express" width="35" height="36" >&nbsp;
											<cfelseif trim(form.MEDtctipo) eq "MC">
												<input type="hidden" name="MEDtctipo" value="MC" >
												<img src="images/card/MC.gif" alt="Master Card" width="45" height="29" >&nbsp;
											<cfelseif form.MEDtctipo eq "VISA">
												<input type="hidden" name="MEDtctipo" value="VISA" >
												<img src="images/card/VISA.gif" alt="Visa" width="38" height="24" >&nbsp; 
											</cfif>
										</td>

										<td>
											<table width="100%" border="0" cellspacing="0" cellpadding="2">
												<tr>
													<td align="left"><b>No. Tarjeta</b></td>	
													<td nowrap align="right">
														<input name="MEDtcnumero" type="hidden" value="#Trim(form.MEDtcnumero)#">
														<cfif trim(form.MEDtcnumero GT 4)>
															#repeatstring('X', max(8,len(trim(form.MEDtcnumero))-4))##right(trim(form.MEDtcnumero), 4)#
														<cfelse>
															#trim(form.MEDtcnumero)#
														</cfif>
													</td>
												</tr>
												
												<tr>
													<td  align="left" nowrap><b>Nombre como aparece en la Tarjeta</b></td>
													<td nowrap align="right">
														<input name="MEDtcnombre" type="hidden" value="#form.MEDtcnombre#" >
														#form.MEDtcnombre#
													</td>
												</tr>

												<tr>
													<td  align="left"><b>Vencimiento</b></td>
													<td nowrap align="right">
														<cfif isdefined("form.tarjeta")>
															<input name="MEDtcvence" type="hidden" value="#form.MEDtcvence#">
															#form.MEDtcvence#
														<cfelse>
															<input name="MEDtcvence" type="hidden" value="#form.mm#/#RemoveChars(form.yy,1,2)#">
															#form.mm#/#RemoveChars(form.yy,1,2)#
														</cfif>
													</td>
												</tr>
			
												<tr>
													<td  align="left" nowrap><b>Dígito Verificador</b></td>
													<td align="right" nowrap>
														<input name="MEDtcdigito" type="hidden" value="#form.MEDtcdigito#">
														#form.MEDtcdigito#
													</td>
												</tr>

												<tr>
													<td  align="left" nowrap><b>Direcci&oacute;n 1</b></td>
													<td align="right" nowrap>
														<input name="MEDtcdireccion1" type="hidden" value="#form.MEDtcdireccion1#">
														#form.MEDtcdireccion1#
													</td>
												</tr>
												
												<tr>
													<td  align="left" nowrap><b>Direcci&oacute;n 2</b></td>
													<td align="right" nowrap>
														<input name="MEDtcdireccion2" type="hidden" value="#form.MEDtcdireccion2#">
														#form.MEDtcdireccion2#
													</td>
												</tr>

												<tr>
													<td  align="left" nowrap><b>Ciudad</b></td>
													<td align="right" nowrap>
														<input name="MEDtcciudad" type="hidden" value="#form.MEDtcciudad#">
														#form.MEDtcciudad#
													</td>
												</tr>
												
												<tr>
													<td   align="left"nowrap><b>Estado</b></td>
													<td align="right" nowrap>
														<input name="MEDtcestado" type="hidden" value="#form.MEDtcestado#">
														#form.MEDtcestado#
													</td>
												</tr>
												
												<tr>
													<td  align="left"><b>Código Postal</b></td>
													<td valign="top" align="right"><input name="MEDtczip" type="hidden" value="#form.MEDtczip#">#form.MEDtczip#</td>
												</tr>
												
												<tr>
													<td  align="left"><b>País</b></td>
													<td valign="top" align="right"><input name="MEDtcpais" type="hidden" value="#form.MEDtcpais#">#pais.Pnombre#</td>
												</tr>

												<!--- Ocultos --->
												<input type="hidden" name="MEDdescripcion" value="#form.MEDdescripcion#">
												<!---<input type="hidden" name="MEDtcpais" value="#form.MEDtcpais#">--->
												<cfif isdefined("form.tarjeta")>
													<input type="hidden" name="tarjeta" value="#form.tarjeta#">
												</cfif>

											</table>
										</td>
									</tr>
								</table>				
							</td>
						</tr>

						<tr><td>&nbsp;</td></tr>		
	
						<tr>
							<td colspan="2" align="center">
								<input type="submit" name="Alta" value="Confirmar">
								<input type="button" name="Regresar" value="Atrás" onClick="javascript:history.back();">
								<input type="button" name="Cancelar" value="Cancelar" onClick="location.href = '/'">
							</td>
						</tr>

					</table>
				</form>
			</cfoutput>	
		</td>
		<td valign="top"><!--- <img border="0" src="images/Verisign-Secure-White98x102.gif" > ---></td>
		<td width="1%">&nbsp;</td>
	</tr>
</table>

<script language="javascript1.4" type="text/javascript">
	<!--
	//Function Finalizar
	function finalizar(){
		document.form1.MEDimporte.obj.value = qf(document.form1.MEDimporte.obj);
		return true;
	}
	
	function MM_findObj(n, d) { //v4.01
	  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
		d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	  if(!x && d.getElementById) x=d.getElementById(n); return x;
	}

	function show_if(n,v,fp){
		MM_findObj(n).style.display=(fp==v)?'inline':'none';
	}
	function det_forma_pago(fp){
		//var fp = document.form1.MEDforma_pago.value;
		show_if('trcheque',  'C',fp);
		show_if('trtarjeta', 'T',fp);
		show_if('trespecie', 'S',fp);

		document.form1.MEDchbanco.required = ('C'==fp);
		document.form1.MEDchcuenta.required = ('C'==fp);
		document.form1.MEDchnumero.required = ('C'==fp);
		
		document.form1.MEDtctipo.required = ('T'==fp);
		document.form1.MEDtcnumero.required = ('T'==fp);
		document.form1.MEDtcvence.required = ('T'==fp);
		
		document.form1.MEDdescripcion.required = ('S'==fp);
	}

	//det_forma_pago(document.form1.MEDforma_pago.value);
	-->
</script>
</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="pMenu.cfm">
</cf_templatearea>
</cf_template>
