<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>
<cfset modo = "ALTA">

<cfif not isdefined("Form.paso")>
	<cfparam name="Form.paso" default="1">
</cfif>

<cfif isdefined("Form.RHASid") and Len(Trim(Form.RHASid))>
	<cfset modo = "CAMBIO">
</cfif>

<cfif Form.paso EQ 0>
	<cfset titulo = "Lista de Reportes">
<cfelseif Form.paso EQ 1>
	<cfset titulo = "Seleccionar Encuesta">
<cfelseif Form.paso EQ 2>
	<cfset titulo = "Asignar Puestos">
<cfelseif Form.paso EQ 3>
	<cfset titulo = "Generar Reporte">
<cfelse>
	<cfset titulo = "">
</cfif>

<cfif modo EQ "CAMBIO">
	<cfquery name="rsDatosASalarial" datasource="#Session.DSN#">
		select  a.RHASid, a.Ecodigo, a.EEid, a.ETid, a.Eid, a.Mcodigo, a.NoSalario, a.RHASdescripcion, 
				a.RHASref, a.HYERVid, a.ESid, a.RHASporcentaje, a.BMUsucodigo, 
				b.EEnombre, c.ETdescripcion, d.Edescripcion, e.Mnombre, 
				<!--- f.HYERVid, f.HYERVdescripcion,  --->
				g.ESid, g.EScodigo, g.ESdescripcion, rtrim(g.EScodigo) || ' ' || g.ESdescripcion as EscalaSalarial
		from RHASalarial a
			inner join EncuestaEmpresa b
				on b.EEid = a.EEid
			inner join EmpresaOrganizacion c
				on c.ETid = a.ETid
			inner join Encuesta d
				on d.Eid = a.Eid
			inner join Monedas e
				on e.Mcodigo = a.Mcodigo
<!--- 			inner join HYERelacionValoracion f
				on f.HYERVid = a.HYERVid
 --->			inner join RHEscalaSalHAY g
				on g.ESid = a.ESid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
	</cfquery>
</cfif>

<style type="text/css">
	input.botonUp2 {font-family: Tahoma, sans-serif; font-size: 8pt; border:1px solid gray}
</style>

<script language="javascript" type="text/javascript">
	function funcAnterior(f, pasoActual) {
		f.paso.value = pasoActual - 1;
	}
	
	function funcSiguiente(f, pasoActual) {
		f.paso.value = pasoActual + 1;
	}
</script>
