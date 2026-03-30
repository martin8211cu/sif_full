<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Cálculo y Registro del Método de Participación" returnvariable="LB_Titulo" xmlfile="MetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Documento" default="Documento" returnvariable="LB_Documento" xmlfile="MetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripción" returnvariable="LB_Descripcion" xmlfile="MetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SeleccionarTodos" default="Seleccionar Todos" returnvariable="LB_SeleccionarTodos" xmlfile="MetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_EstaSeguroDeQueDeseaAplicarLosDocumentosSeleccionados" default="¿Está seguro de que desea aplicar los Documentos seleccionados?" returnvariable="MSG_EstaSeguroDeQueDeseaAplicarLosDocumentosSeleccionados" xmlfile="MetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_EstaSeguroDeQueDeseaEliminarLosDocumentosSeleccionados" default="¿Está seguro de que desea ELIMINAR los Documentos seleccionados?" returnvariable="MSG_EstaSeguroDeQueDeseaEliminarLosDocumentosSeleccionados" xmlfile="MetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_DebeSeleccionarAlMenosUnDocumentoAntesDeAplicar" default="Debe seleccionar al menos un documento antes de Aplicar" returnvariable="MSG_DebeSeleccionarAlMenosUnDocumentoAntesDeAplicar" xmlfile="MetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_DebeSeleccionarAlMenosUnDocumentoAntesDeEliminar" default="Debe seleccionar al menos un documento antes de Eliminar" returnvariable="MSG_DebeSeleccionarAlMenosUnDocumentoAntesDeEliminar" xmlfile="MetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PctjePar" default="% de Participación" returnvariable="LB_PctjePar"
xmlfile="MetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Capital" default="Capital" returnvariable="LB_Capital"
xmlfile="MetodoParticipacion.xml">




<!--- Sentencias para mantener el filtro de la Lista --->
<cfif isdefined("url.SNnombreU") and not isdefined("form.SNnombreU")>
	<cfset Form.SNnombreU = url.SNnombreU>
</cfif>

<cfif isdefined("url.Periodo") and not isdefined("form.Periodo")>
	<cfset Form.Periodo = url.Periodo>
</cfif>

<cfif isdefined("url.Mes") and not isdefined("form.Mes")>
	<cfset Form.Mes = url.Mes>
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
<cfif isdefined("Form.SNnombreU") and len(trim(form.SNnombreU))>
	<cfset Navegacion = Navegacion & "SNnombreU=#Form.SNnombreU#&">
</cfif>

<cfif isdefined("url.Periodo") and not isdefined("form.Periodo")>
	<cfset Navegacion = Navegacion & "Periodo=#Form.Periodo#&">
</cfif>

<cfif isdefined("url.Mes") and not isdefined("form.Mes")>
	<cfset Navegacion = Navegacion & "Periodo=#Form.Mes#&">
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
					<cfif (isdefined("Form.MetParID") and len(trim(Form.MetParID))) or (isdefined("Form.btnNuevo"))>
						<cfinclude template="formMetodoParticipacion.cfm">

					<cfelse>
						<!--- Filtro para la lista --->

						<cfinclude template="filtroMetodoParticipacion.cfm">
       				<form style="margin: 0" action="MetodoParticipacion.cfm" name="frListaMP" method="post" id="frListaMP">
		                        <tbody  ><tbody  >

		                        <tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tbody  ><tbody  >
								<!---<tr><td align="left">
			                        <input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);" style="background:background-color ">
		    			            <label for="chkTodos"><cfoutput>#LB_SeleccionarTodos#</cfoutput></label>
		                        </td></tr>--->

                         <cfquery name="rsMP" datasource="#session.dsn#">
                         	select emp.MetParID, emp.SNid,sn.SNnombre, emp.Documento, emp.Descripcion,m.Miso4217,dmp.pctjePart, dmp.Capital
                            from EMetPar emp left join DMetPar dmp on emp.Ecodigo=dmp.Ecodigo and emp.MetParID=dmp.MetParID
                            inner join SNegocios sn on sn.Ecodigo=emp.Ecodigo and sn.SNid=emp.SNid
                            left join Monedas m on dmp.Ecodigo=m.Ecodigo and dmp.Mcodigo=m.Mcodigo
                            where emp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                                    <!--- And Filtros seleccionados --->
                            <cfif isdefined('form.SNnombreU') and len(trim(form.SNnombreU)) and form.SNnombreU NEQ '-1'>
									and emp.SNid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnombreU#">
							</cfif>
							<cfif isdefined('form.Periodo') and len(trim(form.Periodo)) and form.Periodo NEQ '-1'>
									and emp.Periodo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Periodo#">
							</cfif>
							<cfif isdefined('form.Mes') and len(trim(form.Mes)) and form.Mes NEQ '-1'>
									and emp.Mes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Mes#">
							</cfif>


                         </cfquery>


						<cfinvoke
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaRet">
								<cfinvokeargument name="query" value="#rsMP#"/>
								<cfinvokeargument name="desplegar" value="Documento, Descripcion, pctjePart,Capital,Miso4217"/>
								<cfinvokeargument name="etiquetas" value="#LB_Documento#,#LB_Descripcion#,#LB_PctjePar#,#LB_Capital#,#LB_Moneda#"/>
								<cfinvokeargument name="formatos" value="S, S, S, S, S"/>
                                <cfinvokeargument name="cortes" value="SNnombre"/>
								<cfinvokeargument name="align" value="left, left, left, left, left"/>
								<cfinvokeargument name="ajustar" value="N, N, N, N, N"/>
								<cfinvokeargument name="irA" value="MetodoParticipacion.cfm"/>
								<cfinvokeargument name="keys" value="MetParID"/>
								<cfinvokeargument name="checkboxes" value="S"/>
								<cfinvokeargument name="botones" value="Nuevo,Aplicar,Eliminar"/>
								<cfinvokeargument name="formName" value="frListaMP"/>
								<cfinvokeargument name="showemptylistmsg" value="true"/>
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
		for (counter = 0; counter < document.frListaMP.chk.length; counter++)
		{
			if ((!document.frListaMP.chk[counter].checked) && (!document.frListaMP.chk[counter].disabled))
				{  document.frListaMP.chk[counter].checked = true;}
		}
		if ((counter==0)  && (!document.frListaMP.chk.disabled)) {
			document.frListaMP.chk.checked = true;
		}
	}
	else {
		for (var counter = 0; counter < document.frListaMP.chk.length; counter++)
		{
			if ((document.frListaMP.chk[counter].checked) && (!document.frListaMP.chk[counter].disabled))
				{  document.frListaMP.chk[counter].checked = false;}
		};
		if ((counter==0) && (!document.frListaMP.chk.disabled)) {
			document.frListaMP.chk.checked = false;
		}
	};
	}
	// Aplicar
	function algunoMarcado(f){

		var aplica = false;
		if (document.frListaMP.chk) {
			if (document.frListaMP.chk.value) {
				aplica = document.frListaMP.chk.checked;
			}else{
				for (var i=0; i<document.frListaMP.chk.length; i++) {
					if (document.frListaMP.chk[i].checked) {
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
			return (confirm("<cfoutput>#MSG_EstaSeguroDeQueDeseaEliminarLosDocumentosSeleccionados#</cfoutput>"));
		} else {
			if (f == 'A')
			alert('<cfoutput>#MSG_DebeSeleccionarAlMenosUnDocumentoAntesDeAplicar#</cfoutput>');
			else
			alert('<cfoutput>#MSG_DebeSeleccionarAlMenosUnDocumentoAntesDeEliminar#</cfoutput>');
			return false;
		}
	}
	function funcAplicar() {
		if (algunoMarcado('A'))
			document.frListaMP.action = "SQLMetodoParticipacion.cfm";
		else
			return false;
	}

	function funcEliminar() {
		if (algunoMarcado('E'))
			document.frListaMP.action = "SQLMetodoParticipacion.cfm";
		else
			return false;
	}





	function funcAnular() {
		if (algunoMarcado('X'))
			document.frListaMP.action = "SQLMetodoParticipacion.cfm";
		else
			return false;
	}
</script>
