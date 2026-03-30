<!---<cfset filtro = " mc.MSrevAgente <> 'L' ">--->
<cfset filtro = "1=1">


<cfset camposExtra = "">
<cfoutput>
	<cfif isdefined('url.fechaIni') and url.fechaIni NEQ ''>
		<cfset filtro = filtro & " and mc.BACFEC >= '" & LSDateFormat(url.fechaIni, "yyyymmdd") & "'">
		<cfset camposExtra = camposExtra & ",'#url.fechaIni#' as fechaIni_f">
	</cfif>		
	<cfif isdefined('url.fechaFin') and url.fechaFin NEQ ''>
		<cfset filtro = filtro & " and mc.BACFEC <= '" & LSDateFormat(url.fechaFin, "yyyymmdd") & " 23:59:59" & "'">
		<cfset camposExtra = camposExtra & ",'#url.fechaFin#' as fechaFin_f">
	</cfif>	
	<cfif isdefined('url.TipActividad') and url.TipActividad NEQ 'T'>
		<cfset filtro = filtro & " and mc.BACDAM = '#url.TipActividad#'">
		<cfset camposExtra = camposExtra & ",'#url.TipActividad#' as BACDAM_f">
	</cfif>	
	<cfif isdefined('url.opt_mayorista') and url.opt_mayorista NEQ 'T'>
		<cfset filtro = filtro & " and mc.BACCAB = '#url.opt_mayorista#'">
		<cfset camposExtra = camposExtra & ",'#url.opt_mayorista#' as BACCAB_f">
	</cfif>

</cfoutput>

<cfinvoke 
	component="sif.Componentes.pListas"
	method="pListaRH"
	returnvariable="pListaRet"
		columnas="
				BACCON
				,case mc.BACDAM
					when 'C' then 'C - Cambio Cuenta'
					when 'L' then 'L - Cambio Login'
					when 'I' then 'I - Cambio Inte'
					when 'Q' then 'Q - Cambio Paquete'
					when 'N' then 'N - Nuevo Inte'
				  end BACDAM
				, mc.CUECUE
				, coalesce (mc.SERIDS, '-') as SERIDS
				, SERCLA
				, mc.CINCAT
				, coalesce (INTPAD, '-') as INTPAD
				, CONVERT(CHAR(8),BACFEC,112) FECHA
				, CONVERT(CHAR(8),BACFEC,108) HORA
				, coalesce(CONVERT(varchar,BACCSV), '-') as BACCSV
				, BACFEC"
		tabla="
				SACISIIC..SSXBAC mc"
		filtro="#filtro# order by BACFEC"
		desplegar="BACDAM,CUECUE,SERIDS,SERCLA,CINCAT,INTPAD,FECHA,HORA,BACCSV"
		etiquetas="Tipo,Cuenta,Inte,Login,Paquete,Suscriptor,Fecha,Hora,Cod.Servicio"
		formatos="S,I,S,S,I,S,S,S,S"
		align="left,left,left,left,left,left,left,left,left"
		showlink="false"
		formName="form2"
		ajustar="N,N,N,N,N,N,N,N"
		keys="BACCON"
		cortes="SERCLA"
		MaxRows="15"
		filtrar_automatico="false"
		mostrar_filtro="false"/>
		
		
		
		