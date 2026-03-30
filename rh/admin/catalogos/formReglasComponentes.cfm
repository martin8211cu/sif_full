<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_Cantidad" Default="Cantidad" returnvariable="LB_Cantidad" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Codigo" Default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Grado" Default="Grado" returnvariable="LB_Grado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Puesto" Default="Puesto" returnvariable="LB_Puesto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_SumaFija" Default="Suma Fija" returnvariable="LB_SumaFija" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_EsteDeYaFueAgregado" Default="El detalle ya fue agregado" returnvariable="MSG_EsteDeYaFueAgregado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_Detalle" Default="Detalle" returnvariable="MSG_Detalle" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_Valor" Default="Valor" returnvariable="MSG_Valor" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_Metodo" Default="Método" returnvariable="MSG_Metodo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_DeseaEliminarElRegistro" Default="Desea eliminar el registro?" returnvariable="MSG_DeseaEliminarElRegistro" component="sif.Componentes.Translate" method="Translate"/>	
<!--- FIN DE VARIABLES DE TRADUCCION --->

<!--- VARIABLES URL --->
<cfif isdefined('url.PAGENUM') and not isdefined('form.PAGENUM')>
	<cfset form.PAGENUM = url.PAGENUM>
</cfif>
<cfif isdefined('url.PAGENUMPADRE') and not isdefined('form.PAGENUMPADRE')>
	<cfset form.PAGENUMPADRE = url.PAGENUMPADRE>
</cfif><!--- FIN VARIABLES URL --->


<!--- Consultas --->
<cfquery name="rsGComponentes" datasource="#Session.DSN#">
	select RHCAcodigo, RHCAdescripcion
	from RHComponentesAgrupados
	where RHCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCAid#">
</cfquery>
<cfquery name="rsComponentes" datasource="#Session.DSN#">
	select CScodigo, CSdescripcion, CSusatabla
	from ComponentesSalariales
	where CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">
</cfquery>
<cfset Lvar_Clases = ''>
<cfquery name="rsClases" datasource="#session.DSN#">
	select ERCclase
	from EReglaComponente
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">
</cfquery>
<cfif modo EQ 'cambio'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		select ERCclase,ts_rversion
		from EReglaComponente
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and ERCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERCid#">
	</cfquery>
	<cfquery name="rsDForm" datasource="#session.DSN#">
		select DRCid,DRCdetalle,DRCvalor,DRCmetodo,ts_rversion
		from DReglaComponente
		where ERCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERCid#">
		order by DRCdetalle
	</cfquery>
	<cfset ts = "">
	<cfinvoke  component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
	</cfinvoke>
</cfif>
<cfif rsClases.REcordCount GT 0><cfset Lvar_Clases = ValueList(rsClases.ERCclase)></cfif>
<cfset Clases = QueryNew("IDClase,Clase")>
<cfset newRow = QueryAddRow(Clases, 5)>
<cfset querySetCell(Clases,"IDClase",'1',1)>
<cfset querySetCell(Clases,"Clase",LB_Cantidad,1)>
<cfset querySetCell(Clases,"IDClase",'2',2)>
<cfset querySetCell(Clases,"Clase",LB_Codigo,2)>
<cfset querySetCell(Clases,"IDClase",'3',3)>
<cfset querySetCell(Clases,"Clase",LB_Grado,3)>
<cfset querySetCell(Clases,"IDClase",'4',4)>
<cfset querySetCell(Clases,"Clase",LB_Puesto,4)>
<cfset querySetCell(Clases,"IDClase",'5',5)>
<cfset querySetCell(Clases,"Clase",LB_SumaFija,5)>
<cfif LEN(TRIM(Lvar_Clases)) and not isdefined('form.ERCid')>
	<cfquery name="Clases" dbtype="query">
		select *
		from Clases
		where IDClase not in (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#Lvar_Clases#">)
	</cfquery>
</cfif>
<!--- Consultas --->
<cfoutput>
<!--- ENCABEZADO --->
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr bgcolor="CCCCCC"><td align="center"><strong>#rsGComponentes.RHCAcodigo#&nbsp;#rsGComponentes.RHCAdescripcion#</strong></td></tr>
	<tr bgcolor="CCCCCC"><td align="center"><strong>#rsComponentes.CScodigo#&nbsp;-&nbsp;#rsComponentes.CSdescripcion#</strong></td></tr>
</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="50%" valign="top">
			<cfset filtro  = "">
			<cfset navegacion = "">
				<cfinvoke 
					 component="rh.Componentes.pListas"
					 method="pListaRH"
					 returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="EReglaComponente"/>
						<cfinvokeargument name="columnas" value="#form.RHCAid# as RHCAid,ERCid,CSid,case ERCclase 
																					when 1 then 'Cantidad' 
																					when 2 then 'Código'
																					when 3 then 'Grado'
																					when 4 then 'Puesto'
																					when 5 then 'Suma Fija' end as Clase,ERCclase,
																					#form.PAGENUMPADRE# as PAGENUMPADRE,
																					#form.PAGENUM# as PAGENUM"/>
						<cfinvokeargument name="desplegar" value="Clase"/>
						<cfinvokeargument name="etiquetas" value="Clase"/>
						<cfinvokeargument name="formatos" value="S"/>
						<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# and CSid = #Form.CSid# #filtro#"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="align" value="left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="irA" value="ReglasComponentes.cfm"/>
						<cfinvokeargument name="keys" value="ERCid"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="EmptyListMsg" value=""/>
						<cfinvokeargument name="incluyeForm" value="true"/>
						<cfinvokeargument name="Pageindex" value="1"/>
					</cfinvoke>
			</td>
			<td width="50%" valign="top">
				<form name="formDetalles" action="sqlReglasComponentes.cfm" method="post">
					<cfif modo NEQ 'ALTA'>
						<input name="ERCid" type="hidden" value="#form.ERCid#">
						<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
						<input name="DRCid" type="hidden" value="" />
					</cfif>
						<input name="PAGENUM" type="hidden" value="#form.PAGENUM#" />
						<input name="PAGENUMPADRE" type="hidden" value="#form.PAGENUMPADRE#" />
					<input name="CSid" type="hidden" value="#form.CSid#">
					<input name="RHCAid" type="hidden" value="#form.RHCAid#">

					<table width="100%" cellpadding="0" cellspacing="0">
						<tr><td colspan="2"></td></tr>
						<tr>
							<td align="right"><strong><cf_translate key="LB_Clase">Clase</cf_translate>:</strong>&nbsp;</td>
							<td>
								<select name="ERCclase">
									<cfloop query="Clases">
									<option value="#Clases.IDClase#" <cfif isdefined('form.ERCid') and isdefined('form.ERCclase') and form.ERCclase EQ Clases.IDClase>selected</cfif>>#Clases.Clase#</option>
									</cfloop>
								</select>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>	
						<tr><td colspan="2" align="center"><cf_botones modo="#form.modo#" include="Regresar"></td></tr>
						<tr><td>&nbsp;</td></tr>	
						<!--- DETALLE DE LAS CLASES ASIGNADAS A LOS COMPONENTES --->		
						<cfif isdefined('form.ERCid') and form.ERCid GT 0>
							<tr>
								<td colspan="2">
									<table width="100%" cellpadding="0" cellspacing="0">
										<tr class="tituloListas"><td colspan="6" align="center"><strong><cf_translate key="LB_Detalle">Detalle</cf_translate></strong></td></tr>
										<tr><td>&nbsp;</td></tr>
										<tr>
											<td align="right"><strong><cf_translate key="LB_Detalle">Detalle</cf_translate>:</strong>&nbsp;</td>
											<td><input name="DRCdetalle" type="text" size="5" value=""></td>
											<td align="right"><strong><cf_translate key="LB_Valor">Valor</cf_translate>:</strong>&nbsp;</td>
											<td><input name="DRCvalor" type="text" size="10" value=""></td>
											<td align="right"><strong><cf_translate key="LB_Metodo">M&eacute;todo</cf_translate>:</strong>&nbsp;</td>
											<td>
												<select name="DRCmetodo">
													<option value="M"><cf_translate key="CMB_Monto">Monto</cf_translate></option>
													<option value="P"><cf_translate key="CMB_Porcentaje">Porcentaje</cf_translate></option>
												</select>
											</td>
											<td><input name="AgregaD" type="submit" value="+" ></td>
										</tr>
										<tr><td>&nbsp;</td></tr>
										<tr class="tituloListas">
											<td align="center" colspan="2"><strong><cf_translate key="LB_Detalle">Detalle</cf_translate></strong>&nbsp;</td>
											<td align="right" colspan="2"><strong><cf_translate key="LB_Valor">Valor</cf_translate></strong>&nbsp;</td>
											<td align="right" colspan="2"><strong><cf_translate key="LB_Metodo">M&eacute;todo</cf_translate></strong>&nbsp;</td>
											<td>&nbsp;</td>
										</tr>
										<cfloop query="rsDform">
											<tr >
												<td align="center" colspan="2">#DRCdetalle#</td>
												<td align="right" colspan="2">#DRCvalor#</td>
												<td align="right" colspan="2">
													<cfif DRCmetodo EQ 'M'><cf_translate key="LB_Monto">Monto</cf_translate><cfelse><cf_translate key="LB_Porcentaje">Porcentaje</cf_translate></cfif>
												</td>
												<td><img src="/cfmx/rh/imagenes/Borrar01_S.gif" onclick="javascript: funcEliminar(#DRCid#,0); "  /></td>
											</tr>
										</cfloop>
									</table>
								</td>
							</tr>
						</cfif>
					</table>
				</form>
			</td>
		</tr>
	</table>

<cfif isdefined('form.ERCid') and form.ERCid GT 0>
<cf_qforms form='formDetalles' objForm='objFormDetalles'>
	<cf_qformsrequiredfield args="DRCdetalle, #MSG_Detalle#">
	<cf_qformsrequiredfield args="DRCvalor, #MSG_Valor#">
	<cf_qformsrequiredfield args="DRCmetodo, #MSG_Metodo#">
</cf_qforms>
</cfif>
</cfoutput>

<script>
	function funcCambio(){
		deshabilitarValidacion();
	}
	<cfif isdefined('form.ERCid') and form.ERCid GT 0>
		function deshabilitarValidacion(){
			objFormDetalles.DRCdetalle.required = false;
			objFormDetalles.DRCvalor.required = false;
			objFormDetalles.DRCmetodo.required = false;
		}
		function habilitarValidacion(){
			objFormDetalles.DRCdetalle.required = true;
			objFormDetalles.DRCvalor.required = true;
			objFormDetalles.DRCmetodo.required = true;
		}	
	</cfif>
	
	function funcEliminar(ID){
		var f = document.formDetalles;
		if (confirm('<cfoutput>#MSG_DeseaEliminarElRegistro#</cfoutput>')){
			f.DRCid.value = ID;
			f.botonSel.value = 'EliminarD';
			f.submit();	
		}
		return false;
	}
	function funcRegresar(){
		var f = document.formDetalles;
		<cfif isdefined('form.ERCid') and form.ERCid GT 0>
		deshabilitarValidacion();
		</cfif>
		f.action = "Componentes.cfm";
		return true;
	}
</script>
