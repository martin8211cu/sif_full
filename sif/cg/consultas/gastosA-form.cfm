	<cfinvoke returnvariable="datos1" component="sif.Componentes.CG_EstadoResultadosAR" method="estadoResultados" 
		Ecodigo="#Session.Ecodigo#"
		periodo="#Form.periodo#"
		mes="#Form.mes#"
		nivel = "#form.Nivel#"
		CGARepid="#form.CGARepid#"
		CGARid="#form.CGARid#"
		moneda="#form.moneda#" >
	</cfinvoke>
	<cfquery name="datos" dbtype="query">
		select *
		from datos1
		where descrip is not null
	</cfquery>

	<cfif isdefined("form.CGARid") and len(trim(CGARid))>
		<cfquery name="area" datasource="#session.DSN#">
			select CGARdescripcion as descripcion
			from CGAreaResponsabilidad
			where CGARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGARid#">
		</cfquery>
	</cfif>


<cfif isDefined("form.toExcel") and datos1.recordcount lt 20000 >
	<cfcontent type="application/vnd.ms-excel">
	<cfheader 	name="Content-Disposition" 
			value="attachment;filename=estadoRAG#session.Usucodigo#_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls" >
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
</cfif>

<cfinclude template="gastosA-formInc.cfm">