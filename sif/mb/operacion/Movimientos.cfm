<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ListaDetalleMovimiento" default="Lista de Detalles del Movimiento" returnvariable="LB_ListaDetalleMovimiento" xmlfile="Movimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cuenta" default="Cuenta" returnvariable="LB_Cuenta" xmlfile="Movimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Codigo" xmlfile="Movimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Monto" default="Monto" returnvariable="LB_Monto" xmlfile="Movimientos.xml"/>

<cfif isdefined('LvarTCE') and len(trim(#LvarTCE#)) gt 0><!---  varTCE  indica si es un reporte para TCE--->
<cfset _Pagina = 'TCEMovimientos.cfm'>
<cfset _PaginaLista = 'TCEListaMovimientos.cfm'>
<cfset _PaginaForm = 'TCEformMovimientos.cfm'>
<cfset _LvarCBesTCE = 1>
<cfelse>
<cfset _Pagina = 'Movimientos.cfm'>
<cfset _PaginaLista = 'listaMovimientos.cfm'>
<cfset _PaginaForm = 'formMovimientos.cfm'>
<cfset _LvarCBesTCE = 0>
</cfif>

<cfif isdefined("url.EMid") and len(trim(url.EMid))>
	<cfset form.EMid = url.EMid>
</cfif>

<cfif isdefined("url.Nuevo") and len(trim(url.Nuevo))>
	<cfset form.Nuevo = url.Nuevo>
</cfif>

<cfif isdefined("url.DMlinea") and len(trim(url.DMlinea))>
	<cfset form.DMlinea = url.DMlinea>
</cfif>

<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
	<cfset url.PAGENUM_LISTA2 = url.Pagina>
</cfif>

<cfif isdefined("url.PAGENUM_LISTA2") and len(trim(url.PAGENUM_LISTA2))>
	<cfset form.PAGENUM_LISTA2 = url.PAGENUM_LISTA2>
</cfif>

<!--- 	VALIDA QUE ESTE EN ESTA PANTALLA CORRECTAMENTE --->
<cfif 	NOT (
			isdefined('Form.EMid') and len(trim(Form.EMid))
			or
			isdefined('Form.btnNuevo')
			or
			isdefined('Form.Nuevo')
			or
			isdefined('Form.btnAplicar')
		)>
	<cflocation addtoken="no" url='#_PaginaLista#'>
</cfif>

<!--- 	APLICA EL MOVIMIENTO --->
<cfif isdefined("Form.chk") AND isdefined("form.btnAplicar") >
	<cfset lista = ListToArray(Form.chk)>

	<cfloop from="1" to="#ArrayLen(lista)#" index="item">
		<!--- APLICACIÓN DEL MB, SE GUARDA EN LAS TABLAS HISTORICAS! --->

		<cfquery datasource="#Session.DSN#">
			delete from HDMovimientos
			WHERE EMid = <cfqueryparam value="#lista[item]#" cfsqltype="cf_sql_integer">
			  AND Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfquery datasource="#Session.DSN#">
			DELETE FROM HEMovimientos
			WHERE EMid = <cfqueryparam value="#lista[item]#" cfsqltype="cf_sql_integer">
			  AND Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		</cfquery>


		<cfquery datasource="#Session.DSN#" name="insertHDMovimientos">
			INSERT INTO HDMovimientos (EMid, DMlinea, Ecodigo, Ccuenta, Dcodigo, CFid, DMmonto, DMdescripcion, BMUsucodigo, PCGDid, CFcuenta, Icodigo)
			SELECT EMid,
			       DMlinea,
			       Ecodigo,
			       Ccuenta,
			       Dcodigo,
			       CFid,
			       DMmonto,
			       DMdescripcion,
			       BMUsucodigo,
			       PCGDid,
			       CFcuenta,
			       Icodigo
			FROM DMovimientos
			WHERE EMid = <cfqueryparam value="#lista[item]#" cfsqltype="cf_sql_integer">
			  AND Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfquery datasource="#Session.DSN#" name="insertHEMovimientos">
			INSERT INTO HEMovimientos (EMid, BTid, Ecodigo, CBid, CFid, Ocodigo, EMtipocambio, EMdocumento, EMtotal, EMreferencia, EMfecha, EMdescripcion, EMusuario, EMselect, BMUsucodigo, SNcodigo, id_direccion, TpoSocio, TpoTransaccion, Documento, SNid, CDCcodigo, EMdescripcionOD, EMBancoIdOD, Tipo, EMNombreBenefic, EMRfcBenefic, EMdocumentoRef, ERNid, EIid, CodTipoPago)
			SELECT EMid,
			       BTid,
			       Ecodigo,
			       CBid,
			       CFid,
			       Ocodigo,
			       EMtipocambio,
			       EMdocumento,
			       EMtotal,
			       EMreferencia,
			       EMfecha,
			       EMdescripcion,
			       EMusuario,
			       EMselect,
			       BMUsucodigo,
			       SNcodigo,
			       id_direccion,
			       TpoSocio,
			       TpoTransaccion,
			       Documento,
			       SNid,
			       CDCcodigo,
			       EMdescripcionOD,
			       EMBancoIdOD,
			       Tipo,
			       EMNombreBenefic,
			       EMRfcBenefic,
			       EMdocumentoRef,
			       ERNid,
			       EIid,
			       CodTipoPago
			FROM EMovimientos
			WHERE EMid = <cfqueryparam value="#lista[item]#" cfsqltype="cf_sql_integer">
			  AND Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfinvoke component="sif.Componentes.CP_MBPosteoMovimientosB" method="PosteoMovimientos">
			<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
			<cfinvokeargument name="EMid" value="#lista[item]#"/>
			<cfinvokeargument name="usuario" value="#session.usucodigo#"/>
			<cfinvokeargument name="debug" value="N"/>
            <cfinvokeargument name="ubicacion" value="#_LvarCBesTCE#"/>
		</cfinvoke>
	</cfloop>

	<cfset navegacion_lista = '&pagenum_lista=1' >
	<cfif isdefined("form.pagenum_lista") >
		<cfset navegacion_lista = '&pagenum_lista=#form.pagenum_lista#' >
	</cfif>

	<cfif isdefined("form.pagenum_lista2") >
		<cfset navegacion_lista = navegacion_lista & '&pagenum_lista2=#form.pagenum_lista2#' >
	</cfif>
	<cfif isdefined("form.filtro_DMdescripcion") >
		<cfset navegacion_lista = navegacion_lista & '&filtro_DMdescripcion=#form.filtro_DMdescripcion#' >
	</cfif>
	<cfif isdefined("form.filtro_Cdescripcion") >
		<cfset navegacion_lista = navegacion_lista & '&filtro_Cdescripcion=#form.filtro_Cdescripcion#' >
	</cfif>

	<cfif isdefined("form.filtro_EMdocumento") >
		<cfset navegacion_lista = navegacion_lista & '&filtro_EMdocumento=#form.filtro_EMdocumento#' >
	</cfif>
	<cfif isdefined("form.filtro_CBid") >
		<cfset navegacion_lista = navegacion_lista & '&filtro_CBid=#form.filtro_CBid#' >
	</cfif>
	<cfif isdefined("form.filtro_BTid") >
		<cfset navegacion_lista = navegacion_lista & '&filtro_BTid=#form.filtro_BTid#' >
	</cfif>
	<cfif isdefined("form.filtro_EMdescripcion") >
		<cfset navegacion_lista = navegacion_lista & '&filtro_EMdescripcion=#form.filtro_EMdescripcion#' >
	</cfif>
	<cfif isdefined("form.filtro_EMfecha") >
		<cfset navegacion_lista = navegacion_lista & '&filtro_EMfecha=#form.filtro_EMfecha#' >
	</cfif>
	<cfif isdefined("form.filtro_usuario") >
		<cfset navegacion_lista = navegacion_lista & '&filtro_usuario=#form.filtro_usuario#' >
	</cfif>

	<cflocation addtoken="no" url="#_PaginaLista#?sqlDone=ok#navegacion_lista#">
</cfif>



<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="navegacion">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>

<cfinvoke component="sif.Componentes.TranslateDB"
    method="Translate"
    VSvalor="#nav__SScodigo#.#nav__SMcodigo#.#nav__SPcodigo#"
    Default="#nav__SPdescripcion#"
    VSgrupo="103"
    Idioma="#session.idioma#"
    returnvariable="translated_Title"/>

<cf_templateheader title="#translated_Title#">
	<cfoutput>#navegacion#</cfoutput>
	<cf_web_portlet_start titulo="<cfoutput>#translated_Title#</cfoutput>">
		<cfinclude template="formMovimientos.cfm">
		<cfif isdefined('Form.EMid') and len(trim(Form.EMid)) and rsForm.TpoSocio eq 0>
		<table   id="tabla" width="98%" align="center"  border="0" cellspacing="0" cellpadding="0" style="border:0px;">
		  <tr>
			<td>
			<fieldset><legend><cfoutput>#LB_ListaDetalleMovimiento#</cfoutput></legend>
			<cfset navegacion = "&EMid=#form.EMid#">
			<cfif isdefined("navegacionDetalle")>
				<cfset navegacion = "&EMid=#form.EMid##navegacionDetalle#">
			</cfif>

			<!--- ========================================= --->
			<!--- MANTIENE LOS FILTROS DE LA LISTA PRINCIPAL --->
			<!--- ========================================= --->
			<cfif isdefined("form.pagenum_lista") >
				<cfset camposExtra = "'#form.pagenum_lista#' as pagenum_lista" >
			<cfelse>
				<cfset camposExtra = "'1' as pagenum_lista" >
			</cfif>

			<cfif isdefined("form.filtro_EMdocumento") >
				<cfset camposExtra = camposExtra & " , '#form.filtro_EMdocumento#' as filtro_EMdocumento" >
			</cfif>
			<cfif isdefined("form.filtro_CBid") >
				<cfset camposExtra = camposExtra & ", '#form.filtro_CBid#' as filtro_CBid">
			</cfif>
			<cfif isdefined("form.filtro_BTid") >
				<cfset camposExtra = camposExtra & ", '#form.filtro_BTid#' as filtro_BTid">
			</cfif>
			<cfif isdefined("form.filtro_EMdescripcion") >
				<cfset camposExtra = camposExtra & ", '#form.filtro_EMdescripcion#' as filtro_EMdescripcion">
			</cfif>
			<cfif isdefined("form.filtro_EMfecha") >
				<cfset camposExtra = camposExtra & ", '#form.filtro_EMfecha#' as filtro_EMfecha">
			</cfif>
			<cfif isdefined("form.filtro_usuario") >
				<cfset camposExtra = camposExtra & ", '#form.filtro_usuario#' as filtro_usuario">
			</cfif>
			<cfif isdefined("url.pagenum_lista2") and not isdefined("form.pagenum_lista2") >
				<cfset form.pagenum_lista2 = url.pagenum_lista2 >
			</cfif>
			<cfif isdefined("form.pagenum_lista2") >
				<cfset camposExtra = camposExtra & ", '#form.pagenum_lista2#' as pagenum_lista2">
			</cfif>

			<cfif isdefined("url.sqlDone")>
			<cfif not isdefined('LvarTCE')>
				<cfif isdefined("form.filtro_DMdescripcion") >
					<cfset form.hfiltro_DMdescripcion = form.filtro_DMdescripcion >
				</cfif>
			</cfif>
				<cfif isdefined("form.filtro_Cdescripcion") >
					<cfset form.hfiltro_Cdescripcion = form.filtro_Cdescripcion >
				</cfif>
			</cfif>
			<cf_dbfunction name="concat" args="CFformato,' ',Cdescripcion" returnvariable="LvarCFdescripcion">
			<cf_dbfunction name="concat" args="Cformato,' ',Cdescripcion" returnvariable="LvarCdescripcion">

			<cfinvoke component="sif.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="DMovimientos dm
				                                         inner join CContables cc
														  on  dm.Ccuenta=cc.Ccuenta
														  left join CFinanciera cf
														  on dm.CFcuenta = cf.CFcuenta"/>
				<cfinvokeargument name="columnas" value="DMlinea, EMid, DMdescripcion,
									coalesce(CFformato,Cformato) as CFformato,
									coalesce(CFdescripcion,Cdescripcion) as CFdescripcion,
									DMmonto, #camposExtra#"/>
				<cfinvokeargument name="desplegar" value="DMdescripcion, CFformato, CFdescripcion, DMmonto"/>
				<cfinvokeargument name="etiquetas" value="#LB_Descripcion#, #LB_Cuenta#, #LB_Descripcion#, #LB_Monto#"/>
				<cfinvokeargument name="totales" value="DMmonto"/>
				<cfinvokeargument name="filtro" value="dm.EMid=#form.EMid# and dm.Ecodigo=#session.Ecodigo# order by DMlinea"/>
				<cfinvokeargument name="align" value="left, left, left, left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="#_Pagina#?EMid=#form.EMid#"/>
				<cfinvokeargument name="keys" value="EMid, DMlinea"/>
				<cfinvokeargument name="PageIndex" value="2"/>
				<cfinvokeargument name="formatos" value="S, S, S, M"/>
				<cfinvokeargument name="mostrar_filtro" value="true"/>
				<cfinvokeargument name="filtrar_automatico" value="true"/>
				<cfinvokeargument name="QueryString_lista" value="&#CGI.QUERY_STRING#"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="maxrows" value="30"/>
			</cfinvoke>
			<cfoutput>
			<script language="javascript">
				function funcFiltrar2(){
					document.lista.EMID.value="#Form.EMid#";

					<cfif isdefined("form.filtro_EMdocumento") >
						document.lista.FILTRO_EMDOCUMENTO.value = '#JSStringFormat(form.filtro_EMdocumento)#';
					</cfif>
					<cfif isdefined("form.filtro_CBid") >
						document.lista.FILTRO_CBID.value = '#JSStringFormat(form.filtro_CBid)#';
					</cfif>
					<cfif isdefined("form.filtro_BTid") >
						document.lista.FILTRO_BTID.value = '#JSStringFormat(form.filtro_BTid)#';
					</cfif>
					<cfif isdefined("form.filtro_EMdescripcion") >
						document.lista.FILTRO_EMDESCRIPCION.value = '#JSStringFormat(form.filtro_EMdescripcion)#';
					</cfif>
					<cfif isdefined("form.filtro_EMfecha") >
						document.lista.FILTRO_EMFECHA.value = '#JSStringFormat(form.filtro_EMfecha)#';
					</cfif>
					<cfif isdefined("form.filtro_usuario") >
						document.lista.FILTRO_USUARIO.value = '#JSStringFormat(form.filtro_usuario)#';
					</cfif>
					<cfif isdefined("form.pagenum_lista") >
						document.lista.PAGENUM_LISTA.value = '#JSStringFormat(form.pagenum_lista)#';
					</cfif>

					<cfif isdefined("form.pagenum_lista2") >
						document.lista.PAGENUM_LISTA2.value = '#JSStringFormat(form.pagenum_lista2)#';
					</cfif>

					return true;
				}

				/* ============================ */
				<cfif not isdefined('LvarTCE')>
				document.lista.filtro_DMdescripcion.tabIndex = 4;
				</cfif>
				<!---document.lista.filtro_Cdescripcion.tabIndex = 4;--->
				document.lista.filtro_DMmonto.tabIndex = 4;
				//document.lista.Filtrar.tabIndex = 4;
			</script>
			</cfoutput>
			</fieldset>
			</td>
		  </tr>
		</table>
		<br>
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>