<cfif isdefined("url.empresa")>
	<cfparam name="Form.Empresas" default="#Url.Empresa#">
</cfif>

<cfif isdefined("url.DEidentificacion") and len(trim(url.DEidentificacion)) and isdefined("url.pd_acciondesde") and len(trim(url.pd_acciondesde)) >
	<cfquery name="rsEmpleado" datasource="#session.DSN#">
		select a.DEid, a.DEidentificacion,
			{fn concat({fn concat({fn concat({ fn concat(a.DEapellido1 , ' ') },a.DEapellido2)}, ' ')},a.DEnombre) } as NombreCompleto
		from DatosEmpleado a
			inner join LineaTiempo b
				on a.DEid = b.DEid
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.pd_acciondesde)#"> <= b.LThasta
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.pd_accionhasta)#"> >= b.LTdesde
				
				inner join RHLineaTiempoPlaza c
					on b.RHPid = c.RHPid
					and c.RHMPnegociado = 'T'
		where a.Ecodigo in (<cfif isdefined ('Empresas') and len(trim(Empresas))>
    							#Empresas#
                        	<cfelse>
                        		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                        	</cfif>)
			and a.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.DEidentificacion#">
		order by a.DEidentificacion, a.DEapellido1, a.DEapellido2, a.DEnombre
	</cfquery>
	<cfif rsEmpleado.RecordCount NEQ 0>
		<script type="text/javascript" language="javascript1.2">
			<cfoutput>
				parent.document.#url.po_form#.DEid.value = '#rsEmpleado.DEid#';
				parent.document.#url.po_form#.DEidentificacion.value = '#rsEmpleado.DEidentificacion#';
				parent.document.#url.po_form#.Nombre.value = '#rsEmpleado.NombreCompleto#';
			</cfoutput>
		</script>		
	<cfelse>		
		<script type="text/javascript" language="javascript1.2">
			<cfoutput>
				parent.document.#url.po_form#.DEid.value = '';
				parent.document.#url.po_form#.DEidentificacion.value = '';
				parent.document.#url.po_form#.Nombre.value = '';
			</cfoutput>
		</script>		
	</cfif>
</cfif>