<cfparam name="request.calledFromSQL" default="true">
<cfinclude template="aftfHojasCoteo-common.cfm">
<cfset params="">
<cfif isdefined("Form.AFTFid_hoja") and len(trim(Form.AFTFid_hoja)) gt 0>
	<cfset params=ListAppend(params,"AFTFid_hoja="&Form.AFTFid_hoja,"&")>
</cfif>
<cfset Request.Error.URL="aftfHojasCoteo.cfm?#Gvar_navegacion_Lista1#&#Gvar_navegacion_Lista2#&#params#">
<cfset params="">
<cfif isdefined("Form.Alta")>
	<cfinvoke component="sif.af.tomaFisica.componentes.aftfHojasConteo" 
			method="insertHojaConteo" returnvariable="resAFTFid_hoja">
		<cfinvokeargument name="AFTFdescripcion_hoja" value="#Form.AFTFdescripcion_hoja#">
		<cfinvokeargument name="AFTFid_dispositivo" value="#Form.AFTFid_dispositivo#">
		<cfinvokeargument name="DEid" value="#Form.DEid#">
		<cfinvokeargument name="AFTFfecha_hoja" value="#Form.AFTFfecha_hoja#">
		<cfinvokeargument name="AFTFresponsable_hoja" value="#Form.AFTFresponsable_hoja#">
	</cfinvoke>
	<cfset Form.Pagina = 1>
	<cfset params=ListAppend(params,"AFTFid_hoja="&resAFTFid_hoja,"&")>
<cfelseif isdefined("Form.Cambio")>
	<cf_dbtimestamp 
		table="AFTFHojaConteo"
		redirect="aftfHojasCoteo.cfm"
		timestamp="#form.ts_rversion#"				
		field1="AFTFid_hoja,numeric,#Form.AFTFid_hoja#">
	<cfinvoke component="sif.af.tomaFisica.componentes.aftfHojasConteo" 
			method="updateHojaConteo">
		<cfinvokeargument name="AFTFid_hoja" value="#Form.AFTFid_hoja#">
		<cfinvokeargument name="AFTFdescripcion_hoja" value="#Form.AFTFdescripcion_hoja#">
		<cfinvokeargument name="AFTFid_dispositivo" value="#Form.AFTFid_dispositivo#">
		<cfinvokeargument name="DEid" value="#Form.DEid#">
		<cfinvokeargument name="AFTFfecha_hoja" value="#Form.AFTFfecha_hoja#">
		<cfinvokeargument name="AFTFresponsable_hoja" value="#Form.AFTFresponsable_hoja#">
	</cfinvoke>
	<cfset params=ListAppend(params,"AFTFid_hoja="&Form.AFTFid_hoja,"&")>
<cfelseif isdefined("Form.Baja")>
    <cfinvoke component="sif.af.tomaFisica.componentes.aftfHojasConteo" 
			method="deleteHojaConteo">
		<cfinvokeargument name="AFTFid_hoja" value="#Form.AFTFid_hoja#">
	</cfinvoke>
<cfelseif isdefined("Form.BtnEliminar") and isdefined("Form.Chk") and len(trim(Form.Chk)) gt 0>
    <cfinvoke component="sif.af.tomaFisica.componentes.aftfHojasConteo" 
			method="deleteHojaConteo">
		<cfinvokeargument name="AFTFid_hoja" value="#Form.Chk#">
	</cfinvoke>
<cfelseif isdefined("Form.BtnAplicar") or isdefined("Form.Aplicar")>
    <cfinvoke component="sif.af.tomaFisica.componentes.aftfHojasConteo" 
			method="aplicarHojaConteo" returnvariable="rsAplicado">
		<cfinvokeargument name="AFTFid_hoja" value="#Form.AFTFid_hoja#">
	</cfinvoke>
	<cfif rsAplicado.AFTFestatus_hoja LT 3>
		<cfset params=ListAppend(params,"AFTFid_hoja="&Form.AFTFid_hoja,"&")>
	</cfif>
<cfelseif isdefined("Form.BtnCancelar") or isdefined("Form.Cancelar")>
    <cfinvoke component="sif.af.tomaFisica.componentes.aftfHojasConteo" 
			method="cancelarHojaConteo">
		<cfinvokeargument name="AFTFid_hoja" value="#Form.AFTFid_hoja#">
	</cfinvoke>
<cfelseif isdefined("Form.btnGenerar")>
	<cfinvoke component="sif.af.tomaFisica.componentes.aftfHojasConteo" 
			method="insertDHojaConteoWFilters">
		<cfinvokeargument name="AFTFid_hoja" value="#Form.AFTFid_hoja#">
		<cfinvokeargument name="Aid" value="#Form.Aid#">
		<cfinvokeargument name="AFCcodigo" value="#Form.AFCcodigo#">
		<cfinvokeargument name="CFid" value="#Form.CFid#">
		<cfinvokeargument name="Ocodigo" value="#Form.Ocodigo#">
		<cfinvokeargument name="ACcodigo" value="#Form.ACcodigo#">
		<cfinvokeargument name="ACid" value="#Form.ACid#">
		<cfinvokeargument name="DEid" value="#Form.DEid#">
	</cfinvoke>
	<cfset params=ListAppend(params,"AFTFid_hoja="&Form.AFTFid_hoja,"&")>
<cfelseif isdefined("Form.btnEliminar_Activos") and isdefined("Form.Chk") and len(trim(Form.Chk)) gt 0>
    <cfinvoke component="sif.af.tomaFisica.componentes.aftfHojasConteo" 
			method="deleteDHojaConteo">
		<cfinvokeargument name="AFTFid_hoja" value="#Form.AFTFid_hoja#">
		<cfinvokeargument name="AFTFid_detallehoja" value="#Form.Chk#">
	</cfinvoke>
	<cfset params=ListAppend(params,"AFTFid_hoja="&Form.AFTFid_hoja,"&")>
<cfelseif isdefined("Form.btnEliminar_Todos")>
    <cfinvoke component="sif.af.tomaFisica.componentes.aftfHojasConteo" 
			method="deleteDHojaConteo">
		<cfinvokeargument name="AFTFid_hoja" value="#Form.AFTFid_hoja#">
	</cfinvoke>
	<cfset params=ListAppend(params,"AFTFid_hoja="&Form.AFTFid_hoja,"&")>
<cfelseif isdefined("Form.btnNormal") and isdefined("Form.Chk") and len(trim(Form.Chk)) gt 0>
    <cfinvoke component="sif.af.tomaFisica.componentes.aftfHojasConteo" 
			method="updatebDHojaConteo"><!--- Ojo que se utiliza el updateb porque este verifica el estado 4 --->
		<cfinvokeargument name="AFTFid_hoja" value="#Form.AFTFid_hoja#">
		<cfinvokeargument name="AFTFid_detallehoja" value="#Form.Chk#">
		<cfinvokeargument name="AFTFbanderaproceso" value="1">
	</cfinvoke>
	<cfset params=ListAppend(params,"AFTFid_hoja="&Form.AFTFid_hoja,"&")>
<cfelseif isdefined("Form.btnNo_Contado") and isdefined("Form.Chk") and len(trim(Form.Chk)) gt 0>
    <cfinvoke component="sif.af.tomaFisica.componentes.aftfHojasConteo" 
			method="updatebDHojaConteo"><!--- Ojo que se utiliza el updateb porque este verifica el estado 4 --->
		<cfinvokeargument name="AFTFid_hoja" value="#Form.AFTFid_hoja#">
		<cfinvokeargument name="AFTFid_detallehoja" value="#Form.Chk#">
		<cfinvokeargument name="AFTFbanderaproceso" value="2">
	</cfinvoke>
	<cfset params=ListAppend(params,"AFTFid_hoja="&Form.AFTFid_hoja,"&")>
<cfelseif isdefined("Form.btnContado") and isdefined("Form.Chk") and len(trim(Form.Chk)) gt 0>
    <cfinvoke component="sif.af.tomaFisica.componentes.aftfHojasConteo" 
			method="updatebDHojaConteo"><!--- Ojo que se utiliza el updateb porque este verifica el estado 4 --->
		<cfinvokeargument name="AFTFid_hoja" value="#Form.AFTFid_hoja#">
		<cfinvokeargument name="AFTFid_detallehoja" value="#Form.Chk#">
		<cfinvokeargument name="AFTFbanderaproceso" value="3">
	</cfinvoke>
	<cfset params=ListAppend(params,"AFTFid_hoja="&Form.AFTFid_hoja,"&")>
<cfelseif isdefined("Form.AltaDet")>
	<cfinvoke component="sif.af.tomaFisica.componentes.aftfHojasConteo" 
			method="insertDHojaConteo" returnvariable="resAFTFid_detallehoja">
		<cfinvokeargument name="AFTFid_hoja" value="#Form.AFTFid_hoja#">
		
		<cfif isdefined("Form.Aid") and len(trim(Form.Aid)) gt 0>
			<cfinvokeargument name="Aid" value="#Form.Aid#">
		</cfif>
		
		<cfinvokeargument name="AFMid" value="#Form.AFMid#">
		<cfinvokeargument name="AFMMid" value="#Form.AFMMid#">
		<cfinvokeargument name="ACcodigo" value="#Form.ACcodigo#">
		<cfinvokeargument name="ACid" value="#Form.ACid#">
		
		<cfinvokeargument name="AFCcodigo" value="#Form.AFCcodigo#">
		<cfinvokeargument name="CFid" value="#Form.CFid#">
		<cfinvokeargument name="DEid" value="#Form.DEid#">
		<cfif isdefined("Form.CFid_lectura") and len(trim(Form.CFid_lectura)) gt 0>
			<cfinvokeargument name="CFid_lectura" value="#Form.CFid_lectura#">
		</cfif>
		<cfif isdefined("Form.DEid_lectura") and len(trim(Form.DEid_lectura)) gt 0>
			<cfinvokeargument name="DEid_lectura" value="#Form.DEid_lectura#">
		</cfif>
		<cfif isdefined("Form.Aplaca") and len(trim(Form.Aplaca)) gt 0>
			<cfinvokeargument name="Aplaca" value="#Form.Aplaca#">
		</cfif>
		
		<cfif isdefined("Form.Aserie") and len(trim(Form.Aserie)) gt 0>
			<cfinvokeargument name="Aserie" value="#Form.Aserie#">
		</cfif>
		<cfinvokeargument name="Adescripcion" value="#Form.Adescripcion#">
		<cfinvokeargument name="Avutil" value="#Form.Avutil#">
		<cfinvokeargument name="Avalrescate" value="#Form.Avalrescate#">
		
		<cfif isdefined("Form.AFTFobservaciondetalle") and len(trim(Form.AFTFobservaciondetalle)) gt 0>
			<cfinvokeargument name="AFTFobservaciondetalle" value="#Form.AFTFobservaciondetalle#">
		</cfif>
	
	</cfinvoke>
	<cfset params=ListAppend(params,"AFTFid_detallehoja="&resAFTFid_detallehoja,"&")>
	<cfset params=ListAppend(params,"AFTFid_hoja="&Form.AFTFid_hoja,"&")>
<cfelseif isdefined("Form.CambioDet")>
	<cfinvoke component="sif.af.tomaFisica.componentes.aftfHojasConteo" 
			method="updateDHojaConteo" returnvariable="resAFTFid_detallehoja">
		<cfinvokeargument name="AFTFid_hoja" value="#Form.AFTFid_hoja#">
		<cfinvokeargument name="AFTFid_detallehoja" value="#Form.AFTFid_detallehoja#">
		
		<cfif isdefined("Form.Aid") and len(trim(Form.Aid)) gt 0>
			<cfinvokeargument name="Aid" value="#Form.Aid#">
		</cfif>
		
		<cfinvokeargument name="AFMid" value="#Form.AFMid#">
		<cfinvokeargument name="AFMMid" value="#Form.AFMMid#">
		<cfinvokeargument name="ACcodigo" value="#Form.ACcodigo#">
		<cfinvokeargument name="ACid" value="#Form.ACid#">
		
		<cfinvokeargument name="AFCcodigo" value="#Form.AFCcodigo#">
		<cfinvokeargument name="CFid" value="#Form.CFid#">
		<cfinvokeargument name="DEid" value="#Form.DEid#">
		<cfif isdefined("Form.CFid_lectura") and len(trim(Form.CFid_lectura)) gt 0>
			<cfinvokeargument name="CFid_lectura" value="#Form.CFid_lectura#">
		</cfif>
		<cfif isdefined("Form.DEid_lectura") and len(trim(Form.DEid_lectura)) gt 0>
			<cfinvokeargument name="DEid_lectura" value="#Form.DEid_lectura#">
		</cfif>
		<cfinvokeargument name="Aplaca" value="#Form.Aplaca#">
		
		<cfif isdefined("Form.Aserie") and len(trim(Form.Aserie)) gt 0>
			<cfinvokeargument name="Aserie" value="#Form.Aserie#">
		</cfif>
		<cfinvokeargument name="Adescripcion" value="#Form.Adescripcion#">
		<cfinvokeargument name="Avutil" value="#Form.Avutil#">
		<cfinvokeargument name="Avalrescate" value="#Form.Avalrescate#">
		
		<cfif isdefined("Form.AFTFobservaciondetalle") and len(trim(Form.AFTFobservaciondetalle)) gt 0>
			<cfinvokeargument name="AFTFobservaciondetalle" value="#Form.AFTFobservaciondetalle#">
		</cfif>
	
	</cfinvoke>
	<cfset params=ListAppend(params,"AFTFid_detallehoja="&Form.AFTFid_detallehoja,"&")>
	<cfset params=ListAppend(params,"AFTFid_hoja="&Form.AFTFid_hoja,"&")>
<cfelseif isdefined("Form.BajaDet")>
	<cfinvoke component="sif.af.tomaFisica.componentes.aftfHojasConteo" 
			method="deleteDHojaConteo">
		<cfinvokeargument name="AFTFid_hoja" value="#Form.AFTFid_hoja#">
		<cfinvokeargument name="AFTFid_detallehoja" value="#Form.AFTFid_detallehoja#">
	</cfinvoke>
	<cfset params=ListAppend(params,"AFTFid_hoja="&Form.AFTFid_hoja,"&")>
</cfif>

<cflocation url="aftfHojasCoteo.cfm?#Gvar_navegacion_Lista1#&#Gvar_navegacion_Lista2#&#params#">