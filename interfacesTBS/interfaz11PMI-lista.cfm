<cfif isdefined("url.CodICTS") and not isdefined("form.CodICTS")>
	<cfset form.CodICTS = url.CodICTS>
	<cfset varCodICTS = form.CodICTS>
<cfelseif isdefined("form.CodICTS")>
	<cfset varCodICTS = form.CodICTS>
</cfif>	

<cfquery name="rsNombre" datasource="preicts">
	select min(acct_full_name) as acct_full_name
	from account
	<!--- where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#"> --->
	where acct_num = 	<cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
</cfquery>

<cfquery name="rsMostrar" datasource="sifinterfaces">
	select distinct a1.NumeroDocumento, a2.MontoPago, a2.CodigoTransaccion, a2.Documento, a2.MontoPagoDocumento, a2.CodigoMonedaDoc,
		   a1.EcodigoSDC from PMIINT_IE11 a1, PMIINT_ID11 a2
	where a1.ID = a2.ID
	  and a1.sessionid = #session.monitoreo.sessionid#
	  and a2.sessionid = #session.monitoreo.sessionid#
	  and a1.EcodigoSDC= #session.Eempresa#
	order by a1.ID
</cfquery>

<cfinvoke 
 component="sif.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsMostrar#"/>
	<cfinvokeargument name="cortes" value=""/>
	<cfinvokeargument name="desplegar" value="Numerodocumento, MontoPago, CodigoTransaccion, Documento, MontoPagoDocumento, CodigoMonedaDoc, EcodigoSDC"/>
	<cfinvokeargument name="etiquetas" value="NumeroDocumento, MontoPago, Cod.Transacción, Documento, Monto Doc., Moneda, Empresa"/>
	<cfinvokeargument name="formatos" value="S,M,S,S,M,S,S"/>
	<cfinvokeargument name="ajustar" value="N,N,N,N,N,N,N"/>
	<cfinvokeargument name="align" value="right,right,left,left,right,left,left"/>
	<cfinvokeargument name="lineaRoja" value=""/>
	<cfinvokeargument name="checkboxes" value="N"/>
	<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="formName" value=""/>
	<cfinvokeargument name="PageIndex" value="1"/>
	<cfinvokeargument name="botones" value="Aplicar,Imprimir,Regresar">
	<cfinvokeargument name="showLink" value="true"/>
	<cfinvokeargument name="showEmptyListMsg" value="True"/>
	<cfinvokeargument name="EmptyListMsg" value="No existen registros a procesar"/>
	<cfinvokeargument name="Keys" value=""/>
</cfinvoke>
