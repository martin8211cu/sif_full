<!--- =============================================================== --->
<!---   Autor: 	Rodrigo Rivera                                        --->
<!---	Nombre: Arrendamiento                                         --->
<!---	Fecha: 	28/03/2014              	                          --->
<!---	Última Modificación: 16/04/2014    	                          --->
<!--- =============================================================== --->
<!--- =============================================================== --->
<!---                       Navegacion		                     	  --->
<!--- =============================================================== --->
	<cf_navegacion name="Fecha" 		default="">	
	<cf_navegacion name="Documento" 	default="">	
    <cf_navegacion name="Usuario" 		default="">	
    <cf_navegacion name="Registros" 	default="20"> 
    <cf_navegacion name="Moneda" 		default="-1">	
    <cf_navegacion name="pageNum_lista" default="1">	
    <cf_navegacion name="IDArrend" 		default="-1">
    <cf_navegacion name="titulo" 		default="Lista de Arrendamientos">	
    <cf_navegacion name="Botones" 		default="Nuevo">	
    <cf_navegacion name="FiltroExtra" 	default="">
    
    <cfset campos_extra = ", #form.Registros#' as Registros, '#form.pageNum_lista#' as pageNum_lista" >
    <cfif len(trim(Form.Fecha))> 		<cfset campos_extra = campos_extra & ", '#form.Fecha#' as fecha" ></cfif>
    <cfif len(trim(Form.Documento))>	<cfset campos_extra = campos_extra & ", '#form.Documento#' as documento" ></cfif>
    <cfif len(trim(Form.Usuario))>		<cfset campos_extra = campos_extra & ", '#form.usuario#' as usuario" ></cfif>
    <cfif len(trim(Form.Moneda)) and Form.Moneda gte 0><cfset campos_extra = campos_extra & ", '#form.moneda#' as moneda" ></cfif>
    
    <cfset filtro = "a.Ecodigo = #Session.Ecodigo# AND a.Estado=0"> 
    <cfset Fecha       = "Todos">
    <cfset Documento   = "">
    <cfset Usuario     = "Todos">
    <cfset Moneda      = "Todos">
    <cfset Registros   = 20>
    <cfset Navegacion  = Navegacion >
    <cfset params 	   = ''>
<!--- =============================================================== --->
<!---                       Definición Filtros                     	  --->
<!--- =============================================================== --->
    <cfif isDefined("Form.Fecha") and Trim(Form.Fecha) NEQ "" and Trim(Form.Fecha) NEQ "Todos">
        <cfset filtro = filtro & " and convert(varchar(10),a.Fecha,101) = '" & Trim(Form.Fecha) & "'" >
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
        <cfset filtro = filtro & FiltroExtra & " Order by SNnombre, Documento">
    
    <cfquery name="rsMonedas" datasource="#Session.DSN#" cachedwithin="#CreateTimeSpan(0,0,10,0)#">
        select b.Mcodigo as Mcodigo, b.Miso4217 as Mnombre 
        from Monedas b 
        where b.Ecodigo = #Session.Ecodigo#
    </cfquery> 
    
    <cftransaction isolation="read_uncommitted">
        <cfquery name="rsUsuarios" datasource="#Session.DSN#">
            select u.Usulogin as Usulogin
            from EncArrendamiento a inner join Usuario u
            on a.BMUsucodigo = u.Usucodigo
            where Ecodigo = #Session.Ecodigo#
            and a.BMUsucodigo = u.Usucodigo
            group by u.Usulogin
        </cfquery>
    </cftransaction>
<!--- =============================================================== --->
<!---                       Translate                             	  --->
<!--- =============================================================== --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_EncPago 	= t.Translate('LB_EncPago','Encabezado de Pago')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacción','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Folio 	= t.Translate('LB_Folio','Folio','/sif/generales.xml')>
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
						<!---  	DOCUMENTO   --->
							<td>&nbsp;</td>
							<td>
								<input name="Documento" type="text" value="<cfif isDefined("Form.Documento") and Trim(Form.Documento) NEQ ""><cfoutput>#Form.Documento#</cfoutput></cfif>" size="20" maxlength="20">	
							</td>
						<!--- 	USUARIO     --->
							<td>
								<select name="Usuario">
									<option value=""><cfoutput>#LB_Todos#</cfoutput></option>
									<cfoutput query="rsUsuarios"> 
										<option value="#rsUsuarios.Usulogin#" <cfif (rsUsuarios.Usulogin EQ Usuario)>selected</cfif>>#rsUsuarios.Usulogin#</option>
									</cfoutput>
								</select>
							</td>
						<!--- 	FECHA	 	--->
							<td>
								<cfif isdefined('Form.Fecha')>
									<cf_sifcalendario name="Fecha" form="filtros" value="#form.Fecha#">
								<cfelse>
									<cf_sifcalendario name="Fecha" form="filtros">
								</cfif>	
							</td>
						<!--- 	MONEDA		--->
							<td nowrap>
								<select name="Moneda">
									<option value="-1"><cfoutput>#LB_Todas#</cfoutput></option>
									<cfoutput query="rsMonedas"> 
										<option value="#rsMonedas.Mcodigo#" <cfif rsMonedas.Mcodigo EQ Moneda>selected</cfif>>#rsMonedas.Mnombre#</option>
									</cfoutput>
								</select>
							</td>
						<!--- 	REGISTROS	 --->
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
			<td><strong>&nbsp;&nbsp;&nbsp;</strong></td>
		  </tr>
		  <tr> 
			<cfflush interval="64">
			<td>
				<cfinvoke component="sif.Componentes.pListas" method="pListaRH">
				<cfinvokeargument name="tabla" value="EncArrendamiento a
					left join DetArrendamiento d on a.IDArrend = d.IDArrend
					inner join SNegocios b
						on b.SNcodigo = a.SNcodigo
						and b.Ecodigo = a.Ecodigo
					inner join Monedas m
						on m.Mcodigo = a.Mcodigo
					inner join Usuario u
						on a.BMUsucodigo = u.Usucodigo">
					<cfinvokeargument name="columnas" value="a.IDArrend, 
						b.SNidentificacion, 
						b.SNnombre,
						a.Fecha,
						a.Folio,
						a.Documento,
						a.TipoCambio, 
						u.Usulogin,
						m.Miso4217 as Mnombre,
                        '#URLira#' as URLira">
					<cfinvokeargument name="desplegar" 	value="Documento, Folio, TipoCambio, Usulogin, Mnombre">
					<cfinvokeargument name="etiquetas" 	value="#LB_Documento#, #LB_Folio#, #LB_TipoCambio#, #LB_Usuario#, #LB_Moneda#">
					<cfinvokeargument name="formatos" 	value="S,S,N,S,S">
					<cfinvokeargument name="filtro" 	value="#filtro#">
					<cfinvokeargument name="cortes" 	value="SNnombre">
					<cfinvokeargument name="align" 		value="left, center, center, center, center">
					<cfinvokeargument name="checkboxes" value="N">
					<cfinvokeargument name="ira" 		value="#URLira#">
					<cfinvokeargument name="botones" 	value="#Botones#">
					<cfinvokeargument name="keys" 		value="IDArrend">
					<cfinvokeargument name="MaxRows" 	value="#Registros#">
					<cfinvokeargument name="Navegacion" value="#Navegacion#">
				</cfinvoke> 
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="JavaScript1.2">
///////////////////////////////////////////////////
//FUNCION PARA LIMPIAR TODOS LOS FILTROS         //
///////////////////////////////////////////////////
function LimpiarFiltros(f) {
	f.Documento.value = "";
	f.Moneda.selectedIndex = 0;
	f.Fecha.value = "";
	f.Usuario.selectedIndex = 0;
	f.Registros.value = 20;
}
///////////////////////////////////////////////////
//FUNCION DEL BOTON DE NUEVO DOCUMENTO           //
///////////////////////////////////////////////////
function funcNuevo(){
	document.lista.action = "<cfoutput>#URLira#</cfoutput>?btnNuevo=true";
}
</script>