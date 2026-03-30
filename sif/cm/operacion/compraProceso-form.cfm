<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<!---Tipo de Proceso de compra--->
<cfquery name="TipoProceso" datasource="#Session.DSN#">
	select CMTPid, CMTPCodigo,CMTPMontoIni,CMTPMontoFin,Mcodigo,CMTPDescripcion,TGidP, TGidC 
	from CMTipoProceso
	where Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="rsGarantiaP" datasource="#session.dsn#">
	select TGid,TGcodigo,TGporcentaje,
		TGdescripcion
	from TiposGarantia
	where TGtipo = 1 and Ecodigo = #session.Ecodigo#
</cfquery>

<cfquery name="rsGarantiaC" datasource="#session.dsn#">
	select TGid,TGcodigo,TGporcentaje,
		TGdescripcion
	from TiposGarantia
	where TGtipo = 2 and Ecodigo = #session.Ecodigo#
</cfquery>


<cfquery name="rsCriterios" datasource="#Session.DSN#">
	select CCid, CCdesc
	from CCriteriosCM
	order by CCid
</cfquery>

<cfquery name="rsGruposCriteriosTodo" datasource="#Session.DSN#">
	select a.GCcritid, a.GCcritdesc, b.CCid, b.CGpeso
	from GruposCriteriosCM a, CriteriosGrupoCM b
	where a.Ecodigo =  #Session.Ecodigo# 
	and a.GCcritid = b.GCcritid
</cfquery>

<cfquery name="rsGruposCriterios" dbtype="query">
	select distinct GCcritid, GCcritdesc
	from rsGruposCriteriosTodo
</cfquery>
<cfif isdefined("Session.Compras.ProcesoCompra.DSlinea") and LEN(TRIM(Session.Compras.ProcesoCompra.DSlinea))>
	<cfset iCount = 1>
	<cfquery name="rsDetalleProcesoCompra" datasource="#Session.DSN#">
		select a.ESidsolicitud, b.CMTSdescripcion, a.ESnumero, a.ESobservacion, a.ESfecha, c.CFcodigo, c.CFdescripcion, d.CMSnombre, 
			   e.DSlinea, 
			    '<label style="font-weight:normal" title="'#_Cat# e.DSdescripcion #_Cat#'">' #_Cat# <cf_dbfunction name='sPart' args='e.DSdescripcion|1|50' delimiters='|'> #_Cat# case when <cf_dbfunction name="length"	args="e.DSdescripcion"> > 50 then '...' else '' end as DSdescripcion,
			   e.DScant, e.DStotallinest, f.Udescripcion, e.DSdescalterna, e.DSobservacion,
			   g.CFcodigo as CFcodigoDet, g.CFdescripcion as CFdescripcionDet,
			   case e.DStipo when 'A' then (select min(Acodigo) from Articulos x where x.Ecodigo = e.Ecodigo and x.Aid = e.Aid) 
							 when 'S' then (select min(Ccodigo) from Conceptos x where x.Ecodigo = e.Ecodigo and x.Cid = e.Cid) 
							 else ''
			   end as CodigoItem,
			   e.DScant - e.DScantsurt as CantDisponible,
			   a.Mcodigo,
			   a.EStipocambio,
               a.CMSid
		from ESolicitudCompraCM a

			 inner join CMTiposSolicitud b
				on a.Ecodigo = b.Ecodigo
				and a.CMTScodigo = b.CMTScodigo
			 
			 inner join CFuncional c
				on a.Ecodigo = c.Ecodigo
				and a.CFid = c.CFid
			 
			 inner join CMSolicitantes d
				on a.Ecodigo = d.Ecodigo
				and a.CMSid = d.CMSid
			 
			 inner join DSolicitudCompraCM e
				on a.Ecodigo = e.Ecodigo
				and a.ESidsolicitud = e.ESidsolicitud
				and e.DSlinea in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.DSlinea#" list="yes" separator=",">)
			 
			 inner join Unidades f
				on e.Ecodigo = f.Ecodigo
				and e.Ucodigo = f.Ucodigo

			left outer join CFuncional g
				on e.CFid = g.CFid
			 
		where a.Ecodigo =  #lvarFiltroEcodigo#
	</cfquery>
	<cfset LvarMonedaConsulta = #rsDetalleProcesoCompra.Mcodigo#>

	<cfquery name="rsSQL" datasource="#session.dsn#">  <!------Moneda Local------->
		Select Mcodigo 
		  from Empresas
		 where Ecodigo	= #session.Ecodigo#
    </cfquery>
	
	<cfquery name="rsSimbolo" datasource="#session.dsn#">   <!-----Simbolo de la Moneda------->
		Select Msimbolo, Miso4217 
		  from Monedas
		 where Ecodigo	= #session.Ecodigo# 
		  and  Mcodigo =  #rsSQL.Mcodigo#
    </cfquery>
	
	<cfset LvarSimbolo = #rsSimbolo.Msimbolo#>
	<cfset LvarMnombre = #rsSimbolo.Miso4217#>
	
	<cfset LvarMonedaEmpresa = #rsSQL.Mcodigo#>                     <!---Moneda de la empresa ---->
	   
	<cfset LvarMonedaDocumento = #rsDetalleProcesoCompra.Mcodigo#>  <!---Moneda del documento ---->
	
    <cfset LvarTipoCambio = #rsDetalleProcesoCompra.EStipocambio#>  <!--- Tipo Cambio del Doc ---->
   
    <cfset LvarTipoCambioCompra = 1>    
	<cfquery name="rsSolicitudes" dbtype="query">
		select distinct ESidsolicitud, CMTSdescripcion, ESnumero, ESobservacion, ESfecha, CFcodigo, CFdescripcion, CMSnombre
		from rsDetalleProcesoCompra
		order by ESnumero
	</cfquery>
    <cfset LvarTotalDocumento=  0>
	<cfloop query="rsSolicitudes">
			<cfquery name="rsMontoDet" dbtype="query">
						select DSlinea,  DStotallinest
						from rsDetalleProcesoCompra
						where ESidsolicitud = #rsSolicitudes.ESidsolicitud#
						order by DSlinea
			</cfquery>
			   <cfloop query="rsMontoDet"> 
     				<cfset LvarTotalDocumento=  LvarTotalDocumento + #rsMontoDet.DStotallinest#>	 
	    	   </cfloop>
	</cfloop>
	<cfset LvarTotalDocumento= LvarTotalDocumento *  LvarTipoCambio> 
	
</cfif>

<cfif modo EQ "CAMBIO">
	<cfquery name="rsProcesoCompra" datasource="#Session.DSN#">
		select 
			CMPid, 
			CMPdescripcion, 
			GCcritid, 
			Usucodigo, 
			fechaalta, 
			CMPfechapublica, 
			CMPfmaxofertas, 
			CMPestado, 
			CMPnumero,
			CMFPid,
			CMIid,
			CMTPid,
			TGidP,
			TGidC,
			ts_rversion,
			CMPcodigoProceso
		from CMProcesoCompra
		where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#">
		and Ecodigo =  #Session.Ecodigo# 
	</cfquery>
	<cfquery name="rsCondicionesProceso" datasource="#Session.DSN#">
		select CCid, CPpeso
		from CMCondicionesProceso
		where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#">
	</cfquery>
	<cfset condicionId = ValueList(rsCondicionesProceso.CCid, ',')>
	<cfset condicionPeso = ValueList(rsCondicionesProceso.CPpeso, ',')>
    
	<cfquery name="rsTotReNotas" datasource="#Session.DSN#">
	  select count(CMPid) as LvarTotReg from CMNotas where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#">
	</cfquery>
</cfif>

<cfquery name="rsCMFormasPago" datasource="#session.dsn#">
	select CMFPid, CMFPcodigo, CMFPdescripcion, CMFPplazo
	from CMFormasPago
	where Ecodigo =  #session.Ecodigo# 
	order by CMFPcodigo
</cfquery>

<cfquery name="rsCMIncoterm" datasource="#session.dsn#">
	select CMIid, CMIcodigo, CMIdescripcion, CMIpeso
	from CMIncoterm
	where Ecodigo =  #session.Ecodigo# 
	order by CMIcodigo
</cfquery>

<cfoutput>
	<script src="/cfmx/sif/js/utilesMonto.js"></script>
	<script src="/cfmx/sif/js/qForms/qforms.js"></script>
	<script language="javascript" type="text/javascript">

		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");

		var criterio = new Object();
		
		<cfloop query="rsGruposCriterios">
		criterio["#rsGruposCriterios.GCcritid#"] = new Object();
		</cfloop>
		
		<cfloop query="rsGruposCriteriosTodo">
		criterio["#rsGruposCriteriosTodo.GCcritid#"]["#rsGruposCriteriosTodo.CCid#"] = "#LSNumberFormat(rsGruposCriteriosTodo.CGpeso,',9.00')#";
		</cfloop>
		
		function limpiarCriterios() {
		<cfloop query="rsCriterios">
			document.getElementById("CCid_#rsCriterios.CCid#").value = "0.00";
		</cfloop>
		}
		
		function cambioCriterio(ctl) {
			limpiarCriterios();
			var val = ctl.value;
			if (criterio[val]) {
				for (var i in criterio[val]) {
					var elem = document.getElementById("CCid_"+i);
					if (elem) elem.value = criterio[val][i];
				}
			}
		}
		
		function funcNotas(f) {
			f.opt.value = "2";
		}
	</script>

	<form name="form1" method="post" action="<cfoutput>#GetFileFromPath(GetTemplatePath())#</cfoutput>" onSubmit="javasript: validar(this);"> 
		<input type="hidden" name="opt" value="">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td nowrap valign="top">
				<table width="100%"  border="0" cellspacing="0" cellpadding="2">
				  <tr>
					<td class="fileLabel" align="right">N&uacute;mero:</td>  
					<td colspan="2">
						<input type="text" name="CMPnumero" id="CMPnumero" value="<cfif modo EQ 'CAMBIO'>#rsProcesoCompra.CMPnumero#</cfif>" style="border:0px;" readonly>
						<input type="hidden" name="CMPestado" id="CMPestado" value="<cfif modo EQ 'CAMBIO'>#rsProcesoCompra.CMPestado#</cfif>" style="border:0px;" readonly>
					</td>
				  </tr>
				<!---Tipo de Proceso de compra: Si el Catalogo esta vacio no lo pinta.--->
				<cfif TipoProceso.recordcount GT 0>
					  <tr>
				<!---	<cfdump var="#rsProcesoCompra#" >--->
					<cfif modo eq 'CAMBIO' and len(trim(rsProcesoCompra.CMTPid))>
					   <cfset LvarRegTipProc = #rsProcesoCompra.CMTPid#>
					<cfelse>
					  <cfset LvarRegTipProc = 0 >  
					 </cfif>					  
						<td class="fileLabel" align="right">Tipo Proceso:</td>
						<td colspan="2">
							<select name="CMTPid" <cfif LvarRegTipProc neq 0 and LvarRegTipProc neq '' > disabled </cfif> ><!----Si ya fue creada y tiene actividades asociadas no se permite cambiar---->
							  <option value="-1">--Ninguno--</option>
							      <cfset LvarMontoInicial = 0>
								  <cfset LvarMontoFinal   = 0>
							  <cfloop query="TipoProceso">
									  <cfif modo eq "ALTA">
											  <cfif LvarMonedaEmpresa neq TipoProceso.Mcodigo>
													<cfquery name="rsTC" datasource="#Session.DSN#">
														select tc.TCcompra
														  from Htipocambio tc
														 where tc.Mcodigo = #TipoProceso.Mcodigo#
														   and tc.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
														   and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
														   and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
													</cfquery>	
												</cfif>															
										<option value="#TipoProceso.CMTPid#" <cfif modo EQ 'CAMBIO' and rsProcesoCompra.CMTPid EQ TipoProceso.CMTPid> selected <cfelseif modo EQ 'ALTA' and TipoProceso.CMTPMontoIni  lte LvarTotalDocumento and TipoProceso.CMTPMontoFin gte LvarTotalDocumento> selected </cfif>>#TipoProceso.CMTPCodigo#-#TipoProceso.CMTPDescripcion#</option>		
									 <cfelse> 					  
								   		<option value="#TipoProceso.CMTPid#" <cfif modo EQ 'CAMBIO' and rsProcesoCompra.CMTPid EQ TipoProceso.CMTPid > selected <cfelseif modo EQ 'CAMBIO' and TipoProceso.CMTPMontoIni  lte LvarTotalDocumento and TipoProceso.CMTPMontoFin gte LvarTotalDocumento> selected </cfif>>#TipoProceso.CMTPCodigo#-#TipoProceso.CMTPDescripcion#</option>
							 		</cfif>	
                              </cfloop>
							</select>
						</td>
					  </tr>
				</cfif>
				  <tr>
					<td class="fileLabel" align="right">Descripci&oacute;n:</td>
					<td colspan="2">
						<input type="text" name="CMPdescripcion" size="40" maxlength="100" value="<cfif modo EQ 'CAMBIO'>#rsProcesoCompra.CMPdescripcion#</cfif>">
					</td>
				  </tr>
				  	  <tr>
				    <td class="fileLabel" align="right">Código de Proceso:</td>
				    <td colspan="2">
							<input type="text" name="CMPcodigoProceso" size="40" maxlength="100" value="<cfif modo EQ 'CAMBIO'>#rsProcesoCompra.CMPcodigoProceso#</cfif>">
	    			</td>
			      </tr>
				  <tr>
				    <td class="fileLabel" align="right">Fecha de Publicaci&oacute;n:</td>
				    <td colspan="2">
						<cfif modo EQ "CAMBIO">
							<cfset fechapub = LSDateFormat(rsProcesoCompra.CMPfechapublica, 'dd/mm/yyyy')>
						<cfelse>
							<cfset fechapub = LSDateFormat(Now(),'dd/mm/yyyy')>
						</cfif>
						<cf_sifcalendario form="form1" name="CMPfechapublica" value="#fechapub#">
					</td>
			      </tr>
				  <tr>
				    <td class="fileLabel" align="right">Fecha M&aacute;xima para Cotizaci&oacute;n:</td>
				    <td>
						<cfif modo EQ "CAMBIO">
							<cfset fechacot = LSDateFormat(rsProcesoCompra.CMPfmaxofertas, 'dd/mm/yyyy')>
						<cfelse>
							<cfset fechacot = "">
						</cfif>
						<cf_sifcalendario form="form1" name="CMPfmaxofertas" value="#fechacot#">
					</td>
			        <td nowrap>
						<cfif modo EQ "CAMBIO">
							<cfif Hour(rsProcesoCompra.CMPfmaxofertas) GT 12>
								<cfset hora = Hour(rsProcesoCompra.CMPfmaxofertas) mod 12>
								<cfset ampm = "PM">
							<cfelseif Hour(rsProcesoCompra.CMPfmaxofertas) EQ 12>
								<cfset hora = 12>
								<cfset ampm = "PM">
							<cfelseif Hour(rsProcesoCompra.CMPfmaxofertas) EQ 0>
								<cfset hora = 12>
								<cfset ampm = "AM">
							<cfelse>
								<cfset hora = Hour(rsProcesoCompra.CMPfmaxofertas)>
								<cfset ampm = "AM">
							</cfif>
							<cfset minutos = Minute(rsProcesoCompra.CMPfmaxofertas)>
						<cfelse>
							<cfset hoy = Now()>
							<cfif Hour(hoy) GT 12>
								<cfset hora = Hour(hoy) mod 12>
								<cfset ampm = "PM">
							<cfelseif Hour(hoy) EQ 12>
								<cfset hora = 12>
								<cfset ampm = "PM">
							<cfelseif Hour(hoy) EQ 0>
								<cfset hora = 12>
								<cfset ampm = "AM">
							<cfelse>
								<cfset hora = Hour(hoy)>
								<cfset ampm = "AM">
							</cfif>
							<cfset minutos = Minute(hoy)>
						</cfif>
						<select name="hcotizacion">
						<cfloop from="1" to="12" index="i">
							<option value="#i#"<cfif i EQ hora> selected</cfif>>#Right('0'&i,2)#</option>
						</cfloop>
						</select>
						:
						<select name="mcotizacion">
						<cfloop from="0" to="59" index="i">
							<option value="#i#"<cfif i EQ minutos> selected</cfif>>#Right('0'&i,2)#</option>
						</cfloop>
						</select>
						<select name="ampm">
							<option value="AM"<cfif ampm EQ 'AM'> selected</cfif>>AM</option>
							<option value="PM"<cfif ampm EQ 'PM'> selected</cfif>>PM</option>
						</select>
					</td>
				  </tr>
				  <tr>
				  	<td class="fileLabel" align="right">Forma de pago:</td>
					<td colspan="2">
						<select name="CMFPid">
                        	<option value="" selected>Definida por Proveedor</option>
							<cfloop query="rsCMFormasPago">
								<option value="#CMFPid#" <cfif modo EQ 'CAMBIO' and CMFPid eq rsProcesoCompra.CMFPid>selected</cfif>>#CMFPdescripcion#</option>
							</cfloop>
						</select>
					</td>
				  </tr>
				  <tr>
				  	<td class="fileLabel" align="right">Incoterm:</td>
					<td colspan="2">
						<select name="CMIid">
							<option value="-1">--Ninguno--</option>
							<cfloop query="rsCMIncoterm">
								<option value="#CMIid#" <cfif modo EQ 'CAMBIO' and CMIid eq rsProcesoCompra.CMIid>selected</cfif>>#CMIcodigo# - #CMIdescripcion#</option>
							</cfloop>
						</select>
					</td>
				  </tr>
				<tr>
					<td nowrap align="right">Garantía - Cumplimiento:</td>                        
					<td align="left">
						<select name="TipoC" tabindex="1" id="TipoC">
						<option value="">-Seleccione-</option>
							<cfloop query="rsGarantiaC">
							<option value="#rsGarantiaC.TGid#" <cfif modo neq 'ALTA' and  rsGarantiaC.TGid eq rsProcesoCompra.TGidC> selected </cfif>>#rsGarantiaC.TGdescripcion# - #rsGarantiaC.TGporcentaje#</option>
							</cfloop>
						 </select>
					</td>
				</tr>
				<tr>
					<td nowrap align="right">Garantía - Participación:</td>                        
					<td align="left">
						<select name="TipoP" tabindex="1" id="TipoP">
							<option value="">-Seleccione-</option>
							<cfloop query="rsGarantiaP">
							<option value="#rsGarantiaP.TGid#"<cfif modo neq 'ALTA' and  rsGarantiaP.TGid eq rsProcesoCompra.TGidP> selected </cfif>>#rsGarantiaP.TGdescripcion# - #rsGarantiaP.TGporcentaje#</option>
							</cfloop>
						 </select>
					</td>
				</tr>
				</table>
			</td>
			<td valign="top">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td class="fileLabel" align="right" nowrap>Grupo de Criterios:</td>
				    <td nowrap>
						<select name="GCcritid" onChange="javascript: cambioCriterio(this);">
							<option value="0">-- Ninguno --</option>
						<cfloop query="rsGruposCriterios">
							<option value="#rsGruposCriterios.GCcritid#"<cfif modo EQ 'CAMBIO' and rsProcesoCompra.GCcritid EQ rsGruposCriterios.GCcritid> selected</cfif>>#rsGruposCriterios.GCcritdesc#</option>
						</cfloop>
						</select>
					</td>
				  </tr>
				  <tr>
					<td colspan="2" nowrap>
						<fieldset>
							<legend><strong>Seleccione el peso para cada criterio</strong></legend>
							<table width="100%"  border="0" cellspacing="0" cellpadding="2">
							  <cfloop query="rsCriterios">
							  <tr>
								<td nowrap>#rsCriterios.CCdesc#</td>
								<td nowrap>
									<cfif modo EQ "CAMBIO">
										<cfset pos = ListFind(condicionId, rsCriterios.CCid, ',')>
										<cfif pos NEQ 0>
											<cfset valorcriterio = LSNumberFormat(ListGetAt(condicionPeso, pos, ','), ',9.00')>
										<cfelse>
											<cfset valorcriterio = "0.00">
										</cfif>
									<cfelse>
										<cfset valorcriterio = "0.00">
									</cfif>
									<input type="text" name="CCid_#rsCriterios.CCid#" id="CCid_#rsCriterios.CCid#" size="10" maxlength="10" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="#valorcriterio#">
								</td>
							  </tr>
							  </cfloop>
							</table>
						</fieldset>
					</td>
				  </tr>
				</table>			
			</td>
		  </tr>
		  <tr>
			<td nowrap="nowrap" >&nbsp;</td>
			<td nowrap="nowrap"><strong>Monto del Documento: <cfdump var="#LvarSimbolo# #LsNumberFormat(LvarTotalDocumento,"9,9.99")# #LvarMnombre#"></strong></td>
		  </tr>
		  <tr>
		      <td>&nbsp;</td>
		  </tr>
		  <tr align="center">
			<td colspan="2" nowrap>
				<cfif modo EQ "CAMBIO">
				<input type="submit" name="btnNotas" class="btnNormal" id="btnNotas" value="Notas" onClick="javascript: funcNotas(this.form);"> 
				</cfif>
				<input type="submit" name="btnGuardar" class="btnGuardar" value="Guardar y Continuar >>" onClick="javascript: funcSiguiente(); ">
			</td>
		  </tr>
		  <tr>
			<td nowrap>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>
	  </table>		  

	<cfif isdefined("Session.Compras.ProcesoCompra.DSlinea") and LEN(TRIM(Session.Compras.ProcesoCompra.DSlinea))>
		<table width="98%"  border="0" cellspacing="0" cellpadding="2" align="center">
		  <tr>
		    <td class="tituloListas" colspan="5">Lista de Itemes de Compra</td>
	      </tr>
		  <tr>
			<td nowrap class="tituloListas" style="padding-right: 5px;">Tipo de Solicitud</td>
			<td align="right" nowrap class="tituloListas" style="padding-right: 5px;">No. Solicitud</td>
			<td align="center" nowrap class="tituloListas" style="padding-right: 5px;">Fecha</td>
			<td nowrap class="tituloListas" style="padding-right: 5px;">Centro Funcional</td>
			<td nowrap class="tituloListas">Solicitante</td>
		  </tr>
		  <cfloop query="rsSolicitudes">
			  <cfset solicitud = rsSolicitudes.ESidsolicitud>
			  <tr class=<cfif (iCount MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
				<td nowrap style="border-top: 1px solid black; padding-right: 5px;">#rsSolicitudes.CMTSdescripcion#</td>
				<td align="right" nowrap  style="border-top: 1px solid black; padding-right: 5px;">#rsSolicitudes.ESnumero#</td>
				<td align="center" nowrap style="border-top: 1px solid black; padding-right: 5px;">#LSDateFormat(rsSolicitudes.ESfecha, 'dd/mm/yyyy')#</td>
				<td nowrap style="border-top: 1px solid black; padding-right: 5px;">#rsSolicitudes.CFcodigo# - #rsSolicitudes.CFdescripcion#</td>
				<td style="border-top: 1px solid black;">#rsSolicitudes.CMSnombre#</td>
			  </tr>
			  <tr class=<cfif (iCount MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
			    <td colspan="5">#rsSolicitudes.ESobservacion#</td>
		      </tr>
			  <cfset iCount = iCount + 1>
			  <cfquery name="rsSolicitudesDetalle" dbtype="query">
				select distinct DSlinea, CodigoItem,
				 DSdescripcion,				
				 DScant,CantDisponible, DStotallinest,Udescripcion, DSobservacion, DSdescalterna, ESidsolicitud, CFcodigoDet, CFdescripcionDet, ESnumero, CMSid
				from rsDetalleProcesoCompra
				where ESidsolicitud = #rsSolicitudes.ESidsolicitud#
		
				order by DSlinea
			  </cfquery>
			  <tr>
				<td colspan="6" nowrap>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td style="padding-right: 5px;" class="tituloListas" width="1%" nowrap>&nbsp;</td>
						<td style="padding-right: 5px;" class="tituloListas" width="47%" nowrap>Item</td>
						<td style="padding-right: 5px;" width="5%" align="right" nowrap class="tituloListas">Cantidad</td>
						<td style="padding-right: 5px;" class="tituloListas" width="20%" >Unidad</td>
						<td style="padding-right: 5px;" class="tituloListas" width="20%" >Monto</td>
						<td style="padding-right: 5px;" class="tituloListas" width="50%" nowrap>Ctro.Funcional</td>
						<td class="tituloListas" width="50%" nowrap>&nbsp;Observaciones</td>
						<cfif isdefined("Session.Compras.ProcesoCompra.CMPid") and Len(Trim(Session.Compras.ProcesoCompra.CMPid))>
						<td class="tituloListas" width="50%" nowrap>&nbsp;</td>
						</cfif>
					  </tr>
					<cfloop query="rsSolicitudesDetalle">
					  <tr class=<cfif (iCount MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
						<td style="padding-right: 5px;" nowrap>-</td>
						<td style="padding-right: 5px;" nowrap>#rsSolicitudesDetalle.CodigoItem# - #rsSolicitudesDetalle.DSdescripcion#</td>
						<td style="padding-right: 5px;" align="right" nowrap>#rsSolicitudesDetalle.CantDisponible#</td>
						<td style="padding-right: 5px;">#rsSolicitudesDetalle.Udescripcion#</td>
						<td style="padding-right: 5px;">#NumberFormat(rsSolicitudesDetalle.DStotallinest,'9,9.99')#</td>
						<td style="padding-right: 5px;">
							<cfif Len(Trim(rsSolicitudesDetalle.CFcodigoDet))>
								#rsSolicitudesDetalle.CFcodigoDet# - #rsSolicitudesDetalle.CFdescripcionDet#
							<cfelse>
								---
							</cfif>
						</td>
						<td nowrap align="center">
							<input name="DSlinea" type="hidden" value="#rsSolicitudesDetalle.DSlinea#">
							<input name="DSdescalterna#rsSolicitudesDetalle.DSlinea#" type="hidden" value="#trim(rsSolicitudesDetalle.DSdescalterna)#">
							<input name="DSobservacion#rsSolicitudesDetalle.DSlinea#" type="hidden" value="#trim(rsSolicitudesDetalle.DSobservacion)#">							
							<a href="javascript:info(#rsSolicitudesDetalle.DSlinea#);"><img border="0" src="../../imagenes/iedit.gif" alt="informac&oacute;n adicional (Descripci&oacute;n alterna, Observaciones)"></a>																	
						</td>
						<cfif isdefined("Session.Compras.ProcesoCompra.CMPid") and Len(Trim(Session.Compras.ProcesoCompra.CMPid))>
						<td nowrap align="center">
							<input name="AlmObjecto" value="Almacenar Objetos" onClick="javascript:AlmacenarObjetos('#rsSolicitudesDetalle.DSlinea#');" type="image" src="../../imagenes/ftv2folderopen.gif">&nbsp;<a href='##' onclick='javascript:return fnImprimir(#rsSolicitudesDetalle.ESidsolicitud#,"#rsSolicitudesDetalle.ESnumero#", #rsSolicitudesDetalle.CMSid#);'><img border='0' src='/cfmx/sif/imagenes/impresora2.gif'>
						</td>
						</cfif>
					  </tr>
					  <cfset iCount = iCount + 1>					                							    
    				</cfloop>										
				  </table>
				</td>
			  </tr>
		  </cfloop>		
		  <tr>
		  	<td colspan="5">&nbsp;</td>
		  </tr>
		  <cfif rsSolicitudesDetalle.RecordCount GT 10 >
		    <tr align="center">
			<td colspan="5" nowrap>
				<cfif modo EQ "CAMBIO">
				<input type="submit" name="btnNotas" class="btnNormal"  id="btnNotas" value="Notas" onClick="javascript: funcNotas(this.form);"> 
				</cfif>
				<input type="submit" name="btnGuardar" class="btnGuardar"  value="Guardar y Continuar >>" onClick="javascript: funcSiguiente(); ">
			</td>
		  </tr>
		   <tr>
		  	<td colspan="5">&nbsp;</td>
		  </tr>
		  </cfif>
	  </table>
	</cfif>	
	</form>
</cfoutput>

<script language="javascript" type="text/javascript">
	// Funcion para ejecutar componente de observaciones 
	function info(index){
		//popUpWindow("Solicitudes-info.cfm" ,250,200,600,400);		
		//open('Solicitudes-info.cfm?index='+index, 'solicitudes', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height=420,left=250, top=200,screenX=250,screenY=200');
		open('solicitudes-info.cfm?index='+index, 'solicitudes', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height=420,left=250, top=200,screenX=250,screenY=200');
	}
	/// Funcion para llamar pantalla de Adjuntar dctos
	function AlmacenarObjetos(valor){			
		if (valor != "") {				
			var PARAM  = "ObjetosSolicitudes.cfm?Modulo=SC&DSlinea1="+valor;
			open(PARAM,'','left=50,top=150,scrollbars=yes,resizable=no,width=1000,height=400');	
		}
		return false;
	}
	function fnImprimir(ESidsolicitud,ESnumero,CMSid){
			if (ESidsolicitud != ""){			
				var PARAM  = "solicitudesReimprimir-sql.cfm?PC=true&ESidsolicitud="+ESidsolicitud+"&ESnumero="+ESnumero+"&CMSid="+CMSid;
				open(PARAM,'','left=50,top=150,scrollbars=yes,resizable=no,width=1000,height=400');	
			}
			return false;
		}
	<cfoutput>
		function validar(f) {
			<cfloop query="rsCriterios">
				f.obj.CCid_#rsCriterios.CCid#.value = qf(f.obj.CCid_#rsCriterios.CCid#.value);
			</cfloop>
		}
	
		function __SumaCriterios() {
			var f = this.obj.form;
			var total = 0.00;
			if (this.required) {
				<cfloop query="rsCriterios">
					total = total + parseFloat(qf(f.CCid_#rsCriterios.CCid#.value));
				</cfloop>
				if (total != 100.00) {
					this.error = "La suma de los pesos de todos los criterios debe ser 100";
				}
			}
		}
	</cfoutput>

	
	//Valida que una fecha no sea menor que la fecha actual
	function __isActualDate() {
		if (this.required && !objForm.allowsubmitonerror && this.obj.form.CMPestado.value == 0 ) {
			var a = this.value.split("/");
			var fecha = new Date(parseInt(a[2], 10), parseInt(a[1], 10)-1, parseInt(a[0], 10), 23, 59, 59);
			var now = new Date( );
			//var dif = ((now-fecha)/86400000.0);	// diferencia en días
			if (now>fecha) {
				this.error = "El campo " + this.description + " debe ser Mayor o Igual que la fecha de hoy.";
			}
		}		
	}

	// Valida el rango entre la fecha de inicio y la fecha de fin de la accion y valida que la fecha fin sea mayor a la inicial
	function __isFechas() {
		if (this.required && this.obj.form.CMPestado.value == 0) {
			var a = this.obj.form.CMPfechapublica.value.split("/");
			var ini = new Date(parseInt(a[2], 10), parseInt(a[1], 10)-1, parseInt(a[0], 10));
			var b = this.obj.form.CMPfmaxofertas.value.split("/");
			var fin = new Date(parseInt(b[2], 10), parseInt(b[1], 10)-1, parseInt(b[0], 10));
			var dif = ((fin-ini)/86400000.0);	// diferencia en días
			if (new Number(dif) < 0) {
				this.error = "El campo " + objForm.CMPfmaxofertas.description + " debe ser Mayor o Igual que el campo " + objForm.CMPfechapublica.description;
			}
		}
	}
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	_addValidator("isFechas", __isFechas);
	_addValidator("SumaCriterios", __SumaCriterios);
	_addValidator("isActualDate", __isActualDate);

	objForm.CMPdescripcion.required = true;
	objForm.CMPdescripcion.description = "Descripción";
	objForm.CMPfechapublica.required = true;
	objForm.CMPfechapublica.description = "Fecha de Publicación";
	<cfif modo EQ 'ALTA'>
		objForm.CMPfechapublica.validateActualDate();
	</cfif>
	objForm.CMPfmaxofertas.required = true;
	objForm.CMPfmaxofertas.description = "Fecha Máxima para Cotización";
	objForm.CMPfmaxofertas.validateFechas();
	<cfif modo EQ 'ALTA'>
		objForm.CMPfmaxofertas.validateActualDate();
	</cfif>
	
	objForm.GCcritid.required = true;
	objForm.GCcritid.description = "Criterios del Proceso de Compra";
	objForm.GCcritid.validateSumaCriterios();
	
</script>
