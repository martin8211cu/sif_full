<cfset param = "">
<!---======================Agregar un Nuevo Envento=============================--->
<cfif isdefined('ALTA')>
	<cftransaction>
		<cfinvoke component="sif.Componentes.ControlEventos" method="ALTA_EVENTO" returnvariable="CEVid">
			<cfinvokeargument name="TEVid" 			value="#form.TEVid#">
			<cfinvokeargument name="CEVidTabla"  	value="#form.CEVidTabla#">
			<cfinvokeargument name="CEVDescripcion" value="#ltrim(rtrim(form.CEVDescripcion))#">
			<cfinvokeargument name="FechaEvento" 	value="#lsparseDatetime(form.FechaEvento)#">
		   <cfif isdefined('form.HoraEvento') and len(trim(form.HoraEvento)) GT 0>
			<cfinvokeargument name="HoraEvento"	 	value="#form.HoraEvento#">
		   </cfif>
		</cfinvoke>
		
		<cfinvoke component="sif.Componentes.ControlEventos" method="ALTA_SEGUIMIENTO">
			<cfinvokeargument name="CEVid" 			value="#CEVid#">
			<cfinvokeargument name="SEVDescripcion" value="Estado Inicial">
		</cfinvoke>
	</cftransaction>
	
	<cfset param = "CEVid=#CEVid#&tab=#form.tab#">
<!---======================Modificar un Envento=================================--->
<cfelseif isdefined('CAMBIO')>
	<cfinvoke component="sif.Componentes.ControlEventos" method="CAMBIO_EVENTO">
		<cfinvokeargument name="CEVid" 			value="#form.CEVid#">
		<cfinvokeargument name="CEVDescripcion" value="#ltrim(rtrim(form.CEVDescripcion))#">
		<cfinvokeargument name="FechaEvento" 	value="#lsparseDatetime(form.FechaEvento)#">
	   <cfif isdefined('form.HoraEvento') and len(trim(form.HoraEvento)) GT 0>
		<cfinvokeargument name="HoraEvento"	 	value="#form.HoraEvento#">
	   </cfif>
	</cfinvoke>
	<cfset param = "CEVid=#form.CEVid#&tab=#form.tab#">
<!---======================Eliminar un Evento===================================--->
<cfelseif isdefined('BAJA')>
	<cfinvoke component="sif.Componentes.ControlEventos" method="BAJA_EVENTO">
		<cfinvokeargument name="CEVid" 			value="#form.CEVid#">
	</cfinvoke>
<!---======================Nuevo Envento=========================================--->
<cfelseif isdefined('NUEVO')>
	<cfset param = "Nuevo=true">
<!---===============Guardar los Datos Variables del Evento======================--->
<cfelseif isdefined('AGREGAR_VALOR')>
	<cfset Tipificacion = StructNew()>
	<cfset temp = StructInsert(Tipificacion, "TEV", "#form.TEVid#")> 
	<cfinvoke component="sif.Componentes.DatosVariables" method="GETVALOR" returnvariable="CamposForm">
		<cfinvokeargument name="DVTcodigoValor" value="TEV">
		<cfinvokeargument name="Tipificacion"   value="#Tipificacion#">
		<cfinvokeargument name="DVVidTablaVal"  value="#form.CEVid#">
	</cfinvoke>
	<cfloop query="CamposForm">
		<cfif isdefined('form.#CamposForm.DVTcodigoValor#_#CamposForm.DVid#')>
			<cfset valor = #Evaluate('form.'&CamposForm.DVTcodigoValor&'_'&CamposForm.DVid)#>
		</cfif>
		<cfinvoke component="sif.Componentes.DatosVariables" method="SETVALOR">
			<cfinvokeargument name="DVTcodigoValor" value="TEV">
			<cfinvokeargument name="DVid" 		    value="#CamposForm.DVid#">
			<cfinvokeargument name="DVVidTablaVal"  value="#form.CEVid#">
			<cfinvokeargument name="DVVvalor" 	  	value="#valor#">
		</cfinvoke>
	</cfloop>
	<cfset param = "CEVid=#form.CEVid#&tab=1">
<!---===============Guardar Seguimiento de un Nuevo Estado===============--->
<cfelseif isdefined('AGREGAR_EST')>
	<cfinvoke component="sif.Componentes.ControlEventos" method="ALTA_SEGUIMIENTO">
		<cfinvokeargument name="CEVid" 			value="#form.CEVid#">
		<cfinvokeargument name="TEVECodigo"  	value="#form.TEVECodigo#">
		<cfinvokeargument name="SEVDescripcion" value="#ltrim(rtrim(form.SEVDescripcion))#">
	</cfinvoke>
	<cfset param = "CEVid=#form.CEVid#&tab=2">
<!---==============Guardar un Nuevo Responsables=========================--->
<cfelseif isdefined('AGREGAR_RESP')>
	<cfinvoke component="sif.Componentes.ControlEventos" method="ALTA_RESPONSABLE">
		<cfinvokeargument name="CEVid" 			value="#form.CEVid#">
		<cfinvokeargument name="DEid"  			value="#form.DEid#">
	</cfinvoke>
	<cfset param = "CEVid=#form.CEVid#&tab=3">
<cfelseif isdefined('BAJARESP')>
	<cfinvoke component="sif.Componentes.ControlEventos" method="BAJA_RESPONSABLE">
		<cfinvokeargument name="CEVid" 			value="#form.idEvento#">
		<cfinvokeargument name="DEid"  			value="#form.idEmpleado#">
	</cfinvoke>
	<cfset param = "CEVid=#form.CEVid#&tab=3">
<cfelseif isdefined('idEmpleado')>
	<cfset param = "CEVid=#form.CEVid#&tab=3">
</cfif>

<cflocation url="#form.PaginaInicial#?#param#" addtoken="no">