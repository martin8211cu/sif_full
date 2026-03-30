<cfif isdefined("url.EOnumero") and len(trim(url.EOnumero))>
	<cfset LvarListaEmpresas = session.Ecodigo>
    <cfquery name="rsProvCorp" datasource="#session.DSN#">
        select Pvalor 
         from Parametros 
        where Ecodigo = #session.Ecodigo#
          and Pcodigo = 5100
	</cfquery>
	<cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
        <cfset lvarProvCorp = true>
        <cfquery name="rsEProvCorp" datasource="#session.DSN#">
            select EPCid
            from EProveduriaCorporativa
            where Ecodigo = #session.Ecodigo#
             and EPCempresaAdmin = #session.Ecodigo#
        </cfquery>
        <cfif rsEProvCorp.recordcount eq 0>
            <cfthrow message="El Catálogo de Proveduría Corporativa no se ha configurado">
        </cfif>
        <cfquery name="rsDProvCorp" datasource="#session.DSN#">
            select DPCecodigo as Ecodigo, Edescripcion
            from DProveduriaCorporativa dpc
                inner join Empresas e
                    on e.Ecodigo = dpc.DPCecodigo
            where dpc.Ecodigo = #session.Ecodigo#
             and dpc.EPCid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsEProvCorp.EPCid)#" list="yes">)
            union
            select e.Ecodigo, e.Edescripcion
            from Empresas e
            where e.Ecodigo = #session.Ecodigo#
            order by 2
        </cfquery>
        <cfset LvarListaEmpresas = ValueList(rsDProvCorp.Ecodigo)>
    </cfif>
    
    <cfquery name="rs" datasource="#session.DSN#">
		select eo.EOidorden, eo.EOnumero, eo.Observaciones
		 from EOrdenCM eo
			inner join CMTipoOrden cmto
				on cmto.Ecodigo           = eo.Ecodigo
			   and cmto.CMTOcodigo        = eo.CMTOcodigo
			   and cmto.CMTgeneratracking = 1
			   and cmto.CMTOimportacion   = 1
		 where eo.EOestado = 10
		   and eo.Ecodigo IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarListaEmpresas#" list="yes">)
		   and eo.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#TRIM(url.EOnumero)#">
	</cfquery>

	<script language="javascript1.2" type="text/javascript">
		<cfoutput>
			<cfif rs.recordCount gt 0>
				window.parent.document.form1.EOidorden#url.index#.value     = '#rs.EOidorden#';
				window.parent.document.form1.EOnumero#url.index#.value      = '#rs.EOnumero#';
				window.parent.document.form1.Observaciones#url.index#.value = '#rs.Observaciones#';
			<cfelse>			
				window.parent.document.form1.EOidorden#url.index#.value     = '';
				window.parent.document.form1.EOnumero#url.index#.value      = '';
				window.parent.document.form1.Observaciones#url.index#.value = '';
			</cfif>
		</cfoutput>
	</script>
</cfif>