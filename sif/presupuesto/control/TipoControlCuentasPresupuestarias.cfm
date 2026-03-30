<!---Variables de Traduccion --->
<cfinvoke component="sif.Componentes.Translate" method="Translate"
				Key="LB_Cmayor"
				Default="C. Mayor"
				XmlFile="/rh/generales.xml"
				returnvariable="LB_Cmayor"/>
<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Detalle"
				Default="Detalle"
				XmlFile="/rh/generales.xml"
				returnvariable="LB_Detalle"/>
<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Descripcion"
				Default="Descripci&oacute;n"
				XmlFile="/rh/generales.xml"
				returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_TipoControl"
				Default="Tipo de Control"
				XmlFile="/rh/generales.xml"
				returnvariable="LB_TipoControl"/>	
<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_CalculoControl"
				Default="C&aacute;lculo de Control"
				XmlFile="/rh/generales.xml"
				returnvariable="LB_CalculoControl"/>						
<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Filtrar"
				Default="Filtrar"
				XmlFile="/rh/generales.xml"
				returnvariable="BTN_Filtrar"/>
<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Limpiar"
				Default="Limpiar"
				XmlFile="/rh/generales.xml"
				returnvariable="BTN_Limpiar"/>	
								
		<cfset filtroRs="">
		<cfif isdefined('form.CPMayorF') and len(trim(form.CPMayorF)) gt 0>
			<cfset filtroRs= filtroRs & " and pres.Cmayor ='" & form.CPMayorF &"'">
		</cfif>
		<cfif isdefined('form.CPDetalleF') and len(trim(form.CPDetalleF)) gt 0>
			<cfset filtroRs= filtroRs & " and pres.CPformato like '%" & form.CPDetalleF & "%'">
		</cfif>
		<cfif isdefined('form.CPDescripcionF') and len(trim(form.CPDescripcionF)) gt 0>
			<cfset filtroRs= filtroRs & " and upper(pres.CPdescripcion) like '%" & ucase(form.CPDescripcionF) & "%'">
		</cfif>
		<cfif isdefined('form.CPTipoControlF') and form.CPTipoControlF neq -1>
			<cfset filtroRs= filtroRs & " and cp.CPCPtipoControl =" & form.CPTipoControlF>
		</cfif> 
		<cfif isdefined('form.CPCalculoControlF') and form.CPCalculoControlF neq -1>
			<cfset filtroRs= filtroRs & " and cp.CPCPcalculoControl =" & form.CPCalculoControlF>
		</cfif> 
			
		<cfquery name="rsCPPeriodo" datasource="#session.dsn#">
			select CPPid
			  from CPresupuestoPeriodo d
			 where Ecodigo = #session.ecodigo#
			   and CPPestado = 1
		</cfquery>
		<cfquery name="rsCuentasPresupuestarias" datasource="#Session.dsn#">					
			select pres.CPcuenta,
				   pres.Cmayor, 
				   pres.CPformato as CPdetalle, 
				   Coalesce(pres.CPdescripcionF,pres.CPdescripcion) as CPdescripcion,
				   case CPCPtipoControl 
						when 0 then 'Abierto' 
						when 1 then 'Restringido'
						when 2 then 'Restrictivo'
						end as TipoControl,
					case CPCPcalculoControl 
						when 1 then 'Mensual' 
						when 2 then 'Acumulado'
						when 3 then 'Total'
						end as CalculoControl,		
				   #rsCPPeriodo.CPPid# as CPPid		 
			from CPresupuesto pres
				 inner join CPCuentaPeriodo cp on pres.CPcuenta = cp.CPcuenta 
			where pres.Ecodigo = #Session.Ecodigo#	 
				  and cp.CPPid =#rsCPPeriodo.CPPid#		
				  #PreserveSingleQuotes(filtroRs)#											 														
		</cfquery>				

<cf_templateheader title="Tipo de Control de Cuentas Presupuestarias" template="#session.sitio.template#">
	<cf_web_portlet_start titulo="Tipo de Control de Cuentas Presupuestarias">							 
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr> 
				<td valign="top" width="65%">
					<form style="margin:0" name="filtro" method="post">
						<table border="0" width="100%" class="tituloListas" cellpadding="0" cellspacing="0	">
							<tr> 
								<td><cfoutput>#LB_Cmayor#</cfoutput></td>
								<td><cfoutput>#LB_Detalle#</cfoutput></td>
								<td><cfoutput>#LB_Descripcion#</cfoutput></td>
								<td><cfoutput>#LB_TipoControl#</cfoutput></td>
								<td><cfoutput>#LB_CalculoControl#</cfoutput></td>
							</tr>
							<tr> 
								<td>
									<input type="text" name="CPMayorF" size="10" maxlength="4" tabindex="1"
									value="<cfif isdefined("form.CPMayorF") and len(trim(form.CPMayorF)) gt 0 ><cfoutput>#form.CPMayorF#</cfoutput></cfif>" 
									onFocus="javascript:this.select();" >
								</td>
								<td>
									<input type="text" name="CPDetalleF" size="15" maxlength="100" tabindex="1"
									value="<cfif isdefined("form.CPDetalleF") and len(trim(form.CPDetalleF)) gt 0 ><cfoutput>#form.CPDetalleF#</cfoutput></cfif>" 
									onFocus="javascript:this.select();" >
								</td>								
								<td>
									<input type="text" name="CPDescripcionF" size="30" maxlength="80"  tabindex="1"
									value="<cfif isdefined("form.CPDescripcionF") and len(trim(form.CPDescripcionF)) gt 0 ><cfoutput>#form.CPDescripcionF#</cfoutput></cfif>" 
									onFocus="javascript:this.select();" >
								</td>
								<td>
									<select name="CPTipoControlF">
										<option value="-1" <cfif isdefined('form.CPTipoControlF') and form.CPTipoControlF EQ -1>selected</cfif>>Todos</option>
										<option value="0" <cfif isdefined('form.CPTipoControlF') and form.CPTipoControlF EQ 0>selected</cfif>>Abierto</option>
										<option value="1" <cfif isdefined('form.CPTipoControlF') and form.CPTipoControlF EQ 1>selected</cfif>>Restringido</option>
										<option value="2" <cfif isdefined('form.CPTipoControlF') and form.CPTipoControlF EQ 2>selected</cfif>>Restrictivo</option>													
									</select>
								</td>
								<td>
									<select name="CPCalculoControlF">
										<option value="-1" <cfif isdefined('form.CPCalculoControlF') and form.CPCalculoControlF EQ -1>selected</cfif>>Todos</option>
										<option value="1" <cfif isdefined('form.CPCalculoControlF') and form.CPCalculoControlF EQ 1>selected</cfif>>Mensual</option>
										<option value="2" <cfif isdefined('form.CPCalculoControlF') and form.CPCalculoControlF EQ 2>selected</cfif>>Acumulado</option>
										<option value="3" <cfif isdefined('form.CPCalculoControlF') and form.CPCalculoControlF EQ 3>selected</cfif>>Total</option>													
									</select>
								</td>
								<td nowrap>
									<cfoutput>
									<input type="submit" name="Filtrar" value="#BTN_Filtrar#" tabindex="1"> 
									<input type="button" name="Limpiar" value="#BTN_Limpiar#" tabindex="1" onClick="javascript:limpiar();">
									</cfoutput>
								</td>
							</tr>
						</table>
					</form>																																	
					<cfinvoke 
						 component="rh.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
							<cfinvokeargument name="Query" value="#rsCuentasPresupuestarias#"/>
							<cfinvokeargument name="desplegar" value="Cmayor, CPdetalle, CPdescripcion, TipoControl,CalculoControl"/>
							<cfinvokeargument name="etiquetas" value="#LB_Cmayor#,#LB_Detalle#,#LB_Descripcion#,#LB_TipoControl#,#LB_CalculoControl#"/>
							<cfinvokeargument name="formatos" value="V,V, V,V,V"/>
							<cfinvokeargument name="align" value="left, left, left, left,left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="irA" value="TipoControlCuentasPresupuestarias.cfm"/>
							<cfinvokeargument name="keys" value="CPcuenta"/>
							<cfinvokeargument name="usaAJAX" value="YES"/>
							<cfinvokeargument name="conexion" value="#Session.dsn#"/>
					</cfinvoke>
				</td>
				<td width="35%" valign="top"> 
					<cfinclude template="TipoControlCuentasPresupuestarias-form.cfm">
				</td>
			</tr>
		</table> 
	<cf_web_portlet_end>
<cf_templatefooter>	

<script   language="javascript" type="text/javascript">
	 function limpiar(){
	 document.filtro.reset();
	 document.filtro.CPMayorF.value = " ";
	 document.filtro.CPDetalleF.value = " ";
	 document.filtro.CPDescripcionF.value = " ";						 
	 document.filtro.CPTipoControlF.value = -1;	
	 document.filtro.CPCalculoControlF.value = -1;					 
	 }
</script>		 
							