<cfsetting enablecfoutputonly="yes">
<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 19-5-2005.
		Motivo: Agregar un botón de Imprimir (JCGÑ).
	Modificado por Gustavo Fonseca H.
		Fecha: 24-5-2005.
		Motivo: Areglo del filtro.
		
	Modificado por: Ana Villavicencio R.
		Fecha: 11 de julio del 2005
		Motivo: Error en el filtro de la lista.  En cantidad de registro no aceptaba vacios.
		Lineas: 99 la comparacion  Trim(Form.Registros) NEQ "", antes no tenia nada.
	- Modificado por Gustavo Fonseca H.
		Fecha: 4-8-2005
		Motivo: - Se modifica para arreglar la seguridad de CxP en los procesos de facturas y notas de crédito, para que seguridad sepa 
				con cual de los dos procesos está trabajando. Esto porque se estaba trabajando con un archivo para los dos procesos.
				- Se agrega el botón nuevo en el form para que no tenga que salir hasta la lista para hacer uno nuevo (CHAVA).
		
--->
<cfif not isdefined('dato') >
<cfif ( isDefined("url.tipo") and len(Trim(url.tipo)) gt 0 ) and not isdefined("form.tipo")>
	<cfset form.tipo = url.tipo>
</cfif>
<cfif isdefined('LvarTipo') and not isdefined('Form.tipo')>
	<cfset form.tipo = LvarTipo>
</cfif>
<cfif ( isDefined("url.Fecha") and len(Trim(url.Fecha)) gt 0 ) and not isdefined("form.Fecha")>
	<cfset form.Fecha = url.Fecha>
</cfif>
<cfif ( isDefined("url.Transaccion") and len(Trim(url.Transaccion)) gt 0 ) and not isdefined("form.Transaccion")>
	<cfset form.Transaccion = url.Transaccion>
</cfif>
<cfif ( isDefined("url.Documento") and len(Trim(url.Documento)) gt 0 ) and not isdefined("form.Documento")  >
	<cfset form.Documento = url.Documento>
</cfif>
<cfif ( isDefined("url.Usuario") and len(Trim(url.Usuario)) gt 0 ) and not isdefined("form.Usuario")  >
	<cfset form.Usuario = url.Usuario>
</cfif>
<cfif ( isDefined("url.Registros") and len(Trim(url.Registros)) gt 0 ) and not isdefined("form.Registros")  >
	<cfset form.Registros = url.Registros>
</cfif>
<cfif ( isDefined("url.Moneda") and len(Trim(url.Moneda)) gt 0 ) and not isdefined("form.Moneda")  >
	<cfset form.Moneda = url.Moneda>
</cfif>
<cfif isDefined("url.pageNum_lista") and len(Trim(url.pageNum_lista)) gt 0>
	<cfset form.pageNum_lista = url.pageNum_lista>
</cfif>
<cfset titulo = "Lista de ">						
<cfif form.tipo NEQ "D">
	<cfset titulo = titulo & "Facturas">
<cfelse>
	<cfset titulo = titulo & "Notas de Cr&eacute;dito">
</cfif>	
<cfparam name="Form.tipo" default="D">
<cfparam name="Form.Fecha" default="">
<cfparam name="Form.Transaccion" default="">
<cfparam name="Form.Documento" default="">
<cfparam name="Form.Usuario" default="">
<cfparam name="Form.Moneda" default="-1">
<cfparam name="Form.Registros" default="20">
<cfparam name="Form.pageNum_lista" default="1">
<!--- =========================================================== --->
<!--- NAVEGACION --->
<!--- =========================================================== --->
<cfset campos_extra = ", '#Form.tipo#' as tipo , '#form.Registros#' as Registros, '#form.pageNum_lista#' as pageNum_lista" >
<cfif len(trim(Form.Fecha))>
	<cfset campos_extra = campos_extra & ", '#form.Fecha#' as fecha" >
</cfif>
<cfif len(trim(Form.Transaccion))>
	<cfset campos_extra = campos_extra & ", '#Form.Transaccion#' as transaccion" >
</cfif>
<cfif len(trim(Form.Documento))>
	<cfset campos_extra = campos_extra & ", '#form.Documento#' as documento" >
</cfif>
<cfif len(trim(Form.Usuario))>
	<cfset campos_extra = campos_extra & ", '#form.usuario#' as usuario" >
</cfif>
<cfif len(trim(Form.Moneda)) and Form.Moneda gte 0>
	<cfset campos_extra = campos_extra & ", '#form.moneda#' as moneda" >
</cfif>
<cfset filtro = "a.Ecodigo = #Session.Ecodigo#"> 
<cfset Fecha       = "Todos">
<cfset Transaccion = "Todos">
<cfset Documento   = "">
<cfset Usuario     = "Todos">
<cfset Moneda      = "Todos">
<cfset Registros   = 20>
<cfset Navegacion = "Tipo=#Form.Tipo#">
<cf_dbfunction name="to_sdateDMY"	args="a.EDfecha" returnvariable="EDfecha">
<cfif isDefined("Form.Fecha") and Trim(Form.Fecha) NEQ "">
	<cfif Trim(Form.Fecha) NEQ "Todos">
		<cfset filtro = filtro & " and #EDfecha# = '" & Trim(Form.Fecha) & "'" >
		<cfset Fecha = Trim(Form.Fecha)>
		<cfset Navegacion = Navegacion & "&Fecha="&Form.Fecha>
	</cfif>
</cfif>
<cfif isDefined("Form.Transaccion") and Trim(Form.Transaccion) NEQ "">
	<cfif Trim(Form.Transaccion) NEQ "Todos">
		<cfset filtro = filtro & " and a.CPTcodigo = '" & Trim(Form.Transaccion) & "'" >
		<cfset Transaccion = Trim(Form.Transaccion)>
		<cfset Navegacion = Navegacion & "&Transaccion="&Form.Transaccion>
	</cfif>
</cfif>
<cfif isDefined("Form.Documento") and Trim(Form.Documento) NEQ "">
	<cfset filtro = filtro & " and upper(a.EDdocumento) like '%" & Ucase(Trim(Form.Documento)) & "%'" >
	<cfset Documento = Trim(Form.Documento)>
	<cfset Navegacion = Navegacion & "&Documento="&Form.Documento>
</cfif>
<cfif isDefined("Form.Usuario") and Trim(Form.Usuario) NEQ "">
	<cfif Trim(Form.Usuario) NEQ "Todos">
		<cfset filtro = filtro & " and a.EDusuario = '" & Trim(Form.Usuario) & "'" >
		<cfset Usuario = Trim(Form.Usuario)>
		<cfset Navegacion = Navegacion & "&Usuario="&Form.Usuario>
	</cfif>
</cfif>
<cfif isDefined("Form.Registros") and Trim(Form.Registros) NEQ "">
	<cfset Registros = Form.Registros>
	<cfset Navegacion = Navegacion & "&Registros="&Form.Registros>
</cfif>
<cfif isDefined("Form.Moneda") and Trim(Form.Moneda) NEQ "-1" and trim(Form.Moneda) NEQ "">
	<cfif Trim(Form.Moneda) NEQ "Todos">
		<cfset filtro = filtro & " and a.Mcodigo = " & Trim(Form.Moneda) >
		<cfset Moneda = Trim(Form.Moneda)>
		<cfset Navegacion = Navegacion & "&Moneda="&Form.Moneda>
	</cfif>
</cfif>
<cfset filtro = filtro & " Order by SNnombre, EDdocumento">
<cfquery name="rsTransacciones" datasource="#Session.DSN#" cachedwithin="#CreateTimeSpan(0,0,10,0)#" >
	  select b.CPTcodigo, b.CPTdescripcion 
	  from CPTransacciones b
	  where b.Ecodigo = #Session.Ecodigo#
		and b.CPTtipo = '#form.tipo#' 
		and coalesce(b.CPTpago, 0) != 1
	  order by CPTcodigo desc 
</cfquery> 

<cfquery name="rsMonedas" datasource="#Session.DSN#" cachedwithin="#CreateTimeSpan(0,0,10,0)#">
	select b.Mcodigo as Mcodigo, b.Miso4217 as Mnombre 
	from Monedas b 
	where b.Ecodigo = #Session.Ecodigo#
</cfquery> 

<cfquery name="rsTiposTran" datasource="#Session.DSN#" cachedwithin="#CreateTimeSpan(0, 0, 10, 0)#">
	select CPTcodigo as CPTcodigo
	from CPTransacciones 
	where Ecodigo = #session.ecodigo#
	  and CPTtipo = '#form.tipo#'
	  and coalesce(CPTpago, 0) != 1
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
			<td></td>
		</tr>
		<tr> 
			<td> 
				<form style="margin: 0" name="filtros" action="listaDocumentosCP.cfm" method="post">
					<table width="100%" border="0" cellspacing="2" cellpadding="0" class="areaFiltro">
						<tr> 
							<td width="4%">&nbsp;</td>
							<td><strong>Transacción</strong></td>
							<td><strong>Documento </strong></td>
							<td><strong>Usuario</strong></td>
							<td><strong>Fecha</strong></td>
							<td><strong>Moneda</strong></td>
							<td><strong>Registros</strong></td>
							<td>&nbsp;</td>
						</tr>
						<tr> 
							<td>&nbsp;</td>
							<td>
								<select name="Transaccion">
									<option value="Todos">Todos</option>
									<cfoutput query="rsTransacciones"> 
										<option value="#rsTransacciones.CPTcodigo#" <cfif rsTransacciones.CPTcodigo EQ Transaccion>selected</cfif>>#rsTransacciones.CPTdescripcion#</option>
									</cfoutput>
								</select>
							</td>
							<td>
								<input name="Documento" type="text" value="<cfif isDefined("Form.Documento") and Trim(Form.Documento) NEQ ""><cfoutput>#Form.Documento#</cfoutput></cfif>" size="20" maxlength="20">	
							</td>
							<td>
								<select name="Usuario">
									<option value="">Todos</option>
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
							<td nowrap>
								<select name="Moneda">
									<option value="-1">Todas</option>
									<cfoutput query="rsMonedas"> 
										<option value="#rsMonedas.Mcodigo#" <cfif rsMonedas.Mcodigo EQ Moneda>selected</cfif>>#rsMonedas.Mnombre#</option>
									</cfoutput>
								</select>
							</td>
							<td>
								<cf_monto decimales="0" size="3" maxlength="3" name="Registros" value="#Registros#">
							</td>
							<td nowrap> 
								<input name="Filtrar" type="submit" class="btnFiltrar"  value="Filtrar"> 
								<input name="Limpiar" type="button" class="btnLimpiar" value="Limpiar" onClick="javascript: LimpiarFiltros(this.form); "> 
								<input name="tipo"    type="hidden"  value="<cfoutput>#form.tipo#</cfoutput>"> 
							</td>
						</tr>
					</table>
				</form>
			</td>
		  </tr>
		  <tr> 
			<td><strong>&nbsp;&nbsp;&nbsp;<input name="chkTodos" type="checkbox" value="" border="1" onClick="javascript:Marcar(this);">Seleccionar Todos</strong></td>
		  </tr>
		  <tr> 
			<cfflush interval="64">
			<td>
				<cfif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo EQ 'D'><!--- D = Notas de Credito en CxP --->
				<cf_dbfunction name="to_char"	args="a.IDdocumento" returnvariable="IDdocumento">
				<cf_dbfunction name="to_char"	args="a.EDtotal"     returnvariable="EDtotal">
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH" 
						tabla="EDocumentosCxP a
								inner join SNegocios b
									on b.SNcodigo = a.SNcodigo
									and b.Ecodigo = a.Ecodigo
								inner join CPTransacciones c
									 on c.CPTcodigo = a.CPTcodigo
									and c.Ecodigo = a.Ecodigo
									and c.CPTtipo = 'D'
								inner join Monedas m
									on m.Mcodigo = a.Mcodigo" 
						columnas="#IDdocumento# as IDdocumento, 
								b.SNidentificacion, 
								b.SNnombre, 
								c.CPTdescripcion, 
								a.EDdocumento, 
								a.EDusuario,
								#EDfecha# EDfecha,
								m.Miso4217 as Mnombre,
								#EDtotal# EDtotal #campos_extra#" 
						desplegar="CPTdescripcion, EDdocumento, EDusuario, EDfecha, Mnombre, EDtotal"
						etiquetas="Transacción, Documento, Usuario, Fecha, Moneda, Total"
						formatos="S,S,S,S,S,M"
						filtro= "#filtro#"
						cortes="SNnombre" 
						align="left, left, left,left, center, right"
						checkboxes="S"
						nuevo="RegistroNotasCreditoCP.cfm"
						ira="RegistroNotasCreditoCP.cfm" 
						botones="Aplicar,Nuevo,Importar_Facturas,Importar_Transito,Reporte"
						keys="IDdocumento"
						MaxRows="#Registros#"
						Navegacion="#Navegacion#">
					</cfinvoke> 
				<cfelseif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo EQ 'C'> <!--- C = Facturas en CxP  --->
                	<cf_dbfunction name="to_sdateDMY" args="a.EDfecha" returnvariable="LvarEDfecha">
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH" 
						tabla="EDocumentosCxP a
								inner join SNegocios b
									on b.SNcodigo = a.SNcodigo
									and b.Ecodigo = a.Ecodigo
								inner join CPTransacciones c
									 on c.CPTcodigo = a.CPTcodigo
									and c.Ecodigo = a.Ecodigo
									and c.CPTtipo = 'C'
								inner join Monedas m
									on m.Mcodigo = a.Mcodigo" 
						columnas="a.IDdocumento as IDdocumento, 
								b.SNidentificacion, 
								b.SNnombre, 
								c.CPTdescripcion, 
								a.EDdocumento, 
								a.EDusuario,
                                 #LvarEDfecha# as EDfecha,
								m.Miso4217 as Mnombre,
								a.EDtotal as EDtotal 
								#campos_extra#" 
						desplegar="CPTdescripcion, EDdocumento, EDusuario, EDfecha, Mnombre, EDtotal"
						etiquetas="Transacción, Documento, Usuario, Fecha, Moneda, Total"
						formatos="S,S,S,S,S,M"
						filtro= "#filtro#"
						cortes="SNnombre" 
						align="left, left, left,left, center, right"
						checkboxes="S"
						nuevo="RegistroFacturasCP.cfm"
						ira="RegistroFacturasCP.cfm" 
						botones="Aplicar,Nuevo,Importar_Facturas,Importar_Transito,Reporte"
						keys="IDdocumento"
						MaxRows="#Registros#"
						Navegacion="#Navegacion#">
					</cfinvoke> 
				</cfif>
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
<cfif isDefined("url.tipo") and len(Trim(url.tipo)) gt 0>
	<cfset form.tipo = url.tipo>
</cfif>
<cfset params = '' >
<cfif isdefined('form.tipo')>
	<cfset params = params & 'tipo=#form.tipo#'>
</cfif>
<script language="JavaScript1.2">
function Marcar(c) {
	if (document.lista.chk != undefined) { //existe?
		if (document.lista.chk.value != undefined) {// solo un check
			if (c.checked) document.lista.chk.checked = true; else document.lista.chk.checked = false;
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

function LimpiarFiltros(f) {
	f.Transaccion.selectedIndex = 0;
	f.Documento.value = "";
	f.Moneda.selectedIndex = 0;
	f.Fecha.selectedIndex = 0;
	f.Usuario.selectedIndex = 0;
}

/*  Funciones para el evento onclick de los botones */
function funcNuevo(){
	document.lista.modo.value = "ALTA";																		
	document.lista.TIPO.value = "<cfoutput>#trim(form.tipo)#</cfoutput>";									

	<cfoutput>
	<cfif isdefined("form.tipo") and len(trim(form.tipo)) >
		document.lista.TIPO.value = '#form.tipo#';
	</cfif>
	<cfif isdefined("form.registros") and len(trim(form.registros)) >
		document.lista.REGISTROS.value = '#form.registros#';
	</cfif>

	<cfif isdefined("form.pageNum_lista") and len(trim(form.pageNum_lista)) >
		document.lista.PAGENUM_LISTA.value = '#form.pageNum_lista#';
	</cfif>
	<cfif isdefined("form.Fecha") and len(trim(form.Fecha)) >
		document.lista.FECHA.value = '#form.Fecha#';
	</cfif>
	<cfif isdefined("form.Transaccion") and len(trim(form.Transaccion)) >
		document.lista.TRANSACCION.value = '#form.Transaccion#';
	</cfif>
	<cfif isdefined("form.Documento") and len(trim(form.Documento)) >
		document.lista.DOCUMENTO.value = '#form.Documento#';
	</cfif>
	<cfif isdefined("form.usuario") and len(trim(form.usuario)) >
		document.lista.USUARIO.value = '#form.usuario#';
	</cfif>
	<cfif isdefined("form.moneda") and len(trim(form.moneda)) >
		document.lista.MONEDA.value = '#form.moneda#';
	</cfif>
	</cfoutput>
	
	return true;
}

function funcAplicar(){
	document.lista.TIPO.value = "<cfoutput>#trim(form.tipo)#</cfoutput>";
	
	<cfoutput>
	<cfif isdefined("form.tipo") and len(trim(form.tipo)) >
		document.lista.TIPO.value = '#form.tipo#';
	</cfif>
	<cfif isdefined("form.registros") and len(trim(form.registros)) >
		document.lista.REGISTROS.value = '#form.registros#';
	</cfif>

	<cfif isdefined("form.pageNum_lista") and len(trim(form.pageNum_lista)) >
		document.lista.PAGENUM_LISTA.value = '#form.pageNum_lista#';
	</cfif>
	<cfif isdefined("form.Fecha") and len(trim(form.Fecha)) >
		document.lista.FECHA.value = '#form.Fecha#';
	</cfif>
	<cfif isdefined("form.Transaccion") and len(trim(form.Transaccion)) >
		document.lista.TRANSACCION.value = '#form.Transaccion#';
	</cfif>
	<cfif isdefined("form.Documento") and len(trim(form.Documento)) >
		document.lista.DOCUMENTO.value = '#form.Documento#';
	</cfif>
	<cfif isdefined("form.usuario") and len(trim(form.usuario)) >
		document.lista.USUARIO.value = '#form.usuario#';
	</cfif>
	<cfif isdefined("form.moneda") and len(trim(form.moneda)) >
		document.lista.MONEDA.value = '#form.moneda#';
	</cfif>
	</cfoutput>
	
}

function funcImportar_Facturas(){
	location.href = "listaDocumentosCP.cfm?dato=importarMateriaPrima";
	return false;
}

function funcImportar_Transito(){
	location.href = "listaDocumentosCP.cfm?dato=importarCrudo";
	return false;
}
function funcReporte(){
	location.href = "../reportes/DocumentosSinAplicarCP.cfm?Docs=1&<cfoutput>#params#</cfoutput>";
	return false;
}

/* fin de funciones para los botones */

</script>
</cfif>