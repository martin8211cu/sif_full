<cfset minisifdb = Application.dsinfo[session.dsn].schema>
<cfquery name="rsReversa" datasource="sifinterfaces">
	select distinct a.Modulo, a.Documento, a.CodigoTransaccion, a.SNcodigo,a.TipoReversa, a.IDdocumento
	from DocumentoReversion a
	where a.Ecodigo = #session.Ecodigo#
	and a.Procesado = 'N'
</cfquery>

<cfloop query="rsReversa">
	<cfif rsReversa.TipoReversa EQ "B">
		<cfset varTipoReversa = false>
	<cfelse>
		<cfset varTipoReversa = true>
	</cfif>
	<cfif rsReversa.Modulo EQ "CC">
		<cfset varModulo = "CxC">
		<cfquery name="rsCodigoRef" datasource="sifinterfaces">
			select CCTCodigoRef 
			from #minisifdb#..CCTransacciones 
			where Ecodigo = #session.Ecodigo#
			and CCTcodigo = '#rsReversa.CodigoTransaccion#'
		</cfquery>
		<cfif rsCodigoRef.recordcount EQ 1>
			<cfset varCodigoRef = rsCodigoRef.CCTCodigoRef>
		<cfelse>
			<cfabort showerror="Codigo de Transaccion Invalido">
		</cfif>
	<cfelse>
		<cfset varModulo = "CxP">
	</cfif>

	<cfif varModulo EQ "CxC">
		<cfinvoke 
			component="sif.Componentes.ReversionDocNoFact" 
			method="Reversion" 
				Modulo="#varModulo#"
				debug="false"
				ReversarTotal="#varTipoReversa#"
				CCTcodigo="#rsReversa.CodigoTransaccion#"
				CCTCodigoRef="#varCodigoRef#"
				Ddocumento="#rsReversa.Documento#"
		/> 
	<cfelse>
		<cfinvoke 
			component="sif.Componentes.ReversionDocNoFact" 
			method="Reversion" 
				Modulo="#varModulo#"
				debug="false"
				ReversarTotal="#varTipoReversa#"
				CPTcodigo="#rsReversa.CodigoTransaccion#"
				IDdocumento="#rsReversa.IDdocumento#"
		/>
	</cfif>
	<cfquery datasource="sifinterfaces">
		update DocumentoReversion
		set Procesado ='S'
		where Ecodigo = #session.Ecodigo#
		and Documento = '#rsReversa.Documento#'
		and CodigoTransaccion = '#rsReversa.CodigoTransaccion#'
		and SNcodigo = #rsReversa.SNcodigo#
		and Modulo = '#rsReversa.Modulo#'
	</cfquery> 
</cfloop>

<cflocation url="Reversion.cfm?botonsel=btnTerminado">