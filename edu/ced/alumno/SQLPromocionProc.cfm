<cfif isdefined("form.btnAplicar")>
	<cfloop list="#form.chk#" index="i">
		<cfquery name="rsExists" datasource="#Session.Edu.Dsn#">
			select 1
			from Grado sigg
				inner join Grado g
					on g.Gpromogrado = sigg.Gcodigo
				inner join Promocion pr 
					on pr.Gcodigo = g.Gcodigo
			where pr.PRcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
		</cfquery>
		<cfif rsExists.recordcount eq 0>
			<cfquery name="rsAplicar" datasource="#Session.Edu.Dsn#">
				update Promocion
					set PRactivo = 0
				where PRcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			</cfquery>
			<cfquery name="rsAplicar" datasource="#Session.Edu.Dsn#">
				update Alumnos 
					set Aretirado = 2
				where PRcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
					and Aretirado = 0
			</cfquery>
			<cfquery name="rsAplicar" datasource="#Session.Edu.Dsn#">
				insert AlumnoRetirado (CEcodigo, Ecodigo, ARfecha, PRcodigo, SPEcodigo, PEcodigo , Gcodigo , Ncodigo , ARalta)
				select a.CEcodigo, a.Ecodigo, getdate(), p.PRcodigo,  p.SPEcodigo, p.PEcodigo, p.Gcodigo , p.Ncodigo, 2
				from Promocion p
					inner join Alumnos a
					on a.PRcodigo = p.PRcodigo
				where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				  and p.PRcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			</cfquery>
		<cfelse>
			<cfquery name="rsAplicar" datasource="#Session.Edu.Dsn#">
				update Promocion
				set pr.PEcodigo = pv.PEcodigo,
					pr.SPEcodigo = pv.SPEcodigo,
					pr.Ncodigo = g.Gpromonivel,
					pr.Gcodigo = g.Gpromogrado
				from Promocion pr
					inner join Grado g
						on g.Gcodigo = pr.Gcodigo
					inner join PeriodoVigente pv
						on pv.Ncodigo = g.Gpromonivel
				where pr.PRcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			</cfquery>
		</cfif>
	</cfloop>			
</cfif>
<cfparam name="form.Filtro_Promocion" default="">
<cfparam name="form.Filtro_Nivel" default="">
<cfparam name="form.Filtro_Grado" default="">
<cfparam name="form.Filtro_NivelProx" default="">
<cfparam name="form.Filtro_GradoProx" default="">
<cfset param = "">
<cfset param = param & "&Filtro_Promocion="&form.Filtro_Promocion>
<cfset param = param & "&HFiltro_Promocion="&form.Filtro_Promocion>
<cfset param = param & "&Filtro_Nivel="&form.Filtro_Nivel>
<cfset param = param & "&HFiltro_Nivel="&form.Filtro_Nivel>
<cfset param = param & "&Filtro_Grado="&form.Filtro_Grado>
<cfset param = param & "&HFiltro_Grado="&form.Filtro_Grado>
<cfset param = param & "&Filtro_NivelProx="&form.Filtro_NivelProx>
<cfset param = param & "&HFiltro_NivelProx="&form.Filtro_NivelProx>
<cfset param = param & "&Filtro_GradoProx="&form.Filtro_GradoProx>
<cfset param = param & "&HFiltro_GradoProx="&form.Filtro_GradoProx>
<cflocation url="PromocionProc.cfm?sql=1#param#">