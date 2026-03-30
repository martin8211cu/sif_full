<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
	<cfset form.Pagina = url.PageNum_Lista>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
	<cfset form.Pagina = form.PageNum>
</cfif>		

<cfif isdefined('url.Pquien_F') and not isdefined('form.Pquien_F')>
	<cfset form.Pquien_F = url.Pquien_F>
</cfif>
<cfif isdefined('url.TJestado_F') and not isdefined('form.TJestado_F')>
	<cfset form.TJestado_F = url.TJestado_F>
</cfif>
<cfif isdefined("url.AGid") and Len(Trim(url.AGid))>
	<cfset Form.AGid = url.AGid>
</cfif>

<cfset filtro= "and AGid =" & Form.AGid>
<cfset navegacion = "btnFiltrar=1&AGid=#Form.AGid#">
<cfif isdefined('form.Pquien_F') and form.Pquien_F NEQ ''>
	<!---
	<cfset filtro = filtro & " and AGid = " & form.Pquien_F>
	--->
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "Pquien_F=" & form.Pquien_F>
</cfif>
<cfif isdefined('form.TJid_F') and form.TJid_F NEQ ''>
	<cfset filtro = filtro & " and TJid = " & form.TJid_F>
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "TJid_F=" & form.TJid_F>	
</cfif>
<cfif isdefined('form.TJestado_F') and form.TJestado_F NEQ 'NI'>
	<cfif form.TJestado_F EQ 'SL'>		<!--- Sin Liquidar --->
		<cfset filtro = filtro & " and TJuso is not null and TJliquidada = 0">	
	<cfelseif form.TJestado_F EQ 'CE'>		<!--- Cerrada --->
		<cfset filtro = filtro & " and TJestado = '0'">
	<cfelseif form.TJestado_F EQ 'AC'>		<!--- Activa --->
		<cfset filtro = filtro & " and TJestado = '1'">		
	<cfelseif form.TJestado_F EQ 'L'>		<!--- Liquidada --->
		<cfset filtro = filtro & " and TJliquidada = 1">
	<cfelseif form.TJestado_F EQ 'U'>		<!--- En Uso --->	
		<cfset filtro = filtro & " and TJestado = '2'">	
	<cfelseif form.TJestado_F EQ 'V'>		<!--- Vencida --->	
		<cfset filtro = filtro & " and TJestado = '4'">	
	<cfelseif form.TJestado_F EQ 'A'>		<!--- Anulada --->	
		<cfset filtro = filtro & " and TJestado = '6'">	
	<cfelseif form.TJestado_F EQ 'B'>		<!--- Bloqueada --->	
		<cfset filtro = filtro & " and TJestado = '5'">	
	<cfelseif form.TJestado_F EQ 'C'>		<!--- Consumida --->	
		<cfset filtro = filtro & " and TJestado = '3'">	
	</cfif>
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "TJestado_F=" & form.TJestado_F>	
</cfif>

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.MaxRows" default="20">					

<cfinvoke 
	component="sif.Componentes.pListas"
	method="pLista"
	returnvariable="pListaRet">
	<cfinvokeargument name="tabla" value="ISBprepago"/>
	<cfinvokeargument name="columnas" value="TJid
											, PQcodigo
											, TJlogin 
											, TJuso
											, TJvigencia
											, case TJestado
												when '0' then 'Cerrada'
												when '1' then 'Activa'
												when '2' then 'En Uso'
												when '3' then 'Consumida'
												when '4' then 'Vencida'
												when '5' then 'Bloqueada'
												when '6' then 'Anulada'
											end TJestado"/> 
	<cfinvokeargument name="desplegar" value="PQcodigo, TJlogin, TJestado, TJuso, TJvigencia"/> 
	<cfinvokeargument name="etiquetas" value="Paquete, Log&iacute;n, Estado, Primer Uso, Vigencia"/>
	<cfinvokeargument name="formatos" value="V,V,V,D,I"/> 									
	<cfinvokeargument name="filtro" value="1=1 #filtro# order by TJlogin"/> 
	<cfinvokeargument name="align" value="left,left,center,center,Right"/>
	<cfinvokeargument name="ajustar" value="N"/> 
	<cfinvokeargument name="checkboxes" value="N"/> 
	<cfinvokeargument name="irA" value="prepagos.cfm"/> 									
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="keys" value="TJid"/> 
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="maxRows" value="#form.MaxRows#"/>	
</cfinvoke>