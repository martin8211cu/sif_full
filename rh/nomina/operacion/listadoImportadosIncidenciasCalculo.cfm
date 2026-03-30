<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_RecursosHumanos"
	default="Recursos Humanos"
	xmlfile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">		
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>

<!--- Usuarios que han insertado incidencias --->
<cfquery name="rsUsuariosRegistro" datasource="#Session.DSN#">
	select distinct coalesce(a.Usucodigo,-1) as Usucodigo
	from CIncidentes c
		inner join Incidencias a
			on c.CIid = a.CIid 	
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsUsuarios" datasource="asp">
	select u.Usucodigo as Codigo,
		  {fn concat({fn concat({fn concat({ fn concat(d.Pnombre, ' ') }, d.Papellido1)}, ' ')}, d.Papellido2) } as Nombre
	from Usuario u	
		inner join DatosPersonales d
			on u.datos_personales = d.datos_personales
	<cfif rsUsuariosRegistro.recordCount GT 0>
		where u.Usucodigo in ( #ValueList(rsUsuariosRegistro.Usucodigo)# )
	<cfelse>
		where u.Usucodigo = 0
	</cfif>
</cfquery> 

<!--- filtro para la lista --->
<cfset navegacion = "" >
<cfset filtro2 = ''>
<cfif isdefined("url.btnFiltrar") and not isdefined("form.btnFiltrar")><cfset form.btnFiltrar=1></cfif>
<cfif isdefined("form.btnFiltrar")><cfset navegacion="&btnFiltrar=1"></cfif>

<cfset filtro = "b.Ecodigo = " & Session.Ecodigo >
<cfset filtro = filtro & " and a.CIid = b.CIid and a.DEid = c.DEid and CItipo != 3">

<cfif isdefined("url.Usuario") and len(trim(url.Usuario)) and not isdefined("form.Usuario")>
	<cfset form.Usuario = url.Usuario>
	<cfset navegacion = trim(navegacion) & "&Usuario=#form.Usuario#">	
</cfif>

<cfif isdefined("Form.Usuario") and Len(Trim(Form.Usuario)) NEQ 0 and Form.Usuario NEQ "-1">
	<cfset filtro = filtro & " and a.Usucodigo = #form.Usuario#" >
	<cfset filtro2 = filtro2 & " and a.Usucodigo = #form.Usuario#" >
	<cfset navegacion = trim(navegacion) & "&Usuario=#form.Usuario#">	
<cfelseif isdefined("Form.Usuario") and Len(Trim(Form.Usuario)) NEQ 0 and Form.Usuario EQ "-1">	
	<cfset filtro = "b.Ecodigo = " & #Session.Ecodigo# >
	<cfset filtro = filtro & " and a.CIid = b.CIid and a.DEid = c.DEid and CItipo != 3">		
	<cfset navegacion = trim(navegacion) & "&Usuario=#form.Usuario#">	
<cfelse>
	<cfset filtro =  filtro & " and a.Usucodigo = " & Session.Usucodigo & " and a.Ulocalizacion = '" & Session.Ulocalizacion & "'">
	<cfset filtro2 =  filtro2 & " and a.Usucodigo = " & Session.Usucodigo & " and a.Ulocalizacion = '" & Session.Ulocalizacion & "'">
	<cfset Form.Usuario = Session.Usucodigo >	
</cfif>

<cfset array_valores = ArrayNew(1)>
<cfif isdefined("url.CIid") and len(trim(url.CIid)) gt 0 and not isdefined("form.CIid")><cfset form.CIid=url.CIid></cfif>
<cfif isdefined("form.CIid") and len(trim(form.CIid)) gt 0 and isdefined("btnFiltrar")>
	<cfset navegacion = trim(navegacion) & "&CIid=#form.CIid#">
	<cfset filtro = filtro & " and a.CIid=" & form.CIid>
	<cfset filtro2 = filtro2 & " and a.CIid=" & form.CIid>
	<cfquery name="rsIncidencia" datasource="#session.DSN#">
		select CIid,CIcodigo,CIdescripcion
		from CIncidentes
		where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
	</cfquery>
	<cfset array_valores[1] = "#rsIncidencia.CIid#">
	<cfset array_valores[2] = "#rsIncidencia.CIcodigo#">
	<cfset array_valores[3] = "#rsIncidencia.CIdescripcion#">	
</cfif>

<cfif isdefined("url.Ffecha") and len(trim(url.Ffecha))><cfset form.Ffecha=url.Ffecha></cfif>
<cfif isdefined("form.Ffecha") and len(trim(form.Ffecha)) gt 0 and isdefined("btnFiltrar")>
	<cfset navegacion = trim(navegacion) & "&Ffecha=#form.Ffecha#">	
	<cfset filtro = filtro & " and a.Ifecha =" & LSParseDateTime(form.Ffecha)>
	<cfset filtro2 = filtro2 & " and a.Ifecha =" & LSParseDateTime(form.Ffecha)>
</cfif>

<!--- ============================================= --->
<!--- Traducciones --->
<!--- ============================================= --->
<!--- Concepto_Incidente --->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="Concepto_Incidente"
	default="Concepto Incidente"
	xmlfile="/rh/generales.xml"
	returnvariable="vConcepto"/>		
<!--- Fecha --->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Fecha"
	default="Fecha"
	xmlfile="/rh/generales.xml"
	returnvariable="vFecha"/>			
<!--- Filtrar --->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Filtrar"
	default="Filtrar"
	xmlfile="/rh/generales.xml"
	returnvariable="vFiltrar"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Codigo"
	default="C&oacute;digo"
	xmlfile="/rh/generales.xml"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Descripcion"
	default="Descripci&oacute;n"
	xmlfile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
<!--- Empleado --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Empleado"
	default="Empleado"
	xmlfile="/rh/generales.xml"
	returnvariable="vEmpleado"/>		
<!--- Cantidad/Monto --->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Cantidad_Monto"
	default="Cantidad/Monto"
	returnvariable="vCantidadMonto"/>
	<!--- Cantidad/Calculado --->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Cantidad_Monto"
	default="Monto Calculado"
	returnvariable="vCalculado"/>
<!--- Icpespecial --->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_CP_Especiales"
	default="CP Especiales"
	returnvariable="vIcpespecial"/>			

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_ListaDeLoteImportado"
	default="Lista de Lote Importado"
	returnvariable="LB_ListaDeLoteImportado"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_ListaDeConceptosIncidentes"
	default="Lista de Conceptos Incidentes"
	returnvariable="LB_ListaDeConceptosIncidentes"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_EstaSeguroQueDeseaEliminarLaIncidencia"
	default="Esta seguro que desea eliminar la incidencia"
	returnvariable="LB_EstaSeguroQueDeseaEliminarLaIncidencia"/>	

	
	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cf_web_portlet_start border="true" titulo="#LB_ListaDeLoteImportado#" skin="#Session.Preferences.Skin#">
						<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
							<tr><td colspan="3" align="center">
								<cfset regresar = '/cfmx/rh/nomina/operacion/Incidencias.cfm' >
								<cfinclude template="/rh/portlets/pNavegacion.cfm">
							</td></tr>
							<tr><td></td></tr>	
								<cfoutput>
								<table width="100%" cellpadding="0" cellspacing="0">
									<!----==================== FILTRO ====================----->
									<tr>
										<td>
											<form name="formUsuario" method="post" action="listadoImportadosIncidenciasCalculo.cfm">
												<table class="areaFiltro" width="100%" border="0" cellspacing="0" cellpadding="0">
													<tr>														
														<cfif rsUsuarios.recordCount GT 0>
															<td>																
																<cf_translate key="LB_Usuario" xmlfile="/rh/generales.xml">Usuario</cf_translate><br>
																<select name="Usuario" tabindex="1"><!----onChange="javascript: this.form.submit();" ---->
																	<option value="-1" <cfif Form.Usuario EQ "-1">selected</cfif>>(<cf_translate key="LB_Todos" xmlfile="/rh/generales.xml">Todos</cf_translate>)</option>
																	<cfloop query="rsUsuarios">
																		<option value="#rsUsuarios.Codigo#" <cfif Form.Usuario EQ rsUsuarios.Codigo>selected</cfif>>#rsUsuarios.Nombre#</option>
																	</cfloop>
																</select>
															</td>
														</cfif>
														<td nowrap>
															<cf_translate key="LB_Fecha">Fecha</cf_translate> 
															<cfif isdefined("form.Ffecha") and len(trim(form.Ffecha))>
																<cf_sifcalendario form="formUsuario" name="Ffecha" value="#form.Ffecha#">
															<cfelse>
																<cf_sifcalendario form="formUsuario" name="Ffecha" value="">
															</cfif>
														</td>
														<td nowrap>
															<cf_translate key="LB_Concepto_Incidente">Concepto Incidente</cf_translate>
															<!---Se muestran las incidencias de tipo 3 (calculo) con el bit de nomostrar apagado---->
															<!-----and coalesce(CInomostrar,0) = 0---->
															<cf_conlis title="#LB_ListaDeConceptosIncidentes#"
																campos = "CIid, CIcodigo, CIdescripcion" 
																desplegables = "N,S,S" 
																modificables = "N,S,S" 
																size = "0,10,20"
																asignar="CIid, CIcodigo, CIdescripcion"
																asignarformatos="N,S,S"
																tabla="CIncidentes"																	
																columnas="CIid, CIcodigo, CIdescripcion"
																filtro="Ecodigo =#session.Ecodigo#																		
																		and CItipo = 3
																		and CIcarreracp = 0"
																desplegar="CIcodigo, CIdescripcion"
																etiquetas="	#LB_Codigo#, 
																			#LB_Descripcion#"
																formatos="S,S"
																align="left,left"
																showEmptyListMsg="true"
																debug="false"
																form="formUsuario"
																width="800"
																height="500"
																left="70"
																top="20"
																filtrar_por="CIcodigo/
																			CIdescripcion"
																filtrar_por_delimiters="/"
																ValuesArray="#array_valores#">																
														</td>	
														<td>
															<input type="submit" name="btnFiltrar" value="#vFiltrar#">	
														</td>			
													</tr>
												</table>
									<!----==================== LISTA ====================---->
                                                <table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
                                                    <tr> 
                                                           <td>
																
                                                            <cfquery name="rsLista" datasource="#Session.DSN#">	 <!----Las incidencias tipo calculo que tienen bit de NOmostrar en 0---->
                                                                select  a.Id as Chequeado,#Form.Usuario# as Usuario,
                                                                        a.CIid,
                                                                        b.CIdescripcion, 
                                                                        a.Ifecha, 																
                                                                        case b.CItipo  	when 0 then { fn concat (<cf_dbfunction name="to_char" args="Ivalor">, ' hora(s)' ) }
                                                                                        when 1 then { fn concat (<cf_dbfunction name="to_char" args="Ivalor">, ' día(s)' ) }
                                                                                        else <cf_dbfunction name="to_char" args="Ivalor"> end as Ivalor,
																		a.Imontores,
                                                                        {fn concat({fn concat({fn concat({ fn concat( c.DEnombre, ' ') }, c.DEapellido1)}, ' ')}, c.DEapellido2) }  as NombreEmp ,
                                                                        case when a.Icpespecial = 0 then '<img src="/cfmx/rh/imagenes/unchecked.gif">'
                                                                            else '<img src="/cfmx/rh/imagenes/checked.gif">' 
                                                                        end as Icpespecial
                                                                        ,a.Id		
                                                                        ,a.Id as IDeliminar 
                                                                from  IMPIncidentes a, CIncidentes b, DatosEmpleado c
                                                                where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                                                                    and a.CIid = b.CIid 
                                                                    and a.DEid = c.DEid																
                                                                    #preservesinglequotes(filtro2)#																	
                                                                order by a.Ifecha desc
                                                            </cfquery>
                                                            <cfinvoke component="sif.Componentes.Translate"
                                                             method="Translate"
                                                             key="LB_NoSeEncontraronRegistros"
                                                             default="No se encontraron Registros "
                                                             returnvariable="LB_NoSeEncontraronRegistros"/> 
   
                                                            <cfinvoke component="rh.Componentes.pListas"
                                                             method="pListaQuery"
                                                             returnvariable="pListaRet">
                                                                <cfinvokeargument name="query" value="#rsLista#"/>
                                                                <cfinvokeargument name="desplegar" value="Ifecha, CIdescripcion, NombreEmp, Ivalor, Imontores, Icpespecial"/>
                                                                <cfinvokeargument name="etiquetas" value="#vFecha#, #vConcepto#, #vEmpleado#, #vCantidadMonto#, #vCalculado#,#vIcpespecial#"/>
                                                                <cfinvokeargument name="formatos" value="D,V,V,V,M,V"/>
                                                                <cfinvokeargument name="align" value="center, left, left, right, right,center"/>
                                                                <cfinvokeargument name="ajustar" value="N"/>															
                                                                <cfinvokeargument name="showEmptyListMsg" value="true"/>
                                                                <cfinvokeargument name="EmptyListMsg" value="#LB_NoSeEncontraronRegistros#"/>
                                                                <cfinvokeargument name="navegacion" value="#navegacion#"/>
                                                                <cfinvokeargument name="maxRows" value="30"/>
                                                                <cfinvokeargument name="checkboxes" value="S"/>		
                                                                <cfinvokeargument name="keys" value="Id"/>	
                                                                <cfinvokeargument name="checkall" value="S"/>
                                                                <cfinvokeargument name="checkbox_function" value="UpdChkAll(this)"/>
																<cfif rsLista.recordcount gt 0 >
																	<cfinvokeargument name="botones" value="Eliminar,Eliminar_Todas,Aplicar,Aplicar_Todas, Recalcular, Recalcular_Todas"/>
																</cfif>
                                                                <cfinvokeargument name="showLink" value="false"/>
																<cfinvokeargument name="formName" value="formUsuario"/>
																<cfinvokeargument name="irA" value="SQL_IncidenciasImpCalculo.cfm">
                                                            </cfinvoke>			
													   </form>		
                                                        </td>
                                                    </tr>
												</table>
                                            	<!-----==================== REGRESAR ====================---->
                                                <tr><td align="center">
                                                        <table cellpadding="0" cellspacing="10">
                                                            <tr>
                                                                  <td align="center">
                                                                    <cfinvoke component="sif.Componentes.Translate"
                                                                    method="Translate"
                                                                    key="BTN_Regresar"
                                                                    default="Regresar"
                                                                    xmlfile="/rh/generales.xml"
                                                                    returnvariable="BTN_Regresar"/>
                                                                    <input type="button" name="Regresar" value="<cfoutput>#BTN_Regresar#</cfoutput>"
                                                                        onclick="javascript:location.href='importarIncidencias.cfm?cualimportador=c'">	
                                                                </td>
                                                            </tr>
                                                        </table>
                                                </td></tr>	
											</form>
										</td>
									</tr>
								</table>
								</cfoutput>
	                <cf_web_portlet_end>
				</td>	
			</tr>
		</table>
<script type="text/javascript" language="javascript1.2">
	function funcAplicar(){
		if (!fnAlgunoMarcadolista()){
			alert("¡Debe seleccionar al menos una Incidencia para Aplicar!");
			return false;
		}else{
			if ( confirm("¿Desea Aplicar las Incidencias marcadas?") )	{
				document.formUsuario.action = 'SQL_IncidenciasImpCalculo.cfm';
				return true;
			}
			return false;
		}		
	}
	
	function funcAplicar_Todas(){
			if ( confirm("¿Desea Aplicar TODAS las incidencias?") )	{
			document.formUsuario.action = '	SQL_IncidenciasImpCalculo.cfm';
				return true;
			}
			return false;
	}
	
	//CHEQUEAR
	function funcChkAll(c) {
		if (document.formUsuario.chk) {
			if (document.formUsuario.chk.value) {
				if (!document.formUsuario.chk.disabled) { 
					document.formUsuario.chk.checked = c.checked;
					//funcChkSolicitud(document.filtro.chk);
				}
			} else {
				for (var counter = 0; counter < document.formUsuario.chk.length; counter++) {
					if (!document.formUsuario.chk[counter].disabled) {
						document.formUsuario.chk[counter].checked = c.checked;
						//funcChkSolicitud(document.form1.ESidsolicitud[counter]);
					}
				}
			}
		}
	}
	//Deschequear
	function UpdChkAll(c) {	
		var allChecked = true;
		if (!c.checked) {
			allChecked = false;
		} else {
			if (document.formUsuario.chk.value) {
				if (!document.formUsuario.chk.disabled) allChecked = true;
			} else {
				for (var counter = 0; counter < document.formUsuario.chk.length; counter++) {
					if (!document.formUsuario.chk[counter].disabled && !document.formUsuario.chk[counter].checked) {allChecked=false; break;}
				}
			}
		}
		document.formUsuario.chkAllItems.checked = allChecked;								
	}
	
	
	function fnAlgunoMarcadolista(){
		if (document.formUsuario.chk) {
			if (document.formUsuario.chk.value) {
				return document.formUsuario.chk.checked;
			} else {
				for (var i=0; i<document.formUsuario.chk.length; i++) {
					if (document.formUsuario.chk[i].checked) { 
						return true;
					}
				}
			}
		}
		return false;
	}
	function funcEliminar(){
		if (!fnAlgunoMarcadolista()){
			alert("¡Debe seleccionar al menos una Incidencia para eliminar!");
			return false;
		}else{
			if ( confirm("¿Desea Eliminar las Incidencias marcadas?") )	{
				document.formUsuario.action = '	SQL_IncidenciasImpCalculo.cfm';
				return true;
			}
			return false;
		}		
	}
	

	function funcEliminar_Todas(){
			if ( confirm("¿Desea Eliminar TODAS las incidencias?") )	{
				document.formUsuario.action = '	SQL_IncidenciasImpCalculo.cfm';
				return true;
			}
			return false;
	}

	function funcRecalcular(){
		if (!fnAlgunoMarcadolista()){
			alert("¡Debe seleccionar al menos una Incidencia para Recalcular!");
			return false;
		}else{
			if ( confirm("¿Desea Recalcular las Incidencias marcadas?") )	{
				document.formUsuario.action = 'SQL_IncidenciasImpCalculo.cfm';
				return true;
			}
			return false;
		}	
	}
	
	function funcRecalcular_Todas(){
			if ( confirm("¿Desea Recalcular TODAS las incidencias?") )	{
				document.formUsuario.action = '	SQL_IncidenciasImpCalculo.cfm';
				return true;
			}
			return false;
	}
	


</script>	
<cf_templatefooter>