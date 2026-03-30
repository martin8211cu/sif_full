<cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
<cfset javaRT.gc()>

<cfquery name="rsOficinas" datasource="#session.DSN#">
	Select Ocodigo, Oficodigo, Odescripcion
	from Oficinas
	where Ecodigo = #Session.Ecodigo#
	order by Odescripcion
</cfquery>
<cfset navegacion = "">

<cfif isdefined('url.CatSoc') and not isdefined('form.CatSoc')>
	<cfset form.CatSoc = url.CatSoc>
</cfif>
<cfif isdefined("session.SocioCxC") and len(trim(session.SocioCxC))>
	<cfset form.SNcodigo = session.SocioCxC>
</cfif>
<cfif isDefined("Url.SNcodigo") and not isDefined("form.SNcodigo")>
	<cfset form.SNcodigo = Url.SNcodigo>
</cfif>
<cfif isDefined("Url.SNnumero") and not isDefined("form.SNnumero")>
	<cfset form.SNnumero = Url.SNnumero>
</cfif>
<cfif isDefined("Url.Ocodigo_F") and not isDefined("form.Ocodigo_F")>
	<cfset form.Ocodigo_F = Url.Ocodigo_F>
</cfif>
<cfif isDefined("Url.id_direccion") and not isDefined("form.id_direccion")>
	<cfset form.id_direccion = Url.id_direccion>
</cfif>
<cfif isdefined("URL.SNcodigo") and len(trim(URL.SNcodigo))>
	<cfset form.SNcodigo=URL.SNcodigo>
</cfif>
<cfparam name="url.Ecodigo" default="#session.Ecodigo#">
<cfif isdefined("Url.Ecodigo") and not isdefined("Form.Ecodigo")>
	<cfparam name="Form.Ecodigo" default="#Url.Ecodigo#">
</cfif>
<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
	<cfquery name="rsSNid" datasource="#session.DSN#">
		select SNid
		from SNegocios
		where Ecodigo = #session.Ecodigo#
		  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
	</cfquery>
<cfquery name="rsLista" datasource="#session.DSN#">
	select SNcodigo, SNid,
		<cfif isdefined('form.SNidRel')>
			case when SNid = #form.SNidRel# then 1 else 2 end as SNorden,
			case when SNid = #form.SNidRel# then '<strong>' #CAT# SNnumero #CAT# '</strong>' else SNnumero end as SNnumero,
			case when SNid = #form.SNidRel# then '<strong>' #CAT# SNnombre #CAT# '</strong>' else SNnombre end as SNnombre
		<cfelse>
			1 as SNorden,
			SNnumero, SNnombre
		</cfif>
	  from SNegocios
	 where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ecodigo#">
		<cfif isdefined('form.SNidRel')>
		   and #form.SNidRel# in (SNid, SNidPadre)
		</cfif>
	   and SNinactivo = 0
		<cfif isdefined("filtro") and len(trim(filtro))>
			#preservesinglequotes(filtro)#
		</cfif>
       and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
	order by 3,4
</cfquery>
	<cfoutput>
		<script language="javascript1.1" type="text/javascript">
			function funcAgregar(){
				var PARAM  = "/cfmx/sif/cc/catalogos/Contacto.cfm?SNcodigo=#form.SNcodigo#&Nuevo=1";
				open(PARAM,'V1','left=100,top=150,scrollbars=yes,resizable=no,width=1000,height=350')
			}
		</script>
	</cfoutput>
	<cf_dbfunction name="to_char" args="ds.SNDcodigo" returnvariable="LvarSNDcodigo">
	<cf_dbfunction name="concat" args="dp.Pnombre, ' ',dp.Papellido1,' ',dp.Papellido2" returnvariable="Lvarnombre">
	<cfquery name="rsContactoSocio" datasource="#session.DSN#">
		select
			cs.CSEid,
			hd.CCTcodigo,
			hd.Ddocumento,
			cs.HDid,
			us.Usulogin,
			cs.CSEFecha,
			cs.TCid,
			cs.CSEnombreContacto,
			#PreserveSingleQuotes(Lvarnombre)# as Responsable
		from ContactoSocioE cs
			left outer join HDocumentos hd
				on hd.HDid = cs.HDid

			inner join Usuario us
				inner join DatosPersonales dp
					on dp.datos_personales = us.datos_personales
				on us.Usucodigo = cs.Usucodigo

			left outer join SNDirecciones ds
				on ds.SNid = cs.SNid
				and ds.id_direccion = cs.id_direccion
		where cs.SNid = #rsSNid.SNid#
		  and cs.CSEEstatus = 1
		  <cfif isdefined("form.id_direccion")>
			  	and cs.id_direccion = #form.id_direccion#
		  </cfif>
	</cfquery>
</cfif>
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 		= t.Translate('LB_TituloH','SIF - Cuentas por Cobrar')>
<cfset TIT_AnaSaldo 	= t.Translate('TIT_AnaSaldo','An&aacute;lisis del Saldo Actual de Socio')>
<cfset MSG_DigSoc 	= t.Translate('MSG_DigSoc','Debe digitar el Socio de Negocios')>
<cfset LB_Socio = t.Translate('LB_Socio','Socio')>
<cfset LB_OfEmp = t.Translate('LB_OfEmp','Oficina de Empresa')>
<cfset LB_Analisi = t.Translate('LB_Analisi','Análisis')>
<cfset LB_Datos = t.Translate('LB_Datos','Datos')>
<cfset LB_Saldo 	= t.Translate('LB_Saldo','Saldo')>
<cfset LB_Antig 	= t.Translate('LB_Antig','Antiguedad')>
<cfset LB_Hist 	= t.Translate('LB_Hist','Hist&oacute;rico')>
<cfset LB_Regresar = t.Translate('LB_Regresar','Regresar','/sif/generales.xml')>
<cfset LB_Todas = t.Translate('LB_Todas','Todas','/sif/generales.xml')>
<cfset LB_Oficina = t.Translate('Oficina','Oficina','/sif/generales.xml')>
<cfset LB_Responsable 	= t.Translate('LB_Responsable','Responsable')>
<cfset LB_Transaccion 	= t.Translate('LB_Transaccion','Transacción')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_UsuAsig = t.Translate('LB_UsuAsig','Usuario Asignado')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Tipo = t.Translate('LB_Tipo','Tipo','/sif/generales.xml')>
<cfset LB_Contacto = t.Translate('LB_Contacto','Contacto')>
<cfset LB_Pendientes = t.Translate('LB_Pendientes','Pendientes')>
<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocios','/sif/generales.xml')>
<cfset LB_Vencimiento 	= t.Translate('LB_Vencimiento','Vencimiento')>
<cfset LB_Corriente 	= t.Translate('LB_Corriente','Corriente')>
<cfset LB_SinVenc 		= t.Translate('LB_SinVenc','Sin Vencer')>
<cfset LB_Masde = t.Translate('LB_Masde','Mas de')>
<cfset LB_Dir 	= t.Translate('LB_Dir','Direcci&oacute;n')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto')>
<cfset LB_Local = t.Translate('LB_Local','Local')>
<cfset LB_Documentos = t.Translate('LB_Documentos','Documentos')>


<cf_templateheader title="#LB_TituloH#">
           <cf_web_portlet_start titulo='#TIT_AnaSaldo#'>
		  	<cfinclude template="../../portlets/pNavegacion.cfm">

			<script language="javascript" type="text/javascript">
				function funcDatos(){
					if (document.form2.SNcodigo.value != '') {
						document.form2.action = "../../ad/catalogos/DatosGSocio.cfm";
						document.form2.submit();}
					else {
							alert('#MSG_DigSoc#');
							return false;
						}
				}

				function funcImprimir(){
					if (document.form2.SNcodigo.value != '') {
						document.form2.action = "ImpresionSaldoCliente.cfm";
						document.form2.method = "get";
						document.form2.submit();}
					else {
							alert('#MSG_DigSoc#');
							return false;
						}
				}

			</script>
			<form name="form1" method="post" action="" style="margin:0;">
				<cfif isdefined('form.CatSoc') and form.CatSoc EQ 1>
					<cfoutput><input name="CatSoc"  type="hidden" value="#form.CatSoc#"></cfoutput>
				</cfif>
				<table align="center" width="100%" border="0" cellspacing="0" cellpadding="3" class="AreaFiltro">
				<cfif not (isdefined("session.SocioCxC") and len(trim(session.SocioCxC)))>
				  <tr nowrap>
                  	<cfoutput>
					<td>&nbsp;</td>
					<td align="right" nowrap class="FileLabel"><strong>#LB_Socio#:</strong></td>
					<td>
						<cfif isdefined('form.SNcodigo') and form.SNcodigo NEQ ''>
							<cf_sifsociosnegocios2 SNcodigo="SNcodigo" SNnombre="SNnombre" SNnumero="SNnumero" idquery="#form.SNcodigo#" tabindex="1">
						<cfelse>
							<cf_sifsociosnegocios2 SNcodigo="SNcodigo" SNnombre="SNnombre" SNnumero="SNnumero" tabindex="1">
						</cfif>
					</td>
					<td nowrap class="FileLabel" align="right"><strong>#LB_OfEmp# </strong>:
					</td>
                    </cfoutput>
					<td>
						<select name="Ocodigo_F" id="Ocodigo_F" tabindex="1">
							<cfif isdefined('rsOficinas') and rsOficinas.recordCount GT 0>
								<option value="-1"><cfoutput>-- #LB_Todas# --</cfoutput></option>
								<cfoutput query="rsOficinas">
									<option value="#rsOficinas.Ocodigo#"<cfif isdefined('form.Ocodigo_F') and len(trim(form.Ocodigo_F)) and form.Ocodigo_F EQ rsOficinas.Ocodigo> selected</cfif>>#rsOficinas.Odescripcion#</option>
								</cfoutput>
							</cfif>
			    	</select>					</td>
					<td nowrap align="center" valign="middle">
						<cfif isdefined('form.CatSoc') and form.CatSoc EQ 1>
							<cfset regresa = '../../ad/catalogos/Socios.cfm?SNcodigo=#form.SNcodigo#'>
						</cfif>
					</td>
				  </tr>
				  </cfif>
				  <tr>
				 	 <td colspan="6">
						<table border="0" cellspacing="0" cellpadding="0" width="50%" align="center">
 							<tr>
    							<td align="center">
									<input type="hidden" name="botonSel" value="">
									<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb" tabindex="-1" style="visibility:hidden;">
								</td>
    							<td align="center">
									<input type="submit" name="Consultar" class="btnNormal" value="<cfoutput>#LB_Analisi#</cfoutput>" onclick="javascript: this.form.botonSel.value = this.name; if (window.funcConsultar) return funcConsultar();" tabindex="1">
								</td>
			</form>

								<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
									<form name="form2" method="post" action="" style="margin:0;">
										<input name="SNcodigo"  type="hidden" value="<cfoutput>#form.SNcodigo#</cfoutput>">
										<input name="Ocodigo_F"  type="hidden" value="<cfif isdefined("form.Ocodigo_F") and len(trim(form.Ocodigo_F))><cfoutput>#form.Ocodigo_F#</cfoutput><cfelse>-1</cfif>">
										<cfif isdefined('form.CatSoc') and form.CatSoc EQ 1>
											<input name="CatSoc"  type="hidden" value="<cfoutput>#form.CatSoc#</cfoutput>">
										</cfif>
                                        <cfoutput>
										<td align="center">
											<input type="submit" name="Datos" class="btnNormal" value="#LB_Datos#" onclick="javascript: if (window.funcDatos) return funcDatos();" tabindex="1">
										</td>
										<td align="center">
											<input type="submit" name="Imprimir" class="btnNormal" value="#LB_Saldo#" onclick="javascript: if (window.funcImprimir) return funcImprimir();" tabindex="1">
										</td>
										<td align="center">
											<input type="button" name="reporte" class="btnNormal" value="#LB_Antig#" onclick="javascript: if (window.funcreporte) return funcreporte();" tabindex="1">
										</td>
										<td align="center">
											<input type="button" name="historico" class="btnNormal" value="#LB_Hist#" onclick="javascript: if (window.funcHistorico) return funcHistorico();" tabindex="1">
										</td>
                                        </cfoutput>
									</form>
								</cfif>

								<cfif isdefined('form.CatSoc') and form.CatSoc EQ 1>
									<cfset regresa = '../../ad/catalogos/Socios.cfm?SNcodigo=#form.SNcodigo#'>
									<td align="center">
										<input type="button" name="Regresar" class="btnAnterior" value="Regresar" onclick="javascript:location.href='<cfoutput>#regresa#</cfoutput>'" tabindex="1">
									</td>
								</cfif>
  							</tr>
						</table>
				  </td>
				  </tr>
			  </table>
			</form>
			<br/>
			<cfif not (isdefined("session.SocioCxC") and len(trim(session.SocioCxC)))>
				<cf_qforms>
				<script language="javascript" type="text/javascript">
					<!--//
					<cfoutput>
					objForm.SNcodigo.required = true;
					objForm.SNcodigo.description = '#LB_SocioNegocio#';
					</cfoutput>
					//-->
				</script>
			</cfif>
			<cfif isdefined('form.SNcodigo') and form.SNcodigo NEQ ''>
					<cfquery name="rsSocio" datasource="#session.DSN#">
						select SNcodigo, SNnombre
						from SNegocios
						where Ecodigo= #session.Ecodigo#
						  and SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
					</cfquery>
					<!--- Esta sección se muestra solo cuando está definido el socio... --->
					<table width="100%"  border="0" cellspacing="0" cellpadding="2" align="center">
					  <tr><td colspan="2" align="center" class="subTitulo"><cfoutput>#LB_Socio#:#rsLista.SNnumero#-#rsSocio.SNnombre#</cfoutput></td></tr>

			  			<cfif isdefined('form.Ocodigo_F') and form.Ocodigo_F gt -1>
							<cfquery name="rsOficina" datasource="#session.DSN#">
								select Ocodigo, Odescripcion
								from Oficinas
								where Ecodigo= #session.Ecodigo#
								  and Ocodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo_F#">
							</cfquery>
						</cfif>
						<tr><td colspan="2" align="center" class="subTitulo"><cfoutput>#LB_Oficina#: <cfif isdefined("rsOficina")>#rsOficina.Ocodigo#-#rsOficina.Odescripcion#<cfelse>#LB_Todas#</cfif></cfoutput></td></tr>

					  <tr><td colspan="2" align="center" >&nbsp;</td></tr>
					  <tr>
						<td>
							<cfset session.referencia = 'analisisSocio.cfm'>
							<cfinclude template="../MenuCC-barGraph-v2.cfm">
						</td>
						<td>
							<cfif isdefined('rsGraficoBar') and rsGraficoBar.recordCount GT 0>
								<cfinclude template="../MenuCC-pieGraph.cfm">
							<cfelse>
								&nbsp;
							</cfif>
						</td>
					  </tr>
					  <tr>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					  </tr>
					 <!---  <cfflush interval="64"> --->
						  <tr>
							<td colspan="2" class="subTitulo" nowrap="nowrap">
								<cfoutput>#LB_Pendientes#</cfoutput>
								<cfif not (isdefined("session.SocioCxC") and len(trim(session.SocioCxC)))>
									<img border='0' src='/cfmx/sif/imagenes/notas2.gif'  title='Agregar'
									onClick=javascript:funcAgregar() style="cursor:pointer">&nbsp;
								</cfif>
							</td>
						  </tr>

					  <tr>

						<td colspan="2">
								<cfinvoke
									component="sif.Componentes.pListas"
									method="pListaQuery"
									returnvariable="pLista"
									query="#rsContactoSocio#"
									formname="listaDocum"
									funcion="verContactos"
									fparams="CSEid"
									keys="CSEid"
									desplegar="Responsable, CCTcodigo, Ddocumento, Usulogin, CSEFecha, TCid, CSEnombreContacto"
									etiquetas="#LB_Responsable#, #LB_Transaccion#, #LB_Documento#, #LB_UsuAsig#, #LB_Fecha#, #LB_Tipo#, #LB_Contacto#"
									totalgenerales="SaldoLoc"
									formatos="S, S, S, S, D, S, S"
									align="left, left, left, left, left, left, left"
									navegacion="#navegacion#"
									showlink="false"
									maxrows="0"
									pageindex="2"
									ira="analisisSocio.cfm"/>
							</td>

						</tr>
						<tr>
							<td colspan="2">&nbsp;</td>
						</tr>
					  <tr>
						<td colspan="2" class="subTitulo"><cfoutput>#LB_Vencimiento#</cfoutput></td>
					  </tr>
					  <tr>
						<td colspan="2">
							<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
								<cfset navegacion = navegacion & "&SNcodigo=" & form.SNcodigo>
							</cfif>
							<cfif isdefined("form.Ocodigo_F") and len(trim(form.Ocodigo_F))>
								<cfset navegacion = navegacion & "&Ocodigo_F=" & form.Ocodigo_F>
							</cfif>
							<cfif isdefined("form.id_direccion") and len(trim(form.id_direccion))>
								<cfset navegacion = navegacion & "&id_direccion=" & form.id_direccion>
							</cfif>
							<cfinvoke
								component="sif.Componentes.pListas"
								method="pListaQuery"
								returnvariable="pLista"
								query="#rsGraficoBar#"
								formname="listaVencOfi"
								desplegar="direccion, Corriente, SinVencer, P1, P2, P3, P4, P5, Morosidad, Dsaldo"
								etiquetas="#LB_Dir#,  #LB_Corriente#, #LB_SinVenc#, #venc1#, #venc2#, #venc3#, #venc4#, #LB_Masde# #venc4#, Morosidad, #LB_Saldo#"
								formatos="S, M, M, M, M, M, M, M, M, M"
								totales="Corriente,SinVencer,P1,P2,P3,P4,P5,Morosidad,Dsaldo"
								align="left, right, right, right, right, right, right, right, right, right"
								navegacion="#navegacion#"
								maxrows="15"
								keys="id_direccion"
								pageindex="1"
								ira="analisisSocio.cfm"/>
						</td>
					  </tr>
					  <tr>
						<td colspan="2">&nbsp;</td>
					  </tr>

					  <tr>
					  	<td></td>
					  </tr>



					  <cfif isdefined('rsDocumentos') and rsDocumentos.recordCount GT 0 >
						  <tr>
							<td colspan="2" class="subTitulo"><cfoutput>#LB_Documentos#<cfif isdefined("form.id_direccion") and form.id_direccion gt -1> de #rsDocumentos.direccion#</cfif></cfoutput></td>
						  </tr>
						  <tr>
							<td colspan="2">
								<cfinvoke
									component="sif.Componentes.pListas"
									method="pListaQuery"
									returnvariable="pLista"
									query="#rsDocumentos#"
									formname="listaDocum"
									Cortes="Mnombre"
									funcion="verdocumentos"
									fparams="HDid"
									desplegar="Tipo, Documento, Fecha, Vencimiento, Oficina, Monto, Saldo, SaldoLoc"
									etiquetas="#LB_Tipo#, #LB_Documento#, #LB_Fecha#, #LB_Vencimiento#, #LB_Oficina#, #LB_Monto#, #LB_Saldo#, #LB_Local#"
									totalgenerales="SaldoLoc"
									formatos="S, S, D, D, S, M, M,M"
									align="left, left, center, center, center, right, right, right"
									navegacion="#navegacion#"
									showlink="false"
									maxrows="0"
									pageindex="2"
									ira="analisisSocio.cfm"/>
							</td>
						  </tr>
					  </cfif><!--- si está definida la consulta de documentos --->
					</table>
			</cfif><!--- si está definido el socio ??? --->
		<cf_web_portlet_end>
	<cf_templatefooter>
<cfif not (isdefined("session.SocioCxC") and len(trim(session.SocioCxC)))>
	<script>document.form1.SNnumero.focus();</script>
</cfif>
<script language="JavaScript">
	var popUpWin=0;
	var popUpWinSN=0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWinSN) {
			if(!popUpWinSN.closed) popUpWinSN.close();
		}
		popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		window.onfocus = closePopUp;
	}
	function closePopUp(){
		if(popUpWinSN) {
			if(!popUpWinSN.closed) popUpWinSN.close();
			popUpWinSN=null;
		}
	}

	function funcreporte() {
		popUpWindow("/cfmx/sif/cc/reportes/AntSalCliDet-sql.cfm?SNcodigo=<cfoutput><cfif isdefined("form.SNcodigo")>#form.SNcodigo#<cfelse>-1</cfif></cfoutput>",200,75,900,800);
	}
	function funcHistorico() {
		open("/cfmx/sif/cc/consultas/analisisSocioHM.cfm?SNcodigo=<cfoutput><cfif isdefined("form.SNcodigo")>#form.SNcodigo#<cfelse>-1</cfif></cfoutput>",'V1','left=75,top=75,scrollbars=yes,resizable=yes,width=1000,height=900');
	}


	function verdocumentos(HDid){
		var PARAM  = "../../cc/consultas/RFacturasCC2-DetalleDoc.cfm?pop=true&HDid="+ HDid;
		open(PARAM,'V1','left=110,top=150,scrollbars=yes,resizable=yes,width=1000,height=500')
	}
	<cfif isdefined("form.SNcodigo")>
		function verContactos(CSEid){
			var PARAM  = "../../cc/catalogos/Contacto.cfm?pop=true&SNcodigo=<cfoutput>#form.SNcodigo#</cfoutput>&CSEid="+ CSEid;
			open(PARAM,'V1','left=100,top=150,scrollbars=yes,resizable=no,width=1000,height=350')
		}
	</cfif>
</script>