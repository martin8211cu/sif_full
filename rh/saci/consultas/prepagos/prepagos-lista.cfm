<cfset filtro= "">
<cfset navegacion = "">
<cfif isdefined('form.pagina') and form.pagina NEQ ''>
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "pagina=" & form.pagina>	
</cfif>
<cfif isdefined('form.Pquien_F') and len(trim(form.Pquien_F)) GT 0>
	<cfset filtro = filtro & " and per.Pquien = " & form.Pquien_F>
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "Pquien_F=" & form.Pquien_F>
</cfif>
<cfif isdefined('form.TJid_F') and len(trim(form.TJid_F)) GT 0>
	<cfset filtro = filtro & " and TJid = " & form.TJid_F>
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "TJid_F=" & form.TJid_F>	
</cfif>
<cfif isdefined('form.TJestado_F') and  len(trim(form.TJestado_F)) GT 0 and form.TJestado_F NEQ 'NI'>
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

<cfset campos_extra = '' >
<cfif isdefined("form.Pquien_F")>
	<cfset campos_extra = campos_extra & ",'#form.Pquien_F#' as Pquien_F" >
</cfif>	
<cfif isdefined("form.TJestado_F")>
	<cfset campos_extra =  campos_extra & ",'#form.TJestado_F#' as TJestado_F" >
</cfif>	
<cfif isdefined("form.TJid_F")>
	<cfset campos_extra =  campos_extra & ",'#form.TJid_F#' as TJid_F" >
</cfif>	

<cfquery name="rsCuentaRegs" datasource="#Session.DSN#">
	select count(1) as cont
	from ISBprepago pp
		inner join ISBpaquete paq
			on paq.PQcodigo=pp.PQcodigo
				and paq.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		left outer join ISBpersona per
			on per.Pquien = pp.AGid
	where 1=1
		#preservesinglequotes(filtro)#
</cfquery>
<style type="text/css">
<!--
.style2 {
	font-size: 18px;
	color: #0000FF;
	font-weight: bold;
}
-->
</style>

<cfif isdefined('rsCuentaRegs') and rsCuentaRegs.cont LT 10000>
	<cfinvoke 
		component="sif.Componentes.pListas"
		method="pLista"
		returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="ISBprepago pp
											inner join ISBpaquete paq
												on paq.PQcodigo=pp.PQcodigo
													and paq.Ecodigo=#session.Ecodigo#
											left outer join ISBagente per
												on per.AGid = pp.AGid
												"/>
		<cfinvokeargument name="columnas" value="TJid
												, paq.PQnombre
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
												end TJestado
												#preservesinglequotes(campos_extra)#"/> 
		<cfinvokeargument name="desplegar" value="PQnombre, TJlogin, TJestado, TJuso, TJvigencia"/> 
		<cfinvokeargument name="etiquetas" value="Paquete, Log&iacute;n, Estado, Primer Uso, Vigencia"/>
		<cfinvokeargument name="formatos" value="V,V,V,D,I"/> 									
		<cfinvokeargument name="filtro" value="1=1 #filtro# order by paq.PQnombre"/> 
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
<cfelse>
		<table width="100%"  border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td align="center"><span class="style2">
			  Resultado con demasiados registros. Favor de utilizar mas filtros para la consulta.
			</span></td>
		  </tr>
		</table>
</cfif>