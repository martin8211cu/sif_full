<cfoutput>
<cfif modo neq 'ALTA' and isdefined('form.ID_PEmpleado') and len(trim('form.ID_PEmpleado'))>
	<cfquery name="rsSelectDatosEmpleado" datasource="#session.dsn#">
		select pe.ID_PEmpleado, pe.DEid, pe.PEfechaini, pe.PEfechafin, pe.ts_rversion,  p.Pid, p.Pcodigo, p.Pdescripcion,
               de.DEidentificacion, de.DEnombre, de.DEapellido1, de.DEapellido2
		from PEmpleado pe inner join Peaje p 
		on pe.Pid = p.Pid 
        inner join DatosEmpleado de
        on de.DEid=pe.DEid
		where pe.ID_PEmpleado=#form.ID_PEmpleado#
	</cfquery>
	<cfset ID_PEmpleado=rsSelectDatosEmpleado.ID_PEmpleado>
	<cfset DEid=rsSelectDatosEmpleado.DEid>
	<cfset PEfechaini=rsSelectDatosEmpleado.PEfechaini>
	<cfset PEfechafin=rsSelectDatosEmpleado.PEfechafin>
	
	<cfset Pid=rsSelectDatosEmpleado.Pid>
	<cfset Pcodigo=rsSelectDatosEmpleado.Pcodigo>
	<cfset Pdescripcion=rsSelectDatosEmpleado.Pdescripcion>
	
	<cfset DEidentificacion=rsSelectDatosEmpleado.DEidentificacion>
	<cfset DEnombre=rsSelectDatosEmpleado.DEnombre>
	<cfset DEapellido1=rsSelectDatosEmpleado.DEapellido1>
	<cfset DEapellido2=rsSelectDatosEmpleado.DEapellido2>
<cfelse>
	<cfset ID_PEmpleado="">
	<cfset DEid="">
	<cfset PEfechaini="">
	<cfset PEfechafin="">
	<cfset Pid="">
	<cfset Pcodigo="">
	<cfset Pdescripcion="">
	<cfset DEidentificacion="">
	<cfset DEnombre="">
	<cfset DEapellido1="">
	<cfset DEapellido2="">
</cfif>
<cfform action="Empleado-SQL.cfm" method="post" name="form1" onSubmit="return validar(this);">
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
      		<td nowrap align="right">Empleado:</td>
      		<td>
				<cf_conlis
					Campos="DEid,DEidentificacion,DEnombre,DEapellido1,DEapellido2"
					tabindex="6"
					values="#DEid#,#DEidentificacion#,#DEnombre#,#DEapellido1#,#DEapellido2#"
					Desplegables="N,S,S,S,S"
					Modificables="N,N,S,S,S"
					Size="0,15,30,12,12"
					Title="Lista de Empleados"
					Tabla="DatosEmpleado de"
					Columnas="DEid,DEidentificacion,DEnombre,DEapellido1,DEapellido2  "
					Filtro="Ecodigo = #Session.Ecodigo# order by DEidentificacion,DEnombre,DEapellido1,DEapellido2 "
					Desplegar="DEidentificacion,DEnombre,DEapellido1,DEapellido2"
					Etiquetas="Cedula,Nombre,Apellido1,Apellido2"
					filtrar_por="DEidentificacion,DEnombre,DEapellido1,DEapellido2"
					Formatos="S,S,S,S"
					Align="left,left,left,left"
					Asignar="DEid,DEidentificacion,DEnombre,DEapellido1,DEapellido2"
					Asignarformatos="I,S,S,S,S"
					funcion="resetPeaje"/>
			</td>
    	</tr>
			<tr>
                <td align="right"><strong>Fecha de Inicio:</strong></td>
                <td>
						<cfif modo NEQ 'ALTA'>
							<cfset PEfechaini  = DateFormat(#PEfechaini#,'DD/MM/YYYY') >
						</cfif>
					<cf_sifcalendario form="form1" value="#PEfechaini#" name="PEfechaini" tabindex="1">
                </td>
			</tr>
			<tr>	
                <td align="right"><strong>Fecha Final:</strong></td>
                <td>
						<cfif modo NEQ 'ALTA'>
							<cfset PEfechafin  = DateFormat(#PEfechafin#,'DD/MM/YYYY') >
						</cfif>
					<cf_sifcalendario form="form1" value="#PEfechafin#" name="PEfechafin" tabindex="1">
                </td>
         	</tr>	
		<tr> 
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
			<input type="hidden" id="ID_PEmpleado" name="ID_PEmpleado" value="#form.ID_PEmpleado#" />
				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsSelectDatosEmpleado.ts_rversion#" returnvariable="ts">
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
		objForm.DEidentificacion.description = "Empleado";
		objForm.PEfechaini.description = "Fecha de Inicio";
		objForm.PEfechafin.description = "Fecha Final";
		
		objForm.Pcodigo.required = true;
		objForm.DEidentificacion.required = true;
		objForm.PEfechaini.required = true;
		objForm.PEfechafin.required = true;
		
	function fnFechaYYYYMMDD (LvarFecha)
	{
		return LvarFecha.substr(6,4)+LvarFecha.substr(3,2)+LvarFecha.substr(0,2);
	}
	
	function validar(form1){
		if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) && !btnSelected('IrLista',document.form1)){
			var error_input;
			var error_msg = '';
	
		if (fnFechaYYYYMMDD(document.form1.PEfechaini.value) > fnFechaYYYYMMDD(document.form1.PEfechafin.value))
		{
			alert ("La Fecha de Vigencia Desde debe ser menor a la Fecha Hasta");
			return false;
		}

	// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
	}
}    


</script>
</cfoutput>
