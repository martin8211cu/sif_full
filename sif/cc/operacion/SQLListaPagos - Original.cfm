<!--- 
	Modificado por: Gustavo Fonseca Hernández.
		Fecha: 24-10-2005
		Motivo: Se modifica para eliminar la creación de las tablas temporales #INTARC y #asiento de este cfm, 
		ya que estas tablas son incluidas en el sp: CC_PosteoPagosCxC.
 --->
<cfif isdefined("Form.Aplicar")>
	<cfset pagos = #ListToArray(Form.IDpago, ',')#>
	<cfloop index="i" from="1" to="#ArrayLen(pagos)#">
		<cfset codigo = #ListToArray(pagos[i], '|')#>
		
		<cfquery name="rsValida" datasource="#session.DSN#" maxrows="1">
			select 
				(case when 
				(p.Pfecha) < (select d.Dfecha 
								from Documentos d 
								where d.Ecodigo = dp.Ecodigo 
									and d.CCTcodigo = dp.Doc_CCTcodigo
									and d.Ddocumento = dp.Ddocumento)
				then 1 else 2 end) as diferencia
			from Pagos p
				inner join DPagos dp
					on dp.Ecodigo = p.Ecodigo
						and dp.CCTcodigo = p.CCTcodigo
						and dp.Pcodigo  = p.Pcodigo  
			where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and p.CCTcodigo =  <cfqueryparam cfsqltype="cf_sql_char"  value="#codigo[1]#" >
				and p.Pcodigo = <cfqueryparam cfsqltype="cf_sql_char"  value="#codigo[2]#" >
			order by 1
		</cfquery>
		<cfquery name="rsSNid" datasource="#session.dsn#">
			select b.SNid 
			from Pagos p 
				inner join SNegocios  b
				on p.Sncodigo = b.SNcodigo
			where p.Ecodigo = #Session.Ecodigo#
			and p.CCTcodigo =  <cfqueryparam cfsqltype="cf_sql_char"  value="#codigo[1]#" >
			and p.Pcodigo = <cfqueryparam cfsqltype="cf_sql_char"  value="#codigo[2]#" >
		</cfquery> 
		<cfif isdefined("rsValida") and rsValida.diferencia eq 1>
			<cf_errorCode	code = "50187" msg = "No se puede aplicar un recibo con fecha menor a la del documento.">
			<cfabort>
		</cfif>
		<!--- ejecuta el proc.--->
		<cfinvoke component="sif.Componentes.CC_PosteoPagosCxC" method="PosteoPagosCxC" returnvariable="status"
			Ecodigo 	= "#session.Ecodigo#"
			CCTcodigo	= "#codigo[1]#"
			Pcodigo		= "#codigo[2]#"
			usuario  	= "#Session.Usuario#"
			SNid		= "#rsSNid.SNid#"
			debug		= "N"				
		/>
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

