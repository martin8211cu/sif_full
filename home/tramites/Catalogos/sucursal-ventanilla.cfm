<cfif not isdefined("form.fid_sucursal") and not isdefined("form.id_sucursal") and not isdefined("form.fid_inst") and not isdefined("form.id_inst") and isdefined("url.id_inst") and len(trim(url.id_inst)) and isdefined("url.id_sucursal") and len(trim(url.id_sucursal))>
	<cfset form.id_inst  = url.id_inst>
	<cfset form.fid_inst = url.id_inst>
	<cfset form.fid_sucursal = url.id_sucursal>
	<cfset form.id_sucursal = url.id_sucursal>
	<cfset instituciones =  url.instituciones>
</cfif>

<cf_templatecss>

	<table width="100%" border="0" cellspacing="1" cellpadding="0">
	<tr> 
		<td valign="top"><cfinclude template="sucursal-ventanilla-form.cfm"></td>
	</tr>

	<tr> 
		<td valign="top" >
			<cfquery name="rsLista" datasource="#session.tramites.dsn#">
				select TPInstitucion.id_inst,
					   TPVentanilla.id_sucursal,
					   id_ventanilla,
					   codigo_ventanilla,
					   nombre_ventanilla,
					   nombre_inst,
					   nombre_sucursal,
					   2 as tab,
					   'suc2' as tabsuc
					    
				from TPVentanilla,TPSucursal,TPInstitucion 

				where TPInstitucion .id_inst = TPSucursal.id_inst 
				  and TPVentanilla.id_sucursal = TPSucursal.id_sucursal 
				  and TPInstitucion.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
				  and TPVentanilla.id_sucursal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_sucursal#">

					<cfif isdefined("form.fcodigo_ventanilla") and len(trim(form.fcodigo_ventanilla))>
						and	upper (codigo_ventanilla) like upper('%#trim(form.fcodigo_ventanilla)#%')
					</cfif>
					<cfif isdefined("form.fnombre_ventanilla") and len(trim(form.fnombre_ventanilla))>
						and upper(nombre_ventanilla) like upper('%#trim(form.fnombre_ventanilla)#%')
					</cfif>
				order by codigo_sucursal
			</cfquery>

			<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="codigo_ventanilla,nombre_ventanilla"/>
				<cfinvokeargument name="etiquetas" value="C&oacute;digo,Ventanilla"/>
				<cfinvokeargument name="formatos" value="S,S"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="instituciones.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="id_inst,id_sucursal,id_ventanilla"/>
				<cfinvokeargument name="formname" value="listasv"/>
			</cfinvoke>
		</td>
	</tr>

	<tr> 
		<td colspan="3">&nbsp;</td>
	</tr> 
	</table>

<!---
<script language="javascript" type="text/javascript">
	function limpiar(){
		document.filtro.fcodigo_tiporeq.value = ' ';
		document.filtro.fnombre_tiporeq.value = ' ';
	}
</script>
--->