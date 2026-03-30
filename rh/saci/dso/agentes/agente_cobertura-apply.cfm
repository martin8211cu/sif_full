<cfinclude template="agente-params.cfm">

<!--- 

Select *
from LocalidadCubo
where LCidPadre=10100
--	and LCnivel = 1
order by LCnivel



select *
from Localidad 
where LCid=10101
and DPnivel = 3

 --->
<cfif isdefined("form.Guardar")>
	<cfquery name="rsNiveles" datasource="#session.DSN#">
		select coalesce(max(DPnivel), 0) as maxNivel
		from DivisionPolitica
		where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.pais#">
	</cfquery>

	<cfif isdefined('rsNiveles') and rsNiveles.recordCount GT 0>
		<!--- Encuentra la ultima localidad seleccionada del mantenimiento --->
		<cfloop index = "LoopCount" 
			from = "#rsNiveles.maxNivel#" 
			to = "1" 
			step = "-1">
				<cfif Evaluate("isdefined('form.LCid_#LoopCount#') and form.LCid_#LoopCount# NEQ ''")>
					<cfbreak>
				</cfif>
		</cfloop>
		
		<cfif isdefined("form.LCid_#LoopCount#")>
			<cfset form.LCid = Evaluate("form.LCid_#LoopCount#")>
		<cfelse>
			<cfset form.LCid = "0">
		</cfif>
		<cfif not isdefined('form.Habilitado')>
			<cfset form.Habilitado = 0>
		</cfif>
			
		<cfinvoke component="saci.comp.ISBagenteCobertura"
			method="AltaMasivo" 
			AGid="#form.AGid#"
			LCid="#form.LCid#"
			Habilitado="#form.Habilitado#"
			nivelMax="#rsNiveles.maxNivel#"
		/>		
	</cfif>
<cfelseif isdefined("form.Baja") and Form.Baja EQ 1>
	<cfquery name="rsHayProsp" datasource="#session.DSN#">
		select 1
		from ISBagenteCobertura a
			inner join Localidad b
				on b.LCid = a.LCid
			inner join ISBprospectos pr
				on pr.AGid=a.AGid
					and pr.LCid=a.LCid
					and pr.Pprospectacion='A'
		where a.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGid#">
	</cfquery>
	
	<cfif isdefined('rsHayProsp') and rsHayProsp.recordCount GT 0>
		<cfthrow message="Error, no se permite borrar la cobertura del agente, ya existen prospectos asignados.">
	<cfelse>
		<cfinvoke component="saci.comp.ISBagenteCobertura"
			method="Baja" 
			AGid="#form.AGid#"
			LCid="#form.LCid#"
		/>
	</cfif>
<cfelseif isdefined("form.Cambio") and Form.Cambio EQ 1>
	<cfinvoke component="saci.comp.ISBagenteCobertura"
		method="Cambio" 
		AGid="#form.AGid#"
		LCid="#form.LCid#"
		Habilitado="#form.Habilitado#"
	/>
</cfif>

<cfinclude template="agente-redirect.cfm">
