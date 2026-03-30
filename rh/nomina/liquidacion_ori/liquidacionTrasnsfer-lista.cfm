<!--- Identificacion --->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"
	XmlFile="/rh/generales.xml"		
	returnvariable="vIdentificacion"/>

<!--- nombre --->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"
	XmlFile="/rh/generales.xml"		
	returnvariable="vNombre"/>

	<!--- Filtrar --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="BTN_Filtrar"
		Default="Filtrar"
		xmlfile="/rh/generales.xml"		
		returnvariable="vFiltrar"/>

	<!--- Limpiar --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="BTN_Limpiar"
		Default="Limpiar"
		xmlfile="/rh/generales.xml"		
		returnvariable="vLimpiar"/>		

	<!--- fecha desde --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Fecha_Desde"
		Default="Fecha Desde"
		xmlfile="/rh/generales.xml"		
		returnvariable="vFechaDesde"/>		

	<!--- fecha hasta --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Fecha_Hasta"
		Default="Fecha Hasta"
		xmlfile="/rh/generales.xml"		
		returnvariable="vFechaHasta"/>		

	<!--- fecha liquidacion --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Fecha_Liquidacion"
		Default="Fecha Liquidaci&oacute;n"
		returnvariable="vFechaLiq"/>		


<cfinclude template="/rh/portlets/pNavegacion.cfm">				
<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.filtro.fDEnombre.value = '';
		document.filtro.fDEidentificacion.value = '';
	}
	
	function funcNuevo(){
		document.lista.PASO.value=1;
	}
	
	function funcEliminar(){
		document.lista.PASO.value=0;
	}
</script>

	<cfif isdefined("url.fDEidentificacion")>
		<cfparam name="Form.fDEidentificacion" default="#url.fDEidentificacion#">
	</cfif>
	<cfif isdefined("url.fDEnombre")>
		<cfparam name="Form.fDEnombre" default="#url.fDEnombre#">
	</cfif>
	<cfif isdefined("url.Fdesde")>
		<cfparam name="Form.Fdesde" default="#url.Fdesde#">
	</cfif>
	<cfif isdefined("url.Fhasta")>
		<cfparam name="Form.Fhasta" default="#url.Fhasta#">
	</cfif>

	<table align="right" width="98%" cellpadding="0" cellspacing="0" border="0">
		
		
		<tr>
			<td align="center" class="tituloAlterno">
				<cf_translate  key="LB_SeleccioneUnEmpleado">Seleccione un Empleado</cf_translate>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td valign="top" width="100%" align="center">
				<form style="margin:0" name="filtro" method="post">
					<table width="100%" cellpadding="2" cellspacing="0" class="areaFiltro">
						<tr>
							<td valign="middle" align="right">
								<strong><cfoutput>#vIdentificacion#</cfoutput>:&nbsp;</strong> 
							</td>
							<td valign="middle">
								<input name="fDEidentificacion" type="text" size="20" maxlength="60" align="middle" onFocus="this.select();" value="<cfif isdefined("form.fDEidentificacion")><cfoutput>#form.fDEidentificacion#</cfoutput></cfif>">
							</td>
							<td valign="middle" align="right">
								<strong><cfoutput>#vNombre#</cfoutput>:&nbsp;</strong>
							</td>
							<td valign="middle" align="left">
								<input name="fDEnombre" type="text" size="30" maxlength="80" align="middle" onFocus="this.select();" value="<cfif isdefined("form.fDEnombre")><cfoutput>#form.fDEnombre#</cfoutput></cfif>">
							</td>
							<td valign="middle" align="right" nowrap="nowrap">
								<strong><cfoutput>#vFechaDesde#</cfoutput>:&nbsp;</strong>
							</td>
							<td valign="middle" align="left">
								<cfset FechaDesde = "">
								<cfif not isdefined("Form.Fdesde")>
									<cfset Form.Fdesde = LSDateFormat(CreateDate(Year(Now()), Month(Now()), 1), 'dd/mm/yyyy')>
									<cfset FechaDesde = Form.Fdesde>
								<cfelse>
									<cfset FechaDesde = Form.Fdesde>
								</cfif>
								<cf_sifcalendario form="filtro" name="Fdesde" value="#FechaDesde#">
							</td>
							<td valign="middle" align="right" nowrap="nowrap">
								<strong><cfoutput>#vFechaHasta#</cfoutput>:&nbsp;</strong>
							</td>
							<td valign="middle" align="left">
								<cfset FechaHasta = "">
								<cfif not isdefined("Form.Fhasta")>
									<cfset Form.Fhasta = LSDateFormat(Now(), 'dd/mm/yyyy')>
									<cfset FechaHasta = Form.Fhasta>
								<cfelse>
									<cfset FechaHasta = Form.Fhasta>
								</cfif>
								<cf_sifcalendario form="filtro" name="Fhasta" value="#FechaHasta#">
							</td>
							<td align="center">
								<input type="submit"  name="btnFiltrar" value="<cfoutput>#vFiltrar#</cfoutput>">
								<input type="button" name="btnLimpiar" value="<cfoutput>#vlimpiar#</cfoutput>" onClick="javascript:limpiar();">
								<input name="DLlinea" type="hidden" value="<cfif isdefined("form.DLlinea")and (form.DLlinea GT 0)><cfoutput>#form.DLlinea#</cfoutput></cfif>">
							</td>
						</tr>
					</table>
				</form>
			</td>
		</tr>
		<tr>
			<td align="center">
				 <cfquery name="rsListaLiquidaciones" datasource="#session.DSN#">
					select 1 as paso, a.DLlinea, a.DEid, RHLPestado, fechaalta, 
							<cf_dbfunction name="concat" args="b.DEnombre,' ',b.DEapellido1,'  ',b.DEapellido2"> as nombre,
							b.DEidentificacion, 'ALTA'  as modo,
							c.DLfvigencia
					from RHLiquidacionPersonal a

						inner join DatosEmpleado b
							on a.Ecodigo = b.Ecodigo
							and a.DEid = b.DEid
						inner join 	DatosEmpleadoCorp  y
							on a.Ecodigo = y.Ecodigo
							and a.DEid = y.DEid
						<cfif isdefined("form.fDEidentificacion") and len(trim(form.fDEidentificacion))>
							and b.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fDEidentificacion#">
						</cfif>
						<cfif isdefined("form.fDEnombre") and len(trim(form.fDEnombre))>
							and upper(<cf_dbfunction name="concat" args="b.DEnombre,' ',b.DEapellido1,'  ',b.DEapellido2">) like '%#Ucase(Trim(form.fDEnombre))#%'
						</cfif>

						inner join DLaboralesEmpleado c
							on a.DLlinea = c.DLlinea
						<cfif isdefined("form.Fdesde") and len(trim(form.Fdesde)) and isdefined("form.Fhasta") and len(trim(form.Fhasta))>
							and c.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Fhasta)#">
						<cfelseif isdefined("form.Fdesde") and len(trim(form.Fdesde))>
							and c.DLfvigencia >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Fdesde)#">
						<cfelseif isdefined("form.Fhasta") and len(trim(form.Fhasta))>
							and c.DLfvigencia <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Fhasta)#">
						</cfif>

					where a.Ecodigo= #rsParam.Pvalor#
					and a.RHLPestado = 1
					and y.DEidcorp  in(
										select z.DEidcorp 
										from RHLiquidacionPersonal x, DatosEmpleadoCorp z  
										where x.Ecodigo = #session.Ecodigo# 
										and x.Ecodigo = z.Ecodigo 
										and x.DEid = z.DEid )
					order by 9, 7, 6
				</cfquery> 
				
				
	
				<cfset navegacion = "">
				<cfif isdefined("form.fDEidentificacion")>
					<cfset navegacion = navegacion & "&fDEidentificacion=" & form.fDEidentificacion>
				</cfif>
				<cfif isdefined("form.fDEnombre")>
					<cfset navegacion = navegacion & "&fDEnombre=" & form.fDEnombre>
				</cfif>
				<cfif isdefined("form.Fdesde")>
					<cfset navegacion = navegacion & "&Fdesde=" & form.Fdesde>
				</cfif>
				<cfif isdefined("form.Fhasta")>
					<cfset navegacion = navegacion & "&Fhasta=" & form.Fhasta>
				</cfif>

				 <cfinvoke 
					component="rh.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rsListaLiquidaciones#"/>
						<cfinvokeargument name="desplegar" value="DEidentificacion, nombre, DLfvigencia "/>
						<cfinvokeargument name="etiquetas" value="#vIdentificacion#, #vNombre#, #vFechaLiq#"/>
						<cfinvokeargument name="formatos" value="S, S, D"/>
						<cfinvokeargument name="align" value="left, left, center "/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="debug" value="N"/>
						<cfinvokeargument name="keys" value="DLlinea"/> 
						<cfinvokeargument name="showEmptyListMsg" value= "true"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="botones" value=""/>
						<cfinvokeargument name="maxRows" value="20"/>
						<cfinvokeargument name="irA" value="#CurrentPage#"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
				</cfinvoke>
			</td>
		</tr>
		<tr>
		  <td>&nbsp;</td>
	  </tr>	
	  <tr>
			<td align="center">
				<font color="#FF0000"><cf_translate  key="LB_Es_necesario_confeccionar_la_boleta_de_liquidacion_en_ambas_empresas">Es necesario confeccionar la boleta de liquidaci&oacute;n en ambas empresas</cf_translate></font>
			</td>
		</tr>																								  
	</table>
	
	
