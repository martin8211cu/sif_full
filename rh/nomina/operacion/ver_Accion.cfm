<title>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Acciones"
		Default="cciones"
		returnvariable="Titulo"/>
		<cfoutput>#Titulo#</cfoutput>
</title>

<cfif isdefined("url.DEid") and len(trim(url.DEid)) gt 0 and not isdefined("form.DEid")  >
	<cfset form.DEid = url.DEid>
</cfif>
<cfif isdefined("url.DLlinea") and len(trim(url.DLlinea)) gt 0 and not isdefined("form.DLlinea")  >
	<cfset form.DLlinea = url.DLlinea>
</cfif>
<cfif isdefined("url.RAP") and len(trim(url.RAP)) gt 0 and not isdefined("form.RAP")  >
	<cfset form.RAP = url.RAP>
</cfif>

<cfif  not isdefined("Session.cache_empresarial")>
	<cfset Session.cache_empresarial = 0>
</cfif>
<cfif  not isdefined("Session.Params.ModoDespliegue")>
	<cfset Session.Params.ModoDespliegue = 1>
</cfif>
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">


<cfquery datasource="#Session.DSN#" name="rsEmpleado">
	select a.DEid,
		   a.Ecodigo,
		   a.Bid,
		   a.NTIcodigo, 
		   a.DEidentificacion, 
		   a.DEnombre, 
		   a.DEapellido1, 
		   a.DEapellido2, 
		   case a.DEsexo when 'M' then '<cf_translate key="LB_Masculino">Masculino</cf_translate>' 
						 when 'F' then '<cf_translate key="LB_Femenino">Femenino</cf_translate>' 
						 else 'N/D' 
		   end as Sexo,
		   a.CBTcodigo, 
		   a.DEcuenta, 
		   a.CBcc, 
		   a.DEdireccion, 
		   case a.DEcivil 
				when 0 then '<cf_translate key="LB_Soltero">Soltero(a)</cf_translate>' 
				when 1 then '<cf_translate key="LB_Casado">Casado(a)</cf_translate>' 
				when 2 then '<cf_translate key="LB_Divorciado">Divorciado(a)</cf_translate>' 
				when 3 then '<cf_translate key="LB_Viudo">Viudo(a)</cf_translate>' 
				when 4 then '<cf_translate key="LB_UnionLibre">Unión Libre</cf_translate>' 
				when 5 then '<cf_translate key="LB_Separado">Separado(a)</cf_translate>' 
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
		   a.Ulocalizacion, 
		   a.DEsistema, 
		   a.ts_rversion,
		   b.NTIdescripcion,
		   c.Mnombre,
		   coalesce(d.Bdescripcion, '<cf_translate key="LB_Ninguno">Ninguno</cf_translate>') as Bdescripcion	
	from DatosEmpleado a
		inner join NTipoIdentificacion b
			on a.NTIcodigo = b.NTIcodigo				
		inner join Monedas c
			on a.Mcodigo = c.Mcodigo
		left outer join Bancos d
			on a.Ecodigo = d.Ecodigo
			and a.Bid = d.Bid
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
</cfquery>
<table width="100%" cellpadding="3" cellspacing="0">
	<tr> 
	  <td>
	  	<cfinclude template="../../expediente/consultas/frame-infoEmpleado.cfm">
	  </td>
	</tr>
	<tr> 
	  <td class="<cfoutput>#Session.preferences.Skin#_thcenter</cfoutput>"><cf_translate key="LB_Accion">Acci&oacute;n</cf_translate></td>
	</tr>	
	<tr> 
	  <td>
        <cfinclude template="../../expediente/consultas/frame-detalleAcciones.cfm">
	  </td>
	</tr>	

</table>


