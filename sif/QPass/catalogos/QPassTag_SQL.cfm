<cfif form.TagVendidos>
	<cfset LvarUrl = "QPassTagVendidos.cfm">
<cfelse>
	<cfset LvarUrl = "QPassTag.cfm">
</cfif>

	<cfif isdefined('form.QPTlista')>
        <cfset LvarLista = form.QPTlista>
	<cfelse>
        <cfset LvarLista = 'N'>
	</cfif>					

<cfif isdefined("form.Alta")>

    <cfquery name="rsOficinaUsuario" datasource="#session.dsn#">
        select min(Ocodigo) as Oficina
        from QPassUsuarioOficina
        where Ecodigo = #session.Ecodigo#
          and Usucodigo = #Session.Usucodigo#
    </cfquery>
    
    <cfif rsOficinaUsuario.recordcount GT 0 and len(trim(rsOficinaUsuario.Oficina)) GT 0>
        <cfset LvarUsuarioOficina = rsOficinaUsuario.Oficina>
    <cfelse>
        <cfset LvarUsuarioOficina = -1>
    </cfif>
	
	<cfinvoke component="sif.QPass.Componentes.QPassTag" method="InsertaTag" returnvariable="LvarResultado">
		<cfinvokeargument name="Conexion"			 value="#session.DSN#">
		<cfinvokeargument name="QPTNumParte" 		 value="#form.QPTNumParte#">
		<cfinvokeargument name="QPTFechaProduccion"  value="#form.QPTFechaProduccion#">
		<cfinvokeargument name="QPTNumSerie"  		 value="#form.QPTNumSerie#">
		<cfinvokeargument name="QPTPAN"  			 value="#form.QPTPAN#">
		<cfinvokeargument name="QPTNumLote"  		 value="#form.QPLcodigo#">
		<cfinvokeargument name="QPTNumPall" 		 value="#form.QPTNumPall#">
		<cfinvokeargument name="QPidEstado"  		 value="#form.QPidEstado#">
		<cfinvokeargument name="Ocodigo"  			 value="#LvarUsuarioOficina#">
		<cfinvokeargument name="QPidLote"  			 value="#form.QPidLote#">
		<cfinvokeargument name="QPTEstadoActivacion" value="#form.QPTEstadoActivacion#">
		<cfinvokeargument name="Ecodigo" 			 value="#session.Ecodigo#">
		<cfinvokeargument name="QPTlista"  		 	 value="#LvarLista#">
		<cfinvokeargument name="BMUsucodigo"  		 value="#session.Usucodigo#">
	</cfinvoke>
    <cflocation url="#LvarUrl#?QPTidTag=#LvarResultado#" addtoken="no">
	
<cfelseif isdefined("form.Cambio") or isdefined("form.Baja")>
	<cfif isdefined("form.Baja")>
    	<cfset form.QPTEstadoActivacion = 90>
    </cfif>
	<cfinvoke component="sif.QPass.Componentes.QPassTag" method="ActualizaTag" returnvariable="LvarResultado">
		<cfinvokeargument name="Conexion"			 value="#session.DSN#">
		<cfinvokeargument name="QPTidTag"			value = "#form.QPTidTag#">
		<cfinvokeargument name="QPTNumParte" 		 value="#form.QPTNumParte#">
		<cfinvokeargument name="QPTFechaProduccion"  value="#LsDateFormat(form.QPTFechaProduccion)#">
		<cfinvokeargument name="QPTNumSerie"  		 value="#form.QPTNumSerie#">
		<cfinvokeargument name="QPTPAN"  			 value="#form.QPTPAN#">
		<cfinvokeargument name="QPTNumLote"  		 value="#form.QPLcodigo#">
		<cfinvokeargument name="QPTNumPall" 		 value="#form.QPTNumPall#">
		<cfinvokeargument name="QPidEstado"  		 value="#form.QPidEstado#">
		<cfinvokeargument name="QPidLote"  			 value="#form.QPidLote#">
		<cfinvokeargument name="QPTEstadoActivacion" value="#form.QPTEstadoActivacion#">
		<cfinvokeargument name="Ecodigo" 			 value="#session.Ecodigo#">
		<cfinvokeargument name="QPTlista"  		 	 value="#LvarLista#">
		<cfinvokeargument name="BMUsucodigo"  		 value="#session.Usucodigo#">
	</cfinvoke>
	
    <cfif isdefined("form.Baja")>
    	<cflocation url="QPassTag.cfm" addtoken="no">
    </cfif>
    <cflocation url="#LvarUrl#?QPTidTag=#form.QPTidTag#" addtoken="no">
<cfelse>
    <cflocation url="#LvarUrl#" addtoken="no">
</cfif>
