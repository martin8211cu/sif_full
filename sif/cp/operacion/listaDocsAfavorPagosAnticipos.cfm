 <cfif isdefined("Url.pageNum_lista") and len(trim(Url.pageNum_lista)) and not isdefined("form.pageNum_lista")>
	<cfset Form.pageNum_lista=Url.pageNum_lista>
</cfif>
<cfif isdefined("Url.usuario") and len(trim(Url.usuario))>
	<cfset Form.usuario=Url.usuario>
</cfif>
<cfif isdefined("Url.descripcion") and len(trim(Url.descripcion))>
	<cfset Form.descripcion=Url.descripcion>
</cfif>
<cfif isdefined("Url.Transaccion") and len(trim(Url.Transaccion))>
	<cfset Form.Transaccion=Url.Transaccion>
</cfif>
<cfif isdefined("Url.Fecha") and len(trim(Url.Fecha))>
	<cfset Form.Fecha=Url.Fecha>
</cfif>				
<cfif isdefined("Url.Moneda") and len(trim(Url.Moneda))>
	<cfset Form.Moneda=Url.Moneda>
</cfif>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Todas = t.Translate('LB_Todas','Todas','/sif/generales.xml')>
<cfset LB_Todos = t.Translate('LB_Todos','Todos','/sif/generales.xml')>
			
<cfoutput>            
<cfquery name="rsTransaccion" datasource="#Session.DSN#">
	select '' as value, '-- #LB_Todas# --' as description from dual
	union all
	select distinct EAplicacionCP.CPTcodigo as value, 
	CPTransacciones.CPTdescripcion  as description 
	from EAplicacionCP, CPTransacciones 
	where EAplicacionCP.Ecodigo=  #Session.Ecodigo# 
	  and CPTransacciones.CPTcodigo = EAplicacionCP.CPTcodigo 
	  and CPTransacciones.Ecodigo = EAplicacionCP.Ecodigo 
</cfquery>
<cfquery name="rsUsuarios" datasource="#Session.DSN#">
	select '' as value, '-- #LB_Todos# --' as description from dual
	union all
	select distinct EAusuario as value, Usulogin as description
	from EAplicacionCP a
	inner join Usuario u
	   on a.EAusuario = u.Usulogin
	where a.Ecodigo=  #Session.Ecodigo# 
</cfquery>
<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select -1 as value, '-- #LB_Todas# --' as description from dual
	union all
	select distinct EAplicacionCP.Mcodigo as value, Monedas.Mnombre as description
	from EAplicacionCP, Monedas 
	where EAplicacionCP.Ecodigo=  #Session.Ecodigo# 
	  and Monedas.Mcodigo = EAplicacionCP.Mcodigo 
</cfquery>
</cfoutput>

<cfif isDefined("Form.BtnAplicar") and isdefined("Form.chk")>
  <cfset chequeados = ListToArray(Form.chk, ',')>
  <cfset cuantos = ArrayLen(chequeados)>
  <cfloop index="CountVar" from="1" to="#cuantos#">
	  <cfset valores = ListToArray(chequeados[CountVar],"|")>

	  <!--- ejecuta el proc.--->
	  <cfset request.error.backs = 1 >	
	  <cfinvoke component="sif.Componentes.CP_PosteoDocsFavorPagosAnticipos" method="CP_PosteoDocsFavorCxP"
			ID 			= "#valores[1]#"
			Ecodigo 	= "#Session.Ecodigo#"
			CPTcodigo 	= "#valores[3]#"
			Ddocumento 	= "#valores[2]#"
			usuario 	= "#Session.usuario#"
			Usucodigo	= "#Session.Usucodigo#"
			fechaDoc 	= "S"
			debug 		= "N"	
		/>
  </cfloop>
</cfif>
            
<cfset campos_extra = ",1 as pageNum_lista" >
<cfif isdefined("form.pageNum_lista") >
	<cfset campos_extra = ",'#form.pageNum_lista#' as pageNum_lista" >
</cfif>

<cf_dbfunction name="to_char" args="a.ID" returnvariable="ID_char">
<cf_dbfunction name="concat" returnvariable="LvarImagen" args="<img border=''0'' src=''/cfmx/sif/imagenes/findsmall.gif'' onClick=''javascript:imprimeDoc2('+#ID_char#+')''>" delimiters="+">
<cf_dbfunction name="concat" returnvariable="LvarActivo" args="#ID_char#+'|'+rtrim(Ddocumento)+'|'+rtrim(a.CPTcodigo)" delimiters="+">

<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Tipo = t.Translate('LB_Tipo','Tipo','/sif/generales.xml')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_USUARIO = t.Translate('LB_Usuario','Usuario','/sif/generales.xml')>
<cfset LB_Total = t.Translate('LB_Total','Total','/sif/generales.xml')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Titulo = t.Translate('LB_Titulo','Lista de Documentos a Favor sin Aplicar')>

<cf_templateheader title="SIF - Cuentas por Pagar">	
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
		<cfinclude template="/sif/portlets/pNavegacionCP.cfm">
        <cfoutput>
			<form style="margin:0" action="AplicaDocsAfavorPagosAnticipos.cfm" method="post" name="form1">           
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="85%" valign="top">
							<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="pListaRet">
							 <cfinvokeargument name="columnas"  
								 value="a.ID as IDpago, t.CPTdescripcion, rtrim(a.CPTcodigo) as CPTcodigo, rtrim(a.Ddocumento) as Ddocumento,EAfecha,m.Mcodigo, m.Mnombre,a.EAusuario,EAtotal,(select count(*) from DAplicacionCP x where a.ID = x.ID) as Balance, EAusuario,
										case (select count(*) from DAplicacionCP x where a.ID = x.ID) when 0 then 
											#LvarActivo#
											else '' end as activo 
											#campos_extra# , 
											'#LvarImagen#' as imagen"/>
								<cfinvokeargument name="tabla"         value="EAplicacionCP a, Monedas m, CPTransacciones t"/>
								<cfinvokeargument name="filtro"  	   value="a.Ecodigo = #Session.Ecodigo#
																						  and m.Mcodigo = a.Mcodigo 
																						  and t.CPTcodigo = a.CPTcodigo 
																						  and t.Ecodigo = a.Ecodigo
                                                                                          and ((coalesce(t.CPTpago,0)=1 and coalesce(t.CPTanticipo,0)=0) or (coalesce(t.CPTpago,0)= 0 and coalesce(t.CPTanticipo,0)=1))"/>
								<cfinvokeargument name="desplegar"  			value="CPTdescripcion, Ddocumento, EAfecha, EAusuario, Mnombre, EAtotal, imagen"/>
								<cfinvokeargument name="filtrar_por"  			value="a.CPTcodigo, Ddocumento, EAfecha, EAusuario, a.Mcodigo, EAtotal, ''"/>
								<cfinvokeargument name="etiquetas"  			value="#LB_Tipo#, #LB_Documento#, #LB_Fecha#, #LB_USUARIO#, #LB_Moneda#, #LB_Total#, "/>
								<cfinvokeargument name="formatos"   			value="S, S, D, S, S, UM, U"/>
								<cfinvokeargument name="align"      			value="left, left, left, left, left, left, center"/>
								<cfinvokeargument name="ajustar"    			value="N"/>
								<cfinvokeargument name="irA"        			value="AplicaDocsAfavorPagosAnticipos.cfm"/>
								<cfinvokeargument name="showLink" 				value="true"/>
								<cfinvokeargument name="checkboxes" 	 	 	value="S"/>
								<cfinvokeargument name="inactivecol" 			value="activo"/>
								<cfinvokeargument name="botones"    			value="Nuevo,Aplicar"/>
								<cfinvokeargument name="showEmptyListMsg" 		value="true"/>
								<cfinvokeargument name="maxrows" 				value="15"/>
								<cfinvokeargument name="keys"             		value="IDpago,Ddocumento,CPTcodigo"/>
								<cfinvokeargument name="mostrar_filtro"			value="true"/>
								<cfinvokeargument name="filtrar_automatico"		value="true"/>
								<cfinvokeargument name="formname"				value="form1"/>
								<cfinvokeargument name="incluyeform"			value="false"/>
								<cfinvokeargument name="rsCPTdescripcion"		value="#rsTransaccion#"/>
								<cfinvokeargument name="rsMnombre"				value="#rsMonedas#"/>
								<cfinvokeargument name="rsEAusuario"			value="#rsUsuarios#"/>
							</cfinvoke>
						</td>
					</tr>
				</table>
			</form>
     	</cfoutput>
	 <cf_web_portlet_end>	
<cf_templatefooter>		

<cfset MSG_EscDocto = t.Translate('MSG_EscDocto','Debe escoger un documento de pago para aplicar')>
<cfset MSG_NoDocto  = t.Translate('MSG_NoDocto','No hay documentos de pago para aplicar')>
<cfset MSG_validaChecks = t.Translate('MSG_validaChecks','¿Desea aplicar los documentos seleccionados?')>

<script language="JavaScript1.2">
	function funcAplicar() {
		if ( validaChecks()  ){ 
			<cfoutput>
			if ( confirm('#MSG_validaChecks#') ){
			</cfoutput>
				<cfif isdefined("form.pageNum_lista")>
					document.form1.PAGENUM_LISTA.value = '<cfoutput>#form.pageNum_lista#</cfoutput>';
				<cfelse>
					document.form1.PAGENUM_LISTA.value = 1;
				</cfif>

				<cfif isdefined('form.filtro_CPTdescripcion') and len(trim(form.filtro_CPTdescripcion)) >
					document.form1.FILTRO_CPTDESCRIPCION.value = '<cfoutput>#JSStringFormat(form.filtro_CPTdescripcion)#</cfoutput>';
				</cfif>
				<cfif isdefined('form.filtro_Ddocumento') and len(trim(form.filtro_Ddocumento))>
					document.form1.FILTRO_DDOCUMENTO.value = '<cfoutput>#JSStringFormat(form.filtro_Ddocumento)#</cfoutput>';
				</cfif>
				<cfif isdefined('form.filtro_EAfecha') and len(trim(form.filtro_EAfecha)) >
					document.form1.FILTRO_EAFECHA.value = '<cfoutput>#JSStringFormat(form.filtro_EAfecha)#</cfoutput>';
				</cfif>
				<cfif isdefined('form.filtro_EAusuario') and len(trim(form.filtro_EAusuario)) >
					document.form1.FILTRO_EAUSUARIO.value = '<cfoutput>#JSStringFormat(form.filtro_EAusuario)#</cfoutput>';
				</cfif>
				<cfif isdefined('form.filtro_Mnombre') and len(trim(form.filtro_Mnombre)) and form.filtro_Mnombre neq -1 >
					document.form1.FILTRO_MNOMBRE.value = '<cfoutput>#JSStringFormat(form.filtro_Mnombre)#</cfoutput>';
				</cfif>

				<cfif isdefined('form.hfiltro_CPTdescripcion') and len(trim(form.hfiltro_CPTdescripcion)) >
					document.form1.HFILTRO_CPTDESCRIPCION.value = '<cfoutput>#JSStringFormat(form.hfiltro_CPTdescripcion)#</cfoutput>';
				</cfif>
				<cfif isdefined('form.hfiltro_Ddocumento') and len(trim(form.hfiltro_Ddocumento))>
					document.form1.HFILTRO_DDOCUMENTO.value = '<cfoutput>#JSStringFormat(form.hfiltro_Ddocumento)#</cfoutput>';
				</cfif>
				<cfif isdefined('form.hfiltro_EAfecha') and len(trim(form.hfiltro_EAfecha)) >
					document.form1.HFILTRO_EAFECHA.value = '<cfoutput>#JSStringFormat(form.hfiltro_EAfecha)#</cfoutput>';
				</cfif>
				<cfif isdefined('form.hfiltro_EAusuario') and len(trim(form.hfiltro_EAusuario)) >
					document.form1.HFILTRO_EAUSUARIO.value = '<cfoutput>#JSStringFormat(form.hfiltro_EAusuario)#</cfoutput>';
				</cfif>
				<cfif isdefined('form.hfiltro_Mnombre') and len(trim(form.hfiltro_Mnombre)) and form.hfiltro_Mnombre neq -1 >
					document.form1.HFILTRO_MNOMBRE.value = '<cfoutput>#JSStringFormat(form.hfiltro_Mnombre)#</cfoutput>';
				</cfif>

				return true;
			}
		}	
		return false;
	}
	<cfoutput>
	function validaChecks(){
		f = document.form1;
		if (f.chk != null) {
			if (f.chk.value) {
				if (!f.chk.checked) { 
					alert("#MSG_EscDocto#");
					return false;
				} else {
					f.action='listaDocsAfavorPagosAnticipos.cfm';
					return true;
				}
			} else {
				for (var i=0; i<f.chk.length; i++) {
					if (f.chk[i].checked) {
						f.action='listaDocsAfavorPagosAnticipos.cfm';
						return true;
					}
				}
				alert("#MSG_EscDocto#");
				return false;
			}
		} else {
			alert("#MSG_NoDocto#");
			return false;
		}
	}
	</cfoutput>
	function Editar(data) {
		if (data!="") {
			document.form1.action='AplicaDocsAfavorPagosAnticipos.cfm';
			document.form1.datos.value = data;
			document.form1.submit();
		}
		return false;
	}
	
	var popupdoc = 0 ;
	function imprimeDoc2(id){
		window.document.form1.nosubmit = true;
		if(popupdoc){ if(!popupdoc.closed) popupdoc.close(); }
		var width = 800;
		var height = 800;
		var top = 80;
		var left = 200;
		popupdoc = open('/cfmx/sif/cp/consultas/DocsFavorComprobantePagosAnticipos.cfm?id='+id, 'popupdoc', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
</script>