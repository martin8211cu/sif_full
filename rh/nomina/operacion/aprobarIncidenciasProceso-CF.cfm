
<script language="javascript" type="text/javascript">
	function validar(){
		if(confirm('Esta seguro que desea realizar el cambio?')){
			return true;
		}
		else{
			return false;
		}
	}
</script>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
	Default="Aprobaci&oacute;n de Incidencias"
	VSgrupo="103"
	returnvariable="nombre_proceso"/>
	
<!--- Monto Calculado --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_MontoCalculado"
		default="Monto Calculado*"
		xmlfile="/rh/generales.xml"		
		returnvariable="vMontoCalculado"/>	

<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
<table width="100%" cellpadding="2" cellspacing="0">
<tr><td valign="top">
<cf_web_portlet_start titulo="#nombre_proceso#">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr valign="top"> <td align="center" style="color:##0099FF"><strong>Solo es posible modificar el centro funcional, los demas datos son informativos.</strong></td></tr>
<tr valign="top"> 
<td align="center">

		<cfparam default="0" name="url.Iid">
		<cfparam default="" name="url.CFpk">
		<cfparam default="" name="url.dependencias">
		<cfparam default="" name="url.filtro_CIid">
		<cfparam default="" name="url.DEid">
		<cfparam default="" name="url.filtro_fecha">
		
		<cfif isdefined("url.BTNCambiar")>
				<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="Cambio" >
					<cfinvokeargument name="Iid" 	value="#url.Iid#">
					<cfinvokeargument name="DEid" 	value="#url.DEid2#">
					<cfinvokeargument name="CIid" 	value="#url.CIid#">
					<cfinvokeargument name="iFecha" value="#LSParseDateTime(url.Ifecha)#">
					<cfinvokeargument name="iValor" value="#url.Ivalor#">				
					<cfinvokeargument name="CFid" value="#url.CFid#">
					<cfif isdefined("url.RHJid") and len(trim(url.RHJid)) gt 0>
						<cfinvokeargument name="RHJid" value="#url.RHJid#">
					</cfif>
					<cfif isdefined("url.Icpespecial") and len(trim(url.Icpespecial)) EQ 0>
						<cfinvokeargument name="Icpespecial" value="1">	
						<cfif isdefined("url.IfechaRebajo")>
							<cfinvokeargument name="IfechaRebajo" value="#url.IfechaRebajo#">
						</cfif>
					</cfif>	
					<cfif isdefined("url.Iobservacion")>
						<cfinvokeargument name="Iobservacion" value="#url.Iobservacion#">
					</cfif>	
				</cfinvoke>
		</cfif>
		
		<!---Averiguar si se ingresa desde Autogestion o desde Nomina --->
		<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="validaLugarConsulta" returnvariable="Menu"/>
		
		<cfquery name="rsIncidencia" datasource="#Session.DSN#">
			SELECT a.Iid, 
				   a.DEid, 
				   a.CIid, CIcodigo, CIdescripcion,
				   Ifecha as fecha, 
				   IfechaRebajo, 
				   a.Ivalor, 
				   case c.CItipo  	when 3 then <cf_dbfunction name="to_char" args="Imonto"> 
					else ''  end as Imonto,
				   a.Usucodigo, a.Ulocalizacion, 
					{fn concat({fn concat({fn concat({ fn concat( b.DEnombre, ' ') }, b.DEapellido1)}, ' ')}, b.DEapellido2) } as 	NombreEmp,
				   b.DEidentificacion,
				   b.DEtarjeta,
				   b.NTIcodigo,
				   a.CFid,
				   a.ts_rversion,
				   RHJid,
				   a.Icpespecial,
				   a.Iobservacion
				   
			FROM CIncidentes c
				inner join  Incidencias a
					on a.CIid = c.CIid		
					inner join DatosEmpleado b
						on a.DEid = b.DEid
				
			WHERE c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and a.Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Iid#">		
		</cfquery>
		
		<cfif len(trim(rsIncidencia.CFid)) gt 0><cfset cfid = rsIncidencia.CFid ><cfelse><cfset cfid = -1 ></cfif>
		
		<cfquery name="rsCFuncional" datasource="#session.DSN#">
			select CFid, CFcodigo, CFdescripcion
			from CFuncional
			where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cfid#">
		</cfquery>
		
		<cfquery name="rsJornadas" datasource="#Session.DSN#">
			select RHJid, {fn concat(rtrim(RHJcodigo),{fn concat(' - ',RHJdescripcion)})} as Descripcion
			from RHJornadas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
		<cfset va_arrayvalues=ArrayNew(1)>
		<cfset ArrayAppend(va_arrayvalues, rsIncidencia.CIid)>
		<cfset ArrayAppend(va_arrayvalues, rsIncidencia.CIcodigo)>
		<cfset ArrayAppend(va_arrayvalues, rsIncidencia.CIdescripcion)>
		
		<cfoutput>	
			
			<!---guarda la navegacion--->
			<form name="filtro" method="get" action="aprobarIncidenciasProceso.cfm">
					<input type="hidden" name="CFpk" value="#url.CFpk#" />
					<input type="hidden" name="dependencias" value="#url.dependencias#" />
					<input type="hidden" name="filtro_CIid" value="#url.filtro_CIid#" />
					<input type="hidden" name="DEid" value="#url.DEid#" />
					<input type="hidden" name="filtro_fecha" value="#url.filtro_fecha#" />
			</form>
			
			
			<form name="form1" method="get" enctype="multipart/form-data" onsubmit="return validar();">
				<input type="hidden" name="Iid" value="#url.Iid#" />
				<input type="hidden" name="CFpk" value="#url.CFpk#" />
				<input type="hidden" name="dependencias" value="#url.dependencias#" />
				<input type="hidden" name="filtro_CIid" value="#url.filtro_CIid#" />
				<input type="hidden" name="DEid" value="#url.DEid#" />
				<input type="hidden" name="filtro_fecha" value="#url.filtro_fecha#" />
				
				<table cellpadding="2" cellspacing="2">
				<tr>
					  <!--- Empleado --->
					  <td  colspan="2" class="fileLabel">Empleado</td>
					  <!--- Concepto --->
					  <td class="fileLabel" nowrap>Concepto</td>
					</tr>
					<!--- Línea No. 2 --->
					<tr>
						<td  colspan="2">
							<cf_rhempleado idempleado="#rsIncidencia.DEid#" index="2" tabindex="1" size = "50" readonly="true">
						</td>
					  <td>
						
						<cfset DesdeAutogetion =''>
						<cfif Menu EQ 'AUTO'>	<!---solo las visibles desde autogestion--->
							<cfset DesdeAutogetion ='and a.CIautogestion = 1'>
						</cfif>
						<cf_conlis title="Lista de Incidencias"
									campos = "CIid,CIcodigo,CIdescripcion" 
									desplegables = "N,S,S" 
									modificables = "N,S,N" 
									size = "0,10,20"
									asignar="CIid,CIcodigo,CIdescripcion"
									asignarformatos="I,S,S"
									tabla="	CIncidentes a"																	
									columnas="CIid,CIcodigo,CIdescripcion"
									filtro="a.Ecodigo =#session.Ecodigo#
											and coalesce(a.CInomostrar,0) = 0
											and CIcarreracp = 0
											and CItipo < 3
											#DesdeAutogetion#"
									desplegar="CIcodigo,CIdescripcion"
									etiquetas="Codigo,Descripcion"
									formatos="S,S"
									align="left,left"
									showEmptyListMsg="true"
									debug="false"
									form="form1"
									width="800"
									height="500"
									left="70"
									top="20"
									filtrar_por="CIcodigo,CIdescripcion"
									funcion="changeValLabel"
									valuesarray="#va_arrayvalues#"
									readonly="True">  </td>
					</tr>
					<tr>
					  <!--- Centro funcional --->
					  <td class="fileLabel" nowrap><cf_translate key="LB_Centro_Funcional_de_Servicio">Centro Funcional de Servicio</cf_translate></td>
					  <!--- Concepto --->
					  <td class="fileLabel">Fecha</td>
					  <!--- Valor --->
					  <td class="fileLabel" nowrap> Valor</td>
					  <!--- monto --->
					  <cfif len(trim(rsIncidencia.Imonto))>
					  <td class="fileLabel" nowrap>#vMontoCalculado#</td>
					  </cfif>
					</tr>
					<!--- Línea No. 4 --->
					<tr>
					 
					  <td><!---Muestra los centros funcionales que tienen la cuenta de gasto o de compras definido--->
							<cf_rhcfuncional query="#rsCFuncional#" tabindex="1" contables="1" id="CFid">
					  </td>
					  <!--- Fecha --->
					  <td><cf_sifcalendario  readonly="true" form="form1" name="Ifecha" value="#LSDateFormat(rsIncidencia.fecha,'dd/mm/yyyy')#" onChange="CambiaCF();">
					  </td>
					  <!--- Valor --->
					  <td id="TDValor" nowrap><input   readonly="readonly" name="Ivalor" type="text" id="Ivalor" size="18" maxlength="15" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="#LSCurrencyFormat(rsIncidencia.Ivalor, 'none')#" tabindex="1" />      </td>
					  <cfif len(trim(rsIncidencia.Imonto))>
					  <!--- Valor --->
					  	<td nowrap><input   readonly="readonly" name="Imonto" type="text" id="Imonto" size="18" maxlength="15" style="text-align: right;" value="#LSCurrencyFormat(rsIncidencia.Imonto, 'none')#" tabindex="1" />      </td>
					  </cfif>
					</tr>
					<!--- Línea No. 5 --->
					<tr>
					   
					  <td class="fileLabel" <cfif Menu EQ 'AUTO'>style="visibility:hidden"</cfif>><input type="checkbox" name="Icpespecial" id="Icpespecial" onClick="javascript:fechaRebajo(this);" disabled="disabled" value="" <cfif rsIncidencia.Icpespecial EQ 1>checked</cfif> />
						  <cf_translate key="LB_Incluir_solo_en_Calendario_de_Pagos_especiales">Incluir solo en Calendario de Pagos especiales</cf_translate>      
					  </td>
					 
					  <td><table width="100%" align="center" border="0" cellspacing="0" cellpadding="1">
						  <tr id="TRLabelJornada" style="display:<cfif isdefined("rsIncidencia") and len(trim(rsIncidencia.RHJid))><cfelse>none</cfif>">
							<td class="fileLabel"><cf_translate key="LB_Jornada">Jornada</cf_translate></td>
						  </tr>
						  <tr id="TRJornada" style="display:<cfif isdefined("rsIncidencia") and len(trim(rsIncidencia.RHJid))><cfelse>none</cfif>">
							<td><select name="RHJid"  readonly="readonly">
								<option value="">--- Seleccionar ---</option>
								<cfloop query="rsJornadas">
								  <option value="#RHJid#" <cfif rsJornadas.RHJid EQ rsIncidencia.RHJid> selected</cfif>>#Descripcion#</option>
								</cfloop>
							  </select>            </td>
						  </tr>
					  </table></td>
					</tr>
					<tr>
					  <td colspan="4">&nbsp;</td>
					</tr>
					<tr>
					  <td colspan="4"><strong>Observaci&oacute;n</strong></td>
					</tr>
					<tr>
					  <td colspan="4">
						  <textarea name="Iobservacion" cols="100" rows="2" readonly="readonly"><cfif isdefined("rsIncidencia.Iobservacion") and len(trim(rsIncidencia.Iobservacion))>#rsIncidencia.Iobservacion#</cfif></textarea>		</td>
					</tr>
					<tr align="center">
					  <td colspan="4">
						  <input type="submit" name="BTNCambiar" value="Cambiar"/>
						  <input type="button" name="BTNRegresar" value="Regresar" onclick="javascript: document.filtro.submit();"/>
					   </td>
					</tr>
				</table>
			</form>
		</cfoutput>
</td>
</tr>
<tr valign="top"> <td>&nbsp;</td></tr>
</table>
<cf_web_portlet_end>
</td></tr>
</table>	
<cf_templatefooter>	