	<cfif isdefined("Form.Aplicar")>
		<cfset pagos = #ListToArray(Form.IDpago, ',')#>
		<cfloop index="i" from="1" to="#ArrayLen(pagos)#">

		<!---  Se va a aplicar un documento? --->
		<cfinvoke component="sif.Componentes.CP_PosteoPagosCxP" method="PosteoPagos">
			<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
			<cfinvokeargument name="IDpago" value="#pagos[i]#"/>				
			<cfinvokeargument name="usuario" value="#session.usuario#"/>			
			<cfinvokeargument name="debug" value="Y"/>							
		</cfinvoke>
	
		</cfloop>
	</cfif>

<cfset params = '?pageNum_rsLista=1' >
<cfif isdefined('form.PageNum_rsLista') and len(trim(form.PageNum_rsLista))>
	<cfset params = '?pageNum_rsLista=#form.PageNum_rsLista#' >
</cfif>

<cfif isdefined('form.fecha') and len(trim(form.fecha)) and form.fecha neq -1 >
	<cfset params = params & '&fecha=#form.fecha#' >
</cfif>
<cfif isdefined('form.transaccion') and len(trim(form.transaccion)) and form.transaccion neq -1 >
	<cfset params =  params & '&transaccion=#form.transaccion#' >
</cfif>
<cfif isdefined('form.usuario') and len(trim(form.usuario)) and form.usuario neq -1 >
	<cfset params =  params & '&usuario=#form.usuario#' >
</cfif>
<cfif isdefined('form.moneda') and len(trim(form.moneda)) and form.moneda neq -1 >
	<cfset params =  params & '&moneda=#form.moneda#' >
</cfif>

<cflocation url="ListaPagos.cfm#params#" addtoken="no"> 	