<cfinvoke key="BTN_Filtrar" default="Filtrar" returnvariable="vFiltrar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="BTN_Limpiar" default="Limpiar" returnvariable="vLimpiar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_Fecha" default="Fecha" returnvariable="vFecha" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_Deduccion" default="Deducci&oacute;n" returnvariable="vDeduccion" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_Metodo" default="M&eacute;todo" returnvariable="vMetodo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Valor" default="Valor" returnvariable="vValor" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Estado" default="Estado" returnvariable="vEstado" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>

<cfif isdefined("url.o") and not isdefined("form.o")>
	<cfset form.o = url.o>
</cfif>

<cfif isdefined("url.sel") and not isdefined("form.sel")>
	<cfset form.sel = url.sel>
</cfif>

<cfif isdefined("url.Did") and not isdefined("form.Did")>
	<cfset form.Did = url.Did>
</cfif>
<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
	<cfset form.DEid = url.DEid>
</cfif>
<cfif isdefined("url.fEstado") and not isdefined("form.fEstado")>
	<cfset form.fEstado = url.fEstado>
</cfif>
<cfif isdefined("url.fFecha") and not isdefined("form.fFecha")>
	<cfset form.fFecha = url.fFecha>
</cfif>
<cfif isdefined("url.fSNcodigo") and not isdefined("form.fSNcodigo")>
	<cfset form.fSNcodigo = url.fSNcodigo>
</cfif>
<cfif isdefined("url.fSNnumero") and not isdefined("form.fSNnumero")>
	<cfset form.fSNnumero = url.fSNnumero>
</cfif>
<cfif isdefined("url.modo") and not isdefined("form.modo")>
	<cfset form.modo = url.modo>
</cfif>


<cfset navegacionDed = "">
<cfset navegacionDed = navegacionDed & Iif(Len(Trim(navegacionDed)) NEQ 0, DE("&"), DE("")) & "o=8">
<cfif isdefined("Form.DEid")>
	<cfset navegacionDed = navegacionDed & Iif(Len(Trim(navegacionDed)) NEQ 0, DE("&"), DE("")) & "DEid=" & Form.DEid>
</cfif>
<cfif isdefined("Form.sel")>
	<cfset navegacionDed = navegacionDed & Iif(Len(Trim(navegacionDed)) NEQ 0, DE("&"), DE("")) & "sel=" & Form.sel>
</cfif> 
<cfif isdefined("Form.fEstado")>
	<cfset navegacionDed = navegacionDed & Iif(Len(Trim(navegacionDed)) NEQ 0, DE("&"), DE("")) & "fEstado=" & Form.fEstado>
</cfif> 
<cfif isdefined("Form.fFecha")>
	<cfset navegacionDed = navegacionDed & Iif(Len(Trim(navegacionDed)) NEQ 0, DE("&"), DE("")) & "fFecha=" & Form.fFecha>
</cfif> 
<cfif isdefined("Form.fSNcodigo")>
	<cfset navegacionDed = navegacionDed & Iif(Len(Trim(navegacionDed)) NEQ 0, DE("&"), DE("")) & "fSNcodigo=" & Form.fSNcodigo>
</cfif> 
<cfif isdefined("Form.fSNnumero")>
	<cfset navegacionDed = navegacionDed & Iif(Len(Trim(navegacionDed)) NEQ 0, DE("&"), DE("")) & "fSNnumero=" & Form.fSNnumero>
</cfif> 
<cfif isdefined('form.BtnFiltrar')>
	<cfset form.PageNum_lista = 1>
</cfif>

<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.filtro.fSNnumero.value = '';
		document.filtro.fSNnombre.value = '';
		document.filtro.fSNcodigo.value = '';
		document.filtro.fFecha.value = '';
		document.filtro.fEstado.value = '';
	}
</script>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td colspan="2" align="center"><table align="center" width="95%"><tr><td align="center">
		<cfinclude template="/rh/portlets/pEmpleado.cfm">
	</td></tr></table></td></tr>	
	<tr><td>&nbsp;</td></tr>
						
	<tr>
		<td>
			<table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td valign="top" width="50%">
						<form style="margin:0" name="filtro" method="post">
						<table width="100%" cellpadding="2" cellspacing="0" class="areaFiltro">
							<tr>
								<td><strong><cf_translate key="LB_Socio">Socio</cf_translate></strong></td>
								<td><strong><cfoutput>#vFecha#</cfoutput></strong></td>
								<td><strong><cfoutput>#vEstado#</cfoutput></strong></td>
							</tr>

							<tr>
								<td>
									<cf_rhsociosnegociosFA form="filtro" frame="frame_filtro" SNcodigo="fSNcodigo" SNnombre="fSNnombre" SNnumero="fSNnumero" >
									<cfif isdefined("form.fSNnumero") and len(trim(form.fSNnumero)) gt 0>
										<script language="JavaScript1.2" type="text/javascript">
											document.filtro.fSNnumero.value = '<cfoutput>#form.fSNnumero#</cfoutput>';
											document.filtro.fSNnumero.focus();
											document.filtro.fSNnumero.blur();
										</script>									
									</cfif>
								</td>
								<td>
									<cfset fecha = '' >
									<cfif isdefined("form.fFecha")>
										<cfset fecha = form.fFecha >
									</cfif>
									<cf_sifcalendario form="filtro" name="fFecha" value="#fecha#">
								</td>
								<td>
									<select name="fEstado">
										<option value=""><cf_translate key="LB_Todos" xmlfile="/sif/rh/generales.xml">Todos</cf_translate></option>
										<option value="1" <cfif isdefined("form.fEstado") and form.fEstado eq 1>selected<cfelseif not isdefined("form.fEstado")>selected</cfif> ><cf_translate key="LB_Activas">Activas</cf_translate></option>
										<option value="0" <cfif isdefined("form.fEstado") and form.fEstado eq 0>selected</cfif> ><cf_translate key="LB_Inactivas">Inactivas</cf_translate></option>
									</select>
								</td>
							</tr>
							<tr>
								<td colspan="3" align="center">
                                  <input type="submit" name="btnFiltrar" value="<cfoutput>#vFiltrar#</cfoutput>">				
                                  <input type="button" name="btnLimpiar" value="<cfoutput>#vLimpiar#</cfoutput>" onclick="javascript:limpiar();">
									<input name="DEid" type="hidden" value="<cfif isdefined("form.DEid")><cfoutput>#form.DEid#</cfoutput></cfif>">
									<input name="o" type="hidden" value="8">
							  <input name="sel" type="hidden" value="1">							  </td>
							</tr>
						</table>
						</form>

						<!--- <cfset filtro = "a.Ecodigo=b.Ecodigo and a.SNcodigo=b.SNcodigo and DEid=#form.DEid# and a.Ecodigo=#session.Ecodigo#" > --->
						<cfset filtro = "">

						<cfif isdefined("form.fSNcodigo") and len(trim(form.fSNcodigo)) gt 0>
							<cfset filtro = filtro & " and a.SNcodigo = #form.fSNcodigo# ">
						</cfif>

						<cfif isdefined("form.fFecha") and len(trim(form.fFecha)) gt 0>
							<cfset filtro = filtro & " and a.Dfechaini =  '#LSDateFormat(form.fFecha,"dd/mmm/yyyy")#'">
						</cfif>

						<cfif isdefined("form.fEstado") and len(trim(form.fEstado)) gt 0>
							<cfset filtro = filtro & " and a.Dactivo = #form.fEstado# ">
						<cfelseif not isdefined("form.fEstado")>
							<cfset filtro = filtro & " and a.Dactivo = 1">						
						</cfif>
						
						<!---sacamos la deduccion de subsidio al salario de las nominas anteriores del periodo--->
						<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
							ecodigo="#session.Ecodigo#" pvalor="2033" default="0" returnvariable="vTDidsubc"/>
							
						<cfquery name="rsLista" datasource="#session.DSN#">
							select a.DEid, a.Did, a.Ddescripcion, a.SNcodigo, b.SNnombre, 
							case a.Dmetodo 
								when 0 then 'Porcentaje' 
								when 1 then 'Valor' 
								when 2 then 'UMA' 
								when 3 then 'UMI'
								when 4 then 'Cuota Fija'
								else 'N/A' 
							end as Dmetodo,
							a.Dvalor,Dfechaini, Dfechafin, 
							8 as o, 1 as sel, case a.Dactivo when 1 then 'A' else 'I' end as estado
							<cfif isdefined('form.fEstado')>,'#form.fEstado#' as fEstado</cfif><cfif isdefined('form.fFecha')>,'#Form.fFecha#' as fFecha</cfif><cfif isdefined('form.fSNcodigo') and LEN(TRIM(form.fSNcodigo))>, #Form.fSNcodigo# as fSNcodigo</cfif>
							from DeduccionesEmpleado a
							inner join SNegocios b
							  on a.Ecodigo=b.Ecodigo 
							  and a.SNcodigo=b.SNcodigo 
							where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">  
							  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> 
							  and TDid <> #vTDidsubc#
							  <cfif isdefined("filtro") and Len(trim(filtro))>
								  #PreserveSingleQuotes(filtro)#
							  </cfif>
							 order by SNnombre				  
						</cfquery>
						
						<cfinvoke 
							component="rh.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaDed">
								<cfinvokeargument name="query" value="#rsLista#"/>
								<cfinvokeargument name="desplegar" value="Dfechaini,Ddescripcion, Dmetodo, Dvalor, estado"/>
								<cfinvokeargument name="etiquetas" value="#vFecha#, #vDeduccion#, #vMetodo#, #vValor#, #vEstado#"/>
								<cfinvokeargument name="formatos" value="D, V, V, M, V"/>
								<cfinvokeargument name="formName" value="listaDeducciones"/>	
								<cfinvokeargument name="align" value="left,left,left,right,center"/>
								<cfinvokeargument name="ajustar" value="N"/>				
								<cfinvokeargument name="irA" value="expediente-cons.cfm"/>			
								<cfinvokeargument name="navegacion" value="#navegacionDed#"/>
								<cfinvokeargument name="showEmptyListMsg" value="yes"/>
								<cfinvokeargument name="keys" value="Did"/>
								<cfinvokeargument name="Cortes" value="SNnombre"/>
						</cfinvoke>		
						
						<!--- <cfinvoke 
							component="sif.rh.Componentes.pListas"
							method="pListaRH"
							returnvariable="pListaDed">
								<cfinvokeargument name="tabla" value="DeduccionesEmpleado a, SNegocios b"/>
								<cfinvokeargument name="columnas" value="a.DEid, a.Did, a.Ddescripcion, a.SNcodigo, b.SNnombre, case a.Dmetodo when 0 then 'Porcentaje' when 1 then 'Valor' end as Dmetodo, a.Dvalor,Dfechaini, Dfechafin, 7 as o, 1 as sel"/>
								<cfinvokeargument name="desplegar" value="Dfechaini,Ddescripcion, Dmetodo, Dvalor"/>
								<cfinvokeargument name="etiquetas" value="Fecha, Deducci&oacute;n, M&eacute;todo, Valor"/>
								<cfinvokeargument name="formatos" value="D, V, V, M"/>
								<cfinvokeargument name="formName" value="listaDeducciones"/>	
								<cfinvokeargument name="filtro" value="#filtro#"/>
								<cfinvokeargument name="align" value="left,left,left,right"/>
								<cfinvokeargument name="ajustar" value="N"/>				
								<cfinvokeargument name="irA" value="expediente-cons.cfm"/>			
								<cfinvokeargument name="navegacion" value="#navegacionDed#"/>
								<cfinvokeargument name="keys" value="Did"/>
								<cfinvokeargument name="Cortes" value="SNnombre"/>
						</cfinvoke>--->
						
					</td>
						
					<cfset action = "SQLdeducciones.cfm"> 
					<td width="1%">&nbsp;</td>

					<td width="50%" valign="top">
						<cfinclude template="formDeducciones.cfm">
					</td>
				</tr>																									  
			</table>
		</td>																									  
	</tr>  		
</table>
  
