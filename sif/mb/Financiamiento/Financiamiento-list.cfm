<!--- =============================================================== --->
<!---   Autor: 	Rodrigo Rivera                                        --->
<!---	Nombre: Arrendamiento                                         --->
<!---	Fecha: 	28/03/2014              	                          --->
<!--- =============================================================== --->
<!---  Modificado por: Andres Lara                						  --->
<!---	Nombre: Financiamiento                                         --->
<!---	Fecha: 	02/04/2014              	                          --->
<!--- =============================================================== --->
<!---                       Navegacion		                     	  --->
<!--- =============================================================== --->

    <cf_navegacion name="Fecha" 		default="">
    <cf_navegacion name="Documento" 	default="">
    <cf_navegacion name="Usuario" 		default="">
    <cf_navegacion name="Registros" 	default="20">
    <cf_navegacion name="Moneda" 		default="-1">
    <cf_navegacion name="pageNum_lista" default="1">
    <cf_navegacion name="IDFinan" 		default="-1">
    <cf_navegacion name="titulo" 		default="Lista de Financiamiento">
    <cf_navegacion name="Botones" 		default="Aplicar,Nuevo">
    <cf_navegacion name="FiltroExtra" 	default="">

    <cfset campos_extra = ", #form.Registros#' as Registros, '#form.pageNum_lista#' as pageNum_lista" >
    <cfif len(trim(Form.Fecha))> 		<cfset campos_extra = campos_extra & ", '#form.Fecha#' as fecha" ></cfif>
    <cfif len(trim(Form.Documento))>	<cfset campos_extra = campos_extra & ", '#form.Documento#' as documento" ></cfif>
    <cfif len(trim(Form.Usuario))>		<cfset campos_extra = campos_extra & ", '#form.usuario#' as usuario" ></cfif>
    <cfif len(trim(Form.Moneda)) and Form.Moneda gte 0><cfset campos_extra = campos_extra & ", '#form.moneda#' as moneda" ></cfif>

    <cfset filtro = "a.Ecodigo = #Session.Ecodigo#">
    <cfset Fecha       = "Todos">
    <cfset Documento   = "">
    <cfset Usuario     = "Todos">
    <cfset Moneda      = "Todos">
    <cfset Registros   = 20>
    <cfset Navegacion  = Navegacion >
    <cfset params 	   = ''>
<!--- =============================================================== --->
<!---                       Definicion Filtros                     	  --->
<!--- =============================================================== --->
    <cfif isDefined("Form.Fecha") and Trim(Form.Fecha) NEQ "" and Trim(Form.Fecha) NEQ "Todos">
        <cfset filtro = filtro & " and convert(varchar(10),a.Periodo,101) = '" & Trim(Form.Fecha) & "'" >
        <cfset Fecha = Trim(Form.Fecha)>
    </cfif>
    <cfif isDefined("Form.Documento") and Trim(Form.Documento) NEQ "">
        <cfset filtro = filtro & " and upper(a.Documento) like '%" & Ucase(Trim(Form.Documento)) & "%'" >
        <cfset Documento = Trim(Form.Documento)>
    </cfif>
    <cfif isDefined("Form.Usuario") and Trim(Form.Usuario) NEQ "" and Trim(Form.Usuario) NEQ "Todos">
        <cfset filtro = filtro & " and u.Usulogin = '" & Trim(Form.Usuario) & "'" >
        <cfset Usuario = Trim(Form.Usuario)>
    </cfif>
    <cfif isDefined("Form.Moneda") and Trim(Form.Moneda) NEQ "-1" and trim(Form.Moneda) NEQ "" and Trim(Form.Moneda) NEQ "Todos">
        <cfset filtro = filtro & " and a.Mcodigo = " & Trim(Form.Moneda) >
        <cfset Moneda = Trim(Form.Moneda)>
    </cfif>
    <cfif isDefined("Form.Registros") and Trim(Form.Registros) NEQ "">
        <cfset Registros = Form.Registros>
    </cfif>
        <cfset filtro = filtro & FiltroExtra & " Order by Bdescripcion, Documento">

    <cfquery name="rsMonedas" datasource="#Session.DSN#" cachedwithin="#CreateTimeSpan(0,0,10,0)#">
        select b.Mcodigo as Mcodigo, b.Miso4217 as Mnombre
        from Monedas b
        where b.Ecodigo = #Session.Ecodigo#
    </cfquery>

    <cfquery name="rsTiposTran" datasource="#Session.DSN#" cachedwithin="#CreateTimeSpan(0, 0, 10, 0)#">
        select CPTcodigo as CPTcodigo
        from CPTransacciones
        where Ecodigo = #session.ecodigo#
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
<!--- =============================================================== --->
<!---                       Translate                             	  --->
<!--- =============================================================== --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_EncPago 	= t.Translate('LB_EncPago','Encabezado de Pago')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacción','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Buque')>
<cfset LB_LineaC 	= t.Translate('LB_LineaC','Linea de Cr&eacute;dito','/sif/generales.xml')>
<cfset LB_Usuario 	= t.Translate('LB_Usuario','Usuario','/sif/generales.xml')>
<cfset LB_TipoCambio= t.Translate('LB_TipoCambio','TipoCambio','/sif/generales.xml')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Registros	= t.Translate('LB_Registros','Registros')>
<cfset LB_Fecha 	= t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Todos 	= t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset LB_Todas 	= t.Translate('LB_Todas','Todas','/sif/generales.xml')>
<cfset LB_SelTodos 	= t.Translate('LB_SelTodos','Seleccionar Todos')>
<cfset LB_Total 	= t.Translate('LB_Total','Total','/sif/generales.xml')>
<cfset MSG_SePrErr	= t.Translate('MSG_SePrErr','Sepresentaron los siguientes errores')>
<cfset MSG_MarcApl	= t.Translate('MSG_MarcApl','Debe marcar uno o más registros, de la lista para Aplicar.')>
<cfset MSG_MarcEnv	= t.Translate('MSG_MarcEnv','Debe marcar uno o más registros, de la lista para Enviar a Aplicar.')>
<cfset MSG_Anular	= t.Translate('MSG_Anular','Debe marcar uno o más registros, de la lista para Anular.')>
<cfset MSG_Imprimir	= t.Translate('MSG_Imprimir','Debe marcar uno o más registros, de la lista para imprimir su trámite.')>
<cfset LB_btnFiltrar= t.Translate('LB_btnFiltrar','Filtrar','/sif/generales.xml')>
<cfset LB_btnLimpiar= t.Translate('LB_btnLimpiar','Limpiar','/sif/generales.xml')>

<cf_templateheader title="SIF - Bancos">
	<cfinclude template="../../portlets/pNavegacion.cfm">
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#titulo#'>
	 <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>

<!--- =============================================================== --->
<!---                       Forma                               	  --->
<!--- =============================================================== --->
				<form style="margin: 0" name="filtros" action="<cfoutput>#URLira#</cfoutput>" method="post">
                    <input name="URLira" id="URLira" type="hidden" value="<cfoutput>#URLira#</cfoutput>">
					<table width="100%" border="0" cellspacing="2" cellpadding="0" class="areaFiltro">
						<tr>
                        <cfoutput>
							<td width="4%">&nbsp;</td>
							<td><strong>#LB_Documento#</strong></td>
							<td><strong>#LB_Usuario#</strong></td>
							<td><strong>#LB_Fecha#</strong></td>
							<td><strong>#LB_Moneda#</strong></td>
							<td><strong>#LB_Registros#</strong></td>
							<td>&nbsp;</td>
                        </cfoutput>
						</tr>
						<tr>
							<td>&nbsp;</td>
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
								<input name="Limpiar" type="button" class="btnLimpiar" value="#LB_btnLimpiar#" onClick="javascript: LimpiarFiltros(this.form);">
							</td>
							</cfoutput>
						</tr>
					</table>
				</form>
			</td>
		  </tr>
		  <tr>
			<!---td><strong>&nbsp;&nbsp;&nbsp;<input name="chkTodos" type="checkbox" value="" border="1" onClick="javascript:Marcar(this);"><cfoutput>#LB_SelTodos#</cfoutput></strong></td--->
		  </tr>
		  <tr>
			<cfflush interval="64">
			<td>
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH">
						<cfinvokeargument name="tabla" value="EncFinanciamiento a
								left join DetFinanciamiento d on a.IDFinan = d.IDFinan
								inner join Bancos b
									on b.Bid = a.Bid
									and b.Ecodigo = a.Ecodigo
								inner join Monedas m
									on m.Mcodigo = a.Mcodigo
								inner join Usuario u
									on a.BMUsucodigo = u.Usucodigo and StatusE = 0">
						<cfinvokeargument name="columnas" value="a.IDFinan,
								b.Bdescripcion,
								a.LineaC,
								a.Documento,
								a.TipoCambio,
								a.Periodo,
								u.Usulogin,
								m.Miso4217 as Mnombre,
                                '#URLira#' as URLira">
						<cfinvokeargument name="desplegar" 	value="Documento, LineaC, TipoCambio, Usulogin, Mnombre">
						<cfinvokeargument name="etiquetas" 	value="#LB_Documento#, #LB_LineaC#, #LB_TipoCambio#, #LB_Usuario#, #LB_Moneda#">
						<cfinvokeargument name="formatos" 	value="S,S,N,S,S">
						<cfinvokeargument name="filtro" 	value="#filtro#">
						<cfinvokeargument name="cortes" 	value="Bdescripcion">
						<cfinvokeargument name="align" 		value="left, center, center, center, center">
						<cfinvokeargument name="ira" 		value="#URLira#?&mododet=Cambio">
						<cfinvokeargument name="botones" 	value="#Botones#">
						<cfinvokeargument name="keys" 		value="IDFinan">
						<cfinvokeargument name="MaxRows" 	value="#Registros#">
						<cfinvokeargument name="Navegacion" value="#Navegacion#">
					</cfinvoke>
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="JavaScript1.2">
<!---
  ////////////////////////////////////////////////////////////////////
 //   FUNCION PARA MARCAR TODOS LOS DOCUMENTOS 					    //
//////////////////////////////////////////////////////////////////////
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
}--->
///////////////////////////////////////////////////
//FUNCION PARA LIMPIAR TODOS LOS FILTROS         //
///////////////////////////////////////////////////
function LimpiarFiltros(f) {
	f.Documento.value = "";
	f.Moneda.selectedIndex = 0;
	f.Fecha.value = '';
	f.Usuario.selectedIndex = 0;
	f.Registros.value = 20;
}
///////////////////////////////////////////////////
//FUNCION DEL BOTON DE NUEVO DOCUMENTO           //
///////////////////////////////////////////////////
function funcNuevo(){
	document.lista.action = "<cfoutput>#URLira#</cfoutput>?btnNuevo=true";
}
///////////////////////////////////////////////////
//FUNCION DEL BOTON APLICAR                      //
///////////////////////////////////////////////////

<!---cfoutput>
function funcAplicar(){
		if (!ValidaMarcado()){
			alert("#MSG_SePrErr#:\n - #MSG_MarcApl#");
			return false;
		}else{
			param = "variable=<cfoutput>variable</cfoutput>&URLira=<cfoutput>#URLira#</cfoutput>";
			document.lista.action= "SQLRegistroFinanciamiento.cfm?"+param;
			return true;
		}
}
</cfoutput--->
///////////////////////////////////////////////////
//FUNCION PARA IR AL REPORTE DE FINANCIAMIENTO   //
///////////////////////////////////////////////////
function funcReporte(){
	<cfoutput>
	location.href = "../reportes/DocumentosSinAplicarCP.cfm?Docs=1&#params#";
	return false;
	</cfoutput>
}
<!---
//////////////////////////////////////////////////////
//FUNCION PARA VALIDAR SI HAY ALGUN REGISTRO MARCADO//
//////////////////////////////////////////////////////
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
--->
//////////////////////////////////////////////////////////////////
//Funcion para imprimir 										//
//////////////////////////////////////////////////////////////////

	//function funcImprimir(){
	//	if (algunoMarcado()){
	//
	//	<cfif isdefined('LvarTCE') and len(trim(#LvarTCE#)) gt 0><!---  varTCE  indica si es una reporte para para TCE o bancos--->
	//		document.lista.action = "../../mb/Reportes/RPRegistroMovBancariosMasivo-frame.cfm?lista="+getMarcados()+"&varTCE=1";
	//	<cfelse>
	//		document.lista.action = "../../mb/Reportes/RPRegistroMovBancariosMasivo-frame.cfm?lista="+getMarcados()+"&varTCE=0";
	//	</cfif>
	//		document.lista.submit();
	//	}
	//	return false; //Siempre Retorn falso porque lo que hace es levantar una pantalla cuando hay marcados.
	//}
</script>