
<!--- Asignar Gestor o Abogado--->
<cfif form.whatToDo eq 'UPDATE'>
	<!--- Asignar Gestor --->
	<cfif isdefined('form.GDEID')>
		<cfif form.GDEID NEQ "">
			<cfquery name="q_update" datasource="#session.DSN#">
				update CRCCuentas set 
					DatosEmpleadoDEid = #form.GDEID#, 
					FechaGestor = CURRENT_TIMESTAMP,
					Usumodif = #session.usucodigo#,
					updatedat = CURRENT_TIMESTAMP
				where id = #form.id#
			</cfquery>
		</cfif>
	</cfif>
	<!--- Asignar Abogado --->
	<cfif isdefined('form.ADEID')>
		<cfif form.ADEID NEQ "">
			<cfquery name="q_update" datasource="#session.DSN#">
				update CRCCuentas set 
					DatosEmpleadoDEid2 = #form.ADEID#, 
					FechaAbogado = CURRENT_TIMESTAMP,
					Usumodif = #session.usucodigo#,
					updatedat = CURRENT_TIMESTAMP
				where id = #form.id#
			</cfquery>
		</cfif>
	</cfif>
</cfif>

<!--- Remover Abogado --->
<cfif form.whatToDo eq 'ADELETE'>
	<cfquery name="q_update" datasource="#session.DSN#">
		update CRCCuentas set 
			DatosEmpleadoDEid2 = null,
			FechaAbogado = null,
			Usumodif = #session.usucodigo#,
			updatedat = CURRENT_TIMESTAMP
			where id = #form.id#
	</cfquery>
</cfif>

<!--- Remover Gestor --->
<cfif form.whatToDo eq 'GDELETE'>
	<cfquery name="q_update" datasource="#session.DSN#">
		update CRCCuentas set 
			DatosEmpleadoDEid = null, 
			FechaGestor = null,
			Usumodif = #session.usucodigo#,
			updatedat = CURRENT_TIMESTAMP 
			where id = #form.id#
	</cfquery>
</cfif>

<!--- Cambiar Estado a la cuenta --->
<cfif form.whatToDo eq 'cambiarEstado'>
	<cfquery name="q_update" datasource="#session.DSN#">
		update CRCCuentas set 
			CRCEstatusCuentasid = #form.nuevoEstado#,
			Usumodif = #session.usucodigo#,
			updatedat = CURRENT_TIMESTAMP
			where id = #form.id#
	</cfquery>
</cfif>

<!--- Cambiar Categoria a la cuenta --->
<cfif form.whatToDo eq 'cambiarCategoria'>
	<cfset tipo = ListToArray(form.nuevaCategoria,'|')[1] >
	<cfset nuevaCatID = ListToArray(form.nuevaCategoria,'|')[2] >
	<cfset nuevaCatOrd = ListToArray(form.nuevaCategoria,'|')[3] >
	<cfscript>
		campoSeguro = "";
		switch(trim(tipo)){
			case "D": campoSeguro = "DSeguro"; break;
			case "TC": campoSeguro = "TCSeguro"; break;
			case "TM": campoSeguro = "TMSeguro"; break;
			default: campoSeguro = "";
		}
	</cfscript>
	<cfquery name="q_update" datasource="#session.DSN#">
		update CRCCuentas set 
			CRCCategoriaDistid = #nuevaCatID#,
			Usumodif = #session.usucodigo#,
			updatedat = CURRENT_TIMESTAMP
			where id = #form.id#;
		<cfif form.catsubsidio le nuevaCatOrd>
			update CRCTCParametros set #campoSeguro# = 2 where CRCCuentasid = #form.id#;
		<cfelse>
			update CRCTCParametros set #campoSeguro# = case #campoSeguro# when 0 then 0 else 1 end where CRCCuentasid = #form.id#;
		</cfif>
	</cfquery>
</cfif>

<!--- Cambiar Seguro de la cuenta --->
<cfif form.whatToDo eq 'cambiarSeguro'>
	<cfset tipo = ListToArray(form.nuevoSeguro,'|')[1] >
	<cfset seguro = ListToArray(form.nuevoSeguro,'|')[2] >
	<cfscript>
		campoSeguro = "";
		switch(trim(tipo)){
			case "D": campoSeguro = "DSeguro"; break;
			case "TC": campoSeguro = "TCSeguro"; break;
			case "TM": campoSeguro = "TMSeguro"; break;
			default: campoSeguro = "";
		}
	</cfscript>
	<cfquery datasource="#session.dsn#">
			update CRCTCParametros set #campoSeguro# = #seguro# where CRCCuentasid = #form.id#;
	</cfquery>
</cfif>


<!--- Agregar Incidencia --->
<cfif form.whatToDo eq 'AddINCI'>
	<cfquery name="q_update" datasource="#session.DSN#">
		insert into CRCIncidenciasCuenta (
			CRCCuentasid,Corte,Observaciones, TipoEmpleado, CRCTipoTransaccionid, Monto,TransaccionPendiente,
			DatosEmpleadoDEid, Ecodigo,Usucrea,createdat,Usumodif
			) values(
			#form.id#,
			'#form.CODIGOCORTE#',
			'#form.observaciones#',
			'#form.tipoempleado#',
			<cfif #form.tipoTransID# eq ''> null <cfelse> #form.tipoTransID# </cfif>,
			<cfif #form.tipoTransID# neq ''> #form.monto# <cfelse> 0 </cfif>,
			<cfif #form.tipoTransID# neq ''> '0'<cfelse> '2' </cfif>,
			#form.empleadoid#,
			#session.ecodigo#, 
			#session.usucodigo#, 
			CURRENT_TIMESTAMP, 
			#session.usucodigo#		
			);
	</cfquery>
</cfif>

<!--- Modificar Incidencia --->
<cfif form.whatToDo eq 'UpdateINCI' || form.whatToDo eq 'ProcessINCI'>
	<cfquery name="q_Incidencia" datasource="#session.DSN#">
		select TransaccionPendiente from CRCIncidenciasCuenta 
		where id = #form.InciID#  and ecodigo = #session.ecodigo#
	</cfquery>

	<cfif ArrayContains([0,2], q_Incidencia.TransaccionPendiente)>
		<cfquery name="q_update" datasource="#session.DSN#">
			update CRCIncidenciasCuenta set 
					Observaciones = '#form.observaciones#'
				,	CRCTipoTransaccionid = <cfif #form.tipoTransID# eq ''> null <cfelse> #form.tipoTransID# </cfif>
				,	Monto = <cfif #form.tipoTransID# neq ''> #form.monto# <cfelse> 0 </cfif>
				,	TransaccionPendiente = <cfif #form.tipoTransID# neq ''> '0'<cfelse> '2' </cfif>
				,	updatedat = CURRENT_TIMESTAMP
				,	Usumodif = #session.usucodigo#
				where id = #form.InciID#
		</cfquery>
	</cfif>
</cfif>

<!--- Aplicar o Rechazar Incidencia --->
<cfif form.whatToDo eq 'ProcessINCI'>

	<cfquery name="q_Incidencia" datasource="#session.DSN#">
		select TransaccionPendiente from CRCIncidenciasCuenta 
		where id = #form.InciID#  and ecodigo = #session.ecodigo#
	</cfquery>

	<!--- Estados de Incidencia: 0-Pendiente, 1-Aplicada, 2-N/A, 3-Rechazada --->
	<cfif q_Incidencia.TransaccionPendiente eq 0>
		<cfif form.ProcesarInciComo eq 'a'>
			<cfinvoke  component ="crc.Componentes.incidencias.CRCIncidencia" method="AplicarIncidencia">
				<cfinvokeargument name="ID_Incidencia" value="#form.InciID#" >
			</cfinvoke>
			<cfset aplicar = 1>
		<cfelse>
			<cfset aplicar = 3>
		</cfif>
		<cfquery name="q_update" datasource="#session.DSN#">
			update CRCIncidenciasCuenta set 
					Observaciones = '#form.observaciones#'
				,	CRCTipoTransaccionid = <cfif #form.tipoTransID# eq ''> null <cfelse> #form.tipoTransID# </cfif>
				,	Monto = <cfif #form.tipoTransID# neq ''> #form.monto# <cfelse> 0 </cfif>
				,	TransaccionPendiente = #aplicar#
				,	updatedat = CURRENT_TIMESTAMP
				,	Usumodif = #session.usucodigo#
				where id = #form.InciID#
		</cfquery>
	</cfif>


</cfif>