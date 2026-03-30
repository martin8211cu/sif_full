<!--- modificado en notepad para incluir el boom --->
<cfparam name="url.PEXid" default="">
<cfquery datasource="#session.dsn#" name="data">
	select *
	from  RHPagosExternos where PEXid =
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PEXid#" null="#Len(url.PEXid) Is 0#">
	</cfquery>

<cfoutput>

<form action="RHPagosExternos-apply.cfm" enctype="multipart/form-data" method="post" name="form1" id="form1">
	<table width="1%" align="center" summary="Tabla de entrada">
	<tr><td colspan="2" class="subTitulo">
	#LB_RHPagosExternos#
	</td></tr>
	
		<tr><td valign="top" nowrap><label for="PEXTid">#LB_PEXTid#</label>
		</td><td valign="top">

			<cfquery name="rsdatatemp" datasource="#session.dsn#">
				select 
					t.PEXTid as c1,
					t.PEXTcodigo as c2,
					t.PEXTdescripcion as c3
				from RHPagosExternosTipo t
				where t.PEXTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.PEXTid#" null="#Len(data.PEXTid) Is 0#">
			</cfquery>
			
			<cfset valuesarray = ArrayNew(1)>
			<cfif rsdatatemp.recordcount gt 0>			
				<cfset ArrayAppend(valuesarray,rsdatatemp.c1)>
				<cfset ArrayAppend(valuesarray,rsdatatemp.c2)>
				<cfset ArrayAppend(valuesarray,rsdatatemp.c3)>
			</cfif>
			
			<cf_conlis
				valuesarray="#valuesarray#"
				campos="PEXTid, PEXTcodigo, PEXTdescripcion"
				desplegables="N,S,S"
				modificables="N,S,N"
				columnas="PEXTid, PEXTcodigo, PEXTdescripcion"
				tabla="RHPagosExternosTipo"
				filtro="Ecodigo=#Session.Ecodigo# order by 2"
				desplegar="PEXTcodigo, PEXTdescripcion"
				etiquetas="#LB_Codigo#, #LB_Descripcion#"
				formatos="S,S"
				align="left,left"
				asignar="PEXTid, PEXTcodigo, PEXTdescripcion"
				asignarformatos="S,S,S"
				tabindex="1"/>
		
		</td></tr>
		
		<tr><td valign="top" nowrap><label for="DEid">#LB_Empleado#</label>
		</td><td valign="top">
		
			<cfquery name="rsdatatemp" datasource="#session.dsn#">
				select 
					t.DEid as c1,
					t.DEidentificacion as c2,
					{fn concat(t.DEapellido1, {fn concat(' ', {fn concat(t.DEapellido2, {fn concat(' ', t.DEnombre)})})})} as c3
				from DatosEmpleado t
				where t.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.DEid#" null="#Len(data.DEid) Is 0#">
			</cfquery>
			
			<cfset valuesarray = ArrayNew(1)>
			<cfif rsdatatemp.recordcount gt 0>			
				<cfset ArrayAppend(valuesarray,rsdatatemp.c1)>
				<cfset ArrayAppend(valuesarray,rsdatatemp.c2)>
				<cfset ArrayAppend(valuesarray,rsdatatemp.c3)>
			</cfif>
			<cf_conlis
				valuesarray="#valuesarray#"
				campos="DEid, DEidentificacion, DEnombrecompleto"
				desplegables="N,S,S"
				modificables="N,S,N"
				columnas="DEid, DEidentificacion, {fn concat(DEapellido1, {fn concat(' ', {fn concat(DEapellido2, {fn concat(' ', DEnombre)})})})} as DEnombrecompleto"
				tabla="DatosEmpleado"
				filtro="Ecodigo=#Session.Ecodigo# order by 2"
				desplegar="DEidentificacion, DEnombrecompleto"
				filtrar_por="DEidentificacion|{fn concat(DEapellido1, {fn concat(' ', {fn concat(DEapellido2, {fn concat(' ', DEnombre)})})})}"
				filtrar_por_delimiters="|"
				etiquetas="#LB_DEidentificacion# #LB_Empleado#, #LB_DEnombrecompleto#  #LB_Empleado#"
				formatos="S,S"
				align="left,left"
				asignar="DEid, DEidentificacion, DEnombrecompleto"
				asignarformatos="S,S,S"
				tabindex="1"/>
		
		</td></tr>
		
		<tr><td valign="top" nowrap><label for="PEXfechaPago">#LB_PEXfechaPago#</label>
		</td><td valign="top">
		
			<cf_sifcalendario name="PEXfechaPago" id="PEXfechaPago" value="#LSDateFormat(data.PEXfechaPago,'dd/mm/yyyy')#" decimales="2" tabindex="1">
		
		</td></tr>
		
		<tr><td valign="top" nowrap><label for="PEXmonto">#LB_PEXmonto#</label>
		</td><td valign="top">
		
			<cf_inputNumber name="PEXmonto" id="PEXmonto" value="#iif(len(trim(data.PEXmonto)),HTMLEditFormat(data.PEXmonto),0.00)#" decimales="2" tabindex="1"/>
		
		</td></tr>
		
		<!---<tr><td valign="top" nowrap><label for="PEXperiodo">#LB_PEXperiodo#</label>
		</td><td valign="top">
		
			<cf_rhperiodos name="PEXperiodo" id="PEXperiodo" value="#HTMLEditFormat(data.PEXperiodo)#" tabindex="1">
			
		</td></tr>
		
		<tr><td valign="top" nowrap><label for="PEXmes">#LB_PEXmes#</label>
		</td><td valign="top">
		
			<cf_meses name="PEXmes" id="PEXmes" value="#HTMLEditFormat(data.PEXmes)#" tabindex="1">
		
		</td></tr>--->
		
	<tr><td colspan="2" class="formButtons">
		<cfif data.RecordCount>
			<cf_botones  regresar="RHPagosExternos.cfm" modo="CAMBIO" tabindex="1" width="500">
		<cfelse>
			<cf_botones  regresar="RHPagosExternos.cfm" modo="ALTA" tabindex="1" width="500">
		</cfif>
	</td></tr>
	</table>
	
	<input type="hidden" name="PEXid" value="#HTMLEditFormat(data.PEXid)#">

	<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
		artimestamp="#data.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">
		
</form>

</cfoutput>

<cf_qforms>
<script language="javascript" type="text/javascript">
objForm.PEXTid.description = "Tipo de Pago";	
objForm.DEid.description = "Empleado";	
objForm.PEXfechaPago.description = "Fecha de Pago";	
objForm.PEXmonto.description = "Monto";	

	function habilitarValidacion() {	
		objForm.PEXTid.required = true;					
		objForm.DEid.required = true;			
		objForm.PEXfechaPago.required = true;			
		objForm.PEXmonto.required = true;			
		
	}
</script>