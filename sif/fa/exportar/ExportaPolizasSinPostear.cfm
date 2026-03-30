<cfif not isdefined('URL.IDcontable') and isdefined('form.IDcontable')>
	<cfset URL.IDcontable = Form.IDcontable>
</cfif>
<cfquery name="ERR" datasource="#session.DSN#">
	select 
     a.Ecodigo, a.Cconcepto, a.Eperiodo, a.Emes, 
     a.Edocumento, <cf_dbfunction name="to_sdateDMY" args="a.Efecha"> as Efecha, 
     a.Edescripcion, a.Edocbase, a.Ereferencia, 
     a.ECauxiliar, a.ECusuario, a.ECselect,
     b.Dlinea, b.Ocodigo, b.Ddescripcion, 
     b.Ddocumento, b.Dreferencia, b.Dmovimiento, 
     b.Ccuenta, b.Doriginal, b.Dlocal, b.Mcodigo, 
     b.Dtipocambio
 from EContables a
	inner join DContables b
		on a.IDcontable=b.IDcontable
where a.Ecodigo = #session.Ecodigo#
  and a.IDcontable = #URL.IDcontable#
  and b.IDcontable =#URL.IDcontable#
</cfquery>