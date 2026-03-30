<cfif isdefined("Url.SNcodigo") and not isdefined("Form.SNcodigo")>
	<cfparam name="Form.SNcodigo" default="#Url.SNcodigo#">
</cfif>

<cfif isdefined("Url.DocumentoC") and not isdefined("Form.DocumentoC")>
	<cfparam name="Form.DocumentoC" default="#Url.DocumentoC#">
</cfif>

<cfquery name="rsParametroCcuentaTransitoQuery" datasource="#session.DSN#">
	select Pvalor, Pdescripcion
	from Parametros 
	where Pcodigo = 650
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfif rsParametroCcuentaTransitoQuery.Pvalor eq ''>
	<cfthrow message="La&nbsp;Cuenta&nbsp;Dep&oacute;sitos&nbsp;en&nbsp;Tr&aacute;nsito&nbsp;no&nbsp;est&aacute;&nbsp;defnida."
			detail="Debe&nbsp;digitar&nbsp;la&nbsp;cuenta:&nbsp;Dep&oacute;sitos&nbsp;en&nbsp;Tr&aacute;nsito:&nbsp;Admnistraci&oacute;n&nbsp;del&nbsp;Sistema,&nbsp;Cuentas&nbsp;Contables&nbsp;de&nbsp;Operaci&oacute;n." >
</cfif>

<cfquery name="rsCuentaQuery" datasource="#Session.DSN#">
	select Ccuenta, convert(varchar(40),Cdescripcion) as Cdescripcion 
	from CContables 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParametroCcuentaTransitoQuery.Pvalor#"> 
</cfquery>
	<!--- Busca el "SNidPadre", el nombre de SN y el grupo--->
<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
	<cfquery name="rsNombreSocioQuery" datasource="#Session.DSN#">
		select SNid, SNnombre, GSNid, SNidPadre
		from SNegocios
		where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
</cfif>
<!----<cfif isdefined("url.dato") and Len(Trim(url.dato))>----->
<cfif isdefined("url.documentoc") and Len(Trim(url.documentoc))>
	<cfquery name="rs" datasource="#url.conexion#">
		select a.Mcodigo, b.Ccuenta, Dtipocambio, c.Cdescripcion, coalesce (b.Rcodigo, '%') as Rcodigo,
			   rtrim(b.CCTcodigo+'-'+rtrim(b.Ddocumento)+'-'+a.Mnombre) as Descripcion,
			   a.Mnombre, 
			   b.Dfecha, 
			   d.CCTcodigo, 
			   rtrim(b.Ddocumento) as Ddocumento,
			   b.Dsaldo,
			   (select min(pp.PPnumero)
				from PlanPagos pp
					where pp.Ecodigo = b.Ecodigo
					and pp.CCTcodigo = b.CCTcodigo
					and pp.Ddocumento = b.Ddocumento
					and pp.PPfecha_pago is null <!--- documentos sin pagar --->) as PPnumero,
				
				coalesce( (select pp.PPprincipal + pp.PPinteres
				from PlanPagos pp
					where pp.Ecodigo = b.Ecodigo
					and pp.CCTcodigo = b.CCTcodigo
					and pp.Ddocumento = b.Ddocumento
					and pp.PPfecha_pago is null <!--- documentos sin pagar --->
					group by Ecodigo,CCTcodigo,Ddocumento <!--- para que sirva / ase 12.5.1/EBF11428/WinNT --->
					having pp.PPnumero = min (pp.PPnumero)), 0) as MontoCuota,
				
				coalesce( (select pp.PPpagomora
				from PlanPagos pp
					where pp.Ecodigo = b.Ecodigo
					and pp.CCTcodigo = b.CCTcodigo
					and pp.Ddocumento = b.Ddocumento
					and pp.PPfecha_pago is null <!--- documentos sin pagar --->
					group by Ecodigo,CCTcodigo,Ddocumento <!--- para que sirva / ase 12.5.1/EBF11428/WinNT --->
					having pp.PPnumero = min (pp.PPnumero)),0) as InteresMora,
				
				(select pp.PPfecha_vence
				from PlanPagos pp
					where pp.Ecodigo = b.Ecodigo
					and pp.CCTcodigo = b.CCTcodigo
					and pp.Ddocumento = b.Ddocumento
					and pp.PPfecha_pago is null <!--- documentos sin pagar --->
					group by Ecodigo,CCTcodigo,Ddocumento <!--- para que sirva / ase 12.5.1/EBF11428/WinNT --->
					having pp.PPnumero = min (pp.PPnumero)) as PPfecha_vence
		from Documentos b
			inner join SNegocios f
				on b.Ecodigo=f.Ecodigo 
				and b.SNcodigo= f.SNcodigo
			inner join Monedas a
				on a.Mcodigo = b.Mcodigo 
			inner join CContables c
				on b.Ccuenta = c.Ccuenta 
			inner join CCTransacciones d
				on b.Ecodigo = d.Ecodigo 
				and b.CCTcodigo = d.CCTcodigo 
				and d.CCTtipo = 'D'
				and coalesce(d.CCTpago,0) != 1
				and coalesce(d.CCTvencim,0) != -1
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		<!----
		<cfif isdefined("url.dato") and (Len(Trim(url.dato)) NEQ 0) and (url.dato NEQ "-1")> 
			and rtrim(ltrim(upper (b.CCTcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
		</cfif> 	
		----->
		 <cfif isdefined("Form.DocumentoC") and (Len(Trim(Form.DocumentoC)) NEQ 0)> 
		  	and upper(b.Ddocumento) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(form.DocumentoC)#"><!----'#Ucase(Form.DocumentoC)#'----->
		 </cfif>
		 <cfif isdefined("url.GSNid") and len(trim(url.GSNid))>
			and f.GSNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.GSNid#">
		</cfif>  
			and b.Dsaldo > 0 
		<cfif isdefined("rsNombreSocioQuery") and rsNombreSocioQuery.recordcount gt 0 and rsNombreSocioQuery.SNid NEQ ''>
			<!--- Para no utilizar un "Union all"  se usa el or en este caso particular --->			
			and (f.SNidPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNombreSocioQuery.SNid#"> OR  f.SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNombreSocioQuery.SNid#">)
		<cfelse>
			<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
				and b.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#"> 
			</cfif>
		</cfif>
		order by b.Dfecha, b.Mcodigo, b.Dsaldo desc, b.CCTcodigo, b.Ddocumento
	</cfquery>
	
	<cfif isdefined("rs") and rs.recordcount GT 0>
		<cfset Codigo = rs.Mcodigo & '|' & 
								rs.CCTcodigo & '|' & 
								rs.Ddocumento & '|' & 
								rs.Ccuenta & '|' & 
								rs.Dtipocambio & '|' & 
								(rs.MontoCuota + rs.InteresMora ) & '|' & 
								rs.Cdescripcion & '|' & 
								rs.Rcodigo & '|' & 
								rs.PPnumero	& '|' &
								rs.Dsaldo>
	</cfif>

	<cfoutput>
	<script language="JavaScript"> 
		var descAnt = window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value.toUpperCase();
		window.parent.document.#url.form#.#url.desc#.value="#rs.Descripcion#";
		window.parent.document.#url.form#.#url.name#.value="#rs.Ddocumento#";
		window.parent.document.#url.form#.#url.CCTcodigoConlis#.value = "#rs.CCTcodigo#";
		
		<cfif isdefined("rs") and rs.recordcount GT 0>
		window.parent.document.#url.form#.Cod#url.id#.value = "#Codigo#";
		</cfif>

		if (window.parent.func#url.name#) { window.parent.func#url.name#(); }		
		// si el valor devuelto por el "rs" es diferente al que se digitó en el conlis... entonces limpia el conlis con la funcion limpiarDocsPagoCxC
		 if (descAnt != window.parent.document.#url.form#.#url.name#.value.toUpperCase() && window.parent.limpiarDocsPagoCxC) {
			window.parent.limpiarDocsPagoCxC(); 
		} 
		
	</script>
	</cfoutput>
</cfif>



	
