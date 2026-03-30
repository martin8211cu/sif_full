
<title>
	<cf_translate key="LB_ExpedienteDelConcursante">Expediente del concursante</cf_translate>
</title>
<cf_templatecss>
<cfset form.toconcursantes = ''>

<!--- <link href="/cfmx/sif/css/web_portlet.css" rel="stylesheet" type="text/css">
 --->
<!---*******************************--->
<!---  área de consultas            --->
<!---*******************************--->


<cfif url.tipo eq 'I'>
	<cfquery name="rsconsultaDE" datasource="#session.DSN#">
		select 1
		from DatosEmpleado
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	</cfquery>
<cfelse>
	<cfquery name="rsconsultaDO" datasource="#session.DSN#">
		select 1
		from DatosOferentes
		where RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	</cfquery>
</cfif>

<cfif isdefined("url.DEid") and Len(Trim(url.DEid)) NEQ 0>
	<cfset form.DEid = url.DEid>
</cfif>
<!--- <cfdump var="#rsconsultaDE#">
<cf_dump var="#rsconsultaDO#"> --->

<!---VARIABLES DE TRADUCCION--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Masculino"
	Default="Masculino"
	returnvariable="LB_Masculino"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Femenino"
	Default="Femenino"
	returnvariable="LB_Femenino"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SolteroA"
	Default="Soltero(a)"
	returnvariable="LB_SolteroA"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CasadoA"
	Default="Casado(a)"
	returnvariable="LB_CasadoA"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DivorciadoA"
	Default="Divorciado(a)"
	returnvariable="LB_DivorciadoA"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ViudoA"
	Default="Viudo(a)"
	returnvariable="LB_ViudoA"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_UnionLibre"
	Default="Unión Libre"
	returnvariable="LB_UnionLibre"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SeparadoA"
	Default="Separado(a)"
	returnvariable="LB_SeparadoA"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Ninguno"
	Default="Ninguno"
	returnvariable="LB_Ninguno"/>

<!---*******************************--->
<!---  área de pintado              --->
<!---*******************************--->
<table width="100%" border="0">
	<tr>
		<cfif isdefined("rsconsultaDE") and rsconsultaDE.RecordCount Gt 0>
			<cf_translatedata name="get" tabla="NTipoIdentificacion" col="b.NTIdescripcion" returnvariable="LvarNTIdescripcion">
			<cfquery datasource="#Session.DSN#" name="rsEmpleado">
				select a.DEid,
					   a.Ecodigo,
					   a.Bid,
					   a.NTIcodigo, 
					   a.DEidentificacion, 
					   a.DEnombre, 
					   a.DEapellido1, 
					   a.DEapellido2, 
					   case a.DEsexo when 'M' then '#LB_Masculino#' when 'F' then '#LB_Femenino#' else 'N/D' end as Sexo,
					   a.CBTcodigo, 
					   a.DEcuenta, 
					   a.CBcc, 
					   a.DEdireccion, 
					   case a.DEcivil 
							when 0 then '#LB_SolteroA#' 
							when 1 then '#LB_CasadoA#' 
							when 2 then '#LB_DivorciadoA#' 
							when 3 then '#LB_ViudoA#' 
							when 4 then '#LB_UnionLibre#' 
							when 5 then '#LB_SeparadoA#' 
							else '' 
					   end as EstadoCivil, 
					   a.DEfechanac as FechaNacimiento, 
					   a.DEcantdep, 
					   a.DEobs1, 
					   a.DEobs2, 
					   a.DEobs3, 
					   a.DEdato1, 
					   a.DEdato2, 
					   a.DEdato3, 
					   a.DEdato4, 
					   a.DEdato5, 
					   a.DEinfo1, 
					   a.DEinfo2, 
					   a.DEinfo3, 
					   #Session.Usucodigo# as Usucodigo, 
					   a.Ulocalizacion, 
					   a.DEsistema, 
					   a.ts_rversion,
					   #LvarNTIdescripcion# as NTIdescripcion,
					   c.Mnombre,
					   coalesce(d.Bdescripcion, '#LB_Ninguno#') as Bdescripcion
				from DatosEmpleado a
				
				inner join NTipoIdentificacion b
				on a.NTIcodigo = b.NTIcodigo	
				and b.Ecodigo = #Session.Ecodigo#			
			
				inner join Monedas c
				on a.Mcodigo = c.Mcodigo
				
				left outer join Bancos d
				on a.Ecodigo = d.Ecodigo
				  and a.Bid = d.Bid
			
				where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
			</cfquery>
			<td><cfinclude template="../../Reclutamiento/consultas/expediente-Empleado.cfm"></td>
		<cfelseif isdefined("rsconsultaDO") and rsconsultaDO.RecordCount Gt 0>
			<cf_translatedata name="get" tabla="NTipoIdentificacion" col="b.NTIdescripcion" returnvariable="LvarNTIdescripcion">
			<cfquery datasource="#Session.DSN#" name="rsOferente">
				select a.RHOid,
					   a.Ecodigo,
					   a.NTIcodigo, 
					   a.RHOidentificacion, 
					   a.RHOnombre, 
					   a.RHOapellido1, 
					   a.RHOapellido2, 
					   case a.RHOsexo when 'M' then '#LB_Masculino#' when 'F' then '#LB_Femenino#' else 'N/D' end as Sexo,
					   a.RHOdireccion, 
					   case a.RHOcivil 
							when 0 then '#LB_SolteroA#' 
							when 1 then '#LB_CasadoA#' 
							when 2 then '#LB_DivorciadoA#' 
							when 3 then '#LB_ViudoA#' 
							when 4 then '#LB_UnionLibre#' 
							when 5 then '#LB_SeparadoA#' 
							else '' 
					   end as EstadoCivil, 
					   a.RHOfechanac as FechaNacimiento, 
					   a.RHOobs1, 
					   a.RHOobs2, 
					   a.RHOobs3, 
					   a.RHOdato1, 
					   a.RHOdato2, 
					   a.RHOdato3, 
					   a.RHOdato4, 
					   a.RHOdato5, 
					   a.RHOinfo1, 
					   a.RHOinfo2, 
					   a.RHOinfo3, 
					   #Session.Usucodigo# as Usucodigo,
					   a.ts_rversion,
					   #LvarNTIdescripcion# as NTIdescripcion,
					   a.id_direccion
				from DatosOferentes a inner join NTipoIdentificacion b
				  on a.NTIcodigo = b.NTIcodigo	
				  and b.Ecodigo = #Session.Ecodigo#		
				where a.RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
			</cfquery>
			<td><cfinclude template="../../Reclutamiento/consultas/expediente-OferenteExt.cfm"></td>
		</cfif>
	</tr>
</table>



<!---****************************************************************************--->
<!--- Para esta funcionalidad fue necesario modificar los siguientes archivos    --->
<!--- frame-deducciones.cfm,formDetalleDeducciones.cfm,expediente-globalcons.cfm --->
<!---****************************************************************************--->



