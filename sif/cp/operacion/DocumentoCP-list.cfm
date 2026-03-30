<cfif not isdefined('dato')>
    <cf_navegacion name="tipo" 			default="D">	
    <cf_navegacion name="Fecha" 		default="">	
	<cf_navegacion name="FechaFin" 		default="">	
    <cf_navegacion name="Transaccion" 	default="">	
    <cf_navegacion name="Documento" 	default="">
	<cf_navegacion name="FTimbre" 		default="">	
    <cf_navegacion name="Usuario" 		default="">	
    <cf_navegacion name="Registros" 	default="20">	
    <cf_navegacion name="Moneda" 		default="-1">	
	<cf_navegacion name="Ocodigo" 		default="-1">
    <cf_navegacion name="pageNum_lista" default="1">	
    <cf_navegacion name="LvarTipoMov" 	default="D">	  
    <cf_navegacion name="titulo" 		default="Lista de Documentos de CxP">	
    <cf_navegacion name="Botones" 		default="Aplicar,Nuevo,Importar_Facturas,Importar_Transito,Reporte">	
    <cf_navegacion name="FiltroExtra" 	default="">	
    
    
    <cfset campos_extra = ", '#LvarTipoMov#' as tipo , '#form.Registros#' as Registros, '#form.pageNum_lista#' as pageNum_lista" >
    <cfif len(trim(Form.Fecha))> 		<cfset campos_extra = campos_extra & ", '#form.Fecha#' as fecha" ></cfif>
    <cfif len(trim(Form.FechaFin))> 	<cfset campos_extra = campos_extra & ", '#form.FechaFin#' as fecha" ></cfif>
	<cfif len(trim(Form.Transaccion))>	<cfset campos_extra = campos_extra & ", '#Form.Transaccion#' as transaccion" ></cfif>
    <cfif len(trim(Form.Documento))>	<cfset campos_extra = campos_extra & ", '#form.Documento#' as documento" ></cfif>
	<cfif len(trim(Form.FTimbre))>		<cfset campos_extra = campos_extra & ", '#form.FTimbre#' as ftimbre" ></cfif>
    <cfif len(trim(Form.Usuario))>		<cfset campos_extra = campos_extra & ", '#form.usuario#' as usuario" ></cfif>
    <cfif len(trim(Form.Moneda)) and Form.Moneda gte 0><cfset campos_extra = campos_extra & ", '#form.moneda#' as moneda" ></cfif>
    <cfif len(trim(Form.Ocodigo)) and Form.Ocodigo gte 0><cfset campos_extra = campos_extra & ", '#form.Ocodigo#' as Ocodigo" ></cfif>
    
    <cfset filtro = "a.Ecodigo = #Session.Ecodigo#"> 
    <cfset Fecha       = "Todos">
	<cfset FechaFin       = "Todos">
    <cfset Transaccion = "Todos">
    <cfset Documento   = "">
	<cfset FTimbre   	= "Todos">
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
    <cfif isDefined("Form.FTimbre") and Trim(Form.FTimbre) NEQ "" and Trim(Form.FTimbre) NEQ "Todos">
        <cfset filtro = filtro & " and "& Trim(Form.FTimbre) &"= case when a.TimbreFiscal is not null and ltrim(rtrim(a.TimbreFiscal)) <> '' then 1 else 0
			  end" >
        <cfset FTimbre = Trim(Form.FTimbre)>
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
            and b.CPTtipo = '#LvarTipoMov#' 
            and coalesce(b.CPTpago, 0) != 1 and coalesce(b.CPTanticipo, 0) != 1
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
	<cfset filtro = filtro & FiltroExtra & " Order by SNnombre, EDdocumento">
    
    <cfquery name="rsTiposTran" datasource="#Session.DSN#" cachedwithin="#CreateTimeSpan(0, 0, 10, 0)#">
        select CPTcodigo as CPTcodigo
        from CPTransacciones 
        where Ecodigo = #session.ecodigo#
          and CPTtipo = '#LvarTipoMov#'
          and coalesce(CPTpago, 0) != 1 and coalesce(CPTanticipo, 0) != 1
    </cfquery>

	<cfquery name="rsTiposTran" datasource="#Session.DSN#" cachedwithin="#CreateTimeSpan(0, 0, 10, 0)#">
        select CPTcodigo as CPTcodigo
        from CPTransacciones 
        where Ecodigo = #session.ecodigo#
          and CPTtipo = '#LvarTipoMov#'
          and coalesce(CPTpago, 0) != 1 and coalesce(CPTanticipo, 0) != 1
    </cfquery>
    
    <cfset LvarTipoListas = valuelist(rsTiposTran.CPTcodigo, "','")>
    
    <cftransaction isolation="read_uncommitted">
        <cfquery name="rsUsuarios" datasource="#Session.DSN#" cachedwithin="#CreateTimeSpan(0, 0, 10, 0)#">
            select EDusuario, count(1) as Cantidad
            from EDocumentosCxP 
            where Ecodigo = #Session.Ecodigo#
              and CPTcodigo in ('#preservesinglequotes(LvarTipoListas)#') 
            group by EDusuario
        </cfquery>
    </cftransaction>
</cfif>
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_EncPago 	= t.Translate('LB_EncPago','Encabezado de Pago')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacción','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Usuario 	= t.Translate('LB_Usuario','Usuario','/sif/generales.xml')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Oficina 	= t.Translate('LB_Oficina','Oficina','/sif/generales.xml')>
<cfset LB_FolioReferencia 	= t.Translate('LB_FolioRegferencia','Folio Referencia','/sif/generales.xml')>
<cfset LB_Folio 	= t.Translate('LB_Folio','Folio','/sif/generales.xml')>
<cfset LB_Timbre 	= t.Translate('LB_Timbre','Timbre','/sif/generales.xml')>
<cfset LB_Registros	= t.Translate('LB_Registros','Registros')>
<cfset LB_Fecha 	= t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_FechaFin 	= t.Translate('LB_FechaFin','Fecha Fin','/sif/generales.xml')>
<cfset LB_Todos 	= t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset LB_Todas 	= t.Translate('LB_Todas','Todas','/sif/generales.xml')>
<cfset LB_SelTodos 	= t.Translate('LB_SelTodos','Seleccionar Todos')>
<cfset LB_Total 	= t.Translate('LB_Total','Total','/sif/generales.xml')>
<cfset MSG_SePrErr	= t.Translate('MSG_SePrErr','Se presentaron los siguientes errores')>
<cfset MSG_MarcApl	= t.Translate('MSG_MarcApl','Debe marcar uno o más registros, de la lista para Aplicar.')>
<cfset MSG_MarcEnv	= t.Translate('MSG_MarcEnv','Debe marcar uno o más registros, de la lista para Enviar a Aplicar.')>
<cfset MSG_Anular	= t.Translate('MSG_Anular','Debe marcar uno o más registros, de la lista para Anular.')>
<cfset MSG_Imprimir	= t.Translate('MSG_Imprimir','Debe marcar uno o más registros, de la lista para imprimir su trámite.')>
<cfset LB_btnFiltrar 	= t.Translate('LB_btnFiltrar','Filtrar','/sif/generales.xml')>
<cfset LB_btnLimpiar 	= t.Translate('LB_btnLimpiar','Limpiar','/sif/generales.xml')>
<cfset LB_btnCargaXML 	= t.Translate('LB_btnCargaXML','Carga XML','/sif/generales.xml')>

<cfset CBT_SinTimbre	= t.Translate('CBT_SinTimbre','Sin Timbre Fiscal')>
<cfset CBT_ConTimbre	= t.Translate('CBT_ConTimbre','Con Timbre Fiscal')>

<cfsetting enablecfoutputonly="no">
<cf_templateheader title="SIF - Cuentas por Pagar">
	<cfinclude template="../../portlets/pNavegacion.cfm">	
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
								<!--- 
								JARR se Cambio el filtro--a un tag para facilitar su uso con varios registros
								<select name="Ocodigo" tabindex="1">
								    <option value="-1"><cfoutput>#LB_Todas#</cfoutput></option>
									<cfoutput query="rsOficinas">
									    <option value="#rsOficinas.Ocodigo#" <cfif rsOficinas.Ocodigo EQ Oficinacodigo>selected</cfif>>#rsOficinas.Odescripcion#</option>
									</cfoutput>
								</select>
								Form.Ocodigo --->
								<cfif isdefined("Form.Ocodigo") and Form.Ocodigo NEQ -1>	
					                <cf_sifoficinas form="filtros" id="#Form.Ocodigo#">
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
							<td><strong>#LB_Timbre#</strong></td>
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
								<select name="FTimbre">
									<option value="Todos"><cfoutput>#LB_Todos#</cfoutput></option>
									<option value="0" <cfif FTimbre eq 0>selected</cfif>><cfoutput>#CBT_SinTimbre#</cfoutput></option>
									<option value="1" <cfif FTimbre eq 1>selected</cfif>><cfoutput>#CBT_ConTimbre#</cfoutput></option>
								</select>
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
								<input name="Carga XML" type="button" class="" value="#LB_btnCargaXML#" onClick="javascript: funcCargaXML(this.form); "> 
							</td>
							</cfoutput>
							<td>&nbsp;</td>
						</tr>
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
				
			    <cfset desplegar = "CPTdescripcion, EDdocumento, Odescripcion, EDusuario, EDfecha, Mnombre, EDtotal">
				<cfset etiquetas = "#LB_Transaccion#, #LB_Documento#, #LB_Oficina#, #LB_Usuario#, #LB_Fecha#, #LB_Moneda#, #LB_Total#">
				<cfset alineacion = "left, left, left, left,left, left, center, right">
			    <cfif LvarTipoMov EQ 'D'>
				    <cfset desplegar = "CPTdescripcion, EDdocumento, folioRef, Odescripcion, EDusuario, , EDfecha, Mnombre, EDtotal">
				    <cfset etiquetas = "#LB_Transaccion#, #LB_Documento#, #LB_FolioReferencia#, #LB_Folio#, #LB_Oficina#, #LB_Usuario# , #LB_Fecha#, #LB_Moneda#, #LB_Total#, #LB_Timbre#">
				    <cfset alineacion = "left, left, left, left, left,left,left, center, right, right">
				</cfif>
				
				<cf_dbfunction name="to_char"	args="a.IDdocumento" returnvariable="IDdocumento">
				<cf_dbfunction name="to_char"	args="a.EDtotal"     returnvariable="EDtotal">
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH">
						<cfinvokeargument name="tabla" value="EDocumentosCxP a
								inner join SNegocios b
									on b.SNcodigo = a.SNcodigo
									and b.Ecodigo = a.Ecodigo
								inner join CPTransacciones c
									 on c.CPTcodigo = a.CPTcodigo
									and c.Ecodigo = a.Ecodigo
									and c.CPTtipo = '#LvarTipoMov#'
								inner join Monedas m
									on m.Mcodigo = a.Mcodigo
								inner join Oficinas ofi
								on ofi.Ocodigo = a.Ocodigo
								and ofi.Ecodigo = a.Ecodigo">
						<cfinvokeargument name="columnas" value="#IDdocumento# as IDdocumento, 
								b.SNidentificacion,
								a.FolioReferencia, 
								a.Folio, 
								ofi.Odescripcion,
								b.SNnombre, 
								c.CPTdescripcion, 
								a.EDdocumento, 
								a.EDusuario,
								#EDfecha# EDfecha,
								m.Miso4217 as Mnombre,
                                '#URLira#' as URLira,
                                '#LvarTipDoc#' as TipDoc,
								#EDtotal# EDtotal #campos_extra#,								
								case when (a.TimbreFiscal is not null and ltrim(rtrim(a.timbreFiscal)) <> '')
								then '<img border=''0'' src=''/cfmx/sif/imagenes/iindex.gif'' alt=''Mostrar CFDI''>'
								else null end as Timbre">
						<cfinvokeargument name="desplegar" 	value="CPTdescripcion, EDdocumento, FolioReferencia, Folio, Odescripcion, EDusuario, EDfecha, Mnombre, EDtotal, Timbre">
						<cfinvokeargument name="etiquetas" 	value="#LB_Transaccion#, #LB_Documento#, #LB_FolioReferencia#, #LB_Folio#, #LB_Oficina#,#LB_Usuario#, #LB_Fecha#, #LB_Moneda#, #LB_Total#, #LB_Timbre#">
						<cfinvokeargument name="formatos" 	value="S,S,S,S,S,S,S,S,M, S">
						<cfinvokeargument name="filtro" 	value="#filtro#">
						<cfinvokeargument name="cortes" 	value="SNnombre">
						<cfinvokeargument name="align" 		value="left, left, left,left,left,left, left, center, right, right">
						<cfinvokeargument name="checkboxes" value="S">
						<cfinvokeargument name="ira" 		value="#URLira#">
						<cfinvokeargument name="botones" 	value="#Botones#">
						<cfinvokeargument name="keys" 		value="IDdocumento">
						<cfinvokeargument name="MaxRows" 	value="#Registros#">
						<cfinvokeargument name="Navegacion" value="#Navegacion#">
					</cfinvoke> 
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>

<style type = "text/css">
	#dialogDateMasive { display: none; }
	#dummyDate {
		opacity: 0;
		position: absolute;
		top: 0;
		left: 0;    
	}
</style>

<div id="dialogDateMasive" title="Text Dialog">
	<input type="text" id="dummyDate" />
	Fecha: <input type="text" id="dateMasiveNC" placeholder="dd/mm/yyyy" title = "dd/mm/yyyy"
	    autocomplete="off" maxlength="10" size="10"/>
</div>

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
	f.FTimbre.selectedIndex = 0;
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
//Funcion para ejecutar la tarea de relacionar XML del SIC a las facturas RDF 140322
function funcCargaXML(){     			
	window.open("/cfmx/sif/tasks/facturas/relacion_cxp.cfm", 'mywindow','location=1, align= absmiddle,status=1,scrollbars=1, top=100, left=100 width=500,height=500');		
}
function funcImprimir(){
     	
		var lista = '';
		var arr = document.lista.chk;
   
		for(i=0;i<arr.length; i++ )
		{
			if(document.lista.chk[i].checked)
			{
					lista = lista + document.lista.chk[i].value + ',';			 			
			}
		}	
		window.open('facturaTramite.cfm?lista='+lista, 'mywindow','location=1, align= absmiddle,status=1,scrollbars=1, top=100, left=100 width=500,height=500');
		
}
//FUNCION DEL BOTON APLICAR
<cfoutput>
function funcAplicar(){
		if (!ValidaMarcado()){
			alert("#MSG_SePrErr#:\n - #MSG_MarcApl#");
			return false;
		}else{
			param = "TipDoc=<cfoutput>#LvarTipDoc#</cfoutput>&URLira=<cfoutput>#URLira#</cfoutput>";
			document.lista.action= "SQLRegistroDocumentosCP.cfm?"+param;
			return true;
		}
}
</cfoutput>

//BOTON DE IMPORTAR FACTURAS
function funcImportar_Facturas(){
	location.href = "<cfoutput>#URLira#</cfoutput>?dato=importarMateriaPrima";
	return false;
}
//FUNCION DE IMPORTAR TRANSITO
function funcImportar_Transito(){
	location.href = "<cfoutput>#URLira#</cfoutput>?dato=importarCrudo";
	return false;
}
//FUNCION PARA IR AL REPORTE DE DOCUMENTOS DE CXP
function funcReporte(){
	<cfoutput>
	location.href = "../reportes/DocumentosSinAplicarCP.cfm?Docs=1&#params#";
	return false;
	</cfoutput>
}
//FUNCION PARA MODIFICAR FECHA DE DOCUMENTOS DE NOTAS DE CREDITO
function funcCambiar_Fecha(){
	if (!ValidaMarcado()) {
		<cfoutput>
		    alert("#MSG_SePrErr#:\n - #MSG_MarcApl#");
		</cfoutput>
		return false;
	}
	else {
		$('#dateMasiveNC').datepicker({
			title:'DatePicker',
			format: 'dd/mm/yyyy'
		}).on('change', function(){
			$("#dateMasiveNC").datepicker("hide");
		});
		$(".datepicker-days").css("zIndex", 10000);
		$(".datepicker").css("zIndex", 10000);
		$("#dialogDateMasive").dialog({
			modal: true,
			title: "Cambio de fecha masiva notas de credito",
			resizable: false,
			width: 350,
			height: 150,
			minWidth: 300,
			maxWidth: 550,
			show: "scale",
			hide: "scale",
			buttons: [
				{
					text: "Modificar",
					click: function() {
						var dateMNC = $("#dateMasiveNC").val();
						if(dateMNC === ""){
							alert("Debe ingresar una fecha");
						}
						else{
							<cfoutput>
								var param = "TipDoc=<cfoutput>#LvarTipDoc#</cfoutput>&URLira=<cfoutput>#URLira#</cfoutput>";
								param += "&cambioMasivoFechaEvento=" + true;
								param += "&fechaMasiva=" + dateMNC;
								var lista = $("##lista");
								$(lista).attr("action", "SQLRegistroDocumentosCP.cfm?" + param);
								$("##lista").submit();
								return true;
							</cfoutput>
						}
					}
				},
				{
					text: "Cancelar",
					click: function(){
						$("#dateMasiveNC").val("");
						$(this).dialog("close");
					}
				}
			]
		});
	}
	return false;
}
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
//FUNCION PARA ENVIAR A APLICAR
<cfoutput>
function funcEnviar_a_Aplicar(){
		if (!ValidaMarcado()){
			alert("#MSG_SePrErr#:\n - #MSG_MarcEnv#");
			return false;
		}else{
			param = "TipDoc=<cfoutput>#LvarTipDoc#</cfoutput>&URLira=<cfoutput>#URLira#</cfoutput>";
			document.lista.action= "SQLRegistroDocumentosCP.cfm?"+param;
			document.lista.submit();
			return true;}
	}
</cfoutput>
//
function funcAnular(){
		if (!ValidaMarcado()){
			alert("#MSG_SePrErr#:\n - #MSG_Anular#");
			return false;
		}else{
			param = "TipDoc=<cfoutput>#LvarTipDoc#</cfoutput>&URLira=<cfoutput>#URLira#</cfoutput>";
			document.lista.action= "SQLRegistroDocumentosCP.cfm?"+param;
			document.lista.submit();
			return true;}
	}
//Funcion para imprimri masivamente los tramites de las facturas
function funcImprimir_Tramite(){
	var Documentos = '';
	var cont =0;
	var cont2 =1;
	var obj = document.lista.chk;
	var listDocs = '';
	if (ValidaMarcado())
	{
		if (obj.length != undefined) {
			
			for (var i = 0; i < obj.length; i++) {
				if (!obj[i].disabled && obj[i].checked) {	
				cont=cont+1;
				}
			}
			for (var i = 0; i < obj.length; i++) {
				if (!obj[i].disabled && obj[i].checked){
					if(cont2 == cont){
						listDocs = listDocs+"lista="+obj[i].value;
					}else{
						listDocs = listDocs+"lista="+obj[i].value+'&';
						 cont2 =cont2+1;
						}
				}
			}
		}
		 window.open('facturaTramite.cfm?'+listDocs, 'mywindow','location=1, align= absmiddle,status=1,scrollbars=1, top=100, left=100 width=500,height=500'); 
		//alert('facturaTramite.cfm?'+listDocs, 'mywindow','location=1, align= absmiddle,status=1,scrollbars=1, top=100, left=100 width=500,height=500')
	}else{
	<cfoutput>
		alert("#MSG_SePrErr#:\n - #MSG_Imprimir#");
			return false;
	</cfoutput>
	}
}
	
</script>
</cfif>