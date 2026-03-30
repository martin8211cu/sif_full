<cfset modoreq = 'ALTA' >
<cfif isdefined("form.id_ventanilla")>
	<cfset modoreq = 'CAMBIO' >
</cfif>

<cfquery name="rsSucursales" datasource="#session.tramites.dsn#">
	select id_sucursal,codigo_sucursal,nombre_sucursal 
	from TPSucursal 
	where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
</cfquery>

<cfquery name="rsVentanillas" datasource="#session.tramites.dsn#">
	select id_sucursal,id_ventanilla,codigo_ventanilla,nombre_ventanilla
	from TPVentanilla 
	order by id_sucursal,id_ventanilla
</cfquery>

<cfif modoreq neq 'ALTA'>
	<cfquery name="data" datasource="#session.tramites.dsn#">
		select a.id_ventanilla, a.id_funcionario, nombre_sucursal, nombre_ventanilla, a.ts_rversion, ventanilla_default, funcionario_default 
		from TPRFuncionarioVentanilla a, TPVentanilla b, TPSucursal c
		where a.id_ventanilla = b.id_ventanilla 
		  and b.id_sucursal = c.id_sucursal	
		  and id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_funcionario#">
		  and a.id_ventanilla  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_ventanilla#" >
		order by a.id_ventanilla
	</cfquery>
</cfif>

<cfoutput>
<form name="formv" method="post" style="margin:0;" action="funcionario-ventanilla-sql.cfm" onsubmit="return validarfv(this);">
	<input type="hidden" name="id_funcionario" value="#Form.id_funcionario#">
	<table width="400" align="center" cellpadding="2" cellspacing="0">
		<tr>
			<td width="16%" align="right">Sucursal:&nbsp;</td>
			<td width="56%">
				<cfif modoreq eq 'ALTA'>
					<select name="id_sucursal" onChange="javascript: CargaVent(this.value);">
						<option value="">-seleccionar-</option>
						<cfloop query="rsSucursales">
							<option value="#rsSucursales.id_sucursal#">#rsSucursales.codigo_sucursal#-#rsSucursales.nombre_sucursal#</option>
						</cfloop>
					</select>					
				<cfelse>
					#data.nombre_sucursal#
				</cfif>
			</td>
		</tr>
		<tr>
			<td  align="right">Ventanilla:&nbsp;</td>
			<td>
				<cfif modoreq eq 'ALTA'>
					<select name="id_ventanilla" >
						<option value="">-seleccionar-</option>
					</select>		
				<cfelse>
					#data.nombre_ventanilla#
				</cfif>						
			</td>	
		</tr>

		<cfquery name="hayVentanillas" datasource="#session.tramites.dsn#">
			select 1 
			from TPRFuncionarioVentanilla
			where id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_funcionario#">
		</cfquery>

		<tr>	
			<td   nowrap align="right">Ventanilla default:&nbsp;</td>
			<td>
				<input type="checkbox" name="ventanilla_default" <cfif modoreq neq 'ALTA' and data.ventanilla_default eq 1>checked<cfelseif hayVentanillas.recordcount eq 0>checked</cfif>>
			</td>	
		</tr>
		<tr>
			<td colspan="2" align="center">
				<cfif modoreq neq 'ALTA'>
					<input type="submit" name="Modificar" value="Modificar" >
					<input type="submit" name="Eliminar" value="Eliminar" onClick="javascript: if ( confirm('Desea eliminar el registro?') ){  deshabilitarValidacion(); return true;} return false;">
					<input type="submit" name="Nuevo" value="Nuevo" >
			<cfelse>
					<input type="submit" name="Agregar" value="Agregar" >
				</cfif>
			</td>
		</tr>
	</table>

	<cfset ts = "">
	<cfif modoreq NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#data.ts_rversion#" returnvariable="ts"></cfinvoke>
	</cfif>
	<input type="hidden" name="ts_rversion" value="<cfif modoreq NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">
	<cfif modoreq neq 'ALTA'>
		<input type="hidden" name="id_ventanilla" value="#data.id_ventanilla#">
	</cfif>
	<input name="id_inst" type="hidden" value="<cfif isdefined("Form.id_inst")><cfoutput>#Form.id_inst#</cfoutput></cfif>">
	<input name="id_persona" type="hidden" value="<cfif isdefined("Form.id_persona")><cfoutput>#Form.id_persona#</cfoutput></cfif>">
	<input name="tab" type="hidden" value="4">
</form>
</cfoutput>

<script type="text/javascript" language="javascript1.2">
	function CargaVent(valor){
		var form = document.formv;
		var combo = form.id_ventanilla;
		var i = 1;
		<cfoutput query="rsVentanillas">
			var tmp = #rsVentanillas.id_sucursal# ;
			if ( valor != '' && tmp != '' && parseFloat(valor) == parseFloat(tmp) ) {
				combo.length++;
				combo.options[i].text = '#trim(rsVentanillas.codigo_ventanilla)#-#trim(rsVentanillas.nombre_ventanilla)#';
				combo.options[i].value = '#rsVentanillas.id_ventanilla#';
				i++;
			}
		</cfoutput>
	}

	function validarfv(f){
		var msj = '';
		<cfif modoreq EQ "ALTA">
			if ( document.formv.id_sucursal.value == '' ){
				var msj = msj + ' - El campo sucursal es requerido.\n';
			}
		</cfif>
		if ( document.formv.id_ventanilla.value == '' ){
			var msj = msj + ' - El campo ventanilla es requerido.\n';
		}
		if ( msj != ''){
			msj = 'Se presentaron los siguientes errores:\n' + msj;
			alert(msj)
			return false;
		}

		return true
	}
</script>


<cfquery name="rsLista2" datasource="#session.tramites.dsn#">
	select a.id_ventanilla,
		   a.id_funcionario,
		   c.id_inst,
		   nombre_sucursal,
		   nombre_ventanilla,
		   '<cfoutput>#rsDatos.id_persona#</cfoutput>' as id_persona,
		   case when ventanilla_default = 1 then '<img border=0 src=/cfmx/home/tramites/images/checked.gif>' else '<img border=0 src=/cfmx/home/tramites/images/unchecked.gif>' end as  ventanilla_default,
		   4 as tab

	from TPRFuncionarioVentanilla a, TPVentanilla b,TPSucursal c

	where a.id_ventanilla = b.id_ventanilla 
	  and b.id_sucursal = c.id_sucursal	
	  and id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_funcionario#">

	order by a.id_ventanilla
</cfquery>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsLista2#"/>
	<cfinvokeargument name="desplegar" value="nombre_sucursal,nombre_ventanilla,ventanilla_default"/>
	<cfinvokeargument name="etiquetas" value="Sucursal,Ventanilla,Ventanilla Def."/>
	<cfinvokeargument name="formatos" value="V,V,V"/>
	<cfinvokeargument name="align" value="left,left,center"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="instituciones.cfm"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="keys" value="id_ventanilla,id_funcionario,id_inst,id_persona"/>
	<cfinvokeargument name="formname" value="listafv"/>
</cfinvoke>
