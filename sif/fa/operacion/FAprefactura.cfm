<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PreFactura" default="Pre-Factura" returnvariable="LB_PreFactura" xmlfile="FAprefactura-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Header" default="Facturaci&oacute;n" returnvariable="LB_Header" xmlfile="FAprefactura.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_RegistroPreFacturas" default="" returnvariable="LB_RegistroPreFacturas" xmlfile="FAprefactura.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CentroFuncionalDefault" default="Centro Funcional Default" returnvariable="LB_CentroFuncionalDefault" xmlfile="FAprefactura.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CuentaDefault" default="Cuenta Default" returnvariable="LB_CuentaDefault" xmlfile="FAprefactura.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SeleccionarTodos" default="Seleccionar Todos" returnvariable="LB_SeleccionarTodos" xmlfile="FAprefactura.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_EstaSeguroQueDeseaImprimirLosDocumentosSeleccionados" default="¿Está seguro que desea IMPRIMIR los documentos seleccionados?" returnvariable="MSG_EstaSeguroQueDeseaImprimirLosDocumentosSeleccionados" xmlfile="FAprefactura.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_EstaSeguroDeQueDeseaAplicarLosDocumentosSeleccionados" default="¿Está seguro de que desea APLICAR los documentos seleccionados?" returnvariable="MSG_EstaSeguroDeQueDeseaAplicarLosDocumentosSeleccionados" xmlfile="FAprefactura.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_EstaSeguroDeQueDeseaAnularLosDocumentosSeleccionados" default="¿Está seguro de que desea ANULAR los documentos seleccionados?" returnvariable="MSG_EstaSeguroDeQueDeseaAnularLosDocumentosSeleccionados" xmlfile="FAprefactura.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_DebeSeleccionarAlMenosUnDocumentoAntesDeImprimir" default="Debe seleccionar al menos un documento antes de Imprimir" returnvariable="MSG_DebeSeleccionarAlMenosUnDocumentoAntesDeImprimir" xmlfile="FAprefactura.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_DebeSeleccionarAlMenosUnDocumentoAntesDeAplicar" default="Debe seleccionar al menos un documento antes de Aplicar" returnvariable="MSG_DebeSeleccionarAlMenosUnDocumentoAntesDeAplicar" xmlfile="FAprefactura.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_DebeSeleccionarAlMenosUnDocumentoAntesDeAnular" default="Debe seleccionar al menos un documento antes de Anular" returnvariable="MSG_DebeSeleccionarAlMenosUnDocumentoAntesDeAnular" xmlfile="FAprefactura.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Pendiente" default="Pendiente" returnvariable="LB_Pendiente" xmlfile="FAprefactura.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PorAsignar" default="Por Asignar" returnvariable="LB_PorAsignar" xmlfile="FAprefactura.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Estimada" default="Estimada" returnvariable="LB_Estimada" xmlfile="FAprefactura.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Anulada" default="Anulada" returnvariable="LB_Anulada" xmlfile="FAprefactura.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Terminada" default="Terminada" returnvariable="LB_Terminada" xmlfile="FAprefactura.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Vencida" default="Vencida" returnvariable="LB_Vencida" xmlfile="FAprefactura.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_DocEstimado" default="Documento Estimado" returnvariable="LB_DocEstimado" xmlfile="FAprefactura.xml">
<!--- Sentencias para mantener el filtro de la Lista --->
<cfquery name="rsExisteVersion" datasource="#session.DSN#">
	select Pvalor from Parametros where Pcodigo = 17200 and Ecodigo = #session.Ecodigo#
</cfquery>


<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
	<cfset Form.SNcodigo = url.SNcodigo>
</cfif>
<cfif isdefined("url.EstatusPF") and not isdefined("form.EstatusPF") and url.EstatusPF NEQ -1>
	<cfset Form.EstatusPF = url.EstatusPF>
</cfif>
<cfif isdefined("url.PFdocumento") and not isdefined("form.PFdocumento")>
	<cfset Form.PFdocumento = url.PFdocumento>
</cfif>
<cfif isdefined("url.Mcodigo") and not isdefined("form.Mcodigo")>
	<cfset Form.Mcodigo = url.Mcodigo>
</cfif>
<cfif isdefined("url.PFTcodigo") and not isdefined("form.PFTcodigo")>
	<cfabort showerror="MIRA">
	<cfset Form.PFTcodigo = url.PFTcodigo>
</cfif>
<cfif isdefined("url.Ocodigo") and not isdefined("form.Ocodigo")>
	<cfset Form.Ocodigo = url.Ocodigo>
</cfif>
<cfif isdefined("url.opt_CF") and not isdefined("form.opt_CF")>
	<cfset Form.opt_CF = url.opt_CF>
</cfif>
<cfif isdefined("url.opt_CC") and not isdefined("form.opt_CC")>
	<cfset Form.opt_CC = url.opt_CC>
</cfif>
<cfparam name="Navegacion" default="">
<cfparam name="Registros" default="20">
<cfif isdefined("url.ver") and len(trim(url.ver)) and not isdefined("form.ver")>
	<cfset form.ver = url.ver >
</cfif>
<cfif isdefined("form.ver") and len(trim(form.ver)) and form.ver GT 0>
	<cfset Registros = form.Ver>
</cfif>
<cfif isdefined("form.ver") and len(trim(form.ver)) and form.ver GT 0>
	<cfset Navegacion = Navegacion & "ver=#Form.ver#&">
</cfif>
<!--- NAVEGACION --->
<cfif isdefined("Form.SNcodigo") and len(trim(form.SNcodigo))>
	<cfset Navegacion = Navegacion & "SNcodigo=#Form.SNcodigo#&">
</cfif>
<cfif isdefined("Form.EstatusPF") and form.EstatusPF NEQ -1>
	<cfset Navegacion = Navegacion & "EstatusPF=#Form.EstatusPF#&">
</cfif>
<cfif isdefined("url.PFdocumento") and not isdefined("form.PFdocumento")>
	<cfset Form.PFdocumento = url.PFdocumento>
</cfif>
<cfif isdefined("url.Mcodigo") and not isdefined("form.Mcodigo")>
	<cfset Navegacion = Navegacion & "Mcodigo=#Form.Mcodigo#&">
</cfif>
<cfif isdefined("url.PFTcodigo") and not isdefined("form.PFTcodigo")>
	<cfset Navegacion = Navegacion & "PFTcodigo=#Form.PFTcodigo#&">
</cfif>
<cfif isdefined("url.Ocodigo") and not isdefined("form.Ocodigo")>
	<cfset Navegacion = Navegacion & "Ocodigo=#Form.Ocodigo#&">
</cfif>
<cfif isdefined("form.opt_CF")>
	<cfset Navegacion = Navegacion & "opt_CF=#Form.opt_CF#&">
</cfif>
<cfif isdefined("form.opt_CC")>
	<cfset Navegacion = Navegacion & "opt_CC=#Form.opt_CC#&">
</cfif>

<cfparam name="url.PageNum_lista" default=1>
<cf_templateheader title="#LB_Header#">
	<cf_templatecss>
		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_RegistroPreFacturas#">
		<table width="100%" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<cfinclude template="../../portlets/pNavegacion.cfm">
				</td>
			</tr>
			<tr align="center">
				<td  valign="top">
				<cfif (isdefined("Form.IDpreFacturaCur") and len(trim(form.IDpreFacturaCur)))>
					<cfset Form.IDpreFactura = Form.IDpreFacturaCur>
				</cfif>
					<cfif isdefined("form.SNDirec") and form.SNDirec EQ "valor">
                        <cfquery name="rsForm" datasource="#session.DSN#">
                        	Select
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pfdocumento#"> as PFdocumento,
								<cfif isdefined("form.ocodigo") and form.ocodigo NEQ ""> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ocodigo#"> as Ocodigo, </cfif>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pftcodigo#"> as PFTcodigo,
								<cfif isdefined("form.descuento") and form.descuento NEQ ""> <cfqueryparam cfsqltype="cf_sql_money" value="#form.Descuento#"> as Descuento </cfif>,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.observaciones#"> as Observaciones,
								<cfif isdefined("form.fechacot") and len(trim("form.fechacot"))> <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.fechacot,'dd/mm/yyyy')#"> as FechaCot </cfif>,
					            <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.numordencompra#"> as NumOrdenCompra
	                    </cfquery>
                        <cfinclude template="FAprefactura-form.cfm">
						

					<cfelseif (isdefined("Form.IDpreFactura") and len(trim(form.IDpreFactura))) or (isdefined("Form.btnNuevo"))>
						<cfif rsExisteVersion.Pvalor eq ''>	
							<Strong><h3> ---------------- No cuenta con una versión del CFDI seleccionada, favor de seleccionar una ---------------- </h3></Strong>		
						<cfelseif rsExisteVersion.Pvalor eq '0'>	
							<Strong><h3> ---------------- No cuenta con una versión del CFDI seleccionada, favor de seleccionar una ---------------- </h3></Strong>		
						<cfelse>
							<cfinclude template="FAprefactura-form.cfm">										
						</cfif>
					<cfelse>
						<!--- Filtro para la lista --->

						<cfinclude template="FAprefactura-filtro.cfm">
       					<form style="margin: 0" action="FAprefactura.cfm" name="frListaPF" method="post" id="frListaPF">
								<input id="IDpreFactura" name ="IDpreFactura" type="hidden" value="">
								<input id="IDpreFacturaCur" name ="IDpreFacturaCur" type="hidden" value="">
								<input id="Ecodigo" name ="Ecodigo" type="hidden">
		                        <tbody  ><tbody  >
								<tr><td align="left">
		                             <table width="100%" border="0" cellspacing="0" cellpadding="2">
		                                <tr>
		                                    <td align="right">
		                                    <input type="checkbox" name="opt_CF" value="<cfif isdefined("Form.opt_CF")>Form.opt_CF</cfif>">
		                                    </td>
		                                    <td align="left" ><strong><cfoutput>#LB_CentroFuncionalDefault#</cfoutput></strong> </td>
		                                    <td align="right">
		                                    <input type="checkbox" name="opt_CC" value="<cfif isdefined("Form.opt_CC")>Form.opt_CC</cfif>">
		                                    </td>
		                                    <td align="left" ><strong><cfoutput>#LB_CuentaDefault#</cfoutput></strong> </td>
		                                </tr>
		                            </table>
		                        </td></tr>
		                        <tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tr><td align="left">
                                    <input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);" style="background:background-color ">
		    			            <label for="chkTodos"><cfoutput>#LB_SeleccionarTodos#</cfoutput></label>
									</td></tr>

						<cfquery name="rsPF" datasource="#session.dsn#">
							Select
									IDpreFactura, SNnombre,fac.SNcodigo,
                                    PFDocumento,
									case Estatus
										when 'R' then '#LB_PorAsignar#'
										when 'P' then '#LB_Pendiente#'
										when 'E' then '#LB_Estimada#'
                                        when 'A' then '#LB_Anulada#'
                                        when 'T' then '#LB_Terminada#'
                                        when 'V' then '#LB_Vencida#'
									end Estatus,
                                    case Estatus
										when 'R' then 0
										when 'P' then 0
										when 'E' then 0
                                        when 'A' then IDpreFactura
                                        when 'T' then IDpreFactura
                                        when 'V' then IDpreFactura
									end as inactiva,
									Estatus as estado,
                                    m.Mnombre as Moneda,
                                    pf.PFTdescripcion as Transaccion,
                                    o.Odescripcion,
									COALESCE(DdocumentoREF, ' ') AS DdocumentoREF,
									'<i class=''fa fa-search'' title=''Ver'' onclick=''doView('+ cast(IDpreFactura as varchar)  + ');'' style=''cursor:pointer;''></i>&nbsp;&nbsp;
									<!--- <img border=''0'' src=''/cfmx/sif/imagenes/find.small.png'' style=''cursor:pointer'' alt=''Ver'' onclick=''doView('+ cast(IDpreFactura as varchar)  + ');''> &nbsp; --->
									<i class=''fa fa-print'' title=''Imprimir'' onclick=''doPrint('+ cast(IDpreFactura as varchar)  + ');'' style=''cursor:pointer;''></i>'Botones
									<!--- <img border=''0''  style=''cursor:pointer'' alt=''Imprimir'' onclick=''doPrint('+ cast(IDpreFactura as varchar)  + ');''>'Botones --->
							from FAPreFacturaE fac
								inner join SNegocios sn
								on fac.Ecodigo = sn.Ecodigo and sn.SNcodigo=fac.SNcodigo
                                inner join Monedas m
                                on fac.Ecodigo = m.Ecodigo and fac.Mcodigo = m.Mcodigo
                                inner join FAPFTransacciones pf
                                on fac.Ecodigo = pf.Ecodigo and fac.PFTcodigo = pf.PFTcodigo
                                inner join Oficinas o
                                on o.Ecodigo = fac.Ecodigo and o.Ocodigo = fac.Ocodigo
							where fac.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                            	and Estatus in ('R','P','E')
								<!---and Estatus in ('P','E')--->
								<cfif isdefined('form.EstatusPF') and len(trim(form.EstatusPF)) and form.EstatusPF NEQ '-1'>
									and Estatus=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EstatusPF#">
								</cfif>
								<cfif isdefined('form.SNcodigo') and len(trim(form.SNcodigo))>
									and fac.SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
								</cfif>
								<cfif isdefined('form.PFdocumento') and len(trim(form.PFdocumento)) and form.PFdocumento NEQ "">
									and PFdocumento like '%' + <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PFdocumento#"> + '%'
								</cfif>
                                <cfif isdefined('form.Mcodigo') and len(trim(form.Mcodigo)) and form.Mcodigo NEQ '-1'>
									and fac.Mcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mcodigo#">
								</cfif>
                                <cfif isdefined('form.PFTcodigo') and len(trim(form.PFTcodigo)) and form.PFTcodigo NEQ '-1'>
									and fac.PFTcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PFTcodigo#">
								</cfif>
                                <cfif isdefined('form.Ocodigo') and len(trim(form.Ocodigo)) and form.Ocodigo NEQ '-1'>
									and fac.Ocodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">
								</cfif>
                                Order by SNnombre
						</cfquery>
						<cfinvoke
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaRet">
								<cfinvokeargument name="query" value="#rsPF#"/>
								<cfinvokeargument name="desplegar" value="PFdocumento, Odescripcion, Estatus,Moneda,Transaccion,DdocumentoREF,Botones"/>
								<cfinvokeargument name="etiquetas" value="#LB_PreFactura#, #LB_Oficina#, #LB_Estatus#, #LB_Moneda#, #LB_Transaccion#,#LB_DocEstimado#, "/>
								<cfinvokeargument name="formatos" value="S, S, S, S, S, S, S"/>
                                <cfinvokeargument name="cortes" value="SNnombre"/>
								<cfinvokeargument name="align" value="left, left, left, left, left, left, center"/>
								<cfinvokeargument name="ajustar" value="N, N, N, N, N, N"/>
								<cfinvokeargument name="irA" value="FAprefactura.cfm"/>
								<cfinvokeargument name="keys" value="IDpreFactura"/>
								<cfinvokeargument name="checkboxes" value="S"/>
								<cfinvokeargument name="showlink" value="false"/>
								<cfinvokeargument name="includeForm" value="false"/>
								<cfinvokeargument name="botones" value="Nuevo,Aplicar_Factura,Aplicar_Estimado,Anular,Impresion"/>
								<cfinvokeargument name="formName" value="frListaPF"/>
								<cfinvokeargument name="showemptylistmsg" value="true"/>
                                <cfinvokeargument name="inactivecol" value="inactiva"/>
                                <cfinvokeargument name="MaxRows" value="#Registros#"/>
			                    <cfinvokeargument name="Navegacion" value="#Navegacion#"/>
						</cfinvoke>

						<script type="text/javascript" src="/cfmx/CFIDE/scripts/wddx.js"></script>
						<script language="javascript" type="text/javascript">
						<cfoutput>
						<cfwddx action="cfml2js" input="#rsPF#" topLevelVariable="jsrsPF">
							for (counter = 0; counter < document.getElementsByName('chk').length; counter++)
							{
							var row = (#url.PageNum_lista# -1) * 20;
							var selRow = row + counter;
								if (jsrsPF.getField(selRow, "Estatus") == 'Por Asignar'){
									document.getElementsByName('chk')[counter].disabled = true;
								}
							}
						</cfoutput>
						</script>
					</cfif>
        			</form>
				</td>
			</tr>
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>

<script language="javascript" type="text/javascript">
	function doView(v){
		$('input[name=IDpreFactura]').val(v);
		$('input[name=IDpreFacturaCur]').val(v);
		document.getElementById("frListaPF").submit();
	}

	function doPrint(v){
		<cfoutput>
		var a = document.getElementById("IDpreFactura");
		var b = document.getElementById("Ecodigo");
		if(a != null) {
			a.value = v;
			b.value = #Session.Ecodigo#;
		}
		document.getElementById("frListaPF").action='FAprefactura-Imprime.cfm';
		document.getElementById("frListaPF").submit();
		</cfoutput>
	}

    function funcImpresion() {

        if (algunoMarcado('p'))
			document.frListaPF.action = "FAprefactura-Imprime.cfm";
		else
			return false;
	}

	function funcNuevo(){
	}
	function Marcar(c) {
	if (c.checked) {
		for (counter = 0; counter < document.frListaPF.chk.length; counter++)
		{
			if ((!document.frListaPF.chk[counter].checked) && (!document.frListaPF.chk[counter].disabled))
				{  document.frListaPF.chk[counter].checked = true;}
		}
		if ((counter==0)  && (!document.frListaPF.chk.disabled)) {
			document.frListaPF.chk.checked = true;
		}
	}
	else {
		for (var counter = 0; counter < document.frListaPF.chk.length; counter++)
		{
			if ((document.frListaPF.chk[counter].checked) && (!document.frListaPF.chk[counter].disabled))
				{  document.frListaPF.chk[counter].checked = false;}
		};
		if ((counter==0) && (!document.frListaPF.chk.disabled)) {
			document.frListaPF.chk.checked = false;
		}
	};
	}
	// Aplicar
	function algunoMarcado(f){
		var aplica = false;
		if (document.frListaPF.chk) {
			if (document.frListaPF.chk.value) {
				aplica = document.frListaPF.chk.checked;
			}else{
				for (var i=0; i<document.frListaPF.chk.length; i++) {
					if (document.frListaPF.chk[i].checked) {
						aplica = true;
						break;
					}
				}
			}
		}
		if (aplica) {
			if (f == 'A')
			return (confirm("<cfoutput>#MSG_EstaSeguroDeQueDeseaAplicarLosDocumentosSeleccionados#</cfoutput>"));
			else if (f == 'p')
			return (confirm("<cfoutput>#MSG_EstaSeguroQueDeseaImprimirLosDocumentosSeleccionados#</cfoutput>"));
			else
			return (confirm("<cfoutput>#MSG_EstaSeguroDeQueDeseaAnularLosDocumentosSeleccionados#</cfoutput>"));
		} else {

			if (f == 'A')
			alert('<cfoutput>#MSG_DebeSeleccionarAlMenosUnDocumentoAntesDeAplicar#</cfoutput>');
			else if (f == 'p')
			alert('<cfoutput>#MSG_DebeSeleccionarAlMenosUnDocumentoAntesDeImprimir#</cfoutput>');
			else
			alert('<cfoutput>#MSG_DebeSeleccionarAlMenosUnDocumentoAntesDeAnular#</cfoutput>');
		}
	}
	function funcAplicar() {
		if (algunoMarcado())
			document.frListaPF.action = "FAprefactura-sql.cfm";
		else
			return false;
	}

	function funcAplicar_Factura() {
		if (algunoMarcado('A'))
			document.frListaPF.action = "FAprefactura-sql.cfm";
		else
			return false;
	}

	function funcAplicar_Estimado() {
		if (algunoMarcado('A'))
			document.frListaPF.action = "FAprefactura-sql.cfm";

		else
			return false;
	}

	function funcAnular() {
		if (algunoMarcado('X'))
			document.frListaPF.action = "FAprefactura-sql.cfm";
		else
			return false;
	}
	function funcMensaje() {
		
			alert('<cfoutput>#MSG_DebeSeleccionarAlMenosUnDocumentoAntesDeAnular#</cfoutput>');
	}


</script>