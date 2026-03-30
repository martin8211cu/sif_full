<cfif isdefined("url.NTIcodigo") and Len(Trim(url.NTIcodigo)) NEQ 0 and url.NTIcodigo NEQ "-1" and isdefined("url.DEidentificacion") and Len(Trim(url.DEidentificacion)) NEQ 0>
	<cfquery name="rsEmpleado" datasource="#Session.DSN#">
		select a.DEid, b.ACAid, a.DEidentificacion, 
			{fn concat(		{fn concat(		
			{fn concat(		{fn concat(
				a.DEapellido1 , ' ')} , a.DEapellido2 )} ,  ', ' )} ,  a.DEnombre )} as NombreCompleto,
		   coalesce(( select Tcodigo from LineaTiempo lt where lt.Ecodigo=a.Ecodigo and lt.DEid=a.DEid and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between lt.LTdesde and lt.LThasta), '') as Tcodigo,
		   coalesce(( select tn.Ttipopago from LineaTiempo lt, TiposNomina tn where lt.Ecodigo=a.Ecodigo and lt.DEid=a.DEid and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between lt.LTdesde and lt.LThasta and tn.Ecodigo=lt.Ecodigo and tn.Tcodigo=lt.Tcodigo), 0) as Ttipopago		   

		from DatosEmpleado a, ACAsociados b

		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and a.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(url.DEidentificacion)#">
		and a.NTIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(url.NTIcodigo)#">
		  and b.DEid=a.DEid
		  and b.ACAestado=1
		
	</cfquery>
	<script language="JavaScript" type="text/javascript">
		<cfoutput>
		window.parent.document.#url.f#.#url.p1#.value = '#rsEmpleado.DEid#';
		window.parent.document.#url.f#.#url.p3#.value = '#trim(rsEmpleado.DEidentificacion)#';
		window.parent.document.#url.f#.#url.p4#.value = '#trim(rsEmpleado.NombreCompleto)#';
		window.parent.document.#url.f#.#url.p6#.value = '#rsEmpleado.ACAid#';		
		window.parent.document.#url.f#.#url.p7#.value = '#rsEmpleado.Tcodigo#';
		window.parent.document.#url.f#.#url.p8#.value = '#rsEmpleado.Ttipopago#';
		
		if (window.parent.funcACAid){ window.parent.funcACAid(); }
		var funcName = 'window.parent.func#rsEmpleado.ACAid#';
		if (eval(funcName)){ eval(funcName)(); }
		</cfoutput>
	</script>
</cfif>
