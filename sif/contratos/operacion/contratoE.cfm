
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_EncabezadoContratos" Default= "Encabezado de Contratos" XmlFile="ContratoE.xml" returnvariable="LB_EncabezadoContratos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NumerodeContrato" Default= "N&uacute;mero de Contrato" XmlFile="ContratoE.xml" returnvariable="LB_NumerodeContrato"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TipoContrato" Default= "Tipo de Contrato" XmlFile="ContratoE.xml" returnvariable="LB_TipoContrato"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" Default= "Fecha" XmlFile="ContratoE.xml" returnvariable="LB_Fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Provedor" Default= "Provedor" XmlFile="ContratoE.xml" returnvariable="LB_Provedor"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_VigenciaInicio" Default= "Vigencia Inicio" XmlFile="ContratoE.xml" returnvariable="LB_VigenciaInicio"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaFirma" Default= "Fecha de Firma" XmlFile="ContratoE.xml" returnvariable="LB_FechaFirma"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fin" Default= "Fin" XmlFile="ContratoE.xml" returnvariable="LB_Fin"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Moneda" Default= "Moneda" XmlFile="ContratoE.xml" returnvariable="LB_Moneda"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TipoCambio" Default= "Tipo Cambio" XmlFile="ContratoE.xml" returnvariable="LB_TipoCambio"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Oficina" Default= "Oficina" XmlFile="ContratoE.xml" returnvariable="LB_Oficina"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Procedimiento" Default= "Procedimiento de Contrataci&oacute;n" XmlFile="ContratoE.xml" returnvariable="LB_Procedimiento"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Importe" Default= "Importe" XmlFile="ContratoE.xml" returnvariable="LB_Importe"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fundamento" Default= "Fundamento Legal" XmlFile="ContratoE.xml" returnvariable="LB_Fundamento"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Importeen" Default= "Importe en" XmlFile="ContratoE.xml" returnvariable="LB_Importeen"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default= "Descripci&oacute;n" XmlFile="ContratoE.xml" returnvariable="LB_Descripcion"/>



<cfparam name="URLLista" default="/cfmx/sif/cm/operacion/listaContratos.cfm">
<cfparam name="URLNuevo" default="/cfmx/sif/contratos/operacion/registroContratos.cfm">
<cfif isdefined("url.Ecodigo_f")><cfset lvarFiltroEcodigo = trim(#url.Ecodigo_f#)></cfif>

<cfif not isdefined('lvarFiltroEcodigo') or len(trim(#lvarFiltroEcodigo#)) eq 0 >
  <cfset lvarFiltroEcodigo = #session.Ecodigo#>
</cfif>

<cfif isdefined("url.CTContid") and len(trim(url.CTContid))><cfset form.CTContid = url.CTContid></cfif>
<cfparam name="modo" default="ALTA">
<cfif isdefined("form.CTContid") and len(trim(form.CTContid))><cfset modo = "CAMBIO"></cfif>


<cfquery name="rsLocal" datasource="#Session.DSN#">
	select e.Mcodigo, Miso4217
	from Empresas e
		inner join Monedas m
			on m.Mcodigo = e.Mcodigo
	where e.Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ocodigo, Odescripcion from Oficinas
	where Ecodigo = #Session.Ecodigo#
	order by Ocodigo
</cfquery>


<!---Pasa parámetros del url al form--->
<!---Consultas--->


<cfif (modo EQ "CAMBIO")>

	<!--- Consulta del encabezado de la Orden --->
	<cfquery name="rsCantDetalles" datasource="#Session.DSN#">
		select 1
		from CTContrato
		where Ecodigo = #lvarFiltroEcodigo#
		  and CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTContid#">
	</cfquery>
	<!--- Consulta del encabezado de la Orden --->
	<cfquery name="rsContrato" datasource="#Session.DSN#">
            select a.*, b.SNcodigo, d.Mcodigo,d.Mnombre,c.CTTCdescripcion from CTContrato a
            inner join SNegocios b
                on a.SNid = b.SNid
                and a.Ecodigo = b.Ecodigo
            inner join CTTipoContrato c
                on a.CTTCid = c.CTTCid
                and a.Ecodigo = c.Ecodigo
            inner join Monedas d
                on a.CTMcodigo = d.Mcodigo
                and a.Ecodigo = d.Ecodigo
            inner join CTFundamentoLegal e
                on a.CTFLid = e.CTFLid
                and a.Ecodigo = e.Ecodigo
            inner join CTProcedimientoContratacion f
                on a.CTPCid = f.CTPCid
                and a.Ecodigo = f.Ecodigo
            inner join CTCompradores g
                on a.CTCid = g.CTCid
                and a.Ecodigo = g.Ecodigo
            where a.Ecodigo = #lvarFiltroEcodigo#
		  	and a.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTContid#">
	</cfquery>

    <cfquery name="rsMonedaEmpresa" datasource="#Session.DSN#">
            select Mnombre from Monedas a
            inner join Empresas b
                on	a.Ecodigo = b.Ecodigo
                and a.Mcodigo = b.Mcodigo
            where a.Ecodigo = #lvarFiltroEcodigo#
  	</cfquery>



    <cfquery name="rsMonedaEmpresa" datasource="#Session.DSN#">
            select Mnombre from Monedas a
            inner join Empresas b
                on	a.Ecodigo = b.Ecodigo
                and a.Mcodigo = b.Mcodigo
            where a.Ecodigo = #lvarFiltroEcodigo#
  	</cfquery>
    
    
    
    <cfset Monto = rsContrato.CTmonto * rsContrato.CTtipoCambio>

	<cfif modo neq "ALTA">
		<cfinvoke
		 component="sif.Componentes.DButils"
		 method="toTimeStamp"
		 returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsContrato.ts_rversion#"/>
		</cfinvoke>
	</cfif>
	<!--- Nombre del Socio --->
	<cfquery name="rsNombreSocio" datasource="#Session.DSN#">
		select SNcodigo, SNidentificacion, SNnombre from SNegocios
		where Ecodigo = #lvarFiltroEcodigo#
    	and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsContrato.SNcodigo#">
	</cfquery>
</cfif>

<!--- Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo from Empresas
	where Ecodigo = #lvarFiltroEcodigo#
</cfquery>

<cfquery name="rsObligatorios" datasource="#Session.DSN#">
	select rtrim(CMTOcodigo) as CMTOcodigo, CMTOdescripcion, CMTgeneratracking, CMTOte, CMTOtransportista, CMTOtipotrans, CMTOincoterm, CMTOlugarent
	from CMTipoOrden
	where Ecodigo = #lvarFiltroEcodigo#
	order by CMTOcodigo
</cfquery>

<cfquery name="rsTipoContrato" datasource="#Session.DSN#">
		select CTTCdescripcion,CTTCid
		from CTTipoContrato
		where Ecodigo = #Session.Ecodigo#
        order by CTTCdescripcion
</cfquery>

<cfquery name="rsFundamentoLegal" datasource="#Session.DSN#">
		select CTFLdescripcion,CTFLid
		from CTFundamentoLegal
		where Ecodigo = #Session.Ecodigo#
        order by CTFLdescripcion
</cfquery>

<cfquery name="rsContratacion" datasource="#Session.DSN#">
		select CTPCdescripcion,CTPCid
		from CTProcedimientoContratacion
		where Ecodigo = #Session.Ecodigo#
        order by CTPCdescripcion
</cfquery>






<!---Javascript Incial--->
<script language="JavaScript" src="/cfmx/sif/js/utilesMonto.js" type="text/javascript"></script>
<script language="javascript" src="/cfmx/sif/js/qForms/qforms.js" type="text/javascript"></script>
<script language="javascript" type="text/javascript">
<!--// //poner a código javascript
	//incluye qforms en la página
	// Qforms. especifica la ruta donde el directorio "/qforms/" está localizado
	qFormAPI.setLibraryPath("../../js/qForms/");
	// Qforms. carga todas las librerías por defecto
	qFormAPI.include("*");



	var ob = new Object();
	<cfoutput query="rsObligatorios">
		ob['#CMTOcodigo#'] = new Object();
		ob['#CMTOcodigo#']['CMTOte'] = #CMTOte#;
		ob['#CMTOcodigo#']['CMTOtransportista'] = #CMTOtransportista#;
		ob['#CMTOcodigo#']['CMTOtipotrans'] = #CMTOtipotrans#;
		ob['#CMTOcodigo#']['CMTOincoterm'] = #CMTOincoterm#;
		ob['#CMTOcodigo#']['CMTOlugarent'] = #CMTOlugarent#;
	</cfoutput>


//-->
</script>
<!---Pintado del form--->

<cfoutput>

<form action="contratos-sql.cfm" method="post" name="form1" onSubmit="javascript: valida(); return _formEnd();">
<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td nowrap class="subTitulo"><font size="2">#LB_EncabezadoContratos#</font></td>
  </tr>
</table>
<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0" summary="Formulario del Encabezado Contratos">
  <tr>
    <td nowrap>&nbsp;</td>
    <td nowrap>&nbsp;</td>
    <td nowrap>&nbsp;</td>
    <td nowrap>&nbsp;</td>
    <td nowrap>&nbsp;</td>
    <td nowrap>&nbsp;</td>
  </tr>
  <!---Línea 1--->

    <td nowrap align="right"><strong>#LB_NumerodeContrato#:&nbsp;</strong></td>
    <td nowrap>
			<!---Número de Orden: Este campo se llena con un cálculo en el SQL --->
            <cfif (modo EQ "CAMBIO")>
            	#rsContrato.CTCnumContrato#
                <input type="hidden" name="NumContrato" value="#rsContrato.CTCnumContrato#">
            <cfelse>
                <input
                name="NumContrato"
                type="text"
                tabindex="1"
                maxlength="18"
                size="30"
                title="Número de Contrato requerido"
                >
            </cfif>

    </td>
    <td nowrap align="right"><strong>#LB_TipoContrato#:&nbsp;</strong></td>
    <td nowrap align="left">
			<!---Tipo de Contrato--->
        <select name="TipoContrato" onChange="javascript: LimpiarCuenta();">
            <cfloop query="rsTipoContrato">

                <option value="#rsTipoContrato.CTTCid#"<cfif modo EQ 'CAMBIO' and rsTipoContrato.CTTCid EQ rsContrato.CTTCid> selected</cfif>>
                #rsTipoContrato.CTTCdescripcion#</option>
            </cfloop>
        </select>
	</td>

   <td width="12%" align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
   <td nowrap align="right"><strong>#LB_Fecha#:&nbsp;</strong></td>
	<td nowrap>
        <!---Fecha--->
        <cfif (modo EQ "CAMBIO")>
            <input type="hidden" name="CTfecha" id="CTfecha" value="<cfif modo EQ 'CAMBIO'>#LSDateFormat(rsContrato.CTfecha,'dd/mm/yyyy')#</cfif>">
            #LSDateFormat(rsContrato.CTfecha,'dd/mm/yyyy')#
        <cfelse>
            <cf_sifcalendario name="FechaContrato" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
        </cfif>
    </td>
  </tr>

	<!---Línea 2--->
  <tr>

  </tr>
	<!---Línea 3--->
  <tr>
     <td nowrap align="right" ><strong>#LB_Provedor#:&nbsp;</strong></td>
    	<td nowrap>
			<!---Provedor--->
			<cfif (modo EQ "CAMBIO")>
				#rsNombreSocio.SNnombre#
				<input type="hidden" name="SNcodigo" value="#rsContrato.SNcodigo#">
				<input type="hidden" name="SNidentificacion" value="#rsNombreSocio.SNidentificacion#">
			<cfelseif isdefined("form.SNcodigo") and len(trim(form.SNCodigo))>
				  <cf_sifsociosnegocios2 sntiposocio="P"SNcontratos = 1 tabindex="1" idquery="#form.SNcodigo#" Ecodigo="#lvarFiltroEcodigo#">
            <cfelse>
				 <cf_sifsociosnegocios2 sntiposocio="P" SNcontratos = 1 tabindex="1" Ecodigo="#lvarFiltroEcodigo#">
            </cfif>
		</td>

     <td align="right" nowrap class="fileLabel"><strong>#LB_VigenciaInicio#:</strong></td>
       <td>
            <cfif modo EQ "CAMBIO">
              <cfset fecha = LSDateFormat(rsContrato.CTfechaIniVig, 'dd/mm/yyyy')>
              <cfelse>
              <cfset fecha = LSDateFormat(Now(), 'dd/mm/yyyy')>
            </cfif>
            <cf_sifcalendario name="VigenciaInicio" form="form1" value="#fecha#">
       </td>
  </tr>
	<!---Línea 4--->

  <tr>

  <td nowrap align="right"><strong>#LB_FechaFirma#:&nbsp;</strong></td>
      	<td>
			<cfif modo EQ "CAMBIO">
              <cfset fecha = LSDateFormat(rsContrato.CTfechaFirma, 'dd/mm/yyyy')>
            <cfelse>
              <cfset fecha = LSDateFormat(Now(), 'dd/mm/yyyy')>
            </cfif>
            <cf_sifcalendario name="FechaFirma" form="form1" value="#fecha#">
		</td>


    <td align="right" nowrap class="fileLabel"><strong>#LB_Fin#:</strong></td>
        <td>
			<cfif modo EQ "CAMBIO">
            	<cfset fecha = LSDateFormat(rsContrato.CTfechaFinVig, 'dd/mm/yyyy')>
            <cfelse>
            	<cfset fecha = LSDateFormat(Now(), 'dd/mm/yyyy')>
            </cfif>
            	<cf_sifcalendario name="VigenciaFin" form="form1" value="#fecha#">
        </td>

		<td>
		</td>

     <tr>
		 <td nowrap align="right"><strong>#LB_Moneda#:&nbsp;</strong></td>

      	 <td>
			<table cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<cfif MODO EQ "ALTA">
							<cf_sifmonedas onChange="sbMonedas()" FechaSugTC="#LSdateFormat(now())#">
						<cfelse>
							<cf_sifmonedas onChange="sbMonedas()" FechaSugTC="#LSdateFormat(now())#" habilita="N" value="#rsContrato.CTMcodigo#">
							<input type="hidden" name="Mcodigo" value="#rsContrato.CTMcodigo#" id="Mcodigo">
						</cfif>
					</td>
					<td nowrap>
                            &nbsp;&nbsp;<strong>Tipo Cambio:</strong>
                            <input type="text" name="TipoCambio" id="TipoCambio" size="20" maxlength="18"
	                           onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,5);"
                               onKeyUp="if(snumber(this,event,5)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;"
                                <cfif Modo EQ "ALTA">
                                    value="1.0000" disabled
                                <cfelse>
                                    value="#numberFormat(rsContrato.CTtipoCambio,",9.9999")#"disable
                                    <cfif rsContrato.CTMcodigo EQ rsLocal.Mcodigo>disabled</cfif>
                                </cfif>
                             />
							<script language="javascript">
                                function sbMonedas()
                                {
                                    document.form1.TipoCambio.value 	= fm(document.form1.TC.value,4);
                                    document.form1.TipoCambio.disabled 	= document.form1.Mcodigo.value == #rsLocal.Mcodigo#;
                                }
                            </script>
					</td>
			</tr>
		 </table>
    <!---►►Oficina◄◄--->
            <td nowrap align="right"><strong>#LB_Oficina#:&nbsp;</strong></td>
            <td nowrap ><select name="Ocodigo" tabindex="1">
                  <cfloop query="rsOficinas">
                  	<option value="#rsOficinas.Ocodigo#"
							<cfif modo NEQ "ALTA" and rsOficinas.Ocodigo EQ rsContrato.Ocodigo>selected
							<cfelseif modo EQ 'ALTA' and isdefined('form.Ocodigo') and rsOficinas.Ocodigo EQ form.Ocodigo>selected</cfif>> #rsOficinas.Odescripcion# </option>
                  </cfloop>
              </select>
            </td>



  <tr>
        <td nowrap align="right"><strong>#LB_Procedimiento#:&nbsp;</strong></td>
        <td nowrap>
                <select name="ProcedimientoContratacion" onChange="javascript: LimpiarCuenta();">
                    <cfloop query="rsContratacion">
                        <option value="#rsContratacion.CTPCid#"<cfif modo EQ 'CAMBIO' and rsContrato.CTPCid EQ rsContratacion.CTPCid>
                            selected</cfif>>#rsContratacion.CTPCdescripcion#</option>
                    </cfloop>
                </select>
        </td>


        <td nowrap align="right"><strong>#LB_Importe#:&nbsp;</strong></td>
        <td nowrap>
            <cfif (modo EQ "CAMBIO")>
                <input type="hidden" name="Importe" id="Importe" value="<cfif modo EQ 'CAMBIO'>#LSCurrencyFormat(rsContrato.CTmonto,'none')#</cfif>">
                #LSCurrencyFormat(rsContrato.CTmonto,'none')#
            <cfelse>
                <input 	name="Importe" readonly="true" type="text" size="18" tabindex="1" maxlength="18" style="text-align:right"
                    onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
                    onFocus="javascript:this.select();"
                    onBlur="javascript: fm(this,2); <cfif modo neq 'ALTA'>calcular_totales();</cfif> "
                    value="0.00">
            </cfif>
        </td>

  </tr>

  <tr>


   	<td>
        </td>

  </tr>

  <tr>
  	    <td nowrap align="right"><strong>#LB_Fundamento#:&nbsp;</strong></td>
    	<td nowrap>
			<select name="FundamentoLegal" onChange="javascript: LimpiarCuenta();">
                <cfloop query="rsFundamentoLegal"> <option value="#rsFundamentoLegal.CTFLid#"<cfif modo EQ 'CAMBIO' and rsContrato.CTFLid EQ rsFundamentoLegal.CTFLid>
                selected </cfif>>#rsFundamentoLegal.CTFLdescripcion#</option>
                </cfloop>
            </select>
   	    </td>
	   <cfif (modo EQ "CAMBIO")>
          <td nowrap align="right"><strong>#LB_Importeen# #rsMonedaEmpresa.Mnombre#:&nbsp;</strong></td>
            <td nowrap>
                <cfif (modo EQ "CAMBIO")>
                    <input type="hidden" name="ImporteConvertido" id="ImporteConvertido" value="<cfif modo EQ 'CAMBIO'>#LSCurrencyFormat(Monto,'none')#</cfif>">
                    #LSCurrencyFormat(Monto,'none')#
                <cfelse>
                    <input 	name="ImporteConvertido" readonly="true" type="text" size="18" tabindex="1" maxlength="18" style="text-align:right"
                        onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
                        onFocus="javascript:this.select();"
                        onBlur="javascript: fm(this,2); <cfif modo neq 'ALTA'>calcular_totales();</cfif> "
                        value="0.00">
                </cfif>
            </td>
       </cfif>
  </tr>
  <tr>
  	<td>
  	</td>

  </tr>
  <tr>
        <td align="right" class="fileLabel" nowrap><strong>#LB_Descripcion#:</strong></td>
        <td colspan="2">
            <input
            name="Descripcion"
            type="text"
            tabindex="1"
            value="<cfif (modo EQ "CAMBIO")>#rsContrato.CTCdescripcion#</cfif>"
            maxlength="255"
            size="80">
        </td>


        <td align="right">&nbsp;</td>
            <td></td>
 </tr>

  <tr>
  	<td nowrap colspan="6">&nbsp;</td>
  </tr>
</table>

<cfif (modo EQ "CAMBIO")>
	<cfinclude template="contratoD.cfm">
</cfif>

<input type="hidden" name="CTContid" value="<cfif (modo EQ "CAMBIO")>#form.CTContid#</cfif>">
<input type="hidden" name="ts_rversion" value="<cfif (modo EQ "CAMBIO")>#ts#</cfif>">
<input type="hidden" name="Ecodigo_f" value="<cfoutput>#lvarFiltroEcodigo#</cfoutput>">
<input type="hidden" name="EncabezadoCambiado">

<cfparam name="mododet" default="CAMBIO">

<cfset exclude="Nuevo,AltaDet,NuevoDet">
<cfif (modo eq "CAMBIO") and (rsCantDetalles.RecordCount) and mododet NEQ "CAMBIO">
	<cfset includevalues="Aplicar,Nuevo Contrato">
	<cfset include="btnAplicar,Nuevo">
<cfelseif (modo eq "CAMBIO") and (rsCantDetalles.RecordCount) and mododet EQ "CAMBIO">
	<cfset includevalues="Aplicar,Nuevo Contrato,Nueva Línea">
	<cfset include="btnAplicar,Nuevo,NuevoDet">
<cfelse>
	<cfset includevalues="">
	<cfset include="">

</cfif>


<br>
<table align="center">
        <td>
            <cf_botones modo="#modo#" mododet="#mododet#" nameenc="Contrato" generoenc="F" tabindex="5" include="#include#" includevalues="#includevalues#" exclude="#exclude#">
        </td>
        <cfif mododet EQ "ALTA">

            <td>
                <input type="button" class="btnNormal"  tabindex="1" name="Suficiencia" value="Suficiencia" onClick="javascript:VentanaSuficiencia(<cfoutput>
                <cfif isdefined('form.CTContid') and len(trim(#form.CTContid#))>#form.CTContid#</cfif></cfoutput>);">
            </td>
		</cfif>

		<cfif modo EQ "CAMBIO">
        	

            <td align="left">
                <input type="button"  class="btnNormal" value="Anotaciones y Documentos" name="Anotaciones" onclick="funcAnotaciones(<cfoutput>
                <cfif isdefined('form.CTContid') and len(trim(#form.CTContid#))>#form.CTContid#</cfif></cfoutput>);">
            </td>
        </cfif>
</table>
<!---</cfif>--->
<cfif (modo EQ "CAMBIO")>
	<cfinclude template="contratoL.cfm">
</cfif>
</form>
</cfoutput>

<!---Javascript Final--->
<cfparam name="qformsNombresCamposDetalle" 			default="">
<cfparam name="qformsHabilitarValidacionDetalle" 	default="">
<cfparam name="qformsDesHabilitarValidacionDetalle" default="">
<cfparam name="qformsFinalizarValidacionDetalle" 	default="">
<cfparam name="qformsFocusOnDetalle" 				default="">
<script language="javascript" type="text/javascript">
<!--// //poner a código javascript
	//define el color de los campos en caso de error
	qFormAPI.errorColor = "#FFFFCC";
	//inicializa qforms en la página


function habilitarValidacion(){
		<cfif modo EQ 'ALTA'>
			objForm.NumContrato.required = true;
			objForm.SNcodigo.required = true;
			objForm.Descripcion.required = true;
		</cfif>

		<cfif modo NEQ 'ALTA'>
			objForm.Descripcion.required = true;
		</cfif>


	}


	objForm = new qForm("form1");

	//Llama el conlis
	function VentanaSuficiencia(CTContid) {
		var params ="";

		params = "&form=form"+

		popUpWindowIns("/cfmx/sif/cm/operacion/popUp-suficiencia.cfm?CTContid="+CTContid+params,window.screen.width*0.05 ,window.screen.height*0.05,window.screen.width*0.90 ,window.screen.height*0.90);
	}


	var popUpWinIns = 0;
	function popUpWindowIns(URLStr, left, top, width, height){
		if(popUpWinIns){
			if(!popUpWinIns.closed) popUpWinIns.close();
		}
		popUpWinIns = open(URLStr, 'popUpWinIns', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,scrolling=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	<cfoutput>


	//Define nombres de los campos
	objForm.NumContrato.description = "#JSStringFormat('Número de Contrato')#";
	objForm.TipoContrato.description = "#JSStringFormat('Tipo de Contrato')#";
	objForm.SNcodigo.description = "#JSStringFormat('Provedor')#";
	objForm.CTfecha.description = "#JSStringFormat('Fecha')#";
	objForm.Mcodigo.description = "#JSStringFormat('Moneda')#";
	objForm.TipoCambio.description = "#JSStringFormat('Tipo de Cambio')#";
	objForm.VigenciaInicio.description = "#JSStringFormat('Vigencia Inicio')#";
	objForm.VigenciaFin.description = "#JSStringFormat('Vigencia Fin')#";
	objForm.FechaFirma.description = "#JSStringFormat('Fecha Firma')#";

	objForm.Ocodigo.description = "#JSStringFormat('Oficina')#";
	objForm.ProcedimientoContratacion.description = "#JSStringFormat('Procedimiento de Contratacion')#";
	objForm.FundamentoLegal.description = "#JSStringFormat('Fundamento Legal')#";
	objForm.Importe.description = "#JSStringFormat('Importe')#";
	objForm.Descripcion.description = "#JSStringFormat('Descripcion')#";

	#qformsNombresCamposDetalle#

	//function para iniciar el form1
	function _formIni(){
		habilitarValidacion();
		<cfif (modo EQ "ALTA")>
			objForm.TipoContrato.obj.focus();
		<cfelse>
			#qformsFocusOnDetalle#
		</cfif>
	}

	</cfoutput>
	//inicia el form1
	_formIni();
	/* **************************************************** Inician funciones del form **************************************************** */
	/* aquí asigna el hidden creado por el tag de monedas al objeto que realmente se va a usar como el tipo de cambio */
	function asignaTC() {
		var f = document.form1;
		<cfif modo EQ "ALTA">
			if (f.Mcodigo.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>") {
				formatCurrency(f.TC,2);
				f.TipoCambio.disabled = true;
			}
			else
				f.TipoCambio.disabled = false;

			var estado = f.TipoCambio.disabled;
			f.TipoCambio.disabled = false;
			f.TipoCambio.value = f.TipoCambio.value;
			f.TipoCambio.disabled = estado;
		<cfelse>
			if (f.Mcodigo.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>")
				formatCurrency(f.TC,2);

			f.TipoCambio.value = f.TC.value;
		</cfif>
	}

		//Llama el conlis
	function funcAnotaciones(CTContid) {
			var Ecodigo = document.form1.Ecodigo.value;

		popUpWindowIns("/cfmx/sif/contratos/operacion/Contratos_frameAnotacion.cfm?CTContid="+CTContid+"&Ecodigo="+Ecodigo,window.screen.width*0.05 ,window.screen.height*0.05,window.screen.width*0.90 ,window.screen.height*0.90);
		return false;
	}

</script>