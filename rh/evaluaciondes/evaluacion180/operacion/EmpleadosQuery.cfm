<cfif isdefined("url.DEidentificacion") and len(trim(url.DEidentificacion)) and isdefined('url.REid')>
	<cfquery name="rsEmpleado" datasource="#session.DSN#">
		select de.NTIcodigo,de.DEid as DEid, 
			de.DEidentificacion as DEidentificacion, 
			{fn concat({fn concat({fn concat({fn concat( de.DEnombre, ' ' )}, de.DEapellido1 )},  ' ' )}, de.DEapellido2)} as Nombre
		from RHGruposRegistroE gr
		inner join RHCFGruposRegistroE gcf
			on gcf.Ecodigo = gr.Ecodigo
			and gcf.GREid = gr.GREid
			
		inner join RHRegistroEvaluacion rel
			on rel.REid = gr.REid
			
		inner join RHPlazas rhp
			on rhp.Ecodigo = gcf.Ecodigo
			and rhp.CFid = gcf.CFid	
	
		inner join CFuncional cf
			on cf.Ecodigo = rhp.Ecodigo
			and cf.CFid = rhp.CFid
	
		inner join LineaTiempo lt
			on lt.Ecodigo = rhp.Ecodigo
			and lt.RHPid = rhp.RHPid
			and getDate() between lt.LTdesde and lt.LThasta
	
		inner join RHPuestos rhpu
			on rhpu.Ecodigo = lt.Ecodigo
			and rhpu.RHPcodigo = lt.RHPcodigo
	
		inner join DatosEmpleado de
			on de.Ecodigo = rhpu.Ecodigo
			and de.DEid = lt.DEid
			and de.DEidentificacion= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.DEidentificacion#">
	
		where gr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		   and rel.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.REid#">
	
	union
		select de2.NTIcodigo,de2.DEid as DEid, de2.DEidentificacion as DEidentificacion, 
			{fn concat({fn concat({fn concat({fn concat( de2.DEnombre, ' ' )}, de2.DEapellido1 )},  ' ' )}, de2.DEapellido2)} as Nombre								
			from RHRegistroEvaluacion rel2
				inner join RHEmpleadoRegistroE ere2
					on ere2.REid = rel2.REid
				inner join DatosEmpleado de2
					on de2.DEid = ere2.DEid
					and de2.DEidentificacion= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.DEidentificacion#">					
				inner join LineaTiempo lt2
					on lt2.Ecodigo=de2.Ecodigo
					and lt2.DEid=de2.DEid
					and lt2.LTid = (select max(lt3.LTid) from LineaTiempo lt3 where lt3.DEid = lt2.DEid and lt3.LTdesde = (select max(lt4.LTdesde) from LineaTiempo lt4 where lt4.DEid = lt3.DEid))
			where rel2.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.REid#">
	</cfquery>
	<cfif rsEmpleado.RecordCount NEQ 0>
		<script type="text/javascript" language="javascript1.2">
			<cfoutput>
				parent.document.#url.po_form#.#prefijo#DEid.value = '#rsEmpleado.DEid#';
				parent.document.#url.po_form#.#prefijo#DEidentificacion.value = '#rsEmpleado.DEidentificacion#';
				parent.document.#url.po_form#.#prefijo#Nombre.value = '#rsEmpleado.Nombre#';
			</cfoutput>
		</script>		
	<cfelse>		
		<script type="text/javascript" language="javascript1.2">
			<cfoutput>
				parent.document.#url.po_form#.#prefijo#DEid.value = '';
				parent.document.#url.po_form#.#prefijo#DEidentificacion.value = '';
				parent.document.#url.po_form#.#prefijo#Nombre.value = '';
			</cfoutput>
		</script>		
	</cfif>
</cfif>