<cfif not isdefined('dato')>
    <cf_navegacion name="tipo" 			default="D">	
    <cf_navegacion name="Fecha" 		default="">
	<cf_navegacion name="FechaFin" 		default="">		
    <cf_navegacion name="Transaccion" 	default="">	
    <cf_navegacion name="Documento" 	default="">	
    <cf_navegacion name="Usuario" 		default="">	
    <cf_navegacion name="Registros" 	default="20">	
    <cf_navegacion name="Moneda" 		default="-1">	
	<cf_navegacion name="Ocodigo" 		default="-1">
    <cf_navegacion name="pageNum_lista" default="1">	
    <cf_navegacion name="LvarTipoMov" 	default="D">	  
    <cf_navegacion name="titulo" 		default="Lista de Documentos de Remisi&oacute;n">	
    <cf_navegacion name="Botones" 		default="Aplicar,Nuevo,Importar_Facturas,Importar_Transito,Reporte,Cancelar_Remisión,Aplicar_Devolución">	
    <cf_navegacion name="FiltroExtra" 	default="">	
    
    
    <cfset campos_extra = ", '#LvarTipoMov#' as tipo , '#form.Registros#' as Registros, '#form.pageNum_lista#' as pageNum_lista" >
    <cfif len(trim(Form.Fecha))> 		<cfset campos_extra = campos_extra & ", '#form.Fecha#' as fecha" ></cfif>
    <cfif len(trim(Form.FechaFin))> 		<cfset campos_extra = campos_extra & ", '#form.FechaFin#' as fecha" ></cfif>
	<cfif len(trim(Form.Transaccion))>	<cfset campos_extra = campos_extra & ", '#Form.Transaccion#' as transaccion" ></cfif>
    <cfif len(trim(Form.Documento))>	<cfset campos_extra = campos_extra & ", '#form.Documento#' as documento" ></cfif>
    <cfif len(trim(Form.Usuario))>		<cfset campos_extra = campos_extra & ", '#form.usuario#' as usuario" ></cfif>
    <cfif len(trim(Form.Moneda)) and Form.Moneda gte 0><cfset campos_extra = campos_extra & ", '#form.moneda#' as moneda" ></cfif>
    <cfif len(trim(Form.Ocodigo)) and Form.Ocodigo gte 0><cfset campos_extra = campos_extra & ", '#form.Ocodigo#' as Ocodigo" ></cfif>
    
    <cfset filtro = "a.Ecodigo = #Session.Ecodigo#"> 
    <cfset Fecha       = "Todos">
	<cfset FechaFin       = "Todos">
    <cfset Transaccion = "Todos">
    <cfset Documento   = "">
    <cfset Usuario     = "Todos">
    <cfset Moneda      = "Todos">
	<cfset Oficinacodigo      = "Todos">
    <cfset Registros   = 20>
    <cfset Navegacion  = Navegacion & "Tipo="&LvarTipoMov>
    <cfset params 	   = 'tipo='&LvarTipoMov>
    
    <cf_dbfunction name="to_sdateDMY"	args="a.EDfecha" returnvariable="EDfecha">
    <cfif isDefined("Form.Fecha") and Trim(Form.Fecha) NEQ "" and Trim(Form.Fecha) NEQ "Todos">
        <cfset filtro = filtro & " and #EDfecha# = '" & Trim(Form.Fecha) & "'" >
        <cfset Fecha = Trim(Form.Fecha)>
		<cfif isDefined("Form.FechaFin") and Trim(Form.FechaFin) NEQ "" and Trim(Form.FechaFin) NEQ "Todos">
			<cfset filtro = "a.Ecodigo = #Session.Ecodigo#">
			<cfset filtro = filtro & " and a.EDfecha between convert(datetime, '" & Trim(Form.Fecha) & "', 103)" 
			    & " and convert(datetime, '" & Trim(Form.FechaFin) & "', 103) + 1">
			<cfset FechaFin = Trim(Form.FechaFin)>
		</cfif>
    </cfif>
    <cfif isDefined("Form.Transaccion") and Trim(Form.Transaccion) NEQ "" and Trim(Form.Transaccion) NEQ "Todos">
        <cfset filtro = filtro & " and a.CPTcodigo = '" & Trim(Form.Transaccion) & "'" >
        <cfset Transaccion = Trim(Form.Transaccion)>
    </cfif>
    <cfif isDefined("Form.Documento") and Trim(Form.Documento) NEQ "">
        <cfset filtro = filtro & " and upper(a.EDdocumento) like '%" & Ucase(Trim(Form.Documento)) & "%'" >
        <cfset Documento = Trim(Form.Documento)>
    </cfif>
    <cfif isDefined("Form.Usuario") and Trim(Form.Usuario) NEQ "" and Trim(Form.Usuario) NEQ "Todos">
        <cfset filtro = filtro & " and a.EDusuario = '" & Trim(Form.Usuario) & "'" >
        <cfset Usuario = Trim(Form.Usuario)>
    </cfif>
    <cfif isDefined("Form.Moneda") and Trim(Form.Moneda) NEQ "-1" and trim(Form.Moneda) NEQ "" and Trim(Form.Moneda) NEQ "Todos">
        <cfset filtro = filtro & " and a.Mcodigo = " & Trim(Form.Moneda) >
        <cfset Moneda = Trim(Form.Moneda)>
    </cfif>
	<cfif isDefined("Form.Ocodigo") and Trim(Form.Ocodigo) NEQ "-1" and trim(Form.Ocodigo) NEQ "" and Trim(Form.Ocodigo) NEQ "Todos">
        <cfset filtro = filtro & " and a.Ocodigo = " & Trim(Form.Ocodigo) >
        <cfset Oficinacodigo = Trim(Form.Ocodigo)>
    </cfif>
    <cfif isDefined("Form.Registros") and Trim(Form.Registros) NEQ "">
        <cfset Registros = Form.Registros>
    </cfif>
    
    <cfquery name="rsTransacciones" datasource="#Session.DSN#" cachedwithin="#CreateTimeSpan(0,0,10,0)#" >
          select b.CPTcodigo, b.CPTdescripcion 
          from CPTransacciones b
          where b.Ecodigo = #Session.Ecodigo#
            --and b.CPTtipo = '#LvarTipoMov#' 
            and coalesce(b.CPTpago, 0) != 1 and coalesce(b.CPTanticipo, 0) != 1
			<cfif session.monitoreo.SPCODIGO EQ "CPRemDev">
			     and b.CPTcodigo = 'DR'
		    <cfelse>
			    and b.CPTcodigo = 'RM'
			</cfif>
          order by CPTcodigo desc 
    </cfquery> 
    
    <cfquery name="rsMonedas" datasource="#Session.DSN#" cachedwithin="#CreateTimeSpan(0,0,10,0)#">
        select b.Mcodigo as Mcodigo, b.Miso4217 as Mnombre 
        from Monedas b 
        where b.Ecodigo = #Session.Ecodigo#
    </cfquery> 

	<cfquery name="rsOficinas" datasource="#Session.DSN#">
		select Ocodigo, Odescripcion from Oficinas
		where Ecodigo = #Session.Ecodigo#
		order by Ocodigo
	</cfquery>

	<cfif (isdefined("form.SNidentificacion") and len(trim(form.SNidentificacion))) or (isdefined("form.SNnumero") and len(trim(form.SNnumero)))>
		<cfquery name="rsSociosN" datasource="#session.DSN#">
			select SNid, SNcodigo, SNnombre, SNidentificacion, DEidVendedor, DEidCobrador, SNcuentacxp, SNvenventas, SNvencompras
			from SNegocios a, EstadoSNegocios b
			where a.Ecodigo = #Session.Ecodigo#
			and a.ESNid = b.ESNid
			<cfif isdefined('Form.SNnumero') and len(trim(Form.SNnumero))>
				and a.SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#">
			</cfif>
			<cfif isdefined('Form.SNidentificacion') and len(trim(Form.SNidentificacion))>
				and a.SNidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNidentificacion#">
			</cfif>
		</cfquery>
		<cfset filtro = filtro & " and a.SNcodigo = " & #rsSociosN.SNcodigo#>
	</cfif>
    
    <cfquery name="rsTiposTran" datasource="#Session.DSN#" cachedwithin="#CreateTimeSpan(0, 0, 10, 0)#">
        select CPTcodigo as CPTcodigo
        from CPTransacciones 
        where Ecodigo = #session.ecodigo#
          --and CPTtipo = '#LvarTipoMov#'
          and coalesce(CPTpago, 0) != 1 and coalesce(CPTanticipo, 0) != 1
          <cfif session.monitoreo.SPCODIGO EQ "CPRemDev">
			     and CPTcodigo = 'DR'
		    <cfelse>
			    and CPTcodigo = 'RM'
			</cfif>
          order by CPTcodigo desc 
    </cfquery>
    
    <cfset LvarTipoListas = valuelist(rsTiposTran.CPTcodigo, "','")>
    
    <cftransaction isolation="read_uncommitted">
        <cfquery name="rsUsuarios" datasource="#Session.DSN#" cachedwithin="#CreateTimeSpan(0, 0, 10, 0)#">
            select EDusuario, count(1) as Cantidad
            from EDocumentosCPR 
            where Ecodigo = #Session.Ecodigo#
              and CPTcodigo in ('#preservesinglequotes(LvarTipoListas)#') 
            group by EDusuario
        </cfquery>
    </cftransaction>
</cfif>
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_EncPago 	= t.Translate('LB_EncPago','Encabezado de Pago')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Estado = t.Translate('LB_Estado','Estado')>
<cfset LB_Registrado = t.Translate('LB_Registrado','Registrado')>
<cfset LB_Aplicado = t.Translate('LB_Aplicado','Aplicado')>
<cfset LB_Cancelado = t.Translate('LB_Cancelado','Cancelado')>
<cfset LBCHK_Cancelados = t.Translate('LBCHK_Cancelados','Cancelados')>
<cfset LB_Usuario 	= t.Translate('LB_Usuario','Usuario','/sif/generales.xml')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Oficina 	= t.Translate('LB_Oficina','Oficina','/sif/generales.xml')>
<cfset LB_Registros	= t.Translate('LB_Registros','Registros')>
<cfset LB_Fecha 	= t.Translate('LB_Fecha','Fecha Inicio','/sif/generales.xml')>
<cfset LB_FechaFin 	= t.Translate('LB_FechaFin','Fecha Fin','/sif/generales.xml')>
<cfset LB_Todos 	= t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset LB_Todas 	= t.Translate('LB_Todas','Todas','/sif/generales.xml')>
<cfset LB_SelTodos 	= t.Translate('LB_SelTodos','Seleccionar Todos')>
<cfset LB_Total 	= t.Translate('LB_Total','Total','/sif/generales.xml')>
<cfset MSG_SePrErr	= t.Translate('MSG_SePrErr','Sepresentaron los siguientes errores')>
<cfset MSG_MarcApl	= t.Translate('MSG_MarcApl','Debe marcar uno o más registros, de la lista para Aplicar.')>
<cfset MSG_MarcEnv	= t.Translate('MSG_MarcEnv','Debe marcar uno o más registros, de la lista para Enviar a Aplicar.')>
<cfset MSG_Anular	= t.Translate('MSG_Anular','Debe marcar uno o más registros, de la lista para Anular.')>
<cfset MSG_Imprimir	= t.Translate('MSG_Imprimir','Debe marcar uno o más registros, de la lista para imprimir su trámite.')>

<cfset LB_btnFiltrar 	= t.Translate('LB_btnFiltrar','Filtrar','/sif/generales.xml')>
<cfset LB_btnLimpiar 	= t.Translate('LB_btnLimpiar','Limpiar','/sif/generales.xml')>

<cfsetting enablecfoutputonly="no">
<cf_templateheader title="SIF - Cuentas por Pagar">
	<cfinclude template="../../../portlets/pNavegacion.cfm">
	<cfif  isdefined('dato') and dato eq 'importarMateriaPrima'>   
        <cfinclude template="ImportadorMateriaPrima.cfm">  
    <cfelseif  isdefined('dato') and dato eq 'importarCrudo'>   
        <cfinclude template="ImportadorCrudo.cfm">  
    <cfelse>  
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#titulo#'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td> 
					<form style="margin: 0" name="filtros" action="<cfoutput>#URLira#</cfoutput>" method="post">
						<input name="TipDoc" id="TipDoc" type="hidden" value="<cfoutput>#LvarTipDoc#</cfoutput>">
						<input name="URLira" id="URLira" type="hidden" value="<cfoutput>#URLira#</cfoutput>">

                        <table width="100%" border="0" cellspacing="2" cellpadding="0" class="areaFiltro">
						    <tr>
							<cfoutput> 
								<td width="4%">&nbsp;</td>
								<td width="4%"><strong>#LB_Transaccion#</strong></td>
								<td width="4%">&nbsp;</td>
								<td><strong>#LB_Oficina#</strong></td>
								<td width="0%">&nbsp;</td>
								<td><strong>Proveedor</strong></td>
								<td>&nbsp;</td>
							</cfoutput>
							</tr>
							<tr> 
								<td>&nbsp;</td>
								<td>
									<select name="Transaccion">
										<option value="Todos"><cfoutput>#LB_Todos#</cfoutput></option>
										<cfoutput query="rsTransacciones"> 
											<option value="#rsTransacciones.CPTcodigo#" <cfif rsTransacciones.CPTcodigo EQ Transaccion>selected</cfif>>#rsTransacciones.CPTdescripcion#</option>
										</cfoutput>
									</select>
								</td>
								<td width="4%">&nbsp;</td>
								<td>
									<!--- <select name="Ocodigo" tabindex="1">
									    <option value="-1"><cfoutput>#LB_Todas#</cfoutput></option>
										<cfoutput query="rsOficinas">
										    <option value="#rsOficinas.Ocodigo#" <cfif rsOficinas.Ocodigo EQ Oficinacodigo>selected</cfif>>#rsOficinas.Odescripcion#</option>
										</cfoutput>
									</select> --->

					                    <cfif isdefined("form.Ocodigo") and form.Ocodigo NEQ -1>    
					                        <cf_sifoficinas form="filtros" id="#form.Ocodigo#">
					                    <cfelse>
					                        <cf_sifoficinas form="filtros">
					                    </cfif>
            					</td>
								<td width="0%">&nbsp;</td>
								<td>
								    <cfif isdefined('form.SNnumero') and LEN(trim(form.SNnumero))>
									    <cf_sifsociosnegocios2 tabindex="1" SNtiposocio="P" 
											size="55" frame="frame1" form = "filtros"
											idquery = "#rsSociosN.SNcodigo#">
									<cfelse>
										<cf_sifsociosnegocios2 tabindex="1" SNtiposocio="P" 
											size="55" frame="frame1" form = "filtros">
									</cfif>
									<!--- Token para lista solo lista --->
									<input type = "hidden" name = "tokenListaDoc" 
									    id = "tokenListaDoc" value = "0">
								</td>
								<td>&nbsp;</td>
							</tr>
						</table>
						<br>
						<table width="100%" border="0" cellspacing="2" cellpadding="0" class="areaFiltro">
							<tr>
							    <cfoutput>
							    <td width="4%">&nbsp;</td>
								<td><strong>#LB_Documento#</strong></td>
								<td><strong>#LB_Usuario#</strong></td>
								<td><strong>#LB_Fecha#</strong></td>
								<td><strong>#LB_FechaFin#</strong></td>
								<td><strong>#LB_Moneda#</strong></td>
								<td><strong>#LB_Registros#</strong></td>
								</cfoutput>
							</tr>
							<tr>
							    <td width="4%">&nbsp;</td>
								<td>
									<input name="Documento" type="text" value="<cfif isDefined("Form.Documento") and Trim(Form.Documento) NEQ ""><cfoutput>#Form.Documento#</cfoutput></cfif>" size="20" maxlength="20">	
								</td>
								<td>
									<select name="Usuario">
										<option value=""><cfoutput>#LB_Todos#</cfoutput></option>
										<cfoutput query="rsUsuarios"> 
											<option value="#rsUsuarios.EDusuario#" <cfif rsUsuarios.EDusuario EQ Usuario>selected</cfif>>#rsUsuarios.EDusuario#</option>
										</cfoutput>
									</select>
								</td>
								<td>
									<cfif isdefined('Form.Fecha')>
										<cf_sifcalendario name="Fecha" form="filtros" value="#form.Fecha#">
									<cfelse>
										<cf_sifcalendario name="Fecha" form="filtros">
									</cfif>
										
								</td>
								<td>
									<cfif isdefined('Form.FechaFin')>
										<cf_sifcalendario name="FechaFin" form="filtros" value="#form.FechaFin#">
									<cfelse>
										<cf_sifcalendario name="FechaFin" form="filtros">
									</cfif>
										
								</td>
								<td nowrap>
									<select name="Moneda">
										<option value="-1"><cfoutput>#LB_Todas#</cfoutput></option>
										<cfoutput query="rsMonedas"> 
											<option value="#rsMonedas.Mcodigo#" <cfif rsMonedas.Mcodigo EQ Moneda>selected</cfif>>#rsMonedas.Mnombre#</option>
										</cfoutput>
									</select>
								</td>
								<td>
									<cf_monto decimales="0" size="3" maxlength="3" name="Registros" value="#Registros#">
								</td>
								<cfoutput>
								<td nowrap> 
									<input name="Filtrar" type="submit" class="btnFiltrar"  value="#LB_btnFiltrar#"> 
									<input name="Limpiar" type="button" class="btnLimpiar" value="#LB_btnLimpiar#" onClick="javascript: LimpiarFiltros(this.form); "> 
								</td>
								</cfoutput>
								<td>&nbsp;</td>
							</tr>
							<cfif session.monitoreo.SPCODIGO EQ "CPRemCanc">
								<tr>
									<td width="4%">&nbsp;</td>
									<cfif isdefined('Form.chkCancela')>
									    <td><input name="chkCancela" type="checkbox" value="" border="1" checked><cfoutput>#LBCHK_Cancelados#</cfoutput></strong></td>
									<cfelse>
									    <td><input name="chkCancela" type="checkbox" value="" border="1"><cfoutput>#LBCHK_Cancelados#</cfoutput></strong></td>
									</cfif>
								</tr>
							</cfif>
						</table>
					</form>
				</td>
			</tr>
			<tr> 
				<td><strong>&nbsp;&nbsp;&nbsp;<input name="chkTodos" type="checkbox" value="" border="1" onClick="javascript:Marcar(this);"><cfoutput>#LB_SelTodos#</cfoutput></strong></td>
			</tr>
			<tr> 
				<cfflush interval="64">
				<td>
				    <cfset whereStatusCondition = "">
					<cfset whereCancelaCondition = "">
					<cfset condicionActivarCol = "">
					<cfif session.monitoreo.SPCODIGO EQ "CPRemision">
					    <cfset whereStatusCondition = "a.EVestado = 0">
						<cfset condicionActivarCol = "0 as marcaInactiva">
					<cfelseif session.monitoreo.SPCODIGO EQ "CPRemCanc">
					    <cfset whereStatusCondition = "(a.EVestado = 1 or a.EVestado = 2)">
						<cfset whereCancelaCondition = " and (select count(*) from DDocumentosCPR dd where dd.IDdocumento = a.IDdocumento and dd.DFacturalinea is null) > 0">
						<cfif isdefined('Form.chkCancela')>
					        <cfset whereStatusCondition = "a.EVestado = 2">
					    </cfif>
						<cfset condicionActivarCol = "case when a.EVestado = 2 then a.IDdocumento else 0 end as marcaInactiva">
					<cfelseif session.monitoreo.SPCODIGO EQ "CPRemDev">
					    <cfset whereStatusCondition = "a.CPTCodigo = 'DR'">
						<!--- <cfset condicionActivarCol = "0 as marcaInactiva"> --->
						<cfset condicionActivarCol = "case when a.EVestado = 1 then a.IDdocumento else 0 end as marcaInactiva">
						<cfset LvarTipoMov = 'D'>
					</cfif>
					
					<cfset filtro = filtro & " and " & whereStatusCondition & whereCancelaCondition>
					<cfset filtro = filtro & FiltroExtra & " Order by SNnombre, EDdocumento">
					<cf_dbfunction name="to_char"	args="a.IDdocumento" returnvariable="IDdocumento">
					<cf_dbfunction name="to_char"	args="a.EDtotal"     returnvariable="EDtotal">
						<cfinvoke component="sif.Componentes.pListas" method="pListaRH">
							<cfinvokeargument name="tabla" value="EDocumentosCPR a
									inner join SNegocios b
										on b.SNcodigo = a.SNcodigo
										and b.Ecodigo = a.Ecodigo
									inner join CPTransacciones c
										on c.CPTcodigo = a.CPTcodigo
										and c.Ecodigo = a.Ecodigo
										and c.CPTtipo = '#LvarTipoMov#'
									inner join Monedas m
										on m.Mcodigo = a.Mcodigo
									left outer join Oficinas o
											on o.Ocodigo= a.Ocodigo
											and o.Ecodigo=a.Ecodigo">

							<cfinvokeargument name="columnas" value="#IDdocumento# as IDdocumento, 
									b.SNidentificacion, 
									b.SNnombre, 
									c.CPTdescripcion, 
									a.EDdocumento,
									case 
									when a.EVestado = 0 then '#LB_Registrado#'
									when a.EVestado = 1 then '#LB_Aplicado#'
									when a.EVestado = 2 then '#LB_Cancelado#'
									end as Estado,
									a.EDusuario,
									#EDfecha# EDfecha,
									m.Miso4217 as Mnombre,
									'#URLira#' as URLira,
									'#LvarTipDoc#' as TipDoc,
									#condicionActivarCol#,
									isnull(o.Odescripcion,'') as Odescripcion,
									#EDtotal# EDtotal #campos_extra#">
							<cfinvokeargument name="desplegar" 	value="CPTdescripcion, EDdocumento, Estado,Odescripcion, EDusuario, EDfecha, Mnombre, EDtotal">
							<cfinvokeargument name="etiquetas" 	value="#LB_Transaccion#, #LB_Documento#, #LB_Estado#,#LB_Oficina#, #LB_Usuario#, #LB_Fecha#, #LB_Moneda#, #LB_Total#">
							<cfinvokeargument name="formatos" 	value="S,S,S,S,S,S,S,M">
							<cfinvokeargument name="filtro" 	value="#filtro#">
							<cfinvokeargument name="cortes" 	value="SNnombre">
							<cfinvokeargument name="align" 		value="left, left, left, left,left, left, center, right">
							<cfinvokeargument name="checkboxes" value="S">
							<cfinvokeargument name="ira" 		value="#URLira#">
							<cfinvokeargument name="botones" 	value="#Botones#">
							<cfinvokeargument name="keys" 		value="IDdocumento">
							<cfinvokeargument name="MaxRows" 	value="#Registros#">
							<cfinvokeargument name="Navegacion" value="#Navegacion#">
							<cfinvokeargument name="inactivecol"  value="marcaInactiva"/>
						</cfinvoke> 
				</td>
			</tr>
		</table>
		<cf_web_portlet_end>
	    <cf_templatefooter>

		<script language="JavaScript1.2">
			//FUNCION PARA MARCAR TODOS LOS DOCUMENTOS DE CUENTAS POR PAGAR
			function Marcar(c) {
				if (document.lista.chk != undefined) { //existe?
					if (document.lista.chk.value != undefined || document.lista.chk.value != "") {// solo un check
					if (c.checked) {
							document.lista.chk.checked = true; 
							for (var counter = 0; counter < document.lista.chk.length; counter++) {
								if (!document.lista.chk[counter].disabled) {
									document.lista.chk[counter].checked = c.checked;
								}
							}
					} else {
							document.lista.chk.checked = false;
							for (var counter = 0; counter < document.lista.chk.length; counter++) {
								if (!document.lista.chk[counter].disabled) {
									document.lista.chk[counter].checked = c.checked;
								}
							}
					}
					}
					else {
						for (var counter = 0; counter < document.lista.chk.length; counter++) {
							if (!document.lista.chk[counter].disabled) {
								document.lista.chk[counter].checked = c.checked;
							}
						}
					}
				}
			}
			//FUNCION PARA LIMPIAR TODOS LOS FILTROS
			function LimpiarFiltros(f) {
				f.Transaccion.selectedIndex = 0;
				f.Documento.value = "";
				f.Moneda.selectedIndex = 0;
				f.Oficinacodigo.selectedIndex = 0;
				f.Fecha.selectedIndex = 0;
				f.FechaFin.selectedIndex = 0;
				f.Usuario.selectedIndex = 0;
			}
			//FUNCION DEL BOTON DE NUEVO DOCUMENTO
			function funcNuevo(){
				document.lista.action = "<cfoutput>#URLira#</cfoutput>?btnNuevo=true";
			}

			//FUNCION DEL BOTON APLICAR
			<cfoutput>
				function funcAplicar(){
					if (!ValidaMarcado()){
						alert("#MSG_SePrErr#:\n - #MSG_MarcApl#");
						return false;
					}else{
						param = "TipDoc=<cfoutput>#LvarTipDoc#</cfoutput>&URLira=<cfoutput>#URLira#</cfoutput>";
						document.lista.action= "SQLRegistroDocumentosRemision.cfm?"+param;
						return true;
					}
				}

				function funcCancelar_Remisión(){
					if (!ValidaMarcado()){
						alert("#MSG_SePrErr#:\n - #MSG_MarcApl#");
						return false;
					}else{
						var cancelar = false;
						<cfoutput>
							<cfset MSG_CanRem = t.Translate('MSG_CanRem','¿Esta seguro que desea cancelar el / los Documento?')>
							cancelar = confirm('#MSG_CanRem#');
						</cfoutput>
						if(cancelar){
							param = "TipDoc=<cfoutput>#LvarTipDoc#</cfoutput>&URLira=<cfoutput>#URLira#</cfoutput>";
							<cfif session.monitoreo.SPCODIGO EQ "CPRemCanc">
								var esCancelacion = true;
								param += "&esCancelacion=" + esCancelacion;
							</cfif>
							document.lista.action= "SQLRegistroDocumentosRemision.cfm?"+param;
							return true;
						}
						return false;
					}
				}

				function funcAplicar_Devolución(){
					if (!ValidaMarcado()){
						alert("#MSG_SePrErr#:\n - #MSG_MarcApl#");
						return false;
					}else{
						param = "TipDoc=<cfoutput>#LvarTipDoc#</cfoutput>&URLira=<cfoutput>#URLira#</cfoutput>";
						<cfif session.monitoreo.SPCODIGO EQ "CPRemDev">
							var esCancelacion = true;
							var esDevolucion = true;
							param += "&esCancelacion=" + esCancelacion + "&esDevolucion=" + esDevolucion;
						</cfif>
						document.lista.action= "SQLRegistroDocumentosRemision.cfm?"+param;
						return true;
					}
				}
			</cfoutput>

			//FUNCION PARA VALIDA SI HAY ALGUN REGISTRO MARCADO
			function ValidaMarcado() {
				var obj = document.lista.chk;
				var correcto = false; 
				if (obj.length != undefined) {
					for (var i = 0; i < obj.length; i++) {
						if (!obj[i].disabled && obj[i].checked) {
							correcto = true;
							break;
						}
					}
				}else{ if (obj.checked ) 
							correcto = true;
				}
				return(correcto);	
			}
			
		</script>
	</cfif>