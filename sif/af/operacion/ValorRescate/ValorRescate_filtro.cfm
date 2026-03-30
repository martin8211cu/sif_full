<cf_web_portlet_start titulo="<cfoutput>Filtro de Activos</cfoutput>">
<cfoutput>
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<form name="filtro" action="ValorRescate_filtro_sql.cfm" method="post" onSubmit="return validar(this);">
<cfif isdefined ('url.AFTRid')>
<input type="hidden" name="AFTRid" value="#url.AFTRid#" />
</cfif>
<table width="100%">
	<tr>
		<td align="right"><strong>Categor&iacute;a :</strong></td>
		<td>

				<cf_conlis
					Campos="ACcodigoORI,CATORI,CATdescripcionORI"
					Desplegables="N,S,S"
					Modificables="N,S,N"
					Size="0,10,30"
					tabindex="1"
					Title="Lista de Categor&iacute;as"
					Tabla="ACategoria "
					Columnas="ACcodigo as ACcodigoORI,ACcodigodesc as CATORI,ACdescripcion as CATdescripcionORI"
					Filtro=" Ecodigo = #session.Ecodigo#"
					Desplegar="CATORI,CATdescripcionORI"
					Etiquetas="C&oacute;digo,Descripci&oacute;n"
					filtrar_por="ACcodigodesc,ACdescripcion"
					Formatos="S,S"
					Align="left,left"
					form="filtro"
					Asignar="ACcodigoORI,CATORI,CATdescripcionORI"
					Asignarformatos="S,S,S"/>
		</td>
	</tr>
	<tr>
		<td align="right"><strong>Clase :</strong></td>
			<td>
				<cf_conlis title="LISTA DE EMPLEADOS"
				Campos="ACidORI,CLASSORI,CLASSdescripcionORI"
				Desplegables="N,S,S"
				Modificables="N,S,N"
				Size="0,10,30"
				Asignar="ACidORI,CLASSORI,CLASSdescripcionORI"
				Asignarformatos="S,S,S"
				Tabla="AClasificacion "
				Columnas="ACid as ACidORI,ACcodigodesc as CLASSORI,ACdescripcion as CLASSdescripcionORI"
				Filtro=" Ecodigo = #session.Ecodigo# and ACcodigo = $ACcodigoORI,numeric$"
				Desplegar="CLASSORI,CLASSdescripcionORI"
				Etiquetas="C&oacute;digo,Descripci&oacute;n"
				Formatos="S,S"
				Align="left,left"
				showEmptyListMsg="true"
				EmptyListMsg=""
				form="filtro"
				width="800"
				height="500"
				left="70"
				top="20"
				filtrar_por="ACcodigodesc,ACdescripcion"
				tabindex="1"			
				/>        
			</td>
	</tr>
	<tr>
		<td nowrap align="right"><strong>Marca&nbsp;:&nbsp;</strong></td>
			<td rowspan="2">
				<cfif (isdefined('rsMarcaMod'))
						and (rsMarcaMod.recordCount)>
					<cf_sifmarcamod	query="#rsMarcaMod#" tabindexMar="1" tabindexMod="1">
				<cfelse>
					<cf_sifmarcamod  tabindexMar="1" tabindexMod="1" form="filtro">
				</cfif>
			</td>
	</tr>
	<tr>
		<td align="right"><strong>Modelo:</strong></td>
		
	</tr>
	<tr>
		<td align="right"><strong>Tipo:</strong></td>
		<td>
			
				<cf_conlis 
					Campos="AFCcodigoORI,AFCcodigoclasORI,AFCdescripcionORI"
					Desplegables="N,S,S"
					Modificables="N,S,N"
					Size="0,10,30"
					tabindex="1"
					Title="Lista de tipos"
					Tabla="AFClasificaciones "
					Columnas="AFCcodigo as AFCcodigoORI,AFCcodigoclas as AFCcodigoclasORI,AFCdescripcion as AFCdescripcionORI,AFCnivel as AFCnivelORI"
					Filtro=" Ecodigo = #session.Ecodigo#"
					Desplegar="AFCcodigoclasORI,AFCdescripcionORI,AFCnivelORI"
					Etiquetas="C&oacute;digo,Descripci&oacute;n,Nivel"
					filtrar_por="AFCcodigoclas,AFCdescripcion,AFCnivel"
					Formatos="S,S,S"
					Align="left,left,left"
					form="filtro"
					Asignar="AFCcodigoORI,AFCcodigoclasORI,AFCdescripcionORI"
					Asignarformatos="S,S,S"/>
		</td>
	</tr>
	<tr>
		<td class="fileLabel" align="right"><strong>Centro Funcional:&nbsp;</strong></td>
		<td>
			<cfset valuesArraySN = ArrayNew(1)>
			<cfif isdefined("rsForm.CFid") and len(trim(rsForm.CFid))>
				<cfquery datasource="#Session.DSN#" name="rsSN">
				select 
				CFid,
				CFcodigo,
				CFdescripcion
				from
				CFuncional
				where 
				Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFid#">
				</cfquery>
					<cfset ArrayAppend(valuesArraySN, rsSN.CFid)>
					<cfset ArrayAppend(valuesArraySN, rsSN.CFcodigo)>
					<cfset ArrayAppend(valuesArraySN, rsSN.CFdescripcion)>
			</cfif>   
						<cf_conlis
						Campos="CFid,CFcodigo,CFdescripcion"
						valuesArray="#valuesArraySN#"
						Desplegables="N,S,S"
						Modificables="N,S,N"
						Size="0,10,40"
						tabindex="1"
						Title="Lista de Centros Funcionales"
						Tabla="CFuncional cf 
						inner join Oficinas o 
						on o.Ecodigo=cf.Ecodigo 
						and o.Ocodigo=cf.Ocodigo
						inner join TESusuarioSP tu
						on tu.CFid                 = cf.CFid
						and tu.Ecodigo            = #session.Ecodigo#
						and tu.TESUSPsolicitante = 1"
						Columnas="distinct cf.CFid,cf.CFcodigo,cf.CFdescripcion #_Cat# ' (Oficina: ' #_Cat# rtrim(o.Oficodigo) #_Cat# ')' as CFdescripcion"
						Filtro=" cf.Ecodigo = #Session.Ecodigo#  order by cf.CFcodigo"
						Desplegar="CFcodigo,CFdescripcion"
						Etiquetas="Codigo,Descripcion"
						filtrar_por="cf.CFcodigo,CFdescripcion"
						Formatos="S,S"
						Align="left,left"
						form="filtro"
						Asignar="CFid,CFcodigo,CFdescripcion"
						Asignarformatos="S,S,S,S"
						/> 
		</td>
	</tr>
	<tr>
		<td class="fileLabel" align="right">
			<strong>Placa Desde:</strong>
		</td>
		<td>
			<input name="AplacaDesde" id="AplacaDesde" value="" type="text" maxlength="20" tabindex="1">
		</td>
	</tr>
	<tr>
		<td class="fileLabel" align="right">
			<strong>Placa Hasta:</strong>
		</td>
		<td>
			<input name="AplacaHasta" id="AplacaHasta" value="" type="text" maxlength="20" tabindex="1">
		</td>
	</tr>
	<tr>
		<td class="fileLabel" align="right"><strong>Valor de Rescate:&nbsp;</strong></td>
		<td><cf_inputNumber name="valor" size="15" enteros="13" decimales="2" tabindex="1"></td>
	
	<tr>
	
		<tr><td align="center" colspan="2"><input type="checkbox" name="vr" tabindex="1"> Valor de rescate diferente de 0</td></tr>
	</tr>
	<tr><td align="center" colspan="3"><input type="submit" value="Filtrar" name="filtrar" id="filtrar" tabindex="1"></td></tr>
	
	<cfif isdefined("url.bandera")>
		<td colspan="2" align="center">
			<font color="FF0000"><strong>Su busqueda no genero ningun resultado</strong></font>
		</td>
	</cfif>

</table>
</form>
</cfoutput>
<cf_web_portlet_end>
	<script type="text/javascript">
function validar(formulario)	{
formulario.valor.value = qf(formulario.valor);
}
</script>