<cfsetting requesttimeout="43200">

<cfif not isdefined("url.inter")  and not isdefined("form.inter")>
 	<cfset inter = 'N'>
</cfif>
<cfif isdefined("url.inter") and not isdefined("form.inter")>
 	<cfset inter = url.inter>
</cfif>
<cfif not isdefined("url.inter") and  isdefined("form.inter")>
 	<cfset inter = form.inter>
</cfif>

<cfif isdefined("form.chk") and len(trim(form.chk))>
	<cfset ListaAplicar = form.chk >
	<cfset msgAplicar = 'No tiene permisos para aplicar la p&oacute;liza'>
	<cfloop list="#ListaAplicar#" index="IDcontable">
		<!--- Verificar el permiso antes de aplicar el asiento --->
		<cfquery name="chkPermiso" datasource="#Session.DSN#">
			select 1
			from EContables a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
			and ( not exists ( 
					select 1 from UsuarioConceptoContableE b 
					where a.Cconcepto = b.Cconcepto
					and a.Ecodigo = b.Ecodigo
				) or exists (
					select 1
					from ConceptoContableE b, UsuarioConceptoContableE c
					where a.Cconcepto = b.Cconcepto
					and a.Ecodigo = b.Ecodigo
					and b.Cconcepto = c.Cconcepto
					and b.Ecodigo = c.Ecodigo
					and c.Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">
					and c.UCCpermiso in (8,9,10,11,12,13,14,15)
				)
			)
		</cfquery>
	
		<!--- Si tiene permisos entonces puede aplicar el asiento --->
		<cfif chkPermiso.recordCount GT 0>
			<!--- Aplicación del Asiento --->
			<cfinvoke 
			 component="sif.Componentes.CG_AplicaAsiento"
			 method="CG_AplicaAsiento">
				 <cfinvokeargument name="IDcontable" value="#IDcontable#">
				 <cfinvokeargument name="CtlTransaccion" value="true">
				 <cfinvokeargument name="inter" value="#inter#">
			</cfinvoke>
		<cfelse>
			<cfthrow message="#msgAplicar#">
		</cfif>
	</cfloop>
</cfif>

<cflocation addtoken="no" url="listaDocumentosContablesMasiva.cfm">


