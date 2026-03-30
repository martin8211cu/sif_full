<cfif not isdefined('form.btnModificar') and isdefined('url.btnModificar')>
	<cfset form.btnModificar = url.btnModificar>
</cfif>
<cfif not isdefined('form.btnCargar_Articulos') and isdefined('url.btnCargar_Articulos')>
	<cfset form.btnCargar_Articulos = url.btnCargar_Articulos>
</cfif>
<cfif not isdefined('form.btnCalcular_Precios') and isdefined('url.btnCalcular_Precios')>
	<cfset form.btnCalcular_Precios = url.btnCalcular_Precios>
</cfif>
<cfif not isdefined('form.Aid') and isdefined('url.Aid')>
	<cfset form.Aid= url.Aid>
</cfif>
<cfif not isdefined('form.CPPid') and isdefined('url.CPPid')>
	<cfset form.CPPid= url.CPPid>
</cfif>
<cfif not isdefined('form.value') and isdefined('url.value')>
	<cfset form.value= url.value>
</cfif>
<cfif isdefined('form.btnModificar')>
	<cfquery datasource="#session.dsn#">
		update FPPreciosArticulo set FPPAPrecio = #form.Value#
		where Aid = #form.Aid#
		and CPPid = #form.CPPid#
	</cfquery>
<cfelseif isdefined('form.btnCargar_Articulos')>
	<cfquery datasource="#session.DSN#">
		insert into FPPreciosArticulo (Ecodigo,CPPid,Aid,FPPAPrecio,BMUsucodigo)
		select a.Ecodigo, #form.CPPid#, a.Aid, 0.00, #session.Usucodigo# 
		 from Articulos a
		where a.Ecodigo = #session.Ecodigo#
		 and (select count(1) from FPPreciosArticulo b where b.Ecodigo = a.Ecodigo and  b.CPPid = #form.CPPid# and b.Aid = a.Aid) = 0
	</cfquery>
<cfelseif isdefined('form.btnCalcular_Precios')>
	<cfquery datasource="#session.DSN#" name="promedio">
		select a.Aid, case when sum(a.Ecostou)/count(1) < 0 then 0.00 else  sum(a.Ecostou)/ count(1) end as value
			from Existencias a 
				inner join FPPreciosArticulo b
					on a.Aid = b.Aid
		where b.CPPid = #form.CPPid#
		group by a.Aid
	</cfquery>
	<cfloop query="promedio">
		<cfquery datasource="#session.DSN#">
			update FPPreciosArticulo 
				set FPPAPrecio = #promedio.value#
			where Ecodigo = #session.Ecodigo#
			 and CPPid    = #form.CPPid#
			 and Aid      = #promedio.Aid#
		</cfquery>
	</cfloop>
</cfif>
<cfoutput>
<cflocation url="EstimacionPrecio.cfm?CPPid=#form.CPPid#" addtoken="no">
</cfoutput>