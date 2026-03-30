<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Header" default="Facturaci&oacute;n" returnvariable="LB_Header" xmlfile="MetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Cálculo y Registro del Método de Participación" returnvariable="LB_Titulo" xmlfile="MetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Documento" default="Documento" returnvariable="LB_Documento" xmlfile="MetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripción" returnvariable="LB_Descripcion" xmlfile="MetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SeleccionarTodos" default="Seleccionar Todos" returnvariable="LB_SeleccionarTodos" xmlfile="MetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_EstaSeguroDeQueDeseaAplicarLosDocumentosSeleccionados" default="¿Está seguro de que desea aplicar los Documentos seleccionados?" returnvariable="MSG_EstaSeguroDeQueDeseaAplicarLosDocumentosSeleccionados" xmlfile="MetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_EstaSeguroDeQueDeseaAnualLosDocumentosSeleccionados" default="¿Está seguro de que desea ANULAR los Documentos seleccionados?" returnvariable="MSG_EstaSeguroDeQueDeseaAnualLosDocumentosSeleccionados" xmlfile="MetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_DebeSeleccionarAlMenosUnDocumentoAntesDeAplicar" default="Debe seleccionar al menos un documento antes de Aplicar" returnvariable="MSG_DebeSeleccionarAlMenosUnDocumentoAntesDeAplicar" xmlfile="MetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_DebeSeleccionarAlMenosUnDocumentoAntesDeAnular" default="Debe seleccionar al menos un documento antes de Anular" returnvariable="MSG_DebeSeleccionarAlMenosUnDocumentoAntesDeAnular" xmlfile="MetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PctjePar" default="% de Participación" returnvariable="LB_PctjePar" 
xmlfile="MetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Capital" default="Capital" returnvariable="LB_Capital" 
xmlfile="MetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Anulada" default="Anulada" returnvariable="LB_Anulada" xmlfile="MetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Terminada" default="Terminada" returnvariable="LB_Terminada" xmlfile="MetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Vencida" default="Vencida" returnvariable="LB_Vencida" xmlfile="MetodoParticipacion.xml">



<!--- Sentencias para mantener el filtro de la Lista --->
<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
	<cfset Form.SNcodigo = url.SNcodigo>
</cfif>

<cfif isdefined("url.Mcodigo") and not isdefined("form.Mcodigo")>
	<cfset Form.Mcodigo = url.Mcodigo>
</cfif>

<cfif isdefined("url.Ocodigo") and not isdefined("form.Ocodigo")>
	<cfset Form.Ocodigo = url.Ocodigo>
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

<cfif isdefined("url.Mcodigo") and not isdefined("form.Mcodigo")>
	<cfset Navegacion = Navegacion & "Mcodigo=#Form.Mcodigo#&">
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


<cf_templateheader title="#LB_Titulo#">
	<cf_templatecss>
		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_Titulo#">
		<table width="100%" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<cfinclude template="../../portlets/pNavegacion.cfm">
				</td>
			</tr>
			<tr align="center">
				<td  valign="top">
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
                        <cfinclude template="../../cg/operacion/formMetodoParticipacion.cfm">
					<cfelseif (isdefined("Form.IDpreFactura") and len(trim(form.IDpreFactura))) or (isdefined("Form.btnNuevo"))>
						<cfinclude template="../../cg/operacion/formMetodoParticipacion.cfm">
					<cfelse>
						<!--- Filtro para la lista --->
						<cfinclude template="../../cg/operacion/filtroMetodoParticipacion.cfm">
       				<form style="margin: 0" action="MetodoParticipacion.cfm" name="frListaPF" method="post" id="frListaPF">
		                        <tbody  ><tbody  >
								<!---<tr><td align="left">					
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
		                        </td></tr>--->   
		                        <tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tbody  >
								<!---<tr><td align="left">
			                        <input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);" style="background:background-color ">
		    			            <label for="chkTodos"><cfoutput>#LB_SeleccionarTodos#</cfoutput></label>
		                        </td></tr>--->
						<cfquery name="rsPF" datasource="#session.dsn#">
							Select 
									IDpreFactura, SNnombre,fac.SNcodigo,
                                    PFDocumento,
									case Estatus
										when 'P' then '#LB_Pendiente#'
										when 'E' then '#LB_Estimada#'
                                        when 'A' then '#LB_Anulada#'
                                        when 'T' then '#LB_Terminada#'
                                        when 'V' then '#LB_Vencida#'
									end Estatus,
                                    case Estatus
										when 'P' then 0
										when 'E' then 0
                                        when 'A' then IDpreFactura
                                        when 'T' then IDpreFactura
                                        when 'V' then IDpreFactura
									end as inactiva,
									Estatus as estado,
                                    m.Mnombre as Moneda,
                                    pf.PFTdescripcion as Transaccion,
                                    o.Odescripcion
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
                            	and Estatus in ('P','E')
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
								<cfinvokeargument name="desplegar" value="PFdocumento, Odescripcion, Estatus,Moneda,Transaccion"/>
								<cfinvokeargument name="etiquetas" value="#LB_Documento#,#LB_Descripcion#,#LB_PctjePar#,#LB_Capital#,#LB_Moneda#"/>
								<cfinvokeargument name="formatos" value="S, S, S, S, S"/>
                                <cfinvokeargument name="cortes" value="SNnombre"/>
								<cfinvokeargument name="align" value="left, left, left, left, left"/>
								<cfinvokeargument name="ajustar" value="N, N, N, N, N"/>
								<cfinvokeargument name="irA" value="MetodoParticipacion.cfm"/>
								<cfinvokeargument name="keys" value="IDpreFactura"/>
								<cfinvokeargument name="checkboxes" value="S"/>
								<cfinvokeargument name="botones" value="Nuevo,Aplicar,Eliminar"/>
								<cfinvokeargument name="formName" value="frListaPF"/>
								<cfinvokeargument name="showemptylistmsg" value="true"/>
                                <cfinvokeargument name="inactivecol" value="inactiva"/>
                                <cfinvokeargument name="MaxRows" value="#Registros#"/>
			                    <cfinvokeargument name="Navegacion" value="#Navegacion#"/>
						</cfinvoke>
					</cfif>
        			</form>
				</td>
			</tr>		
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>

<script language="javascript" type="text/javascript">
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
			else 
			return (confirm("<cfoutput>#MSG_EstaSeguroDeQueDeseaAnualLosDocumentosSeleccionados#</cfoutput>"));
		} else {
			if (f == 'A')
			alert('<cfoutput>#MSG_DebeSeleccionarAlMenosUnDocumentoAntesDeAplicar#</cfoutput>');
			else
			alert('<cfoutput>#MSG_DebeSeleccionarAlMenosUnDocumentoAntesDeAnular#</cfoutput>');
			return false;
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
</script>
