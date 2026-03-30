<!--- ============================================= --->
<!--- Traducciones --->
<!--- ============================================= --->
	<!--- Identificacion --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Identificacion"
		Default="Identificaci&oacute;n"
		XmlFile="/rh/generales.xml"		
		returnvariable="vIdentificacion"/>

	<!--- Nombre --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Nombre"
		Default="Nombre"
		XmlFile="/rh/generales.xml"		
		returnvariable="vNombre"/>

	<!--- Fecha Desde --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Fecha_Desde"
		Default="Fecha Desde"
		XmlFile="/rh/generales.xml"		
		returnvariable="vfdesde"/>

	<!--- Fecha Hasta --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Fecha_Hasta"
		Default="Fecha Hasta"
		XmlFile="/rh/generales.xml"		
		returnvariable="vfhasta"/>
	<!--- Estado --->	        
    <cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Estado"
		Default="Estado"
		XmlFile="/rh/generales.xml"		
		returnvariable="LB_Estado"/>    
		
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

<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="BTN_EliminarLiq"
		Default="Eliminar"
		xmlfile="/rh/generales.xml"		
		returnvariable="BTN_EliminarLiq"/>	
        
	<!--- Fecha de Liquidacion --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="BTN_Fecha_de_Liquidacion"
		Default="Fecha de Liquidaci&oacute;n"
		returnvariable="vFechaLiq"/>
<!--- ============================================= --->
<!--- ============================================= --->

<cfinclude template="/rh/portlets/pNavegacion.cfm">				
<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.filtro.fDEnombre.value = '';
		document.filtro.fDEidentificacion.value = '';
	}
	
	function funcNuevo(){
		document.lista.PASO.value=1;
	}



	function fnAlgunoMarcadolista(formObj){
		if (formObj.chk) {
			if (formObj.chk.value) {
				return formObj.chk.checked;
			} else {
				for (var i=0; i<formObj.chk.length; i++) {
					if (formObj.chk[i].checked) { 
						return true;
					}
				}
			}
		}
		return false;
	}


	function funcEliminarLiquidacion(){
		document.filtro.PASO.value=0;
		
		if (!fnAlgunoMarcadolista(document.filtro)){
			alert("¡Debe seleccionar al menos un registro para eliminar!");
			return false;
		}else{
			if ( confirm("¿Desea eliminar los registros marcadas?") )	{
				document.filtro.action = 'PreliquidacionBorrar-sql.cfm';
				document.filtro.submit(); 
			}
		}		
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
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td valign="top" width="100%" align="center">
			<form style="margin:0" name="filtro" method="post" > 
				<table width="100%" cellpadding="1" cellspacing="0" class="areaFiltro">
					<tr>
						<td valign="middle" width="1%" align="right">
							<strong><cfoutput>#vIdentificacion#:</cfoutput>&nbsp;</strong> 
						</td>
						<td valign="middle">
							<input name="fDEidentificacion" type="text" size="20" maxlength="60" align="middle" onFocus="this.select();" value="<cfif isdefined("form.fDEidentificacion")><cfoutput>#form.fDEidentificacion#</cfoutput></cfif>">
						</td>
						<td valign="middle" width="1%" align="right">
							<strong><cfoutput>#vNombre#</cfoutput>:&nbsp;</strong>
						</td>
						<td valign="middle" align="left">
							<input name="fDEnombre" type="text" size="40" maxlength="80" align="middle" onFocus="this.select();" value="<cfif isdefined("form.fDEnombre")><cfoutput>#form.fDEnombre#</cfoutput></cfif>">
						</td>
					</tr>

					<tr>
					</tr>

					<tr>
						<td valign="middle" nowrap="nowrap">
							<strong><cfoutput>#vfdesde#</cfoutput>:&nbsp;</strong>
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
						<td valign="middle" nowrap="nowrap">
							<strong><cfoutput>#vfhasta#</cfoutput>:&nbsp;</strong>
						</td>
						<td valign="middle" align="left">
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td>
										<cfset FechaHasta = "">
										<cfif not isdefined("Form.Fhasta")>
											<cfset Form.Fhasta = LSDateFormat(Now(), 'dd/mm/yyyy')>
											<cfset FechaHasta = Form.Fhasta>
										<cfelse>
											<cfset FechaHasta = Form.Fhasta>
										</cfif>
										<cf_sifcalendario form="filtro" name="Fhasta" value="#FechaHasta#">
									</td>
									<td align="center" rowspan="4" valign="middle">
										<input type="submit" name="btnFiltrar" value="<cfoutput>#vFiltrar#</cfoutput>">
									</td>
									<td align="center" valign="middle" rowspan="4">
										<input type="button" name="btnLimpiar" value="<cfoutput>#vLimpiar#</cfoutput>" onClick="javascript:limpiar();">
										<input name="DLlinea" type="hidden" value="<cfif isdefined("form.DLlinea")and (form.DLlinea GT 0)><cfoutput>#form.DLlinea#</cfoutput></cfif>">
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
                
                
                <tr>
                <td align="center">
                     <cfquery name="rsListaLiquidaciones" datasource="#session.DSN#">
                        select 1 as paso, a.RHPLPid, a.DEid, a.RHPLPestado, a.RHPLPfsalida, 
                                {fn concat({fn concat({fn concat({fn concat(b.DEapellido1, ' ')}, b.DEapellido2)}, ' ')}, b.DEnombre)} as nombre,
                                b.DEidentificacion, 'ALTA'  as modo,
                                a.RHPLPfecha,
                                case  when  a.RHPLPestado  = 1 then
                                	'Calculado'
                                else
                                	'Proceso'
                                end as Estado
                                
                                
                        from RHPreLiquidacionPersonal a
                            
                            inner join DatosEmpleado b
                                on a.Ecodigo = b.Ecodigo
                                and a.DEid = b.DEid
                            <cfif isdefined("form.fDEidentificacion") and len(trim(form.fDEidentificacion))>
                                and b.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fDEidentificacion#">
                            </cfif>
                            <cfif isdefined("form.fDEnombre") and len(trim(form.fDEnombre))>
                                and upper({fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )}, ' ' )}, b.DEnombre )}) like '%#Ucase(Trim(form.fDEnombre))#%'
                            </cfif>
        
                        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                       <!--- and a.RHPLPestado = 0--->
                        <cfif isdefined("form.Fdesde") and len(trim(form.Fdesde)) and isdefined("form.Fhasta") and len(trim(form.Fhasta))>
                            and a.RHPLPfsalida between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Fhasta)#">
                        <cfelseif isdefined("form.Fdesde") and len(trim(form.Fdesde))>
                            and a.RHPLPfsalida >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Fdesde)#">
                        <cfelseif isdefined("form.Fhasta") and len(trim(form.Fhasta))>
                            and a.RHPLPfsalida <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Fhasta)#">
                        </cfif>
                        
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
        
                    <cfset botonesList='Eliminar'>
        
                     <cfinvoke 
                        component="rh.Componentes.pListas"
                        method="pListaQuery"
                        returnvariable="pListaRet">
                            <cfinvokeargument name="query" value="#rsListaLiquidaciones#"/>
                            <cfinvokeargument name="desplegar" value="DEidentificacion, nombre, RHPLPfsalida, Estado "/>
                            <cfinvokeargument name="etiquetas" value="#vIdentificacion#, #vNombre#, #vFechaLiq#,#LB_Estado#"/>
                            <cfinvokeargument name="formatos" value="S, S, D, S"/>
                            <cfinvokeargument name="align" value="left, left, center, center "/>
                            <cfinvokeargument name="ajustar" value="N"/>
                            <cfinvokeargument name="debug" value="N"/>
                            <cfinvokeargument name="keys" value="RHPLPid"/> 
                            <cfinvokeargument name="showEmptyListMsg" value= "1"/>
                            <cfinvokeargument name="checkboxes" value="N"/>
                            <cfinvokeargument name="botones" value=""/>
                            <cfinvokeargument name="maxRows" value="20"/>
                            <cfinvokeargument name="irA" value= "#CurrentPage#"/>
                            <cfinvokeargument name="navegacion" value="#navegacion#"/>
                            <cfinvokeargument name="checkboxes" value="S"/>
                            <cfinvokeargument name="checkall" value="S"/>
                            <cfinvokeargument name="form_method" value="get"/>
                            <cfinvokeargument name="formName" value="filtro"/>
                            
                    </cfinvoke>
                    <cfif rsListaLiquidaciones.recordcount gt 0 >
                        <input type="button" name="btnEliminar" class ="btnEliminar"value="<cfoutput>#BTN_EliminarLiq#</cfoutput>" onClick="javascript:funcEliminarLiquidacion();">
                    </cfif>
                    
                </td>
            </tr>
			</form>
		</td>
	</tr>
</table>
