<!--- Lista de Facturas y Notas de Crédito de CxC
	Modificado por: Ana Villavicencio R.
		Fecha: 11 de julio del 2005
		Motivo: Error en el filtro de la lista.  En cantidad de registro no aceptaba vacios.
		Lineas: 99 la comparacion  Trim(Form.Registros) NEQ "", antes no tenia nada.

- Modificado por Gustavo Fonseca H.
		Fecha: 4-8-2005
		Motivo: - Se modifica para arreglar la seguridad de CxC en los procesos de facturas y notas de crédito, para que seguridad sepa
				con cual de los dos procesos está trabajando. Esto porque se estaba trabajando con un archivo para los dos procesos.

	Modificado por: Ana Villavicencio
	Fecha: 10 de octubre del 2005
	Motivo: Se acomodó los encabezados de la lista. Se agregó estilo a los checkbox.
--->
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset MSG_FechasLim = t.Translate('MSG_Pantalla','Pantalla Cargada con errores. NO está definido el Tipo. Proceso Cancelado!')>
<cfset LB_Todos = t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset LB_Todas = t.Translate('LB_Todos','Todas','/sif/generales.xml')>
<cfset LB_TituloCr = t.Translate('LB_TituloCr','Registro de Documentos Crédito de CxC')>
<cfset LB_TituloDoc = t.Translate('LB_TituloDoc','Registro de Documentos de CxC')>
<cfset LB_ListaFac = t.Translate('LB_ListaFac','Lista de Facturas ')>
<cfset LB_ListaCred = t.Translate('LB_ListaCred','Lista de Notas de Crédito')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacción','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Usuario = t.Translate('LB_Usuario','Usuario','/sif/generales.xml')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Total = t.Translate('LB_Total','Total','/sif/generales.xml')>

<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
	<cfset form.Pagina = url.PageNum_Lista>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
	<cfset form.Pagina = form.PageNum>
</cfif>
<cfif isDefined("url.tipo") and len(Trim(url.tipo)) gt 0>
	<cfset form.tipo = url.tipo>
</cfif>
<cfif isDefined("LvarTipo") and len(Trim(LvarTipo)) gt 0>
	<cfset form.tipo = LvarTipo>
</cfif>
<cfif isDefined("url.Filtro_CCTdescripcion") and not isdefined('form.Filtro_CCTdescripcion')>
	<cfset form.Filtro_CCTdescripcion = url.Filtro_CCTdescripcion>
</cfif>
<cfif isDefined("url.Filtro_EDdocumento") and not isdefined('form.Filtro_EDdocumento')>
	<cfset form.Filtro_EDdocumento = url.Filtro_EDdocumento>
</cfif>
<cfif isDefined("url.Filtro_EDFecha") and not isdefined('form.Filtro_EDFecha')>
	<cfset form.Filtro_EDFecha = url.Filtro_EDFecha>
</cfif>
<cfif isDefined("url.Filtro_EDUsuario") and not isdefined('form.Filtro_EDUsuario')>
	<cfset form.Filtro_EDUsuario = url.Filtro_EDUsuario>
</cfif>
<cfif isDefined("url.Filtro_Mnombre") and not isdefined('form.Filtro_Mnombre')>
	<cfset form.Filtro_Mnombre = url.Filtro_Mnombre>
</cfif>
<cfif isDefined("url.Filtro_FechasMayores") and not isdefined('form.Filtro_FechasMayores')>
	<cfset form.Filtro_FechasMayores = url.Filtro_FechasMayores>
</cfif>
<cfset params = '' >
<cfif isdefined('form.tipo')>
	<cfset params = params & 'tipo=#form.tipo#'>
</cfif>
<cfif isdefined('form.Filtro_CCTdescripcion')>
	<cfset params = params & '&Filtro_CCTdescripcion=#form.Filtro_CCTdescripcion#'>
</cfif>
<cfif isdefined('form.Filtro_EDdocumento')>
	<cfset params = params & '&Filtro_EDdocumento=#form.Filtro_EDdocumento#'>
</cfif>
<cfif isdefined('form.Filtro_EDFecha')>
	<cfset params = params & '&Filtro_EDFecha=#form.Filtro_EDFecha#'>
</cfif>
<cfif isdefined('form.Filtro_EDUsuario')>
	<cfset params = params & '&Filtro_EDUsuario=#form.Filtro_EDUsuario#'>
</cfif>
<cfif isdefined('form.Filtro_Mnombre')>
	<cfset params = params & '&Filtro_Mnombre=#form.Filtro_Mnombre#'>
</cfif>
<cfif isdefined('form.hFiltro_CCTdescripcion')>
	<cfset params = params & '&hFiltro_CCTdescripcion=#form.hFiltro_CCTdescripcion#'>
<cfelseif isdefined('form.Filtro_CCTdescripcion')>
	<cfset params = params & '&hFiltro_CCTdescripcion=#form.Filtro_CCTdescripcion#'>
</cfif>
<cfif isdefined('form.hFiltro_EDdocumento')>
	<cfset params = params & '&hFiltro_EDdocumento=#form.hFiltro_EDdocumento#'>
<cfelseif isdefined('form.Filtro_EDdocumento')>
	<cfset params = params & '&hFiltro_EDdocumento=#form.Filtro_EDdocumento#'>
</cfif>
<cfif isdefined('form.hFiltro_EDFecha')>
	<cfset params = params & '&hFiltro_EDFecha=#form.hFiltro_EDFecha#'>
<cfelseif isdefined('form.Filtro_EDFecha')>
	<cfset params = params & '&hFiltro_EDFecha=#form.Filtro_EDFecha#'>
</cfif>
<cfif isdefined('form.hFiltro_EDUsuario')>
	<cfset params = params & '&hFiltro_EDUsuario=#form.hFiltro_EDUsuario#'>
<cfelseif isdefined('form.Filtro_EDUsuario')>
	<cfset params = params & '&hFiltro_EDUsuario=#form.Filtro_EDUsuario#'>
</cfif>
<cfif isdefined('form.hFiltro_Mnombre')>
	<cfset params = params & '&hFiltro_Mnombre=#form.hFiltro_Mnombre#'>
<cfelseif isdefined('form.Filtro_Mnombre')>
	<cfset params = params & '&hFiltro_Mnombre=#form.Filtro_Mnombre#'>
</cfif>
<cfif isdefined('form.Filtro_FechasMayores')>
	<cfset params = params & '&Filtro_FechasMayores=#form.Filtro_FechasMayores#'>
</cfif>
<cfif isdefined('form.Pagina')>
	<cfset params = params & '&Pagina=#form.Pagina#'>
</cfif>
<cfif not isdefined("form.tipo")>
	<cf_errorCode	code = "50185" msg = "#MSG_Pantalla#">
</cfif>
<cfif form.tipo eq "D">
	<cfset form.titulo = "#LB_ListaFac#">
<cfelse>
	<cfset form.titulo = "#LB_ListaCred#">
</cfif>

<cfparam name="Form.tipo" default="D">
<cfparam name="Form.Fecha" default="">
<cfparam name="Form.Transaccion" default="">
<cfparam name="Form.Documento" default="">
<cfparam name="Form.Usuario" default="">
<cfparam name="Form.Moneda" default="">
<cfparam name="Form.MaxRows" default="25">

<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select '' as value, '#LB_Todas#' as description from dual
	union all
	select CCTcodigo as value, CCTdescripcion as description
	from CCTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and CCTtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo#">
	  and coalesce(CCTpago,0) != 1
	order by 1
</cfquery>

<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> as value, '#LB_Todas#' as description from dual
	union all
	select <cf_dbfunction name='to_char' args="b.Mcodigo" isNumber="yes"> as value, b.Miso4217 as description
	from Monedas b
	where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by 1
</cfquery>

<cfquery name="rsUsuarios" datasource="#Session.DSN#">
	select '' as value, '#LB_Todos#' as description from dual
	union all
	select distinct EDusuario as value, EDusuario as description
	from EDocumentosCxC
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and CCTcodigo in (
		select t.CCTcodigo
		from CCTransacciones t
		where t.Ecodigo = #session.Ecodigo#
		  and t.CCTtipo = '#form.tipo#'
		and coalesce(t.CCTpago, 0) != 1)
	order by 1
</cfquery>

<cfset navegacion = "tipo=#form.tipo#&maxrows=#form.maxrows#">
<cfparam name="form.Pagina" default="1">
<cfset LvarTitulo = "#LB_TituloDoc#">
<cfif Form.tipo EQ "C">
	<cfset LvarTitulo = "#LB_TituloCr#">
</cfif>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cf_templateheader title="#LvarTitulo#">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
	<cf_web_portlet_start titulo="<cfoutput>#LvarTitulo#</cfoutput>">
			<form name="lista" action="listaDocumentosCC.cfm" method="post" style="margin:0;">
			<cfoutput>
			<input name="tipo" type="hidden" value="#form.tipo#">
			<input name="Pagina" type="hidden" value="#form.Pagina#">
			<input name="MaxRows" type="hidden" value="#form.MaxRows#">
			</cfoutput>

			<cfif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo EQ 'D'><!--- D = Facturas en CxC --->
				<cfinvoke
					component="sif.Componentes.pListas"
					method="pLista" >
					<cfinvokeargument name="columnas"  			value="	EDid,
																		b.SNnumero,
																		b.SNidentificacion,
																		b.SNnombre,
																		c.CCTdescripcion,
																		a.EDdocumento,
																		a.EDusuario,
																		a.EDfecha as EDfecha,
																		m.Miso4217 as Mnombre,
																		a.EDtotal as EDtotal,
																		'' as esp"/>
					<cfinvokeargument name="tabla"  			value="EDocumentosCxC a, SNegocios b, CCTransacciones c, Monedas m"/>
					<cfinvokeargument name="filtro"  			value="a.Ecodigo = #Session.Ecodigo#
																		and c.CCTtipo = '#form.tipo#'
																		and coalesce(c.CCTpago, 0) != 1
																		and a.SNcodigo = b.SNcodigo
																		and a.CCTcodigo = c.CCTcodigo
																		and a.Ecodigo = b.Ecodigo
																		and a.Ecodigo = c.Ecodigo
																		and a.Mcodigo = m.Mcodigo
																		Order by SNnombre"/>
					<cfinvokeargument name="desplegar"  		value="CCTdescripcion, EDdocumento, EDusuario, Mnombre, EDfecha, EDtotal,esp"/>
					<cfinvokeargument name="filtrar_por"		value="a.CCTcodigo,EDdocumento,EDusuario,a.Mcodigo,EDfecha,EDtotal,esp"/>
					<cfinvokeargument name="etiquetas"  		value="#LB_Transaccion#, #LB_Documento#, #LB_Usuario#, #LB_Moneda#, #LB_Fecha#, #LB_Total#, "/>
					<cfinvokeargument name="formatos"  			value="S,S,S,S,D,UM,U"/>
					<cfinvokeargument name="cortes"  			value="SNnombre" />
					<cfinvokeargument name="align"  			value="left, left, left, left, left, right,center"/>
					<cfinvokeargument name="checkboxes"  		value="S"/>
					<cfinvokeargument name="nuevo"  			value="RegistroFacturas.cfm"/>
					<cfinvokeargument name="ira"  				value="RegistroFacturas.cfm"/>
					<cfinvokeargument name="botones"  			value="Aplicar,Nuevo,Importar_Ventas,Reporte"/>
					<cfinvokeargument name="keys"  				value="EDid" />
					<cfinvokeargument name="maxrows"  			value="#Form.MaxRows#"/>
					<cfinvokeargument name="navegacion"  		value="#Navegacion#"/>
					<cfinvokeargument name="mostrar_filtro"  	value="true"/>
					<cfinvokeargument name="filtrar_automatico"	value="true"/>
					<cfinvokeargument name="tabindex"  			value="1"/>
					<cfinvokeargument name="rsCCTdescripcion" 	value="#rsTransacciones#"/>
					<cfinvokeargument name="rsMnombre" 			value="#rsMonedas#"/>
					<cfinvokeargument name="rsEDusuario"		value="#rsUsuarios#"/>
					<cfinvokeargument name="formName"			value="lista"/>
					<cfinvokeargument name="incluyeform" 		value="false"/>
				 </cfinvoke>
			<cfelseif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo EQ 'C'> <!--- C = Notas de Crédito en CxC  --->
				<cfinvoke
					component="sif.Componentes.pListas"
					method="pLista" >
					<cfinvokeargument name="columnas"  			value="	EDid,
																		b.SNnumero,
																		b.SNidentificacion,
																		b.SNnombre,
																		c.CCTdescripcion,
																		a.EDdocumento,
																		a.EDusuario,
																		a.EDfecha as EDfecha,
																		m.Miso4217 as Mnombre,
																		a.EDtotal as EDtotal,
																		'' as esp"/>
					<cfinvokeargument name="tabla"  			value="EDocumentosCxC a, SNegocios b, CCTransacciones c, Monedas m"/>
					<cfinvokeargument name="filtro"  			value="a.Ecodigo = #Session.Ecodigo#
																		and c.CCTtipo = '#form.tipo#'
																		and coalesce(c.CCTpago, 0) != 1
																		and a.SNcodigo = b.SNcodigo
																		and a.CCTcodigo = c.CCTcodigo
																		and a.Ecodigo = b.Ecodigo
																		and a.Ecodigo = c.Ecodigo
																		and a.Mcodigo = m.Mcodigo
																		Order by SNnombre"/>
					<cfinvokeargument name="desplegar"  		value="CCTdescripcion, EDdocumento, EDusuario, Mnombre, EDfecha, EDtotal, esp"/>
					<cfinvokeargument name="filtrar_por"		value="a.CCTcodigo,EDdocumento,EDusuario,a.Mcodigo,EDfecha,EDtotal,esp"/>
					<cfinvokeargument name="etiquetas"  		value="#LB_Transaccion#, #LB_Documento#, #LB_Usuario#, #LB_Moneda#, #LB_Fecha#, #LB_Total#, "/>
					<cfinvokeargument name="formatos"  			value="S,S,S,S,D,UM,U"/>
					<cfinvokeargument name="cortes"  			value="SNnombre" />
					<cfinvokeargument name="align"  			value="left, left, left, left, left, right,center"/>
					<cfinvokeargument name="checkboxes"  		value="S"/>
					<cfinvokeargument name="nuevo"  			value="RegistroNotasCredito.cfm"/>
					<cfinvokeargument name="ira"  				value="RegistroNotasCredito.cfm"/>
					<cfinvokeargument name="botones"  			value="Aplicar,Nuevo,Importar_Ventas,Reporte"/>
					<cfinvokeargument name="keys"  				value="EDid"/>
					<cfinvokeargument name="maxrows"  			value="#Form.MaxRows#"/>
					<cfinvokeargument name="navegacion"  		value="#Navegacion#"/>
					<cfinvokeargument name="mostrar_filtro"  	value="true"/>
					<cfinvokeargument name="filtrar_automatico" value="true"/>
					<cfinvokeargument name="tabindex"  			value="1"/>
					<cfinvokeargument name="rsCCTdescripcion" 	value="#rsTransacciones#"/>
					<cfinvokeargument name="rsMnombre" 			value="#rsMonedas#"/>
					<cfinvokeargument name="rsEDusuario"		value="#rsUsuarios#"/>
					<cfinvokeargument name="formName"			value="lista"/>
					<cfinvokeargument name="incluyeform" 		value="false"/>
				</cfinvoke>
			</cfif>
		</form>


		<cf_web_portlet_end>
		<script language="JavaScript" type="text/javascript">

			/*  Funciones para el evento onclick de los botones */
			function funcNuevo(){
				var parametros = "<cfoutput>#params#</cfoutput>" + "&EDid=";
				if(document.lista.tipo.value == 'D')
					location.href ='RegistroFacturas.cfm?' + parametros;
				else location.href ='RegistroNotasCredito.cfm?'  + parametros;
				return false;
			}

			function funcAplicar(){
				document.lista.tipo.value = "<cfoutput>#trim(form.tipo)#</cfoutput>";

				<cfoutput>
				<cfif isdefined("form.tipo") and len(trim(form.tipo)) >
					document.lista.tipo.value = '#form.tipo#';
				</cfif>
				<cfif isdefined("form.filtro_MaxRows") and len(trim(form.filtro_MaxRows)) >
					document.lista.MaxRows.value = '#form.MaxRows#';
				</cfif>

				<cfif isdefined("form.Pagina") and len(trim(form.Pagina)) >
					document.lista.Pagina.value = '#form.Pagina#';
				</cfif>
				<cfif isdefined("form.filtro_EDfecha") and len(trim(form.filtro_EDfecha)) >
					document.lista.filtro_EDfecha.value = '#form.filtro_EDfecha#';
				</cfif>
				<cfif isdefined("form.filtro_CCTdescripcion") and len(trim(form.filtro_CCTdescripcion)) >
					document.lista.filtro_CCTdescripcion.value = '#form.filtro_CCTdescripcion#';
				</cfif>
				<cfif isdefined("form.filtro_EDdocumento") and len(trim(form.filtro_EDdocumento)) >
					document.lista.filtro_EDdocumento.value = '#form.filtro_EDdocumento#';
				</cfif>
				<cfif isdefined("form.filtro_EDusuario") and len(trim(form.filtro_EDusuario)) >
					document.lista.filtro_EDusuario.value = '#form.filtro_EDusuario#';
				</cfif>
				<cfif isdefined("form.filtro_Mnombre") and len(trim(form.filtro_Mnombre)) >
					document.lista.filtro_Mnombre.value = '#form.filtro_Mnombre#';
				</cfif>
				<cfif isdefined("form.Filtro_FechasMayores") and len(trim(form.Filtro_FechasMayores)) >
					document.lista.Filtro_FechasMayores.value = '#form.Filtro_FechasMayores#';
				</cfif>
				if(document.lista.tipo.value == 'D')document.lista.action ='RegistroFacturas.cfm';
				else document.lista.action ='RegistroNotasCredito.cfm';
				</cfoutput>
			}

			function funcImportar_Ventas(){
				var parametros = "<cfoutput>#params#</cfoutput>";
				location.href = "ImportadorVentas.cfm?" + parametros;
				return false;
			}

			function funcReporte(){
				location.href = "../reportes/DocumentosSinAplicar.cfm?Docs=1&<cfoutput>#params#</cfoutput>";
				return false;
			}
			/* fin de funciones para los botones */
		</script>
	<cf_templatefooter>


