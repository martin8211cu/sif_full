<cfoutput>
<cfif modo neq 'ALTA' and isdefined('form.ID_PPreciov') and len(trim('form.ID_PPreciov'))>
	<cfquery name="rsSelectDatosPrecio" datasource="#session.dsn#">
		select pp.ID_PPreciov, pp.Mcodigo, pp.PPrecio, pp.ts_rversion,  p.Pid, p.Pcodigo, p.Pdescripcion,
               pv.PVid, pv.PVcodigo, pv.PVdescripcion, m.Mnombre
		from PPrecio pp inner join Peaje p 
		on pp.Pid = p.Pid 
        inner join PVehiculos pv
        on pv.PVid=pp.PVid
		inner join Monedas m
		on pp.Mcodigo= m.Mcodigo
		where pp.ID_PPreciov=#form.ID_PPreciov#
	</cfquery>	
	<cfset ID_PPreciov=rsSelectDatosPrecio.ID_PPreciov>
	<cfset PPrecio=rsSelectDatosPrecio.PPrecio>
	
	<cfset Pid=rsSelectDatosPrecio.Pid>
	<cfset Pcodigo=rsSelectDatosPrecio.Pcodigo>
	<cfset Pdescripcion=rsSelectDatosPrecio.Pdescripcion>
	
	<cfset PVid=rsSelectDatosPrecio.PVid>
	<cfset PVcodigo=rsSelectDatosPrecio.PVcodigo>
	<cfset PVdescripcion=rsSelectDatosPrecio.PVdescripcion>
	
	<cfset Mcodigo=rsSelectDatosPrecio.Mcodigo>	
	<cfset Mnombre=rsSelectDatosPrecio.Mnombre>
<cfelse>
	<cfset ID_PPreciov="">
	<cfset PPrecio="">
	<cfset Pid="">
	<cfset Pcodigo="">
	<cfset Pdescripcion="">
	<cfset PVid="">
	<cfset PVcodigo="">
	<cfset PVdescripcion="">
	<cfset Mcodigo="">
	<cfset Mnombre="">
</cfif>

<cfquery name="rsSelectMonedas" datasource="#session.dsn#">
		select Mcodigo,Mnombre
		from Monedas
		where Ecodigo=#session.Ecodigo#
</cfquery>

<cfform action="Precio-SQL.cfm" method="post" name="form1">
	<table align="center">
		<tr> 
      		<td nowrap align="right">Peaje:</td>
      		<td>
				<cf_conlis
					Campos="Pid,Pcodigo,Pdescripcion"
					tabindex="6"
					values="#Pid#,#Pcodigo#,#Pdescripcion#,"
					Desplegables="N,S,S"
					Modificables="N,S,N"
					Size="0,15,35"
					Title="Lista de Peajes"
					Tabla="Peaje p"
					Columnas="Pid,Pcodigo,Pdescripcion"
					Filtro="Ecodigo = #Session.Ecodigo# order by Pcodigo,Pdescripcion"
					Desplegar="Pcodigo,Pdescripcion"
					Etiquetas="C&oacute;digo,Descripci&oacute;n"
					filtrar_por="Pcodigo,Pdescripcion"
					Formatos="S,S"
					Align="left,left"
					Asignar="Pid,Pcodigo,Pdescripcion"
					Asignarformatos="I,S,S"
					funcion="resetPeaje"/>
			</td>
    	</tr>
		<tr> 
      		<td nowrap align="right">Vehículos:</td>
      		<td>
				<cf_conlis
					Campos="PVid,PVcodigo,PVdescripcion"
					tabindex="6"
					values="#PVid#,#PVcodigo#,#PVdescripcion#"
					Desplegables="N,S,S"
					Modificables="N,S,N"
					Size="0,15,35"
					Title="Lista de Vehiculos"
					Tabla="PVehiculos pv"
					Columnas="PVid,PVcodigo,PVdescripcion"
					Filtro="Ecodigo = #Session.Ecodigo# order by PVcodigo,PVdescripcion"
					Desplegar="PVcodigo,PVdescripcion"
					Etiquetas="Codigo,Descripcion"
					filtrar_por="PVcodigo,PVdescripcion"
					Formatos="S,S"
					Align="left,left"
					Asignar="PVid,PVcodigo,PVdescripcion"
					Asignarformatos="I,S,S"
					funcion="resetPeaje"/>
			</td>
    	</tr>
		
	<tr> 
      		<td nowrap align="right">Moneda:</td>
      		<td>
				<cfselect name="monedas" id="monedas">
					<cfif modo neq "ALTA">
							<option Value="<cfoutput>#Mcodigo#</cfoutput>" selected><cfoutput>#Mnombre#</cfoutput></option>
					</cfif>
						<cfloop query="rsSelectMonedas">
							<option value="<cfoutput>#Mcodigo#</cfoutput>"><cfoutput>#Mnombre#</cfoutput></option>
					</cfloop>
				</cfselect>

			</td>
    	</tr>
			<tr> 
      		<td nowrap align="right">Precio:</td>
      		<td>
				<cf_monto name="PPrecio" id="PPrecio" tabindex="-1" value="#PPrecio#" decimales="2" negativos="false">
			</td>
    	</tr>
      		<td colspan="2">
				<cf_botones modo="#modo#">
			</td>
    	</tr>	
		<tr> 
      		<td colspan="2">
				<input type="hidden" name="modo" value="#modo#" />
				<input type="hidden" name="BMUsucodigo" value="#session.usucodigo#" />
				<input type="hidden" name="Ecodigo" value="#session.Ecodigo#" />
					<cfif modo neq "ALTA">
			<input type="hidden" id="ID_PPreciov" name="ID_PPreciov" value="#form.ID_PPreciov#" />
				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsSelectDatosPrecio.ts_rversion#" returnvariable="ts">
					</cfinvoke>
				</cfif>
			<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">
			</td>
    	</tr>
  	</table>
</cfform>
	<cf_qforms form="form1">
<script language="javascript1" type="text/javascript">
		objForm.Pcodigo.description = "Peaje";
		objForm.PVcodigo.description = "Tipo de Vehiculo";
		objForm.PPrecio.description = "Precio del peaje";
			
		objForm.Pcodigo.required = true;
		objForm.PVcodigo.required = true;
		objForm.PPrecio.required = true;
</script>
</cfoutput>
