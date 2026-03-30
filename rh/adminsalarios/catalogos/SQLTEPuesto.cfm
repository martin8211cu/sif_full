<cfif not isdefined("Form.Nuevo")>
	<cfquery name="rsCodPuesto" datasource="sifpublica">
		select EPid,a.EEid,EPcodigo,EPdescripcion
		from EncuestaPuesto a 
				inner join EncuestaEmpresa b
					on a.EEid = b.EEid		
		where a.EEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">
			<cfif isdefined('Form.Cambio')>
				and EPcodigo not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EPcodigoCambio#">)
				and EPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EPcodigo#">
			<cfelseif isdefined('Form.Alta')>
				and EPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EPcodigo#">
			</cfif>
	</cfquery>
	
	<cfif isdefined("rsCodPuesto") and rsCodPuesto.recordCount GT 0 and not isdefined("Form.Baja")>
		<cfthrow message="Error, el c&oacute;digo que digit&oacute; ya existe">
	<cfelse>
		<cfif isdefined("Form.Alta")>
			<cfquery name="Puesto" datasource="sifpublica">
				insert into EncuestaPuesto (EEid, EPcodigo, EPdescripcion, EAid, BMfechaalta, BMUsucodigo)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EPcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EPdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EAid#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				)
			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="Area" datasource="sifpublica">
				update EncuestaPuesto set 
					EEid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EEid#">, 
					EPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EPcodigo#">, 
					EPdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EPdescripcion#">,
					EAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EAid#">
				where EPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPid#">
			</cfquery>
			<cfset modo="CAMBIO">		
		</cfif>
	</cfif>

	<cfif isdefined("Form.Baja")>			
		<cfquery name="Area" datasource="sifpublica">
			delete from EncuestaPuesto
			where EPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPid#">
		</cfquery>
		<cfset modo="BAJA">			
	</cfif>
</cfif>

<form action="TEncuestadoras.cfm" method="post" name="sql">
	<cfoutput>
		<input name="EEid" type="hidden" value="#form.EEid#"> 
		<input name="tab" type="hidden" value="3"> 
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<cfif isdefined("Form.EPid") and not isDefined("Form.Baja") and not isDefined("Form.Nuevo")>
			<input name="EPid" type="hidden" value="#Form.EPid#">
		</cfif>
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
	</cfoutput>
</form>

<html>
	<head>
	</head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>